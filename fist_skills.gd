class_name FistSkills
extends SpearSkills
## สกิลของ CAT ASH (หมัดกับเท้า) id ขึ้นต้น fs_sk_
## ต่อยอดจาก SpearSkills (ซึ่งต่อยอดจาก SusiSkills) ใช้ชิ้นสกิล land zone mover slide ร่วมกัน แต่ใช้ตาราง มานา คูลดาวน์ พาสซีฟของตัวเอง
## สาย: hw_ HEAVYWEIGHT  gs_ GRAND SUMO  zp_ ZEPHYR  kf_ KUNG FU
##       wm_ WAR MUAY  mt_ MUAY THAI  sy_ SYSTEMA GRAPPLER  sb_ SAMBO
## สีหลักเทาของ ASH แซมสีเดียวต่อสาย (ร่างใหญ่ส้มแดง ลมเขียวฟ้า มวยทอง ปล้ำฟ้าคราม) ทรงมนทั้งหมด ไม่มีดาว

## cd คูลดาวน์  air ใช้กลางอากาศได้  hold กดค้าง  charge กดค้างชาร์จแล้วปล่อย
const FIST_DEFS := {
	"fs_sk_palm": {"cd": 2.5, "air": true},
	"fs_sk_slam": {"cd": 12.0, "air": true},
	"fs_sk_combo": {"cd": 7.0},
	"fs_sk_flurry": {"cd": 9.0},
	"fs_sk_whirl": {"cd": 14.0},
	"fs_sk_counter": {"cd": 6.0},
	"fs_sk_hw_bash": {"cd": 6.0},
	"fs_sk_hw_stomp": {"cd": 8.0},
	"fs_sk_hw_iron": {"cd": 25.0},
	"fs_sk_hw_toss": {"cd": 8.0},
	"fs_sk_hw_charge": {"cd": 9.0, "charge": true},
	"fs_sk_hw_drop": {"cd": 6.0, "air": true},
	"fs_sk_hw_clap": {"cd": 12.0},
	"fs_sk_gs_shiko": {"cd": 16.0},
	"fs_sk_gs_push": {"cd": 10.0},
	"fs_sk_gs_salt": {"cd": 20.0},
	"fs_sk_gs_throw": {"cd": 12.0},
	"fs_sk_gs_ring": {"cd": 28.0},
	"fs_sk_gs_yokozuna": {"cd": 22.0},
	"fs_sk_zp_gust": {"cd": 4.0, "air": true},
	"fs_sk_zp_crane": {"cd": 6.0},
	"fs_sk_zp_step": {"cd": 4.0, "air": true},
	"fs_sk_zp_cyclone": {"cd": 10.0, "hold": true},
	"fs_sk_zp_rise": {"cd": 9.0},
	"fs_sk_zp_feather": {"cd": 7.0, "air": true},
	"fs_sk_zp_vortex": {"cd": 14.0},
	"fs_sk_kf_dragon": {"cd": 10.0},
	"fs_sk_kf_mantis": {"cd": 9.0},
	"fs_sk_kf_palm8": {"cd": 14.0},
	"fs_sk_kf_tiger": {"cd": 10.0},
	"fs_sk_kf_phoenix": {"cd": 10.0, "air": true},
	"fs_sk_kf_master": {"cd": 22.0},
	"fs_sk_wm_teep": {"cd": 4.0},
	"fs_sk_wm_elbow": {"cd": 6.0},
	"fs_sk_wm_clinch": {"cd": 8.0},
	"fs_sk_wm_war": {"cd": 30.0},
	"fs_sk_wm_flykick": {"cd": 8.0},
	"fs_sk_wm_combo": {"cd": 9.0},
	"fs_sk_wm_low": {"cd": 10.0},
	"fs_sk_mt_skyknee": {"cd": 10.0},
	"fs_sk_mt_cobra": {"cd": 8.0},
	"fs_sk_mt_storm": {"cd": 12.0},
	"fs_sk_mt_hanuman": {"cd": 10.0, "air": true},
	"fs_sk_mt_mongkol": {"cd": 35.0},
	"fs_sk_mt_erawan": {"cd": 22.0},
	"fs_sk_sy_slip": {"cd": 5.0},
	"fs_sk_sy_wave": {"cd": 7.0},
	"fs_sk_sy_lock": {"cd": 9.0},
	"fs_sk_sy_breath": {"cd": 30.0},
	"fs_sk_sy_strike": {"cd": 10.0},
	"fs_sk_sy_roll": {"cd": 6.0, "air": true},
	"fs_sk_sy_spiral": {"cd": 10.0},
	"fs_sk_sb_suplex": {"cd": 10.0},
	"fs_sk_sb_leglock": {"cd": 10.0},
	"fs_sk_sb_chain": {"cd": 14.0},
	"fs_sk_sb_bear": {"cd": 10.0, "hold": true},
	"fs_sk_sb_tank": {"cd": 16.0},
	"fs_sk_sb_avalanche": {"cd": 22.0},
}
const FIST_MP := {
	"fs_sk_palm": 30.0,
	"fs_sk_slam": 160.0,
	"fs_sk_combo": 90.0,
	"fs_sk_flurry": 140.0,
	"fs_sk_whirl": 220.0,
	"fs_sk_counter": 50.0,
	"fs_sk_hw_bash": 70.0,
	"fs_sk_hw_stomp": 100.0,
	"fs_sk_hw_iron": 100.0,
	"fs_sk_hw_toss": 110.0,
	"fs_sk_hw_charge": 130.0,
	"fs_sk_hw_drop": 80.0,
	"fs_sk_hw_clap": 130.0,
	"fs_sk_gs_shiko": 220.0,
	"fs_sk_gs_push": 160.0,
	"fs_sk_gs_salt": 120.0,
	"fs_sk_gs_throw": 180.0,
	"fs_sk_gs_ring": 200.0,
	"fs_sk_gs_yokozuna": 300.0,
	"fs_sk_zp_gust": 60.0,
	"fs_sk_zp_crane": 70.0,
	"fs_sk_zp_step": 50.0,
	"fs_sk_zp_cyclone": 80.0,
	"fs_sk_zp_rise": 120.0,
	"fs_sk_zp_feather": 90.0,
	"fs_sk_zp_vortex": 110.0,
	"fs_sk_kf_dragon": 180.0,
	"fs_sk_kf_mantis": 140.0,
	"fs_sk_kf_palm8": 200.0,
	"fs_sk_kf_tiger": 160.0,
	"fs_sk_kf_phoenix": 180.0,
	"fs_sk_kf_master": 300.0,
	"fs_sk_wm_teep": 50.0,
	"fs_sk_wm_elbow": 70.0,
	"fs_sk_wm_clinch": 100.0,
	"fs_sk_wm_war": 100.0,
	"fs_sk_wm_flykick": 120.0,
	"fs_sk_wm_combo": 110.0,
	"fs_sk_wm_low": 120.0,
	"fs_sk_mt_skyknee": 180.0,
	"fs_sk_mt_cobra": 160.0,
	"fs_sk_mt_storm": 200.0,
	"fs_sk_mt_hanuman": 170.0,
	"fs_sk_mt_mongkol": 200.0,
	"fs_sk_mt_erawan": 300.0,
	"fs_sk_sy_slip": 60.0,
	"fs_sk_sy_wave": 70.0,
	"fs_sk_sy_lock": 90.0,
	"fs_sk_sy_breath": 70.0,
	"fs_sk_sy_strike": 110.0,
	"fs_sk_sy_roll": 60.0,
	"fs_sk_sy_spiral": 130.0,
	"fs_sk_sb_suplex": 180.0,
	"fs_sk_sb_leglock": 140.0,
	"fs_sk_sb_chain": 200.0,
	"fs_sk_sb_bear": 60.0,
	"fs_sk_sb_tank": 220.0,
	"fs_sk_sb_avalanche": 300.0,
}

const ASH := Color(0.66, 0.66, 0.72)
## สีแซมของแต่ละสาย กับชุดสีของ SusiFx ที่ใช้คู่กัน
const FIST_ACCENT := {
	"base": [Color(0.97, 0.97, 1.0), "silver"],
	"heavy": [Color(1.0, 0.5, 0.38), "fire"],
	"wind": [Color(0.5, 0.88, 0.8), "leaf"],
	"muay": [Color(1.0, 0.8, 0.3), "sun"],
	"grip": [Color(0.5, 0.62, 1.0), "mana"],
}
const COUNTER_TIME := 1.2       # 20.2 ตั้งท่ารับ
const IRON_TIME := 6.0          # hw 15.5
const WAR_TIME := 15.0          # wm 25.1 ไหว้ครู ดาเมจ +20%
const MONGKOL_TIME := 10.0      # mt 50.1 มงคล ดาเมจ +25% ฟื้นเลือด
const RING_ZONE_TIME := 8.0     # gs 50.1 วงเวทีซูโม่
const GRIT_CD := 120.0          # sb 60.2 ไม่ตาย
const ECHO_CHANCE := 0.2        # kf 60.2 ฝ่ามือลมซ้ำ
const MT_CRIT := 0.2            # mt 35.4

var grit_cd := 0.0
var counters := 0               # นับไว้ใช้ในเทสต์
var throws := 0
var echoes := 0
var _ring_zone := {}            # วงเวทีซูโม่ {x half}
var _echo_ms := 0

# ---------------------------------------------------------------- ข้อมูล
func cost(id: String) -> float:
	return Stats.skill_mp("fist", id)

func cooldown(id: String) -> float:
	var cd := float(FIST_DEFS.get(id, {}).get("cd", 3.0))
	# KUNG FU 60.1 สมาธิ คูลดาวน์ลดลง 15%
	if has("fs_sk_kf_focus"):
		cd *= 0.85
	return cd

func _line_key(id: String) -> String:
	var p := id.trim_prefix("fs_sk_").get_slice("_", 0)
	if p in ["hw", "gs"]:
		return "heavy"
	if p in ["zp", "kf"]:
		return "wind"
	if p in ["wm", "mt"]:
		return "muay"
	if p in ["sy", "sb"]:
		return "grip"
	return "base"

func _el() -> String:
	return str(FIST_ACCENT[_line_key(_cur_id)][1])

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	var d: Dictionary = FIST_DEFS.get(id, {})
	if d.is_empty():
		return
	if page.combo_nth >= 0 or hero.hurt_t > 0.0:
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
	call("_do_" + id.trim_prefix("fs_sk_"))

# ---------------------------------------------------------------- ตัวช่วย
## ท่าจากตารางคอมโบหมัด ใช้แค่ภาพ ไม่ทำดาเมจเอง
func _act(move_id: String, time := 0.4, over := {}) -> void:
	var m: Dictionary = FistCombo.move(move_id).duplicate(true)
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

## เอฟเฟกต์ทรงมน สีเทาแซมสีของสาย
func _afx(kind: String, at: Vector2, size: float, life := 0.6, follow: Node2D = null) -> SpearSkillFx:
	var n := SpearSkillFx.new()
	n.kind = kind
	n.base = ASH
	n.accent = FIST_ACCENT[_line_key(_cur_id)][0]
	n.size = size
	n.life = life
	n.dir = _f()
	n.position = at
	if follow != null:
		n.follow = follow
		n.offset = at - follow.position
	page.world.add_child(n)
	return n

## เอฟเฟกต์หมัด/เท้าของคอมโบ (jab hook upper kick round spin axe knee dash dive sweep)
func _hitfx(kind: String) -> void:
	FistFx.cast(page, "fs_" + kind)

## จุดกลางลำตัวด้านหน้า
func _ahead(units: float, up := 60.0) -> Vector2:
	return hero.position + Vector2(_f() * units * U, -up)

## ฝ่ามือลมกลม พุ่งไปด้านหน้า
func _palm_shot(speed: float, r: float, dmg: float, eff: String, o := {}) -> Dictionary:
	var d := _proj("wind", _el(), _ahead(0.8, 75.0), Vector2(_f() * speed, 0.0), r, dmg, eff, o)
	return d

## พุ่งตัวไปข้างหน้า ชนมอน (once_each) หรือรัวเป็นจังหวะ (beats)
func _dash(speed: float, life: float, dmg: float, eff: String, o := {}) -> Dictionary:
	var d := {"type": "slide", "life": life, "speed": speed, "dmg": dmg, "eff": eff, "node": null}
	d.merge(o, true)
	if not d.has("beats"):
		d["once_each"] = true
	return _add(d)

## ต่อยรัว n ที ห่างกัน gap วิ ฮิตท้ายเป็น last
func _flurry(n: int, gap: float, dmg: float, last_dmg: float, last: String, ahead := 1.2, half := 1.3, fx := "jab") -> void:
	for i in n:
		var is_last := i == n - 1
		_later(0.06 + float(i) * gap, func() -> void:
			if i % 2 == 0:
				_hitfx(fx if not is_last else "hook")
			_front(ahead, half, last_dmg if is_last else dmg, last if is_last else "light", 1.3))

## มอนที่คว้าได้ด้านหน้า ใกล้สุด ไม่เกิน reach หน่วย
func _grab(reach := 1.8) -> Monster:
	var best: Monster = null
	var bd := INF
	for m in _mons():
		var dx: float = (m.position.x - hero.position.x) * _f()
		if dx < -0.4 * U or dx > reach * U or absf(_mc(m).y - (hero.position.y - 60.0)) > 1.6 * U:
			continue
		if absf(dx) < bd:
			bd = absf(dx)
			best = m
	return best

## ทุ่มมอนข้ามหัวไปด้านหลัง กระแทกพื้น
func _throw(m: Monster, dmg: float, boom := 0.0) -> void:
	if m == null or not is_instance_valid(m):
		return
	throws += 1
	var k := 1.25 if has("fs_sk_sb_iron") else 1.0
	_hit(m, dmg * 0.3 * k, "launch", _f())
	_later(0.22, func() -> void:
		if not is_instance_valid(m) or m.state == "dead":
			return
		if not ROLES_HEAVY(m):
			m.pos.x = clampf(hero.pos.x - _f() * 1.1, -m.half_width, m.half_width)
		_hit(m, dmg * 0.7 * k, "knock", -_f())
		var at := Vector2(m.position.x, 0.0)
		_afx("ring", at, 1.3 * U, 0.45)
		if boom > 0.0:
			_boom(at + Vector2(0.0, -40.0), boom * U, boom * 0.55 * U, dmg * 0.4 * k, "flinch", _el())
		page.shake_left = maxf(page.shake_left, 0.22))

## วาปไปตำแหน่ง x มีควันกลมสีเทา
func _blink(x: float) -> void:
	var from := hero.position
	hero.pos.x = clampf(x, -hero.half_width, hero.half_width)
	hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
	_fx("poof", "silver", from + Vector2(0.0, -70.0), 60.0, 0.4)
	_fx("poof", "silver", hero.position + Vector2(0.0, -70.0), 60.0, 0.4)

## กดค้างชาร์จ ปล่อยแล้วเรียก fn(k)
func _charge_up(max_t: float, fn: Callable) -> void:
	_charge = {"t": 0.0, "max": max_t, "fn": fn, "fx": _afx("aura", hero.position, 70.0, max_t + 1.0, hero)}

## ทุบพื้นวงคลื่น
func _quake_at(at: Vector2, w: float, dmg: float, eff: String) -> void:
	_boom(at + Vector2(0.0, -40.0), w * U, w * 0.5 * U, dmg, eff, _el())
	_afx("ring", at, w * U, 0.5)
	for i in 6:
		_fx("poof", "silver", at + Vector2(randf_range(-w, w) * 0.7 * U, randf_range(-0.6, -0.1) * U), 22.0 + randf() * 14.0, 0.45)

# ---------------------------------------------------------------- BASIC
## 1.1 ฝ่ามือลมกลมเล็ก พุ่งไปหน้า ชะงัก
func _do_palm() -> void:
	_act("fs_z1", 0.3, {"name": "ผลักฝ่ามือ"})
	_hitfx("jab")
	_later(0.08, func() -> void: _palm_shot(1000.0, 0.4 * U, 14.0, "flinch", {"life": 0.8}))

## 1.5 กระโดดทุบหมัดลงพื้น คลื่นกระแทกมอนลอย (กลางอากาศก็ทุบลงได้)
func _do_slam() -> void:
	if hero.on_floor():
		_hop(0.8)
	_act("fs_adz2", 0.45)
	_land(0.15, func() -> void:
		_hitfx("dive")
		_quake_at(Vector2(hero.position.x + _f() * 0.6 * U, 0.0), 2.6, 55.0, "launch")
		page.shake_left = maxf(page.shake_left, 0.3))

## 5.1 วันทูหมัด พุ่งต่อย 1-2 ฮุก แล้วอัปเปอร์คัตมอนลอย
func _do_combo() -> void:
	_act("fs_dz", 0.3)
	_dash(9.0, 0.2, 0.0, "none")
	var seq := [["fs_z1", "jab", 12.0, "light"], ["fs_z2", "jab", 12.0, "light"], ["fs_z3", "hook", 16.0, "flinch"], ["fs_z4", "upper", 24.0, "launch"]]
	for i in seq.size():
		var s: Array = seq[i]
		_later(0.2 + float(i) * 0.17, func() -> void:
			_act(str(s[0]), 0.2)
			_hitfx(str(s[1]))
			_front(1.2, 1.3, float(s[2]), str(s[3]), 1.4))

## 15.1 ร้อยหมัดแมว ต่อยรัว 12 ฮิต ฮิตท้ายกระเด็น
func _do_flurry() -> void:
	_act("fs_z1", 1.1, {"name": "ร้อยหมัด"})
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	_afx("aura", hero.position, 80.0, 1.1, hero)
	_flurry(12, 0.08, 6.0, 26.0, "knock")

## 20.1 กระโดดหมุนเตะรอบตัว 3 รอบ ดูดมอนเข้าหา
func _do_whirl() -> void:
	_hop(0.55)
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	for i in 3:
		_later(0.05 + float(i) * 0.25, func() -> void:
			_act("fs_ax", 0.25)
			_hitfx("spin")
			_afx("ring", hero.position + Vector2(0.0, -60.0), 2.0 * U, 0.35)
			for m in _in_circle(hero.position + Vector2(0.0, -60.0), 2.4 * U):
				if not ROLES_HEAVY(m):
					m.pos.x = move_toward(m.pos.x, hero.pos.x, 0.5)
				_hit(m, 22.0 if i < 2 else 34.0, "flinch" if i < 2 else "knock", _side(m)))

## 20.2 ตั้งท่ารับ ถ้ามอนเข้ามาใกล้หรือโดนตี สวนหมัดหนัก สตั๊น
func _do_counter() -> void:
	_act("fs_z1", COUNTER_TIME, {"name": "ตั้งท่ารับ", "wind": 0.95})
	buffs["counter_st"] = COUNTER_TIME
	_afx("aura", hero.position, 90.0, COUNTER_TIME, hero)

func _fire_counter() -> void:
	buffs.erase("counter_st")
	counters += 1
	hero.invuln_t = maxf(hero.invuln_t, 0.5)
	var keep := _cur_id
	_cur_id = "fs_sk_counter"
	_act("fs_z3", 0.3, {"name": "สวนหมัด"})
	_hitfx("hook")
	_afx("ring", _ahead(1.0), 1.2 * U, 0.35)
	_front(1.2, 1.5, 60.0, "stun", 1.5)
	_cur_id = keep

# ---------------------------------------------------------------- HEAVYWEIGHT
## 15.2 พุ่งเอาพุงชน ลากมอนไปด้วย แล้วกระเด็นล้ม
func _do_hw_bash() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.6)
	_act("fs_dz", 0.45, {"name": "พุงชน", "lean": -10.0})
	_hitfx("dash")
	_dash(13.0, 0.4, 0.0, "none", {"drag": true})
	_later(0.42, func() -> void:
		_afx("ring", _ahead(1.0), 1.3 * U, 0.4)
		_front(1.1, 1.4, 34.0, "knock", 1.4))

## 15.3 กระทืบพื้น 3 ครั้ง คลื่นหินกลิ้งไปด้านหน้า
func _do_hw_stomp() -> void:
	_act("fs_zzx", 0.5, {"name": "กระทืบพื้น"})
	_add({"type": "wave", "pos": Vector2(hero.position.x + _f() * 1.2 * U, 0.0), "face": _f(), "step": 1.3 * U, "n": 3, "every": 0.2, "t": 0.0, "dmg": 22.0, "eff": "launch", "life": 2.0})

## 15.5 พุงเหล็ก ติด SA 6 วิ โอกาสป้อง +25%
func _do_hw_iron() -> void:
	_act("fs_z1", 0.4, {"name": "เบ่งพุง", "lean": -15.0})
	buffs["iron"] = IRON_TIME
	hero.plain_sa_t = maxf(hero.plain_sa_t, IRON_TIME)
	_afx("dome", hero.position, 1.1 * U, 0.6, hero)

## 25.1 คว้ามอนตรงหน้า เหวี่ยงข้ามหัวทุ่มด้านหลัง
func _do_hw_toss() -> void:
	_act("fs_dx", 0.5, {"name": "ทุ่มกระสอบ"})
	var m := _grab(1.8)
	if m != null:
		_throw(m, 50.0, 1.4)
	else:
		_front(1.0, 1.2, 20.0, "flinch")

## 30.1 กดค้างชาร์จ ปล่อยพุ่งชนแรด ระยะไกลตามชาร์จ
func _do_hw_charge() -> void:
	_act("fs_z1", 0.3, {"name": "ตั้งท่าชาร์จ", "wind": 0.9})
	_charge_up(1.2, func(k: float) -> void:
		hero.plain_sa_t = maxf(hero.plain_sa_t, 0.6)
		_act("fs_dz", 0.5, {"name": "แรดพุ่งชน"})
		_hitfx("dash")
		_dash(12.0 + 10.0 * k, 0.35 + 0.2 * k, 24.0 + 36.0 * k, "knock" if k > 0.6 else "strong"))

## 30.2 กลางอากาศทิ้งตัวลงทับ วงกว้าง
func _do_hw_drop() -> void:
	if hero.on_floor():
		_hop(0.7)
	_act("fs_az", 0.4, {"name": "ทิ้งตัวทับ"})
	_land(0.1, func() -> void:
		_quake_at(Vector2(hero.position.x, 0.0), 2.2, 40.0, "knock"))

## 35.1 ตบมือฟ้าผ่า คลื่นเสียงสองข้าง ผลักมอนแล้วสตั๊น
func _do_hw_clap() -> void:
	_act("fs_z4", 0.4, {"name": "ตบมือ"})
	_later(0.18, func() -> void:
		_afx("ring", hero.position + Vector2(0.0, -80.0), 2.8 * U, 0.5)
		_fx("boom", _el(), hero.position + Vector2(0.0, -80.0), 2.4 * U, 0.4)
		for m in _in_ellipse(hero.position + Vector2(0.0, -60.0), 3.0 * U, 1.6 * U):
			_hit(m, 30.0, "stun", _side(m))
		page.shake_left = maxf(page.shake_left, 0.25))

# ---------------------------------------------------------------- GRAND SUMO
## 35.2 ยกขากระทืบซ้ายขวา แผ่นดินไหวทั้งจอ มอนลอยต่ำ
func _do_gs_shiko() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.2)
	for i in 2:
		_later(float(i) * 0.45, func() -> void:
			_act("fs_x4", 0.4, {"name": "ชิโกะ"})
			_hop(0.35))
		_later(float(i) * 0.45 + 0.38, func() -> void:
			_quake_at(Vector2(hero.position.x, 0.0), 4.5 if i == 1 else 3.0, 30.0 if i == 0 else 50.0, "flinch" if i == 0 else "launch")
			page.shake_left = maxf(page.shake_left, 0.35))

## 35.3 ตบฝ่ามือรัว 12 ครั้ง เดินดันไปข้างหน้า
func _do_gs_push() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.2)
	_act("fsh_slap1", 1.2, {"name": "สึปปาริ"})
	var beats := []
	for i in 12:
		beats.append(0.05 + float(i) * 0.09)
	_dash(3.0, 1.15, 9.0, "light", {"beats": beats, "last": "knock", "drag": true})
	for i in 6:
		_later(float(i) * 0.18, func() -> void: _hitfx("jab"))

## 45.1 โปรยเกลือเป็นวง มอนอ่อนแรง ฟื้นเลือด 10%
func _do_gs_salt() -> void:
	_act("fs_z4", 0.45, {"name": "โปรยเกลือ"})
	hero.hp = minf(hero.hp + hero.hp_max() * 0.1, hero.hp_max())
	var at := Vector2(hero.position.x, 0.0)
	var node := _afx("sigil", at, 2.6 * U, 4.2)
	_zone(at, 2.6 * U, 4.0, 6.0, "light", 0.5, node, {"weak": true})
	for i in 10:
		_fx("poof", "silver", at + Vector2(randf_range(-2.4, 2.4) * U, randf_range(-2.0, -0.6) * U), 10.0, 0.7)

## 45.2 คว้ามอนรอบตัว 3 ตัว ทุ่มลงพื้นพร้อมกัน
func _do_gs_throw() -> void:
	_act("fs_x3", 0.5, {"name": "อุวาเตะนาเกะ"})
	var list := _in_circle(hero.position + Vector2(0.0, -60.0), 2.2 * U)
	list.sort_custom(func(a: Monster, b: Monster) -> bool: return absf(a.position.x - hero.position.x) < absf(b.position.x - hero.position.x))
	for m in list.slice(0, 3):
		_throw(m, 60.0, 1.2)

## 50.1 วงเวทีซูโม่บนพื้น 8 วิ มอนในวงช้า ยืนในวงดาเมจ +20%
func _do_gs_ring() -> void:
	_act("fs_x4", 0.4, {"name": "วงเวที"})
	var at := Vector2(hero.position.x, 0.0)
	var node := _afx("sigil", at, 3.2 * U, RING_ZONE_TIME + 0.2)
	_zone(at, 3.2 * U, RING_ZONE_TIME, 4.0, "light", 0.6, node, {"slow": true})
	_ring_zone = {"x": at.x, "half": 3.2 * U, "t": RING_ZONE_TIME}

## 55.1 โยโกะซึนะ กระโดดสูง ทิ้งตัวลง ระเบิดวงใหญ่
func _do_gs_yokozuna() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 2.0)
	_hop(1.1)
	_act("fs_ax", 0.5, {"name": "โยโกะซึนะ"})
	_afx("aura", hero.position, 110.0, 1.2, hero)
	_land(0.35, func() -> void:
		_quake_at(Vector2(hero.position.x, 0.0), 4.2, 110.0, "knock")
		_later(0.15, func() -> void: _quake_at(Vector2(hero.position.x, 0.0), 5.5, 40.0, "launch"))
		page.shake_left = maxf(page.shake_left, 0.5))

# ---------------------------------------------------------------- ZEPHYR
## 15.2 ฝ่ามือลมก้อนใหญ่ ทะลุ ผลักกระเด็น
func _do_zp_gust() -> void:
	_act("fs_z1", 0.32, {"name": "ฝ่ามือลม"})
	_hitfx("jab")
	_later(0.08, func() -> void: _palm_shot(800.0, 0.65 * U, 22.0, "strong", {"life": 0.9, "pierce": true, "hits": 99}))

## 15.3 เตะกระเรียน ยืนขาเดียว เตะเสยมอนลอย
func _do_zp_crane() -> void:
	_act("fs_x1", 0.45, {"name": "เตะกระเรียน", "leap": 2.0})
	_later(0.2, func() -> void:
		_hitfx("upper")
		_afx("crescent", _ahead(1.0, 100.0), 1.0 * U, 0.4)
		_front(1.1, 1.3, 32.0, "launch", 1.8))

## 15.5 ก้าวลม พุ่งทะลุมอน ทิ้งรอยลมตัด
func _do_zp_step() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 0.35)
	var from := hero.position
	_act("fs_dz", 0.3, {"name": "ก้าวลม"})
	_blink(hero.pos.x + _f() * 3.0)
	var mid := (from + hero.position) * 0.5 + Vector2(0.0, -60.0)
	_afx("crescent", mid, 1.4 * U, 0.4)
	for m in _in_ellipse(mid, absf(hero.position.x - from.x) * 0.5 + 0.3 * U, 1.0 * U):
		_hit(m, 24.0, "flinch", _f())

## 25.1 กดค้างหมุนแขน ลมหมุนดูดมอนเข้า
func _do_zp_cyclone() -> void:
	_act("fs_x2", 0.4, {"name": "มือพายุ"})
	_start_channel("fs_sk_zp_cyclone", 0.22, 3.0, 25.0, func() -> void:
		var at := _ahead(1.3)
		_afx("ring", at, 1.4 * U, 0.3)
		for m in _in_circle(at, 2.4 * U):
			if not ROLES_HEAVY(m):
				m.pos.x = move_toward(m.pos.x, at.x / U, 0.35)
			_hit(m, 6.0, "light", _f()))

## 30.1 หมัดมังกรเหิน พุ่งขึ้นฟ้าหมุน มอนลอย
func _do_zp_rise() -> void:
	_act("fs_z4", 0.5, {"name": "มังกรเหิน"})
	_hop(0.85)
	_hitfx("upper")
	for i in 4:
		_later(0.05 + float(i) * 0.1, func() -> void:
			_afx("ring", hero.position + Vector2(_f() * 40.0, -80.0), 0.9 * U, 0.3)
			_front(0.6, 1.1, 14.0 if i < 3 else 24.0, "launch", 2.0))

## 30.2 ลอยขนนก เตะลงเฉียง 3 ครั้ง
func _do_zp_feather() -> void:
	if hero.on_floor():
		_hop(0.7)
	for i in 3:
		_later(0.1 + float(i) * 0.22, func() -> void:
			hero.vel.y = maxf(hero.vel.y, 2.0)
			_act("fs_ax", 0.2, {"name": "เตะขนนก"})
			_hitfx("kick")
			var at := hero.position + Vector2(_f() * 1.3 * U, 20.0)
			_afx("crescent", at, 0.9 * U, 0.3)
			for m in _in_ellipse(at, 1.2 * U, 1.4 * U):
				_hit(m, 20.0 if i < 2 else 30.0, "flinch" if i < 2 else "knock", _f()))

## 35.1 กำแพงลมหมุนตรงหน้า 4 วิ ดันมอนออก
func _do_zp_vortex() -> void:
	_act("fs_x3", 0.45, {"name": "กำแพงลม"})
	var at := Vector2(hero.position.x + _f() * 2.0 * U, 0.0)
	var node := _afx("ring", at + Vector2(0.0, -80.0), 1.2 * U, 4.2)
	_zone(at, 1.2 * U, 4.0, 10.0, "strong", 0.4, node)

# ---------------------------------------------------------------- KUNG FU
## 35.2 หมัดมังกรลม พุ่งยาว ทะลุ
func _do_kf_dragon() -> void:
	_act("fs_dz", 0.45, {"name": "หมัดมังกร"})
	_hitfx("dash")
	_later(0.12, func() -> void:
		var d := _palm_shot(1300.0, 0.8 * U, 38.0, "knock", {"life": 0.8, "pierce": true, "hits": 99})
		d["trail"] = true)

## 35.3 ตะขอตั๊กแตน 6 ครั้ง ดึงมอนเข้าหาตัว
func _do_kf_mantis() -> void:
	_act("fs_z3", 0.9, {"name": "ตะขอตั๊กแตน"})
	for i in 6:
		_later(0.05 + float(i) * 0.13, func() -> void:
			_hitfx("hook")
			var hit := _front(1.6, 1.6, 10.0 if i < 5 else 22.0, "light" if i < 5 else "launch", 1.4)
			for m in hit:
				if not ROLES_HEAVY(m):
					m.pos.x = move_toward(m.pos.x, hero.pos.x + _f() * 0.9, 0.4))

## 45.1 ฝ่ามือแปดทิศ ตีรอบตัว 8 ครั้ง วงลมแปดวง
func _do_kf_palm8() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	for i in 8:
		_later(0.04 + float(i) * 0.1, func() -> void:
			var ang := TAU * float(i) / 8.0
			var at := hero.position + Vector2(cos(ang) * 1.5 * U, -70.0 + sin(ang) * 0.8 * U)
			_act("fs_z1" if i % 2 == 0 else "fs_z2", 0.1)
			_afx("ring", at, 0.8 * U, 0.35)
			for m in _in_circle(at, 1.1 * U):
				_hit(m, 14.0 if i < 7 else 30.0, "light" if i < 7 else "knock", _side(m)))

## 45.2 เสือกระเรียน เตะสลับ 2 ที แล้วฟาดฝ่ามือลง
func _do_kf_tiger() -> void:
	_act("fs_x2", 0.3, {"name": "เสือ"})
	_hitfx("round")
	_front(1.2, 1.3, 22.0, "flinch")
	_later(0.3, func() -> void:
		_act("fs_x1", 0.3, {"name": "กระเรียน", "leap": 2.5})
		_hitfx("upper")
		_front(1.2, 1.3, 22.0, "launch", 1.8))
	_later(0.65, func() -> void:
		_act("fs_adz2", 0.35)
		_hitfx("dive")
		_quake_at(Vector2(hero.position.x + _f() * 1.0 * U, 0.0), 1.8, 40.0, "knock"))

## 50.1 วงล้อหงส์ หมุนเตะเป็นวงล้อพุ่งลงเฉียง
func _do_kf_phoenix() -> void:
	if hero.on_floor():
		_hop(0.8)
	_act("fs_ax", 0.6, {"name": "วงล้อหงส์", "spin": 720.0})
	_afx("ring", hero.position + Vector2(0.0, -60.0), 1.2 * U, 0.6, hero)
	_later(0.25, func() -> void:
		hero.vel = Vector2(_f() * 8.0, -12.0)
		_land(0.05, func() -> void:
			_quake_at(Vector2(hero.position.x, 0.0), 2.6, 50.0, "launch")))
	for i in 3:
		_later(0.08 + float(i) * 0.12, func() -> void:
			for m in _in_circle(hero.position + Vector2(0.0, -60.0), 1.5 * U):
				_hit(m, 14.0, "light", _side(m)))

## 55.1 ปรมาจารย์สายลม พายุหมุนใหญ่ข้างหน้า ดูดมอนแล้วระเบิด
func _do_kf_master() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 2.0)
	_act("fs_x2", 1.4, {"name": "ปรมาจารย์สายลม", "wind": 0.9})
	var at := Vector2(hero.position.x + _f() * 3.0 * U, 0.0)
	var node := _afx("ring", at + Vector2(0.0, -100.0), 2.4 * U, 1.8)
	_zone(at, 2.6 * U, 1.6, 10.0, "light", 0.2, node, {"pull": 3.0 * U})
	_later(1.6, func() -> void:
		_boom(at + Vector2(0.0, -80.0), 3.4 * U, 2.0 * U, 120.0, "launch", _el())
		_afx("ring", at, 3.6 * U, 0.6)
		page.shake_left = maxf(page.shake_left, 0.45))

# ---------------------------------------------------------------- WAR MUAY
## 15.2 ถีบตรง มอนกระเด็นไกล
func _do_wm_teep() -> void:
	_act("fs_x1", 0.35, {"name": "ถีบ"})
	_later(0.12, func() -> void:
		_hitfx("kick")
		_afx("ring", _ahead(1.2), 0.9 * U, 0.3)
		_front(1.3, 1.3, 26.0, "knock"))

## 15.3 หมุนศอกกลับหลัง สตั๊น
func _do_wm_elbow() -> void:
	_act("fsm_elbow_spin", 0.4, {"name": "ศอกกลับ"})
	_later(0.16, func() -> void:
		_hitfx("spin")
		_afx("crescent", _ahead(0.9), 1.0 * U, 0.35)
		_front(1.0, 1.3, 30.0, "stun"))

## 15.5 ปล้ำคอ เข่า 4 ครั้ง ครั้งสุดท้ายมอนลอย
func _do_wm_clinch() -> void:
	var m := _grab(1.6)
	if m != null and not ROLES_HEAVY(m):
		m.pos.x = hero.pos.x + _f() * 0.9
		m.root_t = maxf(m.root_t, 1.0)
	for i in 4:
		_later(float(i) * 0.18, func() -> void:
			_act("fs_dx", 0.18, {"name": "เข่า", "lunge": 0.1, "leap": 0.0})
			_hitfx("knee")
			_front(1.0, 1.0, 14.0 if i < 3 else 28.0, "light" if i < 3 else "launch", 1.4))

## 25.1 ร่ายรำไหว้ครู ดาเมจ +20% 15 วิ
func _do_wm_war() -> void:
	_act("fs_z1", 0.8, {"name": "ไหว้ครู", "wind": 0.95})
	buffs["ram"] = WAR_TIME
	_afx("aura", hero.position, 90.0, 1.0, hero)
	_afx("moon", hero.position + Vector2(0.0, -2.4 * U), 0.5 * U, 0.9, hero)

## 30.1 กระโดดเข่าพุ่งไกล
func _do_wm_flykick() -> void:
	_hop(0.55)
	_act("fs_dx", 0.45, {"name": "เข่าลอย", "lunge": 0.0})
	_hitfx("knee")
	_dash(16.0, 0.32, 38.0, "knock")

## 30.2 มวยรัว ต่อย ศอก เข่า เตะ 5 ฮิต
func _do_wm_combo() -> void:
	var seq := [["fs_z1", "jab", 12.0, "light"], ["fsm_elbow_spin", "hook", 14.0, "light"], ["fs_dx", "knee", 16.0, "flinch"], ["fs_z3", "hook", 14.0, "flinch"], ["fs_x2", "round", 26.0, "knock"]]
	for i in seq.size():
		var s: Array = seq[i]
		_later(float(i) * 0.16, func() -> void:
			_act(str(s[0]), 0.18, {"leap": 0.0})
			_hitfx(str(s[1]))
			_front(1.1, 1.3, float(s[2]), str(s[3]), 1.4))

## 35.1 เตะต่ำสลับ 6 ครั้ง มอนช้าลง
func _do_wm_low() -> void:
	for i in 6:
		_later(float(i) * 0.14, func() -> void:
			_act("fs_zzx", 0.15, {"name": "เตะต่ำ", "spin": 0.0, "lunge": 0.15})
			_hitfx("sweep")
			var hit := _front(1.2, 1.3, 10.0 if i < 5 else 24.0, "light" if i < 5 else "knock", 1.0)
			for m in hit:
				m.slow_t = maxf(m.slow_t, 3.0))

# ---------------------------------------------------------------- MUAY THAI
## 35.2 เข่าผ่าฟ้า กระโดดเข่าสูง แล้วทุบศอกลง
func _do_mt_skyknee() -> void:
	_hop(0.9)
	_act("fs_dx", 0.4, {"name": "เข่าผ่าฟ้า"})
	_hitfx("knee")
	_later(0.12, func() -> void: _front(0.9, 1.2, 36.0, "launch", 2.2))
	_later(0.42, func() -> void:
		_act("fs_adz2", 0.35, {"name": "ศอกทุบ"})
		_land(0.0, func() -> void:
			_hitfx("dive")
			_quake_at(Vector2(hero.position.x + _f() * 0.6 * U, 0.0), 2.0, 44.0, "knock")))

## 35.3 หมัดเหยียดงูเห่า ก้าวกระโดดหมัดตรงแรง
func _do_mt_cobra() -> void:
	_act("fs_dz", 0.4, {"name": "หมัดงูเห่า"})
	_hitfx("dash")
	_dash(14.0, 0.25, 0.0, "none")
	_later(0.26, func() -> void:
		_afx("ring", _ahead(1.1), 1.1 * U, 0.35)
		_front(1.2, 1.3, 62.0, "strong", 1.4)
		page.shake_left = maxf(page.shake_left, 0.2))

## 45.1 พายุศอก ศอกรัว 10 ครั้ง เดินหน้า
func _do_mt_storm() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.2)
	var beats := []
	for i in 10:
		beats.append(0.06 + float(i) * 0.1)
	_dash(2.5, 1.05, 11.0, "light", {"beats": beats, "last": "launch", "drag": true})
	for i in 5:
		_later(float(i) * 0.2, func() -> void:
			_act("fsm_elbow_spin", 0.2, {"name": "พายุศอก"})
			_hitfx("spin"))

## 45.2 หนุมานกระโดด เข่าทุบลงวงกว้าง
func _do_mt_hanuman() -> void:
	if hero.on_floor():
		_hop(0.85)
	_act("fs_dx", 0.45, {"name": "หนุมานกระโดด", "lunge": 0.0})
	_later(0.2, func() -> void:
		hero.vel = Vector2(_f() * 5.0, -14.0)
		_land(0.0, func() -> void:
			_hitfx("dive")
			_quake_at(Vector2(hero.position.x, 0.0), 3.0, 55.0, "launch")))

## 50.1 ออร่ามงคล 10 วิ ดาเมจ +25% ฟื้นเลือด
func _do_mt_mongkol() -> void:
	_act("fs_z1", 0.7, {"name": "มงคล", "wind": 0.95})
	buffs["mongkol"] = MONGKOL_TIME
	_afx("aura", hero.position, 100.0, MONGKOL_TIME, hero)
	_afx("moon", hero.position + Vector2(0.0, -2.5 * U), 0.45 * U, 1.0, hero)

## 55.1 เตะเอราวัณ เตะขวานสามจังหวะ คลื่นทองไล่ไปด้านหน้า
func _do_mt_erawan() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.6)
	for i in 3:
		_later(float(i) * 0.38, func() -> void:
			_act("fs_x4", 0.36, {"name": "เตะเอราวัณ", "leap": 1.5})
			_hitfx("axe"))
		_later(float(i) * 0.38 + 0.3, func() -> void:
			var at := Vector2(hero.position.x + _f() * (1.4 + float(i) * 1.4) * U, 0.0)
			_quake_at(at, 1.8 + float(i) * 0.4, 45.0 if i < 2 else 90.0, "flinch" if i < 2 else "launch")
			page.shake_left = maxf(page.shake_left, 0.3))

# ---------------------------------------------------------------- SYSTEMA GRAPPLER
## 15.2 หลบไปหลังมอนใกล้สุด แล้วฟาดสันมือ
func _do_sy_slip() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 0.4)
	var m := _nearest(hero.position + Vector2(0.0, -60.0), 4.0 * U)
	if m != null:
		var side := _side(m)
		_blink(m.pos.x + side * 0.9)
		hero.facing = -side
	_act("fss_z1", 0.3, {"name": "สันมือ"})
	_later(0.1, func() -> void:
		_hitfx("hook")
		_front(1.1, 1.2, 30.0, "stun"))

## 15.3 คลื่นร่างกาย แรงคลื่นจากตัว ผลักรอบตัว
func _do_sy_wave() -> void:
	_act("fss_z2", 0.4, {"name": "คลื่นร่าง"})
	_later(0.15, func() -> void:
		_afx("ring", hero.position + Vector2(0.0, -60.0), 2.2 * U, 0.45)
		for m in _in_circle(hero.position + Vector2(0.0, -60.0), 2.2 * U):
			_hit(m, 22.0, "strong", _side(m)))

## 15.5 ล็อกแขนมอนตรงหน้า ตรึง 2 วิ ดาเมจต่อเนื่อง
func _do_sy_lock() -> void:
	_act("fss_z1", 0.5, {"name": "ล็อกแขน"})
	var m := _grab(1.6)
	if m == null:
		return
	if not ROLES_HEAVY(m):
		m.pos.x = hero.pos.x + _f() * 0.9
	m.root_t = maxf(m.root_t, 2.0)
	_afx("sigil", Vector2(m.position.x, 0.0), 0.9 * U, 2.0)
	for i in 5:
		_later(0.2 + float(i) * 0.36, func() -> void:
			if is_instance_valid(m) and m.state != "dead":
				_hit(m, 12.0 if i < 4 else 24.0, "light" if i < 4 else "knock", _f()))

## 25.1 หายใจแบบซิสเตมา ฟื้นเลือด 15% มานา 50
func _do_sy_breath() -> void:
	_act("fs_z1", 0.8, {"name": "หายใจ", "wind": 0.95})
	hero.hp = minf(hero.hp + hero.hp_max() * 0.15, hero.hp_max())
	hero.mp = minf(hero.mp + 50.0, hero.mp_max())
	_afx("aura", hero.position, 90.0, 1.0, hero)

## 30.1 จิ้มจุดชีพจร 5 ครั้ง มอนอ่อนแรง
func _do_sy_strike() -> void:
	for i in 5:
		_later(float(i) * 0.12, func() -> void:
			_act("fs_z1" if i % 2 == 0 else "fs_z2", 0.12, {"name": "จิ้มจุด"})
			_hitfx("jab")
			var hit := _front(1.1, 1.2, 12.0 if i < 4 else 28.0, "light" if i < 4 else "stun", 1.4)
			for m in hit:
				m.weak_t = maxf(m.weak_t, 6.0))

## 30.2 ม้วนตัวหลบถอยหลัง ไม่โดนดาเมจ แล้วเตะสวน
func _do_sy_roll() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 0.6)
	_act("fs_ax", 0.35, {"name": "ม้วนหลบ", "spin": -360.0})
	_dash(-10.0, 0.22, 0.0, "none")
	_later(0.3, func() -> void:
		_act("fs_dx", 0.3, {"name": "เข่าสวน", "leap": 0.0})
		_hitfx("knee")
		_dash(16.0, 0.24, 30.0, "knock"))

## 35.1 คว้ามอนหมุนเหวี่ยงรอบตัว ชนมอนอื่น แล้วปล่อยกระเด็น
func _do_sy_spiral() -> void:
	var m := _grab(1.8)
	_act("fs_x3", 0.8, {"name": "เหวี่ยงเกลียว", "spin": 720.0})
	if m == null:
		_front(1.0, 1.2, 20.0, "flinch")
		return
	m.root_t = maxf(m.root_t, 0.8)
	for i in 4:
		_later(0.1 + float(i) * 0.15, func() -> void:
			if not is_instance_valid(m) or m.state == "dead":
				return
			var ang := TAU * float(i) / 4.0
			if not ROLES_HEAVY(m):
				m.pos.x = clampf(hero.pos.x + cos(ang) * 1.2, -m.half_width, m.half_width)
			_afx("ring", _mc(m), 0.8 * U, 0.3)
			for o in _in_circle(_mc(m), 1.3 * U):
				if o != m:
					_hit(o, 18.0, "flinch", _side(o))
			_hit(m, 10.0, "none", _f()))
	_later(0.75, func() -> void:
		if is_instance_valid(m) and m.state != "dead":
			_hit(m, 40.0, "knock", _f()))

# ---------------------------------------------------------------- SAMBO
## 35.2 กอดหมีทุ่มสะพานหลัง พื้นแตก
func _do_sb_suplex() -> void:
	_act("fs_x3", 0.6, {"name": "ซุปเพล็กซ์", "lean": -40.0})
	var m := _grab(1.8)
	if m != null:
		_throw(m, 80.0, 2.0)
	else:
		_front(1.0, 1.2, 24.0, "flinch")

## 35.3 สไลด์ล็อกขา มอนตรึง 3 วิ
func _do_sb_leglock() -> void:
	_act("fs_zzx", 0.45, {"name": "ล็อกขา"})
	_dash(11.0, 0.3, 0.0, "none")
	_later(0.3, func() -> void:
		_hitfx("sweep")
		var hit := _front(1.0, 1.3, 30.0, "flinch", 1.0)
		for m in hit:
			m.root_t = maxf(m.root_t, 3.0)
			_afx("sigil", Vector2(m.position.x, 0.0), 0.8 * U, 3.0))

## 45.1 ทุ่มต่อเนื่อง 3 ตัวรอบๆ ทีละตัว
func _do_sb_chain() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.4)
	var list := _in_circle(hero.position + Vector2(0.0, -60.0), 3.0 * U)
	list.sort_custom(func(a: Monster, b: Monster) -> bool: return absf(a.position.x - hero.position.x) < absf(b.position.x - hero.position.x))
	var picks := list.slice(0, 3)
	if picks.is_empty():
		_act("fs_x3", 0.4, {"name": "ทุ่มต่อ"})
		return
	for i in picks.size():
		var m: Monster = picks[i]
		_later(float(i) * 0.4, func() -> void:
			if not is_instance_valid(m) or m.state == "dead":
				return
			hero.facing = _side(m)
			_act("fs_x3", 0.35, {"name": "ทุ่มต่อ"})
			_throw(m, 55.0, 1.2))

## 45.2 กดค้างกอดรัดหมี บีบมอนตรงหน้า ดาเมจต่อเนื่อง
func _do_sb_bear() -> void:
	_act("fs_z1", 0.4, {"name": "กอดหมี"})
	_start_channel("fs_sk_sb_bear", 0.3, 3.0, 20.0, func() -> void:
		var m := _grab(1.5)
		if m == null:
			return
		if not ROLES_HEAVY(m):
			m.pos.x = hero.pos.x + _f() * 0.8
		m.root_t = maxf(m.root_t, 0.5)
		_afx("ring", _mc(m), 0.7 * U, 0.25)
		_hit(m, 14.0, "light", _f()))

## 50.1 พุ่งไหล่รถถัง ลากมอนทั้งแถวไปแล้วระเบิด
func _do_sb_tank() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	_act("fs_dz", 0.7, {"name": "รถถัง", "lean": 35.0})
	_hitfx("dash")
	_dash(15.0, 0.6, 0.0, "none", {"drag": true})
	_later(0.62, func() -> void:
		_quake_at(Vector2(hero.position.x + _f() * 1.2 * U, 0.0), 2.6, 80.0, "knock")
		page.shake_left = maxf(page.shake_left, 0.35))

## 55.1 หิมะถล่มไซบีเรีย คว้ามอนกระโดดสูง ทุ่มลงทั้งจอสั่น
func _do_sb_avalanche() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 2.0)
	var m := _grab(2.2)
	_hop(1.05)
	_act("fs_ax", 0.6, {"name": "หิมะถล่ม"})
	if m != null:
		_hit(m, 30.0, "launch", _f())
	_land(0.35, func() -> void:
		if m != null and is_instance_valid(m) and m.state != "dead":
			if not ROLES_HEAVY(m):
				m.pos.x = clampf(hero.pos.x + _f() * 0.8, -m.half_width, m.half_width)
			_hit(m, 120.0, "knock", _f())
		_quake_at(Vector2(hero.position.x, 0.0), 4.6, 70.0, "launch")
		for i in 8:
			_fx("poof", "ice", hero.position + Vector2(randf_range(-4.0, 4.0) * U, randf_range(-1.8, -0.3) * U), 20.0, 0.6)
		page.shake_left = maxf(page.shake_left, 0.5))

# ---------------------------------------------------------------- ทุกเฟรม พาสซีฟ
func _process(delta: float) -> void:
	super._process(delta)
	if page == null:
		return
	grit_cd = maxf(grit_cd - delta, 0.0)
	# 20.2 ตั้งท่ารับ มอนเข้ามาใกล้แล้วสวนทันที
	if buffs.has("counter_st"):
		hero.plain_swing = maxf(hero.plain_swing, 0.2)
		if not _in_ellipse(_ahead(0.8), 1.1 * U, 1.3 * U).is_empty():
			_fire_counter()
	if not _ring_zone.is_empty():
		_ring_zone["t"] = float(_ring_zone["t"]) - delta
		if float(_ring_zone["t"]) <= 0.0:
			_ring_zone = {}
	if buffs.has("mongkol"):
		hero.hp = minf(hero.hp + hero.hp_max() * 0.01 * delta, hero.hp_max())

func _in_ring() -> bool:
	return not _ring_zone.is_empty() and absf(hero.position.x - float(_ring_zone["x"])) <= float(_ring_zone["half"])

func _apply_passives(_delta: float) -> void:
	var hpb := 0.0
	if has("fs_sk_hw_bulk"):
		hpb += 80.0
	if has("fs_sk_gs_root"):
		hpb += 70.0
	if has("fs_sk_mt_heart"):
		hpb += 80.0
	if has("fs_sk_sb_winter"):
		hpb += 70.0
	hero.hp_bonus = hpb
	hero.mp_bonus = 0.0
	hero.regen_mult = 1.4 if has("fs_sk_zp_breath") else 1.0
	var spd := 1.0
	if has("fs_sk_zp_flow"):
		spd *= Stats.SPEED_MULT
	if has("fs_sk_sy_flow"):
		spd *= Stats.SPEED_MULT
	hero.speed_bonus = spd
	page.atk_speed = 1.1 if has("fs_sk_wm_spirit") else 1.0
	var block := 0.0
	if has("fs_sk_guard"):
		block = 0.12
	if has("fs_sk_wm_shin"):
		block = maxf(block, 0.15)
	if has("fs_sk_sy_relax"):
		block = maxf(block, 0.15)
	if has("fs_sk_gs_root"):
		block = maxf(block, 0.18)
	if buffs.has("iron"):
		block += 0.25
	hero.block_chance = block
	hero.ranged_guard_t = 0.0
	hero.melee_guard_t = 0.0
	if has("fs_sk_gs_body"):
		hero.hp = minf(hero.hp + hero.hp_max() * 0.005 * _delta, hero.hp_max())
	if has("fs_sk_sb_winter"):
		hero.hp = minf(hero.hp + hero.hp_max() * 0.003 * _delta, hero.hp_max())
	# GRAND SUMO 60.2 เลือดต่ำ ไม่ขยับ ติด SA ตลอด
	if has("fs_sk_gs_spirit") and hero.hp < hero.hp_max() * 0.3:
		hero.plain_sa_t = maxf(hero.plain_sa_t, 0.2)

func dmg_mult(m: Monster, h: Dictionary) -> float:
	var k := 1.0
	var skill: bool = h.get("skill", false)
	if buffs.has("ram"):
		k *= 1.2
	if buffs.has("mongkol"):
		k *= 1.25
	if _in_ring():
		k *= 1.2
	if has("fs_sk_hw_heavy") and not skill:
		k *= 1.15
	if has("fs_sk_mt_crit") and randf() < MT_CRIT:
		k *= 1.5
		crits += 1
	if has("fs_sk_mt_last") and hero.hp < hero.hp_max() * 0.35:
		k *= 1.3
	if m != null and m.weak_t > 0.0 and has("fs_sk_sy_relax"):
		k *= 1.1
	return k

func on_strike(m: Monster, h: Dictionary) -> void:
	var skill: bool = h.get("skill", false)
	# KUNG FU 35.4 ลมปราณ ตีคอมโบได้มานา
	if has("fs_sk_kf_chi") and not skill:
		hero.mp = minf(hero.mp + 1.0, hero.mp_max())
	# KUNG FU 60.2 สกิลโดน มีโอกาสปล่อยฝ่ามือลมซ้ำ
	if has("fs_sk_kf_echo") and skill and m != null and Time.get_ticks_msec() - _echo_ms >= 400 and randf() < ECHO_CHANCE:
		_echo_ms = Time.get_ticks_msec()
		echoes += 1
		var keep := _cur_id
		_cur_id = "fs_sk_kf_echo"
		_palm_shot(900.0, 0.45 * U, 16.0, "flinch", {"life": 0.7})
		_cur_id = keep

func _on_hurt(_kind: String) -> void:
	# SAMBO 60.2 ทรหด เลือดหมดไม่ตาย 1 ครั้ง
	if hero.hp <= 0.0:
		if grit_cd <= 0.0 and has("fs_sk_sb_grit"):
			grit_cd = GRIT_CD
			hero.hp = hero.hp_max() * 0.3
			hero.invuln_t = maxf(hero.invuln_t, 1.5)
			_cur_id = "fs_sk_sb_grit"
			_afx("aura", hero.position, 110.0, 1.2, hero)
			page.bars.notice("ยังไม่ยอมแพ้!")
		return
	# 20.2 โดนตีตอนตั้งท่ารับ สวนกลับ
	if buffs.has("counter_st"):
		_fire_counter()

