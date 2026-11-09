class_name SpearLineShell
## คอมโบสาย PETIT SHELL / GENBU TITAN ของ CAT CITRUS
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย sps_ เท่านั้น
## PETIT SHELL: >>^zx ปายันต์เฉียงลง 2 ใบ   >>xz ปายันต์ไปหน้า 1 ใบทะลุมอน   >>^xz ปายันต์เฉียงลง
## GENBU TITAN: zzxx ปายันต์ลง 2 ใบ   >>^zxx แทงหอกขึ้นฟ้า แล้วกระทืบพื้นมอนลอยต่ำ   >>zx พุ่งชนมอนลอย

const NEXT := {
	"PETIT SHELL": {
		# >>^zx
		"sp_adz1": {"x": "sps_toss2_down"},
		# >>xz
		"sp_dx": {"z": "sps_toss_pierce"},
		# >>^xz
		"sp_adx": {"z": "sps_toss_down"},
	},
	"GENBU TITAN": {
		# zzxx: zzx ดีดตัวถอยหลังเสยลอย แล้ว x ปายันต์ลง 2 ใบ
		"sp_zzx": {"x": "sps_toss2_low"},
		# >>^zxx (ทับ >>^zx ของ PETIT SHELL)
		"sp_adz1": {"x": "sps_sky_thrust"},
		"sps_sky_thrust": {"x": "sps_stomp"},
		# >>zx
		"sp_dz": {"x": "sps_ram"},
	},
}
const START := {}

const TALIS_SPEED := 900.0
const TALIS_R := 44.0
const TOSS_DMG := 14.0
const PIERCE_DMG := 18.0

## เพิ่มท่าลงตาราง m
static func add_moves(m: Dictionary) -> void:
	var stab: Dictionary = m["sp_z1"]
	var chop: Dictionary = m["sp_az"]
	var lift: Dictionary = m["sp_ax"]
	# ท่าปายันต์ มือรองสะบัดไปข้างหน้า หอกถือไว้
	var toss := SpearCombo._mv(stab, {"name": "ปายันต์", "lunge": 0.1, "time": 0.42, "wind": 0.3, "strike": 0.45, "next": 0.8, "dmg": 0.0, "no_hit": true,
		"shake": 0.08, "stop": 0.0, "twist": -20.0, "fx": "sps_toss_pierce", "hit": {}})
	m["sps_toss_pierce"] = SpearCombo._mv(toss, {"name": "ปายันต์ทะลุ"})
	m["sps_toss_down"] = SpearCombo._mv(toss, {"name": "ปายันต์เฉียงลง", "hover": true, "lean": 25.0, "fx": "sps_toss_down"})
	m["sps_toss2_down"] = SpearCombo._mv(toss, {"name": "ปายันต์เฉียงลง 2 ใบ", "hover": true, "lean": 25.0, "fx": "sps_toss2_down"})
	m["sps_toss2_low"] = SpearCombo._mv(toss, {"name": "ปายันต์ลง 2 ใบ", "hover": true, "lean": 30.0, "fx": "sps_toss2_low"})
	# GENBU >>^zxx: แทงหอกขึ้นฟ้า แล้วกระทืบพื้นมอนลอยต่ำ
	m["sps_sky_thrust"] = SpearCombo._mv(lift, {"name": "แทงหอกขึ้นฟ้า", "hover": true, "time": 0.4, "next": 0.8, "dmg": 12.0, "lunge": 0.2,
		"wind_hand": Vector3(0.2, 0.0, 0.1), "end_hand": Vector3(0.35, 0.75, 0.1), "wind_aim": Vector2(60.0, 0.0), "end_aim": Vector2(88.0, 0.0),
		"fx": "sp_up", "hit": {"kb": 0.2, "stun": 0.8}})
	m["sps_stomp"] = SpearCombo._mv(chop, {"name": "กระทืบพื้นกระดองเต่า", "hover": null, "dive": true, "time": 0.42, "wind": 0.2, "strike": 0.5, "next": 0.85,
		"dmg": 18.0, "lunge": 0.0, "shake": 0.26, "stop": 0.08, "wide": true, "wide_half": 200.0, "fx": "sps_quake", "hit": {"type": "launch", "vy": 5.0}})
	m["sps_stomp"].erase("hover")
	# GENBU >>zx: พุ่งชนด้านหน้า มอนลอย
	m["sps_ram"] = SpearCombo._mv(stab, {"name": "พุ่งชนกระดอง", "time": 0.42, "wind": 0.15, "strike": 0.6, "next": 0.85, "dmg": 18.0, "lunge": 1.8, "lean": 25.0,
		"front_hit": true, "shake": 0.2, "stop": 0.06, "fx": "sps_ram", "hit": {"type": "launch", "vy": 9.0}})

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(page: WalkPage, fx: String) -> bool:
	if not fx.begins_with("sps_"):
		return false
	var f := page.hero.facing
	match fx:
		"sps_toss_pierce":
			_throw(page, [Vector2(f, 0.0)], true, PIERCE_DMG)
		"sps_toss_down":
			_throw(page, [Vector2(f, 0.85).normalized()], false, TOSS_DMG)
		"sps_toss2_down":
			_throw(page, [Vector2(f, 0.7).normalized(), Vector2(f, 1.15).normalized()], false, TOSS_DMG)
		"sps_toss2_low":
			_throw(page, [Vector2(f * 0.6, 1.0).normalized(), Vector2(f, 0.6).normalized()], false, TOSS_DMG)
		"sps_quake", "sps_ram":
			# วงกระแทกเขียวทองบนพื้น ใช้รอยหอกเดิมแบบฟาดพื้น
			SpearFx.cast(page, "sp_ground")
	return true

## ปายันต์ทีละใบห่างกันนิด
static func _throw(page: WalkPage, dirs: Array, pierce: bool, dmg: float) -> void:
	for i in dirs.size():
		var dir: Vector2 = dirs[i]
		var delay := float(i) * 0.1
		if delay <= 0.0:
			_spawn(page, dir, pierce, dmg)
		else:
			page.get_tree().create_timer(delay, false).timeout.connect(func() -> void:
				if is_instance_valid(page) and is_instance_valid(page.hero):
					_spawn(page, dir, pierce, dmg))

static func _spawn(page: WalkPage, dir: Vector2, pierce: bool, dmg: float) -> void:
	var t := Talisman.new()
	var f := page.hero.facing
	t.position = page.hero.position + Vector2(f * 80.0, -90.0)
	t.vel = dir * TALIS_SPEED
	t.radius = TALIS_R
	t.dmg = dmg
	t.pierce = pierce
	t.life = 1.3
	t.extra = {} if pierce else {"kb": 0.8, "stun": 0.7}
	page.world.add_child(t)
