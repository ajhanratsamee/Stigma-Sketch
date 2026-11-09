class_name NeedleShot
extends Node2D
## เข็มฉีดยาที่ยิงตรงไปด้านหน้า ชนมอนตัวแรกแล้วหาย มอนชะงัก

const U := CombatData.UNIT
const LIFE := 1.2
const SPEED := 14.0
const TOUCH_X := 0.7
const TOUCH_TOP := 2.2
const L := 26.0
const W := 8.0
const NEEDLE := 16.0

var pos := Vector2.ZERO
var dir := 1.0
var dmg := 8.0
var hero: Hero
var extra_hit := {}            # แก้ผลที่มอนโดน เช่น เข็มสุดท้ายทำล้ม
var _t := 0.0

func _ready() -> void:
	z_index = 2
	scale.x = dir
	position = Vector2(pos.x, -pos.y) * U

func _physics_process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	pos.x += dir * SPEED * delta
	position = Vector2(pos.x, -pos.y) * U
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	hit.merge(extra_hit, true)
	for e in get_tree().get_nodes_in_group("monsters"):
		var dy: float = pos.y - e.pos.y
		if e.is_invulnerable() or absf(e.pos.x - pos.x) >= TOUCH_X or dy <= -0.3 or dy >= TOUCH_TOP:
			continue
		var hp_before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)
		queue_free()
		return

func _draw() -> void:
	var body := Rect2(Vector2(-L, -W), Vector2(L * 2.0, W * 2.0))
	draw_rect(body, Color.WHITE)
	draw_rect(Rect2(Vector2(-L * 0.3, -W), Vector2(L * 1.3, W * 2.0)), Hero.DRONE_ACCENT)
	Sketch.line(self, PackedVector2Array([body.position, Vector2(body.end.x, body.position.y), body.end, Vector2(body.position.x, body.end.y), body.position]), 2410, 2.4, 0.3)
	Sketch.line(self, PackedVector2Array([Vector2(L, 0.0), Vector2(L + NEEDLE, 0.0)]), 2411, 2.6, 0.1)
	Sketch.line(self, PackedVector2Array([Vector2(-L, 0.0), Vector2(-L - 12.0, 0.0)]), 2412, 2.8, 0.1)
