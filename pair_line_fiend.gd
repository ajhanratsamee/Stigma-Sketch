class_name PairLineFiend
## คอมโบสาย SPARK FIEND / NEON BOLT ของ CAT AZURE & LAPIS (ทุกคอมโบมีทั้งท่า AZURE และ LAPIS)
## ชื่อท่าและเอฟเฟกต์ขึ้นต้น pc_fd_ (SPARK FIEND) pc_nb_ (NEON BOLT)
## SPARK FIEND: zzx เสยไฟฟ้า / กระสุนช็อตต่อ   >>zx พุ่งไฟฟ้า / บอลไฟฟ้า   ^xz ดิ่งฟ้าผ่า / ยิงเสาฟ้าผ่า
## NEON BOLT: xxz พุ่งฟันนีออน / ลำแสงราง   >>xz กากบาทนีออน / พุ่งนีออนกลับ   ^zx แท่งนีออนตก / ฝนนีออน 3 สาย

const NEXT := {
	"SPARK FIEND": {
		"pc_az_z2": {"x": "pc_fd_az_upper"}, "pc_lp_z2": {"x": "pc_fd_lp_zap"},
		"pc_az_dz": {"x": "pc_fd_az_rush"}, "pc_lp_dz": {"x": "pc_fd_lp_ball"},
		"pc_az_ax": {"z": "pc_fd_az_drop"}, "pc_lp_ax": {"z": "pc_fd_lp_column"},
	},
	"NEON BOLT": {
		"pc_az_x2": {"z": "pc_nb_az_dash"}, "pc_lp_x2": {"z": "pc_nb_lp_rail"},
		"pc_az_dx": {"z": "pc_nb_az_cross"}, "pc_lp_turn_shot": {"z": "pc_nb_lp_dash"},
		"pc_az_az": {"x": "pc_nb_az_grid"}, "pc_lp_az": {"x": "pc_nb_lp_rain"},
	},
}
const START := {}

const BASE := Color(0.18, 0.42, 1.0)
const ACCENT := Color(0.72, 1.0, 1.0)

static func add_moves(m: Dictionary) -> void:
	var claw: Dictionary = m["pc_az_z1"]
	var shoot: Dictionary = m["pc_lp_x1"]
	var slash: Dictionary = m["pc_lp_z1"]
	# ---- SPARK FIEND ----
	m["pc_fd_az_upper"] = PairCombo._mv(claw, {"name": "เสยไฟฟ้า", "wind_hand": Vector3(0.3, -0.45, 0.15), "end_hand": Vector3(0.5, 0.65, 0.05), "time": 0.4, "next": 0.68,
		"dmg": 16.0, "lean": -12.0, "shake": 0.14, "fx": "pc_fd_spark", "hit": {"type": "launch", "vy": 11.0}})
	m["pc_fd_lp_zap"] = PairCombo._mv(shoot, {"name": "กระสุนช็อตต่อ", "time": 0.36, "next": 0.7, "fx": "pc_fd_chain"})
	m["pc_fd_az_rush"] = PairCombo._mv(claw, {"name": "พุ่งไฟฟ้า", "time": 0.4, "wind": 0.12, "strike": 0.6, "next": 0.8, "dmg": 15.0, "lunge": 2.6, "lean": 28.0,
		"front_hit": true, "fx": "pc_fd_trail", "hit": {"kb": 1.8, "stun": 0.6}})
	m["pc_fd_lp_ball"] = PairCombo._mv(shoot, {"name": "ยิงบอลไฟฟ้า", "time": 0.4, "next": 0.78, "fx": "pc_fd_ball"})
	m["pc_fd_az_drop"] = PairCombo._mv(claw, {"name": "ดิ่งฟ้าผ่า", "dive": true, "wind_hand": Vector3(0.2, 0.55, 0.1), "end_hand": Vector3(0.45, -0.6, 0.05), "time": 0.42,
		"strike": 0.55, "next": 0.82, "dmg": 15.0, "lean": 30.0, "shake": 0.16, "wide": true, "wide_half": 140.0, "fx": "pc_fd_column", "hit": {"type": "launch", "vy": 8.0}})
	m["pc_fd_lp_column"] = PairCombo._mv(shoot, {"name": "ยิงเสาฟ้าผ่า", "hover": true, "time": 0.38, "next": 0.78, "lean": 18.0, "fx": "pc_fd_column_far"})
	# ---- NEON BOLT ----
	m["pc_nb_az_dash"] = PairCombo._mv(claw, {"name": "พุ่งฟันนีออน", "time": 0.38, "wind": 0.1, "strike": 0.55, "next": 0.78, "dmg": 18.0, "lunge": 3.2, "lean": 26.0,
		"front_hit": true, "ghost": true, "fx": "pc_nb_line", "hit": {"kb": 2.0, "stun": 0.6}})
	m["pc_nb_lp_rail"] = PairCombo._mv(shoot, {"name": "ลำแสงราง", "time": 0.44, "next": 0.82, "lunge": -0.4, "shake": 0.14, "fx": "pc_nb_rail"})
	m["pc_nb_az_cross"] = PairCombo._mv(claw, {"name": "กากบาทนีออน", "time": 0.44, "next": 0.82, "dmg": 0.0, "no_hit": true, "spin": 180.0, "fx": "pc_nb_cross"})
	m["pc_nb_lp_dash"] = PairCombo._mv(slash, {"name": "พุ่งฟันนีออนกลับ", "time": 0.38, "next": 0.78, "dmg": 18.0, "lunge": 3.2, "lean": 24.0, "front_hit": true,
		"ghost": true, "fx": "pc_nb_line", "hit": {"kb": 2.0, "stun": 0.6}})
	m["pc_nb_az_grid"] = PairCombo._mv(claw, {"name": "แท่งนีออนตก", "hover": true, "time": 0.42, "next": 0.82, "dmg": 0.0, "no_hit": true, "fx": "pc_nb_grid"})
	m["pc_nb_lp_rain"] = PairCombo._mv(shoot, {"name": "ฝนนีออน 3 สาย", "hover": true, "wind_hand": Vector3(0.3, 0.5, 0.1), "end_hand": Vector3(0.4, 0.7, 0.1), "time": 0.4, "next": 0.8, "fx": "pc_nb_rain"})

static func cast(page: WalkPage, fx: String) -> bool:
	if not (fx.begins_with("pc_fd_") or fx.begins_with("pc_nb_")):
		return false
	var f := page.hero.facing
	var hp := page.hero.position
	var U := CombatData.UNIT
	var K := SkillScale.K
	match fx:
		"pc_fd_spark":
			fx_node(page, "burst", hp + Vector2(f * 100.0, -110.0), 80.0, 0.3)
			fx_node(page, "bolt", hp + Vector2(f * 90.0, -30.0), 30.0, 0.25, Vector2(f * 20.0, -170.0))
		"pc_fd_chain":
			var from := PairFx._muzzle(page)
			var first := _nearest(page, hp + Vector2(f * 2.0 * U * K, -60.0), 3.0 * U * K, [])
			if first == null:
				fx_node(page, "bolt", from, 30.0, 0.22, Vector2(f * 2.6 * U * K, 0.0))
				return true
			var done := [first]
			_zap(page, from, first, 12.0)
			var nx := _nearest(page, first.position + Vector2(0.0, -WalkPage.MONSTER_MID), 2.4 * U * K, done)
			if nx != null:
				_zap(page, first.position + Vector2(0.0, -WalkPage.MONSTER_MID), nx, 9.0)
		"pc_fd_trail":
			fx_node(page, "bolt", hp + Vector2(-f * 40.0, -70.0), 30.0, 0.3, Vector2(f * 2.4 * U * K, 0.0))
		"pc_fd_ball":
			var b := orb(page, "spark", Vector2(f * 380.0, 0.0), 30.0, 8.0, {"kb": 0.4, "stun": 0.5})
			b.pierce = true
			b.life = 1.6
		"pc_fd_column":
			fx_node(page, "column", Vector2(hp.x + f * 60.0, 0.0), 0.8 * U, 0.4)
		"pc_fd_column_far":
			var at := Vector2(hp.x + f * 2.6 * U * K, 0.0)
			fx_node(page, "column", at, 0.8 * U, 0.4)
			page._hit_area(at.x, 1.0 * U * K, 16.0, f, null, {"type": "launch", "vy": 9.0})
		"pc_nb_line":
			fx_node(page, "line", hp + Vector2(-f * 2.2 * U * K, -70.0), 40.0, 0.35, Vector2(f * 2.6 * U * K, 0.0))
		"pc_nb_rail":
			var from2 := PairFx._muzzle(page)
			var length := 7.0 * U * K
			fx_node(page, "beam", from2, 46.0, 0.4, Vector2(f * length, 0.0))
			page._hit_area(from2.x + f * length * 0.5, length * 0.5, 20.0, f, null, {"kb": 2.4, "stun": 0.6})
		"pc_nb_cross":
			var c := hp + Vector2(f * 1.4 * U * K, -90.0)
			fx_node(page, "cross", c, 1.3 * U, 0.5)
			page._hit_area(c.x, 1.4 * U * K, 22.0, f, null, {"type": "launch", "vy": 11.0})
		"pc_nb_grid":
			for i in 2:
				var k := float(i)
				page.get_tree().create_timer(0.02 + k * 0.16, false).timeout.connect(func() -> void:
					if not is_instance_valid(page) or not is_instance_valid(page.hero):
						return
					var at2 := Vector2(page.hero.position.x + f * (1.1 + k * 1.2) * U * K, 0.0)
					fx_node(page, "bar", at2, 0.7 * U, 0.5)
					page._hit_area(at2.x, 0.8 * U * K, 14.0, f, null, {"type": "launch", "vy": 8.0}))
		"pc_nb_rain":
			for i in 3:
				var k2 := float(i)
				var at3 := Vector2(hp.x + f * (1.0 + k2 * 1.0) * U * K, 0.0)
				fx_node(page, "column", at3, 0.55 * U, 0.35)
				page._hit_area(at3.x, 0.6 * U * K, 10.0, f, null, {"kb": 0.5, "stun": 0.5})
	return true

static func fx_node(page: WalkPage, kind: String, at: Vector2, size: float, life: float, to := Vector2.ZERO) -> PairSkillFx:
	var n := PairSkillFx.new()
	n.kind = kind
	n.base = BASE
	n.accent = ACCENT
	n.size = size * SkillScale.K
	n.life = life
	n.dir = page.hero.facing
	n.to = to
	n.position = at
	page.world.add_child(n)
	return n

static func orb(page: WalkPage, style: String, vel: Vector2, r: float, dmg: float, extra: Dictionary) -> PairSkillFx.PairOrb:
	var b := PairSkillFx.PairOrb.new()
	b.style = style
	b.base = BASE
	b.accent = ACCENT
	b.position = PairFx._muzzle(page)
	b.vel = vel
	b.radius = r
	b.dmg = dmg
	b.pierce = false
	b.life = 0.9
	b.extra = extra
	page.world.add_child(b)
	return b

static func _nearest(page: WalkPage, at: Vector2, within: float, skip: Array) -> Monster:
	var best: Monster = null
	var bd := within
	for e in page.get_tree().get_nodes_in_group("monsters"):
		var mo := e as Monster
		if mo == null or mo.state == "dead" or mo in skip:
			continue
		var d := (mo.position + Vector2(0.0, -WalkPage.MONSTER_MID)).distance_to(at)
		if d < bd:
			bd = d
			best = mo
	return best

static func _zap(page: WalkPage, from: Vector2, mo: Monster, dmg: float) -> void:
	var to := mo.position + Vector2(0.0, -WalkPage.MONSTER_MID)
	fx_node(page, "bolt", from, 30.0, 0.22, to - from)
	page._strike(mo, {"dmg": dmg, "type": "flinch", "stun": 0.45, "kb": 0.4}, signf(to.x - from.x) if to.x != from.x else page.hero.facing)
