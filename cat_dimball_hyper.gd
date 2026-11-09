class_name CatDimBallHyper
extends HyperStage
## HYPER ของ DIMENSION CASTER (CAT SUSI) จอดำ กล้องถอยไกล มอนสตั๊น
## โยนลูกบอลมิติสีชมพูม่วงขนาดยักษ์ขึ้นฟ้า ตกลงมากระแทกพื้นข้างหน้า แตกเป็นลูกที่เล็กลง
## ทุกลูกที่ตกถึงพื้นแตกต่อเป็นลูกเล็กกว่าเดิม จำนวนเพิ่มขึ้นทุกครั้ง 1 2 4 8 16 กระแทกทีไหนโดนทีนั้น

const THROW_AT := 0.6
const UP_TIME := 0.7             # ลอยขึ้นจนพ้นขอบจอด้านบน
const HANG := 0.35
const BIG := 440.0
const SKY_Y := -1700.0
const AHEAD := 800.0
const GRAVITY := 2600.0
const SPLIT := 2                 # แตกออกเป็นกี่ลูกต่อครั้ง
const LAST_GEN := 4              # รุ่นสุดท้าย แตกไม่ได้แล้ว 1+2+4+8+16 ลูก
const SHRINK := 0.62
const HIT_DMG := 70.0
const PINK := Color(1.0, 0.45, 0.85)
const VIOLET := Color(0.66, 0.5, 0.92)    # สีหลักม่วงอ่อนของ CAT SUSI
const CORE := Color(1.0, 0.85, 1.0)

## [ตำแหน่ง ความเร็ว รัศมี รุ่น เฟสหมุน]
var _balls: Array = []
var _rings: Array = []           # วงกระแทกบนพื้น [ตำแหน่ง รัศมีลูก อายุ]
var _stars: Array = []           # ประกายดาว [ตำแหน่ง ความเร็ว อายุ]
var _thrown := false
var _done_at := -1.0

func _stage_start() -> void:
	open_time = 0.5
	close_from = 30.0
	end_time = 30.45
	Monster.hide_bars = true

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _land_x() -> float:
	return hero.position.x + hero.facing * AHEAD

func _stage_tick(delta: float) -> void:
	# โยนขึ้น ลอยค้างนิดหนึ่งบนฟ้า แล้วตกลงตรงหน้า
	if not _thrown and _t >= THROW_AT:
		_thrown = true
		_balls.append([hero.position + Vector2(hero.facing * 60.0, -150.0), Vector2.ZERO, BIG * 0.3, 0, 0.0])
	if _thrown and _t < THROW_AT + UP_TIME + HANG and not _balls.is_empty():
		var ball: Array = _balls[0]
		var k := clampf((_t - THROW_AT) / UP_TIME, 0.0, 1.0)
		var e := 1.0 - pow(1.0 - k, 3.0)
		var from := hero.position + Vector2(hero.facing * 60.0, -150.0)
		ball[0] = from.lerp(Vector2(_land_x(), SKY_Y), e)
		ball[2] = lerpf(BIG * 0.3, BIG, e)
		ball[1] = Vector2.ZERO
		ball[4] = float(ball[4]) + delta * 3.0
	else:
		for ball in _balls.duplicate():
			ball[1] = (ball[1] as Vector2) + Vector2(0.0, GRAVITY) * delta
			ball[0] = (ball[0] as Vector2) + (ball[1] as Vector2) * delta
			ball[4] = float(ball[4]) + delta * 4.0
			var r: float = ball[2]
			if (ball[0] as Vector2).y + r >= 0.0 and (ball[1] as Vector2).y > 0.0:
				_land(ball)
	if _thrown and _balls.is_empty() and _done_at < 0.0:
		_done_at = _t
		close_from = _t + 0.5
		end_time = close_from + 0.45
	for r in _rings.duplicate():
		r[2] += delta
		if r[2] > 0.6:
			_rings.erase(r)
	for s in _stars.duplicate():
		s[2] += delta
		s[1] = (s[1] as Vector2) + Vector2(0.0, 900.0) * delta
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
		if s[2] > 0.8:
			_stars.erase(s)

## ลูกบอลกระแทกพื้น โดนมอน วงกระแทก แล้วแตกเป็นลูกเล็กกว่าเดิมเด้งออกไปสองข้าง
func _land(ball: Array) -> void:
	_balls.erase(ball)
	var at := Vector2((ball[0] as Vector2).x, 0.0)
	var r: float = ball[2]
	var gen: int = ball[3]
	_hit_all(HIT_DMG)
	_shake = maxf(_shake, 6.0 + r * 0.05)
	_rings.append([at, r, 0.0])
	for n in 18:
		var a := randf_range(PI * 1.05, PI * 1.95)
		_stars.append([at + Vector2(0.0, -r * 0.3), Vector2(cos(a), sin(a)) * randf_range(350.0, 1200.0), 0.0])
	if gen >= LAST_GEN:
		return
	var child_r := r * SHRINK
	for n in SPLIT:
		var side := -1.0 if n == 0 else 1.0
		var jump := 1700.0 * pow(0.86, float(gen))
		var vx := side * randf_range(220.0, 520.0)
		_balls.append([at + Vector2(side * child_r * 1.1, -child_r), Vector2(vx, -jump), child_r, gen + 1, randf() * TAU])

func _finish() -> void:
	Monster.hide_bars = false
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	super._exit_tree()

func _oval(c: Vector2, rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 48:
		var a := TAU * float(i) / 48.0
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## ลูกบอลมิติ แสงชมพูฟุ้งรอบ ผิวม่วงชมพู เกลียวมิติหมุนข้างใน ดาวระยิบ ไฮไลต์มันวาว
func _draw_ball(c: Vector2, r: float, spin: float, fade: float) -> void:
	# รัศมีแสงชมพูกว้าง หลายชั้น
	draw_circle(c, r * 2.3, Color(PINK, 0.05 * fade))
	draw_circle(c, r * 1.8, Color(PINK, 0.08 * fade))
	# เม็ดแสงกลมโคจรรอบลูก
	for n in 6:
		var a := spin * 0.7 + TAU * float(n) / 6.0
		var p := c + Vector2(cos(a) * r * 1.55, sin(a) * r * 0.6)
		var tw := maxf(3.0, r * 0.07)
		draw_circle(p, tw * 1.2, Color(1.0, 0.9, 1.0, 0.85 * fade))
	draw_circle(c, r * 1.35, Color(PINK, 0.12 * fade))
	draw_circle(c, r * 1.15, Color(PINK, 0.22 * fade))
	# หูแมวโผล่เหนือลูกบอล
	_kitty_ears(self, c, r, Color(VIOLET.lerp(PINK, 0.35), 0.95 * fade), Color(1.0, 0.75, 0.9, 0.95 * fade))
	draw_circle(c, r, Color(VIOLET.lerp(PINK, 0.35), 0.95 * fade))
	draw_circle(c + Vector2(r * 0.08, r * 0.1), r * 0.82, Color(0.35, 0.1, 0.55, 0.85 * fade))
	# เกลียวมิติ 3 แขน หมุนเข้ากลาง
	for arm in 3:
		var pts := PackedVector2Array()
		for n in 20:
			var k := float(n) / 19.0
			var a := spin + TAU * float(arm) / 3.0 + k * 4.2
			pts.append(c + Vector2(cos(a), sin(a)) * r * 0.8 * (1.0 - k * 0.92))
		draw_polyline(pts, Color(PINK.lightened(0.3), 0.85 * fade), maxf(2.0, r * 0.07), true)
	draw_circle(c, r * 0.18, Color(CORE, 0.95 * fade))
	for n in 5:
		var a := spin * 0.5 + float(n) * 1.9
		var p := c + Vector2(cos(a), sin(a)) * r * (0.35 + 0.1 * float(n % 3))
		var tw := maxf(2.0, r * 0.05) * (0.6 + 0.4 * sin(_t * 9.0 + float(n)))
		draw_line(p + Vector2(-tw * 2.0, 0.0), p + Vector2(tw * 2.0, 0.0), Color(1, 1, 1, 0.9 * fade), maxf(1.5, tw * 0.5), true)
		draw_line(p + Vector2(0.0, -tw * 2.0), p + Vector2(0.0, tw * 2.0), Color(1, 1, 1, 0.9 * fade), maxf(1.5, tw * 0.5), true)
	draw_arc(c, r, 0.0, TAU, 48, Color(1.0, 0.75, 0.95, 0.9 * fade), maxf(2.0, r * 0.05), true)
	draw_circle(c + Vector2(-r * 0.38, -r * 0.42), r * 0.16, Color(1, 1, 1, 0.55 * fade))
	_kitty_face(self, c + Vector2(0.0, r * 0.12), r * 0.62, Color(1.0, 0.9, 1.0, 0.95 * fade))

## ลายอุ้งเท้าแมว ฝ่าเท้ากลมกับนิ้วสี่นิ้ว หมุนได้ ry_k บีบแนวตั้งให้นอนบนพื้น
func _kitty_paw(target: CanvasItem, c: Vector2, s: float, col: Color, angle := 0.0, ry_k := 1.0) -> void:
	if s < 1.5 or col.a <= 0.0:
		return
	var rot := Transform2D(angle, Vector2.ZERO)
	var pad := PackedVector2Array()
	for i in 16:
		var a := TAU * float(i) / 16.0
		var p := rot * Vector2(cos(a) * s * 0.62, s * 0.3 + sin(a) * s * 0.46)
		pad.append(c + Vector2(p.x, p.y * ry_k))
	target.draw_colored_polygon(pad, col)
	for t in 4:
		var q := rot * Vector2((float(t) - 1.5) * s * 0.42, -s * (0.24 + (0.15 if t == 1 or t == 2 else 0.0)))
		target.draw_circle(c + Vector2(q.x, q.y * ry_k), s * 0.18, col)

## หูแมวคู่บนวงกลมจุดศูนย์กลาง c รัศมี r
func _kitty_ears(target: CanvasItem, c: Vector2, r: float, col: Color, inner: Color) -> void:
	if r < 2.0:
		return
	for side in [-1.0, 1.0]:
		var base := c + Vector2(side * r * 0.55, -r * 0.62)
		var tri := PackedVector2Array([base + Vector2(-side * r * 0.32, r * 0.1), base + Vector2(side * r * 0.12, -r * 0.62), base + Vector2(side * r * 0.38, r * 0.2)])
		target.draw_colored_polygon(tri, col)
		var m := (tri[0] + tri[1] + tri[2]) / 3.0
		target.draw_colored_polygon(PackedVector2Array([tri[0].lerp(m, 0.45), tri[1].lerp(m, 0.45), tri[2].lerp(m, 0.45)]), inner)

## หน้าเหมียว ตา ^ ^ ปาก ω แก้มชมพู
func _kitty_face(target: CanvasItem, c: Vector2, r: float, ink: Color) -> void:
	if r < 8.0:
		return
	var w := maxf(2.0, r * 0.08)
	for side in [-1.0, 1.0]:
		var e := c + Vector2(side * r * 0.32, -r * 0.08)
		target.draw_polyline(PackedVector2Array([e + Vector2(-r * 0.12, r * 0.06), e + Vector2(0.0, -r * 0.07), e + Vector2(r * 0.12, r * 0.06)]), ink, w, true)
		target.draw_circle(c + Vector2(side * r * 0.5, r * 0.14), r * 0.1, Color(1.0, 0.55, 0.65, 0.55 * ink.a))
	var m := c + Vector2(0.0, r * 0.2)
	target.draw_arc(m + Vector2(-r * 0.08, 0.0), r * 0.08, 0.0, PI, 8, ink, w * 0.8, true)
	target.draw_arc(m + Vector2(r * 0.08, 0.0), r * 0.08, 0.0, PI, 8, ink, w * 0.8, true)

## กระดิ่งแมวสีทอง
func _kitty_bell(target: CanvasItem, c: Vector2, r: float, col: Color, ink: Color) -> void:
	if r < 2.0:
		return
	target.draw_circle(c, r, col)
	target.draw_line(c + Vector2(-r * 0.95, -r * 0.25), c + Vector2(r * 0.95, -r * 0.25), ink, maxf(1.5, r * 0.16), true)
	target.draw_circle(c + Vector2(0.0, r * 0.4), r * 0.2, ink)
	target.draw_line(c + Vector2(0.0, r * 0.4), c + Vector2(0.0, r * 0.85), ink, maxf(1.0, r * 0.1), true)
	target.draw_circle(c + Vector2(-r * 0.35, -r * 0.5), r * 0.2, Color(1, 1, 1, 0.6 * col.a))

func _draw() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.4, 0.0, 1.0)
	for r in _rings:
		var k: float = float(r[2]) / 0.6
		var size: float = float(r[1]) * (1.4 + 3.6 * k)
		var at: Vector2 = r[0]
		# เสาแสงพุ่งขึ้นตอนกระแทก
		if k < 0.45:
			var pk := 1.0 - k / 0.45
			var pw := float(r[1]) * 0.9
			var lo := Color(1.0, 0.75, 0.97, 0.55 * pk * fade)
			var hi := Color(1.0, 0.75, 0.97, 0.0)
			draw_polygon(PackedVector2Array([at + Vector2(-pw, 0.0), at + Vector2(pw, 0.0), at + Vector2(pw * 0.4, -float(r[1]) * 6.0), at + Vector2(-pw * 0.4, -float(r[1]) * 6.0)]), PackedColorArray([lo, lo, hi, hi]))
		draw_colored_polygon(_oval(at, size * 0.8, size * 0.16), Color(VIOLET, 0.3 * (1.0 - k) * fade))
		for n in 2:
			var s2 := size * (1.0 - float(n) * 0.3)
			var pts := _oval(at, s2, s2 * 0.22)
			pts.append(pts[0])
			draw_polyline(pts, Color(PINK.lightened(0.3 + 0.3 * float(n)), (1.0 - k) * fade), (14.0 - float(n) * 5.0) * (1.0 - k) + 2.0, true)
		# รอยเท้าแมวประทับพื้นตรงที่กระแทก
		_kitty_paw(self, at + Vector2(0.0, -4.0), float(r[1]) * 0.9, Color(1.0, 0.6, 0.92, 0.6 * (1.0 - k) * fade), 0.0, 0.3)
	for ball in _balls:
		# เงาลูกที่ลอยตามหลังตอนตก
		var v: Vector2 = ball[1]
		if v.length() > 200.0:
			for n in 3:
				var back := (ball[0] as Vector2) - v * 0.025 * float(n + 1)
				draw_circle(back, float(ball[2]) * (0.9 - 0.15 * float(n)), Color(PINK, (0.18 - 0.05 * float(n)) * fade))
		_draw_ball(ball[0], ball[2], ball[4], fade)
	for s in _stars:
		var k: float = 1.0 - float(s[2]) / 0.8
		_kitty_paw(self, s[0], 7.0 + 9.0 * k, Color(1.0, 0.8, 0.95, k * fade), float(s[2]) * 4.0)
