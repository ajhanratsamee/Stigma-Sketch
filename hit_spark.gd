class_name HitSpark
extends Node2D
## ประกายเล็กๆ ตรงจุดที่ตีโดน จุดกลมฟุ้ง 4 จุดพุ่งออกนิดเดียวแล้วหาย ไม่มีรอยเท้าแมว

const LIFE := 0.22

var tint := Color(1.0, 0.9, 0.6)
var _t := 0.0
var _dirs: Array = []

func _ready() -> void:
	for i in 4:
		var a := TAU * float(i) / 4.0 + randf_range(-0.4, 0.4)
		_dirs.append(Vector2(cos(a), sin(a)) * randf_range(14.0, 26.0))

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	queue_redraw()

## ประกายกลมฟุ้ง แกนสว่าง ไม่มีแฉก
func _star(at: Vector2, r: float, color: Color) -> void:
	draw_circle(at, r * 0.75, Color(color, color.a * 0.35))
	draw_circle(at, r * 0.42, color)

func _draw() -> void:
	var k := _t / LIFE
	var a := 1.0 - k
	_star(Vector2.ZERO, 9.0 * (1.0 - k * 0.5), Color(1.0, 1.0, 1.0, a))
	for d in _dirs:
		_star((d as Vector2) * (0.4 + k), 5.0 * a + 1.0, Color(tint, a))
