class_name CatFlameHyper
extends HyperStage
## HYPER ของ FLAME KNIGHT จอเป็นแบบภาพ กล้องถอยไกล มอนสตั๊น
## ลูกไฟยักษ์ลอยเหนือหัวเลยขอบจอด้านบน ค่อยๆ ตกลงมาช้าๆ ถึงพื้นยังไม่ระเบิด ทำดาเมจต่อ
## บีบอัดเล็กลงเรื่อยๆ แล้วระเบิดหลายฮิตต่อเนื่อง

const BIG := 760.0
const SMALL := 260.0
const START_Y := -2800.0
const FALL_FROM := 0.6
const FALL_TO := 3.2
const SQUEEZE_TO := 5.0
const BOOM_HITS := 6
const BOOM_GAP := 0.13
const TICK := 0.2
const TICK_DMG := 15.0
const BOOM_DMG := 45.0

var _ball: CatFireball
var _tick := 0.0
var _booms := 0
var _boom_t := -1.0

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = SQUEEZE_TO + float(BOOM_HITS) * BOOM_GAP + 0.6
	end_time = close_from + 0.45
	Monster.hide_bars = true
	# ซ่อนดาบตลอดท่าจนจบ
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_ball = CatFireball.new()
	_ball.radius = BIG
	_ball.position = Vector2(hero.position.x, START_Y)
	page.world.add_child(_ball)

## ซ่อนประกายดาวที่ลอยรอบลูกไฟ เหลือแค่แสงฟุ้งด้านหลัง
func _no_stars(node) -> void:
	if not is_instance_valid(node):
		return
	for ch in node.get_children():
		if ch is Node2D and ch.get("front") == true and ch.get("_t") != null:
			(ch as Node2D).visible = false

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _stage_tick(delta: float) -> void:
	_no_stars(_ball)
	if is_instance_valid(_ball) and _boom_t < 0.0:
		var ground_y := -BIG
		if _t < FALL_TO:
			var k := clampf((_t - FALL_FROM) / (FALL_TO - FALL_FROM), 0.0, 1.0)
			_ball.position.y = lerpf(START_Y, ground_y, k * k * (3.0 - 2.0 * k))
		else:
			# ถึงพื้นแล้ว บีบอัดเล็กลงเรื่อยๆ ไฟสั่นแรงขึ้น
			var k := clampf((_t - FALL_TO) / (SQUEEZE_TO - FALL_TO), 0.0, 1.0)
			_ball.radius = lerpf(BIG, SMALL, k * k)
			_ball.position.y = -_ball.radius + sin(_t * 60.0) * 6.0 * k
			_shake = maxf(_shake, 4.0 * k)
			_tick -= delta
			if _tick <= 0.0:
				_tick = TICK
				_hit_all(TICK_DMG)
			if _t >= SQUEEZE_TO:
				_boom_t = 0.0
				_ball.burst()
	if _boom_t >= 0.0:
		_boom_t += delta
		while _booms < BOOM_HITS and _boom_t >= float(_booms) * BOOM_GAP:
			_booms += 1
			_hit_all(BOOM_DMG)
			_shake = 16.0

func _finish() -> void:
	Monster.hide_bars = false
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
	if is_instance_valid(_ball):
		_ball.queue_free()
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	super._exit_tree()

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

## ก่อนระเบิด แสงร้อนรอบลูกไฟ รังสีหมุน ลูกไฟเล็กโคจร แสงส้มบนพื้นโตขึ้นตามที่ลูกใกล้พื้น
func _draw_charge() -> void:
	if not is_instance_valid(_ball) or _t < FALL_FROM * 0.5:
		return
	var c := _ball.position
	var r := _ball.radius
	var near := clampf(1.0 - (-c.y - r) / 1600.0, 0.0, 1.0)
	var heat := clampf((_t - FALL_TO) / (SQUEEZE_TO - FALL_TO), 0.0, 1.0)
	# แสงบนพื้นใต้ลูกไฟ
	var gx := Vector2(c.x, 0.0)
	for n in 3:
		var k := 1.0 - float(n) * 0.28
		var pts := PackedVector2Array()
		for i in 40:
			var a := TAU * float(i) / 40.0
			pts.append(gx + Vector2(cos(a) * r * 2.4 * k, sin(a) * r * 0.32 * k))
		draw_colored_polygon(pts, Color(1.0, 0.42 + 0.1 * float(n), 0.36, (0.12 + 0.08 * float(n)) * (0.3 + 0.7 * near)))
	# รังสีความร้อนรอบลูกเอาออก (ผู้ใช้ไม่เอาดาวหลายแฉก)
	for n in 0:
		var a := _t * 0.8 + TAU * float(n) / 14.0
		var d := Vector2(cos(a), sin(a))
		var sd := Vector2(-d.y, d.x) * r * 0.1
		var lo := Color(1.0, 0.7, 0.3, (0.18 + 0.25 * heat))
		var hi := Color(1.0, 0.6, 0.2, 0.0)
		draw_polygon(PackedVector2Array([c + d * r * 0.95 - sd, c + d * r * 0.95 + sd, c + d * r * (1.8 + 0.6 * heat + 0.2 * sin(_t * 6.0 + float(n)))]), PackedColorArray([lo, lo, hi]))
	# ลูกไฟเล็กหน้าแมวโคจรรอบ
	for n in 6:
		var a := -_t * 2.2 + TAU * float(n) / 6.0
		var p := c + Vector2(cos(a) * r * 1.35, sin(a) * r * 0.5)
		draw_circle(p, r * 0.12, Color(1.0, 0.5, 0.15, 0.85))
		draw_circle(p, r * 0.07, Color(1.0, 0.9, 0.5, 0.9))
		_kitty_ears(self, p, r * 0.12, Color(1.0, 0.5, 0.15, 0.85), Color(1.0, 0.85, 0.4, 0.9))
	# ตอนบีบอัด วงแสงหดเข้าหาลูก
	if heat > 0.0:
		var pk := fposmod(_t * 2.5, 1.0)
		draw_arc(c, r * (2.6 - 1.5 * pk), 0.0, TAU, 64, Color(1.0, 0.9, 0.6, 0.7 * pk * heat), 10.0, true)

func _draw() -> void:
	if _boom_t < 0.0:
		_draw_charge()
		return
	var c := Vector2(hero.position.x, -SMALL)
	# เสาไฟพุ่งขึ้นฟ้าเป็นดอกเห็ด
	var col_k := clampf(_boom_t / 0.5, 0.0, 1.0)
	var col_fade := 1.0 - clampf((_boom_t - 0.6) / 0.6, 0.0, 1.0)
	if col_fade > 0.0:
		var top := -2600.0 * col_k
		var lo := Color(1.0, 0.45, 0.38, 0.55 * col_fade)
		var hi := Color(1.0, 0.7, 0.4, 0.0)
		draw_polygon(PackedVector2Array([Vector2(c.x - 420.0, 0.0), Vector2(c.x + 420.0, 0.0), Vector2(c.x + 220.0, top), Vector2(c.x - 220.0, top)]), PackedColorArray([lo, lo, hi, hi]))
		draw_circle(Vector2(c.x, top * 0.85), 380.0 * col_k, Color(1.0, 0.45, 0.38, 0.35 * col_fade))
	# รังสีระเบิดพุ่งออกรอบทิศ
	var ray_fade := 0.0  # เอารังสีดาวหลายแฉกออก
	if ray_fade > 0.0:
		for n in 20:
			var a := TAU * float(n) / 20.0 + 0.15
			var d := Vector2(cos(a), sin(a))
			var sd := Vector2(-d.y, d.x) * 70.0
			var reach := 900.0 + 1800.0 * (1.0 - ray_fade)
			var lo := Color(1.0, 0.95, 0.7, 0.6 * ray_fade)
			var hi := Color(1.0, 0.7, 0.3, 0.0)
			draw_polygon(PackedVector2Array([c + d * 150.0 - sd, c + d * 150.0 + sd, c + d * reach]), PackedColorArray([lo, lo, hi]))
	for n in BOOM_HITS:
		var age := _boom_t - float(n) * BOOM_GAP
		if age < 0.0:
			continue
		var k := clampf(age / 0.5, 0.0, 1.0)
		var r := 260.0 + 2200.0 * k
		draw_circle(c, r, Color(1.0, 0.45 - 0.1 * k, 0.38, 0.25 * (1.0 - k)))
		draw_arc(c, r, 0.0, TAU, 72, Color(1.0, 0.9, 0.6, 0.85 * (1.0 - k)), 20.0 * (1.0 - k) + 2.0, true)
		draw_arc(c, r * 0.8, 0.0, TAU, 64, Color(1.0, 0.55, 0.2, 0.6 * (1.0 - k)), 8.0 * (1.0 - k) + 1.0, true)
	# วงไหม้บนพื้น
	var scorch := 1.0 - clampf((_boom_t - 0.5) / 0.9, 0.0, 1.0)
	if scorch > 0.0:
		var pts := PackedVector2Array()
		for i in 48:
			var a := TAU * float(i) / 48.0
			pts.append(Vector2(c.x + cos(a) * 1500.0 * col_k, sin(a) * 160.0 * col_k))
		if col_k > 0.05:
			draw_colored_polygon(pts, Color(0.86, 0.33, 0.28, 0.25 * scorch))
	# รอยอุ้งเท้าไฟพุ่งออกรอบระเบิด
	var spread := clampf(_boom_t / 0.9, 0.0, 1.0)
	if spread < 1.0:
		for n in 20:
			var a := TAU * float(n) / 20.0 + 0.3
			var p := c + Vector2(cos(a), sin(a) * 0.7) * (300.0 + (1100.0 + 500.0 * float(n % 2)) * spread)
			_kitty_paw(self, p, (80.0 - 25.0 * float(n % 2)) * (1.0 - spread * 0.5), Color(1.0, 0.7, 0.3, 0.85 * (1.0 - spread)), a + PI * 0.5)
	var flash := clampf(1.0 - _boom_t / 0.25, 0.0, 1.0)
	draw_circle(c, 1300.0, Color(1.0, 0.95, 0.85, 0.25 * flash))   # แฟลชจางลง สบายตา
	draw_circle(c, 500.0, Color(1.0, 0.97, 0.9, 0.35 * flash))
