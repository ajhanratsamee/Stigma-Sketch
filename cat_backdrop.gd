class_name CatBackdrop
extends Node2D
## ฉากหลังมีชีวิตชีวาธีมแมว ใช้หน้าคลังตัวละครกับหน้าสร้างตัวละคร
## พื้นไล่สีพาสเทลอุ่น รอยเท้าแมวจางๆ ไหมพรม ปลา หัวใจ ลอยขึ้นลงช้าๆ ธงราวรอยเท้าด้านบน
## แมวหลากสีโผล่หัวที่ขอบล่าง กะพริบตาเป็นระยะ ทุกอย่างจางพอให้ตัวหนังสือกับการ์ดอ่านง่าย

const TOP := Color(1.0, 0.92, 0.86)
const LOW := Color(0.98, 0.86, 0.9)
const INK := Color(0.2, 0.17, 0.15)
const CATS := [Color(1.0, 0.75, 0.45), Color(0.82, 0.72, 0.95), Color(0.6, 0.6, 0.66), Color(0.98, 0.97, 0.94), Color(0.35, 0.32, 0.38), Color(1.0, 0.65, 0.6)]

var _t := 0.0
var _view := Vector2.ZERO
var _paws: Array = []        # [ตำแหน่ง มุม ขนาด]
var _floaters: Array = []    # [ชนิด ตำแหน่ง เฟส ขนาด]
var _cats: Array = []        # [x สี ขนาด เฟสกะพริบ]

func _ready() -> void:
	_view = get_viewport_rect().size
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	for i in 26:
		_paws.append([Vector2(rng.randf_range(0.0, _view.x), rng.randf_range(80.0, _view.y - 60.0)), rng.randf_range(-0.6, 0.6), rng.randf_range(10.0, 16.0)])
	for i in 9:
		_floaters.append([["yarn", "fish", "heart"][i % 3], Vector2(rng.randf_range(40.0, _view.x - 40.0), rng.randf_range(90.0, _view.y * 0.75)), rng.randf() * TAU, rng.randf_range(16.0, 26.0)])
	var x := 40.0
	var n := 0
	while x < _view.x:
		_cats.append([x, CATS[n % CATS.size()], rng.randf_range(34.0, 46.0), rng.randf() * 5.0])
		x += rng.randf_range(160.0, 260.0)
		n += 1

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()

func _paw(c: Vector2, r: float, angle: float, color: Color) -> void:
	var rot := Transform2D(angle, c)
	draw_colored_polygon(_oval(rot * Vector2(0.0, r * 0.3), r * 0.62, r * 0.5), color)
	for i in 4:
		var a := -2.3 + float(i) * 0.55
		draw_circle(rot * (Vector2(cos(a), sin(a)) * r * 0.95), r * 0.24, color)

func _oval(c: Vector2, rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 20:
		var a := TAU * float(i) / 20.0
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _draw() -> void:
	var steps := 14
	for i in steps:
		var k := float(i) / float(steps - 1)
		draw_rect(Rect2(0.0, _view.y * float(i) / float(steps), _view.x, _view.y / float(steps) + 1.0), TOP.lerp(LOW, k))
	for p in _paws:
		_paw(p[0], p[2], p[1], Color(0.92, 0.7, 0.68, 0.22))
	# ธงราวรอยเท้าด้านบน
	var pts := PackedVector2Array()
	for i in 25:
		var k := float(i) / 24.0
		pts.append(Vector2(_view.x * k, 8.0 + 22.0 * absf(sin(k * PI * 3.0))))
	draw_polyline(pts, Color(INK, 0.5), 1.6, true)
	for i in range(1, 24, 2):
		var flag := pts[i]
		var col: Color = [Color(1.0, 0.7, 0.6), Color(0.75, 0.85, 1.0), Color(1.0, 0.88, 0.55), Color(0.85, 0.75, 1.0)][floori(float(i) / 2.0) % 4]
		draw_colored_polygon(PackedVector2Array([flag + Vector2(-14.0, 0.0), flag + Vector2(14.0, 0.0), flag + Vector2(14.0, 26.0), flag + Vector2(0.0, 34.0), flag + Vector2(-14.0, 26.0)]), Color(col, 0.85))
		_paw(flag + Vector2(0.0, 16.0), 6.0, 0.0, Color(1.0, 1.0, 1.0, 0.85))
	# ของลอยไปมา
	for f in _floaters:
		var c: Vector2 = (f[1] as Vector2) + Vector2(sin(_t * 0.5 + float(f[2])) * 30.0, cos(_t * 0.8 + float(f[2])) * 16.0)
		var r: float = f[3]
		match str(f[0]):
			"yarn":
				draw_circle(c, r, Color(1.0, 0.6, 0.65, 0.35))
				for k in 3:
					draw_arc(c, r * (0.4 + 0.25 * float(k)), _t * 0.5 + float(k), _t * 0.5 + float(k) + 2.2, 10, Color(0.9, 0.45, 0.5, 0.4), 2.0, true)
			"fish":
				var dir := 1.0 if sin(_t * 0.5 + float(f[2])) > 0.0 else -1.0
				draw_colored_polygon(PackedVector2Array([c + Vector2(-r * dir, 0.0), c + Vector2(-r * 0.2 * dir, -r * 0.5), c + Vector2(r * 0.6 * dir, -r * 0.2), c + Vector2(r * dir, -r * 0.55), c + Vector2(r * dir, r * 0.55), c + Vector2(r * 0.6 * dir, r * 0.2), c + Vector2(-r * 0.2 * dir, r * 0.5)]), Color(0.55, 0.75, 0.95, 0.4))
				draw_circle(c + Vector2(-r * 0.6 * dir, -r * 0.08), 2.5, Color(INK, 0.5))
			"heart":
				PaperFront.heart(self, c, r * 0.75, Color(1.0, 0.62, 0.7, 0.4))
	# แมวโผล่หัวที่ขอบล่าง กะพริบตา
	for cat in _cats:
		var x: float = cat[0]
		var col: Color = cat[1]
		var s: float = cat[2]
		var bob := sin(_t * 1.2 + x) * 4.0
		var head := Vector2(x, _view.y - s * 0.5 + bob)
		for side in [-1.0, 1.0]:
			var base := head + Vector2(side * s * 0.55, -s * 0.6)
			draw_colored_polygon(PackedVector2Array([base + Vector2(-s * 0.3, 0.0), base + Vector2(side * s * 0.1, -s * 0.55), base + Vector2(s * 0.3, 0.0)]), col)
		draw_colored_polygon(_oval(head, s, s * 0.85), col)
		var rim := _oval(head, s, s * 0.85)
		rim.append(rim[0])
		draw_polyline(rim, Color(INK, 0.6), 2.0, true)
		var blink := fposmod(_t + float(cat[3]), 4.0) < 0.15
		for side in [-1.0, 1.0]:
			var e := head + Vector2(side * s * 0.38, -s * 0.15)
			if blink:
				draw_line(e + Vector2(-5.0, 0.0), e + Vector2(5.0, 0.0), INK, 2.5, true)
			else:
				draw_circle(e, s * 0.13, INK)
				draw_circle(e + Vector2(-2.0, -2.0), s * 0.04, Color.WHITE)
			draw_circle(head + Vector2(side * s * 0.6, s * 0.15), s * 0.12, Color(1.0, 0.55, 0.6, 0.5))
		draw_arc(head + Vector2(-s * 0.08, s * 0.1), s * 0.08, 0.0, PI, 6, INK, 2.0, true)
		draw_arc(head + Vector2(s * 0.08, s * 0.1), s * 0.08, 0.0, PI, 6, INK, 2.0, true)
