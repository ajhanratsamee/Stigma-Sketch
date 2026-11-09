class_name SpinTop
extends Node2D
## ลูกข่างของ TWIN NODE ยิงออกไปด้านหน้า ตกถึงพื้นแล้วไถลไปเรื่อยๆ 2.3 วินาทีแล้วระเบิด
## โดนมอนก่อนหมดเวลาก็ระเบิดทันที ระเบิดทำให้มอนลอย

const U := CombatData.UNIT
const GRAVITY := 16.0
const SLIDE_SPEED := 3.6
const SLIDE_TIME := 2.3
const AIR_LIFE := 2.0
const TOUCH_X := 0.75
const TOUCH_TOP := 2.2
const BLAST_R := 1.8
const SMALL_BLAST := 1.1
const SMALL_K := 0.6
const R := 24.0
const STRIPES := 3
const FOLLOW_TIME := 6.0         # ลูกเล็กตามมอนที่เป็นเป้านานเท่านี้
const FOLLOW_SPEED := 8.0

var pos := Vector2.ZERO
var vel := Vector2.ZERO
var dir := 1.0
var dmg := 14.0
var hero: Hero
var sliding := false
var small := false             # ลูกเล็ก ระเบิดเล็ก มอนแค่ชะงัก
var slide_time := SLIDE_TIME
var exploded := false
var followed := false
var slide_t := 0.0
var _air_t := 0.0
var _follow_t := 0.0
var _clock := 0.0

func _ready() -> void:
	z_index = 2
	_place()

func _physics_process(delta: float) -> void:
	_clock += delta
	queue_redraw()
	if small:
		_small_tick(delta)
		return
	# มีมอนเป็นเป้าในระยะ ลูกข่างวิ่งตามเป้า
	if is_instance_valid(hero):
		var mark: Node2D = hero.marked_near()
		if mark != null and absf(mark.pos.x - pos.x) > 0.05:
			dir = signf(mark.pos.x - pos.x)
			vel.x = absf(vel.x) * dir
			followed = true
	if sliding:
		slide_t += delta
		pos.x += dir * SLIDE_SPEED * delta * (1.8 if small else 1.0)
		if slide_t >= slide_time:
			_explode()
			return
	else:
		_air_t += delta
		vel.y -= GRAVITY * delta
		pos += vel * delta
		if pos.y <= 0.0:
			pos.y = 0.0
			sliding = true
		elif _air_t >= AIR_LIFE:
			_explode()
			return
	_place()
	for e in get_tree().get_nodes_in_group("monsters"):
		var dy: float = pos.y - e.pos.y
		if not e.is_invulnerable() and absf(e.pos.x - pos.x) < TOUCH_X and dy > -0.4 and dy < TOUCH_TOP:
			_explode()
			return

## ลูกเล็ก พ้นตัวไปนิดเดียวก็ระเบิด เว้นแต่มีมอนเป็นเป้าในระยะจอ จะตามไปนานขึ้น
func _small_tick(delta: float) -> void:
	var mark: Node2D = hero.marked_near() if is_instance_valid(hero) else null
	if mark != null:
		followed = true
		_follow_t += delta
		pos += (mark.pos + Vector2(0.0, 1.0) - pos).normalized() * FOLLOW_SPEED * delta
		if _follow_t >= FOLLOW_TIME:
			_explode()
			return
	else:
		slide_t += delta
		pos += vel * delta
		if slide_t >= slide_time:
			_explode()
			return
	pos.y = maxf(pos.y, 0.0)
	_place()
	for e in get_tree().get_nodes_in_group("monsters"):
		var dy: float = pos.y - e.pos.y
		if not e.is_invulnerable() and absf(e.pos.x - pos.x) < TOUCH_X and dy > -0.4 and dy < TOUCH_TOP:
			_explode()
			return

func _explode() -> void:
	exploded = true
	var hit := {"type": "launch", "vy": 11.0, "dmg": dmg, "kd": 40}
	if small:
		hit = {"type": "flinch", "dmg": dmg, "kb": 0.0, "skill": true}
	var blast := SMALL_BLAST if small else BLAST_R
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) > blast or e.pos.y - pos.y > blast + TOUCH_TOP:
			continue
		var hp_before: float = e.hp
		var side := signf(e.pos.x - pos.x)
		if e.take_hit(hit, side if side != 0.0 else dir) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)
	var fx := ImpactFx.new()
	fx.kind = "ram"
	fx.pos = pos + Vector2(0.0, 0.5)
	get_parent().add_child(fx)
	if not small:
		var ring := ImpactFx.new()
		ring.kind = "pillar"
		ring.pos = Vector2(pos.x, 0.0)
		get_parent().add_child(ring)
	queue_free()

func _place() -> void:
	position = Vector2(pos.x, -pos.y) * U
	scale = Vector2.ONE * (SMALL_K if small else 1.0)

## ลูกข่างรูปข้าวหลามตัด ปลายล่างแหลมแตะพื้น แถบม่วงวิ่งรอบตัวเหมือนกำลังหมุน
func _draw() -> void:
	var c := Vector2(0.0, -R)
	var tip := Vector2(0.0, 0.0)
	var shape := PackedVector2Array([tip, c + Vector2(R, 0.0), c + Vector2(R * 0.5, -R * 0.75), c + Vector2(0.0, -R * 0.95), c + Vector2(-R * 0.5, -R * 0.75), c + Vector2(-R, 0.0)])
	draw_colored_polygon(shape, Color.WHITE)
	for n in STRIPES:
		var x := sin(_clock * 18.0 + TAU * n / STRIPES) * R * 0.75
		draw_line(c + Vector2(x, -R * 0.55), c + Vector2(x * 0.75, R * 0.45), Hero.DRONE_ACCENT, 3.0, true)
	shape.append(shape[0])
	Sketch.line(self, shape, 2390, 2.8, 0.3)
	Sketch.line(self, PackedVector2Array([c + Vector2(0.0, -R * 0.95), c + Vector2(0.0, -R * 1.35)]), 2391, 3.0, 0.1)
