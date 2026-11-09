class_name PickPage
extends Node2D
## หน้าสร้างตัวละคร พื้นขาว ตัวละครอยู่กลางจอ แตะเลือกแล้วตัวนั้นเลื่อนไปซ้าย ตัวอื่นหาย ทางขวาแสดงสายคลาสให้เลือก
## ปุ่มย้อนกลับพากลับไปเลือกตัวใหม่ ยังไม่เลือกตัวกลับหน้าคลัง
## กด "สร้างตัวละคร" เก็บตัวนี้เข้าคลังเป็น BASIC เลเวล 1 แล้วไปหน้าคลัง กด "ทดลองเล่น" เข้าหน้าฝึกซ้อมโดยไม่เก็บ

# ซ่อน ASH ("fist"), AZURE & LAPIS ("azure") ไว้ก่อน ยังไม่เปิดให้เล่น
const CHOICES := ["cat", "mage", "bow", "spear"]
const X_AT := [0.14, 0.38, 0.62, 0.86, 1.1]
const PAIR_SHADE := Color(0.32, 0.38, 0.6, 0.85)   # ตัวรองของตัวละครคู่เป็นเงา
const SLOT_W := 0.24             # ระยะห่างตัวละคร (สัดส่วนจอ) ลากเลื่อนซ้ายขวาได้
const PICKED_X := 0.25           # ตัวที่เลือกเลื่อนมาตรงนี้
const SLIDE_TIME := 0.25
const BACK_CENTER := Vector2(78.0, 78.0)
const BACK_RADIUS := 44.0
const BACK_GLYPH := 18.0
const GROUND_AT := 0.72
const ZOOM := 1.99
const PICK_RADIUS := 225.0       # พื้นที่แตะเลือก และวงที่บอกว่าเลือกตัวนี้อยู่
const PICK_UP := 95.0            # กึ่งกลางวง เทียบจุดยืน หน่วยเป็นจุดก่อนซูม
const PICK_RING := 5.0
const WIDE_HANDS := 1.9          # มือห่างจากตัวมากขึ้นในหน้านี้
# โหมดทดสอบ สร้างตัวแล้วเป็นเลเวล 99 เลย (ตอนเปิดเกมจริงเปลี่ยนกลับเป็น 1)
const TEST_START_LEVEL := 1
const NAMES := {"cat": "CAT BOYS", "mage": "CAT SUSI", "bow": "CAT MATCHA", "spear": "CAT CITRUS", "azure": "CAT AZURE & LAPIS", "fist": "CAT ASH"}
# ผังคลาส กล่อง กว้าง สูง และเส้นโยงจากคลาสแม่
const CLASS_BOX := {
	"BOYS": Rect2(680.0, 228.0, 110.0, 70.0),
	"BASIC": Rect2(680.0, 228.0, 140.0, 70.0),
	"APPRENTICE": Rect2(680.0, 228.0, 220.0, 70.0),
	"SWORD KNIGHT": Rect2(880.0, 78.0, 270.0, 70.0),
	"GRAND KNIGHT": Rect2(1190.0, 78.0, 260.0, 70.0),
	"FLAME KNIGHT": Rect2(1190.0, 178.0, 260.0, 70.0),
	"GUARDIAN KNIGHT": Rect2(1190.0, 278.0, 300.0, 70.0),
	"CRIMSON KNIGHT": Rect2(1190.0, 378.0, 290.0, 70.0),
	"WARLORD": Rect2(1150.0, 78.0, 180.0, 70.0),
	"MAGIC KNIGHT": Rect2(880.0, 178.0, 270.0, 70.0),
	"SHIELD KNIGHT": Rect2(880.0, 278.0, 270.0, 70.0),
	"MAGUS": Rect2(1150.0, 178.0, 150.0, 70.0),
	"DARK KNIGHT": Rect2(880.0, 378.0, 270.0, 70.0),
	"ABYSS": Rect2(1150.0, 278.0, 150.0, 70.0),
	"DIVINE KNIGHT": Rect2(840.0, 378.0, 270.0, 70.0),
	"ARCH MAGE": Rect2(880.0, 78.0, 270.0, 70.0),
	"BATTLE MAGE": Rect2(880.0, 178.0, 270.0, 70.0),
	"DARK MAGE": Rect2(880.0, 278.0, 270.0, 70.0),
	"ALCHEMIST MAGE": Rect2(880.0, 378.0, 270.0, 70.0),
	"ELEMENT MASTER": Rect2(1190.0, 78.0, 300.0, 70.0),
	"DIMENSION CASTER": Rect2(1190.0, 178.0, 320.0, 70.0),
	"ECLIPSE": Rect2(1190.0, 278.0, 200.0, 70.0),
	"TRANSMUTATION MASTER": Rect2(1190.0, 378.0, 350.0, 70.0),
	"WINDSTARKER": Rect2(880.0, 78.0, 270.0, 70.0),
	"SNIPESTARKER": Rect2(880.0, 178.0, 270.0, 70.0),
	"MANASTARKER": Rect2(880.0, 278.0, 270.0, 70.0),
	"TRAPSTARKER": Rect2(880.0, 378.0, 270.0, 70.0),
	"GALE TEMPEST": Rect2(1190.0, 78.0, 280.0, 70.0),
	"APEX SNIPER": Rect2(1190.0, 178.0, 260.0, 70.0),
	"ESSENCE WEAVER": Rect2(1190.0, 278.0, 330.0, 70.0),
	"TWILIGHT": Rect2(1190.0, 378.0, 200.0, 70.0),
	"PETIT TIGER": Rect2(880.0, 78.0, 270.0, 70.0),
	"PETIT FANG": Rect2(880.0, 178.0, 270.0, 70.0),
	"PETIT VIXEN": Rect2(880.0, 278.0, 270.0, 70.0),
	"PETIT SHELL": Rect2(880.0, 378.0, 270.0, 70.0),
	"FIERCE PROWLER": Rect2(1190.0, 78.0, 300.0, 70.0),
	"LUPINE DIRE": Rect2(1190.0, 178.0, 250.0, 70.0),
	"PHANTOM VULPINE": Rect2(1190.0, 278.0, 330.0, 70.0),
	"GENBU TITAN": Rect2(1190.0, 378.0, 260.0, 70.0),
	# CAT ASH
	"HEAVYWEIGHT": Rect2(870.0, 78.0, 320.0, 70.0),
	"ZEPHYR": Rect2(870.0, 178.0, 320.0, 70.0),
	"WAR MUAY": Rect2(870.0, 278.0, 320.0, 70.0),
	"SYSTEMA GRAPPLER": Rect2(870.0, 378.0, 320.0, 70.0),
	"GRAND SUMO": Rect2(1230.0, 78.0, 270.0, 70.0),
	"KUNG FU": Rect2(1230.0, 178.0, 230.0, 70.0),
	"MUAY THAI": Rect2(1230.0, 278.0, 250.0, 70.0),
	"SAMBO": Rect2(1230.0, 378.0, 210.0, 70.0),
	"SPARK DREAMER": Rect2(880.0, 128.0, 290.0, 70.0),
	"SPARK FIEND": Rect2(880.0, 328.0, 270.0, 70.0),
	"SOMNAMBULIST": Rect2(1190.0, 128.0, 290.0, 70.0),
	"NEON BOLT": Rect2(1190.0, 328.0, 240.0, 70.0),
	"GODHOOD": Rect2(1150.0, 378.0, 180.0, 70.0),
}
const CLASS_TEXT := 28
const CLASS_LINE := UiStyle.LINE
const CLASS_LINE_BOLD := UiStyle.LINE_BOLD + 1.0
const CLASS_TITLE_AT := Vector2(680.0, 72.0)
const CLASS_TITLE_SIZE := 36
const NO_CLASS_AT := Vector2(680.0, 260.0)
const NAME_SIZE := 40
const NAME_BELOW := 46.0
const BUTTON_SIZE := Vector2(360.0, 84.0)
const BUTTON_Y := 0.89
const BUTTON_LINE := 4.0
const BUTTON_TEXT := "สร้างตัวละคร"
const TRY_TEXT := "ทดลองเล่น"
const BUTTON_GAP := 40.0
const SHOW_TRY := false          # ปุ่มทดลองเล่น ปิดไว้ (เปิดกลับได้)
const BUTTON_TEXT_SIZE := 38

var heroes := {}
var holders: Array = []
var selected := ""
var chosen_class := ""
var _view := Vector2.ZERO
var _done := false
var spin := 0.0                  # ลากนิ้วบนตัวละครเพื่อหมุนดู องศา
var _full_t := 0.0               # แสดงข้อความคลังเต็ม
const SPIN_PER_PX := 0.6

func _ready() -> void:
	_view = get_viewport_rect().size
	var backdrop := CatBackdrop.new()
	backdrop.show_behind_parent = true
	add_child(backdrop)
	for i in CHOICES.size():
		var holder := Node2D.new()
		holder.position = _spot(i)
		holder.scale = Vector2.ONE * ZOOM
		add_child(holder)
		holders.append(holder)
		var hero := Hero.new()
		hero.plain = true
		hero.plain_weapon = CHOICES[i]
		hero.set_job("boy")
		holder.add_child(hero)
		hero.use_model(SkillPanel.model_style(CHOICES[i], ""))
		heroes[CHOICES[i]] = hero
		if CHOICES[i] == "azure":
			_add_partner(holder)

var _scroll := 0.0
var _partner: Hero
var _press_at := Vector2.ZERO
var _dragged := false
var _pressed_here := false        # นิ้วกดลงในหน้านี้จริง กันนิ้วที่ปล่อยค้างจากหน้าก่อน (ปุ่มกลับของห้องฝึก) ไปเลือกตัว
var _last_tap := -10.0

## ตัวละครคู่ อีกตัวยืนเป็นเงาด้านหลัง
func _add_partner(holder: Node2D) -> void:
	_partner = Hero.new()
	_partner.plain = true
	_partner.plain_weapon = "azure"
	_partner.set_job("boy")
	# ตัวละครตั้งตำแหน่งกับสีของตัวเองทุกเฟรม จึงใส่ไว้ในกล่องที่เลื่อนไปด้านหลังและย้อมเป็นเงา
	var shade := Node2D.new()
	shade.position = Vector2(78.0, -22.0)
	shade.scale = Vector2.ONE * 0.82
	holder.add_child(shade)
	holder.move_child(shade, 0)
	shade.add_child(_partner)
	_partner.use_model("cat_" + SkillPanel.pair_partner(WalkPage.pair_form))
	if _partner.plain_model != null:
		_partner.plain_model.shade = PAIR_SHADE

## สลับตัวหลักของตัวละครคู่
func swap_pair() -> void:
	WalkPage.pair_form = SkillPanel.pair_partner(WalkPage.pair_form)
	(heroes["azure"] as Hero).use_model("cat_" + WalkPage.pair_form)
	if _partner != null:
		_partner.use_model("cat_" + SkillPanel.pair_partner(WalkPage.pair_form))
		if _partner.plain_model != null:
			_partner.plain_model.shade = PAIR_SHADE

func _max_scroll() -> float:
	# ท้ายสุดเผื่อที่ให้ตัวรองของตัวละครคู่ (เงาด้านหลังทางขวา) ไม่โดนตัด
	return maxf(0.0, _view.x * (0.14 + SLOT_W * float(CHOICES.size() - 1) + 0.26) - _view.x)

func _spot(i: int) -> Vector2:
	return Vector2(_view.x * (0.14 + SLOT_W * float(i)) - _scroll, _view.y * GROUND_AT)

func _ring_center(i: int) -> Vector2:
	return (holders[i] as Node2D).position + Vector2(0.0, -PICK_UP * ZOOM)

func _process(delta: float) -> void:
	_full_t = maxf(_full_t - delta, 0.0)
	# ยังไม่เลือกตัว ตัวละครเรียงตามการเลื่อน
	if selected == "":
		for n in holders.size():
			var h := holders[n] as Node2D
			h.position.x = lerpf(h.position.x, _spot(n).x, 1.0 - exp(-18.0 * delta))
	for id in heroes:
		var model = (heroes[id] as Hero).plain_model
		if model != null:
			model.turn_extra = spin if id == selected else 0.0
			model.wide_hands = WIDE_HANDS
	queue_redraw()

## เลื่อนตัวที่เลือกไปซ้าย ซ่อนตัวอื่น
func _pick(i: int) -> void:
	selected = CHOICES[i]
	chosen_class = SkillPanel.BASE_CLASS.get(selected, "")
	for n in holders.size():
		(holders[n] as Node2D).visible = n == i
	var tween := create_tween()
	tween.tween_property(holders[i], "position:x", _view.x * PICKED_X, SLIDE_TIME)
	_scroll = clampf(_scroll, 0.0, _max_scroll())
	tween.tween_callback(queue_redraw)

## กลับไปหน้าเลือกตัว ทุกตัวกลับที่เดิม
func unpick() -> void:
	if selected != "":
		(heroes[selected] as Hero).use_model(SkillPanel.model_style(selected, ""))
	selected = ""
	chosen_class = ""
	for n in holders.size():
		var holder := holders[n] as Node2D
		holder.visible = true
		var tween := create_tween()
		tween.tween_property(holder, "position:x", _spot(n).x, SLIDE_TIME)
		tween.tween_callback(queue_redraw)

func button_rect() -> Rect2:
	if not SHOW_TRY:
		return Rect2(Vector2(_view.x * 0.5 - BUTTON_SIZE.x * 0.5, _view.y * BUTTON_Y - BUTTON_SIZE.y * 0.5), BUTTON_SIZE)
	return Rect2(Vector2(_view.x * 0.5 + BUTTON_GAP * 0.5, _view.y * BUTTON_Y - BUTTON_SIZE.y * 0.5), BUTTON_SIZE)

func try_rect() -> Rect2:
	if not SHOW_TRY:
		return Rect2()
	return Rect2(Vector2(_view.x * 0.5 - BUTTON_GAP * 0.5 - BUTTON_SIZE.x, _view.y * BUTTON_Y - BUTTON_SIZE.y * 0.5), BUTTON_SIZE)

func _input(event: InputEvent) -> void:
	# ลากซ้ายขวาบนตัวละครเพื่อหมุนดูรอบตัว
	if not _done and event is InputEventScreenDrag and selected != "" and event.position.distance_to(_ring_center(CHOICES.find(selected))) <= PICK_RADIUS * 1.3:
		spin = wrapf(spin + event.relative.x * SPIN_PER_PX, -180.0, 180.0)
		return
	# ยังไม่เลือกตัว ลากซ้ายขวาเลื่อนดูตัวละคร
	if not _done and event is InputEventScreenDrag and selected == "":
		_scroll = clampf(_scroll - event.relative.x, 0.0, _max_scroll())
		if event.position.distance_to(_press_at) > 24.0:
			_dragged = true
		return
	if not _done and event is InputEventScreenTouch and not event.pressed and selected == "":
		# ปล่อยนิ้วโดยไม่ได้ลาก คือเลือกตัว
		if not _dragged and _pressed_here:
			_pressed_here = false
			for i in CHOICES.size():
				if event.position.distance_to(_ring_center(i)) <= PICK_RADIUS:
					_pick(i)
					return
		return
	if not _done and event is InputEventScreenTouch and event.pressed:
		_press_at = event.position
		_dragged = false
		_pressed_here = true
		# แตะตัวละครคู่สองครั้ง สลับตัว
		if selected == "azure" and event.position.distance_to(_ring_center(CHOICES.find("azure"))) <= PICK_RADIUS:
			var now := Time.get_ticks_msec() / 1000.0
			if now - _last_tap < 0.4:
				swap_pair()
				_last_tap = -10.0
				return
			_last_tap = now
	if _done or not event is InputEventScreenTouch or not event.pressed:
		return
	if button_rect().has_point(event.position):
		if selected != "":
			# สร้างแล้วได้ตัว BASIC เลเวล 1 เสมอ ผังคลาสเป็นแค่ตัวอย่างและใช้ตอนทดลองเล่น
			var at := SaveData.add_character(selected, SkillPanel.BASE_CLASS.get(selected, "BASIC"), TEST_START_LEVEL)
			if at < 0:
				_full_t = 2.0
				queue_redraw()
				return
			if selected == "azure":
				SaveData.update_character(at, {"form": WalkPage.pair_form})
			_done = true
			WalkPage.just_created = at
			get_tree().change_scene_to_file("res://roster.tscn")
		return
	if try_rect().has_point(event.position):
		if selected != "":
			_done = true
			WalkPage.chosen_weapon = selected
			WalkPage.chosen_class = chosen_class
			WalkPage.trial = true
			# ทดลองเล่นใช้ได้ทุกสกิล
			WalkPage.chosen_level = 99
			WalkPage.chosen_exp = 0
			WalkPage.roster_index = -1
			WalkPage.dungeon_index = -1
			get_tree().change_scene_to_file("res://walk.tscn")
		return
	for id in _tree():
		if class_rect(id).has_point(event.position):
			chosen_class = id
			(heroes[selected] as Hero).use_model(SkillPanel.model_style(selected, chosen_class))
			queue_redraw()
			return
	if event.position.distance_to(BACK_CENTER) <= BACK_RADIUS:
		if selected != "":
			unpick()
		else:
			_done = true
			get_tree().change_scene_to_file("res://roster.tscn")
		return
	if selected != "":
		return

func _tree() -> Array:
	var base: String = SkillPanel.BASE_CLASS.get(selected, "")
	return [] if base == "" else SkillPanel.lineage(base, selected)

## ผังคลาสเลื่อนลงมาให้อยู่กลางจอ
const TREE_DOWN := Vector2(0.0, 75.0)

func class_rect(id: String) -> Rect2:
	var box: Rect2 = CLASS_BOX[id]
	return Rect2(box.position + TREE_DOWN, box.size)

func _draw_tree() -> void:
	if selected == "":
		return
	var font := Sketch.font()
	draw_string(font, CLASS_TITLE_AT + TREE_DOWN, "คลาส", HORIZONTAL_ALIGNMENT_LEFT, -1.0, CLASS_TITLE_SIZE, Sketch.INK)
	var tree := _tree()
	if tree.is_empty():
		draw_string(font, NO_CLASS_AT, "ยังไม่มีคลาส", HORIZONTAL_ALIGNMENT_LEFT, -1.0, CLASS_TITLE_SIZE, Sketch.INK)
		return
	for id in tree:
		for next in SkillPanel.next_of(id, selected):
			var from: Vector2 = class_rect(id).position + Vector2(class_rect(id).size.x, class_rect(id).size.y * 0.5)
			var to: Vector2 = class_rect(next).position + Vector2(0.0, class_rect(next).size.y * 0.5)
			Sketch.line(self, PackedVector2Array([from, to]), 530, CLASS_LINE, Sketch.WOBBLE)
	var seed_no := 540
	for id in tree:
		var box := class_rect(id)
		UiStyle.box(self, box, seed_no, CLASS_LINE_BOLD if id == chosen_class else CLASS_LINE, UiStyle.INK, UiStyle.PICKED if id == chosen_class else UiStyle.PAPER)
		seed_no += 1
		# ชื่อยาวย่อตัวอักษรให้พอดีกล่อง
		var text_size := CLASS_TEXT
		while text_size > UiStyle.SMALL and font.get_string_size(id, HORIZONTAL_ALIGNMENT_LEFT, -1.0, text_size).x > box.size.x - 24.0:
			text_size -= 1
		var word_w := font.get_string_size(id, HORIZONTAL_ALIGNMENT_LEFT, -1.0, text_size).x
		draw_string(font, box.get_center() + Vector2(-word_w * 0.5, float(text_size) * 0.36), id, HORIZONTAL_ALIGNMENT_LEFT, -1.0, text_size, Sketch.INK)

func _draw() -> void:
	_draw_tree()
	# ปุ่มย้อนกลับ ยังไม่เลือกตัวกลับหน้าคลัง
	draw_circle(BACK_CENTER, BACK_RADIUS, Color(1.0, 1.0, 1.0, 0.9))
	var back := Sketch.oval(BACK_CENTER, BACK_RADIUS, BACK_RADIUS, 40)
	back.append(back[0])
	Sketch.line(self, back, 520, CLASS_LINE, Sketch.WOBBLE)
	Sketch.line(self, PackedVector2Array([BACK_CENTER + Vector2(BACK_GLYPH * 0.4, -BACK_GLYPH), BACK_CENTER + Vector2(-BACK_GLYPH * 0.5, 0.0), BACK_CENTER + Vector2(BACK_GLYPH * 0.4, BACK_GLYPH)]), 521, CLASS_LINE, Sketch.WOBBLE)
	var name_font := Sketch.font()
	for i in CHOICES.size():
		var word: String = NAMES.get(CHOICES[i], "")
		if word == "":
			continue
		var word_w := name_font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, NAME_SIZE).x
		if (holders[i] as Node2D).visible:
			draw_string(name_font, (holders[i] as Node2D).position + Vector2(-word_w * 0.5, NAME_BELOW), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, NAME_SIZE, Sketch.INK)
	var box := button_rect()
	var on := selected != ""
	UiStyle.button(self, box, BUTTON_TEXT, 510, on, true)
	if SHOW_TRY:
		UiStyle.button(self, try_rect(), TRY_TEXT, 511, on)
	var font := Sketch.font()
	if _full_t > 0.0:
		var msg := "คลังเต็มแล้ว ลบตัวเก่าในหน้าคลังก่อน"
		var mw := font.get_string_size(msg, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 28).x
		draw_string(font, Vector2(_view.x * 0.5 - mw * 0.5, box.position.y - 20.0), msg, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 28, Color(0.8, 0.2, 0.15))
