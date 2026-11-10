class_name Monster
extends Node2D
## มอนแคปซูล กติกาการโดนตีเหมือน Stigma Zero: ชะงัก ลอย กระเด็นล้ม ตกตรง ฟาดลงพื้น
## ล้มแล้วอมตะจนลุกเสร็จ โดนกลางอากาศเกินกำหนดจะล้ม ถูกซัดชนขอบจอเด้งกลับ
## พิกัด pos เป็นหน่วยโลก y คือความสูงจากพื้น

signal died(monster: Monster)
signal slammed(monster: Monster)  # บอสตกลงทุบพื้น ให้หน้าต่อสู้เขย่าจอ
signal shockwave(monster: Monster, dir: float)   # บอสค้อนทุบพื้น คลื่นวิ่งตามพื้น
signal vanished(monster: Monster, from: Vector2)   # บอสเงาวาร์ป
signal shoot(monster: Monster)                      # ตัวยิงไกลยิงใส่ตัวละคร
signal healed(monster: Monster, target: Monster)    # ซัพพอร์ตฮีลเพื่อน
signal phase_two(monster: Monster)                  # บอสเข้าเฟส 2 เรียกลูกน้อง
signal ult_warn(monster: Monster)                   # บอสเตือนท่าใหญ่ทั้งลาน
signal ult_hit(monster: Monster)                    # ท่าใหญ่ลง โดนทุกคนที่อยู่บนพื้น

const ROLES := {
	"dummy": {"hp": 100.0, "scale": 1.0},
	"melee": {"hp": 60.0, "scale": 1.0, "speed": 3.0, "dmg": 6.0, "reach": 1.6, "windup": 0.68, "cool": 2.04},
	# มอนแมวไม่มีแขนขา กระโดดเข้าหาแล้วชนตอนลอยอยู่
	"hopper": {"hp": 70.0, "scale": 1.0, "speed": 3.4, "dmg": 5.0, "reach": 0.9, "hop": 8.0, "cool": 1.87},
	# บอสแมวยักษ์ ง้างอาวุธฟาด และกระโดดทุบพื้นเป็นระยะ
	"boss": {"hp": 1200.0, "scale": 1.0, "speed": 2.0, "dmg": 14.0, "reach": 2.6, "windup": 1.05, "cool": 2.72, "slam_every": 7.50, "slam_reach": 3.0, "slam_dmg": 18.0},
	# บทบาทในดันเจี้ยน ตัวยิงไกล อยู่บนแท่นลอยหรือมุมไกล ยิงขัดจังหวะ
	"ranged": {"hp": 55.0, "speed": 2.0, "keep": 5.5, "shoot_every": 3.60, "shot_dmg": 7.0},
	# แทงค์ เกราะหนาไม่ชะงัก เลือดเยอะ ขวางทาง
	"tank": {"hp": 280.0, "speed": 1.4, "dmg": 12.0, "reach": 1.7, "windup": 1.20, "cool": 3.06, "armor": true},
	# ซัพพอร์ต หลบหลังเพื่อน ฮีลเพื่อนเป็นระยะ
	"support": {"hp": 70.0, "speed": 2.2, "heal_every": 4.80, "heal": 40.0, "heal_reach": 6.0},
	# ตัวพุ่งชน นิ่งจนตัวละครเดินผ่าน แล้วพุ่งเข้าใส่เร็วมาก
	"rusher": {"hp": 60.0, "speed": 3.0, "trigger": 8.0, "rush": 12.0, "dmg": 9.0, "cool": 4.08},
	# มินิบอสกลางทาง ตัวใหญ่ มีเกราะ เลือดเยอะ ท่าไม่ซับซ้อน
	"midboss": {"hp": 700.0, "size": 1.6, "speed": 1.8, "dmg": 15.0, "reach": 2.6, "windup": 1.12, "cool": 2.72, "armor": true, "slam_every": 7.50, "slam_reach": 3.0, "slam_dmg": 14.0},
	# บอสแต่ละตัวขนาดและท่าต่างกัน
	# ราชาโมจิ ตัวใหญ่ช้า กระโดดทุบพื้นบ่อย
	"boss_club": {"hp": 1100.0, "size": 1.15, "speed": 1.8, "dmg": 14.0, "reach": 2.6, "windup": 1.05, "cool": 2.38, "slam_every": 4.80, "slam_reach": 3.4, "slam_dmg": 18.0},
	# แมวยืด ตัวสูง แทงหอกไกล แทงแล้วพุ่งตามไปด้วย
	"boss_spear": {"hp": 1000.0, "size": 1.1, "speed": 2.6, "dmg": 13.0, "reach": 4.2, "windup": 0.90, "cool": 2.21, "lunge": 13.0},
	# แมวกล่อง ตัวกว้างช้ามาก ทุบพื้นเป็นคลื่นวิ่งตามพื้น
	"boss_hammer": {"hp": 1400.0, "size": 1.25, "speed": 1.2, "dmg": 18.0, "reach": 2.8, "windup": 1.35, "cool": 3.06, "wave_every": 5.40, "wave_dmg": 15.0},
	# แมวเงา ตัวเล็กกว่าเพื่อน ลอยตัว วาร์ปไปข้างหลังแล้วเหวี่ยงเคียวกว้าง
	"boss_scythe": {"hp": 1000.0, "size": 0.9, "speed": 3.0, "dmg": 12.0, "reach": 3.4, "windup": 0.75, "cool": 1.87, "float": 1.4, "teleport_every": 5.10},
	# ราชันแมว ฟัน 3 ทีติดกัน และพุ่งชาร์จโล่ข้ามลาน
	# บอสยักษ์แบบรุม (raid_boss.gd) ยืนนิ่ง หลายเฟส ค่าจริงตั้งตามเมืองตอนเกิด
	"boss_raid": {"hp": 1500.0, "dmg": 16.0, "armor": true},
	"boss_king": {"hp": 1800.0, "size": 1.2, "speed": 2.4, "dmg": 13.0, "reach": 2.8, "windup": 0.83, "cool": 2.55, "combo": 3, "charge_every": 9.00, "charge_dmg": 20.0},
}
const GRAVITY := 25.0
const AIR_HIT_LIMIT := 4
const PUSH_SPEED := 14.0
const WALL_BOUNCE_MIN_SPEED := 3.0
const WALL_BOUNCE_KEEP := 0.6
const WALL_BOUNCE_VY := 5.0
const DOWN_TIME := 0.7
const GETUP_TIME := 0.35
const LIE_DEG := 85.0
const LIE_RATE := 560.0
const BODY_R := 0.5
const NUMBER_LIFE := 0.6
const NUMBER_RISE := 0.8
const WINDUP_LEAN := -14.0
const DRAW_R := 42.0
const DRAW_H := 126.0
const DRAW_GAP := 14.0
const BAR_W := 80.0
const BAR_H := 9.0
const STUN_MIN := 5.0          # ท่าที่กำหนดเวลาตั้งแต่เท่านี้คือสตั๊น ต่ำกว่านี้คือชะงัก
const FLINCH_TIME := 0.26      # ชะงักเฉพาะท่าทาง ตัวไม่ถูกดันไปไหน
const FLINCH_LEAN := 17.0
const FLINCH_SQUASH := 0.1
const DIZZY_STARS := 3
const DIZZY_RX := 36.0
const DIZZY_RY := 10.0
const DIZZY_LIFT := 50.0       # เหนือแถบเลือด
const DIZZY_SPEED := 6.0
const DIZZY_R := 11.0
const DIZZY_COLOR := Color(0.96, 0.78, 0.22)
const KD_DOWN_CHANCE := 0.3     # สกิลติดตัวลด KD โอกาสที่ท่าล้มเป็นแค่ชะงัก
const MARK_R := 34.0
const MARK_COLOR := Color(0.86, 0.14, 0.14)
const CURSE_CHANCE := 0.2
const WEAK_DMG := Stats.WEAK_MULT        # ลดพลังโจมตี -50
const DS_NO_FALL_CHANCE := 0.5
const ARMOR_BREAK_TIME := 10.0
const ARMOR_MARK := Color(0.84, 0.16, 0.16)
const ARMOR_BREAK_MULT := Stats.BREAK_MULT   # ลดป้องกัน -50
const ICE_FILL := Color(0.72, 0.9, 1.0, 0.65)
const ICE_EDGE := Color(0.3, 0.6, 0.9)
const ROOT_RX := 52.0
const ROOT_COLOR := Color(0.5, 0.32, 0.82)
const BURN_TIME := 3.0
const BURN_GAP := 0.5
const BURN_DMG := 2.0
const BURN_TONGUES := [[-26.0, 0.0], [24.0, -30.0], [-8.0, -62.0], [18.0, 26.0]]

var role := "dummy"
var pos := Vector2.ZERO
var vel := Vector2.ZERO
var half_width := 7.0
var hp := 100.0
var max_hp := 100.0
var kd := 0.0
var state := "idle"     # idle flinch(ชะงัก) stun(สตั๊น มีดาวบนหัว) air down getup dead
var state_t := 0.0
var air_t := 0.0
var air_stall := 0.0
var air_hits := 0
var kd_flight := false
var launch_fall := false
var slam_flag := false
var wall_bounced := false
var body_radius := BODY_R
var model_view := 0              # ความละเอียดภาพ 3D (บอสยักษ์ใช้ภาพใหญ่ ไม่แตก)
var _model: MonsterModel        # ตัว 3D ทรงกลม ธีมเดียวกับตัวแมว (ไม่มีก็วาด 2D แบบเดิม)
var _back: Node2D               # แสงเตือนวาดหลังตัว 3D
var look := ""                 # หน้าตา ว่างคือแคปซูลเดิม
var _look_t := 0.0
var ai_state := "move"
var ai_t := 0.0
var ai_cool := 0.6
var ai_face := -1.0
var ai_hit := false            # กระโดดครั้งนี้ชนโดนแล้ว
var ai_hop_vx := 0.0
var ai_slam_t := 3.0           # บอสกระโดดทุบพื้นอีกกี่วินาที
var ai_slamming := false
var aggro := 0.0               # ระยะที่เริ่มไล่ตาม 0 คือไล่ตลอด
var floor_h := 0.0             # ยืนบนแท่นลอยสูงเท่านี้ (0 คือพื้น)
var plat := Vector2.ZERO       # ขอบซ้ายขวาของแท่นที่ยืน (ว่างคือไม่อยู่บนแท่น)
var easy_dmg := 1.0            # เมืองแรกๆ มอนตีเบาลง
var easy_slow := 1.0           # เมืองแรกๆ บอสออกท่าช้าลง (คูณเวลาคูลดาวน์)
const HOP_DOWN_RANGE := 4.0     # ตัวละครเข้ามาใกล้ในระยะนี้ มอนบนแท่นกระโดดลงพื้น
var ai_shoot_t := 1.5
var ai_heal_t := 2.0
var heal_fx := 0.0             # เพิ่งฮีลเพื่อน วาดแสงเขียว
var ai_rushing := 0.0
var phase := 1                 # บอสเฟส 2 เมื่อเลือดเหลือครึ่ง
var ai_ult_t := 6.0
var ai_ult_warn := 0.0         # กำลังเตือนท่าใหญ่ทั้งลาน
var ai_idle_t := 0.0
var ai_combo := 0
var ai_lunge_t := 0.0
var ai_wave_t := 2.5
var ai_tp_t := 2.5
var ai_charge_t := 4.0
var ai_charging := 0.0
var hero: Hero
var _lie := 0.0
var _flinch_t := 0.0
var _hurt_t := 0.0             # เพิ่งโดนตี ตาเป็น >< และตัวสั่น
var _flinch_dir := 1.0
var _numbers: Array = []
static var chain := 0              # ฮิตต่อเนื่องของผู้เล่น (ตัวนับคอมโบ)
static var chain_ms := 0           # เวลาฮิตล่าสุด
var _st_max := {}                  # สถานะ -> เวลาเต็มตอนเริ่ม ใช้วาดวงเวลาที่เหลือบนป้ายสถานะ
const BADGE_R := 19.0              # ป้ายสถานะกลมๆ ข้างหลอดเลือด
const BADGE_MAX := 3
const NUM_INK := Color(0.4, 0.34, 0.31)
const NUM_BIG := Color(0.93, 0.52, 0.42)
const NUM_EDGE := Color(1.0, 0.98, 0.95)
var ice_t := 0.0               # แช่แข็ง นิ่งทุกอย่าง เหลือกี่วินาที
var weak_t := 0.0              # มอนอ่อนแรง โจมตีเบาลง เหลือกี่วินาที
var mark_t := 0.0              # ตกเป็นเป้า เหลือกี่วินาที
var armor_t := 0.0             # เกราะแตก โดนแรงขึ้น เหลือกี่วินาที
var root_t := 0.0              # ถูกตรึงกับที่ เหลือกี่วินาที
var slow_t := 0.0               # เคลื่อนไหวช้าลง
static var hide_bars := false     # HYPER บางท่าซ่อนหลอดเลือดมอนให้จอเป็นภาพล้วน
var frozen := false            # เวลาหยุด นิ่งทุกอย่าง โดนดาเมจได้ ผลเกิดตอนเวลาเดินต่อ
var burn_kind := ""            # ติดไฟอยู่ fire poison ice
var burn_t := 0.0
var _burn_tick := 0.0
var _burn_clock := 0.0
var _clock := 0.0
# ท่าเตรียมตี เห็นชัดก่อนโดน: ย่อตัว เอนหลัง ยกอุ้งเท้า มีเครื่องหมาย ! เหนือหัว
var tele_t := 0.0
var tele_len := 0.0
var tele_kind := ""            # claw stab smash pounce rush shoot slam charge wave
var strike_t := 0.0            # เพิ่งตี วาดรอยตะปบด้านหน้า
var strike_kind := ""
var ai_crouch := 0.0           # ตัวกระโดดย่อตัวก่อนพุ่ง
var ai_rush_wind := 0.0        # ตัวพุ่งชนสั่นก่อนพุ่ง
var ai_wave_wind := 0.0        # บอสค้อนยกค้อนก่อนทุบคลื่น
var ai_charge_wind := 0.0      # ราชันแมวกระทืบเท้าก่อนชาร์จ
var ai_slam_wind := 0.0        # บอสย่อตัวก่อนกระโดดทุบ
# ท่าตาย ลอยกระเด็นหมุน ตกพื้นแล้วกลายเป็นควันกับดาว
var death_t := 0.0
var _death_vel := Vector2.ZERO
var _death_dir := 1.0
const DEATH_FLY := 0.55
const DEATH_TIME := 1.05
const STRIKE_TIME := 0.26

func _ready() -> void:
	add_to_group("monsters")
	max_hp = float(ROLES[role]["hp"])
	hp = max_hp
	_place()
	if MonsterModel.has_look(look):
		_back = Node2D.new()
		_back.show_behind_parent = true
		_back.draw.connect(func() -> void:
			var k := _tele_k()
			if k > 0.0 and state != "dead":
				_back_draw(MonsterLook.top(look), k))
		add_child(_back)
		_model = MonsterModel.new()
		_model.look = look
		_model.face = ai_face
		_model.view_px = model_view
		_model.show_behind_parent = true
		add_child(_model)

## แสงเตือนกลมหลังตัว วาดบนโหนดด้านหลัง ไม่ทับตัว 3D
func _back_draw(top: float, k: float) -> void:
	var pulse := 0.5 + 0.5 * sin(_clock * (10.0 + 26.0 * k))
	var c := Color(1.0, 0.3, 0.25, 0.18 + 0.22 * pulse * k)
	if tele_kind == "shoot":
		c = Color(0.85, 0.4, 1.0, 0.15 + 0.2 * pulse * k)
	_back.draw_circle(Vector2(0.0, -top * 0.45), top * (0.52 + 0.08 * k), c)

## ความคลาดเคลื่อนของความสูงพื้น/แท่น pos เก็บเป็นเลข 32 บิต ความสูงอย่าง 3.4 ปัดแล้วสูงกว่าเดิมนิดหน่อย
const FLOOR_EPS := 0.002

func on_floor() -> bool:
	return pos.y <= floor_h + FLOOR_EPS and vel.y <= 0.0

func is_invulnerable() -> bool:
	return state == "down" or state == "getup" or state == "dead" or kd_flight

## ดาเมจจริงหลังคิดบัพและเกราะแตก
func _scaled_damage(h: Dictionary) -> float:
	var dmg := float(h.get("dmg", 1.0))
	if is_instance_valid(hero):
		dmg *= hero.attack_mult()
		if h.get("skill", false):
			dmg *= hero.skill_mult()
	if armor_t > 0.0:
		dmg *= ARMOR_BREAK_MULT
	if is_instance_valid(hero) and not h.get("skill", false):
		dmg *= hero.basic_mult()
	return dmg

## แช่แข็ง ตัวนิ่งจนหมดเวลา
func freeze_ice(time: float) -> void:
	if state != "dead":
		ice_t = time

## คืนค่า true ถ้าโดนจริง
func take_hit(h: Dictionary, dir: float) -> bool:
	if state == "dead" or is_invulnerable():
		return false
	var t: String = h.get("type", "flinch")
	# นับคอมโบ ฮิตห่างกันเกิน 1.5 วิเริ่มนับใหม่
	var now_ms := Time.get_ticks_msec()
	if now_ms - chain_ms > 1500:
		chain = 0
	chain += 1
	chain_ms = now_ms
	var heavy_hit := t == "launch" or t == "knockdown" or t == "slam" or float(h.get("dmg", 0.0)) >= 80.0
	Snd.hit(heavy_hit)
	if heavy_hit:
		Snd.buzz(15)
	# ดาเมจล้วน ไม่ชะงัก ไม่เปลี่ยนสถานะ
	if t == "none":
		var quiet := _scaled_damage(h)
		hp -= quiet
		_check_phase()
		# ดาเมจล้วนก็ยังสะดุ้งให้เห็น (HYPER ที่มอนถูกหยุดเวลา)
		_flinch_t = FLINCH_TIME
		_flinch_dir = dir if dir != 0.0 else (1.0 if randf() < 0.5 else -1.0)
		_hurt_t = 0.35
		_numbers.append({"text": str(int(quiet)), "t": 0.0, "x": randf_range(-20.0, 20.0)})
		_check_death()
		return true
	# เกราะหนา (แทงค์ มินิบอส) โดนดาเมจแต่ไม่ชะงัก ไม่ลอย ไม่ล้ม
	if ROLES.get(role, {}).get("armor", false):
		var hard := _scaled_damage(h)
		hp -= hard
		_numbers.append({"text": str(int(hard)), "t": 0.0, "x": randf_range(-20.0, 20.0), "big": heavy_hit or hard >= maxf(120.0, max_hp * 0.25)})
		_flinch_t = FLINCH_TIME * 0.5
		_flinch_dir = dir if dir != 0.0 else 1.0
		_hurt_t = 0.25
		_check_phase()
		_check_death()
		return true
	if (t == "knockdown" or t == "fall") and is_instance_valid(hero) and (hero.has_passive("sc_kd_down") or hero.has_passive("st_speed")) and randf() < KD_DOWN_CHANCE:
		t = "flinch"
	var dmg := _scaled_damage(h)
	if is_instance_valid(hero) and hero.has_passive("mk_curse") and randf() < CURSE_CHANCE:
		armor_t = ARMOR_BREAK_TIME
		weak_t = ARMOR_BREAK_TIME
	if h.get("armor_break", false):
		armor_t = ARMOR_BREAK_TIME
	_flinch_t = FLINCH_TIME
	_flinch_dir = dir if dir != 0.0 else 1.0
	_hurt_t = 0.35
	if h.has("slow"):
		slow_t = maxf(slow_t, float(h["slow"]))
	if h.has("burn"):
		burn_kind = str(h["burn"])
		burn_t = BURN_TIME
		_burn_tick = BURN_GAP
	hp -= dmg
	_numbers.append({"text": str(int(dmg)), "t": 0.0, "x": randf_range(-20.0, 20.0), "big": heavy_hit or dmg >= maxf(120.0, max_hp * 0.25)})
	var airborne := state == "air" or not on_floor()
	if airborne:
		air_hits += 1
	# ท่าที่ทำให้ลอยต่อก็โดนจำกัดจำนวนฮิตกลางอากาศ
	if (t == "flinch" or t == "launch") and airborne and air_hits > AIR_HIT_LIMIT and not h.get("no_air_limit", false):
		t = "knockdown"
	# ลอยแล้วถึงพื้นล้มทุกกรณี เว้นแต่โดนท่าชะงักต่อกลางอากาศ
	launch_fall = t == "launch"
	# 35.4 โจมตีแล้วมอนล้มน้อยลง
	if launch_fall and is_instance_valid(hero) and (hero.has_passive("ds_no_down") or hero.has_passive("rm_no_down")) and randf() < DS_NO_FALL_CHANCE:
		launch_fall = false
	match t:
		"flinch":
			if airborne:
				vel.y = maxf(vel.y, float(h.get("air_lift", 3.5)))
				vel.x = dir * float(h.get("kb_air", 0.3))  # ตีกลางอากาศดันออกนิดเดียว ตามคอมโบต่อได้
				air_stall = float(h.get("air_stall", 0.25))
				state = "air"
				air_t = 0.0
			else:
				var hold := float(h.get("stun", 0.45))
				if hold >= STUN_MIN or h.get("real_stun", false):
					state = "stun"
					state_t = hold
				elif state != "stun":
					# กำลังสตั๊นอยู่โดนตีธรรมดา ยังสตั๊นต่อ ไม่เปลี่ยนเป็นชะงัก
					state = "flinch"
					state_t = hold
				vel.x = dir * float(h.get("kb", 2.5))
		"launch":
			vel.y = float(h.get("vy", 10.0))
			# ลอยขึ้นตรง ไม่โค้งถอยออกไป ผู้เล่นตามตีต่อได้ทัน
			vel.x = dir * float(h.get("launch_kb", 0.0))
			state = "air"
			air_t = 0.0
			air_stall = float(h.get("stall", 0.15))
		"knockdown":
			vel.y = -8.0 if airborne else 5.0
			vel.x = dir * float(h.get("fly", 7.0))
			state = "air"
			air_t = 0.0
			air_stall = 0.0
			kd_flight = true
		"fall":
			# ล้มลงตรงจุดที่โดนตี ไม่กระเด็น
			vel.x = 0.0
			vel.y = -8.0 if airborne else 2.5
			state = "air"
			air_t = 0.0
			air_stall = 0.0
			kd_flight = true
		"drop":
			vel.x = 0.0
			vel.y = -14.0
			state = "air"
			air_t = 0.0
			air_stall = 0.0
		"slam":
			vel.x = dir * 1.0
			vel.y = -18.0 if airborne else 3.0
			state = "air"
			air_t = 0.0
			kd_flight = true
			slam_flag = true
	_check_death()
	return true

func _check_death() -> void:
	if hp > 0.0 or state == "dead":
		return
	if role == "dummy":
		hp = max_hp
		return
	state = "dead"
	Snd.play("defeat", -3.0, 0.06)
	hp = 0.0
	kd_flight = false
	tele_t = 0.0
	strike_t = 0.0
	ai_ult_warn = 0.0
	_hurt_t = 9.0
	remove_from_group("monsters")
	_death_dir = signf(pos.x - hero.pos.x) if is_instance_valid(hero) and pos.x != hero.pos.x else -ai_face
	_death_vel = Vector2(_death_dir * 4.5, 8.0)
	died.emit(self)

## ลอยกระเด็นหมุน ตกพื้นแล้วสลายเป็นควัน
func _tick_death(delta: float) -> void:
	death_t += delta
	if death_t < DEATH_FLY:
		_death_vel.y -= GRAVITY * delta
		pos += _death_vel * delta
		pos.x = clampf(pos.x, -half_width, half_width)
		pos.y = maxf(pos.y, floor_h)
	for n in _numbers:
		n["t"] = float(n["t"]) + delta
	_numbers = _numbers.filter(func(n): return float(n["t"]) < NUMBER_LIFE)
	_place()
	queue_redraw()
	if death_t >= DEATH_TIME:
		queue_free()

## เริ่มท่าเตรียมตี
func _tele(kind: String, time: float) -> void:
	tele_kind = kind
	tele_t = time
	tele_len = maxf(time, 0.01)

## ตีออกไปแล้ว วาดรอยตะปบ
func _strike(kind: String) -> void:
	tele_t = 0.0
	strike_kind = kind
	strike_t = STRIKE_TIME

## โดนตีระหว่างเตรียมท่า ท่าถูกขัด (ยกเว้นเกราะหนาและบอส)
func _cancel_tele() -> void:
	if ROLES.get(role, {}).get("armor", false) or role.begins_with("boss_"):
		return
	tele_t = 0.0
	ai_crouch = 0.0
	ai_rush_wind = 0.0

## กำลังชะงักอยู่หรือไม่ 0 ถึง 1
func flinch_amount() -> float:
	return clampf(_flinch_t / FLINCH_TIME, 0.0, 1.0)

## ไฟที่ติดตัวกัดเลือดเรื่อยๆ จนดับ
func _tick_burn(delta: float) -> void:
	if burn_t <= 0.0:
		return
	burn_t -= delta
	_burn_clock += delta
	_burn_tick -= delta
	if burn_t <= 0.0:
		burn_kind = ""
		return
	if _burn_tick <= 0.0:
		_burn_tick = BURN_GAP
		var burn_dmg := BURN_DMG * (hero.burn_mult() if is_instance_valid(hero) else 1.0)
		hp -= burn_dmg
		_numbers.append({"text": str(int(burn_dmg)), "t": 0.0, "x": randf_range(-20.0, 20.0)})
		_check_death()

func _physics_process(delta: float) -> void:
	_clock += delta
	if state == "dead":
		_look_t += delta
		_tick_death(delta)
		return
	tele_t = maxf(tele_t - delta, 0.0)
	strike_t = maxf(strike_t - delta, 0.0)
	armor_t = maxf(armor_t - delta, 0.0)
	mark_t = maxf(mark_t - delta, 0.0)
	weak_t = maxf(weak_t - delta, 0.0)
	_look_t += delta
	ice_t = maxf(ice_t - delta, 0.0)
	_hurt_t = maxf(_hurt_t - delta, 0.0)
	if frozen or ice_t > 0.0:
		_flinch_t = maxf(_flinch_t - delta, 0.0)
		for n in _numbers:
			n["t"] = float(n["t"]) + delta
		_numbers = _numbers.filter(func(n): return float(n["t"]) < NUMBER_LIFE)
		_place()
		queue_redraw()
		return
	_tick_burn(delta)
	slow_t = maxf(slow_t - delta, 0.0)
	if state == "dead":
		return
	root_t = maxf(root_t - delta, 0.0)
	_flinch_t = maxf(_flinch_t - delta, 0.0)
	var g := GRAVITY
	if air_stall > 0.0:
		air_stall -= delta
		g *= 0.25
	if not on_floor():
		vel.y -= g * delta
	match state:
		"idle":
			vel.x = move_toward(vel.x, 0.0, 30.0 * delta)
			_ai(delta)
		"stun", "flinch":
			vel.x = move_toward(vel.x, 0.0, 12.0 * delta)
			state_t -= delta
			if state_t <= 0.0:
				state = "idle"
		"air":
			air_t += delta
			if air_t > 0.08 and on_floor():
				_land()
		"down":
			vel.x = move_toward(vel.x, 0.0, 20.0 * delta)
			state_t -= delta
			if state_t <= 0.0:
				state = "getup"
				state_t = GETUP_TIME
		"getup":
			state_t -= delta
			if state_t <= 0.0:
				state = "idle"
				kd = 0.0
				air_hits = 0
	if root_t > 0.0 and on_floor():
		vel.x = 0.0
	var vx_before := vel.x
	pos += vel * delta
	if plat != Vector2.ZERO:
		pos.x = clampf(pos.x, plat.x, plat.y)
	if pos.y <= floor_h + FLOOR_EPS:
		pos.y = floor_h
		vel.y = minf(vel.y, 0.0) if vel.y > 0.0 else 0.0
	_keep_inside(vx_before)
	_separate(delta)
	var want := LIE_DEG if state == "down" else 0.0
	_lie = move_toward(_lie, want, LIE_RATE * delta)
	for n in _numbers:
		n["t"] = float(n["t"]) + delta
	_numbers = _numbers.filter(func(n): return float(n["t"]) < NUMBER_LIFE)
	_place()
	queue_redraw()

## ขอบจอทำหน้าที่เป็นกำแพง
func _keep_inside(vx_before: float) -> void:
	if absf(pos.x) < half_width:
		return
	pos.x = clampf(pos.x, -half_width, half_width)
	vel.x = 0.0
	if state == "air" and not wall_bounced and absf(vx_before) >= WALL_BOUNCE_MIN_SPEED:
		wall_bounced = true
		kd_flight = false
		vel.x = -vx_before * WALL_BOUNCE_KEEP
		vel.y = maxf(vel.y, WALL_BOUNCE_VY)
		air_t = 0.0

## มอนบนพื้นผลักกันออกเฉพาะแกน X
func _separate(delta: float) -> void:
	if not on_floor():
		return
	for other in get_tree().get_nodes_in_group("monsters"):
		if other == self or not other.on_floor():
			continue
		# คนละชั้น ไม่ผลักกัน
		if absf(pos.y - other.pos.y) > 0.9:
			continue
		var dx: float = pos.x - other.pos.x
		var overlap: float = body_radius + other.body_radius - absf(dx)
		if overlap > 0.0:
			var side := signf(dx) if dx != 0.0 else (1.0 if get_instance_id() > other.get_instance_id() else -1.0)
			pos.x += side * minf(overlap * 0.5, PUSH_SPEED * delta)

func _land() -> void:
	air_hits = 0
	slam_flag = false
	if kd_flight or wall_bounced or launch_fall:
		kd_flight = false
		wall_bounced = false
		launch_fall = false
		state = "down"
		state_t = DOWN_TIME
		vel.x *= 0.3
	else:
		state = "flinch"
		state_t = 0.0 if vel.y < -10.0 else 0.25

func _ai(delta: float) -> void:
	if role == "dummy" or not is_instance_valid(hero) or hero.hp <= 0.0:
		return
	var spec: Dictionary = ROLES[role]
	var dx: float = hero.pos.x - pos.x
	var dir := signf(dx) if dx != 0.0 else ai_face
	ai_cool -= delta / easy_slow
	# ยืนบนแท่นลอยแล้วตัวละครเข้ามาใกล้อยู่ข้างล่าง กระโดดลงมาสู้บนพื้น ตีง่ายขึ้น
	if plat != Vector2.ZERO and floor_h > 0.0 and on_floor() and absf(dx) < HOP_DOWN_RANGE and hero.pos.y < floor_h - 0.5 and not role.begins_with("boss") and state != "dead":
		floor_h = 0.0
		plat = Vector2.ZERO
		vel = Vector2(dir * 2.5, 5.0)
		return
	# อยู่ไกลเกินระยะไล่ กระโดดเล่นอยู่กับที่
	if aggro > 0.0 and absf(dx) > aggro:
		_ai_idle(delta)
		return
	if spec.has("hop"):
		_ai_hop(spec, dx, dir)
		return
	if spec.has("shoot_every"):
		_ai_ranged(spec, dx, dir, delta)
		return
	if spec.has("heal_every"):
		_ai_support(spec, dx, dir, delta)
		return
	if spec.has("rush"):
		_ai_rush(spec, dx, dir, delta)
		return
	if phase == 2 and _ai_ultimate(delta):
		return
	if spec.has("float"):
		pos.y = lerpf(pos.y, float(spec["float"]) + sin(_clock * 2.0) * 0.25, 1.0 - exp(-4.0 * delta))
		vel.y = 0.0
	if spec.has("slam_every") and _ai_slam(spec, dx, dir, delta):
		return
	if _ai_boss_moves(spec, dx, dir, delta):
		return
	if ai_state == "windup":
		ai_t -= delta
		if ai_t <= 0.0:
			ai_state = "move"
			ai_cool = float(spec["cool"]) * (0.65 if phase == 2 else 1.0)
			_strike(_melee_kind(spec))
			if absf(dx) <= float(spec["reach"]) + body_radius and absf(hero.pos.y - pos.y) < 2.5:
				hero.take_damage(easy_dmg * float(spec["dmg"]) * (WEAK_DMG if weak_t > 0.0 else 1.0), ai_face)
			if spec.has("lunge"):
				ai_lunge_t = 0.28
			# ฟันต่อเนื่องหลายที
			if spec.has("combo") and ai_combo < int(spec["combo"]) - 1:
				ai_combo += 1
				ai_state = "windup"
				ai_t = 0.5
				_tele("claw", 0.5)
			else:
				ai_combo = 0
		return
	ai_face = dir
	if absf(dx) > float(spec["reach"]) - 0.2 + body_radius:
		vel.x = dir * float(spec["speed"]) * (0.4 if slow_t > 0.0 else 1.0) * (1.35 if phase == 2 else 1.0)
	elif ai_cool <= 0.0:
		ai_state = "windup"
		ai_t = maxf(float(spec["windup"]), 0.7)
		_tele(_melee_kind(spec), ai_t)

## ท่าตีของแต่ละตัว หอกแทง ค้อนทุบ ที่เหลือตะปบ
func _melee_kind(spec: Dictionary) -> String:
	if spec.has("lunge"):
		return "stab"
	if spec.has("wave_every") or role == "tank" or role == "midboss":
		return "smash"
	return "claw"

## ตัวยิงไกล รักษาระยะ หันหาตัวละคร ยิงเป็นระยะ อยู่บนแท่นก็ยืนยิงอยู่บนแท่น
func _ai_ranged(spec: Dictionary, dx: float, dir: float, delta: float) -> void:
	ai_face = dir
	if plat == Vector2.ZERO:
		var want := 0.0
		if absf(dx) < float(spec["keep"]) - 1.0:
			want = -dir
		elif absf(dx) > float(spec["keep"]) + 2.0:
			want = dir
		vel.x = want * float(spec["speed"])
	else:
		vel.x = 0.0
	ai_shoot_t -= delta / easy_slow
	if ai_shoot_t <= 0.9 and tele_t <= 0.0 and tele_kind != "shoot_wait":
		_tele("shoot", maxf(ai_shoot_t, 0.05))
		tele_kind = "shoot"
	if ai_shoot_t <= 0.0:
		ai_shoot_t = float(spec["shoot_every"]) * randf_range(0.8, 1.2)
		_strike("shoot")
		shoot.emit(self)

## ซัพพอร์ต อยู่หลังเพื่อนที่ใกล้ตัวละครที่สุด ฮีลเพื่อนที่เลือดลดในระยะ
func _ai_support(spec: Dictionary, dx: float, dir: float, delta: float) -> void:
	ai_face = dir
	heal_fx = maxf(heal_fx - delta, 0.0)
	var front: Monster = null
	for e in get_tree().get_nodes_in_group("monsters"):
		var m := e as Monster
		if m == null or m == self or m.state == "dead":
			continue
		if front == null or absf(m.pos.x - hero.pos.x) < absf(front.pos.x - hero.pos.x):
			front = m
	var spot := (front.pos.x - dir * 3.0) if front != null else hero.pos.x - dir * 7.0
	vel.x = clampf(spot - pos.x, -1.0, 1.0) * float(spec["speed"])
	ai_heal_t -= delta
	if ai_heal_t <= 0.0:
		ai_heal_t = float(spec["heal_every"])
		for e in get_tree().get_nodes_in_group("monsters"):
			var m := e as Monster
			if m == null or m.state == "dead" or m.hp >= m.max_hp or absf(m.pos.x - pos.x) > float(spec["heal_reach"]):
				continue
			m.hp = minf(m.hp + float(spec["heal"]), m.max_hp)
			m._numbers.append({"text": "+%d" % int(spec["heal"]), "t": 0.0, "x": 0.0})
			healed.emit(self, m)
		heal_fx = 0.6

## ตัวพุ่งชน นิ่งรอจนตัวละครเข้าระยะ แล้วพุ่งเร็ว ชนโดนครั้งเดียวต่อรอบ
func _ai_rush(spec: Dictionary, dx: float, dir: float, delta: float) -> void:
	if ai_rushing > 0.0:
		ai_rushing -= delta
		vel.x = ai_face * float(spec["rush"])
		if not ai_hit and absf(dx) < 0.9 + body_radius and absf(hero.pos.y - pos.y) < 1.4:
			ai_hit = true
			hero.take_damage(easy_dmg * float(spec["dmg"]), ai_face)
		return
	vel.x = 0.0
	if ai_rush_wind > 0.0:
		ai_rush_wind -= delta
		if ai_rush_wind <= 0.0:
			ai_rushing = 0.6
			ai_hit = false
			_strike("rush")
		return
	if absf(dx) < float(spec["trigger"]) and ai_cool <= 0.0:
		ai_cool = float(spec["cool"])
		ai_face = dir
		ai_rush_wind = 0.9
		_tele("rush", 0.9)
	elif ai_cool > 0.0:
		ai_face = dir

## บอสเลือดเหลือครึ่ง เข้าเฟส 2 เร็วขึ้น เรียกลูกน้อง เริ่มใช้ท่าใหญ่ทั้งลาน
func _check_phase() -> void:
	if phase == 1 and role.begins_with("boss_") and hp <= max_hp * 0.5 and hp > 0.0:
		phase = 2
		ai_ult_t = 1.5
		phase_two.emit(self)

## ท่าใหญ่ทั้งลาน เตือน 1.6 วิ แล้วกระแทกทั้งลาน คนที่อยู่บนพื้นโดน กระโดดหรือขึ้นแท่นหลบได้
func _ai_ultimate(delta: float) -> bool:
	if ai_ult_warn > 0.0:
		ai_ult_warn -= delta
		vel.x = 0.0
		if ai_ult_warn <= 0.0:
			ai_ult_t = randf_range(9.0, 12.0)
			ult_hit.emit(self)
		return true
	ai_ult_t -= delta / easy_slow
	if ai_ult_t <= 0.0 and on_floor() and ai_state != "windup":
		ai_ult_warn = 1.6
		ult_warn.emit(self)
		return true
	return false

## มอนยังไม่เห็นตัวละคร กระโดดดึ๋งเบาๆ อยู่กับที่ หันซ้ายขวา
func _ai_idle(delta: float) -> void:
	ai_idle_t -= delta
	if on_floor():
		vel.x = 0.0
		if ai_idle_t <= 0.0:
			ai_idle_t = randf_range(1.2, 2.6)
			if role == "hopper":
				vel.y = randf_range(3.0, 5.0)
				pos.y = 0.01
			ai_face = -ai_face if randf() < 0.4 else ai_face

## ท่าพิเศษของบอสแต่ละตัว คืน true ถ้ากำลังทำท่าอยู่
func _ai_boss_moves(spec: Dictionary, dx: float, dir: float, delta: float) -> bool:
	# แทงแล้วพุ่งตาม
	if ai_lunge_t > 0.0:
		ai_lunge_t -= delta
		vel.x = ai_face * float(spec["lunge"])
		return true
	# ชาร์จโล่พุ่งข้ามลาน ชนโดนครั้งเดียว
	if ai_charging > 0.0:
		ai_charging -= delta
		vel.x = ai_face * 12.0
		if not ai_hit and absf(dx) < 1.4 + body_radius and hero.pos.y < 2.0:
			ai_hit = true
			hero.take_damage(easy_dmg * float(spec["charge_dmg"]), ai_face)
		return true
	# กระทืบเท้าเตรียมชาร์จ
	if ai_charge_wind > 0.0:
		ai_charge_wind -= delta
		vel.x = 0.0
		if ai_charge_wind <= 0.0:
			ai_charging = 0.8
			ai_hit = false
			_strike("charge")
		return true
	# ยกค้อนสูงเตรียมทุบคลื่น
	if ai_wave_wind > 0.0:
		ai_wave_wind -= delta
		vel.x = 0.0
		if ai_wave_wind <= 0.0:
			_strike("smash")
			shockwave.emit(self, ai_face)
			ai_cool = 0.6
		return true
	if ai_state == "windup":
		return false
	if spec.has("charge_every"):
		ai_charge_t -= delta / easy_slow
		if ai_charge_t <= 0.0 and on_floor():
			ai_charge_t = float(spec["charge_every"]) * randf_range(0.8, 1.2)
			ai_face = dir
			ai_charge_wind = 1.1
			_tele("charge", 1.1)
			return true
	if spec.has("wave_every"):
		ai_wave_t -= delta / easy_slow
		if ai_wave_t <= 0.0 and on_floor():
			ai_wave_t = float(spec["wave_every"]) * randf_range(0.8, 1.2)
			ai_face = dir
			ai_wave_wind = 1.1
			_tele("wave", 1.1)
			return true
	if spec.has("teleport_every"):
		ai_tp_t -= delta / easy_slow
		if ai_tp_t <= 0.0:
			ai_tp_t = float(spec["teleport_every"]) * randf_range(0.8, 1.2)
			var from := position
			var side := -hero.facing if hero.facing != 0.0 else 1.0
			pos.x = clampf(hero.pos.x + side * 2.2, -half_width + 0.5, half_width - 0.5)
			ai_face = -side
			vanished.emit(self, from)
			ai_state = "windup"
			ai_t = maxf(float(spec["windup"]), 0.55)
			_tele("claw", ai_t)
			return true
	return false

## กระโดดดึ๋งเข้าหาตัวละคร ชนโดนตอนลอยผ่าน
func _ai_hop(spec: Dictionary, dx: float, dir: float) -> void:
	if on_floor():
		ai_hit = false
		ai_face = dir
		vel.x = 0.0
		# ย่อตัวเตรียมพุ่ง เห็น ! ก่อน แล้วค่อยกระโดดตะปบ
		if ai_crouch > 0.0:
			ai_crouch -= get_physics_process_delta_time()
			if ai_crouch <= 0.0:
				ai_hop_vx = dir * float(spec["speed"]) * (0.4 if slow_t > 0.0 else 1.0)
				vel.y = float(spec["hop"]) * randf_range(0.85, 1.1)
				pos.y = floor_h + 0.01
				vel.x = ai_hop_vx
				_strike("pounce")
				strike_t = 0.0
				ai_hit = false
			return
		if ai_cool <= 0.0 and root_t <= 0.0:
			ai_cool = float(spec["cool"]) * randf_range(0.9, 1.3)
			# อยู่ไกลแค่เดินเข้าหา กระโดดสั้นไม่ตะปบ
			if absf(dx) > 4.5:
				ai_hop_vx = dir * float(spec["speed"]) * 0.7
				vel.y = float(spec["hop"]) * 0.55
				pos.y = floor_h + 0.01
				vel.x = ai_hop_vx
				ai_hit = true
				return
			ai_crouch = 0.75
			_tele("pounce", 0.75)
		return
	vel.x = ai_hop_vx
	if not ai_hit and absf(dx) <= float(spec["reach"]) + body_radius and absf(hero.pos.y - pos.y) < 1.4:
		ai_hit = true
		_strike("claw")
		hero.take_damage(easy_dmg * float(spec["dmg"]) * (WEAK_DMG if weak_t > 0.0 else 1.0), ai_face)

## บอสกระโดดลอยไปหาตัวละคร ตกลงทุบพื้น ใกล้แค่ไหนโดนหมด คืน true ระหว่างกระโดด
func _ai_slam(spec: Dictionary, dx: float, dir: float, delta: float) -> bool:
	if ai_slamming:
		if on_floor() and vel.y <= 0.0:
			ai_slamming = false
			ai_cool = float(spec["cool"])
			_strike("slam")
			if absf(hero.pos.x - pos.x) <= float(spec["slam_reach"]) and hero.pos.y < 1.5:
				hero.take_damage(easy_dmg * float(spec["slam_dmg"]), signf(hero.pos.x - pos.x))
			slammed.emit(self)
		else:
			vel.x = ai_hop_vx
		return true
	if ai_slam_wind > 0.0:
		ai_slam_wind -= delta
		vel.x = 0.0
		if ai_slam_wind <= 0.0:
			ai_slamming = true
			ai_hop_vx = clampf(dx, -6.0, 6.0) / 1.1
			vel.y = 12.0
			pos.y = floor_h + 0.01
		return true
	ai_slam_t -= delta / easy_slow
	if ai_slam_t <= 0.0 and ai_state != "windup" and on_floor():
		ai_slam_t = float(spec["slam_every"]) * randf_range(0.8, 1.2)
		ai_face = dir
		ai_slam_wind = 0.9
		_tele("slam", 0.9)
		return true
	return false

func _place() -> void:
	position = Vector2(pos.x, -pos.y) * CombatData.UNIT

func _draw() -> void:
	if state == "dead":
		_draw_death()
		return
	var lean := _lie * _flinch_dir
	var body_y := -DRAW_GAP - DRAW_H * 0.5
	var top := MonsterLook.top(look)
	var tk := _tele_k()
	var sk := strike_t / STRIKE_TIME
	var pre := Vector2.ZERO
	var crouch := 0.0
	if tk > 0.0:
		_draw_tele_back(top, tk)
		match tele_kind:
			"rush", "charge":
				lean = -ai_face * 10.0 * tk
				crouch = 0.12 * tk
				pre.x = sin(_clock * 70.0) * 5.0 * tk
			"pounce", "slam":
				lean = -ai_face * 8.0 * tk
				crouch = 0.28 * tk
				pre.x = sin(_clock * 40.0) * 3.0 * tk
			"shoot":
				lean = -ai_face * 6.0 * tk
				crouch = 0.06 * tk
			_:
				lean = -ai_face * 22.0 * tk
				crouch = 0.14 * tk
	elif sk > 0.0:
		lean = ai_face * 18.0 * sk
	elif ai_rushing > 0.0 or ai_charging > 0.0:
		lean = ai_face * 20.0
	elif not on_floor() and role == "hopper" and not ai_hit:
		lean = ai_face * 24.0
	# โดนตีตัวสั่น
	var pivot := Vector2(sin(_clock * 95.0) * 7.0 * _hurt_t / 0.35, 0.0)
	# โดนตีตัวเอนหนีแล้วเด้งกลับ ยุบนิดหน่อย
	var shock := flinch_amount()
	lean += _flinch_dir * FLINCH_LEAN * sin(shock * PI * 0.5)
	var squash := Vector2(1.0 + FLINCH_SQUASH * shock + crouch * 0.6, 1.0 - FLINCH_SQUASH * shock - crouch)
	draw_set_transform(pivot + pre, deg_to_rad(lean), squash)
	if _model != null:
		_model.visible = true
		_model.transform = Transform2D(deg_to_rad(lean), squash, 0.0, pivot + pre)
		_model.face = ai_face
		_model.flash = clampf(_hurt_t / 0.35, 0.0, 1.0) * 0.6
		_model.tele = tk
		_model.strike = sk
		_back.queue_redraw()
	# บอสเฟส 2 ออร่าแดงเต้น ซัพพอร์ตฮีลมีแสงเขียว เตือนท่าใหญ่เรืองแดงแรง
	if phase == 2 or ai_ult_warn > 0.0:
		var pulse := 0.5 + 0.5 * sin(_clock * (14.0 if ai_ult_warn > 0.0 else 6.0))
		draw_circle(Vector2(0.0, -MonsterLook.top(look) * 0.45), MonsterLook.top(look) * 0.55, Color(1.0, 0.25, 0.25, (0.35 if ai_ult_warn > 0.0 else 0.15) * pulse))
	if heal_fx > 0.0:
		draw_arc(Vector2(0.0, -50.0), 70.0 + 30.0 * (0.6 - heal_fx), 0.0, TAU, 32, Color(0.4, 0.95, 0.5, heal_fx), 5.0, true)
	if _model != null:
		pass
	elif CatLook.TOP.has(look):
		CatLook.draw(self, look, _look_t, ai_face)
	elif look != "":
		MonsterLook.draw(self, look, _look_t, ai_face, Sketch.INK)
	else:
		Sketch.shape(self, Sketch.capsule(Vector2(0.0, body_y), DRAW_R, DRAW_H), 81)
		Sketch.shape(self, Sketch.oval(Vector2(0.0, body_y), 15.0, 15.0), 82)
		Sketch.shape(self, Sketch.oval(Vector2(0.0, body_y), 6.0, 6.0), 83, 2.2)
		if role == "melee":
			Sketch.line(self, PackedVector2Array([Vector2(-28.0, body_y - 34.0), Vector2(28.0, body_y - 34.0)]), 84)
	if burn_kind != "":
		_draw_burn(body_y)
	if root_t > 0.0:
		_draw_root()
	if ice_t > 0.0:
		_draw_ice(body_y)
	if mark_t > 0.0:
		_draw_mark(body_y)
	if tk > 0.0:
		_draw_tele_paw(top, tk)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if sk > 0.0:
		_draw_strike(top, sk)
	if ai_rushing > 0.0 or ai_charging > 0.0:
		_draw_speed_lines(top)
	if tk > 0.0:
		_draw_alert(-top - 70.0, tk)
	if _lie < 1.0 and look == "" and _model == null:
		for side in [-1.0, 1.0]:
			Sketch.shape(self, Sketch.oval(Vector2(side * 20.0, -6.0), 16.0, 6.0), 85 + int(side))
	var head_y: float = body_y - DRAW_H * 0.5 if look == "" and _model == null else -MonsterLook.top(look)
	_draw_bar(head_y - 22.0)
	if ROLES.get(role, {}).get("armor", false) and state != "dead":
		var at := Vector2(-BAR_W * 0.5 - 16.0, head_y - 22.0 + BAR_H * 0.5)
		draw_colored_polygon(PackedVector2Array([at + Vector2(-9.0, -10.0), at + Vector2(9.0, -10.0), at + Vector2(8.0, 3.0), at + Vector2(0.0, 11.0), at + Vector2(-8.0, 3.0)]), Color(1.0, 0.6, 0.2))
	if state == "stun":
		_draw_dizzy(head_y - 22.0 - DIZZY_LIFT)
	_draw_numbers(head_y - 34.0)

## 0 ถึง 1 ยิ่งใกล้ตียิ่งมาก
func _tele_k() -> float:
	if tele_t <= 0.0 or state != "idle":
		return 0.0
	return clampf(1.0 - tele_t / tele_len, 0.0, 1.0) * 0.7 + 0.3

## แสงแดงกะพริบหลังตัว ยิ่งใกล้ตียิ่งถี่
func _draw_tele_back(top: float, k: float) -> void:
	var pulse := 0.5 + 0.5 * sin(_clock * (10.0 + 26.0 * k))
	var c := Color(1.0, 0.3, 0.25, 0.18 + 0.22 * pulse * k)
	if tele_kind == "shoot":
		c = Color(0.85, 0.4, 1.0, 0.15 + 0.2 * pulse * k)
	# ตัว 3D วาดแสงนี้ไว้ด้านหลังตัวแทน (_back_draw)
	if _model == null:
		draw_circle(Vector2(0.0, -top * 0.45), top * (0.52 + 0.08 * k), c)
	if tele_kind == "rush" or tele_kind == "charge":
		# ฝุ่นฟุ้งหลังเท้า
		for i in 3:
			var f := fposmod(_clock * 3.0 + float(i) * 0.33, 1.0)
			draw_circle(Vector2(-ai_face * (top * 0.3 + f * 50.0), -10.0 - f * 26.0), 10.0 + f * 12.0, Color(0.85, 0.78, 0.66, 0.6 * (1.0 - f)))

## อุ้งเท้ายกขึ้นเหนือหัว (ตะปบ แทง ทุบ) ลูกพลังที่ปาก (ยิง)
func _draw_tele_paw(top: float, k: float) -> void:
	var face := ai_face
	match tele_kind:
		"shoot":
			var at := Vector2(face * top * 0.42, -top * 0.5)
			var r := 6.0 + 16.0 * k
			draw_circle(at, r * 1.6, Color(0.9, 0.5, 1.0, 0.3))
			draw_circle(at, r, Color(0.95, 0.65, 1.0, 0.9))
			draw_circle(at, r * 0.5, Color(1.0, 1.0, 1.0, 0.95))
			return
		"pounce", "rush", "charge", "slam":
			return
	var lift := top * (0.75 + 0.45 * k)
	var at := Vector2(-face * top * 0.25, -lift)
	var r := top * 0.16 * (1.25 if tele_kind == "smash" else 1.0)
	if tele_kind == "stab":
		at = Vector2(-face * top * 0.45, -top * 0.55)
		draw_line(at, at + Vector2(face * top * 0.9, 0.0), Color(0.45, 0.3, 0.18), 7.0)
		draw_colored_polygon(PackedVector2Array([at + Vector2(face * top * 0.9, -12.0), at + Vector2(face * top * 1.15, 0.0), at + Vector2(face * top * 0.9, 12.0)]), Color(0.85, 0.88, 0.95))
	CatLook._fill(self, Sketch.oval(at, r, r * 0.92, 16), Color(1.0, 0.96, 0.92))
	draw_circle(at + Vector2(0.0, r * 0.18), r * 0.42, Color(1.0, 0.62, 0.72))
	for i in 3:
		var toe := at + Vector2((float(i) - 1.0) * r * 0.5, -r * 0.45)
		draw_circle(toe, r * 0.17, Color(1.0, 0.62, 0.72))
		# กรงเล็บโผล่ตอนใกล้ตี
		if k > 0.6:
			var tip := toe + Vector2(0.0, -r * (0.35 + 0.4 * (k - 0.6) / 0.4))
			draw_colored_polygon(PackedVector2Array([toe + Vector2(-3.0, -r * 0.15), tip, toe + Vector2(3.0, -r * 0.15)]), Color(1.0, 1.0, 1.0))

## เครื่องหมาย ! เหนือหัว เด้งใหญ่ขึ้นตอนใกล้ตี
func _draw_alert(y: float, k: float) -> void:
	var bob := 1.0 + 0.25 * k + 0.1 * sin(_clock * 30.0)
	var at := Vector2(0.0, y)
	var r := 17.0 * bob
	draw_circle(at, r + 3.0, Color(0.35, 0.1, 0.05))
	draw_circle(at, r, Color(1.0, 0.85, 0.2) if k < 0.85 else Color(1.0, 0.35, 0.25))
	draw_line(at + Vector2(0.0, -r * 0.6), at + Vector2(0.0, r * 0.18), Color(0.35, 0.1, 0.05), 5.0 * bob)
	draw_circle(at + Vector2(0.0, r * 0.52), 3.0 * bob, Color(0.35, 0.1, 0.05))

## รอยตีพุ่งออกด้านหน้า หายไปเร็ว
func _draw_strike(top: float, k: float) -> void:
	var face := ai_face
	var a := k
	match strike_kind:
		"stab":
			var y := -top * 0.55
			draw_line(Vector2(face * top * 0.2, y), Vector2(face * top * (1.2 + (1.0 - k) * 1.2), y), Color(1.0, 1.0, 1.0, a), 10.0 * k + 2.0)
			draw_line(Vector2(face * top * 0.2, y), Vector2(face * top * (1.2 + (1.0 - k) * 1.2), y), Color(1.0, 0.35, 0.3, a * 0.6), 18.0 * k + 2.0)
		"smash", "slam":
			var r := top * (0.5 + (1.0 - k) * 1.1)
			for i in 2:
				var ring := Sketch.oval(Vector2(0.0, -4.0), r * (1.0 - float(i) * 0.25), r * 0.22 * (1.0 - float(i) * 0.25), 24)
				ring.append(ring[0])
				draw_polyline(ring, Color(1.0, 0.85, 0.6, a), 6.0 * k + 1.0, true)
			for i in 5:
				var ang := PI + float(i) / 4.0 * PI
				var d := Vector2(cos(ang), sin(ang))
				draw_line(Vector2(0.0, -6.0) + d * r * 0.4, Vector2(0.0, -6.0) + d * r * 0.75, Color(0.75, 0.6, 0.45, a), 5.0)
		"shoot":
			draw_circle(Vector2(face * top * 0.42, -top * 0.5), 26.0 * (1.0 + (1.0 - k)), Color(1.0, 0.8, 1.0, a * 0.6))
		"rush", "charge":
			draw_circle(Vector2(-face * top * 0.4, -12.0), 30.0 * (1.5 - k), Color(0.9, 0.85, 0.75, a * 0.7))
		_:
			# ตะปบสามเส้น โค้งจากบนลงล่างด้านหน้า
			var c := Vector2(face * top * 0.35, -top * 0.5)
			var r := top * 0.62
			var from := -PI * 0.6 if face > 0.0 else -PI * 0.4
			var span := PI * 0.9 * face
			for i in 3:
				var off := (float(i) - 1.0) * 13.0
				var pts := PackedVector2Array()
				for j in 10:
					var ang := from + span * float(j) / 9.0
					pts.append(c + Vector2(cos(ang), sin(ang)) * (r + off))
				draw_polyline(pts, Color(1.0, 0.35, 0.3, a * 0.7), 12.0 * k + 2.0, true)
				draw_polyline(pts, Color(1.0, 1.0, 1.0, a), 5.0 * k + 1.0, true)

## เส้นความเร็วตอนพุ่ง
func _draw_speed_lines(top: float) -> void:
	for i in 4:
		var y := -top * (0.15 + 0.22 * float(i))
		var f := fposmod(_clock * 6.0 + float(i) * 0.27, 1.0)
		var x0 := -ai_face * (top * 0.45 + f * 40.0)
		draw_line(Vector2(x0, y), Vector2(x0 - ai_face * 60.0, y), Color(1.0, 1.0, 1.0, 0.8 * (1.0 - f)), 4.0)

## ท่าตาย ลอยหมุนกระเด็น ตาเป็น >< แล้วตกพื้นสลายเป็นควันฟู ดาว และวิญญาณแมวลอยขึ้น
func _draw_death() -> void:
	var top := MonsterLook.top(look)
	if death_t < DEATH_FLY:
		var k := death_t / DEATH_FLY
		var spin := _death_dir * k * TAU * 0.9
		draw_set_transform(Vector2(0.0, -top * 0.45), spin, Vector2.ONE * (1.0 - 0.1 * k))
		draw_set_transform_matrix(Transform2D(spin, Vector2.ONE * (1.0 - 0.1 * k), 0.0, Vector2(0.0, -top * 0.45)) * Transform2D(0.0, Vector2(0.0, top * 0.45)))
		if _model != null:
			_model.visible = true
			_model.flash = 0.5
			_model.transform = Transform2D(spin, Vector2.ONE * (1.0 - 0.1 * k), 0.0, Vector2(0.0, -top * 0.45)) * Transform2D(0.0, Vector2(0.0, top * 0.45))
		elif CatLook.TOP.has(look):
			CatLook.draw(self, look, _look_t, ai_face)
		elif look != "":
			MonsterLook.draw(self, look, _look_t, ai_face, Sketch.INK)
		else:
			Sketch.shape(self, Sketch.capsule(Vector2(0.0, -DRAW_GAP - DRAW_H * 0.5), DRAW_R, DRAW_H), 81)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# ดาวหมุนรอบตัวตอนกระเด็น
		for i in 3:
			var ang := _clock * 9.0 + float(i) * TAU / 3.0
			_star(Vector2(cos(ang) * top * 0.5, -top * 0.9 + sin(ang) * 12.0), 9.0, Color(1.0, 0.85, 0.25))
		_draw_numbers(-top - 34.0)
		return
	# ตกพื้นแล้ว ระเบิดเป็นควันฟู
	if _model != null:
		_model.visible = false
	var f := clampf((death_t - DEATH_FLY) / (DEATH_TIME - DEATH_FLY), 0.0, 1.0)
	var alpha := 1.0 - f
	for i in 7:
		var ang := float(i) / 7.0 * TAU + 0.4
		var d := Vector2(cos(ang), sin(ang) * 0.6)
		var r := top * (0.18 + 0.12 * f)
		draw_circle(Vector2(0.0, -top * 0.3) + d * top * (0.15 + 0.5 * f), r, Color(1.0, 1.0, 1.0, 0.9 * alpha))
		draw_arc(Vector2(0.0, -top * 0.3) + d * top * (0.15 + 0.5 * f), r, 0.0, TAU, 16, Color(0.55, 0.5, 0.5, 0.5 * alpha), 2.0, true)
	for i in 4:
		var ang := float(i) / 4.0 * TAU + 0.8
		_star(Vector2(0.0, -top * 0.4) + Vector2(cos(ang), sin(ang)) * top * (0.3 + 0.7 * f), 10.0 * alpha + 2.0, Color(1.0, 0.85, 0.25, alpha))
	# วิญญาณแมวน้อยลอยขึ้น
	var soul := Vector2(sin(f * 9.0) * 8.0, -top * (0.5 + 0.9 * f))
	draw_circle(soul, 13.0, Color(1.0, 1.0, 1.0, 0.85 * alpha))
	for side in [-1.0, 1.0]:
		draw_colored_polygon(PackedVector2Array([soul + Vector2(side * 4.0, -9.0), soul + Vector2(side * 12.0, -18.0), soul + Vector2(side * 12.0, -4.0)]), Color(1.0, 1.0, 1.0, 0.85 * alpha))
	draw_line(soul + Vector2(0.0, 12.0), soul + Vector2(-6.0, 26.0), Color(1.0, 1.0, 1.0, 0.6 * alpha), 4.0)
	_draw_numbers(-top - 34.0)

## ประกายกลมๆ มีแกนขาว (ไม่ใช้ดาวแฉก ให้เข้าธีมทรงมน)
func _star(at: Vector2, r: float, color: Color) -> void:
	draw_circle(at, r * 0.7, color)
	draw_circle(at + Vector2(-r * 0.2, -r * 0.2), r * 0.28, Color(1.0, 1.0, 1.0, color.a * 0.85))

## ตกเป็นเป้า วงเล็งสีแดงทับตัว
func _draw_mark(body_y: float) -> void:
	var c := Vector2(0.0, body_y)
	var ring := Sketch.oval(c, MARK_R, MARK_R, 26)
	ring.append(ring[0])
	Sketch.line(self, ring, 86, 2.8, 0.3, MARK_COLOR)
	for d in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		Sketch.line(self, PackedVector2Array([c + d * MARK_R * 0.6, c + d * MARK_R * 1.3]), 85, 2.4, 0.1, MARK_COLOR)

## แช่แข็ง ก้อนน้ำแข็งครอบตัว
func _draw_ice(body_y: float) -> void:
	var w := DRAW_R + 14.0
	var h := DRAW_H * 0.5 + 18.0
	var pts := PackedVector2Array([Vector2(-w, body_y + h), Vector2(-w - 6.0, body_y - h * 0.4), Vector2(-w * 0.3, body_y - h - 8.0), Vector2(w * 0.6, body_y - h), Vector2(w + 6.0, body_y - h * 0.2), Vector2(w, body_y + h)])
	Sketch.hatch(self, pts, ICE_FILL)
	pts.append(pts[0])
	Sketch.line(self, pts, 87, 3.0, 0.4, ICE_EDGE)

## ถูกตรึง มีวงเวทเล็กๆ ใต้เท้า
func _draw_root() -> void:
	for k in [1.0, 0.65]:
		var ring := Sketch.oval(Vector2.ZERO, ROOT_RX * k, ROOT_RX * k * 0.28, 22)
		ring.append(ring[0])
		Sketch.line(self, ring, 99, 2.4, 0.3, ROOT_COLOR)

## เปลวไฟหนึ่งลิ้น โคนกว้างปลายเรียว แกนกลางพลิ้วเป็นคลื่นวิ่งขึ้น ขอบเต้นไม่สม่ำเสมอเหมือนไฟจริง
func _flame_tongue(base: Vector2, high: float, width: float, phase: float) -> PackedVector2Array:
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for n in 9:
		var k := float(n) / 8.0
		var spine := Vector2(sin(k * 3.6 - _burn_clock * 13.0 + phase) * width * 0.55 * k, -high * k)
		var half := width * pow(1.0 - k, 0.8) * (1.0 + 0.22 * sin(k * 9.0 - _burn_clock * 21.0 + phase))
		left.append(base + spine + Vector2(-half, 0.0))
		right.append(base + spine + Vector2(half, 0.0))
	right.reverse()
	left.append_array(right)
	return left

## ติดไฟ เปลวไฟหลายลิ้นเลียขึ้นจากตัว ไล่สีจากขอบแดงส้มถึงแกนเหลืองขาว มีแสงเรืองรอบตัว สะเก็ดไฟกับควันลอยขึ้น
## ติดเลือด มีหยดเลือดไหลลงตามตัว
func _draw_burn(body_y: float) -> void:
	var colors: Array = CombatData.FLAME[burn_kind]
	if burn_kind == "blood":
		for i in 5:
			var x := -22.0 + float(i) * 11.0
			var k := fmod(_burn_clock * 0.8 + float(i) * 0.37, 1.0)
			var at := Vector2(x, body_y - 40.0 + k * 85.0)
			draw_line(at, at + Vector2(0.0, -12.0), Color(colors[0], 0.9 * (1.0 - k * 0.5)), 3.0, true)
			draw_circle(at, 4.5 * (1.0 - k * 0.3), Color(colors[0], 1.0 - k * 0.5))
		return
	var outer: Color = colors[0]
	var inner: Color = colors[1]
	draw_circle(Vector2(0.0, body_y), DRAW_R * 1.5, Color(outer, 0.1 + 0.04 * sin(_burn_clock * 9.0)))
	var roots := [[-24.0, 18.0, 0.8], [-14.0, -18.0, 1.0], [0.0, -38.0, 1.25], [14.0, -20.0, 1.0], [24.0, 14.0, 0.8], [-6.0, 30.0, 0.6], [8.0, 26.0, 0.65]]
	for i in roots.size():
		var r: Array = roots[i]
		var base := Vector2(float(r[0]), body_y + float(r[1]))
		var flick := 0.8 + 0.2 * sin(_burn_clock * 17.0 + float(i) * 2.1) + 0.1 * sin(_burn_clock * 31.0 + float(i))
		var high := 46.0 * float(r[2]) * flick
		var phase := float(i) * 1.7
		draw_colored_polygon(_flame_tongue(base, high, 15.0, phase), Color(outer, 0.7))
		draw_colored_polygon(_flame_tongue(base, high * 0.72, 10.0, phase + 0.3), Color(outer.lerp(inner, 0.55), 0.85))
		draw_colored_polygon(_flame_tongue(base, high * 0.45, 6.0, phase + 0.6), Color(inner, 0.95))
		draw_colored_polygon(_flame_tongue(base, high * 0.2, 3.0, phase + 0.9), Color(1.0, 0.97, 0.85, 0.9))
	for i in 5:
		var k := fmod(_burn_clock * 1.3 + float(i) * 0.23, 1.0)
		var at := Vector2(sin(float(i) * 7.3 + _burn_clock * 2.0) * 22.0, body_y - 30.0 - k * 80.0)
		draw_circle(at, 2.5 * (1.0 - k) + 0.5, Color(inner, 1.0 - k))
	for i in 2:
		var k := fmod(_burn_clock * 0.6 + float(i) * 0.5, 1.0)
		draw_circle(Vector2(sin(_burn_clock + float(i) * 3.0) * 12.0, body_y - 70.0 - k * 60.0), 10.0 + 14.0 * k, Color(0.35, 0.32, 0.3, 0.18 * (1.0 - k)))

## ดาวหมุนเป็นวงบนหัว บอกว่ากำลังสตั๊น
func _draw_dizzy(y: float) -> void:
	for i in DIZZY_STARS:
		var a := _clock * DIZZY_SPEED + TAU * i / DIZZY_STARS
		var c := Vector2(cos(a) * DIZZY_RX, y + sin(a) * DIZZY_RY)
		# เวียนหัวเป็นหัวใจกลมๆ หมุนรอบหัว
		_heart(c, DIZZY_R, DIZZY_COLOR)

func _heart(c: Vector2, r: float, col: Color) -> void:
	draw_circle(c + Vector2(-r * 0.42, -r * 0.15), r * 0.5, col)
	draw_circle(c + Vector2(r * 0.42, -r * 0.15), r * 0.5, col)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-r * 0.88, 0.0), c + Vector2(r * 0.88, 0.0), c + Vector2(0.0, r * 0.85)]), col)

func _draw_bar(y: float) -> void:
	if hide_bars:
		return
	var left := -BAR_W * 0.5
	_draw_badges(y + BAR_H * 0.5)
	draw_rect(Rect2(left, y, BAR_W * clampf(hp / max_hp, 0.0, 1.0), BAR_H), Sketch.INK)
	Sketch.line(self, PackedVector2Array([
		Vector2(left, y), Vector2(left + BAR_W, y), Vector2(left + BAR_W, y + BAR_H), Vector2(left, y + BAR_H), Vector2(left, y),
	]), 88, 2.0, 0.3)

## ตัวเลขดาเมจนุ่มๆ ขอบครีม  ดาเมจแรงตัวใหญ่ขึ้น สีอุ่น เด้งเบาๆ ตอนขึ้น
func _draw_numbers(y: float) -> void:
	var font := Sketch.font()
	for n in _numbers:
		var u: float = float(n["t"]) / NUMBER_LIFE
		var big: bool = n.get("big", false)
		var size := 34 if big else 25
		var word := str(n["text"])
		var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
		var at := Vector2(float(n["x"]), y - u * NUMBER_RISE * CombatData.UNIT)
		var pop := 1.0 + (0.35 * sin(minf(u / 0.25, 1.0) * PI) if big else 0.0)
		var a := clampf((1.0 - u) / 0.3, 0.0, 1.0)
		draw_set_transform(at, 0.0, Vector2.ONE * pop)
		draw_string_outline(font, Vector2(-w * 0.5, 0.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, 6, Color(NUM_EDGE, a))
		draw_string(font, Vector2(-w * 0.5, 0.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, Color(NUM_BIG if big else NUM_INK, a))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## ป้ายสถานะกลมนุ่มๆ เรียงข้างขวาหลอดเลือด สูงสุด 3 อัน วงนอกบอกเวลาที่เหลือ ระหว่าง HYPER ซ่อน
func _draw_badges(cy: float) -> void:
	if is_instance_valid(hero) and hero.in_hyper():
		return
	var list := []
	if state == "stun":
		list.append(["stun", 0.0])
	if ice_t > 0.0:
		list.append(["ice", ice_t])
	if burn_kind != "" and burn_t > 0.0:
		list.append(["burn_" + burn_kind, burn_t])
	if root_t > 0.0:
		list.append(["root", root_t])
	if slow_t > 0.0:
		list.append(["slow", slow_t])
	if weak_t > 0.0:
		list.append(["weak", weak_t])
	if armor_t > 0.0:
		list.append(["armor", armor_t])
	if mark_t > 0.0:
		list.append(["mark", mark_t])
	var keys := {}
	for e in list:
		keys[e[0]] = true
		if float(e[1]) > float(_st_max.get(e[0], 0.0)):
			_st_max[e[0]] = float(e[1])
	for k in _st_max.keys():
		if not keys.has(k):
			_st_max.erase(k)
	var x := BAR_W * 0.5 + BADGE_R + 8.0
	for i in mini(list.size(), BADGE_MAX):
		var id: String = list[i][0]
		var left: float = list[i][1]
		var c := Vector2(x + float(i) * (BADGE_R * 2.0 + 6.0), cy + sin(_clock * 2.4 + float(i)) * 2.0)
		_badge(c, id, left / maxf(float(_st_max.get(id, left)), 0.01) if left > 0.0 else 1.0)

func _badge(c: Vector2, id: String, k: float) -> void:
	var ink := Color(0.42, 0.36, 0.33)
	var back := Color(1.0, 0.97, 0.92)
	var tint := Color(0.85, 0.8, 0.75)
	match id:
		"stun": tint = Color(1.0, 0.88, 0.55)
		"ice": tint = Color(0.72, 0.87, 1.0)
		"burn_fire": tint = Color(1.0, 0.72, 0.55)
		"burn_poison": tint = Color(0.72, 0.9, 0.6)
		"burn_ice": tint = Color(0.72, 0.87, 1.0)
		"burn_blood": tint = Color(1.0, 0.66, 0.68)
		"root": tint = Color(0.74, 0.88, 0.64)
		"slow": tint = Color(0.8, 0.82, 0.95)
		"weak": tint = Color(0.86, 0.8, 0.92)
		"armor": tint = Color(1.0, 0.76, 0.66)
		"mark": tint = Color(1.0, 0.7, 0.72)
	var r := BADGE_R
	draw_circle(c + Vector2(1.5, 2.0), r, Color(0.0, 0.0, 0.0, 0.08))
	draw_circle(c, r, back)
	draw_circle(c, r - 3.0, tint)
	draw_arc(c, r, 0.0, TAU, 28, Color(ink, 0.6), 2.0, true)
	if k < 1.0:
		draw_arc(c, r + 3.5, -PI * 0.5, -PI * 0.5 + TAU * clampf(k, 0.0, 1.0), 24, Color(ink, 0.45), 2.4, true)
	var s := r * 0.55
	match id:
		"stun":
			var pts := PackedVector2Array()
			for j in 14:
				var a := float(j) * 0.55 + _clock * 4.0
				pts.append(c + Vector2(cos(a), sin(a)) * s * (0.15 + float(j) / 14.0))
			draw_polyline(pts, ink, 2.4, true)
		"ice", "burn_ice":
			UiStyle.fill(self, Rect2(c - Vector2.ONE * s * 0.85, Vector2.ONE * s * 1.7), Color(1.0, 1.0, 1.0, 0.75), s * 0.45)
			draw_line(c + Vector2(-s * 0.35, -s * 0.35), c + Vector2(-s * 0.05, -s * 0.05), Color(0.55, 0.72, 0.92), 2.4, true)
		"burn_fire":
			draw_colored_polygon(Sketch.flame(c + Vector2(0.0, s * 0.75), Vector2.UP, s * 1.7, s * 0.7, 1.5), Color(0.98, 0.5, 0.36))
			draw_circle(c + Vector2(0.0, s * 0.3), s * 0.3, Color(1.0, 0.86, 0.55))
		"burn_poison":
			draw_circle(c + Vector2(-s * 0.3, s * 0.2), s * 0.42, Color(0.45, 0.72, 0.38))
			draw_circle(c + Vector2(s * 0.35, -s * 0.2), s * 0.3, Color(0.45, 0.72, 0.38))
			draw_circle(c + Vector2(s * 0.05, -s * 0.6), s * 0.18, Color(0.45, 0.72, 0.38))
		"burn_blood":
			draw_circle(c + Vector2(0.0, s * 0.25), s * 0.5, Color(0.86, 0.38, 0.42))
			draw_colored_polygon(PackedVector2Array([c + Vector2(-s * 0.45, s * 0.1), c + Vector2(0.0, -s * 0.8), c + Vector2(s * 0.45, s * 0.1)]), Color(0.86, 0.38, 0.42))
		"root":
			draw_arc(c + Vector2(0.0, s * 0.35), s * 0.6, PI, TAU, 12, ink, 2.2, true)
			draw_circle(c + Vector2(-s * 0.35, -s * 0.2), s * 0.32, Color(0.5, 0.74, 0.42))
			draw_circle(c + Vector2(s * 0.35, -s * 0.35), s * 0.32, Color(0.5, 0.74, 0.42))
		"slow":
			draw_arc(c + Vector2(0.0, s * 0.3), s * 0.75, PI, TAU, 14, ink, 2.4, true)
			draw_line(c + Vector2(-s * 0.75, s * 0.3), c + Vector2(s * 0.75, s * 0.3), ink, 2.4, true)
			draw_circle(c + Vector2(-s * 0.15, -s * 0.05), s * 0.14, ink)
			draw_circle(c + Vector2(s * 0.25, -s * 0.1), s * 0.14, ink)
		"weak":
			draw_line(c + Vector2(0.0, -s * 0.7), c + Vector2(0.0, s * 0.55), ink, 3.0, true)
			draw_polyline(PackedVector2Array([c + Vector2(-s * 0.5, s * 0.1), c + Vector2(0.0, s * 0.65), c + Vector2(s * 0.5, s * 0.1)]), ink, 3.0, true)
		"armor":
			var sh := PackedVector2Array([c + Vector2(-s * 0.7, -s * 0.7), c + Vector2(s * 0.7, -s * 0.7), c + Vector2(s * 0.6, s * 0.15), c + Vector2(0.0, s * 0.8), c + Vector2(-s * 0.6, s * 0.15)])
			draw_colored_polygon(sh, Color(1.0, 1.0, 1.0, 0.7))
			draw_polyline(PackedVector2Array([c + Vector2(-s * 0.05, -s * 0.7), c + Vector2(s * 0.15, -s * 0.15), c + Vector2(-s * 0.15, s * 0.2), c + Vector2(s * 0.05, s * 0.7)]), Color(0.84, 0.4, 0.38), 2.2, true)
		"mark":
			draw_arc(c, s * 0.75, 0.0, TAU, 20, Color(0.84, 0.4, 0.44), 2.4, true)
			draw_circle(c, s * 0.25, Color(0.84, 0.4, 0.44))
