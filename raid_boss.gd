class_name RaidBoss
extends Monster
## บอสยักษ์แบบรุม (เมืองโหดๆ) ตัวใหญ่หลายเท่า ยืนนิ่งชิดขวาหรือกลางลาน ให้ตัวละครรุมตี
## หลายเฟสตามเลือด แต่ละเฟสเปลี่ยนสี ท่า และความเร็ว เปลี่ยนเฟสคำรามอมตะครู่หนึ่ง
## ท่า: ทุบพื้นเป็นคลื่น (กระโดดข้าม)  ของตกจากฟ้า (ดูวงเตือน)  กวาดแขนเลียดพื้น (กระโดดหลบ)
##      เรียกลูกน้อง  ก้มหัวโชว์จุดอ่อน (ดาเมจ x2)
## จุดที่ตีโดนคือหน้าตัวด้านที่หันเข้าหาตัวละคร (pos) ส่วนภาพตัวยักษ์อยู่ที่ anchor_x

const UNIT := CombatData.UNIT
const INTRO := 1.4
const ROAR := 1.6
const WEAK_TIME := 3.6
const WEAK_MULT := 2.0
const DROP_WARN := 1.05
const DROP_FALL := 0.28
const DROP_R := 1.3
const MAX_MINIONS := 4
const TINTS := [Color(1.0, 1.0, 1.0), Color(1.0, 0.86, 0.8), Color(0.96, 0.78, 0.9), Color(0.86, 0.8, 1.0)]
const WARN := Color(1.0, 0.42, 0.45)

var page: Node                    # DungeonPage
var anchor := "right"             # right ชิดขวา  center กลางลาน (เดินลอดได้)
var anchor_x := 16.0              # กลางตัวยักษ์ หน่วยเกม
var body_half := 3.5              # ครึ่งความกว้างตัว หน่วยเกม
var giant := 3.6                  # ตัวใหญ่กี่เท่า
var phases := 2
var dmg_k := 1.0
var speed_k := 1.0
var town := 4

var phase_i := 0
var mode := "intro"               # intro idle tele act weak roar
var mode_t := 0.0
var cur := ""                     # ท่าที่กำลังทำ
var _attacks := 0                 # นับท่า ครบแล้วก้มโชว์จุดอ่อน
var _drops: Array = []            # [x หน่วยเกม, เวลา, โดนแล้ว]
var _sweep_t := 0.0
var _slam_t := 0.0
var _gone := 0.0
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	model_view = 512
	super._ready()
	_rng.randomize()
	if _model != null:
		_model.scale = Vector2.ONE * giant
		_model.face = -1.0
	_place_body()

## เส้นแบ่งเฟส เลือดเหลือเท่าไหร่ถึงเข้าเฟสถัดไป
func thresholds() -> Array:
	var out := []
	for i in range(1, phases):
		out.append(1.0 - float(i) / float(phases))
	return out

func on_floor() -> bool:
	# ตัวกลางลานเดินลอดใต้ได้ ไม่ผลักตัวละคร
	return anchor == "right"

func is_invulnerable() -> bool:
	return state == "dead" or mode == "intro" or mode == "roar"

func face_x() -> float:
	if anchor == "center" and is_instance_valid(hero):
		return anchor_x + (body_half if hero.pos.x > anchor_x else -body_half)
	return anchor_x - body_half

func _place_body() -> void:
	pos = Vector2(face_x(), 0.0)
	_place()
	if _model != null:
		var weak_k := clampf(mode_t / 0.4, 0.0, 1.0) if mode == "weak" else 0.0
		_model.position = Vector2((anchor_x - pos.x) * UNIT, 30.0 * weak_k * giant)
		_model.rotation = deg_to_rad(-12.0 * weak_k * (1.0 if anchor == "right" else signf(hero.pos.x - anchor_x) if is_instance_valid(hero) else 1.0))
		if anchor == "center" and is_instance_valid(hero):
			_model.face = signf(hero.pos.x - anchor_x) if hero.pos.x != anchor_x else -1.0
		_model.tele = clampf(mode_t / 0.6, 0.0, 1.0) if mode == "tele" else 0.0
		_model.strike = maxf(1.0 - mode_t / 0.35, 0.0) if mode == "act" else 0.0

func take_hit(h: Dictionary, dir: float) -> bool:
	if is_invulnerable():
		return false
	var dmg := _scaled_damage(h) * (WEAK_MULT if mode == "weak" else 1.0)
	hp -= dmg
	_hurt_t = 0.2
	_numbers.append({"text": str(int(dmg)) + ("!" if mode == "weak" else ""), "t": 0.0, "x": randf_range(-30.0, 30.0)})
	if _model != null:
		_model.flash = 0.6
	_flinch_dir = dir if dir != 0.0 else 1.0
	# ข้ามเส้นแบ่งเฟส คำรามเปลี่ยนเฟส
	var th := thresholds()
	if hp > 0.0 and phase_i < th.size() and hp / max_hp <= float(th[phase_i]):
		phase_i += 1
		_start_roar()
	_check_death()
	if state == "dead":
		_on_raid_dead()
	return true

func _start_roar() -> void:
	mode = "roar"
	mode_t = 0.0
	_drops.clear()
	if _model != null:
		_model.set_tint(TINTS[mini(phase_i, TINTS.size() - 1)])
	if page != null:
		page.set("_flash", "เฟส %d!" % (phase_i + 1))
		page.set("_flash_t", 1.6)
		# คำรามเขย่าจอ (ยอมให้สั่นแม้ไม่ได้ตีโดน)
		page.set("_hit_clock", Time.get_ticks_msec() + int(ROAR * 1000.0))
		page.set("shake_left", maxf(float(page.get("shake_left")), 0.7))

func _on_raid_dead() -> void:
	# บอสตาย ลูกน้องที่เหลือสลายตามไปด้วย
	for e in get_tree().get_nodes_in_group("monsters"):
		var m := e as Monster
		if m != null and m != self and m.state != "dead":
			m.hp = 0.0
			m._check_death()

func _physics_process(delta: float) -> void:
	_clock += delta
	_hurt_t = maxf(_hurt_t - delta, 0.0)
	for n in _numbers:
		n["t"] = float(n["t"]) + delta
	_numbers = _numbers.filter(func(n): return float(n["t"]) < NUMBER_LIFE * 1.5)
	if _model != null:
		_model.flash = maxf(_model.flash - delta * 3.0, 0.0)
	if state == "dead":
		_gone += delta
		if _model != null:
			_model.modulate.a = maxf(1.0 - _gone / 1.4, 0.0)
			_model.position.y += 120.0 * delta
		queue_redraw()
		if _gone > 1.6:
			queue_free()
		return
	mode_t += delta * (speed_k if mode in ["idle", "tele"] else 1.0)
	_tick_drops(delta)
	_sweep_t = maxf(_sweep_t - delta, 0.0)
	_slam_t = maxf(_slam_t - delta, 0.0)
	match mode:
		"intro":
			if mode_t >= INTRO:
				_to("idle")
		"roar":
			if mode_t >= ROAR:
				_to("idle")
		"idle":
			if mode_t >= maxf(1.6 - 0.25 * float(phase_i), 0.7):
				_pick_attack()
		"tele":
			if mode_t >= _tele_time():
				_do_attack()
				_to("act")
		"act":
			if mode_t >= 0.5:
				_attacks += 1
				# เฟส 2 ขึ้นไป ทุก 3 ท่าก้มหัวโชว์จุดอ่อน
				if phase_i >= 1 and _attacks % 3 == 0:
					_to("weak")
				else:
					_to("idle")
		"weak":
			if mode_t >= WEAK_TIME:
				_to("idle")
	_place_body()
	queue_redraw()

func _to(m: String) -> void:
	mode = m
	mode_t = 0.0

func _tele_time() -> float:
	return maxf(1.15 - 0.12 * float(phase_i), 0.65)

func _pattern_set() -> Array:
	var set := ["slam", "rain"]
	if phase_i >= 1:
		set.append_array(["sweep", "summon"])
	if phase_i >= 2:
		set.append_array(["rain", "slam", "sweep"])
	return set

func _pick_attack() -> void:
	var set := _pattern_set()
	var pick: String = set[_rng.randi() % set.size()]
	if pick == "summon" and _minion_count() >= MAX_MINIONS:
		pick = "slam"
	cur = pick
	_to("tele")
	if pick == "rain":
		# ของตกพร้อมวงเตือนบนพื้นตั้งแต่ตอนง้าง
		var n := 4 + phase_i * 2 + (town - 4)
		var lo := -18.0
		var hi := face_x() - 1.0 if anchor == "right" else 18.0
		for i in n:
			var x := lerpf(lo, hi, (float(i) + _rng.randf_range(0.1, 0.9)) / float(n))
			_drops.append([x, -_rng.randf_range(0.0, 0.5), false])
		# ตกใส่ตำแหน่งตัวละครด้วยหนึ่งลูก
		if is_instance_valid(hero):
			_drops.append([hero.pos.x, -0.2, false])

func _minion_count() -> int:
	var c := 0
	for e in get_tree().get_nodes_in_group("monsters"):
		if e != self:
			c += 1
	return c

func _hurt(dmg: float, from_x: float) -> void:
	if is_instance_valid(hero):
		hero.take_damage(dmg * dmg_k, signf(hero.pos.x - from_x) if hero.pos.x != from_x else -1.0)

func _do_attack() -> void:
	var fx := face_x()
	var side := -1.0 if anchor == "right" else (signf(hero.pos.x - anchor_x) if is_instance_valid(hero) and hero.pos.x != anchor_x else -1.0)
	match cur:
		"slam":
			_slam_t = 0.5
			# ทุบพื้นด้านหน้า โดนตรงๆ ถ้ายืนในวง แล้วคลื่นวิ่งตามพื้น กระโดดข้าม
			if is_instance_valid(hero) and hero.pos.y < 0.6 and (hero.pos.x - fx) * side >= -0.5 and (hero.pos.x - fx) * side <= 6.0:
				_hurt(20.0, fx)
			if page != null and page.has_method("_raid_wave"):
				page.call("_raid_wave", self, fx + side * 1.0, side, 14.0 * dmg_k)
			_shake(0.45)
		"sweep":
			_sweep_t = 0.45
			# แขนกวาดเลียดพื้นทั้งฝั่ง ต้องกระโดดหลบ
			if is_instance_valid(hero) and hero.pos.y < 1.1 and (hero.pos.x - fx) * side >= -0.5:
				_hurt(18.0, fx)
			_shake(0.3)
		"summon":
			if page != null and page.has_method("_raid_summon"):
				page.call("_raid_summon", self, 2 + mini(phase_i, 2))
		"rain":
			pass

func _shake(t: float) -> void:
	if page != null:
		page.set("_hit_clock", Time.get_ticks_msec())
		page.set("shake_left", maxf(float(page.get("shake_left")), t))

func _tick_drops(delta: float) -> void:
	for d in _drops:
		d[1] = float(d[1]) + delta
		var t := float(d[1])
		if not bool(d[2]) and t >= DROP_WARN + DROP_FALL:
			d[2] = true
			if is_instance_valid(hero) and absf(hero.pos.x - float(d[0])) < DROP_R and hero.pos.y < 1.6:
				_hurt(12.0, float(d[0]))
	_drops = _drops.filter(func(d: Array) -> bool: return float(d[1]) < DROP_WARN + DROP_FALL + 0.45)

# ---------------------------------------------------------------- ภาพ (พิกัดเทียบตำแหน่งหน้าตัว)
func _lx(x_units: float) -> float:
	return (x_units - pos.x) * UNIT

func _draw() -> void:
	if state == "dead":
		return
	var fx := face_x()
	var side := -1.0 if anchor == "right" else (signf(hero.pos.x - anchor_x) if is_instance_valid(hero) and hero.pos.x != anchor_x else -1.0)
	# วงเตือนท่าทุบ/กวาด กลมมนบนพื้น กะพริบเร็วขึ้นตอนใกล้ลง
	if mode == "tele":
		var k := clampf(mode_t / _tele_time(), 0.0, 1.0)
		var pulse := 0.5 + 0.5 * sin(_clock * (8.0 + 20.0 * k))
		var col := Color(WARN, 0.18 + 0.25 * pulse)
		match cur:
			"slam":
				var a := _lx(fx)
				var b := _lx(fx + side * 6.0)
				UiStyle.fill(self, Rect2(minf(a, b), -26.0, absf(b - a), 30.0), col, 15.0)
			"sweep":
				var a2 := _lx(fx)
				var b2 := _lx(fx + side * 40.0)
				UiStyle.fill(self, Rect2(minf(a2, b2), -70.0, absf(b2 - a2), 74.0), Color(WARN, 0.12 + 0.18 * pulse), 30.0)
				_text_mid(Vector2(_lx(fx + side * 6.0), -110.0), "กระโดด!", Color(0.8, 0.2, 0.25, 0.6 + 0.4 * pulse))
			"summon":
				draw_circle(Vector2(_lx(anchor_x), -giant * 70.0), 40.0 + 30.0 * k, Color(1.0, 0.85, 0.5, 0.35 * pulse))
	# แขนกวาด แคปซูลกลมใหญ่เลียดพื้น
	if _sweep_t > 0.0:
		var k2 := 1.0 - _sweep_t / 0.45
		var reach := lerpf(0.0, 40.0, k2)
		var a3 := _lx(fx)
		var b3 := _lx(fx + side * reach)
		UiStyle.fill(self, Rect2(minf(a3, b3), -60.0, absf(b3 - a3) + 1.0, 56.0), Color(0.7, 0.68, 0.74, 0.85), 28.0)
		UiStyle.fill(self, Rect2(minf(a3, b3), -52.0, absf(b3 - a3) + 1.0, 14.0), Color(1.0, 1.0, 1.0, 0.35), 7.0)
	# วงกระแทกตอนทุบ
	if _slam_t > 0.0:
		var k3 := 1.0 - _slam_t / 0.5
		draw_arc(Vector2(_lx(fx + side * 2.5), 0.0), 60.0 + 260.0 * k3, PI, TAU, 32, Color(0.95, 0.9, 0.85, 1.0 - k3), 10.0 * (1.0 - k3) + 2.0, true)
	# ของตกจากฟ้า: วงเตือนบนพื้น แล้วลูกกลมตกลงมา
	for d in _drops:
		var t := float(d[1])
		if t < 0.0:
			continue
		var x := _lx(float(d[0]))
		if t < DROP_WARN + DROP_FALL:
			var kw := clampf(t / DROP_WARN, 0.0, 1.0)
			draw_set_transform(Vector2(x, 0.0), 0.0, Vector2(1.0, 0.3))
			draw_circle(Vector2.ZERO, DROP_R * UNIT * (0.4 + 0.6 * kw), Color(WARN, 0.18 + 0.2 * kw))
			draw_arc(Vector2.ZERO, DROP_R * UNIT, 0.0, TAU, 32, Color(WARN, 0.6), 4.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if t >= DROP_WARN - 0.3:
			var kf := clampf((t - (DROP_WARN - 0.3)) / (DROP_FALL + 0.3), 0.0, 1.0)
			if kf < 1.0:
				var y := lerpf(-1400.0, -40.0, kf * kf)
				draw_circle(Vector2(x, y), 46.0, _drop_color())
				draw_circle(Vector2(x - 14.0, y - 14.0), 14.0, Color(1.0, 1.0, 1.0, 0.5))
			else:
				var kp := (t - DROP_WARN - DROP_FALL) / 0.45
				draw_arc(Vector2(x, 0.0), 40.0 + 90.0 * kp, PI, TAU, 24, Color(_drop_color(), 1.0 - kp), 8.0, true)
	# จุดอ่อน: วงเรืองกลมที่หัว ตอนก้มหัว
	if mode == "weak":
		var c := Vector2(_lx(anchor_x), -giant * 62.0)
		var pz := 0.5 + 0.5 * sin(_clock * 9.0)
		draw_circle(c, 44.0 + 10.0 * pz, Color(1.0, 0.95, 0.55, 0.45))
		draw_circle(c, 22.0, Color(1.0, 1.0, 0.85, 0.85))
		_text_mid(c + Vector2(0.0, -70.0), "จุดอ่อน! x2", Color(0.85, 0.5, 0.1))
	# ตัวเลขดาเมจเหนือหน้าตัว
	_draw_numbers(-giant * 90.0)

func _drop_color() -> Color:
	var cols := [Color(0.95, 0.75, 0.55), Color(0.7, 0.85, 0.95), Color(0.95, 0.85, 0.5), Color(0.8, 0.95, 1.0), Color(0.95, 0.5, 0.35), Color(0.7, 0.6, 0.9), Color(1.0, 0.9, 0.5)]
	return cols[clampi(town - 2, 0, cols.size() - 1)]

func _text_mid(at: Vector2, word: String, col: Color) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30).x
	draw_string_outline(font, at + Vector2(-w * 0.5, 10.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, 6, Color.WHITE)
	draw_string(font, at + Vector2(-w * 0.5, 10.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, col)
