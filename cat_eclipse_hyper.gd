class_name CatEclipseHyper
extends HyperStage
## HYPER ของ ECLIPSE (CAT SUSI) จอดำ กล้องถอยไกล มอนสตั๊น
## ค่อยๆ ลอยขึ้น ปล่อย void ลูกเล็กไปข้างหน้า ลอยค้างสักพัก แล้วขยายใหญ่ขึ้นเรื่อยๆ แบบดูดกลืน
## จนเต็มครึ่งจอด้านหน้า ไม่ล้นมาทางตัวละคร แล้วจอกลับปกติ เริ่มทำดาเมจตอน void เริ่มขยาย

const RISE_TO := 1.2
const AIR_Y := 4.5               # หน่วยเกม
const CAST_AT := 1.4
const FLY_TIME := 0.8            # void ลอยออกไปข้างหน้า
const AHEAD := 1000.0             # void อยู่ข้างหน้า ทั้งวงอยู่ในจอ
const VOID_Y := -380.0
const SMALL := 34.0
const GROW_FROM := 3.0           # เริ่มขยาย เริ่มทำดาเมจ
const GROW_TO := 6.8             # เต็มด้านหน้า
const FULL := 470.0              # void โตสุดแค่เกินครึ่งจอนิดเดียว
const HOLD := 0.5
const TICK := 0.25
const TICK_DMG := 16.0
const VOID_RIM := Color(0.78, 0.62, 0.98)  # สีหลักม่วงอ่อนของ CAT SUSI แซมดำของหลุม
const HOT := Color(1.0, 0.85, 1.0)
const INSIDE := Color(0.05, 0.0, 0.1)

var _tick := 0.0
var _motes: Array = []           # เศษที่ถูกดูดเข้าหา void [มุม ระยะ ความเร็ว]

func _stage_start() -> void:
	open_time = 0.5
	close_from = GROW_TO + HOLD
	end_time = close_from + 0.5
	Monster.hide_bars = true

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _hero_y() -> float:
	if _t < close_from:
		return AIR_Y * _ease(_t / RISE_TO)
	return AIR_Y * (1.0 - _ease((_t - close_from) / 0.4))

func _center() -> Vector2:
	var hand := hero.position + Vector2(hero.facing * 70.0, -120.0)
	var to := Vector2(hero.position.x + hero.facing * AHEAD, VOID_Y)
	return hand.lerp(to, _ease((_t - CAST_AT) / FLY_TIME))

func _radius() -> float:
	if _t < CAST_AT:
		return 0.0
	var born := SMALL * _ease((_t - CAST_AT) / 0.3)
	if _t < GROW_FROM:
		return born * (1.0 + 0.08 * sin(_t * 10.0))
	# ขยายช้าก่อนแล้วเร็วขึ้นเรื่อยๆ เหมือนดูดกลืน
	var k := clampf((_t - GROW_FROM) / (GROW_TO - GROW_FROM), 0.0, 1.0)
	return lerpf(SMALL, FULL, pow(k, 2.6))

func _stage_tick(delta: float) -> void:
	hero.pos.y = _hero_y()
	hero.vel = Vector2.ZERO
	if _t >= GROW_FROM and _t < close_from:
		_tick -= delta
		if _tick <= 0.0:
			_tick = TICK
			_hit_all(TICK_DMG)
			_shake = maxf(_shake, 3.0 + 8.0 * clampf((_t - GROW_FROM) / (GROW_TO - GROW_FROM), 0.0, 1.0))
	if _t >= CAST_AT and _t < close_from and _motes.size() < 180:
		for n in 6:
			_motes.append([randf() * TAU, _radius() + randf_range(200.0, 900.0), randf_range(500.0, 1200.0)])
	for m in _motes.duplicate():
		m[1] = float(m[1]) - float(m[2]) * delta
		m[0] = float(m[0]) + delta * 1.5
		if float(m[1]) <= _radius():
			_motes.erase(m)

func _finish() -> void:
	Monster.hide_bars = false
	hero.pos.y = 0.0
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

func _draw() -> void:
	var r := _radius()
	if r <= 0.5:
		return
	var fade := 1.0 - clampf((_t - close_from) / 0.4, 0.0, 1.0)
	var c := _center()
	# ออร่ามืดรอบตัวแมวที่ลอยอยู่
	var aura_c := hero.position + Vector2(0.0, -70.0)
	for n in 3:
		var ar := 120.0 + 40.0 * float(n) + 10.0 * sin(_t * 4.0 + float(n))
		draw_arc(aura_c, ar, _t * (1.5 + float(n)), _t * (1.5 + float(n)) + 4.2, 32, Color(VOID_RIM, (0.45 - 0.12 * float(n)) * fade), 6.0, true)
	draw_circle(aura_c, 110.0, Color(0.35, 0.1, 0.55, 0.15 * fade))
	# ก้อนแสงม่วงกลมนุ่มลอยวนหลัง void หมุนช้าๆ แทนรังสีแหลม
	for n in 16:
		var a := _t * 0.25 + TAU * float(n) / 16.0
		var len_k := 1.3 + 0.2 * sin(_t * 1.5 + float(n) * 1.3)
		var d := Vector2(cos(a), sin(a))
		draw_circle(c + d * r * len_k, r * 0.12, Color(VOID_RIM, 0.2 * fade))
	# แสงบิดเบี้ยวรอบนอก วงซ้อนจางๆ
	for n in 4:
		var k := float(n + 1)
		draw_arc(c, r * (1.0 + 0.12 * k) + 8.0 * k, 0.0, TAU, 96, Color(VOID_RIM, 0.22 / k * fade), maxf(3.0, r * 0.04), true)
	# จานพลังหมุนรอบขอบ ด้านหนึ่งสว่างกว่า
	var spin := _t * 2.2
	for n in 24:
		var a := spin + TAU * float(n) / 24.0
		var bright := 0.5 + 0.5 * cos(a - spin * 0.3)
		var arc_len := 0.22
		draw_arc(c, r * 1.06, a, a + arc_len, 8, Color(VOID_RIM.lerp(HOT, bright), (0.35 + 0.5 * bright) * fade), maxf(4.0, r * 0.07), true)
	# เนื้อในมืดสนิทมีเกลียวม่วงจางวน
	draw_circle(c, r, Color(INSIDE, fade))
	for arm in 4:
		var pts := PackedVector2Array()
		for n in 24:
			var k := float(n) / 23.0
			var a := -spin * 0.8 + TAU * float(arm) / 4.0 + k * 5.0
			pts.append(c + Vector2(cos(a), sin(a)) * r * 0.95 * (1.0 - k))
		draw_polyline(pts, Color(0.35, 0.1, 0.55, 0.55 * fade), maxf(2.0, r * 0.05), true)
	# ตาแมวกลาง void ม่านตาม่วงทอง รูม่านตาเรียวตั้ง กะพริบช้าๆ
	var blink := clampf(absf(sin(_t * 0.9)) * 3.0, 0.15, 1.0)
	var iris := PackedVector2Array()
	var slit := PackedVector2Array()
	for n in 32:
		var a := TAU * float(n) / 32.0
		iris.append(c + Vector2(cos(a) * r * 0.42, sin(a) * r * 0.62 * blink))
		slit.append(c + Vector2(cos(a) * r * 0.07, sin(a) * r * 0.56 * blink))
	draw_colored_polygon(iris, Color(0.75, 0.35, 0.95, 0.55 * fade))
	var iris_in := PackedVector2Array()
	for p in iris:
		iris_in.append(c + (p - c) * 0.7)
	draw_colored_polygon(iris_in, Color(1.0, 0.8, 0.45, 0.4 * fade))
	draw_colored_polygon(slit, Color(INSIDE, fade))
	draw_circle(c + Vector2(-r * 0.14, -r * 0.24 * blink), r * 0.06, Color(1, 1, 1, 0.7 * fade))
	# หูแมวมืดบนขอบ void
	_kitty_ears(self, c, r * 1.02, Color(INSIDE, fade), Color(0.45, 0.15, 0.6, 0.9 * fade))
	# ขอบฟ้าเหตุการณ์ เส้นสว่าง
	draw_arc(c, r, 0.0, TAU, 96, Color(HOT, 0.95 * fade), maxf(3.0, r * 0.025), true)
	# สายฟ้าม่วงแลบรอบขอบ สุ่มใหม่ทุก 0.05 วิ
	var seed_no := int(_t * 20.0)
	for n in 5:
		var a0 := fposmod(sin(float(seed_no * 7 + n) * 12.9898) * 43758.5453, TAU)
		var pts := PackedVector2Array()
		for i in 6:
			var a := a0 + float(i) * 0.09
			var jag := 1.0 + (fposmod(sin(float(seed_no * 13 + n * 5 + i) * 78.233) * 43758.5453, 1.0) - 0.5) * 0.18
			pts.append(c + Vector2(cos(a), sin(a)) * r * jag * 1.04)
		draw_polyline(pts, Color(HOT, 0.85 * fade), maxf(3.0, r * 0.012), true)
	# เศษถูกดูดเข้าหาเป็นเม็ดกลม
	var mi := 0
	for m in _motes:
		var a: float = m[0]
		var d: float = m[1]
		var dir := Vector2(cos(a), sin(a))
		var tail := d + 110.0
		var near := clampf(1.0 - (d - r) / 1600.0, 0.0, 1.0)
		# เม็ดกลมเรียงเป็นหางสั้นๆ ไหลเข้าหาหลุม แทนเส้นแหลม
		var mc := Color(VOID_RIM.lerp(HOT, near), (0.3 + 0.6 * near) * fade)
		draw_circle(c + dir * d, 6.0, mc)
		draw_circle(c + dir * (d + 40.0), 4.5, Color(mc, mc.a * 0.7))
		draw_circle(c + dir * (d + 75.0), 3.0, Color(mc, mc.a * 0.4))
		if mi % 3 == 0:
			_kitty_paw(self, c + dir * tail, 12.0, Color(VOID_RIM.lerp(HOT, near), (0.3 + 0.6 * near) * fade), a + PI * 0.5)
		mi += 1
