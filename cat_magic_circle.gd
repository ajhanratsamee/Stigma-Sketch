class_name CatMagicCircle
extends Node2D
## วงเวทใหญ่บนพื้น เป็นทรงกระบอกแสงกระพริบขึ้นลง วางที่พื้น y 0
## FLAME KNIGHT 50.2 สีส้มทอง ยืนในวงได้ MP เพิ่ม ส่วน GUARDIAN 50.2 สีแดง ยืนในวงได้ SA
## walk_page เป็นคนเช็กว่าตัวละครอยู่ในวง

const RY_K := 0.18

var radius := 420.0
var high := 620.0
var life := 12.0
var tint := Color(1.0, 0.6, 0.2)
var pillar := true
var _t := 0.0

func inside(x: float) -> bool:
	return absf(x - position.x) <= radius

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	queue_redraw()

func _oval(rx: float, ry: float, y: float, n: int = 48) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n + 1:
		var a := TAU * float(i) / float(n)
		pts.append(Vector2(cos(a) * rx, y + sin(a) * ry))
	return pts

func _draw() -> void:
	var grow := clampf(_t / 0.35, 0.0, 1.0) * CatGlow.pop(_t, 0.4)
	var fade := clampf((life - _t) / 0.5, 0.0, 1.0)
	var r := radius * grow
	var ry := r * RY_K
	# พื้นเรืองกว้างกว่าวง วงอักษรนอกสุดหมุนสวนทาง ลำแสงจากกลางวง
	CatGlow.glow_oval(self, Vector2.ZERO, r * 1.35, ry * 1.6, Color(tint, 0.75 * fade), 4)
	draw_polyline(_oval(r * 1.15, ry * 1.15, 0.0), Color(tint.lightened(0.3), 0.55 * fade), 3.0, true)
	for i in 36:
		var a := TAU * float(i) / 36.0 - _t * 0.9
		var p := Vector2(cos(a) * r * 1.08, sin(a) * ry * 1.08)
		CatGlow.star4(self, p, 7.0 + 3.0 * float(i % 3), Color(tint.lightened(0.5), 0.75 * fade))
	CatGlow.rays(self, Vector2(0.0, -6.0), 20.0, r * 0.9, 12, Color(tint.lightened(0.4), 0.18 * fade), _t * 0.5, 0.05)
	# วงเวทบนพื้น วงซ้อน อักษรเป็นขีดวิ่งวน
	var ground := _oval(r, ry, 0.0)
	ground.remove_at(ground.size() - 1)
	draw_colored_polygon(ground, Color(tint, 0.14 * fade))
	draw_polyline(_oval(r, ry, 0.0), Color(tint, 0.85 * fade), 5.0, true)
	draw_polyline(_oval(r * 0.82, ry * 0.82, 0.0), Color(tint, 0.6 * fade), 3.0, true)
	draw_polyline(_oval(r * 0.45, ry * 0.45, 0.0), Color(tint, 0.6 * fade), 3.0, true)
	for i in 24:
		var a := TAU * float(i) / 24.0 + _t * 0.6
		var p := Vector2(cos(a) * r * 0.91, sin(a) * ry * 0.91)
		draw_line(p, p + Vector2(cos(a + PI * 0.5) * 18.0, sin(a + PI * 0.5) * 4.0), Color(tint.lightened(0.4), 0.8 * fade), 3.0, true)
	# อุ้งเท้าแมวใหญ่กลางวง รอยเท้าเล็กวนรอบวงใน
	CatGlow.paw(self, Vector2.ZERO, r * 0.3, Color(tint.lightened(0.3), 0.5 * fade), PI, RY_K * 1.6)
	for i in 8:
		var a := TAU * float(i) / 8.0 - _t * 0.5
		CatGlow.paw(self, Vector2(cos(a) * r * 0.64, sin(a) * ry * 0.64), r * 0.06, Color(tint.lightened(0.4), 0.75 * fade), a + PI * 0.5, RY_K * 2.0)
	for n in 6:
		var a := TAU * float(n) / 6.0 - _t * 0.4
		var b := a + TAU / 3.0
		draw_line(Vector2(cos(a) * r * 0.82, sin(a) * ry * 0.82), Vector2(cos(b) * r * 0.82, sin(b) * ry * 0.82), Color(tint, 0.45 * fade), 2.5, true)
	if not pillar:
		return
	# ผนังทรงกระบอก แถบแสงวิ่งขึ้นลงและกระพริบ
	var blink := 0.6 + 0.4 * sin(_t * 9.0)
	var h := high * grow
	draw_colored_polygon(PackedVector2Array([Vector2(-r, 0.0), Vector2(-r, -h), Vector2(r, -h), Vector2(r, 0.0)]), Color(tint, 0.07 * blink * fade))
	draw_line(Vector2(-r, 0.0), Vector2(-r, -h), Color(tint, 0.5 * blink * fade), 4.0, true)
	draw_line(Vector2(r, 0.0), Vector2(r, -h), Color(tint, 0.5 * blink * fade), 4.0, true)
	for i in 3:
		var y := -h * (0.5 + 0.5 * sin(_t * 2.2 + float(i) * 2.1))
		draw_polyline(_oval(r, ry, y), Color(tint.lightened(0.3), 0.55 * blink * fade), 4.0, true)
	draw_polyline(_oval(r, ry, -h), Color(tint, 0.35 * fade), 3.0, true)
	CatGlow.embers(self, Vector2.ZERO, r * 0.9, h, 20, _t, Color(tint.lightened(0.5), 0.8 * blink * fade), 13.0, 7.0)
	CatGlow.sparkles(self, Vector2(0.0, -h * 0.5), r * 0.9, h * 0.5, 16, _t, Color(1.0, 1.0, 0.95, 0.85 * fade), 14.0, 12.0)
	draw_polyline(_oval(r, ry, -h), Color(tint.lightened(0.4), 0.25 * fade), 16.0, true)
	# รอยเท้าแมวลอยขึ้นในเสา
	for i in 4:
		var k := fposmod(_t * 0.4 + float(i) * 0.25, 1.0)
		CatGlow.bean_paw(self, Vector2(sin(float(i) * 2.3) * r * 0.5, -h * k), 22.0, Color(tint.lightened(0.5), 0.7 * blink * fade), 0.0, (1.0 - k) * fade)
