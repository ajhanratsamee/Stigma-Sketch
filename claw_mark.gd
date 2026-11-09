class_name ClawMark
extends Node2D
## รอยข่วนกรงเล็บสามเส้นโค้งตอนตีโดน ขีดเร็วแล้วจางหาย มีรอยอุ้งเท้าเล็กเด้งออก ใช้กับทุกคอมโบและสกิล

const LIFE := 0.32
const INK := Color(0.2, 0.17, 0.15)

var dir := 1.0
var tint := Color(1.0, 0.95, 0.85)
var _t := 0.0

func _ready() -> void:
	z_index = 5
	rotation = randf_range(-0.5, 0.2) * dir

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	queue_redraw()

func _draw() -> void:
	var k := _t / LIFE
	var draw_k := clampf(k / 0.35, 0.0, 1.0)
	var fade := 1.0 - clampf((k - 0.5) / 0.5, 0.0, 1.0)
	for i in 3:
		var off := (float(i) - 1.0) * 26.0
		var pts := PackedVector2Array()
		for n in 9:
			var t := float(n) / 8.0 * draw_k
			pts.append(Vector2(dir * (-60.0 + 120.0 * t), off - 40.0 + 80.0 * t + sin(t * PI) * -14.0))
		if pts.size() > 1:
			draw_polyline(pts, Color(INK, 0.55 * fade), 13.0, true)
			draw_polyline(pts, Color(tint, fade), 7.0, true)
	# รอยอุ้งเท้าเล็กเด้งออก
	var p := Vector2(dir * 46.0 * k, -50.0 * k)
	var r := 10.0 * (1.0 - k * 0.5)
	draw_circle(p, r * 0.7, Color(1.0, 0.65, 0.75, fade))
	for t in 3:
		draw_circle(p + Vector2((float(t) - 1.0) * r * 0.7, -r * 0.8), r * 0.3, Color(1.0, 0.65, 0.75, fade))
