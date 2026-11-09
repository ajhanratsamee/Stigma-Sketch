class_name BowSkillFx
extends Node2D
## เอฟเฟกต์เสริมของสกิล CAT MATCHA ให้อลังการขึ้น ทุกอย่างทรงกลมมน ไม่มีดาวแฉก ไม่มีรังสีแหลม
## kind:
##   burst     ระเบิดลมใหญ่ วงลมซ้อนหลายชั้นหมุน ใบไม้ปลิว จุดกลมกระจาย รอยลมบนพื้น
##   puff      ควันกลมเล็กตอนตีโดน
##   leafstorm ใบไม้กับเม็ดลมพัดไปด้านหน้า
##   decal     วงลมบนพื้นขยายออก
##   swirl     ลมหมุนวนรอบตัวตอนร่ายสกิลใหญ่
##   charge    เม็ดลมดูดเข้าหาจุดกลาง แสงโตขึ้น (ติดตามตัวละคร)
##   trail     ติดกับลูกพลัง/ลูกศร ทิ้งเงาซ้อนเป็นเม็ดกลมตามทาง
##   twig      ประดับกับดัก กิ่งไม้มีใบรอบลูกกับดัก
##   stake     ประดับหมุดกับดัก แสงเรืองวนรอบ
##   vine      ประดับเถาวัลย์ขดบนพื้น

var kind := "burst"
var dir := 1.0
var size := 200.0
var life := 0.7
var base := Color(0.55, 0.88, 0.52)
var accent := Color(0.88, 1.0, 0.9)
var follow: Node2D = null
var _t := 0.0
var _seed := 0.0
var _hist: Array = []

func _ready() -> void:
	_seed = randf() * 100.0
	z_index = 2 if kind != "decal" else -1

func _process(delta: float) -> void:
	_t += delta
	if kind in ["trail", "twig", "stake", "vine"]:
		# ประดับติดกับโหนดแม่ หายเมื่อแม่หาย
		var p := get_parent() as Node2D
		if p == null or not is_instance_valid(p) or p.is_queued_for_deletion():
			queue_free()
			return
		if kind == "trail":
			_hist.push_front(p.global_position)
			if _hist.size() > 9:
				_hist.pop_back()
	elif kind == "charge":
		if is_instance_valid(follow):
			position = follow.position + Vector2(dir * 30.0, -70.0)
		if _t > life:
			queue_free()
			return
	elif _t > life:
		queue_free()
		return
	queue_redraw()

func _k() -> float:
	return clampf(_t / maxf(life, 0.01), 0.0, 1.0)

func _leaf(at: Vector2, s: float, ang: float, col: Color) -> void:
	draw_set_transform(at, ang, Vector2(1.0, 0.5))
	draw_circle(Vector2.ZERO, s, col)
	draw_set_transform(at, ang, Vector2(0.55, 0.2))
	draw_circle(Vector2.ZERO, s, Color(1.0, 1.0, 1.0, col.a * 0.45))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw() -> void:
	match kind:
		"burst":
			_draw_burst()
		"puff":
			_draw_puff()
		"leafstorm":
			_draw_leafstorm()
		"decal":
			_draw_decal()
		"swirl":
			_draw_swirl()
		"charge":
			_draw_charge()
		"trail":
			_draw_trail()
		"twig":
			_draw_twig()
		"stake":
			_draw_stake()
		"vine":
			_draw_vine()

func _draw_burst() -> void:
	var k := _k()
	var e := 1.0 - pow(1.0 - k, 3.0)
	var a := 1.0 - k
	# แสงฟุ้งกลาง
	for i in 6:
		draw_circle(Vector2.ZERO, size * (0.25 + 0.12 * float(i)) * (0.5 + e), Color(base, 0.1 * a))
	# วงลมซ้อน 3 ชั้น หมุนสวนกัน เป็นเส้นโค้งปลายมน
	for ring in 3:
		var r := size * (0.45 + 0.28 * float(ring)) * (0.4 + e * 0.8)
		var spin := _t * (4.0 - float(ring)) * (1.0 if ring % 2 == 0 else -1.0) + _seed
		var col := accent if ring == 1 else base
		for s in 3:
			var a0 := spin + TAU * float(s) / 3.0
			draw_arc(Vector2.ZERO, r, a0, a0 + 1.4, 18, Color(col, 0.95 * a), maxf(8.0, size * 0.07 * (1.0 - k * 0.5)), true)
	# เม็ดกลมกระจายออก
	for i in 16:
		var ang := _seed + TAU * float(i) / 16.0
		var d := size * (0.3 + 1.1 * e) * (0.85 + 0.25 * sin(float(i) * 2.3))
		draw_circle(Vector2(cos(ang), sin(ang) * 0.75) * d, maxf(10.0, size * 0.06) * (1.0 - k * 0.6), Color(accent if i % 2 == 0 else base, a))
	# ใบไม้ปลิวขึ้นหมุน
	for i in 10:
		var ang := _seed * 2.0 + TAU * float(i) / 10.0
		var d := size * (0.2 + 1.3 * e)
		var p := Vector2(cos(ang) * d, sin(ang) * d * 0.6 - size * 0.5 * e)
		_leaf(p, maxf(18.0, size * 0.09), ang + _t * 6.0, Color(base.darkened(0.15), a))

func _draw_puff() -> void:
	var k := _k()
	var a := 1.0 - k
	for i in 6:
		var ang := _seed + TAU * float(i) / 6.0
		var d := size * (0.2 + 0.9 * k)
		draw_circle(Vector2(cos(ang), sin(ang)) * d, size * (0.28 - 0.18 * k), Color(accent if i % 2 == 0 else base, 0.7 * a))
	draw_arc(Vector2.ZERO, size * (0.3 + 1.0 * k), 0.0, TAU, 24, Color(1.0, 1.0, 1.0, 0.85 * a), 6.0, true)

func _draw_leafstorm() -> void:
	var k := _k()
	var a := 1.0 - clampf((k - 0.6) / 0.4, 0.0, 1.0)
	for i in 22:
		var f := float(i) / 22.0
		var x := dir * size * (f * 0.3 + k * (0.7 + 0.5 * fposmod(f * 7.3, 1.0)))
		var y := -40.0 - size * 0.45 * fposmod(f * 3.7, 1.0) + sin(_t * 9.0 + f * 20.0) * 18.0
		if i % 3 == 0:
			_leaf(Vector2(x, y), 26.0, _t * 8.0 + f * 9.0, Color(base.darkened(0.1), a))
		else:
			draw_circle(Vector2(x, y), 11.0 + 7.0 * fposmod(f * 5.1, 1.0), Color(accent if i % 2 == 0 else base, 0.9 * a))
	# เส้นลมโค้งยาว ปลายมน
	for j in 3:
		var y0 := -60.0 - float(j) * size * 0.14
		var pts := PackedVector2Array()
		for s in 12:
			var u := float(s) / 11.0
			pts.append(Vector2(dir * size * u * (0.4 + k), y0 + sin(u * PI * 2.0 + _t * 6.0 + float(j)) * 16.0))
		draw_polyline(pts, Color(accent, 0.75 * a), 10.0, true)

func _draw_decal() -> void:
	var k := _k()
	var a := 1.0 - k
	for i in 3:
		var kk := clampf(k * 1.3 - float(i) * 0.15, 0.0, 1.0)
		var rx := size * (0.3 + 0.9 * kk)
		var pts := PackedVector2Array()
		for s in 33:
			var ang := TAU * float(s) / 32.0
			pts.append(Vector2(cos(ang) * rx, sin(ang) * rx * 0.18))
		draw_polyline(pts, Color(base if i != 1 else accent, 0.75 * a), 10.0 - float(i) * 2.0, true)
	# ใบไม้ตกพื้นรอบวง
	for i in 8:
		var ang := _seed + TAU * float(i) / 8.0
		_leaf(Vector2(cos(ang) * size * (0.4 + 0.6 * k), sin(ang) * size * 0.1), 20.0, ang, Color(base.darkened(0.2), 0.9 * a))

func _draw_swirl() -> void:
	var k := _k()
	var a := sin(k * PI)
	for ring in 3:
		var r := size * (0.6 + 0.25 * float(ring))
		for s in 14:
			var ang := _t * (5.0 - float(ring)) + TAU * float(s) / 14.0 + float(ring)
			var p := Vector2(cos(ang) * r, sin(ang) * r * 0.35 - size * (0.2 + 0.25 * float(ring)) - 60.0)
			if s % 4 == 0:
				_leaf(p, 24.0, ang * 2.0, Color(base.darkened(0.1), a))
			else:
				draw_circle(p, 12.0, Color(accent if s % 2 == 0 else base, 0.85 * a))

func _draw_charge() -> void:
	var k := _k()
	var grow := clampf(_t / 0.9, 0.0, 1.0)
	for i in 5:
		draw_circle(Vector2.ZERO, (30.0 + 60.0 * grow) * (0.4 + 0.15 * float(i)), Color(accent, 0.12))
	draw_circle(Vector2.ZERO, 14.0 + 20.0 * grow, Color(1.0, 1.0, 1.0, 0.85))
	for i in 14:
		var ang := _seed + TAU * float(i) / 14.0 + _t * 3.0
		var d := 160.0 * (1.0 - fposmod(_t * 1.6 + float(i) * 0.13, 1.0))
		draw_circle(Vector2(cos(ang), sin(ang)) * d, 13.0, Color(base if i % 2 == 0 else accent, 0.95))

func _draw_trail() -> void:
	var n := _hist.size()
	for i in n:
		var p: Vector2 = to_local(_hist[i])
		var f := 1.0 - float(i) / float(maxi(n, 1))
		draw_circle(p, size * 0.45 * f + 6.0, Color(accent if i % 2 == 0 else base, 0.7 * f))

func _draw_twig() -> void:
	# กิ่งไม้สามกิ่งรอบลูกกับดัก ปลายมีใบ หมุนช้าๆ
	for i in 3:
		var ang := _t * 1.5 + TAU * float(i) / 3.0
		var tip := Vector2(cos(ang), sin(ang)) * size * 1.1
		draw_line(Vector2.ZERO, tip, Color(0.55, 0.38, 0.22), 6.0, true)
		draw_circle(tip, 4.0, Color(0.55, 0.38, 0.22))
		_leaf(tip + Vector2(cos(ang + 0.6), sin(ang + 0.6)) * 12.0, 13.0, ang + 0.6, base)
		_leaf(tip + Vector2(cos(ang - 0.6), sin(ang - 0.6)) * 12.0, 11.0, ang - 0.6, base.lightened(0.15))
	draw_circle(Vector2.ZERO, size * 0.35, Color(accent, 0.35 + 0.15 * sin(_t * 6.0)))

func _draw_stake() -> void:
	# แสงเรืองวนรอบหมุดกับดัก
	for i in 6:
		var ang := _t * 3.0 + TAU * float(i) / 6.0
		draw_circle(Vector2(cos(ang) * size * 1.4, -size * 1.2 + sin(ang) * size * 0.4), 6.0, Color(accent, 0.8))
	draw_circle(Vector2(0.0, -size * 2.2), size * 0.6 + 4.0 * sin(_t * 5.0), Color(accent, 0.5))

func _draw_vine() -> void:
	# เถาวัลย์ขดเป็นวงบนพื้น มีใบ
	for c in 3:
		var pts := PackedVector2Array()
		var off := float(c) * 2.1
		for s in 25:
			var ang := off + TAU * float(s) / 24.0
			var r := size * (0.5 + 0.12 * sin(ang * 3.0 + _t * 2.0))
			pts.append(Vector2(cos(ang) * r, sin(ang) * r * 0.25 - 6.0))
		draw_polyline(pts, Color(0.35, 0.6, 0.3), 5.0, true)
	for i in 8:
		var ang := TAU * float(i) / 8.0 + _t
		_leaf(Vector2(cos(ang) * size * 0.55, sin(ang) * size * 0.14 - 6.0), 11.0, ang, base)
