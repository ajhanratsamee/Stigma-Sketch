class_name WalkPage
extends Node2D
## หน้าฝึกซ้อม พื้นเปล่า จอยวิ่ง ปุ่มกระโดด ปุ่มย้อนกลับ ตัว BOYS ปุ่ม Z X แสดงไว้แต่ยังกดไม่ได้
## เอาปุ่มสกิลและช่องสกิลออกชั่วคราว รอสกิลชุดใหม่ โค้ดสกิลเดิมยังอยู่

const GROUND_AT := 0.6            # พื้นอยู่ต่ำเกือบถึงปุ่ม JUMP
const ZOOM := 0.65              # ซูมเข้า 18% จากเดิม 0.55 พื้นยังอยู่ระดับเดิม ภาพขยายขึ้นด้านบน (ตัดแค่ท้องฟ้า)
# กล้องตามขึ้นเมื่อตัวละคร / มอนที่โดนตีลอย ลอยสูงจนจะหลุดขอบบน แล้วค่อยลงเมื่อลงพื้น
const AIR_TOP := 150.0          # จุดบนสุดของหัวต้องอยู่ต่ำกว่านี้บนจอ (ใต้การ์ดเลือด)
const AIR_HEAD := 230.0         # ความสูงหัวเหนือเท้า (จุดภาพในโลก)
const AIR_MAX := 340.0          # กล้องยกขึ้นได้มากสุด (จุดภาพบนจอ)
const AIR_RANGE := 900.0        # มอนลอยที่ห่างตัวละครไม่เกินนี้ (จุดภาพในโลก) ถึงนับ
const AIR_RISE := 6.0           # ความไวตอนกล้องยกขึ้น
const AIR_FALL := 2.6           # ความไวตอนกล้องลง (ช้ากว่า ไม่วูบ)
const AIR_FEET := 520.0         # เท้าตัวละครต้องอยู่สูงกว่านี้บนจอเสมอ (ไม่จมลงไปหลังจอย/ปุ่ม) ตัวละครสำคัญกว่ามอนลอย
# กล้องมองล้ำไปข้างหน้าตามทิศที่หัน (เมือง ดันเจี้ยน) เห็นมอนที่เข้ามาเร็วขึ้น
const LOOK_AHEAD := 0.1         # สัดส่วนความกว้างจอ
const LOOK_RATE := 1.8          # ความไวตอนกล้องเลื่อนตามทิศ (ช้าๆ หันกลับเร็วไม่กระตุก)
const SIDE_MARGIN := 0.6
const HIDDEN_BUTTONS := []
const LOCKED_BUTTONS := []
const JUMP_WIND := 0.09           # ย่อตัวก่อนลอย วินาที
const COMBO_HIT_AHEAD := 130.0
const COMBO_HIT_HALF := 150.0
const MONSTER_BODY_HALF := 46.0  # ครึ่งความกว้างหุ่นที่วาดจริง ดาบแตะขอบหุ่นก็นับ
const BACK_MARGIN := 34.0
const SKILL_GAP := 20.0
const SLOT_COUNT := 8            # ช่องสกิล 8 ช่อง แถวละ 4 สลับแถวด้วยปุ่มต้นพัด
const SLOTS_PER_ROW := 4
const SA_BUFF_TIME := 15.0
const STAB_TIME := 0.8
const STAB_AT := 0.25            # คลื่นเกิดตอนดาบถึงพื้น
const WAVE_AHEAD := 190.0
const ROW_AHEAD := 150.0
const DUMMY_AT := [3.0, 6.0, 9.0]  # ตำแหน่งหุ่นซ้อม หน่วยเกม
const SLASH_HIT_AHEAD := 150.0
const SLASH_HIT_HALF := 190.0
const SLASH_DMG := 14.0
const POUND_HALF := 90.0
const POUND_DMG := 14.0
const SKILL_STUN := 0.25
const SKILL_KB := 0.4
const SHAKE_TIME := 0.3
const SWORD_SHAKE := 0.16
const SHAKE_POWER := 8.0         # สั่นเบาลง
const SHAKE_HIT_WINDOW := 300     # จอสั่นได้เฉพาะช่วงนี้ (ms) หลังตีโดนมอน ตีพลาดไม่สั่น
const SHAKE_SPEED := 60.0
const POUND_TIME := 0.7
const POUND_WAVES := 3
const POUND_GAP := 0.13          # เวลาระหว่างคลื่นแต่ละลูก
const POUND_AHEAD := 170.0
const POUND_STEP := 150.0
const POUND_HEIGHT := 270.0
const POUND_WIDTH := 74.0
const SLASH_TIME := 1.05
const SLASH_SLIDE := 3.0         # ไถลหน่วยต่อวินาที
const SWING_TIME := 0.42
const STORM_AT := 0.3            # ปล่อยพายุเมื่อท่าเดินไปถึงสัดส่วนนี้
const STORM_AHEAD := 150.0

static var chosen_weapon := "cat"
static var chosen_class := ""     # คลาสที่เลือกตอนสร้างตัวละคร ว่างคือคลาสพื้นฐาน
static var equipped := {}        # ตัวที่เลือก -> สกิลในแต่ละช่อง
static var chosen_level := 1      # เลเวลตัวละคร สกิลที่ต้องเลเวลสูงกว่านี้ใช้ไม่ได้
static var trial := false         # ทดลองเล่นจากหน้าสร้าง ย้อนกลับไปหน้าสร้าง
static var chosen_exp := 0        # EXP ที่เก็บได้ในเลเวลนี้
static var roster_index := -1     # ตัวละครลำดับไหนในคลัง (-1 คือทดลองเล่น ไม่บันทึก)
static var current_town := 0      # อยู่เมืองไหน
static var pair_form := "azure"   # ตัวละครคู่ AZURE/LAPIS ตัวที่ออกมาเล่น
# ห้องฝึกซ้อม ติ๊กในเมนูตั้งค่า
static var train_cd := false      # รีคูลดาวน์ตลอด
static var train_mp := false      # มานาเต็มตลอด
static var train_hp := false      # เลือดเต็มตลอด
static var just_created := -1     # ลำดับในคลังของตัวที่เพิ่งสร้าง หน้าคลังเลือกไว้ให้
static var dungeon_town := -1     # เล่นดันเจี้ยนอยู่ เมืองไหน ดันไหน ไม่เล่นเป็น -1 (หน้าฝึกซ้อม)
static var dungeon_index := -1
static var tutorial := false      # โหมดฝึกสอนของตัวที่เพิ่งสร้าง (ห้องฝึก + TutorialGuide)
var intro_lock := false            # ท่าเปิดดัน / ท่าแพ้กำลังเล่น ไม่รับปุ่มและการเดิน
static var return_to := "res://roster.tscn"   # ปุ่มย้อนกลับพาไปหน้านี้

var world: Node2D
var hero: Hero
var pad: TouchPad
var susi: SusiSkills             # สกิลของ CAT SUSI
var skill_cds := {}              # คูลดาวน์สกิล CAT BOYS และ HYPER ทุกตัว
var _cd_ui: Node2D
var joy: Joystick
var panel: SkillPanel
var bars: StatBars
var hyper: HyperStage
var combo_panel: ComboPanel
var shake_left := 0.0
var combo_nth := -1              # ทีที่กำลังเล่นในคอมโบ Z ไม่เล่นคือ -1
var _combo_t := 0.0
var _combo_hit_done := false
var _combo_queued := ""          # ท่าที่กดต่อไว้แล้ว
var combo_name := ""
var _mage: MageCaster              # เวทของคอมโบ CAT SUSI
var _repeat_count := 0             # กดรัวต่อท่าเดิมไปแล้วกี่ครั้ง
var _hover_lock := 0.0             # ความสูงที่ค้างไว้ตอนกดค้างกลางอากาศ
var _air_started := false         # ลอยครั้งหนึ่งเริ่มคอมโบกลางอากาศได้ครั้งเดียว
var _x_key_was := false
var _blood_count := 0             # ลูกเลือดที่รัวไปแล้วในคอมโบนี้
const BLOOD_MAX := 8
var _time_stop_t := 0.0          # หยุดเวลาตอนปล่อยสกิลใหญ่
var _time_stop_list: Array = []
var _time_dim: Node2D
var _double_jumped := false       # CAT MATCHA กระโดดซ้ำกลางอากาศไปแล้ว
var _skill_button := ""          # ปุ่มสกิลที่กดล่าสุด ใช้เช็กกดค้าง
var atk_speed := 1.0             # ความเร็วท่าคอมโบ (พาสซีฟ)
var test_hold := false            # ให้เทสจำลองกดปุ่มสกิลค้าง
var _after_t := 0.0               # กดค้างหลังฟาดไปแล้วกี่วินาที
var _pulse_t := 0.0
var _gust_cd := 0.0
var _paw_t := {}                  # มอน -> เวลาที่ขึ้นรอยเท้าแมวล่าสุด
var _fx_clock := 0.0
var _zones: Array = []            # สิ่งที่ทำดาเมจเป็นจังหวะ ดูรายละเอียดที่ _tick_zones
var _circles: Array = []          # วงเวทที่ยืนแล้วได้ผล [วง ชนิด]
var _ck_cd := 0.0                 # คูลดาวน์พาสซีฟ 60.2 ของ CRIMSON
var _ck_regen := 0.0
var _pushers: Array = []          # พายุแดงยักษ์ [พายุ ทิศ ระยะที่เหลือ เวลาถึงฮิตถัดไป ความเร็ว]
var _whirl: CatWhirl              # หมุนคลื่นดาบอยู่
var _whirl_t := 0.0
var _whirl_hit := 0.0
var _storms: Array = []           # พายุเลือดคู่ [ซ้าย ขวา จุดกลาง เวลาถึงฮิตถัดไป]
var _vortex: Array = []           # ลูกไฟหมุน [ลูก ฮิตที่เหลือ เวลาถึงฮิตถัดไป ระเบิดที่เหลือ]
var _multi_hit := {}               # มอนที่โดนท่าหลายฮิตแบบครั้งเดียวต่อตัวไปแล้ว
var _hold_t := 0.0                # กดค้างหน่วงก่อนพุ่ง นานสุดตามค่า hold ของท่า
var _multi_t := 0.0               # นับเวลาทำดาเมจซ้ำของท่าหมุนพุ่งลง
var _orb: CatFireball             # ลูกไฟที่เรียกไว้ รอระเบิด
var _shots: Array = []            # ลูกไฟที่พุ่งอยู่ [ลูก ความเร็ว ทะลุได้อีกกี่ตัว ที่โดนแล้ว อายุ]
const MULTI_HALF := 130.0         # ระยะโดนรอบตัวของท่าหมุน
# เวทไฟของ MAGIC KNIGHT หน่วยเป็นจุดของ world
const ORB_AHEAD := 150.0
const ORB_UP := 110.0
const BURST_RADIUS := 130.0
const BURST_DMG := 18.0
const BURST_CHARGED_DMG := 30.0
const SHOT_SPEED := 850.0
const SHOT_RADIUS := 48.0
const SHOT_DMG := 20.0
const SHOT45_SPEED := 800.0
const SHOT45_RADIUS := 34.0
const SHOT45_DMG := 14.0
const SHOT_LIFE := 1.4
const MONSTER_MID := 60.0         # กึ่งกลางตัวหุ่นสูงจากพื้นเท่านี้
const MONSTER_HEIGHT := 130.0     # ตัวหุ่นสูงเท่านี้
const FRONT_AHEAD := 90.0
const FRONT_HALF := 110.0
const WIDE_HALF := 170.0
const BLOOD_SPEED := 900.0
const BLOOD_RADIUS := 28.0
const BLOOD_DMG := 9.0
const ATK_BUFF := Stats.ATK_MULT          # บัพพลังโจมตี +100
const SK_MIGHT := Stats.ATK_MULT          # พาสซีฟ 15.4 ของ SWORD KNIGHT พลังโจมตี +100
const MK_MAGIC := Stats.ATK_MULT          # พาสซีฟ 15.4 ของ MAGIC KNIGHT
const MK_BURN_BONUS := 1.3
const MK_CURSE_CHANCE := 0.5
const MK_CURSE_TIME := 10.0
const IGNITE_TIME := 20.0
const AURA_TIME := 20.0           # GRAND KNIGHT 35.2
const AURA_REACH := 140.0         # ออร่าดาบตีไกลขึ้นเท่านี้
const GUST_CHANCE := 0.25         # พาสซีฟ 35.4
const GUST_GAP := 0.3
const RED_STORM_TIME := 3.0       # พายุแดงยักษ์พัดไป 1 จอครึ่งในเวลานี้
const RED_STORM_SCALE := 2.4
const WHIRL_MIN := 1.0            # หมุนคลื่นดาบอย่างน้อย
const WHIRL_MAX := 5.0
const WHIRL_PULL := 450.0
const WHIRL_PULL_SPEED := 3.0     # หน่วยเกมต่อวินาที
const WHIRL_HIT := 0.2
const WHIRL_HALF := 190.0
const GUARD_REACH := 1.3          # มอนเข้าใกล้เท่านี้ระหว่างตั้งการ์ด สวนกลับ
const FK_BALL_SIZE := 1.35        # พาสซีฟ 35.4 ของ FLAME KNIGHT
const FK_FIREBALL := 1.25         # พาสซีฟ 60.1 ของ FLAME KNIGHT
const GD_LOUD := 1.25             # พาสซีฟ 35.4 ของ GUARDIAN ทุกสกิลเป็นโล่หรือตะโกน
const GD_MANA_GAIN := 4.0
const GD_MANA_TIME := 20.0
const CK_MIGHT := Stats.ATK_MULT          # พาสซีฟ 60.1 ของ CRIMSON
const CK_BOOST := 2.0             # สังเวยเลือดแล้วดาเมจคูณนี้
const CK_PRICE := 0.8
const CK_PRICE_LOW := 0.4         # เลือดต่ำกว่าครึ่ง สังเวยถูกลง
const CK_SURVIVE_CD := 20.0
const CK_REGEN_TIME := 5.0
const CK_REGEN := 0.04            # สัดส่วนเลือดสูงสุดที่ฟื้นต่อวินาที
const CK_MARK_TIME := 10.0
const CK_MARK_HEAL := 20.0
const FX_SCALE := 1.3             # เอฟเฟกต์สกิลใหญ่ขึ้นให้เห็นชัด
const PAW_GAP := 0.12             # รอยเท้าแมวตรงจุดโดน ห่างกันอย่างน้อยต่อมอนหนึ่งตัว
const RALLY_REACH := 1000.0       # GUARDIAN 45.2 วงตะโกนรอบตัว
const PULSE_GAP := 0.4            # คลื่นกระแทกตอนกดค้าง SHIELD 30.2
const STORM_START := 400.0        # พายุเลือดเริ่มห่างจากตัวราว 4 ช่วงตัว
const STORM_SPEED := 230.0
const STORM_HIT_EVERY := 0.3
const STORM_BOOM_DMG := 45.0
const BEAM_MIN := 450.0
const BEAM_MAX_EXTRA := 900.0
const BLOOD_SWORD_TIME := 15.0
const LIFESTEAL := 0.08
const SH_IRON := Stats.ATK_MULT           # พาสซีฟ 15.4 ของ SHIELD KNIGHT ดาเมจและเวลาชะงัก
const SH_WALL_SA := 2.0           # พาสซีฟ 40.1 ของ SHIELD KNIGHT
const TAUNT_RANGE := 5.0          # หน่วยเกม
const TAUNT_GAP := 1.1
const TAUNT_SA := 6.0
const DK_THIRST := Stats.ATK_MULT         # พาสซีฟ 15.4 ของ DARK KNIGHT
const DK_BROKEN_BONUS := 1.3
const BLAST_RANGE := 0.45          # วินาทีที่ลูกไฟพุ่งก่อนระเบิดเอง
const BLAST_RADIUS := 120.0
const BLAST_DMG := 20.0
const VORTEX_HITS := 18
const VORTEX_GAP := 0.1
const VORTEX_RADIUS := 150.0
const VORTEX_DMG := 5.0
const VORTEX_BURST_DMG := 22.0
const BLOOD_LOW := 24.0           # ลูกเลือดเลียดพื้น สูงจากพื้นเท่านี้
const BLOOD45_DMG := 14.0
const HIT_Y_MARGIN := 15.0
const BODY_HIT_UP := 190.0        # ท่าเตะ ท่าโดนรอบตัว โดนได้สูงจากเท้าเราเท่านี้ มอนที่ลอยสูงกว่าไม่โดน
const MONSTER_HIT_R := 45.0
var _z_key_was := false
var _combo_stop := 0.0           # ค้างจังหวะตอนดาบโดนเป้า
var _jump_wind := 0.0
var _jump_was := false
var frame: PictureFrame
var room: TrainingRoom
var _view := Vector2.ZERO

## หน้าเมืองใช้หน้านี้ทั้งหน้า (TownPage) ไม่มีหุ่นซ้อม ไม่มีห้องฝึก
func is_town() -> bool:
	return false

## หน้าดันเจี้ยน (DungeonPage) วางมอนกับฉากเอง
func is_dungeon() -> bool:
	return false

## กึ่งกลางกล้องแนวนอน หน้าเมืองเลื่อนตามตัวละคร
func _home_x() -> float:
	return _view.x * 0.5

var air_y := 0.0                # กล้องยกขึ้นอยู่กี่จุดภาพ (โลกเลื่อนลง)
var look := 0.0                 # กล้องล้ำไปข้างหน้ากี่จุดภาพ

## ตำแหน่งแนวตั้งของโลกบนจอ (พื้นระดับเดิม + กล้องยกตามของที่ลอย)
func _home_y() -> float:
	return _view.y * GROUND_AT + air_y

## กล้องยกขึ้นเท่าไรถึงเห็นหัวตัวละครกับมอนที่ลอยอยู่ใกล้ๆ  ground_y คือพื้นใต้ตัวละคร (จุดภาพในโลก)
func _air_target(ground_y := 0.0) -> float:
	if hero == null:
		return 0.0
	var top := hero.position.y
	for e in get_tree().get_nodes_in_group("monsters"):
		var m := e as Monster
		if m == null or m.state != "air" or absf(m.position.x - hero.position.x) > AIR_RANGE:
			continue
		top = minf(top, m.position.y)
	var need := AIR_TOP - _view.y * GROUND_AT - (top - ground_y - AIR_HEAD) * ZOOM
	# ห้ามยกจนเท้าตัวละครตกต่ำกว่า AIR_FEET
	var cap := AIR_FEET - _view.y * GROUND_AT - (hero.position.y - ground_y) * ZOOM
	return clampf(minf(need, cap), 0.0, AIR_MAX)

func _tick_air(delta: float, ground_y := 0.0) -> void:
	if hyper != null:
		return
	var want := _air_target(ground_y)
	air_y = want if delta <= 0.0 else lerpf(air_y, want, 1.0 - exp(-(AIR_RISE if want > air_y else AIR_FALL) * delta))

## กล้องล้ำไปข้างหน้าตามทิศที่หัน
func _tick_look(delta: float) -> void:
	if hero == null:
		return
	var want := signf(hero.facing) * _view.x * LOOK_AHEAD
	look = want if delta <= 0.0 else lerpf(look, want, 1.0 - exp(-LOOK_RATE * delta))

func _ready() -> void:
	# เปลี่ยนฉากระหว่างหยุดจังหวะตอนโดนตี เวลาอาจค้างช้าอยู่ คืนเป็นปกติทุกครั้งที่เข้าหน้า
	Engine.time_scale = 1.0
	_view = get_viewport_rect().size
	Hero.platforms = []
	world = Node2D.new()
	world.position = Vector2(_view.x * 0.5, _view.y * GROUND_AT)
	world.scale = Vector2.ONE * ZOOM
	add_child(world)
	world.child_entered_tree.connect(_on_world_child)
	hero = Hero.new()
	hero.plain = true
	hero.plain_weapon = chosen_weapon
	hero.set_job("boy")
	hero.use_model(SkillPanel.model_style(chosen_weapon, chosen_class))
	hero.is_player = true
	hero.half_width = _view.x * 0.5 / (CombatData.UNIT * ZOOM) - SIDE_MARGIN
	world.add_child(hero)
	pad = TouchPad.new()
	add_child(pad)
	# CAT SUSI มีคอมโบกดลง ใช้ปุ่มลง
	pad.show_down = chosen_weapon == "mage"
	# AZURE/LAPIS ปุ่ม V สลับตัว อยู่ในพัดต่อจากช่องสกิล ก่อน HYPER
	pad.pair_swap_on = chosen_weapon == "azure"
	pad.layout(_view)
	if chosen_weapon == "mage" or chosen_weapon == "bow":
		_mage = MageCaster.new()
		_mage.page = self
		_mage.hero = hero
		world.add_child(_mage)
	joy = Joystick.new()
	joy.position = pad.stick_home
	joy.home = pad.stick_home
	joy.enabled = pad.use_stick
	joy.show_idle = tutorial
	# จอยลอย แตะตรงไหนก็ได้ครึ่งซ้ายของจอ (ใต้การ์ดเลือด) จอยเกิดใต้นิ้ว ไม่ต้องเล็งลูกศร
	var left_btn: Vector2 = pad.buttons.get("hyper", pad.buttons.get("pswap", pad.buttons["s0"]))
	var cells_left: float = minf(minf((pad.buttons["s0"] as Vector2).x, left_btn.x) - TouchPad.CELL * 0.5 * pad.size_k - 40.0, _view.x * 0.55)
	joy.zone = Rect2(Vector2(0.0, 200.0), Vector2(cells_left, _view.y - 200.0))
	pad.stick = joy
	add_child(joy)
	for id in HIDDEN_BUTTONS:
		pad.buttons.erase(id)
	pad.locked = LOCKED_BUTTONS.duplicate()
	pad.buttons["back"] = Vector2(_view.x - BACK_MARGIN - UiStyle.safe_side() - TouchPad.SLOT_RADIUS, BACK_MARGIN + TouchPad.SLOT_RADIUS)
	pad.buttons["combo"] = pad.buttons["back"] + Vector2(-TouchPad.SLOT_RADIUS * 2.0 - SKILL_GAP, 0.0)
	pad.buttons["skill"] = pad.buttons["combo"] + Vector2(-TouchPad.SLOT_RADIUS * 2.0 - SKILL_GAP, 0.0)
	pad.pressed_button.connect(_on_button)
	combo_panel = ComboPanel.new()
	combo_panel.z_index = 45
	combo_panel.visible = false
	combo_panel.place(pad.buttons["combo"], pad.buttons["back"], TouchPad.SLOT_RADIUS)
	combo_panel.set_class(chosen_class, chosen_weapon)
	add_child(combo_panel)
	frame = PictureFrame.new()
	add_child(frame)
	move_child(frame, 0)
	if is_town() or is_dungeon():
		pass
	elif dungeon_index >= 0:
		var run := DungeonRun.new()
		run.page = self
		run.town = dungeon_town
		run.index = dungeon_index
		add_child(run)
	else:
		for x in DUMMY_AT:
			_spawn_dummy.call_deferred(x)
	if not is_town() and not is_dungeon():
		room = TrainingRoom.new()
		room.ground_y = _view.y * GROUND_AT
		add_child(room)
		move_child(room, 0)
	bars = StatBars.new()
	bars.hero = hero
	bars.level = chosen_level
	bars.exp_ratio = _exp_ratio()
	add_child(bars)
	# ฟิลเตอร์นุ่มทับฉากโลก โทนเดียวกับหน้าโหลด (UI อยู่เหนือ)
	add_child(SoftWorld.new())
	_cd_ui = Node2D.new()
	_cd_ui.z_index = 44
	_cd_ui.draw.connect(_draw_cds)
	add_child(_cd_ui)
	if chosen_weapon == "mage":
		susi = SusiSkills.new()
		world.add_child(susi)
		susi.setup(self)
	elif chosen_weapon == "spear":
		# สกิลของ CAT CITRUS ใช้ระบบเดียวกับ SUSI
		susi = SpearSkills.new()
		world.add_child(susi)
		susi.setup(self)
	elif chosen_weapon == "bow":
		# สกิลของ CAT MATCHA ใช้ระบบเดียวกับ SUSI
		susi = BowSkills.new()
		world.add_child(susi)
		susi.setup(self)
	elif chosen_weapon == "azure":
		# สกิลของ CAT AZURE & LAPIS ใช้ระบบเดียวกับ SUSI
		susi = PairSkillsPlus.new()
		world.add_child(susi)
		susi.setup(self)
	elif chosen_weapon == "fist":
		# สกิลของ CAT ASH ใช้ระบบเดียวกับ CITRUS
		susi = FistSkills.new()
		world.add_child(susi)
		susi.setup(self)
	panel = SkillPanel.new()
	panel.weapon = chosen_weapon
	panel.root_class = chosen_class
	panel.level = chosen_level
	panel.open_chosen_tab()
	panel.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	panel.visible = false
	panel.toggled.connect(_on_skill_toggled)
	panel.closed.connect(_close_panel)
	if tutorial and not trial and not is_town() and not is_dungeon():
		var guide := TutorialGuide.new()
		add_child(guide)
		guide.setup.call_deferred(self)
	add_child(panel)
	_refresh_slot()

## หุ่นซ้อมอยู่กับที่ มีเลขดาเมจและหลอดเลือดของตัวเอง เลือดหมดแล้วเต็มใหม่ทันที
func _spawn_dummy(x: float) -> void:
	var dummy := Monster.new()
	dummy.role = "dummy"
	dummy.pos = Vector2(x, 0.0)
	dummy.half_width = hero.half_width
	dummy.hero = hero
	world.add_child(dummy)

## รอยข่วนกรงเล็บสามเส้นที่ตัวมอนตอนโดนตี ตัวเดียวกันห่างกันอย่างน้อย 0.12 วิ จะได้ไม่รก
var _claw_t := {}

func _claw_mark(monster: Monster, side: float) -> void:
	var now := Time.get_ticks_msec()
	if now - int(_claw_t.get(monster, -1000)) < 120:
		return
	_claw_t[monster] = now
	var mark := ClawMark.new()
	mark.dir = side if side != 0.0 else hero.facing
	mark.tint = Color(0.92, 0.3, 0.5) if _line("DARK KNIGHT") else (Color(1.0, 0.55, 0.2) if _line("MAGIC KNIGHT") else Color(1.0, 0.95, 0.85))
	mark.position = monster.position + Vector2(randf_range(-12.0, 12.0), -WalkPage.MONSTER_MID + randf_range(-20.0, 20.0))
	world.add_child(mark)

## ช่วงความสูงที่ตัวเราตีถึง ตั้งแต่เท้าถึงเหนือหัวนิดหน่อย ใช้กับท่าที่ไม่ได้ใช้ใบดาบ
func _body_span() -> Vector2:
	# ใช้ตำแหน่งจริงของตัวละคร (pos) ไม่ใช้ position ที่อาจยังค้างค่าของเฟรมก่อนตอนเพิ่งลงพื้น
	var feet := -hero.pos.y * CombatData.UNIT
	return Vector2(feet - BODY_HIT_UP, feet + 20.0)

## ทำดาเมจมอนในช่วงความกว้างนี้ หน่วยเป็นจุดของ world ส่ง once มาเพื่อให้โดนครั้งเดียวต่อตัว
func _hit_area(center: float, half: float, dmg: float, side: float, once = null, extra := {}, y_span := Vector2.ZERO) -> bool:
	var any := false
	for e in get_tree().get_nodes_in_group("monsters"):
		var monster := e as Monster
		if monster == null or absf(monster.pos.x * CombatData.UNIT - center) > half:
			continue
		# ดาบต้องผ่านช่วงความสูงของตัวมอนด้วย มอนลอยอยู่สูงกว่าดาบไม่โดน
		if y_span != Vector2.ZERO:
			var feet := -monster.pos.y * CombatData.UNIT
			if feet - MONSTER_HEIGHT > y_span.y + HIT_Y_MARGIN or feet < y_span.x - HIT_Y_MARGIN:
				continue
		if once != null:
			if once.has(monster):
				continue
			once[monster] = true
		var h := {"type": "flinch", "dmg": dmg, "skill": true, "stun": SKILL_STUN, "kb": SKILL_KB}
		h.merge(extra, true)
		_strike(monster, h, side)
		any = true
	return any

## เอฟเฟกต์สกิลที่วาดตามตำแหน่งตัวเอง ขยายให้ใหญ่ขึ้นตอนเข้าฉาก
func _on_world_child(node: Node) -> void:
	var listed := node is CatShockwave or node is CatShout or node is CatSwordWave or node is CatEruption or node is CatRedCrack or node is CatCrack or node is CatSlashMarks or node is CatStorm or node is CatWhirl or node is CatPhoenix or node is CatSkyBlade
	if listed:
		(node as Node2D).scale *= FX_SCALE
	# ระหว่างใช้สกิลแมว เอฟเฟกต์ที่ตีได้ย่อตาม SkillScale และระยะโดนเท่ากับภาพ (คอมโบธรรมดาไม่ย่อ)
	if node is Node2D and combo_name.begins_with("cat_") and not combo_name.ends_with("_hyper") and (listed or "hitter" in node):
		(node as Node2D).scale *= SkillScale.K
		SkillScale.wrap_hitter(node as Node2D)

## สีลูกเล่นของแต่ละสาย
func _fx_tint() -> Color:
	if chosen_weapon == "bow":
		return Color(0.55, 0.85, 0.4)
	if chosen_weapon == "spear":
		return Color(1.0, 0.62, 0.2)
	if chosen_weapon == "fist":
		return Color(0.66, 0.66, 0.72)
	if chosen_weapon == "azure":
		return Color(0.55, 0.8, 1.0)
	# สีของสาย CAT SUSI
	if chosen_weapon == "mage":
		if _line("ELEMENT MASTER") or _line("ARCH MAGE"):
			return Color(0.35, 0.7, 1.0)
		if _line("DIMENSION CASTER") or _line("BATTLE MAGE"):
			return Color(1.0, 0.4, 0.75)
		if _line("ECLIPSE") or _line("DARK MAGE"):
			return Color(0.6, 0.3, 0.95)
		if _line("TRANSMUTATION MASTER") or _line("ALCHEMIST MAGE"):
			return Color(0.35, 0.85, 0.45)
		return Color(1.0, 0.45, 0.8)
	if _line("MAGIC KNIGHT"):
		return Color(1.0, 0.55, 0.12)
	if _line("DARK KNIGHT"):
		return Color(0.85, 0.05, 0.15)
	if _line("SHIELD KNIGHT"):
		return Color(1.0, 0.3, 0.3)
	return Color(1.0, 0.35, 0.18)

## ดาววิ้งและรอยเท้าแมวตอนปล่อยสกิล
func _cute_pop(at: Vector2) -> void:
	var spark := HitSpark.new()
	spark.tint = _fx_tint().lightened(0.3)
	spark.position = at
	world.add_child(spark)

## สร้าง HYPER จากไฟล์ (ใช้กับ HYPER ใหม่ของ CAT MATCHA)
func _new_hyper(path: String) -> HyperStage:
	var script := load(path) as Script
	return script.new() as HyperStage if script != null else null

## คลาสนี้หรือคลาสก่อนหน้าในสายเดียวกัน
func _line(class_id: String) -> bool:
	return chosen_class == class_id or class_id in SkillPanel.ancestors(chosen_class)

## ทุกครั้งที่ตีโดน ปรับดาเมจตามพาสซีฟและบัพของสาย แล้วค่อยส่งให้มอน
var _hit_clock := -100000
var _heavy_down_was := false

func _strike(monster: Monster, h: Dictionary, side: float) -> void:
	_hit_clock = Time.get_ticks_msec()
	var mult := 1.0
	if hero.plain_atk_t > 0.0:
		mult *= ATK_BUFF
	if _line("SWORD KNIGHT"):
		mult *= SK_MIGHT
	if _line("MAGIC KNIGHT"):
		# ดาบติดไฟ ทุกท่าเป็นไฟ ติดสถานะเผาไหม้
		if hero.plain_fire_t > 0.0 and not h.has("burn"):
			h["burn"] = "fire"
			h["magic"] = true
		if h.get("magic", false):
			mult *= MK_MAGIC
			if monster.burn_t > 0.0:
				mult *= MK_BURN_BONUS
	if _line("SHIELD KNIGHT"):
		mult *= SH_IRON
		h["stun"] = float(h.get("stun", SKILL_STUN)) * SH_IRON
	if _line("DARK KNIGHT"):
		mult *= DK_THIRST
		# ดาบเลือด ตีโดนแล้วเลือดไหล ทำดาเมจต่อเนื่อง
		if hero.plain_blood_t > 0.0 and not h.has("burn"):
			h["burn"] = "blood"
		if monster.armor_t > 0.0:
			mult *= DK_BROKEN_BONUS
	if chosen_class == "FLAME KNIGHT" and h.get("fireball", false):
		mult *= FK_FIREBALL
	if chosen_class == "GUARDIAN KNIGHT":
		mult *= GD_LOUD
	if chosen_class == "CRIMSON KNIGHT":
		mult *= CK_MIGHT
		if hero.plain_boost_t > 0.0:
			mult *= CK_BOOST
	# CRIMSON 35.3 มาร์คเป้าหมาย ดูดเลือด
	if h.get("mark", false):
		monster.mark_t = CK_MARK_TIME
		hero.hp = minf(hero.hp + CK_MARK_HEAL, hero.hp_max())
	# GUARDIAN 45.2 ตีคอมโบได้ MP เพิ่ม
	if hero.plain_mana_t > 0.0 and combo_nth >= 0 and not combo_name.begins_with("cat_"):
		hero.mp = minf(hero.mp + GD_MANA_GAIN, hero.mp_max())
	if susi != null:
		mult *= susi.dmg_mult(monster, h)
		susi.on_strike(monster, h)
	# ยิ่งเลเวลสูงยิ่งตีแรง (มอนในดันเลเวลสูงก็เลือดเยอะตาม)
	h["dmg"] = float(h.get("dmg", 0.0)) * mult * LevelData.power(chosen_level)
	monster.take_hit(h, side)
	# สกิลโดน จอสั่นเบาๆ ให้รู้สึกหนัก  ตีคอมโบโดนได้มานาคืน
	if h.get("skill", false):
		shake_left = maxf(shake_left, 0.07)
	elif chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"]:
		hero.mp = minf(hero.mp + Stats.HIT_MP, hero.mp_max())
	# โดนตี ขึ้นประกายเล็กๆ ตรงตัวมอน ทั้งตีปกติ คอมโบ และสกิล
	if chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and _fx_clock - float(_paw_t.get(monster, -1.0)) >= PAW_GAP:
		_paw_t[monster] = _fx_clock
		var spark := HitSpark.new()
		spark.tint = _fx_tint().lightened(0.3)
		spark.position = monster.position + Vector2(randf_range(-20.0, 20.0), -MONSTER_MID - randf_range(0.0, 40.0))
		world.add_child(spark)
	# พาสซีฟ 35.4 ของ GRAND KNIGHT คลื่นลมแดงจางเล็กๆ คลื่นนี้ไม่ต่อคลื่นอีก
	if chosen_class == "GRAND KNIGHT" and not h.get("proc", false) and _gust_cd <= 0.0 and randf() < GUST_CHANCE:
		_gust_cd = GUST_GAP
		var gust := CatSwordWave.new()
		gust.dir = hero.facing
		gust.hitter = _hit_area
		gust.high = 120.0
		gust.speed = 900.0
		gust.life = 0.6
		gust.dmg = 8.0
		gust.body = Color(1.0, 0.3, 0.28, 0.6)
		gust.glow = Color(1.0, 0.4, 0.4, 0.25)
		gust.edge = Color(1.0, 0.9, 0.9, 0.8)
		gust.extra = {"kb": 1.0, "stun": 0.3, "proc": true}
		gust.position = Vector2(hero.position.x + hero.facing * 80.0, 0.0)
		world.add_child(gust)
	# ดาบเลือด ดูดเลือดจากเป้าหมายนิดหน่อย
	if _line("DARK KNIGHT") and hero.plain_blood_t > 0.0:
		hero.hp = minf(hero.hp + float(h["dmg"]) * LIFESTEAL, Hero.MAX_HP)
	# พาสซีฟ 40.1 ของ MAGIC KNIGHT
	if _line("MAGIC KNIGHT") and randf() < MK_CURSE_CHANCE:
		monster.armor_t = MK_CURSE_TIME
		hero.plain_atk_t = MK_CURSE_TIME

## AZURE/LAPIS สลับตัว: manual คือกดปุ่ม V (ติดคูลดาวน์ 3 วิ) ส่วนคู่หูกระโดดออกมาโจมตีก็นับเป็นการสลับตัว (ไม่ติดคูลดาวน์)
## เลือด มานา ทิศ เก็บไว้เหมือนเดิม  at คือจุดที่ตัวใหม่ยืน (ตำแหน่งที่คู่หูลงพื้น)
const PAIR_SWAP_CD := 3.0
var pair_swap_cd := 0.0
var _v_key_was := false

func pair_swap(manual := true, at: Variant = null, face := 0.0) -> bool:
	if chosen_weapon != "azure" or hyper != null:
		return false
	if manual and pair_swap_cd > 0.0:
		return false
	# แปลงร่างพลังดิบอยู่ สลับตัวไม่ได้
	if susi != null and susi.has_method("tf_active") and susi.tf_active():
		if manual:
			bars.notice("แปลงร่างอยู่ สลับตัวไม่ได้")
		return false
	var old_at := hero.position
	pair_form = SkillPanel.pair_partner(pair_form)
	if at is Vector2:
		hero.pos = at
		hero.position = Vector2(hero.pos.x, -hero.pos.y) * CombatData.UNIT
	if face != 0.0:
		hero.facing = face
	hero.use_model(SkillPanel.model_style("azure", chosen_class))
	_end_combo()
	if manual:
		pair_swap_cd = PAIR_SWAP_CD
		pad.pair_swap_cd = pair_swap_cd
		pad.queue_redraw()
	# ควันฟ้าตรงตัวใหม่ ตัวเก่าหายเป็นควันตรงจุดเดิม
	for p in [hero.position, old_at]:
		var fx := PairFx.new()
		fx.kind = "swap"
		fx.dir = hero.facing
		fx.position = p
		fx.life = 0.4
		world.add_child(fx)
	# สกิลติดตัวของคู่ที่ทำงานตอนสลับตัว
	if susi != null and susi.has_method("on_swap"):
		susi.on_swap(manual)
	return true

func _on_button(id: String) -> void:
	if intro_lock:
		return
	match id:
		"back":
			# ปุ่มตั้งค่า เปิดเมนู ย้อนกลับ / ห้องฝึกซ้อม
			open_settings()
		"z":
			press_z()
		"x":
			press_x()
		"pswap":
			pair_swap()
		"combo":
			combo_panel.visible = not combo_panel.visible
		"v":
			if susi != null:
				susi.press_v()
		"skill":
			_open_panel.call_deferred()
		"hyper":
			var hyper_id := _hyper_skill()
			if hyper_id != "":
				_skill_button = id
				_use_skill(hyper_id)
		"s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7":
			_skill_button = id
			_use_skill(_slot_skill(int(id.substr(1))))

# ---------------------------------------------------------------- เมนูตั้งค่า
const MENU_W := 300.0
const MENU_ROW := 70.0

var _menu: Node2D
var settings_panel: SettingsPanel    # แผงตั้งค่าเสียง สั่น ปุ่ม

## ย้อนกลับไปหน้าก่อนหน้า ทดลองเล่นกลับหน้าสร้าง
func go_back() -> void:
	get_tree().change_scene_to_file("res://pick.tscn" if trial else return_to)

## เข้าห้องฝึกซ้อม ย้อนกลับจากห้องฝึกแล้วกลับมาหน้านี้ (หรือเมืองถ้ามาจากดันเจี้ยน)
func go_training() -> void:
	if is_town():
		WalkPage.return_to = "res://town.tscn"
	elif dungeon_index >= 0:
		WalkPage.return_to = "res://town.tscn"
	else:
		return
	WalkPage.dungeon_index = -1
	WalkPage.trial = false
	get_tree().change_scene_to_file("res://walk.tscn")

func menu_items() -> Array:
	var training_ok := is_town() or dungeon_index >= 0
	var out := [["ย้อนกลับ", true], ["ห้องฝึกซ้อม", training_ok]]
	# ห้องฝึกซ้อมมีช่องติ๊ก รีคูลดาวน์ รีมานา รีเลือด
	if is_training():
		out.append(["รีคูลดาวน์", true, "cd"])
		out.append(["รีมานา", true, "mp"])
		out.append(["รีเลือด", true, "hp"])
	out.append(["ตั้งค่า", true, "settings"])
	return out

## เปิดแผงตั้งค่า (เสียง สั่น ปุ่ม)
func open_game_settings() -> void:
	if settings_panel == null:
		settings_panel = SettingsPanel.new()
		settings_panel.page = self
		settings_panel.closed.connect(func() -> void:
			pad.visible = true
			joy.visible = true)
		add_child(settings_panel)
	pad.reset()
	joy.release()
	pad.visible = false
	joy.visible = false
	settings_panel.open()

## ช่องสกิลที่ติดคูลดาวน์ มืดลงตามเวลาที่เหลือ มีตัวเลขวินาที (สกิล CAT BOYS และ HYPER)
func _draw_cds() -> void:
	if not pad.visible:
		return
	var cells := []
	for i in pad.slot_ids.size():
		cells.append(["s%d" % i, str(pad.slot_ids[i])])
	cells.append(["hyper", str(pad.hyper_id)])
	for c in cells:
		var id: String = c[1]
		var left := float(skill_cds.get(id, 0.0))
		if id == "" or left <= 0.0 or not pad.shown(c[0]):
			continue
		var r: Rect2 = pad.cell_rect(c[0])
		var k := clampf(left / maxf(Stats.skill_cd(chosen_weapon, id), 0.01), 0.0, 1.0)
		TouchPad.draw_cd(_cd_ui, r, k, left)

## หยุดเวลาชั่วครู่ตอนปล่อยสกิลใหญ่ มอนนิ่ง ฉากหลังมืดลง ตัวละครยังขยับได้
func time_stop(t: float) -> void:
	if hyper != null:
		return
	for e in get_tree().get_nodes_in_group("monsters"):
		var m := e as Monster
		if m != null and not m.frozen:
			m.frozen = true
			_time_stop_list.append(m)
	_time_stop_t = maxf(_time_stop_t, t)
	if _time_dim == null:
		_time_dim = Node2D.new()
		_time_dim.draw.connect(_draw_time_dim)
		world.add_child(_time_dim)
		world.move_child(_time_dim, 0)
	_time_dim.queue_redraw()

func _tick_time_stop(delta: float) -> void:
	if _time_stop_t <= 0.0:
		return
	_time_stop_t -= delta
	if _time_dim != null:
		_time_dim.queue_redraw()
	if _time_stop_t <= 0.0:
		_time_stop_t = 0.0
		if hyper == null:
			for m in _time_stop_list:
				if is_instance_valid(m):
					(m as Monster).frozen = false
		_time_stop_list.clear()

func _draw_time_dim() -> void:
	if _time_stop_t <= 0.0:
		return
	var a := clampf(_time_stop_t / 0.15, 0.0, 1.0)
	var c := hero.position
	_time_dim.draw_rect(Rect2(c + Vector2(-6000.0, -4000.0), Vector2(12000.0, 8000.0)), Color(0.08, 0.05, 0.16, 0.45 * a))
	# เส้นแสงพุ่งเข้าหาตัวละคร
	for i in 16:
		var ang := TAU * float(i) / 16.0 + 0.2
		var u := Vector2(cos(ang), sin(ang) * 0.6)
		_time_dim.draw_line(c + Vector2(0.0, -70.0) + u * 900.0, c + Vector2(0.0, -70.0) + u * 260.0, Color(1.0, 1.0, 1.0, 0.25 * a), 4.0, true)

## หน้าฝึกซ้อม (ไม่ใช่เมือง ไม่ใช่ดันเจี้ยน)
func is_training() -> bool:
	return not is_town() and not is_dungeon()

func train_flag(key: String) -> bool:
	match key:
		"cd":
			return train_cd
		"mp":
			return train_mp
		"hp":
			return train_hp
	return false

func toggle_train(key: String) -> void:
	match key:
		"cd":
			train_cd = not train_cd
		"mp":
			train_mp = not train_mp
		"hp":
			train_hp = not train_hp

## ห้องฝึกซ้อมที่ติ๊กไว้ เติมให้ทุกเฟรม
func _apply_training() -> void:
	if not is_training():
		return
	if train_hp and hero.hp > 0.0:
		hero.hp = hero.hp_max()
	if train_mp:
		hero.mp = hero.mp_max()
	if train_cd:
		skill_cds.clear()
		if susi != null:
			susi.cds.clear()

func menu_rect(i: int) -> Rect2:
	var r := TouchPad.SLOT_RADIUS
	var gear: Vector2 = pad.buttons["back"]
	return Rect2(Vector2(gear.x + r - MENU_W, gear.y + r + 14.0 + float(i) * (MENU_ROW + 8.0)), Vector2(MENU_W, MENU_ROW))

var _menu_frame := -1

func open_settings() -> void:
	_menu_frame = Engine.get_process_frames()
	if _menu == null:
		_menu = Node2D.new()
		_menu.z_index = 90
		_menu.draw.connect(_draw_menu)
		add_child(_menu)
	_menu.visible = true
	combo_panel.visible = false
	pad.reset()
	pad.visible = false
	_menu.queue_redraw()

func close_settings() -> void:
	if _menu != null:
		_menu.visible = false
	pad.visible = true

func settings_open() -> bool:
	return _menu != null and _menu.visible

## แตะในเมนูตั้งค่า แตะนอกเมนูคือปิด คืน true ถ้าเมนูเปิดอยู่
func _menu_tap(at: Vector2) -> bool:
	if not settings_open():
		return false
	# แตะเดียวกับที่เพิ่งกดเปิดเมนู ไม่นับเป็นแตะนอกเมนู
	if Engine.get_process_frames() == _menu_frame:
		return true
	var items := menu_items()
	for i in items.size():
		if menu_rect(i).has_point(at):
			if not items[i][1]:
				return true
			if items[i].size() > 2 and str(items[i][2]) == "settings":
				close_settings()
				open_game_settings()
				return true
			# ช่องติ๊ก สลับเปิดปิด เมนูยังเปิดอยู่
			if items[i].size() > 2:
				toggle_train(str(items[i][2]))
				_menu.queue_redraw()
				return true
			close_settings()
			if i == 0:
				go_back()
			else:
				go_training()
			return true
	close_settings()
	return true

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		if _menu_tap(event.position) and is_inside_tree():
			get_viewport().set_input_as_handled()

func _draw_menu() -> void:
	_menu.draw_rect(Rect2(Vector2.ZERO, _view), Color(1.0, 0.98, 0.94, 0.4))
	var font := Sketch.font()
	var items := menu_items()
	var gear: Vector2 = pad.buttons["back"]
	_menu.draw_circle(gear, TouchPad.SLOT_RADIUS, Sketch.PAPER)
	var ring := Sketch.oval(gear, TouchPad.SLOT_RADIUS, TouchPad.SLOT_RADIUS, 40)
	ring.append(ring[0])
	Sketch.line(_menu, ring, 880, 6.0, Sketch.WOBBLE)
	for i in items.size():
		var r := menu_rect(i)
		var on: bool = items[i][1]
		var color := Sketch.INK if on else TouchPad.EMPTY_RING
		UiStyle.box(_menu, r, 881 + i, UiStyle.LINE, color)
		var a := r.position
		if items[i].size() > 2 and str(items[i][2]) != "settings":
			# ช่องติ๊กทางซ้าย ข้อความต่อท้าย
			var box := Rect2(Vector2(a.x + 22.0, r.get_center().y - 18.0), Vector2(36.0, 36.0))
			var ticked := train_flag(str(items[i][2]))
			UiStyle.box(_menu, box, 890 + i, UiStyle.LINE, UiStyle.INK, Color(0.88, 0.94, 0.88) if ticked else UiStyle.PAPER)
			if ticked:
				_menu.draw_polyline(PackedVector2Array([box.position + Vector2(7.0, 18.0), box.position + Vector2(15.0, 28.0), box.position + Vector2(31.0, 6.0)]), Color(0.4, 0.62, 0.45), 4.0, true)
			_menu.draw_string(font, Vector2(box.end.x + 18.0, r.get_center().y + 11.0), items[i][0], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, color)
			continue
		var w := font.get_string_size(items[i][0], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30).x
		_menu.draw_string(font, r.get_center() + Vector2(-w * 0.5, 11.0), items[i][0], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, color)

func _open_panel() -> void:
	pad.reset()
	joy.release()
	pad.visible = false
	joy.visible = false
	panel.visible = true
	panel.queue_redraw()

func _close_panel() -> void:
	panel.visible = false
	pad.visible = true
	joy.visible = true

## คลาสคนละสายเก็บช่องสกิลแยกกัน สกิลจึงไม่ปนสาย
func _slots() -> Array:
	var key := chosen_weapon if chosen_class == "" or chosen_class == SkillPanel.BASE_CLASS.get(chosen_weapon, "") else chosen_class
	if not equipped.has(key):
		var empty := []
		empty.resize(SLOT_COUNT)
		empty.fill("")
		equipped[key] = empty
	# ของเก่ามี 4 ช่อง ขยายเป็น 8 (ช่องใหม่ว่าง)
	var arr: Array = equipped[key]
	while arr.size() < SLOT_COUNT:
		arr.append("")
	if arr.size() > SLOT_COUNT:
		arr.resize(SLOT_COUNT)
	return equipped[key]

## สกิลที่ใส่อยู่ถอดออก สกิลใหม่ลงช่องว่างแรก
func _on_skill_toggled(id: String) -> void:
	# พาสซีฟติดตัวตลอด HYPER ใช้ปุ่มแยก ไม่ต้องใส่ช่อง
	if SkillPanel.find_skill(id).get("passive", false) or id.ends_with("_hyper"):
		return
	var slots := _slots()
	var at := slots.find(id)
	if at >= 0:
		slots[at] = ""
	else:
		at = slots.find("")
		if at >= 0:
			slots[at] = id
	_refresh_slot()

## ช่องที่ใส่สกิลแล้วถึงกดได้
## HYPER ของคลาสที่เลือก ไม่มีคืนค่าว่าง
func _hyper_skill() -> String:
	for skill in SkillPanel.SKILLS.get(SkillPanel.skill_key(chosen_weapon), []):
		if skill.get("class", "") == chosen_class and str(skill["id"]).ends_with("_hyper"):
			return skill["id"]
	return ""

# ---------------------------------------------------------------- EXP เลเวล เควส
func _exp_ratio() -> float:
	var need := LevelData.need(chosen_level)
	return 1.0 if need <= 0 else clampf(float(chosen_exp) / float(need), 0.0, 1.0)

## ตัวละครในคลังที่กำลังเล่น ทดลองเล่นคืนค่าว่าง
func roster_entry() -> Dictionary:
	var list := SaveData.roster()
	return list[roster_index] if roster_index >= 0 and roster_index < list.size() else {}

## ได้ EXP ครบแล้วเลเวลขึ้น ขึ้นข้อความ วงแสงรอบตัว บันทึกลงคลัง
func gain_exp(amount: int) -> void:
	if amount <= 0 or chosen_level >= LevelData.MAX_LEVEL:
		return
	var r := LevelData.add(chosen_level, chosen_exp, amount)
	chosen_level = int(r[0])
	chosen_exp = int(r[1])
	if roster_index >= 0:
		SaveData.update_character(roster_index, {"level": chosen_level, "exp": chosen_exp})
	bars.level = chosen_level
	bars.exp_ratio = _exp_ratio()
	bars.queue_redraw()
	if int(r[2]) > 0:
		# เลเวลอัป เควสเลเวล จดหมายฉลอง
		var qe := roster_entry()
		if not qe.is_empty():
			var had := QuestData.unread(qe)
			QuestData.on_level(qe, chosen_level)
			QuestData.commit(qe)
			if QuestData.unread(qe) > had:
				get_tree().create_timer(1.6).timeout.connect(func() -> void:
					if is_inside_tree():
						bars.notice("มีจดหมายใหม่ เหมียว~"))
		panel.level = chosen_level
		_refresh_slot()
		bars.notice("เลเวลอัป! Lv.%d เหมียว~" % chosen_level)
		hero.hp = hero.hp_max()
		hero.mp = hero.mp_max()
		var pop := CatPop.new()
		pop.tint = Color(1.0, 0.8, 0.25)
		pop.position = hero.position + Vector2(0.0, -80.0)
		pop.scale = Vector2.ONE * 2.2
		world.add_child(pop)
		Snd.play("levelup", -1.0)
		var ring := LevelUpRing.new()
		ring.position = hero.position
		world.add_child(ring)

## นับมอนที่ตีตายหรือดันที่ผ่าน ให้เควสที่รับไว้
func quest_count(town: int, kills: int, cleared_index := -1, kind := "") -> void:
	var entry := roster_entry()
	if entry.is_empty():
		return
	# เควสหลัก รอง กระดาน
	var ready: Array = []
	if kills > 0:
		ready.append_array(QuestData.on_kill(entry, town, kind))
	if cleared_index >= 0:
		ready.append_array(QuestData.on_clear(entry, town, cleared_index))
	if not ready.is_empty():
		QuestData.commit(entry)
		bars.notice("เควสสำเร็จ: %s" % str(QuestData.quest(str(ready[0])).get("title", "")))
	elif kills > 0 or cleared_index >= 0:
		QuestData.commit(entry)
	if QuestData.count(entry, town, kills, cleared_index):
		SaveData.update_character(roster_index, {"quest": entry["quest"]})
		var q := QuestData.find(str(entry["quest"]["id"]))
		if QuestData.is_done(entry, q) and not _quest_told:
			_quest_told = true
			bars.notice("เควสสำเร็จ! กลับไปส่งเควสในเมือง")

var _quest_told := false

## วงแสงทองพร้อมรอยเท้าแมวลอยขึ้นรอบตัวตอนเลเวลอัป
class LevelUpRing extends Node2D:
	var _t := 0.0
	func _process(delta: float) -> void:
		_t += delta
		if _t > 1.2:
			queue_free()
		queue_redraw()
	func _draw() -> void:
		var k := _t / 1.2
		var a := 1.0 - k
		for i in 2:
			var r := 60.0 + 140.0 * k + float(i) * 30.0
			draw_arc(Vector2(0.0, -70.0), r, 0.0, TAU, 40, Color(1.0, 0.82, 0.3, a * (0.9 - float(i) * 0.4)), 8.0 * a + 2.0, true)
		for i in 6:
			var ang := float(i) / 6.0 * TAU + _t * 2.0
			var p := Vector2(cos(ang) * 90.0, -70.0 + sin(ang) * 40.0 - 160.0 * k)
			draw_circle(p, 11.0, Color(1.0, 0.7, 0.8, a))
			for j in 3:
				draw_circle(p + Vector2((float(j) - 1.0) * 9.0, -12.0 - (2.0 if j == 1 else 0.0)), 4.5, Color(1.0, 0.7, 0.8, a))
		var font := Sketch.font()
		var word := "LEVEL UP!"
		var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 44).x
		var at := Vector2(-w * 0.5, -230.0 - 40.0 * k)
		draw_string_outline(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 44, 10, Color(0.45, 0.25, 0.05, a))
		draw_string(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 44, Color(1.0, 0.88, 0.3, a))

func _refresh_slot() -> void:
	var slots := _slots()
	var hyper_id := _hyper_skill()
	pad.hyper_ready = hyper_id != "" and SkillPanel.need_level(SkillPanel.find_skill(hyper_id)) <= chosen_level
	pad.hyper_id = hyper_id
	# สกิลของสายอื่นที่ยังไม่ได้ (หรือ HYPER) ถอดออกจากช่อง
	var allowed := panel._classes()
	for i in slots.size():
		var id := str(slots[i])
		if id == "":
			continue
		var cls: String = SkillPanel.find_skill(id).get("class", SkillPanel.BASE_CLASS.get(chosen_weapon, ""))
		if not SkillPanel.in_list(chosen_weapon, id) or id.ends_with("_hyper") or (not allowed.is_empty() and not cls in allowed):
			slots[i] = ""
	panel.equipped = slots
	for i in SLOT_COUNT:
		var id: String = slots[i]
		var slot := "s%d" % i
		pad.slot_ids[i] = id
		var info := SkillPanel.find_skill(id)
		var too_high := id != "" and SkillPanel.need_level(info) > chosen_level
		pad.slot_labels[i] = "" if id == "" else ("Lv%d" % SkillPanel.need_level(info) if too_high else str(info["slot"]))
		if id == "" or too_high:
			if not slot in pad.locked:
				pad.locked.append(slot)
		else:
			pad.locked.erase(slot)
	# แปลงร่างพลังดิบ ช่องสกิลเป็นสกิลชุดแปลงร่าง 4 อย่าง
	if susi != null and susi.has_method("tf_slots"):
		var tf: Array = susi.tf_slots()
		if not tf.is_empty():
			for i in SLOT_COUNT:
				var tid := str(tf[i]) if i < tf.size() else ""
				pad.slot_ids[i] = tid
				pad.slot_labels[i] = str(susi.tf_label(tid)) if tid != "" else ""
				if tid != "":
					pad.locked.erase("s%d" % i)
				elif not ("s%d" % i) in pad.locked:
					pad.locked.append("s%d" % i)
	pad.queue_redraw()

## สกิลในช่องที่ i (ตอนแปลงร่างเป็นสกิลชุดแปลงร่าง)
func _slot_skill(i: int) -> String:
	if susi != null and susi.has_method("tf_slots"):
		var tf: Array = susi.tf_slots()
		if not tf.is_empty():
			return str(tf[i]) if i < tf.size() else ""
	return str(_slots()[i])

## ใช้สกิลได้เฉพาะตอนยืนบนพื้น และไม่ซ้อนกับท่าที่ออกอยู่
## เสียงปล่อยสกิล นุ่มๆ สามแบบตามชนิดสกิล (ลม กระดิ่ง ประกาย)
func _skill_sound(id: String) -> void:
	var k := id.hash() % 3
	Snd.play(["skill_air", "skill_bell", "skill_spark"][absi(k)], -4.0, 0.04)

func _use_skill(id: String) -> void:
	# เลเวลไม่ถึง ใช้สกิลนี้ไม่ได้
	var need := SkillPanel.need_level(SkillPanel.find_skill(id))
	if need > chosen_level:
		bars.notice("ต้องเลเวล %d" % need)
		return
	# CRIMSON 35.4 กดสกิลเลือดซ้ำก่อนท่าออก สังเวยเลือดตัวเองเพิ่มดาเมจ
	if chosen_class == "CRIMSON KNIGHT" and combo_nth >= 0 and id == combo_name and hero.plain_move.get("blood", false) and not _combo_hit_done and hero.plain_boost_t <= 0.0:
		_blood_price()
		return
	# สกิลของ CAT SUSI ใช้ระบบของตัวเอง (มานา คูลดาวน์ กดค้าง)
	if id.begins_with("su_") or id.begins_with("bw_sk_") or id.begins_with("sp_sk_") or id.begins_with("fs_sk_") or id.begins_with("pr_sk_"):
		if susi == null:
			return
		if susi != null and not SkillPanel.find_skill(id).get("passive", false):
			var cd0: float = susi.cd_left(id)
			susi.use(id)
			# ใช้สำเร็จ (คูลดาวน์เริ่ม) ค่อยมีเสียง
			if susi.cd_left(id) > cd0 + 0.01:
				_skill_sound(id)
		return
	if hero.plain_swing > 0.0 or not hero.on_floor():
		return
	# สกิลของแมวเล่นผ่านระบบท่าคอมโบ
	if id.begins_with("cat_"):
		var info := SkillPanel.find_skill(id)
		if info.get("passive", false):
			return
		# คูลดาวน์ แล้วมานาของสกิล (HYPER 300)
		if float(skill_cds.get(id, 0.0)) > 0.0:
			bars.notice("รออีก %.1f วิ" % float(skill_cds[id]))
			return
		var need_mp := Stats.skill_mp(chosen_weapon, id)
		if hero.mp < need_mp:
			bars.notice("มานาไม่พอ (%d)" % int(need_mp))
			return
		hero.mp -= need_mp
		_skill_sound(id)
		BigSkillFx.cast(self, id, need_mp)
		skill_cds[id] = Stats.skill_cd(chosen_weapon, id)
		# สกิลใหญ่ หยุดเวลาชั่วครู่
		if need_mp >= 250.0 and not id.ends_with("_hyper"):
			time_stop(0.45)
		# GRAND KNIGHT 60.2 ใช้สกิล 12% ลดคูลดาวน์ทุกช่องลงครึ่ง
		if chosen_class == "GRAND KNIGHT" and chosen_level >= 60 and randf() < 0.12:
			for k in skill_cds.keys():
				if k != id:
					skill_cds[k] = float(skill_cds[k]) * 0.5
		if _line("SHIELD KNIGHT"):
			hero.plain_sa_t = maxf(hero.plain_sa_t, SH_WALL_SA)
		if id == "cat_gk_hyper":
			_start_hyper(CatGrandHyper.new())
			return
		if id == "cat_fk_hyper":
			_start_hyper(CatFlameHyper.new())
			return
		if id == "cat_gd_hyper":
			_start_hyper(CatGuardHyper.new())
			return
		if id == "cat_ck_hyper":
			_start_hyper(CatCrimsonHyper.new())
			return
		if id == "cat_em_hyper":
			_start_hyper(CatElementHyper.new())
			return
		if id == "cat_dc_hyper":
			_start_hyper(CatDimBallHyper.new())
			return
		if id == "cat_ec_hyper":
			_start_hyper(CatEclipseHyper.new())
			return
		if id == "cat_tm_hyper":
			_start_hyper(CatGoldTreeHyper.new())
			return
		# HYPER ของ CAT MATCHA
		if id == "cat_gt_hyper":
			_start_hyper(_new_hyper("res://cat_gale_hyper.gd"))
			return
		if id == "cat_as_hyper":
			_start_hyper(_new_hyper("res://cat_apex_hyper.gd"))
			return
		if id == "cat_eb_hyper":
			_start_hyper(_new_hyper("res://cat_elemental_bow_hyper.gd"))
			return
		if id == "cat_tw_hyper":
			_start_hyper(_new_hyper("res://cat_twilight_hyper.gd"))
			return
		# HYPER ของ CAT CITRUS
		var pair_hypers := {"cat_so_hyper": "res://cat_somnambulist_hyper.gd", "cat_nb_hyper": "res://cat_neonbolt_hyper.gd", "cat_hd_hyper": "res://cat_duet_hyper.gd", "cat_ie_hyper": "res://cat_psyche_hyper.gd"}
		if pair_hypers.has(id):
			var ph := _new_hyper(str(pair_hypers[id]))
			if ph != null:
				_start_hyper(ph)
			return
		var spear_hypers := {"cat_fp_hyper": "res://cat_prowler_hyper.gd", "cat_ld_hyper": "res://cat_lupine_hyper.gd", "cat_pv_hyper": "res://cat_vulpine_hyper.gd", "cat_gt2_hyper": "res://cat_genbu_hyper.gd"}
		if spear_hypers.has(id):
			var hs := _new_hyper(str(spear_hypers[id]))
			if hs != null:
				_start_hyper(hs)
			return
		var fist_hypers := {"cat_gs_hyper": "res://cat_sumo_hyper.gd", "cat_kf_hyper": "res://cat_kungfu_hyper.gd", "cat_mt_hyper": "res://cat_muaythai_hyper.gd", "cat_sb_hyper": "res://cat_sambo_hyper.gd"}
		if fist_hypers.has(id):
			var hf := _new_hyper(str(fist_hypers[id]))
			if hf != null:
				_start_hyper(hf)
			return
		if id == "cat_gk_whirl":
			_start_whirl()
			return
		_start_combo("cat_rush1" if id == "cat_rush" else id)
		return

func _start_hyper(stage: HyperStage) -> void:
	Snd.play("hyper", -1.0)
	Snd.buzz(30)
	pad.reset()
	joy.release()
	pad.visible = false
	joy.visible = false
	bars.visible = false
	hyper = stage
	hyper.page = self
	hyper.hero = hero
	hyper.finished.connect(_end_hyper)
	if hyper.behind_view:
		add_child(hyper)
	else:
		world.add_child(hyper)

func _end_hyper() -> void:
	hyper = null
	frame.k = 0.0
	frame.dark = false
	pad.visible = true
	joy.visible = true
	bars.visible = true

func _process(delta: float) -> void:
	# ตีไม่โดนมอน จอไม่สั่น
	if not is_town() and not is_dungeon():
		_tick_air(delta)
		if hyper == null and shake_left <= 0.0:
			world.position.y = _home_y()
		if room != null:
			room.position.y = air_y
	if shake_left > 0.0 and Time.get_ticks_msec() - _hit_clock > SHAKE_HIT_WINDOW:
		shake_left = 0.0
		world.position = Vector2(_home_x(), _home_y())
	if hyper == null and shake_left > 0.0:
		shake_left = maxf(shake_left - delta, 0.0)
		var home := Vector2(_home_x(), _home_y())
		var power := SHAKE_POWER * shake_left / SHAKE_TIME
		world.position = home + Vector2(sin(shake_left * SHAKE_SPEED), cos(shake_left * SHAKE_SPEED * 1.3)) * power
	if hyper != null:
		frame.dark = hyper.black_backdrop
		frame.k = hyper.frame_k

## จอสั่นหนึ่งที แล้วพื้นดินประทุจากจุดปักดาบไปข้างหน้า
func _spawn_light_blade() -> void:
	if not is_inside_tree():
		return
	var blade := ChibiLightBlade.new()
	blade.hitter = _hit_area
	blade.dir = hero.facing
	blade.position = Vector2(hero.position.x, 0.0)
	world.add_child(blade)

func _on_sword_planted() -> void:
	shake_left = maxf(shake_left, SWORD_SHAKE)

## คอมโบของ BASIC กด Z หรือ X เริ่มท่าตามสถานะ บนพื้น ตอนแดช กลางอากาศ และกลางอากาศหลังแดชกระโดด
## ระหว่างท่ากดปุ่มเพื่อต่อท่าถัดไปตาม Hero.CHIBI_NEXT
func press_z() -> void:
	press_attack("z")

func press_x() -> void:
	press_attack("x")

## กดปุ่มลงค้างไว้
func _down_held() -> bool:
	return pad.is_held("down") or joy.vector().y > 0.55 or Input.is_key_pressed(KEY_DOWN)

## กดทิศที่หันอยู่ค้างไว้
var _dir_hold_t := 0.0
var _dir_hold_sign := 0.0
const FRESH_DIR := 0.35         # กดทิศมาไม่เกินเท่านี้ถึงนับเป็น ">" (กดค้างเดินมานานไม่นับ)
const COMBO_DRIFT := 1.4        # ตีไปเดินไปช้าๆ หน่วยต่อวินาที

func _forward_held() -> bool:
	if _dir_hold_t > FRESH_DIR:
		return false
	if joy.direction() != 0.0 and joy.direction() == signf(hero.facing):
		return true
	if hero.facing > 0.0:
		return pad.is_held("right") or Input.is_key_pressed(KEY_RIGHT)
	return pad.is_held("left") or Input.is_key_pressed(KEY_LEFT)

## กดทิศตรงข้ามกับที่หันอยู่ค้างไว้
func _back_held() -> bool:
	if joy.direction() != 0.0 and joy.direction() == -signf(hero.facing):
		return true
	if hero.facing > 0.0:
		return pad.is_held("left") or Input.is_key_pressed(KEY_LEFT)
	return pad.is_held("right") or Input.is_key_pressed(KEY_RIGHT)

## คอมโบของ CAT SUSI ตาราง MageCombo
func _press_mage(button: String) -> void:
	if combo_nth >= 0:
		# จำปุ่มไว้ ถ้าท่านี้ต่อท่าถัดไปเอง (auto) จะลองต่อจากท่าใหม่ให้ ไม่ทิ้งปุ่มที่กดไว้
		_queued_btn = button
		_queued_btn_t = 0.45
		var next := _table_next(button)
		if next == "":
			# ท่าเดิมจบแล้วกำลังกลับท่ายืน กดปุ่มที่ต่อไม่ได้ ให้เริ่มคอมโบใหม่เลย ไม่ทิ้งปุ่ม
			if _combo_t >= float(hero.plain_move.get("time", 0.4)) and not hero.plain_move.has("auto") and not hero.plain_move.get("stance", false):
				_end_combo()
			else:
				return
		else:
			# กดรัวต่อท่าเดิมได้ไม่เกินที่กำหนด
			if next == combo_name and _repeat_count + 1 >= int(hero.plain_move.get("repeat", 1)):
				return
			_combo_queued = next
			return
	if hero.plain_swing > 0.0:
		return
	var state := ""
	if hero.on_floor():
		state = "dash" if hero.dash_t > 0.0 else "ground"
	elif not _air_started:
		_air_started = true
		state = "airdash" if hero.jump_dashed else "air"
	if state != "":
		_start_combo(_table_start(state, button))

## ตารางคอมโบตามอาวุธ SUSI MATCHA CITRUS
func _table_next(button: String) -> String:
	if chosen_weapon == "bow":
		return BowCombo.next(chosen_class, combo_name, button, _down_held(), _forward_held())
	if chosen_weapon == "spear":
		return SpearCombo.next(chosen_class, combo_name, button, _down_held(), _forward_held(), _back_held())
	if chosen_weapon == "fist":
		return FistCombo.next(chosen_class, combo_name, button, _down_held(), _forward_held(), _back_held())
	if chosen_weapon == "azure":
		return PairCombo.next(chosen_class, combo_name, button, _down_held(), _forward_held(), _back_held())
	return MageCombo.next(chosen_class, combo_name, button, _down_held(), _forward_held())

func _table_start(state: String, button: String) -> String:
	if chosen_weapon == "bow":
		return BowCombo.start(chosen_class, state, button)
	if chosen_weapon == "spear":
		return SpearCombo.start(chosen_class, state, button, _down_held(), _back_held(), _forward_held())
	if chosen_weapon == "fist":
		return FistCombo.start(chosen_class, state, button, _down_held(), _back_held(), _forward_held())
	if chosen_weapon == "azure":
		return PairCombo.start(chosen_class, state, button, _down_held(), _back_held(), _forward_held())
	return MageCombo.start(chosen_class, state, button)

func press_attack(button: String) -> void:
	if chosen_weapon == "mage" or chosen_weapon == "bow" or chosen_weapon == "spear" or chosen_weapon == "fist" or chosen_weapon == "azure":
		_press_mage(button)
		return
	if combo_nth >= 0:
		var next: String = Hero.chibi_next(chosen_class, combo_name, button)
		if next.begins_with("dk_blood") and next != "dk_blood45" and combo_name.begins_with("dk_blood") and _blood_count >= BLOOD_MAX:
			return
		if next != "":
			_combo_queued = next
		return
	if hero.plain_swing > 0.0:
		return
	var start := ""
	if hero.on_floor():
		if hero.dash_t > 0.0:
			start = "dz1" if button == "z" else "dx"
		else:
			start = "z1" if button == "z" else "x1"
	elif not _air_started:
		_air_started = true
		if hero.jump_dashed:
			start = "adz1" if button == "z" else "adx1"
		else:
			start = "az" if button == "z" else "ax"
	if start != "":
		_start_combo(start)

func _start_combo_hit(nth: int) -> void:
	_start_combo("z%d" % (nth + 1))

func _start_combo(id: String) -> void:
	_combo_air = not hero.on_floor()
	_dir_released = false
	var prev: Dictionary = Hero.chibi_move_for(chosen_class, combo_name) if combo_nth >= 0 else {}
	_repeat_count = _repeat_count + 1 if id == combo_name and combo_nth >= 0 else 0
	combo_name = id
	combo_nth = int(id.substr(1)) - 1 if id.length() == 2 and id[0] == "z" and id[1].is_valid_int() else 99
	_combo_t = 0.0
	_combo_hit_done = false
	_combo_queued = ""
	hero.dash_t = 0.0
	hero.plain_swing_kind = "combo"
	_blood_count = _blood_count + 1 if id == "dk_blood" or id == "dk_blood_b" else 0
	hero.plain_move = Hero.chibi_move_for(chosen_class, id)
	_multi_hit = {}
	_hold_t = 0.0
	_multi_t = 0.0
	_after_t = 0.0
	_pulse_t = PULSE_GAP
	if hero.plain_move.get("fx", "") == "summon":
		_summon_orb()
	# ท่าที่ดีดตัวขึ้นก่อน บนพื้นหรือกลางอากาศก็ได้
	if hero.plain_move.has("leap"):
		if hero.on_floor():
			hero.pos.y = 0.01
		hero.vel.y = float(hero.plain_move["leap"])
		_air_started = true
	_cast(hero.plain_move.get("fx_start", ""))
	hero.plain_prev = prev
	hero.plain_combo_id += 1
	if hero.plain_move.has("turn_around"):
		hero.facing = -hero.facing
	hero.plain_combo_nth = maxi(combo_nth, 0)
	hero.plain_combo_rest = 0.0
	hero.plain_swing = 0.001

## ท่ากลางอากาศค้างตัวไว้ไม่ตก ท่าพุ่งลงเร่งลงจนถึงพื้น
func _hold_air(hit: Dictionary, u: float) -> void:
	if hero.on_floor():
		return
	if hit.has("dive") and u >= float(hit["wind"]):
		hero.vel.y = -Hero.CHIBI_DIVE_SPEED * (0.6 if hit.has("dive_forward") else 1.0)
		if hit.has("dive_forward"):
			hero.pos.x = clampf(hero.pos.x + hero.facing * float(hit["dive_forward"]) * get_physics_process_delta_time(), -hero.half_width, hero.half_width)
	elif hit.has("hover") and (not hit.has("hover_apex") or hero.vel.y <= 0.0):
		hero.vel.y = 0.0

## ลูกไฟลอยอยู่หน้าตัว กดค้างเพื่อชาร์จให้ใหญ่ขึ้น
func _summon_orb() -> void:
	if is_instance_valid(_orb):
		_orb.queue_free()
	var orb := CatFireball.new()
	orb.position = Vector2(hero.position.x + hero.facing * ORB_AHEAD, -ORB_UP)
	# ลูกไฟลอยหน้ามือข้างที่ไม่ได้ถือดาบ
	if hero.plain_model != null:
		orb.position = world.to_local(hero.plain_model.off_hand_global()) + Vector2(hero.facing * 90.0, -10.0)
	world.add_child(orb)
	_orb = orb
	# ไม่ได้ระเบิดภายในเวลานี้ ลูกไฟหายเอง จับลูกนี้ไว้ ไม่ไปลบลูกที่เรียกใหม่
	var ref: WeakRef = weakref(orb)
	get_tree().create_timer(2.5).timeout.connect(func() -> void:
		var left = ref.get_ref()
		if left != null and not left.bursting:
			left.queue_free())

## จุดปล่อยเวทจากมือข้างที่ไม่ได้ถือดาบ ไม่มีโมเดลใช้จุดหน้าตัว
func _cast_point(fallback: Vector2) -> Vector2:
	# CAT MATCHA ยิงธนูจากมือที่ถือคันธนู
	if hero.plain_model != null and hero.plain_move.get("bow_cast", false):
		return world.to_local(hero.plain_model.weapon_hand_global()) + Vector2(hero.facing * 40.0, -10.0)
	if hero.plain_model != null and hero.plain_move.get("hand_cast", false):
		return world.to_local(hero.plain_model.off_hand_global()) + Vector2(hero.facing * 30.0, 0.0)
	return fallback

func _cast(fx: String) -> void:
	# รอยหอกของ CAT CITRUS
	if fx.begins_with("sp_"):
		SpearFx.cast(self, fx)
		return
	# เอฟเฟกต์คอมโบของ CAT AZURE & LAPIS
	if fx.begins_with("pc_"):
		PairFx.cast(self, fx)
		return
	# เอฟเฟกต์หมัดเท้าสีเทาของ CAT ASH
	if fx.begins_with("fs"):
		FistFx.cast(self, fx)
		return
	for line in SpearCombo.lines():
		if line.cast(self, fx):
			return
	if fx.begins_with("mg_") or fx.begins_with("bw"):
		if _mage != null:
			_mage.cast(fx)
		return
	# ปล่อยสกิลของแมว มีดาววิ้งกับรอยเท้าแมวด้านหน้า
	if fx != "" and chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and combo_name.begins_with("cat_") and not fx in ["roar", "shock", "mist"]:
		_cute_pop(hero.position + Vector2(hero.facing * 90.0, -90.0))
	match fx:
		"burst":
			if not is_instance_valid(_orb) or _orb.bursting:
				return
			var full := _orb.charge >= 0.99
			var reach := BURST_RADIUS * (1.0 + _orb.charge * 0.4)
			# ชาร์จเต็มแล้ว มอนบนพื้นไม่ลอย แต่ดาเมจแรงกว่า
			var extra := {"type": "launch", "vy": 10.0}
			for e in get_tree().get_nodes_in_group("monsters"):
				var monster := e as Monster
				if monster == null or (monster.position + Vector2(0.0, -MONSTER_MID)).distance_to(_orb.position) > reach + MONSTER_HIT_R:
					continue
				var h := {"type": "flinch", "dmg": BURST_CHARGED_DMG if full else BURST_DMG, "skill": true, "stun": 0.6, "kb": 1.5}
				if not (full and monster.on_floor()):
					h.merge(extra, true)
				monster.take_hit(h, hero.facing)
			_orb.burst()
			shake_left = maxf(shake_left, 0.3)
		"shot":
			_fire(_cast_point(Vector2(hero.position.x + hero.facing * 70.0, -80.0)), Vector2(hero.facing, 0.0) * SHOT_SPEED, SHOT_RADIUS, SHOT_DMG, {"kb": 2.5, "stun": 0.6})
		"storm":
			var storm := CatStorm.new()
			storm.dir = hero.facing
			storm.hitter = _hit_area
			storm.position = Vector2(hero.position.x + hero.facing * STORM_AHEAD, 0.0)
			world.add_child(storm)
		"wave", "pound":
			var burst := CatEruption.new()
			burst.dir = hero.facing
			burst.hitter = _hit_area
			burst.position = Vector2(hero.position.x + hero.facing * 90.0, 0.0)
			world.add_child(burst)
		"smoke":
			var smoke := CatCrack.new()
			smoke.smoke_only = true
			smoke.position = Vector2(hero.position.x + hero.facing * 70.0, 0.0)
			world.add_child(smoke)
		"crack", "mist":
			var crack := CatCrack.new()
			crack.mist_only = fx == "mist"
			crack.lava = _line("SWORD KNIGHT")
			crack.position = Vector2(hero.position.x, 0.0)
			world.add_child(crack)
		"blast":
			var at := _cast_point(Vector2(hero.position.x + hero.facing * 70.0, -80.0))
			_fire(at, Vector2(hero.facing, 0.0) * SHOT_SPEED, SHOT45_RADIUS, 10.0, {"kb": 1.0, "stun": 0.4, "magic": true, "burn": "fire"}, false, 1)
			_shots[_shots.size() - 1][4] = BLAST_RANGE
			_shots[_shots.size() - 1][7] = true
		"sword_row":
			var row := ChibiSwordRow.new()
			row.hitter = _hit_area
			row.dir = hero.facing
			row.blade_w = ChibiSwordRow.BODY_W * 3.5
			row.position = Vector2(hero.position.x + hero.facing * ROW_AHEAD, 0.0)
			world.add_child(row)
		"light_blade":
			_spawn_light_blade()
		"fire_wave":
			for side in [-1.0, 1.0]:
				var flames := CatEruption.new()
				flames.fire = true
				flames.bursts = 10
				flames.linger = 4.0
				flames.dir = side
				flames.hitter = _hit_area
				flames.position = Vector2(hero.position.x + side * 60.0, 0.0)
				world.add_child(flames)
		"ignite":
			hero.plain_fire_t = IGNITE_TIME
		"vortex":
			var spin := CatFireVortex.new()
			spin.position = Vector2(hero.position.x, 0.0)
			world.add_child(spin)
			_vortex.append([spin, VORTEX_HITS, 0.1, 2, {"kb": 0.2, "stun": 0.25, "magic": true, "burn": "fire"}, {"type": "launch", "vy": 7.0, "magic": true, "burn": "fire"}, VORTEX_BURST_DMG])
		"sparks":
			# ประกายแดงกระจายเป็นรูปพัดจากปลายดาบ
			for k in 11:
				var a := deg_to_rad(lerpf(-55.0, 6.0, float(k) / 10.0))
				_fire(Vector2(hero.position.x + hero.facing * 80.0, -20.0), Vector2(hero.facing * cos(a), sin(a)) * randf_range(850.0, 1100.0), 24.0, 9.0, {"kb": 1.0, "stun": 0.4}, false, 2)
				(_shots[_shots.size() - 1][0] as CatFireball).spark = true
		"crack_line":
			shake_left = maxf(shake_left, 0.3)
			var rift := CatRedCrack.new()
			rift.dir = hero.facing
			rift.hitter = _hit_area
			rift.position = Vector2(hero.position.x + hero.facing * 60.0, 0.0)
			world.add_child(rift)
		"crack_big":
			var big := CatCrack.new()
			big.big = true
			big.lava = true
			big.position = Vector2(hero.position.x, 0.0)
			world.add_child(big)
		"shield_quake":
			var quake_big := CatCrack.new()
			quake_big.big = true
			quake_big.position = Vector2(hero.position.x, 0.0)
			world.add_child(quake_big)
			_shock_ring(hero.position.x)
		"sword_wave":
			# ปล่อย 2 ลูก ลูกแรกเล็ก ลูกสองใหญ่ตามมา
			_sk_wave(240.0, 1.4)
			get_tree().create_timer(0.3).timeout.connect(func() -> void:
				if is_inside_tree():
					_sk_wave(420.0, 1.9))
		"quake":
			var front := hero.position.x + hero.facing * 150.0
			_hit_area(front, 150.0, 16.0, hero.facing, null, {"type": "launch", "vy": 7.0})
			var quake := CatCrack.new()
			quake.position = Vector2(front, 0.0)
			world.add_child(quake)
		"shield_throw":
			var thrown := CatShieldThrow.new()
			thrown.dir = hero.facing
			thrown.target = hero
			thrown.hitter = _hit_area
			thrown.position = hero.position + Vector2(hero.facing * 60.0, -80.0)
			world.add_child(thrown)
		"taunt":
			for e in get_tree().get_nodes_in_group("monsters"):
				var monster := e as Monster
				if monster == null:
					continue
				var d: float = monster.pos.x - hero.pos.x
				if absf(d) <= TAUNT_RANGE:
					monster.pos.x = hero.pos.x + signf(d if d != 0.0 else hero.facing) * TAUNT_GAP
					_strike(monster, {"type": "flinch", "dmg": 4.0, "skill": true, "stun": 1.0, "kb": 0.0}, -signf(d))
			hero.plain_sa_t = maxf(hero.plain_sa_t, TAUNT_SA)
			var ring := CatCrack.new()
			ring.smoke_only = true
			ring.position = Vector2(hero.position.x, 0.0)
			world.add_child(ring)
		"dome":
			var dome := CatDome.new()
			dome.target = hero
			dome.hitter = _hit_area
			dome.position = hero.position
			world.add_child(dome)
			hero.plain_sa_t = maxf(hero.plain_sa_t, CatDome.LIFE)
		"dark_erupt":
			var spikes := CatEruption.new()
			spikes.dark = true
			spikes.dir = hero.facing
			spikes.hitter = _hit_area
			spikes.position = Vector2(hero.position.x + hero.facing * 90.0, 0.0)
			world.add_child(spikes)
		"shock":
			_shock_ring(hero.position.x)
		"phoenix":
			var bird := CatPhoenix.new()
			bird.position = Vector2(hero.position.x, -40.0)
			world.add_child(bird)
			_zone(bird, CatPhoenix.LIFE - 0.1, 0.2, bird.hit_half, 6.0, {"kb": 0.2, "stun": 0.3, "magic": true, "burn": "fire"})
		"fire_orb":
			var orb := CatFireball.new()
			orb.radius = 70.0 * (FK_BALL_SIZE if chosen_class == "FLAME KNIGHT" else 1.0)
			orb.position = Vector2(hero.position.x + hero.facing * 230.0, -110.0)
			world.add_child(orb)
			_zone(orb, 5.0, 0.25, orb.radius + 50.0, 5.0, {"kb": 0.2, "stun": 0.25, "magic": true, "burn": "fire", "fireball": true})
		"fire_wheel":
			var wheel := CatFireball.new()
			wheel.radius = 150.0 * (FK_BALL_SIZE if chosen_class == "FLAME KNIGHT" else 1.0)
			wheel.tail = Vector2.ZERO
			wheel.position = Vector2(hero.position.x + hero.facing * 260.0, -wheel.radius - 10.0)
			world.add_child(wheel)
			var dist := 2.0 * _screen_w()
			_zone(wheel, dist / 700.0, 0.25, wheel.radius + 30.0, 8.0, {"kb": 0.5, "stun": 0.3, "magic": true, "burn": "fire", "fireball": true}, hero.facing * 700.0, hero.facing * 7.0)
		"sky_blade":
			var sky := CatSkyBlade.new()
			sky.hitter = _hit_area
			sky.position = Vector2(hero.position.x + hero.facing * 380.0, 0.0)
			world.add_child(sky)
		"mana_circle":
			var circle := CatMagicCircle.new()
			circle.position = Vector2(hero.position.x, 0.0)
			world.add_child(circle)
			_circles.append([circle, "mana"])
		"nova":
			var nova := CatFireball.new()
			var r := 120.0 * (FK_BALL_SIZE if chosen_class == "FLAME KNIGHT" else 1.0)
			nova.radius = r
			nova.position = Vector2(hero.position.x + hero.facing * 300.0, -r - 20.0)
			world.add_child(nova)
			var tw := nova.create_tween()
			tw.tween_property(nova, "radius", r * 1.25, 0.25)
			tw.tween_property(nova, "radius", r * 0.45, 0.3)
			tw.tween_callback(func() -> void:
				if is_inside_tree():
					_hit_area(nova.position.x, r + 140.0, 60.0, hero.facing, null, {"type": "launch", "vy": 10.0, "magic": true, "burn": "fire", "fireball": true})
					shake_left = maxf(shake_left, 0.4)
				nova.burst())
		"roar":
			var roar := CatShout.new()
			roar.reach = _screen_w() * 0.5
			roar.position = hero.position
			world.add_child(roar)
			_hit_area(hero.position.x, _screen_w() * 0.5, 6.0, hero.facing, null, {"kb": 0.3, "stun": 0.35})
			if randf() < 0.6:
				var split := CatCrack.new()
				split.position = Vector2(hero.position.x + randf_range(-1.0, 1.0) * _screen_w() * 0.4, 0.0)
				world.add_child(split)
		"horn":
			var horn := CatShout.new()
			horn.dir = hero.facing
			horn.cone = 0.45
			horn.reach = _screen_w() * 0.5
			horn.position = hero.position + Vector2(hero.facing * 50.0, 0.0)
			world.add_child(horn)
			_hit_area(hero.position.x + hero.facing * _screen_w() * 0.25, _screen_w() * 0.25, 12.0, hero.facing, null, {"kb": 0.5, "stun": 1.6, "real_stun": true})
		"shout_trail":
			var start := CatShout.new()
			start.reach = 520.0
			start.ring_round = true
			start.position = hero.position + Vector2(hero.facing * 200.0, 0.0)
			world.add_child(start)
			var x0 := hero.position.x
			var face := hero.facing
			var step := 2.0 * _screen_w() / 12.0
			for i in 12:
				get_tree().create_timer(0.1 + 0.12 * float(i)).timeout.connect(func() -> void:
					if not is_inside_tree():
						return
					var x := x0 + face * step * float(i + 1)
					var mark := CatShout.new()
					mark.reach = 260.0
					mark.ring_round = true
					mark.position = Vector2(x, 0.0)
					world.add_child(mark)
					_hit_area(x, 200.0, 10.0, face, null, {"kb": 0.6, "stun": 0.4}))
		"rally":
			hero.plain_mana_t = GD_MANA_TIME
			# วงกลมตะโกนรอบตัวแนวตั้ง กว้างมาก โดน 1 ฮิต
			var cheer := CatShout.new()
			cheer.reach = RALLY_REACH
			cheer.ring_round = true
			cheer.position = hero.position
			world.add_child(cheer)
			_hit_area(hero.position.x, RALLY_REACH, 30.0, hero.facing, null, {"kb": 1.5, "stun": 0.6})
			var glow := CatGlow.new()
			glow.target = hero
			world.add_child(glow)
		"banner":
			var ring := CatMagicCircle.new()
			ring.radius = 520.0
			ring.life = 10.0
			ring.pillar = false
			ring.tint = Color(1.0, 0.25, 0.22)
			ring.position = Vector2(hero.position.x, 0.0)
			world.add_child(ring)
			_circles.append([ring, "sa"])
			var shout_b := CatShout.new()
			shout_b.reach = 560.0
			shout_b.color = Color(1.0, 0.45, 0.4)
			shout_b.position = hero.position
			world.add_child(shout_b)
		"smash_wave":
			var smash := CatShockwave.new()
			smash.dir = hero.facing
			smash.hitter = _hit_area
			smash.position = Vector2(hero.position.x + hero.facing * 120.0, 0.0)
			world.add_child(smash)
		"slash_marks":
			var marks := CatSlashMarks.new()
			marks.dir = hero.facing
			marks.width = _screen_w() * 0.5
			marks.hitter = _hit_area
			marks.position = Vector2(hero.position.x, 0.0)
			world.add_child(marks)
		"blood_pull":
			var tip := hero.pos.x + hero.facing * 1.8
			for e in get_tree().get_nodes_in_group("monsters"):
				var monster := e as Monster
				if monster == null:
					continue
				var d: float = (monster.pos.x - hero.pos.x) * hero.facing
				if d > 0.0 and d * CombatData.UNIT < 800.0:
					monster.pos.x = tip + randf_range(-0.2, 0.2)
					monster.vel.x = 0.0
					_strike(monster, {"type": "flinch", "dmg": 3.0, "skill": true, "stun": 0.5, "kb": 0.0}, -hero.facing)
			var tip_px := tip * CombatData.UNIT
			get_tree().create_timer(0.35).timeout.connect(func() -> void:
				if not is_inside_tree():
					return
				var pop := CatFireball.new()
				pop.blood = true
				pop.radius = 110.0
				pop.position = Vector2(tip_px, -80.0)
				world.add_child(pop)
				pop.burst()
				_hit_area(tip_px, 220.0, 40.0, hero.facing, null, {"type": "launch", "vy": 6.0})
				shake_left = maxf(shake_left, 0.35))
		"chakram":
			var wheel_b := CatChakram.new()
			wheel_b.position = Vector2(hero.position.x + hero.facing * 200.0, 0.0)
			world.add_child(wheel_b)
			_zone(wheel_b, 8.0, 0.25, CatChakram.RX, 6.0, {"kb": 0.0, "stun": 0.3, "slow": 4.0}, hero.facing * 260.0)
		"offering":
			var spray := CatBloodSpray.new()
			spray.position = Vector2(hero.position.x, 0.0)
			world.add_child(spray)
			_zone(spray, 0.6, 0.12, 280.0, 4.0, {"kb": 0.0, "stun": 0.2, "armor_break": true}, 0.0, 0.0, true)
			hero.plain_atk_t = 15.0
		"orbit":
			var orbit := CatOrbit.new()
			orbit.target = hero
			orbit.position = hero.position
			world.add_child(orbit)
			_zone(orbit, 10.0, 0.15, orbit.hit_half, 3.0, {"type": "none"})
		"blood_sky":
			var bsky := CatSkyBlade.new()
			bsky.blood = true
			bsky.hitter = _hit_area
			bsky.position = Vector2(hero.position.x + hero.facing * 330.0, 0.0)
			world.add_child(bsky)
		"blood_flash":
			hero.plain_blood_t = maxf(hero.plain_blood_t, 1.0)
		"aura_on":
			hero.plain_aura_t = AURA_TIME
		"red_storm":
			var big_storm := CatBloodStorm.new()
			big_storm.light = true
			big_storm.dir = hero.facing
			big_storm.scale = Vector2.ONE * RED_STORM_SCALE
			big_storm.position = Vector2(hero.position.x + hero.facing * 120.0, 0.0)
			world.add_child(big_storm)
			var dist := 1.5 * _view.x / ZOOM
			_pushers.append([big_storm, hero.facing, dist, 0.1, dist / RED_STORM_TIME])
		"aura_slash":
			var cleave := CatAuraSlash.new()
			cleave.dir = hero.facing
			cleave.hitter = _hit_area
			cleave.radius = _view.x * 0.5 / ZOOM
			cleave.position = Vector2(hero.position.x, 0.0)
			world.add_child(cleave)
		"red_ring":
			var ring := CatRing.new()
			ring.hitter = _hit_area
			ring.position = Vector2(hero.position.x, 0.0)
			world.add_child(ring)
		"blood_beam":
			var charge := clampf(_hold_t / float(hero.plain_move.get("hold", 1.0)), 0.0, 1.0)
			var beam := CatBloodBeam.new()
			beam.dir = hero.facing
			beam.hitter = _hit_area
			beam.length = BEAM_MIN + BEAM_MAX_EXTRA * charge
			beam.thick = 100.0 + 70.0 * charge
			beam.position = hero.position + Vector2(hero.facing * 80.0, -55.0)
			world.add_child(beam)
			shake_left = maxf(shake_left, 0.3)
		"blood_sword":
			hero.plain_blood_t = BLOOD_SWORD_TIME
		"blood_pool":
			var pool := CatBloodPool.new()
			pool.dir = hero.facing
			pool.hitter = _hit_area
			pool.position = Vector2(hero.position.x + hero.facing * 220.0, 0.0)
			world.add_child(pool)
		"blood_aura":
			var aura := CatBloodAura.new()
			aura.target = hero
			aura.position = hero.position
			world.add_child(aura)
		"blood_storm":
			var cx := hero.position.x
			var pair: Array = []
			for side in [-1.0, 1.0]:
				var storm := CatBloodStorm.new()
				storm.dir = -side
				storm.position = Vector2(cx + side * STORM_START, 0.0)
				world.add_child(storm)
				pair.append(storm)
			_storms.append([pair[0], pair[1], cx, 0.2])
		"sa_buff":
			hero.plain_sa_t = SA_BUFF_TIME
		"blood_shot":
			# ลูกเลือดเลียดไปกับพื้น ทะลุได้ 2 ตัว จึงโดนได้ 3 ตัว ลูกสุดท้ายของชุดทำมอนกระเด็น
			var last := _blood_count >= BLOOD_MAX or _combo_queued == ""
			var push := {"type": "knockdown", "fly": 7.0} if last else {"kb": 0.8, "stun": 0.35}
			_fire(Vector2(hero.position.x + hero.facing * 70.0, -BLOOD_LOW), Vector2(hero.facing, 0.0) * BLOOD_SPEED, BLOOD_RADIUS, BLOOD_DMG, push, true, 3)
		"blood45":
			_fire(hero.position + Vector2(hero.facing * 60.0, -70.0), Vector2(hero.facing, 1.0).normalized() * BLOOD_SPEED, BLOOD_RADIUS, BLOOD45_DMG, {"kb": 1.2, "stun": 0.45, "air_lift": 2.0}, true, 2)
		"shot45":
			_fire(_cast_point(hero.position + Vector2(hero.facing * 60.0, -70.0)), Vector2(hero.facing, 1.0).normalized() * SHOT45_SPEED, SHOT45_RADIUS, SHOT45_DMG, {"kb": 1.5, "stun": 0.5, "air_lift": 2.0})

## ลูกไฟพุ่ง ทะลุมอนได้ 1 ตัว โดนตัวที่สองแล้วหาย
func _fire(at: Vector2, vel: Vector2, radius: float, dmg: float, extra: Dictionary, blood := false, hits := 2) -> void:
	# CAT SUSI ใช้ลูกบอลไฟของตัวเอง
	var ball: CatFireball = CatFireball.new()
	if chosen_weapon == "mage" and not blood:
		ball = MageOrb.new()
	elif chosen_weapon == "bow" and not blood:
		ball = CatArrow.new()
	if chosen_class == "FLAME KNIGHT" and not blood:
		radius *= FK_BALL_SIZE
	# ลูกที่ปล่อยจากสกิลแมว ย่อตาม SkillScale (ลูกคอมโบไม่ย่อ)
	if combo_name.begins_with("cat_"):
		radius *= SkillScale.K
	ball.radius = radius
	ball.position = at
	ball.tail = -vel.normalized()
	ball.blood = blood
	world.add_child(ball)
	_shots.append([ball, vel, hits, {}, SHOT_LIFE, dmg, extra, false])
	if susi != null and not blood:
		susi.mod_shot(_shots[_shots.size() - 1])

## ระเบิดเป็นวง โดนมอนทุกตัวในรัศมี
func _explode(at: Vector2, radius: float, dmg: float, extra: Dictionary) -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		var monster := e as Monster
		if monster == null or (monster.position + Vector2(0.0, -MONSTER_MID)).distance_to(at) > radius + MONSTER_HIT_R:
			continue
		var h := {"type": "flinch", "dmg": dmg, "skill": true, "stun": 0.5, "kb": 1.5}
		h.merge(extra, true)
		_strike(monster, h, hero.facing)
	shake_left = maxf(shake_left, 0.25)
	if chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"]:
		_cute_pop(at)

## ลูกไฟยักษ์หมุนอยู่กับที่ ทำดาเมจรอบตัวเป็นจังหวะ ครบแล้วระเบิด
## [โหนด ฮิตที่เหลือ เวลาถึงฮิตถัดไป ระเบิดที่เหลือ ผลฮิตย่อย ผลระเบิด ดาเมจระเบิด]
func _tick_vortex(delta: float) -> void:
	for v in _vortex.duplicate():
		var node: Node2D = v[0]
		if not is_instance_valid(node):
			_vortex.erase(v)
			continue
		v[2] -= delta
		if v[2] > 0.0:
			continue
		var half: float = node.get("hit_half")
		if v[1] > 0:
			v[1] -= 1
			v[2] = VORTEX_GAP
			_hit_area(node.position.x, half, VORTEX_DMG, hero.facing, null, (v[4] as Dictionary).duplicate())
		elif v[3] > 0:
			v[3] -= 1
			v[2] = 0.15
			_hit_area(node.position.x, half * 1.1, float(v[6]), hero.facing, null, (v[5] as Dictionary).duplicate())
			shake_left = maxf(shake_left, 0.3)
			if v[3] == 0:
				node.call("burst")
				_vortex.erase(v)
	_tick_storms(delta)

## พายุเลือดสองลูกเคลื่อนเข้าหาจุดกลาง ลากมอนในพายุมาด้วย บรรจบแล้วระเบิด มอนไม่ลอย
func _tick_storms(delta: float) -> void:
	for st in _storms.duplicate():
		var left := st[0] as CatBloodStorm
		var right := st[1] as CatBloodStorm
		if not is_instance_valid(left) or not is_instance_valid(right):
			_storms.erase(st)
			continue
		var center: float = st[2]
		st[3] -= delta
		var tick: bool = st[3] <= 0.0
		if tick:
			st[3] = STORM_HIT_EVERY
		for storm in [left, right]:
			var step := minf(STORM_SPEED * delta, absf(center - storm.position.x))
			var move := signf(center - storm.position.x) * step
			storm.position.x += move
			for e in get_tree().get_nodes_in_group("monsters"):
				var monster := e as Monster
				if monster == null or absf(monster.position.x - storm.position.x) > CatBloodStorm.HALF:
					continue
				monster.pos.x += move / CombatData.UNIT
				if tick:
					_strike(monster, {"type": "flinch", "dmg": 3.0, "skill": true, "stun": 0.35, "kb": 0.0}, signf(move))
		if absf(left.position.x - right.position.x) < 40.0:
			_hit_area(center, 260.0, STORM_BOOM_DMG, hero.facing, null, {"kb": 0.0, "stun": 1.2, "real_stun": true})
			var boom := CatFireball.new()
			boom.blood = true
			boom.radius = 140.0
			boom.position = Vector2(center, -120.0)
			world.add_child(boom)
			boom.burst()
			left.queue_free()
			right.queue_free()
			_storms.erase(st)
			shake_left = maxf(shake_left, 0.45)

## GRAND KNIGHT 45.2 เริ่มหมุนคลื่นดาบ ระหว่างหมุนเดินและกระโดดได้ตามปกติ
func _start_whirl() -> void:
	if is_instance_valid(_whirl):
		return
	_whirl = CatWhirl.new()
	_whirl.target = hero
	_whirl.position = hero.position
	world.add_child(_whirl)
	_whirl_t = 0.0
	_whirl_hit = 0.0

func _tick_whirl(delta: float) -> void:
	if not is_instance_valid(_whirl):
		return
	_whirl_t += delta
	if hero.plain_model != null:
		hero.plain_model.turn_extra = fmod(hero.plain_model.turn_extra + 1100.0 * delta, 360.0)
	# ดูดมอนรอบๆ เข้ามาหาตัว
	for e in get_tree().get_nodes_in_group("monsters"):
		var monster := e as Monster
		if monster == null:
			continue
		var d: float = hero.pos.x - monster.pos.x
		if absf(d) * CombatData.UNIT < WHIRL_PULL and absf(d) > 0.6:
			monster.pos.x += signf(d) * minf(WHIRL_PULL_SPEED * delta, absf(d) - 0.6)
	_whirl_hit -= delta
	if _whirl_hit <= 0.0:
		_whirl_hit = WHIRL_HIT
		_hit_area(hero.position.x, WHIRL_HALF, 5.0, hero.facing, null, {"kb": 0.0, "stun": 0.3})
	if _whirl_t >= WHIRL_MAX or (_whirl_t >= WHIRL_MIN and not _skill_held()):
		_whirl.stop()
		_whirl = null
		if hero.plain_model != null:
			hero.plain_model.turn_extra = 0.0

## พายุแดงยักษ์ พัดไปข้างหน้า ลากมอนในพายุไปด้วย
func _tick_pushers(delta: float) -> void:
	for pu in _pushers.duplicate():
		var storm := pu[0] as CatBloodStorm
		if not is_instance_valid(storm):
			_pushers.erase(pu)
			continue
		var move: float = float(pu[1]) * minf(float(pu[4]) * delta, float(pu[2]))
		pu[2] -= absf(move)
		storm.position.x += move
		pu[3] -= delta
		var tick: bool = pu[3] <= 0.0
		if tick:
			pu[3] = 0.3
		for e in get_tree().get_nodes_in_group("monsters"):
			var monster := e as Monster
			if monster == null or absf(monster.position.x - storm.position.x) > CatBloodStorm.HALF * RED_STORM_SCALE:
				continue
			monster.pos.x += move / CombatData.UNIT
			if tick:
				_strike(monster, {"type": "flinch", "dmg": 6.0, "skill": true, "stun": 0.35, "kb": 0.0}, float(pu[1]))
		if pu[2] <= 0.0:
			storm.queue_free()
			_pushers.erase(pu)

## ตั้งการ์ดอยู่ ศัตรูตีโดนหรือเข้าประชิดด้านหน้า งัดสวนขึ้นทันที
func _tick_guard() -> void:
	var guarding: bool = combo_nth >= 0 and hero.plain_move.get("guard", false) and _combo_t / float(hero.plain_move["time"]) < float(hero.plain_move["strike"])
	hero.plain_guard_t = 1.0 if guarding else 0.0
	if not guarding:
		hero.plain_guard_hit = false
		return
	var near := hero.plain_guard_hit
	for e in get_tree().get_nodes_in_group("monsters"):
		var monster := e as Monster
		if monster != null and not hero.plain_move.get("guard_ranged", false) and absf(monster.pos.x - hero.pos.x) < GUARD_REACH and (monster.pos.x - hero.pos.x) * hero.facing > -0.2:
			near = true
	if near:
		hero.plain_guard_hit = false
		hero.plain_guard_t = 0.0
		_start_combo(hero.plain_move.get("counter", "cat_gk_counter"))

## คลื่นดาบสีลาวาแดงส้มของ SWORD KNIGHT 35.1 ไหลช้า ทำดาเมจต่อเนื่อง
func _sk_wave(high: float, thick_k: float) -> void:
	var wave := CatSwordWave.new()
	wave.dir = hero.facing
	wave.hitter = _hit_area
	wave.high = high
	wave.thick_k = thick_k
	wave.speed = 320.0
	wave.life = 2.6
	wave.hit_every = 0.2
	wave.dmg = 7.0
	wave.body = Color(1.0, 0.3, 0.08, 0.72)
	wave.glow = Color(0.9, 0.15, 0.04, 0.3)
	wave.edge = Color(1.0, 0.88, 0.6)
	wave.extra = {"kb": 0.6, "stun": 0.35}
	wave.position = Vector2(hero.position.x + hero.facing * 60.0, 0.0)
	world.add_child(wave)

## โซนทำดาเมจเป็นจังหวะ แต่ละอันเป็น dictionary
## node โหนดที่แสดง left เวลาที่เหลือ gap ห่างแต่ละฮิต half ระยะครึ่งกว้าง dmg extra ผลที่ใส่
## vel ความเร็วแนวนอน spin หมุน keep ไม่ลบโหนดตอนหมด
func _zone(node: Node2D, left: float, gap: float, half: float, dmg: float, extra: Dictionary, vel := 0.0, spin := 0.0, keep := false) -> void:
	_zones.append({"node": node, "left": left, "gap": gap, "timer": 0.05, "half": half, "dmg": dmg, "extra": extra, "vel": vel, "spin": spin, "keep": keep})

func _tick_zones(delta: float) -> void:
	for z in _zones.duplicate():
		var node: Node2D = z["node"]
		if not is_instance_valid(node):
			_zones.erase(z)
			continue
		node.position.x += float(z["vel"]) * delta
		node.rotation += float(z["spin"]) * delta
		z["left"] = float(z["left"]) - delta
		z["timer"] = float(z["timer"]) - delta
		if float(z["timer"]) <= 0.0:
			z["timer"] = z["gap"]
			var side := signf(float(z["vel"])) if float(z["vel"]) != 0.0 else hero.facing
			_hit_area(node.position.x, z["half"], z["dmg"], side, null, (z["extra"] as Dictionary).duplicate())
		if float(z["left"]) <= 0.0:
			if not z["keep"]:
				if node.has_method("burst"):
					node.call("burst")
				else:
					node.queue_free()
			_zones.erase(z)

## วงเวทที่ยืนอยู่ในวงแล้วได้ผล mana ได้ MP เพิ่ม sa ได้เกราะ
func _tick_circles(delta: float) -> void:
	for c in _circles.duplicate():
		if not is_instance_valid(c[0]):
			_circles.erase(c)
			continue
		var circle := c[0] as CatMagicCircle
		if not circle.inside(hero.position.x):
			continue
		if c[1] == "mana":
			hero.mp = minf(hero.mp + Hero.MP_REGEN * 1.5 * delta, hero.mp_max())
		else:
			hero.plain_sa_t = maxf(hero.plain_sa_t, 0.3)

## CRIMSON 35.4 สังเวยเลือด เลือดต่ำกว่าครึ่งสังเวยถูกลง ใช้คูลดาวน์ร่วมกับการฟื้นเลือด
func _blood_price() -> void:
	var price := CK_PRICE
	if hero.hp < hero.hp_max() * 0.5 and _ck_cd <= 0.0:
		price = CK_PRICE_LOW
		_ck_cd = CK_SURVIVE_CD
	hero.hp = maxf(hero.hp * (1.0 - price), 1.0)
	hero.plain_boost_t = 3.0
	var mist := CatCrack.new()
	mist.mist_only = true
	mist.position = Vector2(hero.position.x, 0.0)
	world.add_child(mist)

## CRIMSON 60.2 เลือดต่ำกว่า 25% ฟื้นเลือดเป็นระยะ
func _tick_crimson(delta: float) -> void:
	_ck_cd = maxf(_ck_cd - delta, 0.0)
	if chosen_class != "CRIMSON KNIGHT":
		return
	if _ck_regen <= 0.0 and _ck_cd <= 0.0 and hero.hp > 0.0 and hero.hp < hero.hp_max() * 0.25:
		_ck_regen = CK_REGEN_TIME
		_ck_cd = CK_SURVIVE_CD
	if _ck_regen > 0.0:
		_ck_regen -= delta
		hero.hp = minf(hero.hp + hero.hp_max() * CK_REGEN * delta, hero.hp_max())

func _screen_w() -> float:
	return _view.x / ZOOM

## ปุ่มสกิลที่กดยังค้างอยู่ไหม
func _skill_held() -> bool:
	return test_hold or (_skill_button != "" and pad.is_held(_skill_button))

## คลื่นกระแทกสีแดงวิ่งไปตามพื้นทั้งซ้ายขวา
func _shock_ring(x: float) -> void:
	for side in [-1.0, 1.0]:
		var wave := CatShockwave.new()
		wave.dir = side
		wave.hitter = _hit_area
		wave.position = Vector2(x + side * 40.0, 0.0)
		world.add_child(wave)

## ท่าพุ่งลาก มอนที่อยู่หน้าตัวโดนลากไปด้วย ชะงักตลอดทาง
func _drag_monsters() -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		var monster := e as Monster
		if monster == null or not monster.on_floor():
			continue
		var d: float = (monster.pos.x - hero.pos.x) * hero.facing
		if d > -0.4 and d < 1.8:
			monster.pos.x = hero.pos.x + hero.facing * 1.1
			monster.vel.x = 0.0
			if monster.state in ["idle", "flinch", "stun"]:
				monster.state = "flinch"
				monster.state_t = maxf(monster.state_t, 0.3)

func _tick_shots(delta: float) -> void:
	for shot in _shots.duplicate():
		var ball := shot[0] as CatFireball
		if not is_instance_valid(ball) or ball.bursting:
			_shots.erase(shot)
			continue
		ball.position += (shot[1] as Vector2) * delta
		shot[4] -= delta
		var done: bool = shot[4] <= 0.0 or ball.position.y >= -8.0 or absf(ball.position.x) > hero.half_width * CombatData.UNIT + 200.0
		for e in get_tree().get_nodes_in_group("monsters"):
			var monster := e as Monster
			if monster == null or (shot[3] as Dictionary).has(monster):
				continue
			if (monster.position + Vector2(0.0, -MONSTER_MID)).distance_to(ball.position) > ball.size() + MONSTER_HIT_R:
				continue
			shot[3][monster] = true
			var h := {"type": "flinch", "dmg": shot[5], "skill": true}
			h.merge(shot[6], true)
			h["fireball"] = not ball.blood
			_strike(monster, h, signf((shot[1] as Vector2).x))
			shot[2] -= 1
			if shot[2] <= 0:
				done = true
				break
		if done:
			if shot.size() > 7 and shot[7]:
				_explode(ball.position, BLAST_RADIUS, BLAST_DMG, {"type": "launch", "vy": 8.0, "magic": true, "burn": "fire"})
			ball.burst()
			_shots.erase(shot)

## โหมดตั้งธนูของ CAT MATCHA (ท่าที่มี stance) กดเดินหรือกระโดดใหม่ ออกจากโหมดทันที
## ทิศที่ค้างมาจากแดชก่อนเข้าโหมดไม่นับ ต้องปล่อยก่อนแล้วกดใหม่
var _stance_free := false
func _tick_bow_stance(dir: float) -> void:
	var in_stance: bool = combo_nth >= 0 and hero.plain_move.get("stance", false)
	var jump_now: bool = pad.is_held("jump") or Input.is_key_pressed(KEY_SPACE)
	if not in_stance:
		_stance_free = false
		return
	if dir == 0.0 and not jump_now:
		_stance_free = true
		return
	if _stance_free:
		_stance_free = false
		combo_nth = -1
		combo_name = ""
		_combo_queued = ""
		hero.plain_swing = 0.0
		hero.plain_combo_rest = 0.0
		hero.plain_ghost = false

func _tick_combo(delta: float) -> void:
	_tick_shots(delta)
	_tick_vortex(delta)
	hero.plain_sa_t = maxf(hero.plain_sa_t - delta, 0.0)
	hero.plain_fire_t = maxf(hero.plain_fire_t - delta, 0.0)
	hero.plain_atk_t = maxf(hero.plain_atk_t - delta, 0.0)
	hero.plain_blood_t = maxf(hero.plain_blood_t - delta, 0.0)
	hero.plain_aura_t = maxf(hero.plain_aura_t - delta, 0.0)
	_gust_cd -= delta
	_fx_clock += delta
	_tick_whirl(delta)
	_tick_pushers(delta)
	_tick_guard()
	_tick_zones(delta)
	_tick_circles(delta)
	_tick_crimson(delta)
	hero.plain_mana_t = maxf(hero.plain_mana_t - delta, 0.0)
	hero.plain_boost_t = maxf(hero.plain_boost_t - delta, 0.0)
	if hero.on_floor():
		_air_started = false
	_queued_btn_t = maxf(_queued_btn_t - delta, 0.0)
	if combo_nth < 0:
		hero.plain_ghost = false
		return
	var hit: Dictionary = hero.plain_move
	var time: float = hit["time"]
	if _combo_stop > 0.0:
		_combo_stop -= delta
		_hold_air(hit, _combo_t / time)
		return
	var strike_at: float = hit["strike"]
	var wind_at: float = hit["wind"]
	# ท่าพุ่งลงค้างไว้ก่อนฟาด จนกว่าจะถึงพื้น
	var held := hit.has("dive") and not hero.on_floor() and _combo_t / time >= strike_at - 0.02
	# กดปุ่มค้างไว้ หน่วงท่าไว้ก่อนพุ่ง
	var hold_button: String = hit.get("hold_button", "x")
	var pressing: bool = _skill_held() if hold_button == "skill" else (pad.is_held(hold_button) or Input.is_key_pressed(KEY_Z if hold_button == "z" else KEY_X))
	if hit.has("hold") and _combo_t / time < wind_at and _hold_t < float(hit["hold"]) and pressing:
		_hold_t += delta
		held = true
		if hit.get("fx", "") == "summon" and is_instance_valid(_orb):
			_orb.charge = clampf(_hold_t / float(hit["hold"]), 0.0, 1.0)
	# ฟาดแล้วยังกดค้าง ค้างท่าไว้และปล่อยคลื่นกระแทกเป็นจังหวะ
	if hit.has("hold_after") and _combo_hit_done and _after_t < float(hit["hold_after"]) and pressing:
		# ท่ากลางอากาศ กดค้างแล้วลอยค้างอยู่ที่เดิม ไม่ร่วงลง
		if hit.has("hover") and not hero.on_floor():
			if _after_t <= 0.0:
				_hover_lock = hero.pos.y
			hero.pos.y = _hover_lock
			hero.vel.y = 0.0
		_after_t += delta
		held = true
		_pulse_t -= delta
		if _pulse_t <= 0.0:
			_pulse_t = PULSE_GAP
			_cast(hit.get("pulse", "shock"))
			shake_left = maxf(shake_left, 0.15)
	if not held:
		_combo_t += delta * atk_speed
	# ท่าพุ่งลงห้ามข้ามจังหวะฟาดกลางอากาศ (เฟรมยาวกระโดดข้ามช่วงค้างได้) ต้องฟาดตอนถึงพื้นเท่านั้น
	if hit.has("dive") and not hero.on_floor() and _combo_t / time >= strike_at:
		_combo_t = (strike_at - 0.001) * time
	# หมุนพุ่งลงทำดาเมจซ้ำรอบตัวจนถึงพื้น
	var multi_on: bool = hit.has("multi") and _combo_t / time >= wind_at and (not hero.on_floor() if hit.has("dive") else _combo_t / time < strike_at)
	if multi_on:
		_multi_t -= delta
		if _multi_t <= 0.0:
			_multi_t = float(hit["multi"])
			# ท่ากลิ้งโดนแต่ละตัวครั้งเดียวระหว่างกลิ้งผ่าน
			_hit_area(hero.position.x + hero.facing * float(hit.get("multi_ahead", 40.0)), float(hit.get("multi_half", MULTI_HALF)), hit["dmg"], hero.facing, _multi_hit if hit.has("multi_once") else null, hit.get("hit", {}), _body_span())
			shake_left = maxf(shake_left, hit["shake"])
			if hit.has("multi_fx"):
				_cast(hit["multi_fx"])
	var u := _combo_t / time
	_hold_air(hit, u)
	# ทะลุมอนได้ตลอดท่า จะได้ไม่โดนผลักกลับเข้าหาด้านเดิมตอนยังซ้อนตัวมอนอยู่
	hero.plain_ghost = hit.has("ghost")
	# ก้าวพุ่งไปข้างหน้าตอนฟาด
	if u >= wind_at and u < strike_at:
		var speed: float = float(hit["lunge"]) / (time * (strike_at - wind_at))
		hero.pos.x = clampf(hero.pos.x + hero.facing * speed * delta, -hero.half_width, hero.half_width)
		if hit.has("drag"):
			_drag_monsters()
	if not _combo_hit_done and u >= strike_at:
		_combo_hit_done = true
		# โดนเฉพาะมอนที่ใบดาบกวาดผ่านจริง ห่างกว่าปลายดาบไม่นับ
		var center := hero.position.x + hero.facing * COMBO_HIT_AHEAD
		var half := COMBO_HIT_HALF
		var y_span := Vector2.ZERO
		if hero.plain_model != null:
			var span: Vector2 = hero.plain_model.blade_span_x(hit)
			center = (span.x + span.y) * 0.5
			half = (span.y - span.x) * 0.5 + MONSTER_BODY_HALF
			y_span = hero.plain_model.blade_span_y(hit)
		# ท่าที่ใช้โล่หรือฟาดพื้น โดนช่วงด้านหน้าหรือรอบตัว ไม่ได้ใช้ใบดาบ
		if hit.has("front_hit"):
			center = hero.position.x + hero.facing * FRONT_AHEAD
			half = FRONT_HALF
			y_span = _body_span()
		# ออร่าดาบ ตีไกลขึ้น
		if hero.plain_aura_t > 0.0 and not hit.has("wide"):
			center += hero.facing * AURA_REACH * 0.5
			half += AURA_REACH * 0.5
			y_span = Vector2.ZERO
		elif hit.has("wide"):
			center = hero.position.x
			half = float(hit.get("wide_half", WIDE_HALF))
			y_span = _body_span()
		if not hit.get("no_hit", false) and _hit_area(center, half, hit["dmg"], hero.facing, null, hit.get("hit", {}), y_span):
			_combo_stop = hit["stop"]
		shake_left = maxf(shake_left, hit["shake"])
		_cast(hit.get("fx", ""))
		# เอฟเฟกต์ยกเลิกท่าเอง (เช่นตั้งธนูซ้ำตอนติดคูลดาวน์) ห้ามตั้งท่าค้างต่อ ไม่งั้นกดโจมตีไม่ได้อีก
		if combo_nth < 0:
			hero.plain_swing = 0.0
			return
	# ท่าที่ต่อท่าถัดไปเองโดยไม่ต้องกด
	# ยิงในโหมดตั้งธนูของ CAT MATCHA กดต่อไว้แล้วยิงชุดถัดไปเลย ไม่ต้องกลับท่าตั้งธนูก่อน
	if hit.has("auto") and u >= float(hit["next"]) and not (hit.has("stance_shot") and _combo_queued != "") and (not hit.has("auto_hold") or pressing):
		var btn := _queued_btn if _queued_btn_t > 0.0 else ""
		_start_combo(hit["auto"])
		if btn != "":
			var carried := _table_next(btn)
			if carried != "":
				_combo_queued = carried
		return
	if _combo_queued != "" and u >= float(hit["next"]):
		_start_combo(_combo_queued)
		return
	hero.plain_swing = clampf(u, 0.001, 1.0)
	var rest := maxf((_combo_t - time) / Hero.CHIBI_Z_RECOVER, 0.0)
	hero.plain_combo_rest = minf(rest, 1.0)
	if rest >= 1.0:
		combo_nth = -1
		combo_name = ""
		_combo_queued = ""
		hero.plain_swing = 0.0
		hero.plain_combo_rest = 0.0
		hero.plain_ghost = false

## ตัดท่าคอมโบได้ไหม: ท่าทำดาเมจไปแล้ว และเลยจังหวะต่อคอมโบ (next) แล้ว
func _can_cancel() -> bool:
	if combo_nth < 0 or not _combo_hit_done:
		return false
	var mv: Dictionary = hero.plain_move
	if mv.get("stance", false) or mv.get("guard", false):
		return false
	# ท่ากลางอากาศโดนแล้วและลงถึงพื้น ตัดท่าได้ทันที แดชหรือกระโดดต่อได้เลย
	if _combo_air and hero.on_floor() and not mv.has("auto"):
		return true
	if mv.has("auto"):
		return false
	var t := float(mv.get("time", 0.4))
	return _combo_t / maxf(t, 0.01) >= float(mv.get("next", 0.6))

var _combo_air := false           # ท่านี้เริ่มกลางอากาศ
var _queued_btn := ""
var _queued_btn_t := 0.0
var _raw_dir_was := 0.0
var _raw_tap_dir := 0.0
var _raw_tap_t := -10.0
var _dash_buf_dir := 0.0          # กดทิศสองทีระหว่างออกท่า จำไว้ แดชทันทีที่ตัดท่าได้
var _dash_buf_t := 0.0
var _jump_buf_t := 0.0            # กดกระโดดระหว่างออกท่า จำไว้ กระโดดทันทีที่ตัดท่าได้
const INPUT_BUFFER := 0.35

var _dir_released := true
var _cancel_hold := 0.0
const CANCEL_HOLD := 0.1

func _end_combo() -> void:
	combo_nth = -1
	combo_name = ""
	_combo_queued = ""
	hero.plain_swing = 0.0
	hero.plain_combo_rest = 0.0
	hero.plain_ghost = false

## CAT CITRUS ย่ำอากาศ (^>> หรือ ^^>>): กลางอากาศกดหน้าซ้ำสองครั้ง ก้าวไปข้างหน้าทีละก้าว แต่ละก้าวต่ำลงเรื่อยๆ
const SPEAR_DJ_K := 0.7           # กระโดดซ้ำของ CITRUS สูงกว่าครึ่งหนึ่งนิดหน่อย เตี้ยกว่าของ MATCHA (0.95)
const SPEAR_DJ_PUSH := 0.32       # >>^^ พุ่งไปข้างหน้านานเท่านี้
const AIR_STEPS := 4
const AIR_STEP_EVERY := 0.2
const AIR_STEP_DROP := 0.35       # แต่ละก้าวต่ำลงเท่านี้ (หน่วยโลก)
const AIR_STEP_HOP := 0.28        # เด้งขึ้นนิดหน่อยทุกก้าว
var _spear_push_t := 0.0
var _air_walked := false
var _walk_steps := 0
var _walk_t := 0.0
var _walk_y0 := 0.0
var _air_tap_dir := 0.0
var _air_tap_t := -10.0
var _air_prev_dir := 0.0

func _tick_air_walk(delta: float, dir: float) -> void:
	if chosen_weapon != "spear":
		return
	var now := Time.get_ticks_msec() / 1000.0
	if dir != 0.0 and _air_prev_dir == 0.0:
		if not hero.on_floor() and not _air_walked and combo_nth < 0 and dir == _air_tap_dir and now - _air_tap_t < Hero.DOUBLE_TAP:
			_air_walked = true
			_walk_steps = AIR_STEPS
			_walk_t = 0.0
			_walk_y0 = hero.pos.y
			hero.facing = dir
			_step_puff(hero.position + Vector2(-hero.facing * 10.0, 40.0))
		_air_tap_dir = dir
		_air_tap_t = now
	_air_prev_dir = dir
	if _walk_steps <= 0:
		return
	if hero.on_floor() or combo_nth >= 0:
		_walk_steps = 0
		return
	# เดินไปข้างหน้าตลอดช่วงย่ำอากาศ ความสูงตามเส้นก้าวที่ค่อยๆ ต่ำลง
	hero.input_dir = signf(hero.facing)
	_walk_t += delta
	var f := _walk_t / AIR_STEP_EVERY
	var i := floori(f)
	if i >= AIR_STEPS:
		_walk_steps = 0
		hero.vel.y = 0.0
		return
	if AIR_STEPS - i < _walk_steps:
		_walk_steps = AIR_STEPS - i
		_step_puff(hero.position + Vector2(-hero.facing * 10.0, 40.0))
	var ph := f - float(i)
	var target := maxf(_walk_y0 - f * AIR_STEP_DROP + AIR_STEP_HOP * sin(ph * PI), 0.0)
	hero.vel.y = (target - hero.pos.y) / maxf(delta, 0.001)

## ปุยลมเล็กๆ ใต้เท้าตอนกระโดดซ้ำหรือย่ำอากาศ
func _step_puff(at: Vector2) -> void:
	var puff := KickTrail.new()
	puff.kind = "flip"
	puff.dir = hero.facing
	puff.life = 0.25
	puff.position = at
	puff.scale = Vector2.ONE * 0.6
	world.add_child(puff)

func _physics_process(delta: float) -> void:
	if intro_lock:
		return
	_apply_training()
	_tick_time_stop(delta)
	for k in skill_cds.keys():
		skill_cds[k] = maxf(float(skill_cds[k]) - delta, 0.0)
	if _cd_ui != null:
		_cd_ui.queue_redraw()
	var z_key := Input.is_key_pressed(KEY_Z)
	if z_key and not _z_key_was:
		press_z()
	_z_key_was = z_key
	var x_key := Input.is_key_pressed(KEY_X)
	if x_key and not _x_key_was:
		press_x()
	_x_key_was = x_key
	var v_key := Input.is_key_pressed(KEY_V)
	if v_key and not _v_key_was and chosen_weapon == "azure":
		pair_swap()
	_v_key_was = v_key
	if pair_swap_cd > 0.0:
		pair_swap_cd = maxf(pair_swap_cd - delta, 0.0)
		pad.pair_swap_cd = pair_swap_cd
		pad.queue_redraw()
	_tick_combo(delta)
	if hero.plain_swing > 0.0 and hero.plain_swing_kind == "slash":
		hero.pos.x = clampf(hero.pos.x + hero.facing * SLASH_SLIDE * delta, -hero.half_width, hero.half_width)
	# ปุ่มซ้ายขวาเดิน แตะทิศเดิมซ้ำเร็วๆ เป็นแดช
	var dir := 0.0
	if pad.is_held("left"):
		dir -= 1.0
	if pad.is_held("right"):
		dir += 1.0
	if dir == 0.0:
		dir = joy.direction()
	if dir == 0.0:
		if Input.is_key_pressed(KEY_LEFT):
			dir -= 1.0
		if Input.is_key_pressed(KEY_RIGHT):
			dir += 1.0
	# นับว่ากดทิศเดิมค้างมานานแค่ไหน (คนเดินค้างแล้วตี ไม่ให้นับเป็นคำสั่ง ">")
	if dir != 0.0 and dir == _dir_hold_sign:
		_dir_hold_t += delta
	else:
		_dir_hold_t = 0.0
		_dir_hold_sign = dir
	_tick_bow_stance(dir)
	var planted: bool = hero.plain_swing > 0.0 and hero.plain_swing_kind != "swing"
	# ท่าโดนไปแล้วและถึงช่วงต่อคอมโบ กดเดินหรือกระโดดตัดท่าได้ทันที ไม่ต้องรอท่าจบ
	# ทิศที่กดค้างมาตั้งแต่ก่อนออกท่า (คอมโบที่ขึ้นด้วย >) ไม่นับ ต้องปล่อยแล้วกดใหม่ถึงตัดท่า
	if dir == 0.0:
		_dir_released = true
	var jump_now: bool = pad.is_held("jump") or Input.is_key_pressed(KEY_SPACE)
	# กดทิศค้างสั้นๆ ก่อนถึงตัดท่า เผื่อกดทิศแล้วตามด้วยปุ่มโจมตี (คอมโบ back_z fwd_z)
	if planted and _can_cancel() and dir != 0.0 and _dir_released and _combo_queued == "":
		_cancel_hold += delta
	else:
		_cancel_hold = 0.0
	# จำปุ่มแดช (แตะทิศเดิมสองที) กับปุ่มกระโดดที่กดระหว่างออกท่า
	var now_s := Time.get_ticks_msec() / 1000.0
	if planted and dir != 0.0 and _raw_dir_was == 0.0:
		if dir == _raw_tap_dir and now_s - _raw_tap_t < Hero.DOUBLE_TAP:
			_dash_buf_dir = dir
			_dash_buf_t = INPUT_BUFFER
		_raw_tap_dir = dir
		_raw_tap_t = now_s
	_raw_dir_was = dir
	if planted and jump_now and not _jump_was:
		_jump_buf_t = INPUT_BUFFER
	_dash_buf_t = maxf(_dash_buf_t - delta, 0.0)
	_jump_buf_t = maxf(_jump_buf_t - delta, 0.0)
	var want_dash := _dash_buf_t > 0.0
	var want_jump_buf := _jump_buf_t > 0.0
	if planted and _can_cancel() and (_cancel_hold >= CANCEL_HOLD or (jump_now and not _jump_was) or want_dash or want_jump_buf):
		_end_combo()
		_cancel_hold = 0.0
		planted = false
	# ท่าจบเองหรือเพิ่งตัดท่า ใช้ปุ่มที่จำไว้
	if not planted and combo_nth < 0:
		if want_dash and hero.on_floor():
			# แดชทันที ไม่ต้องแตะทิศใหม่อีกรอบ
			hero.dash_t = Hero.DASH_TIME
			hero.dash_dir = _dash_buf_dir
			hero.facing = _dash_buf_dir
			hero._last_dir = dir
			_dash_buf_t = 0.0
		if want_jump_buf and hero.on_floor() and _jump_wind <= 0.0:
			_jump_wind = JUMP_WIND
			_jump_buf_t = 0.0
	hero.input_dir = 0.0 if planted else dir
	# ตีไปเดินไปช้าๆ: ระหว่างคอมโบบนพื้น กดทิศไปทางที่หันค้าง ตัวไหลตามมอนไปข้างหน้า
	if planted and combo_nth >= 0 and hero.on_floor() and dir != 0.0 and dir == signf(hero.facing) and not hero.plain_move.has("dive") and not hero.plain_move.get("stance", false) and not hero.plain_move.get("guard", false):
		hero.pos.x = clampf(hero.pos.x + dir * COMBO_DRIFT * delta, -hero.half_width, hero.half_width)
	hero.run_push = joy.running() and not planted
	hero.fast_fall = _down_held() and not hero.on_floor() and combo_nth < 0
	# CAT ASH สาย HEAVYWEIGHT กลางอากาศกดลง กระแทกพื้นรอบตัว
	var down_now := _down_held()
	if down_now and not _heavy_down_was and chosen_weapon == "fist" and _line("HEAVYWEIGHT") and not hero.on_floor() and combo_nth < 0:
		_start_combo("fsh_slam")
	_heavy_down_was = down_now
	# กดกระโดดแล้วย่อตัวสั้นๆ ก่อน จึงค่อยลอยจริง
	var want_jump: bool = not planted and (pad.is_held("jump") or Input.is_key_pressed(KEY_SPACE))
	if want_jump and not _jump_was and hero.on_floor() and _jump_wind <= 0.0:
		_jump_wind = JUMP_WIND
	# CAT MATCHA กระโดดซ้ำกลางอากาศได้ 1 ครั้ง นับเป็นท่ากลางอากาศใหม่ (^)
	elif want_jump and not _jump_was and not hero.on_floor() and chosen_weapon == "bow" and not _double_jumped and combo_nth < 0:
		_double_jumped = true
		hero.vel.y = Hero.JUMP_VELOCITY * 0.95
		_air_started = false
		var puff := KickTrail.new()
		puff.kind = "flip"
		puff.dir = hero.facing
		puff.life = 0.3
		puff.position = hero.position + Vector2(0.0, 60.0)
		world.add_child(puff)
	# CAT CITRUS กระโดดซ้ำสั้นๆ 1 ครั้ง  หลังแดชกระโดด (>>^^) พุ่งไปข้างหน้าด้วย
	elif want_jump and not _jump_was and not hero.on_floor() and chosen_weapon == "spear" and not _double_jumped and combo_nth < 0:
		_double_jumped = true
		hero.vel.y = Hero.JUMP_VELOCITY * SPEAR_DJ_K
		_air_started = false
		if hero.jump_dashed:
			_spear_push_t = SPEAR_DJ_PUSH
		_step_puff(hero.position + Vector2(0.0, 30.0))
	_tick_air_walk(delta, dir)
	if _spear_push_t > 0.0:
		_spear_push_t -= delta
		if combo_nth < 0:
			hero.input_dir = signf(hero.facing)
			hero.dash_t = maxf(hero.dash_t, 0.05)
			hero.dash_dir = signf(hero.facing)
	if hero.on_floor():
		_double_jumped = false
		_air_walked = false
		_walk_steps = 0
		_spear_push_t = 0.0
	_jump_was = want_jump
	var launch := false
	if planted:
		_jump_wind = 0.0
	elif _jump_wind > 0.0:
		_jump_wind -= delta
		launch = _jump_wind <= 0.0
	hero.plain_jump_wind = 1.0 - _jump_wind / JUMP_WIND if _jump_wind > 0.0 else 0.0
	hero.jump_held = launch

