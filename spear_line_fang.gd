class_name SpearLineFang
## คอมโบสาย PETIT FANG / LUPINE DIRE ของ CAT CITRUS
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย spf_ เท่านั้น
## PETIT FANG:  >>zx ยิงบอลหมาป่า 3 ลูกทะลุ   >>xzx หมุนฟาดอ้อมหลังหันกลับ แล้วยิง 3 ลูกทะลุ   >>^zx ยิง 3 ลูกเฉียงลงทะลุ
## LUPINE DIRE: zzzz>z ยิงบอลหมาป่า 1 ลูกไม่ทะลุ   >>^xzx ตวัดหอกกลับที่เดิม แล้วยิง 3 ลูกเฉียงลงทะลุ   xx ลงx ลงx ยิง 3 ลูกทะลุ

const NEXT := {
	"PETIT FANG": {
		"sp_dz": {"x": "spf_volley"},
		"sp_dx": {"z": "spf_spin_around"},
		"spf_spin_around": {"x": "spf_volley"},
		"spf_turn": {"x": "spf_volley"},
		"sp_adz1": {"x": "spf_volley_down"},
	},
	"LUPINE DIRE": {
		"sp_z4": {"fwd_z": "spf_ball1"},
		# >>^xzx  x กระโดดตวัดหมุนตัว  z ตวัดทะลุไปแล้วตวัดกลับที่เดิม  x หันกลับแล้วยิงบอลหมาป่า 3 ลูก
		"sp_adx": {"z": "spf_flick_back"},
		"spf_flick_back": {"x": "spf_turn_volley"},
		"spf_flick_return": {"x": "spf_turn_volley"},
		# xx ลงx ยิง 3 ลูกไปหน้าทะลุ
		"sp_x2": {"down_x": "spf_volley_low"},
	},
}
const START := {}

const BALL_SPEED := 950.0
const BALL_R := 54.0
const VOLLEY_DMG := 7.5
const DIAG_DMG := 12.0             # ยิงเฉียงลงโดนยากกว่า
const SINGLE_DMG := 12.0

## เพิ่มท่าลงตาราง m
static func add_moves(m: Dictionary) -> void:
	var stab: Dictionary = m["sp_z1"]
	var sweep: Dictionary = m["sp_x1"]
	# ท่ายิงบอล ดันหอกไปข้างหน้าค้างไว้ บอลออกจากปลายหอก
	var shoot := SpearCombo._mv(stab, {"name": "ยิงบอลหมาป่า 3 ลูก", "lunge": 0.15, "time": 0.46, "wind": 0.3, "strike": 0.45, "next": 0.82, "dmg": 0.0, "no_hit": true,
		"shake": 0.12, "stop": 0.0, "fx": "spf_balls3", "hit": {}})
	m["spf_volley"] = shoot
	# ยิงเฉียงลงกลางอากาศ หอกชี้เฉียงลง
	m["spf_volley_down"] = SpearCombo._mv(shoot, {"name": "ยิงบอลหมาป่าเฉียงลง", "hover": true, "wind_hand": Vector3(-0.2, 0.3, 0.12), "wind_aim": Vector2(25.0, 0.0),
		"end_hand": Vector3(0.65, -0.35, 0.0), "end_aim": Vector2(-38.0, 0.0), "lean": 30.0, "fx": "spf_balls3_down"})
	# xx ลงx ลงx: แทงต่ำ แล้วแทงต่ำยิง 3 ลูกไปหน้า
	m["spf_low_stab"] = SpearCombo._mv(stab, {"name": "แทงต่ำ", "wind_hand": Vector3(-0.3, -0.3, 0.12), "end_hand": Vector3(0.75, -0.42, 0.0), "end_aim": Vector2(-12.0, 0.0),
		"lean": 34.0, "dmg": 12.0, "hit": {"kb": 0.6, "stun": 0.55}})
	m["spf_volley_low"] = SpearCombo._mv(shoot, {"name": "แทงต่ำยิงบอลหมาป่า 3 ลูก", "wind_hand": Vector3(-0.3, -0.3, 0.12), "end_hand": Vector3(0.75, -0.4, 0.0), "end_aim": Vector2(-8.0, 0.0), "lean": 30.0})
	# zzzz>z ยิงบอลลูกเดียว ไม่ทะลุ
	m["spf_ball1"] = SpearCombo._mv(shoot, {"name": "ยิงบอลหมาป่าลูกเดียว", "time": 0.4, "next": 0.8, "fx": "spf_ball1"})
	# >>xzx: หมุนตัวฟาดทะลุไปด้านหลังมอน แล้วหันกลับ
	m["spf_spin_around"] = SpearCombo._mv(sweep, {"name": "หมุนฟาดอ้อมหลัง", "spin": 360.0, "ghost": true, "lunge": 1.9, "time": 0.42, "wind": 0.2, "strike": 0.55, "next": 0.82,
		"dmg": 12.0, "fx": "sp_spin", "auto": "spf_turn", "hit": {"kb": 0.6, "stun": 0.6}})
	m["spf_turn"] = SpearCombo._mv(sweep, {"name": "หันกลับ", "turn_around": true, "lunge": 0.0, "time": 0.36, "wind": 0.3, "strike": 0.4, "next": 0.4, "dmg": 0.0, "no_hit": true, "fx": ""})
	# >>^xzx: ตวัดหอกพากลับไปที่เดิม (ถอยกลับทางเดิมกลางอากาศ)
	# ตวัดหมุนตัวทะลุไปอีกด้าน แล้วหันตวัดกลับมาที่เดิม (หลังหันใส่มอน)
	m["spf_flick_back"] = SpearCombo._mv(sweep, {"name": "ตวัดหมุนตัวทะลุไป", "spin": 360.0, "hover": true, "ghost": true, "lunge": 1.9, "time": 0.4, "wind": 0.2, "strike": 0.55, "next": 0.8,
		"dmg": 10.0, "fx": "sp_spin", "auto": "spf_flick_return", "hit": {"kb": 0.3, "stun": 0.6}})
	m["spf_flick_return"] = SpearCombo._mv(sweep, {"name": "ตวัดกลับที่เดิม", "turn_around": true, "spin": 360.0, "hover": true, "ghost": true, "lunge": 1.9, "time": 0.4, "wind": 0.2, "strike": 0.55, "next": 0.8,
		"dmg": 10.0, "fx": "sp_spin", "hit": {"kb": 0.3, "stun": 0.6}})
	# หันกลับแล้วยิงบอลหมาป่า 3 ลูกใส่มอนที่อยู่ข้างหลัง
	# หันกลับแล้วยิงบอลหมาป่า 3 ลูกเฉียงลง
	m["spf_turn_volley"] = SpearCombo._mv(m["spf_volley_down"], {"name": "หันกลับยิงบอลหมาป่าเฉียงลง", "turn_around": true})

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(page: WalkPage, fx: String) -> bool:
	if not fx.begins_with("spf_"):
		return false
	var f := page.hero.facing
	match fx:
		"spf_balls3":
			_volley(page, Vector2(f, 0.0), true, 3, VOLLEY_DMG)
		"spf_balls3_down":
			_volley(page, Vector2(f, 0.85).normalized(), true, 3, DIAG_DMG)
		"spf_ball1":
			_volley(page, Vector2(f, 0.0), false, 1, SINGLE_DMG)
	return true

## ยิงบอลหมาป่าทีละลูกห่างกันนิด ความสูงสลับกันเล็กน้อย
static func _volley(page: WalkPage, dir: Vector2, pierce: bool, count: int, dmg: float) -> void:
	var lifts := [0.0, -36.0, 30.0]
	for i in count:
		var delay := float(i) * 0.09
		var lift: float = lifts[i % 3]
		if delay <= 0.0:
			_spawn(page, dir, pierce, dmg, lift)
		else:
			page.get_tree().create_timer(delay, false).timeout.connect(func() -> void:
				if is_instance_valid(page) and is_instance_valid(page.hero):
					_spawn(page, dir, pierce, dmg, lift))

static func _spawn(page: WalkPage, dir: Vector2, pierce: bool, dmg: float, lift: float) -> void:
	var b := WolfBall.new()
	var f := page.hero.facing
	b.position = page.hero.position + Vector2(f * 95.0, -85.0 + lift)
	b.vel = dir * BALL_SPEED
	b.radius = BALL_R if pierce else BALL_R * 1.1
	b.dmg = dmg
	b.pierce = pierce
	b.extra = {} if pierce else {"kb": 1.2, "stun": 0.6}
	page.world.add_child(b)
