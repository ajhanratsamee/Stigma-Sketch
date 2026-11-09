class_name CatOrbit
extends Node2D
## CRIMSON KNIGHT 50.1 ใบเลือดเล็ก 2 อันหมุนรอบตัวเร็วมาก เดินตามตัวละคร
## walk_page ทำดาเมจรอบตัวผ่านระบบโซน ไม่ทำให้ชะงัก

const RX := 130.0
const RY := 40.0
const Y := -70.0

var target: Node2D
var hit_half := RX + 80.0
var _t := 0.0

func burst() -> void:
	queue_free()

func _process(delta: float) -> void:
	_t += delta
	if is_instance_valid(target):
		position = target.position
	queue_redraw()

func _blade(c: Vector2, a: float, front: float) -> void:
	var r := 36.0
	CatGlow.halo(self, c, 70.0, Color(1.0, 0.4, 0.5, 0.6 + 0.4 * front), 3)
	var pts := PackedVector2Array()
	for i in 3:
		var t := a + TAU * float(i) / 3.0
		pts.append(c + Vector2(cos(t), sin(t)) * r)
		pts.append(c + Vector2(cos(t + 0.5), sin(t + 0.5)) * r * 0.35)
	draw_colored_polygon(pts, Color(0.8, 0.05, 0.1, 0.6 + 0.4 * front))
	CatGlow.paw(self, c, 14.0, Color(1.0, 0.75, 0.8, 0.7 + 0.3 * front), a)
	CatGlow.star4(self, c + Vector2(cos(a), sin(a)) * r, 10.0 * front, Color(1.0, 0.95, 0.95, front))

## ภาพวงโคจรใหญ่กว่าระยะโดนเล็กน้อย
const LOOK := 1.3

func _draw() -> void:
	var spin := _t * 14.0
	var k := CatGlow.pop(_t, 0.25)
	var rx := RX * LOOK * k
	var ry := RY * LOOK * k
	CatGlow.glow_oval(self, Vector2(0.0, Y), rx * 1.2, ry * 1.6, Color(1.0, 0.35, 0.45, 0.45), 3)
	CatGlow.ring(self, Vector2(0.0, Y), rx, ry, Color(1.0, 0.6, 0.7, 0.35), 3.0)
	CatGlow.sparkles(self, Vector2(0.0, Y), rx * 1.1, ry * 1.8, 10, _t, Color(1.0, 0.9, 0.92, 0.9), 15.0, 9.0)
	for n in 2:
		var a := spin + PI * float(n)
		var front := 0.5 + 0.5 * sin(a)
		var trail := PackedVector2Array()
		for i in 16:
			var t := a - float(i) * 0.12
			trail.append(Vector2(cos(t) * rx, Y + sin(t) * ry))
		draw_polyline(trail, Color(1.0, 0.4, 0.5, 0.2), 26.0, true)
		draw_polyline(trail, Color(0.9, 0.1, 0.15, 0.55), 12.0, true)
		draw_polyline(trail, Color(1.0, 0.8, 0.85, 0.6), 3.0, true)
		_blade(Vector2(cos(a) * rx, Y + sin(a) * ry), _t * 30.0, front)
