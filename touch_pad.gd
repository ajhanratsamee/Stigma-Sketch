class_name TouchPad
extends Node2D
## ปุ่ม Z X JUMP ขวาล่าง ช่องสกิล 4 ช่องกับ HYPER เรียงโค้งรอบนอกตามแนวนิ้วโป้ง วาดด้วยเส้น กดหลายปุ่มพร้อมกันได้ เมาส์ก็ใช้ได้
## กดอยู่แล้วเส้นขอบหนาขึ้น

signal pressed_button(id: String)

const RADIUS := 62.0
const RING := 3.0
const RING_DOWN := 6.5
const GLYPH := 26.0
const EDGE := 30.0
const LOW := 92.0
const GAP := 16.0               # ปุ่ม Z X ชิดกัน นิ้วโป้งเลื่อนสลับได้ไว
const SLOT_RADIUS := 44.0
const DOWN_RADIUS := 50.0
const SLOTS := 4               # ช่องสกิล 4 ช่อง เรียงโค้งรอบปุ่ม Z X ตามแนวนิ้วโป้ง
const CELL := 76.0              # เส้นผ่านศูนย์กลางช่องสกิลกลม (เล็กกว่าปุ่ม Z X)
const ARC_R := 262.0            # รัศมีแนวโค้งช่องสกิล วัดจากจุดหมุนนิ้วโป้ง
const ARC_PIVOT := Vector2(-68.0, 12.0)   # จุดหมุนแนวโค้ง เทียบกับปุ่ม X
const ARC_FROM := 180.0         # องศาเริ่ม (ซ้าย) ถึงองศาจบ (บน) ช่องสกิล 4 ช่อง แล้ว HYPER ปลายบนสุด
const ARC_TO := 270.0
const TOUCH_GROW := 1.15        # พื้นที่แตะกว้างกว่าวงที่เห็นเล็กน้อย
const JUMP_RADIUS := 46.0       # ปุ่ม JUMP เล็กกว่าปุ่มอื่น
const PSWAP_RADIUS := 46.0      # ปุ่ม V สลับตัว เล็กเท่าปุ่ม JUMP
const SLOT_TEXT := 18
const SKILL_TEXT := 24
const COMBO_TEXT := UiStyle.SMALL
const SWAP_RADIUS := 36.0
const HYPER_RADIUS := 40.0
const EMPTY_RING := Color(0.16, 0.15, 0.14, 0.35)

# ตัวอักษรเขียนเป็นเส้น พิกัดในกรอบ -1 ถึง 1
const LETTERS := {
	"<": [[Vector2(0.45, -0.8), Vector2(-0.5, 0.0), Vector2(0.45, 0.8)]],
	">": [[Vector2(-0.45, -0.8), Vector2(0.5, 0.0), Vector2(-0.45, 0.8)]],
	"Z": [[Vector2(-0.6, -0.8), Vector2(0.6, -0.8), Vector2(-0.6, 0.8), Vector2(0.6, 0.8)]],
	"X": [[Vector2(-0.6, -0.8), Vector2(0.6, 0.8)], [Vector2(0.6, -0.8), Vector2(-0.6, 0.8)]],
	"J": [[Vector2(0.5, -0.8), Vector2(0.5, 0.45), Vector2(0.15, 0.8), Vector2(-0.3, 0.8), Vector2(-0.55, 0.4)]],
	"U": [[Vector2(-0.55, -0.8), Vector2(-0.55, 0.4), Vector2(-0.2, 0.8), Vector2(0.2, 0.8), Vector2(0.55, 0.4), Vector2(0.55, -0.8)]],
	"M": [[Vector2(-0.6, 0.8), Vector2(-0.6, -0.8), Vector2(0.0, 0.2), Vector2(0.6, -0.8), Vector2(0.6, 0.8)]],
	"V": [[Vector2(-0.8, -0.45), Vector2(0.0, 0.5), Vector2(0.8, -0.45)]],
	# ตัว V ของปุ่มสลับตัว สูงแคบ ไม่ให้เหมือนลูกศรชี้ลง
	"v": [[Vector2(-0.5, -0.8), Vector2(0.0, 0.8), Vector2(0.5, -0.8)]],
	"P": [[Vector2(-0.5, 0.8), Vector2(-0.5, -0.8), Vector2(0.25, -0.8), Vector2(0.55, -0.45), Vector2(0.25, -0.05), Vector2(-0.5, -0.05)]],
}

var show_down := false
var captions := false           # คำอธิบายเหนือปุ่มสำหรับผู้เล่นใหม่ (เมืองแรกๆ เลเวลยังน้อย)
const CAPTION := {"z": "ตี", "x": "ท่าพิเศษ", "jump": "กระโดด", "pswap": "สลับตัว"}
var use_stick := true           # เดินด้วยจอยสติ๊กลอยฝั่งซ้าย ไม่มีปุ่มซ้าย ขวา ลง
var stick: Joystick             # นิ้วที่จับจอยอยู่ ปุ่มไม่สนใจ
var stick_home := Vector2.ZERO  # จุดพักของจอย
var locked: Array = []        # ปุ่มที่แสดงอยู่แต่ยังกดไม่ได้
var buttons := {}        # รหัสปุ่ม -> ตำแหน่ง
var held := {}           # รหัสปุ่ม -> จำนวนนิ้วที่กดอยู่
var _fingers := {}       # หมายเลขนิ้ว -> รหัสปุ่ม
var slot_labels := ["", "", "", ""]
var slot_ids := ["", "", "", ""]   # รหัสสกิลในแต่ละช่อง ใช้วาดไอคอน
var hyper_id := ""
var hyper_ready := false         # คลาสนี้มี HYPER ใช้ปุ่มแยก
var slot_cooldowns := [0.0, 0.0, 0.0, 0.0]
var row := 0                    # แถวสกิลที่แสดงอยู่
var pair_swap_on := false        # ปุ่ม V สลับตัว AZURE/LAPIS อยู่หน้าปุ่ม Z
var pair_swap_cd := 0.0          # คูลดาวน์ที่เหลือ วินาที
var v_on := false               # ปุ่ม V ของโฮมุนครุส
var v_ratio := 0.0              # เกจเทียบค่าใช้ 1 คือพร้อมยิง
var v_center := Vector2.ZERO
var v_dna := false              # เกจรูป DNA ของ ROGUE MEDIC
var v_stage := 0

## จัดตำแหน่งตามขนาดจอจริง
## ขวาล่าง: X ชิดมุม Z ชิดซ้าย X  JUMP เยื้องขึ้นเหนือ X  ช่องสกิล 4 ช่องกับ HYPER เรียงโค้งรอบนอก ตามแนวนิ้วโป้ง
func layout(view: Vector2) -> void:
	var y := view.y - LOW
	var xr := view.x - EDGE - UiStyle.safe_side() - RADIUS
	buttons = {
		"left": Vector2(EDGE + RADIUS, y),
		"right": Vector2(EDGE + RADIUS * 3.0 + 26.0, y),
		"x": Vector2(xr, y),
		"z": Vector2(xr - RADIUS * 2.0 - GAP, y + 10.0),
		"jump": Vector2(xr - 22.0, y - RADIUS - 20.0 - JUMP_RADIUS),
	}
	if pair_swap_on:
		buttons["pswap"] = buttons["z"] + Vector2(-18.0, -RADIUS - 18.0 - PSWAP_RADIUS)
	stick_home = (buttons["left"] + buttons["right"]) * 0.5 + Vector2(0.0, -30.0)
	if use_stick:
		buttons.erase("left")
		buttons.erase("right")
	elif show_down:
		buttons["down"] = (buttons["left"] + buttons["right"]) * 0.5 + Vector2(0.0, -RADIUS * 1.75)
	var pivot: Vector2 = buttons["x"] + ARC_PIVOT
	for i in SLOTS + 1:
		var ang := deg_to_rad(lerpf(ARC_FROM, ARC_TO, float(i) / float(SLOTS)))
		buttons["s%d" % i if i < SLOTS else "hyper"] = pivot + Vector2(cos(ang), sin(ang)) * ARC_R
	v_center = pivot + Vector2(cos(deg_to_rad(205.0)), sin(deg_to_rad(205.0))) * (ARC_R + 92.0)
	queue_redraw()

## ปล่อยทุกปุ่ม ใช้ตอนเข้าออกจอภาพ
func reset() -> void:
	_fingers.clear()
	held.clear()
	queue_redraw()

func _radius(id: String) -> float:
	if id == "down":
		return DOWN_RADIUS
	if id == "swap":
		return SWAP_RADIUS
	if id == "hyper":
		return HYPER_RADIUS
	if _is_slot(id):
		return CELL * 0.5
	if id == "jump" or id == "pswap":
		return JUMP_RADIUS if id == "jump" else PSWAP_RADIUS
	if id == "back" or id == "skill" or id == "combo":
		return SLOT_RADIUS
	return SLOT_RADIUS if _is_slot(id) else RADIUS

func _is_slot(id: String) -> bool:
	return id.length() == 2 and id[0] == "s"

func is_held(id: String) -> bool:
	return int(held.get(id, 0)) > 0

func _input(event: InputEvent) -> void:
	if not visible:
		return
	# นิ้วที่จับจอยอยู่ ไม่กดปุ่มอื่นแม้ลากผ่าน
	if stick != null and stick.finger() != -1 and (event is InputEventScreenTouch or event is InputEventScreenDrag) and event.index == stick.finger():
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			_finger_on(event.index, event.position)
		else:
			_finger_off(event.index)
	elif event is InputEventScreenDrag:
		_finger_off(event.index)
		_finger_on(event.index, event.position, false)

func _finger_on(index: int, at: Vector2, fresh := true) -> void:
	var id := _button_at(at)
	if id == "" or id in locked:
		return
	_fingers[index] = id
	held[id] = int(held.get(id, 0)) + 1
	if fresh:
		pressed_button.emit(id)
	queue_redraw()

func _finger_off(index: int) -> void:
	if not _fingers.has(index):
		return
	var id: String = _fingers[index]
	_fingers.erase(index)
	held[id] = maxi(int(held.get(id, 0)) - 1, 0)
	queue_redraw()

## กรอบสี่เหลี่ยมรอบช่องสกิลกลมกับ HYPER (ใช้วางตัวเลขคูลดาวน์) ปุ่มอื่นคืนกรอบว่าง
func cell_rect(id: String) -> Rect2:
	if (_is_slot(id) or id == "hyper") and buttons.has(id):
		var r := _radius(id)
		return Rect2(buttons[id] - Vector2.ONE * r, Vector2.ONE * r * 2.0)
	return Rect2()

const CD_SHADE := Color(0.35, 0.35, 0.38, 0.55)   # เงาเทาจางของคูลดาวน์

## เงาคูลดาวน์แบบวงกลมกวาด (Radial) เริ่มเต็มวง แล้วกวาดตามเข็มนาฬิกาจากด้านบนจนหมด  k คือส่วนที่เหลือ (0-1)
static func cd_fill(rect: Rect2, k: float) -> PackedVector2Array:
	var c := rect.get_center()
	var r := rect.size.x * 0.5
	k = clampf(k, 0.0, 1.0)
	var pts := PackedVector2Array()
	if k <= 0.0:
		return pts
	# ส่วนที่เหลืออยู่ระหว่างมุมที่กวาดผ่านแล้วไปจนครบรอบที่ด้านบน
	var start := -PI * 0.5 + TAU * (1.0 - k)
	var end := -PI * 0.5 + TAU
	var n := maxi(3, ceili(48.0 * k))
	pts.append(c)
	for i in n + 1:
		var a := lerpf(start, end, float(i) / float(n))
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	return pts

## วาดคูลดาวน์บนปุ่ม: เงากวาด + ขอบวงที่เหลือ + ตัวเลขวินาที
static func draw_cd(ci: CanvasItem, rect: Rect2, k: float, left: float) -> void:
	var pts := cd_fill(rect, k)
	if pts.size() >= 3:
		ci.draw_colored_polygon(pts, CD_SHADE)
	var c := rect.get_center()
	var r := rect.size.x * 0.5
	ci.draw_arc(c, r - 3.0, -PI * 0.5 + TAU * (1.0 - k), PI * 1.5, 40, Color(1.0, 1.0, 1.0, 0.85), 4.0, true)
	var font := Sketch.font()
	var word := "%d" % ceili(left)
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30).x
	ci.draw_string_outline(font, c + Vector2(-w * 0.5, 11.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, 6, Color(0.15, 0.13, 0.12))
	ci.draw_string(font, c + Vector2(-w * 0.5, 11.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, Color.WHITE)

## ปุ่มที่ใกล้นิ้วที่สุด พื้นที่แตะกว้างกว่าวงที่เห็นเล็กน้อย
func _button_at(at: Vector2) -> String:
	if v_on and at.distance_to(v_center) <= SLOT_RADIUS * TOUCH_GROW:
		return "v"
	var best := ""
	var best_k := INF
	for id in buttons:
		var k: float = at.distance_to(buttons[id]) / _radius(id)
		if k <= TOUCH_GROW and k < best_k:
			best_k = k
			best = id
	return best

## ปุ่ม V วงนอกคือเกจ เต็มวงแล้วเส้นหนาขึ้น
func _draw_v() -> void:
	var ready := v_stage > 0 if v_dna else v_ratio >= 1.0
	var ring := Sketch.oval(v_center, SLOT_RADIUS, SLOT_RADIUS, 40)
	draw_colored_polygon(ring, Sketch.PAPER)
	ring.append(ring[0])
	Sketch.line(self, ring, 80, RING_DOWN if ready or is_held("v") else RING, 0.5)
	for stroke in LETTERS["V"]:
		var pts := PackedVector2Array()
		for p in stroke:
			pts.append(v_center + p * GLYPH * 0.75)
		Sketch.line(self, pts, 81, 3.4, 0.3)

func _draw_captions() -> void:
	var font := Sketch.font()
	for id in CAPTION:
		if not buttons.has(id):
			continue
		var c: Vector2 = buttons[id]
		var word: String = CAPTION[id]
		var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, UiStyle.SMALL).x
		# Z X ใต้ตัวอักษรในปุ่ม  JUMP V เหนือปุ่ม
		var at := c + Vector2(-w * 0.5, _radius(id) * 0.72) if id in ["z", "x"] else c + Vector2(-w * 0.5, -_radius(id) - 10.0)
		draw_string_outline(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, UiStyle.SMALL, 6, Sketch.PAPER)
		draw_string(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, UiStyle.SMALL, Color(0.55, 0.3, 0.2))

func _draw() -> void:
	if v_on:
		_draw_v()
	var seed_no := 60
	for id in buttons:
		var c: Vector2 = buttons[id]
		var r := _radius(id)
		var empty_slot: bool = (_is_slot(id) and slot_labels[int(id.substr(1))] == "") or (id == "hyper" and not hyper_ready)
		var ring := Sketch.oval(c, r, r, 64)
		draw_colored_polygon(ring, Color(Sketch.PAPER, 0.8) if empty_slot else Sketch.PAPER)   # บังเส้นพื้นที่ลากผ่านปุ่ม
		ring.append(ring[0])
		Sketch.line(self, ring, seed_no, RING_DOWN if is_held(id) else RING, Sketch.WOBBLE, EMPTY_RING if empty_slot and not is_held(id) else Sketch.INK)
		seed_no += 10
		if id == "swap":
			var word := "แถว %d" % (row + 1)
			var w := Sketch.font().get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT).x
			draw_string(Sketch.font(), c + Vector2(-w * 0.5, SLOT_TEXT * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT, Sketch.INK)
			continue
		if id == "hyper":
			if hyper_id != "":
				SkillIcon.draw(self, c, HYPER_RADIUS * 2.0 - 10.0, hyper_id, not hyper_ready)
			var hw := Sketch.font().get_string_size("HYPER", HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT).x
			var hy := HYPER_RADIUS + SLOT_TEXT if hyper_id != "" else SLOT_TEXT * 0.36
			draw_string_outline(Sketch.font(), c + Vector2(-hw * 0.5, hy), "HYPER", HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT, 5, Sketch.PAPER)
			draw_string(Sketch.font(), c + Vector2(-hw * 0.5, hy), "HYPER", HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT, Sketch.INK if hyper_ready else EMPTY_RING)
			continue
		if id == "combo":
			var combo_w := Sketch.font().get_string_size("คอมโบ", HORIZONTAL_ALIGNMENT_LEFT, -1.0, COMBO_TEXT).x
			draw_string(Sketch.font(), c + Vector2(-combo_w * 0.5, COMBO_TEXT * 0.36), "คอมโบ", HORIZONTAL_ALIGNMENT_LEFT, -1.0, COMBO_TEXT, Sketch.INK)
			continue
		if id == "skill":
			var skill_w := Sketch.font().get_string_size("สกิล", HORIZONTAL_ALIGNMENT_LEFT, -1.0, SKILL_TEXT).x
			draw_string(Sketch.font(), c + Vector2(-skill_w * 0.5, SKILL_TEXT * 0.36), "สกิล", HORIZONTAL_ALIGNMENT_LEFT, -1.0, SKILL_TEXT, Sketch.INK)
			continue
		if _is_slot(id):
			_draw_slot(int(id.substr(1)), c)
			continue
		match id:
			"left": _word("<", c, GLYPH, seed_no)
			"back": _gear(c, seed_no)
			"right": _word(">", c, GLYPH, seed_no)
			"down": _word("V", c, GLYPH * 0.8, seed_no)
			"z": _word("Z", c, GLYPH, seed_no)
			"x": _word("X", c, GLYPH, seed_no)
			"pswap": _draw_pswap(c, seed_no)
			"jump": _word("JUMP", c, GLYPH * 0.42, seed_no)
	if captions:
		_draw_captions()

## ปุ่ม V สลับตัว ติดคูลดาวน์แล้วจางลงพร้อมตัวเลขวินาที
func _draw_pswap(c: Vector2, seed_no: int) -> void:
	var cool := pair_swap_cd > 0.0
	if cool:
		draw_circle(c, PSWAP_RADIUS - 5.0, Color(0.55, 0.62, 0.8, 0.35))
	_word("v", c, GLYPH * 0.7, seed_no)
	if cool:
		var word := str(ceili(pair_swap_cd))
		var w := Sketch.font().get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22).x
		draw_string_outline(Sketch.font(), c + Vector2(-w * 0.5, PSWAP_RADIUS + 22.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22, 5, Sketch.PAPER)
		draw_string(Sketch.font(), c + Vector2(-w * 0.5, PSWAP_RADIUS + 22.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22, Sketch.INK)

## ช่องสกิล ไอคอนเต็มช่อง ไม่มีชื่อ เลเวลไม่ถึงขึ้น Lv ทับ ติดคูลดาวน์ขึ้นวินาทีทับ
func _draw_slot(i: int, c: Vector2) -> void:
	var sid: String = slot_ids[i]
	if sid == "":
		return
	var cool: float = slot_cooldowns[i]
	var locked_slot: bool = ("s%d" % i) in locked
	SkillIcon.draw(self, c, CELL - 8.0, sid, locked_slot or cool > 0.0)
	var text := ""
	if cool > 0.0:
		text = str(ceili(cool))
	elif locked_slot:
		text = str(slot_labels[i])
	if text == "":
		return
	var w := Sketch.font().get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20).x
	draw_string_outline(Sketch.font(), c + Vector2(-w * 0.5, 7.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20, 6, Color.WHITE)
	draw_string(Sketch.font(), c + Vector2(-w * 0.5, 7.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20, Sketch.INK)

## รูปเฟืองของปุ่มตั้งค่า
func _gear(c: Vector2, seed_no: int) -> void:
	var pts := PackedVector2Array()
	for i in 33:
		var a := TAU * float(i) / 32.0
		var r := 20.0 if floori(float(i) / 2.0) % 2 == 0 else 14.0
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	Sketch.line(self, pts, seed_no, 3.0)
	var hole := Sketch.oval(c, 6.0, 6.0, 16)
	hole.append(hole[0])
	Sketch.line(self, hole, seed_no + 1, 2.6)

## เขียนคำด้วยเส้น กึ่งกลางอยู่ที่ c
func _word(word: String, c: Vector2, size_px: float, seed_no: int) -> void:
	var step := size_px * 1.9
	var x := c.x - step * (word.length() - 1) * 0.5
	for i in word.length():
		var strokes: Array = LETTERS[word[i]]
		for s in strokes.size():
			var pts := PackedVector2Array()
			for p in strokes[s]:
				pts.append(Vector2(x, c.y) + (p as Vector2) * size_px)
			Sketch.line(self, pts, seed_no + i * 3 + s, 3.0)
		x += step
