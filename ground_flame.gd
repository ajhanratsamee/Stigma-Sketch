class_name GroundFlame
extends Node2D
## เปลวไฟวิ่งไปตามพื้นด้านหน้า ไประยะหนึ่งแล้วดับ โดนมอนตัวละครั้ง

const U := CombatData.UNIT
const SPEED := 11.0
const HIT_R := 0.8
const TONGUES := 6
const GAP := 34.0
const FADE := 0.25
const BURN_GAP := 44.0
const BURN_TICK := 0.35

var x := 0.0
var dir := 1.0
var reach := 5.5
var dmg := 10.0
var hero: Hero
var hit_list: Array = []
var kind := "fire"
var is_skill := false
var linger := 0.0              # ไฟลุกค้างบนทางที่ลามผ่าน นานเท่านี้วินาที
var _went := 0.0
var _clock := 0.0
var _fade := 0.0
var _burn_wait := 0.0
var burn_ticks := 0

func _ready() -> void:
	z_index = 2
	position = Vector2(x, 0.0) * U

func _physics_process(delta: float) -> void:
	_clock += delta
	queue_redraw()
	if linger > 0.0:
		_burn_trail(delta)
	if _went >= reach:
		if linger > 0.0:
			linger -= delta
			return
		_fade += delta / FADE
		if _fade >= 1.0:
			queue_free()
		return
	var step := SPEED * delta
	x += dir * step
	_went += step
	position = Vector2(x, 0.0) * U
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0, "skill": is_skill}
	for e in get_tree().get_nodes_in_group("monsters"):
		if e in hit_list or absf(e.pos.x - x) > HIT_R or e.pos.y > 1.6:
			continue
		hit_list.append(e)
		var hp_before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

## มอนบนทางที่ไฟลามผ่าน ลุกไหม้ต่อเนื่อง
func _burn_trail(delta: float) -> void:
	_burn_wait -= delta
	if _burn_wait > 0.0:
		return
	_burn_wait = BURN_TICK
	burn_ticks += 1
	var hit := {"type": "flinch", "dmg": dmg * 0.25, "kb": 0.0, "burn": kind, "skill": is_skill}
	var low := minf(x, x - dir * _went)
	var high := maxf(x, x - dir * _went)
	for e in get_tree().get_nodes_in_group("monsters"):
		if e.pos.x < low - HIT_R or e.pos.x > high + HIT_R or e.pos.y > 1.6:
			continue
		var hp_before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

func _draw() -> void:
	var colors: Array = CombatData.FLAME[kind]
	var k := 1.0 - _fade
	if linger > 0.0 or _fade > 0.0:
		_draw_trail(colors, k)
	for i in TONGUES:
		var back := -dir * float(i) * GAP
		if absf(back) > _went * U:
			continue
		var long := (84.0 - float(i) * 9.0) * (0.8 + 0.2 * sin(_clock * 15.0 + float(i) * 1.7)) * k
		var wide := (19.0 - float(i)) * k
		if long < 2.0:
			continue
		var sway := sin(_clock * 11.0 + float(i)) * 9.0
		var pts := Sketch.flame(Vector2(back, 0.0), Vector2.UP, long, wide, sway)
		Sketch.hatch(self, pts, colors[0])
		Sketch.hatch(self, Sketch.flame(Vector2(back, 0.0), Vector2.UP, long * 0.55, wide * 0.55, sway * 0.55), colors[1])
		pts.append(pts[0])
		Sketch.line(self, pts, 2320 + i, 1.8, 0.2)

## ไฟลุกค้างตลอดทางที่ลามผ่าน
func _draw_trail(colors: Array, k: float) -> void:
	var n := int(_went * U / BURN_GAP)
	for i in n:
		var back := -dir * (float(i) + 0.5) * BURN_GAP
		var long := (60.0 + 22.0 * absf(sin(float(i) * 2.3))) * (0.8 + 0.2 * sin(_clock * 13.0 + float(i) * 1.3)) * k
		if long < 2.0:
			continue
		var pts := Sketch.flame(Vector2(back, 0.0), Vector2.UP, long, 17.0 * k, sin(_clock * 9.0 + float(i)) * 8.0)
		Sketch.hatch(self, pts, colors[0], 2330 + i % 8, 7.0)
		pts.append(pts[0])
		Sketch.line(self, pts, 2340 + i % 8, 1.8, 0.2)
