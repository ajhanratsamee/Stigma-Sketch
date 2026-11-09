class_name BowSkills
extends SusiSkills
## สกิลของ CAT MATCHA (ธนู) สาย BASIC / WINDSTARKER / GALE TEMPEST  id ขึ้นต้น bw_sk_
## ต่อยอดจาก SusiSkills ใช้ระบบชิ้นสกิล (proj area slide timer) คูลดาวน์ กดค้าง UI คูลดาวน์บนช่องสกิล ร่วมกัน
## มานาอยู่ในตาราง Stats.MP_COST["bow"]  คูลดาวน์อยู่ใน BOW_DEFS
## สาย SNIPE / MANA / TRAP ยังไม่มีสกิล เพิ่มใน BOW_DEFS กับ SKILLS["bow"] ได้ภายหลัง

## cd คูลดาวน์  air ใช้กลางอากาศได้  hold กดค้างยิงต่อ  charge กดค้างชาร์จ
const BOW_DEFS := {
	# BASIC
	"bw_sk_dodge_shot": {"cd": 2.5, "air": true},
	"bw_sk_storm_arrow": {"cd": 12.0},
	"bw_sk_knee_kick": {"cd": 5.0},
	"bw_sk_zigzag": {"cd": 16.0, "air": true},
	"bw_sk_spin_up": {"cd": 7.0},
	"bw_sk_red_wind": {"cd": 18.0},
	"bw_sk_push_shot": {"cd": 5.0, "air": true},
	# WINDSTARKER
	"bw_sk_ws_wave": {"cd": 14.0, "hold": true},
	"bw_sk_ws_sweep": {"cd": 7.0},
	"bw_sk_ws_slide": {"cd": 6.0},
	"bw_sk_ws_burst": {"cd": 18.0, "charge": true},
	"bw_sk_ws_back": {"cd": 4.0},
	"bw_sk_ws_march": {"cd": 18.0},
	"bw_sk_ws_knee": {"cd": 3.5},
	# GALE TEMPEST
	"bw_sk_gt_tap": {"cd": 30.0},
	"bw_sk_gt_dropkick": {"cd": 14.0},
	"bw_sk_gt_song": {"cd": 35.0},
	"bw_sk_gt_slam": {"cd": 7.0, "air": true},
	"bw_sk_gt_roll": {"cd": 5.0},
	"bw_sk_gt_slide4": {"cd": 7.0},
	# SNIPESTARKER
	"bw_sk_sn_homing": {"cd": 12.0},
	"bw_sk_sn_fan": {"cd": 3.0, "air": true},
	"bw_sk_sn_whirl": {"cd": 10.0},
	"bw_sk_sn_ring": {"cd": 25.0},
	"bw_sk_sn_bomb": {"cd": 15.0},
	"bw_sk_sn_sky": {"cd": 18.0},
	"bw_sk_sn_rapid": {"cd": 4.0, "hold": true},
	# APEX SNIPER
	"bw_sk_ap_mark": {"cd": 8.0, "air": true},
	"bw_sk_ap_rain": {"cd": 18.0},
	"bw_sk_ap_ice": {"cd": 10.0},
	"bw_sk_ap_dive": {"cd": 15.0, "air": true},
	"bw_sk_ap_trap": {"cd": 9.0},
	"bw_sk_ap_cluster": {"cd": 10.0},
	# TRAPSTARKER  (trap คือสกิลกับดัก ใช้กับพาสซีฟสายกับดัก)
	"bw_sk_tr_twigs": {"cd": 14.0, "trap": true},
	"bw_sk_tr_dash": {"cd": 6.0},
	"bw_sk_tr_windarrow": {"cd": 10.0},
	"bw_sk_tr_skyburst": {"cd": 18.0},
	"bw_sk_tr_vines": {"cd": 3.0, "trap": true, "air": true},
	"bw_sk_tr_shock": {"cd": 18.0},
	"bw_sk_tr_ball": {"cd": 6.0, "trap": true},
	# TWILIGHT
	"bw_sk_tw_stake": {"cd": 0.4, "trap": true, "air": true},
	"bw_sk_tw_zigzag": {"cd": 18.0},
	"bw_sk_tw_windtrap": {"cd": 8.0, "trap": true, "air": true},
	"bw_sk_tw_twigs5": {"cd": 8.0, "trap": true, "air": true},
	"bw_sk_tw_orb": {"cd": 6.0, "trap": true, "air": true},
	"bw_sk_tw_six": {"cd": 10.0},
}
const BOW_MP := {
	"bw_sk_dodge_shot": 30.0,
	"bw_sk_storm_arrow": 200.0,
	"bw_sk_knee_kick": 80.0,
	"bw_sk_zigzag": 300.0,
	"bw_sk_spin_up": 120.0,
	"bw_sk_red_wind": 300.0,
	"bw_sk_push_shot": 80.0,
	"bw_sk_ws_wave": 250.0,
	"bw_sk_ws_sweep": 120.0,
	"bw_sk_ws_slide": 100.0,
	"bw_sk_ws_burst": 300.0,
	"bw_sk_ws_back": 60.0,
	"bw_sk_ws_march": 300.0,
	"bw_sk_ws_knee": 50.0,
	"bw_sk_gt_tap": 25.0,
	"bw_sk_gt_dropkick": 250.0,
	"bw_sk_gt_song": 200.0,
	"bw_sk_gt_slam": 120.0,
	"bw_sk_gt_roll": 80.0,
	"bw_sk_gt_slide4": 120.0,
	"bw_sk_sn_homing": 200.0,
	"bw_sk_sn_fan": 50.0,
	"bw_sk_sn_whirl": 150.0,
	"bw_sk_sn_ring": 30.0,
	"bw_sk_sn_bomb": 250.0,
	"bw_sk_sn_sky": 300.0,
	"bw_sk_sn_rapid": 60.0,
	"bw_sk_ap_mark": 100.0,
	"bw_sk_ap_rain": 300.0,
	"bw_sk_ap_ice": 150.0,
	"bw_sk_ap_dive": 250.0,
	"bw_sk_ap_trap": 100.0,
	"bw_sk_ap_cluster": 150.0,
	"bw_sk_tr_twigs": 250.0,
	"bw_sk_tr_dash": 100.0,
	"bw_sk_tr_windarrow": 200.0,
	"bw_sk_tr_skyburst": 300.0,
	"bw_sk_tr_vines": 30.0,
	"bw_sk_tr_shock": 300.0,
	"bw_sk_tr_ball": 80.0,
	"bw_sk_tw_stake": 10.0,
	"bw_sk_tw_zigzag": 300.0,
	"bw_sk_tw_windtrap": 100.0,
	"bw_sk_tw_twigs5": 100.0,
	"bw_sk_tw_orb": 80.0,
	"bw_sk_tw_six": 150.0,
}
const TAP_TIME := 30.0          # 35.2 บัพตีแล้วได้มานาเพิ่ม
const TAP_MP := 4.0
const SONG_TIME := 20.0         # 45.1 ฟื้นมานา +20 ต่อวินาที
const REVIVE_CD := 120.0        # 60.2 ไม่ตายทันที
const REVIVE_TIME := 10.0
const HASTE := 1.2              # 15.4 ความเร็วโจมตี
const VIGOR_HP := 60.0          # 35.4 เลือดสูงสุดเพิ่ม

var _act_tw: Tween
var _charge := {}               # 30.1 ชาร์จ {t max}
var revive_cd := 0.0

func _ready() -> void:
	pass

# ---------------------------------------------------------------- ข้อมูล
func cost(id: String) -> float:
	# SNIPE 30.1 ยืนในวงลม ใช้สกิลไม่เสียมานา
	if buffs.has("free_ring") and absf(hero.position.x - _ring_x) <= 1.4 * U and hero.pos.y < 1.5:
		return 0.0
	return Stats.skill_mp("bow", id)

func cooldown(id: String) -> float:
	var cd := float(BOW_DEFS.get(id, {}).get("cd", 3.0))
	# TWILIGHT 60.2 กับดักครบ 5 ครั้ง สกิลอื่นคูลดาวน์ลดลง 40 วิ
	if buffs.has("trap_rush") and not BOW_DEFS.get(id, {}).get("trap", false):
		cd *= 0.6
	return cd

func _held() -> bool:
	return page.test_hold or super._held()

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	var d: Dictionary = BOW_DEFS.get(id, {})
	if d.is_empty():
		return
	if not _channel.is_empty() or not _charge.is_empty():
		return
	# ท่าคอมโบกำลังออกอยู่ หรือโดนตีอยู่ ใช้สกิลไม่ได้ (ท่าค้างจากสกิลก่อนหน้าตัดได้)
	if page.combo_nth >= 0 or hero.hurt_t > 0.0:
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
	_cast_flare(id)
	BigSkillFx.cast(page, id, c)
	if c >= 250.0:
		page.time_stop(0.45)
	_after_cast(id, d)
	call("_do_" + id.trim_prefix("bw_sk_"))

func _cast_flare(id: String) -> void:
	var c := _fx("flare", "wind", hero.position + Vector2(0.0, -4.0), 1.3 * U, 0.6)
	c.rx = 1.3 * U
	c.ry = 0.35 * U
	# วงลมบนพื้นใต้เท้า สกิลใหญ่มีลมหมุนวนรอบตัว
	_bfx("decal", Vector2(hero.position.x, 0.0), 1.6 * U, 0.6)
	if float(BOW_MP.get(id, 0.0)) >= 250.0:
		var sw := _bfx("swirl", Vector2(hero.position.x, 0.0), 1.4 * U, 0.9)
		sw.follow = hero

# ---------------------------------------------------------------- ความอลังการ (ภาพล้วน ไม่ยุ่งกับดาเมจ)
var _puff_t := {}

## สีหลักเขียว กับสีแซมของแต่ละสาย
func _line_colors() -> Array:
	var cls := WalkPage.chosen_class
	var acc := Color(0.9, 1.0, 0.75)
	if cls in ["WINDSTARKER", "GALE TEMPEST"]:
		acc = Color(0.85, 1.0, 0.95)
	elif cls in ["SNIPESTARKER", "APEX SNIPER"]:
		acc = Color(1.0, 0.86, 0.45)
	elif cls == "TRAPSTARKER":
		acc = Color(0.8, 0.62, 0.38)
	elif cls == "TWILIGHT":
		acc = Color(0.75, 0.55, 1.0)
	return [Color(0.55, 0.88, 0.52), acc]

func _bfx(kind: String, at: Vector2, size: float, life := 0.7, parent: Node = null) -> BowSkillFx:
	var n := BowSkillFx.new()
	var cols := _line_colors()
	n.kind = kind
	n.base = cols[0]
	n.accent = cols[1]
	n.size = size
	n.life = life
	n.dir = _f()
	if parent != null:
		parent.add_child(n)
	else:
		n.position = at
		page.world.add_child(n)
	return n

func _boom(at: Vector2, w: float, h: float, dmg: float, eff: String, el: String, extra := {}) -> void:
	super._boom(at, w, h, dmg, eff, el, extra)
	_bfx("burst", at, minf(w * 0.85, 3.5 * U), 0.75)
	_bfx("decal", Vector2(at.x, 0.0), minf(w * 1.1, 4.0 * U), 0.8)

func _hit(m: Monster, dmg: float, eff: String, side: float, extra := {}) -> void:
	super._hit(m, dmg, eff, side, extra)
	var now := Time.get_ticks_msec()
	if now - int(_puff_t.get(m, -1000)) < 90:
		return
	_puff_t[m] = now
	_bfx("puff", m.position + Vector2(randf_range(-14.0, 14.0), -WalkPage.MONSTER_MID + randf_range(-20.0, 20.0)), 80.0, 0.4)

func _fx(kind: String, el: String, at: Vector2, r: float, life := 1.0, auto := true) -> SusiFx:
	var n := super._fx(kind, el, at, r, life, auto)
	# ประดับของกับดักให้น่ารักละเอียดขึ้น
	if not auto:
		if kind == "arcane" and el == "leaf":
			_bfx("twig", Vector2.ZERO, r, 99.0, n)
		elif kind == "pillar":
			_bfx("stake", Vector2.ZERO, r, 99.0, n)
		elif kind == "web":
			_bfx("vine", Vector2.ZERO, r, 99.0, n)
		elif kind == "charge":
			_bfx("charge", Vector2.ZERO, r, 99.0, n)
	return n

func _proj(kind: String, el: String, at: Vector2, vel: Vector2, r: float, dmg: float, eff: String, o := {}) -> Dictionary:
	var d := super._proj(kind, el, at, vel, r, dmg, eff, o)
	var n = d.get("node")
	if n is Node2D and is_instance_valid(n):
		_bfx("trail", Vector2.ZERO, maxf(r, 30.0), 99.0, n)
	return d

# ---------------------------------------------------------------- ตัวช่วย
## ท่าจากตารางคอมโบธนู ใช้แค่ภาพ ไม่ทำดาเมจเอง
func _act(move_id: String, time := 0.4, over := {}) -> void:
	var m: Dictionary = BowCombo.move(move_id).duplicate(true)
	for k in ["auto", "fx", "fx_start", "dive", "dive_forward", "leap", "hover", "turn_around", "drag", "front_hit", "multi", "invert"]:
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

## รอยเตะเขียว (front spin up flip down slide)
func _kick_fx(kind: String, life := 0.32) -> void:
	_bfx("puff", hero.position + Vector2(_f() * 90.0, -70.0), 90.0, 0.45)
	var t := KickTrail.new()
	t.kind = kind
	t.dir = _f()
	t.life = life
	t.position = hero.position
	if kind == "slide":
		t.follow = hero
	page.world.add_child(t)

## ลมเขียวของสาย WIND (gust lift ring)
func _wind_fx(kind: String, reach := 330.0, life := 0.45, at := Vector2.INF) -> void:
	var n := BowWindFx.new()
	n.kind = kind
	n.dir = _f()
	n.reach = reach
	n.life = life
	n.position = hero.position if at == Vector2.INF else at
	page.world.add_child(n)
	# ใบไม้กับเม็ดลมพัดตามลม และวงลมบนพื้น
	var ls := _bfx("leafstorm", n.position, clampf(reach * 1.5, 3.0 * U, 12.0 * U), life + 0.35)
	ls.dir = _f()
	_bfx("decal", Vector2(n.position.x, 0.0), minf(reach * 0.8, 4.0 * U), life + 0.2)

## โดนมอนด้านหน้าในวงรี ห่างตัว ahead หน่วย กว้างครึ่ง half หน่วย
func _front(ahead: float, half: float, dmg: float, eff: String, tall := 1.5) -> Array:
	var list := _in_ellipse(hero.position + Vector2(_f() * ahead * U, -60.0), half * U, tall * U)
	for m in list:
		_hit(m, dmg, eff, _f())
	return list

func _hop(k := 0.6) -> void:
	hero.vel.y = Hero.JUMP_VELOCITY * k

## ลูกศรธนูจริงออกจากมือ
func _arrow(dir: Vector2, dmg: float, extra := {"kb": 1.0, "stun": 0.45}, hits := 2) -> void:
	page._fire(page._cast_point(hero.position + Vector2(_f() * 70.0, -80.0)), dir.normalized() * WalkPage.SHOT_SPEED * 1.4, 26.0, dmg, extra, false, hits)

func _tick_obj(o: Dictionary, delta: float) -> void:
	# พายุเขียวค่อยๆ พัดไปข้างหน้า
	if o.has("drift"):
		o["pos"] = (o["pos"] as Vector2) + Vector2(float(o["drift"]) * delta, 0.0)
	if str(o.get("type", "")) in ["rollball", "orbtrap"]:
		o["age"] = float(o["age"]) + delta
		o["life"] = float(o["life"]) - delta
		_tick_trap_obj(o, delta)
		return
	super._tick_obj(o, delta)

# ---------------------------------------------------------------- BASIC
## 1.1 กระโดดหลบดาเมจถอยหลัง แล้วยิงศร 3 ดอกเฉียงลง
func _do_dodge_shot() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 0.6)
	if hero.on_floor():
		_hop(0.65)
	_add({"type": "slide", "life": 0.25, "speed": -9.0, "node": null})
	_act("bw_adx1", 0.45)
	_later(0.18, func() -> void:
		for ang in [18.0, 32.0, 46.0]:
			_arrow(Vector2(_f() * cos(deg_to_rad(ang)), sin(deg_to_rad(ang))), 9.0))

## 1.2 กระโดดยิงศรลงพื้น พายุเขียวพัดไปข้างหน้าช้าๆ
func _do_storm_arrow() -> void:
	_hop(0.7)
	_act("bw_ax", 0.5)
	var at := Vector2(hero.position.x + _f() * 2.2 * U, 0.0)
	_later(0.3, func() -> void:
		_fx("poof", "leaf", at + Vector2(0.0, -30.0), 50.0, 0.4)
		_area("storm", "leaf", at, 1.6 * U, 3.2, 7.0, "light", {"tick": 0.3, "drift": _f() * 1.6 * U, "hit_at": Vector2(0.0, -90.0), "hit_r": 1.7 * U}))

## 5.1 พุ่งเข่าชน แล้วเตะซ้ำ
func _do_knee_kick() -> void:
	_act("bw_dz1", 0.3)
	_kick_fx("slide", 0.3)
	_add({"type": "slide", "life": 0.25, "speed": 15.0, "dmg": 16.0, "eff": "flinch", "node": null, "once_each": true})
	_later(0.3, func() -> void:
		_act("bw_z1", 0.32)
		_kick_fx("front")
		_front(1.2, 1.4, 20.0, "strong"))

## 10.1 กระโดดกลางอากาศ ยิงลูกบอลลมซิกแซกไปมาด้านหน้า วงกว้าง
func _do_zigzag() -> void:
	if hero.on_floor():
		_hop(0.8)
	_act("bw_x1", 0.5)
	for i in 5:
		var k := float(i)
		_later(0.12 + k * 0.08, func() -> void:
			var from := hero.position + Vector2(_f() * 60.0, -110.0)
			var o := _proj("arcane", "wind", from, Vector2(_f() * 900.0, 0.0), 0.75 * U, 22.0, "flinch", {"life": 1.4, "hits": 4})
			o["wave"] = [1.4 * U, 7.0, k * 1.3]
			o["base_y"] = -90.0 - (k - 2.0) * 20.0)

## 15.1 หมุนตัวเตะกวาด แล้วเตะเสยขึ้น
func _do_spin_up() -> void:
	_act("bw_z2", 0.3)
	_kick_fx("spin")
	_front(0.6, 1.6, 20.0, "flinch")
	_later(0.3, func() -> void:
		_act("bw_kick_up", 0.35)
		_kick_fx("up")
		_wind_fx("lift", 200.0, 0.5)
		_front(0.9, 1.4, 28.0, "launch"))

## 20.1 พลังลมแดงผสมเขียวกว้าง พุ่งไปด้านหน้าไกล 3 จอ
func _do_red_wind() -> void:
	_act("bw_x4", 0.5)
	var reach := page._screen_w() * 3.0
	_later(0.2, func() -> void:
		var from := hero.position + Vector2(_f() * 80.0, -80.0)
		var speed := 1800.0
		_proj("wind", "redwind", from, Vector2(_f() * speed, 0.0), 1.9 * U, 0.0, "strong", {"life": minf(reach / speed, 4.0), "tick": 0.12, "dmg": 16.0, "carry": false})
		_proj("wind", "leaf", from + Vector2(0.0, 30.0), Vector2(_f() * speed, 0.0), 1.4 * U, 0.0, "light", {"life": minf(reach / speed, 4.0), "tick": 0.15, "dmg": 6.0}))

## 20.2 ยิงศรลมไปข้างหน้า เป้าหมายถูกผลักถอย
func _do_push_shot() -> void:
	_act("bw_x1", 0.35)
	_later(0.12, func() -> void:
		_proj("wind", "wind", hero.position + Vector2(_f() * 70.0, -80.0), Vector2(_f() * 1500.0, 0.0), 0.9 * U, 24.0, "knock", {"life": 0.9, "hits": 3}))

# ---------------------------------------------------------------- WINDSTARKER
## 15.2 กระโดดเตะคลื่นลมกระจายไปมาด้านหน้า กดค้างยิงต่อเนื่อง
func _do_ws_wave() -> void:
	_hop(0.45)
	_start_channel("bw_sk_ws_wave", 0.22, 3.0, 30.0, func() -> void:
		_act("bw_z2" if randf() < 0.5 else "bw_z1", 0.22)
		_kick_fx("spin" if randf() < 0.5 else "front", 0.25)
		for j in 2:
			var ang := deg_to_rad(randf_range(-25.0, 25.0))
			var el := "leaf" if j == 0 else "wind"
			_proj("wind", el, hero.position + Vector2(_f() * 60.0, -70.0), Vector2(_f() * cos(ang), sin(ang)) * 1100.0, 0.8 * U, 14.0, "flinch", {"life": 0.7, "hits": 3}))

## 15.3 หมุนตัวเตะกวาด คลื่นลมแนวตรงไปด้านหน้า
func _do_ws_sweep() -> void:
	_act("bw_z2", 0.35)
	_kick_fx("spin")
	_later(0.12, func() -> void:
		_wind_fx("gust", 520.0, 0.5)
		_proj("wind", "leaf", hero.position + Vector2(_f() * 60.0, -50.0), Vector2(_f() * 1300.0, 0.0), 1.1 * U, 34.0, "strong", {"life": 0.6, "hits": 6, "ground": false}))

## 15.5 สไลด์ไปข้างหน้า โดนเป้าหมายแล้วทะลุไปหลังมอน แล้วเตะขึ้น
func _do_ws_slide() -> void:
	_act("bw_dz1", 0.4)
	_kick_fx("slide", 0.4)
	var o := _add({"type": "slide", "life": 0.35, "speed": 14.0, "dmg": 12.0, "eff": "light", "node": null, "once_each": true})
	_later(0.36, func() -> void:
		if not (o["done"] as Array).is_empty():
			# ทะลุไปด้านหลังมอนตัวแรก หันกลับแล้วเตะเสย
			var m: Monster = (o["done"] as Array)[0]
			if is_instance_valid(m):
				hero.pos.x = clampf(m.pos.x + _f() * 1.1, -hero.half_width, hero.half_width)
				hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
				hero.facing = -hero.facing
		_act("bw_kick_up", 0.35)
		_kick_fx("up")
		_wind_fx("lift", 200.0, 0.5)
		_front(0.9, 1.4, 30.0, "launch"))

## 30.1 รวมพลังที่เท้า กดค้างชาร์จ ปล่อยแล้วเตะล่าง ลมระเบิดวงกว้างด้านหน้า
func _do_ws_burst() -> void:
	_charge = {"t": 0.0, "max": 1.2, "fx": _fx("charge", "leaf", hero.position + Vector2(0.0, -20.0), 50.0, 3.0, false)}
	_act("bw_z1", 1.5, {"wind": 0.95, "strike": 0.98})

func _release_burst() -> void:
	var k := clampf(float(_charge["t"]) / float(_charge["max"]), 0.0, 1.0)
	var n: SusiFx = _charge.get("fx")
	if is_instance_valid(n):
		n.queue_free()
	_charge = {}
	hero.plain_swing = 0.0
	_act("bw_z1", 0.3, {"wind_hand": Vector3(0.3, -0.4, 0.1), "end_hand": Vector3(0.8, -0.5, 0.1)})
	_kick_fx("down")
	var w := (2.4 + 2.2 * k) * U
	_boom(hero.position + Vector2(_f() * (1.4 + k) * U, -50.0), w, w * 0.45, 40.0 + 70.0 * k, "knock" if k > 0.6 else "strong", "leaf")
	_wind_fx("ring", w, 0.5, hero.position + Vector2(_f() * (1.4 + k) * U, 0.0))

## 30.2 เตะกลับหลังไปด้านหน้า
func _do_ws_back() -> void:
	_act("bw_z2", 0.32, {"spin": 180.0})
	_kick_fx("front")
	_later(0.14, func() -> void: _front(1.1, 1.3, 30.0, "strong"))

## 35.1 เตะคลื่นลมไปข้างหน้าพร้อมเดินไปด้วย หลายแนว ตรง เฉียงขึ้น เฉียงลง แล้วกระโดดทุ่มพื้น ลมรอบตัว
func _do_ws_march() -> void:
	var angles := [0.0, -25.0, 25.0, 0.0, -25.0, 25.0]
	for i in angles.size():
		var a: float = angles[i]
		_later(float(i) * 0.2, func() -> void:
			_act("bw_z1" if i % 2 == 0 else "bw_z2", 0.2)
			_kick_fx("front" if i % 2 == 0 else "spin", 0.22)
			hero.pos.x = clampf(hero.pos.x + _f() * 0.6, -hero.half_width, hero.half_width)
			hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
			var ang := deg_to_rad(a)
			_proj("wind", "leaf" if i % 2 == 0 else "wind", hero.position + Vector2(_f() * 60.0, -70.0), Vector2(_f() * cos(ang), sin(ang)) * 1200.0, 0.9 * U, 16.0, "flinch", {"life": 0.6, "hits": 4}))
	_later(1.25, func() -> void:
		_hop(1.0)
		_act("bw_kick_up", 0.4))
	_add({"type": "stomp_wind", "life": 3.0, "wait": 1.6})

## 40.1 พุ่งเข่าชกด้านหน้า
func _do_ws_knee() -> void:
	_act("bw_dz1", 0.28, {"lean": 20.0})
	_kick_fx("front", 0.28)
	_add({"type": "slide", "life": 0.18, "speed": 13.0, "dmg": 26.0, "eff": "strong", "node": null, "once_each": true})

# ---------------------------------------------------------------- GALE TEMPEST
## 35.2 เคาะพื้น บัพ ตีโดนได้มานาเพิ่ม
func _do_gt_tap() -> void:
	_act("bw_z1", 0.35, {"wind_hand": Vector3(0.2, -0.45, 0.1), "end_hand": Vector3(0.25, -0.55, 0.1)})
	buffs["tap"] = TAP_TIME
	_wind_fx("ring", 160.0, 0.5, hero.position)
	page.bars.notice("ตีโดนได้มานาเพิ่ม %d วิ" % int(TAP_TIME))

## 35.3 กระโดดนิดนึงแล้วถีบทั้งตัวพุ่งไปด้านหน้าครึ่งจอ อย่างแรง
func _do_gt_dropkick() -> void:
	_hop(0.5)
	_act("bw_adz", 0.5)
	_kick_fx("slide", 0.5)
	var dist := page._screen_w() * 0.5 / U
	_add({"type": "slide", "life": 0.42, "speed": dist / 0.42, "dmg": 70.0, "eff": "knock", "node": null, "once_each": true})
	_later(0.42, func() -> void: _boom(hero.position + Vector2(_f() * 60.0, -60.0), 1.8 * U, 1.2 * U, 30.0, "knock", "leaf"))

## 45.1 ร่ายพลังลม วงเวทดนตรี บัพฟื้นมานา +20 ต่อวินาที 20 วิ
func _do_gt_song() -> void:
	_act("bw_x1", 0.6)
	var ring := _fx("ring", "wind", hero.position + Vector2(0.0, -10.0), 1.6 * U, 1.4)
	ring.rx = 1.6 * U
	ring.ry = 0.4 * U
	for i in 6:
		var ang := TAU * float(i) / 6.0
		_fx("poof", "leaf", hero.position + Vector2(cos(ang) * 1.4 * U, -110.0 + sin(ang) * 0.6 * U), 22.0, 1.0)
	buffs["song"] = SONG_TIME
	page.bars.notice("ฟื้นมานา +20 ต่อวินาที %d วิ" % int(SONG_TIME))

## 45.2 ใช้กลางอากาศได้ กระโดดทุ่มพื้น วงกว้างครึ่งจอ
func _do_gt_slam() -> void:
	if hero.on_floor():
		_hop(0.8)
	_act("bw_az", 0.5)
	_add({"type": "slam_wind", "life": 3.0, "wait": 0.25})

## 50.1 กระโดดม้วนตัวเตะคลื่นลมไปด้านหน้า
func _do_gt_roll() -> void:
	_hop(0.55)
	_act("bw_z3", 0.4)
	_kick_fx("flip")
	_later(0.2, func() -> void:
		_proj("wind", "leaf", hero.position + Vector2(_f() * 60.0, -60.0), Vector2(_f() * 1250.0, 0.0), 1.0 * U, 30.0, "strong", {"life": 0.6, "hits": 5}))

## 55.1 สไลด์ไปข้างหน้าต่อเนื่อง 4 ฮิต
func _do_gt_slide4() -> void:
	for i in 4:
		_later(float(i) * 0.22, func() -> void:
			_act("bw_dz1", 0.22)
			_kick_fx("slide", 0.24)
			_add({"type": "slide", "life": 0.2, "speed": 9.0, "dmg": 15.0, "eff": "flinch" if i < 3 else "launch", "node": null, "once_each": true}))

# ---------------------------------------------------------------- SNIPESTARKER
## 15.2 ยิงศรติดตามมอน 5 ดอก ตามได้ทั่วแมพ
func _do_sn_homing() -> void:
	_act("bw_x1", 0.45)
	for i in 5:
		var k := float(i)
		_later(0.08 * k, func() -> void:
			var ang := deg_to_rad(-30.0 + k * 15.0)
			_proj("arcane", "wind", hero.position + Vector2(_f() * 60.0, -85.0), Vector2(_f() * cos(ang), sin(ang)) * 900.0, 0.45 * U, 20.0, "flinch", {"life": 4.0, "homing": 1100.0, "hits": 1}))

## 15.3 ศรแดง 5 ดอกเป็นพัดระยะใกล้ ติด sa
func _do_sn_fan() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.6)
	_act("bw_x1", 0.35)
	_later(0.1, func() -> void:
		for i in 5:
			var ang := deg_to_rad(-28.0 + float(i) * 14.0)
			_proj("arcane", "redwind", hero.position + Vector2(_f() * 60.0, -80.0), Vector2(_f() * cos(ang), sin(ang)) * 1300.0, 0.45 * U, 12.0, "flinch", {"life": 0.32, "hits": 2}))

## 25.1 ยิงลมหมุนไปด้านหน้า ดูดมอนมารวมกัน
func _do_sn_whirl() -> void:
	_act("bw_x1", 0.4)
	_later(0.12, func() -> void:
		_proj("storm", "wind", Vector2(hero.position.x + _f() * 80.0, 0.0), Vector2(_f() * 260.0, 0.0), 1.5 * U, 0.0, "light", {"life": 2.6, "tick": 0.3, "dmg": 6.0, "pull": 3.2 * U, "ground": true}))

## 30.1 เคาะพื้น วงลมเล็กใต้เท้า อยู่ในวงใช้สกิลไม่เสียมานา
func _do_sn_ring() -> void:
	_act("bw_z1", 0.3, {"wind_hand": Vector3(0.2, -0.45, 0.1), "end_hand": Vector3(0.25, -0.55, 0.1)})
	var at := Vector2(hero.position.x, -4.0)
	var n := _fx("ring", "leaf", at, 1.3 * U, 10.0)
	n.rx = 1.3 * U
	n.ry = 0.3 * U
	buffs["free_ring"] = 10.0
	_ring_x = at.x
	page.bars.notice("อยู่ในวงลม ใช้สกิลไม่เสียมานา")

## 30.2 รวมพลังที่ศร ยิงไปข้างหน้า ระเบิด 5 ครั้งตามทาง เลยขอบจอได้
func _do_sn_bomb() -> void:
	_act("bw_x4", 0.6, {"wind": 0.6, "strike": 0.7})
	_fx("charge", "leaf", hero.position + Vector2(_f() * 60.0, -85.0), 50.0, 0.4)
	_later(0.4, func() -> void:
		var o := _proj("arcane", "leaf", hero.position + Vector2(_f() * 70.0, -85.0), Vector2(_f() * 1500.0, 0.0), 0.7 * U, 18.0, "flinch", {"life": 1.6, "hits": 99})
		for i in 5:
			_later(0.18 + float(i) * 0.26, func() -> void:
				if _objs.has(o):
					_boom(o["pos"], 1.8 * U, 1.3 * U, 32.0, "strong", "leaf")))

## 35.1 โยนพลังลมขึ้นฟ้า แตกกระจายตกลงรอบๆ
func _do_sn_sky() -> void:
	_act("bw_x1", 0.45, {"wind_aim": Vector2(-60.0, 0.0), "end_aim": Vector2(-80.0, 0.0)})
	var top := hero.position + Vector2(_f() * 1.5 * U, -6.0 * U)
	_proj("arcane", "wind", hero.position + Vector2(0.0, -100.0), (top - hero.position).normalized() * 1400.0, 0.8 * U, 0.0, "light", {"life": 0.35, "no_touch": true})
	_later(0.4, func() -> void:
		_fx("poof", "leaf", top, 90.0, 0.5)
		for i in 12:
			var x := top.x + _f() * randf_range(-3.0, 6.0) * U
			_proj("arcane", "leaf" if i % 2 == 0 else "wind", Vector2(x, top.y + randf_range(-40.0, 40.0)), Vector2(randf_range(-80.0, 80.0), 300.0), 0.45 * U, 0.0, "flinch", {"life": 3.0, "gravity": 1800.0, "ground_end": true, "boom": [1.4 * U, 1.0 * U], "dmg": 22.0, "no_touch": true}))

## 40.1 ยิงรัวไปด้านหน้า กดค้างยิงต่อ ใช้มานา ติด sa
func _do_sn_rapid() -> void:
	_start_channel("bw_sk_sn_rapid", 0.1, 3.0, 35.0, func() -> void:
		hero.plain_sa_t = maxf(hero.plain_sa_t, 0.3)
		_act("bw_x1", 0.12)
		var ang := deg_to_rad(randf_range(-4.0, 4.0))
		_arrow(Vector2(_f() * cos(ang), sin(ang)), 7.0, {"kb": 0.3, "stun": 0.3}, 1))

# ---------------------------------------------------------------- APEX SNIPER
## 35.2 ศรติดตาม โดนแล้วติดเครื่องหมาย ยิงเป้าที่ติดเครื่องหมายแรงขึ้น
func _do_ap_mark() -> void:
	_act("bw_x1", 0.4)
	_later(0.1, func() -> void:
		_proj("arcane", "redwind", hero.position + Vector2(_f() * 60.0, -85.0), Vector2(_f() * 1000.0, 0.0), 0.55 * U, 26.0, "flinch", {"life": 3.0, "homing": 1200.0, "hits": 1, "extra": {"apex_mark": true}}))

## 35.3 กระโดดนิดนึง ยิงฝนลูกศรลงด้านหน้า
func _do_ap_rain() -> void:
	_hop(0.5)
	_act("bw_x1", 0.5, {"wind_aim": Vector2(-60.0, 0.0), "end_aim": Vector2(-75.0, 0.0)})
	var x0 := hero.position.x + _f() * 1.2 * U
	for i in 16:
		var k := float(i)
		_later(0.35 + k * 0.06, func() -> void:
			var x := x0 + _f() * randf_range(0.0, 5.5) * U
			page._fire(Vector2(x, -7.0 * U), Vector2(_f() * 120.0, 1500.0), 22.0, 13.0, {"kb": 0.4, "stun": 0.45}, false, 2))

## 45.1 ศรน้ำแข็งตรงไปด้านหน้า 1.5 จอ มอนแข็ง
func _do_ap_ice() -> void:
	_act("bw_x4", 0.45)
	var reach := page._screen_w() * 1.5
	_later(0.15, func() -> void:
		_proj("ice", "ice", hero.position + Vector2(_f() * 70.0, -85.0), Vector2(_f() * 1700.0, 0.0), 0.8 * U, 34.0, "stun", {"life": reach / 1700.0, "hits": 99, "extra": {"freeze_arrow": true}}))

## 45.2 กระโดด ตั้งท่าชาร์จ แล้วยิงเฉียงลง ลมระเบิดกว้างมาก
func _do_ap_dive() -> void:
	if hero.on_floor():
		_hop(1.0)
	_act("bw_adx1", 0.9, {"wind": 0.6, "strike": 0.7, "hover": true})
	_fx("charge", "leaf", hero.position + Vector2(_f() * 60.0, -85.0), 60.0, 0.5)
	_later(0.45, func() -> void:
		var dir := Vector2(_f(), 0.8).normalized()
		_proj("arcane", "leaf", hero.position + Vector2(_f() * 60.0, -80.0), dir * 1800.0, 0.8 * U, 90.0, "knock", {"life": 1.5, "ground_end": true, "boom": [page._screen_w() * 0.4, 1.8 * U], "no_touch": true}))

## 50.1 ปากับดักป่า มอนที่โดนชะงักติดอยู่ 3 วิ แล้วระเบิด
func _do_ap_trap() -> void:
	_act("bw_x1", 0.4)
	var at := Vector2(hero.position.x + _f() * 3.0 * U, -4.0)
	_later(0.25, func() -> void:
		_fx("poof", "leaf", at + Vector2(0.0, -30.0), 50.0, 0.4)
		_area("web", "leaf", at, 1.6 * U, 3.0, 4.0, "stun", {"root": true, "tick": 0.5, "end_boom": 55.0}))

## 55.1 ชาร์จพลังที่หัวศร ยิงเป็นกลุ่มพลังไปด้านหน้า
func _do_ap_cluster() -> void:
	_act("bw_x4", 0.6, {"wind": 0.6, "strike": 0.7})
	_fx("charge", "wind", hero.position + Vector2(_f() * 60.0, -85.0), 55.0, 0.4)
	_later(0.4, func() -> void:
		for i in 7:
			var ang := deg_to_rad(randf_range(-10.0, 10.0))
			var sp := randf_range(1000.0, 1500.0)
			_proj("arcane", "leaf" if i % 2 == 0 else "wind", hero.position + Vector2(_f() * 70.0, -85.0 + randf_range(-25.0, 25.0)), Vector2(_f() * cos(ang), sin(ang)) * sp, 0.5 * U, 18.0, "flinch", {"life": 0.9, "hits": 2}))

var _ring_x := 0.0

# ---------------------------------------------------------------- TRAPSTARKER / TWILIGHT
var _stakes: Array = []          # TWILIGHT 35.2 หมุดที่ปักไว้ [ตำแหน่ง โหนด]
var _trap_uses: Array = []       # TWILIGHT 60.2 เวลาที่ใช้สกิลกับดัก

## ดาเมจสกิลกับดัก (TRAPSTARKER 15.3 แรงขึ้น)
func _td(dmg: float) -> float:
	return dmg * (1.3 if has("bw_sk_tr_power") else 1.0)

## รอยดาบมือรองของสายกับดัก
func _slash_fx(kind: String, at := Vector2.INF) -> void:
	var n := BowTrapFx.new()
	n.kind = kind
	n.dir = _f()
	n.dusk = WalkPage.chosen_class == "TWILIGHT"
	n.position = hero.position if at == Vector2.INF else at
	page.world.add_child(n)

## หลังใช้สกิล: นับสกิลกับดัก ลดคูลดาวน์ และพาสซีฟสกิลมานาสูง
func _after_cast(id: String, d: Dictionary) -> void:
	if d.get("trap", false):
		# TWILIGHT 35.4 ใช้สกิลกับดัก สกิลอื่นคูลดาวน์ลดลง 1 วิ
		if has("bw_sk_tw_cdr"):
			for k in cds.keys():
				if k != id:
					cds[k] = maxf(float(cds[k]) - 1.0, 0.0)
		# TWILIGHT 60.2 กับดักครบ 5 ครั้งใน 30 วิ นับจากกับดักแรก
		if has("bw_sk_tw_rush"):
			var now := Time.get_ticks_msec() / 1000.0
			if not _trap_uses.is_empty() and now - float(_trap_uses[0]) > 30.0:
				_trap_uses.clear()
			_trap_uses.append(now)
			if _trap_uses.size() >= 5:
				_trap_uses.clear()
				buffs["trap_rush"] = 40.0
				page.bars.notice("Trap Fever! คูลดาวน์สกิลอื่นลดลง 40 วิ")
	# TWILIGHT 60.1 สกิลมานาเดิมเกิน 200 ลดป้องกันและความเร็วเป้าหมายรอบตัว
	if has("bw_sk_tw_break") and float(BOW_MP.get(id, 0.0)) > 200.0:
		for m in _mons():
			if absf(m.position.x - hero.position.x) <= page._screen_w():
				m.weak_t = maxf(m.weak_t, 6.0)
				m.slow_t = maxf(m.slow_t, 6.0)

## 15.1 กระโดดปากิ่งไม้กับดักหลายอัน ระเบิดต่อเนื่อง
func _do_tr_twigs() -> void:
	_hop(0.5)
	_act("bw_x1", 0.45)
	for i in 6:
		var x := hero.position.x + _f() * (1.2 + float(i) * 0.9) * U
		_later(0.2 + float(i) * 0.05, func() -> void: _fx("poof", "leaf", Vector2(x, -20.0), 26.0, 0.3))
		_later(0.7 + float(i) * 0.12, func() -> void: _boom(Vector2(x, -50.0), 1.2 * U, 1.0 * U, _td(30.0), "strong", "leaf"))

## 15.2 พุ่งไปด้านหน้า เอาดาบฟันทะลุ
func _do_tr_dash() -> void:
	_act("bwt_slide_cut", 0.4)
	_slash_fx("through")
	_add({"type": "slide", "life": 0.3, "speed": 15.0, "dmg": 38.0, "eff": "strong", "node": null, "once_each": true})

## 25.1 ยิงศรลมไปด้านหน้า แล้วระเบิดข้างหน้า
func _do_tr_windarrow() -> void:
	_act("bw_x1", 0.4)
	_later(0.12, func() -> void:
		var o := _proj("arcane", "wind", hero.position + Vector2(_f() * 70.0, -85.0), Vector2(_f() * 1400.0, 0.0), 0.5 * U, 16.0, "flinch", {"life": 0.6, "hits": 1})
		_later(0.4, func() -> void:
			var at: Vector2 = o["pos"]
			_boom(at, 2.4 * U, 1.6 * U, 70.0, "knock", "wind")))

## 30.1 ยกมือขึ้นฟ้า ลมระเบิดจากพื้นแนวเฉียง ผลักมอนออกไป ไกล 2 จอ
func _do_tr_skyburst() -> void:
	_act("bw_x1", 0.5, {"wind_aim": Vector2(-70.0, 0.0), "end_aim": Vector2(-85.0, 0.0)})
	var reach := page._screen_w() * 2.0
	for i in 8:
		var x := hero.position.x + _f() * (1.0 * U + float(i) / 7.0 * reach)
		_later(0.2 + float(i) * 0.07, func() -> void:
			_wind_fx("lift", 220.0, 0.5, Vector2(x, 0.0))
			_boom(Vector2(x, -80.0), 1.4 * U, 1.8 * U, 34.0, "knock", "leaf"))

## 30.2 กระโดดปาเถาวัลย์ลงพื้น มอนติดอยู่ โดนดาเมจไม่ชะงัก
func _do_tr_vines() -> void:
	if hero.on_floor():
		_hop(0.55)
	_act("bw_ax", 0.4)
	var at := Vector2(hero.position.x + _f() * 1.8 * U, -4.0)
	_later(0.25, func() -> void:
		_area("web", "leaf", at, 1.4 * U, 3.0, _td(5.0), "none", {"root": true, "tick": 0.4}))

## 35.1 ชี้นิ้วขึ้นฟ้า คลื่นลมระเบิดจากพื้นแนวเฉียงใส่มอน หลายฮิต
func _do_tr_shock() -> void:
	_act("bw_x1", 0.6, {"wind_aim": Vector2(-75.0, 0.0), "end_aim": Vector2(-88.0, 0.0)})
	for i in 4:
		var x := hero.position.x + _f() * (1.5 + float(i) * 1.4) * U
		_later(0.25 + float(i) * 0.1, func() -> void:
			_wind_fx("lift", 260.0, 0.9, Vector2(x, 0.0))
			_area("storm", "wind", Vector2(x, 0.0), 1.2 * U, 1.0, 12.0, "flinch", {"tick": 0.14, "hit_at": Vector2(0.0, -110.0), "hit_r": 1.4 * U}))

## 40.1 ปากับดักลูกกลมกลิ้งไปด้านหน้า โดนมอนแล้วระเบิด ไกล 1 จอ
func _do_tr_ball() -> void:
	_act("bw_x1", 0.35)
	var n := _fx("arcane", "leaf", Vector2(hero.position.x + _f() * 60.0, -30.0), 0.5 * U, 3.0, false)
	_add({"type": "rollball", "node": n, "pos": n.position, "speed": 900.0, "left": page._screen_w(), "dmg": _td(60.0), "life": 3.0})

## TWILIGHT 35.2 กระโดดปาหมุดกับดัก กดซ้ำซ้อนได้ 5 อัน ครบ 5 ระเบิดแรง
func _do_tw_stake() -> void:
	if hero.on_floor():
		_hop(0.45)
	_act("bw_x1", 0.3)
	var at := Vector2(hero.position.x + _f() * (1.5 + float(_stakes.size()) * 0.5) * U, -10.0)
	var n := _fx("pillar", "dark", at, 0.25 * U, 60.0, false)
	_stakes.append([at, n])
	page.bars.notice("หมุดกับดัก %d/5" % _stakes.size())
	if _stakes.size() >= 5:
		var list := _stakes.duplicate()
		_stakes.clear()
		for i in list.size():
			var e: Array = list[i]
			_later(0.15 + float(i) * 0.08, func() -> void:
				if is_instance_valid(e[1]):
					(e[1] as Node).queue_free()
				_boom((e[0] as Vector2) + Vector2(0.0, -50.0), 1.8 * U, 1.4 * U, _td(55.0), "knock", "dark"))

## TWILIGHT 35.3 พุ่งฟันดาบไปด้านหน้า แล้วรอยดาบซิกแซกไปมาด้านหลัง
func _do_tw_zigzag() -> void:
	var x0 := hero.position.x
	_act("bwt_tw_stab", 0.35)
	_slash_fx("rush")
	_add({"type": "slide", "life": 0.35, "speed": 16.0, "dmg": 30.0, "eff": "strong", "node": null, "once_each": true})
	for i in 7:
		var k := float(i)
		_later(0.45 + k * 0.1, func() -> void:
			var x := lerpf(hero.position.x, x0, k / 6.0)
			var at := Vector2(x, -60.0 + (40.0 if i % 2 == 0 else -40.0))
			_slash_fx("slash_up" if i % 2 == 0 else "slash_down", Vector2(x, 0.0))
			for m in _in_ellipse(at, 1.2 * U, 1.5 * U):
				_hit(m, 18.0, "flinch", _f()))

## TWILIGHT 45.1 กระโดดปากับดักกลมมีลมรอบ เดินโดนแล้วลอย
func _do_tw_windtrap() -> void:
	if hero.on_floor():
		_hop(0.5)
	_act("bw_x1", 0.35)
	var at := Vector2(hero.position.x + _f() * 2.4 * U, -4.0)
	_later(0.25, func() -> void:
		var ring := _area("ring", "wind", at, 1.1 * U, 6.0, _td(30.0), "launch", {"tick": 0.0, "hit_at": Vector2(0.0, -40.0), "hit_r": 1.1 * U})
		var n: SusiFx = ring["node"]
		if is_instance_valid(n):
			n.rx = 1.1 * U
			n.ry = 0.3 * U)

## TWILIGHT 45.2 กระโดดปากับดักกิ่งไม้ 5 อันไปด้านหน้า
func _do_tw_twigs5() -> void:
	if hero.on_floor():
		_hop(0.5)
	_act("bw_x1", 0.4)
	for i in 5:
		var at := Vector2(hero.position.x + _f() * (1.2 + float(i) * 1.0) * U, -4.0)
		_later(0.2 + float(i) * 0.05, func() -> void:
			_area("web", "leaf", at, 0.7 * U, 5.0, _td(26.0), "strong", {"tick": 0.0, "hit_at": Vector2(0.0, -40.0), "hit_r": 0.8 * U}))

## TWILIGHT 50.1 กระโดดปากับดักกลมสีขาวเขียว โดนแล้วแตกหลายฮิต มอนชะงัก
func _do_tw_orb() -> void:
	if hero.on_floor():
		_hop(0.5)
	_act("bw_x1", 0.35)
	var n := _fx("arcane", "silver", hero.position + Vector2(_f() * 60.0, -90.0), 0.55 * U, 3.0, false)
	_add({"type": "orbtrap", "node": n, "pos": n.position, "vel": Vector2(_f() * 900.0, -300.0), "dmg": _td(9.0), "life": 2.5})

## TWILIGHT 55.1 พุ่งไปด้านหน้าฟาดดาบ 6 ที ทีสุดท้ายลอย
func _do_tw_six() -> void:
	var moves := ["bwt_z3", "bwt_z4", "bwt_z5", "bwt_tw_h1", "bwt_tw_h2", "bwt_tw_h3"]
	for i in 6:
		_later(float(i) * 0.17, func() -> void:
			_act(moves[i], 0.17)
			hero.pos.x = clampf(hero.pos.x + _f() * 0.45, -hero.half_width, hero.half_width)
			hero.position = Vector2(hero.pos.x, -hero.pos.y) * U
			_slash_fx("slash_down" if i % 2 == 0 else "slash_up")
			_front(1.0, 1.5, 22.0 if i < 5 else 36.0, "flinch" if i < 5 else "launch"))

## ชิ้นสกิลแบบพิเศษของสายกับดัก
func _tick_trap_obj(o: Dictionary, delta: float) -> void:
	var t := str(o.get("type", ""))
	if t == "rollball":
		var step := float(o["speed"]) * delta
		o["left"] = float(o["left"]) - step
		o["pos"] = (o["pos"] as Vector2) + Vector2(_f() * step, 0.0)
		var n: SusiFx = o["node"]
		if is_instance_valid(n):
			n.position = o["pos"]
		var hit := not _in_circle(o["pos"], 0.6 * U).is_empty()
		if hit or float(o["left"]) <= 0.0:
			_boom((o["pos"] as Vector2) + Vector2(0.0, -30.0), 1.9 * U, 1.4 * U, float(o["dmg"]), "knock", "leaf")
			_end(o)
	elif t == "orbtrap":
		var v: Vector2 = o["vel"]
		v.y += 1800.0 * delta
		var pos: Vector2 = (o["pos"] as Vector2) + v * delta
		if pos.y > -30.0:
			pos.y = -30.0
			v = Vector2(v.x * 0.5, 0.0)
		o["vel"] = v
		o["pos"] = pos
		var n2: SusiFx = o["node"]
		if is_instance_valid(n2):
			n2.position = pos
		if not _in_circle(pos, 0.6 * U).is_empty() or float(o["life"]) <= 0.0:
			# แตกเป็นหลายฮิต มอนชะงัก
			_area("boom", "silver", pos, 1.3 * U, 0.8, float(o["dmg"]), "flinch", {"tick": 0.1, "hit_at": Vector2.ZERO, "hit_r": 1.4 * U})
			_fx("poof", "leaf", pos, 50.0, 0.4)
			_end(o)

# ---------------------------------------------------------------- ทุกเฟรม
func _process(delta: float) -> void:
	super._process(delta)
	if page == null:
		return
	revive_cd = maxf(revive_cd - delta, 0.0)
	_tick_charge(delta)
	for o in _objs.duplicate():
		_tick_landing(o)

func _tick_charge(delta: float) -> void:
	if _charge.is_empty():
		return
	_charge["t"] = float(_charge["t"]) + delta
	var n: SusiFx = _charge.get("fx")
	if is_instance_valid(n):
		n.position = hero.position + Vector2(_f() * 30.0, -20.0)
		n.r = 40.0 + 50.0 * clampf(float(_charge["t"]) / float(_charge["max"]), 0.0, 1.0)
	hero.plain_swing = clampf(hero.plain_swing, 0.001, 0.5)
	if (not _held() and float(_charge["t"]) > 0.12) or float(_charge["t"]) >= float(_charge["max"]) or hero.hurt_t > 0.0:
		_release_burst()

## ทุ่มพื้นตอนตกถึงพื้น (35.1 / 45.2)
func _tick_landing(o: Dictionary) -> void:
	var t := str(o.get("type", ""))
	if t != "stomp_wind" and t != "slam_wind":
		return
	if float(o["age"]) < float(o["wait"]):
		return
	if not hero.on_floor() and float(o["life"]) > 0.0:
		hero.vel.y = minf(hero.vel.y, -Hero.CHIBI_DIVE_SPEED * 0.8)
		return
	_objs.erase(o)
	var w := (page._screen_w() * 0.5) if t == "slam_wind" else 3.5 * U
	_boom(hero.position + Vector2(0.0, -40.0), w, 1.6 * U, 60.0 if t == "slam_wind" else 45.0, "launch", "leaf")
	_wind_fx("ring", w, 0.6, hero.position)
	_kick_fx("down")

func _apply_passives(delta: float) -> void:
	hero.mp_bonus = Stats.MP_UP if has("bw_sk_gt_vigor") else 0.0
	hero.hp_bonus = VIGOR_HP if has("bw_sk_gt_vigor") else 0.0
	hero.regen_mult = 1.0
	hero.speed_bonus = Stats.SPEED_MULT * 1.08 if has("bw_sk_gt_swift") else 1.0
	page.atk_speed = HASTE if has("bw_sk_ws_haste") else 1.0
	hero.block_chance = 0.11 if has("bw_sk_ap_block") else 0.0
	if buffs.has("song"):
		hero.mp = minf(hero.mp + 20.0 * delta, hero.mp_max())
	if buffs.has("revive"):
		hero.hp = minf(hero.hp + hero.hp_max() * 0.06 * delta, hero.hp_max())

func on_strike(m: Monster, h: Dictionary) -> void:
	if buffs.has("tap") and not h.get("skill", false):
		hero.mp = minf(hero.mp + TAP_MP, hero.mp_max())
	# APEX 60.1 ยิงธนูโดนได้มานาคืนมากขึ้น
	if has("bw_sk_ap_mana") and not h.get("skill", false):
		hero.mp = minf(hero.mp + 2.0, hero.mp_max())
	if h.get("apex_mark", false):
		m.set_meta("apex_mark", Time.get_ticks_msec() + 8000)
		_fx("ring", "redwind", _mc(m), 40.0, 0.6)
	if h.get("freeze_arrow", false):
		m.freeze_ice(2.0)

## SNIPE 15.4 ลูกศรไปได้ไกลขึ้น
func mod_shot(shot: Array) -> void:
	if has("bw_sk_sn_range") and shot.size() > 4:
		shot[4] = float(shot[4]) * 1.6

func dmg_mult(m: Monster, h: Dictionary) -> float:
	var k := 1.0
	# APEX 35.2 เป้าที่ติดเครื่องหมายโดนแรงขึ้น
	if m.has_meta("apex_mark") and int(m.get_meta("apex_mark")) > Time.get_ticks_msec():
		k *= 1.3
	# APEX 35.4 การโจมตีปกติแรงขึ้น 15%
	if has("bw_sk_ap_eagle") and not h.get("skill", false):
		k *= 1.15
	return k

## 60.2 เลือดหมดไม่ตายทันที ถอยหลังไกลแล้วฟื้นเลือด 10 วิ
func _on_hurt(_kind: String) -> void:
	if hero.hp > 0.0 or revive_cd > 0.0 or not has("bw_sk_gt_revive"):
		return
	revive_cd = REVIVE_CD
	hero.hp = maxf(1.0, hero.hp_max() * 0.1)
	hero.invuln_t = maxf(hero.invuln_t, 1.5)
	buffs["revive"] = REVIVE_TIME
	_hop(0.7)
	_add({"type": "slide", "life": 0.4, "speed": -14.0, "node": null})
	_fx("poof", "leaf", hero.position + Vector2(0.0, -80.0), 70.0, 0.6)
	page.bars.notice("ยังไม่ยอมแพ้! ฟื้นเลือด %d วิ" % int(REVIVE_TIME))

func _draw_ui() -> void:
	super._draw_ui()
