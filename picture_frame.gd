class_name PictureFrame
extends Node2D
## ฉากหลังตอน HYPER แบบมืด (dark) คือดำสนิททั้งจอ ถ้าไม่มืดเป็นพื้นกระดาษเก่ามีกรอบรูป ความเข้มตาม k

const TINT := Color(0.84, 0.76, 0.62)
const TINT_ALPHA := 0.8
const INSET := 22.0
const LINE := 7.0
const SCRIBBLE := 3.0

var k := 0.0:
	set(value):
		if value != k:
			k = value
			queue_redraw()
var dark := false

func _draw() -> void:
	if k <= 0.0:
		return
	var view := get_viewport_rect().size
	if dark:
		draw_rect(Rect2(Vector2.ZERO, view), Color(0.0, 0.0, 0.0, k))
		return
	draw_rect(Rect2(Vector2.ZERO, view), Color(TINT, TINT_ALPHA * k))
	var a := Vector2(INSET, INSET)
	var b := view - a
	Sketch.line(self, PackedVector2Array([a, Vector2(b.x, a.y), b, Vector2(a.x, b.y), a]), 770, LINE, SCRIBBLE, Color(Sketch.INK, k))
