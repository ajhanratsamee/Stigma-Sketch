class_name FistCombo
## คอมโบของ CAT ASH หมัดกับเท้า ใช้ระบบท่าเดียวกับคอมโบแมว (walk_page._tick_combo) แยกตารางของตัวเอง ชื่อท่าขึ้นต้น fs_
## BASIC: zzzz จิ้ม จิ้ม ฮุก อัปเปอร์คัตมอนลอย   zzx เตะกวาดขามอนล้ม
##        xxxx เตะหน้า เตะเหวี่ยง หมุนตัวเตะกลับหลัง เตะจามขวานมอนล้ม
##        >>z พุ่งต่อย  >>x เข่าลอย  ^z ต่อยพุ่งลงพื้น  ^x หมุนเตะกลางอากาศ  >>^zz ต่อยกลางอากาศ แล้วทุบลงมอนล้ม
## สายอื่นเพิ่มท่าได้ผ่าน lines() (ไฟล์ fist_line_*.gd มี NEXT START add_moves(m) cast(page, fx))

const NEXT := {
	"BASIC": {
		"fs_z1": {"z": "fs_z2"}, "fs_z2": {"z": "fs_z3", "x": "fs_zzx"}, "fs_z3": {"z": "fs_z4"},
		"fs_x1": {"x": "fs_x2"}, "fs_x2": {"x": "fs_x3"}, "fs_x3": {"x": "fs_x4"},
		"fs_adz1": {"z": "fs_adz2"},
	},
}

static var _moves := {}

## คอมโบของแต่ละสายแยกไฟล์ (ยังไม่มี)
static func lines() -> Array:
	return [FistLineHeavy, FistLineZephyr, FistLineMuay, FistLineSystema]

static func chain(class_id: String) -> Array:
	var out := []
	if class_id != "" and class_id != "BASIC":
		out.append(class_id)
		for a in SkillPanel.ancestors(class_id):
			if a != "BASIC":
				out.append(a)
	out.append("BASIC")
	return out

## ท่าแรกตามสถานะ ground dash air airdash  สายอื่นเพิ่มได้ใน START แบบ "state_[ทิศ_]ปุ่ม"
static func start(class_id: String, state: String, button: String, down := false, back := false, forward := false) -> String:
	var mods := []
	if down:
		mods.append("down_")
	if back:
		mods.append("back_")
	if forward:
		mods.append("fwd_")
	mods.append("")
	for id in chain(class_id):
		for line in lines():
			var table: Dictionary = (line.START as Dictionary).get(id, {})
			for mod in mods:
				var key: String = state + "_" + str(mod) + button
				if table.has(key):
					return table[key]
	match state:
		"dash":
			return "fs_dz" if button == "z" else "fs_dx"
		"air":
			return "fs_az" if button == "z" else "fs_ax"
		"airdash":
			return "fs_adz1" if button == "z" else "fs_ax"
	return "fs_z1" if button == "z" else "fs_x1"

## ปุ่มต่อท่า ลำดับที่ลอง: "down_z" "back_z" "fwd_z" แล้ว "z"
static func next(class_id: String, current: String, button: String, down: bool, forward: bool, back := false) -> String:
	var keys := []
	if down:
		keys.append("down_" + button)
	if back:
		keys.append("back_" + button)
	if forward:
		keys.append("fwd_" + button)
	keys.append(button)
	for key in keys:
		for id in chain(class_id):
			for line in lines():
				var lt: Dictionary = (line.NEXT as Dictionary).get(id, {})
				var lf: String = (lt.get(current, {}) as Dictionary).get(key, "")
				if lf != "":
					return lf
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
	return _moves.get(id, _moves["fs_z1"])

static func _build() -> void:
	# ต่อยตรง มือข้างหน้าพุ่งออกไประดับอก อีกมือกำไว้ที่อก
	var jab := {"name": "ต่อยจิ้ม", "wind_hand": Vector3(0.15, -0.02, 0.15), "wind_aim": Vector2(90.0, 0.0), "end_hand": Vector3(0.82, -0.02, 0.05), "end_aim": Vector2(90.0, 0.0),
		"wind_off": Vector3(0.25, -0.05, -0.1), "end_off": Vector3(0.1, -0.08, -0.1), "ease": 3.0, "time": 0.26, "wind": 0.3, "strike": 0.5, "next": 0.6,
		"dmg": 9.0, "lunge": 0.3, "shake": 0.06, "stop": 0.04, "lean": 14.0, "twist": -20.0, "front_hit": true, "no_trail": true, "fx": "fs_jab", "hit": {"kb": 0.6, "stun": 0.4}}
	# เตะ ใช้ท่าเตะของแมว
	var kick: Dictionary = (Hero.CAT_SKILLS["cat_sk_kick"] as Dictionary).duplicate(true)
	kick.merge({"no_trail": true, "fx": "fs_kick"}, true)
	var m := {}
	# zzzz
	m["fs_z1"] = _mv(jab, {"name": "ต่อยจิ้ม"})
	m["fs_z2"] = _mv(jab, {"name": "ต่อยจิ้มมือซ้าย", "wind_hand": Vector3(0.25, -0.05, -0.1), "end_hand": Vector3(0.05, -0.08, -0.1),
		"wind_off": Vector3(0.15, -0.02, 0.15), "end_off": Vector3(0.82, -0.02, 0.05), "twist": 20.0})
	m["fs_z3"] = _mv(jab, {"name": "ฮุก", "wind_hand": Vector3(0.0, 0.05, 0.45), "end_hand": Vector3(0.7, 0.02, -0.25), "time": 0.32, "next": 0.66,
		"dmg": 12.0, "lunge": 0.35, "twist": 40.0, "lean": 18.0, "fx": "fs_hook", "hit": {"kb": 1.0, "stun": 0.5}})
	m["fs_z4"] = _mv(jab, {"name": "อัปเปอร์คัต", "wind_hand": Vector3(0.3, -0.45, 0.2), "end_hand": Vector3(0.45, 0.62, 0.05), "time": 0.4, "next": 0.82,
		"dmg": 17.0, "lunge": 0.3, "lean": -12.0, "twist": 10.0, "shake": 0.14, "stop": 0.08, "fx": "fs_upper", "hit": {"type": "launch", "vy": 11.0}})
	# zzx เตะกวาดขา
	m["fs_zzx"] = _mv(kick, {"name": "เตะกวาดขา", "dmg": 14.0, "time": 0.4, "wind": 0.25, "strike": 0.5, "next": 0.82, "lunge": 0.35, "spin": 360.0, "lean": 35.0,
		"shake": 0.12, "fx": "fs_sweep", "hit": {"type": "knockdown", "fly": 2.0}})
	# xxxx เตะ 4 แบบ
	m["fs_x1"] = _mv(kick, {"name": "เตะหน้า", "dmg": 10.0, "time": 0.32, "wind": 0.3, "strike": 0.5, "next": 0.62, "lunge": 0.35, "hit": {"kb": 1.0, "stun": 0.45}})
	m["fs_x2"] = _mv(kick, {"name": "เตะเหวี่ยง", "dmg": 11.0, "time": 0.36, "wind": 0.25, "strike": 0.52, "next": 0.64, "lunge": 0.3, "spin": 180.0, "twist": 30.0,
		"fx": "fs_round", "hit": {"kb": 1.1, "stun": 0.45}})
	m["fs_x3"] = _mv(kick, {"name": "หมุนตัวเตะกลับหลัง", "dmg": 13.0, "time": 0.42, "wind": 0.2, "strike": 0.55, "next": 0.68, "lunge": 0.4, "spin": 360.0, "lean": -15.0,
		"fx": "fs_spin", "hit": {"kb": 1.4, "stun": 0.5}})
	m["fs_x4"] = _mv(kick, {"name": "เตะจามขวาน", "dmg": 19.0, "time": 0.48, "wind": 0.35, "strike": 0.55, "next": 0.9, "lunge": 0.4, "leap": 3.0, "lean": 25.0,
		"shake": 0.2, "stop": 0.08, "fx": "fs_axe", "hit": {"type": "knockdown", "fly": 4.0}})
	# >>z พุ่งต่อย
	m["fs_dz"] = _mv(jab, {"name": "พุ่งต่อย", "time": 0.42, "wind": 0.15, "strike": 0.62, "next": 0.8, "dmg": 15.0, "lunge": 2.6, "lean": 30.0, "drag": true,
		"shake": 0.14, "stop": 0.06, "fx": "fs_dash", "hit": {"kb": 1.6, "stun": 0.6}})
	# >>x เข่าลอย
	m["fs_dx"] = _mv(kick, {"name": "เข่าลอย", "dmg": 15.0, "time": 0.46, "wind": 0.2, "strike": 0.55, "next": 0.82, "lunge": 1.8, "leap": 5.0, "lean": 20.0,
		"shake": 0.14, "fx": "fs_knee", "hit": {"kb": 0.8, "stun": 0.9}})
	# ^z ต่อยพุ่งลงพื้น
	m["fs_az"] = _mv(jab, {"name": "ต่อยพุ่งลงพื้น", "end_hand": Vector3(0.45, -0.6, 0.05), "end_aim": Vector2(-60.0, 0.0), "dive": true, "time": 0.4, "wind": 0.2,
		"strike": 0.55, "next": 0.8, "dmg": 16.0, "lunge": 0.1, "lean": 30.0, "shake": 0.22, "stop": 0.06, "fx": "fs_dive", "hit": {"kb": 0.5, "stun": 0.8}})
	# ^x หมุนเตะกลางอากาศ
	m["fs_ax"] = _mv(kick, {"name": "หมุนเตะกลางอากาศ", "hover": true, "dmg": 13.0, "time": 0.4, "wind": 0.2, "strike": 0.5, "next": 0.75, "lunge": 0.4, "spin": 360.0,
		"fx": "fs_spin", "hit": {"kb": 1.2, "stun": 0.5}})
	# >>^zz ต่อยกลางอากาศ แล้วทุบลง
	m["fs_adz1"] = _mv(jab, {"name": "ต่อยกลางอากาศ", "hover": true, "time": 0.3, "next": 0.62, "dmg": 11.0, "lunge": 0.4})
	m["fs_adz2"] = _mv(jab, {"name": "ทุบลงชะงัก", "wind_hand": Vector3(0.2, 0.6, 0.1), "end_hand": Vector3(0.6, -0.5, 0.05), "dive": true, "time": 0.42, "wind": 0.25,
		"strike": 0.55, "next": 0.85, "dmg": 16.0, "lunge": 0.3, "lean": 30.0, "shake": 0.2, "stop": 0.08, "fx": "fs_dive", "hit": {"kb": 0.6, "stun": 0.9}})
	for line in lines():
		line.add_moves(m)
	_moves = m
