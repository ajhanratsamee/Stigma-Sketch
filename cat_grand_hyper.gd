class_name CatGrandHyper
extends HyperStage
## HYPER ของ GRAND KNIGHT จอเป็นแบบภาพ ซ่อนปุ่มและหลอดเลือด สตั๊นมอนในจอ กล้องถอยไกล
## ตั้งท่า ดูดมอนรอบจอเข้ามา ดาบแปรเป็นออร่าดาบยักษ์ ฟาดไปมารอบตัว 17 ฮิต พักหลังฮิตที่ 8
## ฮิตสุดท้ายฟาดเฉียงขึ้น มีเส้นขาวพาดเฉียงทั้งจอ แล้วกลับปกติ

const PULL_FROM := 0.5
const PULL_TO := 1.1
const GROW_FROM := 1.1
const GROW_TO := 1.45
const FIRST_HITS := 8
const FIRST_AT := 1.5
const FIRST_GAP := 0.12
const SECOND_AT := 3.0
const SECOND_GAP := 0.11
const FINAL_AT := 4.15
const LINE_LIFE := 0.6
const HITS := 17
const DMG := 30.0
const FINAL_DMG := 160.0
const REACH := 950.0
const BLADE_LONG := 940.0
const BLADE_W := 150.0
const AURA := Color(1.0, 0.45, 0.42, 0.75)
const AURA_EDGE := Color(1.0, 0.9, 0.88)

var _done := 0                   # ฮิตที่ฟาดไปแล้ว
var _from := 0.0                 # มุมเริ่มของการฟาดครั้งนี้
var _to := 0.0
var _swing_t := 0.0
var _line_t := -1.0

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = FINAL_AT + LINE_LIFE
	end_time = close_from + 0.45
	Monster.hide_bars = true
	_from = deg_to_rad(-60.0)
	_to = _from

## เวลาของฮิตที่ n นับจาก 0 พักหลังฮิตที่ 8
func _hit_time(n: int) -> float:
	if n < FIRST_HITS:
		return FIRST_AT + FIRST_GAP * float(n)
	if n < HITS - 1:
		return SECOND_AT + SECOND_GAP * float(n - FIRST_HITS)
	return FINAL_AT

func _stage_tick(delta: float) -> void:
	_swing_t += delta
	# ดูดมอนในจอเข้ามารอบตัว
	if _t >= PULL_FROM and _t <= PULL_TO + 0.05:
		var k := _ease((_t - PULL_FROM) / (PULL_TO - PULL_FROM))
		var n := 0
		for monster in caught:
			if not is_instance_valid(monster):
				continue
			var start: Vector2 = _start_at[monster]
			var side := signf(start.x - hero.pos.x) if start.x != hero.pos.x else 1.0
			var spot := hero.pos.x + side * (1.0 + 0.45 * float(n % 4))
			monster.pos.x = lerpf(start.x, spot, k)
			n += 1
	while _done < HITS and _t >= _hit_time(_done):
		_strike_hit(_done)
		_done += 1
	if _line_t >= 0.0:
		_line_t += delta

func _strike_hit(n: int) -> void:
	_swing_t = 0.0
	_from = _to
	if n == HITS - 1:
		# ฟาดเฉียงขึ้น
		_from = deg_to_rad(150.0)
		_to = deg_to_rad(-35.0)
		_line_t = 0.0
	else:
		# ฟันหลากมุม ฟาดข้ามหัว ตัดแนวนอน เฉียงลง งัดขึ้น สลับหน้าหลัง
		var swings := [-200.0, 25.0, -95.0, 160.0, -20.0, 200.0, -150.0, 45.0, -240.0, 10.0, 135.0, -60.0, 190.0, -10.0, -170.0, 60.0]
		_to = deg_to_rad(float(swings[n % swings.size()]))
	var dmg := FINAL_DMG if n == HITS - 1 else DMG
	for monster in caught:
		if is_instance_valid(monster) and absf(monster.pos.x - hero.pos.x) * CombatData.UNIT <= REACH:
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)
	_shake = 18.0 if n == HITS - 1 else 8.0

func _finish() -> void:
	Monster.hide_bars = false
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	super._exit_tree()

## มุมของออร่าดาบตอนนี้ ฟาดเร็วตอนต้นแล้วค้าง
func _blade_angle() -> float:
	var k := 1.0 - pow(1.0 - clampf(_swing_t / 0.09, 0.0, 1.0), 3.0)
	return lerpf(_from, _to, k)

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
	var grow := clampf((_t - GROW_FROM) / (GROW_TO - GROW_FROM), 0.0, 1.0)
	var fade := 1.0 - clampf((_t - close_from) / 0.3, 0.0, 1.0)
	var hand := hero.position + Vector2(hero.facing * 40.0, -80.0)
	# ช่วงดูด เส้นลมพุ่งเข้าหาตัวจากทั่วจอ
	if _t >= PULL_FROM and _t < GROW_TO:
		var pk := clampf((_t - PULL_FROM) / (GROW_TO - PULL_FROM), 0.0, 1.0)
		for n in 24:
			var a := TAU * float(n) / 24.0 + float(n) * 0.37
			var d := Vector2(cos(a), sin(a) * 0.6)
			var far := 2200.0 - fposmod(_t * 2600.0 + float(n) * 173.0, 1900.0)
			# เม็ดแสงกลมไหลเข้าหามือ ไม่ใช้เส้นแหลม
			draw_circle(hand + d * far, 10.0, Color(1.0, 0.75, 0.72, 0.5 * (1.0 - pk * 0.5)))
			draw_circle(hand + d * (far + 60.0), 6.0, Color(1.0, 0.75, 0.72, 0.35 * (1.0 - pk * 0.5)))
		draw_circle(hand, 60.0 + 140.0 * pk, Color(1.0, 0.5, 0.45, 0.18 + 0.2 * pk))
	# คลื่นกระแทกที่มือทุกครั้งที่ฟาด
	if _done > 0 and _swing_t < 0.3 and fade > 0.0:
		var sk := _swing_t / 0.3
		for n in 2:
			var rr := (200.0 + 900.0 * sk) * (1.0 - float(n) * 0.35)
			draw_arc(hand, rr, 0.0, TAU, 56, Color(1.0, 0.8, 0.78, 0.7 * (1.0 - sk)), 12.0 * (1.0 - sk) + 2.0, true)
		for n in 10:
			var a := TAU * float(n) / 10.0 + float(_done)
			var d := Vector2(cos(a), sin(a))
			draw_circle(hand + d * (160.0 + 650.0 * sk), 14.0 * (1.0 - sk) + 3.0, Color(1.0, 0.95, 0.9, 0.8 * (1.0 - sk)))
	if grow > 0.0 and fade > 0.0:
		var a := _blade_angle()
		var along := Vector2(cos(a) * hero.facing, sin(a))
		var side := Vector2(-along.y, along.x)
		var long := BLADE_LONG * grow
		# รอยฟาดโค้งจางๆ จากมุมเดิมถึงมุมตอนนี้
		if _swing_t < 0.32:
			var trail_k := 1.0 - _swing_t / 0.32
			var steps := 12
			for i in steps:
				var a0 := lerpf(_from, a, float(i) / float(steps))
				var a1 := lerpf(_from, a, float(i + 1) / float(steps))
				var d0 := Vector2(cos(a0) * hero.facing, sin(a0))
				var d1 := Vector2(cos(a1) * hero.facing, sin(a1))
				var kk := trail_k * float(i + 1) / float(steps)
				draw_colored_polygon(PackedVector2Array([hand + d0 * long * 0.15, hand + d0 * long * 1.04, hand + d1 * long * 1.04, hand + d1 * long * 0.15]), Color(1.0, 0.35, 0.33, 0.45 * kk))
				draw_colored_polygon(PackedVector2Array([hand + d0 * long * 0.55, hand + d0 * long, hand + d1 * long, hand + d1 * long * 0.55]), Color(1.0, 0.62, 0.6, 0.7 * kk))
				draw_line(hand + d0 * long, hand + d1 * long, Color(1.0, 0.95, 0.95, 0.8 * kk), 4.0, true)
		var w := BLADE_W * grow * 0.5
		# ออร่ากว้างเรืองรอบใบ
		var glow := PackedVector2Array([hand - side * w * 1.4, hand + along * long * 0.8 - side * w * 1.9, hand + along * long * 1.12, hand + along * long * 0.8 + side * w * 1.9, hand + side * w * 1.4])
		if grow > 0.15:
			draw_colored_polygon(glow, Color(1.0, 0.4, 0.38, 0.22 * fade))
		var blade := PackedVector2Array([hand - side * w * 0.6, hand + along * long * 0.82 - side * w, hand + along * long, hand + along * long * 0.82 + side * w, hand + side * w * 0.6])
		draw_colored_polygon(blade, Color(AURA, AURA.a * fade))
		var inner := PackedVector2Array([hand - side * w * 0.25, hand + along * long * 0.85 - side * w * 0.4, hand + along * long * 0.97, hand + along * long * 0.85 + side * w * 0.4, hand + side * w * 0.25])
		draw_colored_polygon(inner, Color(1.0, 0.7, 0.68, 0.5 * fade))
		draw_line(hand, hand + along * long * 0.97, Color(AURA_EDGE, 0.9 * fade), 5.0, true)
		# รอยอุ้งเท้าเรียงตามใบออร่า หันไปทางปลายดาบ
		var paw_a := along.angle() + PI * 0.5
		for i in 3:
			_kitty_paw(self, hand + along * long * (0.3 + 0.18 * float(i)), w * 0.42, Color(1.0, 0.92, 0.9, 0.75 * fade), paw_a)
		# ประกายพุ่งจากปลายดาบ
		var tip := hand + along * long
		for i in 8:
			var sa := _t * 9.0 + float(i) * 0.8
			var p := tip + Vector2(cos(sa), sin(sa)) * (40.0 + 60.0 * fposmod(_t * 3.0 + float(i) * 0.13, 1.0))
			draw_circle(p, 9.0, Color(1.0, 0.92, 0.88, 0.85 * fade))
		draw_circle(tip, w * 0.9, Color(1.0, 0.85, 0.82, 0.3 * fade))
		# เล็บแมวสามเล็บโค้งที่ปลายดาบ
		for i in 3:
			var off := side * w * (float(i) - 1.0) * 0.45
			var root_p := hand + along * long * 0.9 + off
			draw_colored_polygon(PackedVector2Array([root_p - side * w * 0.12, root_p + along * w * 0.9 + side * w * 0.08, root_p + side * w * 0.12]), Color(AURA_EDGE, 0.9 * fade))
	# เส้นขาวพาดเฉียงขึ้นทั้งจอ
	if _line_t >= 0.0 and _line_t < LINE_LIFE:
		var k := 1.0 - _line_t / LINE_LIFE
		var dir := Vector2(hero.facing, -0.7).normalized()
		var reach := 4000.0
		var mid := hero.position + Vector2(0.0, -150.0)
		var width := 26.0 * minf(_line_t / 0.05, 1.0) * k + 2.0
		draw_line(mid - dir * reach, mid + dir * reach, Color(1.0, 0.6, 0.6, 0.18 * k), width * 8.0, true)
		draw_line(mid - dir * reach, mid + dir * reach, Color(1.0, 1.0, 1.0, 0.35 * k), width * 3.0, true)
		# แสงระเบิดกลางเส้น เม็ดกลมขาวกระจายออก ไม่มีรังสีแหลม
		for i in 16:
			var a := TAU * float(i) / 16.0
			var d := Vector2(cos(a), sin(a))
			draw_circle(mid + d * (300.0 + 700.0 * (1.0 - k)), 18.0 * k + 4.0, Color(1.0, 1.0, 1.0, 0.6 * k))
		draw_circle(mid, 260.0 * k, Color(1.0, 0.95, 0.95, 0.5 * k))
		draw_line(mid - dir * reach, mid + dir * reach, Color(1.0, 1.0, 1.0, k), width, true)
		for i in 9:
			var p := mid + dir * (float(i) - 4.0) * 300.0 + Vector2(-dir.y, dir.x) * (40.0 if i % 2 == 0 else -40.0)
			_kitty_paw(self, p, 30.0, Color(1.0, 0.85, 0.85, 0.8 * k), dir.angle() + PI * 0.5)
