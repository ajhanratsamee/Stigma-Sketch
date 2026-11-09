class_name BowTrapFx
extends Node2D
## รอยดาบของสาย TRAPSTARKER (เขียว) / TWILIGHT (ม่วงดำ มีขนนกดำปลิว)
## รอยเป็นเสี้ยวจันทร์ปลายมนทั้งสองด้าน มีแสงฟุ้ง แกนกลางสว่าง
## kind: slash_down slash_up slash_flat heavy (ฟัน) stab mash rush (แทง) pull (ดึงดาบออก)
##       through through_hit (ฟันทะลุ) curve (ฟันโค้งอ้อมหลัง) dive_streak ground (พุ่งแทงลงกระแทกพื้น)

const TRAP := [Color(0.4, 0.92, 0.45), Color(0.15, 0.55, 0.3), Color(0.92, 1.0, 0.88)]
const DUSK := [Color(0.6, 0.35, 0.95), Color(0.12, 0.04, 0.2), Color(0.95, 0.88, 1.0)]

var kind := "slash_down"
var dir := 1.0
var dusk := false
var follow: Node2D
var life := 0.34
var _t := 0.0
var _start := Vector2.ZERO
var _bits: Array = []           # ขนนก ใบไม้ [จุด ความเร็ว หมุน]
var _seed := 0.0

func _ready() -> void:
	z_index = 3
	_start = position
	_seed = randf() * TAU
	match kind:
		"through", "curve":
			life = 0.5
		"heavy", "pull":
			life = 0.42
		"mash":
			life = 0.18
		"ground":
			life = 0.5
		"dive_streak":
			life = 0.6
		"rush":
			life = 0.3
	var n := 3 if kind == "mash" else 7
	for i in n:
		var a := randf() * TAU
		_bits.append([Vector2(dir * 70.0, -80.0), Vector2(cos(a), sin(a)) * randf_range(100.0, 240.0), randf() * TAU])

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if follow != null and is_instance_valid(follow) and kind in ["rush", "dive_streak"]:
		position = follow.position
	for b in _bits:
		b[0] = (b[0] as Vector2) + (b[1] as Vector2) * delta
		b[1] = (b[1] as Vector2) * 0.9 + Vector2(0.0, 160.0 * delta)
		b[2] = float(b[2]) + delta * 7.0
	queue_redraw()

func _pal() -> Array:
	return DUSK if dusk else TRAP

## เสี้ยวจันทร์ตามเส้นโค้ง หนากลางเรียวปลายสองด้าน (ปลายมน) วาด 3 ชั้น
func _crescent(pts: PackedVector2Array, width: float, a: float) -> void:
	var n := pts.size()
	if n < 3:
		return
	var p: Array = _pal()
	for layer in 3:
		var w: float = [width * 1.9, width, width * 0.32][layer]
		var c: Color = [Color(p[0], 0.28 * a), Color(p[1] if dusk else p[0], 0.9 * a), Color(p[2], a)][layer]
		var outer := PackedVector2Array()
		var inner := PackedVector2Array()
		for i in n:
			var k := float(i) / float(n - 1)
			var tang := (pts[mini(i + 1, n - 1)] - pts[maxi(i - 1, 0)]).normalized()
			var nor := tang.orthogonal()
			# หนาขึ้นไปทางหัวรอย ปลายท้ายเรียว
			var thick := w * sin(PI * k) * (0.55 + 0.45 * k)
			outer.append(pts[i] + nor * thick * 0.5)
			inner.append(pts[i] - nor * thick * 0.5)
		inner.reverse()
		var poly := outer + inner
		if Geometry2D.triangulate_polygon(poly).size() > 0:
			draw_colored_polygon(poly, c)
		else:
			for i in n - 1:
				draw_line(pts[i], pts[i + 1], c, w * 0.6, true)
	# ขอบนอกสีม่วงสว่างของ TWILIGHT
	if dusk:
		for i in n - 1:
			var k := float(i + 1) / float(n)
			draw_line(pts[i], pts[i + 1], Color(p[0], 0.8 * a * sin(PI * k)), 2.5, true)

func _arc(c: Vector2, rx: float, ry: float, from: float, to: float, prog: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var end := lerpf(from, to, prog)
	var start := lerpf(from, end, 0.0 if prog < 0.6 else (prog - 0.6) / 0.4 * 0.75)
	for i in 18:
		var ang := lerpf(start, end, float(i) / 17.0)
		pts.append(c + Vector2(cos(ang) * rx * dir, sin(ang) * ry))
	return pts

## แทงตรง หยดน้ำยาวปลายแหลมมน มีเส้นความเร็ว
func _thrust(at: Vector2, length: float, width: float, a: float) -> void:
	var p: Array = _pal()
	for layer in 3:
		var w: float = [width * 1.8, width, width * 0.35][layer]
		var c: Color = [Color(p[0], 0.25 * a), Color(p[1] if dusk else p[0], 0.9 * a), Color(p[2], a)][layer]
		var poly := PackedVector2Array()
		for i in 11:
			var ang := PI * 0.5 + PI * float(i) / 10.0
			poly.append(at + Vector2(cos(ang) * w * 0.5 * dir, sin(ang) * w * 0.5))
		poly.append(at + Vector2(dir * length * 0.85, -w * 0.12))
		poly.append(at + Vector2(dir * length, 0.0))
		poly.append(at + Vector2(dir * length * 0.85, w * 0.12))
		if dir < 0.0:
			poly.reverse()
		draw_colored_polygon(poly, c)
	for i in 3:
		var y := (float(i) - 1.0) * width * 0.9
		var f := fmod(_t * 5.0 + float(i) * 0.3, 1.0)
		draw_line(at + Vector2(-dir * (30.0 + f * 60.0), y), at + Vector2(-dir * (90.0 + f * 60.0), y), Color(p[0], 0.5 * a * (1.0 - f)), 3.0, true)

func _draw() -> void:
	var k := clampf(_t / life, 0.0, 1.0)
	var prog := clampf(k * 2.2, 0.0, 1.0)
	var a := 1.0 - clampf((k - 0.45) / 0.55, 0.0, 1.0)
	var big := 1.25 if dusk else 1.0
	match kind:
		"slash_down":
			_crescent(_arc(Vector2(dir * 40.0, -62.0), 120.0 * big, 78.0 * big, -1.9, 0.9, prog), 30.0 * big, a)
		"slash_up":
			_crescent(_arc(Vector2(dir * 40.0, -58.0), 115.0 * big, 80.0 * big, 1.1, -1.9, prog), 30.0 * big, a)
		"slash_flat":
			_crescent(_arc(Vector2(0.0, -75.0), 150.0, 48.0, -PI * 0.6, PI * 1.5, prog), 26.0, a)
		"heavy":
			_crescent(_arc(Vector2(dir * 50.0, -68.0), 160.0 * big, 100.0 * big, -2.1, 1.0, prog), 44.0 * big, a)
			draw_arc(Vector2(dir * 150.0, -20.0), 40.0 + k * 120.0, 0.0, TAU, 32, Color(_pal()[0], 0.5 * a), 5.0, true)
		"stab", "rush":
			_thrust(Vector2(dir * 20.0, -70.0), (150.0 + 90.0 * prog) * big, 30.0 * big, a)
		"mash":
			var y := -70.0 + sin(_seed) * 26.0
			_thrust(Vector2(dir * 40.0, y), 150.0 * big, 20.0 * big, a)
		"pull":
			# ดึงดาบออกเป็นเส้นโค้งถอยกลับ มีประกายตรงจุดที่ดึง
			_crescent(_arc(Vector2(dir * 60.0, -60.0), 110.0, 70.0, 0.2, -2.6, prog), 28.0, a)
			draw_circle(Vector2(dir * 140.0, -70.0), 18.0 + k * 50.0, Color(_pal()[2], 0.6 * a))
		"through":
			# รอยฟันยาวจากจุดเริ่มทะลุไปข้างหน้า ตามระยะที่พุ่ง
			var reach := 2.6 * CombatData.UNIT
			var pts := PackedVector2Array()
			for i in 18:
				var t := float(i) / 17.0 * prog
				pts.append(Vector2(dir * (-40.0 + reach * 1.2 * t), -70.0 - sin(t * PI) * 26.0))
			_crescent(pts, 34.0, a)
		"through_hit":
			_crescent(_arc(Vector2(-dir * 20.0, -75.0), 120.0, 40.0, PI * 0.9, PI * 0.05, prog), 24.0, a)
		"curve":
			# ฟันโค้งจากด้านหน้าขึ้นเหนือหัวอ้อมไปด้านหลัง
			# จากจุดเริ่ม ขึ้นเหนือมอน แล้วลงไปด้านหลังมอนตรงจุดที่พุ่งไปถึง
			var reach2 := 1.8 * CombatData.UNIT
			var cp := PackedVector2Array()
			var c_end := PI + PI * 1.05 * clampf(k * 1.8, 0.0, 1.0)
			var c_from := lerpf(PI, c_end, clampf((k - 0.7) / 0.3, 0.0, 0.8))
			for i in 20:
				var ang := lerpf(c_from, c_end, float(i) / 19.0)
				cp.append(Vector2(dir * (reach2 * 0.5 + cos(ang) * (reach2 * 0.5 + 30.0)), -60.0 + sin(ang) * 110.0))
			_crescent(cp, 32.0, a)
		"dive_streak":
			var pts2 := PackedVector2Array()
			for i in 12:
				var t := float(i) / 11.0
				pts2.append(Vector2(-dir * (170.0 * (1.0 - t)), -80.0 - 210.0 * (1.0 - t)))
			_crescent(pts2, 30.0 * big, a)
		"ground":
			var p: Array = _pal()
			draw_set_transform(Vector2(dir * 60.0, -6.0), 0.0, Vector2(1.0, 0.28))
			draw_arc(Vector2.ZERO, 50.0 + k * 230.0, 0.0, TAU, 40, Color(p[0], 0.75 * a), 10.0, true)
			draw_arc(Vector2.ZERO, 30.0 + k * 150.0, 0.0, TAU, 40, Color(p[2], 0.6 * a), 5.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			_thrust(Vector2(dir * 10.0, -60.0), 120.0, 26.0, a * (1.0 - k))
	# ใบไม้เขียว / ขนนกดำปลิว
	var p2: Array = _pal()
	for b in _bits:
		var at: Vector2 = b[0]
		var rot := float(b[2])
		var u := Vector2(cos(rot), sin(rot)) * (10.0 if dusk else 7.0)
		var col: Color = Color(0.08, 0.04, 0.12, a) if dusk else Color(p2[0] if int(rot) % 2 == 0 else p2[1].lightened(0.3), a)
		draw_colored_polygon(PackedVector2Array([at - u, at + u.orthogonal() * 0.35, at + u, at - u.orthogonal() * 0.35]), col)
		if dusk:
			draw_line(at - u, at + u, Color(DUSK[0], 0.6 * a), 1.5, true)
