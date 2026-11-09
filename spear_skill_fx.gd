class_name SpearSkillFx
extends Node2D
## เอฟเฟกต์สกิลสายของ CAT CITRUS (หอก) ทรงมนปลายกลมทั้งหมด ไม่มีดาวแฉกหรือแสงแหลม
## base สีหลักของสาย  accent สีแซม (เสือส้มขาว หมาป่าดำส้ม จิ้งจอกขาวฟ้า เต่าเขียวทอง)
## kind: ring วงคลื่นมน  aura ออร่าบัพตามตัว  stripes ลายเสือบนพื้น  moon พระจันทร์กลม
##       orb ไฟจิ้งจอกลูกกลม  clone ร่างเงาแมวจิ้งจอก  dome กระดองครอบตัว  snake งูน้ำแส้
##       rock หินกลมโผล่จากพื้น  sigil วงยันต์บนพื้น  crescent จันทร์เสี้ยวบินไปหน้า  claw อุ้งเล็บ

const INK := Color(0.1, 0.07, 0.08)
const WHITE := Color(1.0, 0.98, 0.94)

var kind := "ring"
var base := Color(1.0, 0.55, 0.15)
var accent := WHITE
var size := 160.0
var life := 0.6
var dir := 1.0
var follow: Node2D
var offset := Vector2.ZERO
var vel := Vector2.ZERO
var _t := 0.0
var _dots: Array = []

func _ready() -> void:
	for i in 10:
		var a := randf() * TAU
		_dots.append([Vector2.ZERO, Vector2(cos(a), sin(a) * 0.6) * randf_range(60.0, 200.0), randf_range(4.0, 10.0)])

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if follow != null and is_instance_valid(follow):
		position = follow.position + offset
	position += vel * delta
	for d in _dots:
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		d[1] = (d[1] as Vector2) * 0.9
	queue_redraw()

## เส้นทรงแคปซูลหัวท้ายกลม
func _cap(a: Vector2, b: Vector2, w: float, col: Color) -> void:
	draw_line(a, b, col, w, true)
	draw_circle(a, w * 0.5, col)
	draw_circle(b, w * 0.5, col)

func _fade() -> float:
	var k := _t / life
	return clampf(_t / 0.12, 0.0, 1.0) * clampf((1.0 - k) / 0.35, 0.0, 1.0)

func _draw() -> void:
	var a := _fade()
	var k := _t / life
	match kind:
		"ring":
			for i in 3:
				var kk := clampf(k * 1.4 - float(i) * 0.18, 0.0, 1.0)
				if kk <= 0.0:
					continue
				var r := size * (0.25 + kk)
				var col := base if i % 2 == 0 else accent
				draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.55))
				draw_arc(Vector2.ZERO, r, 0.0, TAU, 56, Color(col, a * (1.0 - kk)), 16.0 * (1.0 - kk) + 2.0, true)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for d in _dots:
				draw_circle(d[0], float(d[2]) * (1.0 - k), Color(accent, a))
		"aura":
			var p := 0.5 + 0.5 * sin(_t * 6.0)
			draw_set_transform(Vector2(0.0, -70.0), 0.0, Vector2(0.8, 1.15))
			draw_circle(Vector2.ZERO, size * (0.95 + 0.06 * p), Color(base, 0.12 * a))
			draw_arc(Vector2.ZERO, size * (0.9 + 0.05 * p), 0.0, TAU, 48, Color(accent, 0.45 * a), 4.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for i in 6:
				var ph := fmod(_t * 0.8 + float(i) / 6.0, 1.0)
				var x := sin(float(i) * 2.3) * size * 0.6
				draw_circle(Vector2(x, -10.0 - ph * size * 1.6), 7.0 * (1.0 - ph) + 2.0, Color(accent if i % 2 == 0 else base, a * (1.0 - ph)))
		"stripes":
			for i in 7:
				var x := dir * (float(i) / 6.0) * size
				var w := 18.0 + 6.0 * sin(float(i) * 1.7)
				_cap(Vector2(x - dir * 14.0, -6.0), Vector2(x + dir * 20.0, -46.0), w, Color(INK, 0.75 * a))
				_cap(Vector2(x - dir * 4.0, -8.0), Vector2(x + dir * 14.0, -32.0), w * 0.45, Color(base, 0.9 * a))
			draw_set_transform(Vector2(dir * size * 0.5, -4.0), 0.0, Vector2(1.0, 0.18))
			draw_circle(Vector2.ZERO, size * 0.55, Color(base, 0.25 * a))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"moon":
			draw_circle(Vector2.ZERO, size * 1.5, Color(accent, 0.12 * a))
			draw_circle(Vector2.ZERO, size * 1.2, Color(accent, 0.2 * a))
			draw_circle(Vector2.ZERO, size, Color(WHITE.lerp(accent, 0.3), a))
			draw_circle(Vector2(size * 0.3, -size * 0.2), size * 0.18, Color(accent, 0.35 * a))
			draw_circle(Vector2(-size * 0.35, size * 0.25), size * 0.12, Color(accent, 0.35 * a))
			draw_arc(Vector2.ZERO, size, 0.0, TAU, 56, Color(base, 0.8 * a), 6.0, true)
		"orb":
			var r := size * (1.0 + 0.08 * sin(_t * 12.0))
			for i in 4:
				var kk := float(i + 1) / 5.0
				draw_circle(Vector2(0.0, r * (0.4 + kk * 1.1)), r * (0.6 - kk * 0.4), Color(base, 0.4 * (1.0 - kk) * a))
			draw_circle(Vector2.ZERO, r * 1.5, Color(base, 0.16 * a))
			draw_circle(Vector2.ZERO, r, Color(base, 0.85 * a))
			draw_circle(Vector2(0.0, -r * 0.1), r * 0.62, Color(accent, a))
			draw_circle(Vector2(-r * 0.25, -r * 0.3), r * 0.16, Color(WHITE, 0.8 * a))
		"clone":
			var bob := sin(_t * 5.0) * 6.0
			var c := Color(accent, 0.55 * a)
			var e := Color(base, 0.8 * a)
			for i in 3:
				var ang := -PI * 0.5 - dir * (0.6 + float(i) * 0.35)
				_cap(Vector2(-dir * 30.0, -60.0 + bob), Vector2(-dir * 30.0, -60.0 + bob) + Vector2(cos(ang), sin(ang)) * 80.0, 26.0, Color(c, c.a * 0.7))
			draw_set_transform(Vector2(0.0, -70.0 + bob), 0.0, Vector2(0.75, 1.0))
			draw_circle(Vector2.ZERO, 55.0, c)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			var head := Vector2(dir * 8.0, -150.0 + bob)
			_cap(head + Vector2(-30.0, -20.0), head + Vector2(-38.0, -62.0), 22.0, c)
			_cap(head + Vector2(30.0, -20.0), head + Vector2(38.0, -62.0), 22.0, c)
			draw_circle(head, 48.0, c)
			draw_circle(head + Vector2(-16.0 + dir * 6.0, -4.0), 6.0, e)
			draw_circle(head + Vector2(16.0 + dir * 6.0, -4.0), 6.0, e)
			draw_arc(head, 52.0, 0.0, TAU, 40, Color(base, 0.7 * a), 3.0, true)
		"dome":
			var p := 0.5 + 0.5 * sin(_t * 5.0)
			var pts := PackedVector2Array()
			for i in 33:
				var ang := PI + PI * float(i) / 32.0
				pts.append(Vector2(cos(ang) * size, sin(ang) * size * 0.95))
			draw_colored_polygon(pts, Color(base, (0.16 + 0.06 * p) * a))
			draw_polyline(pts, Color(accent, 0.85 * a), 6.0, true)
			for row in 3:
				for col in 5:
					var ang := PI + PI * (float(col) + 0.5 + (0.5 if row % 2 == 1 else 0.0)) / 5.5
					var rr := size * (0.35 + 0.22 * float(row))
					draw_arc(Vector2(cos(ang) * rr, sin(ang) * rr * 0.95), size * 0.1, 0.0, TAU, 16, Color(accent, 0.4 * a), 3.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.2))
			draw_arc(Vector2.ZERO, size, 0.0, TAU, 48, Color(accent, 0.6 * a), 5.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"snake":
			var n := 22
			var reach := size * clampf(_t / 0.18, 0.0, 1.0)
			var prev := Vector2.ZERO
			for i in n + 1:
				var t := float(i) / float(n)
				var q := Vector2(dir * reach * t, sin(t * 9.0 - _t * 14.0) * 34.0 * t)
				if i > 0:
					var w := 30.0 * (1.0 - t * 0.6)
					draw_line(prev, q, Color(base, 0.35 * a), w * 1.8, true)
					draw_line(prev, q, Color(base, a), w, true)
					draw_line(prev, q, Color(WHITE, 0.6 * a), w * 0.3, true)
					draw_circle(q, w * 0.5, Color(base, a))
				prev = q
			draw_circle(prev, 26.0, Color(base, a))
			draw_circle(prev + Vector2(dir * 8.0, -6.0), 6.0, Color(accent, a))
		"rock":
			var rise := clampf(_t / 0.15, 0.0, 1.0) * clampf((life - _t) / 0.25, 0.0, 1.0)
			var h := size * rise
			draw_set_transform(Vector2(0.0, -h * 0.5), 0.0, Vector2.ONE)
			draw_rect(Rect2(-size * 0.28, -h * 0.5, size * 0.56, h), Color(base.darkened(0.25), a), true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			draw_circle(Vector2(0.0, -h), size * 0.28, Color(base.darkened(0.25), a))
			draw_circle(Vector2(-size * 0.08, -h + 4.0), size * 0.16, Color(base, a))
			draw_arc(Vector2(0.0, -h), size * 0.28, PI, TAU, 20, Color(accent, a), 4.0, true)
			for d in _dots:
				draw_circle(d[0], float(d[2]) * (1.0 - k), Color(base, a))
		"sigil":
			var spin := _t * 1.5
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.3))
			draw_circle(Vector2.ZERO, size, Color(base, 0.18 * a))
			draw_arc(Vector2.ZERO, size, 0.0, TAU, 48, Color(accent, 0.9 * a), 6.0, true)
			draw_arc(Vector2.ZERO, size * 0.7, 0.0, TAU, 40, Color(base, 0.8 * a), 4.0, true)
			for i in 6:
				var ang := spin + TAU * float(i) / 6.0
				draw_circle(Vector2(cos(ang), sin(ang)) * size * 0.85, 9.0, Color(accent, a))
			draw_circle(Vector2(0.0, 6.0), size * 0.2, Color(accent, 0.8 * a))
			for i in 4:
				var tx := (float(i) - 1.5) * size * 0.13
				draw_circle(Vector2(tx, -size * 0.2 - absf(tx) * 0.3), size * 0.07, Color(accent, 0.8 * a))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"crescent":
			var pts := PackedVector2Array()
			var inner := PackedVector2Array()
			for i in 25:
				var ang := -PI * 0.5 + PI * float(i) / 24.0
				pts.append(Vector2(cos(ang) * dir * size * 0.55, sin(ang) * size))
				inner.append(Vector2(cos(ang) * dir * size * 0.25, sin(ang) * size * 0.82))
			var poly := pts.duplicate()
			for i in range(inner.size() - 1, -1, -1):
				poly.append(inner[i])
			draw_colored_polygon(poly, Color(base, 0.9 * a))
			draw_polyline(pts, Color(accent, a), 7.0, true)
			draw_circle(pts[0], 6.0, Color(accent, a))
			draw_circle(pts[pts.size() - 1], 6.0, Color(accent, a))
			for i in 4:
				var kk := float(i + 1) / 5.0
				var c0 := -PI * 0.4 if dir > 0.0 else PI * 0.6
				draw_arc(Vector2(-dir * size * 0.3 * kk, 0.0), size * (1.0 - kk * 0.3), c0, c0 + PI * 0.8, 20, Color(base, 0.3 * (1.0 - kk) * a), 8.0, true)
		"claw":
			for i in 4:
				var x := (float(i) - 1.5) * size * 0.22
				var grow := clampf(_t / 0.1, 0.0, 1.0)
				_cap(Vector2(x - dir * size * 0.3, size * 0.45), Vector2(x - dir * size * 0.3, size * 0.45).lerp(Vector2(x + dir * size * 0.3, -size * 0.45), grow), 18.0, Color(INK, 0.7 * a))
				_cap(Vector2(x - dir * size * 0.3, size * 0.45), Vector2(x - dir * size * 0.3, size * 0.45).lerp(Vector2(x + dir * size * 0.3, -size * 0.45), grow), 9.0, Color(base, a))
