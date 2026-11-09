class_name DungeonLookMore
## ฉากดันเจี้ยนชุดเพิ่ม (โทนนุ่มแบบหน้าโหลดแมวมั้ย) ใต้ดิน อุโมงค์ ถ้ำเห็ดเรือง ท่อระบายน้ำ หลังคายามเย็น เกาะเมฆ
## ป่าไผ่ ช่องเขาหิมะ ซากทะเลทราย โรงงานของเล่น หอนาฬิกา สะพานท่าเรือ ดินแดนขนม คฤหาสน์ผีน่ารัก
## ฉากมืดใช้น้ำเงินม่วงนุ่มๆ กับวงแสงโคมอุ่น ไม่ดำสนิท  ทุกรูปทรงมน ไม่มีดาวแฉก  เส้นขอบสีน้ำตาลเทาบาง
## ใช้โครงเดียวกับ DungeonLook.LOOKS (sky ceil sun clouds ground haze plat) far/mid/anim วาดในไฟล์นี้

const LOOKS := {
	"metro": {"sky": [Color(0.36, 0.38, 0.54), Color(0.52, 0.52, 0.64)], "ceil": Color(0.32, 0.34, 0.48), "sun": "none", "clouds": "none",
		"far": "metro_wall", "far_col": Color(0.62, 0.62, 0.72, 0.7), "mid": "hang_lamps", "mid_col": Color(1.0, 0.84, 0.6, 0.85),
		"ground": [Color(0.56, 0.55, 0.64), Color(0.46, 0.46, 0.56)], "haze": Color(1.0, 0.88, 0.72, 0.06), "plat": Color(0.66, 0.62, 0.7), "anim": "metro"},
	"cellar": {"sky": [Color(0.46, 0.38, 0.36), Color(0.64, 0.54, 0.48)], "ceil": Color(0.4, 0.33, 0.31), "sun": "none", "clouds": "none",
		"far": "brick_arches", "far_col": Color(0.66, 0.52, 0.46, 0.7), "mid": "casks", "mid_col": Color(0.66, 0.5, 0.38, 0.85),
		"ground": [Color(0.6, 0.5, 0.44), Color(0.5, 0.42, 0.37)], "haze": Color(1.0, 0.86, 0.66, 0.07), "plat": Color(0.66, 0.52, 0.42), "anim": "lamp_pools"},
	"mushcave": {"sky": [Color(0.3, 0.32, 0.47), Color(0.42, 0.43, 0.58)], "ceil": Color(0.28, 0.3, 0.43), "sun": "none", "clouds": "none",
		"far": "mush_glow", "far_col": Color(0.55, 0.85, 0.82, 0.55), "mid": "mush_small", "mid_col": Color(0.98, 0.7, 0.82, 0.8),
		"ground": [Color(0.44, 0.46, 0.58), Color(0.36, 0.38, 0.5)], "haze": Color(0.8, 1.0, 0.95, 0.06), "plat": Color(0.52, 0.56, 0.68), "anim": "spores"},
	"sewer": {"sky": [Color(0.44, 0.52, 0.54), Color(0.6, 0.66, 0.64)], "ceil": Color(0.4, 0.47, 0.5), "sun": "none", "clouds": "none",
		"far": "sewer_arches", "far_col": Color(0.6, 0.66, 0.66, 0.7), "mid": "pipes", "mid_col": Color(0.62, 0.7, 0.72, 0.85),
		"ground": [Color(0.6, 0.66, 0.64), Color(0.5, 0.56, 0.56)], "haze": Color(0.88, 1.0, 0.98, 0.07), "plat": Color(0.58, 0.64, 0.66), "anim": "water_flow"},
	"duskroof": {"sky": [Color(0.64, 0.58, 0.8), Color(1.0, 0.8, 0.66)], "sun": "glow", "clouds": "up",
		"far": "dusk_city", "far_col": Color(0.6, 0.52, 0.72, 0.7), "mid": "chimneys", "mid_col": Color(0.78, 0.6, 0.6, 0.85),
		"ground": [Color(0.78, 0.62, 0.6), Color(0.66, 0.52, 0.52)], "haze": Color(1.0, 0.9, 0.85, 0.08), "plat": Color(0.74, 0.56, 0.54), "anim": "dusk_birds"},
	"cloudisle": {"sky": [Color(0.7, 0.84, 0.98), Color(0.98, 0.95, 0.98)], "sun": "sun", "clouds": "below",
		"far": "isles", "far_col": Color(0.66, 0.82, 0.68, 0.6), "mid": "cloud_puffs", "mid_col": Color(1.0, 1.0, 1.0, 0.85),
		"ground": [Color(0.94, 0.95, 0.98), Color(0.84, 0.87, 0.94)], "haze": Color(1.0, 1.0, 1.0, 0.08), "plat": Color(0.92, 0.92, 0.98), "anim": "cloud_drift"},
	"bamboo": {"sky": [Color(0.74, 0.88, 0.84), Color(0.95, 0.97, 0.9)], "sun": "sun", "clouds": "none",
		"far": "bamboo_far", "far_col": Color(0.6, 0.78, 0.6, 0.5), "mid": "bamboo_near", "mid_col": Color(0.5, 0.72, 0.5, 0.75),
		"ground": [Color(0.74, 0.84, 0.66), Color(0.62, 0.74, 0.56)], "haze": Color(0.96, 1.0, 0.94, 0.1), "plat": Color(0.62, 0.74, 0.52), "anim": "leaves"},
	"snowpass": {"sky": [Color(0.76, 0.84, 0.94), Color(0.96, 0.97, 1.0)], "sun": "sun", "clouds": "up",
		"far": "peaks", "far_col": Color(0.84, 0.88, 0.96, 0.75), "mid": "snow_pines", "mid_col": Color(0.56, 0.7, 0.66, 0.75),
		"ground": [Color(0.95, 0.96, 0.99), Color(0.86, 0.89, 0.95)], "haze": Color(1.0, 1.0, 1.0, 0.1), "plat": Color(0.8, 0.84, 0.92), "anim": "snowfall"},
	"desertruin": {"sky": [Color(0.72, 0.85, 0.96), Color(1.0, 0.93, 0.8)], "sun": "sun", "clouds": "none",
		"far": "ruin_arches", "far_col": Color(0.92, 0.8, 0.64, 0.6), "mid": "broken_cols", "mid_col": Color(0.86, 0.72, 0.56, 0.8),
		"ground": [Color(0.94, 0.86, 0.7), Color(0.84, 0.74, 0.58)], "haze": Color(1.0, 0.97, 0.9, 0.1), "plat": Color(0.84, 0.7, 0.54)},
	"toyfactory": {"sky": [Color(0.86, 0.8, 0.92), Color(0.98, 0.93, 0.9)], "ceil": Color(0.78, 0.72, 0.84), "sun": "glow", "clouds": "none",
		"far": "conveyors", "far_col": Color(0.74, 0.7, 0.84, 0.65), "mid": "gift_boxes", "mid_col": Color(0.96, 0.72, 0.74, 0.85),
		"ground": [Color(0.86, 0.82, 0.9), Color(0.76, 0.72, 0.82)], "haze": Color(1.0, 0.96, 1.0, 0.08), "plat": Color(0.78, 0.7, 0.86), "anim": "gears"},
	"clocktower": {"sky": [Color(0.62, 0.6, 0.74), Color(0.9, 0.84, 0.8)], "ceil": Color(0.56, 0.52, 0.64), "sun": "glow", "clouds": "none",
		"far": "clockface", "far_col": Color(0.96, 0.9, 0.78, 0.75), "mid": "beams_soft", "mid_col": Color(0.66, 0.56, 0.5, 0.75),
		"ground": [Color(0.72, 0.64, 0.62), Color(0.62, 0.55, 0.54)], "haze": Color(1.0, 0.94, 0.86, 0.07), "plat": Color(0.7, 0.6, 0.56), "anim": "gears"},
	"pier": {"sky": [Color(0.66, 0.84, 0.98), Color(0.98, 0.95, 0.88)], "sun": "sun", "clouds": "up",
		"far": "sea_far", "far_col": Color(0.56, 0.78, 0.92, 0.75), "mid": "pier_posts", "mid_col": Color(0.72, 0.58, 0.46, 0.85),
		"ground": [Color(0.84, 0.74, 0.62), Color(0.74, 0.64, 0.52)], "haze": Color(0.95, 1.0, 1.0, 0.08), "plat": Color(0.74, 0.6, 0.48), "anim": "waves"},
	"candy": {"sky": [Color(0.96, 0.82, 0.9), Color(1.0, 0.96, 0.92)], "sun": "sun", "clouds": "up",
		"far": "candy_hills", "far_col": Color(0.98, 0.78, 0.84, 0.6), "mid": "lollipops", "mid_col": Color(0.86, 0.72, 0.94, 0.85),
		"ground": [Color(0.98, 0.88, 0.9), Color(0.92, 0.78, 0.84)], "haze": Color(1.0, 0.97, 0.98, 0.08), "plat": Color(0.94, 0.76, 0.84)},
	"mansion": {"sky": [Color(0.42, 0.38, 0.58), Color(0.64, 0.56, 0.72)], "sun": "glow", "clouds": "none",
		"far": "mansion", "far_col": Color(0.5, 0.44, 0.64, 0.8), "mid": "fence_lamps", "mid_col": Color(1.0, 0.84, 0.62, 0.85),
		"ground": [Color(0.58, 0.54, 0.66), Color(0.48, 0.45, 0.58)], "haze": Color(0.96, 0.9, 1.0, 0.06), "plat": Color(0.6, 0.54, 0.7), "anim": "ghosts"},
}

## คำบรรยายสั้นของฉาก ใช้เป็นข้อความบนแผนที่ดันเจี้ยน
const BLURB := {
	"metro": "สถานีรถไฟใต้ดินเงียบๆ โคมกลมส่องแสงอุ่น รถไฟวิ่งผ่านเบาๆ ด้านหลัง",
	"cellar": "ห้องเก็บของใต้ดิน ถังไม้เรียงราย มีโคมดวงเล็กส่องเป็นวงอุ่นๆ",
	"mushcave": "อุโมงค์ถ้ำที่เห็ดเรืองแสงนวลๆ สปอร์ลอยวิบวับช้าๆ",
	"sewer": "อุโมงค์ทางน้ำใต้เมือง น้ำไหลเอื่อย ท่อกลมเรียงตามผนัง",
	"duskroof": "หลังคาบ้านยามเย็น ฟ้าสีชมพูม่วง ปล่องไฟเรียงยาว",
	"cloudisle": "เกาะเล็กลอยเหนือทะเลเมฆ ก้อนเมฆนุ่มลอยผ่าน",
	"bamboo": "ป่าไผ่เขียวร่มรื่น ใบไผ่ปลิวร่วงช้าๆ",
	"snowpass": "ช่องเขาหิมะ ยอดเขาขาวนวล หิมะโปรยเบาๆ",
	"desertruin": "ซากซุ้มโค้งกลางทะเลทราย เสาหักนอนอยู่ในทราย",
	"toyfactory": "โรงงานของเล่น สายพานเลื่อน เฟืองกลมหมุนช้าๆ",
	"clocktower": "ข้างในหอนาฬิกา หน้าปัดใหญ่ เฟืองหมุนติ๊กต๊อก",
	"pier": "สะพานท่าเรือริมทะเล คลื่นซัดเบาๆ ลมทะเลเย็นสบาย",
	"candy": "ดินแดนขนมหวาน เนินมาร์ชเมลโล อมยิ้มต้นใหญ่",
	"mansion": "คฤหาสน์ผีน่ารักยามค่ำ ผีน้อยลอยไปมา ไม่น่ากลัวเลย",
}

static func ink(a := 0.35) -> Color:
	return Color(Sketch.INK, a)

static func _blob(c: CanvasItem, at: Vector2, rx: float, ry: float, color: Color) -> void:
	SoftPaint.oval(c, at, rx, ry, color, 0.45)

static func _box(c: CanvasItem, x: float, y: float, w: float, h: float, color: Color, r := 10.0) -> void:
	UiStyle.fill(c, Rect2(x, y, w, h), color, minf(r, minf(w, h) * 0.45))

static func _ring(c: CanvasItem, at: Vector2, r: float, a := 0.3, w := 2.0) -> void:
	c.draw_arc(at, r, 0.0, TAU, 32, ink(a), w, true)

## วงแสงโคมอุ่นบนพื้น (ฉากมืด)
static func _pool(c: CanvasItem, at: Vector2, r: float, a := 0.22) -> void:
	_blob(c, at, r, r * 0.38, Color(1.0, 0.86, 0.6, a))
	_blob(c, at, r * 0.55, r * 0.2, Color(1.0, 0.9, 0.7, a))

# ---------------------------------------------------------------- ฉากไกล
static func far(c: CanvasItem, theme: String, g: float, span: float, rng: RandomNumberGenerator) -> void:
	var look: Dictionary = LOOKS[theme]
	var col: Color = look["far_col"]
	var x := -span
	match str(look["far"]):
		"metro_wall":
			# ผนังกระเบื้องเป็นแถบ ซุ้มอุโมงค์โค้งมีแสงอุ่นข้างใน
			c.draw_rect(Rect2(-span, g - 230.0, span * 2.0, 170.0), Color(col, col.a * 0.6))
			while x < span:
				_blob(c, Vector2(x + 110.0, g - 60.0), 90.0, 120.0, Color(0.24, 0.26, 0.38, 0.8))
				_blob(c, Vector2(x + 110.0, g - 90.0), 30.0, 40.0, Color(1.0, 0.86, 0.6, 0.35))
				for k in 3:
					_box(c, x + 230.0 + float(k) * 34.0, g - 200.0, 26.0, 18.0, Color(0.8, 0.82, 0.9, 0.45), 6.0)
				x += 420.0
		"brick_arches":
			while x < span:
				_blob(c, Vector2(x + 90.0, g - 80.0), 80.0, 110.0, Color(col, col.a))
				_blob(c, Vector2(x + 90.0, g - 70.0), 58.0, 90.0, Color(0.3, 0.24, 0.24, 0.7))
				x += 230.0
		"mush_glow":
			while x < span:
				var h := rng.randf_range(120.0, 210.0)
				var r := rng.randf_range(50.0, 80.0)
				c.draw_rect(Rect2(x - 9.0, g - h, 18.0, h), Color(0.82, 0.86, 0.9, 0.45))
				_blob(c, Vector2(x, g - h), r * 1.5, r * 1.5, Color(col, 0.16))
				_blob(c, Vector2(x, g - h), r, r * 0.55, col)
				x += rng.randf_range(200.0, 320.0)
		"sewer_arches":
			c.draw_rect(Rect2(-span, g - 34.0, span * 2.0, 34.0), Color(0.5, 0.66, 0.7, 0.55))
			while x < span:
				_blob(c, Vector2(x + 100.0, g - 70.0), 96.0, 120.0, col)
				_blob(c, Vector2(x + 100.0, g - 60.0), 70.0, 96.0, Color(0.3, 0.36, 0.4, 0.75))
				x += 260.0
		"dusk_city":
			while x < span:
				var h := rng.randf_range(120.0, 230.0)
				var w := rng.randf_range(70.0, 120.0)
				_box(c, x, g - h, w, h, col, 12.0)
				for k in 3:
					if rng.randf() < 0.6:
						_box(c, x + 14.0 + float(k % 2) * 30.0, g - h + 24.0 + float(k) * 40.0, 16.0, 18.0, Color(1.0, 0.86, 0.6, 0.7), 5.0)
				x += w + rng.randf_range(10.0, 40.0)
		"isles":
			while x < span:
				var cy := g - rng.randf_range(160.0, 260.0)
				_blob(c, Vector2(x, cy), 90.0, 26.0, col)
				_blob(c, Vector2(x, cy + 24.0), 60.0, 34.0, Color(0.78, 0.7, 0.62, 0.55))
				_blob(c, Vector2(x - 20.0, cy - 30.0), 30.0, 30.0, Color(0.56, 0.74, 0.58, 0.6))
				x += rng.randf_range(300.0, 420.0)
		"bamboo_far":
			while x < span:
				var h := rng.randf_range(260.0, 360.0)
				_box(c, x, g - h, 16.0, h, col, 8.0)
				_blob(c, Vector2(x + 8.0, g - h), 40.0, 18.0, Color(col, col.a * 0.8))
				x += rng.randf_range(50.0, 90.0)
		"peaks":
			var pts := PackedVector2Array([Vector2(-span, g)])
			while x < span + 300.0:
				pts.append(Vector2(x + 150.0, g - rng.randf_range(200.0, 290.0)))
				pts.append(Vector2(x + 300.0, g - rng.randf_range(80.0, 130.0)))
				x += 300.0
			pts.append(Vector2(span + 300.0, g))
			SoftPaint.shape(c, pts, col, 0.25)
		"ruin_arches":
			while x < span:
				_box(c, x, g - 170.0, 30.0, 170.0, col, 8.0)
				_box(c, x + 130.0, g - 170.0, 30.0, 170.0, col, 8.0)
				c.draw_arc(Vector2(x + 80.0, g - 170.0), 65.0, PI, TAU, 24, col, 26.0, true)
				x += rng.randf_range(300.0, 420.0)
		"conveyors":
			while x < span:
				_box(c, x, g - 150.0, 260.0, 22.0, col, 11.0)
				for k in 5:
					c.draw_circle(Vector2(x + 20.0 + float(k) * 55.0, g - 139.0), 9.0, Color(1.0, 1.0, 1.0, 0.4))
				_box(c, x + 40.0, g - 182.0, 34.0, 30.0, Color(0.98, 0.8, 0.6, 0.6), 8.0)
				_box(c, x + 150.0, g - 178.0, 28.0, 26.0, Color(0.7, 0.86, 0.96, 0.6), 8.0)
				x += 380.0
		"clockface":
			while x < span:
				var cc := Vector2(x + 160.0, g - 230.0)
				_blob(c, cc, 120.0, 120.0, col)
				_ring(c, cc, 120.0, 0.3, 3.0)
				for k in 12:
					var a := TAU * float(k) / 12.0
					c.draw_circle(cc + Vector2(cos(a), sin(a)) * 100.0, 5.0, ink(0.35))
				c.draw_line(cc, cc + Vector2(0.0, -70.0), ink(0.5), 6.0, true)
				c.draw_line(cc, cc + Vector2(50.0, 10.0), ink(0.5), 5.0, true)
				x += 720.0
		"sea_far":
			c.draw_rect(Rect2(-span, g - 120.0, span * 2.0, 120.0), col)
			while x < span:
				_blob(c, Vector2(x, g - 110.0), 40.0, 5.0, Color(1.0, 1.0, 1.0, 0.45))
				x += rng.randf_range(120.0, 200.0)
		"candy_hills":
			while x < span:
				_blob(c, Vector2(x, g - 20.0), rng.randf_range(140.0, 200.0), rng.randf_range(90.0, 140.0), col if rng.randf() < 0.5 else Color(0.84, 0.86, 0.98, col.a))
				x += rng.randf_range(200.0, 280.0)
		"mansion":
			while x < span:
				var w := 260.0
				_box(c, x, g - 210.0, w, 210.0, col, 14.0)
				_blob(c, Vector2(x + 50.0, g - 230.0), 40.0, 50.0, col)
				_blob(c, Vector2(x + w - 50.0, g - 250.0), 44.0, 60.0, col)
				for k in 4:
					_box(c, x + 26.0 + float(k) * 58.0, g - 160.0, 30.0, 40.0, Color(1.0, 0.86, 0.6, 0.55), 12.0)
				x += 520.0
		_:
			while x < span:
				_blob(c, Vector2(x, g - 80.0), 120.0, 80.0, col)
				x += 260.0

# ---------------------------------------------------------------- ฉากกลาง
static func mid(c: CanvasItem, theme: String, g: float, span: float, rng: RandomNumberGenerator) -> void:
	var look: Dictionary = LOOKS[theme]
	var col: Color = look["mid_col"]
	var x := -span
	match str(look["mid"]):
		"hang_lamps":
			while x < span:
				c.draw_line(Vector2(x, 0.0), Vector2(x, g - 300.0), ink(0.3), 2.0, true)
				_blob(c, Vector2(x, g - 290.0), 46.0, 46.0, Color(1.0, 0.86, 0.6, 0.14))
				_blob(c, Vector2(x, g - 290.0), 16.0, 16.0, col)
				_pool(c, Vector2(x, g + 10.0), 120.0)
				x += 340.0
		"casks":
			while x < span:
				for k in 2:
					var cx := x + float(k) * 64.0
					_blob(c, Vector2(cx, g - 40.0), 30.0, 40.0, col)
					_ring(c, Vector2(cx, g - 40.0), 26.0, 0.25, 2.0)
				_blob(c, Vector2(x + 30.0, g - 200.0), 12.0, 14.0, Color(1.0, 0.82, 0.55, 0.9))
				_pool(c, Vector2(x + 30.0, g + 8.0), 110.0)
				x += rng.randf_range(300.0, 400.0)
		"mush_small":
			while x < span:
				var h := rng.randf_range(30.0, 60.0)
				c.draw_rect(Rect2(x - 4.0, g - h, 8.0, h), Color(0.9, 0.9, 0.94, 0.7))
				_blob(c, Vector2(x, g - h), 34.0, 34.0, Color(col, 0.18))
				_blob(c, Vector2(x, g - h), 20.0, 12.0, col)
				x += rng.randf_range(90.0, 180.0)
		"pipes":
			while x < span:
				_box(c, x, g - 230.0, 34.0, 230.0, col, 17.0)
				_box(c, x - 40.0, g - 170.0, 120.0, 28.0, col, 14.0)
				c.draw_circle(Vector2(x + 17.0, g - 156.0), 16.0, Color(col.darkened(0.15), col.a))
				x += rng.randf_range(320.0, 440.0)
		"chimneys":
			while x < span:
				_box(c, x, g - 70.0, 40.0, 70.0, col, 8.0)
				_blob(c, Vector2(x + 20.0, g - 100.0), 20.0, 16.0, Color(1.0, 1.0, 1.0, 0.35))
				_blob(c, Vector2(x + 34.0, g - 130.0), 26.0, 20.0, Color(1.0, 1.0, 1.0, 0.25))
				x += rng.randf_range(200.0, 300.0)
		"cloud_puffs":
			while x < span:
				for k in 3:
					_blob(c, Vector2(x + float(k) * 40.0, g + 20.0 - float(k % 2) * 16.0), 46.0, 30.0, col)
				x += rng.randf_range(240.0, 340.0)
		"bamboo_near":
			while x < span:
				var h := rng.randf_range(300.0, 420.0)
				_box(c, x, g - h, 22.0, h, col, 11.0)
				var y := g - 60.0
				while y > g - h:
					c.draw_line(Vector2(x, y), Vector2(x + 22.0, y), Color(col.darkened(0.2), col.a), 2.0, true)
					y -= 70.0
				_blob(c, Vector2(x + 30.0, g - h + 30.0), 30.0, 10.0, Color(col.lightened(0.1), col.a))
				x += rng.randf_range(150.0, 260.0)
		"snow_pines":
			while x < span:
				var s := rng.randf_range(0.8, 1.2)
				for k in 3:
					var w := (60.0 - float(k) * 14.0) * s
					var y := g - (40.0 + float(k) * 46.0) * s
					SoftPaint.shape(c, PackedVector2Array([Vector2(x - w, y), Vector2(x + w, y), Vector2(x, y - 60.0 * s)]), col, 0.3)
					_blob(c, Vector2(x, y - 50.0 * s), 14.0 * s, 8.0 * s, Color(1.0, 1.0, 1.0, 0.85))
				x += rng.randf_range(160.0, 260.0)
		"broken_cols":
			while x < span:
				var h := rng.randf_range(60.0, 140.0)
				_box(c, x, g - h, 36.0, h, col, 8.0)
				_blob(c, Vector2(x + 18.0, g - h), 22.0, 8.0, Color(col.lightened(0.15), col.a))
				if rng.randf() < 0.5:
					_box(c, x + 50.0, g - 22.0, 70.0, 22.0, col, 10.0)
				x += rng.randf_range(220.0, 320.0)
		"gift_boxes":
			while x < span:
				var s := rng.randf_range(40.0, 70.0)
				var cc: Color = [col, Color(0.72, 0.86, 0.96, col.a), Color(0.98, 0.9, 0.62, col.a)][rng.randi() % 3]
				_box(c, x, g - s, s, s, cc, 8.0)
				c.draw_line(Vector2(x + s * 0.5, g - s), Vector2(x + s * 0.5, g), Color(1.0, 1.0, 1.0, 0.6), 5.0, true)
				_blob(c, Vector2(x + s * 0.5, g - s), 10.0, 7.0, Color(1.0, 1.0, 1.0, 0.7))
				x += rng.randf_range(160.0, 260.0)
		"beams_soft":
			while x < span:
				_box(c, x, g - 320.0, 26.0, 320.0, col, 10.0)
				_box(c, x - 60.0, g - 300.0, 146.0, 20.0, col, 10.0)
				x += 420.0
		"pier_posts":
			while x < span:
				_box(c, x, g - 60.0, 22.0, 80.0, col, 9.0)
				c.draw_line(Vector2(x + 11.0, g - 56.0), Vector2(x + 151.0, g - 50.0), ink(0.3), 3.0, true)
				x += 140.0
		"lollipops":
			while x < span:
				var h := rng.randf_range(120.0, 200.0)
				c.draw_rect(Rect2(x - 4.0, g - h, 8.0, h), Color(1.0, 1.0, 1.0, 0.8))
				var cc: Color = [col, Color(0.98, 0.74, 0.8, col.a), Color(0.74, 0.88, 0.8, col.a)][rng.randi() % 3]
				_blob(c, Vector2(x, g - h), 34.0, 34.0, cc)
				c.draw_arc(Vector2(x, g - h), 20.0, 0.0, PI * 1.5, 16, Color(1.0, 1.0, 1.0, 0.7), 5.0, true)
				x += rng.randf_range(180.0, 280.0)
		"fence_lamps":
			while x < span:
				_box(c, x, g - 46.0, 160.0, 8.0, ink(0.35), 4.0)
				for k in 5:
					_box(c, x + float(k) * 36.0, g - 60.0, 7.0, 60.0, ink(0.35), 3.0)
				_box(c, x + 170.0, g - 150.0, 8.0, 150.0, ink(0.4), 4.0)
				_blob(c, Vector2(x + 174.0, g - 156.0), 13.0, 15.0, col)
				_pool(c, Vector2(x + 174.0, g + 8.0), 100.0, 0.18)
				x += 360.0
		_:
			while x < span:
				_blob(c, Vector2(x, g - 40.0), 60.0, 40.0, col)
				x += 200.0

# ---------------------------------------------------------------- ชั้นขยับ วาดทุกเฟรมบนจอ ใช้รูปน้อยๆ
static func anim(c: CanvasItem, theme: String, t: float, view: Vector2, g: float, cam: float) -> void:
	var w := view.x
	match str((LOOKS[theme] as Dictionary).get("anim", "")):
		"metro":
			# รถไฟเงาจางวิ่งผ่านด้านหลังทุก 9 วิ หน้าต่างเรืองอุ่น
			var ph := fposmod(t, 9.0)
			if ph < 3.0:
				var tx := w + 200.0 - ph / 3.0 * (w + 1800.0)
				_box(c, tx, g - 150.0, 1500.0, 80.0, Color(0.5, 0.52, 0.66, 0.5), 30.0)
				var k := 0
				while k < 14:
					_box(c, tx + 40.0 + float(k) * 104.0, g - 136.0, 56.0, 30.0, Color(1.0, 0.88, 0.64, 0.45), 10.0)
					k += 1
		"lamp_pools":
			for i in 3:
				var a := 0.05 + 0.03 * sin(t * 1.3 + float(i) * 2.0)
				_blob(c, Vector2(w * (0.2 + 0.3 * float(i)), g * 0.55), 160.0, 120.0, Color(1.0, 0.86, 0.6, a))
		"spores":
			for i in 18:
				var lx := fposmod(float(i) * 97.0 - cam * 0.3 + sin(t * 0.4 + float(i)) * 30.0, w + 60.0) - 30.0
				var ly := g - fposmod(t * 14.0 + float(i) * 53.0, g * 0.9)
				var cc := Color(0.6, 0.95, 0.9, 0.5) if i % 2 == 0 else Color(1.0, 0.75, 0.88, 0.5)
				_blob(c, Vector2(lx, ly), 9.0, 9.0, Color(cc, 0.15))
				c.draw_circle(Vector2(lx, ly), 3.0, cc)
		"water_flow":
			for i in 8:
				var lx := w - fposmod(t * 60.0 + float(i) * 180.0 + cam * 0.2, w + 200.0)
				c.draw_line(Vector2(lx, g - 18.0 + float(i % 3) * 6.0), Vector2(lx + 60.0, g - 18.0 + float(i % 3) * 6.0), Color(1.0, 1.0, 1.0, 0.3), 3.0, true)
		"dusk_birds":
			for i in 4:
				var bx := fposmod(t * 40.0 + float(i) * 330.0, w + 200.0) - 100.0
				var by := g * (0.18 + 0.06 * float(i)) + sin(t * 2.0 + float(i)) * 8.0
				c.draw_arc(Vector2(bx - 8.0, by), 8.0, PI * 1.1, PI * 1.9, 8, ink(0.4), 2.5, true)
				c.draw_arc(Vector2(bx + 8.0, by), 8.0, PI * 1.1, PI * 1.9, 8, ink(0.4), 2.5, true)
		"cloud_drift":
			for i in 5:
				var cx := fposmod(t * 18.0 + float(i) * 300.0 - cam * 0.1, w + 300.0) - 150.0
				_blob(c, Vector2(cx, g * (0.25 + 0.1 * float(i % 3))), 80.0, 24.0, Color(1.0, 1.0, 1.0, 0.35))
		"leaves":
			for i in 10:
				var lx := fposmod(float(i) * 151.0 + sin(t * 0.8 + float(i)) * 50.0 - cam * 0.4, w + 60.0) - 30.0
				var ly := fposmod(t * 30.0 + float(i) * 77.0, g + 40.0) - 20.0
				_blob(c, Vector2(lx, ly), 9.0, 4.0, Color(0.56, 0.76, 0.5, 0.7))
		"snowfall":
			for i in 26:
				var lx := fposmod(float(i) * 61.0 + sin(t * 0.7 + float(i)) * 20.0 - cam * 0.5, w + 40.0) - 20.0
				var ly := fposmod(t * 40.0 + float(i) * 37.0, g + 60.0) - 30.0
				c.draw_circle(Vector2(lx, ly), 3.0 + float(i % 3), Color(1.0, 1.0, 1.0, 0.8))
		"gears":
			for i in 3:
				var gc := Vector2(fposmod(float(i) * 520.0 - cam * 0.35, w + 400.0) - 200.0, g * (0.3 + 0.12 * float(i)))
				var r := 60.0 + float(i) * 14.0
				var a := t * (0.4 if i % 2 == 0 else -0.5)
				_blob(c, gc, r, r, Color(0.86, 0.8, 0.9, 0.35))
				for k in 8:
					var ka := a + TAU * float(k) / 8.0
					c.draw_circle(gc + Vector2(cos(ka), sin(ka)) * r, 12.0, Color(0.86, 0.8, 0.9, 0.35))
				c.draw_circle(gc, r * 0.3, Color(0.7, 0.64, 0.76, 0.35))
		"waves":
			for i in 6:
				var lx := fposmod(t * 30.0 + float(i) * 240.0 - cam * 0.2, w + 240.0) - 120.0
				var ly := g - 90.0 + float(i % 3) * 14.0
				c.draw_arc(Vector2(lx, ly), 26.0, PI * 1.15, PI * 1.85, 10, Color(1.0, 1.0, 1.0, 0.5), 3.0, true)
		"ghosts":
			for i in 4:
				var gx := fposmod(t * 22.0 + float(i) * 360.0 - cam * 0.25, w + 200.0) - 100.0
				var gy := g * (0.3 + 0.1 * float(i % 2)) + sin(t * 1.5 + float(i)) * 14.0
				_blob(c, Vector2(gx, gy), 26.0, 30.0, Color(1.0, 1.0, 1.0, 0.45))
				c.draw_circle(Vector2(gx - 8.0, gy - 4.0), 3.5, ink(0.5))
				c.draw_circle(Vector2(gx + 8.0, gy - 4.0), 3.5, ink(0.5))

## ชนิดชั้นหน้า (พุ่มกระดาษตัดชิดขอบล่าง) ของฉากชุดนี้ ว่างคือไม่มี
static func tufts(theme: String) -> String:
	match theme:
		"bamboo":
			return "grass"
		"snowpass":
			return "snow"
		"desertruin":
			return "sand"
		"cloudisle":
			return "cloud"
		"candy":
			return "bush"
		"mushcave":
			return "crystal"
	return ""
