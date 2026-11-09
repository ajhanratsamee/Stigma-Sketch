class_name PairLineDream
## คอมโบสาย SPARK DREAMER / SOMNAMBULIST ของ CAT AZURE & LAPIS (ทุกคอมโบมีทั้งท่า AZURE และ LAPIS)
## ชื่อท่าขึ้นต้น pc_dr_ (DREAMER) pc_so_ (SOMNAMBULIST)  เอฟเฟกต์ขึ้นต้น pc_dr_ / pc_so_
## SPARK DREAMER: zzx หมอนเสย / ฟองฝัน   >>zx หมุนเพลงกล่อม / ฟองกล่อม 3 ลูก   ^xz ดิ่งกล่อมหลับ / ปาแกะฝัน
## SOMNAMBULIST: xxz ละเมอต่อยรัว / ยิงกระจาย 3 นัด   >>xz ประตูฝันดูดพ่น   ^zx ทุบหมอนพื้น / คลื่นกรน

const NEXT := {
	"SPARK DREAMER": {
		"pc_az_z2": {"x": "pc_dr_az_pillow"}, "pc_lp_z2": {"x": "pc_dr_lp_bubble"},
		"pc_az_dz": {"x": "pc_dr_az_spin"}, "pc_lp_dz": {"x": "pc_dr_lp_lull"},
		"pc_az_ax": {"z": "pc_dr_az_dive"}, "pc_lp_ax": {"z": "pc_dr_lp_sheep"},
	},
	"SOMNAMBULIST": {
		"pc_az_x2": {"z": "pc_so_az_flurry"}, "pc_lp_x2": {"z": "pc_so_lp_volley"},
		"pc_az_dx": {"z": "pc_so_az_door"}, "pc_lp_turn_shot": {"z": "pc_so_lp_door"},
		"pc_az_az": {"x": "pc_so_az_slam"}, "pc_lp_az": {"x": "pc_so_lp_snore"},
	},
}
const START := {}

const BASE := Color(0.42, 0.5, 0.92)
const ACCENT := Color(1.0, 0.9, 0.55)

static func add_moves(m: Dictionary) -> void:
	var claw: Dictionary = m["pc_az_z1"]
	var shoot: Dictionary = m["pc_lp_x1"]
	# ---- SPARK DREAMER ----
	m["pc_dr_az_pillow"] = PairCombo._mv(claw, {"name": "หมอนเสย", "wind_hand": Vector3(0.3, -0.45, 0.15), "end_hand": Vector3(0.5, 0.65, 0.05), "time": 0.42, "next": 0.7,
		"dmg": 15.0, "lean": -12.0, "shake": 0.12, "fx": "pc_dr_pillow", "hit": {"type": "launch", "vy": 9.0}})
	m["pc_dr_lp_bubble"] = PairCombo._mv(shoot, {"name": "ยิงฟองฝัน", "time": 0.36, "next": 0.7, "fx": "pc_dr_bubble"})
	m["pc_dr_az_spin"] = PairCombo._mv(claw, {"name": "หมุนเพลงกล่อม", "time": 0.44, "next": 0.75, "spin": 360.0, "dmg": 14.0, "wide": true, "wide_half": 160.0,
		"fx": "pc_dr_notes", "hit": {"kb": 0.6, "stun": 0.8}})
	m["pc_dr_lp_lull"] = PairCombo._mv(shoot, {"name": "ฟองกล่อม 3 ลูก", "time": 0.4, "next": 0.75, "fx": "pc_dr_bubble3"})
	m["pc_dr_az_dive"] = PairCombo._mv(claw, {"name": "ดิ่งกล่อมหลับ", "dive": true, "wind_hand": Vector3(0.2, 0.55, 0.1), "end_hand": Vector3(0.45, -0.6, 0.05), "time": 0.42,
		"strike": 0.55, "next": 0.82, "dmg": 14.0, "lean": 30.0, "shake": 0.14, "wide": true, "wide_half": 150.0, "fx": "pc_dr_land",
		"hit": {"type": "flinch", "stun": 1.2, "real_stun": true, "kb": 0.3}})
	m["pc_dr_lp_sheep"] = PairCombo._mv(shoot, {"name": "ปาแกะฝัน", "hover": true, "wind_hand": Vector3(-0.1, 0.4, 0.1), "end_hand": Vector3(0.6, 0.1, 0.1), "time": 0.38, "next": 0.8, "fx": "pc_dr_sheep"})
	# ---- SOMNAMBULIST ----
	m["pc_so_az_flurry"] = PairCombo._mv(claw, {"name": "ละเมอต่อยรัว", "wind_hand": Vector3(0.15, -0.02, 0.15), "end_hand": Vector3(0.85, -0.02, 0.05), "time": 0.6, "wind": 0.1,
		"strike": 0.8, "next": 0.9, "dmg": 5.0, "lunge": 0.8, "multi": 0.08, "multi_ahead": 90.0, "multi_half": 100.0, "front_hit": true, "fx": "pc_so_zzz",
		"hit": {"kb": 0.5, "stun": 0.4}, "auto": "pc_so_az_finish"})
	m["pc_so_az_finish"] = PairCombo._mv(claw, {"name": "ละเมอหมัดปิด", "wind_hand": Vector3(0.15, -0.02, 0.15), "end_hand": Vector3(0.9, 0.0, 0.05), "time": 0.36, "next": 0.75,
		"dmg": 18.0, "lunge": 0.5, "shake": 0.16, "fx": "pc_punch", "hit": {"type": "knockdown", "fly": 5.0}})
	m["pc_so_lp_volley"] = PairCombo._mv(shoot, {"name": "ยิงละเมอกระจาย", "time": 0.4, "next": 0.75, "shake": 0.08, "fx": "pc_so_volley"})
	var door := PairCombo._mv(shoot, {"name": "เปิดประตูฝัน", "time": 0.44, "next": 0.95, "lunge": -0.1, "fx": "pc_so_door"})
	m["pc_so_az_door"] = door
	m["pc_so_lp_door"] = door.duplicate(true)
	m["pc_so_az_slam"] = PairCombo._mv(claw, {"name": "ทุบหมอนพื้น", "wind_hand": Vector3(0.2, 0.7, 0.1), "end_hand": Vector3(0.6, -0.6, 0.05), "time": 0.46, "next": 0.8,
		"dmg": 16.0, "lean": 30.0, "shake": 0.2, "wide": true, "wide_half": 180.0, "fx": "pc_so_slam", "hit": {"type": "knockdown", "fly": 4.0}})
	m["pc_so_lp_snore"] = PairCombo._mv(shoot, {"name": "คลื่นกรน", "time": 0.42, "next": 0.8, "lunge": -0.1, "fx": "pc_so_snore"})

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(page: WalkPage, fx: String) -> bool:
	if not (fx.begins_with("pc_dr_") or fx.begins_with("pc_so_")):
		return false
	var f := page.hero.facing
	var hp := page.hero.position
	var U := CombatData.UNIT
	match fx:
		"pc_dr_pillow":
			fx_node(page, "pillow", hp + Vector2(f * 110.0, 0.0), 90.0, 0.5)
		"pc_dr_bubble":
			orb(page, "bubble", Vector2(f * 900.0, 0.0), 30.0, 12.0, {"type": "flinch", "stun": 1.0, "real_stun": true, "kb": 0.2})
		"pc_dr_notes":
			fx_node(page, "notes", hp + Vector2(0.0, -80.0), 150.0, 0.5, page.hero)
		"pc_dr_bubble3":
			for a in [-0.25, 0.0, 0.25]:
				orb(page, "bubble", Vector2(f * 850.0, a * 850.0), 24.0, 9.0, {"type": "flinch", "stun": 0.8, "real_stun": true, "kb": 0.2})
		"pc_dr_land":
			fx_node(page, "ring", Vector2(hp.x, 0.0), 1.6 * U, 0.45)
			fx_node(page, "zzz", hp + Vector2(0.0, -120.0), 120.0, 0.8)
		"pc_dr_sheep":
			var b := orb(page, "sheep", Vector2(f * 380.0, -120.0), 34.0, 16.0, {"type": "flinch", "stun": 1.4, "real_stun": true, "kb": 0.3})
			b.gravity = 1600.0
			b.bounce = 2
			b.pierce = true
			b.life = 1.6
		"pc_so_zzz":
			fx_node(page, "zzz", hp + Vector2(0.0, -120.0), 140.0, 0.7, page.hero)
		"pc_so_volley":
			for a in [-0.18, 0.0, 0.18]:
				orb(page, "neon", Vector2(f * 1300.0, a * 1300.0), 18.0, 9.0, {"kb": 0.6, "stun": 0.45})
		"pc_so_door":
			var at := hp + Vector2(f * 1.8 * U * SkillScale.K, -90.0)
			fx_node(page, "door", at, 0.9 * U, 1.0)
			var tree := page.get_tree()
			for e in tree.get_nodes_in_group("monsters"):
				var mo := e as Monster
				if mo != null and absf(mo.position.x - at.x) < 2.6 * U and mo.state != "dead" and mo.role != "boss" and mo.role != "boss_raid":
					mo.pos.x = lerpf(mo.pos.x, at.x / U, 0.6)
			tree.create_timer(0.55, false).timeout.connect(func() -> void:
				if is_instance_valid(page) and is_instance_valid(page.hero):
					fx_node(page, "burst", at, 1.0 * U, 0.4)
					page._hit_area(at.x, 1.4 * U * SkillScale.K, 18.0, f, null, {"type": "launch", "vy": 11.0}))
		"pc_so_slam":
			fx_node(page, "pillow", hp + Vector2(f * 120.0, 0.0), 110.0, 0.55)
			fx_node(page, "ring", Vector2(hp.x + f * 120.0, 0.0), 2.0 * U, 0.45)
		"pc_so_snore":
			for i in 2:
				var k := float(i)
				page.get_tree().create_timer(0.02 + k * 0.22, false).timeout.connect(func() -> void:
					if not is_instance_valid(page) or not is_instance_valid(page.hero):
						return
					var c := page.hero.position
					fx_node(page, "ring", c, (2.4 + k * 0.6) * U, 0.4)
					page._hit_area(c.x, (2.4 + k * 0.6) * U * SkillScale.K, 10.0, f, null, {"kb": 2.5, "stun": 0.5}))
	return true

## ภาพของสาย (สีสายฝัน)
static func fx_node(page: WalkPage, kind: String, at: Vector2, size: float, life: float, follow: Node2D = null) -> PairSkillFx:
	var n := PairSkillFx.new()
	n.kind = kind
	n.base = BASE
	n.accent = ACCENT
	n.size = size * SkillScale.K
	n.life = life
	n.dir = page.hero.facing
	n.position = at
	if follow != null:
		n.follow = follow
		n.offset = at - follow.position
	page.world.add_child(n)
	return n

## ลูกพลังจากปากกระบอกปืน/มือ
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
