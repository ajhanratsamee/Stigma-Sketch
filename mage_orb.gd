class_name MageOrb
extends CatFireball
## ลูกบอลไฟของ CAT SUSI เท่านั้น ไม่ใช้ร่วมกับสายอื่น
## ลูกกลมเปลวไฟชมพูม่วงหมุนวน แกนขาวชมพู มีเม็ดแสงกลมโปรยตามหาง ระเบิดเป็นเม็ดกลมกระจายและวงแหวนชมพู

const PINK := Color(1.0, 0.42, 0.75)
const VIOLET := Color(0.62, 0.3, 1.0)
const GLOW := Color(1.0, 0.8, 0.95)

## เม็ดแสงกลมฟุ้ง (แทนดาวห้าแฉก)
func _star(c: Vector2, r: float, _spin: float, color: Color) -> void:
	draw_circle(c, r * 0.8, Color(color, color.a * 0.35))
	draw_circle(c, r * 0.45, color)

## ภาพใหญ่กว่าขนาดจริงของลูก (ระยะโดนยังใช้ size() เดิม)
const LOOK := 1.0

func _draw() -> void:
	var r := size() * LOOK
	if bursting:
		var k := clampf(_burst_t / BURST_TIME, 0.0, 1.0)
		draw_circle(Vector2.ZERO, r * (1.0 + k * 2.2), Color(PINK, 0.35 * (1.0 - k)))
		draw_arc(Vector2.ZERO, r * (1.0 + k * 3.0), 0.0, TAU, 48, Color(GLOW, 1.0 - k), 9.0 * (1.0 - k) + 1.0, true)
		draw_arc(Vector2.ZERO, r * (0.6 + k * 2.0), 0.0, TAU, 40, Color(VIOLET, 0.8 * (1.0 - k)), 5.0 * (1.0 - k) + 1.0, true)
		# รังสีแตกกระจาย
		for i in 10:
			var a := TAU * float(i) / 10.0 + 0.2
			var d := Vector2(cos(a), sin(a))
			# เม็ดกลมกระจายออก แทนรังสีแหลม
			draw_circle(d * r * (1.0 + 2.0 * k), 7.0 * (1.0 - k) + 1.5, Color(GLOW, 0.9 * (1.0 - k)))
		for e in _embers:
			var f: float = 1.0 - float(e[2]) / EMBER_LIFE
			_star(e[0], float(e[3]) * 1.6 * f + 1.0, _t * 6.0 + float(e[3]), Color(GLOW if int(e[3]) % 2 == 0 else PINK, f))
		return
	# หางดาวโปรย
	for e in _embers:
		var f: float = 1.0 - float(e[2]) / EMBER_LIFE
		_star(e[0], float(e[3]) * 1.3 * f + 1.0, _t * 5.0 + float(e[3]), Color(PINK.lerp(GLOW, f), f))
	# หางแสงยาวด้านหลัง
	var tail_dir := tail.normalized() if tail.length() > 0.01 else Vector2(-1.0, 0.0)
	var tail_side := Vector2(-tail_dir.y, tail_dir.x)
	var lo := Color(PINK, 0.4)
	var hi := Color(VIOLET, 0.0)
	draw_polygon(PackedVector2Array([tail_side * r * 0.9, tail_dir * r * 4.2, -tail_side * r * 0.9]), PackedColorArray([lo, hi, lo]))
	# แสงฟุ้งรอบ หลายชั้น
	draw_circle(Vector2.ZERO, r * 2.1, Color(PINK, 0.06))
	draw_circle(Vector2.ZERO, r * 1.45, Color(PINK, 0.16))
	# ประกายวงโคจร
	for i in 4:
		var a := _t * 7.0 + TAU * float(i) / 4.0
		_star(Vector2(cos(a) * r * 1.5, sin(a) * r * 0.7), r * 0.16, _t * 5.0, Color(GLOW, 0.9))
	draw_circle(Vector2.ZERO, r * 1.18, Color(VIOLET, 0.3))
	# เปลวไฟวนรอบลูก ยืดไปทางหาง
	var body := PackedVector2Array()
	for i in 28:
		var a := TAU * float(i) / 28.0
		var dir := Vector2(cos(a), sin(a))
		var back := maxf(dir.dot(tail), 0.0)
		var lick := 1.0 + 0.12 * sin(a * 5.0 + _t * 18.0) + back * back * 0.55
		body.append(dir * r * lick)
	draw_colored_polygon(body, Color(VIOLET.lerp(PINK, 0.4), 0.92))
	draw_circle(Vector2.ZERO, r * 0.78, Color(PINK, 0.95))
	# เกลียวไฟหมุนข้างใน
	for arm in 2:
		var pts := PackedVector2Array()
		for n in 10:
			var k := float(n) / 9.0
			var a := _t * 9.0 + PI * float(arm) + k * 3.0
			pts.append(Vector2(cos(a), sin(a)) * r * 0.7 * (1.0 - k * 0.8))
		draw_polyline(pts, Color(GLOW, 0.85), maxf(2.0, r * 0.1), true)
	draw_circle(Vector2.ZERO, r * 0.32, Color(1.0, 0.95, 1.0))
	_star(Vector2.ZERO, r * 0.28, -_t * 4.0, Color(1.0, 0.75, 0.9))
	draw_circle(Vector2(-r * 0.3, -r * 0.32), r * 0.13, Color(1, 1, 1, 0.7))
	# หูแมวและหน้าเหมียว
	cat_face(r, VIOLET.lerp(PINK, 0.4), Color(1.0, 0.8, 0.92), Color(0.45, 0.1, 0.4))
