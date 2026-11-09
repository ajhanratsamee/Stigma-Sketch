class_name UiStyle
## กติกาหน้าตา UI เดียวกันทั้งเกม: โทนกลางวันสว่าง กระดาษขาวนวล ขอบหมึกเส้นมือ มุมโค้งมน
## ตัวหนังสือใหญ่อ่านง่าย สัญลักษณ์ตกแต่งเป็นอุ้งเท้าแมว ไม่ใช้ดาว

# โทนนุ่มทั้งเกม ตามหน้าโหลด "แมวมั้ย" (ตรงกับชุด SOFT_ ของหน้าคลัง/หน้าสร้าง)
const INK := Color(0.36, 0.31, 0.29)         # ตัวหนังสือ เส้นขอบ น้ำตาลเทา
const DIM := Color(0.73, 0.69, 0.66)         # ปุ่มที่กดไม่ได้ เส้นจาง
const PAPER := Color(0.975, 0.96, 0.94, 0.95)  # พื้นกล่องปกติ ครีมนวล
const PICKED := Color(0.96, 0.9, 0.86)       # พื้นกล่องที่เลือกอยู่ ชมพูฝุ่นอ่อน
const WARN := Color(0.72, 0.4, 0.36)         # ปุ่มลบ คำเตือน (ไม่แดงจัด)
const PAW := Color(0.93, 0.76, 0.76)         # อุ้งเท้าตกแต่ง

const RADIUS := 16.0                         # มุมโค้งของกล่องและปุ่ม
const LINE := 2.6                            # ขอบปกติ บางนุ่ม
const LINE_BOLD := 4.0                       # ขอบตัวที่เลือก ปุ่มหลัก

const TITLE := 40                            # หัวข้อหน้า
const BUTTON := 34                           # ตัวหนังสือบนปุ่ม
const NAME := 30                             # ชื่อตัวละคร ชื่อสกิล
const BODY := 22                             # ข้อความทั่วไป
const SMALL := 19                            # ข้อความรอง ห้ามเล็กกว่านี้

## จุดรอบกล่องมุมโค้ง ปิดรูปแล้ว (จุดแรกซ้ำที่ท้าย)
# โทนนุ่มแบบหน้าโหลด "แมวมั้ย" ใช้หน้าคลังกับหน้าสร้างตัวละคร
const SOFT_BG := Color(0.925, 0.902, 0.871)        # พื้นครีมเทา
const SOFT_INK := Color(0.47, 0.42, 0.39)          # เส้นและตัวหนังสือสีน้ำตาลเทา
const SOFT_TEXT := Color(0.36, 0.31, 0.29)         # ตัวหนังสือหลัก เข้มกว่าเส้นนิดหน่อยให้อ่านง่าย
const SOFT_DIM := Color(0.73, 0.69, 0.66)          # กดไม่ได้
const SOFT_CARD := Color(0.975, 0.96, 0.94)        # พื้นการ์ด
const SOFT_PICK := Color(0.96, 0.9, 0.86)          # การ์ดที่เลือก ชมพูฝุ่นอ่อน
const SOFT_ACCENT := Color(0.77, 0.63, 0.55)       # ชมพูฝุ่น ขอบตัวที่เลือก ปุ่มหลัก
const SOFT_PRIMARY := Color(0.91, 0.82, 0.77)      # พื้นปุ่มหลัก
const SOFT_WARN := Color(0.72, 0.4, 0.36)          # ลบ คำเตือน (ไม่แดงจัด)
const SOFT_LINE := 2.4
const SOFT_LINE_BOLD := 3.6

## ปุ่มโทนนุ่ม ปุ่มหลักพื้นชมพูฝุ่น กดไม่ได้เส้นจาง
static func soft_button(c: CanvasItem, r: Rect2, label: String, seed_no: int, on := true, main := false) -> void:
	var col := SOFT_TEXT if on else SOFT_DIM
	fill(c, r, SOFT_PRIMARY if main and on else Color(SOFT_CARD, 0.85 if on else 0.6))
	frame(c, r, seed_no, SOFT_LINE_BOLD if main and on else SOFT_LINE, SOFT_ACCENT if main and on else (SOFT_INK if on else SOFT_DIM))
	text(c, r.get_center(), label, BUTTON, col, r.size.x - 24.0)

## ระยะเว้นขอบซ้ายขวา (หน่วยจอเกม) กันรูกล้องหน้าจอเจาะรู / ขอบโค้ง บนมือถือ  เดสก์ท็อปคืน 0
static func safe_side() -> float:
	if not OS.has_feature("mobile") and not OS.has_feature("web_android") and not OS.has_feature("web_ios"):
		return 0.0
	var win := DisplayServer.window_get_size()
	var scr := DisplayServer.screen_get_size()
	var safe := DisplayServer.get_display_safe_area()
	if win.y <= 0 or safe.size.x <= 0:
		return 0.0
	var inset := float(maxi(safe.position.x, scr.x - safe.end.x))
	return clampf(inset * 720.0 / float(win.y), 0.0, 110.0)

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
