class_name PairLineSync
## คอมโบสาย TWIN TEMPO / HARMONY DUET ของ CAT AZURE & LAPIS ทั้งคู่ตีประสานพร้อมกัน (ทุกคอมโบมีท่า AZURE และ LAPIS)
## ชื่อท่าและเอฟเฟกต์ขึ้นต้น pc_ty_ (TWIN TEMPO) pc_hm_ (HARMONY DUET)
## TWIN TEMPO: zzx คู่หูโผล่ต่อยพร้อม 2 จังหวะ   >>zx ปาดสวนกันกลางมอน   ^xz คู่หูเสยลอย ตัวเองตบลง
## HARMONY DUET: xxz ผลัดกันพุ่งตี 4 จังหวะ   >>xz หมุนวอลทซ์คู่ มอนลอย   ^zx ดิ่งลงพร้อมกัน วงประสาน

const NEXT := {
	"TWIN TEMPO": {
		"pc_az_z2": {"x": "pc_ty_az_beat"}, "pc_lp_z2": {"x": "pc_ty_lp_beat"},
		"pc_az_dz": {"x": "pc_ty_az_scissor"}, "pc_lp_dz": {"x": "pc_ty_lp_scissor"},
		"pc_az_ax": {"z": "pc_ty_az_spike"}, "pc_lp_ax": {"z": "pc_ty_lp_spike"},
	},
	"HARMONY DUET": {
		"pc_az_x2": {"z": "pc_hm_az_tandem"}, "pc_lp_x2": {"z": "pc_hm_lp_tandem"},
		"pc_az_dx": {"z": "pc_hm_az_waltz"}, "pc_lp_turn_shot": {"z": "pc_hm_lp_waltz"},
		"pc_az_az": {"x": "pc_hm_az_dive"}, "pc_lp_az": {"x": "pc_hm_lp_dive"},
	},
}
const START := {}

const BASE := Color(0.38, 0.58, 0.95)
const ACCENT := Color(1.0, 0.82, 0.64)

static func add_moves(m: Dictionary) -> void:
	var claw: Dictionary = m["pc_az_z1"]
	var shoot: Dictionary = m["pc_lp_x1"]
	var slash: Dictionary = m["pc_lp_z1"]
	# ---- TWIN TEMPO ----
	m["pc_ty_az_beat"] = PairCombo._mv(claw, {"name": "ต่อยคู่พร้อมกัน", "time": 0.4, "next": 0.72, "dmg": 14.0, "lunge": 0.4, "fx": "pc_ty_beat", "hit": {"kb": 1.0, "stun": 0.6}})
	m["pc_ty_lp_beat"] = PairCombo._mv(slash, {"name": "ฟันคู่พร้อมกัน", "time": 0.4, "next": 0.72, "dmg": 14.0, "front_hit": true, "fx": "pc_ty_beat", "hit": {"kb": 1.0, "stun": 0.6}})
	m["pc_ty_az_scissor"] = PairCombo._mv(claw, {"name": "ปาดสวนคู่", "time": 0.42, "next": 0.78, "dmg": 0.0, "no_hit": true, "lunge": 0.6, "fx": "pc_ty_scissor"})
	m["pc_ty_lp_scissor"] = PairCombo._mv(slash, {"name": "ฟันสวนคู่", "time": 0.42, "next": 0.78, "dmg": 0.0, "no_hit": true, "fx": "pc_ty_scissor"})
	m["pc_ty_az_spike"] = PairCombo._mv(claw, {"name": "คู่หูเสย ตบลง", "hover": true, "time": 0.5, "next": 0.85, "dmg": 0.0, "no_hit": true, "fx": "pc_ty_spike"})
	m["pc_ty_lp_spike"] = PairCombo._mv(shoot, {"name": "คู่หูเสย ยิงลง", "hover": true, "time": 0.5, "next": 0.85, "fx": "pc_ty_spike"})
	# ---- HARMONY DUET ----
	m["pc_hm_az_tandem"] = PairCombo._mv(claw, {"name": "ผลัดกันพุ่งตี", "time": 0.6, "next": 0.9, "dmg": 0.0, "no_hit": true, "lunge": 0.8, "fx": "pc_hm_tandem"})
	m["pc_hm_lp_tandem"] = PairCombo._mv(slash, {"name": "ผลัดกันฟัน", "time": 0.6, "next": 0.9, "dmg": 0.0, "no_hit": true, "fx": "pc_hm_tandem"})
	m["pc_hm_az_waltz"] = PairCombo._mv(claw, {"name": "วอลทซ์คู่", "time": 0.5, "next": 0.85, "spin": 360.0, "dmg": 16.0, "wide": true, "wide_half": 170.0, "fx": "pc_hm_waltz", "hit": {"type": "launch", "vy": 10.0}})
	m["pc_hm_lp_waltz"] = PairCombo._mv(slash, {"name": "วอลทซ์คู่", "time": 0.5, "next": 0.85, "spin": 360.0, "dmg": 16.0, "wide": true, "wide_half": 170.0, "fx": "pc_hm_waltz", "hit": {"type": "launch", "vy": 10.0}})
	m["pc_hm_az_dive"] = PairCombo._mv(claw, {"name": "ดิ่งคู่", "dive": true, "wind_hand": Vector3(0.2, 0.55, 0.1), "end_hand": Vector3(0.45, -0.6, 0.05), "time": 0.44, "strike": 0.55, "next": 0.85,
		"dmg": 14.0, "lean": 30.0, "shake": 0.14, "wide": true, "wide_half": 150.0, "fx": "pc_hm_dive", "hit": {"type": "knockdown", "fly": 4.0}})
	m["pc_hm_lp_dive"] = PairCombo._mv(slash, {"name": "ดิ่งคู่", "dive": true, "time": 0.44, "strike": 0.55, "next": 0.85, "dmg": 14.0, "wide": true, "wide_half": 150.0, "fx": "pc_hm_dive", "hit": {"type": "knockdown", "fly": 4.0}})

static func cast(page: WalkPage, fx: String) -> bool:
	if not (fx.begins_with("pc_ty_") or fx.begins_with("pc_hm_")):
		return false
	var f := page.hero.facing
	var hp := page.hero.position
	var U := CombatData.UNIT
	var K := SkillScale.K
	match fx:
		"pc_ty_beat":
			partner(page, 0.7, "z2", 0.5, f)
			_after(page, 0.12, func() -> void:
				var c := page.hero.position + Vector2(f * 1.2 * U * K, -70.0)
				fx_node(page, "burst", c, 80.0, 0.3)
				page._hit_area(c.x, 1.0 * U * K, 12.0, f, null, {"kb": 1.2, "stun": 0.6}))
		"pc_ty_scissor":
			var mid := hp + Vector2(f * 1.6 * U * K, -70.0)
			partner(page, 3.2 * K, "z3", 0.6, -f)
			_after(page, 0.14, func() -> void:
				fx_node(page, "cross", mid, 1.2 * U, 0.4)
				for e in page.get_tree().get_nodes_in_group("monsters"):
					var mo := e as Monster
					if mo != null and mo.state != "dead" and absf(mo.position.x - mid.x) < 2.0 * U * K and mo.role != "boss" and mo.role != "boss_raid":
						mo.pos.x = lerpf(mo.pos.x, mid.x / U, 0.5)
				page._hit_area(mid.x, 1.8 * U * K, 20.0, f, null, {"kb": 0.5, "stun": 0.8}))
		"pc_ty_spike":
			var at := hp + Vector2(f * 1.0 * U * K, 0.0)
			partner(page, 1.0, "z4", 0.6, -f)
			_after(page, 0.12, func() -> void:
				fx_node(page, "burst", at + Vector2(0.0, -80.0), 70.0, 0.3)
				page._hit_area(at.x, 1.2 * U * K, 12.0, f, null, {"type": "launch", "vy": 11.0}))
			_after(page, 0.42, func() -> void:
				fx_node(page, "ring", Vector2(page.hero.position.x + f * 80.0, 0.0), 1.8 * U, 0.4)
				page._hit_area(page.hero.position.x + f * 80.0, 1.4 * U * K, 18.0, f, null, {"type": "knockdown", "fly": 4.0}))
		"pc_hm_tandem":
			for i in 4:
				var k := i
				_after(page, 0.04 + float(i) * 0.13, func() -> void:
					var x := page.hero.position.x + f * (0.8 + float(k) * 0.35) * U * K
					if k % 2 == 1:
						partner(page, 0.8 + float(k) * 0.35, "z2", 0.35, f)
					fx_node(page, "line", Vector2(x - f * 60.0, -70.0), 40.0, 0.2, null, Vector2(f * 120.0, 0.0))
					page._hit_area(x, 0.9 * U * K, 10.0 if k < 3 else 16.0, f, null, {"kb": 0.8 if k < 3 else 2.5, "stun": 0.5}))
		"pc_hm_waltz":
			partner(page, 0.5, "", 0.6, -f)
			fx_node(page, "notes", hp + Vector2(0.0, -80.0), 150.0, 0.5, page.hero)
		"pc_hm_dive":
			partner(page, 1.2 * K, "", 0.6, f)
			fx_node(page, "ring", Vector2(hp.x, 0.0), 2.4 * U, 0.45)
			fx_node(page, "notes", hp + Vector2(0.0, -100.0), 130.0, 0.5)
	return true

static func _after(page: WalkPage, t: float, fn: Callable) -> void:
	page.get_tree().create_timer(t, false).timeout.connect(func() -> void:
		if is_instance_valid(page) and is_instance_valid(page.hero):
			fn.call())

## คู่หูโผล่ข้างตัวชั่วครู่ dx หน่วย (+ ด้านหน้า)
static func partner(page: WalkPage, dx: float, key: String, life: float, face: float) -> PairSkillFx.PairPartner:
	var h := page.hero
	var p := PairSkillFx.PairPartner.new()
	p.page = page
	p.at = Vector2(clampf(h.pos.x + h.facing * dx, -h.half_width, h.half_width), maxf(h.pos.y, 0.0))
	p.facing = face
	if key != "":
		var other := "az" if PairCombo.form() == "lp" else "lp"
		var mv: Dictionary = PairCombo.move("pc_" + other + "_" + key).duplicate(true)
		for k2 in ["auto", "fx", "fx_start", "dive", "dive_forward", "leap", "hover", "turn_around", "drag", "front_hit", "multi", "wide", "sa"]:
			mv.erase(k2)
		p.move = mv
	p.swing_time = 0.3
	p.life = life
	page.world.add_child(p)
	return p

static func fx_node(page: WalkPage, kind: String, at: Vector2, size: float, life: float, follow: Node2D = null, to := Vector2.ZERO, base := BASE, accent := ACCENT) -> PairSkillFx:
	var n := PairSkillFx.new()
	n.kind = kind
	n.base = base
	n.accent = accent
	n.size = size * SkillScale.K
	n.life = life
	n.dir = page.hero.facing
	n.to = to
	n.position = at
	if follow != null:
		n.follow = follow
		n.offset = at - follow.position
	page.world.add_child(n)
	return n
