class_name RosterPage
extends Node2D
## หน้าคลังตัวละคร หน้าแรกของเกม เก็บได้ 10 ตัว แสดงทีละ 3 ใบ การ์ดกว้างเต็มพอดี 3 ใบ เกินนั้นกดลูกศรเปลี่ยนหน้า
## แตะการ์ดเพื่อเลือก กด "เล่น" เข้าเมือง การ์ด + ไปหน้าสร้างตัวละคร กด "ลบ" มีหน้าต่างถามยืนยันก่อนลบ

const PER_PAGE := 3
const CARD_H := 400.0
const CARD_GAP := 50.0
const SIDE_ROOM := 110.0          # เว้นขอบซ้ายขวาไว้ให้ลูกศรเปลี่ยนหน้า
const CARD_TOP := 110.0
const MODEL_ZOOM := 1.52
const FEET_DOWN := 290.0          # จุดยืนของตัวละครจากขอบบนการ์ด
const TITLE := "คลังตัวละคร"
const TITLE_AT := Vector2(80.0, 72.0)
const TITLE_SIZE := UiStyle.TITLE
const NAME_SIZE := 30
const CLASS_SIZE := 22
const LINE := UiStyle.LINE
const LINE_BOLD := UiStyle.LINE_BOLD + 1.0
const PLUS_SIZE := 90
const PLAY_SIZE := Vector2(300.0, 84.0)
const DEL_SIZE := Vector2(200.0, 70.0)
const CREATE_SIZE := Vector2(300.0, 84.0)
const BUTTON_Y := 0.9
const BUTTON_TEXT := UiStyle.BUTTON
const ARROW_R := 40.0
const NAMES := {"cat": "CAT BOYS", "mage": "CAT SUSI", "bow": "CAT MATCHA", "spear": "CAT CITRUS", "azure": "CAT AZURE & LAPIS", "fist": "CAT ASH"}
const ERASE := Color(0.8, 0.2, 0.15)

var list: Array = []
var page := 0
var selected := -1
var confirm_delete := false       # หน้าต่างถามยืนยันลบเปิดอยู่
var _dialog: Node2D
var _view := Vector2.ZERO
var _holders: Array = []          # [ลำดับในคลัง ตัวยึดโมเดล]

static var _warmed := false

func _ready() -> void:
	_view = get_viewport_rect().size
	# หน้าสร้างตัวละครใช้โมเดลทุกตัว สร้างผิวล่วงหน้าในเบื้องหลังไว้ก่อน กดไปหน้าสร้างแล้วไม่หน่วง
	if not _warmed:
		_warmed = true
		var styles := []
		for c in PickPage.CHOICES:
			styles.append(SkillPanel.model_style(c, ""))
		styles.append("cat_azure")
		styles.append("cat_lapis")
		ChibiModel.prewarm(styles)
	var backdrop := CatBackdrop.new()
	backdrop.show_behind_parent = true
	add_child(backdrop)
	list = SaveData.roster()
	# ตัวที่เพิ่งสร้างเลือกไว้ให้เลย
	if WalkPage.just_created >= 0 and WalkPage.just_created < list.size():
		selected = WalkPage.just_created
		page = floori(float(selected) / float(PER_PAGE))
	WalkPage.just_created = -1
	_dialog = Node2D.new()
	_dialog.z_index = 20
	_dialog.visible = false
	_dialog.draw.connect(_draw_dialog)
	add_child(_dialog)
	_build_page()

func pages() -> int:
	# การ์ด + อยู่ท้ายสุดเสมอ
	return maxi(1, ceili(float(list.size() + 1) / float(PER_PAGE)))

func card_rect(slot: int) -> Rect2:
	var w := (_view.x - SIDE_ROOM * 2.0 - float(PER_PAGE - 1) * CARD_GAP) / float(PER_PAGE)
	var x := SIDE_ROOM + float(slot) * (w + CARD_GAP)
	return Rect2(Vector2(x, CARD_TOP), Vector2(w, CARD_H))

## ลำดับในคลังของการ์ดช่องนี้ ช่องหลังตัวสุดท้ายคือการ์ด + (คืน list.size()) เกินนั้นคืน -1
func index_at(slot: int) -> int:
	var i := page * PER_PAGE + slot
	return i if i <= list.size() else -1

## ปุ่มล่าง เรียง ลบ | สร้างตัวละคร | เล่น ปุ่มสร้างอยู่กลาง เห็นตลอดไม่ว่าอยู่หน้าไหน
func create_rect() -> Rect2:
	return Rect2(Vector2(_view.x * 0.5 - CREATE_SIZE.x * 0.5, _view.y * BUTTON_Y - CREATE_SIZE.y * 0.5), CREATE_SIZE)

func play_rect() -> Rect2:
	return Rect2(Vector2(create_rect().end.x + 40.0, _view.y * BUTTON_Y - PLAY_SIZE.y * 0.5), PLAY_SIZE)

func delete_rect() -> Rect2:
	return Rect2(Vector2(create_rect().position.x - 40.0 - DEL_SIZE.x, _view.y * BUTTON_Y - DEL_SIZE.y * 0.5), DEL_SIZE)

func arrow_center(side: int) -> Vector2:
	return Vector2(_view.x * 0.5 + float(side) * (_view.x * 0.5 - 50.0), CARD_TOP + CARD_H * 0.5)

func _build_page() -> void:
	for h in _holders:
		(h[1] as Node2D).queue_free()
	_holders.clear()
	for slot in PER_PAGE:
		var i := index_at(slot)
		if i < 0 or i >= list.size():
			continue
		var entry: Dictionary = list[i]
		var holder := Node2D.new()
		var box := card_rect(slot)
		holder.position = Vector2(box.get_center().x, box.position.y + FEET_DOWN)
		holder.scale = Vector2.ONE * MODEL_ZOOM
		add_child(holder)
		var hero := Hero.new()
		hero.plain = true
		hero.plain_weapon = str(entry.get("weapon", "cat"))
		hero.set_job("boy")
		holder.add_child(hero)
		if hero.plain_weapon == "azure":
			# ตัวละครคู่ ตัวหลักอยู่หน้า อีกตัวเป็นเงาอยู่ด้านหลัง แตะสองครั้งเพื่อสลับ
			var form := str(entry.get("form", "azure"))
			hero.use_model(SkillPanel.pair_style(form, str(entry.get("class", ""))))
			var back := Hero.new()
			back.plain = true
			back.plain_weapon = "azure"
			back.set_job("boy")
			var shade := Node2D.new()
			shade.position = Vector2(78.0, -22.0)
			shade.scale = Vector2.ONE * 0.82
			holder.add_child(shade)
			holder.move_child(shade, 0)
			shade.add_child(back)
			back.use_model(SkillPanel.pair_style(SkillPanel.pair_partner(form), str(entry.get("class", ""))))
			if back.plain_model != null:
				back.plain_model.shade = PickPage.PAIR_SHADE
		else:
			hero.use_model(SkillPanel.model_style(hero.plain_weapon, str(entry.get("class", ""))))
		_holders.append([i, holder])
	queue_redraw()

func _process(_delta: float) -> void:
	for h in _holders:
		var hero := (h[1] as Node2D).get_child(0) as Hero
		if hero != null and hero.plain_model != null:
			hero.plain_model.wide_hands = PickPage.WIDE_HANDS

func play() -> void:
	if selected < 0 or selected >= list.size():
		return
	var entry: Dictionary = list[selected]
	WalkPage.chosen_weapon = str(entry.get("weapon", "cat"))
	WalkPage.chosen_class = str(entry.get("class", ""))
	WalkPage.chosen_level = int(entry.get("level", 1))
	WalkPage.pair_form = str(entry.get("form", "azure"))
	WalkPage.chosen_exp = int(entry.get("exp", 0))
	WalkPage.roster_index = selected
	WalkPage.current_town = clampi(int(entry.get("town", 0)), 0, DungeonData.town_total() - 1)
	WalkPage.trial = false
	# ตัวที่เพิ่งสร้างยังไม่ผ่านฝึกสอน ("tut" false) เข้าโหมดฝึกสอนก่อน ตัวเก่าไม่มีฟิลด์นี้ถือว่าผ่านแล้ว
	if not bool(entry.get("tut", true)):
		WalkPage.tutorial = true
		WalkPage.dungeon_town = -1
		WalkPage.dungeon_index = -1
		WalkPage.return_to = "res://roster.tscn"
		get_tree().change_scene_to_file("res://walk.tscn")
		return
	WalkPage.tutorial = false
	get_tree().change_scene_to_file("res://town.tscn")

func delete_selected() -> void:
	if selected < 0:
		return
	if not confirm_delete:
		confirm_delete = true
		_dialog.visible = true
		_dialog.queue_redraw()
		return
	SaveData.remove_character(selected)
	list = SaveData.roster()
	selected = -1
	_close_dialog()
	page = mini(page, pages() - 1)
	_build_page()

func _close_dialog() -> void:
	confirm_delete = false
	_dialog.visible = false
	queue_redraw()

func dialog_rect() -> Rect2:
	var size := Vector2(620.0, 330.0)
	return Rect2((_view - size) * 0.5, size)

func dialog_yes_rect() -> Rect2:
	var d := dialog_rect()
	return Rect2(Vector2(d.get_center().x + 20.0, d.end.y - 110.0), Vector2(220.0, 80.0))

func dialog_no_rect() -> Rect2:
	var d := dialog_rect()
	return Rect2(Vector2(d.get_center().x - 240.0, d.end.y - 110.0), Vector2(220.0, 80.0))

func tap(at: Vector2) -> void:
	# หน้าต่างถามยืนยันลบเปิดอยู่ แตะได้แค่ปุ่มในหน้าต่าง แตะนอกหน้าต่างคือยกเลิก
	if confirm_delete:
		if dialog_yes_rect().has_point(at):
			delete_selected()
		elif dialog_no_rect().has_point(at) or not dialog_rect().has_point(at):
			_close_dialog()
		return
	if play_rect().has_point(at):
		play()
		return
	if create_rect().has_point(at):
		if list.size() < SaveData.ROSTER_MAX:
			get_tree().change_scene_to_file("res://pick.tscn")
		return
	if delete_rect().has_point(at):
		delete_selected()
		return
	for side in [-1, 1]:
		if pages() > 1 and at.distance_to(arrow_center(side)) <= ARROW_R * 1.3:
			page = clampi(page + side, 0, pages() - 1)
			_build_page()
			return
	for slot in PER_PAGE:
		if not card_rect(slot).has_point(at):
			continue
		var i := index_at(slot)
		if i < 0:
			return
		if i == list.size():
			get_tree().change_scene_to_file("res://pick.tscn")
			return
		selected = i
		queue_redraw()
		return

var _last_tap_t := -10.0
var _last_tap_slot := -1

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		# แตะการ์ดตัวละครคู่สองครั้งติด สลับตัวหลัก
		for slot in PER_PAGE:
			var i := index_at(slot)
			if i >= 0 and i < list.size() and card_rect(slot).has_point(event.position) and str((list[i] as Dictionary).get("weapon", "")) == "azure":
				var now := Time.get_ticks_msec() / 1000.0
				if _last_tap_slot == slot and now - _last_tap_t < 0.4:
					var form := SkillPanel.pair_partner(str((list[i] as Dictionary).get("form", "azure")))
					SaveData.update_character(i, {"form": form})
					list = SaveData.roster()
					_build_page()
					_last_tap_slot = -1
					return
				_last_tap_t = now
				_last_tap_slot = slot
		tap(event.position)

func _box(r: Rect2, seed_no: int, width: float, color := Sketch.INK) -> void:
	if r.size.y < 100.0:
		UiStyle.fill(self, r)
	UiStyle.frame(self, r, seed_no, width, color)

func _text(at: Vector2, word: String, size: int, color := Sketch.INK) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
	draw_string(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _draw() -> void:
	draw_string(Sketch.font(), TITLE_AT, TITLE, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TITLE_SIZE, Sketch.INK)
	var count := "%d / %d" % [list.size(), SaveData.ROSTER_MAX]
	draw_string(Sketch.font(), TITLE_AT + Vector2(260.0, 0.0), count, HORIZONTAL_ALIGNMENT_LEFT, -1.0, CLASS_SIZE, TouchPad.EMPTY_RING)
	for slot in PER_PAGE:
		var i := index_at(slot)
		if i < 0:
			continue
		var box := card_rect(slot)
		if i == list.size():
			# การ์ดสร้างตัวใหม่
			if list.size() >= SaveData.ROSTER_MAX:
				continue
			UiStyle.fill(self, box, Color(1.0, 1.0, 1.0, 0.55))
			_box(box, 600 + slot, LINE, TouchPad.EMPTY_RING)
			_text(box.get_center() + Vector2(0.0, -30.0), "+", PLUS_SIZE)
			_text(box.get_center() + Vector2(0.0, 60.0), "สร้างตัวละคร", NAME_SIZE)
			continue
		var entry: Dictionary = list[i]
		UiStyle.fill(self, box, UiStyle.PICKED if i == selected else UiStyle.PAPER)
		if i == selected:
			UiStyle.paw(self, box.position + Vector2(box.size.x - 26.0, 26.0), 18.0)
		_box(box, 600 + slot, LINE_BOLD if i == selected else LINE)
		var weapon := str(entry.get("weapon", "cat"))
		var cls := str(entry.get("class", ""))
		_text(Vector2(box.get_center().x, box.position.y + FEET_DOWN + 45.0), NAMES.get(weapon, weapon), NAME_SIZE)
		_text(Vector2(box.get_center().x, box.position.y + FEET_DOWN + 85.0), "%s    Lv.%d" % [cls if cls != "" else "BASIC", int(entry.get("level", 1))], CLASS_SIZE)
	if pages() > 1:
		for side in [-1, 1]:
			var c := arrow_center(side)
			var on: bool = (side < 0 and page > 0) or (side > 0 and page < pages() - 1)
			var color := Sketch.INK if on else TouchPad.EMPTY_RING
			Sketch.line(self, PackedVector2Array([c + Vector2(-side * 12.0, -22.0), c + Vector2(side * 12.0, 0.0), c + Vector2(-side * 12.0, 22.0)]), 620 + side, LINE_BOLD * 0.7, Sketch.WOBBLE, color)
	var has := selected >= 0
	var play_color := Sketch.INK if has else TouchPad.EMPTY_RING
	_box(play_rect(), 630, LINE_BOLD * 0.6, play_color)
	_text(play_rect().get_center(), "เล่น", BUTTON_TEXT, play_color)
	var room := list.size() < SaveData.ROSTER_MAX
	var create_color := Sketch.INK if room else TouchPad.EMPTY_RING
	_box(create_rect(), 632, LINE_BOLD * 0.6, create_color)
	_text(create_rect().get_center(), "สร้างตัวละคร" if room else "คลังเต็ม", BUTTON_TEXT, create_color)
	var del_color := Sketch.INK if has else TouchPad.EMPTY_RING
	_box(delete_rect(), 631, LINE, del_color)
	_text(delete_rect().get_center(), "ลบ", BUTTON_TEXT - 6, del_color)

## หน้าต่างถามยืนยันก่อนลบ บอกชื่อและคลาสของตัวที่จะลบ
func _draw_dialog() -> void:
	if selected < 0 or selected >= list.size():
		return
	_dialog.draw_rect(Rect2(Vector2.ZERO, _view), Color(1.0, 0.98, 0.94, 0.7))
	var d := dialog_rect()
	UiStyle.fill(_dialog, d, Color.WHITE)
	_dbox(d, 640, LINE_BOLD * 0.7, Sketch.INK)
	var entry: Dictionary = list[selected]
	var weapon := str(entry.get("weapon", "cat"))
	var cls := str(entry.get("class", ""))
	_dtext(Vector2(d.get_center().x, d.position.y + 70.0), "ลบตัวละครนี้ใช่ไหม?", 38, Sketch.INK)
	_dtext(Vector2(d.get_center().x, d.position.y + 135.0), "%s  %s" % [NAMES.get(weapon, weapon), cls if cls != "" else "BASIC"], 28, Sketch.INK)
	_dtext(Vector2(d.get_center().x, d.position.y + 180.0), "ลบแล้วกู้คืนไม่ได้", 22, ERASE)
	_dbox(dialog_no_rect(), 641, LINE, Sketch.INK)
	_dtext(dialog_no_rect().get_center(), "ยกเลิก", 32, Sketch.INK)
	UiStyle.fill(_dialog, dialog_yes_rect(), Color(1.0, 0.92, 0.9))
	_dbox(dialog_yes_rect(), 642, LINE_BOLD * 0.6, ERASE)
	_dtext(dialog_yes_rect().get_center(), "ลบ", 32, ERASE)

func _dbox(r: Rect2, seed_no: int, width: float, color: Color) -> void:
	UiStyle.frame(_dialog, r, seed_no, width, color)

func _dtext(at: Vector2, word: String, size: int, color: Color) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
	_dialog.draw_string(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)
