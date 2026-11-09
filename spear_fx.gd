class_name SpearFx
extends Node2D
## รอยหอกของ CAT CITRUS สีส้มแกนขาว ทรงมนปลายกลม ไม่มีดาวแฉก
## kind: thrust (แทงตรง) rapid (แทงรัว) sweep (กวาดแนวนอน) spin (หมุนรอบตัว) vert (ฟาดแนวตั้งลง)
##       up (ฟาดเสยขึ้น) down (แทงเฉียงลง) ground (ฟาดลงพื้น) flip (ตีลังกา)

const ORANGE := Color(1.0, 0.6, 0.22)
const CORE := Color(1.0, 0.97, 0.9)
const DEEP := Color(0.9, 0.38, 0.12)

var kind := "thrust"
var dir := 1.0
var life := 0.3
var follow: Node2D
var _t := 0.0
var _dots: Array = []

## เรียกจาก walk_page._cast ชื่อเอฟเฟกต์ขึ้นต้น sp_
static func cast(page: WalkPage, fx: String) -> void:
	var node := SpearFx.new()
	node.kind = fx.trim_prefix("sp_")
	node.dir = page.hero.facing
	node.position = page.hero.position
	if node.kind == "rapid" or node.kind == "spin":
		node.follow = page.hero
		node.life = 0.45
	if node.kind == "ground":
		node.life = 0.45
	page.world.add_child(node)

func _ready() -> void:
	for i in 6:
		var a := randf() * TAU
		_dots.append([Vector2(dir * 90.0, -70.0), Vector2(cos(a), sin(a)) * randf_range(90.0, 220.0)])

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if follow != null and is_instance_valid(follow):
		position = follow.position
	for d in _dots:
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		d[1] = (d[1] as Vector2) * 0.88
	queue_redraw()

## เส้นโค้งตามจุด หัวหนาท้ายบาง ปลายมน 3 ชั้น
func _sweep(pts: PackedVector2Array, width: float, a: float) -> void:
	var n := pts.size()
	for layer in 3:
		var col: Color = [Color(ORANGE, 0.28 * a), Color(ORANGE, 0.9 * a), Color(CORE, a)][layer]
		var wk: float = [2.2, 1.0, 0.38][layer]
		for i in n - 1:
			var k := float(i + 1) / float(n)
			var w := width * wk * k + 1.5
			draw_line(pts[i], pts[i + 1], col, w, true)
			draw_circle(pts[i + 1], w * 0.5, col)

func _arc(center: Vector2, rx: float, ry: float, from_deg: float, to_deg: float, prog: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var steps := 18
	var end := lerpf(from_deg, to_deg, prog)
	for i in steps + 1:
		var ang := deg_to_rad(lerpf(from_deg, end, float(i) / float(steps)))
		pts.append(center + Vector2(cos(ang) * rx * dir, sin(ang) * ry))
	return pts

## แทงตรง เส้นแคปซูลพุ่งไปหน้า ปลายกลมสว่าง
func _streak(from: Vector2, to: Vector2, w: float, a: float) -> void:
	draw_line(from, to, Color(ORANGE, 0.3 * a), w * 2.2, true)
	draw_circle(to, w * 1.1, Color(ORANGE, 0.3 * a))
	draw_line(from, to, Color(ORANGE, 0.9 * a), w, true)
	draw_circle(to, w * 0.5, Color(ORANGE, 0.9 * a))
	draw_line(from.lerp(to, 0.3), to, Color(CORE, a), w * 0.4, true)
	draw_circle(to, w * 0.25, Color(CORE, a))

func _draw() -> void:
	var k := _t / life
	var a := 1.0 - k * k
	var grow := minf(k * 3.0, 1.0)
	match kind:
		"thrust":
			_streak(Vector2(dir * 40.0, -72.0), Vector2(dir * (80.0 + 240.0 * grow), -72.0), 16.0, a)
		"rapid":
			for i in 4:
				var y := -60.0 - float((i * 37 + int(_t * 60.0)) % 50)
				var ln := 160.0 + float((i * 53 + int(_t * 90.0)) % 120)
				_streak(Vector2(dir * 60.0, y), Vector2(dir * (60.0 + ln), y), 9.0, a * 0.9)
		"sweep":
			_sweep(_arc(Vector2(0.0, -70.0), 210.0, 70.0, -150.0, 60.0, grow), 26.0, a)
		"spin":
			_sweep(_arc(Vector2(0.0, -70.0), 200.0, 64.0, 0.0, 360.0, grow), 22.0, a)
		"vert":
			_sweep(_arc(Vector2(dir * 40.0, -90.0), 160.0, 170.0, -100.0, 70.0, grow), 26.0, a)
		"up":
			_sweep(_arc(Vector2(dir * 40.0, -90.0), 160.0, 170.0, 80.0, -100.0, grow), 26.0, a)
		"down":
			_streak(Vector2(dir * 10.0, -150.0), Vector2(dir * (40.0 + 200.0 * grow), -150.0 + 150.0 * grow), 15.0, a)
		"flip":
			_sweep(_arc(Vector2(0.0, -110.0), 140.0, 140.0, 90.0, 450.0, grow), 20.0, a)
		"ground":
			_sweep(_arc(Vector2(dir * 60.0, -90.0), 190.0, 120.0, -110.0, 30.0, grow), 26.0, a)
			var r := 60.0 + 220.0 * k
			var ring := PackedVector2Array()
			for i in 33:
				var ang := TAU * float(i) / 32.0
				ring.append(Vector2(dir * 180.0 + cos(ang) * r, sin(ang) * r * 0.22))
			draw_polyline(ring, Color(ORANGE, 0.8 * a), 7.0, true)
	for d in _dots:
		draw_circle(d[0], 6.0 * a + 1.0, Color(CORE, 0.85 * a))
		draw_circle(d[0], 3.0, Color(ORANGE, a))
