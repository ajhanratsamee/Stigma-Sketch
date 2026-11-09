class_name CatFireVortex
extends Node2D
## MAGIC KNIGHT 35.1 ลูกไฟกลมยักษ์ลอยเหนือพื้น หมุนในแนวนอนรอบแกนตั้ง
## มีเส้นเปลวไฟวิ่งวนรอบลูก วงแหวนบนพื้นหมุนบอกทิศ สะเก็ดไฟลอย ไม่มีเปลวไฟรอบลูก
## walk_page เป็นคนนับฮิต สั่ง burst() ตอนระเบิดจบ

const RX := 330.0
const RY := 330.0
const CENTER_Y := -360.0
const RING_RX := 470.0
const RING_RY := 56.0
const OUTER := Color(0.9, 0.22, 0.05)
const MID := Color(1.0, 0.5, 0.1)
const HOT := Color(1.0, 0.85, 0.45)
const CORE := Color(1.0, 0.97, 0.85)

var hit_half := RX + 60.0
var bursting := false
var _t := 0.0
var _burst_t := 0.0
var _embers: Array = []    # [ตำแหน่ง ความเร็ว อายุ]

func burst() -> void:
	bursting = true

func _process(delta: float) -> void:
	_t += delta
	if bursting:
		_burst_t += delta
		if _burst_t > 0.45:
			queue_free()
			return
	for i in 3:
		var a := randf() * TAU
		_embers.append([Vector2(cos(a) * RX * 0.95, CENTER_Y + sin(a) * RY * 0.95), Vector2(randf_range(-60.0, 60.0), randf_range(-220.0, -120.0)), 0.0])
	for e in _embers.duplicate():
		e[2] += delta
		e[0] = (e[0] as Vector2) + (e[1] as Vector2) * delta
		if e[2] > 0.8:
			_embers.erase(e)
	queue_redraw()

func _ellipse(c: Vector2, rx: float, ry: float, n: int = 40) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _draw() -> void:
	var grow := clampf(_t / 0.25, 0.0, 1.0)
	var boom := clampf(_burst_t / 0.45, 0.0, 1.0)
	var size := grow * (1.0 + boom * 0.35)
	var fade := 1.0 - boom
	var c := Vector2(0.0, CENTER_Y)
	var spin := _t * 5.0
	size *= CatGlow.pop(_t, 0.35)
	# แสงไฟฟุ้งรอบลูก พื้นเรืองส้ม ลำแสงหมุนรอบลูก
	CatGlow.glow_oval(self, Vector2(0.0, -4.0), RING_RX * 1.5 * size, RING_RY * 2.4 * size, Color(MID, 0.8 * fade), 4)
	CatGlow.halo(self, c, RX * 2.0 * size, Color(MID, fade), 5)
	CatGlow.rays(self, c, RX * 0.9 * size, RX * 2.1 * size, 16, Color(HOT, 0.28 * fade), spin * 0.25, 0.06)
	CatGlow.embers(self, Vector2(0.0, -10.0), RING_RX * size, -CENTER_Y * 1.6, 22, _t, Color(1.0, 0.75, 0.3, 0.85 * fade), 11.0, 8.0)
	# วงแหวนบนพื้น ขีดเป็นช่วงๆ วิ่งวนบอกว่ากำลังหมุน
	for i in 16:
		var a0 := spin * 0.8 + TAU * float(i) / 16.0
		var arc := PackedVector2Array()
		for n in 6:
			var a := a0 + float(n) * 0.045
			arc.append(Vector2(cos(a) * RING_RX * size, sin(a) * RING_RY * size))
		var front := 0.5 + 0.5 * sin(a0)
		draw_polyline(arc, Color(MID, (0.35 + 0.5 * front) * fade), 4.0 + 3.0 * front, true)
	draw_polyline(_ellipse(Vector2.ZERO, RING_RX * size, RING_RY * size, 48) + PackedVector2Array([Vector2(RING_RX * size, 0.0)]), Color(OUTER, 0.35 * fade), 2.0, true)
	# ตัวลูกไฟแบน ไล่สีจากขอบเข้าแกน
	draw_colored_polygon(_ellipse(c, RX * size * 1.06, RY * size * 1.12), Color(OUTER, 0.35 * fade))
	draw_colored_polygon(_ellipse(c, RX * size, RY * size), Color(OUTER, 0.8 * fade))
	draw_colored_polygon(_ellipse(c, RX * size * 0.78, RY * size * 0.75), Color(MID, 0.88 * fade))
	draw_colored_polygon(_ellipse(c, RX * size * 0.5, RY * size * 0.48), Color(HOT, 0.92 * fade))
	draw_colored_polygon(_ellipse(c, RX * size * 0.22, RY * size * 0.22), Color(CORE, fade))
	# เส้นเปลวไฟวิ่งวนรอบแกนตั้ง ด้านหน้าสว่าง ด้านหลังจาง
	for band in 7:
		var k := float(band) / 6.0
		var ry := RY * size * (k * 1.6 - 0.8)
		var rx := RX * size * sqrt(maxf(1.0 - pow(k * 1.6 - 0.8, 2.0), 0.05)) * 0.98
		for streak in 3:
			var start := spin * (1.4 - k * 0.3) + float(streak) * TAU / 3.0 + k
			var arc := PackedVector2Array()
			for n in 10:
				var a := start + float(n) * 0.12
				arc.append(c + Vector2(sin(a) * rx, ry + cos(a) * RY * size * 0.12))
			var front := 0.5 + 0.5 * cos(start + 0.6)
			draw_polyline(arc, Color(HOT, (0.25 + 0.6 * front) * fade), 3.0 + front * 3.0, true)
	# หน้าแมวและหูบนลูกไฟ
	CatGlow.ears(self, c, RX * size, Color(MID, 0.9 * fade), Color(HOT, fade))
	CatGlow.face(self, c, RX * size * 0.8, Color(0.55, 0.15, 0.05, fade))
	CatGlow.whiskers(self, c, RX * size * 0.8, Color(0.55, 0.15, 0.05, 0.8 * fade), 5.0)
	# รอยเท้าแมววิ่งวนบนวงพื้น
	for i in 6:
		var a := spin * 0.8 + TAU * float(i) / 6.0
		CatGlow.paw(self, Vector2(cos(a) * RING_RX * size * 0.8, sin(a) * RING_RY * size * 0.8), 26.0 * size, Color(HOT, 0.6 * fade), a + PI * 0.5, 0.35)
	for e in _embers:
		var k: float = 1.0 - float(e[2]) / 0.8
		draw_circle(e[0], 3.0 + 6.0 * k, Color(1.0, 0.7, 0.25, k * fade))
	CatGlow.sparkles(self, c, RX * 1.5 * size, RY * 1.4 * size, 20, _t, Color(1.0, 0.97, 0.85, 0.9 * fade), 12.0, 14.0)
	# ระเบิดตอนจบ วงคลื่นไฟใหญ่และลำแสง
	if bursting:
		CatGlow.ring(self, c, RX * (1.0 + boom * 1.8), RY * (1.0 + boom * 1.8), Color(HOT, 1.0 - boom), 18.0 * (1.0 - boom) + 2.0)
		CatGlow.ring(self, Vector2(0.0, -4.0), RING_RX * (1.0 + boom * 1.5), RING_RY * (1.0 + boom * 1.5), Color(MID, 1.0 - boom), 10.0 * (1.0 - boom) + 2.0)
		CatGlow.rays(self, c, RX * 0.5, RX * (2.0 + boom * 1.5), 18, Color(CORE, 0.7 * (1.0 - boom)), 0.1, 0.07)
