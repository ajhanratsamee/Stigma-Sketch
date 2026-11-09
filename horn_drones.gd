class_name HornDrones
extends Node2D
## โดรนทรงโทรโข่งเล็กๆ 3 ตัวลอยหน้าตัวละคร ยิงลำแสงติดตามมอนด้านหน้าในระยะ 5 หน่วย
## ยิงต่อเนื่อง 6 จังหวะ มีมอนหลายตัวแบ่งกันไปตามจำนวนโดรน มอนชะงัก

const U := CombatData.UNIT
const COUNT := 3
const REACH := 5.0
const HITS := 6
const GAP := 0.14
const COME_TIME := 0.15
const LEAVE_TIME := 0.18
const DMG := 3.0
const SPOTS := [Vector2(0.9, 2.3), Vector2(1.5, 1.5), Vector2(0.9, 0.7)]   # เทียบเท้า หน้าตัวเป็นบวก
const HORN_LONG := 28.0
const HORN_MOUTH := 15.0
const HORN_NECK := 5.0
const BEAM := Color(0.74, 0.62, 0.96)
const BEAM_CORE := Color(0.93, 0.89, 1.0)

var hero: Hero
var facing := 1.0
var ticks_done := 0
var hits_done := 0
var _t := 0.0
var _next := COME_TIME
var _targets: Array = []

func _ready() -> void:
	z_index = 2
	facing = hero.facing

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	_targets = _find_targets()
	if ticks_done < HITS and _t >= _next:
		_next = _t + GAP
		ticks_done += 1
		_fire()
	if ticks_done >= HITS and _t >= _next + LEAVE_TIME:
		queue_free()

## มอนด้านหน้าในระยะ ตัวใกล้ก่อน ไม่เกินจำนวนโดรน
func _find_targets() -> Array:
	var found: Array = []
	for e in get_tree().get_nodes_in_group("monsters"):
		var dx: float = (e.pos.x - hero.pos.x) * facing
		if dx >= 0.0 and dx <= REACH and not e.is_invulnerable():
			found.append(e)
	found.sort_custom(func(a, b): return absf(a.pos.x - hero.pos.x) < absf(b.pos.x - hero.pos.x))
	return found.slice(0, COUNT)

func _fire() -> void:
	var hit := {"type": "flinch", "dmg": DMG, "kb": 0.0, "kb_air": 0.0, "air_lift": -1.0, "air_stall": 0.0, "no_air_limit": true}
	for e in _targets:
		var hp_before: float = e.hp
		if e.take_hit(hit, facing):
			hits_done += 1
			hero.count_hit(hp_before - e.hp, hit)

func _spot(i: int) -> Vector2:
	var s: Vector2 = SPOTS[i]
	return Vector2(hero.pos.x + facing * s.x, hero.pos.y + s.y)

func _draw() -> void:
	var come := minf(_t / COME_TIME, 1.0)
	var firing := ticks_done < HITS
	for i in COUNT:
		var at := Vector2(_spot(i).x, -_spot(i).y) * U
		var dir := Vector2(facing, 0.0)
		if firing and not _targets.is_empty():
			var e: Node2D = _targets[i % _targets.size()]
			var to := Vector2(e.pos.x, -(e.pos.y + 1.0)) * U
			dir = (to - at).normalized() if to != at else dir
			if come >= 1.0:
				_draw_beam(at + dir * HORN_LONG, to, i)
		_draw_horn(at, dir, come)

func _draw_beam(from: Vector2, to: Vector2, i: int) -> void:
	var side := (to - from).normalized().orthogonal()
	var pts := PackedVector2Array()
	for n in 7:
		var t := float(n) / 6.0
		var jag := sin(_t * 40.0 + float(n * 3 + i)) * 4.0 * (1.0 if n > 0 and n < 6 else 0.0)
		pts.append(from.lerp(to, t) + side * jag)
	draw_polyline(pts, BEAM, 6.0, true)
	draw_polyline(pts, BEAM_CORE, 2.4, true)

## โทรโข่ง คอแคบ ปากบาน ชี้ไปทางเป้า
func _draw_horn(at: Vector2, dir: Vector2, k: float) -> void:
	var side := dir.orthogonal()
	var long := HORN_LONG * k
	var pts := PackedVector2Array([
		at - side * HORN_NECK * k, at + dir * long * 0.55 - side * HORN_NECK * 1.3 * k, at + dir * long - side * HORN_MOUTH * k,
		at + dir * long + side * HORN_MOUTH * k, at + dir * long * 0.55 + side * HORN_NECK * 1.3 * k, at + side * HORN_NECK * k,
	])
	draw_colored_polygon(pts, Color.WHITE)
	draw_line(at + dir * long * 0.25, at + dir * long * 0.85, Hero.DRONE_ACCENT, 3.0, true)
	pts.append(pts[0])
	Sketch.line(self, pts, 2380, 2.6, 0.3)
