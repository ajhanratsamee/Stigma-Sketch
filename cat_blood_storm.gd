class_name CatBloodStorm
extends Node2D
## DARK KNIGHT 35.1 พายุเลือดใหญ่ เคลื่อนช้าๆ เข้าหาจุดกลาง พัดมอนที่อยู่ในพายุให้ไหลตามมา
## walk_page เป็นคนลากมอนและสั่งระเบิดเมื่อพายุสองลูกมาบรรจบกัน

const BANDS := 18
const BAND_GAP := 20.0
const HALF := 120.0
const DARK := Color(0.5, 0.08, 0.22)
const RED := Color(0.95, 0.3, 0.48)
const PALE := Color(1.0, 0.72, 0.8)

var dir := 1.0                # ทิศที่พายุเคลื่อนไป
var light := false            # สีแดงสว่างของ GRAND KNIGHT 45.1 แทนเลือดคล้ำ
var _t := 0.0
var _specks: Array = []

func _ready() -> void:
	for i in 30:
		_specks.append([randf() * TAU, randf() * BANDS * BAND_GAP, randf_range(80.0, 160.0), randf_range(2.5, 5.0)])

func _process(delta: float) -> void:
	_t += delta
	for s in _specks:
		s[0] += delta * 8.0
		s[1] += float(s[2]) * delta
		if s[1] > BANDS * BAND_GAP:
			s[1] = 0.0
	queue_redraw()

## ภาพพายุใหญ่กว่าระยะที่ใช้ลากมอน ให้ดูยิ่งใหญ่
const LOOK := 1.45

func _band(k: float) -> Vector2:
	var sway := sin(_t * 3.0 + k * 0.4) * k * 1.8 * LOOK
	return Vector2(sway, (30.0 + k * 9.0) * LOOK)

func _draw() -> void:
	var grow := clampf(_t / 0.3, 0.0, 1.0) * CatGlow.pop(_t, 0.35)
	var hue := Color(1.0, 0.35, 0.33) if light else RED
	# พื้นเรือง ฝุ่นวงนอก ลำแสงจากฐาน
	CatGlow.glow_oval(self, Vector2(0.0, -6.0), 300.0 * grow, 50.0 * grow, Color(hue, 0.8), 4)
	CatGlow.halo(self, Vector2(0.0, -BANDS * BAND_GAP * 0.55 * grow), 330.0 * grow, Color(hue, 0.7), 4)
	CatGlow.rays(self, Vector2(0.0, -10.0), 50.0, 360.0 * grow, 9, Color(PALE, 0.22 * grow), -_t * 2.0)
	CatGlow.embers(self, Vector2(0.0, 0.0), 220.0, BANDS * BAND_GAP * 1.1, 16, _t, Color(PALE, 0.8 * grow), 7.0, 7.0)
	for i in 8:
		var a := _t * 6.0 + float(i) * 0.8
		draw_circle(Vector2(cos(a) * 110.0, -8.0 + sin(a) * 14.0), 42.0, Color(DARK, 0.25 * grow))
	for n in BANDS:
		var k := float(n)
		var band := _band(k)
		var c := Vector2(band.x, -k * BAND_GAP * grow)
		var rx := band.y
		var ry := rx * 0.28
		var body := PackedVector2Array()
		for i in 20:
			var a := TAU * float(i) / 20.0
			body.append(c + Vector2(cos(a) * rx, sin(a) * ry))
		draw_colored_polygon(body, Color(Color(0.95, 0.35, 0.33) if light else DARK, 0.16 * grow))
		for streak in 3:
			var start := _t * (10.0 - k * 0.25) + float(streak) * TAU / 3.0 + k * 0.6
			var arc := PackedVector2Array()
			for i in 9:
				var a := start + float(i) * 0.2
				arc.append(c + Vector2(cos(a) * rx, sin(a) * ry))
			var front := 0.5 + 0.5 * sin(start + 0.8)
			var col := (Color(1.0, 0.3, 0.28) if light else RED) if streak != 0 else PALE
			draw_polyline(arc, Color(col, (0.3 + 0.55 * front) * grow), 4.0 + front * 4.0, true)
	var idx := 0
	for s in _specks:
		var k: float = float(s[1]) / BAND_GAP
		var band := _band(k)
		var p := Vector2(band.x + cos(s[0]) * band.y, -float(s[1]) * grow + sin(s[0]) * band.y * 0.28)
		idx += 1
		if idx % 3 == 0:
			CatGlow.paw(self, p, float(s[3]) * 2.2, Color(PALE, 0.85 * grow), float(s[0]))
		else:
			draw_circle(p, s[3], Color(RED.darkened(0.3), 0.8 * grow))
	# ยอดพายุมีหูแมว
	var topk := float(BANDS - 1)
	var tb := _band(topk)
	var tc := Vector2(tb.x, -topk * BAND_GAP * grow)
	var ear_col := Color(Color(1.0, 0.3, 0.28) if light else RED, 0.75 * grow)
	for side in [-1.0, 1.0]:
		var base := tc + Vector2(side * tb.y * 0.6, 0.0)
		var ear := PackedVector2Array([base + Vector2(-side * tb.y * 0.2, 4.0), base + Vector2(side * tb.y * 0.1, -tb.y * 0.4), base + Vector2(side * tb.y * 0.28, 6.0)])
		draw_colored_polygon(ear, ear_col)
		var mid := (ear[0] + ear[1] + ear[2]) / 3.0
		draw_colored_polygon(PackedVector2Array([ear[0].lerp(mid, 0.5), ear[1].lerp(mid, 0.5), ear[2].lerp(mid, 0.5)]), Color(PALE, 0.8 * grow))
