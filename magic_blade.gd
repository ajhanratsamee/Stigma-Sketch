class_name MagicBlade
## หน้าตาดาบเวทของ MAGIC KNIGHT ใช้ร่วมกันทั้งดาบผุดจากดิน 15.3 และดาบพุ่งทะลุจอ 25.1
## ใบเหล็กสองซีกสว่างมืด ขอบคมเรืองส้ม ร่องกลางเรืองไฟ มีไฟเรืองรอบใบจางๆ
## วาดในพิกัดของโหนด โคนใบอยู่ที่จุด 0 0 ใบชี้ขึ้นแกน y ลบ ตั้ง draw_set_transform ก่อนเรียกเพื่อหมุนหรือย้าย

const STEEL_LIGHT := Color(0.94, 0.93, 0.95)
const STEEL_DARK := Color(0.6, 0.62, 0.7)
const EDGE_HOT := Color(1.0, 0.58, 0.18)
const FULLER := Color(0.82, 0.16, 0.06)
const FULLER_CORE := Color(1.0, 0.82, 0.45)
const GLOW := Color(1.0, 0.42, 0.1)
const INK := Color(0.16, 0.08, 0.06)
const GUARD := Color(0.95, 0.72, 0.28)
const GUARD_DARK := Color(0.7, 0.45, 0.15)
const GRIP := Color(0.32, 0.16, 0.12)

## ตัดรูปให้เหลือแค่ส่วนที่อยู่เหนือเส้น cut ไม่มีเส้นตัดถ้า cut เป็น INF
static func _fill(ci: CanvasItem, pts: PackedVector2Array, color: Color, cut: float) -> void:
	if cut == INF:
		ci.draw_colored_polygon(pts, color)
		return
	var box := PackedVector2Array([Vector2(-5000.0, -5000.0), Vector2(5000.0, -5000.0), Vector2(5000.0, cut), Vector2(-5000.0, cut)])
	for part in Geometry2D.intersect_polygons(pts, box):
		if part.size() >= 3:
			ci.draw_colored_polygon(part, color)

## ปลายดาบโค้งมนแบบดาบของเล่น จากซ้าย (-hw, sy) โค้งขึ้นถึงยอด top แล้วลงขวา (hw, sy)
static func _arch(hw: float, sy: float, top: float, from_a := PI, to_a := 0.0) -> PackedVector2Array:
	var out := PackedVector2Array()
	for i in 13:
		var a := lerpf(from_a, to_a, float(i) / 12.0)
		out.append(Vector2(cos(a) * hw, sy - sin(a) * (sy - top)))
	return out

## ใบดาบของเล่นปลายมน ยาว length กว้าง width ส่วนโค้งปลายยาว tip ยกขึ้นจากโคน lift (ใช้ตอนผุดจากดิน) cut คือเส้นพื้น
static func draw_blade(ci: CanvasItem, length: float, width: float, tip: float, glow: float = 1.0, lift: float = 0.0, cut: float = INF) -> void:
	var h := width * 0.5
	var y0 := lift
	var top := lift - length
	var sh := top + minf(tip, width) * 0.9
	var outline := PackedVector2Array([Vector2(-h, y0)])
	outline.append_array(_arch(h, sh, top))
	outline.append(Vector2(h, y0))
	# ไฟเรืองนุ่มรอบใบ
	var g := PackedVector2Array([Vector2(-h * 1.3, y0)])
	g.append_array(_arch(h * 1.3, sh, top - width * 0.15))
	g.append(Vector2(h * 1.3, y0))
	_fill(ci, g, Color(GLOW, 0.2 * glow), cut)
	# ซีกซ้ายสว่าง ซีกขวาเงาอ่อน
	var left := PackedVector2Array([Vector2(-h, y0)])
	left.append_array(_arch(h, sh, top, PI, PI * 0.5))
	left.append(Vector2(0.0, y0))
	_fill(ci, left, STEEL_LIGHT, cut)
	var right := PackedVector2Array([Vector2(0.0, y0)])
	right.append_array(_arch(h, sh, top, PI * 0.5, 0.0))
	right.append(Vector2(h, y0))
	_fill(ci, right, STEEL_DARK.lightened(0.25), cut)
	# แกนกลางขาวปลายมน
	var f := width * 0.12
	var core := PackedVector2Array([Vector2(-f, y0)])
	core.append_array(_arch(f, sh + width * 0.2, top + width * 0.25))
	core.append(Vector2(f, y0))
	_fill(ci, core, FULLER_CORE.lightened(0.5), cut)
	# เส้นขอบส้มนุ่มกับหมึกบาง
	var line := outline.duplicate()
	if cut != INF:
		var clipped := PackedVector2Array()
		for p in line:
			clipped.append(Vector2(p.x, minf(p.y, cut)))
		line = clipped
	SoftDraw.pline(ci, line, Color(EDGE_HOT, 0.7), 6.0, true)
	SoftDraw.pline(ci, line, INK, 2.5, true)

## ดาบเต็มเล่ม มีโกร่งทองกับด้ามจับใต้โคนใบ
static func draw_sword(ci: CanvasItem, length: float, width: float, tip: float, glow: float = 1.0) -> void:
	draw_blade(ci, length, width, tip, glow)
	var gw := width * 0.95
	var gh := width * 0.2
	var guard := PackedVector2Array([Vector2(-gw, -gh * 0.2), Vector2(-gw * 1.1, gh * 0.5), Vector2(-gw, gh), Vector2(gw, gh), Vector2(gw * 1.1, gh * 0.5), Vector2(gw, -gh * 0.2)])
	SoftDraw.poly(ci, guard, GUARD)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-gw, gh * 0.5), Vector2(gw, gh * 0.5), Vector2(gw, gh), Vector2(-gw, gh)]), GUARD_DARK)
	var closed := guard.duplicate()
	closed.append(guard[0])
	SoftDraw.pline(ci, closed, INK, 3.0, true)
	var gl := width * 1.1
	var grip := PackedVector2Array([Vector2(-width * 0.16, gh), Vector2(width * 0.16, gh), Vector2(width * 0.16, gh + gl), Vector2(-width * 0.16, gh + gl)])
	ci.draw_colored_polygon(grip, GRIP)
	for n in 4:
		var y := gh + gl * (float(n) + 0.5) / 4.0
		ci.draw_line(Vector2(-width * 0.16, y - 6.0), Vector2(width * 0.16, y + 6.0), Color(0.55, 0.32, 0.2), 3.0)
	ci.draw_circle(Vector2(0.0, gh + gl + width * 0.14), width * 0.2, GUARD)
	ci.draw_arc(Vector2(0.0, gh + gl + width * 0.14), width * 0.2, 0.0, TAU, 18, INK, 3.0)
