class_name CatSumoHyper
extends HyperStage
## HYPER ของ GRAND SUMO จอดำ กล้องถอยไกล
## ตั้งท่าซูโม่ ยกขากระทืบพื้น เกิดวงคลื่นที่พื้น 1 วง → ตัวค่อยๆ ขยายใหญ่ขึ้น
## → ยกมือฟาดฝ่ามือลงพื้นด้านหน้าสลับซ้ายขวา 10 ฮิต หนักๆ หน่วงๆ
## → กระโดดขึ้นฟ้า ทิ้งตัวลงมา ตูม → ตัวค่อยๆ หดกลับขนาดปกติ
## สีเทาของ ASH เป็นหลัก แซมสีครีมของผ้ามาวาชิ ทุกอย่างทรงกลม ไม่มีดาว

const SIZE := 1.29                 # ขนาดปกติ เท่าตัวละคร
const BIG := 5.0                   # ขนาดตอนขยายสุด
const STANCE_FROM := 0.35
const STOMP_AT := 1.0              # กระทืบพื้นตอนตั้งท่า เกิดวงคลื่น
const GROW_FROM := 1.2
const GROW_TO := 2.3
const SLAP_FROM := 2.5
const SLAP_GAP := 0.27             # ฟาดหน่วงๆ
const SLAPS := 10
const SLAP_DMG := 26.0
const JUMP_FROM := SLAP_FROM + SLAP_GAP * float(SLAPS) + 0.2
const JUMP_UP := 0.5
const HANG := 0.25
const DROP := 0.18
const BOOM_AT := JUMP_FROM + JUMP_UP + HANG + DROP
const BOOM_DMG := 240.0
const SHRINK_FROM := BOOM_AT + 0.5
const SHRINK_TO := SHRINK_FROM + 0.8
const JUMP_H := 290.0
const REACH := 1500.0              # ฝ่ามือยักษ์ฟาดโดนด้านหน้าไกลเท่านี้
const BOOM_R := 1700.0

const GRAY := Color(0.62, 0.63, 0.68)
const LIGHT := Color(0.88, 0.89, 0.93)
const DARK := Color(0.4, 0.41, 0.46)
const CREAM := Color(1.0, 0.93, 0.78)

var _dir := 1.0
var _cx := 0.0
var _slapped := 0
var _stomped := false
var _boomed := false
## วงคลื่นบนพื้น [ตำแหน่ง x, เวลาเกิด, รัศมีสุด, หนา]
var _rings: Array = []
## รอยฝ่ามือบนพื้น [x, เวลาเกิด, ขนาด]
var _prints: Array = []
## ฝุ่นกลมฟุ้ง [ตำแหน่ง, ความเร็ว, เวลาเกิด, ขนาด]
var _dust: Array = []

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = SHRINK_TO + 0.2
	end_time = close_from + 0.5
	Monster.hide_bars = true
	_dir = signf(hero.facing) if hero.facing != 0.0 else 1.0
	_cx = hero.position.x
	add_actor(Vector2(_cx, 0.0), SIZE, ChibiModel.TURN * _dir, SkillPanel.model_style("fist", WalkPage.chosen_class))
	actor.sword_on = false
	add_over()
	_set_hero_visible(false)

func _set_hero_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

## ขนาดตัวตอนนี้ โตขึ้นช่วงกลาง แล้วหดกลับตอนท้าย
func _size_now() -> float:
	var grow := _ease((_t - GROW_FROM) / (GROW_TO - GROW_FROM))
	var shrink := _ease((_t - SHRINK_FROM) / (SHRINK_TO - SHRINK_FROM))
	return lerpf(SIZE, BIG, grow * (1.0 - shrink))

## ท่านอนคว่ำ 0 ยืน 1 นอนราบพุงลง
func _flop_k() -> float:
	var since := _t - JUMP_FROM
	if since < JUMP_UP:
		return 0.0
	if _t < BOOM_AT:
		return _ease((since - JUMP_UP) / (HANG + DROP))
	var after := _t - BOOM_AT
	if after < 0.4:
		return 1.0
	return 1.0 - _ease((after - 0.4) / 0.35)

func _slap_time(n: int) -> float:
	return SLAP_FROM + SLAP_GAP * float(n)

func _stage_tick(delta: float) -> void:
	var s := _size_now()
	var hand := Vector3(0.42, 0.68, 0.3)
	var off := Vector3(-0.42, 0.68, 0.02)
	var y := 0.0
	var squat := 0.0
	var tilt := 0.0
	if _t < SLAP_FROM:
		# ตั้งท่าซูโม่ ย่อตัว กางมือ ยกขาข้างหนึ่งแล้วกระทืบลง
		var sk := _ease((_t - STANCE_FROM) / 0.3)
		squat = 0.16 * sk
		hand = hand.lerp(Vector3(0.62, 0.45, 0.35), sk)
		off = off.lerp(Vector3(-0.62, 0.45, 0.1), sk)
		if _t > STOMP_AT - 0.4 and _t < STOMP_AT:
			var lk := sin((_t - (STOMP_AT - 0.4)) / 0.4 * PI)
			tilt = -_dir * 0.18 * lk
			y = -40.0 * lk
		if _t >= GROW_FROM and _t < GROW_TO:
			# ตัวโตขึ้น ตัวสั่นเบาๆ แขนกางออก
			tilt = sin(_t * 30.0) * 0.02
	elif _t < JUMP_FROM:
		# ฟาดฝ่ามือสลับข้าง: ยกขึ้นเหนือหัวแล้วฟาดลงด้านหน้า
		var step := (_t - SLAP_FROM) / SLAP_GAP
		var i := mini(floori(step), SLAPS - 1)
		var f := clampf(step - float(i), 0.0, 1.0)
		var up := Vector3(0.45, 1.35, 0.25)
		var down := Vector3(0.95, 0.1, 0.55)
		# ยกช้าๆ 60% แรก แล้วฟาดเร็ว ค้างที่พื้นนิดหนึ่ง
		var swing := Vector3.ZERO
		if f < 0.6:
			swing = down.lerp(up, _ease(f / 0.6))
		else:
			swing = up.lerp(down, clampf((f - 0.6) / 0.12, 0.0, 1.0))
		var rest := Vector3(-0.55, 0.5, 0.15)
		if i % 2 == 0:
			hand = swing
			off = rest
		else:
			off = Vector3(-swing.x * 0.2, swing.y, swing.z)
			hand = Vector3(0.55, 0.5, 0.2)
		squat = 0.12
		tilt = _dir * 0.08 * (1.0 if f > 0.6 else 0.0)
	elif _t < BOOM_AT:
		# กระโดดขึ้นฟ้า ค้างนิดหนึ่ง แล้วทิ้งตัวลงมา
		var since := _t - JUMP_FROM
		if since < JUMP_UP:
			y = -JUMP_H * _ease(since / JUMP_UP)
		elif since < JUMP_UP + HANG:
			y = -JUMP_H - 30.0 * sin((since - JUMP_UP) / HANG * PI)
		else:
			var dk := clampf((since - JUMP_UP - HANG) / DROP, 0.0, 1.0)
			y = -JUMP_H * (1.0 - dk * dk)
		hand = Vector3(0.6, 1.2, 0.2)
		off = Vector3(-0.6, 1.2, 0.0)
		squat = -0.08
	else:
		# ลงพื้นแล้วยุบตัวเด้ง แล้วค่อยๆ หดกลับ
		var bk := clampf((_t - BOOM_AT) / 0.35, 0.0, 1.0)
		squat = 0.25 * (1.0 - bk)
		hand = Vector3(0.62, 0.45, 0.35)
		off = Vector3(-0.62, 0.45, 0.1)
	actor.stage_hand = hand
	actor.stage_off = off
	var base := s * ChibiModel.LEGACY_PX / ChibiModel.PX_PER_UNIT
	actor.scale = Vector2(base * (1.0 + squat * 0.6), base * (1.0 - squat))
	# ทิ้งตัวลงแบบเอาพุงลง: ระหว่างลอยค้างค่อยๆ เอนตัวนอนคว่ำหันหน้าไปข้างหน้า ลงพื้นแล้วค้างนิดหนึ่งแล้วลุก
	var flop := _flop_k()
	var lie := 52.0 * s / SIZE * flop
	actor.position = Vector2(_cx - _dir * lie * 0.2, y - lie)
	actor.rotation = tilt + _dir * PI * 0.5 * flop
	# กระทืบพื้นตอนตั้งท่า วงคลื่นที่พื้น 1 วง
	if not _stomped and _t >= STOMP_AT:
		_stomped = true
		_rings.append([_cx, _t, 900.0, 26.0])
		_puff(Vector2(_cx, 0.0), 10, 500.0, 50.0)
		_shake = 10.0
	# ฟาดฝ่ามือ ฮิตตอนมือถึงพื้น
	while _slapped < SLAPS and _t >= _slap_time(_slapped) + SLAP_GAP * 0.72:
		_slap(_slapped, s)
		_slapped += 1
	if not _boomed and _t >= BOOM_AT:
		_boomed = true
		_boom()
	for d in _dust:
		d[1] = (d[1] as Vector2) * 0.9
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
	_dust = _dust.filter(func(d: Array) -> bool: return _t - float(d[2]) < 0.9)
	_rings = _rings.filter(func(r: Array) -> bool: return _t - float(r[1]) < 1.0)
	_prints = _prints.filter(func(p: Array) -> bool: return _t - float(p[1]) < 1.6)

## ฝ่ามือกระทบพื้นด้านหน้า รอยอุ้งมือ ฝุ่น วงคลื่นเล็ก โดนมอนด้านหน้า
func _slap(n: int, s: float) -> void:
	var reach := 260.0 * s / SIZE
	var x := _cx + _dir * (reach + float(n % 3) * 40.0)
	_prints.append([x, _t, 120.0 * s / SIZE])
	_rings.append([x, _t, 520.0 * s / SIZE, 14.0])
	_puff(Vector2(x, 0.0), 6, 380.0, 34.0)
	_shake = 11.0 if n < SLAPS - 1 else 16.0
	for m in caught:
		if not is_instance_valid(m):
			continue
		var d := ((m as Monster).pos.x * CombatData.UNIT - _cx) * _dir
		if d > -120.0 and d < REACH:
			(m as Monster).take_hit({"type": "none", "dmg": SLAP_DMG, "skill": true}, 0.0)

## ทิ้งตัวลงพื้น ตูม วงคลื่นใหญ่ ฝุ่นฟุ้ง โดนทุกตัวในวง
func _boom() -> void:
	_rings.append([_cx, _t, BOOM_R, 46.0])
	_rings.append([_cx, _t + 0.1, BOOM_R * 0.7, 30.0])
	_puff(Vector2(_cx, 0.0), 22, 1100.0, 80.0)
	_shake = 34.0
	for m in caught:
		if is_instance_valid(m) and absf((m as Monster).pos.x * CombatData.UNIT - _cx) <= BOOM_R:
			(m as Monster).take_hit({"type": "none", "dmg": BOOM_DMG, "skill": true}, 0.0)

func _puff(at: Vector2, count: int, speed: float, size: float) -> void:
	for i in count:
		var a := PI + PI * (float(i) + 0.5) / float(count)
		_dust.append([at + Vector2(randf_range(-30.0, 30.0), -10.0), Vector2(cos(a), sin(a) * 0.5) * speed * randf_range(0.6, 1.0), _t, size * randf_range(0.7, 1.2)])

func _finish() -> void:
	var targets := caught.duplicate()
	Monster.hide_bars = false
	_set_hero_visible(true)
	super._finish()
	# ปล่อยมอนแล้วกระเด้งลอยจากแรงตูม
	for m in targets:
		if is_instance_valid(m) and (m as Monster).state != "dead":
			(m as Monster).take_hit({"type": "launch", "vy": 11.0, "dmg": 1.0, "skill": true}, signf((m as Monster).position.x - _cx))

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
	super._exit_tree()

## วงคลื่นแบนบนพื้น วงรีขอบนุ่ม เทาอ่อนแกนขาว
func _ring(x: float, k: float, rmax: float, w: float) -> void:
	if k <= 0.0 or k >= 1.0:
		return
	var r := rmax * _ease(k)
	var a := 1.0 - k
	var pts := PackedVector2Array()
	for i in 49:
		var t := TAU * float(i) / 48.0
		pts.append(Vector2(x + cos(t) * r, sin(t) * r * 0.16))
	draw_polyline(pts, Color(GRAY, 0.35 * a), w * 2.0, true)
	draw_polyline(pts, Color(LIGHT, 0.85 * a), w, true)
	draw_polyline(pts, Color(1.0, 1.0, 1.0, 0.6 * a), w * 0.3, true)

## รอยอุ้งมือแมวบนพื้น บีบแนวตั้งให้นอนราบ
func _paw_print(x: float, size: float, a: float) -> void:
	var c := Vector2(x, 4.0)
	draw_set_transform(c, 0.0, Vector2(1.0, 0.32))
	draw_circle(Vector2(0.0, size * 0.25), size * 0.55, Color(DARK, 0.55 * a))
	for t in 4:
		var q := Vector2((float(t) - 1.5) * size * 0.42, -size * (0.42 + (0.16 if t == 1 or t == 2 else 0.0)))
		draw_circle(q, size * 0.2, Color(DARK, 0.55 * a))
	draw_circle(Vector2(0.0, size * 0.25), size * 0.32, Color(CREAM, 0.35 * a))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.5, 0.0, 1.0)
	if fade <= 0.0:
		return
	# เงาใต้ตัว โตตามตัว เล็กลงตอนลอยขึ้นฟ้า
	if actor != null:
		var lift := clampf(-actor.position.y / JUMP_H, 0.0, 1.0)
		var sr := 120.0 * _size_now() / SIZE * (1.0 - lift * 0.6)
		draw_set_transform(Vector2(_cx, 6.0), 0.0, Vector2(1.0, 0.22))
		draw_circle(Vector2.ZERO, sr, Color(0.0, 0.0, 0.0, 0.25 * fade))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	for p in _prints:
		var k := (_t - float(p[1])) / 1.6
		_paw_print(float(p[0]), float(p[2]), (1.0 - k) * fade)
	for r in _rings:
		_ring(float(r[0]), (_t - float(r[1])) / 1.0, float(r[2]), float(r[3]))

## ฝ่ามือแมวยักษ์ หันฝ่ามือลงพื้น อุ้งเท้าครีม ขอบเทา
func _big_palm(c: Vector2, r: float, a: float, left: bool) -> void:
	if a <= 0.0:
		return
	var tint := 0.92 if left else 1.0
	over.draw_circle(c, r * 1.12, Color(DARK, 0.5 * a))
	over.draw_circle(c, r, Color(GRAY * tint, a))
	for t in 4:
		var q := c + Vector2((float(t) - 1.5) * r * 0.5, r * (0.78 + (0.12 if t == 1 or t == 2 else 0.0)))
		over.draw_circle(q, r * 0.3, Color(DARK, 0.5 * a))
		over.draw_circle(q, r * 0.25, Color(GRAY * tint, a))
		over.draw_circle(q + Vector2(0.0, r * 0.06), r * 0.13, Color(CREAM, a))
	over.draw_circle(c + Vector2(0.0, r * 0.35), r * 0.42, Color(CREAM, a))
	over.draw_circle(c + Vector2(-r * 0.3, -r * 0.35), r * 0.18, Color(1.0, 1.0, 1.0, 0.35 * a))

func _draw_over() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.5, 0.0, 1.0)
	if fade <= 0.0:
		return
	# ฝุ่นกลมฟุ้งด้านหน้า เทาแซมครีม
	for d in _dust:
		var k := (_t - float(d[2])) / 0.9
		var c: Color = CREAM if int(float(d[3])) % 3 == 0 else LIGHT
		over.draw_circle(d[0], float(d[3]) * (0.6 + k * 0.8), Color(c, 0.7 * (1.0 - k) * fade))
	# ฝ่ามือยักษ์ฟาดลงพื้นด้านหน้า โผล่ตอนฟาดลงแล้วจางหลังกระทบ
	if _t >= SLAP_FROM and _t < JUMP_FROM:
		var step := (_t - SLAP_FROM) / SLAP_GAP
		var i := mini(floori(step), SLAPS - 1)
		var f := clampf(step - float(i), 0.0, 1.0)
		# ฝ่ามือยักษ์ใหญ่กว่าตัว ยกขึ้นเหนือหัวช้าๆ แล้วฟาดลงพื้นด้านหน้า
		var s := _size_now()
		var body_h := 105.0 * s / SIZE
		# รัศมีฝ่ามือใหญ่กว่าตัวทั้งตัว
		var r := body_h * 1.05
		var ground := Vector2(_cx + _dir * (body_h * 1.6 + float(i % 3) * 40.0), -r * 0.85)
		var high := Vector2(_cx + _dir * body_h * 0.6, -body_h * 1.9)
		var c := Vector2.ZERO
		if f < 0.6:
			c = ground.lerp(high, _ease(f / 0.6))
		else:
			c = high.lerp(ground, clampf((f - 0.6) / 0.12, 0.0, 1.0))
		_big_palm(c, r, fade, i % 2 == 1)
	# แสงฟุ้งเทาตอนตูม
	if _boomed:
		var bk := (_t - BOOM_AT) / 0.6
		if bk < 1.0:
			for i in 8:
				var rk := 1.0 - float(i) / 8.0
				over.draw_circle(Vector2(_cx, -60.0), 900.0 * _ease(bk) * (0.3 + 0.7 * rk), Color(LIGHT, 0.05 * (1.0 - bk) * fade))
