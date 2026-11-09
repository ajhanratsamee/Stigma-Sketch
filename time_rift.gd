class_name TimeRift
extends Node2D
## รอยแยกมิติเวลาเล็กๆ ของสาย SYNC TIME มีได้ทีละอัน
## plain รอคำสั่งระเบิดหรือวาป  push เกิดหลังมอนที่ลอยอยู่ แล้วผลักมอนกลางอากาศมาหาตัวละคร

const U := CombatData.UNIT
const OPEN_TIME := 0.16
const LIFE := 3.0
const BLAST_R := 2.4
const HALF_W := 34.0
const HALF_H := 62.0
const STEPS := 7
const PUSH_TIME := 0.5
const PUSH_STOP := 1.3
const FOLLOW_LIFE := 4.0
const FOLLOW_EASE := 12.0
const FOLLOW_TICK := 0.2
const PURPLE := Color(0.56, 0.28, 0.86)
const LIGHT := Color(0.78, 0.6, 0.98)
const CORE := Color(0.08, 0.05, 0.16)

var pos := Vector2.ZERO
var slant := 0.0
var hero: Hero
var open_dmg := 0.0
var boom_dmg := 14.0
var open_reach := 1.6
var push_target: Node2D = null
var pushed := false
var blast_mult := 1.0
var exploded := false
var size_k := Vector2.ONE      # ขยายรอยแยก เส้นไม่หนาตาม
var follow := false            # ตามตัวละครไปตามที่เดิน ทำดาเมจต่อเนื่อง
var follow_dmg := 0.0
var follow_near := 1.7
var _tick := 0.0
var _t := 0.0
var _boom := 0.0

func _ready() -> void:
	z_index = 2
	position = Vector2(pos.x, -pos.y) * U
	rotation = slant
	if open_dmg > 0.0:
		_hit_around(open_reach, open_dmg)

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	if exploded:
		_boom += delta / 0.3
		if _boom >= 1.0:
			queue_free()
		return
	if is_instance_valid(push_target):
		_push(delta)
		return
	if pushed:
		queue_free()
		return
	if follow and is_instance_valid(hero):
		_follow(delta)
		return
	if _t >= LIFE:
		queue_free()

## รอยแยกอยู่หน้าตัวละครเสมอ เคลื่อนตามที่เดิน
func _follow(delta: float) -> void:
	var want: Vector2 = hero.pos + Vector2(hero.facing * follow_near, 1.2)
	pos = pos.lerp(want, minf(FOLLOW_EASE * delta, 1.0))
	position = Vector2(pos.x, -pos.y) * U
	_tick -= delta
	if _tick <= 0.0:
		_tick = FOLLOW_TICK
		hit_near(follow_dmg)
	if _t >= FOLLOW_LIFE:
		queue_free()

## ผลักมอนลอยกลางอากาศเข้าหาตัวละคร ระหว่างนั้นมอนค้างความสูงเดิม
func _push(_delta: float) -> void:
	pushed = true
	var e := push_target
	if _t >= PUSH_TIME or e.is_invulnerable():
		push_target = null
		return
	var side := signf(e.pos.x - hero.pos.x)
	var stop: float = hero.pos.x + side * PUSH_STOP
	var left := maxf(PUSH_TIME - _t, 0.01)
	e.pos.x = lerpf(e.pos.x, stop, minf(_delta / left, 1.0))
	e.vel = Vector2.ZERO

## สั่งระเบิด
func explode() -> void:
	if exploded:
		return
	exploded = true
	_hit_around(BLAST_R * blast_mult, boom_dmg)

## ทำดาเมจรอบรอยแยกในระยะใกล้
func hit_near(dmg: float) -> void:
	_hit_around(open_reach, dmg)

func _hit_around(reach: float, dmg: float) -> void:
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) > reach or absf(e.pos.y - pos.y) > reach + 1.5:
			continue
		var hp_before: float = e.hp
		var side := signf(e.pos.x - pos.x)
		if e.take_hit(hit, side if side != 0.0 else 1.0) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

func _outline(k: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var total := STEPS * 2
	for i in total:
		var a := TAU * i / total
		var jag := 1.0 if i % 2 == 0 else 0.72
		pts.append(Vector2(sin(a) * HALF_W * size_k.x * k * jag, -cos(a) * HALF_H * size_k.y * k * jag))
	return pts

func _draw() -> void:
	if exploded:
		var r := BLAST_R * blast_mult * U * _boom
		for n in 3:
			var ring := Sketch.oval(Vector2.ZERO, r * (1.0 - n * 0.24), r * (1.0 - n * 0.24), 40)
			ring.append(ring[0])
			Sketch.line(self, ring, 2400 + n, 3.6, 1.0, Color(PURPLE if n % 2 == 0 else LIGHT, 1.0 - _boom))
		return
	var k := minf(_t / OPEN_TIME, 1.0)
	if k <= 0.02:
		return
	Sketch.hatch(self, _outline(k), LIGHT)
	Sketch.hatch(self, _outline(k * 0.72), PURPLE)
	Sketch.hatch(self, _outline(k * 0.42), CORE)
	var edge := _outline(k)
	edge.append(edge[0])
	Sketch.line(self, edge, 2405, 2.8, 0.4)
	var hand := _t * -5.0
	draw_line(Vector2.ZERO, Vector2(cos(hand), sin(hand)) * HALF_W * 0.3 * k, Color.WHITE, 2.4, true)
