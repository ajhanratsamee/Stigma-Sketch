class_name PairSkills
extends SusiSkills
## สกิลของ CAT AZURE & LAPIS (คู่หู) id ขึ้นต้น pr_sk_
## ต่อยอดจาก SusiSkills (มานา คูลดาวน์ ชิ้นสกิล UI คูลดาวน์) แบบเดียวกับ SpearSkills/BowSkills
## สาย: (ไม่มีคำนำ) BASIC  sd_ SPARK DREAMER  so_ SOMNAMBULIST  sf_ SPARK FIEND  nb_ NEON BOLT
## สกิลส่วนใหญ่ใช้ทั้งคู่: ตัวที่ออกหน้าทำท่าหนึ่ง อีกตัวโผล่มาช่วย (PairPartner) บางสกิลสลับตัวเอง
## ขนาดภาพและระยะโดนคูณ SkillScale.K ทั้งหมด

const S := SkillScale.K
## cd คูลดาวน์  air ใช้กลางอากาศได้
const PAIR_DEFS := {
	"pr_sk_tag": {"cd": 3.0, "air": true},
	"pr_sk_bubble": {"cd": 6.0},
	"pr_sk_highfive": {"cd": 8.0},
	"pr_sk_relay": {"cd": 9.0},
	"pr_sk_guard": {"cd": 20.0},
	"pr_sk_toss": {"cd": 10.0},
	"pr_sk_sd_sheep": {"cd": 9.0},
	"pr_sk_sd_lullaby": {"cd": 18.0},
	"pr_sk_sd_pillow": {"cd": 7.0},
	"pr_sk_sd_moon": {"cd": 10.0, "air": true},
	"pr_sk_sd_yawn": {"cd": 12.0},
	"pr_sk_sd_drift": {"cd": 8.0, "air": true},
	"pr_sk_sd_rain": {"cd": 12.0},
	"pr_sk_sd_blanket": {"cd": 20.0},
	"pr_sk_so_walk": {"cd": 10.0},
	"pr_sk_so_door": {"cd": 14.0},
	"pr_sk_so_pillows": {"cd": 16.0},
	"pr_sk_so_twin": {"cd": 25.0},
	"pr_sk_so_snore": {"cd": 12.0},
	"pr_sk_so_float": {"cd": 12.0, "air": true},
	"pr_sk_so_nightmare": {"cd": 22.0},
	"pr_sk_sf_zap": {"cd": 5.0, "air": true},
	"pr_sk_sf_ball": {"cd": 9.0},
	"pr_sk_sf_rush": {"cd": 8.0},
	"pr_sk_sf_coil": {"cd": 16.0},
	"pr_sk_sf_tail": {"cd": 7.0},
	"pr_sk_sf_drop": {"cd": 8.0, "air": true},
	"pr_sk_sf_circuit": {"cd": 12.0},
	"pr_sk_sf_overcharge": {"cd": 30.0},
	"pr_sk_nb_dash": {"cd": 7.0, "air": true},
	"pr_sk_nb_cross": {"cd": 12.0},
	"pr_sk_nb_grid": {"cd": 14.0},
	"pr_sk_nb_rail": {"cd": 12.0},
	"pr_sk_nb_storm": {"cd": 18.0},
	"pr_sk_nb_relay": {"cd": 14.0},
	"pr_sk_nb_overdrive": {"cd": 30.0},
}
const PAIR_MP := {
	"pr_sk_tag": 30.0,
	"pr_sk_bubble": 40.0,
	"pr_sk_highfive": 60.0,
	"pr_sk_relay": 80.0,
	"pr_sk_guard": 70.0,
	"pr_sk_toss": 100.0,
	"pr_sk_sd_sheep": 70.0,
	"pr_sk_sd_lullaby": 90.0,
	"pr_sk_sd_pillow": 80.0,
	"pr_sk_sd_moon": 110.0,
	"pr_sk_sd_yawn": 50.0,
	"pr_sk_sd_drift": 90.0,
	"pr_sk_sd_rain": 140.0,
	"pr_sk_sd_blanket": 120.0,
	"pr_sk_so_walk": 160.0,
	"pr_sk_so_door": 180.0,
	"pr_sk_so_pillows": 200.0,
	"pr_sk_so_twin": 170.0,
	"pr_sk_so_snore": 150.0,
	"pr_sk_so_float": 160.0,
	"pr_sk_so_nightmare": 260.0,
	"pr_sk_sf_zap": 60.0,
	"pr_sk_sf_ball": 90.0,
	"pr_sk_sf_rush": 80.0,
	"pr_sk_sf_coil": 110.0,
	"pr_sk_sf_tail": 70.0,
	"pr_sk_sf_drop": 100.0,
	"pr_sk_sf_circuit": 140.0,
	"pr_sk_sf_overcharge": 120.0,
	"pr_sk_nb_dash": 150.0,
	"pr_sk_nb_cross": 180.0,
	"pr_sk_nb_grid": 200.0,
	"pr_sk_nb_rail": 170.0,
	"pr_sk_nb_storm": 220.0,
	"pr_sk_nb_relay": 190.0,
	"pr_sk_nb_overdrive": 260.0,
}
## สีหลักกับสีแซมของแต่ละสาย
const LINE_COL := {
	"basic": [Color(0.3, 0.52, 0.95), Color(0.97, 0.99, 1.0)],
	"dream": [Color(0.42, 0.5, 0.92), Color(1.0, 0.9, 0.55)],
	"fiend": [Color(0.18, 0.42, 1.0), Color(0.72, 1.0, 1.0)],
}
const MY_OBJS := ["zone", "coil", "twin", "circuit", "drift"]
const LINK_TIME := 3.0          # 10.1 สลับแล้วแรงขึ้น
const QUICK_CD := 2.0           # 20.3 คูลดาวน์ V
const NAP_WAIT := 2.0           # 15.4 ยืนนิ่งก่อนฟื้นเลือด
const GUARD_CD := 30.0          # 35.4 หลับกันดาเมจ
const AWAKE_CD := 15.0          # 60.2 สกิลฟรี

var guard_cd := 0.0
var awake_cd := 0.0
var free_skill := false
var _still := 0.0
var _act_tw: Tween
var swaps := 0                  # นับในเทสต์
var zaps := 0
var guarded := 0

# ---------------------------------------------------------------- ข้อมูล
func cost(id: String) -> float:
	if free_skill:
		return 0.0
	return Stats.skill_mp("azure", id)

func cooldown(id: String) -> float:
	return float(PAIR_DEFS.get(id, {}).get("cd", 3.0))

func _held() -> bool:
	return page.test_hold or super._held()

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	var d: Dictionary = PAIR_DEFS.get(id, {})
	if d.is_empty():
		return
	if page.combo_nth >= 0 or hero.hurt_t > 0.0:
		return
	if not _channel.is_empty():
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
	if free_skill:
		free_skill = false
	cds[id] = cooldown(id)
	_cur_id = id
	BigSkillFx.cast(page, id, c)
	if c >= 250.0:
		page.time_stop(0.45)
	call("_do_" + id.trim_prefix("pr_sk_"))

# ---------------------------------------------------------------- ตัวช่วย
## ตัวที่ออกหน้า "az" หรือ "lp"
func _form() -> String:
	return PairCombo.form()

func _other() -> String:
	return "az" if _form() == "lp" else "lp"

func _line_of(id: String) -> String:
	var p := id.trim_prefix("pr_sk_").get_slice("_", 0)
	if p in ["sd", "so"]:
		return "dream"
	if p in ["sf", "nb"]:
		return "fiend"
	return "basic"

func _cols(line := "") -> Array:
	return LINE_COL[line if line != "" else _line_of(_cur_id)]

## ท่าจากตารางคอมโบคู่ ใช้แค่ภาพ  key ไม่มีคำนำ เช่น "z1" แล้วเลือกตามตัวที่ออกหน้า
func _act(key: String, time := 0.4, over := {}) -> void:
	var m: Dictionary = PairCombo.move("pc_" + _form() + "_" + key).duplicate(true)
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

func _sfx(kind: String, at: Vector2, size: float, life := 0.6, line := "", to := Vector2.ZERO, follow: Node2D = null) -> PairSkillFx:
	var cols := _cols(line)
	var n := PairSkillFx.new()
	n.kind = kind
	n.base = cols[0]
	n.accent = cols[1]
	n.size = size * S
	n.life = life
	n.dir = _f()
	n.to = to
	n.position = at
	if follow != null:
		n.follow = follow
		n.offset = at - follow.position
	page.world.add_child(n)
	return n

## ลูกพลังของคู่ (ชนเองแบบ WolfBall)
func _orb(style: String, at: Vector2, vel: Vector2, r: float, dmg: float, pierce: bool, life := 1.2, extra := {}, gravity := 0.0, bounce := 0) -> PairSkillFx.PairOrb:
	var cols := _cols()
	var b := PairSkillFx.PairOrb.new()
	b.style = style
	b.base = cols[0]
	b.accent = cols[1]
	b.position = at
	b.vel = vel
	b.radius = r * S
	b.dmg = dmg
	b.pierce = pierce
	b.life = life
	b.extra = extra
	b.gravity = gravity
	b.bounce = bounce
	page.world.add_child(b)
	return b

## มอนด้านหน้าในวงรี ห่างตัว ahead หน่วย กว้างครึ่ง half หน่วย
func _front(ahead: float, half: float, dmg: float, eff: String, tall := 1.4, extra := {}) -> Array:
	var list := _in_ellipse(hero.position + Vector2(_f() * ahead * U * S, -60.0), half * U, tall * U)
	for m in list:
		_hit(m, dmg, eff, _f(), extra)
	return list

func _side_of(m: Monster, from: Vector2) -> float:
	return signf(_mc(m).x - from.x) if _mc(m).x != from.x else _f()

## มอนในแนวตรงไปทาง f จาก from ยาว length (พิกเซลจริง) สูงครึ่ง half
func _in_line(from: Vector2, f: float, length: float, half: float) -> Array:
	var out := []
	for m in _mons():
		var d := (_mc(m).x - from.x) * f
		if d >= -WalkPage.MONSTER_HIT_R and d <= length + WalkPage.MONSTER_HIT_R and absf(_mc(m).y - from.y) <= half + WalkPage.MONSTER_HIT_R:
			out.append(m)
	return out

## มอนใกล้เส้นจาก a ไป b
func _on_line(a: Vector2, b: Vector2, w: float) -> Array:
	var out := []
	var ab := b - a
	var len2 := maxf(ab.length_squared(), 1.0)
	for m in _mons():
		var t := clampf((_mc(m) - a).dot(ab) / len2, 0.0, 1.0)
		if _mc(m).distance_to(a + ab * t) <= w + WalkPage.MONSTER_HIT_R:
			out.append(m)
	return out

## อีกตัวโผล่มาช่วย ที่ระยะ dx หน่วย (+ คือด้านหน้า) ทำท่า key ของตัวเอง แล้วเรียก fn(partner) ตอน fn_at
func _partner(dx: float, key: String, fn: Callable, fn_at := 0.25, life := 0.9, face := 0.0, ghost := false, hop := 0.0) -> PairSkillFx.PairPartner:
	var p := PairSkillFx.PairPartner.new()
	p.page = page
	p.at = Vector2(clampf(hero.pos.x + _f() * dx, -hero.half_width, hero.half_width), maxf(hero.pos.y, 0.0))
	p.facing = face if face != 0.0 else _f()
	if key != "":
		var m: Dictionary = PairCombo.move("pc_" + _other() + "_" + key).duplicate(true)
		for k in ["auto", "fx", "fx_start", "dive", "dive_forward", "leap", "hover", "turn_around", "drag", "front_hit", "multi", "wide", "sa"]:
			m.erase(k)
		p.move = m
	p.swing_time = maxf(fn_at * 1.6, 0.3)
	p.fn = fn
	p.fn_at = fn_at
	p.life = life
	p.ghost = ghost
	p.hop = hop
	page.world.add_child(p)
	return p

## สายฟ้าจาก a ไป b แล้วโดนมอน m
func _zap(a: Vector2, m: Monster, dmg: float, eff := "light") -> void:
	zaps += 1
	var b := _mc(m)
	var n := _sfx("bolt", a, 40.0, 0.25, "fiend", b - a)
	n.scale = Vector2.ONE
	_hit(m, dmg, eff, _side_of(m, a))

func _hop(k := 0.6) -> void:
	hero.vel.y = Hero.JUMP_VELOCITY * k

## รอตกถึงพื้นแล้วทำ fn (ดิ่งลงเร็วระหว่างรอ)
func _land(fn: Callable) -> void:
	_add({"type": "drift", "mode": "land", "life": 2.5, "fn": fn, "wait": 0.12})

func _hit(m: Monster, dmg: float, eff: String, side: float, extra := {}) -> void:
	# SOMNAMBULIST 60.1 สตั๊นนานขึ้น 50%
	if eff == "stun" and has("pr_sk_so_deep") and not extra.has("stun"):
		var e2 := extra.duplicate()
		e2["stun"] = float(EFF["stun"]["stun"]) * 1.5
		super._hit(m, dmg, eff, side, e2)
		return
	super._hit(m, dmg, eff, side, extra)

# ---------------------------------------------------------------- BASIC
## 1.1 ตีเบาๆ แล้วอีกตัวโผล่หลังช่วยยิง
func _do_tag() -> void:
	_act("z1", 0.28)
	_later(0.1, func() -> void: _front(1.0, 1.0, 10.0, "light"))
	var lapis_helps := _form() == "az"
	_partner(-0.9, "x1" if lapis_helps else "z1", func(p: PairSkillFx.PairPartner) -> void:
		var at := p.world_pos() + Vector2(_f() * 70.0, -85.0)
		if lapis_helps:
			_orb("bubble", at, Vector2(_f() * 1300.0, 0.0), 22.0, 12.0, false, 0.8, {"kb": 0.6, "stun": 0.45})
		else:
			_orb("neon", at, Vector2(_f() * 1000.0, 0.0), 30.0, 12.0, true, 0.6, {"kb": 0.8, "stun": 0.45}), 0.22, 0.7, 0.0, false, 0.25)

## 1.5 ฟอง 3 ลูกเด้งไปตามพื้น
func _do_bubble() -> void:
	_act("x1" if _form() == "lp" else "z2", 0.3)
	for i in 3:
		var k := float(i)
		_later(0.08 + k * 0.12, func() -> void:
			_orb("bubble", hero.position + Vector2(_f() * 70.0, -90.0 - k * 10.0), Vector2(_f() * (520.0 + k * 120.0), -380.0), 34.0, 14.0, false, 1.6, {"kb": 0.5, "stun": 0.6}, 1500.0, 3))

## 5.1 แปะมือกับคู่หู วงแหวนกระแทกรอบตัว
func _do_highfive() -> void:
	_act("z3", 0.34)
	_partner(0.8, "z1", func(_p: PairSkillFx.PairPartner) -> void:
		var c := hero.position + Vector2(_f() * 0.4 * U, -80.0)
		_sfx("burst", c, 90.0, 0.4)
		_sfx("ring", Vector2(c.x, hero.position.y), 3.0 * U, 0.5)
		for m in _in_circle(c, 2.4 * U):
			_hit(m, 26.0, "knock", _side_of(m, c))
		page.shake_left = maxf(page.shake_left, 0.15), 0.2, 0.7, -_f())

## 15.1 พุ่งชน สุดทางสลับตัว ตัวใหม่พุ่งต่อเสยลอย
func _do_relay() -> void:
	_act("dz", 0.4)
	_add({"type": "slide", "life": 0.28, "speed": 15.0, "dmg": 18.0, "eff": "flinch", "node": null, "once_each": true})
	_later(0.32, func() -> void:
		page.pair_swap(false)
		_act("dz", 0.4)
		_add({"type": "slide", "life": 0.26, "speed": 15.0, "dmg": 22.0, "eff": "launch", "node": null, "once_each": true})
		_sfx("burst", hero.position + Vector2(0.0, -70.0), 70.0, 0.35))

## 20.1 ทั้งคู่ประกบกัน กันดาเมจ 3 วิ
func _do_guard() -> void:
	_act("x1" if _form() == "az" else "z1", 0.3, {"lunge": 0.0})
	buffs["guard_all"] = 3.0
	_partner(-0.6, "", Callable(), 0.1, 3.0, _f())
	_sfx("bubble", hero.position + Vector2(0.0, -80.0), 2.0 * U, 3.0, "", Vector2.ZERO, hero)

## 20.2 ปาคู่หูพุ่งไปหน้า ตกพื้นระเบิด
func _do_toss() -> void:
	_act("x4" if _form() == "az" else "x4", 0.4)
	var start := hero.position + Vector2(_f() * 60.0, -100.0)
	var ball := _orb("bubble", start, Vector2(_f() * 900.0, -650.0), 50.0, 14.0, true, 1.4, {"kb": 0.6, "stun": 0.5}, 1700.0, 0)
	ball.style = "neon"
	_later(0.75, func() -> void:
		var at := Vector2(start.x + _f() * 4.2 * U * S, -60.0)
		if is_instance_valid(ball):
			at = Vector2(ball.position.x, -60.0)
			ball.queue_free()
		_sfx("ring", Vector2(at.x, 0.0), 2.6 * U, 0.5)
		_boom(at, 2.0 * U, 1.4 * U, 34.0, "launch", "bolt")
		_partner_land(at))

## คู่หูโผล่ตรงจุดตก ยืนชั่วครู่
func _partner_land(at: Vector2) -> void:
	var p := PairSkillFx.PairPartner.new()
	p.page = page
	p.at = Vector2(clampf(at.x / U, -hero.half_width, hero.half_width), 0.0)
	p.facing = -_f()
	p.life = 0.6
	page.world.add_child(p)

# ---------------------------------------------------------------- SPARK DREAMER
## 15.2 แกะฝัน 3 ตัวเด้งไปหน้า โดนแล้วสตั๊น
func _do_sd_sheep() -> void:
	_act("z2", 0.3)
	for i in 3:
		var k := float(i)
		_later(0.06 + k * 0.18, func() -> void:
			_orb("sheep", hero.position + Vector2(_f() * 80.0, -70.0), Vector2(_f() * 560.0, -520.0), 40.0, 16.0, false, 1.8, {"type": "flinch", "stun": 1.6, "real_stun": true, "kb": 0.3}, 1600.0, 2))

## 15.3 คู่หูร้องเพลงกล่อม มอนในวงสตั๊น
func _do_sd_lullaby() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	_partner(-0.8, "", func(_p: PairSkillFx.PairPartner) -> void:
		var c := hero.position + Vector2(0.0, -80.0)
		_sfx("notes", c, 2.8 * U, 1.0, "", Vector2.ZERO, hero)
		for m in _in_circle(c, 2.6 * U):
			_hit(m, 14.0, "stun", _side_of(m, c))
			_sfx("zzz", _mc(m) + Vector2(0.0, -60.0), 120.0, 1.2), 0.3, 1.2)

## 20.4 ทุบหมอนยักษ์ลงด้านหน้า
func _do_sd_pillow() -> void:
	_act("x4" if _form() == "az" else "z3", 0.38)
	var at := hero.position + Vector2(_f() * 1.5 * U * S, 0.0)
	_sfx("pillow", at, 1.6 * U, 0.7)
	_later(0.2, func() -> void:
		_boom(at + Vector2(0.0, -50.0), 1.6 * U, 1.2 * U, 32.0, "knock", "bolt")
		_sfx("ring", at, 2.4 * U, 0.4))

## 25.1 จันทร์เสี้ยวฝันลอยช้าๆ ทะลุ
func _do_sd_moon() -> void:
	_act("x1" if _form() == "lp" else "z1", 0.3)
	_orb("moon", hero.position + Vector2(_f() * 80.0, -90.0), Vector2(_f() * 420.0, 0.0), 54.0, 20.0, true, 2.2, {"kb": 0.8, "stun": 0.7})

## 25.2 หาวกว้างด้านหน้า ได้มานาคืน
func _do_sd_yawn() -> void:
	_act("z1", 0.4, {"lunge": 0.0, "lean": -14.0})
	_sfx("zzz", hero.position + Vector2(_f() * 60.0, -110.0), 200.0, 1.0)
	_sfx("burst", hero.position + Vector2(_f() * 1.4 * U * S, -80.0), 1.6 * U, 0.45)
	var n := _front(1.4, 1.9, 12.0, "flinch", 1.6).size()
	hero.mp = minf(hero.mp + 12.0 * float(n), hero.mp_max())

## 30.1 หลับตาลอยไปหน้า ไม่โดนดาเมจ
func _do_sd_drift() -> void:
	_act("z1", 0.3, {"lean": 6.0})
	hero.invuln_t = maxf(hero.invuln_t, 1.3)
	_sfx("zzz", hero.position + Vector2(0.0, -120.0), 160.0, 1.2, "", Vector2.ZERO, hero)
	_add({"type": "drift", "mode": "float", "life": 1.2, "speed": 3.6, "tick": 0.3, "tick_t": 0.0, "dmg": 12.0})

## 30.2 ฝนประกายด้านหน้า 2 วิ
func _do_sd_rain() -> void:
	_act("x1" if _form() == "lp" else "z3", 0.3)
	var at := hero.position + Vector2(_f() * 2.4 * U * S, 0.0)
	_sfx("drops", at, 2.2 * U, 2.0)
	_zone(at, 2.2 * U * S, 2.0, 9.0, "light", 0.3, null)

## 35.1 ผ้าห่มฝัน มอนช้า โดนดาเมจ ตัวเองมานาฟื้น
func _do_sd_blanket() -> void:
	_act("x4" if _form() == "az" else "x1", 0.35)
	var at := Vector2(hero.position.x + _f() * 1.2 * U * S, 0.0)
	var node := _sfx("zone", at, 2.6 * U, 5.0)
	_zone(at, 2.6 * U * S, 5.0, 8.0, "light", 0.5, node, {"slow": 1.0, "mana": 18.0})

## เขตบนพื้น ทำดาเมจทุก tick
func _zone(at: Vector2, half: float, life: float, dmg: float, eff: String, tick: float, node: Node2D, o := {}) -> Dictionary:
	var d := {"type": "zone", "pos": at, "half": half, "life": life, "dmg": dmg, "eff": eff, "tick": tick, "tick_t": 0.0, "node": node}
	d.merge(o, true)
	return _add(d)

# ---------------------------------------------------------------- SOMNAMBULIST
## 35.2 ละเมอเดินตีอัตโนมัติ 6 ที สลับตัวระหว่างทาง
func _do_so_walk() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.8)
	_sfx("zzz", hero.position + Vector2(0.0, -120.0), 160.0, 1.7, "", Vector2.ZERO, hero)
	for i in 6:
		var k := i
		_later(0.05 + float(i) * 0.26, func() -> void:
			if k == 2 or k == 4:
				page.pair_swap(false)
			_act(["z1", "z2", "z3", "x1", "x2", "z4"][k], 0.24)
			_add({"type": "slide", "life": 0.12, "speed": 6.0, "node": null})
			var last := k == 5
			_front(1.0, 1.2, 26.0 if last else 14.0, "knock" if last else "flinch"))

## 35.3 ประตูฝัน ดูดแล้วพ่นออก
func _do_so_door() -> void:
	_act("x1", 0.35, {"lunge": 0.0})
	var at := hero.position + Vector2(_f() * 2.4 * U * S, -90.0)
	_sfx("door", at, 1.3 * U, 1.4)
	_add({"type": "pull", "pos": at, "r": 3.4 * U, "speed": 7.0, "life": 0.9})
	_later(0.2, func() -> void:
		for m in _in_circle(at, 1.4 * U):
			_hit(m, 10.0, "light", _side_of(m, at)))
	_later(1.0, func() -> void:
		_sfx("burst", at, 1.4 * U, 0.4)
		for m in _in_circle(at, 1.8 * U):
			_hit(m, 38.0, "launch", _side_of(m, at), {"vy": 12.0}))

## 45.1 หมอน 6 ใบตกทั่วด้านหน้า
func _do_so_pillows() -> void:
	_act("x4" if _form() == "az" else "x1", 0.4)
	for i in 6:
		var k := float(i)
		_later(0.1 + k * 0.16, func() -> void:
			var at := Vector2(hero.position.x + _f() * (1.0 + k * 0.85) * U * S, 0.0)
			_sfx("pillow", at, 1.2 * U, 0.6)
			_later(0.18, func() -> void:
				_boom(at + Vector2(0.0, -50.0), 1.2 * U, 1.1 * U, 26.0, "knock", "bolt")))

## 45.2 ร่างฝันของคู่หูช่วยตี 6 วิ
func _do_so_twin() -> void:
	_act("z1", 0.3, {"lunge": 0.0})
	var p := _partner(-1.0, "", Callable(), 0.1, 6.0, _f(), true)
	_add({"type": "twin", "life": 6.0, "partner": p, "tick": 0.6, "tick_t": 0.3})

## 50.1 คลื่นกรน 3 ระลอก
func _do_so_snore() -> void:
	_act("z1", 0.4, {"lunge": 0.0, "lean": -10.0})
	for i in 3:
		var k := float(i)
		_later(0.1 + k * 0.32, func() -> void:
			var c := hero.position + Vector2(0.0, -70.0)
			_sfx("ring", Vector2(c.x, hero.position.y), (2.0 + k * 0.5) * U, 0.45)
			_sfx("burst", c, (1.2 + k * 0.3) * U, 0.4)
			for m in _in_circle(c, (2.0 + k * 0.5) * U):
				_hit(m, 16.0, "strong", _side_of(m, c)))

## 50.2 ยกมอนลอยเหมือนนอนบนเตียง แล้วทิ้งลง
func _do_so_float() -> void:
	_act("z4", 0.4)
	var hit := _front(1.4, 1.6, 14.0, "launch", 1.6, {"vy": 9.0})
	for m in hit:
		_sfx("zone", Vector2(_mc(m).x, -40.0), 0.9 * U, 0.9)
	_later(0.9, func() -> void:
		for m in hit:
			if is_instance_valid(m) and (m as Monster).state != "dead":
				_hit(m, 30.0, "knock", _f(), {"fly": 2.0})
				_sfx("ring", Vector2(_mc(m).x, 0.0), 1.4 * U, 0.4))

## 55.1 ฟองฝันครอบด้านหน้า ดาเมจต่อเนื่อง ปิดท้ายระเบิด
func _do_so_nightmare() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	_act("x1", 0.4, {"lunge": 0.0})
	var c := hero.position + Vector2(_f() * 2.6 * U * S, -100.0)
	_sfx("bubble", c, 2.6 * U, 2.2)
	_area("circle", "ice", c, 2.4 * U, 1.8, 12.0, "light", {"tick": 0.3})
	_later(1.9, func() -> void:
		_boom(c, 2.6 * U, 2.0 * U, 70.0, "knock", "ice")
		_sfx("burst", c, 2.0 * U, 0.5))

# ---------------------------------------------------------------- SPARK FIEND
## 15.2 สายฟ้าสั้น กระโดดต่ออีก 2 ตัว
func _do_sf_zap() -> void:
	_act("z1", 0.28)
	var from := hero.position + Vector2(_f() * 70.0, -85.0)
	var first := _nearest(hero.position + Vector2(_f() * 2.0 * U * S, -60.0), 2.6 * U * S)
	if first == null:
		_sfx("bolt", from, 40.0, 0.25, "", Vector2(_f() * 2.4 * U * S, 0.0))
		return
	var done := [first]
	_zap(from, first, 18.0, "flinch")
	var cur := first
	for i in 2:
		var nx := _nearest(_mc(cur), 2.6 * U * S, done)
		if nx == null:
			break
		_zap(_mc(cur), nx, 12.0)
		done.append(nx)
		cur = nx

## 15.3 ลูกไฟฟ้าลอยช้า ช็อตรอบๆ
func _do_sf_ball() -> void:
	_act("x1" if _form() == "lp" else "z1", 0.3)
	var b := _orb("spark", hero.position + Vector2(_f() * 80.0, -90.0), Vector2(_f() * 300.0, 0.0), 40.0, 10.0, true, 3.0, {"kb": 0.3, "stun": 0.4})
	_add({"type": "coil", "life": 3.0, "node": b, "tick": 0.5, "tick_t": 0.2, "range": 1.8 * U * S, "dmg": 9.0, "pos": b.position})

## 20.4 พุ่งทะลุเป็นเส้นไฟฟ้า สุดทางสลับตัว
func _do_sf_rush() -> void:
	var from := hero.position + Vector2(0.0, -70.0)
	_act("dz", 0.36)
	_add({"type": "slide", "life": 0.26, "speed": 18.0, "dmg": 20.0, "eff": "flinch", "node": null, "once_each": true})
	_later(0.27, func() -> void:
		_sfx("bolt", from, 40.0, 0.3, "", hero.position + Vector2(0.0, -70.0) - from)
		page.pair_swap(false))

## 25.1 เสาไฟฟ้าช็อตมอนใกล้สุด 5 วิ
func _do_sf_coil() -> void:
	_act("x4" if _form() == "az" else "x1", 0.3)
	var at := Vector2(hero.position.x + _f() * 0.9 * U * S, 0.0)
	var node := _sfx("coil", at, 1.3 * U, 5.0)
	_add({"type": "coil", "life": 5.0, "node": node, "tick": 0.5, "tick_t": 0.2, "range": 4.0 * U * S, "dmg": 11.0, "pos": at + Vector2(0.0, -1.3 * U * S), "single": true})

## 25.2 หางไฟฟ้าหมุนรอบตัว
func _do_sf_tail() -> void:
	_act("z3", 0.36, {"spin": 360.0})
	var c := hero.position + Vector2(0.0, -60.0)
	_sfx("ring", Vector2(c.x, hero.position.y), 2.2 * U, 0.4)
	_sfx("burst", c, 1.5 * U, 0.35)
	for m in _in_circle(c, 2.0 * U):
		_hit(m, 22.0, "strong", _side_of(m, c))

## 30.1 ดิ่งลง ฟ้าผ่าจุดที่ตก
func _do_sf_drop() -> void:
	_act("az", 0.4)
	if hero.on_floor():
		_hop(0.6)
	_land(func() -> void:
		var at := Vector2(hero.position.x + _f() * 0.5 * U * S, 0.0)
		_sfx("column", at, 1.0 * U, 0.45)
		_boom(at + Vector2(0.0, -60.0), 1.6 * U, 1.4 * U, 34.0, "launch", "bolt"))

## 30.2 เส้นไฟฟ้าต่อระหว่างคู่ ช็อตต่อเนื่อง
func _do_sf_circuit() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	var p := _partner(3.4 * S, "", Callable(), 0.1, 1.9, -_f())
	var node := _sfx("bolt", hero.position + Vector2(0.0, -80.0), 36.0, 1.8)
	_add({"type": "circuit", "life": 1.7, "partner": p, "node": node, "tick": 0.25, "tick_t": 0.1, "dmg": 9.0})

## 35.1 ชาร์จไฟ 10 วิ ตีไว ตีคอมโบช็อต
func _do_sf_overcharge() -> void:
	_act("z1", 0.3, {"lunge": 0.0})
	buffs["overcharge"] = 10.0
	_sfx("burst", hero.position + Vector2(0.0, -80.0), 1.4 * U, 0.5)
	_sfx("ring", hero.position, 2.0 * U, 0.5)

# ---------------------------------------------------------------- NEON BOLT
## 35.2 พุ่งเส้นนีออน 4 ช่วงตัว
func _do_nb_dash() -> void:
	var from := hero.position + Vector2(0.0, -70.0)
	_act("dz", 0.3)
	hero.invuln_t = maxf(hero.invuln_t, 0.35)
	var dist := 4.0 * S
	var to_x := clampf(hero.pos.x + _f() * dist, -hero.half_width, hero.half_width)
	var hit := _in_line(from, _f(), absf(to_x - hero.pos.x) * U, 1.0 * U * S)
	hero.pos.x = to_x
	hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
	_sfx("line", from, 50.0, 0.4, "", hero.position + Vector2(0.0, -70.0) - from)
	for m in hit:
		_hit(m, 30.0, "strong", _f())

## 35.3 ทั้งคู่พุ่งสวนกันเป็นกากบาท
func _do_nb_cross() -> void:
	_act("dz", 0.34)
	var c := hero.position + Vector2(_f() * 2.0 * U * S, -90.0)
	_partner(4.0 * S, "dz", Callable(), 0.1, 0.5, -_f())
	_later(0.15, func() -> void:
		_sfx("cross", c, 1.6 * U, 0.55)
		for m in _in_circle(c, 1.9 * U):
			_hit(m, 36.0, "launch", _side_of(m, c), {"vy": 11.0}))

## 45.1 แท่งนีออน 3 แท่งตกทีละแท่ง
func _do_nb_grid() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	for i in 3:
		var k := float(i)
		_later(0.1 + k * 0.2, func() -> void:
			var at := Vector2(hero.position.x + _f() * (1.2 + k * 1.3) * U * S, 0.0)
			_sfx("bar", at, 0.9 * U, 0.6)
			_later(0.15, func() -> void:
				_boom(at + Vector2(0.0, -70.0), 0.9 * U, 1.6 * U, 30.0, "launch", "bolt")))

## 45.2 ลำแสงนีออนยาวทะลุทั้งแนว (AZURE เรียก LAPIS มายิง)
func _do_nb_rail() -> void:
	if _form() == "lp":
		_act("x4", 0.4)
		_later(0.12, func() -> void: _rail(hero.position + Vector2(_f() * 70.0, -85.0)))
	else:
		_act("x1", 0.3, {"lunge": 0.0})
		_partner(-0.8, "x4", func(p: PairSkillFx.PairPartner) -> void:
			_rail(p.world_pos() + Vector2(_f() * 70.0, -85.0)), 0.25, 0.8)

func _rail(from: Vector2) -> void:
	var length := 9.0 * U * S
	_sfx("beam", from, 60.0, 0.45, "", Vector2(_f() * length, 0.0))
	for m in _in_line(from, _f(), length, 0.7 * U * S):
		_hit(m, 46.0, "strong", _f())
	page.shake_left = maxf(page.shake_left, 0.12)

## 50.1 สายฟ้านีออน 8 สายผ่ามอนรอบตัว
func _do_nb_storm() -> void:
	_act("x1", 0.35, {"lunge": 0.0})
	for i in 8:
		var k := float(i)
		_later(0.1 + k * 0.18, func() -> void:
			var list := _in_circle(hero.position + Vector2(0.0, -60.0), 4.0 * U)
			var at := Vector2(hero.position.x + _f() * randf_range(0.8, 3.0) * U * S, 0.0)
			if not list.is_empty():
				var m: Monster = list[randi() % list.size()]
				at = Vector2(_mc(m).x, 0.0)
			_sfx("column", at, 0.7 * U, 0.35)
			for m2 in _in_ellipse(at + Vector2(0.0, -60.0), 0.8 * U, 1.6 * U):
				_hit(m2, 18.0, "flinch", _side_of(m2, at)))

## 50.2 สลับตัวรัว 4 ครั้ง พุ่งฟันผ่านมอนใกล้สุด
func _do_nb_relay() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 1.0)
	for i in 4:
		_later(0.05 + float(i) * 0.22, func() -> void:
			var from := hero.position + Vector2(0.0, -70.0)
			var m := _nearest(from, 5.0 * U * S)
			var face := _f()
			var nx := hero.pos.x + face * 1.5
			if m != null:
				face = _side_of(m, from)
				nx = m.pos.x + face * 1.0
			nx = clampf(nx, -hero.half_width, hero.half_width)
			page.pair_swap(false, Vector2(nx, 0.0), face)
			_act("dz", 0.2)
			_sfx("line", from, 44.0, 0.3, "", hero.position + Vector2(0.0, -70.0) - from)
			for t in _on_line(from, hero.position + Vector2(0.0, -70.0), 0.6 * U * S):
				_hit(t, 26.0, "flinch", face))

## 55.1 โหมดนีออน 6 วิ V ไม่มีคูลดาวน์ สลับแล้วระเบิด
func _do_nb_overdrive() -> void:
	_act("z1", 0.35, {"lunge": 0.0})
	buffs["overdrive"] = 6.0
	page.pair_swap_cd = 0.0
	page.pad.pair_swap_cd = 0.0
	_sfx("burst", hero.position + Vector2(0.0, -80.0), 2.0 * U, 0.6)
	_sfx("ring", hero.position, 3.0 * U, 0.6)
	for m in _in_circle(hero.position + Vector2(0.0, -60.0), 2.4 * U):
		_hit(m, 40.0, "knock", _side_of(m, hero.position))

# ---------------------------------------------------------------- สลับตัว
## เรียกจาก WalkPage.pair_swap ทุกครั้งที่สลับตัว (manual = กดปุ่ม V เอง)
func on_swap(manual: bool) -> void:
	swaps += 1
	if has("pr_sk_link"):
		buffs["link"] = LINK_TIME
	if manual and has("pr_sk_quick") and page.pair_swap_cd > QUICK_CD:
		page.pair_swap_cd = QUICK_CD
		page.pad.pair_swap_cd = QUICK_CD
	if buffs.has("overdrive"):
		page.pair_swap_cd = 0.0
		page.pad.pair_swap_cd = 0.0
	var c := hero.position + Vector2(0.0, -60.0)
	if has("pr_sk_quick") and manual:
		for m in _in_circle(c, 1.4 * U):
			_hit(m, 0.0, "light", _side_of(m, c))
	if has("pr_sk_nb_trail") or buffs.has("overdrive"):
		_cur_id = "pr_sk_nb_trail"
		_sfx("ring", hero.position, 2.0 * U, 0.4, "fiend")
		for m in _in_circle(c, 1.8 * U):
			_hit(m, 24.0 if buffs.has("overdrive") else 14.0, "flinch", _side_of(m, c))
	if has("pr_sk_so_awake") and awake_cd <= 0.0:
		awake_cd = AWAKE_CD
		free_skill = true

# ---------------------------------------------------------------- ชิ้นสกิลของคู่
func _tick_obj(o: Dictionary, delta: float) -> void:
	var t: String = o["type"]
	if t in MY_OBJS:
		o["age"] = float(o["age"]) + delta
		o["life"] = float(o["life"]) - delta
		_tick_pair_obj(o, delta, t)
		return
	super._tick_obj(o, delta)

func _tick_pair_obj(o: Dictionary, delta: float, t: String) -> void:
	match t:
		"zone":
			var at: Vector2 = o["pos"]
			var half := float(o["half"])
			o["tick_t"] = float(o["tick_t"]) - delta
			var inside := []
			for m in _mons():
				if absf(m.position.x - at.x) <= half + WalkPage.MONSTER_HIT_R and m.pos.y < 2.5:
					inside.append(m)
			if float(o["tick_t"]) <= 0.0:
				o["tick_t"] = float(o["tick"])
				for m in inside:
					var ex := {}
					if o.has("slow"):
						ex["slow"] = float(o["slow"])
					_hit(m, float(o["dmg"]), str(o["eff"]), _side_of(m, at), ex)
			if o.has("mana") and absf(hero.position.x - at.x) < half and hero.pos.y < 1.0:
				hero.mp = minf(hero.mp + float(o["mana"]) * delta, hero.mp_max())
		"coil":
			var node: Node2D = o.get("node")
			if is_instance_valid(node):
				o["pos"] = node.position if not o.get("single", false) else o["pos"]
			o["tick_t"] = float(o["tick_t"]) - delta
			if float(o["tick_t"]) <= 0.0:
				o["tick_t"] = float(o["tick"])
				var from: Vector2 = o["pos"]
				if o.get("single", false):
					var m := _nearest(from, float(o["range"]))
					if m != null:
						_zap(from, m, float(o["dmg"]))
				else:
					for m in _in_circle(from, float(o["range"]) / GROW):
						_zap(from, m, float(o["dmg"]))
		"twin":
			var p: PairSkillFx.PairPartner = o.get("partner")
			if not is_instance_valid(p) or not is_instance_valid(p.actor):
				_objs.erase(o)
				return
			var a := p.actor
			var target := _nearest(a.position + Vector2(0.0, -60.0), 6.0 * U)
			if target != null:
				var want := target.pos.x - signf(target.pos.x - a.pos.x) * 1.0
				a.facing = signf(target.pos.x - a.pos.x) if target.pos.x != a.pos.x else a.facing
				a.pos.x = move_toward(a.pos.x, clampf(want, -hero.half_width, hero.half_width), 7.0 * delta)
				a.position.x = a.pos.x * U
			o["tick_t"] = float(o["tick_t"]) - delta
			if float(o["tick_t"]) <= 0.0 and target != null and absf(target.pos.x - a.pos.x) < 1.8:
				o["tick_t"] = float(o["tick"])
				var mv: Dictionary = PairCombo.move("pc_" + _other() + "_z" + str(1 + randi() % 3)).duplicate(true)
				a.plain_move = mv
				a.plain_swing_kind = "combo"
				a.plain_combo_id += 1
				a.plain_swing = 0.001
				var tw := page.create_tween()
				tw.tween_property(a, "plain_swing", 1.0, 0.3)
				_cur_id = "pr_sk_so_twin"
				var c := a.position + Vector2(a.facing * 0.8 * U * S, -60.0)
				_sfx("burst", c, 60.0, 0.3)
				for m in _in_circle(c, 1.0 * U):
					_hit(m, 16.0, "flinch", a.facing)
		"circuit":
			var p2: PairSkillFx.PairPartner = o.get("partner")
			var node2: PairSkillFx = o.get("node")
			if not is_instance_valid(p2):
				_end(o)
				return
			var a2 := hero.position + Vector2(0.0, -80.0)
			var b2 := p2.world_pos() + Vector2(0.0, -80.0)
			if is_instance_valid(node2):
				node2.position = a2
				node2.to = b2 - a2
			o["tick_t"] = float(o["tick_t"]) - delta
			if float(o["tick_t"]) <= 0.0:
				o["tick_t"] = float(o["tick"])
				for m in _on_line(a2, b2, 0.6 * U * S):
					_hit(m, float(o["dmg"]), "light", _side_of(m, a2))
					zaps += 1
		"drift":
			if str(o["mode"]) == "land":
				o["wait"] = float(o["wait"]) - delta
				if float(o["wait"]) <= 0.0 and not hero.on_floor():
					hero.vel.y = minf(hero.vel.y, -Hero.CHIBI_DIVE_SPEED * 0.9)
				if float(o["wait"]) <= 0.0 and hero.on_floor():
					_objs.erase(o)
					(o["fn"] as Callable).call()
					return
			else:
				# ลอยละเมอไปหน้า ไม่ตก ชนมอนผลัก
				hero.vel.y = maxf(hero.vel.y, 0.0) * 0.0
				hero.pos.x = clampf(hero.pos.x + _f() * float(o["speed"]) * S * delta, -hero.half_width, hero.half_width)
				hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
				o["tick_t"] = float(o["tick_t"]) - delta
				if float(o["tick_t"]) <= 0.0:
					o["tick_t"] = float(o["tick"])
					for m in _in_circle(hero.position + Vector2(_f() * 0.6 * U, -60.0), 1.0 * U):
						_hit(m, float(o["dmg"]), "flinch", _f())
	if float(o["life"]) <= 0.0:
		if t == "drift" and str(o.get("mode", "")) == "land":
			_objs.erase(o)
			return
		_end(o)

# ---------------------------------------------------------------- พาสซีฟ
func _process(delta: float) -> void:
	super._process(delta)
	if page == null:
		return
	guard_cd = maxf(guard_cd - delta, 0.0)
	awake_cd = maxf(awake_cd - delta, 0.0)
	if hero.on_floor() and absf(hero.vel.x) < 0.1 and hero.plain_swing <= 0.0:
		_still += delta
	else:
		_still = 0.0

func _apply_passives(delta: float) -> void:
	var mpb := 0.0
	if has("pr_sk_so_deep"):
		mpb += 100.0
	if has("pr_sk_sf_volt"):
		mpb += 100.0
	hero.mp_bonus = mpb
	hero.hp_bonus = 0.0
	hero.regen_mult = 1.0
	hero.speed_bonus = Stats.SPEED_MULT if has("pr_sk_sf_volt") else 1.0
	page.atk_speed = 1.15 if buffs.has("overcharge") else 1.0
	hero.block_chance = 0.15 if has("pr_sk_nb_after") else 0.0
	var g := float(buffs.get("guard_all", 0.0))
	hero.ranged_guard_t = g
	hero.melee_guard_t = g
	# DREAMER 15.4 ยืนนิ่งฟื้นเลือด
	if has("pr_sk_sd_nap") and _still >= NAP_WAIT:
		hero.hp = minf(hero.hp + hero.hp_max() * 0.01 * delta, hero.hp_max())

func dmg_mult(m: Monster, _h: Dictionary) -> float:
	var k := 1.0
	if buffs.has("link"):
		k *= 1.2
	if has("pr_sk_sd_dream") and m.state == "stun":
		k *= 1.25
	if has("pr_sk_nb_soul"):
		k *= 1.2
	return k

func on_strike(m: Monster, h: Dictionary) -> void:
	# เฉพาะตอนตีคอมโบ (ท่าคอมโบก็ส่ง skill=true มาจาก _hit_area จึงดูจาก combo_nth แทน)
	if page.combo_nth < 0 or h.get("pair_zap", false):
		return
	# FIEND 15.4 / 35.1 ตีคอมโบช็อตไฟฟ้าเพิ่ม
	var chance := 1.0 if buffs.has("overcharge") else (0.15 if has("pr_sk_sf_static") else 0.0)
	if chance > 0.0 and randf() < chance:
		zaps += 1
		var c := _mc(m)
		var n := PairSkillFx.new()
		n.kind = "burst"
		n.base = LINE_COL["fiend"][0]
		n.accent = LINE_COL["fiend"][1]
		n.size = 50.0
		n.life = 0.25
		n.position = c
		page.world.add_child(n)
		page._strike(m, {"dmg": 6.0, "skill": true, "pair_zap": true, "type": "flinch", "stun": 0.2, "kb": 0.2}, _side_of(m, hero.position))

func mod_shot(_shot: Array) -> void:
	pass

func _on_hurt(_kind: String) -> void:
	# SOMNAMBULIST 35.4 เลือดต่ำโดนตี หลับกันดาเมจ ฟื้นเลือด
	if has("pr_sk_so_sleepguard") and guard_cd <= 0.0 and hero.hp > 0.0 and hero.hp < hero.hp_max() * 0.4:
		guard_cd = GUARD_CD
		guarded += 1
		hero.invuln_t = maxf(hero.invuln_t, 1.0)
		hero.hp = minf(hero.hp + hero.hp_max() * 0.15, hero.hp_max())
		_cur_id = "pr_sk_so_sleepguard"
		_sfx("zzz", hero.position + Vector2(0.0, -120.0), 160.0, 1.0, "dream", Vector2.ZERO, hero)
		page.bars.notice("หลับปุ๊บ ฟื้นปั๊บ")
