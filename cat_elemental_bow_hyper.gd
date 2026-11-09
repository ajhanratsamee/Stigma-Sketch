class_name CatElementalBowHyper
extends HyperStage
## HYPER ของ ESSENCE WEAVER (CAT MATCHA สาย MANASTARKER) จอดำ กล้องถอยไกล มอนสตั๊น
## กระโดดลอยขึ้นกลางจอ ค้างกลางอากาศ ยกธนูชี้ฟ้า ง้างสายสุดแรง วงแหวนเวท 3 ชั้นซ้อนรอบตัว
## (ไฟแดง น้ำแข็งฟ้าคราม สายฟ้าเหลือง) แล้วหันธนูเฉียงลง ยิงศรยักษ์ปักพื้นด้านหน้า
## ระเบิดวงกว้าง กลายเป็นเสาพลังงานธาตุ 3 สีผสมกันพุ่งทะลวงฟ้า ทำดาเมจต่อเนื่อง ปิดท้ายด้วยระเบิดส่งมอนลอย

const RISE_TIME := 0.85
const AIR_Y := 5.0               # หน่วยเกม ลอยสูงกลางจอ
const BOW_AT := 0.7              # ธนูโผล่ ชี้ฟ้า
const DRAW_FROM := 0.9           # เริ่มง้างสาย
const DRAW_TIME := 0.7
const RING_AT := [1.05, 1.35, 1.65]
const RING_GROW := 0.4
const AIM_FROM := 2.35           # หันธนูจากฟ้ามาเฉียงลงหาจุดปัก
const AIM_TIME := 0.4
const SHOT_AT := 2.85
const FLY_TIME := 0.32
const IMPACT_AT := SHOT_AT + FLY_TIME
const RISE_PILLAR := 0.55        # เสาพุ่งขึ้นจนสุด
const BLAST_TO := 5.65           # เสาทำดาเมจถึงตอนนี้ แล้วระเบิดส่งลอย
const TICK := 0.22
const TICK_DMG := 15.0
const IMPACT_DMG := 60.0
const FINAL_DMG := 90.0
const AHEAD := 650.0             # จุดปักศรด้านหน้า
const PILLAR_W := 430.0
const HIGH := 1900.0
const RING_R := [300.0, 380.0, 460.0]
# สีหลัก MATCHA เขียว แซมพลังสามสี (สายนี้ใช้สามสีเป็นเอกลักษณ์ ปรับเป็นโทนพาสเทล)
const FIRE := Color(1.0, 0.55, 0.4)
const ICE := Color(0.55, 0.85, 1.0)
const BOLT := Color(1.0, 0.9, 0.45)
const COLORS := [FIRE, ICE, BOLT]
const MATCHA := Color(0.45, 0.78, 0.4)
const BOW_WOOD := Color(0.42, 0.62, 0.3)
const BOW_DARK := Color(0.2, 0.32, 0.15)
const INK := Color(0.12, 0.08, 0.1)

var _tick := 0.0
var _target := Vector2.ZERO
var _sparks: Array = []          # [ตำแหน่ง ความเร็ว อายุ สี ขนาด]
var _debris: Array = []          # [ตำแหน่ง ความเร็ว อายุ หมุน]
var _bolts: Array = []
var _bolt_t := 0.0
var _impacted := false
var _launched := false

func _stage_start() -> void:
	open_time = 0.5
	close_from = BLAST_TO + 0.25
	end_time = close_from + 0.55
	Monster.hide_bars = true
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_target = Vector2(hero.position.x + hero.facing * AHEAD, 0.0)
	_bolts = [PackedVector2Array(), PackedVector2Array(), PackedVector2Array()]

func _hit_all(h: Dictionary) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit(h, signf(monster.position.x - _target.x) if monster.position.x != _target.x else hero.facing)

func _hero_y() -> float:
	if _t < close_from:
		return AIR_Y * _ease(_t / RISE_TIME)
	return AIR_Y * (1.0 - _ease((_t - close_from) / 0.45))

## มือถือธนู (จุดภาพในโลก)
func _hand() -> Vector2:
	return hero.position + Vector2(hero.facing * 60.0, -150.0)

## มุมที่ธนูชี้ ชี้ฟ้าก่อน แล้วค่อยหันเฉียงลงหาจุดปัก
func _aim_angle() -> float:
	var up := -PI * 0.5
	var down := (_target - _hand()).angle()
	var k := _ease((_t - AIM_FROM) / AIM_TIME)
	return lerp_angle(up, down, k)

## ง้างสาย 0 ถึง 1 ปล่อยแล้วสายดีดกลับ
func _draw_k() -> float:
	if _t >= SHOT_AT:
		return maxf(0.0, 1.0 - (_t - SHOT_AT) / 0.12)
	return _ease((_t - DRAW_FROM) / DRAW_TIME)

func _ring_k(i: int) -> float:
	var k := clampf((_t - float(RING_AT[i])) / RING_GROW, 0.0, 1.0)
	var out := 1.0 - clampf((_t - IMPACT_AT - 0.3) / 0.5, 0.0, 1.0)
	return (1.0 - pow(1.0 - k, 3.0)) * out

func _pillar_k() -> float:
	if _t < IMPACT_AT:
		return 0.0
	var up := 1.0 - pow(1.0 - clampf((_t - IMPACT_AT) / RISE_PILLAR, 0.0, 1.0), 3.0)
	var fade := 1.0 - clampf((_t - BLAST_TO) / 0.6, 0.0, 1.0)
	return up * fade

func _stage_tick(delta: float) -> void:
	hero.pos.y = _hero_y()
	hero.vel = Vector2.ZERO
	# ประกายธาตุไหลเข้าหาตัวตอนวงแหวนหมุน
	if _t >= RING_AT[0] and _t < SHOT_AT and _sparks.size() < 200:
		for n in 3:
			var a := randf() * TAU
			var c: Color = COLORS[randi() % 3]
			var from := _hand() + Vector2(cos(a), sin(a)) * randf_range(500.0, 800.0)
			_sparks.append([from, (_hand() - from) * 1.6, 0.0, c, randf_range(8.0, 16.0)])
	if _t >= IMPACT_AT and not _impacted:
		_impacted = true
		_shake = 22.0
		_hit_all({"type": "none", "dmg": IMPACT_DMG, "skill": true})
		for n in 40:
			var a := randf_range(PI * 1.05, TAU - 0.05)
			_debris.append([_target + Vector2(randf_range(-80.0, 80.0), -10.0), Vector2(cos(a), sin(a)) * randf_range(500.0, 1300.0), 0.0, randf() * TAU])
	if _impacted and _t < BLAST_TO:
		_tick -= delta
		if _tick <= 0.0:
			_tick = TICK
			_hit_all({"type": "none", "dmg": TICK_DMG, "skill": true})
			_shake = maxf(_shake, 6.0 + 6.0 * _pillar_k())
		if _sparks.size() < 240:
			for n in 6:
				var c2: Color = COLORS[randi() % 3]
				var at := _target + Vector2(randf_range(-PILLAR_W, PILLAR_W) * 0.6, randf_range(-40.0, 10.0))
				_sparks.append([at, Vector2(randf_range(-90.0, 90.0), -randf_range(700.0, 1500.0)), 0.0, c2, randf_range(10.0, 22.0)])
		_bolt_t -= delta
		if _bolt_t <= 0.0:
			_bolt_t = 0.06
			_remake_bolts()
	if _t >= BLAST_TO and not _launched:
		_launched = true
		_shake = 26.0
		_hit_all({"type": "none", "dmg": FINAL_DMG, "skill": true})
	for s in _sparks.duplicate():
		s[2] = float(s[2]) + delta
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
		if float(s[2]) > 1.1:
			_sparks.erase(s)
	for d in _debris.duplicate():
		d[2] = float(d[2]) + delta
		d[1] = (d[1] as Vector2) + Vector2(0.0, 1800.0) * delta
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		d[3] = float(d[3]) + delta * 8.0
		if float(d[2]) > 1.4:
			_debris.erase(d)

func _remake_bolts() -> void:
	var top := -HIGH * _pillar_k()
	for b in _bolts.size():
		var pts := PackedVector2Array()
		var x := _target.x + randf_range(-PILLAR_W * 0.7, PILLAR_W * 0.7)
		var y := -20.0
		pts.append(Vector2(x, y))
		while y > top:
			y -= randf_range(70.0, 150.0)
			x += randf_range(-80.0, 80.0)
			pts.append(Vector2(x, maxf(y, top)))
		_bolts[b] = pts

func _finish() -> void:
	# ระเบิดสุดท้าย ปลดมอนแล้วส่งลอยขึ้น
	for monster in caught:
		if is_instance_valid(monster) and monster.state != "dead":
			monster.frozen = false
			var dir := signf(monster.position.x - _target.x) if monster.position.x != _target.x else hero.facing
			monster.take_hit({"type": "launch", "vy": 11.0, "dmg": 1.0, "skill": true}, dir)
	Monster.hide_bars = false
	hero.pos.y = 0.0
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if is_instance_valid(hero) and hero.plain_model != null:
		hero.plain_model.hide_blade = false
	super._exit_tree()

# ---------------------------------------------------------------- วาด

func _oval(c: Vector2, rx: float, ry: float, n: int = 56) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _paw(at: Vector2, r: float, color: Color) -> void:
	# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
	draw_circle(at, r * 0.75, Color(color, color.a * 0.35 * 1.0))
	draw_circle(at, r * 0.45, Color(color, color.a * 0.7 * 1.0))

func _star(at: Vector2, r: float, color: Color) -> void:
	# ประกายกลมนุ่ม ไม่มีแฉก
	if r < 1.5:
		return
	draw_circle(at, r * 0.75, Color(color, color.a * 0.3))
	draw_circle(at, r * 0.4, color)

func _draw() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.5, 0.0, 1.0)
	_draw_rings(fade, true)
	_draw_pillar(fade)
	_draw_sparks(fade)
	_draw_bow(fade)
	_draw_arrow_flight()
	_draw_rings(fade, false)
	_draw_debris(fade)

## วงแหวนเวท 3 ชั้นรอบตัว เอียงเป็นวงรี หมุนสวนกัน back วาดครึ่งหลังก่อนตัวธนู
func _draw_rings(fade: float, back: bool) -> void:
	var c := hero.position + Vector2(0.0, -110.0)
	for i in 3:
		var k := _ring_k(i)
		if k <= 0.01:
			continue
		var col: Color = COLORS[i]
		var rx: float = float(RING_R[i]) * k
		var ry := rx * (0.32 + 0.06 * float(i))
		var tilt := (0.25 - 0.25 * float(i)) * hero.facing
		var spin := _t * (1.6 - 0.9 * float(i)) * (1.0 if i % 2 == 0 else -1.0)
		var a := fade * k
		draw_set_transform(c, tilt, Vector2.ONE)
		var n := 64
		var half := 32
		var from := 0 if back else half
		var pts := PackedVector2Array()
		var glow := PackedVector2Array()
		for j in range(from, from + half + 1):
			var ang := PI + TAU * float(j) / float(n)
			pts.append(Vector2(cos(ang) * rx, sin(ang) * ry))
			glow.append(Vector2(cos(ang) * rx * 1.04, sin(ang) * ry * 1.06))
		draw_polyline(glow, Color(col, 0.25 * a), 26.0, true)
		draw_polyline(pts, Color(col, 0.95 * a), 9.0, true)
		draw_polyline(pts, Color(1.0, 1.0, 1.0, 0.7 * a), 3.0, true)
		# รอยเท้าแมวกับรูนวิ่งวนบนวง
		for m in 8:
			var ang := spin + TAU * float(m) / 8.0
			var p := Vector2(cos(ang) * rx, sin(ang) * ry)
			var front := sin(ang) > 0.0
			if front == back:
				continue
			if m % 2 == 0:
				_paw(p, 16.0 + 4.0 * float(i), Color(col.lightened(0.4), a))
			else:
				_star(p, 14.0, Color(1.0, 1.0, 1.0, a))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if back and _ring_k(0) > 0.0:
		# แสงฟุ้งรอบตัวตอนชาร์จ
		var glow_k := clampf((_t - RING_AT[0]) / 1.0, 0.0, 1.0) * (1.0 - clampf((_t - SHOT_AT) / 0.4, 0.0, 1.0))
		for k2 in 3:
			draw_circle(c, 180.0 + 90.0 * float(k2), Color(COLORS[k2], 0.07 * glow_k * fade))

## ธนูชี้ตามมุม ง้างสาย มีศรพร้อมยิง หัวศรเรืองแสงชาร์จ
func _draw_bow(fade: float) -> void:
	if _t < BOW_AT:
		return
	var pop := _ease((_t - BOW_AT) / 0.2)
	var a := fade * pop
	var hand := _hand()
	var aim_a := _aim_angle()
	var u := Vector2(cos(aim_a), sin(aim_a))
	var side := u.orthogonal()
	var r := 120.0 * (0.6 + 0.4 * pop)
	# คันธนูโค้ง
	var arc := PackedVector2Array()
	for i in 17:
		var t := -1.0 + 2.0 * float(i) / 16.0
		arc.append(hand + side * t * r + u * (cos(t * PI * 0.5) * r * 0.42))
	draw_polyline(arc, Color(BOW_DARK, a), 16.0, true)
	draw_polyline(arc, Color(BOW_WOOD, a), 10.0, true)
	# หูแมวที่ปลายคันธนูทั้งสองข้าง
	for tip in [arc[0], arc[16]]:
		var out: Vector2 = ((tip as Vector2) - hand).normalized()
		draw_colored_polygon(PackedVector2Array([tip - out.orthogonal() * 12.0, tip + out * 26.0, tip + out.orthogonal() * 12.0]), Color(MATCHA, a))
	draw_circle(hand, 12.0, Color(1.0, 0.85, 0.3, a))
	# สายธนู ดึงกลับตามแรงง้าง
	var nock := hand - u * (20.0 + 110.0 * _draw_k())
	draw_polyline(PackedVector2Array([arc[0], nock, arc[16]]), Color(1.0, 1.0, 1.0, 0.9 * a), 3.0, true)
	if _t < SHOT_AT:
		var charge := clampf((_t - DRAW_FROM) / (SHOT_AT - DRAW_FROM), 0.0, 1.0)
		var head := nock + u * 230.0
		_draw_arrow(nock, head, 1.0, a)
		# หัวศรชาร์จ 3 ธาตุหมุนรอบ
		for k in 3:
			var ang := _t * 9.0 + TAU * float(k) / 3.0
			draw_circle(head + Vector2(cos(ang), sin(ang)) * 34.0 * charge, 14.0 * charge + 2.0, Color(COLORS[k], 0.85 * a))
		draw_circle(head, 70.0 * charge, Color(1.0, 1.0, 1.0, 0.18 * a))
		draw_circle(head, 30.0 * charge, Color(1.0, 1.0, 0.9, 0.8 * a))

## ลูกศร ขนนกปลายเป็นหูแมว หัวศรสามเหลี่ยมเรืองแสง
func _draw_arrow(tail: Vector2, head: Vector2, size: float, a: float) -> void:
	var u := (head - tail).normalized()
	var side := u.orthogonal()
	draw_line(tail, head - u * 30.0 * size, Color(0.55, 0.38, 0.2, a), 8.0 * size, true)
	draw_colored_polygon(PackedVector2Array([head, head - u * 46.0 * size + side * 22.0 * size, head - u * 34.0 * size, head - u * 46.0 * size - side * 22.0 * size]), Color(0.95, 0.98, 1.0, a))
	for s in [-1.0, 1.0]:
		draw_colored_polygon(PackedVector2Array([tail + u * 6.0 * size, tail + side * s * 26.0 * size - u * 18.0 * size, tail + u * 40.0 * size]), Color(MATCHA, a))
		draw_colored_polygon(PackedVector2Array([tail + u * 12.0 * size, tail + side * s * 15.0 * size - u * 6.0 * size, tail + u * 30.0 * size]), Color(1.0, 0.7, 0.8, a))

## ศรยักษ์พุ่งเฉียงลงหาจุดปัก หางพลังสามสี
func _draw_arrow_flight() -> void:
	if _t < SHOT_AT or _t > IMPACT_AT + 0.25:
		return
	var k := clampf((_t - SHOT_AT) / FLY_TIME, 0.0, 1.0)
	var from := _hand()
	var u := (_target - from).normalized()
	var head := from.lerp(_target, k * k)
	var stuck := _t >= IMPACT_AT
	var a := 1.0 - clampf((_t - IMPACT_AT) / 0.25, 0.0, 1.0)
	for i in 3:
		var off := u.orthogonal() * (float(i) - 1.0) * 26.0
		draw_line(from.lerp(head, 0.15) + off, head + off, Color(COLORS[i], 0.55 * a), 30.0, true)
	draw_line(from.lerp(head, 0.3), head, Color(1.0, 1.0, 1.0, 0.8 * a), 12.0, true)
	var tail := head - u * 520.0
	_draw_arrow(tail, head + (u * 60.0 if stuck else Vector2.ZERO), 3.2, a)

## ระเบิดวงกว้างที่พื้น และเสาพลังงานธาตุ 3 สีผสมพุ่งขึ้นฟ้า
func _draw_pillar(fade: float) -> void:
	if _t < IMPACT_AT:
		return
	var since := _t - IMPACT_AT
	var pk := _pillar_k()
	var c := _target
	# วงช็อกบนพื้น 3 สีขยายออก
	for i in 3:
		var k := clampf((since - float(i) * 0.08) / 0.7, 0.0, 1.0)
		if k <= 0.0 or k >= 1.0:
			continue
		var rx := 200.0 + 1300.0 * k
		var ring := _oval(c, rx, rx * 0.2)
		ring.append(ring[0])
		draw_polyline(ring, Color(COLORS[i], (1.0 - k) * fade), 18.0 * (1.0 - k) + 3.0, true)
	# แสงระเบิดแวบแรก
	var flash := 1.0 - clampf(since / 0.35, 0.0, 1.0)
	if flash > 0.0:
		draw_circle(c + Vector2(0.0, -120.0), 700.0 * (1.0 - flash * 0.4), Color(1.0, 1.0, 0.95, 0.35 * flash))
		for i in 14:
			var ang := PI + PI * float(i) / 13.0
			var tip := c + Vector2(cos(ang), sin(ang) * 0.9) * 1300.0 * (1.0 - flash * 0.6)
			draw_colored_polygon(PackedVector2Array([c + Vector2(cos(ang + 1.57), 0.0) * 30.0, tip, c - Vector2(cos(ang + 1.57), 0.0) * 30.0]), Color(COLORS[i % 3].lightened(0.4), 0.6 * flash))
	if pk <= 0.01:
		return
	var top := -HIGH * pk
	var w := PILLAR_W * (0.7 + 0.3 * pk) * (1.0 + 0.04 * sin(_t * 30.0))
	# แสงฟุ้งรอบเสา ไล่จางออกด้านข้าง
	for k in 3:
		var ww := w * (2.4 - 0.45 * float(k))
		var col := Color(COLORS[k], 0.16 * fade)
		var clear := Color(COLORS[k], 0.0)
		for s2 in [-1.0, 1.0]:
			draw_polygon(PackedVector2Array([Vector2(c.x, top), Vector2(c.x + s2 * ww, top), Vector2(c.x + s2 * ww, 0.0), Vector2(c.x, 0.0)]), PackedColorArray([col, clear, clear, col]))
	draw_colored_polygon(_oval(c, w * 1.6, w * 0.3), Color(1.0, 0.95, 0.85, 0.35 * fade))
	# ตัวเสา ไล่สีสามธาตุเป็นแถบ
	var inner := Color(0.95, 0.9, 1.0, 0.45 * fade)
	var edge := Color(0.95, 0.9, 1.0, 0.0)
	for s3 in [-1.0, 1.0]:
		draw_polygon(PackedVector2Array([Vector2(c.x, top), Vector2(c.x + s3 * w, top), Vector2(c.x + s3 * w, 0.0), Vector2(c.x, 0.0)]), PackedColorArray([inner, edge, edge, inner]))
	# เกลียวพลังสามสีพันรอบเสา
	for i in 3:
		var pts := PackedVector2Array()
		var steps := 26
		for j in steps + 1:
			var y := top * float(j) / float(steps)
			var ph := _t * 8.0 + float(i) * TAU / 3.0 + y * 0.012
			pts.append(Vector2(c.x + sin(ph) * w * 0.85, y))
		draw_polyline(pts, Color(COLORS[i], 0.85 * fade), 34.0, true)
		draw_polyline(pts, Color(COLORS[i].lightened(0.5), 0.9 * fade), 10.0, true)
	var core := Color(1.0, 1.0, 1.0, 0.9 * fade)
	var core_edge := Color(1.0, 1.0, 1.0, 0.15 * fade)
	for s4 in [-1.0, 1.0]:
		draw_polygon(PackedVector2Array([Vector2(c.x, top), Vector2(c.x + s4 * w * 0.34, top), Vector2(c.x + s4 * w * 0.34, 0.0), Vector2(c.x, 0.0)]), PackedColorArray([core, core_edge, core_edge, core]))
	# สายฟ้าแตกออกรอบเสา
	for b in _bolts:
		if (b as PackedVector2Array).size() > 1:
			draw_polyline(b, Color(BOLT, 0.9 * fade), 7.0, true)
			draw_polyline(b, Color(1.0, 1.0, 1.0, fade), 2.5, true)
	# ยอดเสาเป็นหัวแมวแสง หูสองข้าง
	var head := Vector2(c.x, top)
	draw_circle(head, w * 0.75, Color(1.0, 1.0, 1.0, 0.5 * fade))
	for s in [-1.0, 1.0]:
		draw_colored_polygon(PackedVector2Array([head + Vector2(s * w * 0.25, -w * 0.3), head + Vector2(s * w * 0.75, -w * 1.15), head + Vector2(s * w * 0.85, -w * 0.15)]), Color(1.0, 0.95, 0.8, 0.8 * fade))
	# เปลวไฟกับผลึกน้ำแข็งที่ฐานเสา
	for i in 8:
		var x := c.x + (float(i) / 7.0 - 0.5) * w * 2.4
		var h := 160.0 + 120.0 * sin(_t * 12.0 + float(i) * 1.7)
		if i % 2 == 0:
			draw_colored_polygon(PackedVector2Array([Vector2(x - 34.0, 0.0), Vector2(x, -h), Vector2(x + 34.0, 0.0)]), Color(FIRE, 0.8 * fade))
		else:
			draw_colored_polygon(PackedVector2Array([Vector2(x - 26.0, 0.0), Vector2(x - 8.0, -h * 0.9), Vector2(x, -h * 1.1), Vector2(x + 26.0, 0.0)]), Color(ICE, 0.85 * fade))
	_paw(c + Vector2(0.0, -20.0), w * 0.35, Color(1.0, 1.0, 1.0, 0.5 * fade))

func _draw_sparks(fade: float) -> void:
	for s in _sparks:
		var k: float = float(s[2]) / 1.1
		var col: Color = s[3]
		var at: Vector2 = s[0]
		var r: float = float(s[4]) * (1.0 - k * 0.6)
		if int(r * 10.0) % 3 == 0:
			_star(at, r * 1.4, Color(col.lightened(0.3), (1.0 - k) * fade))
		else:
			draw_circle(at, r, Color(col, (1.0 - k) * fade))

func _draw_debris(fade: float) -> void:
	for d in _debris:
		var k: float = float(d[2]) / 1.4
		var at: Vector2 = d[0]
		var rot: float = d[3]
		var col := Color(0.55, 0.45, 0.35, (1.0 - k) * fade)
		draw_set_transform(at, rot, Vector2.ONE)
		draw_colored_polygon(PackedVector2Array([Vector2(-18.0, -10.0), Vector2(14.0, -16.0), Vector2(20.0, 8.0), Vector2(-10.0, 14.0)]), col)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
