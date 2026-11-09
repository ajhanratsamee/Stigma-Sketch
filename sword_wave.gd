class_name SwordWave
extends Node2D
## คลื่นดาบจางๆ ระยะสั้น ของ LORD KNIGHT 35.4 ออกไปข้างหน้าแล้วหาย แรงกว่าฮิตปกติ เส้นระบายบางๆ

const U := CombatData.UNIT
const SPEED := 12.0
const RANGE := 4.0
const HALF := 1.3
const HIT_X := 1.0
const HIT_Y := 2.6
const RED := Color(0.86, 0.14, 0.14)
const FAINT := 0.55
const STEPS := 14

var x := 0.0
var dir := 1.0
var dmg := 20.0
var hero: Hero
var hit_list: Array = []
var _went := 0.0

func _ready() -> void:
	z_index = 2

func _physics_process(delta: float) -> void:
	x += dir * SPEED * delta
	_went += SPEED * delta
	queue_redraw()
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	for e in get_tree().get_nodes_in_group("monsters"):
		if e in hit_list or absf(e.pos.x - x) > HIT_X or e.pos.y > HIT_Y:
			continue
		hit_list.append(e)
		var before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(before - e.hp, hit)
	if _went >= RANGE:
		queue_free()

## พระจันทร์เสี้ยวตั้งตรง โค้งไปทางที่พุ่ง จางลงตามระยะ
func _draw() -> void:
	var fade := FAINT * (1.0 - _went / RANGE)
	var c := Vector2(x, -1.2) * U
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in STEPS + 1:
		var t := float(i) / STEPS
		var a := lerpf(-1.2, 1.2, t)
		outer.append(c + Vector2(cos(a) * dir * HALF, sin(a) * HALF) * U)
		inner.append(c + Vector2((cos(a) - 0.45 * sin(t * PI)) * dir * HALF, sin(a) * HALF) * U)
	var band := outer.duplicate()
	var back := inner.duplicate()
	back.reverse()
	band.append_array(back)
	Sketch.hatch(self, band, Color(RED, fade), 2860, 10.0)
	Sketch.line(self, outer, 2861, 2.6, 0.6, Color(Sketch.INK, fade))
