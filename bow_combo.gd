class_name BowCombo
## คอมโบของ CAT MATCHA นักธนู ใช้ระบบท่าเดียวกับคอมโบแมว (walk_page._tick_combo) แต่แยกตารางของตัวเอง
## z คือเตะ  x คือยิงธนู  ยิงธนูด้วยมือที่ถือคันธนู (bow_cast) คันธนูตั้งตรงยื่นไปข้างหน้า อีกมือง้างสาย
## BASIC: zzzz เตะ 4 ทีสุดท้ายกระเด็น  xxxx ยิง 4 ดอกสุดท้ายกระเด็น  >>zz สไลด์แล้วหมุนเตะเสย
##        >>x อ้อมไปหันหลังยิง  ^z พุ่งกระทืบลงพื้น  ^x ยิงลงมา 3 ดอก  >>^z เตะเฉียงกลางอากาศ
##        >>^xxx ยิง 3 ดอกเฉียง 3 ครั้งครั้งสุดท้ายล้ม  zzzx เตะเสยมอนลอย

const NEXT := {
	"BASIC": {
		"bw_z1": {"z": "bw_z2"}, "bw_z2": {"z": "bw_z3"}, "bw_z3": {"z": "bw_z4", "x": "bw_kick_up"},
		"bw_x1": {"x": "bw_x2"}, "bw_x2": {"x": "bw_x3"}, "bw_x3": {"x": "bw_x4"},
		"bw_dz1": {"z": "bw_dz2"},
		"bw_adx1": {"x": "bw_adx2"}, "bw_adx2": {"x": "bw_adx3"},
	},
}

static var _moves := {}

## คอมโบของแต่ละสายแยกไฟล์
static func lines() -> Array:
	return [BowLineWind, BowLineSnipe, BowLineMana, BowLineTrap]

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
static func start(class_id: String, state: String, button: String) -> String:
	for id in chain(class_id):
		for line in lines():
			var table: Dictionary = (line.START as Dictionary).get(id, {})
			if table.has(state + "_" + button):
				return table[state + "_" + button]
	match state:
		"dash":
			return "bw_dz1" if button == "z" else "bw_dx"
		"air":
			return "bw_az" if button == "z" else "bw_ax"
		"airdash":
			return "bw_adz" if button == "z" else "bw_adx1"
	return "bw_z1" if button == "z" else "bw_x1"

static func next(class_id: String, current: String, button: String, down: bool, forward: bool) -> String:
	var keys := []
	if down:
		keys.append("down_" + button)
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
	return _moves.get(id, _moves["bw_x1"])

static func _build() -> void:
	var kick: Dictionary = Hero.CAT_SKILLS["cat_sk_kick"]
	# ท่ายิง คันธนูตั้งตรงยื่นไปข้างหน้าด้วยมือที่ถือคันธนู อีกมือง้างสายมาที่อก
	# ยิงระดับอก ไม่ยกธนูสูงเหนือหัว
	var shoot := {"name": "ยิงธนู", "wind_hand": Vector3(0.45, -0.32, 0.15), "wind_aim": Vector2(86.0, 0.0), "end_hand": Vector3(0.72, -0.34, 0.12), "end_aim": Vector2(90.0, 0.0),
		"wind_off": Vector3(0.5, -0.3, 0.14), "end_off": Vector3(0.02, -0.3, 0.12), "ease": 3.0, "time": 0.34, "wind": 0.3, "strike": 0.5, "next": 0.6,
		"dmg": 0.0, "lunge": 0.0, "shake": 0.06, "stop": 0.0, "lean": -6.0, "twist": -25.0, "no_hit": true, "no_trail": true, "bow_cast": true, "fx": "bw_shot"}
	# ยิงเฉียงลง คันธนูเอียงตั้งฉากกับลูกศร
	var shoot45 := _mv(shoot, {"wind_hand": Vector3(0.45, -0.1, 0.15), "wind_aim": Vector2(40.0, 0.0), "end_hand": Vector3(0.62, -0.28, 0.12), "end_aim": Vector2(45.0, 0.0), "end_off": Vector3(0.05, 0.15, 0.12), "lean": 18.0, "hover": true, "fx": "bw_shot3_diag", "time": 0.36})
	# ยิงลงแนวดิ่ง คันธนูแนวนอนใต้ตัว
	var shoot_down := _mv(shoot, {"wind_hand": Vector3(0.15, -0.3, 0.15), "wind_aim": Vector2(0.0, 0.0), "end_hand": Vector3(0.1, -0.55, 0.12), "end_aim": Vector2(0.0, 0.0), "end_off": Vector3(0.05, 0.1, 0.12), "lean": 15.0, "hover": true, "fx": "bw_shot3_down", "time": 0.4, "next": 0.75})
	var m := {}
	# zzzz เตะ 4 ทีไม่ซ้ำท่า: เตะตรง หมุนตัวเตะ พลิกตัวตีลังกาเตะ หมุนสองรอบเตะกระเด็น  ทุกทีมีรอยเตะเขียว
	m["bw_z1"] = _mv(kick, {"name": "เตะตรง", "dmg": 11.0, "time": 0.34, "wind": 0.3, "strike": 0.5, "next": 0.62, "lunge": 0.3, "fx": "bw_kick_front", "hit": {"kb": 1.2, "stun": 0.45}})
	m["bw_z2"] = _mv(kick, {"name": "หมุนตัวเตะ", "dmg": 11.0, "time": 0.38, "wind": 0.2, "strike": 0.5, "next": 0.64, "lunge": 0.3, "spin": 360.0, "lean": -15.0, "fx": "bw_kick_spin", "hit": {"kb": 1.2, "stun": 0.45}})
	m["bw_z3"] = _mv(kick, {"name": "พลิกตัวตีลังกาเตะ", "dmg": 12.0, "time": 0.42, "wind": 0.15, "strike": 0.55, "next": 0.68, "lunge": 0.35, "roll_once": true, "leap": 3.0, "fx": "bw_kick_flip", "hit": {"kb": 1.0, "stun": 0.5}})
	m["bw_z4"] = _mv(kick, {"name": "หมุนสองรอบเตะกระเด็น", "dmg": 20.0, "time": 0.5, "wind": 0.15, "strike": 0.55, "lunge": 0.5, "spin": 720.0, "shake": 0.22, "next": 0.9, "fx": "bw_kick_spin", "hit": {"type": "knockdown", "fly": 8.0}})
	# zzzx ทีสุดท้ายพลิกตัวเตะเสยมอนลอย
	m["bw_kick_up"] = _mv(kick, {"name": "พลิกตัวเตะเสย", "dmg": 16.0, "time": 0.45, "wind": 0.15, "strike": 0.55, "lunge": 0.25, "lean": -28.0, "roll_once": true, "shake": 0.15, "next": 0.85, "fx": "bw_kick_up", "hit": {"type": "launch", "vy": 12.0}})
	# xxxx ยิง 4 ดอก ดอกสุดท้ายกระเด็น
	for i in 3:
		m["bw_x%d" % (i + 1)] = _mv(shoot, {"name": "ยิงธนู %d" % (i + 1)})
	m["bw_x4"] = _mv(shoot, {"name": "ยิงธนูกระเด็น", "fx": "bw_shot_down", "time": 0.4, "next": 0.9, "shake": 0.15})
	# >>zz สไลด์ไปข้างหน้า แล้วหมุนเตะขึ้น มอนลอย
	# สไลด์ไกลเลียดพื้น ตัวเอนหลังต่ำ มีรอยไถลเขียวกับฝุ่นตามหลัง
	m["bw_dz1"] = _mv(kick, {"name": "สไลด์เตะเลียดพื้น", "dmg": 12.0, "time": 0.6, "wind": 0.08, "strike": 0.72, "next": 0.8, "lunge": 3.6, "lean": -55.0, "drag": true, "fx_start": "bw_kick_slide", "front_hit": true, "hit": {"kb": 1.6, "stun": 0.7}})
	m["bw_dz2"] = _mv(kick, {"name": "หมุนตัวเตะเสย", "dmg": 16.0, "time": 0.45, "wind": 0.15, "strike": 0.55, "lunge": 0.3, "spin": 360.0, "lean": -25.0, "shake": 0.15, "next": 0.85, "fx": "bw_kick_up", "hit": {"type": "launch", "vy": 12.0}})
	# >>x อ้อมผ่านมอนไป แล้วหันหลังยิง
	# อ้อมหลังเฉยๆ ไม่ทำดาเมจ แล้วหันยิงเร็วๆ
	m["bw_dx"] = _mv(Hero.MK_MOVES["mk_spin_through"], {"name": "อ้อมผ่าน", "auto": "bw_turn_shot", "dmg": 0.0, "no_hit": true, "time": 0.28, "next": 0.62})
	m["bw_turn_shot"] = _mv(shoot, {"name": "หันหลังยิง", "turn_around": true, "time": 0.3, "wind": 0.22, "strike": 0.4, "next": 0.7})
	# ^z พุ่งกระทืบลงพื้น 1 ฮิต
	m["bw_az"] = _mv(kick, {"name": "พุ่งกระทืบลง", "dmg": 18.0, "dive": true, "lunge": 0.1, "lean": 10.0, "front_hit": true, "shake": 0.25, "next": 0.8, "fx": "bw_kick_down", "hit": {"kb": 0.6, "stun": 0.8}})
	# ^x ยิงลงมา 3 ดอก
	m["bw_ax"] = shoot_down
	# >>^z เตะเฉียงกลางอากาศ
	m["bw_adz"] = _mv(kick, {"name": "ตีลังกาเตะเฉียงกลางอากาศ", "dmg": 15.0, "dive": true, "dive_forward": true, "lunge": 0.5, "lean": 30.0, "roll_once": true, "next": 0.75, "fx": "bw_kick_down", "hit": {"kb": 1.5, "stun": 0.6}})
	# >>^xxx ยิง 3 ดอกเฉียง 3 ครั้ง ครั้งสุดท้ายล้ม
	m["bw_adx1"] = _mv(shoot45, {"name": "ยิงเฉียง 3 ดอก"})
	m["bw_adx2"] = _mv(shoot45, {"name": "ยิงเฉียง 3 ดอก อีกครั้ง"})
	m["bw_adx3"] = _mv(shoot45, {"name": "ยิงเฉียง 3 ดอก ล้ม", "fx": "bw_shot3_diag_kd", "next": 0.85})
	var base := {"kick": kick, "shoot": shoot, "shoot45": shoot45, "shoot_down": shoot_down}
	for line in lines():
		line.add_moves(m, base)
	_moves = m
