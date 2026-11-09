class_name TouchPad
extends Node2D
## ปุ่ม < > Z X JUMP และช่องสกิล 8 ช่อง 2 แถวกลางล่างจอ มี HYPER ต่อท้าย วาดด้วยเส้น กดหลายปุ่มพร้อมกันได้ เมาส์ก็ใช้ได้
## กดอยู่แล้วเส้นขอบหนาขึ้น

signal pressed_button(id: String)

const RADIUS := 66.0
const RING := 3.0
const RING_DOWN := 6.5
const GLYPH := 26.0
const EDGE := 34.0
const LOW := 96.0
const GAP := 26.0
const SLOT_RADIUS := 44.0
const DOWN_RADIUS := 50.0
const SLOTS := 8               # ช่องสกิล 2 แถว แถวละ 4 กลางล่างจอ
const SLOT_COLS := 4
const SLOT_GAP := 0.0           # ช่องสี่เหลี่ยมติดกันเป็นตาราง
const CELL := 84.0              # ด้านของช่องสกิลสี่เหลี่ยม
const SLOT_LOW := 20.0          # ช่องแถวล่างห่างขอบล่างจอ
const JUMP_RADIUS := 46.0       # ปุ่ม JUMP เล็กกว่าปุ่มอื่น
const PSWAP_RADIUS := 46.0      # ปุ่ม V สลับตัว เล็กเท่าปุ่ม JUMP
const SLOT_TEXT := 18
const SKILL_TEXT := 24
const COMBO_TEXT := UiStyle.SMALL
const SWAP_RADIUS := 36.0
const HYPER_RADIUS := 38.0
const HYPER_AT := Vector2(103.0, 108.0)   # มุมองศา ระยะจากกึ่งกลางปุ่ม Z X อยู่ช่องว่างระหว่างปุ่มกับช่องสกิล
const SWAP_LEFT := 100.0        # ปุ่มสลับแถว อยู่ซ้ายช่องสกิลล่างสุด
const EMPTY_RING := Color(0.16, 0.15, 0.14, 0.35)
const V_LEFT := 100.0            # ปุ่ม V อยู่หน้าปุ่มแถว

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
var slot_labels := ["", "", "", "", "", "", "", ""]
var slot_ids := ["", "", "", "", "", "", "", ""]   # รหัสสกิลในแต่ละช่อง ใช้วาดไอคอน
var hyper_id := ""
var hyper_ready := false         # คลาสนี้มี HYPER ใช้ปุ่มแยก
var slot_cooldowns := [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var row := 0                    # แถวสกิลที่แสดงอยู่
var pair_swap_on := false        # ปุ่ม V สลับตัว AZURE/LAPIS อยู่หน้าปุ่ม Z
var pair_swap_cd := 0.0          # คูลดาวน์ที่เหลือ วินาที
var v_on := false               # ปุ่ม V ของโฮมุนครุส
var v_ratio := 0.0              # เกจเทียบค่าใช้ 1 คือพร้อมยิง
var v_center := Vector2.ZERO
var v_dna := false              # เกจรูป DNA ของ ROGUE MEDIC
var v_stage := 0

## จัดตำแหน่งตามขนาดจอจริง
func layout(view: Vector2) -> void:
	var y := view.y - LOW
	buttons = {
		"left": Vector2(EDGE + RADIUS, y),
		"right": Vector2(EDGE + RADIUS * 3.0 + GAP, y),
		"x": Vector2(view.x - EDGE - RADIUS, y),
		"z": Vector2(view.x - EDGE - RADIUS * 3.0 - GAP, y),
		"jump": Vector2(view.x - EDGE - RADIUS, y - RADIUS - GAP - JUMP_RADIUS),
	}
	if pair_swap_on:
		buttons["pswap"] = buttons["z"] + Vector2(-RADIUS - GAP - PSWAP_RADIUS, RADIUS - PSWAP_RADIUS)
	stick_home = (buttons["left"] + buttons["right"]) * 0.5 + Vector2(0.0, -30.0)
	if use_stick:
		buttons.erase("left")
		buttons.erase("right")
	elif show_down:
		buttons["down"] = (buttons["left"] + buttons["right"]) * 0.5 + Vector2(0.0, -RADIUS * 1.75)
	# ช่องสกิล 2 แถว แถวละ 4 กลางล่างจอ HYPER ต่อท้ายทางขวา อยู่กึ่งกลางระหว่างสองแถว
	# ตารางช่องสี่เหลี่ยม 4 x 2 ติดกัน HYPER เป็นช่องสูงสองแถวติดด้านขวา
	var total := CELL * float(SLOT_COLS + 1)
	var x0 := view.x * 0.5 - total * 0.5 + CELL * 0.5
	var low := view.y - SLOT_LOW - CELL * 0.5
	for i in SLOTS:
		var col := i % SLOT_COLS
		var line := floori(float(i) / float(SLOT_COLS))
		buttons["s%d" % i] = Vector2(x0 + CELL * float(col), low - CELL * float(1 - line))
	# HYPER ช่องเดียวต่อท้ายแถวล่าง
	buttons["hyper"] = Vector2(x0 + CELL * float(SLOT_COLS), low)
	v_center = buttons["s0"] + Vector2(-CELL * 1.2, -CELL * 0.5)
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

## ช่องสกิลกับ HYPER เป็นสี่เหลี่ยม คืนกรอบ ปุ่มอื่นคืนกรอบว่าง
func cell_rect(id: String) -> Rect2:
	if _is_slot(id):
		return Rect2(buttons[id] - Vector2.ONE * CELL * 0.5, Vector2.ONE * CELL)
	if id == "hyper":
		return Rect2(buttons[id] - Vector2.ONE * CELL * 0.5, Vector2.ONE * CELL)
	return Rect2()

func _button_at(at: Vector2) -> String:
	if v_on and at.distance_to(v_center) <= SLOT_RADIUS:
		return "v"
	for id in buttons:
		var cell := cell_rect(id)
		if cell.size != Vector2.ZERO:
			if cell.has_point(at):
				return id
		elif at.distance_to(buttons[id]) <= _radius(id):
			return id
	return ""

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
		var cell := cell_rect(id)
		if cell.size != Vector2.ZERO:
			# ช่องสี่เหลี่ยมติดกัน
			draw_rect(cell, Sketch.PAPER)
			var a := cell.position
			var b := cell.end
			Sketch.line(self, PackedVector2Array([a, Vector2(b.x, a.y), b, Vector2(a.x, b.y), a]), seed_no, RING_DOWN if is_held(id) else RING * 0.8, Sketch.WOBBLE * 0.4, EMPTY_RING if empty_slot and not is_held(id) else Sketch.INK)
		else:
			var ring := Sketch.oval(c, r, r, 64)
			draw_colored_polygon(ring, Sketch.PAPER)   # บังเส้นพื้นที่ลากผ่านปุ่ม
			ring.append(ring[0])
			Sketch.line(self, ring, seed_no, RING_DOWN if is_held(id) else RING, Sketch.WOBBLE, EMPTY_RING if empty_slot else Sketch.INK)
		seed_no += 10
		if id == "swap":
			var word := "แถว %d" % (row + 1)
			var w := Sketch.font().get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT).x
			draw_string(Sketch.font(), c + Vector2(-w * 0.5, SLOT_TEXT * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, SLOT_TEXT, Sketch.INK)
			continue
		if id == "hyper":
			if hyper_id != "":
				SkillIcon.draw(self, c, CELL - 10.0, hyper_id, not hyper_ready)
			var hw := Sketch.font().get_string_size("HYPER", HORIZONTAL_ALIGNMENT_LEFT, -1.0, COMBO_TEXT).x
			draw_string_outline(Sketch.font(), c + Vector2(-hw * 0.5, 32.0 if hyper_id != "" else COMBO_TEXT * 0.36), "HYPER", HORIZONTAL_ALIGNMENT_LEFT, -1.0, COMBO_TEXT, 5, Sketch.PAPER)
			draw_string(Sketch.font(), c + Vector2(-hw * 0.5, 32.0 if hyper_id != "" else COMBO_TEXT * 0.36), "HYPER", HORIZONTAL_ALIGNMENT_LEFT, -1.0, COMBO_TEXT, Sketch.INK if hyper_ready else EMPTY_RING)
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
	_draw_grid_frame()
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

## กรอบนอกของตารางช่องสกิลกับ HYPER ให้เห็นเป็นแผงเดียว
func _draw_grid_frame() -> void:
	if not buttons.has("s0") or not buttons.has("hyper"):
		return
	var a: Vector2 = cell_rect("s0").position
	var b: Vector2 = cell_rect("s7").end
	UiStyle.frame(self, Rect2(a, b - a), 990, RING, Sketch.INK, 10.0)
	UiStyle.frame(self, cell_rect("hyper"), 991, RING, Sketch.INK, 10.0)

## ช่องสกิล ไอคอนเต็มช่อง ไม่มีชื่อ เลเวลไม่ถึงขึ้น Lv ทับ ติดคูลดาวน์ขึ้นวินาทีทับ
func _draw_slot(i: int, c: Vector2) -> void:
	var sid: String = slot_ids[i]
	if sid == "":
		return
	var cool: float = slot_cooldowns[i]
	var locked_slot: bool = ("s%d" % i) in locked
	SkillIcon.draw(self, c, CELL - 10.0, sid, locked_slot or cool > 0.0)
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
