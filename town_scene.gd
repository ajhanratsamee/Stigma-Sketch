class_name TownScene
## ฉากเมืองแบบต่างๆ ตาม "style" ใน TownData  วาดแบบสีน้ำนุ่ม พื้นหน้ากระดาษตัดมีเส้นหมึก ทุกอย่างทรงมน ไม่มีดาวแฉก
## แต่ละฟังก์ชันวาดหนึ่งชั้น (ท้องฟ้า ฉากไกล ฉากกลาง พื้น แถวบ้าน ชั้นหน้า) ใช้สีจาก palette ของเมือง
## p คือ TownPage ใช้ตัวช่วยของหน้า (_rng _view _span _ground_y _soft _cut pal() floor_data())

const INK := Color(0.22, 0.18, 0.16)

# ---------------------------------------------------------------- ท้องฟ้า
static func sky(c: Node2D, p) -> void:
	var low: float = p._ground_y()
	var top: Color = p.pal("sky")
	var bottom: Color = top.lerp(Color(1.0, 0.95, 0.88), 0.6)
	match p.style:
		"underground":
			top = p.pal("sky").darkened(0.15)
			bottom = p.pal("sky").lightened(0.15)
		"lava":
			bottom = Color(1.0, 0.78, 0.55)
		"sky":
			bottom = Color(1.0, 0.97, 0.92)
	var steps := 16
	for i in steps:
		var k := float(i) / float(steps - 1)
		c.draw_rect(Rect2(0.0, low * float(i) / float(steps), p._view.x, low / float(steps) + 1.0), top.lerp(bottom, k))
	if p.style == "sky":
		# ท้องฟ้าลึกลงไปใต้พื้นด้วย เพราะเมืองลอยอยู่บนเมฆ
		c.draw_rect(Rect2(0.0, low, p._view.x, p._view.y - low), bottom)
	if p.style != "underground":
		var sun := Color(1.0, 0.97, 0.82, 0.8) if p.style != "lava" else Color(1.0, 0.6, 0.35, 0.7)
		SoftPaint.oval(c, Vector2(p._view.x * 0.8, low * 0.3), 70.0, 70.0, sun, 0.6)
		SoftPaint.oval(c, Vector2(p._view.x * 0.8, low * 0.3), 36.0, 36.0, Color(1.0, 1.0, 0.94), 0.3)

static func clouds(c: Node2D, p) -> void:
	if p.style == "underground":
		# หยดคริสตัลเรืองแสงลอยช้าๆ แทนเมฆ
		var col: Color = p.pal("accent")
		var dots := []
		var xu := 0.0
		while xu < TownPage.CLOUD_TILE - 80.0:
			dots.append(Vector2(xu, p._rng.randf_range(40.0, 200.0)))
			xu += p._rng.randf_range(80.0, 160.0)
		for t in p.cloud_tiles():
			for d in dots:
				SoftPaint.oval(c, (d as Vector2) + Vector2(t, 0.0), 10.0, 10.0, Color(col, 0.35), 0.8)
		return
	# ลายเมฆหนึ่งช่วงวาดซ้ำ ลอยเองได้ไม่ขาดช่วง
	var col2 := Color(1.0, 1.0, 1.0, 0.75) if p.style != "lava" else Color(0.85, 0.75, 0.75, 0.6)
	var puffs := []
	var x := 0.0
	while x < TownPage.CLOUD_TILE - 200.0:
		var y: float = p._rng.randf_range(30.0, 120.0)
		for n in 4:
			puffs.append([Vector2(x + float(n) * 40.0, y + p._rng.randf_range(-10.0, 10.0)), p._rng.randf_range(40.0, 64.0), p._rng.randf_range(18.0, 28.0)])
		x += p._rng.randf_range(320.0, 520.0)
	for t in p.cloud_tiles():
		for pf in puffs:
			SoftPaint.oval(c, (pf[0] as Vector2) + Vector2(t, 0.0), pf[1], pf[2], col2, 0.5)

# ---------------------------------------------------------------- ฉากไกล
static func far(c: Node2D, p) -> void:
	var span: float = p._span(TownPage.PAR_FAR)
	var low: float = p._ground_y()
	match p.style:
		"harbor":
			# ทะเลกว้าง เรือใบไกลๆ ประภาคาร
			c.draw_rect(Rect2(-span, low - 90.0, span * 2.0, 90.0), Color(0.55, 0.78, 0.92, 0.7))
			for i in 6:
				var bx: float = p._rng.randf_range(-span, span)
				p._soft(c, PackedVector2Array([Vector2(bx - 30.0, low - 70.0), Vector2(bx + 30.0, low - 70.0), Vector2(bx + 20.0, low - 58.0), Vector2(bx - 20.0, low - 58.0)]), Color(0.75, 0.6, 0.45, 0.6))
				p._soft(c, PackedVector2Array([Vector2(bx, low - 70.0), Vector2(bx, low - 120.0), Vector2(bx + 26.0, low - 76.0)]), Color(1.0, 1.0, 1.0, 0.7))
		"snow":
			for layer in 2:
				_hills(c, p, span, low, 110.0 - float(layer) * 40.0, 190.0 - float(layer) * 40.0, [Color(0.85, 0.9, 1.0, 0.6), Color(0.92, 0.95, 1.0, 0.7)][layer])
		"desert":
			for layer in 2:
				_hills(c, p, span, low, 50.0 + float(layer) * 10.0, 110.0 - float(layer) * 30.0, [Color(0.95, 0.8, 0.55, 0.5), Color(0.98, 0.86, 0.62, 0.6)][layer])
			# พีระมิดหัวแมวไกลๆ ยอดมน
			for i in 3:
				var px: float = -span * 0.6 + float(i) * span * 0.55
				p._soft(c, PackedVector2Array([Vector2(px - 120.0, low - 40.0), Vector2(px - 18.0, low - 190.0), Vector2(px + 18.0, low - 190.0), Vector2(px + 120.0, low - 40.0)]), Color(0.92, 0.75, 0.5, 0.55))
				_ears_soft(c, p, px, low - 190.0, 22.0, 26.0, Color(0.92, 0.75, 0.5, 0.55))
		"lava":
			_hills(c, p, span, low, 90.0, 160.0, Color(0.55, 0.42, 0.45, 0.55))
			for i in 2:
				var vx: float = -span * 0.4 + float(i) * span * 0.8
				p._soft(c, PackedVector2Array([Vector2(vx - 220.0, low - 40.0), Vector2(vx - 50.0, low - 240.0), Vector2(vx + 50.0, low - 240.0), Vector2(vx + 220.0, low - 40.0)]), Color(0.5, 0.38, 0.42, 0.65))
				SoftPaint.oval(c, Vector2(vx, low - 250.0), 60.0, 26.0, Color(1.0, 0.55, 0.25, 0.55), 0.6)
		"underground":
			# เพดานถ้ำโค้งมน หินย้อยปลายกลม
			var ceil := PackedVector2Array([Vector2(-span, 0.0)])
			var x := -span
			while x <= span:
				ceil.append(Vector2(x, p._rng.randf_range(30.0, 70.0)))
				x += p._rng.randf_range(60.0, 120.0)
			ceil.append(Vector2(span, 0.0))
			p._soft(c, ceil, Color(p.pal("ground").darkened(0.25), 0.8))
			x = -span
			while x < span:
				var h: float = p._rng.randf_range(40.0, 110.0)
				p._soft(c, PackedVector2Array([Vector2(x - 18.0, 40.0), Vector2(x + 18.0, 40.0), Vector2(x + 6.0, 40.0 + h), Vector2(x - 6.0, 40.0 + h)]), Color(p.pal("ground").darkened(0.2), 0.7))
				c.draw_circle(Vector2(x, 40.0 + h), 7.0, Color(p.pal("ground").darkened(0.2), 0.7))
				x += p._rng.randf_range(90.0, 180.0)
			# เสาคริสตัลเรืองแสงไกลๆ
			x = -span
			while x < span:
				var ch: float = p._rng.randf_range(90.0, 180.0)
				var col: Color = p.pal("accent")
				p._soft(c, PackedVector2Array([Vector2(x - 24.0, low), Vector2(x - 14.0, low - ch), Vector2(x + 14.0, low - ch), Vector2(x + 24.0, low)]), Color(col, 0.35))
				c.draw_circle(Vector2(x, low - ch), 14.0, Color(col, 0.35))
				x += p._rng.randf_range(160.0, 320.0)
		"sky":
			# เกาะลอยไกลๆ ใต้เป็นก้อนหินมน มีต้นไม้กลม
			for i in 7:
				var ix: float = p._rng.randf_range(-span, span)
				var iy: float = p._rng.randf_range(low * 0.35, low * 0.8)
				var w: float = p._rng.randf_range(80.0, 160.0)
				p._soft(c, Sketch.oval(Vector2(ix, iy), w, 16.0, 20), Color(0.6, 0.82, 0.55, 0.6))
				p._soft(c, PackedVector2Array([Vector2(ix - w, iy), Vector2(ix + w, iy), Vector2(ix + w * 0.3, iy + w * 0.7), Vector2(ix - w * 0.3, iy + w * 0.7)]), Color(0.75, 0.68, 0.6, 0.5))
				SoftPaint.oval(c, Vector2(ix + w * 0.3, iy - 26.0), 18.0, 22.0, Color(0.45, 0.7, 0.45, 0.6), 0.4)
		_:
			for layer in 2:
				_hills(c, p, span, low, 90.0 - float(layer) * 40.0, 170.0 - float(layer) * 40.0, [Color(0.72, 0.76, 0.9, 0.5), Color(0.68, 0.76, 0.8, 0.55)][layer])

static func _hills(c: Node2D, p, span: float, low: float, lo: float, hi: float, col: Color) -> void:
	var pts := PackedVector2Array([Vector2(-span, low)])
	var x := -span
	while x <= span:
		pts.append(Vector2(x, low - p._rng.randf_range(lo, hi)))
		x += p._rng.randf_range(120.0, 220.0)
	pts.append(Vector2(span, low))
	p._soft(c, pts, col)

static func _ears_soft(c: CanvasItem, p, cx: float, top: float, gap: float, size: float, col: Color) -> void:
	for side in [-1.0, 1.0]:
		var bx: float = cx + side * gap
		p._soft(c, PackedVector2Array([Vector2(bx - size * 0.6, top + 4.0), Vector2(bx - side * size * 0.1, top - size), Vector2(bx + size * 0.6, top + 4.0)]), col)

# ---------------------------------------------------------------- ฉากกลาง (เงาอาคารใหญ่ ต้นไม้)
static func mid(c: Node2D, p) -> void:
	var span: float = p._span(TownPage.PAR_MID)
	var low: float = p._ground_y() - 40.0
	var x := -span
	var n := 0
	var col: Color = Color(p.pal("wall").darkened(0.08), 0.55)
	while x < span:
		match p.style:
			"snow":
				# ต้นสนหิมะยอดมนเป็นก้อนกลมซ้อน
				for k in 3:
					SoftPaint.oval(c, Vector2(x, low - 30.0 - float(k) * 34.0), 46.0 - float(k) * 12.0, 24.0, Color(0.55, 0.72, 0.65, 0.5), 0.3)
					SoftPaint.oval(c, Vector2(x, low - 44.0 - float(k) * 34.0), 34.0 - float(k) * 10.0, 10.0, Color(1.0, 1.0, 1.0, 0.7), 0.3)
			"desert":
				# กระบองเพชรกลมๆ ไม่มีหนาม
				SoftPaint.oval(c, Vector2(x, low - 60.0), 22.0, 60.0, Color(0.5, 0.72, 0.5, 0.5), 0.2)
				SoftPaint.oval(c, Vector2(x + 28.0, low - 70.0), 12.0, 26.0, Color(0.5, 0.72, 0.5, 0.5), 0.2)
			"underground":
				var h: float = p._rng.randf_range(60.0, 130.0)
				p._soft(c, PackedVector2Array([Vector2(x - 30.0, low + 40.0), Vector2(x - 8.0, low + 40.0 - h), Vector2(x + 8.0, low + 40.0 - h), Vector2(x + 30.0, low + 40.0)]), Color(p.pal("ground").darkened(0.1), 0.6))
				c.draw_circle(Vector2(x, low + 40.0 - h), 9.0, Color(p.pal("ground").darkened(0.1), 0.6))
			"sky":
				SoftPaint.oval(c, Vector2(x, low + 60.0), 120.0, 30.0, Color(1.0, 1.0, 1.0, 0.75), 0.5)
				SoftPaint.oval(c, Vector2(x + 60.0, low + 40.0), 70.0, 26.0, Color(1.0, 1.0, 1.0, 0.75), 0.5)
			"lava":
				SoftPaint.oval(c, Vector2(x, low + 20.0), 70.0, 16.0, Color(1.0, 0.55, 0.3, 0.35), 0.6)
			"floors":
				# เสาปราสาทกับหน้าต่างโค้ง
				c.draw_rect(Rect2(x - 26.0, low - 220.0, 52.0, 260.0), col)
				SoftPaint.oval(c, Vector2(x + 120.0, low - 120.0), 34.0, 54.0, Color(0.8, 0.9, 1.0, 0.5), 0.2)
			_:
				var h2: float = p._rng.randf_range(120.0, 200.0)
				p._soft(c, PackedVector2Array([Vector2(x - 40.0, low + 40.0), Vector2(x - 40.0, low - h2), Vector2(x + 40.0, low - h2), Vector2(x + 40.0, low + 40.0)]), col)
				p._soft(c, Sketch.oval(Vector2(x, low - h2), 46.0, 30.0, 16), Color(p.pal("roof"), 0.5))
		x += p._rng.randf_range(260.0, 420.0)
		n += 1

# ---------------------------------------------------------------- พื้นที่ตัวละครเดิน
static func ground(c: Node2D, p) -> void:
	var g: float = p._ground_y()
	var span: float = p._span(1.0)
	var walk: float = g - 74.0
	var front: float = g + 46.0
	var col: Color = p.pal("ground")
	match p.style:
		"sky":
			# ทางเดินเป็นเกาะลอยต่อกันด้วยเมฆ ใต้เกาะเป็นหินมน
			var x := -span
			while x < span:
				var w: float = p._rng.randf_range(420.0, 700.0)
				c.draw_rect(Rect2(x, walk, w, front - walk), col)
				p._cut(c, PackedVector2Array([Vector2(x, front), Vector2(x + w, front), Vector2(x + w * 0.7, front + 120.0), Vector2(x + w * 0.3, front + 120.0)]), Color(0.78, 0.7, 0.62), 0)
				for k in 4:
					SoftPaint.oval(c, Vector2(x + w + 40.0 + float(k) * 26.0, front - 10.0 + sin(float(k)) * 8.0), 40.0, 26.0, Color(1.0, 1.0, 1.0, 0.95), 0.3)
				x += w + 140.0
		"harbor":
			# ท่าเรือไม้ ใต้เป็นน้ำ
			c.draw_rect(Rect2(-span, walk, span * 2.0, front - walk), col)
			var x2 := -span
			while x2 < span:
				c.draw_line(Vector2(x2, walk), Vector2(x2, front), Color(col.darkened(0.2), 0.6), 2.0, true)
				x2 += 60.0
			c.draw_rect(Rect2(-span, front, span * 2.0, p._view.y), Color(0.5, 0.75, 0.9))
			x2 = -span
			while x2 < span:
				c.draw_rect(Rect2(x2, front, 14.0, 80.0), Color(0.6, 0.45, 0.32))
				x2 += 180.0
		_:
			c.draw_rect(Rect2(-span, walk, span * 2.0, front - walk + 200.0), col)
			# แผ่นหินมนบนพื้น
			for row in 3:
				var y: float = g - 10.0 + float(row) * 20.0
				var x3: float = -span + float(row % 2) * 16.0
				while x3 < span:
					var w3: float = p._rng.randf_range(24.0, 34.0)
					UiStyle.fill(c, Rect2(x3, y, w3, 12.0), Color(col.darkened(0.08), 0.6), 6.0)
					x3 += w3 + 8.0
			if p.style == "lava":
				var x4 := -span
				while x4 < span:
					SoftPaint.oval(c, Vector2(x4, front + 30.0), 60.0, 12.0, Color(1.0, 0.5, 0.25, 0.5), 0.5)
					x4 += p._rng.randf_range(260.0, 400.0)
			if p.style == "snow":
				var x5 := -span
				while x5 < span:
					SoftPaint.oval(c, Vector2(x5, walk + 4.0), 50.0, 10.0, Color(1.0, 1.0, 1.0, 0.85), 0.4)
					x5 += p._rng.randf_range(120.0, 200.0)
	PaperFront.lip(c, -span, span, walk + 6.0, col, 77)
	# รอยเท้าแมวจางๆ
	var px := -span
	while px < span:
		PaperFront.paw(c, Vector2(px, g + 8.0), 9.0, Color(col.darkened(0.3), 0.18))
		px += p._rng.randf_range(160.0, 260.0)

# ---------------------------------------------------------------- แถวบ้าน
static func row(c: Node2D, p) -> void:
	var base: float = p._ground_y() - 74.0
	var span: float = p.town_half * CombatData.UNIT * WalkPage.ZOOM + 300.0
	var x := -span
	var n := 0
	var fl: Dictionary = p.floor_data()
	var deco := str(fl.get("deco", "houses"))
	while x < span:
		var w: float
		if p.style == "floors" or deco in ["hall", "library", "kitchen", "cellar", "throne", "garden", "roof"]:
			w = _interior(c, p, x, base, n, deco)
		else:
			w = house(c, p, x, base, n)
		x += w + p._rng.randf_range(60.0, 120.0)
		n += 1

## บ้านตามสไตล์เมือง ทุกหลังมีหน้าแมว (หน้าต่างกลมเป็นตา) หรือหูแมวบนหลังคา คืนความกว้าง
static func house(c: Node2D, p, x: float, base: float, n: int) -> float:
	var wall: Color = p.pal("wall")
	var roof: Color = p.pal("roof")
	var acc: Color = p.pal("accent")
	if n % 2 == 1:
		wall = wall.lerp(Color(1.0, 1.0, 1.0), 0.25)
		roof = roof.lerp(acc, 0.4)
	var w: float = p._rng.randf_range(150.0, 220.0)
	var h: float = p._rng.randf_range(110.0, 170.0)
	var cx := x + w * 0.5
	match p.style:
		"snow":
			# อิกลูโดมหิมะ ประตูโค้ง
			p._cut(c, _arc(cx, base, w * 0.5, h * 0.8), Color(0.95, 0.97, 1.0), 0)
			p._cut(c, _arc(cx, base, 32.0, 56.0), Color(0.6, 0.72, 0.85), 0)
			_ears_soft(c, p, cx, base - h * 0.8 + 8.0, w * 0.22, 24.0, Color(0.95, 0.97, 1.0))
		"desert":
			p._cut(c, PackedVector2Array([Vector2(x, base), Vector2(x, base - h * 0.6), Vector2(x + w, base - h * 0.6), Vector2(x + w, base)]), wall, 0)
			p._cut(c, _arc(cx, base - h * 0.6, w * 0.4, h * 0.45), roof, 0)
			_eyes(c, cx, base - h * 0.4, w * 0.18)
		"underground":
			# บ้านเห็ดใต้ดิน หมวกเห็ดจุดกลม
			p._cut(c, PackedVector2Array([Vector2(cx - w * 0.25, base), Vector2(cx - w * 0.22, base - h * 0.6), Vector2(cx + w * 0.22, base - h * 0.6), Vector2(cx + w * 0.25, base)]), Color(0.96, 0.92, 0.84), 0)
			p._cut(c, _arc(cx, base - h * 0.55, w * 0.55, h * 0.55), roof, 0)
			for k in 4:
				c.draw_circle(Vector2(cx - w * 0.3 + float(k) * w * 0.2, base - h * 0.75 - float(k % 2) * 16.0), 9.0, Color(1.0, 1.0, 1.0, 0.85))
			_eyes(c, cx, base - h * 0.3, w * 0.1)
		"sky":
			# บ้านบนเมฆ ฐานเป็นก้อนเมฆ
			for k in 5:
				SoftPaint.oval(c, Vector2(x + float(k) * w * 0.25, base + 6.0), 40.0, 22.0, Color(1.0, 1.0, 1.0, 0.95), 0.3)
			p._cut(c, PackedVector2Array([Vector2(x + 20.0, base), Vector2(x + 20.0, base - h * 0.7), Vector2(x + w - 20.0, base - h * 0.7), Vector2(x + w - 20.0, base)]), wall, 0)
			p._cut(c, _arc(cx, base - h * 0.7, w * 0.5, h * 0.4), roof, 0)
			_ears_soft(c, p, cx, base - h * 1.08, w * 0.24, 26.0, roof)
			_eyes(c, cx, base - h * 0.45, w * 0.16)
		"harbor":
			# บ้านริมท่า ผนังไม้ลายตั้ง หลังคาโค้ง ป้ายปลา
			p._cut(c, PackedVector2Array([Vector2(x, base), Vector2(x, base - h * 0.7), Vector2(x + w, base - h * 0.7), Vector2(x + w, base)]), wall, 0)
			var lx := x + 12.0
			while lx < x + w:
				c.draw_line(Vector2(lx, base - h * 0.7), Vector2(lx, base), Color(wall.darkened(0.15), 0.6), 2.0, true)
				lx += 22.0
			p._cut(c, _arc(cx, base - h * 0.7, w * 0.55, h * 0.35), roof, 0)
			if n % 3 == 0:
				PaperFront.fish_sign(c, Vector2(cx, base - h * 1.1), 34.0, acc)
			_eyes(c, cx, base - h * 0.45, w * 0.16)
		"lava":
			p._cut(c, PackedVector2Array([Vector2(x, base), Vector2(x + 10.0, base - h * 0.65), Vector2(x + w - 10.0, base - h * 0.65), Vector2(x + w, base)]), wall, 0)
			p._cut(c, _arc(cx, base - h * 0.65, w * 0.5, h * 0.35), roof, 0)
			SoftPaint.oval(c, Vector2(cx, base - h * 0.35), 18.0, 18.0, Color(1.0, 0.65, 0.3, 0.8), 0.5)
		_:
			p._cut(c, PackedVector2Array([Vector2(x, base), Vector2(x, base - h * 0.65), Vector2(x + w, base - h * 0.65), Vector2(x + w, base)]), wall, 0)
			p._cut(c, _arc(cx, base - h * 0.62, w * 0.55, h * 0.45), roof, 0)
			_ears_soft(c, p, cx, base - h * 1.04, w * 0.26, 28.0, roof)
			_eyes(c, cx, base - h * 0.42, w * 0.16)
	# ประตูโค้ง
	if p.style != "snow":
		p._cut(c, _arc(cx, base, 20.0, 46.0), Color(0.62, 0.45, 0.32), 0)
	return w

## ฉากในปราสาท/อาคารหลายชั้น ตาม deco ของชั้น
static func _interior(c: Node2D, p, x: float, base: float, n: int, deco: String) -> float:
	var wall: Color = p.pal("wall")
	var acc: Color = p.pal("accent")
	var w := 200.0
	match deco:
		"library":
			UiStyle.fill(c, Rect2(x, base - 200.0, w, 200.0), wall.darkened(0.2), 14.0)
			for r in 4:
				for k in 7:
					var bh: float = p._rng.randf_range(28.0, 40.0)
					UiStyle.fill(c, Rect2(x + 12.0 + float(k) * 26.0, base - 50.0 - float(r) * 48.0 + (40.0 - bh), 20.0, bh), [acc, p.pal("roof"), Color(0.6, 0.75, 0.9)][(k + r) % 3], 4.0)
		"kitchen":
			UiStyle.fill(c, Rect2(x, base - 90.0, w, 90.0), wall.darkened(0.1), 12.0)
			c.draw_circle(Vector2(x + 60.0, base - 110.0), 30.0, Color(0.5, 0.5, 0.55))
			SoftPaint.oval(c, Vector2(x + 60.0, base - 150.0), 20.0, 30.0, Color(1.0, 1.0, 1.0, 0.5), 0.5)
			PaperFront.fish_sign(c, Vector2(x + 150.0, base - 150.0), 30.0, acc)
		"garden":
			for k in 3:
				SoftPaint.oval(c, Vector2(x + 40.0 + float(k) * 60.0, base - 40.0), 34.0, 40.0, Color(0.5, 0.75, 0.5, 0.9), 0.3)
				c.draw_circle(Vector2(x + 40.0 + float(k) * 60.0, base - 60.0), 7.0, acc)
		"throne":
			UiStyle.fill(c, Rect2(x + 60.0, base - 150.0, 80.0, 150.0), acc, 30.0)
			UiStyle.fill(c, Rect2(x + 70.0, base - 70.0, 60.0, 70.0), Color(1.0, 0.82, 0.3), 12.0)
			_ears_soft(c, p, x + 100.0, base - 150.0, 26.0, 26.0, acc)
		"cellar":
			for k in 3:
				c.draw_circle(Vector2(x + 40.0 + float(k) * 60.0, base - 36.0), 34.0, Color(0.62, 0.45, 0.32))
				c.draw_arc(Vector2(x + 40.0 + float(k) * 60.0, base - 36.0), 34.0, 0.0, TAU, 24, INK, 2.0, true)
		"roof":
			SoftPaint.oval(c, Vector2(x + 100.0, base - 30.0), 90.0, 20.0, Color(1.0, 1.0, 1.0, 0.7), 0.4)
			UiStyle.fill(c, Rect2(x, base - 30.0, w, 30.0), wall.darkened(0.15), 10.0)
		_:
			# ห้องโถง เสา ธงหัวแมว หน้าต่างโค้ง
			UiStyle.fill(c, Rect2(x + 10.0, base - 220.0, 40.0, 220.0), wall.darkened(0.12), 16.0)
			UiStyle.fill(c, Rect2(x + 80.0, base - 170.0, 70.0, 100.0), Color(0.8, 0.9, 1.0), 34.0)
			UiStyle.fill(c, Rect2(x + 160.0, base - 200.0, 34.0, 90.0), acc, 10.0)
			c.draw_circle(Vector2(x + 177.0, base - 150.0), 10.0, Color(1.0, 0.95, 0.85))
	return w

static func _arc(cx: float, base: float, rx: float, ry: float, n := 20) -> PackedVector2Array:
	var pts := PackedVector2Array([Vector2(cx - rx, base)])
	for i in n + 1:
		var a := PI + PI * float(i) / float(n)
		pts.append(Vector2(cx + cos(a) * rx, base + sin(a) * ry))
	pts.append(Vector2(cx + rx, base))
	return pts

## หน้าต่างกลมสองบานเป็นตาแมว มีจมูกเล็ก
static func _eyes(c: CanvasItem, cx: float, y: float, gap: float) -> void:
	for side in [-1.0, 1.0]:
		c.draw_circle(Vector2(cx + side * gap, y), 13.0, Color(1.0, 0.92, 0.6))
		c.draw_arc(Vector2(cx + side * gap, y), 13.0, 0.0, TAU, 18, INK, 2.0, true)
	c.draw_circle(Vector2(cx, y + 14.0), 4.0, Color(1.0, 0.6, 0.65))

# ---------------------------------------------------------------- ชั้นหน้า ใกล้กล้อง
static func front(c: Node2D, p) -> void:
	var span: float = p._span(TownPage.PAR_FRONT)
	var y: float = p._view.y - 30.0
	var x := -span
	while x < span:
		match p.style:
			"harbor":
				SoftPaint.oval(c, Vector2(x, y), 90.0, 18.0, Color(0.45, 0.7, 0.88, 0.8), 0.4)
				PaperFront.fish_sign(c, Vector2(x + 60.0, y - 30.0), 24.0, Color(0.6, 0.8, 0.95))
			"snow":
				SoftPaint.oval(c, Vector2(x, y), 120.0, 40.0, Color(1.0, 1.0, 1.0, 0.95), 0.3)
			"desert":
				SoftPaint.oval(c, Vector2(x, y + 10.0), 140.0, 40.0, Color(0.98, 0.85, 0.6, 0.95), 0.3)
				SoftPaint.oval(c, Vector2(x + 40.0, y - 40.0), 16.0, 40.0, Color(0.5, 0.72, 0.5), 0.2)
			"lava":
				SoftPaint.oval(c, Vector2(x, y), 110.0, 30.0, Color(0.42, 0.34, 0.36, 0.95), 0.3)
				SoftPaint.oval(c, Vector2(x + 30.0, y + 10.0), 40.0, 10.0, Color(1.0, 0.55, 0.25, 0.8), 0.4)
			"underground":
				var col: Color = p.pal("accent")
				p._soft(c, PackedVector2Array([Vector2(x - 30.0, y + 30.0), Vector2(x - 10.0, y - 60.0), Vector2(x + 10.0, y - 60.0), Vector2(x + 30.0, y + 30.0)]), Color(col, 0.75))
				c.draw_circle(Vector2(x, y - 60.0), 10.0, Color(col, 0.75))
			"sky":
				SoftPaint.oval(c, Vector2(x, y + 20.0), 160.0, 50.0, Color(1.0, 1.0, 1.0, 0.95), 0.4)
			"floors":
				UiStyle.fill(c, Rect2(x - 20.0, y - 80.0, 40.0, 120.0), Color(p.pal("wall").darkened(0.2), 0.9), 16.0)
			_:
				PaperFront.yarn(c, Vector2(x, y), 22.0, Color(1.0, 0.66, 0.72))
		x += p._rng.randf_range(300.0, 520.0)

# ---------------------------------------------------------------- ของในเมืองที่กดใช้ได้ (วาดในพิกัด world พื้นอยู่ y = 0)
static func prop(c: CanvasItem, kind: String, at: Vector2, label := "", accent := Color(0.9, 0.45, 0.5), up := true) -> void:
	match kind:
		"board":
			# กระดานเควสไม้ หัวแมวบนป้าย กระดาษโน้ตติดหมุด
			UiStyle.fill(c, Rect2(at + Vector2(-60.0, -40.0), Vector2(14.0, 40.0)), Color(0.55, 0.4, 0.28), 5.0)
			UiStyle.fill(c, Rect2(at + Vector2(46.0, -40.0), Vector2(14.0, 40.0)), Color(0.55, 0.4, 0.28), 5.0)
			UiStyle.box(c, Rect2(at + Vector2(-80.0, -170.0), Vector2(160.0, 134.0)), 931, 3.0, INK, Color(0.82, 0.64, 0.45))
			for k in 4:
				var nr := Rect2(at + Vector2(-66.0 + float(k % 2) * 70.0, -158.0 + floorf(float(k) / 2.0) * 60.0), Vector2(56.0, 48.0))
				UiStyle.fill(c, nr, [Color(1.0, 0.98, 0.9), Color(1.0, 0.92, 0.85), Color(0.92, 0.96, 1.0), Color(1.0, 0.95, 0.8)][k], 6.0)
				c.draw_circle(nr.position + Vector2(nr.size.x * 0.5, 6.0), 4.0, accent)
			for side in [-1.0, 1.0]:
				c.draw_colored_polygon(PackedVector2Array([at + Vector2(side * 50.0 - 16.0, -168.0), at + Vector2(side * 52.0, -196.0), at + Vector2(side * 50.0 + 16.0, -168.0)]), Color(0.82, 0.64, 0.45))
		"mailbox":
			# ตู้จดหมายหัวแมว
			UiStyle.fill(c, Rect2(at + Vector2(-8.0, -80.0), Vector2(16.0, 80.0)), Color(0.55, 0.4, 0.28), 6.0)
			UiStyle.box(c, Rect2(at + Vector2(-46.0, -150.0), Vector2(92.0, 76.0)), 932, 3.0, INK, accent)
			UiStyle.fill(c, Rect2(at + Vector2(-28.0, -128.0), Vector2(56.0, 10.0)), Color(0.3, 0.25, 0.25), 5.0)
			for side in [-1.0, 1.0]:
				c.draw_colored_polygon(PackedVector2Array([at + Vector2(side * 34.0 - 12.0, -148.0), at + Vector2(side * 36.0, -170.0), at + Vector2(side * 34.0 + 12.0, -148.0)]), accent)
			c.draw_circle(at + Vector2(58.0, -132.0), 7.0, Color(0.9, 0.3, 0.3))
			c.draw_line(at + Vector2(52.0, -96.0), at + Vector2(58.0, -132.0), INK, 3.0, true)
		"gate":
			# ประตูดันเจี้ยน ซุ้มโค้งหัวแมว
			UiStyle.box(c, Rect2(at + Vector2(-90.0, -230.0), Vector2(180.0, 230.0)), 933, 4.0, INK, Color(0.75, 0.68, 0.62))
			UiStyle.fill(c, Rect2(at + Vector2(-55.0, -170.0), Vector2(110.0, 170.0)), Color(0.32, 0.26, 0.34), 50.0)
			for side in [-1.0, 1.0]:
				c.draw_colored_polygon(PackedVector2Array([at + Vector2(side * 60.0 - 24.0, -226.0), at + Vector2(side * 66.0, -268.0), at + Vector2(side * 60.0 + 24.0, -226.0)]), Color(0.75, 0.68, 0.62))
		"door", "ladder", "pipe", "pad", "cloud":
			_warp(c, kind, at, accent, up)
	if label != "":
		var font := Sketch.font()
		var w := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 38).x
		var r := Rect2(at + Vector2(-w * 0.5 - 18.0, 14.0), Vector2(w + 36.0, 56.0))
		UiStyle.fill(c, r, Color(1.0, 0.99, 0.96, 0.9), 20.0)
		c.draw_string(font, r.position + Vector2(18.0, 41.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 38, INK)

static func _warp(c: CanvasItem, kind: String, at: Vector2, accent: Color, up: bool) -> void:
	match kind:
		"door":
			UiStyle.box(c, Rect2(at + Vector2(-50.0, -170.0), Vector2(100.0, 170.0)), 941, 3.0, INK, Color(0.65, 0.48, 0.34))
			c.draw_circle(at + Vector2(30.0, -80.0), 6.0, Color(1.0, 0.82, 0.3))
		"ladder":
			for side in [-1.0, 1.0]:
				UiStyle.fill(c, Rect2(at + Vector2(side * 30.0 - 6.0, -260.0), Vector2(12.0, 260.0)), Color(0.62, 0.45, 0.3), 6.0)
			for k in 7:
				UiStyle.fill(c, Rect2(at + Vector2(-30.0, -30.0 - float(k) * 34.0), Vector2(60.0, 8.0)), Color(0.62, 0.45, 0.3), 4.0)
		"pipe":
			UiStyle.box(c, Rect2(at + Vector2(-46.0, -200.0), Vector2(92.0, 200.0)), 942, 3.0, INK, Color(0.6, 0.75, 0.85))
			UiStyle.fill(c, Rect2(at + Vector2(-56.0, -214.0), Vector2(112.0, 24.0)), Color(0.5, 0.65, 0.78), 12.0)
		"pad":
			SoftPaint.oval(c, at + Vector2(0.0, -6.0), 70.0, 18.0, Color(accent, 0.5), 0.5)
			c.draw_arc(at + Vector2(0.0, -6.0), 50.0, 0.0, TAU, 32, Color(accent.lightened(0.3), 0.9), 4.0, true)
		"cloud":
			for k in 4:
				SoftPaint.oval(c, at + Vector2(-48.0 + float(k) * 32.0, -10.0 - float(k % 2) * 10.0), 40.0, 24.0, Color(1.0, 1.0, 1.0, 0.95), 0.3)
	# ลูกศรบอกขึ้นหรือลง ทรงมน
	var tip := at + Vector2(0.0, -300.0 if kind == "ladder" else -230.0)
	var d := -1.0 if up else 1.0
	SoftDraw.poly(c, PackedVector2Array([tip + Vector2(-20.0, -d * 10.0), tip + Vector2(20.0, -d * 10.0), tip + Vector2(0.0, d * 18.0)]), Color(accent, 0.95))

# ---------------------------------------------------------------- เมืองดาวดวงเล็ก พื้นโค้ง
## วาดในพิกัดของโหนดดาว จุดศูนย์กลางดาวอยู่ที่ (0,0) รัศมี r (จุดภาพบนจอ)  dx_to_angle แปลงระยะแนวนอนเป็นมุม
static func planet(c: Node2D, p, r: float) -> void:
	var col: Color = p.pal("ground")
	# ดาวเป็นวงกลม ขอบนอกคือแนวบ้าน (r + 74) ถนนที่ตัวละครเดินอยู่ที่ r
	var pts := Sketch.oval(Vector2.ZERO, r + 80.0, r + 80.0, 200)
	c.draw_colored_polygon(pts, col.lightened(0.08))
	pts.append(pts[0])
	c.draw_polyline(pts, Color(INK, 0.55), 2.5, true)
	c.draw_colored_polygon(Sketch.oval(Vector2.ZERO, r + 30.0, r + 30.0, 200), col)
	c.draw_colored_polygon(Sketch.oval(Vector2.ZERO, r - 50.0, r - 50.0, 200), col.darkened(0.08))
	# บ้านรอบดาว ตั้งฉากกับผิวดาว
	var half_px: float = p.town_half * CombatData.UNIT * WalkPage.ZOOM
	var x := -half_px - 200.0
	var n := 0
	var saved: int = p._rng.seed
	while x < half_px + 200.0:
		var a := x / r
		c.draw_set_transform(Vector2(sin(a), -cos(a)) * (r + 74.0), a, Vector2.ONE)
		var w := house(c, p, -90.0, 0.0, n)
		c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		x += w + p._rng.randf_range(80.0, 150.0)
		n += 1
		if n % 3 == 0:
			var ta := (x + 40.0) / r
			c.draw_set_transform(Vector2(sin(ta), -cos(ta)) * (r + 74.0), ta, Vector2.ONE)
			SoftPaint.oval(c, Vector2(0.0, -70.0), 36.0, 46.0, Color(0.5, 0.75, 0.5, 0.95), 0.3)
			UiStyle.fill(c, Rect2(-6.0, -30.0, 12.0, 30.0), Color(0.55, 0.4, 0.28), 6.0)
			c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			x += 80.0
	p._rng.seed = saved

# ---------------------------------------------------------------- ภูมิประเทศ (เนิน ทางลาด บันได สะพาน ทางโค้งหักเข้าไปไกล)
## วาดในพิกัดจุดภาพบนจอ (โหนดถูกย่อกลับ 1/ZOOM ในโลก) x หน่วยเกม คูณ S  ความสูง h คูณ -S
const BAND_BACK := 74.0           # ขอบหลังของทางเดิน (บ้านตั้งตรงนี้)
const BAND_FRONT := 46.0          # ขอบหน้าของทางเดิน ถัดลงไปเป็นหน้าผา/ผนังดิน

static func _s() -> float:
	return CombatData.UNIT * WalkPage.ZOOM

## น้ำหนักทางโค้ง 0 ถึง 1 นูนกลางช่วง bends
static func bend_w(p, x: float) -> float:
	var w := 0.0
	for b in p.terrain_data().get("bends", []):
		var bx0 := float(b[0])
		var bx1 := float(b[1])
		if x > bx0 - 3.0 and x < bx1 + 3.0:
			var mid := (bx0 + bx1) * 0.5
			var hw := (bx1 - bx0) * 0.5 + 3.0
			w = maxf(w, 0.5 + 0.5 * cos(clampf((x - mid) / hw, -1.0, 1.0) * PI))
	return w

static func on_bridge(p, x: float) -> Array:
	for b in p.terrain_data().get("bridges", []):
		if x >= float(b[0]) and x <= float(b[1]):
			return b
	return []

static func _on_stairs(p, x: float) -> bool:
	for st in p.terrain_data().get("stairs", []):
		if x >= float(st[0]) and x <= float(st[1]):
			return true
	return false

static func terrain(c: Node2D, p) -> void:
	var s := _s()
	var td: Dictionary = p.terrain_data()
	var half: float = p.town_half
	var col: Color = p.pal("ground")
	var face := col.darkened(0.22)
	var below := str(td.get("below", "rock"))
	var x0 := -half - 14.0
	var x1 := half + 14.0
	var step := 0.5
	# ---- หุบเขา: หน้าผาสูงสองข้างด้านหลัง ----
	if td.get("valley", false):
		var rock := col.lerp(Color(0.75, 0.72, 0.8), 0.5)
		for side in [-1.0, 1.0]:
			var ex: float = side * half * s
			var top: float = -float(p.ground_h(side * half)) * s - 900.0
			var pts := PackedVector2Array([Vector2(ex + side * 900.0, 400.0), Vector2(ex + side * 900.0, top - 600.0), Vector2(ex - side * 120.0, top - 300.0), Vector2(ex - side * 380.0, top + 200.0), Vector2(ex - side * 300.0, 400.0)])
			SoftPaint.shape(c, pts, Color(rock, 0.55), 0.06)
	# ---- ขั้นด้านหลัง (เห็นเป็นชั้นซ้อนสูงต่ำ) ----
	for layer in [[260.0, 0.22], [150.0, 0.38]]:
		var up: float = layer[0]
		var a: float = layer[1]
		var back := PackedVector2Array()
		var x := x0
		while x <= x1:
			back.append(Vector2(x * s, -float(p.ground_h(x)) * s - up - bend_w(p, x) * 60.0))
			x += step * 2.0
		var poly := back.duplicate()
		poly.append(Vector2(x1 * s, 800.0))
		poly.append(Vector2(x0 * s, 800.0))
		SoftPaint.shape(c, poly, Color(col.lerp(Color(1.0, 1.0, 1.0), 0.45), a), 0.05)
	# ---- ใต้สะพาน ----
	for b in td.get("bridges", []):
		var bx0 := float(b[0]) * s
		var bx1 := float(b[1]) * s
		var yb := -float(p.ground_h((float(b[0]) + float(b[1])) * 0.5)) * s
		match below:
			"water":
				c.draw_rect(Rect2(bx0, yb + 40.0, bx1 - bx0, 900.0), Color(0.55, 0.78, 0.92))
				for k in 6:
					var wy := yb + 80.0 + float(k) * 50.0
					c.draw_line(Vector2(bx0 + 20.0, wy), Vector2(bx1 - 20.0, wy), Color(1.0, 1.0, 1.0, 0.5), 3.0, true)
			"lava":
				c.draw_rect(Rect2(bx0, yb + 60.0, bx1 - bx0, 900.0), Color(1.0, 0.55, 0.3, 0.85))
				SoftPaint.oval(c, Vector2((bx0 + bx1) * 0.5, yb + 90.0), (bx1 - bx0) * 0.5, 40.0, Color(1.0, 0.85, 0.4, 0.7), 0.5)
			"void":
				for k in 5:
					SoftPaint.oval(c, Vector2(lerpf(bx0, bx1, float(k) / 4.0), yb + 260.0 + float(k % 2) * 40.0), 90.0, 40.0, Color(1.0, 1.0, 1.0, 0.85), 0.4)
	# ---- บ้านตามแนวทางเดิน ----
	_buildings(c, p, s)
	# ---- ตัวทางเดินกับหน้าผา แบ่งเป็นช่วงที่ไม่ใช่สะพาน ----
	var runs := []
	var cur := []
	var xx := x0
	while xx <= x1 + 0.001:
		if on_bridge(p, xx).is_empty():
			cur.append(xx)
		elif not cur.is_empty():
			runs.append(cur)
			cur = []
		xx += step
	if not cur.is_empty():
		runs.append(cur)
	for run in runs:
		var backs := PackedVector2Array()
		var fronts := PackedVector2Array()
		for x in run:
			var y: float = -float(p.ground_h(x)) * s
			var bw := bend_w(p, x)
			backs.append(Vector2(x * s, y - BAND_BACK - bw * 60.0))
			fronts.append(Vector2(x * s, y + BAND_FRONT - bw * 10.0))
		if p.style == "sky":
			# เกาะลอย ใต้เป็นหินมนสั้นๆ ปลายเรียว มีเมฆรองใต้เกาะ
			var under := PackedVector2Array()
			var nf := fronts.size()
			for i in nf:
				var k := float(i) / float(maxi(nf - 1, 1))
				under.append(fronts[i] + Vector2(0.0, 40.0 + sin(k * PI) * 150.0))
			under.reverse()
			var isl := fronts.duplicate()
			isl.append_array(under)
			SoftPaint.shape(c, isl, Color(0.8, 0.76, 0.88), 0.05)
			for i in range(0, nf, 5):
				SoftPaint.oval(c, fronts[i] + Vector2(0.0, 30.0 + sin(float(i) / float(maxi(nf - 1, 1)) * PI) * 140.0), 50.0, 24.0, Color(1.0, 1.0, 1.0, 0.85), 0.35)
		else:
			var cliff := fronts.duplicate()
			cliff.append(Vector2(fronts[fronts.size() - 1].x, 900.0))
			cliff.append(Vector2(fronts[0].x, 900.0))
			c.draw_colored_polygon(cliff, face)
			for i in range(0, fronts.size(), 6):
				SoftPaint.oval(c, fronts[i] + Vector2(0.0, 70.0 + float(i % 12) * 6.0), 26.0, 14.0, Color(face.darkened(0.12), 0.5), 0.4)
		var band := backs.duplicate()
		var rev := fronts.duplicate()
		rev.reverse()
		band.append_array(rev)
		c.draw_colored_polygon(band, col.darkened(0.1) if p.style == "sky" else col)
		# เส้นหมึกขอบหน้า (กระดาษตัด) กับขอบหลังจางๆ
		c.draw_polyline(fronts, Color(INK, 0.75), 3.0, true)
		c.draw_polyline(backs, Color(INK, 0.25), 2.0, true)
		# ทางโค้ง: เส้นจางๆ ชี้เข้าไปไกล
		for i in range(0, run.size(), 4):
			var bw2 := bend_w(p, float(run[i]))
			if bw2 > 0.2:
				c.draw_line(fronts[i], backs[i] + Vector2(0.0, 6.0), Color(col.darkened(0.15), 0.35 * bw2), 2.0, true)
		# บันได
		for i in run.size():
			var x2: float = run[i]
			if _on_stairs(p, x2) and int(round(x2 * 2.0)) % 2 == 0:
				var y2: float = -float(p.ground_h(x2)) * s
				c.draw_line(Vector2(x2 * s - 18.0, y2 - BAND_BACK + 8.0), Vector2(x2 * s - 18.0, y2 + BAND_FRONT - 4.0), Color(col.darkened(0.28), 0.7), 4.0, true)
				c.draw_line(Vector2(x2 * s - 18.0, y2 + BAND_FRONT - 4.0), Vector2(x2 * s + 18.0, y2 + BAND_FRONT - 4.0), Color(col.darkened(0.28), 0.5), 3.0, true)
		# รอยเท้าแมว
		for i in range(2, run.size(), 9):
			var x3: float = run[i]
			PaperFront.paw(c, Vector2(x3 * s, -float(p.ground_h(x3)) * s + 8.0), 9.0, Color(col.darkened(0.3), 0.18))
	# ---- สะพาน ----
	for b in td.get("bridges", []):
		_bridge(c, p, s, float(b[0]), float(b[1]), str(b[2]) if b.size() > 2 else "plank")

static func _bridge(c: Node2D, p, s: float, bx0: float, bx1: float, kind: String) -> void:
	var deck := PackedVector2Array()
	var under := PackedVector2Array()
	var x := bx0
	while x <= bx1 + 0.001:
		var y: float = -float(p.ground_h(x)) * s
		deck.append(Vector2(x * s, y - 14.0))
		under.append(Vector2(x * s, y + 18.0))
		x += 0.25
	if kind == "cloud":
		for i in range(0, deck.size(), 2):
			SoftPaint.oval(c, deck[i] + Vector2(0.0, 6.0), 46.0, 26.0, Color(1.0, 1.0, 1.0, 0.95), 0.3)
		return
	var wood := Color(0.72, 0.55, 0.4)
	if kind == "ice":
		wood = Color(0.8, 0.92, 1.0)
	elif kind == "stone":
		wood = Color(0.7, 0.66, 0.66)
	var poly := deck.duplicate()
	var rev := under.duplicate()
	rev.reverse()
	poly.append_array(rev)
	c.draw_colored_polygon(poly, wood)
	for i in range(0, deck.size(), 3):
		c.draw_line(deck[i], under[i], Color(wood.darkened(0.25), 0.6), 2.0, true)
	c.draw_polyline(under, Color(INK, 0.7), 3.0, true)
	if kind == "pier":
		for i in range(0, under.size(), 8):
			c.draw_rect(Rect2(under[i].x - 7.0, under[i].y, 14.0, 160.0), wood.darkened(0.2))
	else:
		var rail := PackedVector2Array()
		for i in deck.size():
			var k := float(i) / float(maxi(deck.size() - 1, 1))
			rail.append(deck[i] + Vector2(0.0, -70.0 + sin(k * PI) * 20.0))
		c.draw_polyline(rail, Color(wood.darkened(0.3), 0.8), 3.0, true)
		for i in range(0, deck.size(), 6):
			c.draw_line(deck[i], rail[i], Color(wood.darkened(0.3), 0.8), 3.0, true)

## บ้านเรียงตามทางเดิน ฐานบ้านอยู่ขอบหลังของทางเดิน ช่วงทางโค้งบ้านเล็กลงเหมือนอยู่ไกล
static func _buildings(c: Node2D, p, s: float) -> void:
	var half: float = p.town_half
	var tb = load("res://town_buildings.gd") if ResourceLoader.exists("res://town_buildings.gd") else null
	var kinds: Array = []
	if tb != null:
		kinds = tb.kinds(int(p.current_town))
	var x := -half - 6.0
	var n := 0
	while x < half + 6.0:
		var slope: float = absf(float(p.ground_h(x + 1.0)) - float(p.ground_h(x - 1.0))) * 0.5
		if slope > 0.18 or not on_bridge(p, x).is_empty() or not on_bridge(p, x + 2.0).is_empty():
			x += 1.5
			continue
		var bw := bend_w(p, x)
		var k := 1.0 - 0.38 * bw
		var base: float = -float(p.ground_h(x)) * s - BAND_BACK - bw * 60.0 + 2.0
		var cx := x * s
		c.draw_set_transform(Vector2(cx * (1.0 - k), base * (1.0 - k)), 0.0, Vector2(k, k))
		var w: float = 0.0
		if tb != null and not kinds.is_empty():
			var bwid: float = p._rng.randf_range(160.0, 240.0)
			var bh: float = p._rng.randf_range(130.0, 200.0)
			tb.draw(c, int(p.current_town), str(kinds[n % kinds.size()]), Vector2(cx, base), bwid, bh, n * 31 + 7)
			w = bwid
		else:
			w = house(c, p, cx - 90.0, base, n)
		c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		x += (w * k) / s + p._rng.randf_range(1.0, 2.2)
		n += 1
