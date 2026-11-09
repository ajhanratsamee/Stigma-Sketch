class_name PairCombo
## คอมโบ BASIC ของ CAT AZURE & LAPIS (weapon "azure") แยกท่าตามตัวที่ออกหน้า WalkPage.pair_form
## AZURE ใช้กรงเล็บกับหมัด ท่าขึ้นต้น pc_az_  LAPIS ใช้ปืนน่ารักติดดาบปลายปืนสั้น ท่าขึ้นต้น pc_lp_
## ท่าปิดบางท่าเรียกอีกตัวกระโดดออกมาช่วยเตะ (เอฟเฟกต์ pc_assist ใน PairFx)

const NEXT := {
	"BASIC": {
		# AZURE zzzzx: ข่วน 3 ที ทีที่ 4 เสยลอย x เรียก LAPIS เตะ
		"pc_az_z1": {"z": "pc_az_z2"}, "pc_az_z2": {"z": "pc_az_z3"}, "pc_az_z3": {"z": "pc_az_z4"}, "pc_az_z4": {"x": "pc_az_call"},
		# AZURE xxxxz: ต่อยไถล 3 ที ทีที่ 4 ทุบพื้นลอย z เรียก LAPIS เตะ
		"pc_az_x1": {"x": "pc_az_x2"}, "pc_az_x2": {"x": "pc_az_x3"}, "pc_az_x3": {"x": "pc_az_x4"}, "pc_az_x4": {"z": "pc_az_call"},
		# AZURE >>^zx: ข่วนไปหน้า แล้วคลื่นพลังน้ำเงินตรง
		"pc_az_adz": {"x": "pc_az_wave"},
		# AZURE >>^xxxxz: ดีดขึ้น พุ่งเฉียงลง ต่อย ตวัดขึ้น แล้ว z เรียก LAPIS เตะ
		"pc_az_adx1": {"x": "pc_az_adx2"}, "pc_az_adx2": {"x": "pc_az_adx3"}, "pc_az_adx3": {"x": "pc_az_adx4"}, "pc_az_adx4": {"z": "pc_az_call"},
		# LAPIS zzzzx: ฟันดาบปลายปืน 3 ที ทีที่ 4 ยิงลอย x เรียก AZURE เตะ
		"pc_lp_z1": {"z": "pc_lp_z2"}, "pc_lp_z2": {"z": "pc_lp_z3"}, "pc_lp_z3": {"z": "pc_lp_z4"}, "pc_lp_z4": {"x": "pc_lp_call"},
		# LAPIS xxxxz: ยิง 3 นัด นัดที่ 4 แรง z เรียก AZURE เตะ
		"pc_lp_x1": {"x": "pc_lp_x2"}, "pc_lp_x2": {"x": "pc_lp_x3"}, "pc_lp_x3": {"x": "pc_lp_x4"}, "pc_lp_x4": {"z": "pc_lp_call"},
		# LAPIS >>^zx: ฟันตวัดรอบตัว แล้วปาระเบิดน้ำเงินลงพื้น
		"pc_lp_adz": {"x": "pc_lp_grenade"},
		# LAPIS >>^xxxxz: กระโดดสูงขึ้นยิงเฉียงลง 4 นัด แล้ว z เรียก AZURE พุ่งลงต่อยพื้น
		"pc_lp_adx1": {"x": "pc_lp_adx2"}, "pc_lp_adx2": {"x": "pc_lp_adx3"}, "pc_lp_adx3": {"x": "pc_lp_adx4"}, "pc_lp_adx4": {"z": "pc_lp_call_dive"},
	},
}

static var _moves := {}

static func lines() -> Array:
	return [PairLineDream, PairLineFiend]

static func chain(class_id: String) -> Array:
	var out := []
	if class_id != "" and class_id != "BASIC":
		out.append(class_id)
		for a in SkillPanel.ancestors(class_id):
			if a != "BASIC":
				out.append(a)
	out.append("BASIC")
	return out

## ตัวที่ออกหน้าตอนนี้ "az" หรือ "lp"
static func form() -> String:
	return "lp" if WalkPage.pair_form == "lapis" else "az"

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
	var p := "pc_" + form() + "_"
	match state:
		"dash":
			return p + ("dz" if button == "z" else "dx")
		"air":
			return p + ("az" if button == "z" else "ax")
		"airdash":
			return p + ("adz" if button == "z" else "adx1")
	return p + ("z1" if button == "z" else "x1")

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
	return _moves.get(id, _moves["pc_az_z1"])

static func _build() -> void:
	# ---- ท่าพื้นฐาน ----
	# ข่วน/ต่อย มือถือกรงเล็บพุ่งไปหน้าระดับอก
	var claw := {"name": "ข่วน", "wind_hand": Vector3(0.1, 0.35, 0.15), "wind_aim": Vector2(110.0, 0.0), "end_hand": Vector3(0.8, -0.15, 0.05), "end_aim": Vector2(70.0, 0.0),
		"wind_off": Vector3(0.25, 0.1, -0.1), "end_off": Vector3(0.55, -0.05, 0.1), "ease": 3.0, "time": 0.28, "wind": 0.3, "strike": 0.5, "next": 0.62,
		"dmg": 9.0, "lunge": 0.3, "shake": 0.06, "stop": 0.04, "lean": 14.0, "twist": -20.0, "front_hit": true, "no_trail": true, "fx": "pc_claw", "hit": {"kb": 0.6, "stun": 0.45}}
	# ยิงปืน ปืนชี้ไปหน้าระดับอก ไม่ทำดาเมจเอง ลูกกระสุนทำแทน
	var shoot := {"name": "ยิงปืน", "wind_hand": Vector3(0.45, -0.05, 0.15), "wind_aim": Vector2(90.0, 0.0), "end_hand": Vector3(0.62, -0.02, 0.12), "end_aim": Vector2(92.0, 0.0),
		"wind_off": Vector3(0.4, -0.08, 0.12), "end_off": Vector3(0.3, -0.06, 0.12), "ease": 3.0, "time": 0.3, "wind": 0.3, "strike": 0.45, "next": 0.6,
		"dmg": 0.0, "lunge": -0.1, "shake": 0.05, "stop": 0.0, "lean": -6.0, "twist": -20.0, "no_hit": true, "no_trail": true, "fx": "pc_shot"}
	# ฟันดาบปลายปืน ใช้ท่าฟันดาบของแมว
	var slash: Array = Hero.CHIBI_Z
	var kick: Dictionary = (Hero.CAT_SKILLS["cat_sk_kick"] as Dictionary).duplicate(true)
	kick.merge({"no_trail": true, "fx": "pc_kick"}, true)
	# ท่าเรียกอีกตัวออกมาช่วย ชี้มือไปหน้าแป๊บเดียว
	var call := _mv(shoot, {"name": "เรียกคู่หูช่วย", "time": 0.36, "wind": 0.2, "strike": 0.35, "next": 0.95, "lunge": -0.2, "fx": "pc_assist"})
	var m := {}
	# ================= AZURE =================
	m["pc_az_z1"] = _mv(claw, {"name": "ข่วน 1"})
	m["pc_az_z2"] = _mv(claw, {"name": "ข่วน 2", "wind_hand": Vector3(0.6, 0.4, 0.1), "end_hand": Vector3(0.3, -0.35, 0.1), "twist": 20.0})
	m["pc_az_z3"] = _mv(claw, {"name": "ข่วนสองมือ", "time": 0.32, "dmg": 11.0, "lunge": 0.35, "spin": 180.0, "fx": "pc_claw2"})
	m["pc_az_z4"] = _mv(claw, {"name": "ข่วนเสยลอย", "wind_hand": Vector3(0.3, -0.45, 0.15), "end_hand": Vector3(0.5, 0.65, 0.05), "time": 0.4, "next": 0.66,
		"dmg": 15.0, "lean": -12.0, "shake": 0.14, "stop": 0.08, "fx": "pc_claw_up", "hit": {"type": "launch", "vy": 11.0}})
	m["pc_az_call"] = call
	# xxxx ต่อยไถลมอนไปหน้า
	var punch := _mv(claw, {"name": "ต่อยไถล", "wind_hand": Vector3(0.15, -0.02, 0.15), "wind_aim": Vector2(90.0, 0.0), "end_hand": Vector3(0.85, -0.02, 0.05), "end_aim": Vector2(90.0, 0.0),
		"dmg": 9.0, "lunge": 0.7, "drag": true, "fx": "pc_punch", "hit": {"kb": 1.2, "stun": 0.5}})
	m["pc_az_x1"] = _mv(punch, {"name": "ต่อยไถล 1"})
	m["pc_az_x2"] = _mv(punch, {"name": "ต่อยไถล 2", "twist": 20.0})
	m["pc_az_x3"] = _mv(punch, {"name": "ต่อยไถล 3", "dmg": 10.0})
	m["pc_az_x4"] = _mv(punch, {"name": "ทุบพื้นมอนลอย", "wind_hand": Vector3(0.2, 0.65, 0.1), "end_hand": Vector3(0.65, -0.55, 0.05), "end_aim": Vector2(-60.0, 0.0),
		"time": 0.44, "next": 0.7, "dmg": 15.0, "lunge": 0.2, "drag": false, "lean": 30.0, "shake": 0.2, "stop": 0.08, "fx": "pc_pound", "hit": {"type": "launch", "vy": 10.0}})
	# >>^zx ข่วนไปหน้า แล้วคลื่นพลังน้ำเงิน
	m["pc_az_adz"] = _mv(claw, {"name": "ข่วนกลางอากาศ", "hover": true, "dmg": 11.0, "lunge": 0.4, "next": 0.66})
	m["pc_az_wave"] = _mv(claw, {"name": "คลื่นพลังน้ำเงิน", "hover": true, "time": 0.36, "next": 0.85, "dmg": 0.0, "no_hit": true, "lunge": -0.1, "fx": "pc_wave"})
	# >>^xxxxz ดีดขึ้น พุ่งเฉียงลง ต่อย ตวัดขึ้น
	m["pc_az_adx1"] = _mv(claw, {"name": "ดีดตัวขึ้น", "leap": 5.0, "time": 0.3, "strike": 0.5, "next": 0.55, "dmg": 0.0, "no_hit": true, "fx": "", "lean": -15.0})
	m["pc_az_adx2"] = _mv(claw, {"name": "พุ่งเฉียงลง", "dive": true, "dive_forward": 4.0, "wind_hand": Vector3(0.3, 0.3, 0.1), "end_hand": Vector3(0.75, -0.45, 0.05),
		"time": 0.4, "strike": 0.55, "next": 0.7, "dmg": 12.0, "lean": 30.0, "shake": 0.14, "fx": "pc_pound"})
	m["pc_az_adx3"] = _mv(punch, {"name": "ต่อยไปหน้า", "dmg": 10.0, "lunge": 0.5})
	m["pc_az_adx4"] = _mv(claw, {"name": "ตวัดมอนขึ้น", "wind_hand": Vector3(0.3, -0.45, 0.15), "end_hand": Vector3(0.5, 0.65, 0.05), "time": 0.4, "next": 0.68,
		"dmg": 13.0, "lean": -12.0, "shake": 0.12, "fx": "pc_claw_up", "hit": {"type": "launch", "vy": 10.0}})
	# >>z ข่วนมอนลอยไปหน้า
	m["pc_az_dz"] = _mv(claw, {"name": "พุ่งข่วนเสย", "time": 0.42, "wind": 0.15, "strike": 0.6, "next": 0.8, "dmg": 14.0, "lunge": 2.2, "lean": 28.0,
		"shake": 0.14, "fx": "pc_claw_up", "hit": {"type": "launch", "vy": 9.0}})
	# >>x กระโดดกำหมัดทุบพื้น
	m["pc_az_dx"] = _mv(claw, {"name": "กระโดดทุบพื้น", "leap": 5.5, "wind_hand": Vector3(0.2, 0.7, 0.1), "end_hand": Vector3(0.6, -0.6, 0.05), "end_aim": Vector2(-60.0, 0.0),
		"time": 0.55, "wind": 0.35, "strike": 0.62, "next": 0.85, "dmg": 16.0, "lunge": 1.0, "lean": 30.0, "shake": 0.22, "stop": 0.08, "fx": "pc_pound",
		"wide": true, "wide_half": 170.0, "hit": {"kb": 0.8, "stun": 0.9}})
	# ^z ข่วนลงแนวดิ่ง  ^x ข่วนแรงมอนล้ม
	m["pc_az_az"] = _mv(claw, {"name": "ข่วนดิ่งลง", "dive": true, "wind_hand": Vector3(0.2, 0.55, 0.1), "end_hand": Vector3(0.45, -0.6, 0.05), "time": 0.4, "strike": 0.55,
		"next": 0.8, "dmg": 14.0, "lean": 30.0, "shake": 0.16, "fx": "pc_claw_down", "hit": {"kb": 0.4, "stun": 0.8}})
	m["pc_az_ax"] = _mv(claw, {"name": "ข่วนแรงมอนล้ม", "hover": true, "time": 0.44, "next": 0.8, "dmg": 15.0, "lunge": 0.4, "spin": 360.0, "shake": 0.18,
		"fx": "pc_claw2", "hit": {"type": "knockdown", "fly": 4.0}})
	# ================= LAPIS =================
	m["pc_lp_z1"] = _mv(slash[0], {"name": "ฟันดาบปลายปืน 1", "dmg": 9.0, "front_hit": true, "fx": "pc_slash", "hit": {"kb": 0.6, "stun": 0.45}})
	m["pc_lp_z2"] = _mv(slash[1], {"name": "ฟันดาบปลายปืน 2", "dmg": 9.0, "front_hit": true, "fx": "pc_slash", "hit": {"kb": 0.6, "stun": 0.45}})
	m["pc_lp_z3"] = _mv(slash[2], {"name": "แทงดาบปลายปืน", "dmg": 11.0, "front_hit": true, "fx": "pc_slash", "hit": {"kb": 0.8, "stun": 0.5}})
	m["pc_lp_z4"] = _mv(shoot, {"name": "ยิงกระสุนน้ำเงินลอย", "time": 0.36, "next": 0.66, "shake": 0.1, "fx": "pc_shot_launch"})
	m["pc_lp_call"] = call
	m["pc_lp_call_dive"] = _mv(call, {"name": "เรียก AZURE พุ่งลง", "hover": true, "fx": "pc_assist_dive"})
	m["pc_lp_x1"] = _mv(shoot, {"name": "ยิง 1"})
	m["pc_lp_x2"] = _mv(shoot, {"name": "ยิง 2"})
	m["pc_lp_x3"] = _mv(shoot, {"name": "ยิง 3"})
	m["pc_lp_x4"] = _mv(shoot, {"name": "ยิงแรง", "time": 0.42, "next": 0.72, "lunge": -0.35, "shake": 0.16, "fx": "pc_shot_big"})
	# >>^zx ฟันตวัดรอบตัว แล้วปาระเบิด
	m["pc_lp_adz"] = _mv(slash[3], {"name": "ฟันตวัดรอบตัว", "hover": true, "spin": 360.0, "dmg": 11.0, "wide": true, "wide_half": 170.0, "fx": "pc_slash", "hit": {"kb": 0.8, "stun": 0.5}})
	m["pc_lp_grenade"] = _mv(shoot, {"name": "ปาระเบิดน้ำเงิน", "hover": true, "wind_hand": Vector3(-0.1, 0.4, 0.1), "end_hand": Vector3(0.6, 0.1, 0.1), "time": 0.38, "next": 0.85, "fx": "pc_grenade"})
	# >>^xxxxz กระโดดสูงขึ้นยิงเฉียงลง 4 นัด
	var diag := _mv(shoot, {"name": "ยิงเฉียงลง", "hover": true, "wind_hand": Vector3(0.4, -0.15, 0.15), "wind_aim": Vector2(40.0, 0.0), "end_hand": Vector3(0.55, -0.3, 0.12),
		"end_aim": Vector2(45.0, 0.0), "lean": 18.0, "time": 0.36, "next": 0.7, "fx": "pc_shot_diag"})
	m["pc_lp_adx1"] = _mv(diag, {"name": "กระโดดยิงเฉียงลง", "leap": 5.0, "hover": null})
	m["pc_lp_adx1"].erase("hover")
	m["pc_lp_adx2"] = _mv(diag, {"name": "ยิงเฉียงลง 2"})
	m["pc_lp_adx3"] = _mv(diag, {"name": "ยิงเฉียงลง 3"})
	m["pc_lp_adx4"] = _mv(diag, {"name": "ยิงเฉียงลง 4", "time": 0.32, "next": 0.66})
	# >>z สไลด์เตะ
	m["pc_lp_dz"] = _mv(kick, {"name": "สไลด์เตะ", "dmg": 13.0, "time": 0.55, "wind": 0.08, "strike": 0.72, "next": 0.82, "lunge": 3.2, "lean": -55.0, "drag": true,
		"front_hit": true, "hit": {"kb": 1.6, "stun": 0.7}})
	# >>x อ้อมหลังแล้วยิง ไม่ทำดาเมจตอนอ้อม
	m["pc_lp_dx"] = _mv(Hero.MK_MOVES["mk_spin_through"], {"name": "อ้อมหลัง", "auto": "pc_lp_turn_shot", "dmg": 0.0, "no_hit": true, "time": 0.28})
	m["pc_lp_turn_shot"] = _mv(shoot, {"name": "หันหลังยิง", "turn_around": true, "time": 0.3, "next": 0.7})
	# ^z ฟันลงแนวดิ่ง  ^x ยิงไปหน้า
	m["pc_lp_az"] = _mv(Hero.CHIBI_MOVES["az"], {"name": "ฟันดิ่งลง", "dmg": 14.0, "fx": "pc_slash"})
	m["pc_lp_ax"] = _mv(shoot, {"name": "ยิงกลางอากาศ", "hover": true, "time": 0.32, "next": 0.66})
	for line in lines():
		line.add_moves(m)
	_moves = m
