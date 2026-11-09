class_name TutorialGuide
extends Node2D
## โหมดฝึกสอนของตัวละครที่เพิ่งสร้าง (WalkPage.tutorial)
## สอนทีละขั้น แต่ละขั้นผ่านเมื่อทำจริง: เดิน วิ่ง กระโดด กระโดดซ้ำ คอมโบ z คอมโบ x ท่าแดช ท่ากลางอากาศ สกิล ตกเร็ว ปราบมอน 3 ตัว
## จบแล้วได้เลเวลอย่างน้อย 5 บันทึกว่าผ่านฝึกสอน แล้วไปหน้าเมือง  กดข้ามได้ ได้เลเวล 5 เหมือนกัน

const FINISH_LEVEL := 5
const CARD_W := 700.0
const CARD_H := 150.0
const CARD_Y := 100.0
const CARD_CX := 885.0           # กึ่งกลางการ์ด ไม่ทับการ์ดเลือดซ้ายบนกับปุ่มขวาบน
const SKIP_SIZE := Vector2(150.0, 60.0)
const RING := Color(1.0, 0.62, 0.35)
const DONE_HOLD := 0.7            # ผ่านขั้นแล้วโชว์ "เยี่ยม!" แป๊บหนึ่งก่อนไปขั้นถัดไป
const END_HOLD := 2.2

var page: WalkPage
var steps: Array = []             # [{"id", "title", "text", "ring"}]
var index := 0
var _t := 0.0
var _done_t := -1.0               # >= 0 ขั้นนี้ผ่านแล้ว กำลังโชว์ "เยี่ยม!"
var _end_t := -1.0                # >= 0 จบฝึกสอน กำลังฉลอง
var _x0 := 0.0
var _seen_start := false
var _changes := 0
var _last_combo := ""
var _mp0 := 0.0
var _air_t := 0.0
var _kills := 0
var _spawned := false
var _finished := false

func setup(p: WalkPage) -> void:
	page = p
	z_index = 60
	var w := WalkPage.chosen_weapon
	var z_hint := _hint("z")
	var x_hint := _hint("x")
	steps = [
		{"id": "walk", "title": "เดิน", "text": "แตะจอยฝั่งซ้ายแล้วลากไปซ้ายหรือขวา เพื่อเดิน", "ring": "joy"},
		{"id": "run", "title": "วิ่ง", "text": "ดันจอยไปจนสุดขอบ ตัวละครจะออกวิ่ง", "ring": "joy"},
		{"id": "jump", "title": "กระโดด", "text": "กดปุ่ม JUMP เพื่อกระโดด", "ring": "jump"},
	]
	if w == "bow" or w == "spear":
		steps.append({"id": "double", "title": "กระโดดซ้ำ", "text": "กระโดดแล้วกด JUMP อีกครั้งกลางอากาศ", "ring": "jump"})
	steps.append_array([
		{"id": "zchain", "title": "คอมโบ Z", "text": "กด Z ต่อกันหลายครั้ง  " + z_hint, "ring": "z"},
		{"id": "xchain", "title": "คอมโบ X", "text": "กด X ต่อกันหลายครั้ง  " + x_hint, "ring": "x"},
		{"id": "dash", "title": "ท่าแดช >>z", "text": "ดันจอยสุดขอบให้วิ่ง แล้วกด Z ระหว่างวิ่ง", "ring": "z"},
		{"id": "air", "title": "ท่ากลางอากาศ", "text": "กระโดด แล้วกด Z หรือ X กลางอากาศ", "ring": "x"},
		{"id": "fall", "title": "ตกเร็ว", "text": "กระโดด แล้วดึงจอยลงค้างไว้ จะลงถึงพื้นเร็วขึ้น", "ring": "joy"},
	])
	if _give_skill() != "":
		steps.append({"id": "skill", "title": "ใช้สกิล", "text": "แตะช่องสกิลที่เรืองอยู่ เพื่อใช้สกิล", "ring": "s0"})
	steps.append({"id": "fight", "title": "ลองสู้จริง", "text": "ปราบมอนสเตอร์ให้ครบ 3 ตัว", "ring": ""})
	_begin()

## คำใบ้คอมโบจากรายการ BASIC ของตัวละคร
func _hint(button: String) -> String:
	var rows: Array = []
	match WalkPage.chosen_weapon:
		"mage":
			rows = ComboPanel.MAGE_COMBOS
		"bow":
			rows = ComboPanel.BOW_COMBOS
		"spear":
			rows = ComboPanel.SPEAR_COMBOS
		"fist":
			rows = ComboPanel.FIST_COMBOS
		"azure":
			rows = ComboPanel.PAIR_AZURE if WalkPage.pair_form == "azure" else ComboPanel.PAIR_LAPIS
		_:
			rows = ComboPanel.COMBOS
	for r in rows:
		var key := str(r[0])
		if key.length() >= 2 and key.replace(button, "") == "":
			return "(%s %s)" % [key, str(r[1])]
	return ""

## ใส่สกิลแรกของตัวละครลงช่อง 1 ถ้ายังว่าง คืนรหัสสกิล (ไม่มีสกิลคืนค่าว่าง)
func _give_skill() -> String:
	var slots: Array = page._slots()
	for id in slots:
		if str(id) != "":
			return str(id)
	var list: Array = SkillPanel.SKILLS.get(WalkPage.chosen_weapon, [])
	for s in list:
		var info: Dictionary = s
		var id := str(info.get("id", ""))
		if id == "" or info.get("passive", false) or id.ends_with("_hyper"):
			continue
		if SkillPanel.need_level(info) > max(WalkPage.chosen_level, 1):
			continue
		slots[0] = id
		page._refresh_slot()
		return id
	return ""

func _begin() -> void:
	_t = 0.0
	_done_t = -1.0
	_x0 = page.hero.pos.x
	_seen_start = false
	_changes = 0
	_last_combo = page.combo_name
	_mp0 = page.hero.mp
	_air_t = 0.0
	queue_redraw()

func step_id() -> String:
	return str((steps[index] as Dictionary)["id"]) if index < steps.size() else ""

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()
	if _end_t >= 0.0:
		_end_t += delta
		if _end_t >= END_HOLD and not _finished:
			_go_town()
		return
	if _done_t >= 0.0:
		_done_t += delta
		if _done_t >= DONE_HOLD:
			index += 1
			if index >= steps.size():
				finish()
			else:
				_begin()
		return
	if _check(delta):
		_done_t = 0.0

func _start_id(state: String, button: String) -> String:
	if WalkPage.chosen_weapon in ["mage", "bow", "spear", "fist", "azure"]:
		return page._table_start(state, button)
	if state == "dash":
		return "dz1" if button == "z" else "dx"
	return "z1" if button == "z" else "x1"

func _count_changes(start_id: String) -> bool:
	var now := page.combo_name
	if now != _last_combo:
		_last_combo = now
		if now == start_id:
			_seen_start = true
			_changes = 1
		elif now != "" and _seen_start:
			_changes += 1
	return _changes >= 3

func _check(delta: float) -> bool:
	var h := page.hero
	match step_id():
		"walk":
			return absf(h.pos.x - _x0) >= 2.0
		"run":
			return h.dash_t > 0.0 and h.input_dir != 0.0
		"jump":
			return not h.on_floor() and h.vel.y > 0.0
		"double":
			return page._double_jumped
		"zchain":
			return _count_changes(_start_id("ground", "z"))
		"xchain":
			return _count_changes(_start_id("ground", "x"))
		"dash":
			var id := _start_id("dash", "z")
			return page.combo_name != "" and page.combo_name == id
		"air":
			return page.combo_nth >= 0 and page._combo_air
		"fall":
			if h.fast_fall and not h.on_floor():
				_air_t += delta
			return _air_t >= 0.15
		"skill":
			for k in page.skill_cds.keys():
				if float(page.skill_cds[k]) > 0.0:
					return true
			return h.mp < _mp0 - 0.5
		"fight":
			if not _spawned:
				_spawn_three()
			return _kills >= 3
	return false

func _spawn_three() -> void:
	_spawned = true
	for i in 3:
		var m := Monster.new()
		m.role = "hopper"
		m.look = "cat_mochi"
		var x := page.hero.pos.x + (3.5 + float(i) * 1.6) * (1.0 if page.hero.pos.x < 0.0 else -1.0)
		m.pos = Vector2(clampf(x, -page.hero.half_width + 0.5, page.hero.half_width - 0.5), 3.0)
		m.max_hp = 40.0
		m.hp = m.max_hp
		m.half_width = page.hero.half_width
		m.hero = page.hero
		m.ai_cool = randf_range(1.0, 2.0)
		m.died.connect(func(_m = null) -> void: _kills += 1)
		page.world.add_child(m)

## จบฝึกสอน ได้เลเวลอย่างน้อย 5 บันทึก แล้วฉลองก่อนไปเมือง
func finish() -> void:
	if _end_t >= 0.0:
		return
	_end_t = 0.0
	var lv := maxi(WalkPage.chosen_level, FINISH_LEVEL)
	var leveled := lv != WalkPage.chosen_level
	WalkPage.chosen_level = lv
	if page.bars != null:
		page.bars.level = lv
		page.bars.queue_redraw()
	if leveled:
		WalkPage.chosen_exp = 0
	if WalkPage.roster_index >= 0:
		var fields := {"level": lv, "tut": true}
		if leveled:
			fields["exp"] = 0
		SaveData.update_character(WalkPage.roster_index, fields)
	queue_redraw()

func skip() -> void:
	finish()
	_end_t = END_HOLD * 0.6

func _go_town() -> void:
	_finished = true
	WalkPage.tutorial = false
	WalkPage.current_town = 0
	if WalkPage.roster_index >= 0:
		SaveData.update_character(WalkPage.roster_index, {"town": 0})
	if is_inside_tree():
		get_tree().change_scene_to_file("res://town.tscn")

## ออกจากหน้า (ย้อนกลับ) ไม่ค้างโหมดฝึกสอนไปหน้าอื่น เข้าใหม่จากคลังก็กลับมาฝึกสอนต่อเอง
func _exit_tree() -> void:
	WalkPage.tutorial = false

func _cx(view: Vector2) -> float:
	return CARD_CX * view.x / 1560.0

func skip_rect() -> Rect2:
	var view := get_viewport_rect().size
	return Rect2(Vector2(_cx(view) + CARD_W * 0.5 - SKIP_SIZE.x - 18.0, CARD_Y + CARD_H - SKIP_SIZE.y - 14.0), SKIP_SIZE)

func _input(event: InputEvent) -> void:
	if _end_t >= 0.0:
		return
	var at := Vector2(-1.0, -1.0)
	if event is InputEventScreenTouch and event.pressed:
		at = event.position
	elif event is InputEventMouseButton and event.pressed:
		at = event.position
	if at.x >= 0.0 and skip_rect().has_point(at):
		skip()
		get_viewport().set_input_as_handled()

func _ring_center() -> Array:
	if index >= steps.size():
		return []
	var id := str((steps[index] as Dictionary)["ring"])
	if id == "":
		return []
	if id == "joy":
		return [page.joy.position, Joystick.RADIUS + 18.0]
	if page.pad.buttons.has(id):
		return [page.pad.buttons[id] as Vector2, page.pad._radius(id) + 14.0]
	return []

func _draw() -> void:
	var view := get_viewport_rect().size
	var card := Rect2(Vector2(_cx(view) - CARD_W * 0.5, CARD_Y), Vector2(CARD_W, CARD_H))
	if _end_t >= 0.0:
		var big := Rect2(Vector2(view.x * 0.5 - 420.0, view.y * 0.5 - 130.0), Vector2(840.0, 220.0))
		UiStyle.box(self, big, 71, UiStyle.LINE_BOLD, UiStyle.INK, UiStyle.PICKED)
		UiStyle.text(self, big.position + Vector2(big.size.x * 0.5, 70.0), "จบการฝึกสอนแล้ว!", UiStyle.TITLE)
		UiStyle.text(self, big.position + Vector2(big.size.x * 0.5, 135.0), "ได้เลเวล %d  กำลังไปที่เมือง..." % WalkPage.chosen_level, UiStyle.NAME)
		UiStyle.paw(self, big.position + Vector2(60.0, 60.0), 26.0)
		UiStyle.paw(self, big.end - Vector2(60.0, 60.0), 26.0)
		return
	if index >= steps.size():
		return
	var s: Dictionary = steps[index]
	UiStyle.box(self, card, 70, UiStyle.LINE_BOLD, UiStyle.INK, UiStyle.PAPER)
	UiStyle.paw(self, card.position + Vector2(40.0, 40.0), 20.0)
	var head := "ฝึกสอน %d/%d  %s" % [index + 1, steps.size(), str(s["title"])]
	if _done_t >= 0.0:
		head = "เยี่ยม!"
	UiStyle.text(self, card.position + Vector2(CARD_W * 0.5, 42.0), head, UiStyle.NAME)
	var body := str(s["text"])
	if str(s["id"]) == "fight":
		body += "  (%d/3)" % mini(_kills, 3)
	UiStyle.text(self, card.position + Vector2(CARD_W * 0.5 - SKIP_SIZE.x * 0.5, 100.0), body, UiStyle.BODY, UiStyle.INK, CARD_W - SKIP_SIZE.x - 60.0)
	UiStyle.button(self, skip_rect(), "ข้าม", 72)
	# วงเรืองที่ปุ่มที่ต้องกด กะพริบเบาๆ
	var ring := _ring_center()
	if not ring.is_empty() and _done_t < 0.0:
		var pulse := 0.6 + 0.4 * sin(_t * 6.0)
		draw_arc(ring[0], float(ring[1]) + 4.0 * pulse, 0.0, TAU, 48, Color(RING, 0.85 * pulse), 7.0, true)
