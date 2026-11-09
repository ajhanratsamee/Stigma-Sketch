class_name UiStyle
## กติกาหน้าตา UI เดียวกันทั้งเกม: โทนกลางวันสว่าง กระดาษขาวนวล ขอบหมึกเส้นมือ มุมโค้งมน
## ตัวหนังสือใหญ่อ่านง่าย สัญลักษณ์ตกแต่งเป็นอุ้งเท้าแมว ไม่ใช้ดาว

const INK := Color(0.16, 0.15, 0.14)
const DIM := Color(0.62, 0.6, 0.58)          # ปุ่มที่กดไม่ได้ เส้นจาง
const PAPER := Color(1.0, 0.99, 0.96, 0.94)  # พื้นกล่องปกติ
const PICKED := Color(1.0, 0.93, 0.85)       # พื้นกล่องที่เลือกอยู่
const WARN := Color(0.85, 0.3, 0.3)          # ปุ่มลบ คำเตือน
const PAW := Color(1.0, 0.72, 0.8)           # อุ้งเท้าตกแต่ง

const RADIUS := 16.0                         # มุมโค้งของกล่องและปุ่ม
const LINE := 3.5                            # ขอบปกติ
const LINE_BOLD := 6.0                       # ขอบตัวที่เลือก ปุ่มหลัก

const TITLE := 40                            # หัวข้อหน้า
const BUTTON := 34                           # ตัวหนังสือบนปุ่ม
const NAME := 30                             # ชื่อตัวละคร ชื่อสกิล
const BODY := 22                             # ข้อความทั่วไป
const SMALL := 19                            # ข้อความรอง ห้ามเล็กกว่านี้

## จุดรอบกล่องมุมโค้ง ปิดรูปแล้ว (จุดแรกซ้ำที่ท้าย)
static func round_pts(r: Rect2, radius := RADIUS) -> PackedVector2Array:
	var rad := minf(radius, minf(r.size.x, r.size.y) * 0.5)
	var pts := PackedVector2Array()
	var corners := [
		[r.position + Vector2(r.size.x - rad, rad), -PI * 0.5],
		[r.end - Vector2(rad, rad), 0.0],
		[r.position + Vector2(rad, r.size.y - rad), PI * 0.5],
		[r.position + Vector2(rad, rad), PI],
	]
	for c in corners:
		for i in 6:
			var a: float = float(c[1]) + PI * 0.5 * float(i) / 5.0
			pts.append((c[0] as Vector2) + Vector2(cos(a), sin(a)) * rad)
	pts.append(pts[0])
	return pts

## พื้นกล่องมุมโค้ง
static func fill(c: CanvasItem, r: Rect2, color := PAPER, radius := RADIUS) -> void:
	var pts := round_pts(r, radius)
	pts.remove_at(pts.size() - 1)
	c.draw_colored_polygon(pts, color)

## ขอบกล่องมุมโค้งเส้นมือ
static func frame(c: CanvasItem, r: Rect2, seed_no: int, width := LINE, ink := INK, radius := RADIUS) -> void:
	Sketch.line(c, round_pts(r, radius), seed_no, width, Sketch.WOBBLE * 0.6, ink)

## กล่องครบทั้งพื้นและขอบ
static func box(c: CanvasItem, r: Rect2, seed_no: int, width := LINE, ink := INK, color := PAPER) -> void:
	fill(c, r, color)
	frame(c, r, seed_no, width, ink)

## ตัวหนังสือกึ่งกลางจุด ย่อเองถ้ากว้างเกิน max_w
static func text(c: CanvasItem, at: Vector2, word: String, size: int, color := INK, max_w := 0.0) -> void:
	var font := Sketch.font()
	var px := size
	if max_w > 0.0:
		px = Sketch.fit_size(word, size, max_w, SMALL)
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, px).x
	c.draw_string(font, at + Vector2(-w * 0.5, float(px) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, px, color)

## ปุ่ม: กล่องมุมโค้ง ตัวหนังสือกลาง กดไม่ได้เป็นเส้นจาง
static func button(c: CanvasItem, r: Rect2, label: String, seed_no: int, on := true, main := false, ink := INK) -> void:
	var col := ink if on else DIM
	box(c, r, seed_no, LINE_BOLD if main and on else LINE, col, PAPER)
	text(c, r.get_center(), label, BUTTON, col, r.size.x - 24.0)

## อุ้งเท้าแมวตกแต่ง ฝ่าเท้ากลมกับนิ้วสี่นิ้ว
static func paw(c: CanvasItem, center: Vector2, size: float, color := PAW) -> void:
	c.draw_circle(center + Vector2(0.0, size * 0.25), size * 0.42, color)
	for i in 4:
		var a := -PI * 0.5 + (float(i) - 1.5) * 0.55
		c.draw_circle(center + Vector2(cos(a), sin(a)) * size * 0.62, size * 0.2, color)
