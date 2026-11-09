class_name CatGuardHyper
extends HyperStage
## HYPER ของ GUARDIAN KNIGHT จอเป็นแบบภาพ กล้องถอยไกล มอนสตั๊น
## ตะโกนวงกว้าง 1 ฮิต กระโดดขึ้นกลางจอ ตะโกนรอบตัวรุนแรง 15 ฮิต
## ฮิตสุดท้ายดีดขึ้นนิดหน่อย กางโล่ยักษ์ทุ่มลงพื้น พื้นแตกกระจายวงกว้าง 1 จอ

const FIRST_AT := 0.7
const JUMP_FROM := 1.0
const JUMP_TO := 1.4
const AIR_Y := 6.0               # หน่วยเกม
const SHOUTS := 15
const SHOUT_FROM := 1.5
const SHOUT_GAP := 0.13
const HOP_AT := 3.6
const SLAM_AT := 3.9
const SHIELD_R := 75.0           # โล่ปกติของตัวละคร ขนาดเท่ามือถือ
const SHOUT_DMG := 18.0
const SLAM_DMG := 160.0

var _shouts := 0
var _first := false
var _slammed := false

var _shouts_fx: Array = []

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = SLAM_AT + 1.0
	end_time = close_from + 0.45
	Monster.hide_bars = true

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _shout_fx(reach: float) -> void:
	var s := CatShout.new()
	s.reach = reach
	s.color = Color(1.0, 0.3, 0.25)
	s.ring_round = true
	s.position = hero.position
	page.world.add_child(s)
	# ซ่อนดาวกับรังสีรอบคลื่นเสียง (ผู้ใช้ไม่เอาดาวหลายแฉก)
	_shouts_fx.append(s)

func _hero_y() -> float:
	if _t < JUMP_FROM:
		return 0.0
	if _t < JUMP_TO:
		return AIR_Y * _ease((_t - JUMP_FROM) / (JUMP_TO - JUMP_FROM))
	if _t < HOP_AT:
		return AIR_Y
	if _t < SLAM_AT:
		return AIR_Y + 1.5 * sin((_t - HOP_AT) / (SLAM_AT - HOP_AT) * PI * 0.5)
	return maxf(AIR_Y + 1.5 - (_t - SLAM_AT) * 60.0, 0.0)

func _stage_tick(_delta: float) -> void:
	for s in _shouts_fx:
		if is_instance_valid(s):
			for ch in (s as Node).get_children():
				if ch is Node2D and ch.get("front") == true and ch.get("_t") != null:
					(ch as Node2D).visible = false
	hero.pos.y = _hero_y()
	hero.vel = Vector2.ZERO
	# ตอนตะโกนซ่อนดาบ
	if hero.plain_model != null:
		hero.plain_model.hide_blade = _t >= FIRST_AT - 0.1
	if not _first and _t >= FIRST_AT:
		_first = true
		_shout_fx(1600.0)
		_hit_all(SHOUT_DMG)
		_shake = 10.0
	while _shouts < SHOUTS and _t >= SHOUT_FROM + float(_shouts) * SHOUT_GAP:
		_shouts += 1
		_shout_fx(900.0)
		_hit_all(SHOUT_DMG)
		_shake = 8.0
	if not _slammed and _t >= SLAM_AT + 0.12:
		_slammed = true
		_hit_all(SLAM_DMG)
		_shake = 22.0
		for side in [-1.0, 0.0, 1.0]:
			var crack := CatCrack.new()
			crack.big = true
			crack.no_rays = true
			crack.position = Vector2(hero.position.x + side * 600.0, 0.0)
			page.world.add_child(crack)

func _finish() -> void:
	Monster.hide_bars = false
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
	hero.pos.y = 0.0
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	super._exit_tree()

## โล่ปกติของตัวละคร เหล็กกลม ขอบเทา ปุ่มกลาง ลายกากบาทสีน้ำเงิน มีแสงแดงเรืองรอบตอนทุ่ม
func _shield(c: Vector2, r: float, alpha: float) -> void:
	draw_circle(c, r * 1.5, Color(1.0, 0.25, 0.2, 0.3 * alpha))
	_kitty_ears(self, c, r, Color(0.4, 0.42, 0.48, alpha), Color(1.0, 0.65, 0.72, alpha))
	draw_circle(c, r, Color(0.78, 0.8, 0.86, alpha))
	draw_arc(c, r, 0.0, TAU, 40, Color(0.4, 0.42, 0.48, alpha), r * 0.12, true)
	# ตราอุ้งเท้าแมวกลางโล่ แทนกากบาท
	_kitty_paw(self, c + Vector2(0.0, r * 0.05), r * 0.62, Color(1.0, 0.55, 0.65, alpha))
	_kitty_paw(self, c + Vector2(0.0, r * 0.05), r * 0.42, Color(1.0, 0.75, 0.8, alpha))

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

## ออร่าแดงรอบตัวตอนตะโกน รังสีหมุน วงแสงบนพื้น
func _draw_roar_aura() -> void:
	if _t < FIRST_AT or _t >= SLAM_AT + 0.2:
		return
	var c := hero.position + Vector2(0.0, -80.0)
	var pk := fposmod(_t, SHOUT_GAP) / SHOUT_GAP
	draw_circle(c, 260.0 + 40.0 * sin(_t * 30.0), Color(1.0, 0.3, 0.25, 0.14))
	for n in 0:
		var a := _t * 1.5 + TAU * float(n) / 18.0
		var d := Vector2(cos(a), sin(a))
		var sd := Vector2(-d.y, d.x) * 30.0
		var lo := Color(1.0, 0.45, 0.35, 0.35)
		var hi := Color(1.0, 0.45, 0.35, 0.0)
		draw_polygon(PackedVector2Array([c + d * 120.0 - sd, c + d * 120.0 + sd, c + d * (700.0 + 200.0 * sin(_t * 9.0 + float(n)))]), PackedColorArray([lo, lo, hi]))
	for n in 2:
		var kk := fposmod(pk + float(n) * 0.5, 1.0)
		draw_arc(c, 150.0 + 700.0 * kk, 0.0, TAU, 56, Color(1.0, 0.75, 0.65, 0.7 * (1.0 - kk)), 14.0 * (1.0 - kk) + 2.0, true)
	var g := PackedVector2Array()
	for n in 40:
		var a := TAU * float(n) / 40.0
		g.append(Vector2(hero.position.x + cos(a) * 900.0, sin(a) * 120.0))
	draw_colored_polygon(g, Color(1.0, 0.35, 0.3, 0.16))

## โล่ยักษ์เงาโปร่งด้านหลังโล่จริง หูแมว ตราอุ้งเท้า
func _ghost_shield(c: Vector2, r: float, alpha: float) -> void:
	if alpha <= 0.0:
		return
	draw_circle(c, r * 1.25, Color(1.0, 0.3, 0.25, 0.12 * alpha))
	_kitty_ears(self, c, r, Color(1.0, 0.45, 0.4, 0.3 * alpha), Color(1.0, 0.7, 0.75, 0.3 * alpha))
	draw_circle(c, r, Color(1.0, 0.55, 0.5, 0.22 * alpha))
	draw_arc(c, r, 0.0, TAU, 64, Color(1.0, 0.85, 0.8, 0.8 * alpha), 12.0, true)
	draw_arc(c, r * 0.8, 0.0, TAU, 56, Color(1.0, 0.6, 0.55, 0.5 * alpha), 6.0, true)
	_kitty_paw(self, c + Vector2(0.0, r * 0.05), r * 0.6, Color(1.0, 0.75, 0.8, 0.45 * alpha))

func _draw() -> void:
	_draw_roar_aura()
	if _t < HOP_AT:
		return
	var fade := 1.0 - clampf((_t - close_from) / 0.3, 0.0, 1.0)
	# ชูโล่เหนือหัวตอนดีดขึ้น แล้วทุ่มลงพร้อมตัวจนกระแทกพื้น
	var hold := hero.position + Vector2(hero.facing * 30.0, -210.0)
	var giant := SHIELD_R * 5.5
	if _t < SLAM_AT:
		var open := clampf((_t - HOP_AT) / 0.2, 0.0, 1.0)
		_ghost_shield(hold + Vector2(0.0, -giant * 0.6 * open), giant * open, fade)
		_shield(hold, SHIELD_R, fade)
	else:
		var k := clampf((_t - SLAM_AT) / 0.12, 0.0, 1.0)
		var at := hero.position + Vector2(hero.facing * 70.0, -SHIELD_R)
		_shield(hold.lerp(at, k) if hero.position.y < -5.0 else at, SHIELD_R, fade)
		if k < 1.0:
			_ghost_shield(hold.lerp(Vector2(hero.position.x + hero.facing * 70.0, -giant), k), giant, fade)
		if k >= 1.0:
			var age := _t - SLAM_AT - 0.12
			var w := clampf(age / 0.3, 0.0, 1.0)
			# โล่ยักษ์กระแทกพื้นแล้วจางหาย
			_ghost_shield(Vector2(hero.position.x + hero.facing * 70.0, -giant * (1.0 - 0.15 * w)), giant * (1.0 + 0.2 * w), fade * (1.0 - w))
			# เสาแสงตรงจุดกระแทก รังสีแผ่
			var pf := clampf(1.0 - age / 0.5, 0.0, 1.0)
			if pf > 0.0:
				var lo := Color(1.0, 0.85, 0.75, 0.6 * pf)
				var hi := Color(1.0, 0.6, 0.5, 0.0)
				draw_polygon(PackedVector2Array([Vector2(hero.position.x - 300.0, 0.0), Vector2(hero.position.x + 300.0, 0.0), Vector2(hero.position.x + 120.0, -2400.0), Vector2(hero.position.x - 120.0, -2400.0)]), PackedColorArray([lo, lo, hi, hi]))
				for n in 0:
					var a := PI + PI * (float(n) + 0.5) / 16.0
					var d := Vector2(cos(a), sin(a))
					draw_line(Vector2(hero.position.x, -40.0) + d * 150.0, Vector2(hero.position.x, -40.0) + d * (600.0 + 1400.0 * (1.0 - pf)), Color(1.0, 0.9, 0.8, 0.7 * pf), 10.0 * pf + 2.0, true)
			# เศษหินกระเด็นและฝุ่นฟุ้งสองข้าง
			var dk := clampf(age / 0.9, 0.0, 1.0)
			if dk < 1.0:
				for n in 14:
					var side := -1.0 if n % 2 == 0 else 1.0
					var vx := side * (500.0 + 140.0 * float(n))
					var vy := -900.0 - 90.0 * float(n % 5)
					var tt := age
					var p := Vector2(hero.position.x + vx * tt, vy * tt + 1800.0 * tt * tt)
					if p.y < 0.0:
						var rs := 18.0 + 6.0 * float(n % 3)
						# เศษหินกลมมน
						draw_circle(p, rs * 0.75, Color(0.55, 0.42, 0.38, 1.0 - dk))
						draw_circle(p + Vector2(-rs * 0.25, -rs * 0.25), rs * 0.25, Color(0.8, 0.7, 0.66, 0.6 * (1.0 - dk)))
				for n in 8:
					var side := -1.0 if n % 2 == 0 else 1.0
					var dist := (200.0 + 260.0 * floorf(float(n) * 0.5)) * (0.4 + 0.6 * dk)
					draw_circle(Vector2(hero.position.x + side * dist, -50.0 - 40.0 * dk), 90.0 + 80.0 * dk, Color(0.9, 0.82, 0.75, 0.45 * (1.0 - dk)))
			draw_line(Vector2(hero.position.x - 1500.0 * w, 0.0), Vector2(hero.position.x + 1500.0 * w, 0.0), Color(1.0, 0.95, 0.85, 0.8 * (1.0 - w)), 30.0, true)
			for n in 6:
				var side := -1.0 if n % 2 == 0 else 1.0
				var dist := (300.0 + 400.0 * floorf(float(n) * 0.5)) * w
				_kitty_paw(self, Vector2(hero.position.x + side * dist, -30.0 - 60.0 * w), 46.0, Color(1.0, 0.6, 0.65, 0.85 * (1.0 - w)), side * 0.5)
