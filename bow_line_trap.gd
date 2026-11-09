class_name BowLineTrap
## คอมโบสาย TRAPSTARKER / TWILIGHT ของ CAT MATCHA
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย bwt_ เท่านั้น
## NEXT: ต่อท่าตามคลาส {คลาส: {ท่าปัจจุบัน: {ปุ่ม: ท่าถัดไป}}} ปุ่มเป็น "z" "x" "fwd_z" "down_x" เป็นต้น (คลาสลูกได้ท่าของคลาสแม่ด้วย)
## START: ท่าแรกตามคลาส {คลาส: {"สถานะ_ปุ่ม": ท่า}} สถานะ ground dash air airdash เช่น "dash_z"
## ดาบอยู่มือรอง (ดาบสั้นของ TRAPSTARKER / ดาบเรียวยาวของ TWILIGHT) ท่าดาบจึงขยับมือรองด้วย wind_off/end_off
## TRAPSTARKER: zzzzzzz เตะ 2 ที ฟันหลายมุม 3 ที แทง ดึงดาบออกมอนล้ม
##              >>zx สไลด์แล้วฟันทะลุไปด้านหน้า  >>^zx เตะเฉียงแล้วฟันโค้งอ้อมไปด้านหลัง
## TWILIGHT: >>xz<z> อ้อมยิงแล้วพุ่งแทง แทงรัวสูงสุด 8 ฮิต ฮิตสุดท้ายฟาดล้ม
##           zxxx เตะแล้วฟาดดาบหนัก ฮิตสุดท้ายชะงัก  >>^xz ยิงเฉียงแล้วพุ่งแทงเฉียงลงกระแทกพื้น

const MASH := 7                  # แทงรัวกี่ครั้งก่อนฟาดปิด รวมฟาดปิดเป็น 8 ฮิต

const NEXT := {
	"TRAPSTARKER": {
		"bw_z2": {"z": "bwt_z3"},
		"bwt_z3": {"z": "bwt_z4"}, "bwt_z4": {"z": "bwt_z5"}, "bwt_z5": {"z": "bwt_z6"}, "bwt_z6": {"z": "bwt_z7"},
		"bw_dz1": {"x": "bwt_slide_cut"},
		# >>^zx เตะกลางอากาศแบบ BASIC (ค้างกลางอากาศ) แล้วพุ่งดาบลงกระแทกพื้น
		"bwt_air_kick": {"x": "bwt_trap_dive"},
	},
	"TWILIGHT": {
		"bw_turn_shot": {"z": "bwt_tw_stab"},
		"bwt_tw_stab": {"z": "bwt_tw_m1"},
		"bwt_tw_m1": {"z": "bwt_tw_m2"}, "bwt_tw_m2": {"z": "bwt_tw_m3"}, "bwt_tw_m3": {"z": "bwt_tw_m4"},
		"bwt_tw_m4": {"z": "bwt_tw_m5"}, "bwt_tw_m5": {"z": "bwt_tw_m6"}, "bwt_tw_m6": {"z": "bwt_tw_m7"},
		"bwt_tw_m7": {"z": "bwt_tw_finish"},
		"bw_z1": {"x": "bwt_tw_h1"}, "bwt_tw_h1": {"x": "bwt_tw_h2"}, "bwt_tw_h2": {"x": "bwt_tw_h3"},
		"bw_adx1": {"z": "bwt_tw_dive"},
	},
}
const START := {"TRAPSTARKER": {"airdash_z": "bwt_air_kick"}}

## ท่าดาบมือรอง ไม่ใช้ท่าเตะ มือถือธนูหลบไปด้านหลัง
static func _sword(kick: Dictionary, over: Dictionary) -> Dictionary:
	var d := kick.duplicate(true)
	d.erase("kick")
	d["wind_hand"] = Vector3(-0.35, -0.15, -0.1)
	d["end_hand"] = Vector3(-0.4, -0.2, -0.1)
	d["front_hit"] = true
	d["no_trail"] = true
	d.merge(over, true)
	return d

## เพิ่มท่าลงตาราง m  base มี "kick" "shoot" "shoot45" "shoot_down" ของ BowCombo
static func add_moves(m: Dictionary, base: Dictionary) -> void:
	var kick: Dictionary = base["kick"]
	# ---- TRAPSTARKER zzzzzzz (z1 z2 เตะของ BASIC) ----
	m["bwt_z3"] = _sword(kick, {"name": "ฟันเฉียงลง", "off_aim_wind": 120.0, "off_aim_end": -50.0, "wind_off": Vector3(0.05, 0.5, 0.1), "end_off": Vector3(0.6, -0.3, 0.15), "time": 0.32, "wind": 0.25, "strike": 0.5, "next": 0.6, "dmg": 10.5, "lunge": 0.35, "lean": 15.0, "twist": 20.0, "fx": "bwt_slash_down", "hit": {"kb": 0.8, "stun": 0.5}})
	m["bwt_z4"] = _sword(kick, {"name": "ฟันเสยขึ้น", "off_aim_wind": -60.0, "off_aim_end": 110.0, "wind_off": Vector3(0.55, -0.3, 0.1), "end_off": Vector3(0.15, 0.55, 0.1), "time": 0.32, "wind": 0.22, "strike": 0.5, "next": 0.6, "dmg": 10.5, "lunge": 0.3, "lean": -15.0, "twist": -15.0, "fx": "bwt_slash_up", "hit": {"kb": 0.8, "stun": 0.5}})
	m["bwt_z5"] = _sword(kick, {"name": "หมุนตัวฟันแนวนอน", "off_aim_wind": 170.0, "off_aim_end": 0.0, "wind_off": Vector3(-0.35, 0.05, -0.3), "end_off": Vector3(0.6, 0.05, 0.2), "time": 0.38, "wind": 0.2, "strike": 0.55, "next": 0.65, "dmg": 11.0, "lunge": 0.35, "spin": 360.0, "fx": "bwt_slash_flat", "hit": {"kb": 0.9, "stun": 0.55}})
	m["bwt_z6"] = _sword(kick, {"name": "แทงดาบ", "off_aim_wind": 0.0, "off_aim_end": 0.0, "wind_off": Vector3(-0.05, 0.05, 0.0), "end_off": Vector3(0.8, 0.0, 0.1), "time": 0.34, "wind": 0.35, "strike": 0.55, "next": 0.65, "dmg": 13.0, "lunge": 0.6, "lean": 22.0, "fx": "bwt_stab", "hit": {"kb": 0.3, "stun": 0.8}})
	m["bwt_z7"] = _sword(kick, {"name": "ดึงดาบออกมอนล้ม", "off_aim_wind": 0.0, "off_aim_end": 140.0, "wind_off": Vector3(0.8, 0.0, 0.1), "end_off": Vector3(-0.25, 0.35, 0.0), "time": 0.46, "wind": 0.3, "strike": 0.5, "next": 0.9, "dmg": 19.0, "lunge": -0.25, "lean": -22.0, "shake": 0.22, "fx": "bwt_pull", "hit": {"type": "knockdown", "fly": 6.0}})
	# >>zx สไลด์แล้วฟันทะลุไปด้านหน้า
	m["bwt_slide_cut"] = _sword(kick, {"name": "ฟันทะลุ", "off_aim_wind": 160.0, "off_aim_end": -10.0, "wind_off": Vector3(-0.3, 0.1, -0.2), "end_off": Vector3(0.7, 0.0, 0.15), "time": 0.42, "wind": 0.15, "strike": 0.7, "next": 0.82, "dmg": 18.0, "lunge": 2.6, "ghost": true, "lean": 30.0, "shake": 0.18, "fx_start": "bwt_through", "fx": "bwt_through_hit", "wide": true, "wide_half": 150.0, "hit": {"kb": 1.4, "stun": 0.7}})
	# >>^zx ฟันโค้งอ้อมไปด้านหลังมอน
	m["bwt_air_curve"] = _sword(kick, {"name": "ฟันโค้งอ้อมหลัง", "off_aim_wind": 80.0, "off_aim_end": -160.0, "wind_off": Vector3(0.4, 0.5, 0.1), "end_off": Vector3(-0.5, -0.1, -0.1), "time": 0.48, "wind": 0.15, "strike": 0.65, "next": 0.82, "dmg": 17.0, "lunge": 1.8, "ghost": true, "spin": -360.0, "lean": 20.0, "shake": 0.18, "fx_start": "bwt_curve", "wide": true, "wide_half": 170.0, "hit": {"kb": 0.6, "stun": 0.7}})
	var air_kick: Dictionary = (m["bw_adz"] as Dictionary).duplicate(true)
	air_kick.erase("dive")
	air_kick.erase("dive_forward")
	air_kick["hover"] = true
	air_kick["name"] = "เตะกลางอากาศ"
	m["bwt_air_kick"] = air_kick
	m["bwt_trap_dive"] = _sword(kick, {"name": "พุ่งดาบลงกระแทกพื้น", "off_aim_wind": -20.0, "off_aim_end": -60.0, "wind_off": Vector3(0.2, 0.2, 0.05), "end_off": Vector3(0.65, -0.45, 0.1), "time": 0.42, "wind": 0.2, "strike": 0.55, "next": 0.85, "dmg": 20.0, "dive": true, "dive_forward": 4.0, "lunge": 0.3, "lean": 35.0, "shake": 0.28, "fx_start": "bwt_dive_streak", "fx": "bwt_ground", "wide": true, "wide_half": 160.0, "hit": {"kb": 1.0, "stun": 0.8}})
	# ---- TWILIGHT ----
	# >>x อ้อมแล้วหันหลังยิง  z พุ่งแทงด้านหน้าอย่างเร็ว
	m["bwt_tw_stab"] = _sword(kick, {"name": "พุ่งแทงเร็ว", "off_aim_wind": 0.0, "off_aim_end": 0.0, "wind_off": Vector3(-0.05, 0.05, 0.0), "end_off": Vector3(0.85, 0.0, 0.1), "time": 0.3, "wind": 0.15, "strike": 0.55, "next": 0.62, "dmg": 16.0, "lunge": 1.6, "lean": 28.0, "fx": "bwt_stab", "fx_start": "bwt_rush", "hit": {"kb": 0.3, "stun": 0.8}})
	# <z> แทงรัว สลับสูงต่ำ
	var heights := [0.1, -0.05, 0.18, -0.1, 0.05, 0.2, -0.02]
	for i in MASH:
		var hy: float = heights[i]
		m["bwt_tw_m%d" % (i + 1)] = _sword(kick, {"name": "แทงรัว %d" % (i + 1), "off_aim_wind": 5.0, "off_aim_end": 0.0, "wind_off": Vector3(0.1, hy, 0.05), "end_off": Vector3(0.85, hy * 0.6, 0.1), "time": 0.17, "wind": 0.3, "strike": 0.5, "next": 0.5, "dmg": 7.0, "lunge": 0.06, "lean": 22.0, "shake": 0.05, "stop": 0.02, "fx": "bwt_mash", "hit": {"kb": 0.05, "stun": 0.5}})
	m["bwt_tw_finish"] = _sword(kick, {"name": "ฟาดดาบปิดล้ม", "off_aim_wind": 130.0, "off_aim_end": -60.0, "wind_off": Vector3(-0.1, 0.6, -0.1), "end_off": Vector3(0.65, -0.35, 0.15), "time": 0.5, "wind": 0.4, "strike": 0.55, "next": 0.95, "dmg": 30.0, "lunge": 0.4, "lean": 25.0, "twist": 20.0, "shake": 0.3, "stop": 0.1, "fx": "bwt_heavy", "hit": {"type": "knockdown", "fly": 7.0}})
	# zxxx เตะแล้วฟาดดาบหนัก ฮิตสุดท้ายชะงัก
	m["bwt_tw_h1"] = _sword(kick, {"name": "ฟาดดาบหนัก", "off_aim_wind": 130.0, "off_aim_end": -50.0, "wind_off": Vector3(0.0, 0.6, -0.1), "end_off": Vector3(0.65, -0.3, 0.15), "time": 0.44, "wind": 0.38, "strike": 0.55, "next": 0.7, "dmg": 15.0, "lunge": 0.35, "lean": 20.0, "twist": 15.0, "shake": 0.2, "stop": 0.06, "fx": "bwt_slash_down", "hit": {"kb": 0.9, "stun": 0.6}})
	m["bwt_tw_h2"] = _sword(kick, {"name": "ฟาดดาบหนักย้อน", "off_aim_wind": -50.0, "off_aim_end": 120.0, "wind_off": Vector3(0.6, -0.3, 0.15), "end_off": Vector3(-0.1, 0.55, -0.1), "time": 0.44, "wind": 0.3, "strike": 0.55, "next": 0.7, "dmg": 16.5, "lunge": 0.35, "lean": -15.0, "twist": -15.0, "shake": 0.22, "stop": 0.06, "fx": "bwt_slash_up", "hit": {"kb": 0.9, "stun": 0.6}})
	m["bwt_tw_h3"] = _sword(kick, {"name": "ฟาดดาบหนักชะงัก", "off_aim_wind": 135.0, "off_aim_end": -65.0, "wind_off": Vector3(-0.2, 0.65, -0.15), "end_off": Vector3(0.7, -0.35, 0.15), "time": 0.55, "wind": 0.45, "strike": 0.58, "next": 0.95, "dmg": 21.5, "lunge": 0.4, "lean": 28.0, "twist": 20.0, "shake": 0.3, "stop": 0.12, "fx": "bwt_heavy", "hit": {"kb": 0.4, "stun": 1.6, "real_stun": true}})
	# >>^xz พุ่งแทงเฉียงลงกระแทกพื้น
	m["bwt_tw_dive"] = _sword(kick, {"name": "พุ่งแทงเฉียงลง", "off_aim_wind": -20.0, "off_aim_end": -45.0, "wind_off": Vector3(0.2, 0.2, 0.05), "end_off": Vector3(0.7, -0.45, 0.1), "time": 0.42, "wind": 0.2, "strike": 0.55, "next": 0.85, "dmg": 24.0, "dive": true, "dive_forward": 5.0, "lunge": 0.3, "lean": 35.0, "shake": 0.3, "fx_start": "bwt_dive_streak", "fx": "bwt_ground", "wide": true, "wide_half": 170.0, "hit": {"kb": 1.0, "stun": 0.8}})

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(caster: MageCaster, fx: String) -> bool:
	if not fx.begins_with("bwt_"):
		return false
	var node := BowTrapFx.new()
	node.kind = fx.trim_prefix("bwt_")
	node.dir = caster.hero.facing
	node.dusk = WalkPage.chosen_class == "TWILIGHT"
	node.position = caster.hero.position
	if node.kind in ["through", "curve", "rush", "dive_streak"]:
		node.follow = caster.hero
	caster.page.world.add_child(node)
	return true
