class_name SoftDraw
## วาดรูปหลายเหลี่ยมแบบมุมมน ให้เอฟเฟกต์ทุกอย่างกลมนุ่มตามธีมแมว ไม่มีมุมแหลม
## ใช้แทน draw_colored_polygon / draw_polygon โดยปัดมุมด้วยการตัดมุมซ้ำ (Chaikin) สองรอบ

const ROUNDS := 2

static func _smooth(pts: PackedVector2Array) -> PackedVector2Array:
	var cur := pts
	for _r in ROUNDS:
		var n := cur.size()
		if n < 3:
			return cur
		var out := PackedVector2Array()
		for i in n:
			var a := cur[i]
			var b := cur[(i + 1) % n]
			out.append(a.lerp(b, 0.25))
			out.append(a.lerp(b, 0.75))
		cur = out
	return cur

static func _smooth_cols(cols: PackedColorArray) -> PackedColorArray:
	var cur := cols
	for _r in ROUNDS:
		var n := cur.size()
		if n < 3:
			return cur
		var out := PackedColorArray()
		for i in n:
			var a := cur[i]
			var b := cur[(i + 1) % n]
			out.append(a.lerp(b, 0.25))
			out.append(a.lerp(b, 0.75))
		cur = out
	return cur

## รูปสีเดียว มุมมน
static func poly(ci: CanvasItem, pts: PackedVector2Array, col: Color, _uvs := PackedVector2Array(), _tex: Texture2D = null) -> void:
	if pts.size() < 3:
		return
	var s := _smooth(pts)
	if Geometry2D.triangulate_polygon(s).is_empty():
		if Geometry2D.triangulate_polygon(pts).is_empty():
			return
		s = pts
	ci.draw_colored_polygon(s, col)

## รูปไล่สีตามจุด มุมมน
static func poly_c(ci: CanvasItem, pts: PackedVector2Array, cols: PackedColorArray, _uvs := PackedVector2Array(), _tex: Texture2D = null) -> void:
	if pts.size() < 3:
		return
	if cols.size() != pts.size():
		ci.draw_polygon(pts, cols)
		return
	var s := _smooth(pts)
	var sc := _smooth_cols(cols)
	if Geometry2D.triangulate_polygon(s).is_empty():
		if Geometry2D.triangulate_polygon(pts).is_empty():
			return
		s = pts
		sc = cols
	ci.draw_polygon(s, sc)

## ประกายกลมแทนดาวแฉก: จุดกลมฟุ้ง แกนขาว
static func sparkle(ci: CanvasItem, at: Vector2, r: float, col: Color) -> void:
	if r <= 0.5 or col.a <= 0.0:
		return
	ci.draw_circle(at, r * 1.0, Color(col, col.a * 0.35))
	ci.draw_circle(at, r * 0.6, col)
	ci.draw_circle(at, r * 0.28, Color(1.0, 1.0, 1.0, col.a))

## เส้นมุมมน: ปัดมุมของเส้นหลายจุด เส้นปิด (จุดแรกเท่าจุดท้าย) ปัดทุกมุม เส้นเปิดคงปลายสองข้างไว้
static func round_line(pts: PackedVector2Array) -> PackedVector2Array:
	var n := pts.size()
	if n < 3:
		return pts
	var closed := pts[0].distance_to(pts[n - 1]) < 0.5
	if closed:
		var core := pts.slice(0, n - 1)
		var s := _smooth(core)
		s.append(s[0])
		return s
	var cur := pts
	for _r in ROUNDS:
		var out := PackedVector2Array([cur[0]])
		for i in cur.size() - 1:
			var a := cur[i]
			var b := cur[i + 1]
			out.append(a.lerp(b, 0.25))
			out.append(a.lerp(b, 0.75))
		out.append(cur[cur.size() - 1])
		cur = out
	return cur

static func pline(ci: CanvasItem, pts: PackedVector2Array, col: Color, width := -1.0, aa := false) -> void:
	ci.draw_polyline(round_line(pts), col, width, aa)

static func sketch_line(ci: CanvasItem, pts: PackedVector2Array, seed_no: int, width := Sketch.WIDTH, wobble := Sketch.WOBBLE, color := Sketch.INK) -> void:
	Sketch.line(ci, round_line(pts), seed_no, width, wobble, color)
