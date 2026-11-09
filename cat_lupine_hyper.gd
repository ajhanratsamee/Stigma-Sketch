class_name CatLupineHyper
extends HyperStage
## HYPER ของ LUPINE DIRE (สาย PETIT FANG ของ CAT CITRUS แมวส้มถือหอกยาว)
## กระโดดขึ้นกลางอากาศ วงอาคมจันทร์เสี้ยวเงาดำขนาดใหญ่ผุดขึ้น แล้ววงอาคมกับตัวละครหายไป
## เงาแมวลายหมาป่ายักษ์โผล่ด้านหลังกลางจอ ตาเรืองสองข้าง อ้าปากกัดตรงหน้า (ฮิตแรก)
## หางยักษ์โผล่มาฟาดผ่านหน้าจอ (ฮิตสอง) แล้วทุกอย่างจางหาย ตัวละครกลับมายืนที่เดิม

const JUMP_FROM := 0.3
const JUMP_TO := 0.9
const SIGIL_FROM := 0.75
const VANISH_AT := 2.05
const BEAST_FROM := 2.3
const EYES_AT := 2.75
const BITE_FROM := 3.05
const BITE_AT := 3.45
const TAIL_FROM := 3.85
const TAIL_AT := 4.3
const TAIL_TO := 4.9
const BEAST_GONE := 5.5
const RETURN_AT := 5.55
const BITE_DMG := 210.0
# แบบใหม่: ไม่มีหัว มีแค่ตาขาวล้วนสองดวงกับเขี้ยว งับ 3 ครั้ง ครั้งสุดท้ายใหญ่
const EYE_IN := 2.3
const CHOMPS := [3.05, 3.65, 4.35]
const CHOMP_WIND := 0.38
const CHOMP_DMG := [90.0, 90.0, 260.0]
const EYES_OUT := 7.4
const RETURN2_AT := 7.6
const EYE_W := 150.0
const EYE_H := 62.0
const EYE_GAP := 210.0
const FANG_W := 560.0
# แบบล่าสุด: ตาแมวโผล่กลางจอ อ้าปากไปมุมบนซ้าย งับเฉียงลงถึงมุมล่างขวา 1 ฮิตใหญ่ แล้วตา ^ ^
const OPEN_FROM := 2.95
## งับหลายรอบ 10 ฮิต แต่ละรอบเปลี่ยนมุม (เฉียง แนวนอน แนวตั้ง สลับซ้ายขวา)
const BITES := 10
const BITE_T := 0.3                     # เวลาต่องับหนึ่งครั้ง
const BITE_OPEN := 0.4                  # ช่วงแรกของรอบ อ้าปากเลื่อนไปจุดเริ่ม
const BITE_HIT := 0.85                  # กวาดงับจนถึงตรงนี้แล้วโดน
const BITE_ANGS := [35.0, 0.0, 90.0, 145.0, -35.0, 180.0, 60.0, -120.0, 120.0, 30.0]
const BITE_DMG_EACH := 34.0
const LAST_BITE_DMG := 80.0
const HAPPY_FROM := 6.75
const CROSS_AT := 6.15                  # งับครบแล้ว เล็บข่วนไขว้กากบาท 1 ฮิต
const CROSS_DMG := 240.0
const BITES_END := OPEN_FROM + BITE_T * BITES
const CAT_EYE_W := 190.0
const CAT_EYE_H := 150.0
const CAT_EYE_GAP := 290.0
const CUTE_FANG := 120.0
const TAIL_DMG := 190.0
const AIR_H := 4.5                      # กระโดดสูงกี่หน่วย
const SIGIL_R := 420.0
const HEAD_R := 430.0
# ชุดสีพาสเทลน่ารัก แมวลายหมาป่าสีครามอ่อน พุงเงิน
# สีหลัก CITRUS ส้ม แซมดำ (เหมือนลูกบอลหมาป่า)
const INDIGO := Color(0.98, 0.6, 0.24)
const DEEP := Color(0.62, 0.3, 0.1)
const SILVER := Color(0.94, 0.95, 1.0)
const MOON := Color(1.0, 0.8, 0.55)
const MOON_Y := Color(1.0, 0.9, 0.62)
const EYE := Color(1.0, 0.96, 0.85)
const FUR := Color(0.98, 0.62, 0.3)
const FUR_DARK := Color(0.72, 0.36, 0.12)
const PINK := Color(1.0, 0.68, 0.8)
const SOFT_BG := Color(1.0, 0.8, 0.6)
const INK := Color(0.1, 0.07, 0.06)
const SHAFT := Color(0.9, 0.5, 0.15)

var _start := Vector2.ZERO
var _start_pos := Vector2.ZERO
var _target := Vector2.ZERO
var _center := Vector2.ZERO            # หัวเงายักษ์กลางจอ
var _vanished := false
var _bit := false
var _chomped := 0
var _crossed := false
var _tailed := false
var _back := false
var _rng := RandomNumberGenerator.new()
var _sparks: Array = []                 # [ตำแหน่ง ความเร็ว อายุ]

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = 7.9
	end_time = 8.45
	Monster.hide_bars = true
	_rng.seed = 31
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_start = hero.position
	_start_pos = hero.pos
	var sum := 0.0
	var n := 0
	for m in caught:
		if is_instance_valid(m):
			sum += (m as Monster).position.x
			n += 1
	var front := _start.x + hero.facing * 5.0 * CombatData.UNIT
	_target = Vector2(sum / float(n) if n > 0 else front, 0.0)
	_center = Vector2((_start.x + _target.x) * 0.5 + hero.facing * 120.0, -470.0)

func _hit_all(dmg: float) -> void:
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _set_model_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

func _burst(at: Vector2, count: int, speed: float) -> void:
	for i in count:
		var a := _rng.randf() * TAU
		_sparks.append([at, Vector2(cos(a), sin(a)) * _rng.randf_range(speed * 0.3, speed), 0.0])
	if _sparks.size() > 220:
		_sparks = _sparks.slice(_sparks.size() - 220)

func _stage_tick(delta: float) -> void:
	hero.vel = Vector2.ZERO
	# กระโดดขึ้นกลางอากาศ ลอยค้าง หมุนหอก
	if not _vanished:
		var jk := clampf((_t - JUMP_FROM) / (JUMP_TO - JUMP_FROM), 0.0, 1.0)
		var e := 1.0 - pow(1.0 - jk, 3.0)
		hero.pos = Vector2(_start_pos.x, _start_pos.y + AIR_H * e + sin(_t * 3.0) * 0.08 * jk)
		hero.position = Vector2(hero.pos.x, -hero.pos.y) * CombatData.UNIT
	# วงอาคมกับตัวละครหายไป
	if not _vanished and _t >= VANISH_AT:
		_vanished = true
		_set_model_visible(false)
		_burst(hero.position + Vector2(0.0, -60.0), 14, 700.0)
		_shake = maxf(_shake, 8.0)
	# งับหลายรอบ แต่ละรอบโดนตอนกวาดงับเสร็จ รอบสุดท้ายแรงสุด
	while _chomped < BITES and _t >= OPEN_FROM + (float(_chomped) + BITE_HIT) * BITE_T:
		var last := _chomped == BITES - 1
		_hit_all(LAST_BITE_DMG if last else BITE_DMG_EACH)
		_shake = 38.0 if last else maxf(_shake, 14.0)
		_chomped += 1
		_bit = true
		for m in caught:
			if is_instance_valid(m):
				_burst((m as Monster).position + Vector2(0.0, -60.0), 8 if last else 3, 620.0)
	# เล็บข่วนไขว้กากบาท 1 ฮิต
	if not _crossed and _t >= CROSS_AT:
		_crossed = true
		_hit_all(CROSS_DMG)
		_shake = 40.0
		for m in caught:
			if is_instance_valid(m):
				_burst((m as Monster).position + Vector2(0.0, -60.0), 8, 650.0)
	# กลับมายืนที่เดิม
	if not _back and _t >= RETURN2_AT:
		_back = true
		hero.pos = _start_pos
		hero.position = _start
		_set_model_visible(true)
		_burst(_start + Vector2(0.0, -60.0), 20, 600.0)
	for s in _sparks:
		s[2] = float(s[2]) + delta
		s[1] = (s[1] as Vector2) * 0.92
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
	_sparks = _sparks.filter(func(s: Array) -> bool: return float(s[2]) < 0.8)

func _finish() -> void:
	var targets := caught.duplicate()
	Monster.hide_bars = false
	hero.pos = _start_pos
	hero.position = _start
	_set_model_visible(true)
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
		hero.plain_model.turn_extra = 0.0
	super._finish()
	for m in targets:
		if is_instance_valid(m) and (m as Monster).state != "dead":
			(m as Monster).take_hit({"type": "launch", "vy": 11.0, "dmg": 1.0, "skill": true}, signf((m as Monster).position.x - _start.x))

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
		hero.plain_model.turn_extra = 0.0
		hero.plain_model.hide_blade = false
	super._exit_tree()

## สถานะการงับตอนนี้ [พุ่งเข้า 0-1, อ้าปาก 0-1, เพิ่งงับ 0-1, ครั้งที่]
func _chomp_state() -> Array:
	for i in CHOMPS.size():
		var at := float(CHOMPS[i])
		if _t >= at - CHOMP_WIND and _t < at:
			var k := (_t - (at - CHOMP_WIND)) / CHOMP_WIND
			return [1.0 - pow(1.0 - k, 2.0), clampf(k * 1.6, 0.0, 1.0) * (1.0 - clampf((k - 0.8) / 0.2, 0.0, 1.0)), 0.0, i]
		if _t >= at and _t < at + 0.32:
			var k2 := (_t - at) / 0.32
			return [1.0 - k2, 0.0, 1.0 - k2, i]
	return [0.0, 0.0, 0.0, 0]

## ตาขาวล้วนสองดวง ทรงอัลมอนด์เรืองแสง
func _draw_eyes(c: Vector2, sc: float, squint: float, a: float) -> void:
	for side in [-1.0, 1.0]:
		var e := c + Vector2(side * EYE_GAP * sc, 0.0)
		var w := EYE_W * sc
		var h := maxf(EYE_H * sc * squint, 4.0)
		var pts := PackedVector2Array()
		for i in 24:
			var t := TAU * float(i) / 24.0
			# ปลายตาเฉียงขึ้นด้านนอกนิดๆ
			pts.append(e + Vector2(cos(t) * w, sin(t) * h - cos(t) * side * h * 0.35))
		draw_circle(e, w * 1.1, Color(0.85, 0.9, 1.0, 0.05 * a))
		draw_colored_polygon(pts, Color(1.0, 1.0, 1.0, a))

## เขี้ยวขาวแถวบนแถวล่าง อ้าแล้วงับเข้าหากัน
func _draw_fangs(c: Vector2, open: float, shut: float, sc: float, a: float) -> void:
	var gap := 170.0 * open * sc
	var w := FANG_W * sc
	var n := 5
	for row in [-1.0, 1.0]:
		var base_y: float = c.y + float(row) * (gap + 70.0 * sc)
		for i in n:
			var x := c.x - w * 0.5 + w * (float(i) + 0.5) / float(n)
			var big: float = 1.25 if i == 0 or i == n - 1 else 0.8
			var fw := w / float(n) * 0.42
			var fh := 120.0 * sc * big
			var tip := Vector2(x, base_y - float(row) * fh)
			draw_colored_polygon(PackedVector2Array([Vector2(x - fw, base_y), Vector2(x + fw, base_y), tip]), Color(1.0, 1.0, 1.0, a))
		if shut > 0.0:
			draw_line(Vector2(c.x - w * 0.55, c.y), Vector2(c.x + w * 0.55, c.y), Color(1.0, 1.0, 1.0, shut * a), 6.0, true)

# ---------------------------------------------------------------- วาด
func _paw(c: Vector2, s: float, col: Color) -> void:
	if s < 1.5 or col.a <= 0.0:
		return
	draw_circle(c + Vector2(0.0, s * 0.25), s * 0.55, col)
	for i in 4:
		var a := -2.45 + float(i) * 0.55
		draw_circle(c + Vector2(cos(a), sin(a)) * s * 0.85 + Vector2(0.0, s * 0.15), s * 0.22, col)

## จันทร์เสี้ยว วาดเป็นเส้นโค้งหนาตรงกลางเรียวปลาย
func _crescent(c: Vector2, r: float, thick: float, rot: float, col: Color) -> void:
	if r < 4.0 or col.a <= 0.0:
		return
	var n := 18
	for i in n:
		var t0 := float(i) / float(n)
		var t1 := float(i + 1) / float(n)
		var a0 := rot + PI * 0.5 + PI * t0
		var a1 := rot + PI * 0.5 + PI * t1
		var w := maxf(thick * sin(PI * (t0 + t1) * 0.5), 1.0)
		var rr := r - w * 0.5
		draw_line(c + Vector2(cos(a0), sin(a0)) * rr, c + Vector2(cos(a1), sin(a1)) * rr, col, w, true)

func _spear(at: Vector2, ang: float, length: float, a: float) -> void:
	var u := Vector2(cos(ang), sin(ang))
	var tip := at + u * length * 0.55
	var butt := at - u * length * 0.45
	draw_line(butt, tip, Color(SHAFT.darkened(0.3), a), 9.0, true)
	draw_line(butt, tip, Color(SHAFT, a), 5.0, true)
	var n := u.orthogonal()
	var head := tip + u * 70.0
	draw_colored_polygon(PackedVector2Array([tip - u * 6.0, tip + u * 24.0 + n * 18.0, head, tip + u * 24.0 - n * 18.0]), Color(SILVER, a))
	draw_circle(tip, 8.0, Color(1.0, 0.6, 0.2, a))

func _oval(c: Vector2, rx: float, ry: float, n := 28) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## วงเวทจันทร์เสี้ยว นุ่มๆ น่ารัก จันทร์เหลืองนวล ดาว รอยเท้าแมว ลอยรอบตัวกลางอากาศ
func _draw_sigil(c: Vector2, k: float, a: float) -> void:
	var r := SIGIL_R * k
	if r < 6.0:
		return
	draw_colored_polygon(_oval(c, r * 1.05, r * 1.05, 40), Color(SOFT_BG, 0.35 * a))
	draw_arc(c, r, 0.0, TAU, 48, Color(INK, 0.6 * a), 8.0, true)
	draw_arc(c, r, 0.0, TAU, 48, Color(MOON, 0.9 * a), 5.0, true)
	draw_arc(c, r * 0.8, 0.0, TAU, 40, Color(SILVER, 0.6 * a), 3.0, true)
	_crescent(c + Vector2(0.0, -r * 0.05), r * 0.5, r * 0.26, -PI * 0.35 + sin(_t * 1.5) * 0.08, Color(MOON_Y, 0.95 * a))
	for i in 6:
		var ang := -_t * 0.7 + TAU * float(i) / 6.0
		var p := c + Vector2(cos(ang), sin(ang)) * r * 0.9
		if i % 2 == 0:
			_star(p, 26.0 * k, Color(MOON_Y, 0.95 * a))
		else:
			_paw(p, 22.0 * k, Color(PINK, 0.95 * a))

func _star(c: Vector2, r: float, col: Color) -> void:
	# ประกายกลมนุ่ม ไม่มีแฉก
	if r < 2.0 or col.a <= 0.0:
		return
	draw_circle(c, r * 0.75, Color(col, col.a * 0.3))
	draw_circle(c, r * 0.42, col)

func _outline(pts: PackedVector2Array, a: float, w := 10.0) -> void:
	var rim := pts.duplicate()
	rim.append(pts[0])
	draw_polyline(rim, Color(INK, a), w, true)

## ตัวโมจิกลม (หัวกับตัวเป็นก้อนเดียว) กว้างล่าง มนบน
func _mochi(c: Vector2, r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 44:
		var ang := TAU * float(i) / 44.0
		var x := cos(ang) * r
		var y := sin(ang) * r * 0.9
		# ด้านล่างแบนกว้างนิดๆ แบบโมจิ
		if y > 0.0:
			x *= 1.0 + 0.12 * (y / r)
			y *= 0.8
		pts.append(c + Vector2(x, y))
	return pts

## แมวยักษ์ลายหมาป่าแบบน่ารักเรียบง่าย ตัวโมจิก้อนเดียว หูใหญ่ ตากลมโตมีประกาย ปาก ω แก้มชมพู
func _draw_beast(a: float, eye_k: float, open: float, lunge: float) -> void:
	var s := 1.0 + 0.18 * lunge
	var c := _center + Vector2(hero.facing * 140.0 * lunge, 120.0 * lunge + sin(_t * 3.0) * 8.0)
	var r := HEAD_R * s
	# หูใหญ่ ด้านในชมพู
	for side in [-1.0, 1.0]:
		var base := c + Vector2(side * r * 0.52, -r * 0.62)
		var ear := PackedVector2Array([base + Vector2(-side * r * 0.3, r * 0.14), base + Vector2(side * r * 0.06, -r * 0.55), base + Vector2(side * r * 0.36, r * 0.26)])
		draw_colored_polygon(ear, Color(FUR, a))
		_outline(ear, a)
		var m := (ear[0] + ear[1] + ear[2]) / 3.0
		draw_colored_polygon(PackedVector2Array([ear[0].lerp(m, 0.45), ear[1].lerp(m, 0.35), ear[2].lerp(m, 0.45)]), Color(PINK, a))
	var body := _mochi(c, r)
	draw_colored_polygon(body, Color(FUR, a))
	# เงาอ่อนชั้นเดียวด้านล่าง และพุงสีเงินอ่อน (ลายหมาป่า)
	draw_colored_polygon(_oval(c + Vector2(0.0, r * 0.42), r * 0.62, r * 0.28, 28), Color(SILVER, a))
	# ลายหมาป่าง่ายๆ สามขีดบนหัว
	for i in 3:
		draw_colored_polygon(_oval(c + Vector2((float(i) - 1.0) * r * 0.16, -r * 0.66), r * 0.045, r * 0.12, 12), Color(FUR_DARK, 0.8 * a))
	_outline(body, a, 12.0)
	# ตา
	for side in [-1.0, 1.0]:
		var e := c + Vector2(side * r * 0.36, -r * 0.12)
		var er := r * 0.15
		if open > 0.3:
			# ตอนงับ ตาหยี > <
			var tip := e + Vector2(side * er * 0.5, 0.0)
			draw_polyline(PackedVector2Array([e + Vector2(-side * er * 0.6, -er * 0.45), tip, e + Vector2(-side * er * 0.6, er * 0.45)]), Color(INK, a), 12.0, true)
		else:
			var eh := er * maxf(eye_k, 0.08)
			draw_colored_polygon(_oval(e, er, eh, 24), Color(INK, a))
			if eye_k > 0.3:
				draw_circle(e + Vector2(-er * 0.3, -eh * 0.35), er * 0.3, Color(1.0, 1.0, 1.0, a))
				draw_circle(e + Vector2(er * 0.3, eh * 0.3), er * 0.13, Color(1.0, 1.0, 1.0, a))
		draw_colored_polygon(_oval(c + Vector2(side * r * 0.58, r * 0.16), r * 0.11, r * 0.065, 16), Color(1.0, 0.6, 0.7, 0.8 * a))
	# จมูก
	var nose := c + Vector2(0.0, r * 0.1)
	draw_colored_polygon(PackedVector2Array([nose + Vector2(-r * 0.05, -r * 0.025), nose + Vector2(r * 0.05, -r * 0.025), nose + Vector2(0.0, r * 0.035)]), Color(1.0, 0.55, 0.65, a))
	var my := nose.y + r * 0.07
	if open > 0.05:
		# อ้าปากงับกลมๆ เขี้ยวเล็กสองซี่
		var mouth := _oval(Vector2(c.x, my + r * 0.14 * open), r * 0.24, r * 0.2 * open + 4.0, 28)
		draw_colored_polygon(mouth, Color(0.85, 0.3, 0.45, a))
		draw_colored_polygon(_oval(Vector2(c.x, my + r * 0.24 * open), r * 0.12, r * 0.07 * open + 2.0, 16), Color(1.0, 0.6, 0.7, a))
		_outline(mouth, a, 8.0)
		for side in [-1.0, 1.0]:
			var fx: float = c.x + side * r * 0.11
			draw_colored_polygon(PackedVector2Array([Vector2(fx - r * 0.035, my), Vector2(fx + r * 0.035, my), Vector2(fx, my + r * 0.08)]), Color(1.0, 1.0, 1.0, a))
	else:
		draw_arc(Vector2(c.x - r * 0.06, my), r * 0.06, 0.0, PI, 10, Color(INK, a), 8.0, true)
		draw_arc(Vector2(c.x + r * 0.06, my), r * 0.06, 0.0, PI, 10, Color(INK, a), 8.0, true)

## หางฟูกลมๆ ฟาดผ่านหน้าจอ
func _draw_tail(k: float, a: float) -> void:
	var dir := hero.facing
	var pivot := Vector2(_center.x - dir * 1300.0, 700.0)
	var theta := lerpf(-2.5, -0.55, k)
	var n := 10
	var pts := PackedVector2Array()
	for i in n:
		var t := float(i) / float(n - 1)
		var ang := theta + t * 0.6
		var v := Vector2(cos(ang), sin(ang))
		if dir < 0.0:
			v.x = -v.x
		pts.append(pivot + v * 2500.0 * t)
	for i in n:
		var t := float(i) / float(n - 1)
		var rad := 180.0 * (0.8 + 0.4 * sin(t * PI * 0.9))
		draw_circle(pts[i], rad + 10.0, Color(INK, a))
	for i in n:
		var t := float(i) / float(n - 1)
		var rad := 180.0 * (0.8 + 0.4 * sin(t * PI * 0.9))
		draw_circle(pts[i], rad, Color(FUR if t < 0.78 else SILVER, a))
	for i in 3:
		var p := pts[mini(n - 1, 3 + i * 2)]
		draw_line(p + Vector2(-dir * 220.0, -60.0), p + Vector2(-dir * 480.0, -40.0), Color(1.0, 1.0, 1.0, 0.5 * a), 10.0, true)

## ตาแมวน่ารัก ทรงกลมโต ม่านตาเรียวตั้ง เรืองฟ้าขาว  mode: open squint happy
func _cat_eye(e: Vector2, w: float, h: float, mode: String, look: Vector2, a: float) -> void:
	draw_circle(e, w * 1.15, Color(EYE, 0.05 * a))
	match mode:
		"squint":
			draw_line(e + Vector2(-w * 0.9, 0.0), e + Vector2(w * 0.9, 0.0), Color(1.0, 1.0, 1.0, a), 26.0, true)
			draw_line(e + Vector2(-w * 0.9, 0.0), e + Vector2(w * 0.9, 0.0), Color(EYE, 0.6 * a), 10.0, true)
		"happy":
			var arc := PackedVector2Array()
			for i in 13:
				var t := PI + PI * float(i) / 12.0
				arc.append(e + Vector2(cos(t) * w * 0.85, sin(t) * h * 0.7 + h * 0.25))
			draw_polyline(arc, Color(1.0, 1.0, 1.0, a), 26.0, true)
		_:
			draw_colored_polygon(_oval(e, w, h, 32), Color(1.0, 1.0, 1.0, a))
			draw_colored_polygon(_oval(e, w * 0.82, h * 0.82, 28), Color(1.0, 0.95, 0.85, a))
			var p := e + look * w * 0.25
			var slit := PackedVector2Array([p + Vector2(0.0, -h * 0.72), p + Vector2(w * 0.17, 0.0), p + Vector2(0.0, h * 0.72), p + Vector2(-w * 0.17, 0.0)])
			draw_colored_polygon(slit, Color(0.35, 0.18, 0.08, a))
			draw_circle(e + Vector2(-w * 0.35, -h * 0.4), w * 0.16, Color(1.0, 1.0, 1.0, a))

## เขี้ยวน่ารัก 4 ซี่ (บน 2 ล่าง 2) ทรงสามเหลี่ยมมน ระหว่างกรามเป็นปากชมพูอ่อน
func _cute_jaw(c: Vector2, open: float, sc: float, ang: float, a: float) -> void:
	var u := Vector2(cos(ang), sin(ang))
	var n := u.orthogonal()
	var gap := 230.0 * open * sc
	var half := 260.0 * sc
	# ปากด้านใน
	if open > 0.05:
		var mouth := PackedVector2Array()
		for i in 24:
			var t := TAU * float(i) / 24.0
			mouth.append(c + u * cos(t) * half + n * sin(t) * (gap + 30.0 * sc))
		draw_colored_polygon(mouth, Color(1.0, 0.62, 0.75, 0.55 * a))
	for row in [-1.0, 1.0]:
		var base := c + n * float(row) * (gap + 40.0 * sc)
		# เหงือกโค้งเส้นขาวนุ่ม
		draw_line(base - u * half, base + u * half, Color(1.0, 1.0, 1.0, 0.8 * a), 14.0 * sc, true)
		for k in [-1.0, 1.0]:
			var root := base + u * float(k) * half * 0.42
			var fw := 48.0 * sc
			var tip := root - n * float(row) * CUTE_FANG * sc
			var pts := PackedVector2Array([root - u * fw, root - u * fw * 0.5 - n * float(row) * CUTE_FANG * sc * 0.55, tip, root + u * fw * 0.5 - n * float(row) * CUTE_FANG * sc * 0.55, root + u * fw])
			draw_colored_polygon(pts, Color(1.0, 1.0, 1.0, a))
			draw_circle(tip, 12.0 * sc, Color(1.0, 1.0, 1.0, a))

## หน้าเงาแมวเป็นกลุ่มเดียว ตาอยู่บน ปากอยู่ล่างเสมอ ขยับไปด้วยกัน ปากอ้าลงด้านล่าง ไม่ทับตา
const FACE_S := 0.8                     # ขนาดหน้าทั้งกลุ่ม
const FACE_EYE_UP := 210.0              # ตาอยู่เหนือจุดกลางหน้า
const FACE_MOUTH_DOWN := 230.0          # เหงือกบนอยู่ใต้จุดกลางหน้า

## เส้นงับรอบที่ i [จุดเริ่ม จุดจบ] ผ่านกลางจอ
func _bite_line(i: int, center: Vector2, hw: Vector2) -> Array:
	var ang := deg_to_rad(float(BITE_ANGS[i]))
	var d := Vector2(cos(ang) * hw.x * 0.55, sin(ang) * hw.y * 0.38)
	return [center - d, center + d]

## สถานะงับตอนนี้ [รอบ ส่วนในรอบ 0-1] รอบ -1 ยังไม่เริ่ม รอบ BITES งับครบแล้ว
func _bite_now() -> Array:
	if _t < OPEN_FROM:
		return [-1, 0.0]
	var f := (_t - OPEN_FROM) / BITE_T
	var i := floori(f)
	if i >= BITES:
		return [BITES, 0.0]
	return [i, f - float(i)]

func _face_pos(center: Vector2, hw: Vector2) -> Vector2:
	var st := _bite_now()
	var i: int = st[0]
	var k: float = st[1]
	if i < 0:
		return center
	if i >= BITES:
		var last: Vector2 = _bite_line(BITES - 1, center, hw)[1]
		var back := clampf((_t - BITES_END - 0.1) / 0.3, 0.0, 1.0)
		return last.lerp(center, 1.0 - pow(1.0 - back, 2.0))
	var ln := _bite_line(i, center, hw)
	var prev: Vector2 = center if i == 0 else _bite_line(i - 1, center, hw)[1]
	if k < BITE_OPEN:
		var o := k / BITE_OPEN
		return prev.lerp(ln[0], 1.0 - pow(1.0 - o, 2.0))
	var s := clampf((k - BITE_OPEN) / (BITE_HIT - BITE_OPEN), 0.0, 1.0)
	return (ln[0] as Vector2).lerp(ln[1], s * s)

func _draw_cat_bite(a: float) -> void:
	var center := screen_center_world()
	var hw := screen_half_world()
	var st := _bite_now()
	var i: int = st[0]
	var k: float = st[1]
	var biting := i >= 0 and i < BITES
	var open := 0.0
	var sweep := 0.0
	if biting:
		if k < BITE_OPEN:
			open = k / BITE_OPEN
		else:
			sweep = clampf((k - BITE_OPEN) / (BITE_HIT - BITE_OPEN), 0.0, 1.0)
			open = 1.0 - sweep * sweep
	var mode := "open"
	if biting and k >= BITE_OPEN:
		mode = "squint"
	elif _t >= HAPPY_FROM:
		mode = "happy"
	var face := _face_pos(center, hw) + Vector2(0.0, sin(_t * 2.4) * 10.0)
	var look := Vector2.ZERO
	if biting:
		var ln := _bite_line(i, center, hw)
		look = ((ln[1] as Vector2) - (ln[0] as Vector2)).normalized()
	var ew := CAT_EYE_W * FACE_S
	var eh := CAT_EYE_H * FACE_S
	for side in [-1.0, 1.0]:
		_cat_eye(face + Vector2(side * CAT_EYE_GAP * FACE_S, -FACE_EYE_UP * FACE_S), ew, eh, mode, look, a)
	var mouth_off := Vector2(0.0, FACE_MOUTH_DOWN * FACE_S)
	# รอยงับขาวตามแนวปากของรอบที่กำลังกวาด และรอยของรอบก่อนที่ค่อยๆ จาง
	for j in range(maxi(0, i - 1), mini(i + 1, BITES)):
		var lj := _bite_line(j, center, hw)
		var hit_t := OPEN_FROM + (float(j) + BITE_HIT) * BITE_T
		var from: Vector2 = (lj[0] as Vector2) + mouth_off
		var to: Vector2
		var fa := 1.0
		if _t < hit_t:
			if j != i or k < BITE_OPEN:
				continue
			to = from.lerp((lj[1] as Vector2) + mouth_off, sweep * sweep)
		else:
			fa = 1.0 - clampf((_t - hit_t) / 0.35, 0.0, 1.0)
			if fa <= 0.0:
				continue
			to = (lj[1] as Vector2) + mouth_off
		var w := 1.4 if j == BITES - 1 else 1.0
		draw_line(from, to, Color(EYE, 0.3 * a * fa), 170.0 * w, true)
		draw_line(from, to, Color(1.0, 1.0, 1.0, 0.8 * a * fa), 50.0 * w, true)
		if _t >= hit_t:
			var after := 1.0 - fa
			draw_arc(to, (90.0 + 260.0 * after) * w, 0.0, TAU, 40, Color(1.0, 1.0, 1.0, 0.8 * fa * a), 14.0 * fa + 2.0, true)
			for q in 5:
				var qa := TAU * float(q) / 5.0 + float(j)
				_star(to + Vector2(cos(qa), sin(qa)) * (120.0 + 320.0 * after) * w, 30.0 * fa + 4.0, Color(MOON_Y, fa * a))
	# ปากใต้ตาเสมอ อ้าลงด้านล่าง ไม่ทับตา
	if biting and open > 0.0:
		var sc := FACE_S * (1.15 if i == BITES - 1 else 1.0)
		var gap := 230.0 * open * sc
		var jaw_c := face + mouth_off + Vector2(0.0, gap + 40.0 * sc)
		_cute_jaw(jaw_c, open, sc, 0.0, a)

## รอยเล็บข่วนไขว้เป็นกากบาทกลางจอ เส้นละสามรอย ปลายมน ขีดทีละชุด
func _draw_cross(fade: float) -> void:
	var k := _t - CROSS_AT + 0.2
	if k <= 0.0 or k > 0.85:
		return
	var a := (1.0 - clampf((k - 0.55) / 0.3, 0.0, 1.0)) * fade
	var c := screen_center_world()
	var size := screen_half_world().y * 0.8
	for set in 2:
		var grow := clampf((k - float(set) * 0.1) / 0.12, 0.0, 1.0)
		if grow <= 0.0:
			continue
		var d := Vector2(1.0, 1.0 if set == 0 else -1.0).normalized()
		var n := Vector2(-d.y, d.x)
		for i in 3:
			var off := n * (float(i) - 1.0) * size * 0.22
			var from := c + off - d * size
			var to := from + d * size * 2.0 * grow
			var w := size * (0.07 if i == 1 else 0.055)
			draw_line(from, to, Color(MOON, 0.35 * a), w * 2.2, true)
			draw_line(from, to, Color(SILVER, a), w, true)
			draw_circle(from, w * 0.5, Color(SILVER, a))
			draw_circle(to, w * 0.5, Color(SILVER, a))

func _draw() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.5, 0.0, 1.0)
	if fade <= 0.0:
		return
	# หอกควงตอนกระโดดขึ้น
	if not _vanished and _t >= JUMP_FROM:
		var hand := hero.position + Vector2(hero.facing * 30.0, -95.0)
		_spear(hand, _t * 14.0, 300.0, fade)
		for k in 4:
			draw_arc(hand, 160.0, _t * 14.0 - float(k) * 0.25 - 0.2, _t * 14.0 - float(k) * 0.25, 8, Color(MOON, 0.45 * (1.0 - float(k) * 0.22) * fade), 10.0, true)
	# วงอาคมจันทร์เสี้ยวใหญ่ขึ้น แล้วยุบหายพร้อมตัวละคร
	var grow := clampf((_t - SIGIL_FROM) / 0.9, 0.0, 1.0)
	var gone := clampf((_t - VANISH_AT) / 0.35, 0.0, 1.0)
	if grow > 0.0 and gone < 1.0:
		var e := 1.0 - pow(1.0 - grow, 3.0)
		var c := Vector2(_start.x, -(_start_pos.y + AIR_H) * CombatData.UNIT - 60.0)
		_draw_sigil(c, e * (1.0 - gone * 0.7), (1.0 - gone) * fade)
	if _vanished and _t < VANISH_AT + 0.6:
		var vk := (_t - VANISH_AT) / 0.6
		var c2 := Vector2(_start.x, -(_start_pos.y + AIR_H) * CombatData.UNIT - 60.0)
		draw_circle(c2, 80.0 + 380.0 * vk, Color(SOFT_BG, 0.6 * (1.0 - vk) * fade))
		_star(c2, 60.0 * (1.0 - vk) + 4.0, Color(MOON_Y, (1.0 - vk) * fade))
	# ตาแมวโผล่กลางจอ อ้าปากไปมุมบนซ้าย งับเฉียงลงมุมล่างขวา แล้วตา ^ ^
	var ea := clampf((_t - EYE_IN) / 0.4, 0.0, 1.0) * (1.0 - clampf((_t - EYES_OUT) / 0.35, 0.0, 1.0)) * fade
	if ea > 0.0:
		_draw_cat_bite(ea)
	_draw_cross(fade)
	for s in _sparks:
		var sa := (1.0 - float(s[2]) / 0.8) * fade
		_star(s[0], 12.0, Color(MOON_Y, sa))
