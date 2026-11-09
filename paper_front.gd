class_name PaperFront
## ชั้นหน้าแบบกระดาษตัดมีเส้นหมึก ใช้ร่วมกันทุกฉาก (ห้องฝึก ดันเจี้ยน)
## ฉากหลังเป็นสีน้ำนุ่มๆ ส่วนพื้นหน้าเป็นกระดาษตัดขอบหยัก มีเงาใต้กระดาษ เส้นหมึกบางๆ
## ของประดับโลกแมว รอยเท้าแมว ไหมพรม ป้ายปลา ทุกชิ้นทรงมน ไม่มีดาวแฉก

const INK := Color(0.22, 0.18, 0.16)

## ขอบพื้นกระดาษตัด หยักนุ่มๆ ตามแนวพื้น มีเงากระดาษด้านล่าง และเส้นหมึกตามขอบบน
static func lip(c: CanvasItem, x0: float, x1: float, g: float, ground: Color, seed_no: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_no
	var top := PackedVector2Array()
	var x := x0
	var phase := rng.randf() * TAU
	while x <= x1 + 24.0:
		top.append(Vector2(x, g - 6.0 + sin(x * 0.012 + phase) * 4.0 + sin(x * 0.031 + phase * 2.0) * 2.0))
		x += 24.0
	# เงาใต้ขอบกระดาษ
	var shade := PackedVector2Array()
	for p in top:
		shade.append(p + Vector2(0.0, 7.0))
	for i in range(top.size() - 1, -1, -1):
		shade.append(top[i] + Vector2(0.0, 16.0))
	c.draw_colored_polygon(shade, Color(0.0, 0.0, 0.0, 0.08))
	# ตัวกระดาษ แถบสว่างกว่าพื้นนิดหน่อย
	var body := top.duplicate()
	for i in range(top.size() - 1, -1, -1):
		body.append(top[i] + Vector2(0.0, 12.0))
	c.draw_colored_polygon(body, ground.lightened(0.14))
	c.draw_polyline(top, Color(INK, 0.7), 2.2, true)

## รอยเท้าแมวบนพื้น บีบแบนตามมุมมองพื้น
static func paw(c: CanvasItem, at: Vector2, r: float, col: Color) -> void:
	c.draw_set_transform(at, 0.0, Vector2(1.0, 0.45))
	c.draw_circle(Vector2(0.0, r * 0.3), r * 0.55, col)
	for i in 4:
		var a := -2.3 + float(i) * 0.53
		c.draw_circle(Vector2(cos(a), sin(a)) * r * 0.95, r * 0.22, col)
	c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## ไหมพรมกระดาษตัด มีเส้นหมึกขอบ เส้นด้ายโค้ง และปลายด้ายห้อย
static func yarn(c: CanvasItem, at: Vector2, r: float, col: Color) -> void:
	c.draw_circle(at + Vector2(3.0, r * 0.9), r * 0.9, Color(0.0, 0.0, 0.0, 0.08))
	c.draw_circle(at, r, col)
	for k in 3:
		c.draw_arc(at, r * (0.35 + 0.22 * float(k)), 0.4 + float(k), 2.6 + float(k), 12, col.darkened(0.25), 2.0, true)
	c.draw_arc(at, r, 0.0, TAU, 28, Color(INK, 0.75), 2.0, true)
	var tail := PackedVector2Array([at + Vector2(r * 0.7, r * 0.7), at + Vector2(r * 1.3, r * 0.95), at + Vector2(r * 1.8, r * 0.85)])
	c.draw_polyline(tail, col.darkened(0.2), 2.0, true)

## ป้ายไม้รูปปลา ปักดิน
static func fish_sign(c: CanvasItem, at: Vector2, s: float, col: Color) -> void:
	var pole_top := at + Vector2(0.0, -s * 1.6)
	c.draw_rect(Rect2(at.x - s * 0.07, pole_top.y, s * 0.14, s * 1.6), Color(0.62, 0.46, 0.32))
	c.draw_line(at + Vector2(-s * 0.07, 0.0), pole_top + Vector2(-s * 0.07, 0.0), Color(INK, 0.6), 1.6, true)
	c.draw_line(at + Vector2(s * 0.07, 0.0), pole_top + Vector2(s * 0.07, 0.0), Color(INK, 0.6), 1.6, true)
	var mid := pole_top + Vector2(0.0, -s * 0.05)
	var body := PackedVector2Array()
	for i in 24:
		var a := TAU * float(i) / 24.0
		body.append(mid + Vector2(cos(a) * s * 0.62, sin(a) * s * 0.34))
	# หางปลามน
	var tail := PackedVector2Array()
	for i in 12:
		var a := PI * 0.5 + PI * float(i) / 11.0
		tail.append(mid + Vector2(-s * 0.72, 0.0) + Vector2(cos(a) * s * 0.22 - s * 0.05, sin(a) * s * 0.3))
	c.draw_colored_polygon(tail, col.darkened(0.1))
	c.draw_colored_polygon(body, col)
	var rim := body.duplicate()
	rim.append(body[0])
	c.draw_polyline(rim, Color(INK, 0.75), 2.0, true)
	c.draw_circle(mid + Vector2(s * 0.34, -s * 0.06), s * 0.07, INK)
	c.draw_circle(mid + Vector2(s * 0.32, -s * 0.09), s * 0.025, Color.WHITE)
	c.draw_arc(mid + Vector2(-s * 0.05, 0.0), s * 0.18, -1.0, 1.0, 8, Color(INK, 0.5), 1.6, true)

## หัวใจมน ใช้แทนดาวแฉก
static func heart(c: CanvasItem, at: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in 28:
		var t := TAU * float(i) / 28.0
		pts.append(at + Vector2(16.0 * pow(sin(t), 3.0), -(13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t))) * r / 16.0)
	c.draw_colored_polygon(pts, col)
