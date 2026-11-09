class_name CatElementHyper
extends HyperStage
## HYPER ของ ELEMENT MASTER (CAT SUSI) จอดำ กล้องถอยไกล มอนสตั๊น
## ชูคฑาเรียกวงเวทใหญ่ 3 วงบนพื้นด้านหน้า เรียงเป็นสามเหลี่ยม วงหลังกลาง วงหน้าซ้ายขวา
## วงไฟ วงน้ำแข็ง วงไฟฟ้า แล้วพลังแต่ละธาตุค่อยๆ พุ่งขึ้นจากวงเป็นเสาสูง ทำดาเมจต่อเนื่อง

const CIRCLE_FROM := 0.5
const CIRCLE_GAP := 0.3          # วงเวทขึ้นทีละวง
const CIRCLE_GROW := 0.45
const RISE_FROM := 1.7
const RISE_TIME := 2.2           # เสาพลังค่อยๆ สูงขึ้นจนสุด
const BLAST_TIME := 5.0          # ทำดาเมจต่อเนื่องนานเท่านี้
const TICK := 0.25
const TICK_DMG := 14.0
const AHEAD := 1050.0            # กึ่งกลางสามเหลี่ยมอยู่หน้าตัวละคร
const SPREAD_X := 640.0
const BACK_Y := -170.0           # วงหลังอยู่ลึกเข้าไป สูงกว่าบนจอ
const FRONT_Y := 110.0
const RX := 540.0
const RY_K := 0.24
const HIGH := 1550.0
# สีหลักม่วงอ่อนของ CAT SUSI ธาตุเป็นสีแซมแบบพาสเทล ให้เข้าชุดกัน
const LILAC := Color(0.74, 0.6, 0.9)
const FIRE := Color(1.0, 0.55, 0.45)
const ICE := Color(0.6, 0.8, 1.0)
const BOLT := Color(1.0, 0.9, 0.55)
## [ธาตุ สี ตำแหน่งสัมพัทธ์]
const CIRCLES := [["ice", ICE, Vector2(0.0, BACK_Y)], ["fire", FIRE, Vector2(-SPREAD_X, FRONT_Y)], ["bolt", BOLT, Vector2(SPREAD_X, FRONT_Y)]]

var _tick := 0.0
var _sparks: Array = []          # [ตำแหน่ง ความเร็ว อายุ ธาตุ ขนาด]
var _bolts: Array = []           # เส้นสายฟ้าที่สุ่มใหม่เป็นระยะ
var _bolt_t := 0.0

func _stage_start() -> void:
	open_time = 0.5
	close_from = RISE_FROM + BLAST_TIME
	end_time = close_from + 0.45
	Monster.hide_bars = true
	_bolts = [PackedVector2Array(), PackedVector2Array(), PackedVector2Array()]

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _center(i: int) -> Vector2:
	var off: Vector2 = CIRCLES[i][2]
	return Vector2(hero.position.x + hero.facing * AHEAD + off.x, off.y)

func _grow(i: int) -> float:
	var k := clampf((_t - CIRCLE_FROM - float(i) * CIRCLE_GAP) / CIRCLE_GROW, 0.0, 1.0)
	return 1.0 - pow(1.0 - k, 3.0)

func _rise() -> float:
	var k := clampf((_t - RISE_FROM) / RISE_TIME, 0.0, 1.0)
	return k * k * (3.0 - 2.0 * k)

func _fade() -> float:
	return 1.0 - clampf((_t - close_from) / 0.4, 0.0, 1.0)

func _stage_tick(delta: float) -> void:
	if _t >= RISE_FROM and _t < close_from:
		_tick -= delta
		if _tick <= 0.0:
			_tick = TICK
			_hit_all(TICK_DMG)
			_shake = maxf(_shake, 4.0 + 5.0 * _rise())
		# เศษพลังแต่ละธาตุลอยขึ้นตามเสา
		for i in 3:
			for n in (4 if _sparks.size() < 260 else 0):
				var c := _center(i)
				var at := c + Vector2(randf_range(-RX, RX) * 0.6, randf_range(-RX, RX) * RY_K * 0.5)
				var kind: String = CIRCLES[i][0]
				var up := randf_range(500.0, 1100.0)
				_sparks.append([at, Vector2(randf_range(-60.0, 60.0), -up), 0.0, kind, randf_range(8.0, 20.0)])
		_bolt_t -= delta
		if _bolt_t <= 0.0:
			_bolt_t = 0.06
			_remake_bolts()
	for s in _sparks.duplicate():
		s[2] += delta
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
		if s[2] > 1.2:
			_sparks.erase(s)

## สายฟ้าซิกแซกพุ่งจากวงไฟฟ้าขึ้นฟ้า สุ่มใหม่ทุก 0.06 วิ
func _remake_bolts() -> void:
	var c := _center(2)
	var top := -HIGH * _rise()
	for b in _bolts.size():
		var pts := PackedVector2Array()
		var x := c.x + randf_range(-RX * 0.5, RX * 0.5)
		var y := c.y
		pts.append(Vector2(x, y))
		while y > top:
			y -= randf_range(60.0, 130.0)
			x += randf_range(-70.0, 70.0)
			pts.append(Vector2(x, maxf(y, top)))
		_bolts[b] = pts

func _finish() -> void:
	Monster.hide_bars = false
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	super._exit_tree()

func _oval(c: Vector2, rx: float, ry: float, n: int = 64) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _ring(c: Vector2, rx: float, ry: float, color: Color, width: float) -> void:
	var pts := _oval(c, rx, ry)
	pts.append(pts[0])
	draw_polyline(pts, color, width, true)

## วงเวทบนพื้น วงซ้อน ดาวหกแฉก อักษรวิ่งวน สัญลักษณ์ธาตุกลางวง
func _draw_circle_fx(i: int, fade: float) -> void:
	var g := _grow(i)
	if g <= 0.0:
		return
	var c := _center(i)
	var tint: Color = CIRCLES[i][1]
	var kind: String = CIRCLES[i][0]
	var rx := RX * g
	var ry := rx * RY_K
	var a0 := _t * (0.7 if i % 2 == 0 else -0.7)
	draw_colored_polygon(_oval(c, rx * 1.15, ry * 1.15), Color(LILAC, 0.14 * fade))
	draw_colored_polygon(_oval(c, rx, ry), Color(LILAC.darkened(0.6), 0.55 * fade))
	_ring(c, rx, ry, Color(LILAC.lightened(0.3), 0.95 * fade), 9.0)
	_ring(c, rx * 0.86, ry * 0.86, Color(tint, 0.85 * fade), 5.0)
	_ring(c, rx * 0.5, ry * 0.5, Color(tint, 0.75 * fade), 4.0)
	# วงกลมเล็กหกวงเรียงรอบวง แทนดาวหกแฉก
	for n in 6:
		var a := a0 + TAU * float(n) / 6.0
		var p6 := c + Vector2(cos(a) * rx * 0.68, sin(a) * ry * 0.68)
		_ring(p6, rx * 0.16, ry * 0.16, Color(tint, 0.7 * fade), 3.0)
	for n in 32:
		var a := TAU * float(n) / 32.0 - a0 * 1.3
		var p := c + Vector2(cos(a) * rx * 0.93, sin(a) * ry * 0.93)
		draw_line(p, p + Vector2(cos(a + PI * 0.5) * 26.0, sin(a + PI * 0.5) * 6.0), Color(tint.lightened(0.5), 0.85 * fade), 4.0, true)
	# โหนดรอยอุ้งเท้าแมว 6 จุดรอบวง นอนบนพื้นตามมุมกล้อง
	for n in 6:
		var a := a0 * 0.6 + TAU * float(n) / 6.0
		var p := c + Vector2(cos(a) * rx * 0.68, sin(a) * ry * 0.68)
		_kitty_paw(self, p, 26.0 * g, Color(tint.lightened(0.55), 0.9 * fade), 0.0, RY_K * 1.6)
	# สัญลักษณ์ธาตุลอยเหนือกลางวง อยู่ในกรอบหัวแมวมีหู
	var mark := c + Vector2(0.0, -ry * 0.1)
	var s := 60.0 * g
	var head := mark + Vector2(0.0, -s * 0.2)
	_kitty_ears(self, head, s * 1.25, Color(tint.lightened(0.3), 0.85 * fade), Color(tint.darkened(0.4), 0.85 * fade))
	draw_arc(head, s * 1.25, 0.0, TAU, 40, Color(tint.lightened(0.4), 0.85 * fade), 5.0, true)
	for side in [-1.0, 1.0]:
		for wy in [-0.08, 0.12]:
			draw_line(head + Vector2(side * s * 1.05, s * wy), head + Vector2(side * s * 1.75, s * (wy * 2.2 - 0.05)), Color(tint.lightened(0.5), 0.75 * fade), 3.0, true)
	match kind:
		"fire":
			var flame := PackedVector2Array([mark + Vector2(0.0, -s * 1.4), mark + Vector2(s * 0.6, -s * 0.2), mark + Vector2(s * 0.35, s * 0.4), mark + Vector2(-s * 0.35, s * 0.4), mark + Vector2(-s * 0.6, -s * 0.2)])
			draw_colored_polygon(flame, Color(1.0, 0.75, 0.3, 0.85 * fade))
		"ice":
			for n in 3:
				var a := PI * float(n) / 3.0
				var d := Vector2(cos(a), sin(a) * 0.6) * s
				draw_line(mark - d, mark + d, Color(0.85, 0.97, 1.0, 0.9 * fade), 6.0, true)
		"bolt":
			var zig := PackedVector2Array([mark + Vector2(s * 0.3, -s * 1.2), mark + Vector2(-s * 0.25, -s * 0.1), mark + Vector2(s * 0.2, -s * 0.1), mark + Vector2(-s * 0.3, s * 0.9)])
			draw_polyline(zig, Color(1.0, 1.0, 0.8, 0.95 * fade), 8.0, true)

## เสาไฟ เปลวไฟเลียขึ้นเป็นชั้นๆ แกนเหลืองขาว
func _draw_fire(c: Vector2, h: float, fade: float) -> void:
	var w := RX * 0.62
	for layer in 3:
		var k := 1.0 - float(layer) * 0.3
		var col := [Color(0.95, 0.25, 0.05, 0.55), Color(1.0, 0.55, 0.12, 0.7), Color(1.0, 0.9, 0.55, 0.85)][layer] as Color
		var left := PackedVector2Array()
		var right := PackedVector2Array()
		for n in 17:
			var y := float(n) / 16.0
			var lick := sin(y * 9.0 - _t * 12.0 + float(layer)) * 0.18 + sin(y * 17.0 - _t * 19.0) * 0.08
			var half := w * k * (1.0 - y * 0.55) * (1.0 + lick)
			var sway := sin(y * 5.0 - _t * 6.0) * 30.0 * y
			left.append(c + Vector2(-half + sway, -h * y))
			right.append(c + Vector2(half + sway, -h * y))
		right.reverse()
		left.append_array(right)
		draw_colored_polygon(left, Color(col, col.a * fade))

## เสาน้ำแข็ง แสงฟ้าใส ผลึกแหลมหลายแท่งพุ่งขึ้น หมอกเย็น
func _draw_ice(c: Vector2, h: float, fade: float) -> void:
	var w := RX * 0.55
	draw_colored_polygon(PackedVector2Array([c + Vector2(-w, 0.0), c + Vector2(w, 0.0), c + Vector2(w * 0.55, -h), c + Vector2(-w * 0.55, -h)]), Color(0.6, 0.9, 1.0, 0.22 * fade))
	for n in 7:
		var x := (float(n) - 3.0) / 3.0
		var tall := h * (0.55 + 0.45 * absf(sin(float(n) * 2.3))) * (1.0 - absf(x) * 0.3)
		var base := c + Vector2(x * w * 0.75, 0.0)
		var half := w * 0.16
		var tip := base + Vector2(x * 40.0, -tall)
		draw_colored_polygon(PackedVector2Array([base + Vector2(-half, 0.0), tip, base + Vector2(half, 0.0)]), Color(0.55, 0.85, 1.0, 0.8 * fade))
		draw_colored_polygon(PackedVector2Array([base + Vector2(-half * 0.1, 0.0), tip, base + Vector2(half, 0.0)]), Color(0.85, 0.97, 1.0, 0.85 * fade))
		draw_line(base, tip, Color(1.0, 1.0, 1.0, 0.7 * fade), 3.0, true)

## เสาไฟฟ้า ลำแสงเหลืองขาว สายฟ้าซิกแซกหลายเส้น
func _draw_bolt(c: Vector2, h: float, fade: float) -> void:
	var w := RX * 0.4
	var flick := 0.7 + 0.3 * sin(_t * 40.0)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-w, 0.0), c + Vector2(w, 0.0), c + Vector2(w * 0.7, -h), c + Vector2(-w * 0.7, -h)]), Color(1.0, 0.95, 0.4, 0.25 * flick * fade))
	draw_line(c, c + Vector2(0.0, -h), Color(1.0, 1.0, 0.85, 0.8 * flick * fade), w * 0.35, true)
	for pts in _bolts:
		if (pts as PackedVector2Array).size() < 2:
			continue
		draw_polyline(pts, Color(1.0, 0.9, 0.3, 0.5 * fade), 18.0, true)
		draw_polyline(pts, Color(1.0, 1.0, 0.9, fade), 6.0, true)

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

## เส้นพลังเชื่อมสามวงเป็นสามเหลี่ยม และลูกพลังรวมธาตุบนยอด
func _draw_link(fade: float) -> void:
	var g := minf(_grow(2), 1.0)
	if g <= 0.0:
		return
	var cols := [ICE, FIRE, BOLT]
	for i in 3:
		var a := _center(i)
		var b := _center((i + 1) % 3)
		var col: Color = cols[i]
		draw_line(a, a.lerp(b, g), Color(col, 0.3 * fade), 34.0, true)
		draw_line(a, a.lerp(b, g), Color(col.lightened(0.5), 0.85 * fade), 8.0, true)
		# ประกายวิ่งตามเส้น
		var run := fposmod(_t * 0.9 + float(i) * 0.33, 1.0)
		draw_circle(a.lerp(b, run * g), 16.0, Color(1.0, 1.0, 1.0, 0.8 * fade))
	var rise := _rise()
	if rise <= 0.0:
		return
	var mid := (_center(0) + _center(1) + _center(2)) / 3.0 + Vector2(0.0, -HIGH * rise * 0.95)
	var orb_r := 90.0 + 70.0 * rise + 10.0 * sin(_t * 8.0)
	# แสงม่วงอ่อนฟุ้งรอบลูก กับเม็ดธาตุกลมโคจร แทนรังสีแหลม
	draw_circle(mid, orb_r * 2.2, Color(LILAC, 0.12 * rise * fade))
	draw_circle(mid, orb_r * 1.6, Color(LILAC, 0.18 * rise * fade))
	for n in 12:
		var a := _t * 0.6 + TAU * float(n) / 12.0
		var d := Vector2(cos(a), sin(a))
		var col: Color = cols[n % 3]
		draw_circle(mid + d * orb_r * 2.0, 14.0, Color(col, 0.6 * rise * fade))
	for n in 3:
		draw_circle(mid + Vector2(cos(_t * 3.0 + TAU * float(n) / 3.0), sin(_t * 3.0 + TAU * float(n) / 3.0)) * orb_r * 0.35, orb_r * 0.7, Color(cols[n], 0.35 * rise * fade))
	draw_circle(mid, orb_r * 0.75, Color(1.0, 1.0, 0.95, 0.85 * rise * fade))
	_kitty_ears(self, mid, orb_r * 0.75, Color(1.0, 1.0, 0.95, 0.85 * rise * fade), Color(1.0, 0.8, 0.9, 0.85 * rise * fade))
	_kitty_face(self, mid, orb_r * 0.6, Color(0.45, 0.35, 0.6, rise * fade))

func _draw() -> void:
	var fade := _fade()
	for i in 3:
		_draw_circle_fx(i, fade)
		# คลื่นพลังวงรีกระเพื่อมออกจากวงทุกจังหวะดาเมจ
		if _t >= RISE_FROM and _t < close_from:
			var pk := fposmod(_t - RISE_FROM, TICK) / TICK
			_ring(_center(i), RX * (0.9 + 0.6 * pk), RX * RY_K * (0.9 + 0.6 * pk), Color(CIRCLES[i][1], 0.7 * (1.0 - pk) * fade), 10.0 * (1.0 - pk) + 2.0)
	_draw_link(fade)
	var h := HIGH * _rise() * fade
	if h > 1.0:
		# วงหลังวาดก่อน
		_draw_ice(_center(0), h, fade)
		_draw_fire(_center(1), h, fade)
		_draw_bolt(_center(2), h, fade)
	for s in _sparks:
		var k: float = 1.0 - float(s[2]) / 1.2
		var r: float = float(s[4]) * k
		match str(s[3]):
			"fire":
				_kitty_paw(self, s[0], r * 1.5, Color(1.0, 0.65, 0.2, k * fade))
			"ice":
				if r < 2.0:
					continue
				var p: Vector2 = s[0]
				draw_colored_polygon(PackedVector2Array([p + Vector2(0.0, -r * 1.4), p + Vector2(r * 0.6, 0.0), p + Vector2(0.0, r * 1.4), p + Vector2(-r * 0.6, 0.0)]), Color(0.85, 0.97, 1.0, k * fade))
			"bolt":
				draw_line(s[0], (s[0] as Vector2) + Vector2(randf_range(-r, r), r * 2.0), Color(1.0, 1.0, 0.7, k * fade), 3.0, true)
