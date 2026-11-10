class_name PairLineRaw
## คอมโบตอนแปลงร่างพลังดิบของ CAT AZURE & LAPIS (PairCombo.tf = "az" / "lp")
## AZURE (SPARK DREAMER 35.1): zzzz ข่วนพลังดิบ ทีสุดท้ายยิงประกายไล่ล่า  xxx ยิงประกายไล่ล่า  >>z พุ่งพลังดิบ  >>x บอลพลังกลม
## LAPIS (SOMNAMBULIST 50.1): zzzzz ฟันดาบแสงยาวรัวแรงเร็ว  xxx แทงดาบยาวพุ่ง  >>z พุ่งฟันผ่าน  >>x ฟันวงกว้าง
## ชื่อท่า pc_rw_az_ / pc_rw_lp_

const NEXT := {}
const START := {}
const TF_NEXT := {
	"az": {
		"pc_rw_az_z1": {"z": "pc_rw_az_z2"}, "pc_rw_az_z2": {"z": "pc_rw_az_z3"}, "pc_rw_az_z3": {"z": "pc_rw_az_z4"},
		"pc_rw_az_x1": {"x": "pc_rw_az_x2"}, "pc_rw_az_x2": {"x": "pc_rw_az_x3"},
		"pc_rw_az_dz": {"x": "pc_rw_az_dx"},
	},
	"lp": {
		"pc_rw_lp_z1": {"z": "pc_rw_lp_z2"}, "pc_rw_lp_z2": {"z": "pc_rw_lp_z3"}, "pc_rw_lp_z3": {"z": "pc_rw_lp_z4"}, "pc_rw_lp_z4": {"z": "pc_rw_lp_z5"},
		"pc_rw_lp_x1": {"x": "pc_rw_lp_x2"}, "pc_rw_lp_x2": {"x": "pc_rw_lp_x3"},
		"pc_rw_lp_dz": {"x": "pc_rw_lp_dx"},
	},
}

const AZ_BASE := Color(0.32, 0.58, 1.0)
const AZ_ACCENT := Color(0.78, 0.95, 1.0)
const LP_BASE := Color(0.52, 0.48, 0.95)
const LP_ACCENT := Color(0.88, 0.84, 1.0)

static func start_tf(tf: String, state: String, button: String) -> String:
	var p := "pc_rw_" + tf + "_"
	match state:
		"dash", "airdash":
			return p + ("dz" if button == "z" else "dx")
		"air":
			return p + ("az" if button == "z" else "ax")
	return p + ("z1" if button == "z" else "x1")

static func next_tf(tf: String, current: String, button: String) -> String:
	var t: Dictionary = TF_NEXT.get(tf, {})
	return str((t.get(current, {}) as Dictionary).get(button, ""))

static func add_moves(m: Dictionary) -> void:
	var claw: Dictionary = m["pc_az_z1"]
	var shoot: Dictionary = m["pc_lp_x1"]
	var slash: Dictionary = m["pc_lp_z1"]
	# ---- AZURE พลังดิบ ----
	m["pc_rw_az_z1"] = PairCombo._mv(claw, {"name": "ข่วนพลังดิบ 1", "time": 0.24, "next": 0.55, "dmg": 12.0, "fx": "pc_rw_az_claw"})
	m["pc_rw_az_z2"] = PairCombo._mv(claw, {"name": "ข่วนพลังดิบ 2", "time": 0.24, "next": 0.55, "dmg": 12.0, "twist": 20.0, "fx": "pc_rw_az_claw"})
	m["pc_rw_az_z3"] = PairCombo._mv(claw, {"name": "ข่วนพลังดิบสองมือ", "time": 0.28, "next": 0.6, "dmg": 14.0, "spin": 180.0, "fx": "pc_rw_az_claw"})
	m["pc_rw_az_z4"] = PairCombo._mv(claw, {"name": "ข่วนยิงประกาย", "time": 0.36, "next": 0.7, "dmg": 16.0, "shake": 0.12, "fx": "pc_rw_az_seek3", "hit": {"type": "launch", "vy": 9.0}})
	var seek := PairCombo._mv(shoot, {"name": "ยิงประกายไล่ล่า", "time": 0.26, "next": 0.55, "fx": "pc_rw_az_seek2"})
	m["pc_rw_az_x1"] = seek
	m["pc_rw_az_x2"] = seek.duplicate(true)
	m["pc_rw_az_x3"] = PairCombo._mv(seek, {"name": "ยิงประกายไล่ล่า 4 ลูก", "time": 0.34, "next": 0.7, "fx": "pc_rw_az_seek4"})
	m["pc_rw_az_dz"] = PairCombo._mv(claw, {"name": "พุ่งพลังดิบ", "time": 0.38, "wind": 0.12, "strike": 0.55, "next": 0.75, "dmg": 18.0, "lunge": 2.6, "lean": 28.0, "shake": 0.14,
		"fx": "pc_rw_az_dash", "hit": {"kb": 2.0, "stun": 0.7}})
	m["pc_rw_az_dx"] = PairCombo._mv(shoot, {"name": "บอลพลังกลม", "time": 0.4, "next": 0.8, "fx": "pc_rw_az_orb"})
	m["pc_rw_az_az"] = PairCombo._mv(claw, {"name": "ข่วนพลังดิบดิ่ง", "dive": true, "wind_hand": Vector3(0.2, 0.55, 0.1), "end_hand": Vector3(0.45, -0.6, 0.05), "time": 0.38, "strike": 0.55,
		"next": 0.8, "dmg": 16.0, "lean": 30.0, "shake": 0.14, "fx": "pc_rw_az_claw", "hit": {"kb": 0.6, "stun": 0.8}})
	m["pc_rw_az_ax"] = PairCombo._mv(shoot, {"name": "โปรยประกายไล่ล่า", "hover": true, "time": 0.36, "next": 0.75, "fx": "pc_rw_az_seek4"})
	# ---- LAPIS ดาบแสงยาว ----
	var blade := PairCombo._mv(slash, {"name": "ฟันดาบแสงยาว", "time": 0.2, "wind": 0.15, "strike": 0.45, "next": 0.5, "dmg": 11.0, "lunge": 0.25, "front_hit": true,
		"wide": true, "wide_half": 150.0, "fx": "pc_rw_lp_blade", "hit": {"kb": 0.8, "stun": 0.45}})
	var slashes: Array = Hero.CHIBI_Z
	for i in 5:
		var src: Dictionary = slashes[i % slashes.size()]
		m["pc_rw_lp_z%d" % (i + 1)] = PairCombo._mv(src, blade.duplicate(true))
		m["pc_rw_lp_z%d" % (i + 1)]["name"] = "ฟันดาบแสงยาว %d" % (i + 1)
	m["pc_rw_lp_z5"] = PairCombo._mv(m["pc_rw_lp_z5"], {"name": "ฟันดาบแสงยาวปิด", "time": 0.3, "next": 0.7, "dmg": 20.0, "shake": 0.16, "fx": "pc_rw_lp_big", "hit": {"type": "knockdown", "fly": 5.0}})
	var thrust := PairCombo._mv(slashes[2], {"name": "แทงดาบยาว", "time": 0.26, "wind": 0.15, "strike": 0.5, "next": 0.58, "dmg": 13.0, "lunge": 1.2, "front_hit": true,
		"fx": "pc_rw_lp_thrust", "hit": {"kb": 1.6, "stun": 0.5}})
	m["pc_rw_lp_x1"] = thrust
	m["pc_rw_lp_x2"] = thrust.duplicate(true)
	m["pc_rw_lp_x3"] = PairCombo._mv(thrust, {"name": "แทงดาบยาวแรง", "time": 0.34, "next": 0.7, "dmg": 20.0, "lunge": 1.8, "shake": 0.14, "hit": {"type": "knockdown", "fly": 5.0}})
	m["pc_rw_lp_dz"] = PairCombo._mv(blade, {"name": "พุ่งฟันผ่าน", "time": 0.36, "strike": 0.55, "next": 0.75, "dmg": 18.0, "lunge": 2.8, "drag": true, "fx": "pc_rw_lp_big"})
	m["pc_rw_lp_dx"] = PairCombo._mv(slashes[3], {"name": "ฟันวงกว้าง", "spin": 360.0, "time": 0.4, "next": 0.8, "dmg": 18.0, "wide": true, "wide_half": 220.0, "front_hit": false,
		"fx": "pc_rw_lp_spin", "hit": {"type": "launch", "vy": 10.0}})
	m["pc_rw_lp_az"] = PairCombo._mv(Hero.CHIBI_MOVES["az"], {"name": "ฟันดาบยาวดิ่ง", "dmg": 16.0, "fx": "pc_rw_lp_blade"})
	m["pc_rw_lp_ax"] = PairCombo._mv(blade, {"name": "ฟันดาบยาวกลางอากาศ", "hover": true, "time": 0.3, "next": 0.7, "dmg": 15.0})

static func cast(page: WalkPage, fx: String) -> bool:
	if not fx.begins_with("pc_rw_"):
		return false
	var f := page.hero.facing
	var hp := page.hero.position
	var U := CombatData.UNIT
	var K := SkillScale.K
	match fx:
		"pc_rw_az_claw":
			PairLineSync.fx_node(page, "burst", hp + Vector2(f * 100.0, -70.0), 70.0, 0.25, null, Vector2.ZERO, AZ_BASE, AZ_ACCENT)
		"pc_rw_az_seek2", "pc_rw_az_seek3", "pc_rw_az_seek4":
			var n: int = {"pc_rw_az_seek2": 2, "pc_rw_az_seek3": 3, "pc_rw_az_seek4": 4}[fx]
			for i in n:
				var a := -0.5 + float(i) / maxf(float(n - 1), 1.0)
				homing(page, PairFx._muzzle(page), Vector2(f * cos(a * 0.9), sin(a * 0.9) - 0.2) * 800.0, 8.0)
		"pc_rw_az_dash":
			PairLineSync.fx_node(page, "line", hp + Vector2(-f * 80.0, -70.0), 46.0, 0.3, null, Vector2(f * 2.6 * U * K, 0.0), AZ_BASE, AZ_ACCENT)
		"pc_rw_az_orb":
			var b := PairSkillFx.PairOrb.new()
			b.style = "spark"
			b.base = AZ_BASE
			b.accent = AZ_ACCENT
			b.position = PairFx._muzzle(page)
			b.vel = Vector2(f * 650.0, 0.0)
			b.radius = 44.0 * K
			b.dmg = 18.0
			b.pierce = true
			b.life = 1.1
			b.extra = {"kb": 1.5, "stun": 0.6}
			page.world.add_child(b)
		"pc_rw_lp_blade":
			PairLineSync.fx_node(page, "line", hp + Vector2(f * 30.0, -95.0), 34.0, 0.18, null, Vector2(f * 2.4 * U * K, 34.0), LP_BASE, LP_ACCENT)
			page._hit_area(hp.x + f * 1.9 * U * K, 0.9 * U * K, 5.0, f, null, {"kb": 0.6, "stun": 0.4})
		"pc_rw_lp_big":
			PairLineSync.fx_node(page, "cross", hp + Vector2(f * 1.4 * U * K, -80.0), 1.6 * U, 0.35, null, Vector2.ZERO, LP_BASE, LP_ACCENT)
			page._hit_area(hp.x + f * 2.0 * U * K, 1.2 * U * K, 10.0, f, null, {"kb": 2.0, "stun": 0.5})
		"pc_rw_lp_thrust":
			PairLineSync.fx_node(page, "beam", hp + Vector2(f * 40.0, -80.0), 30.0, 0.22, null, Vector2(f * 3.2 * U * K, 0.0), LP_BASE, LP_ACCENT)
			page._hit_area(hp.x + f * 2.4 * U * K, 1.0 * U * K, 7.0, f, null, {"kb": 1.2, "stun": 0.4})
		"pc_rw_lp_spin":
			PairLineSync.fx_node(page, "ring", hp, 3.0 * U, 0.4, null, Vector2.ZERO, LP_BASE, LP_ACCENT)
	return true

static func homing(page: WalkPage, at: Vector2, vel: Vector2, dmg: float) -> PairSkillsPlus.HomingOrb:
	var b := PairSkillsPlus.HomingOrb.new()
	b.style = "spark"
	b.base = AZ_BASE
	b.accent = AZ_ACCENT
	b.position = at
	b.vel = vel
	b.speed = 850.0
	b.radius = 16.0 * SkillScale.K
	b.dmg = dmg
	b.pierce = false
	b.life = 1.4
	b.delay = 0.06
	b.extra = {"kb": 0.4, "stun": 0.4}
	page.world.add_child(b)
	return b
