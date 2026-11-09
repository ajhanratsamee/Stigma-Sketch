class_name CatVulpineHyper
extends HyperStage
## HYPER ของ PHANTOM VULPINE (CAT CITRUS สาย PETIT VIXEN)
## ชี้หอกไปข้างหน้าแล้วพุ่งออกจอหายไป  แมวจิ้งจอกขาว (โมเดลตัวละครเราแต่สีขาว หางอ้วนฟู) ตัวใหญ่โผล่ขึ้นมา
## โน้มตัวไปข้างหน้า ยื่นมือ รวมพลังเป็นก้อนกลมหน้ามือที่ใหญ่ขึ้นเรื่อยๆ แล้วยิงลำแสงยาวราว 2 จอ หลายฮิต
## แล้วจางหายไป CITRUS กลับมาที่เดิม  จอดำ กล้องถอย

const U := CombatData.UNIT
const AIM_FROM := 0.35
const DASH_FROM := 0.8
const DASH_TO := 1.1
const DASH_LEN := 18.0 * 90.0
const FOX_FROM := 1.2
const LEAN_FROM := 1.7
const ORB_FROM := 1.9
const ORB_TO := 3.2
const BEAM_FROM := 3.3
const BEAM_TO := 4.5
const FADE_FROM := 4.6
const RETURN_AT := 5.0
const CLOSE_AT := 5.3
const END_AT := 5.8
const DASH_DMG := 20.0
const BEAM_DMG := 22.0
const BEAM_GAP := 0.12
const BEAM_FINAL := 200.0
const BEAM_LEN := 60.0 * 90.0          # ยาวราว 2 จอที่กล้องถอย
const BEAM_W := 1.5 * 90.0             # ครึ่งความหนาลำแสง
const FOX_SIZE := 4.0                  # ขนาดแมวจิ้งจอก (เทียบตัวละครปกติ)
const CYAN := Color(0.55, 0.92, 1.0)
# สีหลัก CITRUS ส้ม แซมฟ้าอ่อน (ปลายหางจิ้งจอก)
const SOFT := Color(1.0, 0.9, 0.78)
const WHITE := Color(1.0, 1.0, 1.0)
const PINK := Color(1.0, 0.72, 0.85)
const SHAFT := Color(0.55, 0.32, 0.18)
const TIP := Color(0.92, 0.95, 1.0)
const ORANGE := Color(1.0, 0.6, 0.2)

var _start := Vector2.ZERO
var _fox_at := Vector2.ZERO
var _dash_hit: Array = []
var _beam_tick := 0.0
var _beam_final := false
var _hidden := false
var _back := false
var _popped := false
var _sparks: Array = []                # [ตำแหน่ง ความเร็ว อายุ สี]
var _rng := RandomNumberGenerator.new()

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = CLOSE_AT
	end_time = END_AT
	Monster.hide_bars = true
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_rng.seed = 23
	_start = hero.position
	# แมวจิ้งจอกยืนหลังจุดเริ่มเล็กน้อย ยิงไปข้างหน้าผ่านกลุ่มมอน
	_fox_at = Vector2(_start.x - hero.facing * 1.2 * U, 0.0)
	add_actor(_fox_at, FOX_SIZE, ChibiModel.TURN * hero.facing, "cat_spirit_fox")
	actor.sword_on = false
	actor.visible = false
	actor.modulate = Color(1.0, 1.0, 1.0, 0.0)
	add_over()

func _hit_all(h: Dictionary) -> void:
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).take_hit(h, hero.facing)

func _set_model_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

func _lean_k() -> float:
	return clampf((_t - LEAN_FROM) / 0.4, 0.0, 1.0)

## จุดก้อนพลังหน้ามือแมวจิ้งจอก (จุดภาพในโลก)
func _orb_at() -> Vector2:
	var s := FOX_SIZE * ChibiModel.LEGACY_PX * 0.7
	return _fox_at + Vector2(hero.facing * s * (0.75 + 0.25 * _lean_k()), -s * (1.0 - 0.1 * _lean_k()))

func _orb_r() -> float:
	if _t < ORB_FROM:
		return 0.0
	var k := clampf((_t - ORB_FROM) / (ORB_TO - ORB_FROM), 0.0, 1.0)
	var r := 20.0 + 120.0 * k * k
	if _t >= BEAM_FROM:
		r *= 1.0 - clampf((_t - BEAM_TO) / 0.3, 0.0, 1.0)
	return r

func _spark(at: Vector2, count: int, speed: float) -> void:
	for i in count:
		var a := _rng.randf() * TAU
		_sparks.append([at, Vector2(cos(a), sin(a) - 0.4) * _rng.randf_range(speed * 0.3, speed), 0.0, CYAN if _rng.randf() < 0.5 else PINK])
	if _sparks.size() > 50:
		_sparks = _sparks.slice(_sparks.size() - 50)

func _dash_head() -> Vector2:
	var k := clampf((_t - DASH_FROM) / (DASH_TO - DASH_FROM), 0.0, 1.0)
	return _start + Vector2(hero.facing * DASH_LEN * k * k, -70.0)

func _stage_tick(delta: float) -> void:
	hero.vel = Vector2.ZERO
	# 1 ชี้หอกแล้วพุ่งออกจอ ทะลุมอนที่ขวางทางเบาๆ
	if _t >= DASH_FROM and not _hidden:
		_hidden = true
		_set_model_visible(false)
		_spark(_start + Vector2(0.0, -70.0), 8, 600.0)
		_shake = maxf(_shake, 8.0)
	if _t >= DASH_FROM and _t < DASH_TO + 0.05:
		var head_x := _dash_head().x
		for m in caught:
			if is_instance_valid(m) and not m in _dash_hit:
				var mx := (m as Monster).position.x
				if (mx - _start.x) * hero.facing <= (head_x - _start.x) * hero.facing:
					_dash_hit.append(m)
					(m as Monster).take_hit({"type": "none", "dmg": DASH_DMG, "skill": true}, hero.facing)
	# 2 แมวจิ้งจอกขาวโผล่ขึ้นมา (เด้งขยาย) แล้วโน้มตัวไปข้างหน้า ยื่นสองมือ
	if _t >= FOX_FROM and actor != null and _t < FADE_FROM + 0.4:
		actor.visible = true
		if not _popped:
			_popped = true
			_spark(_fox_at + Vector2(0.0, -200.0), 10, 500.0)
		var appear := clampf((_t - FOX_FROM) / 0.35, 0.0, 1.0)
		var fade := 1.0 - clampf((_t - FADE_FROM) / 0.4, 0.0, 1.0)
		actor.modulate = Color(1.0, 1.0, 1.0, appear * fade)
		var pop := 1.0 + 0.18 * sin(appear * PI)
		actor.place_stage(_fox_at, FOX_SIZE * pop)
		var lean := _lean_k()
		actor.rotation = hero.facing * deg_to_rad(9.0) * lean
		actor.stage_hand = Vector3(0.42, 0.68, 0.3).lerp(Vector3(0.22, 0.85, 0.75), lean)
		actor.stage_off = Vector3(-0.42, 0.68, 0.02).lerp(Vector3(-0.22, 0.85, 0.75), lean)
	# 3 รวมพลัง ประกายไหลเข้าก้อน
	if _t >= ORB_FROM and _t < BEAM_FROM:
		_shake = maxf(_shake, 2.0 + 5.0 * clampf((_t - ORB_FROM) / (ORB_TO - ORB_FROM), 0.0, 1.0))
		if _rng.randf() < 0.35:
			var a := _rng.randf() * TAU
			_sparks.append([_orb_at() + Vector2(cos(a), sin(a)) * 260.0, -Vector2(cos(a), sin(a)) * 420.0, 0.0, SOFT])
	# 4 ลำแสงยักษ์ หลายฮิต
	if _t >= BEAM_FROM and _t < BEAM_TO:
		_beam_tick -= delta
		if _beam_tick <= 0.0:
			_beam_tick = BEAM_GAP
			_hit_all({"type": "none", "dmg": BEAM_DMG, "skill": true})
		_shake = maxf(_shake, 12.0)
	if not _beam_final and _t >= BEAM_TO:
		_beam_final = true
		_hit_all({"type": "none", "dmg": BEAM_FINAL, "skill": true, "armor_break": true})
		_shake = 20.0
	# 5 แมวจิ้งจอกจางหาย CITRUS กลับมาที่เดิม
	if _t >= FADE_FROM + 0.4 and actor != null:
		actor.visible = false
	if _hidden and not _back and _t >= RETURN_AT:
		_back = true
		_set_model_visible(true)
		_spark(_start + Vector2(0.0, -70.0), 8, 500.0)
	for s in _sparks:
		s[2] = float(s[2]) + delta
		s[1] = (s[1] as Vector2) * 0.94 + Vector2(0.0, -120.0) * delta
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
	_sparks = _sparks.filter(func(s: Array) -> bool: return float(s[2]) < 0.8)

func _finish() -> void:
	Monster.hide_bars = false
	_set_model_visible(true)
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).frozen = false
			(m as Monster).take_hit({"type": "knockdown", "fly": 8.0, "dmg": 0.0, "skill": true}, hero.facing)
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
		hero.plain_model.hide_blade = false
	super._exit_tree()

# ---------------------------------------------------------------- วาด (ชั้นหลังตัวแมวจิ้งจอก)
func _spear(from: Vector2, ang: float, length: float, a: float) -> void:
	var u := Vector2(cos(ang), sin(ang))
	var tip := from + u * length * 0.62
	var butt := from - u * length * 0.38
	draw_line(butt, tip, Color(CYAN, 0.25 * a), 20.0, true)
	draw_line(butt, tip, Color(SHAFT, a), 7.0, true)
	var n := u.orthogonal()
	draw_colored_polygon(PackedVector2Array([tip + u * 48.0, tip + n * 14.0, tip - u * 6.0, tip - n * 14.0]), Color(TIP, a))
	draw_circle(butt, 6.0, Color(ORANGE, a))

func _paw(c: Vector2, r: float, col: Color, a: float) -> void:
	draw_circle(c, r, Color(col, a))
	for t in 3:
		draw_circle(c + Vector2((float(t) - 1.0) * r * 0.9, -r * (1.05 + (0.15 if t == 1 else 0.0))), r * 0.42, Color(col, a))

func _draw() -> void:
	var f := hero.facing
	# ชี้หอก แล้วเส้นพุ่งออกจอ
	if _t >= AIM_FROM and _t < DASH_FROM:
		var k := clampf((_t - AIM_FROM) / 0.3, 0.0, 1.0)
		_spear(_start + Vector2(f * 40.0, -80.0), 0.0 if f > 0.0 else PI, 150.0, k)
		draw_circle(_start + Vector2(f * 140.0, -80.0), 10.0 + 14.0 * k, Color(SOFT, 0.7 * k))
	if _t >= DASH_FROM and _t < DASH_TO + 0.25:
		var a := 1.0 - clampf((_t - DASH_TO) / 0.25, 0.0, 1.0)
		var head := _dash_head()
		draw_line(_start + Vector2(0.0, -70.0), head, Color(ORANGE, 0.35 * a), 46.0, true)
		draw_line(_start + Vector2(0.0, -70.0), head, Color(WHITE, a), 10.0, true)
		if _t < DASH_TO:
			_spear(head, 0.0 if f > 0.0 else PI, 150.0, a)
	# แสงนุ่มกับวงรอยเท้าใต้แมวจิ้งจอก
	if _t >= FOX_FROM and _t < FADE_FROM + 0.4:
		var a2 := clampf((_t - FOX_FROM) / 0.35, 0.0, 1.0) * (1.0 - clampf((_t - FADE_FROM) / 0.4, 0.0, 1.0))
		draw_circle(_fox_at + Vector2(0.0, -260.0), 420.0, Color(SOFT, 0.1 * a2))
		var ring := PackedVector2Array()
		for i in 41:
			var ang := TAU * float(i) / 40.0
			ring.append(_fox_at + Vector2(cos(ang) * 340.0, sin(ang) * 60.0))
		draw_polyline(ring, Color(ORANGE, 0.55 * a2), 6.0, true)
		for i in 6:
			var ang := _t * 1.2 + TAU * float(i) / 6.0
			_paw(_fox_at + Vector2(cos(ang) * 340.0, sin(ang) * 60.0), 16.0, PINK, 0.8 * a2)

# ---------------------------------------------------------------- วาด (ชั้นหน้า ก้อนพลัง ลำแสง ประกาย)
func _draw_over() -> void:
	var f := hero.facing
	# ลำแสง ยาวราว 2 จอ ขอบนุ่ม แกนขาว มีดาวกับรอยเท้าไหลไปตามลำ
	if _t >= BEAM_FROM and _t < BEAM_TO + 0.35:
		var a := 1.0 - clampf((_t - BEAM_TO) / 0.35, 0.0, 1.0)
		var grow := clampf((_t - BEAM_FROM) / 0.15, 0.0, 1.0)
		var o := _orb_at()
		var end := o + Vector2(f * BEAM_LEN * grow, 0.0)
		var w := BEAM_W * (0.9 + 0.1 * sin(_t * 30.0))
		over.draw_line(o, end, Color(ORANGE, 0.3 * a), w * 2.6, true)
		over.draw_line(o, end, Color(SOFT, 0.75 * a), w * 1.5, true)
		over.draw_line(o, end, Color(WHITE, a), w * 0.6, true)
		for i in 10:
			var k := fmod(_t * 1.6 + float(i) * 0.1, 1.0)
			var p := o + Vector2(f * BEAM_LEN * 0.5 * k * grow, sin(float(i) * 2.3) * w * 0.7)
			if i % 2 == 0:
				_over_star(p, 26.0, PINK, a * (1.0 - k))
			else:
				_over_paw(p, 16.0, WHITE, a * (1.0 - k))
	# ก้อนพลังหน้ามือ ใหญ่ขึ้นเรื่อยๆ
	var r := _orb_r()
	if r > 1.0 and _t < BEAM_TO + 0.3:
		var o2 := _orb_at()
		over.draw_circle(o2, r * 1.8, Color(ORANGE, 0.18))
		over.draw_circle(o2, r * 1.25, Color(SOFT, 0.5))
		over.draw_circle(o2, r, Color(WHITE, 0.95))
		_over_paw(o2 + Vector2(0.0, r * 0.15), r * 0.32, PINK, 0.9)
	# ประกาย
	for s in _sparks:
		var sa := 1.0 - float(s[2]) / 0.8
		_over_star(s[0], 10.0 * sa + 3.0, s[3], sa)

func _over_star(c: Vector2, r: float, col: Color, a: float) -> void:
	# ประกายกลมนุ่ม ไม่มีแฉก
	if a <= 0.0 or r < 1.0:
		return
	over.draw_circle(c, r * 0.75, Color(col, a * 0.3))
	over.draw_circle(c, r * 0.42, Color(col, a))

func _over_paw(c: Vector2, r: float, col: Color, a: float) -> void:
	if a <= 0.0:
		return
	over.draw_circle(c, r, Color(col, a))
	for t in 3:
		over.draw_circle(c + Vector2((float(t) - 1.0) * r * 0.9, -r * (1.05 + (0.15 if t == 1 else 0.0))), r * 0.42, Color(col, a))
