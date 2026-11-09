class_name CatCrimsonHyper
extends HyperStage
## HYPER ของ CRIMSON KNIGHT จอเป็นแบบภาพ ฉากหลังดำทั้งหมด กล้องถอยไกล มอนสตั๊น
## ปักดาบลงดิน ใต้เท้าเกิดวงเลือดแนวนอนกว้างครึ่งจอ หนามเลือดแข็งเป็นผลึกเหลี่ยมพุ่งขึ้นจากวง ไล่จากกลางออกไปขอบ
## หนามกระจายทั้งหน้าหลังวง หลังเล็กเข้มกว่า หน้าใหญ่สว่างกว่า แต่ละจุดมีหนามเล็กแตกข้างฐาน เลือดไหลลงตามหนาม
## หนามข้างกันยาวสั้นสลับกัน และสลับยาวสั้นไปมาทุกจังหวะ แทงขึ้นทีหนึ่งโดนทีหนึ่ง ทำดาเมจต่อเนื่อง 4 วินาที

const STAB_TO := 0.8             # ปักดาบเสร็จ
const RING_FROM := 0.8
const RING_TO := 1.3
const RISE_FROM := 1.3
const SPREAD := 0.6              # หนามไล่พุ่งจากกลางถึงขอบวง
const SWAP := 0.45               # สลับยาวสั้นทุกกี่วินาที
const THRUST := 0.12             # หนามแทงขึ้นเร็ว
const DAMAGE_TIME := 4.0        # สั้นลง 3 วินาทีจากเดิม 7
const TICK_DMG := 22.0
const RX := 1350.0               # วงกว้างเกือบเต็มจอตอนกล้องถอย
const RY := 180.0
const HIGH := 700.0              # หนามยาว ลดความสูงลงไม่ให้ดูเยอะเกิน
const SHORT := 0.42              # หนามสั้นยาวเท่านี้ของหนามยาว
const SPIKES := 40
const CAT_GAP := 150.0           # เว้นตรงตัวละคร จะได้เห็นแมวปักดาบ
const DEEP := Color(0.48, 0.07, 0.2)
const RED := Color(0.92, 0.25, 0.45)
const BRIGHT := Color(1.0, 0.58, 0.72)
const SHADE := Color(0.42, 0.06, 0.18)      # ด้านมืดของหนาม
const LIT := Color(0.88, 0.22, 0.42)       # ด้านรับแสง
const RIDGE := Color(1.0, 0.7, 0.8)      # สันหนามสะท้อนแสง
const EDGE := Color(0.25, 0.02, 0.1)

var _cycle := -1
## [x ลึก(-1 หลัง ถึง 1 หน้า) กว้างฐาน เอียง ความสูงสัมพัทธ์ ยาวก่อน(0/1) หนามข้าง[[ด้าน ขนาด เอียง]]]
var _spikes: Array = []
var _drops: Array = []           # [ตำแหน่ง ความเร็ว อายุ]
var _motes: Array = []           # ประกายเลือดลอยขึ้นจากวง [ตำแหน่ง ความเร็ว อายุ ขนาด]
const MOTE_MAX := 120

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = RISE_FROM + DAMAGE_TIME
	end_time = close_from + 0.45
	Monster.hide_bars = true
	# ตัวละครปักดาบลงดิน ใช้ท่าปักดาบของสกิล
	hero.plain_swing_kind = "combo"
	hero.plain_move = Hero.CAT_SKILLS["cat_sk_crack"]
	hero.plain_swing = 0.001
	var made: Array = []
	for i in SPIKES:
		var x := lerpf(-RX * 0.9, RX * 0.9, (float(i) + randf_range(-0.35, 0.35)) / float(SPIKES - 1))
		if absf(x) < CAT_GAP:
			continue
		var edge_room := sqrt(maxf(1.0 - pow(x / RX, 2.0), 0.0))
		var depth := randf_range(-0.8, 0.8) * edge_room
		# หนามตั้งตรง เอียงออกจากกลางวงแค่นิดเดียว
		var lean := signf(x) * randf_range(0.0, 0.08)
		var kids: Array = []
		for side in [-1.0, 1.0]:
			if randf() < 0.8:
				kids.append([side, randf_range(0.3, 0.5), side * randf_range(0.12, 0.28)])
		made.append([x, depth, randf_range(115.0, 150.0), lean, randf_range(0.8, 1.0), made.size() % 2, kids])
	# วาดหลังก่อนหน้า
	made.sort_custom(func(a: Array, b: Array) -> bool: return float(a[1]) < float(b[1]))
	_spikes = made

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _base(spike: Array) -> Vector2:
	return Vector2(hero.position.x + float(spike[0]), float(spike[1]) * RY * 0.85)

func _scale(spike: Array) -> float:
	return lerpf(0.72, 1.08, (float(spike[1]) + 1.0) * 0.5)

func _stage_tick(delta: float) -> void:
	# ค้างท่าปักดาบไว้ตลอด
	hero.plain_swing = clampf(_t / STAB_TO, 0.001, 0.9)
	if _t >= RISE_FROM and _t < close_from:
		var cycle := int((_t - RISE_FROM) / SWAP)
		if cycle != _cycle:
			_cycle = cycle
			_hit_all(TICK_DMG)
			_shake = maxf(_shake, 9.0)
		if fmod(_t - RISE_FROM, SWAP) < THRUST and not _spikes.is_empty():
			for i in 6:
				var spike: Array = _spikes[randi() % _spikes.size()]
				var h := _height(spike)
				var tip := _base(spike) + Vector2(float(spike[3]) * h, -h)
				_drops.append([tip, Vector2(randf_range(-200.0, 200.0), randf_range(-380.0, -120.0)), 0.0])
	# ประกายเลือดลอยขึ้นจากทั่ววง
	if _t >= RING_TO and _t < close_from and _motes.size() < MOTE_MAX:
		for n in 3:
			var a := randf() * TAU
			var at := Vector2(hero.position.x + cos(a) * RX * randf_range(0.2, 0.95), sin(a) * RY * 0.8)
			_motes.append([at, Vector2(randf_range(-40.0, 40.0), randf_range(-520.0, -220.0)), 0.0, randf_range(8.0, 18.0)])
	for m in _motes.duplicate():
		m[2] += delta
		m[0] = (m[0] as Vector2) + (m[1] as Vector2) * delta
		if m[2] > 1.4:
			_motes.erase(m)
	for d in _drops.duplicate():
		d[2] += delta
		d[1] = (d[1] as Vector2) + Vector2(0.0, 1600.0) * delta
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		if d[2] > 1.0:
			_drops.erase(d)

## ความสูงหนามตอนนี้ ยาวสั้นสลับกันทุก SWAP วินาที แทงขึ้นเร็วเลยไปนิดแล้วเด้งกลับ
func _height(spike: Array) -> float:
	var since := _t - RISE_FROM - absf(float(spike[0])) / RX * SPREAD
	if since <= 0.0:
		return 0.0
	var cycle := int(since / SWAP)
	var long_now := (int(spike[5]) + cycle) % 2 == 0
	var full := HIGH * float(spike[4]) * _scale(spike)
	var now := full if long_now else full * SHORT
	var before := 0.0 if cycle == 0 else (full * SHORT if long_now else full)
	var k := clampf(fmod(since, SWAP) / THRUST, 0.0, 1.0)
	var c1 := 1.4
	var eased := 1.0 + (c1 + 1.0) * pow(k - 1.0, 3.0) + c1 * pow(k - 1.0, 2.0)
	var fade := 1.0 - clampf((_t - close_from) / 0.4, 0.0, 1.0)
	return lerpf(before, now, eased) * fade

func _finish() -> void:
	Monster.hide_bars = false
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	super._exit_tree()

func _oval(c: Vector2, rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 64:
		var a := TAU * float(i) / 64.0
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## จุดบนแกนหนาม k 0 ฐาน 1 ปลาย เป็นเส้นตรง
func _axis(base: Vector2, h: float, lean: float, k: float) -> Vector2:
	return base + Vector2(lean * h * k, -h * k)

func _half(w: float, k: float) -> float:
	return w * 0.5 * (1.0 - k)

## หนามผลึกเหลี่ยม ตรง ด้านซ้ายมืด ด้านขวารับแสง สันกลางสว่าง ปลายมีประกาย เลือดไหลลงตามผิว
func _draw_spike(base: Vector2, h: float, w: float, lean: float, dim: float, fade: float, drip_seed: float) -> void:
	if h <= 2.0:
		return
	var tip := _axis(base, h, lean, 1.0)
	var left := PackedVector2Array()
	var ridge := PackedVector2Array()
	var right := PackedVector2Array()
	for i in 8:
		var k := float(i) / 8.0
		var mid := _axis(base, h, lean, k)
		var half := _half(w, k)
		left.append(mid + Vector2(-half, 0.0))
		ridge.append(mid + Vector2(half * 0.18, 0.0))
		right.append(mid + Vector2(half, 0.0))
	var right_back := right.duplicate()
	right_back.reverse()
	var ridge_back := ridge.duplicate()
	ridge_back.reverse()
	var dark_face := left.duplicate()
	dark_face.append(tip)
	dark_face.append_array(ridge_back)
	var lit_face := ridge.duplicate()
	lit_face.append(tip)
	lit_face.append_array(right_back)
	var tint := Color(dim, dim, dim)
	draw_colored_polygon(dark_face, Color(SHADE * tint, fade))
	draw_colored_polygon(lit_face, Color(LIT * tint, fade))
	# แถบมันวาวบนด้านรับแสง
	var gloss := PackedVector2Array()
	for i in 6:
		var k := float(i) / 8.0
		gloss.append(_axis(base, h, lean, k) + Vector2(_half(w, k) * 0.32, 0.0))
	for i in range(5, -1, -1):
		var k := float(i) / 8.0
		gloss.append(_axis(base, h, lean, k) + Vector2(_half(w, k) * 0.62, 0.0))
	draw_colored_polygon(gloss, Color(RED * tint, 0.8 * fade))
	var ridge_line := ridge.duplicate()
	ridge_line.append(tip)
	draw_polyline(ridge_line, Color(RIDGE, 0.85 * dim * fade), maxf(2.0, w * 0.045), true)
	# เลือดไหลลงตามผิวหนาม
	for j in 2:
		var k0 := 0.25 + 0.3 * fposmod(drip_seed * (1.7 + float(j)), 1.0)
		var flow := fposmod(_t * 0.6 + drip_seed + float(j) * 0.5, 1.0)
		var k1 := maxf(k0 - 0.25 * flow - 0.05, 0.0)
		var side := -0.55 if j == 0 else 0.7
		var from := _axis(base, h, lean, k0) + Vector2(_half(w, k0) * side, 0.0)
		var to := _axis(base, h, lean, k1) + Vector2(_half(w, k1) * side, 0.0)
		var blood := Color(0.42 * dim, 0.0, 0.04, 0.9 * fade)
		draw_line(from, to, blood, maxf(2.5, w * 0.06), true)
		draw_circle(to, maxf(2.5, w * 0.05), blood)
	var outline := left.duplicate()
	outline.append(tip)
	outline.append_array(right_back)
	outline.append(left[0])
	draw_polyline(outline, Color(EDGE, fade), 2.5, true)
	draw_circle(tip, maxf(2.0, w * 0.04), Color(1.0, 0.85, 0.85, 0.9 * dim * fade))
	# ตราอุ้งเท้าแมวบนด้านรับแสงของหนามที่สูงพอ
	if h > w * 2.2:
		var mark := _axis(base, h, lean, 0.3) + Vector2(_half(w, 0.3) * 0.42, 0.0)
		_kitty_paw(self, mark, w * 0.2, Color(1.0, 0.8, 0.86, 0.55 * dim * fade))

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
	var ring := clampf((_t - RING_FROM) / (RING_TO - RING_FROM), 0.0, 1.0) * fade
	if ring <= 0.0:
		return
	var c := Vector2(hero.position.x, 0.0)
	var rx := RX * ring
	var ry := RY * ring
	# วงเลือดใต้เท้า แอ่งเลือด วงซ้อน อักษรวิ่งวน
	draw_colored_polygon(_oval(c, rx, ry), Color(DEEP, 0.85 * fade))
	draw_colored_polygon(_oval(c, rx * 0.75, ry * 0.75), Color(RED, 0.35 * fade))
	var edge := _oval(c, rx, ry)
	edge.append(edge[0])
	draw_polyline(edge, Color(BRIGHT, 0.9 * fade), 10.0, true)
	var inner := _oval(c, rx * 0.85, ry * 0.85)
	inner.append(inner[0])
	draw_polyline(inner, Color(RED, 0.8 * fade), 5.0, true)
	# รอยอุ้งเท้าเดินวนรอบวง
	for i in 14:
		var a := TAU * float(i) / 14.0 + _t * 0.4
		var p := c + Vector2(cos(a) * rx * 0.88, sin(a) * ry * 0.88)
		var s := 22.0 * ring
		draw_colored_polygon(_oval(p + Vector2(0.0, s * 0.3), s * 0.7, s * 0.32), Color(BRIGHT, 0.85 * fade))
		for t in 4:
			draw_circle(p + Vector2((float(t) - 1.5) * s * 0.5, -s * (0.15 + (0.12 if t == 1 or t == 2 else 0.0))), s * 0.2, Color(BRIGHT, 0.85 * fade))
	# แสงเรืองใต้วงกว้างกว่าวง
	draw_colored_polygon(_oval(c, rx * 1.18, ry * 1.25), Color(RED, 0.18 * fade))
	# คลื่นเลือดกระเพื่อมออกจากกลางวงทุกจังหวะแทง
	if _t >= RISE_FROM and _t < close_from:
		var pk := fmod(_t - RISE_FROM, SWAP) / SWAP
		for n in 2:
			var kk := clampf(pk - float(n) * 0.25, 0.0, 1.0)
			var wave := _oval(c, rx * (0.2 + 0.95 * kk), ry * (0.2 + 0.95 * kk))
			wave.append(wave[0])
			draw_polyline(wave, Color(BRIGHT, 0.8 * (1.0 - kk) * fade), 14.0 * (1.0 - kk) + 2.0, true)
	# หมอกเลือดจางๆ ลอยเหนือวง
	var rise := clampf((_t - RISE_FROM) / 0.5, 0.0, 1.0) * fade
	# ลำแสงเลือดพุ่งขึ้นจากวง ไหวช้าๆ อยู่หลังหนาม
	if rise > 0.0:
		for n in 9:
			var bx := c.x + (float(n) - 4.0) / 4.0 * rx * 0.85
			var bw := 70.0 + 40.0 * sin(float(n) * 1.7)
			var bh := HIGH * (1.1 + 0.35 * sin(_t * 2.0 + float(n))) * rise
			var lo := Color(1.0, 0.35, 0.55, 0.32 * rise)
			var hi := Color(1.0, 0.35, 0.55, 0.0)
			draw_polygon(PackedVector2Array([Vector2(bx - bw, 0.0), Vector2(bx + bw, 0.0), Vector2(bx + bw * 0.3, -bh), Vector2(bx - bw * 0.3, -bh)]), PackedColorArray([lo, lo, hi, hi]))
	if rise > 0.0:
		var haze := PackedVector2Array([c + Vector2(-rx, 0.0), c + Vector2(rx, 0.0), c + Vector2(rx * 0.8, -HIGH * 0.9), c + Vector2(-rx * 0.8, -HIGH * 0.9)])
		var low := Color(0.7, 0.0, 0.06, 0.32 * rise)
		var high := Color(0.7, 0.0, 0.06, 0.0)
		draw_polygon(haze, PackedColorArray([low, low, high, high]))
	# หนามเลือด วาดจากหลังมาหน้า
	for spike in _spikes:
		var h := _height(spike)
		if h <= 2.0:
			continue
		var base := _base(spike)
		var s := _scale(spike)
		var w: float = float(spike[2]) * s * (0.8 + 0.2 * h / HIGH)
		var dim := lerpf(0.62, 1.0, (float(spike[1]) + 1.0) * 0.5)
		var drip_seed := float(spike[0]) * 0.013
		# แอ่งเลือดรอบฐาน
		draw_colored_polygon(_oval(base, w * 1.1, w * 0.26), Color(0.5 * dim, 0.0, 0.05, 0.9 * fade))
		for kid in spike[6]:
			var kbase := base + Vector2(float(kid[0]) * w * 0.42, 2.0)
			_draw_spike(kbase, h * float(kid[1]), w * 0.6, float(kid[2]), dim * 0.85, fade, drip_seed + float(kid[0]))
		_draw_spike(base, h, w, float(spike[3]), dim, fade, drip_seed)
		# แสงเรืองที่ปลายหนาม
		var tip := _axis(base, h, float(spike[3]), 1.0)
		draw_circle(tip, w * 0.3, Color(1.0, 0.45, 0.6, 0.16 * dim * fade))
		# เลือดกระเซ็นเป็นมงกุฎตรงฐานตอนแทงขึ้น
		var since := fmod(_t - RISE_FROM - absf(float(spike[0])) / RX * SPREAD, SWAP)
		if since >= 0.0 and since < 0.2:
			var k := since / 0.2
			for j in 5:
				var a := PI + PI * (float(j) + 0.5) / 5.0
				var p := base + Vector2(cos(a) * w * (0.6 + k), sin(a) * w * 0.9 * k)
				draw_circle(p, w * 0.08 * (1.0 - k), Color(RED, (1.0 - k) * fade))
	for d in _drops:
		var k: float = 1.0 - float(d[2])
		_kitty_paw(self, d[0], 9.0 + 12.0 * k, Color(LIT, k * fade), float(d[2]) * 3.0)
	# ประกายเลือดลอยขึ้น เม็ดกลมสลับรอยเท้าแมว
	var mi := 0
	for m in _motes:
		var k: float = 1.0 - float(m[2]) / 1.4
		var p: Vector2 = m[0]
		var s: float = float(m[3]) * k
		if mi % 4 == 0:
			_kitty_paw(self, p, s * 1.3, Color(BRIGHT, k * fade), float(m[2]) * 2.0)
		elif s > 1.5:
			draw_circle(p, s * 0.6, Color(1.0, 0.65, 0.78, k * fade))
		mi += 1
