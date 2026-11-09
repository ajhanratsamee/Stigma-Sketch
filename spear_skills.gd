class_name SpearSkills
extends SusiSkills
## สกิลของ CAT CITRUS (หอก) สาย BASIC  id ขึ้นต้น sp_sk_
## ต่อยอดจาก SusiSkills ใช้ระบบชิ้นสกิล คูลดาวน์ UI คูลดาวน์บนช่องสกิลร่วมกัน (แบบเดียวกับ BowSkills)
## สาย: tg_ PETIT TIGER  fp_ FIERCE PROWLER  fg_ PETIT FANG  ld_ LUPINE DIRE
##       vx_ PETIT VIXEN  pv_ PHANTOM VULPINE  sh_ PETIT SHELL  gb_ GENBU TITAN

## cd คูลดาวน์  air ใช้กลางอากาศได้  hold กดค้าง  charge กดค้างชาร์จแล้วปล่อย
const SPEAR_DEFS := {
	"sp_sk_orb": {"cd": 2.5, "air": true},
	"sp_sk_quake": {"cd": 14.0},
	"sp_sk_pierce": {"cd": 8.0},
	"sp_sk_rapid": {"cd": 7.0},
	"sp_sk_ring": {"cd": 20.0},
	"sp_sk_shoulder": {"cd": 5.0},
	"sp_sk_tg_pounce": {"cd": 6.0},
	"sp_sk_tg_claw": {"cd": 7.0},
	"sp_sk_tg_roar": {"cd": 25.0},
	"sp_sk_tg_stripes": {"cd": 10.0},
	"sp_sk_tg_charge": {"cd": 9.0, "charge": true},
	"sp_sk_tg_sky": {"cd": 5.0, "air": true},
	"sp_sk_tg_tumble": {"cd": 8.0},
	"sp_sk_fp_chain": {"cd": 12.0},
	"sp_sk_fp_lunge": {"cd": 8.0},
	"sp_sk_fp_roar": {"cd": 30.0},
	"sp_sk_fp_whirl": {"cd": 10.0, "hold": true},
	"sp_sk_fp_storm": {"cd": 14.0},
	"sp_sk_fp_king": {"cd": 18.0},
	"sp_sk_fg_ball": {"cd": 4.0, "air": true},
	"sp_sk_fg_howl": {"cd": 30.0},
	"sp_sk_fg_bite": {"cd": 8.0},
	"sp_sk_fg_pup": {"cd": 20.0},
	"sp_sk_fg_fan": {"cd": 7.0},
	"sp_sk_fg_pull": {"cd": 12.0},
	"sp_sk_fg_leap": {"cd": 7.0, "air": true},
	"sp_sk_ld_pack": {"cd": 30.0},
	"sp_sk_ld_crescent": {"cd": 9.0},
	"sp_sk_ld_eclipse": {"cd": 25.0},
	"sp_sk_ld_barrage": {"cd": 10.0, "hold": true},
	"sp_sk_ld_swap": {"cd": 6.0, "air": true},
	"sp_sk_ld_maw": {"cd": 20.0},
	"sp_sk_vx_scratch": {"cd": 4.0, "air": true},
	"sp_sk_vx_fire": {"cd": 18.0},
	"sp_sk_vx_blink": {"cd": 4.0, "air": true},
	"sp_sk_vx_pin": {"cd": 6.0},
	"sp_sk_vx_clone": {"cd": 20.0},
	"sp_sk_vx_trap": {"cd": 12.0},
	"sp_sk_vx_tail": {"cd": 8.0},
	"sp_sk_pv_rush": {"cd": 10.0},
	"sp_sk_pv_pins": {"cd": 9.0},
	"sp_sk_pv_nova": {"cd": 14.0, "charge": true},
	"sp_sk_pv_lift": {"cd": 8.0, "air": true},
	"sp_sk_pv_mirage": {"cd": 22.0},
	"sp_sk_pv_beam": {"cd": 16.0},
	"sp_sk_sh_talis": {"cd": 4.0, "air": true},
	"sp_sk_sh_guard": {"cd": 10.0},
	"sp_sk_sh_stomp": {"cd": 6.0},
	"sp_sk_sh_snake": {"cd": 9.0},
	"sp_sk_sh_ward": {"cd": 30.0},
	"sp_sk_sh_seal": {"cd": 12.0},
	"sp_sk_sh_rock": {"cd": 8.0},
	"sp_sk_gb_dome": {"cd": 35.0},
	"sp_sk_gb_serpent": {"cd": 10.0},
	"sp_sk_gb_storm": {"cd": 12.0},
	"sp_sk_gb_drop": {"cd": 10.0, "air": true},
	"sp_sk_gb_seals": {"cd": 15.0},
	"sp_sk_gb_quake": {"cd": 20.0},
}
const SPEAR_MP := {
	"sp_sk_orb": 30.0,
	"sp_sk_quake": 300.0,
	"sp_sk_pierce": 150.0,
	"sp_sk_rapid": 120.0,
	"sp_sk_ring": 300.0,
	"sp_sk_shoulder": 40.0,
	"sp_sk_tg_pounce": 60.0,
	"sp_sk_tg_claw": 70.0,
	"sp_sk_tg_roar": 100.0,
	"sp_sk_tg_stripes": 90.0,
	"sp_sk_tg_charge": 120.0,
	"sp_sk_tg_sky": 50.0,
	"sp_sk_tg_tumble": 110.0,
	"sp_sk_fp_chain": 160.0,
	"sp_sk_fp_lunge": 130.0,
	"sp_sk_fp_roar": 200.0,
	"sp_sk_fp_whirl": 80.0,
	"sp_sk_fp_storm": 180.0,
	"sp_sk_fp_king": 260.0,
	"sp_sk_fg_ball": 50.0,
	"sp_sk_fg_howl": 90.0,
	"sp_sk_fg_bite": 70.0,
	"sp_sk_fg_pup": 120.0,
	"sp_sk_fg_fan": 100.0,
	"sp_sk_fg_pull": 110.0,
	"sp_sk_fg_leap": 90.0,
	"sp_sk_ld_pack": 220.0,
	"sp_sk_ld_crescent": 140.0,
	"sp_sk_ld_eclipse": 250.0,
	"sp_sk_ld_barrage": 60.0,
	"sp_sk_ld_swap": 80.0,
	"sp_sk_ld_maw": 300.0,
	"sp_sk_vx_scratch": 50.0,
	"sp_sk_vx_fire": 100.0,
	"sp_sk_vx_blink": 40.0,
	"sp_sk_vx_pin": 70.0,
	"sp_sk_vx_clone": 130.0,
	"sp_sk_vx_trap": 90.0,
	"sp_sk_vx_tail": 110.0,
	"sp_sk_pv_rush": 160.0,
	"sp_sk_pv_pins": 140.0,
	"sp_sk_pv_nova": 200.0,
	"sp_sk_pv_lift": 120.0,
	"sp_sk_pv_mirage": 220.0,
	"sp_sk_pv_beam": 280.0,
	"sp_sk_sh_talis": 50.0,
	"sp_sk_sh_guard": 60.0,
	"sp_sk_sh_stomp": 70.0,
	"sp_sk_sh_snake": 100.0,
	"sp_sk_sh_ward": 120.0,
	"sp_sk_sh_seal": 90.0,
	"sp_sk_sh_rock": 110.0,
	"sp_sk_gb_dome": 250.0,
	"sp_sk_gb_serpent": 150.0,
	"sp_sk_gb_storm": 180.0,
	"sp_sk_gb_drop": 160.0,
	"sp_sk_gb_seals": 200.0,
	"sp_sk_gb_quake": 300.0,
}
const DODGE_CD := 8.0           # 10.1 โดนตีแล้วถอยกระโดดหนีเอง
const RING_TIME := 4.0          # 20.1 วงหอกหมุนรอบตัว
const RING_R := 2.6             # รัศมีวงหอก หน่วยเกม
const RING_TICK := 0.3
const RING_DMG := 11.0
const ROAR_TIME := 15.0         # tg 15.5 บัพพลังโจมตี +25%
const HOWL_TIME := 20.0         # fg 15.3 บัพหอนจันทร์
const WARD_TIME := 8.0          # sh 30.1 ติด SA
const DOME_TIME := 6.0          # gb 35.2 กระดองเต่าดำ
const CRIT_CHANCE := 0.2        # tg 15.4
const REVIVE_CD := 120.0        # ld 60.2
const VEIL_CD := 6.0            # pv 35.4
const REFLECT_CD := 3.0         # gb 60.2
const ORANGE := Color(1.0, 0.55, 0.15)
const INK := Color(0.12, 0.08, 0.1)

var dodge_cd := 0.0
var _act_tw: Tween
var _quake := false             # 1.5 รอตกถึงพื้นแล้วฟาด
var _quake_t := 0.0
var _ring_t := 0.0
var _ring_tick := 0.0
var _ring_fx: Node2D
var _charge := {}               # สกิลกดค้างชาร์จ {t max fn fx}
var revive_cd := 0.0
var veil_cd := 0.0
var reflect_cd := 0.0
var veil_chance := 0.3          # pv 35.4 โอกาสวาปหนี (เทสต์ตั้งเป็น 1 ได้)
var _blood_ms := 0
var crits := 0                  # นับไว้ใช้ในเทสต์
var pups := 0
var countered := 0
var reflects := 0
var veils := 0

# ---------------------------------------------------------------- ข้อมูล
func cost(id: String) -> float:
	return Stats.skill_mp("spear", id)

func cooldown(id: String) -> float:
	var cd := float(SPEAR_DEFS.get(id, {}).get("cd", 3.0))
	# PHANTOM 60.2 คูลดาวน์ลดลง 15%
	if has("sp_sk_pv_ghost"):
		cd *= 0.85
	return cd

func _held() -> bool:
	return page.test_hold or super._held()

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	var d: Dictionary = SPEAR_DEFS.get(id, {})
	if d.is_empty():
		return
	if page.combo_nth >= 0 or hero.hurt_t > 0.0 or _quake:
		return
	if not _channel.is_empty() or not _charge.is_empty():
		return
	if not d.get("air", false) and not hero.on_floor():
		return
	if cd_left(id) > 0.0:
		page.bars.notice("รออีก %.1f วิ" % cd_left(id))
		return
	var c := cost(id)
	if hero.mp < c:
		page.bars.notice("มานาไม่พอ (%d)" % int(c))
		return
	hero.mp -= c
	cds[id] = cooldown(id)
	_cur_id = id
	BigSkillFx.cast(page, id, c)
	if c >= 250.0:
		page.time_stop(0.45)
	call("_do_" + id.trim_prefix("sp_sk_"))

# ---------------------------------------------------------------- ตัวช่วย
## ท่าจากตารางคอมโบหอก ใช้แค่ภาพ ไม่ทำดาเมจเอง
func _act(move_id: String, time := 0.4, over := {}) -> void:
	var m: Dictionary = SpearCombo.move(move_id).duplicate(true)
	for k in ["auto", "fx", "fx_start", "dive", "dive_forward", "leap", "hover", "turn_around", "drag", "front_hit", "multi", "wide", "sa"]:
		m.erase(k)
	m.merge(over, true)
	hero.plain_move = m
	hero.plain_swing_kind = "combo"
	hero.plain_combo_id += 1
	hero.plain_swing = 0.001
	if _act_tw != null and _act_tw.is_valid():
		_act_tw.kill()
	_act_tw = page.create_tween()
	_act_tw.tween_property(hero, "plain_swing", 1.0, time)
	_act_tw.tween_callback(func() -> void: hero.plain_swing = 0.0)

## รอยหอกส้มของ CITRUS
func _trail(kind: String) -> void:
	SpearFx.cast(page, "sp_" + kind)
	_shrink_last()

## โดนมอนด้านหน้าในวงรี ห่างตัว ahead หน่วย กว้างครึ่ง half หน่วย
func _front(ahead: float, half: float, dmg: float, eff: String, tall := 1.5) -> Array:
	var list := _in_ellipse(hero.position + Vector2(_f() * ahead * U, -60.0), half * U, tall * U)
	for m in list:
		_hit(m, dmg, eff, _f())
	return list

func _hop(k := 0.6) -> void:
	hero.vel.y = Hero.JUMP_VELOCITY * k

# ---------------------------------------------------------------- BASIC
## 1.1 ปล่อยพลังกลมเล็กๆ ไปด้านหน้า ชะงัก
func _do_orb() -> void:
	_act("sp_z1", 0.3)
	_later(0.1, func() -> void:
		# ลูกพลังกลมเหลืองขอบดำ เห็นชัด
		var orb := SpearOrb.new()
		orb.vel = Vector2(_f() * 1100.0, 0.0)
		orb.radius = 0.5 * U * SkillScale.K
		orb.dmg = 14.0
		orb.pierce = false
		orb.life = 1.0
		orb.extra = {"type": "flinch", "stun": 0.6, "kb": 0.5}
		orb.position = hero.position + Vector2(_f() * 70.0, -80.0)
		page.world.add_child(orb))

## 1.5 กระโดดขึ้นฟ้าแล้วฟาดหอกลงพื้น พื้นแตกกระจาย
func _do_quake() -> void:
	_hop(0.95)
	_act("sp_ax", 0.4)
	_quake = true
	_quake_t = 0.0

func _land_quake() -> void:
	_quake = false
	_act("sp_az", 0.4)
	_trail("ground")
	var at := hero.position + Vector2(_f() * 1.2 * U, 0.0)
	_boom(at + Vector2(0.0, -50.0), 3.4 * U, 1.8 * U, 70.0, "launch", "fire")
	# เศษพื้นแตก ทั้งเม็ดเล็กละเอียดและก้อนใหญ่ กระเด็นออกรอบจุดฟาด
	for i in 14:
		var big := i % 4 == 0
		var p := at + Vector2(randf_range(-3.0, 3.0) * U, randf_range(-1.2, -0.1) * U)
		_fx("poof", "fire" if i % 3 != 0 else "silver", p, 34.0 if big else 14.0, 0.5 + randf() * 0.3)
	page.shake_left = maxf(page.shake_left, 0.3)

## 5.1 แทงหอกดำส้มไปด้านหน้าอย่างแรง แล้วดึงกลับ ดึงมอนเข้ามา
func _do_pierce() -> void:
	_act("sp_z1", 0.32, {"lunge": 0.4})
	_trail("thrust")
	_later(0.12, func() -> void:
		_fx("flare", "fire", hero.position + Vector2(_f() * 2.2 * U, -70.0), 1.2 * U, 0.35)
		_front(1.6, 1.9, 34.0, "strong", 1.2))
	_later(0.4, func() -> void:
		_act("sp_z2", 0.3)
		var hit := _front(1.8, 2.2, 18.0, "light", 1.3)
		for m in hit:
			if ROLES_HEAVY(m):
				continue
			var to := hero.pos.x + _f() * 1.1
			m.pos.x = clampf(lerpf(m.pos.x, to, 0.7), -m.half_width, m.half_width))

## 15.1 แทงหอกรัว 10 ฮิต ฮิตสุดท้ายมอนกระเด็น
func _do_rapid() -> void:
	_act("sp_dz", 0.9)
	_trail("rapid")
	for i in 10:
		var last := i == 9
		_later(0.07 + float(i) * 0.08, func() -> void:
			_front(1.3, 1.5, 22.0 if last else 7.0, "knock" if last else "light", 1.2))

## 20.1 ปาหอกไปด้านหน้า แล้วหอกหมุนรอบตัว เป็นวงหอกสีดำ
func _do_ring() -> void:
	_act("sp_x1", 0.4)
	_proj("arcane", "fire", hero.position + Vector2(_f() * 60.0, -80.0), Vector2(_f() * 900.0, 0.0), 0.4 * U, 16.0, "flinch", {"life": 0.3, "hits": 3})
	_later(0.3, func() -> void:
		_ring_t = RING_TIME
		_ring_tick = 0.0
		if is_instance_valid(_ring_fx):
			_ring_fx.queue_free()
		var n := SpearRing.new()
		n.radius = RING_R * U * SkillScale.K
		n.life = RING_TIME
		page.world.add_child(n)
		_ring_fx = n)

## 20.2 พุ่งไปด้านหน้าเอาไหล่ชน สตั๊น ติด SA
func _do_shoulder() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.6)
	_act("sp_z1", 0.32, {"lean": 30.0})
	_trail("thrust")
	_add({"type": "slide", "life": 0.28, "speed": 16.0, "dmg": 16.0, "eff": "stun", "node": null, "once_each": true})

# ---------------------------------------------------------------- ตัวช่วยสาย
## สีหลักกับสีแซมของแต่ละสาย (เสือส้มขาว หมาป่าดำส้ม จิ้งจอกฟ้าขาว เต่าเขียวทอง)
const LINE_COL := {
	"tiger": [Color(1.0, 0.58, 0.18), Color(1.0, 0.97, 0.9)],
	"fang": [Color(0.14, 0.09, 0.11), Color(1.0, 0.55, 0.15)],
	"vixen": [Color(0.62, 0.84, 1.0), Color(1.0, 1.0, 1.0)],
	"shell": [Color(0.42, 0.78, 0.45), Color(1.0, 0.84, 0.35)],
}
const SNAKE_COL := Color(0.35, 0.72, 0.85)
const MY_OBJS := ["land", "zone", "mover", "pup", "clone", "trap", "wave", "dome", "guard"]

func _line_of(id: String) -> String:
	var p := id.trim_prefix("sp_sk_").get_slice("_", 0)
	if p in ["fg", "ld"]:
		return "fang"
	if p in ["vx", "pv"]:
		return "vixen"
	if p in ["sh", "gb"]:
		return "shell"
	return "tiger"

func _sfx(kind: String, at: Vector2, size: float, life := 0.6, follow: Node2D = null, line := "") -> SpearSkillFx:
	var cols: Array = LINE_COL[line if line != "" else _line_of(_cur_id)]
	var n := SpearSkillFx.new()
	n.kind = kind
	n.base = cols[0]
	n.accent = cols[1]
	n.size = size * SkillScale.K
	n.life = life
	n.dir = _f()
	n.position = at
	if follow != null:
		n.follow = follow
		n.offset = at - follow.position
	page.world.add_child(n)
	return n

func _side(m: Monster) -> float:
	return signf(_mc(m).x - hero.position.x) if _mc(m).x != hero.position.x else _f()

## วาปไปตำแหน่ง x (หน่วยเกม) มีควันจิ้งจอกทั้งต้นทางและปลายทาง
func _warp(x: float) -> void:
	var from := hero.position
	hero.pos.x = clampf(x, -hero.half_width, hero.half_width)
	hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
	SpearLineVixen._fx(page, "poof", from + Vector2(0.0, -70.0), 0.4)
	SpearLineVixen._fx(page, "poof", hero.position + Vector2(0.0, -70.0), 0.4)

## รอตกถึงพื้นแล้วทำ fn (ระหว่างรอดิ่งลงเร็ว)
func _land(wait: float, fn: Callable) -> void:
	_add({"type": "land", "life": 2.5, "wait": wait, "fn": fn})

## เขตบนพื้น ทำดาเมจทุก tick  o: pull ดูด root ตรึง slow ช้า weak อ่อนแรง
func _zone(at: Vector2, half: float, life: float, dmg: float, eff: String, tick: float, node: Node2D, o := {}) -> Dictionary:
	var d := {"type": "zone", "pos": at, "half": half * SkillScale.K, "life": life, "dmg": dmg, "eff": eff, "tick": tick, "node": node}
	d.merge(o, true)
	return _add(d)

## ชิ้นที่บินไปเอง โดนตัวละครั้ง (หรือทุก tick)
func _mover(node: Node2D, at: Vector2, vel: Vector2, r: float, life: float, dmg: float, eff: String, o := {}) -> Dictionary:
	node.position = at
	var d := {"type": "mover", "node": node, "pos": at, "vel": vel, "r": r, "life": life, "dmg": dmg, "eff": eff}
	d.merge(o, true)
	return _add(d)

## เอฟเฟกต์ท่าหอก (ใช้ร่วมกับคอมโบ) ตอนใช้ในสกิล ย่อตามขนาดสกิล
func _tcast(fx: String) -> void:
	SpearTigerFx.cast(page, fx)
	_shrink_last()

func _shrink_last() -> void:
	var n := page.world.get_child(page.world.get_child_count() - 1) as Node2D
	if n != null:
		n.scale *= SkillScale.K

## บอลหน้าแมวหมาป่า
func _wolf(dir: Vector2, speed: float, r: float, dmg: float, pierce: bool, life := 1.2, extra := {}) -> WolfBall:
	var b := WolfBall.new()
	b.position = hero.position + Vector2(_f() * 90.0, -85.0)
	b.vel = dir.normalized() * speed
	b.radius = r * SkillScale.K
	b.dmg = dmg
	b.pierce = pierce
	b.life = life
	b.extra = extra
	page.world.add_child(b)
	return b

## ยันต์กระดาษ
func _talis(at: Vector2, vel: Vector2, dmg: float, pierce: bool, life := 1.0) -> void:
	var t := Talisman.new()
	t.position = at
	t.vel = vel
	t.radius = 0.4 * U * SkillScale.K
	t.dmg = dmg
	t.pierce = pierce
	t.life = life
	t.extra = {} if pierce else {"kb": 0.8, "stun": 0.7}
	page.world.add_child(t)

## ลูกหมาป่าเงา ลอยตามตัว ไล่กัดมอนใกล้ๆ
func _pup(life: float, off: float, dmg := 12.0) -> void:
	var b := WolfBall.new()
	b.radius = 0.42 * U * SkillScale.K
	b.dmg = dmg
	b.pierce = true
	b.life = life + 2.0
	b.extra = {"kb": 0.4, "stun": 0.4}
	b.position = hero.position + Vector2(-_f() * off * U, -120.0)
	page.world.add_child(b)
	pups += 1
	_add({"type": "pup", "node": b, "life": life, "off": off * U, "bite": 0.5})

## ร่างเงาจิ้งจอก ข่วนมอนใกล้ๆ เอง จบแล้วระเบิดได้
func _clone(at: Vector2, life: float, dmg: float, end_boom := 0.0, line := "") -> void:
	var n := _sfx("clone", at, 1.0, life + 0.1, null, line)
	_add({"type": "clone", "node": n, "pos": at, "life": life, "dmg": dmg, "every": 0.55, "t": 0.15, "end_boom": end_boom})

## กับดักบนพื้น มอนเหยียบแล้วทำ fn(ตำแหน่ง)
func _trap(at: Vector2, r: float, life: float, fn: Callable) -> void:
	var n := _sfx("sigil", at, r, life + 0.1)
	_add({"type": "trap", "node": n, "pos": at, "r": r, "life": life, "fn": fn})

## กดค้างชาร์จ ปล่อยแล้วเรียก fn(k) k คือความเต็ม 0 ถึง 1
func _start_charge(max_t: float, fn: Callable) -> void:
	_charge = {"t": 0.0, "max": max_t, "fn": fn, "fx": _sfx("aura", hero.position, 70.0, max_t + 1.0, hero)}

func _tick_charge(delta: float) -> void:
	if _charge.is_empty():
		return
	_charge["t"] = float(_charge["t"]) + delta
	hero.plain_swing = clampf(hero.plain_swing, 0.001, 0.5)
	var t := float(_charge["t"])
	if (not _held() and t > 0.12) or t >= float(_charge["max"]) or hero.hurt_t > 0.0:
		var k := clampf(t / float(_charge["max"]), 0.0, 1.0)
		var fn: Callable = _charge["fn"]
		if is_instance_valid(_charge.get("fx")):
			(_charge["fx"] as Node).queue_free()
		_charge = {}
		hero.plain_swing = 0.0
		fn.call(k)

func _tick_obj(o: Dictionary, delta: float) -> void:
	var t := str(o.get("type", ""))
	if t in MY_OBJS:
		o["age"] = float(o["age"]) + delta
		o["life"] = float(o["life"]) - delta
		_tick_spear_obj(o, delta, t)
		return
	super._tick_obj(o, delta)

func _tick_spear_obj(o: Dictionary, delta: float, t: String) -> void:
	match t:
		"land":
			if float(o["age"]) >= float(o["wait"]) and (hero.on_floor() or float(o["life"]) <= 0.0):
				_objs.erase(o)
				(o["fn"] as Callable).call()
			elif float(o["age"]) > float(o["wait"]) + 0.1 and not hero.on_floor():
				hero.vel.y = minf(hero.vel.y, -Hero.CHIBI_DIVE_SPEED * 0.8)
		"zone":
			var at: Vector2 = o["pos"]
			var half := float(o["half"])
			if o.has("pull"):
				for m in _mons():
					if absf(_mc(m).x - at.x) <= half + float(o["pull"]) and not ROLES_HEAVY(m):
						m.pos.x = move_toward(m.pos.x, at.x / U, 3.5 * delta)
			_ticks(o, delta, func() -> Array:
				var list := _in_ellipse(at + Vector2(0.0, -50.0), half, 1.3 * U)
				for m in list:
					if o.get("root", false):
						m.root_t = maxf(m.root_t, 0.6)
					if o.get("slow", false):
						m.slow_t = maxf(m.slow_t, 0.6)
					if o.get("weak", false):
						m.weak_t = maxf(m.weak_t, 2.0)
				return list)
			if float(o["life"]) <= 0.0:
				_end(o)
		"mover":
			var p: Vector2 = (o["pos"] as Vector2) + (o["vel"] as Vector2) * delta
			o["pos"] = p
			if is_instance_valid(o["node"]):
				(o["node"] as Node2D).position = p
			_ticks(o, delta, func() -> Array: return _in_circle(p, float(o["r"])))
			if float(o["life"]) <= 0.0:
				if o.has("end_boom"):
					_boom(p, float(o["end_boom"]), float(o["end_boom"]) * 0.55, float(o.get("end_dmg", 30.0)), "knock", str(o.get("el", "dark")))
				_end(o)
		"pup":
			if not is_instance_valid(o["node"]):
				_objs.erase(o)
				return
			var b: WolfBall = o["node"]
			o["bite"] = float(o["bite"]) - delta
			if float(o["bite"]) <= 0.0:
				o["bite"] = 0.5
				b._hit.clear()
			var goal := hero.position + Vector2(-_f() * float(o["off"]), -130.0 + sin(float(o["age"]) * 4.0) * 12.0)
			var tgt := _nearest(b.position, 7.0 * U)
			if tgt != null:
				goal = _mc(tgt)
			b.vel = ((goal - b.position) * 5.0).limit_length(950.0)
			if b.position.y > -45.0:
				b.vel.y = minf(b.vel.y, -60.0)
			if float(o["life"]) <= 0.0:
				_objs.erase(o)
				b._burst()
		"clone":
			var at: Vector2 = o["pos"]
			o["t"] = float(o["t"]) - delta
			if float(o["t"]) <= 0.0 and float(o["dmg"]) > 0.0:
				o["t"] = float(o["every"])
				var tgt := _nearest(at + Vector2(0.0, -60.0), 3.0 * U)
				if tgt != null:
					SpearLineVixen._claw(page, _mc(tgt), -PI * 0.5 + randf_range(-0.6, 0.6), 160.0, 4, float(o["dmg"]), {"stun": 0.5, "kb": 0.6}, 110.0)
			if float(o["life"]) <= 0.0:
				if float(o["end_boom"]) > 0.0:
					_boom(at + Vector2(0.0, -70.0), 1.8 * U, 1.2 * U, float(o["end_boom"]), "knock", "ice")
				_end(o)
		"trap":
			var at: Vector2 = o["pos"]
			var hit := _in_ellipse(at + Vector2(0.0, -40.0), float(o["r"]), 1.0 * U)
			if not hit.is_empty() or float(o["life"]) <= 0.0:
				_end(o)
				if not hit.is_empty():
					(o["fn"] as Callable).call(at)
		"wave":
			o["t"] = float(o["t"]) - delta
			if float(o["t"]) <= 0.0 and int(o["n"]) > 0:
				o["t"] = float(o["every"])
				o["n"] = int(o["n"]) - 1
				var at: Vector2 = o["pos"]
				_boom(at + Vector2(0.0, -50.0), 1.5 * U, 1.3 * U, float(o["dmg"]), str(o["eff"]), "leaf")
				_sfx("rock", at, 1.4 * U, 0.55, null, "shell")
				o["pos"] = at + Vector2(float(o["face"]) * float(o["step"]), 0.0)
			if int(o["n"]) <= 0:
				_objs.erase(o)
		"dome":
			_ticks(o, delta, func() -> Array: return _in_circle(hero.position + Vector2(0.0, -60.0), float(o["r"])))
			if float(o["life"]) <= 0.0:
				_end(o)
		"guard":
			hero.plain_swing = maxf(hero.plain_swing, 0.3)
			var near := _in_ellipse(hero.position + Vector2(_f() * 0.9 * U, -60.0), 1.3 * U, 1.4 * U)
			if not near.is_empty():
				_end(o)
				buffs.erase("guard_all")
				_shell_counter()
			elif float(o["life"]) <= 0.0:
				_end(o)

# ---------------------------------------------------------------- PETIT TIGER
## 15.2 กระโดดตะครุบไปด้านหน้า ลงพื้นกระแทก มอนลอย
func _do_tg_pounce() -> void:
	_hop(0.7)
	_act("sp_adz1", 0.4)
	_trail("up")
	_add({"type": "slide", "life": 0.35, "speed": 11.0, "node": null})
	_land(0.15, func() -> void:
		_tcast("spt_impact")
		_sfx("ring", hero.position + Vector2(_f() * 0.6 * U, -10.0), 1.6 * U, 0.5)
		_boom(hero.position + Vector2(_f() * 0.6 * U, -40.0), 2.4 * U, 1.3 * U, 45.0, "launch", "fire"))

## 15.3 พุ่งข่วนรัว 6 ฮิต ติด SA ฮิตสุดท้ายกระเด็น
func _do_tg_claw() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.7)
	_act("sp_dz", 0.6)
	_tcast("spt_rush")
	_add({"type": "slide", "life": 0.62, "speed": 6.0, "dmg": 10.0, "eff": "light", "last": "strong", "beats": [0.05, 0.15, 0.25, 0.35, 0.45, 0.55], "node": null})
	for i in 3:
		_later(0.06 + float(i) * 0.18, func() -> void:
			_sfx("claw", hero.position + Vector2(_f() * 1.1 * U, -80.0), 150.0, 0.3))

## 15.5 คำรามผลักมอนรอบตัว บัพพลังโจมตี
func _do_tg_roar() -> void:
	_act("sp_x1", 0.5)
	_sfx("ring", hero.position + Vector2(0.0, -80.0), 2.2 * U, 0.7)
	for m in _in_circle(hero.position + Vector2(0.0, -60.0), 2.2 * U):
		_push(m, hero.position.x, 7.0)
	buffs["roar"] = ROAR_TIME
	_sfx("aura", hero.position, 90.0, ROAR_TIME, hero)
	page.bars.notice("พลังโจมตี +25%% %d วิ" % int(ROAR_TIME))

## 25.1 กลิ้งพุ่งไปหน้า ทิ้งลายเสือบนพื้น ยืนบนลายโดนต่อเนื่องและช้าลง
func _do_tg_stripes() -> void:
	var x0 := hero.position.x
	_act("sp_dx", 0.4)
	_tcast("spt_roll")
	_add({"type": "slide", "life": 0.35, "speed": 12.0, "dmg": 14.0, "eff": "flinch", "node": null, "once_each": true})
	_later(0.36, func() -> void:
		var dist := absf(hero.position.x - x0) + 1.0 * U
		var n := _sfx("stripes", Vector2(x0 - _f() * 0.5 * U, 0.0), dist, 4.2)
		_zone(Vector2((x0 + hero.position.x) * 0.5, 0.0), dist * 0.5, 4.0, 7.0, "light", 0.35, n, {"slow": true}))

## 30.1 กดค้างชาร์จ ปล่อยพุ่งแทงทะลุ ยิ่งนานยิ่งแรง
func _do_tg_charge() -> void:
	_act("sp_z1", 1.6, {"wind": 0.95, "strike": 0.98})
	_start_charge(1.2, func(k: float) -> void:
		hero.plain_sa_t = maxf(hero.plain_sa_t, 0.5)
		_act("sp_z1", 0.3, {"lunge": 0.5})
		_trail("thrust")
		_tcast("spt_rush")
		_add({"type": "slide", "life": 0.25 + 0.2 * k, "speed": 14.0 + 8.0 * k, "dmg": 35.0 + 65.0 * k, "eff": "knock" if k > 0.6 else "strong", "node": null, "once_each": true}))

## 30.2 ใช้กลางอากาศได้ บนพื้นข่วนเสย กลางอากาศข่วนฟาดลง
func _do_tg_sky() -> void:
	if hero.on_floor():
		_act("sp_ax", 0.4)
		_trail("up")
		_sfx("claw", hero.position + Vector2(_f() * 1.1 * U, -110.0), 170.0, 0.35)
		_later(0.1, func() -> void: _front(1.1, 1.4, 30.0, "launch", 1.8))
		_later(0.16, func() -> void: _hop(0.75))
	else:
		_act("sp_adz1", 0.35)
		_trail("down")
		_sfx("claw", hero.position + Vector2(_f() * 1.0 * U, -40.0), 190.0, 0.35)
		_later(0.08, func() -> void: _front(1.0, 1.5, 34.0, "knock", 2.4))

## 35.1 ม้วนตัวกลิ้งทะลุ ไม่โดนดาเมจ แล้วหมุนหอกฟาดลง
func _do_tg_tumble() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 0.6)
	_act("sp_adx", 0.45)
	_tcast("spt_roll")
	_add({"type": "slide", "life": 0.4, "speed": 13.0, "dmg": 26.0, "eff": "flinch", "node": null, "once_each": true})
	_later(0.45, func() -> void:
		_act("sp_x2", 0.35)
		_tcast("spt_spin_down")
		_later(0.12, func() -> void: _boom(hero.position + Vector2(_f() * 1.1 * U, -50.0), 2.0 * U, 1.3 * U, 40.0, "knock", "fire")))

# ---------------------------------------------------------------- FIERCE PROWLER
## 35.2 ตะครุบไปหามอนใกล้สุดต่อกัน 3 ตัว
func _do_fp_chain() -> void:
	var done: Array = []
	for i in 3:
		_later(float(i) * 0.3, func() -> void:
			var tgt := _nearest(hero.position + Vector2(0.0, -60.0), 6.0 * U, done)
			if tgt == null:
				return
			done.append(tgt)
			if tgt.pos.x != hero.pos.x:
				hero.facing = signf(tgt.pos.x - hero.pos.x)
			_hop(0.35)
			_warp(tgt.pos.x - hero.facing * 0.9)
			_act("sp_adz1", 0.28)
			_tcast("spt_impact")
			_sfx("claw", _mc(tgt), 170.0, 0.3)
			_hit(tgt, 38.0, "launch" if i == 2 else "strong", _f()))

## 35.3 ติด SA พุ่งแทงไกลครึ่งจอ ทิ้งลายเสือ
func _do_fp_lunge() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.6)
	_act("sp_z1", 0.4, {"lunge": 0.6})
	_trail("thrust")
	_tcast("spt_rush")
	var dist := page._screen_w() * 0.5 / U
	_sfx("stripes", Vector2(hero.position.x, 0.0), dist * U, 0.9)
	_add({"type": "slide", "life": 0.35, "speed": dist / 0.35, "dmg": 60.0, "eff": "knock", "node": null, "once_each": true})

## 45.1 คำรามใหญ่ มอนทั่วจอสตั๊นและอ่อนแรง
func _do_fp_roar() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.8)
	_act("sp_x1", 0.6)
	_sfx("ring", hero.position + Vector2(0.0, -80.0), 5.0 * U, 0.9)
	_sfx("ring", hero.position + Vector2(0.0, -80.0), 3.0 * U, 0.7)
	_later(0.15, func() -> void:
		for m in _in_ellipse(hero.position + Vector2(0.0, -60.0), page._screen_w() * 0.55, 3.0 * U):
			_hit(m, 30.0, "stun", _side(m))
			m.weak_t = maxf(m.weak_t, 5.0))

## 45.2 กดค้างหมุนหอกพายุเล็บเดินหน้า
func _do_fp_whirl() -> void:
	_start_channel("sp_sk_fp_whirl", 0.2, 3.0, 40.0, func() -> void:
		_act("sp_x3", 0.22)
		_trail("spin")
		hero.pos.x = clampf(hero.pos.x + _f() * 0.3, -hero.half_width, hero.half_width)
		hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
		_sfx("claw", hero.position + Vector2(randf_range(-1.0, 1.0) * U, -80.0), 140.0, 0.25)
		for m in _in_circle(hero.position + Vector2(0.0, -60.0), 1.7 * U):
			_hit(m, 9.0, "light", _side(m)))

## 50.1 ลูกไฟลายเสือ 5 ลูก บานออกแล้ววิ่งตามมอน
func _do_fp_storm() -> void:
	_act("sp_x1", 0.45)
	for i in 5:
		var ang := deg_to_rad(-70.0 + 35.0 * float(i))
		_later(float(i) * 0.06, func() -> void:
			_proj("fire", "fire", hero.position + Vector2(_f() * 50.0, -100.0), Vector2(_f() * cos(ang), sin(ang)) * 700.0, 0.35 * U, 24.0, "strong", {"life": 2.0, "homing": 1100.0}))

## 55.1 ติด SA แทงเสย กระโดดตาม ทุ่มหอกลงพื้น
func _do_fp_king() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.4)
	_act("sp_z1", 0.3, {"lunge": 0.4})
	_trail("thrust")
	_later(0.12, func() -> void:
		_front(1.5, 1.6, 40.0, "launch", 1.4)
		_later(0.2, func() -> void:
			_hop(0.9)
			_act("sp_zzx", 0.4)
			_trail("up"))
		_land(0.35, func() -> void:
			_act("sp_az", 0.4)
			_tcast("spt_impact")
			_sfx("stripes", Vector2(hero.position.x - _f() * 2.0 * U, 0.0), 4.0 * U, 0.9)
			_boom(hero.position + Vector2(_f() * 1.0 * U, -50.0), 3.6 * U, 1.8 * U, 90.0, "knock", "fire")))

# ---------------------------------------------------------------- PETIT FANG
## 15.2 บอลหมาป่าลูกใหญ่ช้าๆ ทะลุ
func _do_fg_ball() -> void:
	_act("sp_z1", 0.3)
	_later(0.1, func() -> void: _wolf(Vector2(_f(), 0.0), 650.0, 0.7 * U, 26.0, true, 1.4))

## 15.3 หอนใต้แสงจันทร์ บัพตีแรงและดูดเลือด
func _do_fg_howl() -> void:
	_act("sp_x1", 0.6)
	_sfx("moon", hero.position + Vector2(0.0, -3.2 * U), 0.6 * U, 1.4)
	_sfx("ring", hero.position + Vector2(0.0, -90.0), 1.8 * U, 0.8)
	_sfx("aura", hero.position, 90.0, HOWL_TIME, hero)
	buffs["howl"] = HOWL_TIME
	page.bars.notice("หอนจันทร์ ตีแรงขึ้น ดูดเลือด %d วิ" % int(HOWL_TIME))

## 15.5 พุ่งกัด ดูดเลือดตามจำนวนมอนที่กัดโดน
func _do_fg_bite() -> void:
	_act("sp_dz", 0.35)
	_trail("thrust")
	_add({"type": "slide", "life": 0.22, "speed": 13.0, "node": null})
	_later(0.22, func() -> void:
		var hit := _front(0.9, 1.3, 30.0, "strong", 1.3)
		for m in hit:
			_sfx("claw", _mc(m), 130.0, 0.3)
		hero.hp = minf(hero.hp + hero.hp_max() * 0.05 * float(hit.size()), hero.hp_max()))

## 25.1 เรียกลูกหมาป่าเงา
func _do_fg_pup() -> void:
	_act("sp_x1", 0.4)
	_sfx("ring", hero.position + Vector2(-_f() * 1.0 * U, -60.0), 1.0 * U, 0.5)
	_pup(10.0, 1.2)

## 30.1 บอลหมาป่า 5 ลูกเป็นพัด
func _do_fg_fan() -> void:
	_act("sp_z3", 0.4)
	for i in 5:
		var ang := deg_to_rad(-30.0 + 15.0 * float(i))
		_later(float(i) * 0.05, func() -> void:
			_wolf(Vector2(_f() * cos(ang), sin(ang)), 1000.0, 0.42 * U, 16.0, false, 0.9, {"kb": 1.0, "stun": 0.5}))

## 30.2 วังวนมืดด้านหน้า ดูดมอน อ่อนแรง
func _do_fg_pull() -> void:
	_act("sp_x9", 0.35)
	var at := Vector2(hero.position.x + _f() * 2.6 * U, 0.0)
	var n := _fx("dark", "dark", at + Vector2(0.0, -80.0), 50.0, 2.8, false)
	_zone(at, 1.4 * U, 2.5, 6.0, "light", 0.3, n, {"pull": 3.0 * U, "weak": true})

## 35.1 ใช้กลางอากาศได้ กระโดดสูงพุ่งเฉียงลง ระเบิดมืด
func _do_fg_leap() -> void:
	if hero.on_floor():
		_hop(1.0)
	_act("sp_adz1", 0.4)
	_later(0.25, func() -> void:
		_act("sp_x9", 0.35)
		_add({"type": "slide", "life": 0.3, "speed": 9.0, "node": null}))
	_land(0.3, func() -> void:
		_sfx("ring", hero.position + Vector2(0.0, -20.0), 2.0 * U, 0.6)
		_boom(hero.position + Vector2(0.0, -50.0), 2.6 * U, 1.4 * U, 50.0, "launch", "dark"))

# ---------------------------------------------------------------- LUPINE DIRE
## 35.2 เรียกฝูงหมาป่าเงา 3 ตัว
func _do_ld_pack() -> void:
	_act("sp_x1", 0.6)
	_sfx("moon", hero.position + Vector2(0.0, -3.4 * U), 0.7 * U, 1.2)
	for i in 3:
		_pup(12.0, 0.8 + 0.7 * float(i), 14.0)

## 35.3 คลื่นจันทร์เสี้ยวทะลุไปด้านหน้า
func _do_ld_crescent() -> void:
	_act("sp_z5", 0.4)
	_trail("sweep")
	var n := _sfx("crescent", Vector2.ZERO, 1.3 * U, 1.1)
	_mover(n, hero.position + Vector2(_f() * 80.0, -90.0), Vector2(_f() * 1100.0, 0.0), 1.2 * U, 0.9, 32.0, "strong")

## 45.1 จันทร์คราส มอนทั่วจออ่อนแรง บอลหมาป่าตกจากฟ้า
func _do_ld_eclipse() -> void:
	_act("sp_x1", 0.6)
	_sfx("moon", hero.position + Vector2(_f() * 2.0 * U, -4.0 * U), 0.9 * U, 2.2)
	for m in _in_ellipse(hero.position + Vector2(0.0, -60.0), page._screen_w() * 0.6, 4.0 * U):
		m.weak_t = maxf(m.weak_t, 6.0)
	for i in 8:
		_later(0.25 + float(i) * 0.12, func() -> void:
			var ms := _mons()
			var x := hero.position.x + _f() * randf_range(0.5, 6.0) * U
			if not ms.is_empty():
				x = _mc(ms[i % ms.size()]).x + randf_range(-0.3, 0.3) * U
			var b := _wolf(Vector2(0.0, 1.0), 1100.0, 0.5 * U, 28.0, false, 1.5, {"kb": 0.6, "stun": 0.6})
			b.position = Vector2(x, -6.0 * U))

## 45.2 กดค้างยิงบอลหมาป่ารัว
func _do_ld_barrage() -> void:
	_start_channel("sp_sk_ld_barrage", 0.15, 3.0, 50.0, func() -> void:
		_act("sp_z1" if randf() < 0.5 else "sp_z3", 0.15)
		_wolf(Vector2(_f(), randf_range(-0.12, 0.12)), 1200.0, 0.35 * U, 11.0, false, 0.8, {"kb": 0.5, "stun": 0.4}))

## 50.1 ใช้กลางอากาศได้ วาปไปหลังมอนแล้วแทงสวน
func _do_ld_swap() -> void:
	var tgt := _nearest(hero.position + Vector2(0.0, -60.0), 6.0 * U)
	if tgt == null:
		_warp(hero.pos.x + _f() * 3.0)
		return
	var side := signf(tgt.pos.x - hero.pos.x) if tgt.pos.x != hero.pos.x else _f()
	_warp(tgt.pos.x + side * 0.9)
	hero.facing = -side
	_act("sp_z1", 0.3, {"lunge": 0.2})
	_trail("thrust")
	_later(0.1, func() -> void:
		if is_instance_valid(tgt) and tgt.state != "dead":
			_sfx("claw", _mc(tgt), 160.0, 0.3)
			_hit(tgt, 45.0, "knock", hero.facing))

## 55.1 หัวหมาป่ายักษ์ช้าๆ ทะลุทุกตัว แล้วระเบิด
func _do_ld_maw() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.8)
	_act("sp_x1", 0.5)
	_later(0.2, func() -> void:
		var b := _wolf(Vector2(_f(), 0.0), 520.0, 1.6 * U, 45.0, true, 1.8, {"kb": 1.5, "stun": 0.8})
		b.position = hero.position + Vector2(_f() * 1.4 * U, -1.7 * U)
		_later(1.6, func() -> void:
			if is_instance_valid(b):
				_boom(b.position, 2.6 * U, 1.8 * U, 60.0, "knock", "dark")
				_sfx("ring", b.position, 2.2 * U, 0.6)))

# ---------------------------------------------------------------- PETIT VIXEN
## 15.2 ใช้กลางอากาศได้ ข่วนจิ้งจอก 3 ชุด
func _do_vx_scratch() -> void:
	for i in 3:
		_later(float(i) * 0.12, func() -> void:
			_act("sp_z3" if i % 2 == 0 else "sp_z2", 0.14)
			var ang := [-PI * 0.5 - 0.6, -PI * 0.5 + 0.6, 0.0][i] as float
			SpearLineVixen._claw(page, hero.position + Vector2(_f() * 1.2 * U, -80.0), ang, 170.0, 4, 13.0 if i < 2 else 20.0, {"stun": 0.5, "kb": 0.6 if i < 2 else 3.0}, 130.0))

## 15.3 ไฟจิ้งจอก 3 ลูกหมุนรอบตัว
func _do_vx_fire() -> void:
	_act("sp_x1", 0.4)
	var nodes := []
	for i in 3:
		nodes.append(_sfx("orb", hero.position, 22.0, 8.3))
	_add({"type": "orbit", "nodes": nodes, "life": 8.0, "dmg": 7.0, "eff": "light", "tick": 0.35})

## 15.5 ใช้กลางอากาศได้ วาปไปหน้า มอนตามทางโดน
func _do_vx_blink() -> void:
	var x0 := hero.position
	_warp(hero.pos.x + _f() * 3.0)
	hero.invuln_t = maxf(hero.invuln_t, 0.3)
	_act("sp_z1", 0.25)
	for m in _in_ellipse((x0 + hero.position) * 0.5 + Vector2(0.0, -60.0), absf(hero.position.x - x0.x) * 0.5 + 0.6 * U, 1.3 * U):
		_hit(m, 20.0, "flinch", _f())

## 25.1 ปาปิ่น 5 อันเป็นพัด
func _do_vx_pin() -> void:
	_act("sp_x1", 0.35)
	for i in 5:
		var ang := deg_to_rad(-20.0 + 10.0 * float(i))
		_later(float(i) * 0.05, func() -> void:
			SpearLineVixen._pin(page, hero.position + Vector2(_f() * 70.0, -100.0), Vector2(_f() * cos(ang), sin(ang)) * 1300.0, 18.0, {"stun": 0.5, "kb": 0.8}))

## 30.1 ร่างเงาจิ้งจอกด้านหน้า ข่วนเอง
func _do_vx_clone() -> void:
	_act("sp_x1", 0.4)
	var at := Vector2(hero.position.x + _f() * 1.4 * U, 0.0)
	SpearLineVixen._fx(page, "poof", at + Vector2(0.0, -80.0), 0.4)
	_clone(at, 6.0, 16.0)

## 30.2 กับดักวงยันต์จิ้งจอก มอนเหยียบระเบิด ติดที่
func _do_vx_trap() -> void:
	_act("sp_x9", 0.3)
	_trap(Vector2(hero.position.x + _f() * 2.2 * U, 0.0), 0.9 * U, 10.0, func(at: Vector2) -> void:
		SpearLineVixen._fx(page, "ring", at, 0.5, 1.6 * U)
		_fx("boom", "ice", at + Vector2(0.0, -50.0), 1.6 * U, 0.45)
		for m in _in_ellipse(at + Vector2(0.0, -50.0), 1.6 * U, 1.4 * U):
			_hit(m, 40.0, "strong", _f())
			m.root_t = maxf(m.root_t, 3.0))

## 35.1 หมุนเก้าหางรอบตัว มอนลอย
func _do_vx_tail() -> void:
	_act("sp_x3", 0.5)
	_trail("spin")
	for i in 6:
		var ang := TAU * float(i) / 6.0
		_later(float(i) * 0.05, func() -> void:
			SpearLineVixen._claw(page, hero.position + Vector2(cos(ang) * 1.3 * U, -80.0 + sin(ang) * 0.6 * U), ang + PI * 0.5, 130.0, 3, 0.0, {}))
	_later(0.3, func() -> void:
		for m in _in_circle(hero.position + Vector2(0.0, -60.0), 1.9 * U):
			_hit(m, 34.0, "launch", _side(m)))

# ---------------------------------------------------------------- PHANTOM VULPINE
## 35.2 วาปข่วนสลับรอบมอน 4 ครั้ง
func _do_pv_rush() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 1.2)
	for i in 4:
		_later(float(i) * 0.22, func() -> void:
			var tgt := _nearest(hero.position + Vector2(0.0, -60.0), 6.0 * U)
			var x := hero.pos.x + _f() * 1.8
			if tgt != null:
				x = tgt.pos.x + (1.0 if i % 2 == 0 else -1.0) * 0.8
			_warp(x)
			if tgt != null and tgt.pos.x != hero.pos.x:
				hero.facing = signf(tgt.pos.x - hero.pos.x)
			_act("sp_z1", 0.2)
			SpearLineVixen._claw(page, hero.position + Vector2(_f() * 0.8 * U, -80.0), randf_range(-2.2, -0.9), 170.0, 4, 22.0 if i < 3 else 40.0, {"stun": 0.5} if i < 3 else {"type": "launch", "vy": 10.0}, 140.0))

## 35.3 ฝนปิ่นปักผม 9 อันตกด้านหน้า
func _do_pv_pins() -> void:
	_act("sp_x1", 0.4)
	for i in 9:
		_later(0.1 + float(i) * 0.05, func() -> void:
			var x := hero.position.x + _f() * (0.8 + 0.45 * float(i)) * U
			SpearLineVixen._pin(page, Vector2(x - _f() * 1.2 * U, -5.5 * U), Vector2(_f() * 0.22, 1.0).normalized() * 1500.0, 20.0, {"stun": 0.5, "kb": 0.4}))

## 45.1 กดค้างชาร์จไฟจิ้งจอก ปล่อยวงไฟระเบิดรอบตัว มอนแข็ง
func _do_pv_nova() -> void:
	_act("sp_x1", 1.6, {"wind": 0.95, "strike": 0.98})
	_start_charge(1.3, func(k: float) -> void:
		_act("sp_x2", 0.35)
		var w := (2.4 + 2.4 * k) * U
		_sfx("ring", hero.position + Vector2(0.0, -70.0), w, 0.7)
		SpearLineVixen._fx(page, "ring", hero.position, 0.5, w)
		for m in _in_ellipse(hero.position + Vector2(0.0, -60.0), w, w * 0.5):
			_hit(m, 40.0 + 60.0 * k, "strong", _side(m))
			m.freeze_ice(1.0 + 1.5 * k))

## 45.2 ใช้กลางอากาศได้ ข่วนเก้าหาง 9 รอยขึ้นฟ้า
func _do_pv_lift() -> void:
	for i in 3:
		_later(float(i) * 0.12, func() -> void:
			_act("sp_ax" if hero.on_floor() else "sp_adz2", 0.14)
			for j in 3:
				var at := hero.position + Vector2(_f() * (0.8 + 0.3 * float(j)) * U, -60.0 - float(j) * 30.0)
				SpearLineVixen._claw(page, at, -PI * 0.5 + (float(j) - 1.0) * 0.4, 150.0, 3, 9.0 if i < 2 else 16.0, {"type": "launch", "vy": 7.0 + 2.0 * float(i)}, 110.0))

## 50.1 ร่างเงา 3 ร่าง ข่วนแล้วระเบิด
func _do_pv_mirage() -> void:
	_act("sp_x1", 0.5)
	for i in 3:
		var at := Vector2(hero.position.x + _f() * (1.0 + 1.3 * float(i)) * U, 0.0)
		SpearLineVixen._fx(page, "poof", at + Vector2(0.0, -80.0), 0.4)
		_clone(at, 2.2, 18.0, 45.0)

## 55.1 ติด SA ยิงลำแสงจันทร์จิ้งจอก
func _do_pv_beam() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.4)
	_act("sp_z1", 1.3)
	var at := hero.position + Vector2(_f() * 70.0, -90.0)
	var n := _fx("beam", "ice", at, 40.0, 1.35, false)
	n.angle = 0.0 if _f() > 0.0 else PI
	n.length = 9.0 * U
	n.ry = 80.0
	_add({"type": "beam", "node": n, "pos": at, "life": 1.2, "dmg": 12.0, "eff": "flinch", "tick": 0.12, "len": 9.0 * U, "w": 80.0, "ang": n.angle})

# ---------------------------------------------------------------- PETIT SHELL
## 15.2 ใช้กลางอากาศได้ ปายันต์ 3 ใบทะลุ
func _do_sh_talis() -> void:
	_act("sp_x1", 0.35)
	for i in 3:
		_later(float(i) * 0.08, func() -> void:
			_talis(hero.position + Vector2(_f() * 80.0, -90.0 + (float(i) - 1.0) * 30.0), Vector2(_f() * 1000.0, 0.0), 15.0, true))

## 15.3 ตั้งการ์ดกระดอง ไม่โดนดาเมจ มอนเข้าใกล้สวนกลับ
func _do_sh_guard() -> void:
	_act("sp_x1", 1.5, {"wind": 0.95, "strike": 0.98})
	buffs["guard_all"] = 1.5
	var n := _sfx("dome", hero.position, 1.1 * U, 1.5, hero)
	_add({"type": "guard", "node": n, "life": 1.5})

func _shell_counter() -> void:
	countered += 1
	_act("sp_z1", 0.3, {"lunge": 0.3})
	_trail("thrust")
	_sfx("ring", hero.position + Vector2(_f() * U, -70.0), 1.3 * U, 0.4, null, "shell")
	_front(1.2, 1.5, 45.0, "knock", 1.4)

## 15.5 กระทืบพื้น หินโผล่ มอนลอย
func _do_sh_stomp() -> void:
	_act("sp_x2", 0.35)
	_later(0.15, func() -> void:
		_sfx("ring", hero.position + Vector2(0.0, -10.0), 1.8 * U, 0.5)
		for s in [-1.0, 1.0]:
			_sfx("rock", hero.position + Vector2(float(s) * 1.3 * U, 0.0), 1.1 * U, 0.6)
		_boom(hero.position + Vector2(0.0, -40.0), 2.4 * U, 1.2 * U, 32.0, "launch", "leaf"))

## 25.1 แส้งูน้ำ ดึงมอนเข้าหาตัว
func _do_sh_snake() -> void:
	_act("sp_z1", 0.4, {"lunge": 0.1})
	var n := _sfx("snake", hero.position + Vector2(_f() * 60.0, -80.0), 4.0 * U, 0.6)
	n.base = SNAKE_COL
	_later(0.15, func() -> void:
		for m in _in_ellipse(hero.position + Vector2(_f() * 2.5 * U, -60.0), 2.3 * U, 1.2 * U):
			_hit(m, 28.0, "strong", -_f())
			if not ROLES_HEAVY(m):
				m.pos.x = clampf(lerpf(m.pos.x, hero.pos.x + _f() * 1.0, 0.75), -m.half_width, m.half_width))

## 30.1 กระดองครอบตัว ติด SA
func _do_sh_ward() -> void:
	_act("sp_x1", 0.4)
	hero.plain_sa_t = maxf(hero.plain_sa_t, WARD_TIME)
	_sfx("dome", hero.position, 1.3 * U, WARD_TIME, hero)
	page.bars.notice("ติด SA %d วิ" % int(WARD_TIME))

## 30.2 ยันต์ผนึกบนพื้น มอนในวงติดที่
func _do_sh_seal() -> void:
	_act("sp_x9", 0.3)
	var at := Vector2(hero.position.x + _f() * 2.4 * U, 0.0)
	_talis(hero.position + Vector2(_f() * 80.0, -90.0), (at + Vector2(0.0, -20.0) - hero.position - Vector2(_f() * 80.0, -90.0)).normalized() * 1200.0, 10.0, true, 0.3)
	_later(0.2, func() -> void:
		var n := _sfx("sigil", at, 1.4 * U, 3.2)
		_zone(at, 1.4 * U, 3.0, 5.0, "light", 0.4, n, {"root": true}))

## 35.1 เสาหินไล่ไปด้านหน้า 3 ต้น
func _do_sh_rock() -> void:
	_act("sp_x2", 0.4)
	for i in 3:
		_later(0.15 + float(i) * 0.15, func() -> void:
			var at := Vector2(hero.position.x + _f() * (1.2 + 1.3 * float(i)) * U, 0.0)
			_sfx("rock", at, 1.6 * U, 0.7)
			for m in _in_ellipse(at + Vector2(0.0, -60.0), 0.9 * U, 1.6 * U):
				_hit(m, 30.0, "launch", _f()))

# ---------------------------------------------------------------- GENBU TITAN
## 35.2 กระดองเต่าดำ ไม่โดนดาเมจ ผลักมอน
func _do_gb_dome() -> void:
	_act("sp_x2", 0.4)
	buffs["guard_all"] = DOME_TIME
	var n := _sfx("dome", hero.position, 1.7 * U, DOME_TIME, hero)
	_add({"type": "dome", "node": n, "life": DOME_TIME, "r": 1.7 * U, "dmg": 8.0, "eff": "strong", "tick": 0.5})
	page.bars.notice("กระดองเต่าดำ %d วิ" % int(DOME_TIME))

## 35.3 งูน้ำคู่ฟาดหลายฮิต
func _do_gb_serpent() -> void:
	_act("sp_x3", 0.6)
	for k in 2:
		var n := _sfx("snake", hero.position + Vector2(_f() * 60.0, -40.0 - 80.0 * float(k)), 4.5 * U, 0.9)
		n.base = SNAKE_COL
	_zone(Vector2(hero.position.x + _f() * 2.4 * U, 0.0), 2.3 * U, 0.8, 10.0, "flinch", 0.16, null)

## 45.1 ยันต์ 12 ใบรอบทิศ
func _do_gb_storm() -> void:
	_act("sp_x3", 0.5)
	_sfx("ring", hero.position + Vector2(0.0, -90.0), 1.5 * U, 0.5)
	for i in 12:
		var ang := TAU * float(i) / 12.0
		_talis(hero.position + Vector2(0.0, -90.0), Vector2(cos(ang), sin(ang) * 0.6) * 900.0, 18.0, true, 0.8)

## 45.2 ใช้กลางอากาศได้ ทิ้งตัวเหมือนภูเขาตก
func _do_gb_drop() -> void:
	if hero.on_floor():
		_hop(1.0)
	_act("sp_ax", 0.4)
	_land(0.3, func() -> void:
		_act("sp_az", 0.4)
		var w := page._screen_w() * 0.45
		_sfx("ring", hero.position + Vector2(0.0, -10.0), w, 0.7)
		for s in [-1.0, 1.0]:
			_sfx("rock", hero.position + Vector2(float(s) * 1.6 * U, 0.0), 1.4 * U, 0.7)
		_boom(hero.position + Vector2(0.0, -50.0), w, 1.6 * U, 60.0, "launch", "leaf"))

## 50.1 ยันต์ 5 ใบเรียงหน้า 1 วิแล้วระเบิด
func _do_gb_seals() -> void:
	_act("sp_x9", 0.4)
	for i in 5:
		var at := Vector2(hero.position.x + _f() * (1.0 + float(i)) * U, 0.0)
		_sfx("sigil", at, 0.6 * U, 1.2)
		_later(1.0 + float(i) * 0.08, func() -> void:
			_boom(at + Vector2(0.0, -50.0), 1.0 * U, 1.4 * U, 40.0, "launch", "ore"))

## 55.1 ปักหอก คลื่นหินแผ่นดินไหววิ่งไปหน้า 7 ครั้ง
func _do_gb_quake() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.2)
	_act("sp_x2", 0.5)
	_later(0.2, func() -> void:
		_sfx("ring", hero.position + Vector2(0.0, -10.0), 1.5 * U, 0.5)
		_add({"type": "wave", "pos": Vector2(hero.position.x + _f() * 1.0 * U, 0.0), "step": 1.1 * U, "n": 7, "every": 0.12, "t": 0.0, "dmg": 40.0, "eff": "launch", "life": 2.0, "face": _f()}))

# ---------------------------------------------------------------- ทุกเฟรม
func _process(delta: float) -> void:
	super._process(delta)
	if page == null:
		return
	dodge_cd = maxf(dodge_cd - delta, 0.0)
	revive_cd = maxf(revive_cd - delta, 0.0)
	veil_cd = maxf(veil_cd - delta, 0.0)
	reflect_cd = maxf(reflect_cd - delta, 0.0)
	_tick_charge(delta)
	if _quake:
		_quake_t += delta
		if _quake_t > 0.3 and not hero.on_floor():
			hero.vel.y = minf(hero.vel.y, -Hero.CHIBI_DIVE_SPEED * 0.9)
		if _quake_t > 0.3 and hero.on_floor():
			_land_quake()
		elif _quake_t > 2.0:
			_quake = false
	if _ring_t > 0.0:
		_ring_t -= delta
		if is_instance_valid(_ring_fx):
			_ring_fx.position = hero.position + Vector2(0.0, -60.0)
		_ring_tick -= delta
		if _ring_tick <= 0.0:
			_ring_tick = RING_TICK
			for m in _in_circle(hero.position + Vector2(0.0, -60.0), (RING_R + 0.4) * U):
				_hit(m, RING_DMG, "light", signf(_mc(m).x - hero.position.x) if _mc(m).x != hero.position.x else _f())

func _apply_passives(delta: float) -> void:
	var hpb := 0.0
	if has("sp_sk_fg_pelt"):
		hpb += 60.0
	if has("sp_sk_sh_tough"):
		hpb += 80.0
	if has("sp_sk_gb_iron"):
		hpb += 70.0
	if has("sp_sk_fp_heart"):
		hpb += 80.0
	hero.hp_bonus = hpb
	hero.mp_bonus = Stats.MP_UP if has("sp_sk_fg_night") else 0.0
	hero.regen_mult = 1.3 if has("sp_sk_pv_fortune") else 1.0
	var spd := 1.0
	if has("sp_sk_tg_stride"):
		spd *= Stats.SPEED_MULT
	if has("sp_sk_vx_grace"):
		spd *= Stats.SPEED_MULT
	if has("sp_sk_fp_rage") and hero.hp < hero.hp_max() * 0.35:
		spd *= 1.1
	hero.speed_bonus = spd
	page.atk_speed = 1.12 if has("sp_sk_tg_stride") else 1.0
	var block := 0.0
	if has("sp_sk_sh_steady"):
		block = maxf(block, 0.1)
	if has("sp_sk_vx_nimble"):
		block = maxf(block, 0.12)
	if has("sp_sk_gb_body"):
		block = maxf(block, 0.15)
	if has("sp_sk_pv_fortune"):
		block = maxf(block, 0.18)
	hero.block_chance = block
	# กระดอง ไม่โดนดาเมจทั้งใกล้และไกล
	var g := float(buffs.get("guard_all", 0.0))
	hero.ranged_guard_t = g
	hero.melee_guard_t = g
	if has("sp_sk_gb_body"):
		hero.hp = minf(hero.hp + hero.hp_max() * 0.005 * delta, hero.hp_max())
	if buffs.has("revive"):
		hero.hp = minf(hero.hp + hero.hp_max() * 0.05 * delta, hero.hp_max())

func dmg_mult(m: Monster, _h: Dictionary) -> float:
	var k := 1.0
	if buffs.has("roar"):
		k *= 1.25
	if buffs.has("howl"):
		k *= 1.15
	# TIGER 15.4 คริติคอล
	if has("sp_sk_tg_eye") and randf() < CRIT_CHANCE:
		k *= 1.5
		crits += 1
	if has("sp_sk_fp_instinct") and m.hp <= m.max_hp * 0.5:
		k *= 1.2
	if has("sp_sk_fp_rage") and hero.hp < hero.hp_max() * 0.35:
		k *= 1.3
	if has("sp_sk_ld_hunter"):
		k *= 1.2
	return k

func on_strike(_m: Monster, h: Dictionary) -> void:
	var skill: bool = h.get("skill", false)
	# FANG 15.3 หอนจันทร์ ตีคอมโบดูดเลือด
	if buffs.has("howl") and not skill:
		hero.hp = minf(hero.hp + 2.0, hero.hp_max())
	if has("sp_sk_fp_heart") and not skill:
		hero.mp = minf(hero.mp + 1.0, hero.mp_max())
	# LUPINE 35.4 สกิลโดนดูดเลือด 1%
	if has("sp_sk_ld_blood") and skill and Time.get_ticks_msec() - _blood_ms >= 100:
		_blood_ms = Time.get_ticks_msec()
		hero.hp = minf(hero.hp + hero.hp_max() * 0.01, hero.hp_max())

func mod_shot(_shot: Array) -> void:
	pass

## 10.1 โดนตีแล้วถอยหลังกระโดดหนีเอง (คูลดาวน์ 8 วิ)
func _on_hurt(_kind: String) -> void:
	# LUPINE 60.2 เลือดหมดไม่ตาย ฟื้นแล้วเรียกหมาเงา
	if hero.hp <= 0.0:
		if revive_cd <= 0.0 and has("sp_sk_ld_alpha"):
			revive_cd = REVIVE_CD
			hero.hp = hero.hp_max() * 0.25
			hero.invuln_t = maxf(hero.invuln_t, 1.5)
			buffs["revive"] = 8.0
			_cur_id = "sp_sk_ld_alpha"
			_sfx("moon", hero.position + Vector2(0.0, -3.0 * U), 0.6 * U, 1.2, null, "fang")
			_pup(10.0, 1.0)
			_pup(10.0, 1.8)
			page.bars.notice("หัวหน้าฝูงยังไม่ยอมแพ้!")
		return
	# GENBU 60.2 โดนตีแล้วกระดองระเบิดสวน
	if has("sp_sk_gb_reflect") and reflect_cd <= 0.0:
		reflect_cd = REFLECT_CD
		reflects += 1
		_sfx("dome", hero.position, 1.2 * U, 0.5, null, "shell")
		_boom(hero.position + Vector2(0.0, -60.0), 1.8 * U, 1.3 * U, 40.0, "knock", "leaf")
	# PHANTOM 35.4 วาปหนี ทิ้งร่างเงาระเบิด
	if has("sp_sk_pv_veil") and veil_cd <= 0.0 and randf() < veil_chance:
		veil_cd = VEIL_CD
		veils += 1
		var at := Vector2(hero.position.x, 0.0)
		hero.invuln_t = maxf(hero.invuln_t, 1.0)
		_warp(hero.pos.x - _f() * 2.5)
		_clone(at, 1.0, 0.0, 35.0, "vixen")
		return
	if dodge_cd > 0.0 or not has("sp_sk_dodge"):
		return
	dodge_cd = DODGE_CD
	dodged += 1
	hero.invuln_t = maxf(hero.invuln_t, 0.8)
	_hop(0.7)
	_add({"type": "slide", "life": 0.3, "speed": -14.0, "node": null})
	_fx("poof", "fire", hero.position + Vector2(0.0, -60.0), 50.0, 0.4)

var dodged := 0                 # นับจำนวนครั้งที่หลบเอง (ใช้ในเทสต์)

## วงหอกสีดำหมุนรอบตัว ปลายหอกส้ม ทรงมน
class SpearRing extends Node2D:
	var radius := 260.0
	var life := 4.0
	var _t := 0.0
	func _process(delta: float) -> void:
		_t += delta
		if _t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var a := clampf(_t / 0.2, 0.0, 1.0) * clampf((life - _t) / 0.4, 0.0, 1.0)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 64, Color(0.12, 0.08, 0.1, 0.25 * a), 26.0, true)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 64, Color(1.0, 0.55, 0.15, 0.35 * a), 4.0, true)
		for i in 6:
			var ang := _t * 5.0 + TAU * float(i) / 6.0
			var c := Vector2(cos(ang) * radius, sin(ang) * radius * 0.45)
			var d := Vector2(-sin(ang), cos(ang) * 0.45).normalized()
			var tail := c - d * 70.0
			var tip := c + d * 50.0
			draw_line(tail, tip, Color(0.12, 0.08, 0.1, a), 12.0, true)
			draw_circle(tail, 6.0, Color(0.12, 0.08, 0.1, a))
			draw_circle(tip, 11.0, Color(1.0, 0.55, 0.15, a))
			draw_circle(tip, 5.0, Color(1.0, 0.92, 0.75, a))
