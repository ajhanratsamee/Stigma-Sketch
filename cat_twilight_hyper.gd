class_name CatTwilightHyper
extends HyperStage
## HYPER ของ TWILIGHT (สาย TRAPSTARKER ของ CAT MATCHA)
## เสกป่าสนธยาขึ้นด้านหน้า หายตัวเข้าไปในป่า ฟันไปมาในป่า 20 ฮิต (เห็นเป็นเงาเขียวพุ่งไปมา ใบไม้ปลิว)
## โผล่กลับมาที่เดิม สะบัดดาบพลังงาน เกิดรอยตัดแนวนอนกลางป่า ต้นไม้ครึ่งบนไถลตามรอยตัด
## แสงขาวจากรอยตัดลุกลามจนจอขาวทั้งจอ ดาเมจใหญ่ แล้วจอกลับมาปกติ ป่าหายไป

const GROW_FROM := 0.35
const GROW_TO := 1.35
const VANISH_AT := 1.5
const SLASH_FROM := 1.75
const SLASH_GAP := 0.13
const SLASH_COUNT := 20
const SLASH_LIFE := 0.26
const REAPPEAR_AT := 4.45
const FLICK_FROM := 4.6
const FLICK_TO := 4.95
const CUT_AT := 4.85
const GLOW_FROM := 5.05
const WHITE_FROM := 5.55
const WHITE_FULL := 6.25
const FINAL_AT := 6.3
const WHITE_HOLD := 6.75
const WHITE_GONE := 7.35
const SLASH_DMG := 18.0
const FINAL_DMG := 260.0
const HALF_W := 12.0 * 90.0           # ป่าเงากว้างข้างละ 12 หน่วย ราวครึ่งจอ ตัวละครอยู่กลางป่า
const CUT_Y := -340.0                 # ความสูงของรอยตัด กลางป่า (จุดภาพโลก)
const SLIDE := 90.0                   # ต้นไม้ครึ่งบนไถลไปตามรอยตัด
# ป่าเงา ต้นไม้เป็นเงาดำม่วง ขอบเรืองม่วงจางๆ มีตาแมวเรืองในเงา
# สีหลัก MATCHA เขียว (ป่ายามสนธยาเขียวเข้ม) แซมม่วงสนธยา
const TRUNK := Color(0.1, 0.16, 0.09)
const TRUNK_DARK := Color(0.05, 0.08, 0.04)
const LEAF := Color(0.18, 0.32, 0.15)
const LEAF_GLOW := Color(0.72, 0.58, 1.0)
const LEAF_DUSK := Color(0.08, 0.14, 0.07)
const SHADOW_EYE := Color(1.0, 0.85, 0.3)
const FIREFLY := Color(0.85, 1.0, 0.5)
const BLADE := Color(0.7, 1.0, 0.75)
const PINK := Color(1.0, 0.68, 0.78)

var _center := Vector2.ZERO
var _start_x := 0.0
var _trees: Array = []            # [x, สูง, กว้าง, เวลาเกิด, ชั้น(0 หลัง 1 หน้า), เอียง]
var _flies: Array = []            # หิ่งห้อย [x, y, เฟส]
var _slashes: Array = []          # [ตำแหน่ง มุม เวลาเริ่ม โค้ง]
var _leaves: Array = []           # ใบไม้ปลิว [ตำแหน่ง ความเร็ว อายุ หมุน]
var _slash_done := 0
var _final_done := false
var _cut_done := false
var _vanished := false
var _back := false
var _white: ColorRect
var _white_layer: CanvasLayer
var _rng := RandomNumberGenerator.new()

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = WHITE_HOLD
	end_time = WHITE_GONE + 0.1
	Monster.hide_bars = true
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_rng.seed = 7
	_start_x = hero.position.x
	var sum := 0.0
	var n := 0
	for m in caught:
		if is_instance_valid(m):
			sum += (m as Monster).position.x
			n += 1
	var front := _start_x + hero.facing * 6.5 * CombatData.UNIT
	_center = Vector2(sum / float(n) if n > 0 else front, 0.0)
	# ป่าเงาผุดขึ้นรอบตัวละคร ตัวละครอยู่กลางป่า
	_center.x = _start_x
	# ต้นไม้เงาหนาแน่นสองชั้น ชั้นหลังสูงเกือบครึ่งจอ ชั้นหน้าเตี้ยกว่า
	for layer in 2:
		var count := 18 if layer == 0 else 14
		for i in count:
			var k := (float(i) + 0.5) / float(count) * 2.0 - 1.0
			var x := _center.x + k * HALF_W + _rng.randf_range(-40.0, 40.0) + (45.0 if layer == 1 else 0.0)
			var h := _rng.randf_range(560.0, 720.0) if layer == 0 else _rng.randf_range(420.0, 560.0)
			var w := _rng.randf_range(170.0, 230.0) if layer == 0 else _rng.randf_range(150.0, 200.0)
			var born := GROW_FROM + absf(x - _start_x) / (HALF_W * 2.4) * 0.6 + _rng.randf_range(0.0, 0.12)
			_trees.append([x, h, w, born, layer, _rng.randf_range(-0.06, 0.06)])
	for i in 34:
		_flies.append([_center.x + _rng.randf_range(-HALF_W, HALF_W), _rng.randf_range(-620.0, -60.0), _rng.randf() * TAU])
	# จอขาวทั้งจอ อยู่ชั้นของท่านี้เอง
	_white_layer = CanvasLayer.new()
	_white_layer.layer = 6
	page.add_child(_white_layer)
	_white = ColorRect.new()
	_white.color = Color(1.0, 1.0, 1.0, 0.0)
	_white.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_white.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_white_layer.add_child(_white)

func _hit_all(dmg: float) -> void:
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _hand() -> Vector2:
	return hero.position + Vector2(hero.facing * 46.0, -92.0)

func _stage_tick(delta: float) -> void:
	hero.vel = Vector2.ZERO
	# หายตัวเข้าป่า
	if not _vanished and _t >= VANISH_AT:
		_vanished = true
		_set_model_visible(false)
		_leaf_burst(hero.position + Vector2(0.0, -70.0), 26, 900.0)
		_shake = maxf(_shake, 4.0)
	# ฟันในป่า 20 ฮิต
	while _slash_done < SLASH_COUNT and _t >= SLASH_FROM + SLASH_GAP * float(_slash_done):
		var p := Vector2(_center.x + _rng.randf_range(-HALF_W * 0.85, HALF_W * 0.85), _rng.randf_range(-520.0, -90.0))
		var ang := _rng.randf_range(-0.9, 0.9) + (PI if _rng.randf() < 0.5 else 0.0)
		_slashes.append([p, ang, _t, _rng.randf_range(-0.6, 0.6)])
		_hit_all(SLASH_DMG)
		_leaf_burst(p, 9, 700.0)
		_shake = maxf(_shake, 6.0)
		_slash_done += 1
	# โผล่กลับที่เดิม
	if not _back and _t >= REAPPEAR_AT:
		_back = true
		_set_model_visible(true)
		_leaf_burst(hero.position + Vector2(0.0, -70.0), 18, 700.0)
	# รอยตัดแนวนอนกลางป่า
	if not _cut_done and _t >= CUT_AT:
		_cut_done = true
		_shake = 14.0
		_hit_all(SLASH_DMG * 2.0)
		for tr in _trees:
			_leaf_burst(Vector2(float(tr[0]), CUT_Y), 3, 500.0)
	# แสงขาวลุกลามจนจอขาว แล้วจางกลับ
	var wk := 0.0
	if _t >= WHITE_FROM and _t < WHITE_HOLD:
		wk = clampf((_t - WHITE_FROM) / (WHITE_FULL - WHITE_FROM), 0.0, 1.0)
		wk = wk * wk
	elif _t >= WHITE_HOLD:
		wk = 1.0 - clampf((_t - WHITE_HOLD) / (WHITE_GONE - WHITE_HOLD), 0.0, 1.0)
	if is_instance_valid(_white):
		_white.color = Color(0.99, 0.96, 0.91, wk * 0.85)   # แฟลชขาวเป็นครีมนุ่ม ไม่แสบตา
	if not _final_done and _t >= FINAL_AT:
		_final_done = true
		_hit_all(FINAL_DMG)
		_shake = 24.0
	_tick_leaves(delta)

func _set_model_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

func _leaf_burst(at: Vector2, count: int, speed: float) -> void:
	for i in count:
		var a := _rng.randf() * TAU
		_leaves.append([at, Vector2(cos(a), sin(a) * 0.8 - 0.4) * _rng.randf_range(speed * 0.3, speed), 0.0, _rng.randf() * TAU])
	if _leaves.size() > 200:
		_leaves = _leaves.slice(_leaves.size() - 200)

func _tick_leaves(delta: float) -> void:
	for l in _leaves:
		l[2] = float(l[2]) + delta
		l[1] = (l[1] as Vector2) * 0.93 + Vector2(sin(float(l[3]) + _t * 4.0) * 60.0, 420.0) * delta
		l[0] = (l[0] as Vector2) + (l[1] as Vector2) * delta
		l[3] = float(l[3]) + delta * 6.0
	_leaves = _leaves.filter(func(l: Array) -> bool: return float(l[2]) < 1.1)

func _finish() -> void:
	Monster.hide_bars = false
	_set_model_visible(true)
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
	if is_instance_valid(_white_layer):
		_white_layer.queue_free()
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if is_instance_valid(_white_layer):
		_white_layer.queue_free()
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
	super._exit_tree()

# ---------------------------------------------------------------- วาด
func _paw(c: Vector2, s: float, col: Color) -> void:
	# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
	draw_circle(c, s * 0.75, Color(col, col.a * 0.35 * 1.0))
	draw_circle(c, s * 0.45, Color(col, col.a * 0.7 * 1.0))

func _ears(c: Vector2, s: float, col: Color) -> void:
	# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
	pass

## ต้นไม้สนธยา ลำต้นเทาเขียวมืด พุ่มใบสามก้อนเรืองเขียว ยอดพุ่มมีหูแมว
## ส่วนที่อยู่สูงกว่ารอยตัดไถลไปตามรอยตัดหลังโดนตัด
func _tree(tr: Array, fade: float) -> void:
	var born := float(tr[3])
	if _t < born:
		return
	var g := clampf((_t - born) / 0.45, 0.0, 1.0)
	var grow := 1.0 - pow(1.0 - g, 3.0) + sin(g * PI) * 0.08
	var x := float(tr[0])
	var h := float(tr[1]) * grow
	if h < 12.0:
		return
	var w := float(tr[2]) * (0.6 + 0.4 * grow)
	var back := int(tr[4]) == 0
	var lean := float(tr[5])
	var sway := sin(_t * 1.6 + x * 0.01) * 6.0
	var slide := 0.0
	if _cut_done:
		var sk := clampf((_t - CUT_AT) / 0.5, 0.0, 1.0)
		slide = SLIDE * (1.0 - pow(1.0 - sk, 2.0)) * (signf(x - _start_x) if x != _start_x else hero.facing)
	var dark := 0.65 if back else 1.0
	var trunk_c := Color(TRUNK.lerp(TRUNK_DARK, 0.5 if back else 0.0), fade)
	var tw := w * 0.16
	var top := Vector2(x + lean * h + sway, -h)
	var off := Vector2(slide, slide * 0.08)
	# ลำต้นสองท่อน ใต้รอยตัดอยู่ที่เดิม เหนือรอยตัดไถล
	if h > -CUT_Y + 20.0:
		var mid := Vector2(x, 0.0).lerp(top, -CUT_Y / h)
		draw_colored_polygon(PackedVector2Array([Vector2(x - tw, 0.0), Vector2(x + tw, 0.0), mid + Vector2(tw * 0.75, 0.0), mid + Vector2(-tw * 0.75, 0.0)]), trunk_c)
		draw_colored_polygon(PackedVector2Array([mid + Vector2(-tw * 0.75, 0.0) + off, mid + Vector2(tw * 0.75, 0.0) + off, top + Vector2(tw * 0.4, 0.0) + off, top + Vector2(-tw * 0.4, 0.0) + off]), trunk_c)
	else:
		off = Vector2.ZERO
		draw_colored_polygon(PackedVector2Array([Vector2(x - tw, 0.0), Vector2(x + tw, 0.0), top + Vector2(tw * 0.4, 0.0), top + Vector2(-tw * 0.4, 0.0)]), trunk_c)
	# พุ่มใบ
	var crown := top + off
	var base_leaf := LEAF.lerp(LEAF_DUSK, 0.35 if back else 0.0)
	var leaf := Color(base_leaf.r * dark, base_leaf.g * dark, base_leaf.b * dark)
	var r := w * 0.5
	draw_circle(crown + Vector2(0.0, r * 0.2), r * 1.35, Color(LEAF_GLOW, 0.1 * fade))
	draw_circle(crown + Vector2(-r * 0.55, r * 0.35), r * 0.8, Color(leaf, fade))
	draw_circle(crown + Vector2(r * 0.55, r * 0.35), r * 0.8, Color(leaf, fade))
	draw_circle(crown + Vector2(0.0, -r * 0.1), r * 0.95, Color(leaf.lightened(0.08), fade))
	draw_circle(crown + Vector2(-r * 0.25, -r * 0.35), r * 0.35, Color(LEAF_GLOW, 0.35 * fade))
	_ears(crown + Vector2(0.0, -r * 0.88), r * 0.6, Color(leaf.lightened(0.08), fade))
	# ขอบพุ่มเรืองม่วงจางๆ ให้เห็นรูปเงา
	draw_arc(crown + Vector2(0.0, -r * 0.1), r * 0.95, PI * 1.1, PI * 1.9, 12, Color(LEAF_GLOW, 0.35 * fade), 3.0, true)
	# ตาแมวเรืองในเงา กะพริบ บางต้น
	if int(x) % 3 == 0:
		var blink := 1.0 if fmod(_t + x * 0.003, 2.2) > 0.15 else 0.1
		for sd in [-1.0, 1.0]:
			var e := crown + Vector2(sd * r * 0.22, r * 0.2)
			draw_circle(e, r * 0.11, Color(SHADOW_EYE, 0.25 * fade))
			draw_colored_polygon(PackedVector2Array([e + Vector2(0.0, -r * 0.08 * blink), e + Vector2(r * 0.05, 0.0), e + Vector2(0.0, r * 0.08 * blink), e + Vector2(-r * 0.05, 0.0)]), Color(SHADOW_EYE, fade))
	if not back:
		_paw(crown + Vector2(0.0, r * 0.15), r * 0.22, Color(LEAF_GLOW, 0.45 * fade))

## รอยฟันโค้งในป่า แกนขาวเรืองเขียว จางเร็ว
func _slash(s: Array, fade: float) -> void:
	var age := _t - float(s[2])
	if age < 0.0 or age > SLASH_LIFE:
		return
	var k := age / SLASH_LIFE
	var a := (1.0 - k) * fade
	var c: Vector2 = s[0]
	var ang := float(s[1])
	var bend := float(s[3])
	var u := Vector2(cos(ang), sin(ang))
	var pts := PackedVector2Array()
	var reach := 300.0 * minf(k * 3.0, 1.0) + 10.0
	for i in 13:
		var t := float(i) / 12.0 - 0.5
		pts.append(c + u * t * reach * 2.0 + u.orthogonal() * (0.25 - t * t) * 160.0 * bend)
	draw_polyline(pts, Color(LEAF_GLOW, 0.45 * a), 26.0 * (1.0 - k) + 4.0, true)
	draw_polyline(pts, Color(1.0, 1.0, 1.0, a), 8.0 * (1.0 - k) + 2.0, true)
	draw_circle(c, 40.0 * (1.0 - k) + 1.0, Color(1.0, 1.0, 1.0, 0.5 * a))

## เงาแมวเขียวพุ่งระหว่างรอยฟัน
func _blur(fade: float) -> void:
	if _slash_done < 2 or _t > SLASH_FROM + SLASH_GAP * float(SLASH_COUNT) + 0.1:
		return
	var a: Array = _slashes[_slash_done - 2]
	var b: Array = _slashes[_slash_done - 1]
	var k := clampf((_t - float(b[2])) / SLASH_GAP, 0.0, 1.0)
	var from: Vector2 = a[0]
	var to: Vector2 = b[0]
	draw_line(from, from.lerp(to, k) + Vector2(0.5, 0.0), Color(LEAF_GLOW, 0.5 * fade), 10.0, true)
	for i in 5:
		var t := clampf(k - float(i) * 0.12, 0.0, 1.0)
		var p := from.lerp(to, t)
		var al := (0.75 - float(i) * 0.14) * fade
		draw_circle(p, 34.0, Color(0.55, 0.8, 0.4, al))
		_ears(p + Vector2(0.0, -26.0), 34.0, Color(0.55, 0.8, 0.4, al))

func _draw() -> void:
	var fade := 1.0 - clampf((_t - WHITE_FULL) / 0.3, 0.0, 1.0)
	if fade <= 0.0:
		return
	# พื้นป่าเรืองแสงจางๆ
	var spread := clampf((_t - GROW_FROM) / (GROW_TO - GROW_FROM), 0.0, 1.0)
	if spread > 0.02:
		draw_colored_polygon(PackedVector2Array([Vector2(_center.x - HALF_W * 1.1 * spread, -10.0), Vector2(_center.x + HALF_W * 1.1 * spread, -10.0), Vector2(_center.x + HALF_W * 1.2 * spread, 60.0), Vector2(_center.x - HALF_W * 1.2 * spread, 60.0)]), Color(LEAF_GLOW, 0.12 * fade))
	for tr in _trees:
		if int(tr[4]) == 0:
			_tree(tr, fade)
	# หิ่งห้อย
	for f in _flies:
		var p := Vector2(float(f[0]) + sin(_t * 1.3 + float(f[2])) * 30.0, float(f[1]) + cos(_t * 1.7 + float(f[2])) * 20.0)
		var tw := 0.5 + 0.5 * sin(_t * 6.0 + float(f[2]) * 3.0)
		draw_circle(p, 9.0, Color(FIREFLY, 0.25 * tw * spread * fade))
		draw_circle(p, 3.5, Color(FIREFLY, tw * spread * fade))
	for tr in _trees:
		if int(tr[4]) == 1:
			_tree(tr, fade)
	for s in _slashes:
		_slash(s, fade)
	_blur(fade)
	# ใบไม้ปลิว
	for l in _leaves:
		var la := (1.0 - float(l[2]) / 1.1) * fade
		var p: Vector2 = l[0]
		var rot := float(l[3])
		var u := Vector2(cos(rot), sin(rot)) * 12.0
		draw_colored_polygon(PackedVector2Array([p - u, p + u.orthogonal() * 0.45, p + u, p - u.orthogonal() * 0.45]), Color(LEAF_GLOW if int(rot * 3.0) % 2 == 0 else LEAF, la))
	# สะบัดดาบพลังงาน กวาดจากบนลงล่างไปข้างหน้า
	if _back and _t < FLICK_TO + 0.35:
		var hand := _hand()
		var fk := clampf((_t - FLICK_FROM) / (FLICK_TO - FLICK_FROM), 0.0, 1.0)
		var e := 1.0 - pow(1.0 - fk, 3.0)
		var ang := lerpf(-1.9, 0.25, e)
		var u := Vector2(cos(ang) * hero.facing, sin(ang))
		var tip := hand + u * 260.0
		var bl := 1.0 - clampf((_t - FLICK_TO) / 0.35, 0.0, 1.0)
		if fk > 0.0 and fk < 1.0:
			for i in 6:
				var aa := lerpf(-1.9, 0.25, clampf(e - float(i) * 0.06, 0.0, 1.0))
				var uu := Vector2(cos(aa) * hero.facing, sin(aa))
				draw_line(hand, hand + uu * 260.0, Color(LEAF_GLOW, 0.18 * (1.0 - float(i) / 6.0) * fade), 22.0, true)
		draw_line(hand, tip, Color(LEAF_GLOW, 0.5 * bl * fade), 20.0, true)
		draw_line(hand, tip, Color(BLADE.lightened(0.5), bl * fade), 7.0, true)
		draw_circle(hand, 14.0, Color(1.0, 0.82, 0.3, bl * fade))
		_ears(tip + u * 6.0, 18.0, Color(BLADE, bl * fade))
	# รอยตัดแนวนอนกลางป่า พุ่งจากตัวละครไปสุดป่า แล้วเรืองขาวหนาขึ้นเรื่อยๆ
	if _cut_done:
		var ck := clampf((_t - CUT_AT) / 0.18, 0.0, 1.0)
		var left := _center.x - HALF_W * 1.25
		var right := _center.x + HALF_W * 1.25
		# ตัวละครอยู่กลางป่า รอยตัดพุ่งออกทั้งสองข้างพร้อมกัน ขาดทั้งป่า
		var from_x := _start_x
		var glow := clampf((_t - GLOW_FROM) / (WHITE_FULL - GLOW_FROM), 0.0, 1.0)
		var thick := 10.0 + 160.0 * glow * glow
		for to_x in [left, right]:
			var end_x := lerpf(from_x, float(to_x), ck)
			draw_rect(Rect2(Vector2(minf(from_x, end_x), CUT_Y - thick * 2.0), Vector2(absf(end_x - from_x) + 1.0, thick * 4.0)), Color(1.0, 1.0, 1.0, 0.12 * fade))
			draw_line(Vector2(from_x, CUT_Y), Vector2(end_x + 0.5, CUT_Y), Color(LEAF_GLOW, 0.6 * fade), thick + 18.0, true)
			draw_line(Vector2(from_x, CUT_Y), Vector2(end_x + 0.5, CUT_Y), Color(1.0, 1.0, 1.0, fade), thick, true)
		# แสงขาวลุกลามคลุมป่า
		if glow > 0.0:
			var over_a := glow * glow * 0.8 * fade
			draw_rect(Rect2(Vector2(left, -1350.0), Vector2(right - left, 1450.0)), Color(1.0, 1.0, 1.0, over_a))
			for i in 10:
				var rx := lerpf(left, right, (float(i) + 0.5) / 10.0)
				draw_line(Vector2(rx, CUT_Y), Vector2(rx + sin(float(i) * 2.3) * 120.0, CUT_Y - 500.0 * glow - 1.0), Color(1.0, 1.0, 0.92, 0.5 * glow * fade), 18.0 * glow + 2.0, true)
