class_name SpearSkills
extends SusiSkills
## สกิลของ CAT CITRUS (หอก) สาย BASIC  id ขึ้นต้น sp_sk_
## ต่อยอดจาก SusiSkills ใช้ระบบชิ้นสกิล คูลดาวน์ UI คูลดาวน์บนช่องสกิลร่วมกัน (แบบเดียวกับ BowSkills)
## สกิลของสาย TIGER / FANG / VIXEN / SHELL เพิ่มใน SPEAR_DEFS กับ SKILLS["spear"] ได้ภายหลัง

## cd คูลดาวน์  air ใช้กลางอากาศได้
const SPEAR_DEFS := {
	"sp_sk_orb": {"cd": 2.5, "air": true},
	"sp_sk_quake": {"cd": 14.0},
	"sp_sk_pierce": {"cd": 8.0},
	"sp_sk_rapid": {"cd": 7.0},
	"sp_sk_ring": {"cd": 20.0},
	"sp_sk_shoulder": {"cd": 5.0},
}
const SPEAR_MP := {
	"sp_sk_orb": 30.0,
	"sp_sk_quake": 300.0,
	"sp_sk_pierce": 150.0,
	"sp_sk_rapid": 120.0,
	"sp_sk_ring": 300.0,
	"sp_sk_shoulder": 40.0,
}
const DODGE_CD := 8.0           # 10.1 โดนตีแล้วถอยกระโดดหนีเอง
const RING_TIME := 4.0          # 20.1 วงหอกหมุนรอบตัว
const RING_R := 2.6             # รัศมีวงหอก หน่วยเกม
const RING_TICK := 0.3
const RING_DMG := 11.0
const ORANGE := Color(1.0, 0.55, 0.15)
const INK := Color(0.12, 0.08, 0.1)

var dodge_cd := 0.0
var _act_tw: Tween
var _quake := false             # 1.5 รอตกถึงพื้นแล้วฟาด
var _quake_t := 0.0
var _ring_t := 0.0
var _ring_tick := 0.0
var _ring_fx: Node2D

# ---------------------------------------------------------------- ข้อมูล
func cost(id: String) -> float:
	return Stats.skill_mp("spear", id)

func cooldown(id: String) -> float:
	return float(SPEAR_DEFS.get(id, {}).get("cd", 3.0))

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	var d: Dictionary = SPEAR_DEFS.get(id, {})
	if d.is_empty():
		return
	if page.combo_nth >= 0 or hero.hurt_t > 0.0 or _quake:
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
		orb.radius = 0.5 * U
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
		n.radius = RING_R * U
		n.life = RING_TIME
		page.world.add_child(n)
		_ring_fx = n)

## 20.2 พุ่งไปด้านหน้าเอาไหล่ชน สตั๊น ติด SA
func _do_shoulder() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.6)
	_act("sp_z1", 0.32, {"lean": 30.0})
	_trail("thrust")
	_add({"type": "slide", "life": 0.28, "speed": 16.0, "dmg": 16.0, "eff": "stun", "node": null, "once_each": true})

# ---------------------------------------------------------------- ทุกเฟรม
func _process(delta: float) -> void:
	super._process(delta)
	if page == null:
		return
	dodge_cd = maxf(dodge_cd - delta, 0.0)
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

func _apply_passives(_delta: float) -> void:
	pass

func dmg_mult(_m: Monster, _h: Dictionary) -> float:
	return 1.0

func on_strike(_m: Monster, _h: Dictionary) -> void:
	pass

func mod_shot(_shot: Array) -> void:
	pass

## 10.1 โดนตีแล้วถอยหลังกระโดดหนีเอง (คูลดาวน์ 8 วิ)
func _on_hurt(_kind: String) -> void:
	if hero.hp <= 0.0 or dodge_cd > 0.0 or not has("sp_sk_dodge"):
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
