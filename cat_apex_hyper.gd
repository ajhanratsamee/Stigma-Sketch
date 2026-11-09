class_name CatApexHyper
extends HyperStage
## HYPER ของ APEX SNIPER (สาย SNIPESTARKER ของ CAT MATCHA)
## ยิงธนูไปด้านหน้าแล้วเฉียงขึ้นทีละดอกจนเกือบตั้งฉาก  กระโดดหมุนตัวลอยค้างกลางฟ้า ชาร์จแสงที่หัวลูกศร
## ปล่อยศรยักษ์สูงครึ่งจอพุ่งทะลุไปด้านหน้า  พร้อมกันนั้นศรที่ยิงขึ้นฟ้าก่อนหน้าดิ่งกลับลงมาไล่ยิงมอนสุ่มๆ
## หัวลูกศรเป็นหูแมว ขนหางลูกศรเป็นรอยเท้าแมว สีเขียวหยกกับทอง

const FAN_AT := 0.55
const FAN_GAP := 0.2
const FAN_COUNT := 9
const FAN_SPEED := 2600.0
const JUMP_AT := 2.45
const JUMP_TIME := 0.55
const HOVER_H := 3.2             # ลอยสูงเท่านี้ (หน่วยโลก)
const CHARGE_AT := 3.0
const SHOT_AT := 4.25
const BIG_SPEED := 5200.0
const BIG_H := 1050.0            # ศรยักษ์สูงประมาณครึ่งจอตอนกล้องถอย
const BIG_LONG := 2300.0
const BIG_TICK := 0.07
const BIG_DMG := 38.0
const BIG_FINAL_DMG := 140.0
const RAIN_AT := 4.4
const RAIN_GAP := 0.09
const RAIN_DMG := 34.0
const FAN_DMG := 12.0
const LAND_AT := 5.7
# สีหลัก MATCHA เขียว แซมสีทอง
const JADE := Color(0.6, 0.82, 0.42)
const JADE_DEEP := Color(0.3, 0.5, 0.22)
const GOLD := Color(1.0, 0.84, 0.35)
const PINK := Color(1.0, 0.7, 0.8)
const WHITE := Color(1.0, 1.0, 0.95)

var _fan: Array = []             # ศรที่ยิงขึ้นฟ้า [ตำแหน่ง ทิศ อายุ ยิงแล้วหรือยัง]
var _fan_done := 0
var _rain: Array = []            # ศรที่ดิ่งกลับลงมา [จาก ไปหา มอน อายุ โดนแล้ว]
var _rain_done := 0
var _big_x := 0.0                # ปลายศรยักษ์ (จุดภาพ)
var _big_fired := false          # ยิงศรยักษ์แล้ว (ตำแหน่งติดลบได้ จึงแยกเก็บ)
var _big_tick := 0.0
var _big_hits := 0
var _big_left := false
var _final_done := false         # ฮิตสุดท้ายระเบิดครึ่งจอแล้ว
var _bursts: Array = []          # วงแสงตรงจุดโดน [ตำแหน่ง อายุ ขนาด]
var _home := Vector2.ZERO
var _sparks: Array = []          # ประกายไหลเข้าหัวลูกศรตอนชาร์จ [มุม ระยะ]

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = 6.0
	end_time = 6.5
	Monster.hide_bars = true
	_home = Vector2(hero.pos.x, 0.0)
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	for i in 40:
		_sparks.append([randf() * TAU, randf_range(200.0, 900.0)])

func _f() -> float:
	return hero.facing if hero.facing != 0.0 else 1.0

## มือถือธนู (จุดภาพในโลก)
func _hand() -> Vector2:
	return hero.position + Vector2(_f() * 70.0, -110.0)

func _set_height(h: float) -> void:
	hero.pos.y = h
	hero.vel = Vector2.ZERO
	hero.position = Vector2(hero.pos.x, -hero.pos.y) * CombatData.UNIT

func _stage_tick(delta: float) -> void:
	# ยิงพัดศรเฉียงขึ้นทีละดอก
	while _fan_done < FAN_COUNT and _t >= FAN_AT + FAN_GAP * float(_fan_done):
		var deg := lerpf(0.0, 86.0, float(_fan_done) / float(FAN_COUNT - 1))
		var a := deg_to_rad(deg)
		var d := Vector2(cos(a) * _f(), -sin(a))
		_fan.append([_hand(), d, 0.0, false])
		_bursts.append([_hand(), 0.0, 120.0])
		_shake = maxf(_shake, 4.0)
		# ดอกต่ำๆ แนวนอนโดนมอนด้านหน้า
		if deg < 25.0:
			for m in caught:
				if is_instance_valid(m) and signf(m.pos.x - hero.pos.x) == _f():
					m.take_hit({"type": "none", "dmg": FAN_DMG, "skill": true}, 0.0)
		_fan_done += 1
	for s in _fan:
		s[2] = float(s[2]) + delta
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * FAN_SPEED * delta
	# กระโดดหมุนตัว ลอยค้าง
	if _t >= JUMP_AT and _t < LAND_AT:
		var k := clampf((_t - JUMP_AT) / JUMP_TIME, 0.0, 1.0)
		var e := 1.0 - pow(1.0 - k, 3.0)
		_set_height(HOVER_H * e + sin(_t * 3.0) * 0.08 * k)
		if hero.plain_model != null:
			hero.plain_model.turn_extra = fmod(720.0 * e, 360.0) if k < 1.0 else 0.0
	elif _t >= LAND_AT:
		var k := clampf((_t - LAND_AT) / 0.25, 0.0, 1.0)
		_set_height(HOVER_H * (1.0 - k * k))
		if k >= 1.0 and hero.plain_model != null:
			hero.plain_model.turn_extra = 0.0
	# ปล่อยศรยักษ์
	if _t >= SHOT_AT and not _big_fired:
		_big_fired = true
		_big_x = _hand().x
		_shake = 22.0
		_bursts.append([_hand(), 0.0, 520.0])
	if _big_fired and not _big_left:
		_big_x += _f() * BIG_SPEED * delta
		_big_tick -= delta
		if _big_tick <= 0.0:
			_big_tick = BIG_TICK
			var tail := _big_x - _f() * BIG_LONG
			for m in caught:
				if not is_instance_valid(m):
					continue
				var mx: float = m.position.x
				if (mx - tail) * _f() >= 0.0 and (_big_x - mx) * _f() >= -60.0:
					m.take_hit({"type": "none", "dmg": BIG_DMG, "skill": true}, 0.0)
					if randf() < 0.35:
						_bursts.append([m.position + Vector2(0.0, -60.0), 0.0, 160.0])
			_big_hits += 1
		# ฮิตสุดท้าย: ศรพุ่งไปครึ่งจอแล้วระเบิด โดนทุกตัวที่อยู่ในครึ่งจอด้านหน้า
		var half := screen_half_world()
		if not _final_done and (_big_x - hero.position.x) * _f() >= half.x:
			_final_done = true
			for m in caught:
				if not is_instance_valid(m):
					continue
				var dx: float = (m.position.x - hero.position.x) * _f()
				if dx >= -120.0 and dx <= half.x + 200.0:
					m.take_hit({"type": "none", "dmg": BIG_FINAL_DMG, "skill": true}, 0.0)
					_bursts.append([m.position + Vector2(0.0, -60.0), 0.0, 300.0])
			# วงระเบิดใหญ่สูงราวครึ่งจอ กลางครึ่งจอด้านหน้า
			_bursts.append([Vector2(hero.position.x + _f() * half.x * 0.55, _hand().y), 0.0, half.y * 0.55])
			_bursts.append([Vector2(_big_x, _hand().y), 0.0, half.y * 0.4])
			_shake = 26.0
		if absf(_big_x - hero.position.x) > 6500.0:
			_big_left = true
	# ศรที่ยิงขึ้นฟ้าดิ่งกลับลงมาไล่ยิงมอนสุ่มๆ
	var alive := []
	for m in caught:
		if is_instance_valid(m) and m.state != "dead":
			alive.append(m)
	while _rain_done < FAN_COUNT * 2 and _t >= RAIN_AT + RAIN_GAP * float(_rain_done):
		var target: Monster = alive[randi() % alive.size()] if not alive.is_empty() else null
		var to: Vector2 = (target.position + Vector2(randf_range(-30.0, 30.0), -60.0)) if target != null else hero.position + Vector2(_f() * randf_range(600.0, 2000.0), 0.0)
		var from := to + Vector2(randf_range(-700.0, 700.0), -2600.0)
		_rain.append([from, to, target, 0.0, false])
		_rain_done += 1
	for r in _rain:
		r[3] = float(r[3]) + delta
		if not r[4] and float(r[3]) >= 0.3:
			r[4] = true
			var m: Monster = r[2]
			if m != null and is_instance_valid(m):
				m.take_hit({"type": "none", "dmg": RAIN_DMG, "skill": true}, 0.0)
			_bursts.append([r[1], 0.0, 200.0])
			_shake = maxf(_shake, 6.0)
	for b in _bursts:
		b[1] = float(b[1]) + delta
	_bursts = _bursts.filter(func(b: Array) -> bool: return float(b[1]) < 0.5)

func _finish() -> void:
	_cleanup()
	super._finish()

func _exit_tree() -> void:
	_cleanup()
	super._exit_tree()

func _cleanup() -> void:
	Monster.hide_bars = false
	if is_instance_valid(hero):
		if hero.plain_model != null:
			hero.plain_model.hide_blade = false
			hero.plain_model.turn_extra = 0.0
		if hero.pos.y > 0.0:
			_set_height(0.0)

# ---------------------------------------------------------------- วาด
## รอยเท้าแมว (ขนหางลูกศร)
func _paw(c: Vector2, s: float, col: Color, angle := 0.0) -> void:
	if s < 1.5:
		return
	var rot := Transform2D(angle, Vector2.ZERO)
	var pad := PackedVector2Array()
	for i in 14:
		var a := TAU * float(i) / 14.0
		pad.append(c + rot * Vector2(cos(a) * s * 0.6, s * 0.28 + sin(a) * s * 0.45))
	draw_colored_polygon(pad, col)
	for t in 4:
		draw_circle(c + rot * Vector2((float(t) - 1.5) * s * 0.42, -s * (0.24 + (0.15 if t == 1 or t == 2 else 0.0))), s * 0.18, col)

## ลูกศรหนึ่งดอก หัวเป็นหูแมวสองแฉก หางเป็นรอยเท้า  tip คือปลายหัว d ทิศ size ความยาว
func _arrow(tip: Vector2, d: Vector2, size: float, a: float, glow := true) -> void:
	if a <= 0.0:
		return
	var n := d.orthogonal()
	var tail := tip - d * size
	if glow:
		draw_line(tail, tip, Color(JADE, 0.25 * a), size * 0.16, true)
	draw_line(tail, tip - d * size * 0.12, Color(0.55, 0.35, 0.2, a), maxf(size * 0.035, 2.0), true)
	# หัวลูกศรหูแมว
	var base := tip - d * size * 0.16
	var w := size * 0.08
	draw_colored_polygon(PackedVector2Array([tip, base + n * w, base + n * w * 0.35 - d * size * 0.03, base - n * w * 0.35 - d * size * 0.03, base - n * w]), Color(GOLD, a))
	for side in [-1.0, 1.0]:
		var ear: Vector2 = base + n * w * 0.6 * side
		draw_colored_polygon(PackedVector2Array([ear, ear - d * size * 0.06 + n * w * 0.55 * side, ear - d * size * 0.07]), Color(GOLD.darkened(0.15), a))
	draw_circle(tip - d * size * 0.09, w * 0.22, Color(PINK, a))
	# หางรอยเท้า
	_paw(tail + d * size * 0.06, size * 0.07, Color(JADE, a), d.angle() + PI * 0.5)

## ธนูที่มือ คันโค้งเขียวหยก ปลายคันเป็นหูแมว สายง้างตาม pull 0 ถึง 1
func _bow(hand: Vector2, aim: Vector2, pull: float, size: float, a: float) -> void:
	var n := aim.orthogonal()
	var top := hand + n * size - aim * size * 0.25
	var bottom := hand - n * size - aim * size * 0.25
	var pts := PackedVector2Array()
	for i in 17:
		var k := float(i) / 16.0
		var y := lerpf(-1.0, 1.0, k)
		pts.append(hand + n * y * size + aim * (size * 0.3 * (1.0 - y * y)) - aim * size * 0.25)
	draw_polyline(pts, Color(JADE_DEEP, a), size * 0.09, true)
	draw_polyline(pts, Color(JADE, a), size * 0.05, true)
	for end in [top, bottom]:
		draw_circle(end, size * 0.07, Color(GOLD, a))
	var nock := hand - aim * size * (0.25 + 0.55 * pull)
	draw_line(top, nock, Color(WHITE, 0.9 * a), 3.0, true)
	draw_line(bottom, nock, Color(WHITE, 0.9 * a), 3.0, true)

func _draw() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.35, 0.0, 1.0)
	if fade <= 0.0:
		return
	var hand := _hand()
	var f := _f()
	# พื้นเรืองแสงเขียวใต้ตัว
	var floor_c := Vector2(hero.position.x, 0.0)
	for k in 3:
		var rr := 900.0 - float(k) * 250.0
		var ring := PackedVector2Array()
		for i in 40:
			var a := TAU * float(i) / 40.0
			ring.append(floor_c + Vector2(cos(a) * rr, sin(a) * rr * 0.18))
		draw_colored_polygon(ring, Color(JADE, 0.06 * fade))
	# มุมเล็งตอนนี้ (พัดศร เฉียงขึ้นตามลำดับ)
	var aim := Vector2(f, 0.0)
	if _t < JUMP_AT:
		var deg := lerpf(0.0, 86.0, clampf((_t - FAN_AT) / (FAN_GAP * float(FAN_COUNT - 1)), 0.0, 1.0))
		aim = Vector2(cos(deg_to_rad(deg)) * f, -sin(deg_to_rad(deg)))
	var pull := 0.0
	if _t < JUMP_AT:
		pull = 1.0 - fmod(maxf(_t - FAN_AT, 0.0), FAN_GAP) / FAN_GAP
	elif _t >= CHARGE_AT and _t < SHOT_AT:
		pull = clampf((_t - CHARGE_AT) / 0.5, 0.0, 1.0)
	# ศรพัดที่บินขึ้นฟ้า
	for s in _fan:
		var age := float(s[2])
		if age < 1.6:
			var tip: Vector2 = s[0]
			var d: Vector2 = s[1]
			for g in 4:
				_arrow(tip - d * float(g) * 140.0, d, 300.0, (1.0 - float(g) * 0.25) * 0.5 * fade, false)
			_arrow(tip, d, 300.0, fade)
	# ชาร์จที่หัวลูกศร แสงไหลเข้า วงแหวนหมุน
	if _t >= CHARGE_AT and _t < SHOT_AT + 0.1:
		var ck := clampf((_t - CHARGE_AT) / (SHOT_AT - CHARGE_AT), 0.0, 1.0)
		var head := hand + aim * 140.0
		for p in _sparks:
			var ang: float = float(p[0]) + _t * 2.5
			var dist: float = float(p[1]) * (1.0 - fmod(_t * 0.9 + float(p[1]) * 0.001, 1.0))
			var q := head + Vector2(cos(ang), sin(ang)) * dist
			draw_line(q, q + (head - q).normalized() * 40.0, Color(GOLD if int(p[1]) % 2 == 0 else JADE, 0.8 * fade), 4.0, true)
		for k in 3:
			var rr := (90.0 + 160.0 * float(k)) * (0.6 + 0.4 * ck)
			draw_arc(head, rr, _t * (3.0 - float(k)) * f, _t * (3.0 - float(k)) * f + TAU * 0.8, 40, Color(JADE if k != 1 else GOLD, (0.4 + 0.4 * ck) * fade), 6.0, true)
		for k in 3:
			draw_circle(head, (60.0 + 180.0 * ck) * (1.0 - float(k) * 0.3), Color(WHITE if k == 2 else JADE, (0.18 + 0.25 * ck) * fade))
		_arrow(head + aim * 120.0, aim, 380.0 * (1.0 + ck * 0.6), fade)
		# เม็ดแสงกลมโคจรรอบหัวศร
		for i in 12:
			var ang := TAU * float(i) / 12.0 + _t
			var u := Vector2(cos(ang), sin(ang))
			draw_circle(head + u * (140.0 + 200.0 * ck * (1.0 if i % 2 == 0 else 0.7)), 10.0 + 8.0 * ck, Color(GOLD, 0.6 * ck * fade))
	# ธนูในมือ
	if _t < LAND_AT + 0.3:
		_bow(hand, aim, pull, 120.0, fade)
	# ศรยักษ์ทรงเพรียว ยาวครึ่งจอ บางคม แกนสว่าง แสงเรืองบาง หางแสงยาว วงช็อกตามทาง
	if _big_fired:
		var y := hand.y
		var tip := Vector2(_big_x, y)
		var tail := tip - Vector2(f * BIG_LONG, 0.0)
		# เพิ่งปล่อย ศรยังไม่ยืดเลยมือออกไปด้านหลัง
		if (tail.x - hand.x) * f < -300.0:
			tail.x = hand.x - f * 300.0
		var head_len := 380.0
		var head_w := 62.0
		var base := tip - Vector2(f * head_len, 0.0)
		var pulse := 0.85 + 0.15 * sin(_t * 40.0)
		# หางแสงยาวเรียวไปด้านหลัง
		for k in 4:
			var w := (46.0 - float(k) * 10.0) * pulse
			var back := tail - Vector2(f * (900.0 + float(k) * 500.0), 0.0)
			draw_colored_polygon(PackedVector2Array([base + Vector2(0.0, -w), back, base + Vector2(0.0, w)]), Color(JADE.lerp(WHITE, float(k) * 0.2), 0.1 * fade))
		# แสงเรืองบางรอบก้าน
		draw_line(tail, base, Color(JADE, 0.22 * fade), 70.0 * pulse, true)
		draw_line(tail, base, Color(GOLD, 0.35 * fade), 34.0, true)
		# ก้าน และแกนสว่าง
		draw_line(tail, base, Color(GOLD.darkened(0.15), fade), 16.0, true)
		draw_line(tail + Vector2(f * 60.0, 0.0), tip, Color(WHITE, fade), 5.0, true)
		# วงช็อกบางๆ ตามทางที่ศรผ่าน
		for i in 5:
			var d := fposmod(_t * 2600.0 + float(i) * 520.0, 2600.0)
			var cx := tip.x - f * (head_len + d)
			var k := d / 2600.0
			var ring := PackedVector2Array()
			for n in 25:
				var ang := TAU * float(n) / 24.0
				ring.append(Vector2(cx + cos(ang) * (18.0 + 40.0 * k), y + sin(ang) * (60.0 + 220.0 * k)))
			draw_polyline(ring, Color(WHITE.lerp(JADE, k), 0.55 * (1.0 - k) * fade), 3.0, true)
		# เส้นความเร็วบางใกล้ก้าน
		for i in 14:
			var yy := y + (float(i) / 13.0 - 0.5) * 360.0
			var x0 := tip.x - f * (head_len + fposmod(_t * 5200.0 + float(i) * 311.0, 2400.0))
			var len_k := 1.0 - absf(float(i) / 13.0 - 0.5) * 1.4
			draw_line(Vector2(x0, yy), Vector2(x0 - f * 520.0 * len_k, yy), Color(WHITE, 0.4 * len_k * fade), 2.5, true)
		# หัวศรเรียวแหลม ปีกเป็นหูแมวเล็ก ด้านในชมพู
		draw_colored_polygon(PackedVector2Array([tip + Vector2(f * 30.0, 0.0), base + Vector2(f * 40.0, -head_w), base, base + Vector2(f * 40.0, head_w)]), Color(GOLD, fade))
		draw_colored_polygon(PackedVector2Array([tip + Vector2(f * 30.0, 0.0), base + Vector2(f * 60.0, -head_w * 0.35), base + Vector2(f * 60.0, head_w * 0.35)]), Color(WHITE, 0.9 * fade))
		for side in [-1.0, 1.0]:
			var ear: Vector2 = base + Vector2(f * 40.0, side * head_w)
			draw_colored_polygon(PackedVector2Array([ear, ear + Vector2(-f * 70.0, side * 34.0), ear + Vector2(-f * 40.0, -side * 10.0)]), Color(GOLD.darkened(0.15), fade))
			draw_colored_polygon(PackedVector2Array([ear + Vector2(-f * 8.0, side * 2.0), ear + Vector2(-f * 50.0, side * 22.0), ear + Vector2(-f * 32.0, -side * 4.0)]), Color(PINK, fade))
		draw_circle(tip, 26.0 * pulse, Color(WHITE, 0.5 * fade))
		# ขนหางเรียวสองแฉก กับรอยเท้าเล็ก
		for side in [-1.0, 1.0]:
			var fb := tail + Vector2(f * 40.0, 0.0)
			draw_colored_polygon(PackedVector2Array([fb + Vector2(f * 220.0, 0.0), fb + Vector2(f * 40.0, side * 70.0), fb + Vector2(-f * 30.0, side * 64.0), fb + Vector2(f * 30.0, 0.0)]), Color(JADE, 0.95 * fade))
		_paw(tail + Vector2(f * 120.0, 0.0), 26.0, Color(PINK, fade), -PI * 0.5 * f)
	# ศรที่ดิ่งกลับลงมา
	for r in _rain:
		var k := clampf(float(r[3]) / 0.3, 0.0, 1.0)
		var from: Vector2 = r[0]
		var to: Vector2 = r[1]
		var d := (to - from).normalized()
		if k < 1.0:
			var tip := from.lerp(to, k)
			draw_line(tip - d * 900.0, tip, Color(JADE, 0.3 * fade), 18.0, true)
			_arrow(tip, d, 320.0, fade)
		elif float(r[3]) < 0.9:
			# ปักพื้นค้าง แล้วจางไป
			_arrow(to + d * 60.0, d, 320.0, (1.0 - (float(r[3]) - 0.3) / 0.6) * fade, false)
	# วงแสงตรงจุดโดน
	for b in _bursts:
		var bk := float(b[1]) / 0.5
		var c: Vector2 = b[0]
		var s := float(b[2])
		draw_circle(c, s * (0.3 + 0.7 * bk), Color(WHITE, 0.35 * (1.0 - bk) * fade))
		draw_arc(c, s * (0.4 + 1.1 * bk), 0.0, TAU, 32, Color(GOLD, (1.0 - bk) * fade), 8.0 * (1.0 - bk) + 2.0, true)
		for i in 8:
			var ang := TAU * float(i) / 8.0
			var u := Vector2(cos(ang), sin(ang))
			draw_line(c + u * s * 0.3, c + u * s * (0.6 + 0.9 * bk), Color(JADE, (1.0 - bk) * fade), 5.0, true)
		_paw(c, s * 0.18 * (1.0 - bk) + 3.0, Color(GOLD, (1.0 - bk) * fade))
