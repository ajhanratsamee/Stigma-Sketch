class_name CatChakram
extends Node2D
## CRIMSON KNIGHT 45.1 กงจักรเลือดยักษ์หมุนในแนวนอน ใบมีดรอบวง พุ่งไปข้างหน้าช้าๆ
## walk_page เป็นคนเลื่อนและทำดาเมจผ่านระบบโซน

const RX := 600.0
const RY := 95.0
const CENTER_Y := -80.0

var hit_half := RX
var _t := 0.0

func burst() -> void:
	queue_free()

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()

func _draw() -> void:
	var grow := clampf(_t / 0.25, 0.0, 1.0) * CatGlow.pop(_t, 0.3)
	var rx := RX * grow
	var ry := RY * grow
	var c := Vector2(0.0, CENTER_Y)
	var spin := _t * 9.0
	# เงาเรืองบนพื้น แสงฟุ้งรอบจาน วงภาพติดตาหมุน
	CatGlow.glow_oval(self, Vector2(0.0, -4.0), rx * 1.1, ry * 0.6, Color(1.0, 0.3, 0.4, 0.7), 3)
	CatGlow.glow_oval(self, c, rx * 1.3, ry * 1.9, Color(1.0, 0.35, 0.45, 0.6), 4)
	for g in 3:
		CatGlow.ring(self, c, rx * (1.05 + 0.08 * float(g)), ry * (1.05 + 0.08 * float(g)), Color(1.0, 0.6, 0.65, 0.35 - float(g) * 0.1), 6.0 - float(g) * 1.5)
	var disk := PackedVector2Array()
	for i in 48:
		var a := TAU * float(i) / 48.0
		disk.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	draw_colored_polygon(disk, Color(0.4, 0.0, 0.05, 0.45))
	var inner := PackedVector2Array()
	for p in disk:
		inner.append(c + (p - c) * 0.55)
	draw_colored_polygon(inner, Color(0.75, 0.05, 0.1, 0.55))
	# ใบมีดรอบวง หมุนรอบแกนตั้ง ด้านหน้าสว่าง
	for i in 10:
		var a := spin + TAU * float(i) / 10.0
		var front := 0.5 + 0.5 * sin(a)
		var root := c + Vector2(cos(a) * rx * 0.9, sin(a) * ry * 0.9)
		var tip := c + Vector2(cos(a + 0.35) * rx * 1.12, sin(a + 0.35) * ry * 1.12)
		var back := c + Vector2(cos(a - 0.15) * rx * 0.95, sin(a - 0.15) * ry * 0.95)
		draw_colored_polygon(PackedVector2Array([back, tip, root]), Color(0.95, 0.15, 0.2, 0.5 + 0.5 * front))
		draw_line(root, tip, Color(1.0, 0.8, 0.8, 0.4 + 0.6 * front), 5.0, true)
		draw_circle(tip, 10.0 + 8.0 * front, Color(1.0, 0.9, 0.9, 0.5 * front))
	for streak in 3:
		var start := spin * 1.3 + float(streak) * TAU / 3.0
		var arc := PackedVector2Array()
		for i in 12:
			var a := start + float(i) * 0.12
			arc.append(c + Vector2(cos(a) * rx * 0.75, sin(a) * ry * 0.75))
		draw_polyline(arc, Color(1.0, 0.5, 0.5, 0.7), 4.0, true)
	CatGlow.sparkles(self, c, rx * 1.05, ry * 1.4, 22, _t, Color(1.0, 0.92, 0.92, 0.95), 8.0, 13.0)
	CatGlow.halo(self, c, 120.0 * grow, Color(1.0, 0.75, 0.8, 1.0))
	CatGlow.rays(self, c, 30.0, 170.0 * grow, 10, Color(1.0, 0.92, 0.92, 0.45), spin * 0.5)
	draw_circle(c, 40.0 * grow, Color(1.0, 0.7, 0.7))
	if grow > 0.2:
		CatGlow.ears(self, c, 50.0 * grow, Color(0.95, 0.3, 0.4), Color(1.0, 0.8, 0.85))
		draw_circle(c, 50.0 * grow, Color(1.0, 0.7, 0.75))
		CatGlow.face(self, c, 50.0 * grow, Color(0.5, 0.05, 0.12))
	# รอยเท้าแมววนบนจาน
	for i in 6:
		var a := spin * 0.6 + TAU * float(i) / 6.0
		CatGlow.paw(self, c + Vector2(cos(a) * rx * 0.4, sin(a) * ry * 0.4), 18.0 * grow, Color(1.0, 0.6, 0.65, 0.7), a + PI * 0.5, 0.45)
