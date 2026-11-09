class_name CatGoldTreeHyper
extends HyperStage
## HYPER ของ TRANSMUTATION MASTER (CAT SUSI) จอดำ กล้องถอยไกล มอนสตั๊น
## ต้นไม้สีทองงอกขึ้นตรงที่ตัวละครยืน (วาดหลังตัว แมวยืนหน้าโคนต้น) ค่อยๆ โตจนเกือบเต็มจอ
## ลำต้นมีรากแผ่ โคนใหญ่เรียวขึ้น กิ่งโค้งคดแตกแขนงแบบต้นไม้จริง มีลายเปลือก ใบไม้เป็นหนามแหลมสีทอง
## โตเต็มที่แล้วมีวงทองแนวตั้งหมุนรอบต้นไม้ ใบหนามโคจรตามวง ทำดาเมจต่อเนื่อง

const SUMMON_TO := 0.6
const GROW_FROM := 0.6
const GROW_TO := 3.8
const RING_TIME := 4.2           # วงทองหมุนทำดาเมจนานเท่านี้
const TICK := 0.3
const TICK_DMG := 18.0
const TOP := 860.0               # ต้นไม้เล็กลง กิ่งบนสุดไม่เลยขอบจอ
const DEPTH := 6
const BARK := Color(0.42, 0.26, 0.04)
const ORBIT_R := 1250.0
const GOLD := Color(0.98, 0.78, 0.25)
const LILAC := Color(0.74, 0.6, 0.9)      # สีหลักม่วงอ่อนของ CAT SUSI ต้นไม้ทองเป็นสีแซม
const GOLD_DARK := Color(0.55, 0.36, 0.06)
const GOLD_LIGHT := Color(1.0, 0.96, 0.65)

## กิ่ง [จุดตามแนวกิ่ง ความกว้างโคน ความกว้างปลาย ระดับ] พิกัดเทียบโคนต้น
var _branches: Array = []
## ใบหนาม [ตำแหน่ง ขนาด มุม]
var _leaves: Array = []
var _back: Node2D
var _tick := 0.0
var _glints: Array = []          # ประกายทองลอยขึ้น [ตำแหน่ง ความเร็ว อายุ]

func _stage_start() -> void:
	open_time = 0.5
	close_from = GROW_TO + RING_TIME
	end_time = close_from + 0.45
	Monster.hide_bars = true
	_grow_branch(Vector2.ZERO, -PI * 0.5, 300.0, 200.0, 0)
	# รากแผ่ออกจากโคน
	for side in [-1.0, 1.0]:
		for n in 2:
			var pts := PackedVector2Array()
			var reach := randf_range(150.0, 230.0) * (1.0 if n == 0 else 0.7)
			for i in 5:
				var k := float(i) / 4.0
				pts.append(Vector2(side * (30.0 + reach * k), -30.0 * (1.0 - k) + 12.0 * k * k + float(n) * 8.0))
			_branches.append([pts, 46.0 - float(n) * 10.0, 6.0, 0])
	# ย่อขยายให้ยอดสูงเท่า TOP
	var high := 1.0
	for b in _branches:
		for p in b[0]:
			high = maxf(high, -(p as Vector2).y)
	for l in _leaves:
		high = maxf(high, -(l[0] as Vector2).y)
	var k := TOP / high
	for b in _branches:
		var pts := PackedVector2Array()
		for p in b[0]:
			pts.append((p as Vector2) * k)
		b[0] = pts
		b[1] = float(b[1]) * k
		b[2] = float(b[2]) * k
	for l in _leaves:
		l[0] = (l[0] as Vector2) * k
		l[1] = float(l[1]) * k
	# ต้นไม้วาดชั้นหลังตัวละคร
	_back = Node2D.new()
	_back.draw.connect(_draw_tree)
	page.world.add_child(_back)
	page.world.move_child(_back, 0)

## กิ่งโค้งคดเล็กน้อย เรียวจากโคนถึงปลาย แตกกิ่งที่ปลาย กิ่งหลักต่อตรงกว่า กิ่งข้างเบนออก บางทีมีกิ่งแขนงกลางกิ่ง
func _grow_branch(from: Vector2, angle: float, length: float, width: float, level: int) -> void:
	var pts := PackedVector2Array([from])
	var heading := angle
	var at := from
	for i in 4:
		heading += randf_range(-0.16, 0.16)
		# กิ่งสูงๆ ค่อยๆ โน้มขึ้นหาแสง
		heading = lerp_angle(heading, -PI * 0.5, 0.02 if level < 4 else 0.05)
		at += Vector2(cos(heading), sin(heading)) * length * 0.25
		pts.append(at)
	var end_w := width * (0.62 if level < 2 else 0.58)
	_branches.append([pts, width, end_w, level])
	if level >= DEPTH:
		for n in 3:
			_leaves.append([at + Vector2(randf_range(-45.0, 45.0), randf_range(-45.0, 30.0)), randf_range(55.0, 85.0), randf() * TAU])
		return
	if level >= 2 and level < DEPTH - 1 and randf() < 0.5:
		var mid := pts[2]
		var side := 1.0 if randf() < 0.5 else -1.0
		_grow_branch(mid, heading + side * randf_range(0.7, 1.0), length * 0.5, width * 0.4, mini(level + 2, DEPTH))
	# ลำต้นแยกเป็นกิ่งใหญ่สองข้าง แผ่ซ้ายขวา
	if level == 0:
		for side in [-1.0, 1.0]:
			_grow_branch(at, heading + side * randf_range(0.65, 0.85), length * randf_range(0.85, 0.95), end_w * 0.85, 1)
		return
	# กิ่งล่างกางกว้าง กิ่งบนแคบลง กิ่งที่เอียงไปข้างไหนก็แผ่ต่อไปข้างนั้น
	var lean := randf_range(0.55, 0.95) if level < 4 else randf_range(0.35, 0.6)
	var tilt := randf_range(-0.1, 0.1)
	var outward := signf(cos(heading)) if absf(cos(heading)) > 0.15 else (1.0 if randf() < 0.5 else -1.0)
	var flip := outward if randf() < 0.7 else -outward
	_grow_branch(at, heading + tilt - flip * lean * 0.45, length * randf_range(0.74, 0.84), end_w * 0.92, level + 1)
	_grow_branch(at, heading + tilt + flip * lean, length * randf_range(0.62, 0.74), end_w * 0.72, level + 1)

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _root() -> Vector2:
	return Vector2(hero.position.x, 0.0)

func _grow() -> float:
	return clampf((_t - GROW_FROM) / (GROW_TO - GROW_FROM), 0.0, 1.0)

func _fade() -> float:
	return 1.0 - clampf((_t - close_from) / 0.4, 0.0, 1.0)

func _stage_tick(delta: float) -> void:
	if is_instance_valid(_back):
		_back.queue_redraw()
	if _t >= GROW_FROM and _t < GROW_TO:
		_shake = maxf(_shake, 3.0)
	if _t >= GROW_TO and _t < close_from:
		_tick -= delta
		if _tick <= 0.0:
			_tick = TICK
			_hit_all(TICK_DMG)
			_shake = maxf(_shake, 7.0)
	if _t >= GROW_FROM and _t < close_from and _glints.size() < 200:
		for n in 4:
			var at := _root() + Vector2(randf_range(-900.0, 900.0), randf_range(-TOP * _grow(), 0.0))
			_glints.append([at, Vector2(randf_range(-30.0, 30.0), randf_range(-260.0, -120.0)), 0.0])
	for g in _glints.duplicate():
		g[2] += delta
		g[0] = (g[0] as Vector2) + (g[1] as Vector2) * delta
		if g[2] > 1.4:
			_glints.erase(g)

func _finish() -> void:
	Monster.hide_bars = false
	if is_instance_valid(_back):
		_back.queue_free()
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if is_instance_valid(_back):
		_back.queue_free()
	super._exit_tree()

## ใบทองกลม
func _thorn_leaf(target: CanvasItem, c: Vector2, size: float, _angle: float, fade: float) -> void:
	# ใบทองกลมมน ขอบเข้ม แกนสว่าง ไม่มีแฉก
	if size < 6.0 or fade <= 0.0:
		return
	target.draw_circle(c, size * 0.8, Color(GOLD_DARK, fade))
	target.draw_circle(c, size * 0.7, Color(GOLD, fade))
	target.draw_circle(c + Vector2(-size * 0.18, -size * 0.18), size * 0.32, Color(GOLD_LIGHT, 0.9 * fade))

func _draw_tree() -> void:
	var g := _grow()
	var fade := _fade()
	var root := _root()
	# วงแปรธาตุบนพื้นใต้ต้นไม้ตอนเรียก
	var summon := clampf(_t / SUMMON_TO, 0.0, 1.0) * fade
	if summon > 0.0:
		var rx := 520.0 * summon
		var ring := PackedVector2Array()
		for n in 65:
			var a := TAU * float(n) / 64.0
			ring.append(root + Vector2(cos(a) * rx, sin(a) * rx * 0.2))
		_back.draw_polyline(ring, Color(LILAC, 0.9 * summon), 8.0, true)
		var square := PackedVector2Array()
		for n in 5:
			var a := _t * 0.5 + TAU * float(n) / 4.0
			square.append(root + Vector2(cos(a) * rx * 0.8, sin(a) * rx * 0.16))
		_back.draw_polyline(square, Color(LILAC.lightened(0.3), 0.7 * summon), 4.0, true)
		for n in 8:
			var a := -_t * 0.4 + TAU * float(n) / 8.0
			_kitty_paw(_back, root + Vector2(cos(a) * rx * 0.9, sin(a) * rx * 0.18), 34.0 * summon, Color(GOLD_LIGHT, 0.8 * summon), 0.0, 0.4)
	if g <= 0.0:
		return
	# แสงทองบนพื้นแผ่กว้าง
	var floor_pts := PackedVector2Array()
	for n in 48:
		var a := TAU * float(n) / 48.0
		floor_pts.append(root + Vector2(cos(a) * 1500.0 * g, sin(a) * 190.0 * g))
	if g > 0.05:
		_back.draw_colored_polygon(floor_pts, Color(LILAC, 0.2 * fade))
	var crown := root + Vector2(0.0, -TOP * 0.62 * g)
	# แสงทองฟุ้งหลังต้น หลายชั้น
	_back.draw_circle(crown, TOP * 0.9 * g, Color(LILAC, 0.08 * fade))
	_back.draw_circle(root + Vector2(0.0, -TOP * 0.55 * g), TOP * 0.6 * g, Color(1.0, 0.8, 0.3, 0.12 * fade))
	# กิ่งโตทีละระดับ ระดับล่างโตก่อน รูปเรียวมีขอบเข้ม เนื้อทอง แสงด้านหนึ่ง ลายเปลือกตามยาว
	var span := 1.0 / float(DEPTH + 1)
	for b in _branches:
		var level: int = b[3]
		var k := clampf((g - float(level) * span) / span, 0.0, 1.0)
		if k <= 0.0:
			continue
		_draw_branch(b, k, root, fade)
	# ใบหนามผลิตอนกิ่งสุดท้ายโต
	var bloom := clampf((g - float(DEPTH) * span) / span, 0.0, 1.0)
	if bloom > 0.0:
		var li := 0
		for l in _leaves:
			var wiggle := sin(_t * 2.0 + float(l[2])) * 0.15
			_thorn_leaf(_back, root + (l[0] as Vector2), float(l[1]) * bloom, float(l[2]) + wiggle, fade)
			# ผลไม้เป็นกระดิ่งแมวทองห้อยใต้ใบ ทุกใบที่สาม แกว่งเบาๆ
			if li % 3 == 1:
				var hang := root + (l[0] as Vector2) + Vector2(sin(_t * 3.0 + float(li)) * 6.0, float(l[1]) * 0.75 * bloom)
				_back.draw_line(root + (l[0] as Vector2), hang, Color(GOLD_DARK, fade), 2.0, true)
				_kitty_bell(_back, hang, float(l[1]) * 0.42 * bloom, Color(GOLD_LIGHT, fade), Color(GOLD_DARK, fade))
			li += 1

## วาดกิ่งเรียวตามจุด โตได้ k ส่วนของความยาว
func _draw_branch(b: Array, k: float, root: Vector2, fade: float) -> void:
	var src: PackedVector2Array = b[0]
	var count := src.size() - 1
	var reach := k * float(count)
	var pts := PackedVector2Array()
	for i in src.size():
		if float(i) <= reach:
			pts.append(root + src[i])
		else:
			var j := int(reach)
			pts.append(root + src[j].lerp(src[mini(j + 1, count)], reach - float(j)))
			break
	if pts.size() < 2:
		return
	var w0: float = b[1]
	var w1: float = lerpf(w0, float(b[2]), k)
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	var shine := PackedVector2Array()
	var bark_a := PackedVector2Array()
	var bark_b := PackedVector2Array()
	for i in pts.size():
		var dir := (pts[mini(i + 1, pts.size() - 1)] - pts[maxi(i - 1, 0)]).normalized()
		var n := Vector2(-dir.y, dir.x)
		var t := float(i) / float(pts.size() - 1)
		var half := lerpf(w0, w1, t) * 0.5
		left.append(pts[i] + n * half)
		right.append(pts[i] - n * half)
		shine.append(pts[i] + n * half * 0.45)
		bark_a.append(pts[i] - n * half * (0.2 + 0.08 * sin(t * 9.0 + w0)))
		bark_b.append(pts[i] - n * half * (0.62 + 0.06 * sin(t * 7.0 + w0 * 0.5)))
	var body := left.duplicate()
	var back := right.duplicate()
	back.reverse()
	body.append_array(back)
	var outline := body.duplicate()
	outline.append(body[0])
	if pts[0].y < root.y - 1.0:
		_back.draw_circle(pts[0], w0 * 0.5, Color(GOLD, fade))
	_back.draw_colored_polygon(body, Color(GOLD, fade))
	_back.draw_polyline(shine, Color(GOLD_LIGHT, 0.85 * fade), maxf(2.0, w0 * 0.14), true)
	if w0 > 14.0:
		_back.draw_polyline(bark_a, Color(BARK, 0.55 * fade), maxf(1.5, w0 * 0.05), true)
		_back.draw_polyline(bark_b, Color(BARK, 0.45 * fade), maxf(1.5, w0 * 0.04), true)
	_back.draw_polyline(outline, Color(GOLD_DARK, fade), maxf(2.0, w0 * 0.05), true)

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
	var fade := _fade()
	var gi := 0
	for gl in _glints:
		var k: float = 1.0 - float(gl[2]) / 1.4
		var p: Vector2 = gl[0]
		# ประกายกลมๆ ไม่มีดาวแฉก
		draw_circle(p, 6.0 + 6.0 * k, Color(GOLD_LIGHT, k * fade))
		gi += 1
	if _t < GROW_TO:
		return
	# วงทองแนวตั้งรอบต้นไม้ หมุน มีใบหนามโคจร และคลื่นทองขยายออกทุกจังหวะ
	var c := _root() + Vector2(0.0, -TOP * 0.5)
	var open := _ease((_t - GROW_TO) / 0.4) * fade
	var r := ORBIT_R * open
	for n in 3:
		var rr := r * (0.78 + 0.14 * float(n))
		draw_arc(c, rr, 0.0, TAU, 96, Color(GOLD, (0.25 + 0.2 * float(n)) * fade), 10.0 - float(n) * 2.0, true)
	draw_arc(c, r, 0.0, TAU, 96, Color(GOLD_LIGHT, 0.9 * fade), 5.0, true)
	for n in 12:
		var a := _t * 1.6 + TAU * float(n) / 12.0
		_thorn_leaf(self, c + Vector2(cos(a), sin(a)) * r, 70.0, a * 2.0, fade)
	for n in 8:
		var a := -_t * 2.3 + TAU * float(n) / 8.0
		if n % 2 == 0:
			_thorn_leaf(self, c + Vector2(cos(a), sin(a)) * r * 0.78, 50.0, -a * 2.0, fade)
		else:
			_kitty_paw(self, c + Vector2(cos(a), sin(a)) * r * 0.78, 46.0, Color(GOLD_LIGHT, fade), a + PI * 0.5)
	var pulse := fmod(_t - GROW_TO, TICK) / TICK
	draw_arc(c, r * (0.5 + 0.6 * pulse), 0.0, TAU, 96, Color(GOLD_LIGHT, 0.6 * (1.0 - pulse) * fade), 14.0 * (1.0 - pulse) + 2.0, true)
	draw_arc(c, r * (1.0 + 0.35 * pulse), 0.0, TAU, 96, Color(GOLD, 0.45 * (1.0 - pulse) * fade), 10.0 * (1.0 - pulse) + 2.0, true)
	# วงทองชั้นนอกสุด กระดิ่งทองโคจรกลับทาง
	draw_arc(c, r * 1.12, 0.0, TAU, 96, Color(GOLD, 0.35 * fade), 6.0, true)
	for n in 6:
		var a := -_t * 0.9 + TAU * float(n) / 6.0
		_kitty_bell(self, c + Vector2(cos(a), sin(a)) * r * 1.12, 38.0 * open, Color(GOLD_LIGHT, fade), Color(GOLD_DARK, fade))
