class_name SpearCombo
## คอมโบของ CAT CITRUS หอก ใช้ระบบท่าเดียวกับคอมโบแมว (walk_page._tick_combo) แยกตารางของตัวเอง ชื่อท่าขึ้นต้น sp_
## BASIC: zzzzz แทง ดึงกลับ หมุนแทง 3 ฮิต หมุนฟาด 2 ฮิต หมุนฟาดกระเด็น   zzx ดีดตัวถอยหลังสูงมอนลอย
##        xxxxxxxxx ตวัด ฟาดแนวตั้ง ควงหอกหมุนตัว 6 ที (sa) แทงเฉียงลงมอนล้ม
##        >>z พุ่งแทงรัว  >>x พุ่งฟาดลงพื้นชะงัก  >>^zzz ฟาดลอย ฟาดลอย ฟาดลงล้ม  >>^x ตวัดหมุนตัวข้ามไปอีกด้านแล้วหันกลับ
##        ^z ฟาดลงแนวดิ่งชะงัก  ^x ฟาดยาวมอนลอย

const NEXT := {
	"BASIC": {
		"sp_z1": {"z": "sp_z2"}, "sp_z2": {"z": "sp_z3", "x": "sp_zzx"}, "sp_z3": {"z": "sp_z4"}, "sp_z4": {"z": "sp_z5"},
		"sp_x1": {"x": "sp_x2"}, "sp_x2": {"x": "sp_x3"}, "sp_x3": {"x": "sp_x4"}, "sp_x4": {"x": "sp_x5"},
		"sp_x5": {"x": "sp_x6"}, "sp_x6": {"x": "sp_x7"}, "sp_x7": {"x": "sp_x8"}, "sp_x8": {"x": "sp_x9"},
		"sp_adz1": {"z": "sp_adz2"}, "sp_adz2": {"z": "sp_adz3"},
	},
}

static var _moves := {}

## คอมโบของแต่ละสายแยกไฟล์
static func lines() -> Array:
	return [SpearLineTiger, SpearLineFang, SpearLineVixen, SpearLineShell]

static func chain(class_id: String) -> Array:
	var out := []
	if class_id != "" and class_id != "BASIC":
		out.append(class_id)
		for a in SkillPanel.ancestors(class_id):
			if a != "BASIC":
				out.append(a)
	out.append("BASIC")
	return out

## ท่าแรกตามสถานะ ground dash air airdash
## START ของแต่ละสายใช้คีย์ "สถานะ_ปุ่ม" หรือ "สถานะ_ทิศ_ปุ่ม" เช่น "ground_down_x" "airdash_back_z" "dash_fwd_z"
## ลำดับที่ลอง: down_ ก่อน แล้ว back_ แล้ว fwd_ แล้วปุ่มเปล่า
static func start(class_id: String, state: String, button: String, down := false, back := false, forward := false) -> String:
	var keys := []
	if down:
		keys.append(state + "_down_" + button)
	if back:
		keys.append(state + "_back_" + button)
	if forward:
		keys.append(state + "_fwd_" + button)
	keys.append(state + "_" + button)
	for key in keys:
		for id in chain(class_id):
			for line in lines():
				var table: Dictionary = (line.START as Dictionary).get(id, {})
				if table.has(key):
					return table[key]
	match state:
		"dash":
			return "sp_dz" if button == "z" else "sp_dx"
		"air":
			return "sp_az" if button == "z" else "sp_ax"
		"airdash":
			return "sp_adz1" if button == "z" else "sp_adx"
	return "sp_z1" if button == "z" else "sp_x1"

## ปุ่มต่อท่า ลำดับที่ลอง: "down_z" "back_z" (กดทิศตรงข้ามที่หัน) "fwd_z" แล้ว "z"
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
	return _moves.get(id, _moves["sp_z1"])

static func _build() -> void:
	# แทงตรง หอกชี้ไปหน้าระดับอก ดันออกไปสุดแขน
	var stab := {"name": "แทงหอก", "wind_hand": Vector3(-0.4, -0.05, 0.12), "wind_aim": Vector2(4.0, 0.0), "end_hand": Vector3(0.75, -0.1, 0.0), "end_aim": Vector2(-2.0, 0.0),
		"wind_off": Vector3(0.46, -0.06, -0.1), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "ribbon": true, "time": 0.36, "wind": 0.36, "strike": 0.54, "next": 0.64,
		"dmg": 11.0, "lunge": 0.55, "shake": 0.1, "stop": 0.05, "lean": 26.0, "twist": 10.0, "fx": "sp_thrust", "hit": {"kb": 1.0, "stun": 0.45}}
	# กวาดแนวนอน จากหลังมาหน้า
	var sweep := {"name": "กวาดหอก", "wind_hand": Vector3(-0.35, 0.1, 0.35), "wind_aim": Vector2(8.0, 160.0), "end_hand": Vector3(0.6, -0.05, -0.25), "end_aim": Vector2(-10.0, -45.0), "tilt": -20.0,
		"wind_off": Vector3(0.45, -0.1, -0.25), "end_off": Vector3(-0.5, -0.1, 0.25), "ease": 3.0, "time": 0.4, "wind": 0.35, "strike": 0.58, "next": 0.68,
		"dmg": 12.0, "lunge": 0.35, "shake": 0.12, "stop": 0.06, "lean": 18.0, "twist": 35.0, "fx": "sp_sweep", "hit": {"kb": 1.0, "stun": 0.5}}
	# ฟาดแนวตั้งจากบนลงล่าง
	var chop := {"name": "ฟาดหอกลง", "wind_hand": Vector3(-0.1, 0.5, 0.1), "wind_aim": Vector2(140.0, 0.0), "end_hand": Vector3(0.62, -0.35, 0.0), "end_aim": Vector2(-60.0, 0.0),
		"wind_off": Vector3(0.3, 0.2, -0.2), "end_off": Vector3(-0.5, -0.2, -0.1), "ease": 3.0, "time": 0.44, "wind": 0.38, "strike": 0.56, "next": 0.68,
		"dmg": 13.0, "lunge": 0.35, "shake": 0.15, "stop": 0.07, "lean": 28.0, "twist": 12.0, "fx": "sp_vert", "hit": {"kb": 0.8, "stun": 0.55}}
	# ฟาดเสยจากล่างขึ้นบน
	var lift := {"name": "ฟาดเสยหอก", "wind_hand": Vector3(0.35, -0.5, 0.2), "wind_aim": Vector2(-150.0, 10.0), "end_hand": Vector3(0.3, 0.55, 0.0), "end_aim": Vector2(85.0, 0.0),
		"wind_off": Vector3(0.3, 0.1, -0.2), "end_off": Vector3(-0.4, -0.3, 0.1), "ease": 3.0, "time": 0.44, "wind": 0.34, "strike": 0.55, "next": 0.72,
		"dmg": 13.0, "lunge": 0.35, "shake": 0.14, "stop": 0.07, "lean": -8.0, "twist": 15.0, "fx": "sp_up", "hit": {"type": "launch", "vy": 10.0}}
	var m := {}
	# zzzzz
	m["sp_z1"] = _mv(stab, {"name": "แทงหอกไปหน้า"})
	m["sp_z2"] = _mv(stab, {"name": "ดึงหอกกลับ", "wind_hand": Vector3(0.75, -0.1, 0.0), "wind_aim": Vector2(-2.0, 0.0), "end_hand": Vector3(-0.15, -0.02, 0.12), "end_aim": Vector2(8.0, 0.0),
		"wind_off": Vector3(-0.5, -0.2, -0.1), "end_off": Vector3(0.4, -0.06, -0.1), "lunge": -0.2, "dmg": 9.0, "lean": -10.0, "fx": "", "hit": {"kb": 0.2, "stun": 0.55}})
	m["sp_z3"] = _mv(stab, {"name": "หมุนตัวแทง 3 ฮิต", "spin": 360.0, "time": 0.6, "wind": 0.3, "strike": 0.78, "next": 0.86, "dmg": 5.5, "lunge": 0.5,
		"multi": 0.1, "multi_ahead": 150.0, "multi_half": 130.0, "fx_start": "sp_rapid", "fx": "sp_thrust", "hit": {"kb": 0.4, "stun": 0.5}})
	m["sp_z4"] = _mv(sweep, {"name": "หมุนตัวฟาด 2 ฮิต", "spin": 360.0, "time": 0.52, "wind": 0.35, "strike": 0.72, "next": 0.8, "dmg": 8.5,
		"multi": 0.16, "multi_ahead": 60.0, "multi_half": 200.0, "fx_start": "sp_spin", "hit": {"kb": 0.5, "stun": 0.5}})
	m["sp_z5"] = _mv(sweep, {"name": "หมุนฟาดกระเด็น", "spin": 720.0, "time": 0.6, "wind": 0.3, "strike": 0.65, "next": 0.9, "dmg": 20.0, "lunge": 0.5, "shake": 0.3, "stop": 0.12,
		"fx": "sp_spin", "hit": {"type": "knockdown", "fly": 9.0}})
	# zzx ดีดตัวถอยหลังสูง ตีลังกา มอนลอย
	m["sp_zzx"] = _mv(lift, {"name": "ดีดตัวถอยหลังเสยลอย", "leap": 7.5, "lunge": -1.6, "roll_once": true, "time": 0.55, "wind": 0.1, "strike": 0.12, "next": 0.85,
		"dmg": 26.0, "front_hit": true, "fx": "sp_flip", "hit": {"type": "launch", "vy": 12.0}})
	# xxxxxxxxx
	m["sp_x1"] = _mv(sweep, {"name": "ตวัดหอก", "time": 0.36, "dmg": 11.0, "hit": {"kb": 0.8, "stun": 0.5}})
	m["sp_x2"] = _mv(chop, {"name": "หมุนหอกแนวตั้งลงมา", "roll_once": true, "time": 0.46})
	for i in 6:
		var n := i + 3
		m["sp_x%d" % n] = _mv(sweep, {"name": "ควงหอกหมุนตัว %d" % (i + 1), "spin": 360.0 if i % 2 == 0 else -360.0, "time": 0.34, "wind": 0.25, "strike": 0.55, "next": 0.62,
			"dmg": 6.0, "lunge": 0.25, "sa": true, "wide": true, "wide_half": 230.0, "shake": 0.08, "stop": 0.03, "fx": "sp_spin", "hit": {"kb": 0.3, "stun": 0.5}})
	m["sp_x9"] = _mv(stab, {"name": "แทงเฉียงลงมอนล้ม", "wind_hand": Vector3(-0.2, 0.35, 0.12), "wind_aim": Vector2(25.0, 0.0), "end_hand": Vector3(0.7, -0.38, 0.0), "end_aim": Vector2(-38.0, 0.0),
		"time": 0.5, "wind": 0.4, "strike": 0.58, "next": 0.9, "dmg": 22.0, "lunge": 0.8, "shake": 0.25, "stop": 0.1, "lean": 34.0, "fx": "sp_down",
		"hit": {"type": "knockdown", "fly": 4.0}})
	# >>z พุ่งแทงรัว
	m["sp_dz"] = _mv(stab, {"name": "พุ่งแทงรัว", "ease": 1.0, "time": 0.7, "wind": 0.15, "strike": 0.85, "next": 0.92, "dmg": 4.0, "lunge": 2.2,
		"multi": 0.07, "multi_ahead": 150.0, "multi_half": 130.0, "fx_start": "sp_rapid", "fx": "sp_thrust", "hit": {"kb": 0.3, "stun": 0.45}})
	# >>x พุ่งฟาดยาวลงพื้น ชะงัก
	m["sp_dx"] = _mv(chop, {"name": "พุ่งฟาดลงพื้น", "time": 0.55, "wind": 0.35, "strike": 0.6, "next": 0.85, "dmg": 18.0, "lunge": 1.5, "shake": 0.25, "stop": 0.1,
		"front_hit": true, "fx": "sp_ground", "hit": {"kb": 0.4, "stun": 1.2}})
	# >>^zzz ฟาดลอย ฟาดลอย ฟาดลงล้ม
	m["sp_adz1"] = _mv(lift, {"name": "ฟาดเสยกลางอากาศ", "hover": true, "time": 0.4, "dmg": 11.0, "hit": {"type": "launch", "vy": 9.0}})
	m["sp_adz2"] = _mv(lift, {"name": "ฟาดเสยอีกที", "hover": true, "time": 0.4, "dmg": 11.0, "roll_once": true, "hit": {"type": "launch", "vy": 9.0}})
	m["sp_adz3"] = _mv(chop, {"name": "ฟาดลงมอนล้ม", "hover": true, "time": 0.48, "next": 0.85, "dmg": 18.0, "shake": 0.25, "hit": {"type": "knockdown", "fly": 3.0}})
	# >>^x ตวัดหมุนตัวข้ามไปอีกด้าน แล้วหันกลับมาฟาด
	# >>^x กระโดดตวัดหอกหมุนตัว 1 ฮิต ไม่ข้ามไปอีกด้าน
	m["sp_adx"] = _mv(sweep, {"name": "กระโดดตวัดหอกหมุนตัว", "spin": 360.0, "hover": true, "lunge": 0.3, "time": 0.42, "wind": 0.2, "strike": 0.6, "next": 0.82,
		"dmg": 16.0, "wide": true, "wide_half": 190.0, "hit": {"kb": 1.2, "stun": 0.6}})
	m["sp_adx_turn"] = _mv(sweep, {"name": "หันกลับมาตวัด", "turn_around": true, "hover": true, "lunge": 0.2, "time": 0.36, "next": 0.8, "dmg": 12.0, "hit": {"kb": 1.2, "stun": 0.6}})
	# ^z ฟาดลงแนวดิ่ง ชะงัก
	m["sp_az"] = _mv(chop, {"name": "ฟาดลงแนวดิ่ง", "hover": true, "time": 0.42, "next": 0.75, "dmg": 14.0, "hit": {"kb": 0.3, "stun": 1.0}})
	# ^x ฟาดยาวมอนลอย
	m["sp_ax"] = _mv(lift, {"name": "ฟาดยาวมอนลอย", "hover": true, "time": 0.48, "next": 0.8, "dmg": 14.0, "lunge": 0.4, "hit": {"type": "launch", "vy": 6.0}})
	for line in lines():
		line.add_moves(m)
	_moves = m
