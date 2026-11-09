class_name SusiSkills
extends Node
## สกิลของ CAT SUSI ทุกสาย (BASIC ARCH ELEMENT BATTLE DIMENSION DARK ECLIPSE)
## อยู่ใน world จึงหยุดตามเวลาในดันเจี้ยน  ใช้มานาและคูลดาวน์ของตัวเอง
## ชิ้นสกิลที่ทำงานอยู่เก็บเป็น Dictionary ใน _objs  ชนิด: proj area beam slide stomp attach orbit
## ภาพทุกชิ้นใช้ SusiFx  โดนมอนผ่าน page._strike จึงได้ดาเมจตามเลเวลและรอยเท้าแมวเหมือนสกิลอื่น

const U := CombatData.UNIT
const GROW := 1.2               # สกิลใหญ่ขึ้นเล็กน้อย ทั้งภาพและระยะโดน (ไม่ใหญ่กว่าตัว)
const EFF := {
	"light": {"type": "flinch", "stun": 0.3, "kb": 0.6},
	"flinch": {"type": "flinch", "stun": 0.6, "kb": 2.0},
	"strong": {"type": "flinch", "stun": 1.0, "kb": 4.5},
	"stun": {"type": "flinch", "stun": 2.2, "real_stun": true, "kb": 0.4},
	"knock": {"type": "knockdown", "fly": 7.0},
	"launch": {"type": "launch", "vy": 10.0},
	"none": {"type": "none"},
}
## mp มานา  cd คูลดาวน์  el ธาตุ (สะสมเกจท่องจำธาตุ)  air ใช้กลางอากาศได้  dark นับเป็นสกิลมืด
const DEFS := {
	"su_warp": {"mp": 8.0, "cd": 0.6, "air": true},
	"su_blast": {"mp": 12.0, "cd": 2.0},
	"su_counter_guard": {"mp": 15.0, "cd": 15.0},
	"su_fire_storm": {"mp": 25.0, "cd": 14.0, "el": "fire"},
	"su_bolt_wide": {"mp": 22.0, "cd": 8.0, "el": "bolt"},
	"su_meteor": {"mp": 30.0, "cd": 12.0, "el": "fire"},
	"su_bind_circle": {"mp": 25.0, "cd": 16.0},
	"su_ar_fire_trail": {"mp": 10.0, "cd": 2.5, "el": "fire"},
	"su_ar_ice_seeker": {"mp": 20.0, "cd": 12.0, "el": "ice"},
	"su_ar_mana_save": {"mp": 10.0, "cd": 30.0},
	"su_ar_fire_rain": {"mp": 15.0, "cd": 10.0, "el": "fire"},
	"su_ar_ice_pillars": {"mp": 15.0, "cd": 10.0, "el": "ice"},
	"su_ar_mana_up": {"mp": 0.0, "cd": 30.0},
	"su_ar_chain": {"mp": 22.0, "cd": 8.0, "el": "bolt"},
	"su_em_cross_fire": {"mp": 22.0, "cd": 7.0, "el": "fire"},
	"su_em_mini_storms": {"mp": 22.0, "cd": 9.0},
	"su_em_big_wind": {"mp": 30.0, "cd": 14.0},
	"su_em_float_bolts": {"mp": 20.0, "cd": 12.0, "el": "bolt"},
	"su_em_ward": {"mp": 15.0, "cd": 25.0},
	"su_em_fire_spread": {"mp": 25.0, "cd": 8.0, "el": "fire"},
	"su_bt_dim_dust": {"mp": 10.0, "cd": 2.5},
	"su_bt_form": {"mp": 20.0, "cd": 1.0},
	"su_bt_rage": {"mp": 10.0, "cd": 25.0},
	"su_bt_implode": {"mp": 35.0, "cd": 15.0},
	"su_bt_stomp": {"mp": 20.0, "cd": 6.0, "air": true, "air_only": true},
	"su_bt_drain": {"mp": 0.0, "cd": 8.0},
	"su_bt_smash": {"mp": 25.0, "cd": 9.0},
	"su_dc_pull_ball": {"mp": 22.0, "cd": 10.0},
	"su_dc_air_burst": {"mp": 25.0, "cd": 9.0, "air": true},
	"su_dc_bounce_field": {"mp": 30.0, "cd": 14.0},
	"su_dc_ram": {"mp": 20.0, "cd": 7.0},
	"su_dc_ward": {"mp": 15.0, "cd": 25.0},
	"su_dc_slide": {"mp": 25.0, "cd": 9.0},
	"su_dk_dark_trail": {"mp": 10.0, "cd": 2.5, "dark": true},
	"su_dk_smoke_box": {"mp": 22.0, "cd": 10.0, "dark": true},
	"su_dk_rage": {"mp": 10.0, "cd": 25.0},
	"su_dk_chain_orb": {"mp": 35.0, "cd": 14.0, "dark": true},
	"su_dk_dark_burst": {"mp": 22.0, "cd": 9.0, "dark": true},
	"su_dk_web": {"mp": 20.0, "cd": 14.0, "dark": true},
	"su_dk_staff_spin": {"mp": 30.0, "cd": 12.0, "dark": true},
	"su_ec_bat": {"mp": 20.0, "cd": 10.0, "dark": true},
	"su_ec_beam": {"mp": 40.0, "cd": 18.0, "dark": true},
	"su_ec_void_pull": {"mp": 28.0, "cd": 14.0, "dark": true},
	"su_ec_sky_burst": {"mp": 30.0, "cd": 12.0, "dark": true},
	"su_ec_ward": {"mp": 15.0, "cd": 25.0},
	"su_ec_dark_spread": {"mp": 25.0, "cd": 8.0, "dark": true},
	"su_al_poison_trail": {"mp": 10.0, "cd": 2.5},
	"su_al_potion_rain": {"mp": 18.0, "cd": 8.0},
	"su_al_brew_buff": {"mp": 10.0, "cd": 30.0},
	"su_al_acid_rain": {"mp": 35.0, "cd": 16.0},
	"su_al_glitter_bomb": {"mp": 22.0, "cd": 8.0},
	"su_al_ore_line": {"mp": 35.0, "cd": 15.0},
	"su_al_potions": {"mp": 20.0, "cd": 25.0},
	"su_tm_homunculus": {"mp": 30.0, "cd": 35.0},
	"su_tm_poison_pool": {"mp": 18.0, "cd": 9.0},
	"su_tm_triple_blast": {"mp": 30.0, "cd": 12.0},
	"su_tm_silver_crystal": {"mp": 25.0, "cd": 9.0, "air": true},
	"su_tm_ward": {"mp": 15.0, "cd": 25.0},
	"su_tm_poison_rings": {"mp": 28.0, "cd": 16.0},
}

var page: WalkPage
var hero: Hero
var cds := {}                   # คูลดาวน์ที่เหลือ
var buffs := {}                 # counter mana_save mana_up ranged_guard melee_guard
var form := false               # BATTLE 15.3 แปลงร่างมิติ
var gauge := {"fire": 0.0, "ice": 0.0, "bolt": 0.0}
var _objs: Array = []
var _channel := {}              # สกิลกดค้าง {id every t left drain fn}
var _beam := {}                 # ลำแสงมืดบังคับทิศ
var _form_fx: SusiFx
var _ward_fx: SusiFx
var _counter_cd := 0.0
var _cur_id := ""                # สกิลที่กำลังร่าย ใช้เลือกท่า
var _hp_seen := 0.0
var arche := 0.0                # ALCHEMIST 15.4 เกจ Arche ครบ 100 ปุ่ม V รีเซ็ตคูลดาวน์
var poison_hits_t := 0.0        # เก็บขวดพิษแล้ว ตีมอนติดพิษ
var _homun: SusiFx
var _homun_t := 0.0
var _homun_shot := 0.0
var _pickups: Array = []        # ขวดบนพื้น [โหนด ชนิด อายุ]
var ui: Node2D

func setup(p: WalkPage) -> void:
	page = p
	hero = p.hero
	hero.hurt_by.connect(_on_hurt)
	ui = Node2D.new()
	ui.z_index = 44
	ui.draw.connect(_draw_ui)
	p.add_child(ui)

# ---------------------------------------------------------------- ข้อมูล
## สกิล/พาสซีฟนี้อยู่ในสายที่เล่นและเลเวลถึงแล้ว
func has(id: String) -> bool:
	var info := SkillPanel.find_skill(id)
	if info.is_empty():
		return false
	var cls: String = info.get("class", "BASIC")
	var line := [WalkPage.chosen_class] + SkillPanel.ancestors(WalkPage.chosen_class)
	if WalkPage.chosen_class == "" :
		line = ["BASIC"]
	if not cls in line and cls != "BASIC":
		return false
	return SkillPanel.need_level(info) <= WalkPage.chosen_level

func cost(id: String) -> float:
	var c := Stats.skill_mp("mage", id)
	if buffs.has("mana_save"):
		c *= 0.5
	if id == "su_warp" and has("su_dc_cheap_warp"):
		c *= 0.4
	return c

func cooldown(id: String) -> float:
	return float(DEFS.get(id, {}).get("cd", 1.0)) * (0.8 if has("su_em_flow") else 1.0)

func cd_left(id: String) -> float:
	return float(cds.get(id, 0.0))

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	var d: Dictionary = DEFS.get(id, {})
	if d.is_empty():
		return
	# กดซ้ำตอนยิงลำแสงมืด คือหยุดยิง
	if id == "su_ec_beam" and not _beam.is_empty():
		_end_beam()
		return
	if not _channel.is_empty() or not _beam.is_empty():
		return
	if hero.plain_swing > 0.0 or hero.hurt_t > 0.0:
		return
	if d.get("air_only", false) and hero.on_floor():
		page.bars.notice("ใช้ได้กลางอากาศเท่านั้น")
		return
	if not d.get("air", false) and not hero.on_floor():
		return
	if cd_left(id) > 0.0:
		page.bars.notice("รออีก %.1f วิ" % cd_left(id))
		return
	if id == "su_bt_form" and form:
		_set_form(false)
		cds[id] = cooldown(id)
		return
	var c := cost(id)
	if hero.mp < c:
		page.bars.notice("มานาไม่พอ")
		return
	hero.mp -= c
	cds[id] = cooldown(id)
	# ECLIPSE 35.4 ใช้สกิลมืด มีโอกาสได้มานาคืน
	if d.get("dark", false) and has("su_ec_mana_luck") and randf() < 0.1:
		hero.mp = minf(hero.mp + 15.0, hero.mp_max())
	if d.has("el"):
		_add_gauge(str(d["el"]))
	# ALCHEMIST 15.4 ใช้สกิลได้ Arche 10 หน่วย
	if has("su_al_arche"):
		arche = minf(arche + 10.0, 100.0)
		page.pad.v_on = arche >= 100.0
		page.pad.v_ratio = arche / 100.0
		page.pad.queue_redraw()
	_cast_flare(id)
	BigSkillFx.cast(page, id, c)
	_cur_id = id
	# สกิลใหญ่ หยุดเวลาชั่วครู่
	if Stats.skill_mp("mage", id) >= 250.0:
		page.time_stop(0.45)
	call("_do_" + id.trim_prefix("su_"))

## ร่ายสกิล วงเวทใต้เท้าหมุนขยาย มีแสงพุ่งขึ้น สีตามสาย
func _cast_flare(id: String) -> void:
	var el := "arcane"
	if id.begins_with("su_ar_") or id.begins_with("su_em_"):
		el = "ice" if id.contains("ice") else ("bolt" if id.contains("bolt") or id.contains("chain") else "fire")
	elif id.begins_with("su_bt_") or id.begins_with("su_dc_"):
		el = "dim"
	elif id.begins_with("su_dk_") or id.begins_with("su_ec_"):
		el = "dark"
	elif id.begins_with("su_al_") or id.begins_with("su_tm_"):
		el = "poison"
	var c := _fx("flare", el, hero.position + Vector2(0.0, -4.0), 1.3 * U, 0.7)
	c.rx = 1.3 * U
	c.ry = 0.35 * U

## ปุ่ม V ของ Arche รีเซ็ตคูลดาวน์ทุกสกิล (ไม่รวม HYPER)
func press_v() -> void:
	if arche < 100.0:
		return
	arche = 0.0
	cds.clear()
	page.pad.v_on = false
	page.pad.queue_redraw()
	page.bars.notice("Arche! รีเซ็ตคูลดาวน์ทั้งหมด")
	_fx("poof", "ore", hero.position + Vector2(0.0, -80.0), 90.0, 0.5)

## ท่าร่ายสกิลหลายแบบ ไม่ให้ทุกสกิลออกท่าเดียวกัน
const POSE_SETS := {
	"shoot": ["cast", "point", "cast45", "twirl"],
	"sky": ["raise", "up", "twirl"],
	"area": ["spin", "sweep", "twirl"],
	"ground": ["slam", "down", "sweep"],
	"buff": ["raise", "up", "spin"],
	"dash": ["dash", "point"],
}

func _pose_group(id: String) -> String:
	for k in ["warp", "ram", "slide"]:
		if id.contains(k):
			return "dash"
	for k in ["meteor", "rain", "sky", "float", "pillar", "homun", "chain_orb"]:
		if id.contains(k):
			return "sky"
	for k in ["storm", "wind", "field", "void", "web", "pull", "rings", "burst", "implode", "air"]:
		if id.contains(k):
			return "area"
	for k in ["bind", "stomp", "smash", "crystal", "ore", "acid", "pool", "drain", "triple"]:
		if id.contains(k):
			return "ground"
	for k in ["guard", "ward", "rage", "mana", "save", "brew", "form", "counter", "potions"]:
		if id.contains(k):
			return "buff"
	return "shoot"

func _pose_move(name: String) -> Dictionary:
	var m: Dictionary
	match name:
		"cast":
			m = (Hero.MK_MOVES["mk_turn_shot"] as Dictionary).duplicate(true)
		"cast45":
			m = (Hero.MK_MOVES["mk_shot45"] as Dictionary).duplicate(true)
		"point":
			m = (Hero.SK_MOVES["skx5"] as Dictionary).duplicate(true)
		"raise":
			m = (Hero.CHIBI_MOVES["xxz"] as Dictionary).duplicate(true)
		"up":
			m = (Hero.CHIBI_MOVES["x2"] as Dictionary).duplicate(true)
		"down":
			m = (Hero.CHIBI_MOVES["x1"] as Dictionary).duplicate(true)
		"slam":
			m = (Hero.CHIBI_MOVES["zx"] as Dictionary).duplicate(true)
		"sweep":
			m = (Hero.CHIBI_MOVES["x3"] as Dictionary).duplicate(true)
		"spin":
			m = (Hero.CHIBI_MOVES["x3"] as Dictionary).duplicate(true)
			m["spin"] = 360.0
		"twirl":
			m = (Hero.CHIBI_MOVES["x2"] as Dictionary).duplicate(true)
			m["spin"] = -360.0
		"dash":
			m = (Hero.CHIBI_MOVES["dz1"] as Dictionary).duplicate(true)
		_:
			m = (Hero.CHIBI_MOVES["x1"] as Dictionary).duplicate(true)
	for k in ["turn_around", "fx", "fx_start", "auto", "leap", "dive", "hover", "hand_cast"]:
		m.erase(k)
	return m

func _pose(_kind := "swing", time := 0.35) -> void:
	var group := _pose_group(_cur_id)
	var options: Array = POSE_SETS[group]
	var pick: String = options[absi(hash(_cur_id)) % options.size()]
	hero.plain_move = _pose_move(pick)
	hero.plain_swing_kind = "combo"
	hero.plain_combo_id += 1
	hero.plain_swing = 0.001
	var tw := page.create_tween()
	tw.tween_property(hero, "plain_swing", 1.0, maxf(time, 0.4))
	tw.tween_callback(func() -> void: hero.plain_swing = 0.0)

func _later(time: float, fn: Callable) -> void:
	_add({"type": "timer", "life": time, "fn": fn})

func _f() -> float:
	return hero.facing if hero.facing != 0.0 else 1.0

## จุดหัวคฑาโดยประมาณ (จุดภาพในโลก)
func _staff() -> Vector2:
	return hero.position + Vector2(_f() * 60.0, -95.0)

func _fx(kind: String, el: String, at: Vector2, r: float, life := 1.0, auto := true) -> SusiFx:
	var n := SusiFx.new()
	n.kind = kind
	n.element = el
	n.position = at
	n.r = r
	n.life = life
	n.dir = _f()
	n.auto_free = auto
	if kind != "chain":
		n.scale = Vector2.ONE * GROW * BigSkillFx.boost(page)
	page.world.add_child(n)
	return n

func _mons() -> Array:
	var out := []
	for e in page.get_tree().get_nodes_in_group("monsters"):
		var m := e as Monster
		if m != null and m.state != "dead":
			out.append(m)
	return out

func _mc(m: Monster) -> Vector2:
	return m.position + Vector2(0.0, -WalkPage.MONSTER_MID)

func _hit(m: Monster, dmg: float, eff: String, side: float, extra := {}) -> void:
	var h := {"dmg": dmg, "skill": true}
	h.merge(EFF.get(eff, EFF["flinch"]), true)
	h.merge(extra, true)
	page._strike(m, h, side)

## กระเด็นออกไม่เสียเลือด
func _push(m: Monster, from_x: float, power := 9.0) -> void:
	m.take_hit({"type": "knockdown", "fly": power, "dmg": 0.0}, signf(m.position.x - from_x) if m.position.x != from_x else _f())

func _in_circle(at: Vector2, radius: float) -> Array:
	var out := []
	for m in _mons():
		if _mc(m).distance_to(at) <= radius * GROW + WalkPage.MONSTER_HIT_R:
			out.append(m)
	return out

func _in_ellipse(at: Vector2, w: float, h: float) -> Array:
	var out := []
	for m in _mons():
		var d := _mc(m) - at
		var k := pow(d.x / (w * GROW + WalkPage.MONSTER_HIT_R), 2.0) + pow(d.y / (h * GROW + WalkPage.MONSTER_HIT_R), 2.0)
		if k <= 1.0:
			out.append(m)
	return out

func _nearest(at: Vector2, within: float, skip: Array = []) -> Monster:
	var best: Monster = null
	var bd := within
	for m in _mons():
		if m in skip:
			continue
		var d := _mc(m).distance_to(at)
		if d < bd:
			bd = d
			best = m
	return best

## เพิ่มชิ้นสกิล ค่าเริ่มต้นที่ไม่ได้ใส่
func _add(o: Dictionary) -> Dictionary:
	var base := {"pos": Vector2.ZERO, "vel": Vector2.ZERO, "life": 1.0, "r": 30.0, "dmg": 0.0, "eff": "flinch", "tick": 0.0, "tick_t": 0.0, "hits": 1, "done": [], "age": 0.0}
	base.merge(o, true)
	_objs.append(base)
	return base

func _proj(kind: String, el: String, at: Vector2, vel: Vector2, r: float, dmg: float, eff: String, o := {}) -> Dictionary:
	var node := _fx(kind, el, at, r, float(o.get("life", 2.0)) + 0.3, false)
	node.dir = signf(vel.x) if vel.x != 0.0 else _f()
	var d := {"type": "proj", "node": node, "pos": at, "vel": vel, "r": r, "dmg": dmg, "eff": eff, "life": 2.0}
	d.merge(o, true)
	return _add(d)

func _area(kind: String, el: String, at: Vector2, r: float, life: float, dmg: float, eff: String, o := {}) -> Dictionary:
	var node := _fx(kind, el, at, r, life + 0.2, false)
	var d := {"type": "area", "node": node, "pos": at, "r": r, "life": life, "dmg": dmg, "eff": eff}
	d.merge(o, true)
	return _add(d)

func _boom(at: Vector2, w: float, h: float, dmg: float, eff: String, el: String, extra := {}) -> void:
	var n := _fx("boom", el, at, w, 0.45)
	n.rx = w
	n.ry = h
	for m in _in_ellipse(at, w, h):
		if eff == "push":
			_push(m, at.x)
		else:
			_hit(m, dmg, eff, signf(_mc(m).x - at.x) if _mc(m).x != at.x else _f(), extra)
	# ระเบิดใหญ่ จอสั่นแรงตามขนาด มีแสงพุ่งจากจุดระเบิด
	page.shake_left = maxf(page.shake_left, clampf(w / U * 0.09, 0.2, 0.5))

# ---------------------------------------------------------------- BASIC
func _do_warp() -> void:
	var v := page.joy.vector() if page.joy != null else Vector2.ZERO
	var h := 0.0
	if page.pad.is_held("left"):
		h -= 1.0
	if page.pad.is_held("right"):
		h += 1.0
	if h == 0.0:
		h = signf(v.x) if absf(v.x) > 0.3 else 0.0
	var up := 0.0
	if page.pad.is_held("down") or v.y > 0.5:
		up = -1.0
	elif page.pad.is_held("jump") or v.y < -0.5:
		up = 1.0
	var d := Vector2(h, up)
	if d == Vector2.ZERO:
		d = Vector2(_f(), 0.0)
	d = d.normalized()
	_fx("poof", "arcane", hero.position + Vector2(0.0, -60.0), 50.0, 0.4)
	hero.pos.x = clampf(hero.pos.x + d.x * 4.5, -hero.half_width, hero.half_width)
	hero.pos.y = clampf(hero.pos.y + d.y * 3.0, 0.0, 3.5)
	hero.vel = Vector2.ZERO
	if d.x != 0.0:
		hero.facing = signf(d.x)
	hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
	_fx("poof", "arcane", hero.position + Vector2(0.0, -60.0), 50.0, 0.4)

func _do_blast() -> void:
	_pose("stab", 0.55)
	var ch := _fx("charge", "arcane", _staff(), 30.0, 0.35)
	ch.dir = _f()
	_later(0.35, func() -> void:
		_proj("arcane", "arcane", _staff(), Vector2(_f() * 1100.0, 0.0), 42.0, 22.0, "strong", {"hits": 3, "life": 1.0})
		page.shake_left = maxf(page.shake_left, 0.15))

func _do_counter_guard() -> void:
	_pose()
	buffs["counter"] = 12.0
	_ward("arcane", 12.0)

func _do_fire_storm() -> void:
	_pose()
	var nodes := []
	for i in 3:
		nodes.append(_fx("storm", "fire", hero.position, 34.0, 6.2, false))
	_add({"type": "orbit", "nodes": nodes, "life": 6.0, "r": 60.0, "dmg": 6.0, "eff": "light", "tick": 0.4, "extra": {"burn": "fire"}})

func _do_bolt_wide() -> void:
	_pose("stab", 0.45)
	var n := _fx("beam", "bolt", _staff(), 40.0, 0.5, false)
	n.angle = 0.0 if _f() > 0.0 else PI
	n.length = 9.0 * U
	n.ry = 70.0
	_add({"type": "beam", "node": n, "pos": _staff(), "life": 0.45, "dmg": 14.0, "eff": "stun", "tick": 0.15, "len": 9.0 * U, "w": 70.0, "ang": n.angle})

func _do_meteor() -> void:
	_pose("stab", 0.5)
	var land := Vector2(hero.position.x + _f() * 5.0 * U, -40.0)
	var from := land + Vector2(-_f() * 2.5 * U, -9.0 * U)
	_proj("meteor", "fire", from, (land - from).normalized() * 1400.0, 70.0, 45.0, "knock", {"ground_end": true, "boom": [3.5 * U, 1.6 * U], "life": 2.0, "hits": 99, "no_touch": true})

func _do_bind_circle() -> void:
	_pose()
	var a := _area("circle", "arcane", hero.position + Vector2(0.0, -6.0), 4.0 * U, 4.0, 5.0, "none", {"root": true, "tick": 0.5})
	(a["node"] as SusiFx).rx = 4.0 * U
	(a["node"] as SusiFx).ry = 1.0 * U

# ---------------------------------------------------------------- ARCH
func _ground_trail(el: String, dmg: float, extra := {}) -> void:
	_pose()
	_proj("trail", el, Vector2(hero.position.x + _f() * 60.0, 0.0), Vector2(_f() * 650.0, 0.0), 28.0, dmg, "light", {"hits": 6, "life": 1.4, "ground": true, "extra": extra})

func _do_ar_fire_trail() -> void:
	_ground_trail("fire", 12.0, {"burn": "fire"})

func _do_ar_ice_seeker() -> void:
	_pose()
	_proj("ice", "ice", _staff(), Vector2(_f() * 420.0, 0.0), 26.0, 6.0, "light", {"life": 8.0, "homing": 420.0, "tick": 0.5, "hits": 999, "bounce": true})

func _do_ar_mana_save() -> void:
	_pose()
	buffs["mana_save"] = 20.0
	_ward("ice", 1.2)

func _do_ar_fire_rain() -> void:
	_pose("stab", 0.4)
	_start_channel("su_ar_fire_rain", 0.22, 5.0, 18.0, func() -> void:
		var land := Vector2(hero.position.x + _f() * randf_range(1.5, 8.0) * U, -20.0)
		var from := land + Vector2(-_f() * 1.2 * U, -7.0 * U)
		_proj("meteor", "fire", from, (land - from).normalized() * 1200.0, 30.0, 10.0, "light", {"ground_end": true, "boom": [1.4 * U, 0.7 * U], "life": 1.5, "hits": 99, "no_touch": true}))

func _do_ar_ice_pillars() -> void:
	_pose("stab", 0.4)
	_start_channel("su_ar_ice_pillars", 0.3, 5.0, 18.0, func() -> void:
		var side := 1.0 if randf() < 0.5 else -1.0
		var at := Vector2(hero.position.x + side * randf_range(1.0, 5.0) * U, 0.0)
		_area("pillar", "ice", at, 0.9 * U, 0.8, 9.0, "light", {"once": true, "freeze": 1.2}))

func _do_ar_mana_up() -> void:
	_pose()
	buffs["mana_up"] = 8.0
	_ward("bolt", 1.2)

func _do_ar_chain() -> void:
	_pose("stab", 0.4)
	var from := _staff()
	var pts := PackedVector2Array([from])
	var first := _nearest(from + Vector2(_f() * 4.0 * U, 0.0), 6.0 * U)
	if first == null:
		var miss := _fx("beam", "bolt", from, 30.0, 0.3)
		miss.angle = 0.0 if _f() > 0.0 else PI
		miss.length = 5.0 * U
		miss.ry = 30.0
		return
	var visited := []
	var cur := first
	for i in 7:
		pts.append(_mc(cur))
		_hit(cur, 14.0, "flinch", _f())
		visited.append(cur)
		var nxt := _nearest(_mc(cur), 5.0 * U, visited)
		if nxt == null:
			# ตัวเดียวก็ชิ่งตัวเดิมซ้ำ
			nxt = cur
			visited.clear()
		cur = nxt
	var n := _fx("chain", "bolt", Vector2.ZERO, 20.0, 0.45)
	n.points = pts

# ---------------------------------------------------------------- ELEMENT
func _do_em_cross_fire() -> void:
	_pose("stab", 0.45)
	var circle := _fx("circle", "fire", hero.position + Vector2(-_f() * 70.0, -90.0), 70.0, 0.7)
	circle.rx = 40.0
	circle.ry = 80.0
	for ph in [0.0, PI]:
		_proj("fire", "fire", hero.position + Vector2(-_f() * 60.0, -90.0), Vector2(_f() * 700.0, 0.0), 30.0, 16.0, "flinch", {"hits": 6, "life": 1.3, "wave": [80.0, 7.0, ph], "base_y": -90.0})

func _do_em_mini_storms() -> void:
	_pose()
	for i in 3:
		_proj("storm", "wind", _staff() + Vector2(0.0, float(i - 1) * 40.0), Vector2(_f() * 320.0, float(i - 1) * 60.0), 22.0, 5.0, "light", {"life": 4.0, "homing": 320.0, "tick": 0.4, "hits": 999, "bounce": true, "ground": true})

func _do_em_big_wind() -> void:
	_pose("stab", 0.5)
	_proj("wind", "wind", Vector2(hero.position.x + _f() * 120.0, 0.0), Vector2(_f() * 150.0, 0.0), 2.4 * U, 6.0, "light", {"life": 5.0, "tick": 0.3, "hits": 999, "ground": true, "carry": true})

func _do_em_float_bolts() -> void:
	_pose("stab", 0.4)
	_start_channel("su_em_float_bolts", 0.2, 4.0, 20.0, func() -> void:
		var x := hero.position.x + randf_range(-5.0, 5.0) * U
		var el := "bolt" if randf() < 0.5 else "bolt_pink"
		var n := _fx("beam", el, Vector2(x, -8.0 * U), 30.0, 0.25)
		n.angle = PI * 0.5
		n.length = 8.0 * U
		n.ry = 34.0
		_fx("boom", el, Vector2(x, -20.0), 60.0, 0.3)
		for m in _in_circle(Vector2(x, -60.0), 1.2 * U):
			_hit(m, 8.0, "light", signf(_mc(m).x - hero.position.x)), true)

func _do_em_ward() -> void:
	_pose()
	buffs["ranged_guard"] = 10.0
	_ward("wind", 10.0)

func _spread(kind: String, el: String) -> void:
	_pose("stab", 0.4)
	for i in 7:
		var ang := deg_to_rad(-27.0 + float(i) * 9.0)
		var v := Vector2(cos(ang) * _f(), sin(ang)) * 800.0
		_proj(kind, el, _staff(), v, 22.0, 12.0, "light", {"hits": 2, "life": 0.9})

func _do_em_fire_spread() -> void:
	_spread("fire", "fire")

## ELEMENT 60.1 ท่องจำธาตุ ใช้สกิลธาตุสะสมเกจ ครบ 100 ปล่อยวงธาตุใหญ่
func _add_gauge(el: String) -> void:
	if not has("su_em_memory"):
		return
	gauge[el] = float(gauge.get(el, 0.0)) + 25.0
	if float(gauge[el]) >= 100.0:
		gauge[el] = 0.0
		var color_el := "bolt" if el == "bolt" else el
		_proj("mem", color_el, Vector2(hero.position.x + _f() * 100.0, 0.0), Vector2(_f() * 260.0, 0.0), 2.6 * U, 7.0, "light", {"life": 3.0, "tick": 0.25, "hits": 999, "ground": true})
		page.bars.notice("ท่องจำธาตุ! " + {"fire": "ไฟ", "ice": "น้ำแข็ง", "bolt": "ไฟฟ้า"}[el])
	ui.queue_redraw()

# ---------------------------------------------------------------- BATTLE
func _do_bt_dim_dust() -> void:
	_ground_trail("dim", 11.0)

func _set_form(on: bool) -> void:
	form = on
	if on:
		_fx("poof", "dim", hero.position + Vector2(0.0, -60.0), 110.0, 0.6)
		_fx("rays", "dim", hero.position + Vector2(0.0, -60.0), 200.0, 0.6).rx = 300.0
		page.bars.notice("แปลงร่างมิติ!")
		_form_fx = _fx("ward", "dim", hero.position, 70.0, 99999.0, false)
		# ร่างมิติ ตัวอมชมพูเรืองนิดๆ
		if hero.plain_model != null and hero.plain_model.sprite != null:
			hero.plain_model.sprite.self_modulate = Color(1.0, 0.84, 0.97)
	else:
		if is_instance_valid(_form_fx):
			_form_fx.queue_free()
		if hero.plain_model != null and hero.plain_model.sprite != null:
			hero.plain_model.sprite.self_modulate = Color.WHITE

## แปลงร่างมิติ: ลอยขึ้นกลางจอ หมุนตัว ตัวขาว แปลงร่างเสร็จแล้วค่อยๆ ลอยลง เวลาหยุดระหว่างแปลง
func _do_bt_form() -> void:
	page.time_stop(1.9)
	_add({"type": "form_seq", "life": 2.2, "y0": hero.pos.y, "done_form": false})

func _do_bt_rage() -> void:
	_pose()
	hero.plain_atk_t = 15.0
	_fx("poof", "dim", hero.position + Vector2(0.0, -80.0), 70.0, 0.5)

func _do_bt_implode() -> void:
	_pose("stab", 1.0)
	var at := hero.position + Vector2(_f() * 2.0 * U, -60.0)
	_fx("charge", "dim", at, 50.0, 0.7)
	_add({"type": "pull", "pos": at, "life": 0.7, "r": 12.0 * U, "speed": 9.0})
	_later(0.7, func() -> void: _boom(at, 6.0 * U, 2.6 * U, 50.0, "knock", "dim"))

func _do_bt_stomp() -> void:
	_pose("stab", 0.6)
	hero.vel = Vector2(0.0, -26.0)
	_fx("charge", "dim", hero.position + Vector2(0.0, -10.0), 30.0, 0.3)
	_add({"type": "stomp", "life": 3.0})

func _do_bt_drain() -> void:
	_pose("stab", 0.4)
	var list := []
	for m in _mons():
		var dx := (_mc(m).x - hero.position.x) * _f()
		if dx > -20.0 and dx < 5.0 * U and absf(_mc(m).y - hero.position.y + 60.0) < 2.0 * U:
			list.append(m)
	list.sort_custom(func(a: Monster, b: Monster) -> bool: return absf(a.position.x - hero.position.x) < absf(b.position.x - hero.position.x))
	var pts := PackedVector2Array()
	for i in mini(list.size(), 3):
		var m: Monster = list[i]
		_hit(m, 18.0, "flinch", _f())
		hero.mp = minf(hero.mp + 8.0, hero.mp_max())
		pts.append(_mc(m))
		pts.append(_staff())
	if pts.size() > 0:
		var n := _fx("chain", "dim", Vector2.ZERO, 20.0, 0.4)
		n.points = pts

func _do_bt_smash() -> void:
	_pose("stab", 0.6)
	_fx("charge", "dim", _staff(), 34.0, 0.3)
	_later(0.3, func() -> void: _boom(hero.position + Vector2(_f() * 2.0 * U, -50.0), 2.4 * U, 1.4 * U, 40.0, "stun", "dim"))

# ---------------------------------------------------------------- DIMENSION
func _do_dc_pull_ball() -> void:
	_pose()
	_proj("dim", "dim", _staff(), Vector2(_f() * 200.0, 0.0), 34.0, 5.0, "light", {"life": 3.0, "tick": 0.4, "hits": 999, "pull": 4.0 * U})

func _do_dc_air_burst() -> void:
	_pose("stab", 0.5)
	hero.pos.y = maxf(hero.pos.y, 1.2)
	hero.vel.y = 2.0
	_later(0.2, func() -> void: _boom(hero.position + Vector2(0.0, -60.0), 5.0 * U, 2.5 * U, 40.0, "knock", "dim"))

func _do_dc_bounce_field() -> void:
	_pose("stab", 0.5)
	var a := _area("field", "dim", Vector2(hero.position.x + _f() * 3.0 * U, 0.0), 3.5 * U, 3.0, 6.0, "light", {"tick": 0.25, "end_boom": 30.0})
	a["hit_at"] = Vector2(0.0, -3.5 * U * 0.45)

func _do_dc_ram() -> void:
	_pose("stab", 0.4)
	_fx("charge", "dim", _staff(), 30.0, 0.25)
	_later(0.25, func() -> void:
		var n := _fx("dim", "dim", _staff(), 40.0, 0.4, false)
		_add({"type": "slide", "life": 0.35, "speed": 17.0, "dmg": 25.0, "eff": "flinch", "node": n, "once_each": true}))

func _do_dc_ward() -> void:
	_pose()
	buffs["melee_guard"] = 10.0
	_ward("dim", 10.0)

func _do_dc_slide() -> void:
	_pose("stab", 0.7)
	var n := _fx("trail", "dim", hero.position + Vector2(_f() * 60.0, 0.0), 40.0, 0.7, false)
	_add({"type": "slide", "life": 0.6, "speed": 6.5, "dmg": 14.0, "eff": "light", "node": n, "beats": [0.1, 0.3, 0.55], "last": "stun", "drag": true})

# ---------------------------------------------------------------- DARK
func _do_dk_dark_trail() -> void:
	_ground_trail("dark", 12.0)

func _do_dk_smoke_box() -> void:
	_pose()
	_proj("smoke", "dark", Vector2(hero.position.x + _f() * 120.0, 0.0), Vector2(_f() * 110.0, 0.0), 1.6 * U, 7.0, "light", {"life": 4.0, "tick": 0.4, "hits": 999, "ground": true, "hit_at": Vector2(0.0, -1.2 * U)})

func _do_dk_rage() -> void:
	_pose()
	hero.plain_atk_t = 15.0
	_fx("poof", "dark", hero.position + Vector2(0.0, -80.0), 70.0, 0.5)

func _do_dk_chain_orb() -> void:
	_pose("stab", 0.8)
	var above := hero.position + Vector2(0.0, -200.0)
	_fx("charge", "dark", above, 50.0, 0.5)
	_later(0.5, func() -> void:
		_proj("dark", "dark", above, Vector2(_f() * 520.0, -300.0), 46.0, 30.0, "flinch", {"life": 5.0, "gravity": 1500.0, "bounces": 5, "no_touch": true, "hits": 99}))

func _do_dk_dark_burst() -> void:
	_pose("stab", 0.45)
	var c := _fx("circle", "dark", hero.position + Vector2(0.0, -6.0), 5.0 * U, 0.6)
	c.rx = 5.0 * U
	c.ry = 1.2 * U
	_boom(hero.position + Vector2(0.0, -60.0), 5.0 * U, 2.0 * U, 25.0, "strong", "dark")

func _do_dk_web() -> void:
	_pose()
	_proj("dark", "dark", _staff(), Vector2(_f() * 420.0, -420.0), 26.0, 0.0, "none", {"life": 3.0, "gravity": 1300.0, "no_touch": true, "web": true})

func _do_dk_staff_spin() -> void:
	_pose("stab", 0.4)
	_proj("staff", "dark", _staff() + Vector2(0.0, 10.0), Vector2(_f() * 380.0, 0.0), 70.0, 8.0, "light", {"life": 2.5, "tick": 0.2, "hits": 999})

# ---------------------------------------------------------------- ECLIPSE
func _do_ec_bat() -> void:
	_pose()
	_proj("bat", "dark", _staff(), Vector2(_f() * 380.0, 0.0), 30.0, 5.0, "light", {"life": 3.0, "bat": true, "hits": 1, "no_touch": true})

func _do_ec_beam() -> void:
	_pose("stab", 0.3)
	var n := _fx("beam", "dark", _staff(), 50.0, 10.5, false)
	n.angle = 0.0 if _f() > 0.0 else PI
	n.length = 10.0 * U
	n.ry = 46.0
	_beam = {"node": n, "life": 10.0, "tick_t": 0.0, "off": 0.0, "hold_x": hero.pos.x}

func _end_beam() -> void:
	if is_instance_valid(_beam.get("node")):
		(_beam["node"] as Node).queue_free()
	if not _beam.is_empty():
		hero.plain_swing = 0.0
	_beam = {}

func _do_ec_void_pull() -> void:
	_pose("stab", 0.5)
	var at := Vector2(hero.position.x + _f() * 3.0 * U, -80.0)
	var a := _area("dark", "dark", at, 50.0, 2.5, 5.0, "light", {"tick": 0.4, "pull": 5.0 * U, "weak": true})
	a["hit_r"] = 1.5 * U

func _do_ec_sky_burst() -> void:
	_pose("stab", 0.5)
	_proj("dark", "dark", _staff(), Vector2(0.0, -800.0), 40.0, 0.0, "none", {"life": 0.5, "no_touch": true, "end_boom": [7.0 * U, 3.0 * U, 45.0, "flinch"]})

func _do_ec_ward() -> void:
	_pose()
	buffs["ranged_guard"] = 10.0
	_ward("dark", 10.0)

func _do_ec_dark_spread() -> void:
	_spread("dark", "dark")

# ---------------------------------------------------------------- ALCHEMIST
func _do_al_poison_trail() -> void:
	_ground_trail("poison", 12.0, {"burn": "poison"})

func _potion_drop(x: float, dmg: float, splash: float, pool := 0.0) -> void:
	var from := Vector2(x, -7.0 * U)
	_proj("potion", "poison", from, Vector2(0.0, 900.0), 26.0, dmg, "flinch", {"ground_end": true, "boom": [splash, splash * 0.5], "life": 2.0, "hits": 99, "no_touch": true, "extra": {"burn": "poison"}, "pool": pool, "mana_back": 20.0})

func _do_al_potion_rain() -> void:
	_pose()
	var n := randi_range(1, 3)
	for i in n:
		var x := hero.position.x + _f() * randf_range(1.0, 8.0) * U
		_later(float(i) * 0.15, func() -> void: _potion_drop(x, 18.0, 1.6 * U))

func _do_al_brew_buff() -> void:
	_pose()
	hero.plain_atk_t = 15.0
	buffs["mana_save"] = 15.0
	_fx("poof", "poison", hero.position + Vector2(0.0, -80.0), 70.0, 0.5)

func _do_al_acid_rain() -> void:
	_pose("stab", 0.6)
	var at := Vector2(hero.position.x + _f() * 1.5 * U, 0.0)
	_fx("cauldron", "poison", at, 50.0, 4.5)
	var w := 8.0 * U
	var cloud := _area("rain", "poison", Vector2(hero.position.x + _f() * 4.0 * U, 0.0), w, 4.0, 6.0, "light", {"tick": 0.35, "hit_r": 0.0, "acid": true, "extra": {"burn": "poison"}})
	(cloud["node"] as SusiFx).rx = w
	(cloud["node"] as SusiFx).ry = 6.0 * U

func _do_al_glitter_bomb() -> void:
	_pose()
	_proj("potion", "poison", _staff(), Vector2(_f() * 650.0, -250.0), 26.0, 30.0, "flinch", {"gravity": 900.0, "life": 2.0, "hits": 1, "end_boom": [], "glitter": true, "extra": {"burn": "poison"}})

func _do_al_ore_line() -> void:
	_pose("stab", 0.8)
	page.shake_left = maxf(page.shake_left, 0.25)
	var ores := []
	for i in 10:
		var x := hero.position.x + _f() * (1.2 + float(i) * 0.9) * U
		_later(float(i) * 0.08, func() -> void: ores.append(_fx("ore", "ore", Vector2(x, 0.0), 150.0 if i > 0 else 175.0, 1.6, false)))
	for i in 10:
		_later(0.9 + float(i) * 0.09, func() -> void:
			if i < ores.size() and is_instance_valid(ores[i]):
				var p: Vector2 = (ores[i] as Node2D).position
				(ores[i] as Node).queue_free()
				_boom(p + Vector2(0.0, -120.0), 2.4 * U, 1.6 * U, 22.0, "flinch", "ore")
				# วงชมพูบนพื้น เดินผ่านแล้วเร็วขึ้น
				var ring := _area("circle", "ore", p + Vector2(0.0, -4.0), 0.8 * U, 6.0, 0.0, "none", {"speed_zone": true, "hit_r": 0.0})
				(ring["node"] as SusiFx).rx = 0.8 * U
				(ring["node"] as SusiFx).ry = 0.25 * U)

func _do_al_potions() -> void:
	_pose()
	var upgraded := has("su_tm_homun_up")
	_drop_bottle("mana", hero.position.x + _f() * 1.5 * U)
	if not upgraded:
		_drop_bottle("poison", hero.position.x - _f() * 1.5 * U)
	else:
		# TRANSMUTATION 60.1 ไม่ต้องเก็บ ได้ทันที และติด SA
		_pickup("mana")
		hero.plain_sa_t = maxf(hero.plain_sa_t, 8.0)

func _drop_bottle(kind: String, x: float) -> void:
	var n := _fx("bottle", kind, Vector2(x, 0.0), 26.0, 30.0, false)
	_pickups.append([n, kind, 30.0])

func _pickup(kind: String) -> void:
	if kind == "mana":
		hero.mp = minf(hero.mp + 40.0, hero.mp_max())
		page.bars.notice("ขวดมานา +40")
	else:
		poison_hits_t = 15.0
		page.bars.notice("ตีติดพิษ 15 วิ")
	_fx("poof", kind, hero.position + Vector2(0.0, -60.0), 50.0, 0.4)

# ---------------------------------------------------------------- TRANSMUTATION
func _do_tm_homunculus() -> void:
	_pose()
	if is_instance_valid(_homun):
		_homun.queue_free()
	_homun = _fx("homun", "ore", hero.position + Vector2(-_f() * 80.0, -170.0), 26.0, 99999.0, false)
	_homun_t = 30.0
	_homun_shot = 0.5

func _tick_homun(delta: float) -> void:
	if not is_instance_valid(_homun):
		return
	_homun_t -= delta
	if _homun_t <= 0.0:
		_fx("poof", "ore", _homun.position, 40.0, 0.4)
		_homun.queue_free()
		return
	var want := hero.position + Vector2(-_f() * 80.0, -170.0)
	_homun.position = _homun.position.lerp(want, 1.0 - exp(-5.0 * delta))
	_homun_shot -= delta
	if _homun_shot <= 0.0:
		_homun_shot = 5.0
		var tgt := _nearest(_homun.position, 9.0 * U)
		var v := ((_mc(tgt) - _homun.position).normalized() if tgt != null else Vector2(_f(), 0.0)) * 700.0
		var dmg := 14.0 * (2.0 if has("su_tm_homun_up") else 1.0)
		for k in 3:
			_proj("dim", "ore", _homun.position, v.rotated((float(k) - 1.0) * 0.12), 12.0, dmg, "light", {"life": 1.2, "hits": 1})

func _do_tm_poison_pool() -> void:
	_pose()
	_proj("potion", "poison", _staff(), Vector2(_f() * 500.0, -380.0), 24.0, 0.0, "none", {"gravity": 1300.0, "life": 2.0, "no_touch": true, "pool_land": 4.0})

func _do_tm_triple_blast() -> void:
	_pose("stab", 0.5)
	_proj("potion", "poison", _staff(), Vector2(_f() * 600.0, -300.0), 26.0, 0.0, "none", {"gravity": 1100.0, "life": 2.0, "no_touch": true, "triple": true})

## TRANS 45.2 เส้นผลึกเงินตรงพุ่งไปข้างหน้า แล้วแตกกิ่งออกไปเรื่อยๆ ระยะราว 1 จอ โดนทั่วถึง
func _do_tm_silver_crystal() -> void:
	_pose("stab", 0.5)
	var length := 24.0 * U
	var start := hero.position + Vector2(_f() * 60.0, -60.0)
	var segs: Array = []
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	# เส้นหลัก
	var prev := Vector2.ZERO
	var steps := 16
	for i in range(1, steps + 1):
		var x := length * float(i) / float(steps)
		var p := Vector2(x, rng.randf_range(-18.0, 18.0))
		segs.append([prev, p, prev.x])
		# แตกกิ่งจากเส้นหลัก ยิ่งไกลยิ่งแตกเยอะ
		var branches := 1 + floori(float(i) / 5.0)
		for b in branches:
			var side := -1.0 if (i + b) % 2 == 0 else 1.0
			var ang := deg_to_rad(rng.randf_range(20.0, 50.0)) * side
			var blen := rng.randf_range(1.2, 2.6) * U * (0.7 + float(i) / float(steps))
			var tip := p + Vector2(cos(ang), sin(ang)) * blen
			segs.append([p, tip, p.x])
			# กิ่งย่อย
			var ang2 := ang + deg_to_rad(rng.randf_range(15.0, 35.0)) * side
			segs.append([tip, tip + Vector2(cos(ang2), sin(ang2)) * blen * 0.5, tip.x])
		prev = p
	var node := _fx("branch", "silver", start, 30.0, 1.6, true)
	node.scale = Vector2(_f(), 1.0)
	node.segs = segs
	_add({"type": "branch", "node": node, "pos": start, "life": 1.3, "front": 0.0, "len": length, "speed": length / 0.7, "dmg": 24.0, "eff": "flinch"})

func _do_tm_ward() -> void:
	_pose()
	buffs["ranged_guard"] = 10.0
	_ward("poison", 10.0)

func _do_tm_poison_rings() -> void:
	_pose()
	var nodes := []
	for i in 2:
		nodes.append(_fx("ring", "poison", hero.position, 30.0, 8.2, false))
	_add({"type": "orbit", "nodes": nodes, "life": 8.0, "r": 60.0, "dmg": 7.0, "eff": "light", "tick": 0.35, "extra": {"burn": "poison"}})

func _ward(el: String, time: float) -> void:
	if is_instance_valid(_ward_fx):
		_ward_fx.queue_free()
	_ward_fx = _fx("ward", el, hero.position, 70.0, time, false)
	_ward_fx.set_meta("until", time)

# ---------------------------------------------------------------- กดค้าง
func _start_channel(id: String, every: float, max_time: float, drain: float, fn: Callable, float_up := false) -> void:
	_channel = {"id": id, "every": every, "t": 0.0, "left": max_time, "drain": drain, "fn": fn, "float": float_up, "min": 0.6}
	fn.call()

func _held() -> bool:
	var b: String = page._skill_button
	return b != "" and page.pad.is_held(b)

# ---------------------------------------------------------------- ทุกเฟรม
func _process(delta: float) -> void:
	if page == null:
		return
	for k in cds.keys():
		cds[k] = maxf(float(cds[k]) - delta, 0.0)
	for k in buffs.keys():
		buffs[k] = float(buffs[k]) - delta
		if float(buffs[k]) <= 0.0:
			buffs.erase(k)
	_counter_cd = maxf(_counter_cd - delta, 0.0)
	_apply_passives(delta)
	if is_instance_valid(_form_fx):
		_form_fx.position = hero.position
	if is_instance_valid(_ward_fx):
		_ward_fx.position = hero.position
	_tick_channel(delta)
	_tick_beam(delta)
	_tick_homun(delta)
	poison_hits_t = maxf(poison_hits_t - delta, 0.0)
	for p in _pickups.duplicate():
		var n: SusiFx = p[0]
		p[2] = float(p[2]) - delta
		if not is_instance_valid(n) or float(p[2]) <= 0.0:
			if is_instance_valid(n):
				n.queue_free()
			_pickups.erase(p)
		elif absf(n.position.x - hero.position.x) < 0.8 * U and hero.pos.y < 1.0:
			_pickup(str(p[1]))
			n.queue_free()
			_pickups.erase(p)
	for o in _objs.duplicate():
		_tick_obj(o, delta)
	ui.queue_redraw()

func _apply_passives(delta: float) -> void:
	var bonus := 0.0
	if has("su_bt_power"):
		bonus += Stats.MP_UP
	if has("su_em_mana"):
		bonus += Stats.MP_UP
	if has("su_ec_mana"):
		bonus += Stats.MP_UP
	if has("su_tm_mana"):
		bonus += Stats.MP_UP
	hero.mp_bonus = bonus
	var regen := 1.0
	if has("su_em_flow"):
		regen *= 1.5
	if has("su_ec_mana"):
		regen *= 1.5
	hero.regen_mult = regen
	# ARCH 35.1 ฟื้นมานา 20 หน่วยต่อวินาที
	if buffs.has("mana_up"):
		hero.mp = minf(hero.mp + 20.0 * delta, hero.mp_max())
	hero.speed_bonus = Stats.SPEED_MULT if has("su_dc_flow") else 1.0
	if buffs.has("ore_speed"):
		hero.speed_bonus *= Stats.SPEED_MULT
	hero.ranged_guard_t = float(buffs.get("ranged_guard", 0.0))
	hero.melee_guard_t = float(buffs.get("melee_guard", 0.0))
	hero.susi_counter_t = float(buffs.get("counter", 0.0))
	hero.susi_save_t = float(buffs.get("mana_save", 0.0))
	hero.susi_mana_t = float(buffs.get("mana_up", 0.0))
	# ยืนในใยแมงมุม มานาฟื้น
	for o in _objs:
		if o.get("web_zone", false) and absf(hero.position.x - (o["pos"] as Vector2).x) < float(o["r"]) and hero.pos.y < 1.0:
			hero.mp = minf(hero.mp + 20.0 * delta, hero.mp_max())

func _tick_channel(delta: float) -> void:
	if _channel.is_empty():
		return
	_channel["left"] = float(_channel["left"]) - delta
	_channel["min"] = float(_channel["min"]) - delta
	var drain := float(_channel["drain"]) * delta * (0.5 if buffs.has("mana_save") else 1.0)
	var keep := (_held() or float(_channel["min"]) > 0.0) and float(_channel["left"]) > 0.0 and hero.mp >= drain and hero.hurt_t <= 0.0
	if not keep:
		_channel = {}
		# ปล่อยปุ่มแล้วคืนท่า ขยับได้ทันที
		hero.plain_swing = 0.0
		return
	hero.mp -= drain
	hero.plain_swing = maxf(hero.plain_swing, 0.3)
	if str(_channel["id"]) == "su_em_float_bolts":
		hero.pos.y = lerpf(hero.pos.y, 1.6, 1.0 - exp(-6.0 * delta))
		hero.vel.y = 0.0
	_channel["t"] = float(_channel["t"]) + delta
	if float(_channel["t"]) >= float(_channel["every"]):
		_channel["t"] = 0.0
		(_channel["fn"] as Callable).call()

func _tick_beam(delta: float) -> void:
	if _beam.is_empty():
		return
	_beam["life"] = float(_beam["life"]) - delta
	var n: SusiFx = _beam["node"]
	if float(_beam["life"]) <= 0.0 or hero.hurt_t > 0.0 or not is_instance_valid(n):
		_end_beam()
		return
	# ยืนนิ่งตอนยิง บังคับขึ้นลงด้วยปุ่มกระโดด / ปุ่มลง / จอยสติก
	hero.pos.x = float(_beam["hold_x"])
	hero.vel.x = 0.0
	hero.plain_swing = maxf(hero.plain_swing, 0.3)
	var v := page.joy.vector() if page.joy != null else Vector2.ZERO
	var steer := 0.0
	if page.pad.is_held("jump") or v.y < -0.4 or Input.is_key_pressed(KEY_UP):
		steer = -1.0
	elif page.pad.is_held("down") or v.y > 0.4 or Input.is_key_pressed(KEY_DOWN):
		steer = 1.0
	_beam["off"] = clampf(float(_beam["off"]) + steer * 1.3 * delta, -1.0, 0.7)
	var base := 0.0 if _f() > 0.0 else PI
	n.angle = base + float(_beam["off"]) * _f()
	n.position = _staff()
	_beam["tick_t"] = float(_beam["tick_t"]) - delta
	if float(_beam["tick_t"]) <= 0.0:
		_beam["tick_t"] = 0.25
		for m in _on_segment(n.position, n.angle, n.length, n.ry):
			_hit(m, 6.0, "light", _f())

func _on_segment(from: Vector2, ang: float, length: float, w: float) -> Array:
	var u := Vector2(cos(ang), sin(ang))
	var out := []
	for m in _mons():
		var d := _mc(m) - from
		var along := d.dot(u)
		if along < -20.0 or along > length * GROW:
			continue
		if absf(d.dot(u.orthogonal())) <= w * GROW + WalkPage.MONSTER_HIT_R:
			out.append(m)
	return out

func _end(o: Dictionary) -> void:
	_objs.erase(o)
	if o.has("node") and is_instance_valid(o["node"]):
		(o["node"] as Node).queue_free()
	if o.has("nodes"):
		for n in o["nodes"]:
			if is_instance_valid(n):
				(n as Node).queue_free()

func _tick_obj(o: Dictionary, delta: float) -> void:
	o["age"] = float(o["age"]) + delta
	o["life"] = float(o["life"]) - delta
	var t: String = o["type"]
	match t:
		"timer":
			if float(o["life"]) <= 0.0:
				_objs.erase(o)
				(o["fn"] as Callable).call()
			return
		"pull":
			for m in _mons():
				if _mc(m).distance_to(o["pos"]) <= float(o["r"]) and not ROLES_HEAVY(m):
					m.pos.x = move_toward(m.pos.x, (o["pos"] as Vector2).x / U, float(o["speed"]) * delta)
			if float(o["life"]) <= 0.0:
				_objs.erase(o)
			return
		"branch":
			# ผลึกงอกไปข้างหน้า โดนมอนที่แนวผลึกผ่าน แล้วตอนจบโดนอีกทีทั้งแนว
			var old := float(o["front"])
			o["front"] = minf(old + float(o["speed"]) * delta, float(o["len"]))
			var n: SusiFx = o["node"]
			if is_instance_valid(n):
				n.front = float(o["front"])
			var sx := (o["pos"] as Vector2).x
			for m in _mons():
				var d := (_mc(m).x - sx) * _f()
				if d >= old - 40.0 and d < float(o["front"]) + 40.0 and absf(_mc(m).y - (o["pos"] as Vector2).y) < 3.2 * U and not m in (o["done"] as Array):
					(o["done"] as Array).append(m)
					_hit(m, float(o["dmg"]), "flinch", _f())
					_fx("poof", "silver", _mc(m), 40.0, 0.4)
			if float(o["life"]) <= 0.0:
				for m in o["done"]:
					if is_instance_valid(m) and (m as Monster).state != "dead":
						_hit(m, 18.0, "launch", _f())
				_objs.erase(o)
			return
		"form_seq":
			var age := float(o["age"])
			hero.vel = Vector2.ZERO
			hero.plain_swing = maxf(hero.plain_swing, 0.3)
			if hero.plain_model != null:
				hero.plain_model.turn_extra = fmod(hero.plain_model.turn_extra + (1100.0 if age < 0.8 else 300.0) * delta, 360.0)
			if age < 0.8:
				# ลอยขึ้นกลางจอ หมุนตัว ตัวขาว
				var k := 1.0 - pow(1.0 - age / 0.8, 3.0)
				hero.pos.y = lerpf(float(o["y0"]), 3.6, k)
				hero.flash_t = Hero.FLASH_TIME
				if int(age * 20.0) % 3 == 0:
					_fx("poof", "dim", hero.position + Vector2(randf_range(-60.0, 60.0), -60.0 + randf_range(-60.0, 60.0)), 26.0, 0.4)
			else:
				if not o["done_form"]:
					o["done_form"] = true
					_set_form(true)
				# ค่อยๆ ลอยลงมา
				hero.pos.y = maxf(hero.pos.y - 2.6 * delta, 0.0)
			hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
			if (age > 0.8 and hero.pos.y <= 0.0) or float(o["life"]) <= 0.0:
				_objs.erase(o)
				hero.plain_swing = 0.0
				if hero.plain_model != null:
					hero.plain_model.turn_extra = 0.0
				if not o["done_form"]:
					_set_form(true)
			return
		"stomp":
			if hero.on_floor() or float(o["life"]) <= 0.0:
				_objs.erase(o)
				_boom(hero.position + Vector2(0.0, -30.0), 4.0 * U, 1.6 * U, 35.0, "launch", "dim")
			return
		"orbit":
			var nodes: Array = o["nodes"]
			for i in nodes.size():
				var ang := float(o["age"]) * 4.0 + TAU * float(i) / float(nodes.size())
				(nodes[i] as Node2D).position = hero.position + Vector2(cos(ang) * 2.4 * U, sin(ang) * 0.5 * U - 10.0)
			_ticks(o, delta, func() -> Array:
				var out := []
				for n in nodes:
					for m in _in_circle((n as Node2D).position + Vector2(0.0, -60.0), 1.1 * U):
						if not m in out:
							out.append(m)
				return out)
		"slide":
			var step := float(o["speed"]) * delta * _f()
			hero.pos.x = clampf(hero.pos.x + step, -hero.half_width, hero.half_width)
			hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
			if is_instance_valid(o.get("node")):
				(o["node"] as Node2D).position = hero.position + Vector2(_f() * 70.0, -60.0 if o.has("once_each") else 0.0)
			var front := _in_circle(hero.position + Vector2(_f() * 1.0 * U, -60.0), 1.3 * U)
			if o.get("drag", false):
				for m in front:
					m.pos.x = clampf(m.pos.x + step, -m.half_width, m.half_width)
			if o.has("once_each"):
				for m in front:
					if not m in (o["done"] as Array):
						(o["done"] as Array).append(m)
						_hit(m, float(o["dmg"]), str(o["eff"]), _f())
			elif o.has("beats"):
				var beats: Array = o["beats"]
				if beats.size() > 0 and float(o["age"]) >= float(beats[0]):
					beats.pop_front()
					var eff: String = str(o["last"]) if beats.is_empty() else str(o["eff"])
					for m in front:
						_hit(m, float(o["dmg"]), eff, _f())
		"beam":
			_ticks(o, delta, func() -> Array: return _on_segment(o["pos"], float(o["ang"]), float(o["len"]), float(o["w"])))
		"area":
			var node: SusiFx = o["node"]
			var hit_at: Vector2 = o.get("hit_at", Vector2(0.0, -40.0))
			var hit_r := float(o.get("hit_r", o["r"]))
			if o.has("pull"):
				for m in _mons():
					if _mc(m).distance_to(o["pos"]) <= float(o["pull"]) and not ROLES_HEAVY(m):
						m.pos.x = move_toward(m.pos.x, (o["pos"] as Vector2).x / U, 4.0 * delta)
			if o.get("once", false):
				if not o.get("fired", false):
					o["fired"] = true
					for m in _in_circle((o["pos"] as Vector2) + hit_at, hit_r):
						_hit(m, float(o["dmg"]), str(o["eff"]), signf(_mc(m).x - (o["pos"] as Vector2).x))
						if o.has("freeze"):
							m.freeze_ice(float(o["freeze"]))
			elif o.get("root", false):
				_ticks(o, delta, func() -> Array:
					var list := _in_ellipse((o["pos"] as Vector2) + Vector2(0.0, -40.0), float(o["r"]), 1.6 * U)
					for m in list:
						m.root_t = maxf(m.root_t, 1.0)
					return list)
			else:
				_ticks(o, delta, func() -> Array:
					var list := _in_circle((o["pos"] as Vector2) + hit_at, hit_r)
					if o.get("weak", false):
						for m in list:
							m.weak_t = maxf(m.weak_t, 3.0)
					return list)
			if o.get("acid_pool", false):
				_ticks(o, delta, func() -> Array: return _in_ellipse((o["pos"] as Vector2) + Vector2(0.0, -40.0), float(o["r"]), 1.2 * U))
			if o.get("speed_zone", false) and absf(hero.position.x - (o["pos"] as Vector2).x) < float(o["r"]) and hero.pos.y < 1.0:
				buffs["ore_speed"] = 3.0
			if o.get("acid", false):
				_ticks(o, delta, func() -> Array:
					var list := []
					for m in _mons():
						if absf(_mc(m).x - (o["pos"] as Vector2).x) <= float(o["r"]) * GROW:
							list.append(m)
					return list)
			if o.get("web_zone", false):
				_ticks(o, delta, func() -> Array:
					var list := _in_ellipse((o["pos"] as Vector2) + Vector2(0.0, -40.0), float(o["r"]), 1.2 * U)
					for m in list:
						m.slow_t = maxf(m.slow_t, 1.0)
					return list)
			if is_instance_valid(node):
				node.position = o["pos"]
			if float(o["life"]) <= 0.0:
				if o.has("end_boom"):
					_boom((o["pos"] as Vector2) + Vector2(0.0, -float(o["r"]) * 0.45), float(o["r"]), float(o["r"]) * 0.5, float(o["end_boom"]), "knock", "dim")
				_end(o)
			return
		"attach":
			var m: Monster = o["target"]
			var node: SusiFx = o["node"]
			if is_instance_valid(m) and m.state != "dead":
				o["pos"] = _mc(m) + Vector2(0.0, -40.0)
				_ticks(o, delta, func() -> Array:
					hero.hp = minf(hero.hp + 2.0, hero.hp_max())
					return [m])
			if is_instance_valid(node):
				node.position = o["pos"]
			if float(o["life"]) <= 0.0 or not is_instance_valid(m) or m.state == "dead":
				if is_instance_valid(m) and m.state != "dead":
					_hit(m, 25.0, "launch", _f())
				_fx("boom", "dark", o["pos"], 60.0, 0.4)
				_end(o)
			return
		"proj":
			_tick_proj(o, delta)
			return
	if float(o["life"]) <= 0.0:
		_end(o)

## มอนตัวใหญ่ (บอส มินิบอส แทงค์) ไม่ถูกดูด
func ROLES_HEAVY(m: Monster) -> bool:
	return m.role.begins_with("boss_") or m.role == "midboss" or m.role == "tank"

## โดนทุก tick วินาที (ถ้า tick 0 คือโดนครั้งเดียวต่อตัว)
func _ticks(o: Dictionary, delta: float, targets: Callable) -> void:
	if float(o["tick"]) <= 0.0:
		for m in targets.call():
			if m in (o["done"] as Array):
				continue
			(o["done"] as Array).append(m)
			_hit(m, float(o["dmg"]), str(o["eff"]), _f(), o.get("extra", {}))
		return
	o["tick_t"] = float(o["tick_t"]) - delta
	if float(o["tick_t"]) <= 0.0:
		o["tick_t"] = float(o["tick"])
		for m in targets.call():
			_hit(m, float(o["dmg"]), str(o["eff"]), signf(_mc(m).x - (o["pos"] as Vector2).x) if _mc(m).x != (o["pos"] as Vector2).x else _f(), o.get("extra", {}))

func _tick_proj(o: Dictionary, delta: float) -> void:
	var node: SusiFx = o["node"]
	var vel: Vector2 = o["vel"]
	var pos: Vector2 = o["pos"]
	if o.has("gravity"):
		vel.y += float(o["gravity"]) * delta
	if o.has("homing"):
		var tgt: Monster = o.get("target")
		if tgt == null or not is_instance_valid(tgt) or tgt.state == "dead":
			tgt = _nearest(pos, 9.0 * U, o.get("recent", []))
			o["target"] = tgt
		if tgt != null:
			var want := (_mc(tgt) - pos).normalized() * float(o["homing"])
			if o.get("ground", false):
				want.y = 0.0
			vel = vel.lerp(want, 1.0 - exp(-5.0 * delta))
	pos += vel * delta
	if o.has("wave"):
		var w: Array = o["wave"]
		pos.y = float(o["base_y"]) + sin(float(o["age"]) * float(w[1]) + float(w[2])) * float(w[0])
	if o.get("ground", false):
		pos.y = 0.0
	# เด้งกับพื้น (ลูกมืดโซ่ตรวน) ระเบิดทรงกระบอกทุกครั้งที่เด้ง
	if o.has("bounces") and pos.y >= -10.0 and vel.y > 0.0:
		pos.y = -10.0
		vel.y = -620.0
		o["bounces"] = int(o["bounces"]) - 1
		var p := _fx("pillar", "dark", Vector2(pos.x, 0.0), 0.8 * U, 0.5)
		p.r = 0.9 * U
		_boom(Vector2(pos.x, -60.0), 2.0 * U, 1.5 * U, float(o["dmg"]), "flinch", "dark")
		if int(o["bounces"]) <= 0:
			o["life"] = 0.0
	# ขวดพิษตกพื้น เกิดบ่อพิษ / ระเบิด 3 ลูก
	if (o.has("pool_land") or o.get("triple", false)) and pos.y >= -10.0 and vel.y > 0.0:
		if o.has("pool_land"):
			var pool := _area("web", "poison", Vector2(pos.x, -4.0), 2.2 * U, float(o["pool_land"]), 7.0, "light", {"tick": 0.4, "hit_r": 0.0, "acid_pool": true, "extra": {"burn": "poison"}})
			pool["web_zone"] = false
			pool["acid"] = false
			pool["pool_r"] = 2.2 * U
		else:
			for k in 3:
				var bx := pos.x + _f() * float(k) * 1.6 * U
				_later(float(k) * 0.18, func() -> void: _boom(Vector2(bx, -60.0), 1.9 * U, 1.3 * U, 38.0, "knock", "poison", {"burn": "poison"}))
		_end(o)
		return
	# ลูกใยแมงมุม ตกพื้นแล้วกางใย
	if o.get("web", false) and pos.y >= -10.0 and vel.y > 0.0:
		var a := _area("web", "dark", Vector2(pos.x, -4.0), 3.0 * U, 5.0, 6.0, "light", {"tick": 0.5, "web_zone": true, "hit_r": 0.0})
		a["hit_r"] = 0.0
		_end(o)
		return
	# ตกพื้นแล้วระเบิด (อุกกาบาต)
	if o.get("ground_end", false) and pos.y >= -30.0:
		if o.get("mana_back", 0.0) > 0.0:
			hero.mp = minf(hero.mp + float(o["mana_back"]), hero.mp_max())
			_fx("poof", "mana", hero.position + Vector2(0.0, -90.0), 30.0, 0.35)
		var b: Array = o["boom"]
		_boom(Vector2(pos.x, -40.0), float(b[0]), float(b[1]), float(o["dmg"]), str(o["eff"]), node.element, o.get("extra", {}))
		_end(o)
		return
	o["vel"] = vel
	o["pos"] = pos
	if is_instance_valid(node):
		node.position = pos
		if vel.x != 0.0:
			node.dir = signf(vel.x)
	# ลากมอนไปกับพายุลม
	if o.get("carry", false):
		for m in _in_circle(pos + Vector2(0.0, -float(o["r"]) * 0.5), float(o["r"])):
			if not ROLES_HEAVY(m):
				m.pos.x = move_toward(m.pos.x, pos.x / U, (absf(vel.x) / U + 1.5) * delta)
	if o.has("pull"):
		for m in _mons():
			if _mc(m).distance_to(pos) <= float(o["pull"]) and not ROLES_HEAVY(m):
				m.pos.x = move_toward(m.pos.x, pos.x / U, 3.5 * delta)
	if not o.get("no_touch", false):
		var hit_at: Vector2 = o.get("hit_at", Vector2.ZERO)
		var hit_pos := pos + hit_at + (Vector2(0.0, -40.0) if o.get("ground", false) and not o.has("hit_at") else Vector2.ZERO)
		var r := float(o["r"]) * (0.6 if o.get("ground", false) and float(o["r"]) > U else 1.0)
		if float(o["tick"]) > 0.0:
			o["tick_t"] = float(o["tick_t"]) - delta
			if float(o["tick_t"]) <= 0.0:
				var list := _in_circle(hit_pos, r)
				if not list.is_empty():
					o["tick_t"] = float(o["tick"])
					for m in list:
						_hit(m, float(o["dmg"]), str(o["eff"]), signf(vel.x) if vel.x != 0.0 else _f(), o.get("extra", {}))
					# ลูกชิ่ง โดนแล้วเปลี่ยนเป้าไปตัวอื่น
					if o.get("bounce", false):
						var recent: Array = o.get("recent", [])
						recent.append(list[0])
						if recent.size() > 2:
							recent.pop_front()
						o["recent"] = recent
						o["target"] = null
		else:
			for m in _in_circle(hit_pos, r):
				if m in (o["done"] as Array):
					continue
				(o["done"] as Array).append(m)
				if o.get("bat", false):
					_add({"type": "attach", "target": m, "node": node, "life": 4.0, "tick": 0.5, "dmg": 5.0, "eff": "light", "pos": pos})
					_objs.erase(o)
					return
				_hit(m, float(o["dmg"]), str(o["eff"]), signf(vel.x) if vel.x != 0.0 else _f(), o.get("extra", {}))
				o["hits"] = int(o["hits"]) - 1
				if int(o["hits"]) <= 0:
					o["life"] = 0.0
					break
	if o.get("glitter", false) and (pos.y >= -10.0 or float(o["life"]) <= 0.0 or int(o["hits"]) <= 0):
		_boom(Vector2(pos.x, minf(pos.y, -40.0)), 2.2 * U, 1.4 * U, float(o["dmg"]), "flinch", "ore", {"burn": "poison"})
		_fx("poof", "ore", pos, 70.0, 0.5)
		_end(o)
		return
	if float(o["life"]) <= 0.0 or absf(pos.x - hero.position.x) > 30.0 * U:
		if o.has("end_boom") and not (o["end_boom"] as Array).is_empty():
			var e: Array = o["end_boom"]
			_boom(Vector2(hero.position.x, -100.0), float(e[0]), float(e[1]), float(e[2]), str(e[3]), "dark")
		_end(o)

# ---------------------------------------------------------------- พาสซีฟที่ต่อกับระบบเดิม
## ตัวคูณดาเมจตอนตีโดน
func dmg_mult(m: Monster, h: Dictionary) -> float:
	var k := 1.0
	if has("su_al_arche"):
		k *= Stats.ATK_MULT
	if has("su_tm_toxic") and m.burn_kind == "poison" and m.burn_t > 0.0:
		k *= 1.3
	if has("su_bt_power"):
		k *= Stats.ATK_MULT
	if has("su_ec_might"):
		k *= Stats.ATK_MULT
	if has("su_dk_orb_up") and not h.get("skill", false):
		k *= 1.25
	if has("su_dc_flow") and m.hp <= m.max_hp * 0.5:
		k *= 1.25
	return k

## ตีโดนแล้ว ผลเสริมของพาสซีฟ
func on_strike(m: Monster, h: Dictionary) -> void:
	if poison_hits_t > 0.0 and not h.has("burn"):
		m.burn_kind = "poison"
		m.burn_t = Monster.BURN_TIME
	if has("su_ec_might") and randf() < 0.15:
		m.armor_t = maxf(m.armor_t, 5.0)
	if form and not h.get("skill", false):
		hero.mp = minf(hero.mp + 2.0, hero.mp_max())
	if h.get("susi_mana", false) and has("su_em_mana"):
		hero.mp = minf(hero.mp + 4.0, hero.mp_max())

## ลูกไฟของคอมโบ  shot = [ลูก ความเร็ว ทะลุ ที่โดน อายุ ดาเมจ ผล ...]
func mod_shot(shot: Array) -> void:
	var ball := shot[0] as CatFireball
	if has("su_ar_range"):
		shot[2] = int(shot[2]) + 2
		shot[4] = float(shot[4]) * 1.5
	if has("su_em_mana"):
		var extra: Dictionary = (shot[6] as Dictionary).duplicate()
		extra["susi_mana"] = true
		shot[6] = extra
	# ร่างมิติ ลูกบอลมิติชมพูใหญ่ ช้า ฮิตน้อย
	if form:
		shot[1] = (shot[1] as Vector2) * 0.45
		ball.radius *= 1.25
		shot[2] = 1
		shot[4] = float(shot[4]) * 2.0
		shot[5] = float(shot[5]) * 1.6

func _on_hurt(_kind: String) -> void:
	if has("su_dc_hurt_mana"):
		hero.mp = minf(hero.mp + 12.0, hero.mp_max())
	if buffs.has("counter") and _counter_cd <= 0.0:
		_counter_cd = 0.8
		_boom(hero.position + Vector2(0.0, -60.0), 3.5 * U, 1.8 * U, 0.0, "push", "arcane")

# ---------------------------------------------------------------- UI คูลดาวน์บนช่องสกิล เกจธาตุ
func _draw_ui() -> void:
	var font := Sketch.font()
	if page.pad.visible:
		for i in page.pad.slot_ids.size():
			var id := str(page.pad.slot_ids[i])
			var left := cd_left(id)
			if id == "" or left <= 0.0:
				continue
			var r: Rect2 = page.pad.cell_rect("s%d" % i)
			var k := clampf(left / maxf(cooldown(id), 0.01), 0.0, 1.0)
			TouchPad.draw_cd(ui, r, k, left)
	# ระหว่าง HYPER ซ่อนเกจธาตุ ให้จอเป็นภาพล้วน
	if has("su_em_memory") and not is_instance_valid(page.hyper):
		_draw_memory(font)

## เกจท่องจำธาตุ หกเหลี่ยม 3 อันเรียงเป็นสามเหลี่ยม ขอบสีตามธาตุ ข้างในเติมสีตามเปอร์เซ็นต์ มีตัวเลข %
func _draw_memory(font: Font) -> void:
	var colors := {"fire": Color(1.0, 0.45, 0.2), "ice": Color(0.4, 0.78, 1.0), "bolt": Color(0.98, 0.85, 0.25)}
	var r := 27.0
	var base := Vector2(640.0, 62.0)
	var spots := {"fire": base + Vector2(0.0, -r * 0.95), "ice": base + Vector2(-r * 0.92, r * 0.62), "bolt": base + Vector2(r * 0.92, r * 0.62)}
	for el in ["fire", "ice", "bolt"]:
		var c: Vector2 = spots[el]
		var col: Color = colors[el]
		var pct := clampf(float(gauge[el]), 0.0, 100.0)
		var hexa := PackedVector2Array()
		for i in 6:
			var ang := PI / 6.0 + float(i) * PI / 3.0
			hexa.append(c + Vector2(cos(ang), sin(ang)) * r)
		ui.draw_colored_polygon(hexa, Color(1.0, 1.0, 1.0, 0.88))
		# เติมจากล่างขึ้นบนตามเปอร์เซ็นต์ (หกเหลี่ยมเล็กลงตามสัดส่วน ไม่ต้องตัดรูป)
		if pct > 0.0:
			var inner := PackedVector2Array()
			var k := 0.25 + 0.75 * pct / 100.0
			for i in 6:
				var ang := PI / 6.0 + float(i) * PI / 3.0
				inner.append(c + Vector2(cos(ang), sin(ang)) * r * 0.86 * k)
			ui.draw_colored_polygon(inner, Color(col, 0.35 + 0.35 * pct / 100.0))
		var rim := hexa.duplicate()
		rim.append(hexa[0])
		ui.draw_polyline(rim, col.darkened(0.15), 4.5, true)
		if pct >= 100.0:
			ui.draw_polyline(rim, Color(1.0, 1.0, 1.0, 0.8), 1.5, true)
		var word := "%d%%" % int(pct)
		var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 17).x
		ui.draw_string_outline(font, c + Vector2(-w * 0.5, 6.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 17, 4, Color.WHITE)
		ui.draw_string(font, c + Vector2(-w * 0.5, 6.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 17, Sketch.INK)
