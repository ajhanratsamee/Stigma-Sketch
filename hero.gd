class_name Hero
extends Node2D
## ตัวละครแคปซูลถือดาบ ระบบต่อสู้ยกมาจาก Stigma Zero: คิวปุ่ม ชุดท่าตาม CombatData.COMBOS
## แดชกดสองครั้ง ยกเลิกท่าด้วยแดชหรือกระโดด ฟันพลาดหน่วงนานขึ้น ลอยช้าระหว่างคอมโบอากาศ
## hitbox เปิดตามช่วงเวลาของท่า และไม่ชนมอนแนวตั้ง จึงยืนบนหัวมอนไม่ได้
## พิกัด pos เป็นหน่วยโลก y คือความสูงจากพื้น

signal died
signal hurt_by(kind: String)    # โดนตีแล้วเสียเลือด kind คือ melee ranged trap ult

const SPEED := 6.0
const DASH_MULT := 1.8
const JUMP_VELOCITY := 10.5
const GRAVITY := 25.0
const FREE_FALL_DRAG := 8.0
const CHAIN_WINDOW := 0.45
const QUEUE_TIME := 0.35
const BUFFER_WINDOW := 0.3
const DOUBLE_TAP := 0.3
const DASH_TIME := 0.3
const ACTIVE_START := 0.6
const BODY_SEPARATION := 1.0
const PUSH_SPEED := 14.0
const LAYER_GAP := 0.9          # ต่างระดับเกินนี้ถือว่าอยู่คนละชั้น ไม่ชนกัน
const HURT_TIME := 0.45
const FLASH_TIME := 0.2
const INVULN_TIME := 0.8
const COMBO_RESET := 2.0
const MAX_HP := 200.0
const MAX_MP := Stats.MP_BASE    # MP สูงสุดพื้นฐาน 300
const PARENT_CLASS := {"GRAND KNIGHT": "SWORD KNIGHT", "FLAME KNIGHT": "MAGIC KNIGHT", "GUARDIAN KNIGHT": "SHIELD KNIGHT", "CRIMSON KNIGHT": "DARK KNIGHT"}
const CAT_FK_GUARD := Stats.GUARD_MULT   # พาสซีฟ 60.2 ของ FLAME KNIGHT ป้องกัน +100
const CAT_GD_GUARD := Stats.GUARD_MULT   # พาสซีฟ 60.1 ของ GUARDIAN KNIGHT ป้องกัน +100
const CAT_GK_HP := 60.0          # พาสซีฟ 60.1 ของ GRAND KNIGHT
const CAT_GK_GUARD := Stats.GUARD_MULT
const CAT_DK_MP := Stats.MP_UP      # พาสซีฟ 40.1 ของ DARK KNIGHT MP +100
const MP_REGEN := 6.0          # มานาฟื้นต่อวินาที
const MANA_BUFF_TIME := 20.0
const MANA_BUFF_COST := 0.5
const BLINK_LONG := 4.0
const ATTACK_BUFF_TIME := 20.0
const SKILL_BUFF_TIME := 20.0
const SKILL_BUFF_MULT := 1.15
const REGEN_BUFF_TIME := 30.0
const REGEN_BUFF_RATE := 15.0
const MP_PASSIVE := 40.0
const KD_PASSIVE_MP := 100.0
const COAT_TIME := 30.0
const COAT_WIDE := 2.1
const COAT_LABEL := {"ice": "ICE", "poison": "PSN", "water": "WTR", "elec": "ELE", "wind": "WND"}
const AURA_TIME := 30.0          # 35.2 ออร่าดาบ
const AURA_HIT_REACH := 1.7
const AURA_SKILL_BONUS := 1.5
const AURA_LONG := 2.1
const AURA_HALF := 3.0
const AURA_COST := 0.75
const AURA_REGEN := 3.0
const WAVE_CHANCE := 0.33
const WAVE_POWER := 1.5
const WAVE_BASE_DMG := 18.0
const LK_POWER := 1.2
const LK_HP := 1.25
const PARRY_REACH := 3.5
const REFLECT_NEAR := 2.5        # มอนใกล้กว่านี้ถือว่าตีระยะประชิด ปัดไม่ได้
const REFLECT_SPEED := 15.0
const REFLECT_R := 30.0
const REFLECT_DMG := 30.0
const WV_BALL_SIZE := 1.3
const ANIME_HIT_SIZE := 0.75
const RM_MP := 100.0
const RM_HEAL_TIME := 6.0
const RM_HEAL_RATE := 80.0
const RM_CYL_HASTE := 3.0
const RM_NO_DOWN_ATK := 1.15
const RM_DOME_COST := 0.7
const RM_SQUARE_ATK := 1.2
const RM_BASIC := 1.2
const RM_GUARD := 0.8
const DNA_GAIN := 3.0
const DNA_MORE := 2.0
const DNA_MAX := 100.0
const DNA_STEP := 20.0
const DNA_TIME := 20.0
const DNA_REGEN := 2.0
const DNA_REGEN_GAP := 6.0
const DNA_SPEED := 1.2
const DNA_ATK := 1.2
const DNA_SKILL := 1.2
const DNA_ATK_SPEED := 1.25
const LE_MP := 100.0
const DS_FORM_TIME := 30.0
const DS_FORM_ATK := 1.25
const DS_FORM_SPEED := 1.25
const DS_FORM_WING := 0.95
const DS_BASIC := 1.2
const DS_GUARD_TIME := 20.0
const DS_GUARD := 0.7
const DS_MANA_SPEED := 0.3       # มานาเต็มเร็วขึ้นเท่านี้
const DS_BLINK_COST := 0.5
const TW_COST := 0.75
const TW_CD := 0.8
const TW_POWER := 1.3
const TW_MANA_CHANCE := 0.33
const TW_MANA := 10.0
const OP_MP := 100.0
const OP_RESTORE := 5.0
const OP_CD := 0.8
const OP_GAIN := 20.0
const GAUGE_FULL := 100.0
const HASTE_TIME := 15.0
const WV_POWER := 1.2
const WV_GUARD := 0.8
const ZONE_SKILL := 1.3
const ZONE_CD := 0.98
const PARRY_LIFT := 12.0
const BURN_PASSIVE := 1.5
const RK_POWER := 1.1
const RK_MANA := 100.0
const SHOUT_BUFF_TIME := 10.0
const SHOUT_EVERY := 5
const SHOUT_MP := 3.0
const LIMIT_TIME := 30.0
const LIMIT_EXTRA := 100.0
const LIMIT_COST := 0.7
const HASTE_MULT := 1.35
const POTION_TIME := 10.0
const BUBBLE_GAP := 1.9
const BUBBLE_AHEAD := 2.2
const RECALL_TIME := 50.0
const ST_SPEED := 1.02
const TEAR_NEAR := 1.7
const TEAR_DMG := 4.0
const BALL_UP_DMG := 1.3
const BALL_UP_SIZE := 1.35
const BALL_UP_LIFE := 1.6
const POWER_PASSIVE := 1.1
const GUARD_MULT := 0.7        # สกิลติดตัว 40.1 รับดาเมจน้อยลงตอนบัพ 20.2
const BUFF_TIME := 20.0
const BUFF_SPEED := 1.3
const BUFF_ATTACK := 1.3
const RETURN_RATE := 9.0

# ขนาดการวาด หน่วยเป็นจุดภาพ
const BODY_RADIUS := 50.0
const BODY_HEIGHT := 150.0
const BODY_GAP := 26.0
const BOB := 4.0
const BOB_SPEED := 2.6
const FOOT_X := 26.0
const FOOT_RX := 22.0
const FOOT_RY := 11.0
const STEP_SPEED := 11.0
const STEP_LIFT := 14.0
const HAND := Vector2(62.0, -96.0)
const HAND_RADIUS := 14.0
const STICK_W := 11.0            # stickman ความหนาเส้นแขนขา
const STICK_HEAD_R := 28.0
const STICK_HEAD := -62.0        # เทียบกลางลำตัว
const STICK_NECK := -34.0
const STICK_SHOULDER := -22.0
const STICK_HIP := 52.0
const STICK_LEG := 31.5
const STICK_ARM := 44.0
const STICK_HAND := 9.0
const STICK_STANCE := 15.0
const STICK_WALK := 30.0
const STICK_RUN := 46.0
const STICK_AIR_LEG := 48.0
const CHIBI_HEAD := Vector2(0.0, -144.0)
const CHIBI_HEAD_R := 42.0
const CHIBI_BODY_TOP := -90.0
const CHIBI_BODY_LOW := -38.0
const CHIBI_BODY_TOP_X := 13.0
const CHIBI_BODY_LOW_X := 23.0
const CHIBI_BODY_ROUND := 10.0
const CHIBI_CENTER_Y := -68.0
const CHIBI_HAND := Vector2(40.0, -60.0)
const CHIBI_HAND_R := 13.0
const CHIBI_REACH := 90.0        # มือลอยห่างกลางตัวได้ไม่เกินนี้
const CHIBI_FOOT_X := 17.0
const CHIBI_FOOT_R := 14.0
const CHIBI_WALK := 16.0
const CHIBI_RUN := 26.0
const CHIBI_STEP_LIFT := 12.0
const CHIBI_ATTACK_SPREAD := 10.0
const CHIBI_AIR_LIFT := 8.0
const CHIBI_LEAN := 0.45
const CHIBI_BLADE := 104.0
const CHIBI_BLADE_W := 18.0
const CHIBI_GUARD := 18.0
const CHIBI_GUARD_W := 10.0
const CHIBI_GRIP_W := 7.0
const CHIBI_BIG_BLADE := 400.0
const CHIBI_BIG_BLADE_W := 56.0
const CHIBI_BIG_GUARD := 58.0
const CHIBI_BIG_GUARD_W := 18.0
const CHIBI_BIG_LINE := 4.0
const CHIBI_RIM := 8.0
const CHIBI_RIM_COLOR := Color(0.97, 0.96, 0.92)
const CHIBI_BIG_SCRIBBLE := 3.0
const CHIBI_SWING_FROM := -140.0
const CHIBI_SWING_TO := -15.0
const CHIBI_SWING_LOW := Vector2(58.0, -36.0)
const CHIBI_SWING_HIGH := Vector2(72.0, -104.0)
const CHIBI_SWING_UP := 0.6      # ช่วงปัดขึ้น สัดส่วนของท่า
const CHIBI_SWING_BACK := 0.7    # เริ่มกลับท่ายืน
const CHIBI_STAB_ANGLE := 180.0  # ปลายดาบชี้ลง
const CHIBI_STAB_HIGH := Vector2(60.0, -176.0)
const CHIBI_STAB_LOW := Vector2(70.0, -112.0)
const CHIBI_STAB_DOWN := 0.25    # ถึงพื้นเมื่อท่าเดินถึงสัดส่วนนี้
const CHIBI_STAB_BACK := 0.82
const CHIBI_POUND_FROM := 30.0
const CHIBI_POUND_TO := -170.0
const CHIBI_POUND_HIGH := Vector2(40.0, -160.0)
const CHIBI_POUND_LOW := Vector2(84.0, -110.0)
const CHIBI_POUND_DOWN := 0.3    # ถึงพื้นเมื่อท่าเดินถึงสัดส่วนนี้
const CHIBI_POUND_BACK := 0.82
const CHIBI_SLASH_COUNT := 5
# แต่ละที: มุมดาบเริ่ม มุมดาบจบ ตำแหน่งมือเริ่ม ตำแหน่งมือจบ ขนาดรอยฟัน
const CHIBI_SLASHES := [
	[-15.0, -145.0, Vector2(70.0, -104.0), Vector2(80.0, -84.0), 1.0],    # ฟันลงจากบน
	[-150.0, -40.0, Vector2(80.0, -84.0), Vector2(74.0, -100.0), 1.0],    # เสยขึ้น
	[40.0, -70.0, Vector2(50.0, -112.0), Vector2(78.0, -112.0), 1.0],     # ข้ามหัวจากหลังมาหน้า
	[-80.0, -170.0, Vector2(84.0, -112.0), Vector2(78.0, -112.0), 1.0],   # กดต่ำจากหน้าลงล่าง
	[20.0, -160.0, Vector2(56.0, -118.0), Vector2(84.0, -96.0), 1.35],    # ฟันใหญ่ปิดท้าย
]
const CHIBI_SLASH_BACK := 0.94
const CHIBI_HANG_SPEED := 2.2     # ช้ากว่านี้ถือว่าอยู่ช่วงลอยค้าง
const CHIBI_HANG_GRAVITY := 0.45
const CHIBI_FALL_GRAVITY := 1.2
const CHIBI_Z_RECOVER := 0.4     # เวลากลับท่ายืน กดต่อคอมโบได้ในช่วงนี้ (กว้างขึ้นให้กดต่อทัน)
const CHIBI_DIVE_SPEED := 20.0   # ท่าพุ่งลงจากกลางอากาศ
# คอมโบของ BASIC ทุกท่านอกจาก Z ชุดแรก ค่าเหมือนตาราง CHIBI_Z hit คือผลที่มอนโดน
# hover ค้างกลางอากาศระหว่างท่า ghost วิ่งทะลุมอน dive พุ่งลงจนถึงพื้นแล้วค่อยฟาด
const CHIBI_MOVES := {
	"x1": {"name": "ฟันหนักเฉียงลง", "wind_hand": Vector3(-0.3, 0.4, 0.15), "wind_aim": Vector2(150.0, 10.0), "end_hand": Vector3(0.6, -0.4, -0.05), "end_aim": Vector2(-60.0, -15.0), "wind_off": Vector3(0.4, 0.1, -0.2), "end_off": Vector3(-0.45, -0.25, -0.2), "ease": 3.0, "time": 0.5, "wind": 0.45, "strike": 0.6, "next": 0.7, "dmg": 16.0, "lunge": 0.35, "shake": 0.15, "stop": 0.08, "lean": 24.0, "twist": 30.0, "hit": {"kb": 1.2, "stun": 0.5}},
	"x2": {"name": "ฟันหนักเสยขึ้น", "wind_hand": Vector3(0.25, -0.45, 0.3), "wind_aim": Vector2(-125.0, 30.0), "end_hand": Vector3(0.4, 0.45, -0.1), "end_aim": Vector2(70.0, -10.0), "wind_off": Vector3(0.4, -0.2, -0.2), "end_off": Vector3(-0.4, 0.15, 0.2), "ease": 3.0, "time": 0.48, "wind": 0.42, "strike": 0.58, "next": 0.68, "dmg": 16.0, "lunge": 0.3, "shake": 0.15, "stop": 0.08, "lean": 10.0, "twist": 30.0, "hit": {"kb": 1.2, "stun": 0.5}},
	"x3": {"name": "ฟาดกระเด็น", "wind_hand": Vector3(-0.35, 0.15, 0.35), "wind_aim": Vector2(10.0, 160.0), "end_hand": Vector3(0.62, -0.05, -0.25), "end_aim": Vector2(-15.0, -45.0), "tilt": -22.0, "wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.62, "wind": 0.45, "strike": 0.62, "next": 0.9, "dmg": 26.0, "lunge": 0.55, "shake": 0.3, "stop": 0.12, "lean": 20.0, "twist": 40.0, "hit": {"type": "knockdown", "fly": 9.0}},
	"zx": {"name": "ทุบกระเด็น", "wind_hand": Vector3(-0.1, 0.5, 0.1), "wind_aim": Vector2(120.0, 0.0), "end_hand": Vector3(0.62, -0.35, 0.0), "end_aim": Vector2(-50.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.55, "wind": 0.42, "strike": 0.58, "next": 0.9, "dmg": 24.0, "lunge": 0.5, "shake": 0.3, "stop": 0.12, "lean": 30.0, "twist": 15.0, "hit": {"type": "knockdown", "fly": 9.0}},
	"xxz": {"name": "เสยลอย", "wind_hand": Vector3(0.35, -0.5, 0.2), "wind_aim": Vector2(-150.0, 10.0), "end_hand": Vector3(0.3, 0.55, 0.0), "end_aim": Vector2(85.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.5, "wind": 0.38, "strike": 0.55, "next": 0.8, "dmg": 12.0, "lunge": 0.45, "shake": 0.14, "stop": 0.07, "lean": -8.0, "twist": 15.0, "hit": {"type": "launch", "vy": 11.0}},
	"az": {"name": "ฟันลงกลางอากาศ", "wind_hand": Vector3(0.1, 0.45, 0.2), "wind_aim": Vector2(115.0, 0.0), "end_hand": Vector3(0.45, -0.45, 0.0), "end_aim": Vector2(-80.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.15), "end_off": Vector3(-0.4, 0.25, -0.1), "ease": 3.0, "time": 0.36, "wind": 0.3, "strike": 0.5, "next": 0.6, "dmg": 10.0, "lunge": 0.15, "shake": 0.08, "stop": 0.05, "lean": 25.0, "twist": 10.0, "hover": true, "hit": {"kb": 1.5, "air_lift": 2.0}},
	"ax": {"name": "ฟันหนักกลางอากาศ มอนล้ม", "wind_hand": Vector3(-0.25, 0.5, 0.15), "wind_aim": Vector2(145.0, 10.0), "end_hand": Vector3(0.5, -0.5, 0.0), "end_aim": Vector2(-75.0, -10.0), "wind_off": Vector3(0.35, 0.15, -0.2), "end_off": Vector3(-0.45, 0.2, -0.1), "ease": 3.0, "time": 0.52, "wind": 0.42, "strike": 0.58, "next": 0.8, "dmg": 18.0, "lunge": 0.2, "shake": 0.2, "stop": 0.1, "lean": 30.0, "twist": 15.0, "hover": true, "hit": {"type": "knockdown", "fly": 2.5}},
	"dz1": {"name": "พุ่งฟัน", "wind_hand": Vector3(-0.2, 0.05, 0.3), "wind_aim": Vector2(15.0, 145.0), "end_hand": Vector3(0.55, -0.1, -0.25), "end_aim": Vector2(-5.0, -50.0), "tilt": -20.0, "wind_off": Vector3(0.4, -0.1, -0.25), "end_off": Vector3(-0.5, 0.0, 0.2), "ease": 3.0, "time": 0.32, "wind": 0.2, "strike": 0.55, "next": 0.6, "dmg": 10.0, "lunge": 0.7, "shake": 0.1, "stop": 0.04, "lean": 30.0, "twist": 30.0},
	"dz2": {"name": "พุ่งฟันกลับ", "wind_hand": Vector3(0.5, 0.0, -0.25), "wind_aim": Vector2(0.0, -60.0), "end_hand": Vector3(-0.05, 0.1, 0.35), "end_aim": Vector2(10.0, 135.0), "tilt": -20.0, "wind_off": Vector3(-0.4, 0.0, 0.2), "end_off": Vector3(0.4, -0.1, -0.25), "ease": 3.0, "time": 0.34, "wind": 0.2, "strike": 0.55, "next": 0.62, "dmg": 10.0, "lunge": 0.6, "shake": 0.12, "stop": 0.05, "lean": 25.0, "twist": 30.0},
	"dz3": {"name": "พุ่งฟันทะลุ", "wind_hand": Vector3(-0.25, 0.1, 0.3), "wind_aim": Vector2(20.0, 150.0), "end_hand": Vector3(0.6, -0.1, -0.25), "end_aim": Vector2(-8.0, -55.0), "tilt": -20.0, "wind_off": Vector3(0.4, -0.1, -0.25), "end_off": Vector3(-0.5, 0.0, 0.2), "ease": 3.0, "time": 0.4, "wind": 0.22, "strike": 0.6, "next": 0.8, "dmg": 16.0, "lunge": 2.2, "ghost": true, "shake": 0.16, "stop": 0.06, "lean": 32.0, "twist": 35.0, "hit": {"kb": 2.0}},
	"dx": {"name": "พุ่งงัดขึ้น", "wind_hand": Vector3(0.35, -0.5, 0.2), "wind_aim": Vector2(-150.0, 10.0), "end_hand": Vector3(0.3, 0.55, 0.0), "end_aim": Vector2(85.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.46, "wind": 0.3, "strike": 0.55, "next": 0.8, "dmg": 14.0, "lunge": 0.9, "shake": 0.16, "stop": 0.08, "lean": -10.0, "twist": 15.0, "hit": {"type": "launch", "vy": 11.0}},
	"adx1": {"name": "ฟันหนักกลางอากาศหลังแดช", "wind_hand": Vector3(-0.25, 0.5, 0.15), "wind_aim": Vector2(145.0, 10.0), "end_hand": Vector3(0.5, -0.4, 0.0), "end_aim": Vector2(-60.0, -10.0), "wind_off": Vector3(0.35, 0.15, -0.2), "end_off": Vector3(-0.45, 0.2, -0.1), "ease": 3.0, "time": 0.46, "wind": 0.38, "strike": 0.55, "next": 0.65, "dmg": 16.0, "lunge": 0.3, "shake": 0.16, "stop": 0.08, "lean": 25.0, "twist": 15.0, "hover": true, "hit": {"kb": 2.0, "air_lift": 2.5}},
	"adx2": {"name": "พุ่งลงฟาด", "wind_hand": Vector3(0.0, 0.5, 0.1), "wind_aim": Vector2(125.0, 0.0), "end_hand": Vector3(0.5, -0.3, 0.0), "end_aim": Vector2(-70.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.45, 0.25, -0.1), "ease": 3.0, "time": 0.5, "wind": 0.3, "strike": 0.6, "next": 0.9, "dmg": 20.0, "lunge": 0.3, "dive": true, "shake": 0.3, "stop": 0.1, "lean": 35.0, "twist": 0.0, "hit": {"kb": 1.5, "stun": 0.6}},
}
# ท่าถัดไป กดปุ่มไหนระหว่างท่านี้แล้วต่อท่าไหน
const CHIBI_NEXT := {
	"z1": {"z": "z2"}, "z2": {"z": "z3"}, "z3": {"z": "z4", "x": "zx"},
	"x1": {"x": "x2"}, "x2": {"x": "x3", "z": "xxz"},
	"dz1": {"z": "dz2"}, "dz2": {"z": "dz3"},
	"adz1": {"z": "adz2"}, "adz2": {"z": "adz3"},
	"adx1": {"x": "adx2"},
}

# ท่าของ SWORD KNIGHT ต่อจากคอมโบ BASIC sa คือเกราะไม่ชะงัก ขอบตัวแดง
# hold กดปุ่มค้างไว้เพื่อหน่วงก่อนพุ่ง spin_rate หมุนตัวตลอดท่า multi ทำดาเมจซ้ำทุกช่วงเวลานี้จนถึงพื้น
const SK_MOVES := {
	"skx4": {"name": "ฟันซ้ำ", "wind_hand": Vector3(0.55, 0.3, -0.2), "wind_aim": Vector2(60.0, -40.0), "end_hand": Vector3(-0.1, -0.3, 0.35), "end_aim": Vector2(-40.0, 140.0), "tilt": -15.0, "wind_off": Vector3(-0.4, 0.0, 0.2), "end_off": Vector3(0.4, -0.1, -0.25), "ease": 3.0, "time": 0.44, "wind": 0.38, "strike": 0.56, "next": 0.66, "dmg": 16.0, "lunge": 0.3, "shake": 0.15, "stop": 0.08, "lean": 18.0, "twist": 35.0, "sa": true, "hit": {"kb": 1.2, "stun": 0.6}},
	"skx5": {"name": "แทงพุ่ง", "wind_hand": Vector3(-0.45, -0.02, 0.12), "wind_aim": Vector2(6.0, 0.0), "end_hand": Vector3(0.75, -0.08, 0.0), "end_aim": Vector2(-3.0, 0.0), "ribbon": true, "wind_off": Vector3(0.46, -0.06, -0.1), "end_off": Vector3(-0.58, -0.22, -0.1), "ease": 3.0, "time": 0.52, "wind": 0.42, "strike": 0.58, "next": 0.9, "dmg": 24.0, "lunge": 1.1, "shake": 0.25, "stop": 0.1, "lean": 30.0, "twist": 10.0, "sa": true, "hit": {"kb": 2.5, "stun": 0.7}},
	"sk_charge": {"name": "เอาดาบดันพุ่ง", "wind_hand": Vector3(0.25, 0.05, 0.15), "wind_aim": Vector2(78.0, 0.0), "end_hand": Vector3(0.55, 0.0, 0.05), "end_aim": Vector2(72.0, 0.0), "wind_off": Vector3(0.4, 0.05, -0.15), "end_off": Vector3(0.45, 0.0, -0.2), "ease": 2.0, "time": 0.5, "wind": 0.3, "strike": 0.7, "next": 0.75, "dmg": 14.0, "lunge": 2.0, "hold": 1.0, "shake": 0.14, "stop": 0.06, "lean": 30.0, "twist": 0.0, "sa": true, "aura": true, "hit": {"kb": 1.0, "stun": 0.6}},
	"sk_smash": {"name": "ทุบงัดลอย", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(125.0, 0.0), "end_hand": Vector3(0.62, -0.35, 0.0), "end_aim": Vector2(-50.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.56, "wind": 0.42, "strike": 0.58, "next": 0.9, "dmg": 26.0, "lunge": 0.4, "shake": 0.3, "stop": 0.12, "lean": 30.0, "twist": 15.0, "sa": true, "hit": {"type": "launch", "vy": 12.0}},
	"sk_spin_dive": {"name": "หมุนตัวตีลังกาพุ่งลง", "wind_hand": Vector3(0.5, 0.05, 0.1), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.6, 0.0, 0.1), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(-0.3, -0.1, -0.2), "end_off": Vector3(-0.35, -0.1, -0.2), "ease": 1.0, "time": 0.6, "wind": 0.2, "strike": 0.7, "next": 0.9, "dmg": 8.0, "lunge": 0.0, "dive": true, "dive_forward": 6.0, "roll_rate": 1000.0, "aura": true, "no_trail": true, "multi": 0.12, "shake": 0.12, "stop": 0.0, "lean": 0.0, "twist": 0.0, "hit": {"kb": 0.6, "stun": 0.35}},
}
# ท่าของ MAGIC KNIGHT fx คือเวทที่ปล่อยตอนดาบถึงจุดฟาด no_hit ท่านี้ตัวดาบไม่ทำดาเมจ ดาเมจมาจากเวท
# flame ดาบลุกไฟและรอยฟาดเป็นไฟ hold_button ปุ่มที่กดค้างเพื่อชาร์จ
const MK_MOVES := {
	"mk_summon": {"name": "เรียกลูกไฟ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.62, 0.12, 0.1), "ease": 2.0, "time": 0.42, "wind": 0.35, "strike": 0.5, "next": 0.55, "dmg": 0.0, "lunge": 0.1, "shake": 0.0, "stop": 0.0, "lean": 8.0, "twist": -10.0, "fx": "summon", "no_hit": true, "no_trail": true, "hold": 1.0, "hold_button": "z", "hand_cast": true},
	"mk_burst": {"name": "ระเบิดลูกไฟ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.55, 0.05, 0.1), "end_off": Vector3(0.6, 0.45, 0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.52, "next": 0.85, "dmg": 0.0, "lunge": 0.1, "shake": 0.25, "stop": 0.0, "lean": -6.0, "twist": -10.0, "fx": "burst", "no_hit": true, "no_trail": true, "hand_cast": true},
	"mk_dz3": {"name": "พุ่งฟันไฟทะลุ", "wind_hand": Vector3(-0.25, 0.1, 0.3), "wind_aim": Vector2(20.0, 150.0), "end_hand": Vector3(0.6, -0.1, -0.25), "end_aim": Vector2(-8.0, -55.0), "tilt": -20.0, "wind_off": Vector3(0.4, -0.1, -0.25), "end_off": Vector3(-0.5, 0.0, 0.2), "ease": 3.0, "time": 0.4, "wind": 0.22, "strike": 0.6, "next": 0.8, "dmg": 18.0, "lunge": 2.2, "ghost": true, "flame": true, "shake": 0.16, "stop": 0.06, "lean": 32.0, "twist": 35.0, "hit": {"kb": 2.0}},
	"mk_spin_through": {"name": "พุ่งทะลุ", "wind_hand": Vector3(-0.4, -0.3, 0.05), "wind_aim": Vector2(-10.0, 170.0), "end_hand": Vector3(-0.45, -0.32, 0.05), "end_aim": Vector2(-12.0, 172.0), "wind_off": Vector3(0.35, -0.1, -0.2), "end_off": Vector3(0.4, -0.1, -0.2), "ease": 1.0, "time": 0.36, "wind": 0.12, "strike": 0.7, "next": 0.78, "dmg": 8.0, "lunge": 2.8, "ghost": true, "no_trail": true, "auto": "mk_turn_shot", "shake": 0.06, "stop": 0.0, "lean": 35.0, "twist": 0.0, "hit": {"kb": 0.6, "stun": 0.4}},
	"mk_turn_shot": {"name": "หันกลับยิงลูกไฟ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.1, 0.0, 0.25), "end_off": Vector3(0.7, 0.0, 0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "turn_around": true, "shake": 0.15, "stop": 0.0, "lean": 12.0, "twist": -20.0, "fx": "shot", "no_hit": true, "no_trail": true, "hand_cast": true},
	"mk_fslash1": {"name": "ฟันไฟโค้งกลางอากาศ", "wind_hand": Vector3(-0.3, 0.45, 0.15), "wind_aim": Vector2(165.0, 15.0), "end_hand": Vector3(0.55, -0.4, 0.0), "end_aim": Vector2(-70.0, -10.0), "wind_off": Vector3(0.35, 0.15, -0.2), "end_off": Vector3(-0.45, 0.2, -0.1), "ease": 3.0, "time": 0.42, "wind": 0.34, "strike": 0.52, "next": 0.6, "dmg": 14.0, "lunge": 0.2, "shake": 0.14, "stop": 0.06, "lean": 25.0, "twist": 15.0, "hover": true, "flame": true, "hit": {"kb": 1.2, "air_lift": 2.5}},
	"mk_fslash2": {"name": "ฟันไฟโค้งกลับ", "wind_hand": Vector3(0.5, -0.45, 0.1), "wind_aim": Vector2(-110.0, -15.0), "end_hand": Vector3(-0.2, 0.5, 0.2), "end_aim": Vector2(160.0, 20.0), "wind_off": Vector3(-0.4, 0.2, -0.1), "end_off": Vector3(0.35, 0.15, -0.2), "ease": 3.0, "time": 0.46, "wind": 0.34, "strike": 0.55, "next": 0.85, "dmg": 16.0, "lunge": 0.2, "shake": 0.18, "stop": 0.08, "lean": 15.0, "twist": 15.0, "hover": true, "flame": true, "hit": {"kb": 1.5, "air_lift": 3.0}},
	"mk_shot45": {"name": "ยิงลูกไฟเฉียงลง", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.0, 0.2, 0.25), "end_off": Vector3(0.55, -0.5, 0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.55, "next": 0.85, "dmg": 0.0, "lunge": 0.1, "shake": 0.12, "stop": 0.0, "lean": 25.0, "twist": -10.0, "hover": true, "fx": "shot45", "no_hit": true, "no_trail": true, "hand_cast": true},
}
const MK_NEXT := {"x1": {"z": "mk_summon"}, "mk_summon": {"z": "mk_burst"}, "dz2": {"z": "mk_dz3", "x": "mk_spin_through"}, "adz1": {"x": "mk_fslash1"}, "mk_fslash1": {"x": "mk_fslash2"}, "adx1": {"z": "mk_shot45"}}

# ท่าของ SHIELD KNIGHT shield_hand ถอดโล่จากหลังมาถือมือซ้าย front_hit โดนช่วงหน้าตัว wide โดนรอบตัว
const SH_MOVES := {
	"sh_bash": {"name": "กระแทกโล่", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(-0.15, 0.0, 0.25), "end_off": Vector3(0.62, -0.05, 0.15), "ease": 3.0, "time": 0.5, "wind": 0.38, "strike": 0.56, "next": 0.85, "dmg": 18.0, "lunge": 0.8, "shake": 0.25, "stop": 0.1, "lean": 22.0, "twist": -20.0, "sa": true, "shield_hand": true, "front_hit": true, "no_trail": true, "hit": {"type": "knockdown", "fly": 7.0}},
	"sh_guard": {"name": "ตั้งโล่สวนฟัน", "wind_hand": Vector3(0.1, 0.4, 0.2), "wind_aim": Vector2(130.0, 10.0), "end_hand": Vector3(0.6, -0.35, 0.0), "end_aim": Vector2(-60.0, 0.0), "wind_off": Vector3(0.55, 0.15, 0.15), "end_off": Vector3(0.5, 0.0, 0.15), "ease": 3.0, "time": 0.72, "wind": 0.58, "strike": 0.7, "next": 0.9, "dmg": 22.0, "lunge": 0.35, "shake": 0.2, "stop": 0.1, "lean": 18.0, "twist": 20.0, "sa": true, "shield_hand": true, "hit": {"kb": 2.0, "stun": 0.6}},
	"sh_charge": {"name": "ดันโล่พุ่ง", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.45, 0.0, 0.15), "end_off": Vector3(0.6, 0.0, 0.15), "ease": 1.0, "time": 0.6, "wind": 0.2, "strike": 0.8, "next": 0.9, "dmg": 6.0, "lunge": 2.4, "multi": 0.1, "multi_ahead": 80.0, "multi_half": 90.0, "shake": 0.1, "stop": 0.0, "lean": 30.0, "twist": -15.0, "sa": true, "shield_hand": true, "front_hit": true, "no_trail": true, "hit": {"kb": 2.5, "stun": 0.4}},
	"sh_slam": {"name": "โล่ทุบพื้น", "wind_hand": Vector3(-0.35, -0.1, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.2, 0.05), "end_aim": Vector2(-20.0, 172.0), "wind_off": Vector3(0.3, 0.35, 0.2), "end_off": Vector3(0.55, -1.15, 0.2), "ease": 3.0, "time": 0.55, "wind": 0.35, "strike": 0.62, "next": 0.9, "dmg": 18.0, "lunge": 0.2, "leap": 5.0, "dive": true, "shake": 0.3, "stop": 0.1, "lean": 30.0, "twist": 0.0, "shield_hand": true, "wide": true, "no_trail": true, "fx": "smoke", "hit": {"kb": 1.5, "stun": 0.6}},
}
const SH_NEXT := {"z2": {"x": "sh_bash"}, "x2": {"z": "sh_guard"}, "dz1": {"x": "sh_charge"}, "az": {"x": "sh_slam"}}

# ท่าของ DARK KNIGHT blood รอยฟาดเป็นสีเลือด
const DK_MOVES := {
	"dk_blood": {"name": "ยิงลูกเลือดกวาดหน้ามือ", "wind_hand": Vector3(-0.3, -0.05, 0.4), "wind_aim": Vector2(0.0, 150.0), "end_hand": Vector3(0.6, -0.1, -0.3), "end_aim": Vector2(0.0, -50.0), "wind_off": Vector3(0.3, -0.1, -0.2), "end_off": Vector3(-0.45, -0.15, 0.2), "ease": 2.0, "time": 0.28, "wind": 0.3, "strike": 0.5, "next": 0.55, "dmg": 0.0, "lunge": 0.5, "shake": 0.06, "stop": 0.0, "lean": 38.0, "twist": 10.0, "fx": "blood_shot", "no_hit": true, "blood": true},
	"dk_blood_b": {"name": "ยิงลูกเลือดกวาดหลังมือ", "wind_hand": Vector3(0.6, -0.1, -0.3), "wind_aim": Vector2(0.0, -50.0), "end_hand": Vector3(-0.3, -0.05, 0.4), "end_aim": Vector2(0.0, 150.0), "wind_off": Vector3(-0.45, -0.15, 0.2), "end_off": Vector3(0.3, -0.1, -0.2), "ease": 2.0, "time": 0.28, "wind": 0.3, "strike": 0.5, "next": 0.55, "dmg": 0.0, "lunge": 0.5, "shake": 0.06, "stop": 0.0, "lean": 38.0, "twist": -10.0, "fx": "blood_shot", "no_hit": true, "blood": true},
	"dk_blood45": {"name": "ยิงลูกเลือดเฉียงลง", "wind_hand": Vector3(-0.3, 0.15, 0.1), "wind_aim": Vector2(20.0, 0.0), "end_hand": Vector3(0.6, -0.3, 0.0), "end_aim": Vector2(-45.0, 0.0), "ribbon": true, "wind_off": Vector3(0.4, 0.0, -0.1), "end_off": Vector3(-0.5, 0.2, -0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.55, "next": 0.85, "dmg": 0.0, "lunge": 0.1, "shake": 0.12, "stop": 0.0, "lean": 25.0, "twist": 10.0, "hover": true, "fx": "blood45", "no_hit": true, "blood": true},
	"dk_bx1": {"name": "ฟาดเลือด", "wind_hand": Vector3(-0.35, 0.15, 0.35), "wind_aim": Vector2(10.0, 160.0), "end_hand": Vector3(0.62, -0.05, -0.25), "end_aim": Vector2(-15.0, -45.0), "tilt": -22.0, "wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.55, "wind": 0.45, "strike": 0.62, "next": 0.72, "dmg": 22.0, "lunge": 0.45, "shake": 0.2, "stop": 0.1, "lean": 20.0, "twist": 40.0, "blood": true, "hit": {"kb": 1.5, "stun": 0.5}},
	"dk_bx2": {"name": "ฟาดเลือดชะงัก", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(125.0, 0.0), "end_hand": Vector3(0.62, -0.35, 0.0), "end_aim": Vector2(-50.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.58, "wind": 0.42, "strike": 0.58, "next": 0.9, "dmg": 26.0, "lunge": 0.4, "shake": 0.28, "stop": 0.12, "lean": 30.0, "twist": 15.0, "blood": true, "hit": {"kb": 1.0, "stun": 0.9, "real_stun": true}},
}
const DK_NEXT := {"dz2": {"x": "dk_blood"}, "dk_blood": {"x": "dk_blood_b"}, "dk_blood_b": {"x": "dk_blood"}, "adz2": {"x": "dk_blood45"}, "z3": {"x": "dk_bx1"}, "dk_bx1": {"x": "dk_bx2"}}

# สกิลของ CAT BOYS ใช้ระบบเดียวกับคอมโบ leap กระโดดขึ้นตอนเริ่ม charge_glow ดาบเรืองแสงตอนรวมพลัง
const CAT_SKILLS := {
	"cat_roll": {"name": "กลิ้งม้วน", "wind_hand": Vector3(0.3, -0.1, 0.2), "wind_aim": Vector2(30.0, 0.0), "end_hand": Vector3(0.3, -0.1, 0.2), "end_aim": Vector2(30.0, 0.0), "wind_off": Vector3(0.3, -0.1, -0.1), "end_off": Vector3(0.3, -0.1, -0.1), "ease": 1.0, "time": 0.42, "wind": 0.08, "strike": 0.55, "next": 0.9, "dmg": 12.0, "lunge": 2.6, "ghost": true, "roll_once": true, "hide_sword": true, "no_hit": true, "multi": 0.03, "multi_once": true, "multi_ahead": 30.0, "multi_half": 70.0, "no_trail": true, "shake": 0.08, "stop": 0.04, "lean": 0.0, "twist": 0.0, "hit": {"kb": 1.2, "stun": 0.4}},
	"cat_leap": {"name": "กระโดดทุ่ม", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(120.0, 0.0), "end_hand": Vector3(0.55, -0.55, 0.0), "end_aim": Vector2(-80.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.7, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 24.0, "lunge": 0.0, "leap": 9.0, "dive": true, "dive_forward": 5.0, "wide": true, "fx": "crack", "fx_start": "mist", "shake": 0.35, "stop": 0.1, "lean": 30.0, "twist": 10.0, "hit": {"kb": 2.0, "stun": 0.6}},
	"cat_storm": {"name": "งัดพายุ", "wind_hand": Vector3(0.45, -0.55, 0.15), "wind_aim": Vector2(-150.0, 5.0), "end_hand": Vector3(0.35, 0.5, 0.0), "end_aim": Vector2(80.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.55, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.15, "fx": "storm", "no_hit": true, "shake": 0.2, "stop": 0.0, "lean": -8.0, "twist": 15.0},
	"cat_charge": {"name": "รวมพลังพุ่งฟัน", "wind_hand": Vector3(-0.35, -0.05, 0.15), "wind_aim": Vector2(10.0, 170.0), "end_hand": Vector3(0.62, -0.05, -0.2), "end_aim": Vector2(-10.0, -40.0), "tilt": -15.0, "wind_off": Vector3(0.4, -0.05, -0.2), "end_off": Vector3(-0.5, -0.1, 0.2), "ease": 3.0, "time": 1.1, "wind": 0.6, "strike": 0.72, "next": 0.92, "dmg": 40.0, "lunge": 2.2, "charge_glow": true, "shake": 0.35, "stop": 0.14, "lean": 30.0, "twist": 35.0, "hit": {"type": "knockdown", "fly": 8.0}},
	"cat_wave": {"name": "ตบพื้นคลื่นแดง", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(120.0, 0.0), "end_hand": Vector3(0.62, -0.4, 0.0), "end_aim": Vector2(-60.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.6, "wind": 0.15, "strike": 0.62, "next": 0.9, "dmg": 0.0, "lunge": 1.5, "fx": "wave", "no_hit": true, "shake": 0.3, "stop": 0.0, "lean": 30.0, "twist": 10.0},
	"cat_rush_end": {"name": "ตบดินคลื่นแดง", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(120.0, 0.0), "end_hand": Vector3(0.62, -0.4, 0.0), "end_aim": Vector2(-60.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.6, "wind": 0.35, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.2, "fx": "pound", "no_hit": true, "shake": 0.3, "stop": 0.0, "lean": 30.0, "twist": 10.0},
	"cat_escape": {"name": "ไถลหนี", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.3, 0.1, 0.1), "end_off": Vector3(0.4, 0.2, 0.1), "ease": 1.0, "time": 0.45, "wind": 0.05, "strike": 0.75, "next": 0.9, "dmg": 0.0, "lunge": -3.6, "ghost": true, "sa": true, "no_hit": true, "no_trail": true, "shake": 0.0, "stop": 0.0, "lean": -18.0, "twist": 0.0},
	"cat_mk_blast": {"name": "ลูกไฟระเบิด", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.1, 0.0, 0.25), "end_off": Vector3(0.7, 0.0, 0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "blast", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.1, "stop": 0.0, "lean": 12.0, "twist": -20.0},
	"cat_mk_swords": {"name": "ดาบผุด", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.3, -0.3, 0.2), "end_off": Vector3(0.5, 0.45, 0.1), "ease": 3.0, "time": 0.55, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "sword_row", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.15, "stop": 0.0, "lean": -5.0, "twist": -10.0},
	"cat_mk_blade": {"name": "ดาบพุ่งทะลุจอ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.45, 0.2, 0.1), "end_off": Vector3(0.7, 0.05, 0.1), "ease": 3.0, "time": 0.55, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "light_blade", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.2, "stop": 0.0, "lean": 15.0, "twist": -20.0},
	"cat_mk_firewave": {"name": "คลื่นไฟสองข้าง", "wind_hand": Vector3(0.2, 0.45, 0.15), "wind_aim": Vector2(-80.0, 0.0), "end_hand": Vector3(0.45, -0.25, 0.1), "end_aim": Vector2(-90.0, 0.0), "wind_off": Vector3(0.3, 0.3, 0.1), "end_off": Vector3(0.35, 0.0, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "fire_wave", "flame": true, "no_hit": true, "shake": 0.3, "stop": 0.0, "lean": 20.0, "twist": 0.0},
	"cat_mk_ignite": {"name": "ถูดาบติดไฟ", "wind_hand": Vector3(0.35, -0.05, 0.25), "wind_aim": Vector2(88.0, 0.0), "end_hand": Vector3(0.35, -0.05, 0.25), "end_aim": Vector2(90.0, 0.0), "wind_off": Vector3(0.38, 0.0, 0.3), "end_off": Vector3(0.38, 0.75, 0.3), "ease": 2.0, "time": 0.9, "wind": 0.15, "strike": 0.8, "next": 0.95, "dmg": 0.0, "lunge": 0.0, "fx": "ignite", "no_hit": true, "no_trail": true, "shake": 0.0, "stop": 0.0, "lean": 0.0, "twist": 0.0},
	"cat_mk_vortex": {"name": "ลูกไฟหมุน", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.65, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "vortex", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.15, "stop": 0.0, "lean": -8.0, "twist": 0.0},
	"cat_sk_kick": {"name": "เตะ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.3, 0.1, -0.1), "end_off": Vector3(-0.4, 0.15, -0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.55, "next": 0.8, "dmg": 12.0, "lunge": 0.3, "kick": true, "front_hit": true, "no_trail": true, "shake": 0.15, "stop": 0.08, "lean": -12.0, "twist": 0.0, "hit": {"kb": 1.5, "stun": 0.9, "real_stun": true}},
	"cat_sk_sparks": {"name": "งัดประกาย", "wind_hand": Vector3(0.45, -0.55, 0.15), "wind_aim": Vector2(-150.0, 5.0), "end_hand": Vector3(0.35, 0.5, 0.0), "end_aim": Vector2(80.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.55, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.15, "fx": "sparks", "no_hit": true, "shake": 0.15, "stop": 0.0, "lean": -8.0, "twist": 15.0},
	"cat_sk_crack": {"name": "ปักดาบแตกดิน", "wind_hand": Vector3(0.2, 0.45, 0.15), "wind_aim": Vector2(-80.0, 0.0), "end_hand": Vector3(0.45, -0.25, 0.1), "end_aim": Vector2(-90.0, 0.0), "wind_off": Vector3(0.3, 0.3, 0.1), "end_off": Vector3(0.35, 0.0, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "crack_line", "no_hit": true, "shake": 0.3, "stop": 0.0, "lean": 20.0, "twist": 0.0},
	"cat_sk_leap": {"name": "กระโดดทุ่มใหญ่", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(120.0, 0.0), "end_hand": Vector3(0.55, -0.55, 0.0), "end_aim": Vector2(-80.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.7, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 30.0, "lunge": 0.0, "leap": 9.0, "dive": true, "dive_forward": 5.0, "wide": true, "wide_half": 420.0, "fx": "crack_big", "fx_start": "mist", "shake": 0.4, "stop": 0.1, "lean": 30.0, "twist": 10.0, "hit": {"kb": 2.5, "stun": 0.7}},
	"cat_sk_hilt": {"name": "ตีด้ามดาบ", "wind_hand": Vector3(-0.1, 0.05, 0.1), "wind_aim": Vector2(-10.0, 175.0), "end_hand": Vector3(0.65, 0.05, 0.05), "end_aim": Vector2(-5.0, 178.0), "wind_off": Vector3(0.2, 0.0, 0.1), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.55, "next": 0.8, "dmg": 14.0, "lunge": 0.4, "front_hit": true, "no_trail": true, "shake": 0.15, "stop": 0.08, "lean": 20.0, "twist": 10.0, "hit": {"kb": 1.2, "stun": 0.5, "armor_break": true}},
	"cat_sk_wave": {"name": "คลื่นดาบ", "wind_hand": Vector3(-0.1, 0.6, 0.1), "wind_aim": Vector2(150.0, 0.0), "end_hand": Vector3(0.6, -0.35, 0.0), "end_aim": Vector2(-70.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.2, "leap": 7.0, "fx": "sword_wave", "no_hit": true, "shake": 0.25, "stop": 0.0, "lean": 25.0, "twist": 0.0},
	"cat_sh_bash": {"name": "พุ่งโล่กระแทก", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(-0.15, 0.0, 0.25), "end_off": Vector3(0.62, -0.05, 0.15), "ease": 2.0, "time": 0.5, "wind": 0.3, "strike": 0.6, "next": 0.9, "dmg": 14.0, "lunge": 1.6, "shield_hand": true, "front_hit": true, "no_trail": true, "shake": 0.2, "stop": 0.08, "lean": 25.0, "twist": -20.0, "hit": {"kb": 2.5, "stun": 1.0, "real_stun": true}},
	"cat_sh_quake": {"name": "โล่ทุบแผ่นดิน", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.3, 0.45, 0.2), "end_off": Vector3(0.6, -1.1, 0.2), "ease": 3.0, "time": 0.55, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.15, "fx": "quake", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.35, "stop": 0.0, "lean": 28.0, "twist": 0.0},
	"cat_sh_throw": {"name": "ขว้างโล่", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(-0.5, 0.2, -0.1), "end_off": Vector3(0.7, 0.05, 0.1), "ease": 3.0, "time": 0.5, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.1, "fx": "shield_throw", "no_hit": true, "no_trail": true, "shake": 0.1, "stop": 0.0, "lean": 15.0, "twist": -30.0},
	"cat_sh_taunt": {"name": "ยั่วยุ", "wind_hand": Vector3(0.3, 0.2, 0.2), "wind_aim": Vector2(60.0, 0.0), "end_hand": Vector3(0.25, 0.1, 0.25), "end_aim": Vector2(80.0, 10.0), "wind_off": Vector3(0.45, 0.0, 0.2), "end_off": Vector3(0.45, 0.05, 0.2), "ease": 2.0, "time": 0.6, "wind": 0.3, "strike": 0.5, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "taunt", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.2, "stop": 0.0, "lean": -10.0, "twist": 0.0},
	"cat_sh_leap": {"name": "กระโดดทุบโล่", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.3, 0.45, 0.2), "end_off": Vector3(0.55, -1.15, 0.2), "ease": 3.0, "time": 0.7, "wind": 0.4, "strike": 0.62, "next": 0.9, "dmg": 26.0, "lunge": 0.0, "leap": 9.0, "dive": true, "dive_forward": 4.0, "wide": true, "wide_half": 390.0, "fx": "shield_quake", "fx_start": "mist", "hold_after": 3.0, "hold_button": "skill", "shield_hand": true, "no_trail": true, "shake": 0.4, "stop": 0.1, "lean": 30.0, "twist": 0.0, "hit": {"type": "launch", "vy": 8.0}},
	"cat_sh_dome": {"name": "ป้อมปราการ", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.4, 0.0, 0.2), "end_off": Vector3(0.35, 0.6, 0.15), "ease": 3.0, "time": 0.6, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "dome", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.2, "stop": 0.0, "lean": -8.0, "twist": 0.0},
	"cat_dk_erupt": {"name": "เลือดปะทุ", "wind_hand": Vector3(-0.1, 0.55, 0.1), "wind_aim": Vector2(120.0, 0.0), "end_hand": Vector3(0.62, -0.4, 0.0), "end_aim": Vector2(-60.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.55, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.2, "fx": "dark_erupt", "no_hit": true, "blood": true, "shake": 0.3, "stop": 0.0, "lean": 30.0, "twist": 10.0},
	"cat_dk_scythe": {"name": "คลื่นเลือด", "wind_hand": Vector3(-0.25, -0.1, 0.2), "wind_aim": Vector2(-20.0, 175.0), "end_hand": Vector3(0.55, 0.0, 0.05), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(-0.25, -0.05, 0.25), "end_off": Vector3(0.55, 0.05, 0.1), "ease": 3.0, "time": 1.4, "wind": 0.05, "strike": 0.1, "next": 0.95, "dmg": 0.0, "lunge": 0.0, "leap": 5.0, "hover": true, "hover_apex": true, "hold": 1.5, "hold_button": "skill", "charge_glow": true, "fx": "blood_beam", "no_hit": true, "no_trail": true, "shake": 0.1, "stop": 0.0, "lean": 10.0, "twist": 0.0},
	"cat_dk_orb": {"name": "ดาบเลือด", "wind_hand": Vector3(-0.2, 0.05, 0.15), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.7, 0.0, 0.0), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 3.0, "time": 0.6, "wind": 0.3, "strike": 0.75, "next": 0.9, "dmg": 6.0, "lunge": 0.5, "multi": 0.08, "multi_ahead": 120.0, "multi_half": 90.0, "front_hit": true, "fx_start": "blood_sword", "blood": true, "shake": 0.1, "stop": 0.05, "lean": 20.0, "twist": 0.0, "hit": {"kb": 0.3, "stun": 0.4}},
	"cat_dk_curse": {"name": "บ่อเลือด", "wind_hand": Vector3(-0.35, 0.3, 0.3), "wind_aim": Vector2(60.0, 160.0), "end_hand": Vector3(0.6, -0.45, -0.2), "end_aim": Vector2(-20.0, -40.0), "wind_off": Vector3(0.4, 0.0, -0.2), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.65, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "leap": 7.0, "dive": true, "fx": "blood_pool", "no_hit": true, "blood": true, "shake": 0.35, "stop": 0.0, "lean": 28.0, "twist": 35.0},
	"cat_dk_frenzy": {"name": "พุ่งลากเลือด", "wind_hand": Vector3(0.3, -0.1, 0.1), "wind_aim": Vector2(-10.0, 0.0), "end_hand": Vector3(0.55, -0.05, 0.05), "end_aim": Vector2(-5.0, 0.0), "wind_off": Vector3(-0.3, 0.0, 0.0), "end_off": Vector3(-0.45, -0.1, -0.1), "ease": 1.0, "time": 0.75, "wind": 0.15, "strike": 0.85, "next": 0.95, "dmg": 20.0, "lunge": 8.7, "sa": true, "ghost": true, "drag": true, "front_hit": true, "fx_start": "blood_aura", "blood": true, "no_trail": true, "shake": 0.3, "stop": 0.1, "lean": 35.0, "twist": 0.0, "hit": {"kb": 1.0, "stun": 1.8, "real_stun": true}},
	"cat_dk_vortex": {"name": "พายุเลือดคู่", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.1, 0.5, 0.1), "end_aim": Vector2(90.0, 0.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.6, 0.1), "ease": 3.0, "time": 0.7, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "blood_storm", "no_hit": true, "no_trail": true, "blood": true, "shake": 0.2, "stop": 0.0, "lean": -8.0, "twist": 0.0},
	"cat_gk_aura": {"name": "ออร่าดาบ", "wind_hand": Vector3(-0.2, 0.05, 0.15), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.72, 0.0, 0.0), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 3.0, "time": 0.55, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 14.0, "lunge": 0.5, "front_hit": true, "fx": "aura_on", "shake": 0.15, "stop": 0.06, "lean": 22.0, "twist": 0.0, "hit": {"kb": 1.5, "stun": 0.5}},
	"cat_gk_spin": {"name": "หมุนฟาด", "wind_hand": Vector3(-0.35, 0.05, 0.35), "wind_aim": Vector2(0.0, 160.0), "end_hand": Vector3(0.62, 0.0, -0.25), "end_aim": Vector2(-5.0, -45.0), "wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 1.0, "time": 0.8, "wind": 0.15, "strike": 0.85, "next": 0.95, "dmg": 7.0, "lunge": 1.4, "spin_rate": 1000.0, "multi": 0.08, "multi_ahead": 90.0, "multi_half": 130.0, "front_hit": true, "shake": 0.08, "stop": 0.0, "lean": 15.0, "twist": 0.0, "hit": {"kb": 0.6, "stun": 0.4}},
	"cat_gk_ram": {"name": "ไถลชน", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.45, 0.0, 0.15), "end_off": Vector3(0.6, 0.0, 0.15), "ease": 1.0, "time": 0.6, "wind": 0.15, "strike": 0.8, "next": 0.9, "dmg": 9.0, "lunge": 4.5, "sa": true, "ghost": true, "drag": true, "multi": 0.1, "multi_ahead": 80.0, "multi_half": 90.0, "front_hit": true, "no_trail": true, "shake": 0.2, "stop": 0.05, "lean": 40.0, "twist": -15.0, "hit": {"kb": 3.0, "stun": 0.6}},
	"cat_gk_storm": {"name": "พายุแดงยักษ์", "wind_hand": Vector3(0.45, -0.55, 0.15), "wind_aim": Vector2(-150.0, 5.0), "end_hand": Vector3(0.35, 0.5, 0.0), "end_aim": Vector2(80.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.15, "fx": "red_storm", "no_hit": true, "shake": 0.3, "stop": 0.0, "lean": -8.0, "twist": 15.0},
	"cat_gk_guard": {"name": "ตั้งการ์ด", "wind_hand": Vector3(0.35, 0.1, 0.2), "wind_aim": Vector2(85.0, 0.0), "end_hand": Vector3(0.35, 0.12, 0.2), "end_aim": Vector2(88.0, 0.0), "wind_off": Vector3(0.38, 0.0, 0.25), "end_off": Vector3(0.38, 0.05, 0.25), "ease": 2.0, "time": 1.6, "wind": 0.08, "strike": 0.97, "next": 1.0, "dmg": 0.0, "lunge": 0.0, "sa": true, "guard": true, "no_hit": true, "no_trail": true, "shake": 0.0, "stop": 0.0, "lean": -5.0, "twist": 0.0},
	"cat_gk_counter": {"name": "งัดสวน", "wind_hand": Vector3(0.45, -0.55, 0.15), "wind_aim": Vector2(-150.0, 5.0), "end_hand": Vector3(0.35, 0.55, 0.0), "end_aim": Vector2(85.0, 0.0), "wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.45, "wind": 0.2, "strike": 0.45, "next": 0.85, "dmg": 30.0, "lunge": 0.3, "sa": true, "front_hit": true, "shake": 0.3, "stop": 0.1, "lean": -10.0, "twist": 15.0, "hit": {"type": "launch", "vy": 11.0}},
	"cat_gk_cleave": {"name": "ออร่าฟาดจอ", "wind_hand": Vector3(-0.35, 0.6, 0.1), "wind_aim": Vector2(160.0, 0.0), "end_hand": Vector3(0.62, -0.4, 0.0), "end_aim": Vector2(-60.0, 0.0), "wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.85, "wind": 0.6, "strike": 0.7, "next": 0.95, "dmg": 0.0, "lunge": 0.2, "fx": "aura_slash", "no_hit": true, "shake": 0.45, "stop": 0.0, "lean": 30.0, "twist": 10.0},
	"cat_gk_ring": {"name": "วงคลื่นดาบ", "wind_hand": Vector3(-0.35, 0.05, 0.35), "wind_aim": Vector2(0.0, 160.0), "end_hand": Vector3(0.62, 0.0, -0.25), "end_aim": Vector2(-5.0, -45.0), "wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.6, "wind": 0.35, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "spin": 360.0, "fx": "red_ring", "no_hit": true, "shake": 0.35, "stop": 0.0, "lean": 10.0, "twist": 0.0},
	"cat_fk_phoenix": {"name": "ฟีนิกซ์เพลิง", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.65, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "phoenix", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.2, "stop": 0.0, "lean": -10.0, "twist": 0.0},
	"cat_fk_orb": {"name": "ลูกไฟค้าง", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.1, 0.0, 0.25), "end_off": Vector3(0.7, 0.05, 0.1), "ease": 3.0, "time": 0.5, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "fire_orb", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.1, "stop": 0.0, "lean": 10.0, "twist": -20.0},
	"cat_fk_stab": {"name": "พุ่งแทงไฟ", "wind_hand": Vector3(-0.2, 0.05, 0.15), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.72, 0.0, 0.0), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 1.0, "time": 0.55, "wind": 0.2, "strike": 0.8, "next": 0.9, "dmg": 14.0, "lunge": 3.5, "ghost": true, "flame": true, "multi": 0.08, "multi_once": true, "multi_ahead": 80.0, "multi_half": 90.0, "front_hit": true, "shake": 0.15, "stop": 0.05, "lean": 30.0, "twist": 0.0, "hit": {"kb": 1.5, "stun": 0.5, "burn": "fire", "magic": true}},
	"cat_fk_wheel": {"name": "วงล้อไฟ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.1, 0.0, 0.25), "end_off": Vector3(0.7, 0.05, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "fire_wheel", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.2, "stop": 0.0, "lean": 12.0, "twist": -20.0},
	"cat_fk_sky": {"name": "ดาบเวทฟ้า", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.65, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "sky_blade", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.3, "stop": 0.0, "lean": -8.0, "twist": 0.0},
	"cat_fk_guard": {"name": "การ์ดสะท้อน", "wind_hand": Vector3(0.35, 0.1, 0.2), "wind_aim": Vector2(85.0, 0.0), "end_hand": Vector3(0.35, 0.12, 0.2), "end_aim": Vector2(88.0, 0.0), "wind_off": Vector3(0.38, 0.0, 0.25), "end_off": Vector3(0.38, 0.05, 0.25), "ease": 2.0, "time": 1.6, "wind": 0.08, "strike": 0.97, "next": 1.0, "dmg": 0.0, "lunge": 0.0, "sa": true, "guard": true, "guard_ranged": true, "counter": "cat_fk_reflect", "no_hit": true, "no_trail": true, "shake": 0.0, "stop": 0.0, "lean": -5.0, "twist": 0.0},
	"cat_fk_reflect": {"name": "สะท้อน", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.1, 0.0, 0.25), "end_off": Vector3(0.7, 0.05, 0.1), "ease": 3.0, "time": 0.4, "wind": 0.2, "strike": 0.4, "next": 0.85, "dmg": 0.0, "lunge": 0.0, "fx": "shot", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.15, "stop": 0.0, "lean": 10.0, "twist": -20.0},
	"cat_fk_circle": {"name": "วงเวทมานา", "wind_hand": Vector3(0.2, 0.45, 0.15), "wind_aim": Vector2(-80.0, 0.0), "end_hand": Vector3(0.45, -0.25, 0.1), "end_aim": Vector2(-90.0, 0.0), "wind_off": Vector3(0.3, 0.3, 0.1), "end_off": Vector3(0.35, 0.0, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "mana_circle", "no_hit": true, "flame": true, "shake": 0.2, "stop": 0.0, "lean": 20.0, "twist": 0.0},
	"cat_fk_nova": {"name": "บีบลูกไฟ", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.1, 0.0, 0.25), "end_off": Vector3(0.7, 0.05, 0.1), "ease": 3.0, "time": 0.7, "wind": 0.4, "strike": 0.5, "next": 0.95, "dmg": 0.0, "lunge": 0.0, "fx": "nova", "no_hit": true, "no_trail": true, "hand_cast": true, "shake": 0.2, "stop": 0.0, "lean": 10.0, "twist": -20.0},
	"cat_gd_roar": {"name": "คำรามแผ่นดิน", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(0.35, 0.05, 0.2), "ease": 2.0, "time": 1.2, "wind": 0.15, "strike": 0.8, "next": 0.95, "dmg": 0.0, "lunge": 0.0, "multi": 0.25, "multi_fx": "roar", "multi_half": 0.0, "multi_ahead": 0.0, "hold_after": 3.0, "hold_button": "skill", "pulse": "roar", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.2, "stop": 0.0, "lean": -18.0, "twist": 0.0},
	"cat_gd_horn": {"name": "โทรโข่ง", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.1, 0.0, 0.2), "end_off": Vector3(0.6, 0.1, 0.15), "ease": 3.0, "time": 0.6, "wind": 0.35, "strike": 0.45, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "horn", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.25, "stop": 0.0, "lean": -12.0, "twist": 0.0},
	"cat_gd_lunge": {"name": "พุ่งแทง", "wind_hand": Vector3(-0.2, 0.05, 0.15), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.72, 0.0, 0.0), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 1.0, "time": 0.45, "wind": 0.2, "strike": 0.75, "next": 0.8, "dmg": 12.0, "lunge": 2.5, "auto": "cat_gd_bash2", "front_hit": true, "shake": 0.1, "stop": 0.04, "lean": 30.0, "twist": 0.0, "hit": {"kb": 0.5, "stun": 0.5}},
	"cat_gd_bash2": {"name": "กระแทกโล่", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(-0.15, 0.0, 0.25), "end_off": Vector3(0.62, -0.05, 0.15), "ease": 3.0, "time": 0.45, "wind": 0.3, "strike": 0.55, "next": 0.9, "dmg": 22.0, "lunge": 0.6, "shield_hand": true, "front_hit": true, "no_trail": true, "shake": 0.25, "stop": 0.1, "lean": 22.0, "twist": -20.0, "hit": {"type": "knockdown", "fly": 7.0}},
	"cat_gd_trail": {"name": "คลื่นตะโกน", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(0.35, 0.05, 0.2), "ease": 3.0, "time": 0.7, "wind": 0.35, "strike": 0.45, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "shout_trail", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.25, "stop": 0.0, "lean": -15.0, "twist": 0.0},
	"cat_gd_rally": {"name": "โล่เรืองแสง", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(0.3, 0.6, 0.15), "ease": 3.0, "time": 0.7, "wind": 0.4, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "leap": 7.0, "fx": "rally", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.2, "stop": 0.0, "lean": -15.0, "twist": 0.0},
	"cat_gd_guard": {"name": "ตั้งโล่", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.55, 0.05, 0.15), "end_off": Vector3(0.55, 0.08, 0.15), "ease": 2.0, "time": 1.6, "wind": 0.08, "strike": 0.97, "next": 1.0, "dmg": 0.0, "lunge": 0.0, "sa": true, "guard": true, "counter": "cat_gd_counter", "shield_hand": true, "no_hit": true, "no_trail": true, "shake": 0.0, "stop": 0.0, "lean": 8.0, "twist": 0.0},
	"cat_gd_counter": {"name": "สวนโล่", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(-0.15, 0.0, 0.25), "end_off": Vector3(0.65, -0.05, 0.15), "ease": 3.0, "time": 0.4, "wind": 0.2, "strike": 0.45, "next": 0.85, "dmg": 26.0, "lunge": 0.4, "sa": true, "shield_hand": true, "front_hit": true, "no_trail": true, "shake": 0.3, "stop": 0.1, "lean": 22.0, "twist": -20.0, "hit": {"kb": 1.0, "stun": 2.0, "real_stun": true}},
	"cat_gd_banner": {"name": "วงแดงคุ้มกัน", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(0.3, 0.6, 0.15), "ease": 3.0, "time": 0.6, "wind": 0.35, "strike": 0.5, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "banner", "no_hit": true, "shield_hand": true, "no_trail": true, "shake": 0.25, "stop": 0.0, "lean": -15.0, "twist": 0.0},
	"cat_gd_smash": {"name": "โล่ทุบแรง", "wind_hand": Vector3(-0.35, -0.25, 0.05), "wind_aim": Vector2(-15.0, 170.0), "end_hand": Vector3(-0.4, -0.28, 0.05), "end_aim": Vector2(-15.0, 172.0), "wind_off": Vector3(-0.3, 0.1, 0.3), "end_off": Vector3(0.75, -0.05, 0.15), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.58, "next": 0.9, "dmg": 40.0, "lunge": 0.8, "fx": "smash_wave", "shield_hand": true, "front_hit": true, "no_trail": true, "shake": 0.4, "stop": 0.12, "lean": 28.0, "twist": -25.0, "hit": {"kb": 2.0, "stun": 0.8}},
	"cat_ck_rend": {"name": "ฟันเลือดคลั่ง", "wind_hand": Vector3(-0.35, 0.05, 0.35), "wind_aim": Vector2(0.0, 160.0), "end_hand": Vector3(0.62, 0.0, -0.25), "end_aim": Vector2(-5.0, -45.0), "wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.55, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 10.0, "lunge": 0.3, "fx": "slash_marks", "blood": true, "shake": 0.2, "stop": 0.0, "lean": 20.0, "twist": 40.0, "hit": {"kb": 0.6, "stun": 0.4}},
	"cat_ck_punch": {"name": "หมัดมาร์ค", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(-0.25, 0.0, 0.15), "end_off": Vector3(0.78, 0.05, 0.05), "ease": 3.0, "time": 0.45, "wind": 0.35, "strike": 0.55, "next": 0.85, "dmg": 12.0, "lunge": 0.4, "front_hit": true, "blood": true, "no_trail": true, "shake": 0.15, "stop": 0.08, "lean": 18.0, "twist": -25.0, "hit": {"kb": 0.5, "stun": 0.5, "mark": true, "slow": 10.0}},
	"cat_ck_pull": {"name": "ดูดระเบิด", "wind_hand": Vector3(-0.2, 0.05, 0.15), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.72, 0.0, 0.0), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 3.0, "time": 0.8, "wind": 0.3, "strike": 0.45, "next": 0.95, "dmg": 0.0, "lunge": 0.2, "fx": "blood_pull", "no_hit": true, "blood": true, "shake": 0.2, "stop": 0.0, "lean": 15.0, "twist": 0.0},
	"cat_ck_chakram": {"name": "กงจักรเลือด", "wind_hand": Vector3(-0.35, 0.05, 0.35), "wind_aim": Vector2(0.0, 160.0), "end_hand": Vector3(0.62, 0.0, -0.25), "end_aim": Vector2(-5.0, -45.0), "wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.55, "wind": 0.4, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.2, "fx": "chakram", "no_hit": true, "blood": true, "shake": 0.2, "stop": 0.0, "lean": 15.0, "twist": 40.0},
	"cat_ck_offer": {"name": "ถวายเลือด", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.65, 0.1), "ease": 3.0, "time": 0.8, "wind": 0.3, "strike": 0.45, "next": 0.95, "dmg": 0.0, "lunge": 0.0, "fx": "offering", "hide_sword": true, "no_hit": true, "no_trail": true, "blood": true, "shake": 0.2, "stop": 0.0, "lean": -15.0, "twist": 0.0},
	"cat_ck_orbit": {"name": "ใบเลือดหมุน", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.65, 0.1), "ease": 3.0, "time": 0.5, "wind": 0.35, "strike": 0.5, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "orbit", "no_hit": true, "no_trail": true, "blood": true, "shake": 0.1, "stop": 0.0, "lean": -8.0, "twist": 0.0},
	"cat_ck_sky": {"name": "ดาบเลือดฟ้า", "wind_hand": Vector3(-0.3, -0.3, 0.05), "wind_aim": Vector2(-30.0, 175.0), "end_hand": Vector3(-0.32, -0.32, 0.05), "end_aim": Vector2(-32.0, 176.0), "wind_off": Vector3(0.2, 0.0, 0.2), "end_off": Vector3(0.3, 0.65, 0.1), "ease": 3.0, "time": 0.6, "wind": 0.45, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "blood_sky", "no_hit": true, "no_trail": true, "blood": true, "shake": 0.3, "stop": 0.0, "lean": -8.0, "twist": 0.0},
	"cat_ck_wheel": {"name": "ดาบเลือดหมุน", "wind_hand": Vector3(-0.2, 0.05, 0.15), "wind_aim": Vector2(5.0, 0.0), "end_hand": Vector3(0.72, 0.0, 0.0), "end_aim": Vector2(0.0, 0.0), "wind_off": Vector3(0.3, 0.0, 0.2), "end_off": Vector3(-0.4, -0.1, -0.1), "ease": 1.0, "time": 0.75, "wind": 0.1, "strike": 0.85, "next": 0.95, "dmg": 9.0, "lunge": 2.5, "roll_rate": 1000.0, "multi": 0.11, "multi_ahead": 90.0, "multi_half": 120.0, "front_hit": true, "fx_start": "blood_flash", "blood": true, "shake": 0.12, "stop": 0.0, "lean": 10.0, "twist": 0.0, "hit": {"kb": 0.5, "stun": 0.5}},
	"cat_sa": {"name": "เกราะ SA", "wind_hand": Vector3(0.1, 0.0, 0.2), "wind_aim": Vector2(60.0, 0.0), "end_hand": Vector3(0.2, 0.55, 0.1), "end_aim": Vector2(90.0, 0.0), "wind_off": Vector3(-0.2, 0.3, 0.1), "end_off": Vector3(-0.3, 0.4, 0.1), "ease": 2.0, "time": 0.55, "wind": 0.35, "strike": 0.55, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "fx": "sa_buff", "no_hit": true, "no_trail": true, "shake": 0.1, "stop": 0.0, "lean": -5.0, "twist": 0.0},
}
const CAT_RUSH_HITS := 5

## ท่าฟันห้าฮิตของสกิล 20.1 ใช้ท่าฟัน Z สลับกัน เร็วขึ้น ไถลตาม ต่อกันเองจนครบแล้วตบดิน
static func cat_rush(n: int) -> Dictionary:
	var base: Dictionary = (CHIBI_Z[(n - 1) % 2] as Dictionary).duplicate()
	base["time"] = 0.24
	base["wind"] = 0.2
	base["strike"] = 0.55
	base["next"] = 0.62
	base["lunge"] = 0.45 if n > 1 else 1.2
	base["dmg"] = 9.0
	base["auto"] = "cat_rush%d" % (n + 1) if n < CAT_RUSH_HITS else "cat_rush_end"
	base["stop"] = 0.02
	return base

# ท่าถัดไปที่ SWORD KNIGHT ต่อเพิ่มจาก BASIC และท่าที่เปลี่ยนไป
const SK_NEXT := {"x3": {"x": "skx4"}, "skx4": {"x": "skx5"}, "dz1": {"x": "sk_charge"}, "sk_charge": {"x": "sk_smash"}, "adz2": {"z": "sk_spin_dive"}}

## ท่าถัดไปตามสาย SWORD KNIGHT ต่อเพิ่มจาก BASIC
static func chibi_next(class_id: String, current: String, button: String) -> String:
	# สายต่อยอดใช้คอมโบของสายแม่
	class_id = PARENT_CLASS.get(class_id, class_id)
	var table: Dictionary = {"SWORD KNIGHT": SK_NEXT, "MAGIC KNIGHT": MK_NEXT, "SHIELD KNIGHT": SH_NEXT, "DARK KNIGHT": DK_NEXT}.get(class_id, {})
	var extra: String = (table.get(current, {}) as Dictionary).get(button, "")
	if extra != "":
		return extra
	return (CHIBI_NEXT.get(current, {}) as Dictionary).get(button, "")

## ข้อมูลท่าตามสาย SWORD KNIGHT ทำ xxx เป็นเกราะ และทีสามแค่ชะงักแทนกระเด็น
## ท่าสกิลแมวหลากหลายขึ้น เติมการเคลื่อนไหวลำตัว (หมุนตัว ตีลังกา เอนตัว บิดตัว) ไม่ให้ทุกสกิลออกท่าเหมือนกัน
## ไม่เปลี่ยนมือหรือดาบ ระยะโดนจึงเท่าเดิม  สกิลที่มีการหมุนอยู่แล้วไม่แตะ
static var _varied := {}
static func _cat_skill_varied(id: String) -> Dictionary:
	if _varied.has(id):
		return _varied[id]
	var m: Dictionary = (CAT_SKILLS[id] as Dictionary).duplicate(true)
	if not (m.has("spin") or m.has("roll_rate") or m.has("roll_once") or id.ends_with("_hyper")):
		match absi(hash(id)) % 5:
			0:
				m["spin"] = 360.0
			1:
				m["roll_once"] = true
			2:
				m["lean"] = float(m.get("lean", 0.0)) + 22.0
				m["twist"] = float(m.get("twist", 0.0)) + 35.0
			3:
				m["spin"] = -360.0
			4:
				m["lean"] = float(m.get("lean", 0.0)) - 18.0
				m["twist"] = float(m.get("twist", 0.0)) - 30.0
	_varied[id] = m
	return m

static func chibi_move_for(class_id: String, id: String) -> Dictionary:
	if id.begins_with("mg_"):
		return MageCombo.move(id)
	# ท่าธนูทุกสาย bw_ (BASIC) bww_ bws_ bwm_ bwt_
	if id.begins_with("bw"):
		return BowCombo.move(id)
	# ท่าหอกของ CAT CITRUS
	# ท่าหมัดเท้าของ CAT ASH fs_ (BASIC) และสายอื่นที่ขึ้นต้น fs
	if id.begins_with("fs"):
		return FistCombo.move(id)
	# ท่าของ CAT AZURE & LAPIS
	if id.begins_with("pc_"):
		return PairCombo.move(id)
	if id.begins_with("sp_") or id.begins_with("spt_") or id.begins_with("spf_") or id.begins_with("spv_") or id.begins_with("sps_"):
		return SpearCombo.move(id)
	class_id = PARENT_CLASS.get(class_id, class_id)
	if class_id == "SWORD KNIGHT":
		if SK_MOVES.has(id):
			return SK_MOVES[id]
		if id in ["x1", "x2", "x3"]:
			var heavy: Dictionary = (CHIBI_MOVES[id] as Dictionary).duplicate()
			heavy["sa"] = true
			if id == "x3":
				heavy["hit"] = {"kb": 1.5, "stun": 0.7}
				heavy["next"] = 0.7
			return heavy
	if class_id == "MAGIC KNIGHT" and MK_MOVES.has(id):
		return MK_MOVES[id]
	if class_id == "SHIELD KNIGHT" and SH_MOVES.has(id):
		return SH_MOVES[id]
	if class_id == "DARK KNIGHT" and DK_MOVES.has(id):
		return DK_MOVES[id]
	if CAT_SKILLS.has(id):
		return _cat_skill_varied(id)
	if id.begins_with("cat_rush") and id != "cat_rush_end":
		return cat_rush(int(id.substr(8)))
	return chibi_move(id)

## ข้อมูลท่าตามชื่อ z1 ถึง z4 คือคอมโบ Z เดิม adz1 ถึง adz3 คือ Z เดิมแต่ค้างกลางอากาศ
static func chibi_move(id: String) -> Dictionary:
	if id.length() == 2 and id[0] == "z" and id[1].is_valid_int():
		return CHIBI_Z[int(id.substr(1)) - 1]
	if id.begins_with("adz"):
		var air: Dictionary = (CHIBI_Z[int(id.substr(3)) - 1] as Dictionary).duplicate()
		air["hover"] = true
		air["lunge"] = float(air["lunge"]) * 0.5
		air.erase("spin")
		air.erase("orbit")
		return air
	return CHIBI_MOVES.get(id, {})
# คอมโบ ZZZZ ของ BOYS สี่ทีคนละแบบ เฉียงลง กวาดแนวนอน แทงพุ่ง หมุนตัวฟัน
# มือเทียบไหล่ x ไปข้างหน้า y ขึ้น z เข้าหากล้อง ทิศใบดาบ Vector2(เงยองศา หันองศา) หัน 0 คือหน้า 90 คือเข้าหากล้อง
# wind_off end_off มืออีกข้างเทียบไหล่ เหวี่ยงสวนดาบเพื่อถ่วงตัว
# wind จบช่วงง้าง strike ดาบถึงเป้า next กดไว้ก่อนแล้วต่อทีถัดไปได้ตั้งแต่ตรงนี้ เป็นสัดส่วนของเวลาที
const CHIBI_Z := [
	{"name": "เฉียงลง", "wind_off": Vector3(0.36, 0.04, -0.16), "end_off": Vector3(-0.42, -0.26, -0.2), "wind_hand": Vector3(-0.12, 0.28, 0.2), "wind_aim": Vector2(128.0, 20.0), "end_hand": Vector3(0.55, -0.32, -0.1), "end_aim": Vector2(-42.0, -28.0), "ease": 3.0, "time": 0.36, "wind": 0.34, "strike": 0.52, "next": 0.62, "dmg": 10.0, "lunge": 0.28, "shake": 0.09, "stop": 0.05, "lean": 18.0, "twist": 26.0},
	{"name": "กวาดแนวนอน", "wind_off": Vector3(0.42, -0.14, -0.26), "end_off": Vector3(-0.46, -0.12, 0.26), "wind_hand": Vector3(-0.38, -0.02, 0.3), "wind_aim": Vector2(6.0, 150.0), "end_hand": Vector3(0.46, -0.1, -0.3), "end_aim": Vector2(-6.0, -55.0), "tilt": -26.0, "ease": 3.0, "time": 0.36, "wind": 0.34, "strike": 0.54, "next": 0.64, "dmg": 10.0, "lunge": 0.22, "shake": 0.09, "stop": 0.05, "lean": 8.0, "twist": 34.0},
	{"name": "แทงพุ่ง", "wind_off": Vector3(0.46, -0.06, -0.1), "end_off": Vector3(-0.58, -0.22, -0.1), "wind_hand": Vector3(-0.4, -0.02, 0.12), "wind_aim": Vector2(6.0, 0.0), "end_hand": Vector3(0.72, -0.08, 0.0), "end_aim": Vector2(-3.0, 0.0), "ease": 3.0, "ribbon": true, "time": 0.38, "wind": 0.38, "strike": 0.54, "next": 0.64, "dmg": 12.0, "lunge": 0.75, "shake": 0.12, "stop": 0.06, "lean": 28.0, "twist": 10.0},
	{"name": "หมุนตัวฟัน", "wind_off": Vector3(-0.3, -0.16, -0.3), "end_off": Vector3(-0.46, -0.16, 0.14), "off_orbit": 0.5, "wind_hand": Vector3(0.3, -0.1, 0.4), "wind_aim": Vector2(10.0, 330.0), "end_hand": Vector3(0.5, -0.12, -0.2), "end_aim": Vector2(-8.0, -30.0), "tilt": -26.0, "ease": 2.0, "orbit": 0.62, "spin": 360.0, "time": 0.6, "wind": 0.28, "strike": 0.7, "next": 0.8, "dmg": 22.0, "lunge": 0.5, "shake": 0.3, "stop": 0.1, "lean": 10.0, "twist": 0.0},
]
const CHIBI_BOW_SHIFT := 8.0     # มือถือธนูอยู่ห่างตัวกว่าดาบนิดหน่อย
const CHIBI_BOW_HALF := 44.0
const CHIBI_BOW_DEPTH := 18.0
const CHIBI_BOW_W := 10.0
const CHIBI_BOW_TIP := 8.0
const CHIBI_BOW_STRING := 3.0
const BLADE_LONG := 118.0
const BLADE_HALF := 10.0
const PAINT_RED := Color(0.84, 0.16, 0.16)
const PAINT_STEP := 9.0        # ระยะห่างแต่ละขีด
const PAINT_SLANT := 7.0       # ความเอียงของขีด
const PAINT_SKIP := -0.72      # ค่าต่ำกว่านี้เว้นช่องไว้ไม่ระบาย
const PAINT_SKIP_UNTIL := 0.6
const PAINT_WIDTH := 2.6
const GUARD_HALF := 24.0
const GUARD_THICK := 5.5
const GRIP_THICK := 5.0
const GRIP_LONG := 22.0
const REST_SW := -28.0
const SHORTEST_BLADE := 0.25   # ฟันแนวนอนดาบหันเข้ากล้อง ยังเห็นเป็นเส้นสั้นๆ
const BLADE_SEED := 40
const HAND_SQUEEZE := 0.72
const DRONE_SLOTS := [Vector2(-0.95, 2.05), Vector2(0.05, 2.55), Vector2(1.05, 2.05)]   # ตำแหน่งเทียบเท้า หน่วยโลก
const DRONE_TALL := 26.0       # ครึ่งความสูงตัวโดรนแนวตั้ง
const DRONE_WIDE := 8.0
const ROTOR_LONG := 22.0
const ROTOR_SPEED := 22.0
const CUBE_DRONE := 15.0
const BLADE_TALL := 40.0       # แผ่นโดรน ปลายสองด้านเรียวแหลม ตรงกลางเว้า
const BLADE_WIDE := 12.0
const BLADE_WAIST := 4.0
const TRAIL_LONG := 52.0
const SYRINGE_LONG := 26.0     # ครึ่งความยาวกระบอก
const SYRINGE_WIDE := 9.0
const SYRINGE_NEEDLE := 13.0   # ตัวเข็มสั้น
const SYRINGE_PLUNGER := 13.0
const SYRINGE_LIQUID := 0.62   # น้ำยาเต็มกระบอกกี่ส่วน
const DRONE_BOB := 0.08
const DRONE_LUNGE := 2.2       # ตอนโจมตีพุ่งไปข้างหน้า
const DRONE_DOWN := 1.1        # พุ่งลงระดับมอน
const DRONE_ACCENT := Color(0.6, 0.36, 0.86)
const DRONE_FILL := Color(1.0, 1.0, 1.0)
const DRONE_HATCH := 5.0
const WHITE_LINE := Color(0.62, 0.6, 0.66)
const SHIELD_SIZE := Vector2(30.0, 54.0)
const FIRE_COLOR := Color(0.92, 0.36, 0.12)
const FIRE_INNER := Color(0.98, 0.72, 0.2)
const FIRE_HIGH := 30.0
const FIRE_WIDE := 12.0
const WING_LONG := 44.0
const WING_FEATHERS := 3
const WING_COLOR := Color(0.9, 0.36, 0.72)
const STAFF_PAINT := Color(0.5, 0.32, 0.82)
const STAFF_ORB := 17.0
const STAFF_LONG := 78.0       # คทาสั้นกว่าดาบ
const BOOK_OFFSET := Vector2(-1.15, 2.45)   # หลังหัวเฉียงขึ้น หน่วยโลก
const BOOK_FOLLOW := 5.0
const BOOK_BOB := 0.1
const BOOK_W := 34.0
const BOOK_H := 25.0
const BOOK_TILT := 6.0
const BOOK_FLIP_TIME := 1.1
const BOOK_LIFT := 18.0
const STAB_HAND := Vector2(0.2, 0.37)   # ตำแหน่งมือตอนปักดาบ ปลายดาบแตะพื้นพอดี
const SWOOSH_SEED := 50
const SWOOSH_POINTS := 18
const SWOOSH_FLAT_GAP := 16.0
const OFF_HAND_RATE := 12.0
const PLUNGE_STOP := 1.0
const MARK_FOLLOW := 0.5        # ตามมอนที่เป็นเป้าที่อยู่ในจอ
const METEOR_RISE := 5.0
const METEOR_SMALL := 24.0
const METEOR_BIG := 58.0
const CURL_R := 46.0           # ม้วนตัวตอนกลิ้ง
const CURL_CENTER := 50.0
const METEOR_HIGH := 7.5
const METEOR_SPEED := 12.0
const SLIM_HALF := 6.0         # LORD KNIGHT ใบดาบเพรียว
const SLIM_TIP := 26.0
const SQUARE_HALF := 12.0      # BLADE WEAVER ใบดาบสี่เหลี่ยม
const FANCY_GUARD := 30.0
const FANCY_DROP := 11.0
const FANCY_THICK := 4.5
const FANCY_END := 5.0
const FANCY_STEPS := 8
const FANCY_GEM := 7.0
const TETHER_REACH := 5.5      # เส้นไฟฟ้าไปถึง 5 ช่วงตัว
const TETHER_GAP := 0.25
const TETHER_PULL := 2.2
const TETHER_STOP := 1.2
const TETHER_DMG := 2.0
const TETHER_POP := 5.0        # ปล่อยปุ่มแล้วมอนดีดลอยนิดนึง
const RIFT_PUSH_REACH := 7.0
const BODY_CENTER := 112.0
const WAVE_SPEED := 10.0
const DRONE_SIDE := 210.0
const DRONE_ON_HEAD := 270.0
const CHEST_UP := 1.25
const DRONE_SPIN_X := 34.0
const DRONE_SPIN_Y := 9.0
const DRONE_FOLLOW := 12.0     # ความเร็วที่โดรนไปยังจุดของท่า
const DRONE_SPREAD := 26.0
const DRONE_FRONT := Vector2(170.0, -100.0)
const DRONE_AHEAD := Vector2(225.0, -60.0)
const DRONE_ORBIT := Vector2(135.0, 62.0)
const DRONE_ORBIT_SPEED := 13.0
const KICK_REACH := Vector2(78.0, -48.0)
const STOMP_LIFT := 46.0
const LEG_RATE := 16.0
const BEAM_RINGS := 5
const BEAM_LONG := 190.0       # คลื่นกระบอกไฟฟ้าส่งออกจากโดรนไปข้างหน้า เฉียงลง
const BEAM_R := 42.0
const BEAM_FLAT := 0.3
const BEAM_STEPS := 22
const WARP_REACH := 5.0        # วาปหามอนในระยะนี้
const WARP_NEAR := 1.0
const WARP_HIGH := 2.3
const HEART_R := 15.0
const HEART_FILL := Color(1.0, 0.62, 0.78)
const SMALL_WING := 0.7
const SPIRAL_ORB := Color(0.86, 0.42, 0.82)
const SPIRAL_LINE := Color(0.62, 0.3, 0.84)
const SPIRAL_OUT := 15.0       # เกลียวห่างจากขอบหัวคทา
const SPIRAL_R := 15.0
const SPIRAL_TURNS := 2.25
const SPIRAL_STEPS := 22
const CUBE_HEAD := 21.0        # หัวคทาลูกบาศก์สามมิติ ลอยเหนือไม้
const CUBE_HEAD_GAP := 18.0
const CUBE_HEAD_FLAT := 0.42
const CUBE_HEAD_SPIN := 1.6
const CUBE_HEAD_BOB := 3.0
const CUBE_ORB := 10.0
const AURA_MIN_SPEED := 6.0
const AURA_DOTS := 12
const AURA_RX := 74.0
const AURA_RY := 96.0
const BOLT_MISS := 2.5          # สายฟ้าไม่โดนใคร ผ่าลงพื้นตรงหน้า
const WIND_LINES := 4
const WIND_LONG := 210.0
const TIP_CIRCLE_AHEAD := 2.3  # วงเวทที่หัวคทา เฉียงลงด้านหน้า เทียบเท้า หน่วยโลก
const TIP_CIRCLE_UP := 0.5
const TIP_CIRCLE_TILT := PI * 0.25
const SKY_CIRCLE_AHEAD := 3.2  # วงเวทบนฟ้าด้านหน้า ความสูงจากพื้น หน่วยโลก
const SKY_CIRCLE_UP := 5.1
const RAM_LINES := [[-20.0, 95.0], [-62.0, 130.0], [-104.0, 110.0], [-146.0, 80.0]]   # ความสูงเทียบเท้า ความยาว
const RAM_GAP := 70.0          # ห่างจากกลางตัว
const RAM_SHIFT := 26.0
const SLAM_AHEAD := 1.1
const WHEEL_CENTER := 112.0    # กลางตัวเหนือเท้า จุดภาพ
const SLASH_FLAMES := 12
const BLAST_LONG := 62.0        # เปลวเล็กๆ เปลวเดียว ตั้งขึ้นหน้ามือ
const BLAST_WIDE := 13.0
const SWOOSH_FADE := 0.12      # หางเส้นไล่ตามปลายดาบจนหายในเวลานี้หลังฟันจบ
const SWOOSH_LINES := [[1.0, 3.0, 0.0], [0.8, 2.2, 0.14], [0.6, 1.6, 0.28]]   # ตำแหน่งบนใบดาบ ความหนา หางสั้นลงเท่าไร

var pos := Vector2.ZERO
var vel := Vector2.ZERO
var half_width := 7.0
var facing := 1.0
var input_dir := 0.0
static var gravity_k := 1.0      # แรงโน้มถ่วงตามฉาก (ใต้ทะเลลอยเบา)
var fast_fall := false           # กดลงกลางอากาศ ตกเร็ว
var run_push := false             # จอยดันสุดขอบ วิ่งทันที
var _push_run := false
var held_keys := {}        # ปุ่มโจมตีที่กดค้างอยู่
var down_held := false
var _off_k := 0.0          # มือรองหรือโล่กำลังยื่นไปตำแหน่งของท่า
var _off_to := Vector2.ZERO
var _shot_done := false
var _aura: FireAura = null
var _pillar: DimPillar = null
var _meteor_wait := 0.0
var _meteor_n := 0
var _tether: Node2D = null
var _tether_wait := 0.0
var _rift: TimeRift = null
var _drone_k := 0.0        # โดรนกำลังไปจุดของท่า 0 ถึง 1
var _drone_goal := ""
var _kick_k := 0.0
var _dust: DimDust
var _staff_heart := false
var _staff_spiral := false
var _sword_style := ""     # slim ดาบเพรียว การ์ดสวย  square ใบดาบสี่เหลี่ยม
var _paint_taper := true
var _staff_cube := false
var _slam_done := false
var _mash_used := 0
var _ball: FireBall
var jump_held := false
var hp := MAX_HP
var mp := MAX_MP
var skill_buff_t := 0.0    # บัพความเสียหายสกิล
var regen_buff_t := 0.0    # บัพเพิ่มมานา โดนตีแล้วหยุดทันที
var _passives := {}
var coat_t := 0.0          # อาวุธเคลือบไฟ
var coat_kind := ""
var shout_buff_t := 0.0
var shout_count := 0
var limit_buff_t := 0.0
var haste_t := 0.0
var red_t := 0.0            # ขวดเหลือง ตัวแดง ติด SA
var sword_aura_t := 0.0     # 35.2 ออร่าดาบใหญ่
var plain := false          # ตัว chibi ดำล้วน ชิ้นส่วนลอยแยกกัน ไม่มีเอฟเฟกใดๆ
var plain_weapon := "sword"  # ตัว chibi ถือ sword หรือ bow
var plain_model: ChibiModel  # มีโมเดล 3 มิติแล้วไม่วาดตัว 2 มิติ
var plain_swing := 0.0       # ความคืบหน้าท่าสกิล 0 คือไม่ได้ออกท่า
var plain_override := false  # HYPER สั่งท่าเอง
var plain_sw := REST_SW
var plain_hand_at := Vector2.ZERO
var plain_off_at := Vector2.ZERO
var plain_off_scale := 1.0   # กำมือ มือรองหดลง
var plain_blade_k := 0.0     # 0 ดาบปกติ 1 ดาบใหญ่สีแดง
var plain_rim := 0.0         # ขอบสว่างรอบตัวตอนฉากหลังดำ 0 ถึง 1
var plain_jump_wind := 0.0    # จังหวะย่อตัวก่อนกระโดด 0 ถึง 1
var plain_combo_nth := 0      # ทีที่กำลังเล่นในคอมโบ Z
var plain_move: Dictionary = {}  # ท่าคอมโบที่กำลังเล่น
var plain_prev: Dictionary = {}  # ท่าก่อนหน้าในคอมโบ ใช้ต่อท่าง้างจากท่าจบเดิม ว่างคือเริ่มจากท่ายืน
var plain_combo_id := 0          # นับท่าที่เริ่ม ใช้แยกรอยดาบแต่ละท่า
var plain_ghost := false         # ท่านี้วิ่งทะลุมอนได้
var plain_sa_t := 0.0            # เวลาที่เหลือของบัพเกราะ SA
var plain_fire_t := 0.0          # ดาบติดไฟจากสกิล 30.2 ของ MAGIC KNIGHT
var plain_blood_t := 0.0         # ดาบเลือดของ DARK KNIGHT 25.1
var plain_aura_t := 0.0          # ออร่าดาบของ GRAND KNIGHT 35.2
var plain_guard_t := 0.0         # ตั้งการ์ดสวนของ GRAND KNIGHT 50.1
var plain_guard_hit := false
var plain_mana_t := 0.0          # GUARDIAN 45.2 คอมโบได้ MP เพิ่ม
var plain_boost_t := 0.0         # CRIMSON 35.4 สังเวยเลือดแล้ว ดาเมจแรงขึ้น
var plain_atk_t := 0.0           # พลังโจมตีเพิ่มจากพาสซีฟ 40.1 ของ MAGIC KNIGHT
var plain_combo_rest := 0.0   # ความคืบหน้าตอนกลับท่ายืน
var plain_swing_kind := "swing"  # swing ปัดขึ้น stab ปักพื้น slash ฟันรัวหลายมุม
var zone_t := 0.0           # ยืนในวงเวทแดง
var barrier_t := 0.0        # บาเรียม่วง ติด SA
var rm_heal_t := 0.0
var dome_t := 0.0
var rm_square_t := 0.0
var dna_points := 0.0
var dna_stage := 0          # ขั้นบัพ DNA ที่รับอยู่
var dna_t := 0.0
var _dna_regen := 0.0
var ds_form_t := 0.0        # ร่างแปลงเล็ก 15.3 บัพความเร็วและพลัง
var ds_guard_t := 0.0       # รับการโจมตีเบาลง
var _gears := {}            # โดรนลอยตามที่รอกดครั้งที่สอง รหัสสกิล -> โดรน
var _mana_rolled := false
var mana_gained := 0
var homun: Homunculus = null
var gauges := {"fire": 0.0, "elec": 0.0, "ice": 0.0}
var gauge_bursts := 0
var reflected := 0
var parried := 0
var waves_sent := 0
var _wave_rolled := false
var recall_t := 0.0
var _recall_hp := 0.0
var _recall_mp := 0.0
var attack_buff_t := 0.0   # บัพพลังโจมตีอย่างเดียว
var mana_buff_t := 0.0     # บัพลดมานา เฉพาะสกิลกด ไม่รวมกดค้าง
var buff_t := 0.0          # บัพ SA เพิ่มความไว เพิ่มพลังโจมตี เหลือกี่วินาที
var locked := false        # ท่า Hyper คุมตำแหน่งและท่าทางเอง
var sword_hidden := false  # ท่าเวทเก็บดาบ เหลือแค่มือ
var hand_open := 1.0       # 1 มือปกติ 0 ขยำ
var job_id := ""           # กำหนดอาวุธและของติดตัว
var form_on := false       # ร่างแปลงของ DIMENSION STRIKE คทามีปีก
var _spin := 0.0
var _attack_spin := 0.0    # ท่าหมุนตัว
var _wheel := 0.0          # หมุนทั้งตัวแนวตั้งเหมือนตีลังกา เรเดียน
var _white := 0.0
var _drone_style := "rotor"
var _has_shield := false
var _has_fire := false
var _weapon := "sword"
var _has_book := false
var _book_pos := Vector2.ZERO
var _book_ready := false
var _flip_t := 0.0

var chain := ""
var chain_t := 0.0
var queued := ""
var queued_t := 0.0
var dash_t := 0.0
var dash_dir := 0.0
var air_used := false
var air_dash_used := false
var jump_dashed := false
var attacking := false
var cur_move := {}
var attack_t := 0.0
var attack_dur := 0.0
var move_dur := 0.0
var cur_wind := 0.3
var strike_part := 0.25
var active_t0 := 0.0
var active_t1 := 0.0
var active_done := false
var hit_landed := false
var pierced := false
var _tick_wait := 0.0
var _tick_left := 0
var pierce_ahead: Array = []
var already_hit: Array = []
var lunge_v := 0.0
var hurt_t := 0.0
var flash_t := 0.0              # โดนตี ตัวขาววาบ
# สกิล CAT SUSI ตั้งค่าเหล่านี้ทุกเฟรม
var mp_bonus := 0.0             # MP สูงสุดเพิ่ม
var hp_bonus := 0.0             # เลือดสูงสุดเพิ่ม (พาสซีฟสกิล)
var block_chance := 0.0         # โอกาสกันการโจมตีทั้งหมด (พาสซีฟสกิล)
var regen_mult := 1.0           # ตัวคูณมานาฟื้น
var speed_bonus := 1.0          # ตัวคูณความเร็วเดิน
var ranged_guard_t := 0.0       # ไม่โดนตีจากระยะไกล
var melee_guard_t := 0.0        # ไม่โดนตีระยะประชิด
var susi_counter_t := 0.0       # โดนตีแล้วระเบิดผลักมอน
var susi_save_t := 0.0          # ใช้มานาน้อยลง
var susi_mana_t := 0.0          # มานาเพิ่ม
var invuln_t := 0.0
var combo_count := 0
var combo_dmg := 0.0
var combo_t := 0.0

var _prev_jump := false
var _last_dir := 0.0
var _last_tap_dir := 0.0
var _last_tap_time := -10.0
var _hitstop_on := false
var _clock := 0.0
var _sw := REST_SW
var _ry := 0.0
var _hand_off := Vector2.ZERO
var _lean := 0.0

func _ready() -> void:
	add_to_group("hero")
	z_index = 5   # ตัวละครและดาบอยู่หน้ามอนและเอฟเฟกเสมอ
	_place()

## ตัว BOYS ลอยค้างแป๊บหนึ่งที่จุดสูงสุด และตกหนักกว่าตอนขึ้น
func _plain_gravity() -> float:
	if not plain:
		return 1.0
	# กลางอากาศกดลงค้าง ตกถึงพื้นเร็วขึ้น
	if fast_fall:
		return 3.2
	if absf(vel.y) < CHIBI_HANG_SPEED:
		return CHIBI_HANG_GRAVITY
	return CHIBI_FALL_GRAVITY if vel.y < 0.0 else 1.0

## แท่นลอยในฉาก [x ซ้าย, x ขวา, ความสูง] หน่วยเกม ตกลงมายืนได้ ทะลุขึ้นจากข้างล่างได้ เดินตกขอบได้
static var platforms: Array = []
## ความสูงพื้นตามตำแหน่ง x (เมืองที่มีเนิน ทางลาด ชั้น) ไม่ตั้งไว้ พื้นเรียบสูง 0
static var ground_fn: Callable = Callable()

func ground_at(x: float) -> float:
	return float(ground_fn.call(x)) if ground_fn.is_valid() else 0.0

func on_floor() -> bool:
	return vel.y <= 0.0 and (pos.y <= ground_at(pos.x) + 0.001 or _platform_under() >= 0.0)

## ยืนอยู่บนแท่นไหน คืนความสูงแท่น ไม่ได้ยืนคืน -1
func _platform_under() -> float:
	for p in platforms:
		if pos.x >= float(p[0]) and pos.x <= float(p[1]) and absf(pos.y - float(p[2])) < 0.03:
			return float(p[2])
	return -1.0

func _airborne() -> bool:
	return not on_floor() or vel.y > 0.0

## รับปุ่ม z หรือ x กดรัวตอนท่าเพิ่งเริ่มไม่นับ จึงต้องกดจังหวะใกล้จบท่า
func queue_key(k: String) -> void:
	if hp <= 0.0 or hurt_t > 0.0:
		return
	if attacking and attack_t < maxf(attack_dur * (1.0 - BUFFER_WINDOW), active_t1) and not _landed_from_air_move() and not cur_move.has("mash_max"):
		return
	queued = k
	queued_t = QUEUE_TIME

func take_damage(dmg: float, dir: float, kind := "melee") -> void:
	if hp <= 0.0 or invuln_t > 0.0:
		return
	if kind == "ranged" and ranged_guard_t > 0.0:
		return
	if kind == "melee" and melee_guard_t > 0.0:
		return
	if block_chance > 0.0 and randf() < block_chance:
		invuln_t = maxf(invuln_t, 0.3)
		flash_t = FLASH_TIME * 0.5
		return
	# ตั้งการ์ดอยู่ ไม่เสียเลือด แล้วสวนกลับ
	if plain_guard_t > 0.0:
		plain_guard_hit = true
		return
	if WalkPage.chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and WalkPage.chosen_class == "GRAND KNIGHT":
		dmg *= CAT_GK_GUARD
	if WalkPage.chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and WalkPage.chosen_class == "FLAME KNIGHT":
		dmg *= CAT_FK_GUARD
	if WalkPage.chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and WalkPage.chosen_class == "GUARDIAN KNIGHT":
		dmg *= CAT_GD_GUARD
	if attacking and cur_move.get("invuln", false):
		return
	if attacking and cur_move.get("parry", false):
		_parry()
		return
	if attacking and cur_move.get("reflect", false) and _no_monster_near():
		_reflect(dir)
		return
	if _passives.has("wv_guard"):
		dmg *= WV_GUARD
	if ds_guard_t > 0.0:
		dmg *= DS_GUARD
	if _passives.has("rm_body"):
		dmg *= RM_GUARD
	regen_buff_t = 0.0
	if buff_on() and _passives.has("sk_guard"):
		dmg *= GUARD_MULT
	hp -= dmg
	flash_t = FLASH_TIME
	hurt_by.emit(kind)
	# จดจำไว้ ตายแล้วฟื้นกลับมา
	if hp <= 0.0 and recall_t > 0.0:
		hp = _recall_hp
		mp = _recall_mp
		recall_t = 0.0
		invuln_t = INVULN_TIME
		_spawn_fx("gate", pos + Vector2(0.0, 1.1))
		return
	_hitstop(0.08)
	if super_armor() and hp > 0.0:
		invuln_t = INVULN_TIME   # ไม่ชะงัก ท่ายังเดินต่อ
		return
	hurt_t = HURT_TIME
	invuln_t = INVULN_TIME
	if attacking:
		_end_attack()
	chain = ""
	queued = ""
	dash_t = 0.0
	combo_count = 0
	combo_dmg = 0.0
	vel.x = dir * 5.0
	if hp <= 0.0:
		hp = 0.0
		died.emit()

## เริ่มท่า Hyper: หยุดทุกอย่าง อมตะจนกว่าจะจบ
func lock_for_hyper() -> void:
	if attacking:
		_end_attack()
	locked = true
	_drone_k = 0.0
	_kick_k = 0.0
	_attack_spin = 0.0
	_wheel = 0.0
	vel = Vector2.ZERO
	input_dir = 0.0
	chain = ""
	queued = ""
	dash_t = 0.0
	hurt_t = 0.0
	invuln_t = 999.0

func unlock_from_hyper() -> void:
	locked = false
	invuln_t = 0.0
	sword_hidden = false
	hand_open = 1.0
	set_pose(REST_SW, Vector2.ZERO)

func set_pose(sw: float, hand_off: Vector2, lean := 0.0) -> void:
	_sw = sw
	_ry = 0.0
	_hand_off = hand_off
	_lean = lean

func current_sw() -> float:
	return _sw

func current_hand() -> Vector2:
	return _hand_off

func current_lean() -> float:
	return _lean

func count_hit(hp_change: float, h: Dictionary) -> void:
	_count_hit(hp_change, h)

## ตั้งสาย: อาวุธกับหนังสือลอยตาม
func set_job(id: String) -> void:
	job_id = id
	CombatData.use_job(id)
	var job := JobData.find(id)
	_weapon = str(job.get("weapon", "sword"))
	_has_book = job.get("book", false)
	_drone_style = str(job.get("drone", "rotor"))
	_has_shield = job.get("shield", false)
	_passives.clear()
	for s in SkillData.for_job(id):
		if s.get("passive", false):
			_passives[s["id"]] = true
	mp = mp_max()
	_staff_heart = job.get("staff_heart", false)
	_staff_spiral = job.get("staff_spiral", false)
	_sword_style = str(job.get("sword_style", ""))
	_staff_cube = job.get("staff_cube", false)
	_has_fire = job.get("hand_fire", false)
	_book_ready = false
	queue_redraw()

func has_shield() -> bool:
	return _has_shield

func has_hand_fire() -> bool:
	return _has_fire

## แปลงร่าง: เปิดคือคทางอกปีก
func set_form(on: bool) -> void:
	form_on = on

func set_spin(rad: float) -> void:
	_spin = rad

func set_white(k: float) -> void:
	_white = k

func white_amount() -> float:
	return _white

## สีตัวตอนกลายเป็นสีขาว
func _fill() -> Color:
	return Sketch.PAPER.lerp(Color.WHITE, _white)

func _ink() -> Color:
	if super_armor():
		return PAINT_RED
	return Sketch.INK.lerp(WHITE_LINE, _white)

## บัพและดีบัพที่มีตอนนี้ แต่ละอย่างคือ ชื่อสั้น กับ debuff หรือไม่
## เวลาที่เหลือของไอคอน วินาที ไม่มีเวลาคืนศูนย์
func icon_time(id: String) -> float:
	match id:
		"power", "guard": return buff_t
		"mana": return mana_buff_t
		"attack": return attack_buff_t
		"skill": return skill_buff_t
		"regen": return regen_buff_t
		"coat": return coat_t
		"shout": return shout_buff_t
		"limit": return limit_buff_t
		"haste": return haste_t
		"recall": return recall_t
		"sword_aura": return sword_aura_t
		"dna": return dna_t
		"rm_heal": return rm_heal_t
		"ds_form": return ds_form_t
		"ds_guard": return ds_guard_t
		"homun": return homun.life if is_instance_valid(homun) else 0.0
	return 0.0

func status_icons() -> Array:
	var out: Array = []
	if super_armor():
		out.append({"id": "sa", "label": "SA", "debuff": false})
	if buff_on():
		out.append({"id": "power", "label": "UP", "debuff": false})
	if mana_buff_t > 0.0:
		out.append({"id": "mana", "label": "MP", "debuff": false})
	if attack_buff_t > 0.0:
		out.append({"id": "attack", "label": "ATK", "debuff": false})
	if skill_buff_t > 0.0:
		out.append({"id": "skill", "label": "SK", "debuff": false})
	if regen_buff_t > 0.0:
		out.append({"id": "regen", "label": "MP+", "debuff": false})
	if coat_t > 0.0:
		out.append({"id": "coat", "label": COAT_LABEL[coat_kind], "debuff": false})
	if shout_buff_t > 0.0:
		out.append({"id": "shout", "label": "VOX", "debuff": false})
	if limit_buff_t > 0.0:
		out.append({"id": "limit", "label": "MAX", "debuff": false})
	if haste_t > 0.0:
		out.append({"id": "haste", "label": "SPD", "debuff": false})
	if recall_t > 0.0:
		out.append({"id": "recall", "label": "REC", "debuff": false})
	if buff_on() and _passives.has("sk_guard"):
		out.append({"id": "guard", "label": "DEF", "debuff": false})
	if aura_on():
		out.append({"id": "sword_aura", "label": "AUR", "debuff": false})
	if zone_t > 0.0:
		out.append({"id": "zone", "label": "ZON", "debuff": false})
	if dna_t > 0.0:
		out.append({"id": "dna", "label": "DN%d" % dna_stage, "debuff": false})
	if rm_heal_t > 0.0:
		out.append({"id": "rm_heal", "label": "HEL", "debuff": false})
	if dome_t > 0.0:
		out.append({"id": "dome", "label": "DOM", "debuff": false})
	if rm_square_t > 0.0:
		out.append({"id": "square", "label": "SQR", "debuff": false})
	if ds_form_t > 0.0:
		out.append({"id": "ds_form", "label": "FRM", "debuff": false})
	if ds_guard_t > 0.0:
		out.append({"id": "ds_guard", "label": "DEF", "debuff": false})
	if is_instance_valid(homun):
		out.append({"id": "homun", "label": "HMN", "debuff": false})
	if is_instance_valid(_aura):
		out.append({"id": "aura", "label": "FIRE", "debuff": false})
	if form_on:
		out.append({"id": "form", "label": "FORM", "debuff": false})
	return out

func buff_on() -> bool:
	return buff_t > 0.0

func attack_mult() -> float:
	var k := BUFF_ATTACK if buff_on() or attack_buff_t > 0.0 else 1.0
	if _passives.has("rk_power"):
		k *= RK_POWER
	if _passives.has("lk_power"):
		k *= LK_POWER
	if _passives.has("wv_guard"):
		k *= WV_POWER
	if ds_form_t > 0.0:
		k *= DS_FORM_ATK
	if _passives.has("rm_no_down"):
		k *= RM_NO_DOWN_ATK
	if rm_square_t > 0.0:
		k *= RM_SQUARE_ATK
	if _dna_on(3):
		k *= DNA_ATK
	return k * (POWER_PASSIVE if _passives.has("sk_power") else 1.0)

func burn_mult() -> float:
	return BURN_PASSIVE if _passives.has("mk_burn") else 1.0

func hp_max() -> float:
	var cat_bonus := CAT_GK_HP if WalkPage.chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and WalkPage.chosen_class == "GRAND KNIGHT" else 0.0
	return hp_bonus + cat_bonus + MAX_HP * (LK_HP if _passives.has("lk_power") else 1.0) + (LIMIT_EXTRA if limit_buff_t > 0.0 else 0.0)

## ปัดท่าที่เข้ามาขึ้น ไม่เสียเลือด มอนใกล้ตัวลอย แล้วจบท่า
func _parry() -> void:
	parried += 1
	invuln_t = INVULN_TIME
	var hit := {"type": "launch", "vy": PARRY_LIFT, "dmg": 12.0, "kd": 30, "skill": true}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) > PARRY_REACH or e.is_invulnerable():
			continue
		var before: float = e.hp
		var side := signf(e.pos.x - pos.x)
		if e.take_hit(hit, side if side != 0.0 else facing):
			count_hit(before - e.hp, hit)
	_spawn_fx("ram", pos + Vector2(facing * 0.9, 1.7))
	_end_attack()

func _no_monster_near() -> bool:
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) < REFLECT_NEAR and e.state != "dead":
			return false
	return true

## ปัดกลับไปทางที่การโจมตีมา dir คือทิศที่ถูกผลัก ทิศย้อนกลับจึงตรงข้าม
func _reflect(dir: float) -> void:
	reflected += 1
	invuln_t = INVULN_TIME
	var back := -dir if dir != 0.0 else facing
	var ball := FireBall.new()
	ball.hero = self
	ball.radius = REFLECT_R
	ball.dmg = REFLECT_DMG
	ball.is_skill = true
	ball.vel = Vector2(back * REFLECT_SPEED, 0.0)
	ball.pos = pos + Vector2(back * 1.2, 1.2)
	get_parent().add_child(ball)
	_spawn_fx("ram", pos + Vector2(back * 0.9, 1.5))

## โดรนลอยตามพร้อมยิงหรือไม่
func gear_ready(id: String) -> bool:
	return is_instance_valid(_gears.get(id, null))

func set_gear(id: String, gear: Node2D) -> void:
	_gears[id] = gear

func take_gear(id: String) -> Node2D:
	var gear: Node2D = _gears.get(id, null)
	_gears.erase(id)
	return gear

func drone_mult() -> float:
	return TW_POWER if _passives.has("tw_power") else 1.0

func summon_cd_mult() -> float:
	return TW_CD if _passives.has("tw_cheap") else 1.0

## 60.2 โจมตีแล้วมีโอกาสได้มานา ต่อท่าละครั้ง
func _roll_hit_mana() -> void:
	if _mana_rolled or not _passives.has("tw_hit_mana"):
		return
	_mana_rolled = true
	if randf() < TW_MANA_CHANCE:
		mp = minf(mp + TW_MANA, mp_max())
		mana_gained += 1

func basic_mult() -> float:
	return (DS_BASIC if _passives.has("ds_basic") else 1.0) * (RM_BASIC if _passives.has("rm_body") else 1.0)

## ขั้นของเกจ DNA ตอนนี้ 0 ถึง 5
func dna_stage_now() -> int:
	return clampi(int(ceil(dna_points / DNA_STEP)), 0, 5)

## กดปุ่ม V รับบัพขั้นปัจจุบันและขั้นก่อนหน้า ใช้เกจหมด
func use_dna() -> bool:
	var stage := dna_stage_now()
	if stage <= 0:
		return false
	dna_stage = stage
	dna_t = DNA_TIME
	dna_points = 0.0
	_dna_regen = DNA_REGEN_GAP
	_spawn_fx("circle_ground", Vector2(pos.x, 0.0))
	return true

func _dna_on(stage: int) -> bool:
	return dna_t > 0.0 and dna_stage >= stage

func start_ds_guard() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	ds_guard_t = DS_GUARD_TIME
	return true

func cooldown_mult() -> float:
	return (ZONE_CD if zone_t > 0.0 else 1.0) * (OP_CD if _passives.has("op_cd") else 1.0)

## เรียกทุกครั้งที่ใช้สกิลสำเร็จ
func on_skill_cast(id: String) -> void:
	if is_instance_valid(homun):
		homun.gain()
	if _passives.has("rm_dna_gauge") and id.begins_with("rm_"):
		dna_points = minf(dna_points + DNA_GAIN + (DNA_MORE if _passives.has("rm_dna_more") else 0.0), DNA_MAX)
	var kinds: Array = SkillData.ELEMENTS.get(id, [])
	if _passives.has("op_mana") and not kinds.is_empty():
		mp = minf(mp + OP_RESTORE, mp_max())
	if _passives.has("op_gauge"):
		_tick_gauges(kinds)

## เกจเต็มตั้งแต่ก่อนหน้าแล้วปล่อยสกิลธาตุนั้นฟรี จากนั้นค่อยเพิ่มเกจของสกิลนี้
func _tick_gauges(kinds: Array) -> void:
	for k in gauges:
		if float(gauges[k]) >= GAUGE_FULL:
			gauges[k] = 0.0
			gauge_bursts += 1
			match k:
				"fire": OmniSkill.fire_cross(self)
				"elec": OmniSkill.elec_ball(self)
				"ice": OmniSkill.ice_drops(self)
	for k in kinds:
		gauges[k] = minf(float(gauges[k]) + OP_GAIN, GAUGE_FULL)

func start_haste() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	haste_t = HASTE_TIME
	return true

func start_homun() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	if is_instance_valid(homun):
		homun.queue_free()
	homun = Homunculus.new()
	homun.hero = self
	get_parent().add_child(homun)
	return true

func start_poison_coat() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	coat_kind = "poison"
	coat_t = COAT_TIME
	return true

func aura_on() -> bool:
	return sword_aura_t > 0.0

## ระยะของสกิลที่เพิ่มตามออร่าดาบ หน่วยโลก
func skill_reach_bonus() -> float:
	return AURA_SKILL_BONUS if aura_on() else 0.0

## 35.4 ตีแล้วมีโอกาสปล่อยคลื่นดาบ ต่อท่าละครั้ง
func _roll_sword_wave() -> void:
	if _wave_rolled or _weapon != "sword" or not _passives.has("lk_wave"):
		return
	_wave_rolled = true
	if randf() >= WAVE_CHANCE:
		return
	var wave := SwordWave.new()
	wave.hero = self
	wave.dir = facing
	wave.x = pos.x + facing * 1.2
	wave.dmg = WAVE_BASE_DMG * attack_mult() * WAVE_POWER
	get_parent().add_child(wave)
	waves_sent += 1

## เคลือบอาวุธด้วยไฟน้ำแข็งหรือไฟพิษแบบสุ่ม
func start_coat() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	var kinds := ["ice", "poison"]
	if _passives.has("wv_elements"):
		kinds.append_array(["water", "elec", "wind"])
	coat_kind = kinds[randi() % kinds.size()]
	coat_t = COAT_TIME
	return true

func start_shout_buff() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	shout_buff_t = SHOUT_BUFF_TIME
	shout_count = 0
	return true

## ทุกการตะโกนนับหนึ่ง บัพอยู่และครบ 5 ครั้ง ฟื้นมานา
func on_shout() -> void:
	if shout_buff_t <= 0.0:
		return
	shout_count += 1
	if shout_count % SHOUT_EVERY == 0:
		mp = minf(mp + SHOUT_MP, mp_max())

func start_limit_buff() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	limit_buff_t = LIMIT_TIME
	return true

## โยนขวดยา 3 ขวดในฟองสบู่ลงพื้น เก็บได้อันเดียว
func start_bubbles() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	var kinds := ["red", "mana"]
	if _passives.has("le_cost"):
		kinds.append("cost")
	for i in kinds.size():
		var bubble := PotionBubble.new()
		bubble.hero = self
		bubble.kind = kinds[i]
		bubble.x = clampf(pos.x + facing * (BUBBLE_AHEAD + float(i) * BUBBLE_GAP), -half_width, half_width)
		get_parent().add_child(bubble)
	return true

func apply_potion(kind: String) -> void:
	match kind:
		"red": red_t = POTION_TIME
		"mana": regen_buff_t = POTION_TIME
		"cost": mana_buff_t = POTION_TIME

## จดจำเลือดและมานาตอนนี้ ตายแล้วฟื้นกลับมาตามนี้
func start_recall() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	recall_t = RECALL_TIME
	_recall_hp = hp
	_recall_mp = mp
	return true

func skill_mult() -> float:
	return (SKILL_BUFF_MULT if skill_buff_t > 0.0 else 1.0) * (ZONE_SKILL if zone_t > 0.0 else 1.0) * (DNA_SKILL if _dna_on(4) else 1.0)

func mp_max() -> float:
	var extra := MP_PASSIVE if _passives.has("hm_ball_up") else 0.0
	if _passives.has("rk_mana"):
		extra += RK_MANA
	if limit_buff_t > 0.0:
		extra += LIMIT_EXTRA
	if WalkPage.chosen_weapon in ["cat", "mage", "bow", "spear", "azure", "fist"] and WalkPage.chosen_class in ["DARK KNIGHT", "CRIMSON KNIGHT"]:
		extra += CAT_DK_MP
	return mp_bonus + MAX_MP + extra + (KD_PASSIVE_MP if _passives.has("sc_kd_down") else 0.0) + (OP_MP if _passives.has("op_mana") else 0.0) + (LE_MP if _passives.has("le_mana") else 0.0) + (RM_MP if _passives.has("rm_mana") else 0.0)

func has_passive(id: String) -> bool:
	return _passives.has(id)

## สกิลติดตัวเสริมลูกบอลไฟ แรงขึ้น ใหญ่ขึ้น ไกลขึ้น
func boost_ball(ball: FireBall) -> void:
	if _passives.has("wv_ball_up") and ball.kind == "fire":
		ball.radius *= WV_BALL_SIZE
	if not _passives.has("hm_ball_up") or ball.kind != "fire":
		return
	ball.dmg *= BALL_UP_DMG
	ball.radius *= BALL_UP_SIZE
	ball.life_mult *= BALL_UP_LIFE

func start_skill_buff() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	skill_buff_t = SKILL_BUFF_TIME
	return true

func start_regen_buff() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	regen_buff_t = REGEN_BUFF_TIME
	return true

func speed_mult() -> float:
	var k := (BUFF_SPEED if buff_on() else 1.0) * speed_bonus
	if haste_t > 0.0:
		k *= HASTE_MULT
	if ds_form_t > 0.0:
		k *= DS_FORM_SPEED
	if _dna_on(2):
		k *= DNA_SPEED
	if _passives.has("ds_mana_speed"):
		k *= 1.0 + DS_MANA_SPEED * clampf(mp / mp_max(), 0.0, 1.0)
	return k

## เปิดบัพ 20 วินาที
func start_buff() -> void:
	buff_t = BUFF_TIME

## สกิลกลิ้งตัว
func start_roll() -> void:
	start_skill_move(SkillData.ROLL_MOVE.duplicate(true))

## ออกสกิลเป็นท่าปกติ กำลังออกท่าอื่นอยู่หรือโดนตีอยู่ไม่ออก
func start_skill_move(m: Dictionary) -> bool:
	if attacking or hp <= 0.0 or hurt_t > 0.0:
		return false
	if input_dir != 0.0:
		facing = input_dir
	chain = ""
	_begin_move(m, "")
	return true

## มอนที่ตกเป็นเป้าและอยู่ในระยะเกือบครึ่งจอ ไม่มีคืนค่าว่าง
func marked_near() -> Node2D:
	var world_scale: float = get_parent().scale.x
	var reach: float = get_viewport_rect().size.x * MARK_FOLLOW / (CombatData.UNIT * world_scale)
	var best: Node2D = null
	var best_d := reach
	for e in get_tree().get_nodes_in_group("monsters"):
		var d: float = absf(e.pos.x - pos.x)
		if e.mark_t > 0.0 and d <= best_d:
			best_d = d
			best = e
	return best

## เสามิติ วางครั้งแรก กดซ้ำวาปกลับมาที่เสาแล้วเสาหาย คืนค่าว่าครั้งนี้เป็นการวางหรือไม่
func toggle_pillar() -> bool:
	if is_instance_valid(_pillar):
		_spawn_fx("gate", pos + Vector2(0.0, 1.1))
		pos = Vector2(_pillar.pos_x, 0.0)
		vel = Vector2.ZERO
		_spawn_fx("gate", pos + Vector2(0.0, 1.1))
		_pillar.burst(pos.x)
		_pillar.queue_free()
		_pillar = null
		_place()
		return false
	var pillar := DimPillar.new()
	pillar.hero = self
	pillar.pos_x = pos.x
	get_parent().add_child(pillar)
	_pillar = pillar
	return true

func pillar_placed() -> bool:
	return is_instance_valid(_pillar)

func start_attack_buff() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	attack_buff_t = ATTACK_BUFF_TIME
	return true

## สั่งโดรนไปจุดนั้นทันที ใช้ระหว่างสกิลหยุดเวลา
func set_drone_goal(goal: String) -> void:
	_drone_goal = goal
	_drone_k = 1.0

## มานาที่สกิลนี้ใช้ตอนกด บัพลดมานาไม่ช่วยสกิลกดค้าง
func skill_cost(s: Dictionary) -> float:
	var cost := float(s.get("mp", 0.0))
	# กดครั้งที่สองของโดรนลอยตาม ไม่เสียมานา
	if gear_ready(str(s.get("id", ""))):
		return 0.0
	if s.get("summon", false) and _passives.has("tw_cheap"):
		cost *= TW_COST
	if str(s.get("id", "")) == "gwen_blink" and _passives.has("ds_blink_cheap"):
		cost *= DS_BLINK_COST
	if mana_buff_t > 0.0 and not s.get("mp_hold", false):
		cost *= MANA_BUFF_COST
	if limit_buff_t > 0.0:
		cost *= LIMIT_COST
	if aura_on() and _passives.has("lk_aura_mana"):
		cost *= AURA_COST
	if dome_t > 0.0:
		cost *= RM_DOME_COST
	return cost

## วาปตามทิศที่กำลังเคลื่อนไหว
func blink() -> void:
	if hp <= 0.0 or hurt_t > 0.0:
		return
	var dir := Vector2(input_dir, 0.0)
	if jump_held or vel.y > 1.0:
		dir.y = 1.0
	elif down_held or vel.y < -1.0:
		dir.y = -1.0
	if dir == Vector2.ZERO:
		dir.x = facing
	if attacking:
		_end_attack()
	_spawn_fx("warp", pos + Vector2(0.0, 1.2))
	pos += dir.normalized() * BLINK_LONG
	pos.x = clampf(pos.x, -half_width, half_width)
	pos.y = maxf(pos.y, 0.0)
	vel = Vector2.ZERO
	if dir.x != 0.0:
		facing = signf(dir.x)
	_spawn_fx("warp", pos + Vector2(0.0, 1.2))
	_place()

func start_fire_aura() -> void:
	var aura := FireAura.new()
	aura.hero = self
	if is_instance_valid(_aura):
		_aura.queue_free()
	_aura = aura
	get_parent().add_child(aura)

func start_mana_buff() -> bool:
	if not start_skill_move(SkillData.MANA_MOVE.duplicate(true)):
		return false
	mana_buff_t = MANA_BUFF_TIME
	return true

## ท่านี้ไม่ชะงัก ขอบตัวเป็นสีแดง
func super_armor() -> bool:
	if plain and plain_sa_t > 0.0:
		return true
	if plain and plain_swing > 0.0 and plain_swing_kind == "combo" and plain_move.get("sa", false):
		return true
	if buff_on() or red_t > 0.0 or barrier_t > 0.0:
		return true
	return attacking and cur_move.get("sa", false) and attack_t < float(cur_move.get("sa_until", INF))

func _hold_on() -> bool:
	return held_keys.get(str(cur_move.get("hold", "")), false)

## หมุนตัว: ตัวแคบลงตามมุม เหมือนหมุนรอบแกนตั้ง
func _flip_x() -> float:
	var c := cos(_spin + _attack_spin)
	var k := absf(c)
	return facing * maxf(k, 0.12) * (1.0 if c >= 0.0 else -1.0)

## มีหนังสือลอยตามอยู่หรือไม่
func has_book() -> bool:
	return _has_book

func book_flip() -> float:
	return _flip_t

func book_pos() -> Vector2:
	return _book_pos

func _update_book(delta: float) -> void:
	if not _has_book:
		return
	_flip_t = fposmod(_flip_t + delta / BOOK_FLIP_TIME, 1.0)
	var want := pos + Vector2(BOOK_OFFSET.x * facing, BOOK_OFFSET.y + sin(_clock * 2.2) * BOOK_BOB)
	if not _book_ready:
		_book_ready = true
		_book_pos = want
	_book_pos = _book_pos.lerp(want, minf(BOOK_FOLLOW * delta, 1.0))

func _physics_process(delta: float) -> void:
	_clock += delta
	_update_book(delta)
	buff_t = maxf(buff_t - delta, 0.0)
	mana_buff_t = maxf(mana_buff_t - delta, 0.0)
	attack_buff_t = maxf(attack_buff_t - delta, 0.0)
	skill_buff_t = maxf(skill_buff_t - delta, 0.0)
	coat_t = maxf(coat_t - delta, 0.0)
	shout_buff_t = maxf(shout_buff_t - delta, 0.0)
	haste_t = maxf(haste_t - delta, 0.0)
	red_t = maxf(red_t - delta, 0.0)
	sword_aura_t = maxf(sword_aura_t - delta, 0.0)
	zone_t = maxf(zone_t - delta, 0.0)
	barrier_t = maxf(barrier_t - delta, 0.0)
	dome_t = maxf(dome_t - delta, 0.0)
	rm_square_t = maxf(rm_square_t - delta, 0.0)
	if rm_heal_t > 0.0:
		rm_heal_t = maxf(rm_heal_t - delta, 0.0)
		hp = minf(hp + RM_HEAL_RATE * delta, hp_max())
		mp = minf(mp + RM_HEAL_RATE * delta, mp_max())
	if dna_t > 0.0:
		dna_t = maxf(dna_t - delta, 0.0)
		_dna_regen -= delta
		if _dna_regen <= 0.0:
			_dna_regen = DNA_REGEN_GAP
			mp = minf(mp + DNA_REGEN, mp_max())
	ds_form_t = maxf(ds_form_t - delta, 0.0)
	ds_guard_t = maxf(ds_guard_t - delta, 0.0)
	if aura_on() and _passives.has("lk_aura_mana"):
		mp = minf(mp + AURA_REGEN * delta, mp_max())
	recall_t = maxf(recall_t - delta, 0.0)
	if limit_buff_t > 0.0:
		limit_buff_t = maxf(limit_buff_t - delta, 0.0)
		if limit_buff_t <= 0.0:
			hp = minf(hp, hp_max())
			mp = minf(mp, mp_max())
	regen_buff_t = maxf(regen_buff_t - delta, 0.0)
	if regen_buff_t > 0.0:
		mp = minf(mp + REGEN_BUFF_RATE * delta, mp_max())
	mp = minf(mp + MP_REGEN * regen_mult * delta, mp_max())
	if locked:
		_place()
		queue_redraw()
		return
	var now := Time.get_ticks_msec() / 1000.0
	var dir := input_dir
	var jump_pressed := jump_held and not _prev_jump
	_prev_jump = jump_held

	# กดทิศซ้ำ 2 ครั้ง = แดช
	var dash_started := false
	if dir != 0.0 and _last_dir == 0.0:
		if dir == _last_tap_dir and now - _last_tap_time < DOUBLE_TAP and _can_dash():
			dash_t = DASH_TIME
			dash_dir = dir
			dash_started = true
		_last_tap_dir = dir
		_last_tap_time = now
	_last_dir = dir
	# ดันจอยสุดขอบ ออกวิ่งทันทีโดยไม่ต้องแตะสองที
	if run_push and dir != 0.0 and dash_t <= 0.0 and _can_dash():
		dash_t = DASH_TIME
		dash_dir = dir
		dash_started = true
	if run_push and dash_t > 0.0:
		_push_run = true
	# วิ่งจากดันจอยสุดขอบ ปล่อยจอยแล้วหยุดวิ่งทันที
	if _push_run and dir == 0.0:
		dash_t = 0.0
	if dash_t <= 0.0:
		_push_run = false
	if dash_t > 0.0:
		if dir == dash_dir and not attacking:
			dash_t = DASH_TIME
		else:
			dash_t -= delta
			if dir != 0.0 and dir != dash_dir:
				dash_t = 0.0

	queued_t -= delta
	if queued_t <= 0.0:
		queued = ""

	# ถึงพื้นแล้ว: จบคอมโบอากาศ
	if not _airborne():
		air_used = false
		air_dash_used = false
		jump_dashed = false
		if chain.contains("^") and not _plunge_keeps_chain():
			chain = ""

	# ตีกลางอากาศ หยุดลอยนิ่งจนจบคอมโบหรือหมดเวลาต่อคอมโบ
	if not on_floor():
		if _air_float():
			vel.y = 0.0
		else:
			vel.y -= GRAVITY * delta * _plain_gravity() * gravity_k

	if combo_count > 0:
		combo_t -= delta
		if combo_t <= 0.0:
			combo_count = 0
			combo_dmg = 0.0

	invuln_t -= delta
	flash_t = maxf(flash_t - delta, 0.0)
	if hurt_t > 0.0:
		hurt_t -= delta
		queued = ""
		vel.x = move_toward(vel.x, 0.0, 12.0 * delta)
		_finish_move(delta)
		return

	if attacking:
		_tick_attack(delta, dash_started, jump_pressed)
	else:
		chain_t -= delta
		if chain_t <= 0.0:
			chain = ""
		if _free_fall():
			vel.x = move_toward(vel.x, 0.0, FREE_FALL_DRAG * delta)
		else:
			vel.x = dir * SPEED * speed_mult() * (DASH_MULT if dash_t > 0.0 else 1.0)
			# ช่วงต่อคอมโบกดถอยหลังไม่หันตัว ไม่งั้นท่ากดถอยหลังจะออกไม่ได้
			if dir != 0.0 and not (dir == -facing and _back_step_open()):
				facing = dir
		if jump_pressed and on_floor():
			_jump()
		if queued != "":
			_try_attack()
	_finish_move(delta)

func _tick_attack(delta: float, dash_started: bool, jump_pressed: bool) -> void:
	var lt0 := move_dur * cur_wind
	attack_t += delta * speed_mult() * (ST_SPEED if _passives.has("st_speed") else 1.0) * (DNA_ATK_SPEED if _dna_on(5) else 1.0)
	if not active_done and attack_t >= active_t0:
		_active_frame()
	if cur_move.has("tick") and attack_t >= active_t0:
		_tick_hit(delta)
	_shot_tick()
	if cur_move.get("tether", false):
		_tether_tick(delta)
	if cur_move.has("meteor_gap"):
		_meteor_tick(delta)
	# ปล่อยปุ่มแล้วท่ากดค้างจบ ต่อท่าถัดไปได้
	if cur_move.has("hold") and attack_t >= float(cur_move["hold_min"]) and not _hold_on():
		attack_dur = minf(attack_dur, attack_t + 0.08)
	var lt1 := maxf(move_dur * (cur_wind + 0.35), active_t1)
	if cur_move.get("pierce", false):
		_pierce_check(lt0)
	if cur_move.has("hop_back") and _airborne():
		vel.x = -facing * float(cur_move["hop_back"])
	if cur_move.has("rise") and attack_t >= lt0 and attack_t < lt1:
		vel.y = float(cur_move["rise"])
	# ท่าดิ่งลง พ้นช่วงง้างแล้วพุ่งลงพื้นทันที
	if cur_move.get("spin", 1.0) == 0.0:
		_attack_spin = 0.0
	if cur_move.has("plunge") and attack_t >= lt0 and not on_floor():
		vel.y = -float(cur_move["plunge"])
	if pierced:
		vel.x = 0.0
	elif cur_move.get("pierce", false) and not pierce_ahead.is_empty() and attack_t >= lt0 and attack_t < move_dur * 0.95:
		vel.x = lunge_v
	elif cur_move.has("hold") and attack_t >= lt0 and _hold_on():
		vel.x = lunge_v
	elif attack_t >= lt0 and attack_t < lt1:
		vel.x = lunge_v
	else:
		vel.x = move_toward(vel.x, 0.0, 40.0 * delta)
	# ท่าดิ่งลงเฉียง ถึงตัวมอนแล้วหยุดไปต่อ จะได้กระแทกตรงตัว
	if cur_move.has("plunge") and _monster_just_ahead():
		vel.x = 0.0
	# ยกเลิกท่าหลังโดนตี
	var cancel_ok := attack_t >= move_dur * (cur_wind + 0.25)
	if dash_started and not cancel_ok:
		dash_t = 0.0
	var cancel_jump := cancel_ok and jump_pressed and on_floor()
	if (cancel_ok and dash_started) or cancel_jump:
		_end_attack()
		if dash_started:
			chain = ""
			dash_t = DASH_TIME
		if cancel_jump:
			_jump()
	elif attack_t >= attack_dur:
		_end_attack()
		chain_t = CHAIN_WINDOW
	elif queued != "" and active_done and (_can_chain(queued) or _landed_from_air_move()):
		_try_attack()

func _spawn_fx(kind: String, at: Vector2) -> void:
	if plain:
		return
	var fx := ImpactFx.new()
	fx.kind = kind
	fx.pos = at
	get_parent().add_child(fx)

## เส้นวิ่งหลังตัวตอนกำลังพุ่งชน
func _draw_ram_lines() -> void:
	if absf(vel.x) < 2.0:
		return
	for i in RAM_LINES.size():
		var y := float(RAM_LINES[i][0])
		var long := float(RAM_LINES[i][1])
		var shift := sin(_clock * 40.0 + float(i) * 2.0) * RAM_SHIFT
		var from := -RAM_GAP + shift
		Sketch.line(self, PackedVector2Array([Vector2(from, y), Vector2(from - long, y)]), 240 + i, 3.0, 0.5, _ink())

## DIMENSION STRIKE ตอนพุ่งด้วยคทา มีพลังมิติเล็กๆ รอบตัว
func _dim_aura_on() -> bool:
	return _staff_heart and attacking and absf(vel.x) >= AURA_MIN_SPEED

func _draw_dim_aura(body_y: float) -> void:
	for n in AURA_DOTS:
		var a := _clock * 7.0 + TAU * n / AURA_DOTS
		var at := Vector2(cos(a) * AURA_RX, body_y + sin(a) * AURA_RY)
		var r := 3.0 + 2.2 * absf(sin(float(n) * 1.9))
		draw_circle(at, r, Color.WHITE if n % 2 == 0 else DimDust.PINK)
		draw_arc(at, r, 0.0, TAU, 8, DimDust.EDGE, 1.0, true)

## ลมพัดเป็นเส้นคลื่นวิ่งไปข้างหน้า ปลายม้วน
func _draw_wind(body_y: float) -> void:
	for n in WIND_LINES:
		var run := fposmod(_clock * 2.6 + float(n) * 0.27, 1.0)
		var start := 60.0 + run * WIND_LONG
		var y := body_y - 48.0 + float(n) * 32.0
		var pts := PackedVector2Array()
		for k in 11:
			var t := float(k) / 10.0
			pts.append(Vector2(start + t * 90.0, y + sin(t * TAU + float(n)) * 8.0))
		for k in 7:
			var a := -PI * 0.5 + TAU * 0.8 * float(k) / 6.0
			pts.append(Vector2(start + 90.0, y - 11.0) + Vector2(cos(a), sin(a)) * 11.0)
		Sketch.line(self, pts, 250 + n, 2.6, 0.2, _ink())

## ตรึงมอนในวงเวท ไม่จำกัดจำนวน
func _root_monsters(reach: float, time: float) -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) <= reach and absf(e.pos.y - pos.y) <= reach:
			e.root_t = time

func _monster_just_ahead() -> bool:
	for e in get_tree().get_nodes_in_group("monsters"):
		var dx: float = (e.pos.x - pos.x) * facing
		if dx > -0.2 and dx < PLUNGE_STOP:
			return true
	return false

## วาปลงพื้น หรือวาปขึ้นเหนือมอนตัวใกล้สุดด้านหน้า ไม่มีมอนในระยะก็ตีตรงนั้น
func _warp(mode: String) -> void:
	var to := pos
	if mode == "down":
		to = Vector2(pos.x, 0.0)
	elif mode == "rift":
		if not is_instance_valid(_rift):
			to = Vector2(pos.x, 0.0)
		else:
			to = Vector2(_rift.pos.x, 0.0)
			_rift.queue_free()
			_rift = null
	else:
		var best := _nearest_ahead(WARP_REACH)
		if best == null:
			return
		to = Vector2(best.pos.x - facing * WARP_NEAR, WARP_HIGH)
	_spawn_fx("warp", pos + Vector2(0.0, 1.2))
	pos = to
	vel = Vector2.ZERO
	_spawn_fx("warp", pos + Vector2(0.0, 1.2))

## ยิงหรือสั่งระเบิดลูกบอลไฟ ครั้งเดียวต่อท่า ท่าทะลุยิงตอนชนมอน
func _shot_tick() -> void:
	if plain:
		return
	if _shot_done or not (cur_move.has("shot") or cur_move.has("shots") or cur_move.get("detonate", false) or cur_move.get("dust_gather", false) or cur_move.get("rift_boom", false)):
		return
	if cur_move.get("pierce", false):
		if not pierced and attack_t < move_dur * 0.7:
			return
	elif attack_t < active_t0:
		return
	_shot_done = true
	if cur_move.get("rift_boom", false):
		if is_instance_valid(_rift):
			_rift.explode()
			_rift = null
		return
	if cur_move.get("dust_gather", false):
		if is_instance_valid(_dust):
			_dust.gather()
		return
	if cur_move.get("detonate", false):
		if is_instance_valid(_ball):
			_ball.detonate()
		return
	if cur_move.get("turn_shot", false):
		facing = -facing   # หันหลังกลับไปยิงใส่มอนที่เพิ่งวิ่งทะลุ
	if cur_move.has("shot"):
		_fire(cur_move["shot"])
	for one in cur_move.get("shots", []):
		_fire(one)

## รอยแยกเล็กหน้ามือ กดเดินหน้าแล้วรอยแยกไปต่อ ตัวเราอยู่กับที่ ทำดาเมจเป็นจังหวะ
## ฉีกมิติ รอยแยกตามตัวไปตามที่เดิน ตัวละครไม่ต้องหยุด
func start_tear() -> bool:
	if is_instance_valid(_rift):
		_rift.queue_free()
	_rift = TimeRift.new()
	_rift.hero = self
	_rift.follow = true
	_rift.follow_dmg = TEAR_DMG
	_rift.follow_near = TEAR_NEAR
	_rift.pos = pos + Vector2(facing * TEAR_NEAR, 1.2)
	get_parent().add_child(_rift)
	return true

## ลอยค้าง ปล่อยลูกไฟหลายขนาดตกด้านหน้า มานาลดเรื่อยๆ หมดมานาก็จบท่า
func _meteor_tick(delta: float) -> void:
	pos.y = move_toward(pos.y, float(cur_move["hover"]), METEOR_RISE * delta)
	vel.y = 0.0
	mp = maxf(mp - float(cur_move["mp_drain"]) * delta - MP_REGEN * delta, 0.0)
	if mp <= 0.0:
		attack_dur = minf(attack_dur, attack_t + 0.08)
		return
	_meteor_wait -= delta
	if _meteor_wait > 0.0:
		return
	_meteor_wait = float(cur_move["meteor_gap"])
	_meteor_n += 1
	var pick := absf(sin(float(_meteor_n) * 12.9))
	var ball := FireBall.new()
	ball.hero = self
	ball.radius = lerpf(METEOR_SMALL, METEOR_BIG, pick)
	ball.dmg = lerpf(5.0, 14.0, pick)
	var ahead := lerpf(1.5, 8.0, absf(sin(float(_meteor_n) * 7.3)))
	ball.pos = Vector2(pos.x + facing * ahead, METEOR_HIGH)
	ball.vel = Vector2(facing * 2.5, -METEOR_SPEED)
	ball.is_skill = true
	boost_ball(ball)
	get_parent().add_child(ball)

## เส้นไฟฟ้าล็อคมอนตัวใกล้สุดด้านหน้า ช็อตเล็กๆ และดึงเข้าหาตัวเรื่อยๆ
func _tether_tick(delta: float) -> void:
	if attack_t < active_t0:
		return
	if not is_instance_valid(_tether) or _tether.is_invulnerable():
		_tether = _nearest_ahead(TETHER_REACH)
	if _tether == null:
		return
	var side := signf(_tether.pos.x - pos.x)
	_tether.pos.x = move_toward(_tether.pos.x, pos.x + side * TETHER_STOP, TETHER_PULL * delta)
	_tether_wait -= delta
	if _tether_wait <= 0.0:
		_tether_wait = TETHER_GAP
		var hit := {"type": "flinch", "dmg": TETHER_DMG, "kb": 0.0, "stun": 0.4}
		var hp_before: float = _tether.hp
		if _tether.take_hit(hit, -side):
			_count_hit(hp_before - _tether.hp, hit)

## ปล่อยปุ่ม มอนที่ล็อคอยู่ดีดลอยนิดนึง
func _tether_release() -> void:
	if not cur_move.get("tether", false) or not is_instance_valid(_tether):
		_tether = null
		return
	var hit := {"type": "launch", "vy": TETHER_POP, "dmg": TETHER_DMG, "kd": 10}
	var hp_before: float = _tether.hp
	if _tether.take_hit(hit, facing):
		_count_hit(hp_before - _tether.hp, hit)
	_tether = null

func _nearest_ahead(reach: float) -> Node2D:
	var best: Node2D = null
	var best_dx := reach
	for e in get_tree().get_nodes_in_group("monsters"):
		var dx: float = (e.pos.x - pos.x) * facing
		if dx >= 0.0 and dx <= best_dx and not e.is_invulnerable():
			best_dx = dx
			best = e
	return best

## เส้นไฟฟ้าหยักจากมือถึงมอน
func _draw_tether(body_y: float) -> void:
	var hand := HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5) + Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT
	var to := Vector2((_tether.pos.x - pos.x) * facing, -(_tether.pos.y + 1.0 - pos.y)) * CombatData.UNIT
	var pts := PackedVector2Array()
	for n in 9:
		var t := float(n) / 8.0
		var jag := sin(_clock * 45.0 + float(n) * 2.7) * 9.0 * (1.0 if n > 0 and n < 8 else 0.0)
		pts.append(hand.lerp(to, t) + Vector2(0.0, jag))
	draw_polyline(pts, ElecWave.COLOR, 5.0, true)
	draw_polyline(pts, ElecWave.ARC, 2.0, true)

## ปล่อยของออกจากตัว ลูกบอลไฟ ขวดยา เปลวไฟตามพื้น หรือน้ำแข็ง
func _fire(s: Dictionary) -> void:
	match str(s.get("type", "ball")):
		"potion":
			var bottle := PotionBottle.new()
			bottle.hero = self
			bottle.dmg = float(s["dmg"])
			bottle.pos = pos + Vector2(facing * 0.7, 1.3)
			if s.has("from"):
				var from: Vector2 = s["from"]
				bottle.pos = Vector2(pos.x + facing * from.x, from.y)
			bottle.delay = float(s.get("delay", 0.0))
			bottle.hit_monster = s.get("hit_monster", false)
			bottle.vel = Vector2(float(s["vx"]) * facing, float(s["vy"]))
			bottle.smoke_life = float(s.get("smoke_life", SmokeCloud.SHORT_LIFE))
			bottle.smoke_tick = float(s.get("smoke_tick", 0.0))
			bottle.smoke_wide = float(s.get("smoke_wide", 1.0))
			get_parent().add_child(bottle)
		"ground_flame":
			var flame := GroundFlame.new()
			flame.hero = self
			flame.dmg = float(s["dmg"])
			flame.reach = float(s.get("reach", 5.5))
			flame.dir = facing
			flame.kind = str(s.get("kind", "fire"))
			flame.is_skill = s.get("skill", false)
			flame.x = pos.x + facing * 0.9
			get_parent().add_child(flame)
		"dim_dust":
			var dust := DimDust.new()
			dust.hero = self
			dust.scatter_dmg = float(s["dmg"])
			dust.center = Vector2(pos.x + facing * float(s["ahead"]), DimDust.MID_Y)
			get_parent().add_child(dust)
			_dust = dust
		"smoke":
			var cloud := SmokeCloud.new()
			cloud.hero = self
			cloud.pos = Vector2(pos.x + facing * float(s["ahead"]), 0.0)
			cloud.drift = facing * float(s["drift"])
			cloud.life = float(s["life"])
			cloud.tick_dmg = float(s["tick"])
			cloud.burn = str(s.get("burn", ""))
			cloud.fill = s.get("fill", SmokeCloud.FILL)
			get_parent().add_child(cloud)
		"horn":
			var horns := HornDrones.new()
			horns.hero = self
			get_parent().add_child(horns)
		"spin_top":
			var top := SpinTop.new()
			top.hero = self
			top.dmg = float(s["dmg"])
			top.dir = facing
			top.pos = pos + Vector2(facing * 0.9, 1.0)
			top.vel = Vector2(facing * float(s.get("vx", 6.0)), float(s.get("vy", 1.5)))
			top.small = s.get("small", false)
			top.slide_time = float(s.get("slide", SpinTop.SLIDE_TIME))
			if top.vel.x != 0.0:
				top.dir = signf(top.vel.x)
			get_parent().add_child(top)
		"needle":
			var needle := NeedleShot.new()
			needle.hero = self
			needle.dmg = float(s["dmg"])
			needle.extra_hit = s.get("extra", {})
			needle.dir = facing
			needle.pos = pos + Vector2(facing * 0.9, 1.1)
			get_parent().add_child(needle)
		"time_rift":
			# มีได้อันเดียว สร้างใหม่แล้วอันเก่าหาย
			if is_instance_valid(_rift):
				_rift.queue_free()
			var rift := TimeRift.new()
			rift.hero = self
			rift.open_dmg = float(s["dmg"])
			rift.slant = float(s.get("slant", 0.0)) * facing
			var rift_y := 0.6 if s.get("ground", false) else pos.y + 1.1
			rift.pos = Vector2(pos.x + facing * float(s["ahead"]), rift_y)
			get_parent().add_child(rift)
			_rift = rift
		"rift_push":
			var behind := _nearest_ahead(RIFT_PUSH_REACH)
			var push := TimeRift.new()
			push.hero = self
			push.open_dmg = 0.0
			if behind == null:
				push.pos = Vector2(pos.x + facing * 3.0, 1.2)
			else:
				push.pos = Vector2(behind.pos.x + facing * 1.1, behind.pos.y + 1.0)
				push.push_target = behind
				var hit := {"type": "flinch", "dmg": float(s["dmg"]), "kb": 0.0, "kb_air": 0.0, "air_lift": -1.0, "air_stall": 0.0}
				var hp_before: float = behind.hp
				if behind.take_hit(hit, -facing):
					_count_hit(hp_before - behind.hp, hit)
			get_parent().add_child(push)
		"elec_wave":
			var d: Vector2 = s["dir"]
			var wave := ElecWave.new()
			wave.hero = self
			wave.dmg = float(s["dmg"])
			wave.extra_hit = s.get("extra", {})
			wave.vel = Vector2(d.x * facing, d.y).normalized() * WAVE_SPEED
			wave.pos = Vector2(pos.x + facing * 1.0, pos.y + 0.3)
			if s.get("from_foot", false):
				wave.pos = Vector2(pos.x, pos.y + 0.1)
			get_parent().add_child(wave)
		"ice_hook":
			var hook := IceHook.new()
			hook.hero = self
			hook.dmg = float(s["dmg"])
			get_parent().add_child(hook)
		_:
			var d: Vector2 = s["dir"]
			var ball := FireBall.new()
			ball.hero = self
			ball.kind = str(s.get("kind", "fire"))
			ball.burn = str(s.get("burn", ""))
			ball.dmg = float(s["dmg"])
			ball.holding = s.get("holding", false)
			ball.pierce = s.get("pierce", false)
			ball.touch_dmg = float(s.get("touch_dmg", 0.0))
			ball.extra_hit = s.get("extra", {})
			ball.radius = float(s.get("radius", FireBall.BALL_R))
			ball.is_skill = s.get("skill", false)
			boost_ball(ball)
			ball.vel = Vector2(d.x * facing, d.y).normalized() * float(s["speed"])
			ball.pos = pos + Vector2(signf(ball.vel.x) * 1.0, 1.0)
			get_parent().add_child(ball)
			if ball.holding:
				_ball = ball

## ท่าตีซ้ำ ล้างรายชื่อที่โดนแล้วตีใหม่ตามจังหวะ
func _tick_hit(delta: float) -> void:
	_tick_wait -= delta
	if _tick_wait > 0.0 or _tick_left <= 0:
		return
	already_hit.clear()
	_do_hit(cur_move)
	_tick_wait = float(cur_move["tick"])
	_tick_left -= 1

func _finish_move(delta: float) -> void:
	var from_x: float = pos.x
	var from_y: float = pos.y
	pos += vel * delta
	# ตกลงมาเจอแท่นลอย ยืนบนแท่น
	if vel.y <= 0.0:
		for p in platforms:
			var top := float(p[2])
			if pos.x >= float(p[0]) and pos.x <= float(p[1]) and from_y >= top - 0.01 and pos.y <= top:
				pos.y = top
				vel.y = 0.0
				break
	var g := ground_at(pos.x)
	if pos.y <= g:
		pos.y = g
		if vel.y < 0.0:
			vel.y = 0.0
	elif ground_fn.is_valid() and vel.y <= 0.0 and from_y <= ground_at(from_x) + 0.02 and pos.y - g < 0.5:
		# เดินลงทางลาด ติดพื้นไว้ ไม่ลอยหลุดเป็นช่วงตก
		pos.y = g
		vel.y = 0.0
	_push_out_of_monsters(delta, from_x)
	pos.x = clampf(pos.x, -half_width, half_width)
	_update_pose(delta)
	_place()
	queue_redraw()

func _jump() -> void:
	vel.y = JUMP_VELOCITY
	jump_dashed = dash_t > 0.0
	air_dash_used = jump_dashed

func _can_dash() -> bool:
	if on_floor():
		return true
	if air_used or air_dash_used:
		return false
	air_dash_used = true
	return true

func _air_float() -> bool:
	if not chain.contains("^"):
		return false
	if attacking:
		return not (CombatData.is_final(chain) and active_done)
	return chain_t > 0.0 and not CombatData.is_final(chain)

func _free_fall() -> bool:
	return air_used and _airborne() and not attacking and not _air_float()

## กันตัวกับมอนเฉพาะแกน X และเฉพาะตอนอยู่บนพื้นทั้งคู่
## กลางอากาศผ่านตัวกันได้ ตกลงมาทับก็ถูกผลักออกข้าง ยืนบนหัวไม่ได้
## เดินเร็วแค่ไหนก็ไม่ทะลุ เฟรมเดียวเคลื่อนเข้าตัวมอนจะหยุดที่ขอบตัวมอนทันที
func _push_out_of_monsters(delta: float, from_x: float) -> void:
	if plain_ghost or not on_floor() or (attacking and (cur_move.get("pierce", false) or cur_move.get("ghost", false))):
		return
	for e in get_tree().get_nodes_in_group("monsters"):
		if not e.on_floor():
			continue
		# อยู่คนละชั้น (มอนบนแท่นลอย เราอยู่ล่าง หรือกลับกัน) ไม่กันตัวกัน เดินลอดได้
		if absf(pos.y - float(e.pos.y)) > LAYER_GAP:
			continue
		var dx: float = pos.x - e.pos.x
		var gap: float = BODY_SEPARATION - 0.5 + e.body_radius
		var before: float = from_x - e.pos.x
		# เฟรมนี้เดินจากนอกตัวมอนเข้ามา หรือข้ามไปอีกฝั่ง หยุดที่ขอบด้านเดิม
		if absf(before) >= gap and (absf(dx) < gap or signf(dx) != signf(before)):
			pos.x = e.pos.x + signf(before) * gap
			continue
		var overlap: float = gap - absf(dx)
		if overlap > 0.0:
			var side := signf(before) if before != 0.0 else -facing
			var step := side * minf(overlap, PUSH_SPEED * delta)
			pos.x += step
			# ติดขอบจออยู่ ให้มอนขยับแทน
			if absf(pos.x) > half_width:
				e.pos.x -= step

## แสงกระแทกตอนตีโดน
func _anime_hit(e: Node2D) -> void:
	var fx := AnimeBurst.new()
	fx.pos = e.pos + Vector2(0.0, 1.0)
	fx.size_k = ANIME_HIT_SIZE
	get_parent().add_child(fx)

func _end_attack() -> void:
	_tether_release()
	attacking = false
	pierced = false

# ---------------------------------------------------------------- คอมโบ

func _next_chain(k: String) -> String:
	if chain == "":
		return ""
	if chain.contains("^") != _airborne() and not _plunge_keeps_chain():
		return ""
	if cur_move.has("mash_max") and chain.ends_with("<" + k + ">") and _mash_used < int(cur_move["mash_max"]):
		return chain
	if input_dir == -facing and CombatData.has_back_step(chain + "<" + k):
		return chain + "<" + k
	if down_held and CombatData.valid(chain + "↓(" + k + ")"):
		return chain + "↓(" + k + ")"
	if down_held and CombatData.valid(chain + "↓" + k):
		return chain + "↓" + k
	if input_dir == facing and CombatData.valid(chain + ">" + k):
		return chain + ">" + k
	if CombatData.valid(chain + k):
		return chain + k
	if CombatData.valid(chain + "(" + k + ")"):
		return chain + "(" + k + ")"
	if CombatData.valid(chain + "<" + k + ">"):
		return chain + "<" + k + ">"
	return ""

func _back_step_open() -> bool:
	return chain != "" and chain_t > 0.0 and (CombatData.has_back_step(chain + "<z") or CombatData.has_back_step(chain + "<x"))

## ดิ่งลงถึงพื้นแล้วคอมโบยังต่อได้ เช่นงัดมอนจากพื้นต่อจากท่าฟาด
func _plunge_keeps_chain() -> bool:
	if chain == "":
		return false
	if attacking and cur_move.get("from_ground", false):
		return true
	return (cur_move.has("plunge") or cur_move.get("keeps_chain", false)) and CombatData.valid(chain) and not CombatData.is_final(chain)

func _can_chain(k: String) -> bool:
	return _next_chain(k) != ""

func _landed_from_air_move() -> bool:
	return cur_move.get("air", false) and not _airborne()

func _try_attack() -> void:
	var k := queued
	var new_chain := ""
	if _can_chain(k):
		new_chain = _next_chain(k)
	elif _airborne():
		if air_used:
			return   # ไม่ล้างปุ่มที่กดไว้ กดก่อนถึงพื้นนิดเดียวก็ยังออกท่า
		# ไม่มีท่าอากาศเฉพาะ ใช้ท่าเดี่ยวเดิม
		var air_try: String = (">>^" if jump_dashed else "^") + k
		if not CombatData.valid(air_try):
			air_try = k
		air_used = true
		new_chain = air_try
	else:
		var d := ">>" if dash_t > 0.0 else ""
		for c in [d + k, k]:
			if CombatData.valid(c):
				new_chain = c
				break
	queued = ""
	if new_chain == "":
		return
	var again := new_chain == chain
	chain = new_chain
	_start_attack(new_chain)
	if cur_move.has("mash_max"):
		_mash_used = _mash_used + 1 if again else 1
		if cur_move.has("mash_last") and _mash_used >= int(cur_move["mash_max"]):
			if cur_move.has("shot"):
				cur_move["shot"]["extra"] = cur_move["mash_last"]
			else:
				cur_move["hit"] = cur_move["mash_last"]

func _start_attack(c: String) -> void:
	_begin_move(CombatData.spec(c), c)

func _begin_move(m: Dictionary, c: String) -> void:
	_wave_rolled = false
	_mana_rolled = false
	cur_move = m
	attacking = true
	pierced = false
	attack_t = 0.0
	move_dur = m["dur"]
	cur_wind = m.get("wind", 0.3)
	strike_part = m.get("strike", 0.25)
	attack_dur = move_dur + (0.3 if CombatData.is_final(c) else 0.08)
	hit_landed = false
	active_done = false
	already_hit.clear()
	_tick_wait = 0.0
	_tick_left = int(m.get("tick_max", 999))
	_shot_done = false
	_slam_done = false
	if m.has("warp"):
		_warp(str(m["warp"]))
	if m.has("hop") and on_floor():
		vel.y = float(m["hop"])
	if m.has("off_hand"):
		_off_to = m["off_hand"]
	dash_t = 0.0
	lunge_v = float(m.get("lunge", 0.0)) * facing
	active_t0 = move_dur * (cur_wind + strike_part * float(m.get("hit_at", ACTIVE_START)))
	active_t1 = move_dur * (cur_wind + strike_part)
	pierce_ahead.clear()
	if m.get("pierce", false):
		for e in get_tree().get_nodes_in_group("monsters"):
			var dx: float = (e.pos.x - pos.x) * facing
			if dx > -0.3 and dx < 6.0:
				pierce_ahead.append(e)

func _active_frame() -> void:
	if plain:
		_do_plain_hit()
		return
	# ควันฟุ้งตรงหน้าทุกครั้ง โดนมอนหรือไม่ก็ตาม
	if cur_move.get("fx_smoke", false) and not _slam_done:
		_slam_done = true
		var smoke := SmokeCloud.new()
		smoke.pos = Vector2(pos.x + facing * SLAM_AHEAD, 0.0)
		smoke.hero = self
		get_parent().add_child(smoke)
	# กางประตูวาปที่ปากทาง ออกอีกฝั่งด้านหน้า แล้วหันกลับไปหามอนที่วาปผ่านมา
	if cur_move.has("gate_warp") and not _slam_done:
		_slam_done = true
		_spawn_fx("gate", pos + Vector2(facing * 0.9, 1.1))
		pos.x = clampf(pos.x + facing * float(cur_move["gate_warp"]), -half_width, half_width)
		_spawn_fx("gate", pos + Vector2(-facing * 0.6, 1.1))
		if not cur_move.get("no_turn", false):
			facing = -facing
	# วงเวทกางทุกครั้ง โดนมอนหรือไม่ก็ตาม
	if cur_move.has("fx_circle") and not _slam_done:
		_slam_done = true
		if cur_move.has("root_r"):
			_root_monsters(float(cur_move["root_r"]), float(cur_move["root_time"]))
		match str(cur_move["fx_circle"]):
			"wide": _spawn_fx("circle_wide", pos + Vector2(0.0, CHEST_UP))
			"ground": _spawn_fx("circle_ground", Vector2(pos.x, 0.0))
			"sky": _spawn_fx("circle_sky", Vector2(pos.x + facing * SKY_CIRCLE_AHEAD, SKY_CIRCLE_UP))
			_:
				var tip_fx := ImpactFx.new()
				tip_fx.kind = "circle_tip"
				tip_fx.pos = pos + Vector2(facing * TIP_CIRCLE_AHEAD, TIP_CIRCLE_UP)
				tip_fx.rotation = facing * TIP_CIRCLE_TILT
				get_parent().add_child(tip_fx)
	# กระแทกพื้นเห็นรอยแตกทุกครั้ง โดนมอนหรือไม่ก็ตาม
	if cur_move.get("fx_slam", false) and not _slam_done:
		_slam_done = true
		_spawn_fx("slam", Vector2(pos.x + facing * SLAM_AHEAD, 0.0))
	if not cur_move.get("pierce", false) and not cur_move.has("tick"):
		_do_hit(cur_move)
		# ฟันพลาดบนพื้น หน่วงนานขึ้น ต้องดูให้โดนก่อนกดต่อ
		if attack_t >= active_t1 and not hit_landed and cur_move.has("hit") and not cur_move.get("air", false):
			attack_dur += 0.15
	if attack_t >= active_t1:
		active_done = true

## hitbox เป็นกล่องตามแกน: หน้า reach หลัง back สูง height
func _do_hit(m: Dictionary) -> void:
	var h: Dictionary = m.get("hit", {})
	if h.is_empty():
		return
	if coat_t > 0.0 and not h.has("burn"):
		h = h.duplicate()
		h["burn"] = coat_kind
	var reach: float = m.get("hit_reach", 2.2 * float(m.get("big", 1.0)))
	if aura_on():
		reach *= AURA_HIT_REACH
	_roll_sword_wave()
	_roll_hit_mana()
	var back: float = m.get("hit_back", 0.9)
	var height: float = m.get("hit_height", 2.4 if m.get("air", false) else 1.8)
	var any := false
	for e in get_tree().get_nodes_in_group("monsters"):
		var dx: float = (e.pos.x - pos.x) * facing
		var dy: float = e.pos.y - pos.y
		if dx > -back and dx < reach and absf(dy) < height and not (e in already_hit):
			already_hit.append(e)
			var hp_before: float = e.hp
			if e.take_hit(h, facing):
				any = true
				if Sketch.anime:
					_anime_hit(e)
				_count_hit(hp_before - e.hp, h)
				if m.get("fx_ram", false):
					_spawn_fx("ram", Vector2(lerpf(pos.x, e.pos.x, 0.65), e.pos.y + 1.0))
				if m.has("fx_hit"):
					_spawn_fx(str(m["fx_hit"]), e.pos)
	if m.has("fx_hit") and not any:
		_spawn_fx(str(m["fx_hit"]), Vector2(pos.x + facing * BOLT_MISS, 0.0))
	if any:
		hit_landed = true
		var t: String = h.get("type", "flinch")
		_hitstop(float(m.get("hitstop", 0.07 if t == "flinch" else 0.14)))

func _pierce_check(lt0: float) -> void:
	if pierced or attack_t < lt0:
		return
	var h: Dictionary = cur_move.get("hit", {})
	var all_passed := true
	for e in pierce_ahead:
		if not is_instance_valid(e):
			continue
		var dx: float = (e.pos.x - pos.x) * facing
		if dx < 0.4 and not (e in already_hit):
			already_hit.append(e)
			var hp_before: float = e.hp
			if e.take_hit(h, facing):
				hit_landed = true
				_count_hit(hp_before - e.hp, h)
				_hitstop(0.14)
		# ทะลุตัวที่โดนแล้วหยุด ตัวที่อยู่ติดกันก็โดนไปด้วย ตัวไกลๆ ไม่ต้องไถลไปหา
		if dx > -1.0 and (e in already_hit or dx < 0.9):
			all_passed = false
	if all_passed and not already_hit.is_empty():
		pierced = true

func _count_hit(hp_change: float, h: Dictionary) -> void:
	if hp_change == 0.0:
		return
	combo_count += 1
	combo_dmg += hp_change if hp_change > 0.0 else float(h.get("dmg", 0.0))
	combo_t = COMBO_RESET

## หยุดภาพเสี้ยววินาทีตอนโดนเป้าหมาย
func _hitstop(sec: float) -> void:
	if _hitstop_on:
		return
	_hitstop_on = true
	Engine.time_scale = 0.05
	await get_tree().create_timer(sec * 0.05, true, false, false).timeout
	Engine.time_scale = 1.0
	_hitstop_on = false

# ---------------------------------------------------------------- ท่าทางและการวาด

func _update_pose(delta: float) -> void:
	var drone_want := 1.0 if attacking and cur_move.has("drone_to") else 0.0
	if drone_want > 0.0:
		_drone_goal = str(cur_move["drone_to"])
	_drone_k = move_toward(_drone_k, drone_want, DRONE_FOLLOW * delta)
	var kick_want := 0.0
	if attacking and cur_move.get("kick", false):
		kick_want = 1.0
	elif attacking and cur_move.get("stomp", false):
		kick_want = 1.0 if attack_t < move_dur * cur_wind else 0.0
	_kick_k = move_toward(_kick_k, kick_want, LEG_RATE * delta)
	var off_want := 1.0 if attacking and cur_move.has("off_hand") else 0.0
	_off_k = move_toward(_off_k, off_want, OFF_HAND_RATE * delta)
	if attacking:
		var m := cur_move
		var wind_end := move_dur * cur_wind
		var strike_end := wind_end + move_dur * strike_part
		if attack_t < wind_end:
			var u := attack_t / maxf(wind_end, 0.001)
			var w := 1.0 - pow(1.0 - u, 2.0)
			_sw = lerpf(REST_SW, float(m["sw0"]), w)
			_ry = lerpf(0.0, float(m.get("ry0", 0.0)), w)
			_hand_off = Vector2.ZERO.lerp(m.get("p0", Vector2.ZERO), w)
			if m.has("arm_spin"):
				_hand_off += Vector2(sin(TAU * w), 1.0 - cos(TAU * w)) * float(m["arm_spin"])
			_lean = lerpf(0.0, float(m.get("lean_w", 10.0)), w)
		else:
			var u := clampf((attack_t - wind_end) / maxf(strike_end - wind_end, 0.001), 0.0, 1.0)
			var s := u if m.get("linear", false) else u * u * u
			_sw = lerpf(float(m["sw0"]), float(m["sw1"]), s)
			_ry = lerpf(float(m.get("ry0", 0.0)), float(m.get("ry1", 0.0)), s)
			_hand_off = (m.get("p0", Vector2.ZERO) as Vector2).lerp(m.get("p1", Vector2.ZERO), s)
			_lean = lerpf(float(m.get("lean_w", 10.0)), float(m.get("lean_s", -12.0)), s)
			if m.has("stabs"):
				var beat := (attack_t - wind_end) / float(m["tick"])
				_hand_off = (m.get("p0", Vector2.ZERO) as Vector2).lerp(m.get("p1", Vector2.ZERO), absf(sin(beat * PI)))
		if m.has("wheel"):
			var wheel_u := clampf((attack_t - wind_end) / maxf(strike_end - wind_end, 0.001), 0.0, 1.0)
			_wheel = TAU * float(m["wheel"]) * wheel_u if attack_t < strike_end else 0.0
		else:
			_wheel = 0.0
		if m.has("spin"):
			var spin_u := clampf(attack_t / maxf(strike_end, 0.001), 0.0, 1.0)
			_attack_spin = TAU * float(m["spin"]) * spin_u * spin_u * (3.0 - 2.0 * spin_u)
		else:
			_attack_spin = 0.0
	else:
		_attack_spin = 0.0
		_wheel = 0.0
		var k := minf(RETURN_RATE * delta, 1.0)
		_sw = lerpf(_sw, REST_SW, k)
		_ry = lerpf(_ry, 0.0, k)
		_hand_off = _hand_off.lerp(Vector2.ZERO, k)
		_lean = lerpf(_lean, 0.0, k)

func _place() -> void:
	position = Vector2(pos.x, -pos.y) * CombatData.UNIT
	# ตีลังกา หมุนรอบกลางตัว ไม่ใช่รอบเท้า
	rotation = _wheel * facing
	if _wheel != 0.0:
		var mid := Vector2(0.0, -(CURL_CENTER if _curling() else WHEEL_CENTER))
		position += mid - mid.rotated(rotation)

func _curling() -> bool:
	return attacking and cur_move.get("curl", false)

## ตอนกลิ้งม้วนตัวกลมเล็กๆ เก็บดาบ ไม่เห็นมือกับเท้า
func _draw_curl() -> void:
	var c := Vector2(0.0, -CURL_CENTER)
	draw_circle(c, CURL_R, _ink())
	var swirl := PackedVector2Array()
	for i in 19:
		var t := float(i) / 18.0
		var a := t * TAU * 1.25
		swirl.append(c + Vector2(cos(a), sin(a)) * CURL_R * lerpf(0.75, 0.15, t))
	Sketch.line(self, swirl, 12, 2.4, 0.3, Sketch.PAPER)

func _draw() -> void:
	if plain:
		_draw_plain()
		return
	if _curling():
		_draw_curl()
		return
	if _has_book and _book_ready:
		_draw_book()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(_flip_x(), 1.0))
	var body_y := -BODY_GAP - FOOT_RY - BODY_HEIGHT * 0.5 + sin(_clock * BOB_SPEED) * BOB
	var center := Vector2(0.0, body_y)
	_draw_stick_legs(body_y)
	# เอนตัวตอนออกท่า หมุนรอบกลางลำตัว
	draw_set_transform(center * 0.0, deg_to_rad(-_lean * 0.45), Vector2(_flip_x(), 1.0))
	_draw_stick_body(body_y)
	var off_hand := Vector2(-STICK_ARM * 1.1, body_y + 8.0).lerp(Vector2(0.0, body_y) + _off_to, _off_k)
	_draw_stick_arm(body_y, off_hand, 1.0)
	draw_circle(off_hand, STICK_HAND, _ink())
	if _has_shield:
		_draw_shield(off_hand)
	if _has_fire:
		_draw_hand_fire(off_hand)
	if attacking and cur_move.has("flame_blast"):
		_draw_flame_blast(off_hand)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(_flip_x(), 1.0))
	_draw_stick_arm(body_y, _weapon_hand(body_y), -1.0)
	_draw_swoosh(body_y)
	if attacking and cur_move.has("flame"):
		_draw_slash_flames(body_y)
	if attacking and cur_move.get("fx_ram", false):
		_draw_ram_lines()
	if attacking and cur_move.get("tether", false) and is_instance_valid(_tether):
		_draw_tether(body_y)
	if _dim_aura_on():
		_draw_dim_aura(body_y)
	if attacking and cur_move.get("wind_fx", false) and attack_t >= move_dur * cur_wind:
		_draw_wind(body_y)
	_draw_sword(body_y)
	if coat_t > 0.0 and _weapon != "drones":
		_draw_coat(body_y)
	if aura_on() and _weapon == "sword":
		_draw_sword_aura(body_y)

## ออร่าเคลือบสีรอบใบดาบ เป็นเส้นระบายตามชนิดไฟ ไม่มีเปลว
func _draw_coat(body_y: float) -> void:
	var hand := HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5) + Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT
	var sw := deg_to_rad(_sw)
	var axis := Vector2(-sin(sw) * cos(deg_to_rad(_ry)), -cos(sw))
	if axis.length() < SHORTEST_BLADE:
		axis = axis.normalized() * SHORTEST_BLADE if axis.length() > 0.001 else Vector2.RIGHT * SHORTEST_BLADE
	var unit := axis.normalized()
	var side := unit.orthogonal() * BLADE_HALF * COAT_WIDE
	var base := hand + unit * 12.0
	var tip := base + axis * _weapon_long()
	var color: Color = CombatData.FLAME[coat_kind][0]
	Sketch.hatch(self, PackedVector2Array([base - side, tip - side * 0.6, tip + unit * 12.0, tip + side * 0.6, base + side]), color, 330, 8.0)

## 35.2 ออร่าดาบใหญ่ครอบใบดาบ ยาวกว่าดาบเท่าระยะที่เพิ่ม ระบายแดง ขอบหมึก
func _draw_sword_aura(body_y: float) -> void:
	var hand := HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5) + Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT
	var sw := deg_to_rad(_sw)
	var axis := Vector2(-sin(sw) * cos(deg_to_rad(_ry)), -cos(sw))
	if axis.length() < SHORTEST_BLADE:
		axis = axis.normalized() * SHORTEST_BLADE if axis.length() > 0.001 else Vector2.RIGHT * SHORTEST_BLADE
	var unit := axis.normalized()
	var side := unit.orthogonal() * BLADE_HALF * AURA_HALF
	var base := hand + unit * 12.0
	var tip := base + axis * _weapon_long() * AURA_LONG
	var shoulder := tip - unit * BLADE_HALF * AURA_HALF * 1.6
	var pts := PackedVector2Array([base - side * 0.7, shoulder - side, tip, shoulder + side, base + side * 0.7])
	if Sketch.anime:
		Sketch.fx_fill(self, pts, PAINT_RED)
	else:
		Sketch.hatch(self, pts, PAINT_RED, 335, 9.0)
	pts.append(pts[0])
	Sketch.line(self, pts, 336, 2.6, 0.8)

## ช่วงของการฟันที่เส้นวืดควรเห็น x คือหาง y คือหัว ไม่มีเส้นคืน Vector2.ZERO
func swoosh_range() -> Vector2:
	if not attacking:
		return Vector2.ZERO
	var wind_end := move_dur * cur_wind
	var strike_end := wind_end + move_dur * strike_part
	if attack_t < wind_end:
		return Vector2.ZERO
	var u := clampf((attack_t - wind_end) / maxf(strike_end - wind_end, 0.001), 0.0, 1.0)
	# ดาบหมุนหลายรอบ เส้นวืดตามแค่ช่วงสั้นๆ ไม่ให้ซ้อนเป็นวง
	if cur_move.get("linear", false):
		return Vector2(maxf(u - float(cur_move.get("trail", 0.08)), 0.0), u) if attack_t < strike_end else Vector2.ZERO
	var tail := clampf((attack_t - strike_end) / SWOOSH_FADE, 0.0, 1.0)
	var head := u * u * u
	return Vector2(tail, head) if head > tail else Vector2.ZERO

## เส้นวืดตามแนวดาบ แค่เส้นบางๆ สามเส้น ไม่มีสีไม่มีพื้น
func _draw_swoosh(body_y: float) -> void:
	if _weapon == "drones":
		return   # โดรนมีเส้นตามหลังของตัวเอง
	var r := swoosh_range()
	if r == Vector2.ZERO or cur_move.has("wheel"):
		return
	if Sketch.anime:
		_draw_anime_trail(r, body_y)
		return
	# ท่าฟันแนวนอนทุกจุดอยู่ระดับเดียวกัน แยกเส้นบนล่างไม่ให้ทับเป็นเส้นเดียว
	var spread := Vector2(0.0, SWOOSH_FLAT_GAP) if cur_move.has("ry0") else Vector2.ZERO
	for i in SWOOSH_LINES.size():
		var along: float = SWOOSH_LINES[i][0]
		var tail := minf(r.x + float(SWOOSH_LINES[i][2]) * (r.y - r.x), r.y)
		var pts := PackedVector2Array()
		for k in SWOOSH_POINTS + 1:
			pts.append(_blade_point(lerpf(tail, r.y, float(k) / SWOOSH_POINTS), along, body_y) + spread * (i - 1.0))
		Sketch.line(self, pts, SWOOSH_SEED + i, float(SWOOSH_LINES[i][1]), 0.4)

## รอยฟันอนิเมะ แถบโค้งสีสด ปลายบาง มีแกนสว่าง
func _draw_anime_trail(r: Vector2, body_y: float) -> void:
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for k in SWOOSH_POINTS + 1:
		var s := lerpf(r.x, r.y, float(k) / SWOOSH_POINTS)
		outer.append(_blade_point(s, 1.15, body_y))
		inner.append(_blade_point(s, lerpf(1.1, 0.5, float(k) / SWOOSH_POINTS), body_y))
	inner.reverse()
	outer.append_array(inner)
	Sketch.fx_fill(self, outer, PAINT_RED)

## จุดบนใบดาบ ณ ความคืบหน้าของการฟัน s
func _blade_point(s: float, along: float, body_y: float) -> Vector2:
	var m := cur_move
	var sw := deg_to_rad(lerpf(float(m["sw0"]), float(m["sw1"]), s))
	var ry := deg_to_rad(lerpf(float(m.get("ry0", 0.0)), float(m.get("ry1", 0.0)), s))
	var off: Vector2 = (m.get("p0", Vector2.ZERO) as Vector2).lerp(m.get("p1", Vector2.ZERO), s)
	var hand := HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5)
	hand += Vector2(off.x, -off.y) * CombatData.UNIT
	return hand + Vector2(-sin(sw) * cos(ry), -cos(sw)) * (12.0 + _weapon_long() * along)

## เปลวไฟหนึ่งเปลว ชี้ออกจากฐาน มีชั้นในสีอ่อน
func _flame_tongue(base: Vector2, dir: Vector2, long: float, wide: float, kind: String, seed_no: int) -> void:
	var colors: Array = CombatData.FLAME[kind]
	for layer in [[1.0, colors[0]], [0.55, colors[1]]]:
		var k: float = layer[0]
		var sway := sin(_clock * 13.0 + float(seed_no)) * wide * 0.9 * k
		var pts := Sketch.flame(base, dir, long * k, wide * k, sway)
		Sketch.hatch(self, pts, layer[1])
		pts.append(pts[0])
		Sketch.line(self, pts, seed_no, 1.8, 0.2, _ink())

## เปลวไฟตามแนวฟาด เปลวใหญ่ที่หัวดาบ เล็กลงไปทางหาง
func _draw_slash_flames(body_y: float) -> void:
	var r := swoosh_range()
	if r == Vector2.ZERO:
		return
	var kind := str(cur_move["flame"])
	var hand := HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5)
	for i in SLASH_FLAMES:
		var u := float(i) / (SLASH_FLAMES - 1)
		var s := lerpf(r.x, r.y, u)
		var along := 0.45 + 0.55 * absf(sin(float(i) * 2.4))
		var at := _blade_point(s, along, body_y)
		var out := (at - hand).normalized() if at != hand else Vector2.UP
		_flame_tongue(at, out, 26.0 + 34.0 * u, 10.0 + 9.0 * u, kind, 300 + i)

## ปล่อยไฟจากมือรอง เปลวเล็กๆ เปลวเดียว แนวตั้ง
func _draw_flame_blast(hand: Vector2) -> void:
	if attack_t < move_dur * cur_wind or _tick_left <= 0 and _tick_wait <= 0.0:
		return
	var kind := str(cur_move["flame_blast"])
	var long := BLAST_LONG * (0.7 + 0.3 * sin(_clock * 17.0))
	_flame_tongue(hand + Vector2(HAND_RADIUS + 14.0, 24.0), Vector2.UP, long, BLAST_WIDE, kind, 320)

func _weapon_long() -> float:
	return STAFF_LONG if _weapon == "staff" else BLADE_LONG

## ท่าเวท: มือกลมธรรมดา ไม่มีนิ้ว ตอนขยำมือหดลงเล็กน้อย
func _draw_magic_hand(hand: Vector2) -> void:
	draw_circle(hand, STICK_HAND * lerpf(HAND_SQUEEZE, 1.0, hand_open), _ink())

## หนังสือเปิดลอยอยู่ หน้ากระดาษพลิกจากขวาไปซ้ายไม่หยุด วาดไม่กลับด้านตามทิศที่หัน
func _draw_book() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var c := Vector2(_book_pos.x - pos.x, -(_book_pos.y - pos.y)) * CombatData.UNIT
	var top := c + Vector2(0.0, -BOOK_H * 0.5)
	var low := c + Vector2(0.0, BOOK_H * 0.5)
	for side in [-1.0, 1.0]:
		var page := PackedVector2Array([top, top + Vector2(side * BOOK_W, -BOOK_TILT), low + Vector2(side * BOOK_W, -BOOK_TILT), low])
		Sketch.shape(self, page, 60 + int(side), 2.4)
		for row in 3:
			var y := -BOOK_H * 0.22 + row * BOOK_H * 0.24
			var a := c + Vector2(side * BOOK_W * 0.2, y - BOOK_TILT * 0.2)
			var b := c + Vector2(side * BOOK_W * 0.8, y - BOOK_TILT * 0.8)
			Sketch.line(self, PackedVector2Array([a, b]), 63 + row, 1.5, 0.3)
	# แผ่นที่กำลังพลิก
	var angle := PI * _flip_t
	var reach := Vector2(cos(angle) * BOOK_W, -sin(angle) * BOOK_LIFT - BOOK_TILT * absf(cos(angle)))
	Sketch.shape(self, PackedVector2Array([top, top + reach, low + reach, low]), 67, 2.4)

## โล่ปลายแหลมในมือรอง ขีดเฉียงสีแดงแบบเดียวกับดาบ
func _draw_shield(hand: Vector2) -> void:
	var c := hand + Vector2(-SHIELD_SIZE.x * 0.4, 0.0)
	var w := SHIELD_SIZE.x
	var h := SHIELD_SIZE.y * 0.5
	var pts := PackedVector2Array([
		c + Vector2(-w, -h), c + Vector2(w, -h), c + Vector2(w, h * 0.35), c + Vector2(0.0, h * 1.25), c + Vector2(-w, h * 0.35),
	])
	draw_colored_polygon(pts, _fill())
	for n in 5:
		var y := -h * 0.75 + n * h * 0.42
		var narrow := 1.0 if y < h * 0.35 else clampf(1.0 - (y - h * 0.35) / (h * 0.9), 0.0, 1.0)
		draw_line(c + Vector2(-w * 0.8 * narrow, y + 8.0), c + Vector2(w * 0.8 * narrow, y - 8.0), PAINT_RED, 2.8, true)
	pts.append(pts[0])
	Sketch.line(self, pts, 70, 3.2, 0.6, _ink())

## ไฟลุกเล็กๆ บนมือรอง เปลวสั่นตลอดเวลา
func _draw_hand_fire(hand: Vector2) -> void:
	var base := hand + Vector2(0.0, -HAND_RADIUS * 0.9)
	for layer in [[1.0, FIRE_COLOR], [0.55, FIRE_INNER]]:
		var k: float = layer[0]
		var sway := sin(_clock * 11.0) * 6.0 * k
		var jump := sin(_clock * 17.0) * 3.0 * k
		var pts := Sketch.flame(base, Vector2.UP, (FIRE_HIGH + jump) * k, FIRE_WIDE * k, sway)
		Sketch.hatch(self, pts, layer[1])
		pts.append(pts[0])
		Sketch.line(self, pts, 72, 2.2, 0.3, _ink())

## หัวคทาสีชมพูม่วง มีเกลียวขดสองข้าง
func _draw_spiral_head(c: Vector2, unit: Vector2) -> void:
	var across := unit.orthogonal()
	for s in [-1.0, 1.0]:
		var center: Vector2 = c + across * s * (STAFF_ORB + SPIRAL_OUT)
		var coil := PackedVector2Array()
		for i in SPIRAL_STEPS + 1:
			var t := float(i) / SPIRAL_STEPS
			var a: float = t * TAU * SPIRAL_TURNS * s + _clock * 2.0 * s
			coil.append(center + (across * cos(a) + unit * sin(a)) * SPIRAL_R * (1.0 - t * 0.9))
		Sketch.line(self, coil, 282, 2.8, 0.2, SPIRAL_LINE)
	Sketch.shape(self, Sketch.oval(c, STAFF_ORB, STAFF_ORB, 24), BLADE_SEED + 1, 2.8, SPIRAL_ORB, _ink())
	for n in 3:
		var off := -STAFF_ORB * 0.45 + n * STAFF_ORB * 0.45
		draw_line(c + across * off - unit * STAFF_ORB * 0.5, c + across * off + unit * STAFF_ORB * 0.5, SPIRAL_LINE, 2.2, true)

## หัวคทาลูกบาศก์เส้นโปร่งสามมิติ หมุนช้าๆ มีลูกกลมอยู่ข้างใน ลอยแยกจากไม้
func _draw_cube_head(c: Vector2, unit: Vector2) -> void:
	var across := unit.orthogonal()
	var top := PackedVector2Array()
	var low := PackedVector2Array()
	for k in 4:
		var a := _clock * CUBE_HEAD_SPIN + TAU * k / 4.0
		var flat := across * cos(a) * CUBE_HEAD + unit * sin(a) * CUBE_HEAD * CUBE_HEAD_FLAT
		top.append(c + flat + unit * CUBE_HEAD * 0.75)
		low.append(c + flat - unit * CUBE_HEAD * 0.75)
	Sketch.shape(self, Sketch.oval(c, CUBE_ORB, CUBE_ORB, 18), BLADE_SEED + 1, 2.6, STAFF_PAINT, _ink())
	draw_arc(c + (across - unit) * CUBE_ORB * 0.25, CUBE_ORB * 0.35, 0.0, TAU, 10, Color.WHITE, 1.6, true)
	for k in 4:
		var n := (k + 1) % 4
		Sketch.line(self, PackedVector2Array([top[k], top[n]]), 270 + k, 2.4, 0.2, _ink())
		Sketch.line(self, PackedVector2Array([low[k], low[n]]), 274 + k, 2.4, 0.2, _ink())
		Sketch.line(self, PackedVector2Array([top[k], low[k]]), 278 + k, 2.4, 0.2, _ink())

## หัวคทารูปหัวใจ ปลายแหลมชี้ไปทางด้าม
func _draw_heart(c: Vector2, unit: Vector2) -> void:
	var across := unit.orthogonal()
	var pts := PackedVector2Array()
	for k in 24:
		var t := TAU * k / 24.0
		var x := pow(sin(t), 3.0)
		var y := (13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t)) / 16.0
		pts.append(c + (across * x + unit * y) * HEART_R)
	Sketch.hatch(self, pts, HEART_FILL)
	pts.append(pts[0])
	Sketch.line(self, pts, BLADE_SEED + 2, 2.8, 0.2, _ink())

## ปีกสองข้างที่หัวคทา ขนเรียงสามเส้น
func _draw_staff_wings(orb: Vector2, unit: Vector2, size_k := 1.0) -> void:
	var across := unit.orthogonal()
	for side in [-1.0, 1.0]:
		for n in WING_FEATHERS:
			var long := WING_LONG * size_k * (1.0 - n * 0.22)
			var dir: Vector2 = (across * side + unit * (0.75 - n * 0.55)).normalized()
			var root: Vector2 = orb + across * side * STAFF_ORB * 0.7 - unit * n * 3.0
			var wide: Vector2 = dir.orthogonal() * long * 0.17
			var pts := PackedVector2Array([root, root + dir * long * 0.45 + wide, root + dir * long, root + dir * long * 0.45 - wide])
			draw_colored_polygon(pts, Color.WHITE)
			draw_line(root + dir * long * 0.12, root + dir * long * 0.8, WING_COLOR, 2.2 * size_k, true)
			pts.append(pts[0])
			Sketch.line(self, pts, 74 + n, 2.4 * size_k, 0.3 * size_k, _ink())

## ใช้โดรนเป็นอาวุธหรือไม่
func uses_drones() -> bool:
	return _weapon == "drones"

## ตำแหน่งโดรนลำนี้ เทียบเท้า จุดภาพ หน้าตัวเป็นบวก
func drone_offset(i: int) -> Vector2:
	var slot: Vector2 = DRONE_SLOTS[i]
	var lunge := 0.0
	if attacking and move_dur > 0.0:
		lunge = sin(clampf(attack_t / move_dur, 0.0, 1.0) * PI)
	var bob := sin(_clock * 2.6 + float(i) * 1.7) * DRONE_BOB
	var at := slot + Vector2(lunge * DRONE_LUNGE, bob - lunge * DRONE_DOWN)
	var rest := Vector2(at.x, -at.y) * CombatData.UNIT
	if _drone_k <= 0.0:
		return rest
	return rest.lerp(_drone_spot(i), _drone_k)

## จุดที่โดรนไปตามท่า ใช้มือหรือเท้าโดรนจะตามไปตรงนั้น
func _drone_spot(i: int) -> Vector2:
	var spread := Vector2(0.0, (float(i) - 1.0) * DRONE_SPREAD)
	match _drone_goal:
		"hand":
			return HAND + Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT + spread
		"foot":
			return Vector2(FOOT_X, -FOOT_RY) + KICK_REACH * _kick_k + Vector2(spread.y, -8.0)
		"ahead":
			return DRONE_AHEAD + Vector2(spread.y, spread.y * 0.3)
		"sides":
			# โดรนซ้าย ขวา และบนหัว หมุนแนวนอนเร็วๆ อยู่กับที่
			var spin_a := _clock * DRONE_ORBIT_SPEED * 2.0 + float(i)
			var flat := Vector2(cos(spin_a) * DRONE_SPIN_X, sin(spin_a) * DRONE_SPIN_Y)
			if i == 1:
				return Vector2(0.0, -DRONE_ON_HEAD) + flat
			return Vector2(-DRONE_SIDE if i == 0 else DRONE_SIDE, -BODY_CENTER) + flat
		"orbit":
			var a := _clock * DRONE_ORBIT_SPEED + TAU * float(i) / DRONE_SLOTS.size()
			return Vector2(cos(a) * DRONE_ORBIT.x, -BODY_CENTER + sin(a) * DRONE_ORBIT.y)
	return DRONE_FRONT + spread

## รูปโดรนตามสาย: ใบพัดบนหัวแนวตั้ง ลูกบาศก์ขาวแกนม่วง หรือแผ่นปลายแหลมเว้ากลาง
func drone_style() -> String:
	return _drone_style

func _draw_drones() -> void:
	var dashing := attacking and attack_t < move_dur and not cur_move.has("drone_to")
	for i in DRONE_SLOTS.size():
		var c := drone_offset(i)
		match _drone_style:
			"cube": _draw_cube_drone(c, i)
			"blade": _draw_blade_drone(c, i)
			"syringe": _draw_syringe_drone(c, i)
			_: _draw_rotor_drone(c, i)
		if dashing:
			Sketch.line(self, PackedVector2Array([c - Vector2(26.0, 0.0), c - Vector2(26.0 + TRAIL_LONG, 0.0)]), 90 + i, 2.4, 0.5, DRONE_ACCENT)
		if attacking and cur_move.get("drone_beam", false) and attack_t < move_dur:
			if i == 1:
				_draw_drone_beam(c)

## คลื่นไฟฟ้าทรงกระบอก วงซ้อนกันวิ่งออกจากโดรนไปข้างหน้า มีเส้นขอบกระบอก
func _draw_drone_beam(c: Vector2) -> void:
	var dir := Vector2(1.0, 0.6).normalized()
	var side := dir.orthogonal()
	for s in [-1.0, 1.0]:
		var from: Vector2 = c + side * s * BEAM_R
		Sketch.line(self, PackedVector2Array([from, from + dir * BEAM_LONG]), 262, 2.2, 0.9, ElecWave.COLOR)
	for n in BEAM_RINGS:
		var t := fposmod(_clock * 4.5 + float(n) / BEAM_RINGS, 1.0)
		var center := c + dir * BEAM_LONG * t
		var ring := PackedVector2Array()
		for k in BEAM_STEPS + 1:
			var a := TAU * k / BEAM_STEPS
			ring.append(center + side * cos(a) * BEAM_R + dir * sin(a) * BEAM_R * BEAM_FLAT)
		Sketch.line(self, ring, 256 + n, 3.0, 0.5, ElecWave.ARC)

## ตัวตั้งปลายมน แถบม่วงกลางตัว ใบพัดหมุนบนหัว
func _draw_rotor_drone(c: Vector2, i: int) -> void:
	var capsule := Sketch.capsule(c, DRONE_WIDE, DRONE_TALL * 2.0, 10)
	Sketch.shape(self, capsule, 80 + i, 2.6, DRONE_FILL, _ink())
	Sketch.hatch(self, capsule, DRONE_ACCENT, 80 + i, DRONE_HATCH)
	var hub := c + Vector2(0.0, -DRONE_TALL - 9.0)
	Sketch.line(self, PackedVector2Array([c + Vector2(0.0, -DRONE_TALL), hub]), 84 + i, 2.6, 0.2, _ink())
	var swing := cos(_clock * ROTOR_SPEED + float(i)) * ROTOR_LONG
	draw_line(hub + Vector2(-swing, 0.0), hub + Vector2(swing, 0.0), _ink(), 3.2, true)
	Sketch.hatch_circle(self, hub, 3.2, _ink())

## ลูกบาศก์เล็กสีขาว เห็นสองหน้า แกนสีม่วงตรงกลาง
func _draw_cube_drone(c: Vector2, i: int) -> void:
	var a := _clock * 1.4 + float(i) * 1.3
	var s := CUBE_DRONE
	var top := PackedVector2Array()
	var low := PackedVector2Array()
	for k in 4:
		var ang := a + TAU * k / 4.0
		var p := Vector2(cos(ang) * s, sin(ang) * s * 0.42)
		top.append(c + p - Vector2(0.0, s * 0.62))
		low.append(c + p + Vector2(0.0, s * 0.62))
	for k in 4:
		var n := (k + 1) % 4
		var face := PackedVector2Array([top[k], top[n], low[n], low[k]])
		draw_colored_polygon(face, DRONE_FILL)
		Sketch.hatch(self, face, DRONE_ACCENT, 80 + k, DRONE_HATCH)
	draw_colored_polygon(top, DRONE_FILL)
	for k in 4:
		var n := (k + 1) % 4
		Sketch.line(self, PackedVector2Array([top[k], top[n]]), 80 + k, 2.2, 0.15, _ink())
		Sketch.line(self, PackedVector2Array([low[k], low[n]]), 84 + k, 2.2, 0.15, _ink())
		Sketch.line(self, PackedVector2Array([top[k], low[k]]), 88 + k, 2.2, 0.15, _ink())

## โดรนเข็มฉีดยา ชี้ไปข้างหน้า กระบอกใส น้ำยาสีม่วง เข็มสั้น ก้านดันด้านหลัง
func _draw_syringe_drone(c: Vector2, i: int) -> void:
	var l := SYRINGE_LONG
	var w := SYRINGE_WIDE
	var body := Rect2(c + Vector2(-l, -w), Vector2(l * 2.0, w * 2.0))
	draw_rect(body, DRONE_FILL)
	var liquid_x := c.x + l - l * 2.0 * SYRINGE_LIQUID
	Sketch.hatch(self, PackedVector2Array([Vector2(liquid_x, c.y - w), Vector2(c.x + l, c.y - w), Vector2(c.x + l, c.y + w), Vector2(liquid_x, c.y + w)]), DRONE_ACCENT, 80 + i, DRONE_HATCH)
	var edge := PackedVector2Array([body.position, Vector2(body.end.x, body.position.y), body.end, Vector2(body.position.x, body.end.y), body.position])
	Sketch.line(self, edge, 80 + i, 2.6, 0.4, _ink())
	for n in 3:
		var x := -l * 0.45 + n * l * 0.5
		Sketch.line(self, PackedVector2Array([c + Vector2(x, -w), c + Vector2(x, -w * 0.3)]), 83 + n, 1.8, 0.1, _ink())
	# เข็มสั้นด้านหน้า
	Sketch.line(self, PackedVector2Array([c + Vector2(l, 0.0), c + Vector2(l + SYRINGE_NEEDLE, 0.0)]), 86 + i, 2.8, 0.1, _ink())
	# ก้านดันกับปีกจับด้านหลัง
	Sketch.line(self, PackedVector2Array([c + Vector2(-l, 0.0), c + Vector2(-l - SYRINGE_PLUNGER, 0.0)]), 89 + i, 3.0, 0.1, _ink())
	Sketch.line(self, PackedVector2Array([c + Vector2(-l - SYRINGE_PLUNGER, -w * 0.8), c + Vector2(-l - SYRINGE_PLUNGER, w * 0.8)]), 92 + i, 3.0, 0.1, _ink())
	Sketch.line(self, PackedVector2Array([c + Vector2(-l, -w * 1.4), c + Vector2(-l, w * 1.4)]), 95 + i, 3.0, 0.1, _ink())

## แผ่นบาง ปลายบนล่างเรียวแหลม ตรงกลางเว้าเข้า
func _draw_blade_drone(c: Vector2, i: int) -> void:
	var t := BLADE_TALL
	var w := BLADE_WIDE
	var m := BLADE_WAIST
	var pts := PackedVector2Array([
		c + Vector2(0.0, -t), c + Vector2(w, -t * 0.42), c + Vector2(m, 0.0), c + Vector2(w, t * 0.42),
		c + Vector2(0.0, t), c + Vector2(-w, t * 0.42), c + Vector2(-m, 0.0), c + Vector2(-w, -t * 0.42),
	])
	Sketch.shape(self, pts, 80 + i, 2.6, DRONE_FILL, _ink())
	Sketch.hatch(self, pts, DRONE_ACCENT, 80 + i, DRONE_HATCH)

## คทา: ด้ามยาวเส้นเดียว ปลายเป็นลูกแก้วระบายขีดเฉียง
func _draw_staff(hand: Vector2, unit: Vector2, tip: Vector2) -> void:
	Sketch.line(self, PackedVector2Array([hand - unit * 28.0, tip - unit * STAFF_ORB]), BLADE_SEED, 5.0, 0.5, _ink())
	var orb := tip
	if _staff_spiral:
		_draw_spiral_head(orb, unit)
		_hand_dot(hand)
		return
	if _staff_cube:
		_draw_cube_head(tip + unit * (CUBE_HEAD_GAP + sin(_clock * 2.4) * CUBE_HEAD_BOB), unit)
		_hand_dot(hand)
		return
	if _staff_heart:
		_draw_staff_wings(orb, unit, 1.0 if form_on else (DS_FORM_WING if ds_form_t > 0.0 else SMALL_WING))
		_draw_heart(orb, unit)
		_hand_dot(hand)
		return
	if form_on:
		_draw_staff_wings(orb, unit)
	Sketch.shape(self, Sketch.oval(orb, STAFF_ORB, STAFF_ORB, 24), BLADE_SEED + 1, 2.8, _fill(), _ink())
	for n in 4:
		var off := -STAFF_ORB * 0.55 + n * STAFF_ORB * 0.36
		var along := Vector2(1.0, -1.0).normalized()
		var across := Vector2(1.0, 1.0).normalized()
		var chord := sqrt(maxf(STAFF_ORB * STAFF_ORB * 0.8 - off * off, 0.0))
		draw_line(orb + across * off - along * chord, orb + across * off + along * chord, STAFF_PAINT, 2.6, true)
	_hand_dot(hand)

func _weapon_hand(body_y: float) -> Vector2:
	return HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5) + Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT

## มือลอยห่างตัวได้ไม่เกิน CHIBI_REACH
## มุมบนจอของดาบ เทียบแกนขวา จากมุมท่าดาบ เป็นองศา
static func chibi_blade_angle(sw_deg: float) -> float:
	return deg_to_rad(-90.0 - sw_deg)

func _chibi_reach(hand: Vector2, bob: float) -> Vector2:
	var center := Vector2(0.0, CHIBI_CENTER_Y + bob)
	return center + (hand - center).limit_length(CHIBI_REACH)

func plain_hand(bob: float) -> Vector2:
	var rest := CHIBI_HAND + Vector2(CHIBI_BOW_SHIFT if plain_weapon == "bow" else 0.0, bob)
	return _chibi_reach(rest + Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT, bob)

## ท่าไม่มีเอฟเฟก ตีเฉพาะดาเมจ
func _do_plain_hit() -> void:
	if not active_done:
		active_done = true
		_do_hit(cur_move)

## เท้าสองข้างเป็นก้อนกลมลอยแยกจากตัว
func _draw_chibi_feet(extra := 0.0, color := Color.BLACK) -> void:
	var ground := on_floor()
	var moving := ground and not attacking and absf(vel.x) > 0.2
	var phase := _clock * STEP_SPEED
	var stride := CHIBI_RUN if dash_t > 0.0 else CHIBI_WALK
	for i in 2:
		var side := -1.0 if i == 0 else 1.0
		var foot := Vector2(side * CHIBI_FOOT_X, -CHIBI_FOOT_R)
		if moving:
			foot.x += sin(phase) * side * stride
			foot.y -= maxf(cos(phase) * side, 0.0) * CHIBI_STEP_LIFT
		elif attacking and ground:
			foot.x += side * CHIBI_ATTACK_SPREAD
		elif not ground:
			foot.y -= CHIBI_AIR_LIFT
		if i == 1 and _kick_k > 0.0:
			var stomping: bool = attacking and cur_move.get("stomp", false)
			foot += Vector2(0.0, -STOMP_LIFT) * _kick_k if stomping else KICK_REACH * _kick_k
		draw_circle(foot, CHIBI_FOOT_R + extra, color)

## ลำตัวคางหมูขอบมน
func _chibi_body(bob: float, angle: float, pivot: Vector2) -> PackedVector2Array:
	var corners := [Vector2(-CHIBI_BODY_TOP_X, CHIBI_BODY_TOP), Vector2(CHIBI_BODY_TOP_X, CHIBI_BODY_TOP), Vector2(CHIBI_BODY_LOW_X, CHIBI_BODY_LOW), Vector2(-CHIBI_BODY_LOW_X, CHIBI_BODY_LOW)]
	var out := PackedVector2Array()
	for i in 4:
		var c: Vector2 = corners[i]
		var from: Vector2 = c + (corners[(i + 3) % 4] - c).normalized() * CHIBI_BODY_ROUND
		var to: Vector2 = c + (corners[(i + 1) % 4] - c).normalized() * CHIBI_BODY_ROUND
		for k in 9:
			var t := float(k) / 8.0
			var p: Vector2 = from.lerp(c, t).lerp(c.lerp(to, t), t) + Vector2(0.0, bob)
			out.append(pivot + (p - pivot).rotated(angle))
	return out

## ดาบดำ ปลายมนทู่ กันโกร่งปลายมน หมุนตามท่าเดิมของคอมโบ
func _draw_chibi_sword(hand: Vector2, angle_deg: float) -> void:
	var sw := deg_to_rad(angle_deg)
	var axis := Vector2(-sin(sw) * cos(deg_to_rad(_ry)), -cos(sw))
	if axis.length() < SHORTEST_BLADE:
		axis = axis.normalized() * SHORTEST_BLADE if axis.length() > 0.001 else Vector2.RIGHT * SHORTEST_BLADE
	var unit := axis.normalized()
	var across := unit.orthogonal()
	var base := hand + unit * 14.0
	var k := plain_blade_k
	var color := Color.BLACK.lerp(ChibiWave.FILL, k)
	var tip := base + axis * lerpf(CHIBI_BLADE, CHIBI_BIG_BLADE, k)
	var blade_w := lerpf(CHIBI_BLADE_W, CHIBI_BIG_BLADE_W, k)
	var guard := lerpf(CHIBI_GUARD, CHIBI_BIG_GUARD, k)
	var guard_w := lerpf(CHIBI_GUARD_W, CHIBI_BIG_GUARD_W, k)
	if plain_rim > 0.0:
		var rim_color := Color(CHIBI_RIM_COLOR, plain_rim)
		var rim_a := base - across * guard
		var rim_b := base + across * guard
		draw_line(hand - unit * 9.0, base, rim_color, CHIBI_GRIP_W + CHIBI_RIM * 2.0, true)
		draw_line(base, tip, rim_color, blade_w + CHIBI_RIM * 2.0, true)
		draw_circle(tip, blade_w * 0.5 + CHIBI_RIM, rim_color)
		draw_line(rim_a, rim_b, rim_color, guard_w + CHIBI_RIM * 2.0, true)
		draw_circle(rim_a, guard_w * 0.5 + CHIBI_RIM, rim_color)
		draw_circle(rim_b, guard_w * 0.5 + CHIBI_RIM, rim_color)
	draw_line(base, tip, color, blade_w, true)
	draw_circle(tip, blade_w * 0.5, color)
	var guard_a := base - across * guard
	var guard_b := base + across * guard
	draw_line(guard_a, guard_b, color, guard_w, true)
	draw_circle(guard_a, guard_w * 0.5, color)
	draw_circle(guard_b, guard_w * 0.5, color)
	draw_line(hand - unit * 9.0, base, Color.BLACK, CHIBI_GRIP_W, true)
	if k > 0.0:
		var half := blade_w * 0.5
		var outline := PackedVector2Array([base - across * half, tip - across * half])
		for i in range(1, 8):
			var a := -PI * 0.5 + PI * float(i) / 8.0
			outline.append(tip + (unit * cos(a) + across * sin(a)) * half)
		outline.append(tip + across * half)
		outline.append(base + across * half)
		outline.append(base - across * half)
		Sketch.line(self, outline, 780, CHIBI_BIG_LINE, CHIBI_BIG_SCRIBBLE, Color(Sketch.INK, k))

## ธนูสั้นป้อม ปลายกลม สายบาง
func _draw_chibi_bow(hand: Vector2) -> void:
	var limb := PackedVector2Array()
	for i in 17:
		var t := float(i) / 8.0 - 1.0
		limb.append(hand + Vector2(CHIBI_BOW_DEPTH * (1.0 - t * t) - CHIBI_BOW_DEPTH * 0.5, t * CHIBI_BOW_HALF))
	draw_line(limb[0], limb[16], Color.BLACK, CHIBI_BOW_STRING, true)
	draw_polyline(limb, Color.BLACK, CHIBI_BOW_W, true)
	draw_circle(limb[0], CHIBI_BOW_TIP, Color.BLACK)
	draw_circle(limb[16], CHIBI_BOW_TIP, Color.BLACK)

## ตำแหน่งมือและมุมดาบของท่าที่กำลังเล่น ใช้ทั้งตัว 2 มิติและโมเดล 3 มิติ
func plain_pose(bob: float) -> Array:
	var hand := plain_hand(bob)
	var sword_angle := _sw
	if plain_override:
		sword_angle = plain_sw
		hand = plain_hand_at + Vector2(0.0, bob)
	elif plain_swing > 0.0 and plain_swing_kind == "combo":
		pass  # โมเดลคำนวณท่าคอมโบเอง ตรงนี้คืนท่ายืนไว้ให้เบลนด์กลับ
	elif plain_swing > 0.0 and plain_swing_kind == "pound":
		var slam := minf(plain_swing / CHIBI_POUND_DOWN, 1.0)
		slam *= slam
		var rest := maxf((plain_swing - CHIBI_POUND_BACK) / (1.0 - CHIBI_POUND_BACK), 0.0)
		sword_angle = lerpf(lerpf(CHIBI_POUND_FROM, CHIBI_POUND_TO, slam), _sw, rest)
		hand = CHIBI_POUND_HIGH.lerp(CHIBI_POUND_LOW, slam).lerp(hand, rest)
	elif plain_swing > 0.0 and plain_swing_kind == "slash":
		var stroke := plain_swing * float(CHIBI_SLASH_COUNT)
		var nth := mini(int(stroke), CHIBI_SLASH_COUNT - 1)
		var u := minf((stroke - float(nth)) * 1.6, 1.0)
		u = 1.0 - (1.0 - u) * (1.0 - u)
		var pose: Array = CHIBI_SLASHES[nth]
		var rest := maxf((plain_swing - CHIBI_SLASH_BACK) / (1.0 - CHIBI_SLASH_BACK), 0.0)
		sword_angle = lerpf(lerpf(float(pose[0]), float(pose[1]), u), _sw, rest)
		hand = (pose[2] as Vector2).lerp(pose[3], u).lerp(hand, rest)
	elif plain_swing > 0.0 and plain_swing_kind == "stab":
		var down := minf(plain_swing / CHIBI_STAB_DOWN, 1.0)
		down *= down
		var rest := maxf((plain_swing - CHIBI_STAB_BACK) / (1.0 - CHIBI_STAB_BACK), 0.0)
		sword_angle = lerpf(CHIBI_STAB_ANGLE, _sw + 360.0, rest)
		hand = CHIBI_STAB_HIGH.lerp(CHIBI_STAB_LOW, down).lerp(hand, rest)
	elif plain_swing > 0.0:
		var up := minf(plain_swing / CHIBI_SWING_UP, 1.0)
		up = 1.0 - (1.0 - up) * (1.0 - up)
		var back := maxf((plain_swing - CHIBI_SWING_BACK) / (1.0 - CHIBI_SWING_BACK), 0.0)
		sword_angle = lerpf(lerpf(CHIBI_SWING_FROM, CHIBI_SWING_TO, up), _sw, back)
		hand = CHIBI_SWING_LOW.lerp(CHIBI_SWING_HIGH, up).lerp(hand, back)
	return [hand, sword_angle]

## ใส่โมเดล 3 มิติแทนตัววาด ส่งค่าว่างเพื่อกลับไปใช้ตัววาด
func use_model(style: String) -> void:
	if plain_model != null and plain_model.style == style:
		return
	if plain_model != null:
		plain_model.queue_free()
		plain_model = null
	if style != "":
		plain_model = ChibiModel.new()
		plain_model.hero = self
		plain_model.style = style
		add_child(plain_model)
	queue_redraw()

## ตัว chibi ดำล้วน หัว ตัว มือ เท้า ลอยแยกกัน ใช้ท่าทางจากคอมโบเดิม ไม่มีเอฟเฟก
func _draw_plain() -> void:
	if plain_model != null:
		return
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(_flip_x(), 1.0))
	var bob := sin(_clock * BOB_SPEED) * BOB
	var rim_color := Color(CHIBI_RIM_COLOR, plain_rim)
	if plain_rim > 0.0:
		_draw_chibi_feet(CHIBI_RIM, rim_color)
	_draw_chibi_feet()
	var pivot := Vector2(0.0, CHIBI_CENTER_Y + bob)
	var angle := deg_to_rad(-_lean * CHIBI_LEAN)
	var torso := _chibi_body(bob, angle, pivot)
	var head_at := pivot + (CHIBI_HEAD + Vector2(0.0, bob) - pivot).rotated(angle)
	if plain_rim > 0.0:
		var torso_loop := torso.duplicate()
		torso_loop.append(torso[0])
		draw_polyline(torso_loop, rim_color, CHIBI_RIM * 2.0, true)
		draw_circle(head_at, CHIBI_HEAD_R + CHIBI_RIM, rim_color)
	draw_colored_polygon(torso, Color.BLACK)
	draw_circle(head_at, CHIBI_HEAD_R, Color.BLACK)
	var pose := plain_pose(bob)
	var hand: Vector2 = pose[0]
	var sword_angle: float = pose[1]
	if plain_rim > 0.0:
		draw_circle(hand, CHIBI_HAND_R + CHIBI_RIM, rim_color)
	if plain_weapon == "bow":
		_draw_chibi_bow(hand)
	else:
		_draw_chibi_sword(hand, sword_angle)
	var off_rest := Vector2(-CHIBI_HAND.x, CHIBI_HAND.y + bob)
	var off_hand := _chibi_reach(off_rest.lerp(pivot + _off_to, _off_k), bob)
	if plain_override:
		off_hand = plain_off_at + Vector2(0.0, bob)
	if plain_rim > 0.0:
		draw_circle(off_hand, CHIBI_HAND_R * plain_off_scale + CHIBI_RIM, rim_color)
	draw_circle(off_hand, CHIBI_HAND_R * plain_off_scale, Color.BLACK)
	draw_circle(hand, CHIBI_HAND_R, Color.BLACK)

## ข้อต่อระหว่างสองจุด ความยาวท่อนคงที่ งอไปทาง bend
func _joint(a: Vector2, b: Vector2, part: float, bend: float) -> Vector2:
	var span := a.distance_to(b)
	var mid := a.lerp(b, 0.5)
	if span < 0.01:
		return mid + Vector2(bend * part, 0.0)
	var rise := sqrt(maxf(part * part - span * span * 0.25, 0.0))
	return mid + (b - a).orthogonal().normalized() * rise * bend

func _bone(a: Vector2, b: Vector2, c: Vector2) -> void:
	var color := _ink()
	draw_polyline(PackedVector2Array([a, b, c]), color, STICK_W, true)
	draw_circle(a, STICK_W * 0.5, color)
	draw_circle(b, STICK_W * 0.5, color)
	draw_circle(c, STICK_W * 0.5, color)

## ขาสองข้าง เดินสลับก้าว วิ่งก้าวยาว กลางอากาศงอขา เตะและกระทืบตามท่า
func _draw_stick_legs(body_y: float) -> void:
	var hip := Vector2(0.0, body_y + STICK_HIP)
	var stomping: bool = attacking and cur_move.get("stomp", false)
	var stepping := on_floor() and input_dir != 0.0 and not attacking
	var stride := STICK_RUN if dash_t > 0.0 else STICK_WALK
	for i in 2:
		var side := -1.0 if i == 0 else 1.0
		var foot := Vector2(side * STICK_STANCE, -STICK_W * 0.5)
		if stepping:
			var phase := _clock * STEP_SPEED + PI * i
			foot.x = cos(phase) * stride * signf(input_dir * facing)
			foot.y -= maxf(sin(phase), 0.0) * STEP_LIFT * 1.6
		elif not on_floor():
			foot = hip + Vector2(side * 18.0 + 8.0, STICK_AIR_LEG if i == 0 else STICK_AIR_LEG * 0.72)
		if i == 1 and _kick_k > 0.0:
			foot += Vector2(0.0, -STOMP_LIFT) * _kick_k if stomping else KICK_REACH * _kick_k
		_bone(hip, _joint(hip, foot, STICK_LEG, -1.0), foot)

## ลำตัวเส้นเดียว หัวกลมทึบ ไม่มีหน้า
func _draw_stick_body(body_y: float) -> void:
	var neck := Vector2(0.0, body_y + STICK_NECK)
	draw_line(Vector2(0.0, body_y + STICK_HIP), neck, _ink(), STICK_W + 1.5, true)
	draw_circle(Vector2(0.0, body_y + STICK_HEAD), STICK_HEAD_R, _ink())

func _draw_stick_arm(body_y: float, hand: Vector2, bend: float) -> void:
	var shoulder := Vector2(0.0, body_y + STICK_SHOULDER)
	# ถ้ามือไกลกว่าความยาวแขน แขนเหยียดตรงไปยังมือ
	var long := minf(STICK_ARM, maxf(shoulder.distance_to(hand) * 0.5, 1.0) + 1.0) if shoulder.distance_to(hand) > STICK_ARM * 2.0 else STICK_ARM
	_bone(shoulder, _joint(shoulder, hand, long, bend), hand)

## มือเป็นจุดทึบเดียวกับตัว
func _hand_dot(hand: Vector2) -> void:
	draw_circle(hand, STICK_HAND, _ink())

## ดาบหมุนในสามมิติแล้วฉายลงจอ ท่าฟันแนวนอนดาบจึงสั้นลงตอนหันเข้ากล้องเหมือนเกมเดิม
func _draw_sword(body_y: float) -> void:
	var hand := HAND + Vector2(0.0, body_y + BODY_GAP + FOOT_RY + BODY_HEIGHT * 0.5)
	hand += Vector2(_hand_off.x, -_hand_off.y) * CombatData.UNIT
	if _weapon == "drones":
		_draw_magic_hand(hand)
		_draw_drones()
		return
	if sword_hidden:
		_draw_magic_hand(hand)
		return
	var sw := deg_to_rad(_sw)
	var axis := Vector2(-sin(sw) * cos(deg_to_rad(_ry)), -cos(sw))
	if axis.length() < SHORTEST_BLADE:
		axis = axis.normalized() * SHORTEST_BLADE if axis.length() > 0.001 else Vector2.RIGHT * SHORTEST_BLADE
	var unit := axis.normalized()
	var side := unit.orthogonal()
	var base := hand + unit * 12.0
	var tip := base + axis * _weapon_long()
	if _weapon == "staff":
		_draw_staff(hand, unit, tip)
		return
	var half := BLADE_HALF
	var tip_long := BLADE_HALF * 2.0
	if _sword_style == "slim":
		half = SLIM_HALF
		tip_long = SLIM_TIP
	elif _sword_style == "square":
		half = SQUARE_HALF
	var shoulder := tip - unit * tip_long
	# ตัวดาบระบายแดงเป็นขีดเฉียง เส้นหมึกวาดทับทีหลัง
	_paint_taper = _sword_style != "square"
	_paint(base, unit, side, (tip - base).length(), half, BLADE_SEED)
	_paint_taper = true
	var blade := PackedVector2Array([
		base - side * half, shoulder - side * half, tip,
		shoulder + side * half, base + side * half, base - side * half,
	])
	if _sword_style == "square":
		blade = PackedVector2Array([base - side * half, tip - side * half, tip + side * half, base + side * half, base - side * half])
	Sketch.line(self, blade, BLADE_SEED)
	if _sword_style == "slim":
		# ร่องกลางใบดาบ ทำให้ดูเรียว
		Sketch.line(self, PackedVector2Array([base + unit * 8.0, shoulder]), BLADE_SEED + 9, 1.8, 0.2)
	# ด้ามและการ์ดเป็นแท่งแดงระบาย มีขอบหมึก
	var grip_end := base - unit * GRIP_LONG
	_painted_bar(base, grip_end, GRIP_THICK, BLADE_SEED + 5)
	if _sword_style == "slim":
		_draw_fancy_guard(base, unit, side)
	else:
		_painted_bar(base - side * GUARD_HALF, base + side * GUARD_HALF, GUARD_THICK, BLADE_SEED + 7)
	_hand_dot(hand)

## ที่กันมือของดาบเพรียว ปีกโค้งงอลงหาด้าม ปลายกลม มีเม็ดข้าวหลามตัดตรงกลาง
func _draw_fancy_guard(base: Vector2, unit: Vector2, side: Vector2) -> void:
	for s in [-1.0, 1.0]:
		var upper := PackedVector2Array()
		var lower := PackedVector2Array()
		for i in FANCY_STEPS + 1:
			var t := float(i) / FANCY_STEPS
			var mid: Vector2 = base + side * s * FANCY_GUARD * t - unit * FANCY_DROP * t * t
			var thick := FANCY_THICK * (1.0 - t * 0.45)
			upper.append(mid + unit * thick)
			lower.append(mid - unit * thick)
		lower.reverse()
		upper.append_array(lower)
		Sketch.hatch(self, upper, PAINT_RED)
		upper.append(upper[0])
		Sketch.line(self, upper, BLADE_SEED + 7, 2.2, 0.2)
		var end: Vector2 = base + side * s * FANCY_GUARD - unit * FANCY_DROP
		Sketch.shape(self, Sketch.oval(end, FANCY_END, FANCY_END, 12), BLADE_SEED + 8, 2.0, PAINT_RED)
	var gem := PackedVector2Array([base + unit * FANCY_GEM, base + side * FANCY_GEM, base - unit * FANCY_GEM, base - side * FANCY_GEM])
	draw_colored_polygon(gem, Sketch.PAPER)
	gem.append(gem[0])
	Sketch.line(self, gem, BLADE_SEED + 6, 2.2, 0.2)

## ระบายแบบเด็กฝึก: ขีดเฉียงทีละเส้นเป็นจังหวะ ยาวสั้นไม่เท่ากัน บางช่วงเว้นว่าง ไม่เต็มดาบ
func _paint(from: Vector2, unit: Vector2, side: Vector2, long: float, half: float, seed_no: int) -> void:
	var tip_from := long - half * 2.0 if _paint_taper else long
	var pts := PackedVector2Array([from - side * half, from + unit * tip_from - side * half])
	if _paint_taper:
		pts.append(from + unit * long)
	else:
		pts.append(from + unit * long + side * half)
	pts.append(from + unit * tip_from + side * half if _paint_taper else from + unit * long - side * half)
	if _paint_taper:
		pts.append(from + side * half)
	else:
		pts = PackedVector2Array([from - side * half, from + unit * long - side * half, from + unit * long + side * half, from + side * half])
	if Sketch.anime:
		Sketch.toon_fill(self, pts, PAINT_RED, false)
	else:
		Sketch.hatch(self, pts, PAINT_RED, seed_no)
	if Sketch.anime and long > half * 4.0:
		draw_line(from + unit * long * 0.08 - side * half * 0.5, from + unit * long * 0.8 - side * half * 0.5, Color(1.0, 0.86, 0.8), 3.0, true)

## ความกว้างของดาบเมื่อห่างจากปลายเท่านี้ ขีดจึงอยู่ในทรงปลายแหลม
func _taper(from_tip: float, half: float) -> float:
	if not _paint_taper:
		return 1.0
	return clampf(from_tip / (half * 2.0), 0.0, 1.0)

func _painted_bar(a: Vector2, b: Vector2, thick: float, seed_no: int) -> void:
	var unit := (b - a).normalized()
	var side := unit.orthogonal()
	_paint(a, unit, side, a.distance_to(b) + thick * 2.0, thick, seed_no)
	var edge := PackedVector2Array([a - side * thick, b - side * thick, b + side * thick, a + side * thick, a - side * thick])
	Sketch.line(self, edge, seed_no + 1, 2.2, 0.4)
