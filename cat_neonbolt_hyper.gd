class_name CatNeonBoltHyper
extends HyperStage
## HYPER ของ NEON BOLT (CAT AZURE / CAT LAPIS สาย SPARK FIEND)
## ทั้งคู่แปลงร่างปีศาจ  AZURE (เขาย้อยหน้า ปีกที่ก้นกบ) ลอยขึ้นนิดหนึ่ง ยื่นมือเปิดประตูยักษ์ด้านข้างจอ (เห็นประตูด้านข้าง สูงเกือบเต็มจอ)
## LAPIS ยืนด้านหลังประตู ปักดาบปลายปืนลงดินแล้วเกาะไว้แน่น ตัวเอนสู้ลมที่พัดออกจากประตูจนแทบปลิว
## ศรปีศาจหลายขนาดพุ่งออกจากประตูไปข้างหน้าเรื่อยๆ  AZURE ทำท่าเขวี้ยง ศรยักษ์มากๆ พุ่งออกจากประตูทำดาเมจแรง  ประตูปิด กลับร่างเดิม

const SIZE := 1.29               # ขนาดเท่าตัวละครปกติ
const FORM_AT := 0.35
const RISE_FROM := 0.65
const RISE_TO := 1.1
const GATE_FROM := 1.05
const GATE_TO := 1.7
const LAPIS_AT := 1.6
const FIRE_FROM := 1.85
const FIRE_TO := 4.2
const ARROW_GAP := 0.055
const TICK := 0.16
const TICK_DMG := 9.0
const PLANT_TIME := 0.3          # LAPIS ยกดาบแล้วปักลงดิน
const WIND_FROM := 4.45
const THROW_AT := 4.85
const BIG_SPEED := 4200.0
const BIG_DMG := 230.0
const CLOSE_FROM := 5.6
const CLOSE_TO := 6.05
const FADE_FROM := 5.95
const CLOSE_AT := 6.15
const END_AT := 6.75
const ARROW_SPEED := 2600.0
# สีหลัก AZURE ฟ้าอ่อน แซมน้ำเงินเข้ม
const BLUE := Color(0.55, 0.78, 1.0)
const DEEP := Color(0.12, 0.2, 0.55)
const WHITE := Color(1.0, 1.0, 1.0)
const PINK := Color(1.0, 0.72, 0.82)

var _azure: ChibiModel
var _dir := 1.0
var _half := Vector2.ZERO
var _mid_y := 0.0
var _gate_x := 0.0
var _gate_cy := 0.0
var _gate_h := 0.0                     # ครึ่งความสูงประตู
var _lapis_x := 0.0
var _azure_x := 0.0
var _arrows: Array = []                # [x หัว, y, ยาว, หนา, เวลาเกิด]
var _arrow_t := 0.0
var _tick_t := 0.0
var _big_x := 0.0
var _big_fired := false
var _big_hit: Array = []
var _hidden := false
var _back := false
var _rng := RandomNumberGenerator.new()

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = CLOSE_AT
	end_time = END_AT
	Monster.hide_bars = true
	_rng.seed = 77
	_dir = hero.facing if hero.facing != 0.0 else 1.0
	_half = screen_half_world()
	_mid_y = screen_center_world().y
	# ประตูอยู่ด้านข้างจอ ฝั่งหลังตัวละคร หันหน้าไปทางที่ตัวละครหัน
	_gate_x = -_dir * _half.x * 0.45
	var top := _mid_y - _half.y
	_gate_h = absf(top) * 0.45
	_gate_cy = -_gate_h - 10.0
	_azure_x = _gate_x - _dir * 210.0
	# LAPIS อยู่หลังประตู ถัดจาก AZURE ไปอีก
	_lapis_x = _gate_x - _dir * 470.0
	add_actor(Vector2(_lapis_x, 0.0), SIZE, ChibiModel.TURN * _dir, "cat_lapis_demon")
	actor.process_priority = -10
	actor.visible = false
	_azure = ChibiModel.new()
	_azure.hero = hero
	_azure.style = "cat_azure_demon_b"
	_azure.stage_mode = true
	_azure.stage_turn = ChibiModel.TURN * _dir
	_azure.view_size = 1024
	_azure.process_priority = -10
	add_child(_azure)
	_azure.place_stage(Vector2(_azure_x, 0.0), SIZE)
	_azure.visible = false
	add_over()

func _set_hero_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

func _place(m: ChibiModel, at: Vector2, lean := 0.0) -> void:
	m.stage_turn = ChibiModel.TURN * _dir
	m.place_stage(at, SIZE)
	m.rotation = deg_to_rad(lean) * _dir

## มอนด้านหน้าประตู
func _front(m: Monster) -> bool:
	return (m.position.x - _gate_x) * _dir > 0.0

func _gate_open() -> float:
	if _t < GATE_FROM:
		return 0.0
	if _t < CLOSE_FROM:
		return _ease(clampf((_t - GATE_FROM) / (GATE_TO - GATE_FROM), 0.0, 1.0))
	return 1.0 - _ease(clampf((_t - CLOSE_FROM) / (CLOSE_TO - CLOSE_FROM), 0.0, 1.0))

func _stage_tick(delta: float) -> void:
	hero.vel = Vector2.ZERO
	# แปลงร่าง ตัวเดิมหายไป AZURE โผล่เป็นร่างปีศาจ
	if not _hidden and _t >= FORM_AT:
		_hidden = true
		_set_hero_visible(false)
		_azure.visible = true
		_shake = maxf(_shake, 8.0)
	_tick_azure()
	_tick_lapis()
	# ศรปีศาจหลายขนาดพุ่งออกจากประตู ตามความสูงประตู
	if _t >= FIRE_FROM and _t < FIRE_TO:
		_arrow_t -= delta
		while _arrow_t <= 0.0:
			_arrow_t += ARROW_GAP
			var y := _gate_cy + _rng.randf_range(-_gate_h * 0.85, _gate_h * 0.85)
			var big := _rng.randf() < 0.25
			var length := _rng.randf_range(300.0, 560.0) if big else _rng.randf_range(120.0, 280.0)
			var thick := _rng.randf_range(18.0, 28.0) if big else _rng.randf_range(8.0, 15.0)
			_arrows.append([_gate_x, y, length, thick, _t])
		_tick_t -= delta
		if _tick_t <= 0.0:
			_tick_t = TICK
			for m in caught:
				if is_instance_valid(m) and _front(m):
					(m as Monster).take_hit({"type": "none", "dmg": TICK_DMG, "skill": true}, _dir)
			_shake = maxf(_shake, 3.0)
	for a in _arrows:
		a[0] = float(a[0]) + _dir * ARROW_SPEED * delta
	var lim := _half.x + 900.0
	_arrows = _arrows.filter(func(a: Array) -> bool: return absf(float(a[0])) < lim)
	# ศรยักษ์พุ่งออกจากประตู ดาเมจแรง
	if not _big_fired and _t >= THROW_AT:
		_big_fired = true
		_big_x = _gate_x
		_shake = 24.0
	if _big_fired:
		_big_x += _dir * BIG_SPEED * delta
		for m in caught:
			if is_instance_valid(m) and _front(m) and not (m in _big_hit) and ((m as Monster).position.x - _big_x) * _dir <= 0.0:
				_big_hit.append(m)
				(m as Monster).take_hit({"type": "none", "dmg": BIG_DMG, "skill": true, "armor_break": true}, _dir)
				_shake = maxf(_shake, 14.0)
	# ประตูปิดแล้ว AZURE หาย ตัวผู้เล่นกลับมาที่เดิม
	if _t >= FADE_FROM and not _back:
		_back = true
		_azure.visible = false
		actor.visible = false
		_set_hero_visible(true)
		_shake = maxf(_shake, 5.0)

## AZURE ลอยขึ้นนิดหนึ่ง ยื่นมือไปข้างหน้าเปิดประตู แล้วทำท่าเขวี้ยง
func _tick_azure() -> void:
	if not _azure.visible:
		return
	var rise := _ease(clampf((_t - RISE_FROM) / (RISE_TO - RISE_FROM), 0.0, 1.0)) if _t >= RISE_FROM else 0.0
	var bob := sin(_t * 3.0) * 6.0 * rise
	var lean := 0.0
	if _t < RISE_FROM:
		_azure.stage_hand = Vector3(0.42, 0.68, 0.3)
		_azure.stage_off = Vector3(-0.42, 0.68, 0.02)
	elif _t < WIND_FROM:
		# ยื่นมือไปข้างหน้า (ไปทางประตู) เปิดประตู
		_azure.stage_hand = Vector3(0.28, 0.85, 0.85)
		_azure.stage_off = Vector3(-0.2, 0.8, 0.75)
		lean = 6.0
	elif _t < THROW_AT:
		# ง้างมือไปด้านหลังเตรียมเขวี้ยง
		var wk := clampf((_t - WIND_FROM) / (THROW_AT - WIND_FROM), 0.0, 1.0)
		_azure.stage_hand = Vector3(0.45, 0.85 + 0.35 * wk, 0.6 - 1.1 * wk)
		_azure.stage_off = Vector3(-0.35, 0.75, 0.45)
		lean = -14.0 * wk
	else:
		# เขวี้ยงไปข้างหน้า
		var tk := clampf((_t - THROW_AT) / 0.7, 0.0, 1.0)
		_azure.stage_hand = Vector3(0.3, 0.75, 0.95)
		_azure.stage_off = Vector3(-0.4, 0.6, -0.25)
		lean = 18.0 * (1.0 - tk)
	_azure.floating = rise > 0.0
	_place(_azure, Vector2(_azure_x, -90.0 * rise + bob), lean)

## ลมจากประตูแรงแค่ไหน (0-1) แรงสุดตอนศรรัวและตอนศรยักษ์
func _wind() -> float:
	var g := _gate_open()
	var w := 0.35 * g
	if _t >= FIRE_FROM and _t < FIRE_TO:
		w = 0.8
	if _t >= THROW_AT and _t < THROW_AT + 0.8:
		w = 1.0
	return w * g

## LAPIS โผล่หลังประตู ปักดาบปลายปืนลงดิน เกาะไว้ ตัวเอนไปหน้าสู้ลม สั่นเหมือนจะปลิว
func _tick_lapis() -> void:
	if _t < LAPIS_AT or _back:
		return
	actor.visible = true
	var pk := clampf((_t - LAPIS_AT) / PLANT_TIME, 0.0, 1.0)
	if pk < 1.0:
		# ยกดาบขึ้นแล้วกดปักลง
		actor.stage_hand = Vector3(0.3, 1.1 - 0.22 * pk, 0.55 + 0.25 * pk)
		actor.stage_off = Vector3(0.05, 1.05 - 0.21 * pk, 0.5 + 0.26 * pk)
		actor.stage_sw = lerpf(-30.0, -160.0, pk)
		_place(actor, Vector2(_lapis_x, 0.0), 4.0 * pk)
		return
	var w := _wind()
	var shake := sin(_t * 41.0) * 0.6 + sin(_t * 67.0) * 0.4
	# สองมือเกาะด้ามดาบที่ปักอยู่ด้านหน้า ตัวเอนหน้า ยิ่งลมแรงยิ่งเอนและสั่น โดนดันถอยนิดๆ
	actor.stage_hand = Vector3(0.3, 0.88 + shake * 0.02 * w, 0.8)
	actor.stage_off = Vector3(0.08, 0.84, 0.76)
	actor.stage_sw = -160.0
	var push := -_dir * (14.0 * w + absf(shake) * 6.0 * w)
	_place(actor, Vector2(_lapis_x + push, -absf(shake) * 5.0 * w), 6.0 + 18.0 * w + shake * 4.0 * w)

func _finish() -> void:
	Monster.hide_bars = false
	_set_hero_visible(true)
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).frozen = false
			(m as Monster).take_hit({"type": "knockdown", "fly": 9.0, "dmg": 0.0, "skill": true}, _dir)
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
	super._exit_tree()

# ---------------------------------------------------------------- วาด
## ศรปีศาจ หัวเรียวแหลมมีเงี่ยง หางแสง ปลายหางเป็นรอยเท้าแมวสีชมพู
func _arrow(head: Vector2, length: float, thick: float, a: float) -> void:
	# ศรปีศาจทรงมน: ก้านปลายมน หัวศรทรงหยดน้ำ หางเป็นขนนกกลมๆ แสงฟุ้งนุ่มรอบตัว
	var d := Vector2(_dir, 0.0)
	var n := Vector2(0.0, 1.0)
	var tail := head - d * length
	var hb := head - d * thick * 2.6
	# แสงฟุ้งรอบทั้งดอก
	_soft_capsule(tail - d * length * 0.5, hb, thick * 1.6, Color(BLUE, 0.12 * a))
	_soft_capsule(tail, hb, thick * 0.95, Color(BLUE, 0.35 * a))
	_soft_capsule(tail, hb, thick * 0.45, Color(0.3, 0.45, 0.9, a))
	_soft_capsule(tail + d * length * 0.15, hb, maxf(1.5, thick * 0.16), Color(WHITE, a))
	# หัวศรทรงหยดน้ำ ปลายมนเล็กน้อย
	var drop := PackedVector2Array()
	var r := thick * 1.05
	for i in 13:
		var ang := PI * 0.5 + PI * float(i) / 12.0
		drop.append(hb + Vector2(cos(ang) * r * _dir, sin(ang) * r))
	drop.append(head - d * thick * 0.25 - n * thick * 0.18)
	drop.append(head)
	drop.append(head - d * thick * 0.25 + n * thick * 0.18)
	over.draw_colored_polygon(drop, Color(WHITE, a))
	var inner := PackedVector2Array()
	for p in drop:
		inner.append(hb + (p - hb) * 0.6 + d * thick * 0.25)
	over.draw_colored_polygon(inner, Color(BLUE.lightened(0.2), a))
	# ขนนกหางกลมๆ สองข้าง กับลูกกลมชมพู
	for side in [-1.0, 1.0]:
		over.draw_circle(tail + d * thick * 0.9 + n * side * thick * 0.7, thick * 0.55, Color(BLUE.lightened(0.3), 0.85 * a))
	over.draw_circle(tail + d * thick * 0.6, thick * 0.55, Color(PINK, 0.9 * a))

## ก้านทรงแคปซูล ปลายมนทั้งสองด้าน
func _soft_capsule(from: Vector2, to: Vector2, r: float, col: Color) -> void:
	# รูปเดียวทั้งก้าน สีโปร่งไม่ซ้อนกันเป็นวงเทา
	var dv := to - from
	if dv.length() < 1.0:
		over.draw_circle(to, r, col)
		return
	var ang0 := dv.angle()
	var pts := PackedVector2Array()
	for i in 9:
		var t := ang0 + PI * 0.5 + PI * float(i) / 8.0
		pts.append(from + Vector2(cos(t), sin(t)) * r)
	for i in 9:
		var t := ang0 - PI * 0.5 + PI * float(i) / 8.0
		pts.append(to + Vector2(cos(t), sin(t)) * r)
	over.draw_colored_polygon(pts, col)

## ประตูปีศาจ มองจากด้านข้างเห็นเป็นวงรีแคบสูงเกือบเต็มจอ กรอบขาวน้ำเงิน หูแมวบนยอด รอยเท้าที่ฐาน
func _draw_gate() -> void:
	var k := _gate_open()
	if k <= 0.01:
		return
	var c := Vector2(_gate_x, _gate_cy)
	var hh := _gate_h * k
	var hw := 130.0 * (0.4 + 0.6 * k)
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in 48:
		var ang := TAU * float(i) / 48.0
		outer.append(c + Vector2(cos(ang) * hw * 1.25, sin(ang) * hh * 1.04))
		inner.append(c + Vector2(cos(ang) * hw * 0.72, sin(ang) * hh * 0.94))
	over.draw_colored_polygon(outer, Color(BLUE, 0.22))
	over.draw_colored_polygon(inner, Color(0.04, 0.07, 0.2, 0.95))
	# ลายวนในประตู
	for i in 7:
		var ph := _t * 2.6 + float(i) * 0.9
		var yy := c.y + sin(ph) * hh * 0.75
		over.draw_line(Vector2(c.x - hw * 0.45, yy), Vector2(c.x + hw * 0.45, yy + 24.0), Color(BLUE, 0.4), 7.0, true)
	var ring := PackedVector2Array()
	for i in 49:
		var ang := TAU * float(i) / 48.0
		ring.append(c + Vector2(cos(ang) * hw, sin(ang) * hh))
	over.draw_polyline(ring, Color(0.25, 0.4, 0.9), 34.0, true)
	over.draw_polyline(ring, Color(WHITE, 0.95), 12.0, true)
	# ปุ่มกลมรอบกรอบ (แทนหนามแหลม)
	for i in 10:
		var ang := TAU * (float(i) + 0.5) / 10.0
		var p := c + Vector2(cos(ang) * hw, sin(ang) * hh)
		var out := Vector2(cos(ang) * hh / maxf(hw, 1.0), sin(ang)).normalized()
		over.draw_circle(p + out * 18.0 * k, 22.0 * k, Color(WHITE, 0.9))
	# ยอดและฐานประตู: เม็ดแสงกลมนุ่ม (เอาหูแมวกับรอยเท้าออก)
	over.draw_circle(c + Vector2(0.0, -hh * 0.98), 26.0 * k, Color(WHITE, 0.55))
	over.draw_circle(c + Vector2(0.0, hh * 0.98), 26.0, Color(WHITE, 0.55))

func _draw_over() -> void:
	_draw_gate()
	# แสงตอนแปลงร่าง
	if _t >= FORM_AT and _t < FORM_AT + 0.5:
		var k := (_t - FORM_AT) / 0.5
		var p := Vector2(_azure_x, -75.0)
		over.draw_circle(p, 40.0 + 160.0 * k, Color(BLUE, 0.3 * (1.0 - k)))
		over.draw_arc(p, 30.0 + 190.0 * k, 0.0, TAU, 48, Color(WHITE, 0.8 * (1.0 - k)), 10.0, true)
	# LAPIS โผล่
	if _t >= LAPIS_AT and _t < LAPIS_AT + 0.35:
		var k2 := (_t - LAPIS_AT) / 0.35
		over.draw_arc(Vector2(_lapis_x, -75.0), 30.0 + 160.0 * k2, 0.0, TAU, 48, Color(BLUE, 0.8 * (1.0 - k2)), 9.0, true)
	for a in _arrows:
		var age := _t - float(a[4])
		_arrow(Vector2(float(a[0]), float(a[1])), float(a[2]), float(a[3]), clampf(age / 0.08, 0.0, 1.0))
	# ลมพัดจากประตูผ่าน LAPIS ไปด้านหลัง กับฝุ่นตรงที่ปักดาบ
	if actor != null and actor.visible and _t >= LAPIS_AT + PLANT_TIME:
		var w := _wind()
		for i in 9:
			var ph := fmod(_t * (2.2 + float(i) * 0.17) + float(i) * 0.37, 1.0)
			var y := -20.0 - float((i * 53) % 260)
			var x0 := _gate_x - _dir * (60.0 + ph * 900.0)
			var ln := 90.0 + float((i * 37) % 80)
			over.draw_line(Vector2(x0, y), Vector2(x0 - _dir * ln, y), Color(WHITE, 0.45 * w * (1.0 - ph)), 5.0, true)
		var tip := Vector2(_lapis_x + _dir * 70.0, 0.0)
		for i in 3:
			var dp := fmod(_t * 3.0 + float(i) * 0.33, 1.0)
			over.draw_circle(tip + Vector2(-_dir * dp * 60.0, -dp * 18.0), 8.0 + dp * 10.0, Color(0.8, 0.88, 1.0, 0.4 * w * (1.0 - dp)))
	# ศรยักษ์
	if _big_fired and absf(_big_x) < _half.x + 3500.0:
		var head := Vector2(_big_x, _gate_cy)
		over.draw_line(head - Vector2(_dir * 3200.0, 0.0), head - Vector2(_dir * 1800.0, 0.0), Color(BLUE, 0.3), 160.0, true)
		_arrow(head, 1800.0, 130.0, 1.0)
		var fk := clampf((_t - THROW_AT) / 0.4, 0.0, 1.0)
		if fk < 1.0:
			over.draw_circle(Vector2(_gate_x, _gate_cy), 200.0 + 800.0 * fk, Color(WHITE, 0.5 * (1.0 - fk)))
