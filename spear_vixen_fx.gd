class_name SpearVixenFx
extends Node2D
## เอฟเฟกต์สาย PETIT VIXEN / PHANTOM VULPINE ของ CAT CITRUS ทรงมนน่ารัก ไม่มีดาวแฉก
## claw: รอยข่วนจิ้งจอกเก้าหาง 3-4 เส้นขนาน ขาวแกน ฟ้าอ่อนเรือง  ring: วงกระแทกพื้น
## poof: ควันวาป  pin: ปิ่นปักผมบินไปทำดาเมจเอง

const WHITE := Color(1.0, 1.0, 1.0)
const SKY := Color(0.62, 0.84, 1.0)
const PINK := Color(1.0, 0.7, 0.84)
const GOLD := Color(1.0, 0.84, 0.4)

var kind := "claw"
var dir := 1.0
var life := 0.5
var angle := -PI * 0.5          # ทิศรอยข่วน (เรเดียน) ค่าเริ่มต้นข่วนขึ้น
var size := 180.0
var lines := 4
var radius := 260.0
# ปิ่นปักผม
var page: WalkPage
var vel := Vector2.ZERO
var dmg := 0.0
var extra := {}
var _once := {}
var _t := 0.0
var _dots: Array = []

func _ready() -> void:
	for i in 7:
		var a := randf() * TAU
		_dots.append([Vector2.ZERO, Vector2(cos(a), sin(a) * 0.6) * randf_range(80.0, 220.0), randf_range(4.0, 9.0)])

func _process(delta: float) -> void:
	_t += delta
	if kind == "pin":
		_tick_pin(delta)
	if _t >= life:
		queue_free()
		return
	for d in _dots:
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		d[1] = (d[1] as Vector2) * 0.9
	queue_redraw()

func _tick_pin(delta: float) -> void:
	position += vel * delta
	rotation = vel.angle()
	if page == null or not is_instance_valid(page):
		return
	# ปิ่นปักลงพื้นแล้วหยุด
	if position.y >= 0.0:
		position.y = 0.0
		vel = Vector2.ZERO
		return
	if vel == Vector2.ZERO:
		return
	page._hit_area(position.x, 70.0, dmg, dir, _once, extra, Vector2(position.y - 50.0, position.y + 50.0))

## เส้นข่วนหนึ่งเส้น หัวท้ายเรียวมน โค้งนิดๆ
func _streak(from: Vector2, to: Vector2, bend: float, w: float, a: float) -> void:
	var n := 12
	var mid := (from + to) * 0.5 + (to - from).orthogonal().normalized() * bend
	var pts := PackedVector2Array()
	for i in n + 1:
		var t := float(i) / float(n)
		pts.append(from.lerp(mid, t).lerp(mid.lerp(to, t), t))
	for layer in 3:
		var col: Color = [Color(SKY, 0.3 * a), Color(SKY, 0.95 * a), Color(WHITE, a)][layer]
		var wk: float = [2.4, 1.0, 0.42][layer]
		for i in n:
			var t := float(i) / float(n)
			var ww := w * wk * sin(PI * clampf(t + 0.5 / float(n), 0.0, 1.0)) + 1.0
			draw_line(pts[i], pts[i + 1], col, ww, true)
			draw_circle(pts[i + 1], ww * 0.5, col)

func _draw_claw(a: float, grow: float) -> void:
	var d := Vector2(cos(angle) * dir, sin(angle))
	var side := d.orthogonal()
	var gap := size * 0.2
	for i in lines:
		var off := (float(i) - float(lines - 1) * 0.5) * gap
		var start := side * off - d * size * 0.5
		var end := start + d * size * grow
		_streak(start, end, size * 0.08 * dir, size * 0.11, a)
	# ประกายกลมๆ ปลายรอย
	for dd in _dots:
		draw_circle(dd[0], float(dd[2]) * a, Color(WHITE, 0.8 * a))

func _draw_ring(a: float, grow: float) -> void:
	var r := radius * (0.3 + 0.7 * grow)
	for layer in 2:
		var pts := PackedVector2Array()
		var rr := r * (1.0 if layer == 0 else 0.7)
		for i in 41:
			var ang := TAU * float(i) / 40.0
			pts.append(Vector2(cos(ang) * rr, sin(ang) * rr * 0.22))
		draw_polyline(pts, Color(SKY if layer == 0 else WHITE, 0.85 * a), 10.0 if layer == 0 else 5.0, true)
	draw_circle(Vector2.ZERO, r * 0.25 * (1.0 - grow * 0.5), Color(WHITE, 0.35 * a))
	for dd in _dots:
		draw_circle(Vector2((dd[0] as Vector2).x * radius / 200.0, -absf((dd[0] as Vector2).y) * 0.6), float(dd[2]) * 1.4 * a, Color(0.85, 0.9, 1.0, 0.7 * a))

func _draw_poof(a: float, grow: float) -> void:
	for i in 6:
		var ang := TAU * float(i) / 6.0
		var p := Vector2(cos(ang), sin(ang) * 0.8) * 50.0 * grow
		draw_circle(p + Vector2(0.0, -60.0), 34.0 * (1.0 - grow * 0.5), Color(0.92, 0.95, 1.0, 0.6 * a))
	draw_circle(Vector2(0.0, -60.0), 40.0 * (1.0 - grow), Color(SKY, 0.5 * a))

## ปิ่นปักผม ก้านทองปลายมน ท้ายเป็นดอกไม้ชมพูห้ากลีบ มีกระดิ่งเล็ก (วาดชี้ไปทาง +x แล้วหมุนตามทิศบิน)
func _draw_pin(a: float) -> void:
	draw_line(Vector2(-40.0, 0.0), Vector2(30.0, 0.0), Color(SKY, 0.35 * a), 16.0, true)
	draw_line(Vector2(-36.0, 0.0), Vector2(34.0, 0.0), Color(GOLD, a), 6.0, true)
	draw_circle(Vector2(34.0, 0.0), 3.0, Color(GOLD, a))
	var c := Vector2(-40.0, 0.0)
	for i in 5:
		var ang := TAU * float(i) / 5.0
		draw_circle(c + Vector2(cos(ang), sin(ang)) * 9.0, 7.5, Color(PINK, a))
	draw_circle(c, 5.5, Color(1.0, 0.95, 0.6, a))
	draw_line(c + Vector2(4.0, 6.0), c + Vector2(4.0, 18.0), Color(0.9, 0.3, 0.35, a), 2.0, true)
	draw_circle(c + Vector2(4.0, 22.0), 5.0, Color(GOLD, a))

func _draw() -> void:
	var k := _t / life
	var a := 1.0 - k * k
	var grow := clampf(_t / minf(0.14, life * 0.4), 0.0, 1.0)
	match kind:
		"claw":
			_draw_claw(a, grow)
		"ring":
			_draw_ring(a, k)
		"poof":
			_draw_poof(a, k)
		"pin":
			_draw_pin(clampf((life - _t) / 0.3, 0.0, 1.0))
