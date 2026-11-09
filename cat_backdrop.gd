class_name CatBackdrop
extends Node2D
## ฉากหลังโทนนุ่มแบบหน้าโหลด "แมวมั้ย" ใช้หน้าคลังตัวละครกับหน้าสร้างตัวละคร
## พื้นสีครีมเทาเรียบ รอยเท้าแมวจางมาก ฟองวงกลมลอยขึ้นช้าๆ แมวลายเส้นนอนขดหลับมุมขวาล่าง หายใจเบาๆ
## ทุกอย่างจางและนิ่ง ไม่แย่งสายตากับการ์ดและตัวหนังสือ

var _t := 0.0
var _view := Vector2.ZERO
var _paws: Array = []        # [ตำแหน่ง มุม ขนาด]
var _bubbles: Array = []     # [x เฟส ขนาด ความเร็ว]

func _ready() -> void:
	_view = get_viewport_rect().size
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	for i in 14:
		_paws.append([Vector2(rng.randf_range(0.0, _view.x), rng.randf_range(90.0, _view.y - 80.0)), rng.randf_range(-0.6, 0.6), rng.randf_range(10.0, 15.0)])
	for i in 7:
		_bubbles.append([rng.randf_range(60.0, _view.x - 60.0), rng.randf(), rng.randf_range(8.0, 18.0), rng.randf_range(0.018, 0.035)])

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()

func _paw(c: Vector2, r: float, angle: float, color: Color) -> void:
	var rot := Transform2D(angle, c)
	draw_colored_polygon(_oval(rot * Vector2(0.0, r * 0.3), r * 0.62, r * 0.5), color)
	for i in 4:
		var a := -2.3 + float(i) * 0.55
		draw_circle(rot * (Vector2(cos(a), sin(a)) * r * 0.95), r * 0.24, color)

func _oval(c: Vector2, rx: float, ry: float, n := 28) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _ring(pts: PackedVector2Array, color: Color, width: float) -> void:
	var p := pts.duplicate()
	p.append(p[0])
	draw_polyline(p, color, width, true)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, _view), UiStyle.SOFT_BG)
	for p in _paws:
		_paw(p[0], p[2], p[1], Color(UiStyle.SOFT_INK, 0.07))
	# ฟองวงกลมลอยขึ้นช้าๆ จางลงตอนใกล้ขอบบน
	for b in _bubbles:
		var k := fposmod(float(b[1]) + _t * float(b[3]), 1.0)
		var y := lerpf(_view.y + 20.0, 60.0, k)
		var x: float = float(b[0]) + sin(_t * 0.6 + float(b[1]) * 9.0) * 14.0
		var a := 0.22 * sin(k * PI)
		draw_arc(Vector2(x, y), float(b[2]), 0.0, TAU, 24, Color(UiStyle.SOFT_INK, a), 2.0, true)
	_sleeping_cat(Vector2(_view.x - 175.0, _view.y - 92.0), 0.32)

## แมวลายเส้นนอนขดหลับ แบบเดียวกับหน้าโหลด ตัวหายใจขึ้นลงเบาๆ มีฟองหลับลอย
func _sleeping_cat(at: Vector2, s: float) -> void:
	var ink := Color(UiStyle.SOFT_INK, 0.85)
	var fur := Color(0.8, 0.75, 0.71)
	var lw := 2.6
	var breathe := 1.0 + sin(_t * 1.6) * 0.025
	# เงาจาง
	draw_colored_polygon(_oval(at + Vector2(-10.0, 118.0 * s), 220.0 * s, 18.0 * s), Color(0.47, 0.4, 0.36, 0.12))
	var body := _oval(at + Vector2(-15.0 * s, 40.0 * s), 185.0 * s, 80.0 * s * breathe)
	draw_colored_polygon(body, fur)
	_ring(body, ink, lw)
	# หาง
	draw_arc(at + Vector2(-95.0 * s, 85.0 * s), 135.0 * s, deg_to_rad(20.0), deg_to_rad(175.0), 24, ink, lw, true)
	# หัว
	var h := at + Vector2(120.0 * s, 20.0 * s)
	var hr := 85.0 * s
	for side in [-1.0, 1.0]:
		var ex: float = h.x + side * 48.0 * s
		var ear := PackedVector2Array([Vector2(ex - 30.0 * s, h.y - 50.0 * s), Vector2(ex + side * 8.0 * s, h.y - 118.0 * s), Vector2(ex + 34.0 * s, h.y - 45.0 * s)])
		draw_colored_polygon(ear, fur)
		draw_polyline(ear, ink, lw, true)
	var head := _oval(h, hr, hr * 0.85)
	draw_colored_polygon(head, fur)
	_ring(head, ink, lw)
	for side in [-1.0, 1.0]:
		draw_arc(h + Vector2(side * 34.0 * s, -2.0 * s), 17.0 * s, deg_to_rad(15.0), deg_to_rad(165.0), 10, ink, 2.2, true)
	draw_circle(h + Vector2(0.0, 19.0 * s), 6.0 * s, Color(0.88, 0.67, 0.65))
	# ฟองหลับ สามวงลอยขึ้น
	for i in 3:
		var k := fposmod(_t * 0.35 + float(i) / 3.0, 1.0)
		var c := h + Vector2(150.0 * s + k * 40.0, -110.0 * s - k * 70.0)
		draw_arc(c, (8.0 + 8.0 * k) * s * 1.8, 0.0, TAU, 20, Color(UiStyle.SOFT_INK, 0.55 * sin(k * PI)), 2.0, true)
