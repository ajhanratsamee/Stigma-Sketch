class_name MageCombo
## คอมโบของ CAT SUSI ทุกสาย ท่าใช้ระบบเดียวกับคอมโบแมว (walk_page._tick_combo) แต่แยกตารางของตัวเอง
## ทุกสายต่อยอดจากคอมโบของ BASIC เสมอ เว้นแต่ผู้ออกแบบระบุว่าเป็นท่าใหม่ (BATTLE zzzzz, ALCHEMIST zz↓z)
## repeat กดรัวต่อท่าเดิมได้สูงสุดกี่ครั้ง  fx_start เวทตอนเริ่มท่า  fx เวทตอนถึงจุดฟาด (MageCaster)

## สายแม่ของแต่ละคลาส
const PARENT := {"ELEMENT MASTER": "ARCH MAGE", "DIMENSION CASTER": "BATTLE MAGE", "ECLIPSE": "DARK MAGE", "TRANSMUTATION MASTER": "ALCHEMIST MAGE", "ARCH MAGE": "BASIC", "BATTLE MAGE": "BASIC", "DARK MAGE": "BASIC", "ALCHEMIST MAGE": "BASIC"}

## ท่าต่อ ปุ่ม z x หรือ down_z (กดลงค้าง+z) fwd_z (กดหน้าค้าง+z)
const NEXT := {
	"BASIC": {
		"mg_z1": {"z": "mg_z2"}, "mg_z2": {"z": "mg_z3", "down_z": "mg_lift"},
		"mg_x1": {"x": "mg_x2"}, "mg_x2": {"x": "mg_x3"}, "mg_x3": {"x": "mg_x4"},
		"mg_dz1": {"z": "mg_dz2"},
		"mg_adx1": {"x": "mg_adx2"},
	},
	"ARCH MAGE": {
		"mg_x2": {"z": "mg_cloud"}, "mg_cloud_point": {"z": "mg_bolt"}, "mg_bolt": {"z": "mg_bolt"},
		"mg_z2": {"x": "mg_gflame"}, "mg_gflame": {"x": "mg_rapid"}, "mg_rapid": {"x": "mg_rapid"},
		"mg_adx2": {"x": "mg_adx3"},
	},
	"ELEMENT MASTER": {
		"mg_turn_shot": {"x": "mg_turn_shot2", "z": "mg_ice"},
		"mg_adx1": {"z": "mg_spark"},
	},
	"BATTLE MAGE": {
		"mg_bz1": {"z": "mg_bz2"}, "mg_bz2": {"z": "mg_bz3", "down_z": "mg_lift"}, "mg_bz3": {"z": "mg_bz4"}, "mg_bz4": {"z": "mg_bz5"},
		"mg_adz": {"x": "mg_warp"}, "mg_warp": {"x": "mg_thrust"}, "mg_thrust": {"x": "mg_rise"},
		"mg_turn_shot": {"x": "mg_dust"},
	},
	"DIMENSION CASTER": {
		"mg_dust": {"z": "mg_recall"},
		"mg_z2": {"x": "mg_dust2"}, "mg_bz2": {"x": "mg_dust2"}, "mg_dust2": {"x": "mg_recall"},
		"mg_rise": {"x": "mg_dimslam"},
	},
	"DARK MAGE": {
		"mg_turn_shot": {"x": "mg_dark_stay"},
		"mg_z2": {"down_z": "mg_slam_ground"},
		"mg_x2": {"z": "mg_dark_mash"}, "mg_dark_mash": {"z": "mg_dark_mash"},
	},
	"ECLIPSE": {
		"mg_z2": {"x": "mg_ec_hold"},
		"mg_adx1": {"x": "mg_ec_adx2"},
		"mg_x1": {"z": "mg_ec_z1"}, "mg_ec_z1": {"z": "mg_ec_z2"}, "mg_ec_z2": {"z": "mg_ec_z3"},
	},
	"ALCHEMIST MAGE": {
		"mg_turn_shot": {"x": "mg_hop_toss"},
		"mg_z2": {"down_z": "mg_potion_up"},
		"mg_x2": {"z": "mg_back_toss"},
	},
	"TRANSMUTATION MASTER": {
		"mg_dz2": {"x": "mg_potion_rain"}, "mg_potion_rain": {"x": "mg_cauldron"},
		"mg_adx1": {"z": "mg_spin_toss"},
		"mg_z2": {"fwd_z": "mg_potion_bash"},
	},
}

static var _moves := {}

## คลาสนี้และสายแม่ทั้งหมด เรียงจากคลาสนี้ขึ้นไปถึง BASIC
static func chain(class_id: String) -> Array:
	var out := []
	var id := class_id if class_id != "" else "BASIC"
	while id != "":
		out.append(id)
		id = PARENT.get(id, "") if id != "BASIC" else ""
	if not "BASIC" in out:
		out.append("BASIC")
	return out

## ท่าแรกตามสถานะ ground dash air airdash
static func start(class_id: String, state: String, button: String) -> String:
	var battle := "BATTLE MAGE" in chain(class_id)
	match state:
		"dash":
			return "mg_dz1" if button == "z" else "mg_dx"
		"air":
			return "mg_az" if button == "z" else "mg_ax"
		"airdash":
			return "mg_adz" if button == "z" else "mg_adx1"
	if button == "z":
		return "mg_bz1" if battle else "mg_z1"
	return "mg_x1"

## ท่าถัดไป สายลูกทับสายแม่ กดลงหรือกดหน้าค้างไว้ใช้ท่าพิเศษก่อน
static func next(class_id: String, current: String, button: String, down: bool, forward: bool) -> String:
	var keys := []
	if down:
		keys.append("down_" + button)
	if forward:
		keys.append("fwd_" + button)
	keys.append(button)
	for key in keys:
		for id in chain(class_id):
			var table: Dictionary = NEXT.get(id, {})
			var found: String = (table.get(current, {}) as Dictionary).get(key, "")
			if found != "":
				return found
	return ""

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

static func move(id: String) -> Dictionary:
	if _moves.is_empty():
		_build()
	return _moves.get(id, Hero.CHIBI_MOVES["x1"])

static func _build() -> void:
	var down: Dictionary = Hero.CHIBI_MOVES["x1"]
	var up: Dictionary = Hero.CHIBI_MOVES["x2"]
	var big: Dictionary = Hero.CHIBI_MOVES["x3"]
	var over: Dictionary = Hero.CHIBI_MOVES["zx"]
	var lift: Dictionary = Hero.CHIBI_MOVES["xxz"]
	var air: Dictionary = Hero.CHIBI_MOVES["az"]
	var dash: Dictionary = Hero.CHIBI_MOVES["dz1"]
	var stab: Dictionary = Hero.SK_MOVES["skx5"]
	var cast := _mv(Hero.MK_MOVES["mk_turn_shot"], {"turn_around": null, "time": 0.36, "wind": 0.3, "strike": 0.5, "next": 0.62, "fx": "mg_shot"})
	cast.erase("turn_around")
	var cast45: Dictionary = _mv(Hero.MK_MOVES["mk_shot45"], {"fx": "mg_shot45"})
	var toss := _mv(cast, {"time": 0.45, "wind": 0.3, "strike": 0.5, "next": 0.8, "fx": "mg_toss"})
	var m := {}
	# ---------- BASIC ของ SUSI ----------
	m["mg_z1"] = _mv(down, {"name": "ฟาดคฑา", "dmg": 12.0, "time": 0.42, "hit": {"kb": 1.0, "stun": 0.45}})
	m["mg_z2"] = _mv(up, {"name": "ฟาดคฑากลับ", "dmg": 12.0, "time": 0.42, "hit": {"kb": 1.0, "stun": 0.45}})
	m["mg_z3"] = _mv(big, {"name": "ฟาดคฑาล้ม", "dmg": 20.0, "hit": {"type": "knockdown", "fly": 6.0}})
	for i in 3:
		m["mg_x%d" % (i + 1)] = _mv(cast, {"name": "ยิงลูกไฟ %d" % (i + 1)})
	m["mg_x4"] = _mv(cast, {"name": "ยิงลูกไฟล้ม", "next": 0.9, "fx": "mg_shot_down", "shake": 0.2})
	m["mg_dz1"] = _mv(dash, {"name": "พุ่งฟาดคฑา", "dmg": 12.0})
	m["mg_dz2"] = _mv(lift, {"name": "งัดคฑาลอย", "dmg": 14.0, "lunge": 0.4, "hit": {"type": "launch", "vy": 11.0}})
	m["mg_dx"] = _mv(Hero.MK_MOVES["mk_spin_through"], {"name": "พุ่งผ่าน", "auto": "mg_turn_shot", "dmg": 6.0})
	m["mg_turn_shot"] = _mv(cast, {"name": "หันกลับยิงลูกไฟ", "turn_around": true, "time": 0.42, "next": 0.75})
	m["mg_turn_shot2"] = _mv(cast, {"name": "ยิงลูกไฟเพิ่ม", "next": 0.85})
	m["mg_az"] = _mv(over, {"name": "ฟาดลงแนวดิ่ง", "dmg": 16.0, "lunge": 0.15, "hover": true, "hit": {"kb": 1.0, "stun": 0.55, "air_lift": -4.0}})
	m["mg_ax"] = _mv(cast, {"name": "ยิงลูกไฟกลางอากาศ", "hover": true, "next": 0.8})
	m["mg_adz"] = _mv(cast45, {"name": "วงเวทเฉียงลง", "fx": "mg_tilt_circle", "next": 0.8})
	m["mg_adx1"] = _mv(cast45, {"name": "ยิงลูกไฟเฉียงลง", "time": 0.4, "next": 0.7})
	m["mg_adx2"] = _mv(cast45, {"name": "ยิงลูกไฟเฉียงลงอีกลูก", "time": 0.4, "next": 0.7})
	m["mg_adx3"] = _mv(cast45, {"name": "ยิงลูกไฟเฉียงลงลูกที่สาม", "time": 0.4, "next": 0.85})
	m["mg_lift"] = _mv(cast, {"name": "วงเวทขาวใต้เท้า", "fx": "mg_lift", "time": 0.5, "next": 0.9, "shake": 0.2})
	# ---------- ARCH MAGE ----------
	# xx ของ BASIC ก่อน แล้ว z เรียกลมพัดไปข้างหน้าและเมฆสายฟ้าเหนือมอน
	# z กวาดคฑาไปตามพื้นเรียกลม แล้วชี้คฑาไปข้างหน้าเรียกเมฆ ติดเกราะ SA ตัวไม่เอนมาก
	m["mg_cloud"] = _mv(big, {"name": "กวาดคฑาเรียกลม", "fx": "mg_wind", "no_hit": true, "dmg": 0.0, "time": 0.42, "lunge": 0.1, "lean": 8.0, "twist": 15.0, "sa": true, "auto": "mg_cloud_point", "next": 0.75, "shake": 0.05})
	var point := _mv(stab, {"lunge": 0.0, "lean": 6.0, "twist": 5.0, "sa": true, "no_hit": true, "dmg": 0.0, "ribbon": null, "no_trail": true, "shake": 0.05})
	point.erase("ribbon")
	m["mg_cloud_point"] = _mv(point, {"name": "ชี้คฑาเรียกเมฆสายฟ้า", "fx": "mg_cloud", "time": 0.4, "next": 0.6})
	m["mg_bolt"] = _mv(point, {"name": "ชี้คฑาสายฟ้าจากเมฆ", "fx": "mg_bolt", "time": 0.22, "wind": 0.2, "strike": 0.4, "next": 0.45, "repeat": 10})
	m["mg_gflame"] = _mv(cast, {"name": "เปลวไฟเลื้อยพื้น", "fx": "mg_gflame", "time": 0.42})
	m["mg_rapid"] = _mv(cast, {"name": "ยิงลูกไฟรัว", "fx": "mg_shot_quick", "time": 0.2, "wind": 0.2, "strike": 0.4, "next": 0.45, "repeat": 10})
	# ---------- ELEMENT MASTER ----------
	m["mg_ice"] = _mv(cast, {"name": "น้ำแข็งลากเป้าหมาย", "fx": "mg_ice", "time": 0.5, "next": 0.9})
	m["mg_spark"] = _mv(cast45, {"name": "ไฟฟ้าช็อตเฉียงลง", "fx": "mg_spark", "leap": 3.0, "hover": true, "hover_apex": true, "hold_after": 2.0, "hold_button": "z", "pulse": "mg_spark", "next": 0.9})
	# ---------- BATTLE MAGE ท่าตีใหม่ ตวัดขึ้นมอนไม่ลอย หมุนตัว ทีสุดท้ายปัดมอน ----------
	m["mg_bz1"] = _mv(up, {"name": "ตวัดขึ้น", "dmg": 11.0, "time": 0.38, "hit": {"kb": 0.6, "stun": 0.45}})
	m["mg_bz2"] = _mv(down, {"name": "ตวัดกลับ", "dmg": 11.0, "time": 0.38, "hit": {"kb": 0.6, "stun": 0.45}})
	m["mg_bz3"] = _mv(up, {"name": "หมุนตัวตวัดขึ้น", "dmg": 12.0, "time": 0.46, "spin": 360.0, "hit": {"kb": 0.6, "stun": 0.5}})
	m["mg_bz4"] = _mv(down, {"name": "หมุนตัวตวัด", "dmg": 12.0, "time": 0.46, "spin": -360.0, "hit": {"kb": 0.6, "stun": 0.5}})
	m["mg_bz5"] = _mv(big, {"name": "หมุนตัวปัดมอน", "dmg": 22.0, "spin": 360.0, "hit": {"kb": 3.5, "stun": 0.7}})
	m["mg_warp"] = _mv(over, {"name": "วาร์ปฟาดหัว", "fx_start": "mg_warp", "dmg": 18.0, "dive": true, "lunge": 0.0, "hit": {"kb": 0.6, "stun": 0.7}})
	m["mg_thrust"] = _mv(stab, {"name": "แทงคฑา", "dmg": 16.0, "lunge": 0.6, "sa": null, "hit": {"kb": 1.2, "stun": 0.6}})
	m["mg_thrust"].erase("sa")
	m["mg_rise"] = _mv(cast, {"name": "วงเวทยกมอน", "fx": "mg_rise", "time": 0.45, "next": 0.85})
	m["mg_dust"] = _mv(cast, {"name": "โปรยผงมิติ", "fx": "mg_dust", "time": 0.42, "next": 0.8})
	m["mg_dust2"] = m["mg_dust"]
	# ---------- DIMENSION CASTER ----------
	m["mg_recall"] = _mv(cast, {"name": "เรียกผงมิติกลับ", "fx": "mg_recall", "time": 0.45, "next": 0.9})
	m["mg_dimslam"] = _mv(over, {"name": "ฟาดบอลมิติ", "fx_start": "mg_dimball", "fx": "mg_dimslam", "no_hit": true, "time": 0.6, "wind": 0.45, "strike": 0.6, "next": 0.95, "lunge": 0.1, "shake": 0.35})
	# ---------- DARK MAGE ลูกบอลมืดลอยค้างทำดาเมจต่อเนื่อง ----------
	m["mg_dark_stay"] = _mv(cast, {"name": "ลูกบอลมืดลอยค้าง", "fx": "mg_dark_stay", "next": 0.85})
	m["mg_dark_mash"] = _mv(cast, {"name": "ลูกบอลมืดชะงัก", "fx": "mg_dark_flinch", "time": 0.3, "wind": 0.25, "strike": 0.45, "next": 0.5, "repeat": 5})
	m["mg_slam_ground"] = _mv(over, {"name": "ทุบพื้นด้วยคฑา", "dmg": 14.0, "fx": "mg_quake", "front_hit": true, "shake": 0.3, "hit": {"kb": 0.2, "stun": 0.8}})
	# ---------- ECLIPSE ----------
	m["mg_ec_hold"] = _mv(cast, {"name": "ลูกบอลมืดลอยช้า กดค้างปล่อยต่อ", "fx": "mg_dark_slow", "hold_after": 2.85, "hold_button": "x", "pulse": "mg_dark_slow", "next": 0.9})
	m["mg_ec_adx2"] = _mv(cast45, {"name": "ลูกบอลมืดเฉียงลงช้าๆ", "fx": "mg_dark45", "time": 0.4, "next": 0.8})
	m["mg_ec_z1"] = _mv(down, {"name": "ตีคฑา 1", "dmg": 12.0, "time": 0.4, "hit": {"kb": 0.8, "stun": 0.45}})
	m["mg_ec_z2"] = _mv(up, {"name": "ตีคฑา 2", "dmg": 12.0, "time": 0.4, "hit": {"kb": 0.8, "stun": 0.45}})
	m["mg_ec_z3"] = _mv(over, {"name": "ทุบพื้นชะงัก", "dmg": 18.0, "fx": "mg_quake", "front_hit": true, "shake": 0.3, "hit": {"kb": 0.2, "stun": 0.9}})
	# ---------- ALCHEMIST MAGE ----------
	m["mg_hop_toss"] = _mv(toss, {"name": "กระโดดถอยปาขวดยา", "leap": 3.5, "lunge": -1.0, "fx": "mg_toss_short"})
	m["mg_back_toss"] = _mv(toss, {"name": "ปาขวดยาถอยหลัง", "leap": 3.5, "lunge": -1.0, "fx": "mg_toss_short"})
	m["mg_potion_up"] = _mv(toss, {"name": "ปาขวดยามอนลอย", "fx": "mg_toss_lift"})
	# ---------- TRANSMUTATION MASTER ----------
	m["mg_potion_rain"] = _mv(cast, {"name": "โปรยขวดยาจากฟ้า", "fx": "mg_potion_rain", "time": 0.45, "next": 0.75})
	m["mg_cauldron"] = _mv(cast, {"name": "หม้อปรุงยาทับ", "fx": "mg_cauldron", "time": 0.5, "next": 0.95, "shake": 0.2})
	m["mg_spin_toss"] = _mv(toss, {"name": "หมุนตัวโปรยขวดยา", "leap": 4.0, "spin": 360.0, "hover_apex": true, "hover": true, "fx": "mg_toss_three"})
	m["mg_potion_bash"] = _mv(down, {"name": "ฟาดขวดยา", "dmg": 16.0, "fx": "mg_bash_splash", "potion_hand": true, "hit": {"kb": 1.4, "stun": 0.55}})
	_moves = m
