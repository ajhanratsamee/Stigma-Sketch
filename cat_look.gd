class_name CatLook
## หน้าตามอนสเตอร์แมว วาดในพิกัดมอน เท้าอยู่ที่ (0, 0) สีเต็มตัดเส้นหมึกบาง ไม่มีลายขีด
## ลูกน้อง: ไม่มีแขนไม่มีขา กระโดดดึ๋งๆ  บอส: แมวตัวใหญ่มีอุ้งมือสั้นๆ ถืออาวุธ
## c คือตัวมอน ใช้ดูว่าลอยอยู่ไหม และกำลังง้างอาวุธอยู่ไหม

const LOOKS := ["cat_mochi", "cat_long", "cat_cyclops", "cat_box", "cat_ghost", "cat_puff"]
const BOSSES := ["boss_club", "boss_spear", "boss_hammer", "boss_scythe", "boss_king"]
const TOP := {"cat_mochi": 110.0, "cat_long": 190.0, "cat_cyclops": 120.0, "cat_box": 125.0, "cat_ghost": 150.0, "cat_puff": 115.0,
	"boss_club": 250.0, "boss_spear": 330.0, "boss_hammer": 260.0, "boss_scythe": 280.0, "boss_king": 300.0}
const NAMES := {"cat_mochi": "ไหมพรมเด้ง", "cat_long": "แตงกวาตกใจ", "cat_cyclops": "หนูจอมซน", "cat_box": "หุ่นดูดฝุ่น", "cat_ghost": "ขวดสเปรย์ลอย", "cat_puff": "ปลาปักเป้าพอง",
	"boss_club": "ราชาไหมพรมไม้นวดแป้ง", "boss_spear": "อัศวินแตงกวาส้อมยักษ์", "boss_hammer": "หุ่นดูดฝุ่นค้อนยักษ์", "boss_scythe": "หนูเงาเคียวจันทร์", "boss_king": "ราชันหมาอัศวิน"}
const INK := Color(0.16, 0.15, 0.14)

## ชื่อมอนตามธีมเมือง (เมือง 1-8)  "boss" ใช้กับบอสทุกตัวของเมืองนั้น
const TOWN_NAMES := {
	1: {"cat_mochi": "ปลาซาร์ดีนขี้โมโห", "cat_long": "ก้างปลาเดินได้", "cat_cyclops": "หนูขโมยปลา", "cat_box": "ลังปลาเดินได้", "cat_ghost": "หมึกลอยฟ่อง", "cat_puff": "หอยเม่นกลม", "boss": "ราชาหมึกยักษ์"},
	2: {"cat_mochi": "สไลม์คริสตัล", "cat_long": "ตุ่นหินขุดแร่", "cat_cyclops": "หนูถือจอบ", "cat_box": "รถแร่เดินได้", "cat_ghost": "ค้างคาวถ้ำ", "cat_puff": "หินหนามกลิ้ง", "boss": "ราชาตุ่นคริสตัล"},
	3: {"cat_mochi": "ปูน้อยก้ามโต", "cat_long": "นกนางนวลจอมแย่ง", "cat_cyclops": "หนูกะลาสี", "cat_box": "หีบสมบัติจอมกัด", "cat_ghost": "แมงกะพรุนวิบวับ", "cat_puff": "ปลาปักเป้าทะเลลึก", "boss": "กัปตันปูยักษ์"},
	4: {"cat_mochi": "ลูกกระบองเพชร", "cat_long": "งูทรายขดตัว", "cat_cyclops": "หนูหูโตทะเลทราย", "cat_box": "แมงป่องกล่อง", "cat_ghost": "ก้อนฝุ่นลอย", "cat_puff": "เม่นทะเลทราย", "boss": "ราชินีแมงป่องกล่อง"},
	5: {"cat_mochi": "ก้อนหิมะดุ๊กดิ๊ก", "cat_long": "เพนกวินบอท", "cat_cyclops": "หนูหมวกไหมพรม", "cat_box": "เลื่อนหิมะจอมชน", "cat_ghost": "ปลาน้ำแข็งลอย", "cat_puff": "เม่นน้ำแข็ง", "boss": "ราชาเพนกวินบอท"},
	6: {"cat_mochi": "ก้อนลาวาเด้ง", "cat_long": "เทียนถ่านไฟ", "cat_cyclops": "หนูถ่าน", "cat_box": "หม้อไฟเดินได้", "cat_ghost": "ค้างคาวถ่านไฟ", "cat_puff": "หินลาวาหนาม", "boss": "เจ้าแห่งลาวา"},
	7: {"cat_mochi": "สไลม์เงา", "cat_long": "เทียนผีเดินได้", "cat_cyclops": "หนูชุดเกราะ", "cat_box": "หนังสือเวทจอมกัด", "cat_ghost": "ค้างคาวรัตติกาล", "cat_puff": "ลูกแก้วหนามม่วง", "boss": "อัศวินหนูเงา"},
	8: {"cat_mochi": "แกะเมฆปุยฝ้าย", "cat_long": "สไลม์วงแหวนทอง", "cat_cyclops": "หนูนางฟ้า", "cat_box": "หีบทองคำ", "cat_ghost": "ผึ้งทอง", "cat_puff": "ลูกขนนกทอง", "boss": "ราชาแกะเมฆทอง"},
}

## ชื่อมอนตามเมือง town -1 คือเดาจากดันที่เล่นอยู่ / เมืองปัจจุบัน (แบบเดียวกับ MonsterModel.town_of)
## ชื่อบอสยักษ์แบบรุม ใส่คำนำหน้าตามเมืองให้รู้ว่าเป็นตัวพิเศษ
const RAID_TITLES := ["ยักษ์", "ยักษ์", "มหายักษ์", "มหายักษ์", "จอมยักษ์", "จอมยักษ์", "ราชันยักษ์", "ราชันยักษ์", "เทพยักษ์"]
static func raid_name(look: String, town := -1) -> String:
	var t := town if town >= 0 else MonsterModel.town_of(look)
	return str(RAID_TITLES[clampi(t, 0, RAID_TITLES.size() - 1)]) + " " + name_of(look, town)

static func name_of(look: String, town := -1) -> String:
	var kind := look.get_slice("@", 0)
	var t := town
	if t < 0:
		t = MonsterModel.town_of(look)
	if TOWN_NAMES.has(t):
		var names: Dictionary = TOWN_NAMES[t]
		var key := "boss" if kind.begins_with("boss") else kind
		if names.has(key):
			return str(names[key])
	return str(NAMES.get(kind, ""))

static func top(look: String) -> float:
	return TOP.get(look, 120.0)

static func _fill(c: CanvasItem, pts: PackedVector2Array, color: Color, width := 2.6) -> void:
	SoftDraw.poly(c, pts, color)
	var rim := pts.duplicate()
	rim.append(pts[0])
	SoftDraw.pline(c, rim, INK, width, true)

static func _blob(center: Vector2, rx: float, ry: float, flat := 0.0, n := 36) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		var y := sin(a) * ry
		if y > 0.0:
			y *= 1.0 - flat
		pts.append(center + Vector2(cos(a) * rx, y))
	return pts

static func _ear(c: CanvasItem, base: Vector2, w: float, h: float, lean: float, color: Color, inner: Color) -> void:
	var tip := base + Vector2(lean * w, -h)
	_fill(c, PackedVector2Array([base + Vector2(-w * 0.5, 0.0), tip, base + Vector2(w * 0.5, 0.0)]), color)
	SoftDraw.poly(c, PackedVector2Array([base + Vector2(-w * 0.25, -2.0), base.lerp(tip, 0.7), base + Vector2(w * 0.25, -2.0)]), inner)

## เพิ่งโดนตี ตาเป็น >< ปากอ้า
static func _hurt(c: CanvasItem) -> bool:
	var t = c.get("_hurt_t")
	return t != null and float(t) > 0.0

static func _eye(c: CanvasItem, at: Vector2, r: float, face: float, angry := false) -> void:
	if _hurt(c):
		# ตาซ้ายเป็น > ตาขวาเป็น < ตาเดียวเป็นทั้งคู่
		var sides := [1.0] if at.x < -6.0 else ([-1.0] if at.x > 6.0 else [1.0, -1.0])
		for sd in sides:
			var cx: float = at.x + (0.0 if sides.size() == 1 else -float(sd) * r * 0.55)
			var tip := Vector2(cx + float(sd) * r * 0.5, at.y)
			SoftDraw.pline(c, PackedVector2Array([Vector2(cx - float(sd) * r * 0.5, at.y - r * 0.6), tip, Vector2(cx - float(sd) * r * 0.5, at.y + r * 0.6)]), INK, maxf(2.5, r * 0.28), true)
		return
	c.draw_circle(at, r, Color.WHITE)
	c.draw_arc(at, r, 0.0, TAU, 16, INK, 2.0, true)
	c.draw_circle(at + Vector2(face * r * 0.3, r * 0.05), r * 0.55, INK)
	c.draw_circle(at + Vector2(face * r * 0.1 - r * 0.2, -r * 0.3), r * 0.2, Color.WHITE)
	if angry:
		c.draw_line(at + Vector2(-r * 1.1, -r * 1.3 - face * r * 0.3), at + Vector2(r * 1.1, -r * 1.3 + face * r * 0.3), INK, 3.0, true)

## หน้าแมว ตาสองข้าง ปาก :3 หนวด แก้มชมพู
static func _face(c: CanvasItem, center: Vector2, size: float, face: float, angry := false) -> void:
	var gap := size * 0.42
	_eye(c, center + Vector2(-gap + face * size * 0.12, 0.0), size * 0.2, face, angry)
	_eye(c, center + Vector2(gap + face * size * 0.12, 0.0), size * 0.2, face, angry)
	var m := center + Vector2(face * size * 0.12, size * 0.32)
	if _hurt(c):
		# โดนตีปากอ้า
		SoftDraw.poly(c, _blob(m + Vector2(0.0, size * 0.04), size * 0.08, size * 0.07), Color(0.75, 0.3, 0.35))
		c.draw_arc(m + Vector2(0.0, size * 0.04), size * 0.08, 0.0, TAU, 12, INK, 2.0, true)
	else:
		# ปากแมว ω หยักโค้ง
		var w := PackedVector2Array()
		for i in 13:
			var t := float(i) / 12.0
			w.append(m + Vector2((t - 0.5) * size * 0.3, absf(sin(t * TAU)) * size * 0.07))
		SoftDraw.pline(c, w, INK, 2.2, true)
	for side in [-1.0, 1.0]:
		c.draw_circle(center + Vector2(side * gap * 1.25 + face * size * 0.1, size * 0.3), size * 0.1, Color(1.0, 0.55, 0.6, 0.6))
		for k in 2:
			var from := center + Vector2(side * size * 0.55, size * (0.22 + float(k) * 0.12))
			c.draw_line(from, from + Vector2(side * size * 0.42, size * (float(k) * 0.08 - 0.04)), INK, 1.6, true)

## ยืดหดตามการกระโดด ลอยอยู่ตัวยืด ตอนอยู่พื้นยุบดึ๋ง
static func _squash(c: Node2D, t: float) -> Vector2:
	var air: float = clampf(float(c.get("pos").y) * 0.35, 0.0, 0.25) if c.get("pos") != null else 0.0
	var bob := sin(t * 7.0) * 0.05
	return Vector2(1.0 + bob - air * 0.6, 1.0 - bob + air)

static func draw(c: Node2D, look: String, t: float, face: float) -> void:
	match look:
		"cat_mochi": _mochi(c, t, face, Color(1.0, 0.86, 0.62), 1.0)
		"cat_long": _long(c, t, face, 1.0)
		"cat_cyclops": _cyclops(c, t, face, 1.0)
		"cat_box": _box(c, t, face, 1.0)
		"cat_ghost": _ghost(c, t, face)
		"cat_puff": _puff(c, t, face)
		"boss_club": _boss_club(c, t, face)
		"boss_spear": _boss_spear(c, t, face)
		"boss_hammer": _boss_hammer(c, t, face)
		"boss_scythe": _boss_scythe(c, t, face)
		"boss_king": _boss_king(c, t, face)

## มุมง้างอาวุธของบอส 0 ปกติ ง้างสุดแล้วฟาดลง
static func _swing(c: Node2D) -> float:
	if str(c.get("ai_state")) == "windup":
		var k := 1.0 - clampf(float(c.get("ai_t")) / 0.7, 0.0, 1.0)
		return -1.6 * sin(k * PI * 0.5) if k < 0.85 else 0.9
	return 0.0

## โมจิแมว ก้อนกลมไม่มีแขนขา หูแหลม ลายส้มบนหัว
static func _mochi(c: Node2D, t: float, face: float, color: Color, k: float) -> void:
	var s := _squash(c, t) * k
	var body := _blob(Vector2(0.0, -48.0 * s.y), 58.0 * s.x, 48.0 * s.y, 0.35)
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * 30.0 * s.x, -82.0 * s.y), 26.0 * k, 30.0 * s.y, side * 0.25, color, Color(1.0, 0.7, 0.75))
	_fill(c, body, color)
	for i in 3:
		var x := (float(i) - 1.0) * 14.0 * s.x
		c.draw_line(Vector2(x, -94.0 * s.y), Vector2(x * 1.2, -80.0 * s.y), Color(0.95, 0.55, 0.25), 5.0 * k, true)
	_face(c, Vector2(0.0, -52.0 * s.y), 48.0 * k, face)

## แมวยืดยาว ตัวเป็นแท่งยาวสีขาว หน้าอยู่บนสุด
static func _long(c: Node2D, t: float, face: float, k: float) -> void:
	var s := _squash(c, t)
	var h := 170.0 * s.y * k
	var w := 34.0 * s.x * k
	var pts := PackedVector2Array()
	for i in 13:
		var a := PI + PI * float(i) / 12.0
		pts.append(Vector2(cos(a) * w, -h + w + sin(a) * w))
	for i in 9:
		var y := -h + w + (h - w) * float(i) / 8.0
		pts.append(Vector2(w + sin(float(i) + t * 3.0) * 3.0, y))
	pts.append(Vector2(-w, 0.0))
	var sway := PackedVector2Array()
	for p in pts:
		sway.append(p + Vector2(sin(t * 3.0 + p.y * 0.02) * 6.0 * (1.0 + p.y / h), 0.0))
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * w * 0.55, -h + 6.0), 18.0 * k, 24.0 * k, side * 0.2, Color(0.98, 0.97, 0.94), Color(1.0, 0.72, 0.78))
	_fill(c, sway, Color(0.98, 0.97, 0.94))
	_face(c, Vector2(0.0, -h + w * 1.05), 40.0 * k, face)

## แมวตาเดียว ก้อนม่วง ตาโตตรงกลาง เขาเล็ก
static func _cyclops(c: Node2D, t: float, face: float, k: float) -> void:
	var s := _squash(c, t) * k
	var col := Color(0.66, 0.52, 0.92)
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * 32.0 * s.x, -86.0 * s.y), 24.0 * k, 28.0 * s.y, side * 0.3, col, Color(0.95, 0.7, 0.9))
	_fill(c, _blob(Vector2(0.0, -50.0 * s.y), 60.0 * s.x, 52.0 * s.y, 0.3), col)
	_fill(c, PackedVector2Array([Vector2(-6.0, -100.0 * s.y), Vector2(0.0, -122.0 * s.y), Vector2(6.0, -100.0 * s.y)]), Color(1.0, 0.9, 0.5))
	_eye(c, Vector2(face * 6.0, -58.0 * s.y), 22.0 * k, face)
	c.draw_arc(Vector2(face * 6.0, -24.0 * s.y), 10.0 * k, 0.2, PI - 0.2, 10, INK, 2.4, true)

## แมวกล่อง กล่องกระดาษเด้งไปมา หัวแมวโผล่ด้านบน ฝากล่องพับเปิด
static func _box(c: Node2D, t: float, face: float, k: float) -> void:
	var s := _squash(c, t) * k
	var cat := Color(0.55, 0.55, 0.6)
	var head := Vector2(0.0, -86.0 * s.y)
	for side in [-1.0, 1.0]:
		_ear(c, head + Vector2(side * 22.0 * k, -26.0 * k), 22.0 * k, 24.0 * k, side * 0.2, cat, Color(1.0, 0.7, 0.75))
	_fill(c, _blob(head, 40.0 * k, 34.0 * k), cat)
	_face(c, head + Vector2(0.0, 2.0), 34.0 * k, face)
	var box := Color(0.85, 0.66, 0.42)
	_fill(c, PackedVector2Array([Vector2(-56.0 * s.x, -70.0 * s.y), Vector2(56.0 * s.x, -70.0 * s.y), Vector2(52.0 * s.x, 0.0), Vector2(-52.0 * s.x, 0.0)]), box)
	_fill(c, PackedVector2Array([Vector2(-56.0 * s.x, -70.0 * s.y), Vector2(-78.0 * s.x, -96.0 * s.y), Vector2(-30.0 * s.x, -84.0 * s.y)]), box.darkened(0.1))
	_fill(c, PackedVector2Array([Vector2(56.0 * s.x, -70.0 * s.y), Vector2(80.0 * s.x, -92.0 * s.y), Vector2(30.0 * s.x, -84.0 * s.y)]), box.darkened(0.1))
	c.draw_line(Vector2(-20.0 * s.x, -40.0 * s.y), Vector2(20.0 * s.x, -40.0 * s.y), Color(0.6, 0.4, 0.2), 3.0, true)

## แมวผีลอย ตัวใสสีฟ้า ชายล่างเป็นคลื่น ลอยขึ้นลง
static func _ghost(c: Node2D, t: float, face: float) -> void:
	var lift := -30.0 + sin(t * 3.0) * 10.0
	var col := Color(0.75, 0.9, 1.0, 0.85)
	var pts := PackedVector2Array()
	for i in 13:
		var a := PI + PI * float(i) / 12.0
		pts.append(Vector2(cos(a) * 50.0, lift - 70.0 + sin(a) * 50.0))
	for i in 9:
		var x := 50.0 - 100.0 * float(i) / 8.0
		pts.append(Vector2(x, lift + sin(float(i) * 1.6 + t * 6.0) * 10.0))
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * 28.0, lift - 108.0), 22.0, 26.0, side * 0.3, col, Color(0.85, 0.8, 1.0))
	_fill(c, pts, col)
	_face(c, Vector2(0.0, lift - 72.0), 40.0, face)
	SoftDraw.poly(c, _blob(Vector2(0.0, 0.0), 40.0, 8.0), Color(0.3, 0.4, 0.6, 0.2))

## แมวหนามพอง ก้อนดำฟูเป็นหนาม ตาโกรธ
static func _puff(c: Node2D, t: float, face: float) -> void:
	var s := _squash(c, t)
	var pts := PackedVector2Array()
	for i in 28:
		var a := TAU * float(i) / 28.0
		var r := (60.0 if i % 2 == 0 else 46.0) + sin(t * 8.0 + float(i)) * 2.0
		var y := sin(a) * r * s.y
		pts.append(Vector2(cos(a) * r * s.x, -56.0 * s.y + (y * 0.7 if y > 0.0 else y)))
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * 30.0 * s.x, -96.0 * s.y), 22.0, 28.0, side * 0.3, Color(0.25, 0.22, 0.28), Color(0.9, 0.4, 0.5))
	_fill(c, pts, Color(0.25, 0.22, 0.28))
	_eye(c, Vector2(-16.0 + face * 6.0, -62.0 * s.y), 11.0, face, true)
	_eye(c, Vector2(16.0 + face * 6.0, -62.0 * s.y), 11.0, face, true)
	c.draw_line(Vector2(-10.0 + face * 6.0, -38.0 * s.y), Vector2(10.0 + face * 6.0, -38.0 * s.y), Color.WHITE, 3.0, true)

## อุ้งมือสั้นของบอส
static func _paw(c: CanvasItem, at: Vector2, r: float, color: Color) -> void:
	_fill(c, _blob(at, r, r * 0.85), color)
	for i in 3:
		c.draw_circle(at + Vector2((float(i) - 1.0) * r * 0.45, -r * 0.55), r * 0.18, color.darkened(0.25))

## อาวุธหมุนรอบจุดจับ หันตามทิศหน้า
static func _weapon(c: CanvasItem, grip: Vector2, angle: float, face: float, parts: Array) -> void:
	c.draw_set_transform(grip, angle * face, Vector2(face, 1.0))
	for p in parts:
		_fill(c, p[0], p[1])
	c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## บอส 1 ราชาโมจิ ก้อนโมจิยักษ์สีส้ม มงกุฎใบไม้ ถือกระบองไม้
static func _boss_club(c: Node2D, t: float, face: float) -> void:
	var col := Color(1.0, 0.72, 0.42)
	var sw := _swing(c)
	_mochi(c, t, face, col, 2.2)
	var grip := Vector2(face * 105.0, -90.0)
	_weapon(c, grip, -0.5 + sw, face, [
		[PackedVector2Array([Vector2(-9.0, 10.0), Vector2(9.0, 10.0), Vector2(16.0, -150.0), Vector2(-16.0, -150.0)]), Color(0.65, 0.42, 0.22)],
		[_blob(Vector2(0.0, -160.0), 32.0, 40.0), Color(0.58, 0.36, 0.18)],
	])
	_paw(c, grip, 22.0, col)
	_fill(c, PackedVector2Array([Vector2(-50.0, -214.0), Vector2(-30.0, -240.0), Vector2(0.0, -220.0), Vector2(30.0, -240.0), Vector2(50.0, -214.0)]), Color(0.5, 0.75, 0.35))

## บอส 2 แมวยืดยักษ์ ถือหอกยาว
static func _boss_spear(c: Node2D, t: float, face: float) -> void:
	var sw := _swing(c)
	_long(c, t, face, 1.75)
	var grip := Vector2(face * 70.0, -150.0)
	_weapon(c, grip, 1.2 + sw * 0.6, face, [
		[PackedVector2Array([Vector2(-6.0, 120.0), Vector2(6.0, 120.0), Vector2(6.0, -170.0), Vector2(-6.0, -170.0)]), Color(0.55, 0.36, 0.2)],
		[PackedVector2Array([Vector2(-18.0, -165.0), Vector2(0.0, -235.0), Vector2(18.0, -165.0)]), Color(0.82, 0.85, 0.9)],
		[PackedVector2Array([Vector2(-14.0, -160.0), Vector2(14.0, -160.0), Vector2(10.0, -150.0), Vector2(-10.0, -150.0)]), Color(0.9, 0.3, 0.3)],
	])
	_paw(c, grip, 18.0, Color(0.98, 0.97, 0.94))

## บอส 3 แมวกล่องยักษ์ ถือค้อนไม้ยักษ์
static func _boss_hammer(c: Node2D, t: float, face: float) -> void:
	var sw := _swing(c)
	_box(c, t, face, 2.0)
	var grip := Vector2(face * 125.0, -110.0)
	_weapon(c, grip, -0.4 + sw, face, [
		[PackedVector2Array([Vector2(-8.0, 20.0), Vector2(8.0, 20.0), Vector2(8.0, -140.0), Vector2(-8.0, -140.0)]), Color(0.6, 0.4, 0.22)],
		[PackedVector2Array([Vector2(-60.0, -135.0), Vector2(60.0, -135.0), Vector2(60.0, -195.0), Vector2(-60.0, -195.0)]), Color(0.72, 0.55, 0.35)],
		[PackedVector2Array([Vector2(-60.0, -150.0), Vector2(60.0, -150.0), Vector2(60.0, -160.0), Vector2(-60.0, -160.0)]), Color(0.5, 0.5, 0.55)],
	])
	_paw(c, grip, 22.0, Color(0.55, 0.55, 0.6))

## บอส 4 แมวเงาตาเดียวยักษ์ ถือเคียวมืด หมอกม่วงรอบตัว
static func _boss_scythe(c: Node2D, t: float, face: float) -> void:
	var sw := _swing(c)
	for i in 6:
		var a := t * 1.5 + float(i)
		c.draw_circle(Vector2(cos(a) * 110.0, -60.0 + sin(a * 1.3) * 20.0), 24.0, Color(0.45, 0.25, 0.6, 0.25))
	c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var col := Color(0.32, 0.22, 0.45)
	var s := _squash(c, t) * 2.2
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * 32.0 * s.x, -86.0 * s.y), 24.0 * 2.2, 28.0 * s.y, side * 0.3, col, Color(0.7, 0.4, 0.8))
	_fill(c, _blob(Vector2(0.0, -50.0 * s.y), 60.0 * s.x, 52.0 * s.y, 0.3), col)
	_eye(c, Vector2(face * 12.0, -60.0 * s.y), 40.0, face, true)
	c.draw_arc(Vector2(face * 12.0, -22.0 * s.y), 20.0, 0.2, PI - 0.2, 10, Color(0.9, 0.8, 1.0), 3.0, true)
	var grip := Vector2(face * 120.0, -110.0)
	_weapon(c, grip, 0.1 + sw, face, [
		[PackedVector2Array([Vector2(-6.0, 90.0), Vector2(6.0, 90.0), Vector2(6.0, -180.0), Vector2(-6.0, -180.0)]), Color(0.2, 0.15, 0.25)],
		[PackedVector2Array([Vector2(0.0, -180.0), Vector2(130.0, -150.0), Vector2(150.0, -110.0), Vector2(100.0, -140.0), Vector2(0.0, -160.0)]), Color(0.65, 0.55, 0.85)],
	])
	_paw(c, grip, 22.0, col)

## บอส 5 ราชันแมวอัศวิน แมวส้มยักษ์ใส่มงกุฎทอง ผ้าคลุมแดง เกราะอก ถือดาบใหญ่กับโล่
static func _boss_king(c: Node2D, t: float, face: float) -> void:
	var sw := _swing(c)
	var col := Color(1.0, 0.68, 0.38)
	var s := _squash(c, t) * 2.3
	# ผ้าคลุมด้านหลัง
	_fill(c, PackedVector2Array([Vector2(-face * 30.0, -170.0), Vector2(-face * 120.0, 0.0), Vector2(-face * 20.0, -10.0)]), Color(0.8, 0.15, 0.18))
	for side in [-1.0, 1.0]:
		_ear(c, Vector2(side * 30.0 * s.x, -82.0 * s.y), 26.0 * 2.3, 30.0 * s.y, side * 0.25, col, Color(1.0, 0.7, 0.75))
	_fill(c, _blob(Vector2(0.0, -48.0 * s.y), 58.0 * s.x, 48.0 * s.y, 0.35), col)
	# เกราะอกอยู่ใต้หน้า ไม่ทับหน้า
	_fill(c, _blob(Vector2(0.0, -16.0 * s.y), 40.0 * s.x, 14.0 * s.y, 0.2), Color(0.78, 0.8, 0.86))
	c.draw_line(Vector2(0.0, -28.0 * s.y), Vector2(0.0, -4.0 * s.y), Color(0.95, 0.75, 0.3), 6.0, true)
	_face(c, Vector2(0.0, -56.0 * s.y), 44.0 * 2.3, face, true)
	var crown := PackedVector2Array([Vector2(-50.0, -200.0), Vector2(-50.0, -235.0), Vector2(-25.0, -215.0), Vector2(0.0, -245.0), Vector2(25.0, -215.0), Vector2(50.0, -235.0), Vector2(50.0, -200.0)])
	_fill(c, crown, Color(1.0, 0.82, 0.3))
	c.draw_circle(Vector2(0.0, -215.0), 7.0, Color(0.9, 0.2, 0.3))
	# โล่ด้านหลังมืออีกข้าง
	var shield := Vector2(-face * 100.0, -90.0)
	_fill(c, PackedVector2Array([shield + Vector2(-38.0, -50.0), shield + Vector2(38.0, -50.0), shield + Vector2(34.0, 20.0), shield + Vector2(0.0, 58.0), shield + Vector2(-34.0, 20.0)]), Color(0.25, 0.4, 0.75))
	c.draw_line(shield + Vector2(0.0, -44.0), shield + Vector2(0.0, 50.0), Color(1.0, 0.82, 0.3), 6.0, true)
	c.draw_line(shield + Vector2(-32.0, -10.0), shield + Vector2(32.0, -10.0), Color(1.0, 0.82, 0.3), 6.0, true)
	var grip := Vector2(face * 110.0, -100.0)
	_weapon(c, grip, -0.3 + sw, face, [
		[PackedVector2Array([Vector2(-7.0, 30.0), Vector2(7.0, 30.0), Vector2(7.0, -10.0), Vector2(-7.0, -10.0)]), Color(0.45, 0.28, 0.15)],
		[PackedVector2Array([Vector2(-34.0, -10.0), Vector2(34.0, -10.0), Vector2(34.0, -22.0), Vector2(-34.0, -22.0)]), Color(1.0, 0.82, 0.3)],
		[PackedVector2Array([Vector2(-16.0, -22.0), Vector2(16.0, -22.0), Vector2(14.0, -200.0), Vector2(0.0, -232.0), Vector2(-14.0, -200.0)]), Color(0.86, 0.88, 0.94)],
		[PackedVector2Array([Vector2(-3.0, -26.0), Vector2(3.0, -26.0), Vector2(3.0, -200.0), Vector2(-3.0, -200.0)]), Color(0.7, 0.74, 0.82)],
	])
	_paw(c, grip, 24.0, col)
