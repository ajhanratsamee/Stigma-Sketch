class_name ElecWave
extends Node2D
## คลื่นบอลไฟฟ้าสีม่วงอ่อน เลียดไปตามพื้นหรือพุ่งเฉียงลง โดนมอนตัวละครั้งแล้ววิ่งต่อ

const U := CombatData.UNIT
const BALL_R := 22.0
const HIT_X := 0.85
const HIT_HIGH := 3.0
const FADE := 0.16
const COLOR := Color(0.74, 0.62, 0.96)
const CORE := Color(0.93, 0.89, 1.0)
const SPARK_LONG := 1.7
const ARC := Color(0.5, 0.34, 0.86)
const ARCS := 5

var pos := Vector2.ZERO
var vel := Vector2.ZERO
var reach := 7.0
var dmg := 8.0
var extra_hit := {}
var hero: Hero
var hit_list: Array = []
var _went := 0.0
var _fade := 0.0
var _clock := 0.0
var _ending := false

func _ready() -> void:
	z_index = 2
	position = Vector2(pos.x, -pos.y) * U

func _physics_process(delta: float) -> void:
	_clock += delta
	queue_redraw()
	if _ending:
		_fade += delta / FADE
		if _fade >= 1.0:
			queue_free()
		return
	pos += vel * delta
	_went += vel.length() * delta
	position = Vector2(pos.x, -pos.y) * U
	if _went >= reach or (vel.y < 0.0 and pos.y <= 0.3):
		_ending = true
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	hit.merge(extra_hit, true)
	for e in get_tree().get_nodes_in_group("monsters"):
		if e in hit_list or absf(e.pos.x - pos.x) > HIT_X or pos.y - e.pos.y > HIT_HIGH or e.pos.y - pos.y > HIT_HIGH:
			continue
		hit_list.append(e)
		var hp_before: float = e.hp
		var dir := signf(vel.x) if vel.x != 0.0 else 1.0
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

func _draw() -> void:
	var k := 1.0 - _fade
	var r := BALL_R * k
	if r < 1.0:
		return
	Sketch.energy_ball(self, Vector2(vel.x, -vel.y) * U, r, COLOR, CORE, _clock)
	for n in ARCS:
		var a := TAU * n / ARCS + _clock * 9.0
		var d := Vector2(cos(a), sin(a))
		var side := d.orthogonal() * 5.0 * (1.0 if int(_clock * 24.0 + n) % 2 == 0 else -1.0)
		var pts := PackedVector2Array([d * r, d * r * 1.35 + side, d * r * SPARK_LONG])
		draw_polyline(pts, ARC, 2.0, true)
