class_name PairSkillsPlus
extends PairSkills
## สกิลเพิ่มของ CAT AZURE & LAPIS ต่อยอดจาก PairSkills
## สาย 3: tt_ TWIN TEMPO → hd_ HARMONY DUET  ทั้งคู่ตีประสานพร้อมกัน
## สาย 4: ps_ PSYCHE PAW → ie_ ID EGO SAGE  พลัง ID (สัญชาตญาณดิบ) กับ EGO (สติ ควบคุม) มีเกจสมดุล -1 (EGO) ถึง 1 (ID)
## แปลงร่างพลังดิบ: SPARK DREAMER 35.1 (AZURE ประกายไล่ล่า บอลพลัง) / SOMNAMBULIST 50.1 (LAPIS ดาบแสงยาวฟันรัว)
##   ระหว่างแปลงร่าง ช่องสกิล 4 ช่องเป็นสกิลชุดแปลงร่าง คอมโบเปลี่ยน (PairCombo.tf) สลับตัวไม่ได้

const MORE_DEFS := {
	"pr_sk_tt_beat": {"cd": 5.0},
	"pr_sk_tt_scissor": {"cd": 8.0},
	"pr_sk_tt_pass": {"cd": 9.0},
	"pr_sk_tt_bounce": {"cd": 9.0, "air": true},
	"pr_sk_tt_wheel": {"cd": 10.0},
	"pr_sk_tt_chain": {"cd": 22.0},
	"pr_sk_tt_lift": {"cd": 9.0, "air": true},
	"pr_sk_tt_march": {"cd": 12.0},
	"pr_sk_hd_cross": {"cd": 12.0},
	"pr_sk_hd_waltz": {"cd": 11.0},
	"pr_sk_hd_tandem": {"cd": 14.0},
	"pr_sk_hd_pillar": {"cd": 16.0},
	"pr_sk_hd_finale": {"cd": 16.0, "air": true},
	"pr_sk_hd_mirror": {"cd": 26.0},
	"pr_sk_hd_chorus": {"cd": 20.0},
	"pr_sk_ps_id": {"cd": 5.0, "air": true},
	"pr_sk_ps_ego": {"cd": 14.0},
	"pr_sk_ps_roar": {"cd": 8.0},
	"pr_sk_ps_focus": {"cd": 20.0},
	"pr_sk_ps_split": {"cd": 10.0},
	"pr_sk_ps_frenzy": {"cd": 9.0},
	"pr_sk_ps_redirect": {"cd": 12.0},
	"pr_sk_ps_balance": {"cd": 16.0},
	"pr_sk_ie_unleash": {"cd": 10.0, "air": true},
	"pr_sk_ie_halo": {"cd": 12.0},
	"pr_sk_ie_storm": {"cd": 14.0},
	"pr_sk_ie_wall": {"cd": 16.0},
	"pr_sk_ie_clash": {"cd": 14.0},
	"pr_sk_ie_lucid": {"cd": 22.0},
	"pr_sk_ie_core": {"cd": 24.0},
	# แปลงร่าง
	"pr_sk_sd_awaken": {"cd": 45.0},
	"pr_sk_so_awaken": {"cd": 45.0},
	"pr_sk_tfa_seek": {"cd": 2.5, "air": true},
	"pr_sk_tfa_orbit": {"cd": 9.0, "air": true},
	"pr_sk_tfa_nova": {"cd": 7.0},
	"pr_sk_tfa_rain": {"cd": 10.0},
	"pr_sk_tfl_flurry": {"cd": 3.0},
	"pr_sk_tfl_thrust": {"cd": 5.0, "air": true},
	"pr_sk_tfl_cross": {"cd": 7.0},
	"pr_sk_tfl_tempest": {"cd": 11.0},
}
const MORE_MP := {
	"pr_sk_tt_beat": 60.0, "pr_sk_tt_scissor": 80.0, "pr_sk_tt_pass": 90.0, "pr_sk_tt_bounce": 100.0,
	"pr_sk_tt_wheel": 110.0, "pr_sk_tt_chain": 120.0, "pr_sk_tt_lift": 100.0, "pr_sk_tt_march": 140.0,
	"pr_sk_hd_cross": 170.0, "pr_sk_hd_waltz": 160.0, "pr_sk_hd_tandem": 190.0, "pr_sk_hd_pillar": 200.0,
	"pr_sk_hd_finale": 220.0, "pr_sk_hd_mirror": 180.0, "pr_sk_hd_chorus": 240.0,
	"pr_sk_ps_id": 50.0, "pr_sk_ps_ego": 70.0, "pr_sk_ps_roar": 80.0, "pr_sk_ps_focus": 60.0,
	"pr_sk_ps_split": 100.0, "pr_sk_ps_frenzy": 110.0, "pr_sk_ps_redirect": 90.0, "pr_sk_ps_balance": 130.0,
	"pr_sk_ie_unleash": 160.0, "pr_sk_ie_halo": 170.0, "pr_sk_ie_storm": 200.0, "pr_sk_ie_wall": 180.0,
	"pr_sk_ie_clash": 210.0, "pr_sk_ie_lucid": 170.0, "pr_sk_ie_core": 240.0,
	"pr_sk_sd_awaken": 150.0, "pr_sk_so_awaken": 200.0,
	"pr_sk_tfa_seek": 30.0, "pr_sk_tfa_orbit": 70.0, "pr_sk_tfa_nova": 80.0, "pr_sk_tfa_rain": 110.0,
	"pr_sk_tfl_flurry": 35.0, "pr_sk_tfl_thrust": 50.0, "pr_sk_tfl_cross": 80.0, "pr_sk_tfl_tempest": 120.0,
}
const MORE_COL := {
	"sync": [Color(0.38, 0.58, 0.95), Color(1.0, 0.82, 0.64)],
	"psyche": [Color(0.5, 0.52, 0.9), Color(1.0, 0.7, 0.8)],
	"ego": [Color(0.42, 0.62, 0.95), Color(0.72, 0.9, 1.0)],
	"raw_az": [Color(0.32, 0.58, 1.0), Color(0.78, 0.95, 1.0)],
	"raw_lp": [Color(0.52, 0.48, 0.95), Color(0.88, 0.84, 1.0)],
}
## สกิลชุดแปลงร่าง (ขึ้นในช่องสกิล 4 ช่อง)
const TF_AZ := ["pr_sk_tfa_seek", "pr_sk_tfa_orbit", "pr_sk_tfa_nova", "pr_sk_tfa_rain"]
const TF_LP := ["pr_sk_tfl_flurry", "pr_sk_tfl_thrust", "pr_sk_tfl_cross", "pr_sk_tfl_tempest"]
const TF_LABEL := {
	"pr_sk_tfa_seek": "ประกายไล่ล่า", "pr_sk_tfa_orbit": "บอลวงโคจร", "pr_sk_tfa_nova": "บอลพลังแตก", "pr_sk_tfa_rain": "ฝนไล่ล่า",
	"pr_sk_tfl_flurry": "ฟันรัว", "pr_sk_tfl_thrust": "แทงยาว", "pr_sk_tfl_cross": "ฟันกากบาท", "pr_sk_tfl_tempest": "พายุดาบ",
}
const TF_TIME := 18.0
const MORE_OBJS := ["orbit", "pillar", "wall", "lucid"]
const COVER_CD := 10.0
const PSY_STEP := 0.25          # สกิล ID / EGO ขยับเกจ
const SYNC_IDS := ["pr_sk_tt_", "pr_sk_hd_"]

var tf := ""                    # "az" / "lp" แปลงร่างอยู่
var tf_t := 0.0
var tf_count := 0               # นับในเทสต์
var psyche := 0.0               # เกจ -1 EGO ... 1 ID
var cover_cd := 0.0
var focus_left := 0             # PSYCHE 25.1 สกิลลดมานา
var echo_hits := 0              # นับในเทสต์
var _combo_hits := 0
var _aura: Node2D
var _meter: Node2D
var _hp_last := 0.0

func setup(p: WalkPage) -> void:
	super.setup(p)
	PairCombo.tf = ""
	if p.pad != null:
		p.pad.pswap_block = false
	if WalkPage.chosen_class in ["PSYCHE PAW", "ID EGO SAGE"]:
		_meter = PsycheMeter.new()
		_meter.skills = self
		p.world.add_child(_meter)

func _exit_tree() -> void:
	PairCombo.tf = ""

# ---------------------------------------------------------------- ข้อมูล
func cost(id: String) -> float:
	if free_skill:
		return 0.0
	var c := Stats.skill_mp("azure", id)
	if focus_left > 0 and not id.begins_with("pr_sk_tf"):
		c *= 0.7
	return c

func cooldown(id: String) -> float:
	if MORE_DEFS.has(id):
		return float(MORE_DEFS[id].get("cd", 3.0))
	return super.cooldown(id)

func _line_of(id: String) -> String:
	if id.begins_with("pr_sk_tfa_") or id == "pr_sk_sd_awaken":
		return "raw_az"
	if id.begins_with("pr_sk_tfl_") or id == "pr_sk_so_awaken":
		return "raw_lp"
	var p := id.trim_prefix("pr_sk_").get_slice("_", 0)
	if p in ["tt", "hd"]:
		return "sync"
	if p in ["ps", "ie"]:
		return "psyche"
	return super._line_of(id)

func _cols(line := "") -> Array:
	var l := line if line != "" else _line_of(_cur_id)
	if MORE_COL.has(l):
		return MORE_COL[l]
	return super._cols(l)

# ---------------------------------------------------------------- แปลงร่าง (หน้าใช้)
func tf_active() -> bool:
	return tf != ""

func tf_slots() -> Array:
	if tf == "az":
		return TF_AZ
	if tf == "lp":
		return TF_LP
	return []

func tf_label(id: String) -> String:
	return str(TF_LABEL.get(id, ""))

# ---------------------------------------------------------------- ใช้สกิล
func use(id: String) -> void:
	if not MORE_DEFS.has(id):
		# ร่างปกติใช้สกิลเดิม  แปลงร่างอยู่ใช้ได้เฉพาะสกิลชุดแปลงร่าง
		if tf != "":
			page.bars.notice("แปลงร่างอยู่ ใช้ได้เฉพาะสกิลแปลงร่าง")
			return
		super.use(id)
		_after_use(id)
		return
	var d: Dictionary = MORE_DEFS[id]
	if id.begins_with("pr_sk_tf") and tf == "":
		return
	if tf != "" and not id.begins_with("pr_sk_tf"):
		page.bars.notice("แปลงร่างอยู่ ใช้ได้เฉพาะสกิลแปลงร่าง")
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
	if focus_left > 0 and not id.begins_with("pr_sk_tf"):
		focus_left -= 1
	cds[id] = cooldown(id)
	_cur_id = id
	if not id.begins_with("pr_sk_tf"):
		BigSkillFx.cast(page, id, c)
	call("_do_" + id.trim_prefix("pr_sk_"))
	_after_use(id)

func _after_use(id: String) -> void:
	# HARMONY 60.2 มีโอกาสคูลดาวน์รีเซ็ต
	if has("pr_sk_hd_encore") and cds.has(id) and float(cds[id]) > 0.0 and randf() < 0.15:
		cds[id] = 0.0
		page.bars.notice("อังกอร์!")

## ขยับเกจจิต (+ ID  - EGO)
func psy_shift(v: float) -> void:
	var before := psyche
	var k := 1.3 if has("pr_sk_ie_flow") else 1.0
	psyche = clampf(psyche + v * k, -1.0, 1.0)
	# ID EGO SAGE 35.4 เกจข้ามฝั่ง วงกระแทก
	if has("pr_sk_ie_dual") and signf(before) != signf(psyche) and absf(psyche) > 0.05 and absf(before) > 0.05:
		var c := hero.position + Vector2(0.0, -60.0)
		_cur_id = "pr_sk_ie_dual"
		_sfx("ring", hero.position, 2.2 * U, 0.45, "psyche")
		for m in _in_circle(c, 1.8 * U):
			_hit(m, 22.0, "flinch", _side_of(m, c))

func _partner_here(dx: float, key: String, fn: Callable, fn_at := 0.2, life := 0.8, face := 0.0, hop := 0.0) -> PairSkillFx.PairPartner:
	return _partner(dx, key, fn, fn_at, life, face, false, hop)

# ---------------------------------------------------------------- TWIN TEMPO
## 15.2 ทั้งคู่ต่อยจุดเดียวกันพร้อมกัน 2 จังหวะ
func _do_tt_beat() -> void:
	_act("z1", 0.26)
	_partner_here(0.7, "z1", Callable(), 0.1, 0.8, _f())
	for i in 2:
		var k := float(i)
		_later(0.1 + k * 0.22, func() -> void:
			if k > 0.0:
				_act("z2", 0.24)
			var c := hero.position + Vector2(_f() * 1.3 * U * S, -70.0)
			_sfx("burst", c, 80.0, 0.3)
			for m in _in_ellipse(c, 1.0 * U, 1.2 * U):
				_hit(m, 16.0, "flinch", _f())
				_hit(m, 10.0, "light", _f()))

## 15.3 ปาดสวนกันจากสองฝั่ง ดึงมอนเข้ากลาง
func _do_tt_scissor() -> void:
	_act("z3", 0.32)
	var mid := hero.position + Vector2(_f() * 1.8 * U * S, -70.0)
	_partner_here(3.6 * S, "z3", Callable(), 0.12, 0.7, -_f())
	_later(0.16, func() -> void:
		_sfx("cross", mid, 1.3 * U, 0.45)
		for m in _in_ellipse(mid, 2.0 * U, 1.3 * U):
			m.pos.x = lerpf(m.pos.x, mid.x / U, 0.5)
			_hit(m, 26.0, "strong", _side_of(m, mid)))

## 20.4 ส่งบอลให้คู่หู ตีกลับทะลุ 2 รอบ
func _do_tt_pass() -> void:
	_act("x1" if _form() == "lp" else "z1", 0.3)
	var p := _partner_here(4.0 * S, "", Callable(), 0.1, 1.4, -_f())
	var start := hero.position + Vector2(_f() * 60.0, -90.0)
	_orb("bubble", start, Vector2(_f() * 1000.0, 0.0), 30.0, 14.0, true, 0.45, {"kb": 0.5, "stun": 0.5})
	_later(0.5, func() -> void:
		var from := p.world_pos() + Vector2(-_f() * 50.0, -90.0) if is_instance_valid(p) else start + Vector2(_f() * 4.0 * U * S, 0.0)
		_orb("neon", from, Vector2(-_f() * 1100.0, 0.0), 32.0, 18.0, true, 0.5, {"kb": 0.8, "stun": 0.6}))
	_later(1.0, func() -> void:
		_orb("neon", start, Vector2(_f() * 1300.0, 0.0), 36.0, 22.0, true, 0.6, {"kb": 1.6, "stun": 0.6}))

## 25.1 กระทืบพื้นพร้อมกันคนละจุด
func _do_tt_bounce() -> void:
	_act("az", 0.4)
	if hero.on_floor():
		_hop(0.55)
	_partner_here(2.6 * S, "", Callable(), 0.1, 1.0, _f(), 0.55)
	_land(func() -> void:
		for dx in [0.4, 2.8]:
			var at := Vector2(hero.position.x + _f() * dx * U * S, 0.0)
			_sfx("ring", at, 2.0 * U, 0.45)
			_boom(at + Vector2(0.0, -60.0), 1.3 * U, 1.2 * U, 28.0, "launch", "bolt"))

## 25.2 หลังชนหลังหมุนเป็นวงล้อ 3 รอบ
func _do_tt_wheel() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	_partner_here(-0.5, "", Callable(), 0.1, 1.0, -_f())
	for i in 3:
		var k := float(i)
		_later(0.05 + k * 0.28, func() -> void:
			_act("z3", 0.26, {"spin": 360.0, "lunge": 0.0})
			var c := hero.position + Vector2(0.0, -60.0)
			_sfx("ring", hero.position, 2.2 * U, 0.35)
			for m in _in_circle(c, 2.0 * U):
				_hit(m, 16.0, "flinch", _side_of(m, c)))

## 30.1 5 วิ ตีโดนแล้วคู่หูตีสะท้อน
func _do_tt_chain() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	buffs["echo"] = 5.0
	_sfx("burst", hero.position + Vector2(0.0, -80.0), 1.3 * U, 0.5)

## 30.2 คู่หูเสยลอย ตัวเองตบลง
func _do_tt_lift() -> void:
	_act("z1", 0.3, {"lunge": 0.0})
	var at := hero.position + Vector2(_f() * 1.6 * U * S, -60.0)
	_partner_here(1.6 * S, "z4", func(_p: PairSkillFx.PairPartner) -> void:
		_sfx("burst", at, 70.0, 0.3)
		for m in _in_ellipse(at, 1.2 * U, 1.4 * U):
			_hit(m, 14.0, "launch", _f(), {"vy": 11.0}), 0.15, 0.8, -_f())
	_later(0.45, func() -> void:
		_act("az", 0.4)
		if hero.on_floor():
			_hop(0.75)
		_land(func() -> void:
			var c := hero.position + Vector2(_f() * 0.8 * U * S, -60.0)
			_sfx("ring", Vector2(c.x, 0.0), 2.2 * U, 0.4)
			_boom(c, 1.6 * U, 2.6 * U, 34.0, "knock", "bolt")))

## 35.1 เดินหน้าตีสลับคนละที 6 จังหวะ
func _do_tt_march() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.8)
	var p := _partner_here(0.6, "", Callable(), 0.1, 1.9, _f())
	for i in 6:
		var k := i
		_later(0.05 + float(i) * 0.26, func() -> void:
			var last := k == 5
			if k % 2 == 0:
				_act(["z1", "z2", "z3"][k / 2], 0.24)
				_add({"type": "slide", "life": 0.12, "speed": 6.0, "node": null})
			elif is_instance_valid(p) and is_instance_valid(p.actor):
				p.actor.pos.x = clampf(hero.pos.x + _f() * 0.7, -hero.half_width, hero.half_width)
				p.actor.position.x = p.actor.pos.x * U
			_front(1.0 if k % 2 == 0 else 1.6, 1.2, 28.0 if last else 14.0, "knock" if last else "flinch"))

# ---------------------------------------------------------------- HARMONY DUET
## 35.2 ยืนสองฝั่ง ลำแสงไขว้กันกลางมอน ช็อตต่อเนื่อง
func _do_hd_cross() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	var p := _partner_here(4.4 * S, "x1", Callable(), 0.1, 1.6, -_f())
	var node := _sfx("beam", hero.position + Vector2(_f() * 60.0, -100.0), 40.0, 1.4, "", Vector2(_f() * 4.4 * U * S - _f() * 120.0, 30.0))
	_add({"type": "circuit", "life": 1.3, "partner": p, "node": node, "tick": 0.18, "tick_t": 0.05, "dmg": 11.0})

## 35.3 หมุนวอลทซ์ไปหน้า ตี 6 ที
func _do_hd_waltz() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.7)
	var p := _partner_here(0.5, "", Callable(), 0.1, 1.8, -_f())
	for i in 6:
		var k := i
		_later(0.05 + float(i) * 0.25, func() -> void:
			_act("z3", 0.24, {"spin": 360.0})
			_add({"type": "slide", "life": 0.14, "speed": 7.0, "node": null})
			if is_instance_valid(p) and is_instance_valid(p.actor):
				p.actor.pos.x = clampf(hero.pos.x + _f() * 0.5, -hero.half_width, hero.half_width)
				p.actor.position.x = p.actor.pos.x * U
			var last := k == 5
			var c := hero.position + Vector2(_f() * 0.6 * U * S, -60.0)
			_sfx("notes" if k % 2 == 0 else "ring", c, 1.2 * U, 0.35)
			for m in _in_circle(c, 1.5 * U):
				_hit(m, 30.0 if last else 15.0, "launch" if last else "flinch", _side_of(m, c)))

## 45.1 ผลัดกันพุ่งตีมอนใกล้สุด 8 ที
func _do_hd_tandem() -> void:
	hero.invuln_t = maxf(hero.invuln_t, 1.8)
	for i in 8:
		var k := i
		_later(0.05 + float(i) * 0.2, func() -> void:
			var from := hero.position + Vector2(0.0, -70.0)
			var m := _nearest(from, 5.0 * U * S)
			var face := _f() if m == null else _side_of(m, from)
			var tx := hero.pos.x + face * 1.2 if m == null else m.pos.x
			if k % 2 == 0:
				hero.facing = face
				hero.pos.x = clampf(tx - face * 0.9, -hero.half_width, hero.half_width)
				hero.position.x = hero.pos.x * U
				_act("dz", 0.18)
			else:
				_partner_here((tx - hero.pos.x) * face + 0.9, "z2", Callable(), 0.08, 0.35, -face)
			_sfx("line", from, 40.0, 0.25, "", Vector2(tx * U, -70.0) - from)
			if m != null:
				_hit(m, 22.0, "flinch", face))

## 45.2 เสาแสงซ้ายขวา ดูดเข้ากลางแล้วระเบิด
func _do_hd_pillar() -> void:
	_act("x1", 0.35, {"lunge": 0.0})
	var mid := hero.position + Vector2(_f() * 2.6 * U * S, -80.0)
	for side in [-1.0, 1.0]:
		_sfx("column", Vector2(mid.x + side * 2.2 * U * S, 0.0), 0.8 * U, 1.3)
	_add({"type": "pull", "pos": mid, "r": 3.4 * U, "speed": 6.0, "life": 1.0})
	_later(1.1, func() -> void:
		_sfx("burst", mid, 2.0 * U, 0.5)
		_boom(mid, 2.4 * U, 1.8 * U, 70.0, "knock", "bolt"))

## 50.1 กระโดดดิ่งลงพร้อมกัน
func _do_hd_finale() -> void:
	_act("az", 0.4)
	if hero.on_floor():
		_hop(0.8)
	_partner_here(1.4 * S, "", Callable(), 0.1, 1.3, _f(), 0.8)
	_land(func() -> void:
		var c := hero.position + Vector2(_f() * 0.7 * U * S, -60.0)
		_sfx("ring", Vector2(c.x, 0.0), 3.6 * U, 0.55)
		_sfx("burst", c, 2.2 * U, 0.5)
		_boom(c, 3.2 * U, 2.2 * U, 90.0, "knock", "bolt"))

## 50.2 6 วิ คู่หูเป็นเงาตีคอมโบตาม
func _do_hd_mirror() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	buffs["mirror"] = 6.0
	var p := _partner(-0.8, "", Callable(), 0.1, 6.0, _f(), true)
	_add({"type": "twin", "life": 6.0, "partner": p, "tick": 0.8, "tick_t": 0.4})

## 55.1 คลื่นประสานเสียง 3 ระลอก
func _do_hd_chorus() -> void:
	_act("x1", 0.4, {"lunge": 0.0})
	_partner_here(-0.7, "x1", Callable(), 0.1, 1.2, _f())
	for i in 3:
		var k := float(i)
		_later(0.1 + k * 0.3, func() -> void:
			var c := hero.position + Vector2(0.0, -70.0)
			_sfx("notes", c, (1.6 + k * 0.5) * U, 0.45)
			_sfx("ring", hero.position, (2.4 + k * 0.6) * U, 0.45)
			for m in _in_circle(c, (2.2 + k * 0.6) * U):
				if k >= 2.0:
					_hit(m, 40.0, "launch", _side_of(m, c), {"vy": 11.0})
				else:
					_hit(m, 20.0, "flinch", _side_of(m, c)))

# ---------------------------------------------------------------- PSYCHE PAW
## 15.2 กระโจนข่วนรัว 3 ที (ID)
func _do_ps_id() -> void:
	psy_shift(PSY_STEP)
	for i in 3:
		var k := i
		_later(0.03 + float(i) * 0.14, func() -> void:
			_act(["z1", "z2", "z3"][k], 0.14)
			_add({"type": "slide", "life": 0.1, "speed": 9.0, "node": null})
			var c := hero.position + Vector2(_f() * 0.9 * U * S, -60.0)
			_sfx("burst", c, 60.0, 0.25, "psyche")
			_front(1.0, 1.0, 14.0, "flinch"))

## 15.3 ตั้งสติ กันดาเมจ 2 วิ (EGO)
func _do_ps_ego() -> void:
	psy_shift(-PSY_STEP)
	_act("x1", 0.3, {"lunge": 0.0})
	buffs["guard_all"] = 2.0
	_sfx("bubble", hero.position + Vector2(0.0, -80.0), 1.8 * U, 2.0, "ego", Vector2.ZERO, hero)

## 20.4 คำรามรอบตัว (ID)
func _do_ps_roar() -> void:
	psy_shift(PSY_STEP)
	_act("z1", 0.35, {"lunge": 0.0, "lean": -14.0})
	var c := hero.position + Vector2(0.0, -70.0)
	_sfx("ring", hero.position, 2.6 * U, 0.45, "psyche")
	_sfx("burst", c, 1.6 * U, 0.4, "psyche")
	for m in _in_circle(c, 2.4 * U):
		_hit(m, 22.0, "strong", _side_of(m, c))

## 25.1 สงบใจ ฟื้นเลือด สกิล 3 ครั้งลดมานา (EGO)
func _do_ps_focus() -> void:
	psy_shift(-PSY_STEP)
	_act("x1", 0.35, {"lunge": 0.0})
	hero.hp = minf(hero.hp + hero.hp_max() * 0.05, hero.hp_max())
	focus_left = 3
	_sfx("zone", hero.position, 1.4 * U, 1.0, "ego")

## 25.2 เศษจิต 2 ลูก
func _do_ps_split() -> void:
	_act("x1" if _form() == "lp" else "z1", 0.3)
	_cur_id = "pr_sk_ps_split"
	var at := hero.position + Vector2(_f() * 70.0, -90.0)
	var id_orb := _orb("bubble", at + Vector2(0.0, -30.0), Vector2(_f() * 800.0, -60.0), 30.0, 22.0, false, 0.9, {"type": "knockdown", "fly": 4.0})
	id_orb.accent = MORE_COL["psyche"][1]
	var ego := _orb("moon", at + Vector2(0.0, 30.0), Vector2(_f() * 520.0, 0.0), 34.0, 10.0, true, 1.4, {"kb": -1.2, "stun": 0.8})
	ego.base = MORE_COL["ego"][0]
	ego.accent = MORE_COL["ego"][1]
	_later(0.7, func() -> void:
		var c := Vector2(hero.position.x + _f() * 3.2 * U * S, -80.0)
		if is_instance_valid(ego):
			c = ego.position
		_add({"type": "pull", "pos": c, "r": 2.6 * U, "speed": 6.0, "life": 0.6}))

## 30.1 คลั่งข่วนรัว 6 ที (ID)
func _do_ps_frenzy() -> void:
	psy_shift(PSY_STEP)
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.9)
	for i in 6:
		var k := i
		_later(0.02 + float(i) * 0.12, func() -> void:
			_act(["z1", "z2"][k % 2], 0.12)
			_add({"type": "slide", "life": 0.08, "speed": 7.0, "node": null})
			_front(1.0, 1.1, 30.0 if k == 5 else 11.0, "knock" if k == 5 else "flinch"))

## 30.2 ตั้งรับ โดนตีแล้วสะท้อน (EGO)
func _do_ps_redirect() -> void:
	psy_shift(-PSY_STEP)
	_act("x1", 0.3, {"lunge": 0.0})
	buffs["redirect"] = 1.2
	hero.melee_guard_t = maxf(hero.melee_guard_t, 1.2)
	_sfx("bubble", hero.position + Vector2(0.0, -80.0), 1.4 * U, 1.2, "ego", Vector2.ZERO, hero)

## 35.1 จุดสมดุล
func _do_ps_balance() -> void:
	_act("x1", 0.35, {"lunge": 0.0})
	var c := hero.position + Vector2(0.0, -70.0)
	if absf(psyche) <= 0.3:
		hero.hp = minf(hero.hp + hero.hp_max() * 0.12, hero.hp_max())
		_sfx("ring", hero.position, 3.2 * U, 0.5, "psyche")
		_sfx("burst", c, 2.0 * U, 0.5, "ego")
		for m in _in_circle(c, 3.0 * U):
			_hit(m, 50.0, "knock", _side_of(m, c))
	else:
		psy_shift(-psyche * 0.8)
		_sfx("ring", hero.position, 1.8 * U, 0.4, "psyche")
		for m in _in_circle(c, 1.6 * U):
			_hit(m, 22.0, "flinch", _side_of(m, c))

# ---------------------------------------------------------------- ID EGO SAGE
## 35.2 พุ่งข่วนผ่านมอน 3 ครั้ง (ID)
func _do_ie_unleash() -> void:
	psy_shift(PSY_STEP)
	hero.invuln_t = maxf(hero.invuln_t, 0.9)
	for i in 3:
		_later(0.03 + float(i) * 0.24, func() -> void:
			var from := hero.position + Vector2(0.0, -70.0)
			var to_x := clampf(hero.pos.x + _f() * 2.2 * S, -hero.half_width, hero.half_width)
			var hit := _in_line(from, _f(), absf(to_x - hero.pos.x) * U, 1.0 * U * S)
			hero.pos.x = to_x
			hero.position.x = hero.pos.x * U
			_act("dz", 0.2)
			_sfx("line", from, 46.0, 0.3, "psyche", hero.position + Vector2(0.0, -70.0) - from)
			for m in hit:
				_hit(m, 30.0, "strong", _f())
			hero.facing = -_f())

## 35.3 วงแสงยิงมอนใกล้สุด 5 ตัว
func _do_ie_halo() -> void:
	psy_shift(-psyche * 0.4)
	_act("x1", 0.35, {"lunge": 0.0})
	var top := hero.position + Vector2(0.0, -200.0)
	_sfx("ring", top, 1.0 * U, 1.0, "ego")
	var done := []
	for i in 5:
		var k := float(i)
		_later(0.15 + k * 0.15, func() -> void:
			var m := _nearest(top, 6.0 * U * S, done)
			if m == null:
				return
			done.append(m)
			_sfx("bolt", top, 36.0, 0.25, "ego", _mc(m) - top)
			_hit(m, 30.0, "strong", _side_of(m, top)))

## 45.1 หมุนข่วนเป็นพายุ 1.5 วิ (ID)
func _do_ie_storm() -> void:
	psy_shift(PSY_STEP)
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.6)
	for i in 6:
		_later(0.02 + float(i) * 0.25, func() -> void:
			_act("z3", 0.24, {"spin": 360.0, "lunge": 0.0})
			var c := hero.position + Vector2(0.0, -60.0)
			_sfx("ring", hero.position, 2.3 * U, 0.3, "psyche")
			for m in _in_circle(c, 2.1 * U):
				_hit(m, 16.0, "flinch", _side_of(m, c)))

## 45.2 กำแพงสติด้านหน้า 3 วิ (EGO)
func _do_ie_wall() -> void:
	psy_shift(-PSY_STEP)
	_act("x1", 0.3, {"lunge": 0.0})
	var at := Vector2(hero.position.x + _f() * 1.6 * U * S, 0.0)
	var node := _sfx("bar", at, 1.0 * U, 3.0, "ego")
	_add({"type": "wall", "pos": at, "life": 3.0, "node": node, "tick": 0.3, "tick_t": 0.0, "dir": _f()})

## 50.1 ลูก ID กับ EGO ปะทะกันด้านหน้า
func _do_ie_clash() -> void:
	_act("x1", 0.35, {"lunge": 0.0})
	var meet := hero.position + Vector2(_f() * 3.0 * U * S, -90.0)
	var a := _orb("bubble", meet + Vector2(0.0, -1.6 * U), Vector2(0.0, 600.0), 34.0, 0.0, true, 0.6)
	a.accent = MORE_COL["psyche"][1]
	var b := _orb("moon", meet + Vector2(_f() * 1.6 * U, 0.0), Vector2(-_f() * 600.0, 0.0), 34.0, 0.0, true, 0.6)
	b.base = MORE_COL["ego"][0]
	_later(0.55, func() -> void:
		for o in [a, b]:
			if is_instance_valid(o):
				o.queue_free()
		_sfx("burst", meet, 2.2 * U, 0.5, "psyche")
		_sfx("ring", Vector2(meet.x, 0.0), 2.8 * U, 0.5, "ego")
		_boom(meet, 2.4 * U, 1.8 * U, 80.0, "knock", "bolt"))

## 50.2 เขตฝันรู้ตัว 4 วิ
func _do_ie_lucid() -> void:
	psy_shift(-psyche * 0.3)
	_act("x1", 0.3, {"lunge": 0.0})
	var at := Vector2(hero.position.x, 0.0)
	var node := _sfx("zone", at, 3.2 * U, 4.0, "ego")
	_add({"type": "lucid", "pos": at, "life": 4.0, "node": node, "half": 3.2 * U * S})

## 55.1 ใช้เกจทั้งหมด
func _do_ie_core() -> void:
	_act("x1", 0.4, {"lunge": 0.0})
	var c := hero.position + Vector2(_f() * 1.2 * U * S, -80.0)
	var power := absf(psyche)
	if psyche >= 0.0:
		_sfx("burst", c, (1.6 + power) * U, 0.55, "psyche")
		_sfx("ring", Vector2(c.x, 0.0), (2.6 + power) * U, 0.5, "psyche")
		_boom(c, (2.0 + power) * U, 1.8 * U, 60.0 + 140.0 * power, "knock", "bolt")
	else:
		buffs["guard_all"] = 2.0 + 2.0 * power
		hero.hp = minf(hero.hp + hero.hp_max() * (0.1 + 0.2 * power), hero.hp_max())
		_sfx("bubble", hero.position + Vector2(0.0, -80.0), 2.0 * U, 2.0 + 2.0 * power, "ego", Vector2.ZERO, hero)
		for m in _in_circle(c, 2.0 * U):
			_hit(m, 40.0, "strong", _side_of(m, c))
	psyche = 0.0

# ---------------------------------------------------------------- แปลงร่าง
## SPARK DREAMER 35.1 AZURE แปลงร่างพลังดิบ
func _do_sd_awaken() -> void:
	_tf_start("az")

## SOMNAMBULIST 50.1 LAPIS แปลงร่างพลังดิบ
func _do_so_awaken() -> void:
	_tf_start("lp")

func _tf_start(who: String) -> void:
	if _form() != who:
		page.pair_swap(false)
	tf = who
	tf_t = TF_TIME
	tf_count += 1
	PairCombo.tf = who
	page._end_combo()
	if page.pad != null:
		page.pad.pswap_block = true
		page.pad.set_row(0)
	page._refresh_slot()
	_act("x1", 0.4, {"lunge": 0.0, "lean": -10.0})
	_cur_id = "pr_sk_sd_awaken" if who == "az" else "pr_sk_so_awaken"
	_sfx("ring", hero.position, 2.6 * U, 0.6)
	_sfx("burst", hero.position + Vector2(0.0, -80.0), 1.8 * U, 0.6)
	for m in _in_circle(hero.position + Vector2(0.0, -60.0), 2.0 * U):
		_hit(m, 20.0, "strong", _side_of(m, hero.position))
	if is_instance_valid(_aura):
		_aura.queue_free()
	_aura = RawAura.new()
	_aura.skills = self
	var cols: Array = MORE_COL["raw_az" if who == "az" else "raw_lp"]
	_aura.base = cols[0]
	_aura.accent = cols[1]
	page.world.add_child(_aura)
	page.bars.notice("แปลงร่างพลังดิบ! (%d วิ)" % int(TF_TIME))

func _tf_end() -> void:
	if tf == "":
		return
	tf = ""
	tf_t = 0.0
	PairCombo.tf = ""
	if is_instance_valid(page):
		page._end_combo()
		if page.pad != null:
			page.pad.pswap_block = false
		page._refresh_slot()
	if is_instance_valid(_aura):
		_aura.queue_free()
	_aura = null

## AZURE: ประกายไล่ล่า 5 ลูก
func _do_tfa_seek() -> void:
	_act("z1", 0.24)
	for i in 5:
		var k := float(i)
		_later(0.02 + k * 0.07, func() -> void:
			var ang := -0.7 + k * 0.35
			_homing(hero.position + Vector2(_f() * 60.0, -100.0), Vector2(_f() * cos(ang), sin(ang)) * 700.0, 20.0, 12.0, 1.6))

## AZURE: บอลวงโคจร 3 ลูก 6 วิ
func _do_tfa_orbit() -> void:
	_act("x1", 0.3, {"lunge": 0.0})
	var nodes := []
	for i in 3:
		var b := _orb("spark", hero.position, Vector2.ZERO, 26.0, 0.0, true, 6.2)
		b.set_process(false)
		nodes.append(b)
	_add({"type": "orbit", "life": 6.0, "nodes": nodes, "tick": 0.25, "tick_t": 0.0, "dmg": 10.0})

## AZURE: บอลพลังใหญ่ แตกเป็นประกายไล่ล่า 8 ลูก
func _do_tfa_nova() -> void:
	_act("x4" if _form() == "az" else "x1", 0.35)
	var start := hero.position + Vector2(_f() * 80.0, -100.0)
	var big := _orb("spark", start, Vector2(_f() * 420.0, 0.0), 46.0, 26.0, true, 0.8, {"kb": 1.0, "stun": 0.6})
	_later(0.75, func() -> void:
		var c := start + Vector2(_f() * 420.0 * 0.75, 0.0)
		if is_instance_valid(big):
			c = big.position
			big.queue_free()
		_sfx("burst", c, 1.4 * U, 0.4)
		for i in 8:
			var a := TAU * float(i) / 8.0
			_homing(c, Vector2(cos(a), sin(a)) * 520.0, 16.0, 11.0, 1.4, 0.12))

## AZURE: ฝนไล่ล่า 10 ลูก ลอยขึ้นแล้วดิ่งใส่มอน
func _do_tfa_rain() -> void:
	_act("x1", 0.35, {"lunge": 0.0, "lean": -10.0})
	for i in 10:
		var k := float(i)
		_later(0.03 + k * 0.06, func() -> void:
			_homing(hero.position + Vector2(randf_range(-60.0, 60.0), -120.0), Vector2(randf_range(-260.0, 260.0), -760.0), 16.0, 12.0, 2.0, 0.3))

## LAPIS: ฟันดาบแสงยาวรัว 8 ที
func _do_tfl_flurry() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.0)
	for i in 8:
		var k := i
		_later(0.02 + float(i) * 0.09, func() -> void:
			_act(["z1", "z2"][k % 2], 0.09)
			var c := hero.position + Vector2(_f() * 1.6 * U * S, -70.0)
			if k % 2 == 0:
				_sfx("cross", c, 1.1 * U, 0.2)
			for m in _in_ellipse(c, 1.9 * U, 1.1 * U):
				_hit(m, 30.0 if k == 7 else 9.0, "knock" if k == 7 else "light", _f()))

## LAPIS: แทงดาบยาวพุ่ง ทะลุทั้งแนว
func _do_tfl_thrust() -> void:
	var from := hero.position + Vector2(0.0, -70.0)
	_act("dz", 0.28)
	var reach := 4.5 * S
	var to_x := clampf(hero.pos.x + _f() * reach * 0.6, -hero.half_width, hero.half_width)
	var hit := _in_line(from, _f(), reach * U, 0.8 * U * S)
	hero.pos.x = to_x
	hero.position.x = hero.pos.x * U
	_sfx("beam", from, 40.0, 0.3, "", Vector2(_f() * reach * U, 0.0))
	for m in hit:
		_hit(m, 34.0, "strong", _f())

## LAPIS: ฟันกากบาท 2 ครั้ง
func _do_tfl_cross() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 0.7)
	for i in 2:
		var k := float(i)
		_later(0.03 + k * 0.25, func() -> void:
			_act("z3", 0.22)
			var c := hero.position + Vector2(_f() * 1.8 * U * S, -80.0)
			_sfx("cross", c, 1.8 * U, 0.4)
			for m in _in_ellipse(c, 2.2 * U, 1.6 * U):
				_hit(m, 26.0 if k < 1.0 else 40.0, "strong" if k < 1.0 else "launch", _f(), {} if k < 1.0 else {"vy": 11.0}))

## LAPIS: พายุดาบ เดินหน้าฟันรัว 12 ที ปิดฟันใหญ่
func _do_tfl_tempest() -> void:
	hero.plain_sa_t = maxf(hero.plain_sa_t, 1.6)
	for i in 12:
		var k := i
		_later(0.02 + float(i) * 0.1, func() -> void:
			_act(["z1", "z2", "z3"][k % 3], 0.1)
			_add({"type": "slide", "life": 0.08, "speed": 5.0, "node": null})
			var c := hero.position + Vector2(_f() * 1.5 * U * S, -70.0)
			if k % 3 == 0:
				_sfx("cross", c, 1.0 * U, 0.2)
			for m in _in_ellipse(c, 1.8 * U, 1.2 * U):
				_hit(m, 9.0, "light", _f()))
	_later(1.3, func() -> void:
		_act("z4", 0.3)
		var c := hero.position + Vector2(_f() * 2.0 * U * S, -80.0)
		_sfx("beam", hero.position + Vector2(0.0, -80.0), 70.0, 0.4, "", Vector2(_f() * 4.0 * U * S, 0.0))
		for m in _in_ellipse(c, 2.6 * U, 1.6 * U):
			_hit(m, 60.0, "knock", _f()))

## ประกายไล่ล่าติดตามมอน
func _homing(at: Vector2, vel: Vector2, r: float, dmg: float, life: float, delay := 0.08) -> HomingOrb:
	var cols := _cols("raw_az")
	var b := HomingOrb.new()
	b.style = "spark"
	b.base = cols[0]
	b.accent = cols[1]
	b.position = at
	b.vel = vel
	b.speed = maxf(vel.length(), 650.0)
	b.radius = r * S
	b.dmg = dmg
	b.pierce = false
	b.life = life
	b.delay = delay
	b.extra = {"kb": 0.5, "stun": 0.45}
	page.world.add_child(b)
	return b

# ---------------------------------------------------------------- ชิ้นสกิล
func _tick_obj(o: Dictionary, delta: float) -> void:
	var t: String = o["type"]
	if t in MORE_OBJS:
		o["age"] = float(o["age"]) + delta
		o["life"] = float(o["life"]) - delta
		_tick_more(o, delta, t)
		return
	super._tick_obj(o, delta)

func _tick_more(o: Dictionary, delta: float, t: String) -> void:
	match t:
		"orbit":
			var nodes: Array = o["nodes"]
			o["tick_t"] = float(o["tick_t"]) - delta
			var hit_now := float(o["tick_t"]) <= 0.0
			if hit_now:
				o["tick_t"] = float(o["tick"])
			for i in nodes.size():
				var n: Node2D = nodes[i]
				if not is_instance_valid(n):
					continue
				var a := float(o["age"]) * 4.0 + TAU * float(i) / float(nodes.size())
				n.position = hero.position + Vector2(cos(a) * 1.3 * U * S, -80.0 + sin(a) * 0.8 * U * S)
				n.queue_redraw()
				if hit_now:
					for m in _in_circle(n.position, 0.5 * U):
						_hit(m, float(o["dmg"]), "light", _side_of(m, n.position))
			if float(o["life"]) <= 0.0:
				for n in nodes:
					if is_instance_valid(n):
						n.queue_free()
				_objs.erase(o)
			return
		"wall":
			var at: Vector2 = o["pos"]
			o["tick_t"] = float(o["tick_t"]) - delta
			for m in _mons():
				var d: float = (m.position.x - at.x) * float(o["dir"])
				if d > -40.0 and d < 0.8 * U and m.pos.y < 3.0 and m.role != "boss" and m.role != "boss_raid":
					m.pos.x += float(o["dir"]) * 3.0 * delta
			if float(o["tick_t"]) <= 0.0:
				o["tick_t"] = float(o["tick"])
				for m in _mons():
					if absf(m.position.x - at.x) < 0.9 * U and m.pos.y < 3.0:
						_hit(m, 12.0, "light", float(o["dir"]))
		"lucid":
			var at2: Vector2 = o["pos"]
			var half := float(o["half"])
			for m in _mons():
				if absf(m.position.x - at2.x) < half:
					m.slow_t = maxf(m.slow_t, 0.3)
			if absf(hero.position.x - at2.x) < half:
				buffs["lucid_speed"] = 0.2
	if float(o["life"]) <= 0.0:
		_end(o)

# ---------------------------------------------------------------- พาสซีฟ เกจ แปลงร่าง
func _process(delta: float) -> void:
	super._process(delta)
	if page == null:
		return
	cover_cd = maxf(cover_cd - delta, 0.0)
	_hp_last = hero.hp
	if tf != "":
		tf_t -= delta
		if tf_t <= 0.0 or hero.hp <= 0.0:
			_tf_end()
	# เกจค่อยๆ กลับเข้ากลาง
	psyche = move_toward(psyche, 0.0, 0.02 * delta)

func _apply_passives(delta: float) -> void:
	super._apply_passives(delta)
	var mpb := hero.mp_bonus
	if has("pr_sk_tt_sync"):
		mpb += 100.0
	if has("pr_sk_ps_mind"):
		mpb += 100.0
	if has("pr_sk_ie_will"):
		mpb += 100.0
	hero.mp_bonus = mpb
	hero.hp_bonus = 0.15 if has("pr_sk_hd_bond") else 0.0
	if buffs.has("lucid_speed"):
		hero.speed_bonus = maxf(hero.speed_bonus, 1.3)
	if buffs.has("redirect"):
		hero.melee_guard_t = maxf(hero.melee_guard_t, float(buffs["redirect"]))
		hero.ranged_guard_t = maxf(hero.ranged_guard_t, float(buffs["redirect"]))

func dmg_mult(m: Monster, h: Dictionary) -> float:
	var k := super.dmg_mult(m, h)
	if has("pr_sk_tt_sync") and (_cur_id.begins_with("pr_sk_tt_") or _cur_id.begins_with("pr_sk_hd_")):
		k *= 1.2
	if has("pr_sk_hd_bond"):
		k *= 1.1
	if has("pr_sk_ps_instinct") and psyche >= 0.6:
		k *= 1.15
	if has("pr_sk_ie_flow") and absf(psyche) >= 0.9:
		k *= 1.2
	if tf != "":
		k *= 1.15
	return k

func on_strike(m: Monster, h: Dictionary) -> void:
	super.on_strike(m, h)
	if h.get("pair_echo", false):
		return
	if page.combo_nth >= 0:
		_combo_hits += 1
		# TWIN TEMPO 15.4 ตีคอมโบครบ 4 คู่หูตีตาม
		if has("pr_sk_tt_rhythm") and _combo_hits % 4 == 0:
			_echo(m, 12.0)
		# HARMONY 50.2 เงาสะท้อนตีตาม
		if buffs.has("mirror") and randf() < 0.5:
			_echo(m, 8.0)
	# TWIN TEMPO 30.1 ตีโดนทุกครั้งคู่หูตีสะท้อน
	if buffs.has("echo") and float(h.get("dmg", 0.0)) > 0.0:
		_echo(m, float(h.get("dmg", 0.0)) * 0.5)

func _echo(m: Monster, dmg: float) -> void:
	echo_hits += 1
	var c := _mc(m)
	var n := PairSkillFx.new()
	n.kind = "burst"
	n.base = MORE_COL["sync"][0]
	n.accent = MORE_COL["sync"][1]
	n.size = 44.0
	n.life = 0.25
	n.position = c + Vector2(randf_range(-20.0, 20.0), randf_range(-20.0, 10.0))
	page.world.add_child(n)
	page._strike(m, {"dmg": dmg, "skill": true, "pair_echo": true, "pair_zap": true, "type": "flinch", "stun": 0.2, "kb": 0.2}, _side_of(m, hero.position))

func _on_hurt(kind: String) -> void:
	super._on_hurt(kind)
	# ID EGO / PSYCHE ลดดาเมจ: คืนเลือดส่วนหนึ่งหลังโดน
	var save := 0.0
	if has("pr_sk_ps_mind") and psyche <= -0.6:
		save += 0.15
	if has("pr_sk_ie_will"):
		save += 0.1
	if save > 0.0 and hero.hp > 0.0 and _hp_last > hero.hp:
		hero.hp = minf(hero.hp + (_hp_last - hero.hp) * save, hero.hp_max())
	# PSYCHE 30.2 ตั้งรับอยู่ สะท้อนคลื่น
	if buffs.has("redirect"):
		buffs.erase("redirect")
		var c := hero.position + Vector2(0.0, -60.0)
		_cur_id = "pr_sk_ps_redirect"
		_sfx("ring", hero.position, 2.4 * U, 0.4, "ego")
		for m in _in_circle(c, 2.4 * U):
			_hit(m, 40.0, "knock", _side_of(m, c))
	# HARMONY 35.4 คู่หูโผล่สวน
	if has("pr_sk_hd_cover") and cover_cd <= 0.0 and hero.hp > 0.0:
		cover_cd = COVER_CD
		_cur_id = "pr_sk_hd_cover"
		var at := hero.position + Vector2(_f() * 1.0 * U * S, -60.0)
		_partner_here(1.0, "z4", func(_p: PairSkillFx.PairPartner) -> void:
			_sfx("burst", at, 70.0, 0.3, "sync")
			for m in _in_ellipse(at, 1.4 * U, 1.4 * U):
				_hit(m, 26.0, "knock", _f()), 0.12, 0.7, -_f())

# ---------------------------------------------------------------- โหนดภาพ
## ประกายไล่ล่า เลี้ยวเข้าหามอนที่ใกล้ที่สุด
class HomingOrb extends PairSkillFx.PairOrb:
	var speed := 800.0
	var turn := 7.0
	var delay := 0.08
	func _process(delta: float) -> void:
		if _pop < 0.0 and _t >= delay:
			var best: Monster = null
			var bd := 1600.0
			for e in get_tree().get_nodes_in_group("monsters"):
				var m := e as Monster
				if m == null or m.state == "dead" or _hit.has(m):
					continue
				var d := (m.position + Vector2(0.0, -WalkPage.MONSTER_MID)).distance_to(position)
				if d < bd:
					bd = d
					best = m
			if best != null:
				var want := (best.position + Vector2(0.0, -WalkPage.MONSTER_MID) - position).normalized() * speed
				vel = vel.lerp(want, clampf(turn * delta, 0.0, 1.0))
			else:
				vel = vel.lerp(vel.normalized() * speed, clampf(turn * delta, 0.0, 1.0))
		super._process(delta)

## รัศมีพลังดิบตอนแปลงร่าง วงนุ่มรอบตัว + วงเวลาที่เหลือ
class RawAura extends Node2D:
	var skills: PairSkillsPlus
	var base := Color(0.4, 0.6, 1.0)
	var accent := Color(0.8, 0.95, 1.0)
	var _t := 0.0
	func _ready() -> void:
		z_index = -1
	func _process(delta: float) -> void:
		_t += delta
		if not is_instance_valid(skills) or skills.tf == "":
			queue_free()
			return
		position = skills.hero.position
		queue_redraw()
	func _draw() -> void:
		var k := clampf(skills.tf_t / PairSkillsPlus.TF_TIME, 0.0, 1.0)
		var pulse := 1.0 + 0.05 * sin(_t * 5.0)
		var c := Vector2(0.0, -90.0)
		draw_circle(c, 130.0 * pulse, Color(base, 0.1))
		draw_circle(c, 95.0 * pulse, Color(accent, 0.1))
		for i in 6:
			var a := _t * 1.6 + TAU * float(i) / 6.0
			draw_circle(c + Vector2(cos(a) * 120.0, sin(a) * 60.0), 7.0, Color(accent, 0.55))
		# วงเวลาแปลงร่างที่เหลือ ใต้เท้า
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.3))
		draw_arc(Vector2.ZERO, 110.0, 0.0, TAU, 48, Color(base, 0.25), 6.0, true)
		draw_arc(Vector2.ZERO, 110.0, -PI * 0.5, -PI * 0.5 + TAU * k, 48, Color(accent, 0.85), 6.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## เกจจิต ID (ชมพู) — EGO (ฟ้า) เหนือหัว
class PsycheMeter extends Node2D:
	var skills: PairSkillsPlus
	func _process(_delta: float) -> void:
		if not is_instance_valid(skills) or skills.hero == null:
			queue_free()
			return
		position = skills.hero.position + Vector2(0.0, -250.0)
		queue_redraw()
	func _draw() -> void:
		var w := 120.0
		var h := 12.0
		var id_col: Color = PairSkillsPlus.MORE_COL["psyche"][1]
		var ego_col: Color = PairSkillsPlus.MORE_COL["ego"][1]
		UiStyle.fill(self, Rect2(-w * 0.5 - 3.0, -h * 0.5 - 3.0, w + 6.0, h + 6.0), Color(Sketch.PAPER, 0.85), h)
		UiStyle.fill(self, Rect2(-w * 0.5, -h * 0.5, w * 0.5, h), Color(ego_col, 0.55), h * 0.5)
		UiStyle.fill(self, Rect2(0.0, -h * 0.5, w * 0.5, h), Color(id_col, 0.55), h * 0.5)
		var x := skills.psyche * w * 0.5
		draw_circle(Vector2(x, 0.0), h * 0.8, Color(1.0, 1.0, 1.0, 0.95))
		draw_arc(Vector2(x, 0.0), h * 0.8, 0.0, TAU, 20, Sketch.INK, 2.0, true)
