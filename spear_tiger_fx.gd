class_name SpearTigerFx
extends Node2D
## เอฟเฟกต์สาย PETIT TIGER / FIERCE PROWLER สีส้มลายเสือ ทรงมนปลายกลม ไม่มีดาวแฉก
## kind: impact (พุ่งกระแทกพื้น วงคลื่นกับรอยเท้าเสือ) roll (กลิ้งไปหน้า) rush (พุ่งแทงรัวลายเสือ)
##       spin_down (หมุนหอกฟาดลงหน้า) leap (ดีดตัวถอยหลัง)

const ORANGE := Color(1.0, 0.58, 0.18)
const STRIPE := Color(0.45, 0.2, 0.08)
const CORE := Color(1.0, 0.97, 0.9)

var kind := "impact"
var dir := 1.0
var life := 0.45
var follow: Node2D
var _t := 0.0
var _dots: Array = []

static func cast(page: WalkPage, fx: String) -> void:
	var node := SpearTigerFx.new()
	node.kind = fx.trim_prefix("spt_")
	node.dir = page.hero.facing
	node.position = page.hero.position
	match node.kind:
		"roll", "rush":
			node.follow = page.hero
			node.life = 0.5
		"impact":
			node.life = 0.55
		"leap":
			node.life = 0.4
	page.world.add_child(node)

func _ready() -> void:
	var n := 10 if kind == "impact" else 6
	for i in n:
		var a := -PI * randf()
		_dots.append([Vector2(0.0, -10.0), Vector2(cos(a), sin(a)) * randf_range(120.0, 300.0)])

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if follow != null and is_instance_valid(follow):
		position = follow.position
	for d in _dots:
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		d[1] = (d[1] as Vector2) * 0.86 + Vector2(0.0, 300.0 * delta)
	queue_redraw()

## เส้นแคปซูลปลายมน 3 ชั้น
func _capsule(from: Vector2, to: Vector2, w: float, a: float, col := ORANGE) -> void:
	draw_line(from, to, Color(col, 0.28 * a), w * 2.2, true)
	draw_circle(from, w * 1.1, Color(col, 0.28 * a))
	draw_circle(to, w * 1.1, Color(col, 0.28 * a))
	draw_line(from, to, Color(col, 0.9 * a), w, true)
	draw_circle(from, w * 0.5, Color(col, 0.9 * a))
	draw_circle(to, w * 0.5, Color(col, 0.9 * a))
	draw_line(from.lerp(to, 0.35), to, Color(CORE, a), w * 0.38, true)
	draw_circle(to, w * 0.19, Color(CORE, a))

## รอยเท้าเสือกลมๆ
func _paw(c: Vector2, r: float, a: float) -> void:
	# รอยเท้าเป็นเม็ดกลมนุ่ม
	draw_circle(c, r * 1.1, Color(ORANGE, 0.3 * a))
	draw_circle(c, r * 0.6, Color(CORE, 0.75 * a))

func _arc_pts(center: Vector2, rx: float, ry: float, from_deg: float, to_deg: float, prog: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var end := lerpf(from_deg, to_deg, prog)
	for i in 19:
		var ang := deg_to_rad(lerpf(from_deg, end, float(i) / 18.0))
		pts.append(center + Vector2(cos(ang) * rx * dir, sin(ang) * ry))
	return pts

func _sweep(pts: PackedVector2Array, width: float, a: float) -> void:
	var n := pts.size()
	for layer in 3:
		var col: Color = [Color(ORANGE, 0.28 * a), Color(ORANGE, 0.9 * a), Color(CORE, a)][layer]
		var wk: float = [2.2, 1.0, 0.38][layer]
		for i in n - 1:
			var w := width * wk * float(i + 1) / float(n) + 1.5
			draw_line(pts[i], pts[i + 1], col, w, true)
			draw_circle(pts[i + 1], w * 0.5, col)
	# ลายเสือเป็นขีดมนสั้นๆ ตามแนวรอย
	for i in range(3, n - 1, 4):
		var d := (pts[i + 1] - pts[i]).normalized()
		var nrm := d.orthogonal() * width * 0.5
		draw_line(pts[i] - nrm, pts[i] + nrm, Color(STRIPE, 0.75 * a), maxf(2.0, width * 0.22), true)

func _draw() -> void:
	var k := _t / life
	var a := 1.0 - k * k
	var grow := minf(k * 3.0, 1.0)
	match kind:
		"impact":
			# วงคลื่นแบนบนพื้น 2 วง กับรอยเท้าเสือหน้าเท้า
			for j in 2:
				var r := (70.0 + 300.0 * k) * (1.0 - 0.3 * float(j))
				var ring := PackedVector2Array()
				for i in 41:
					var ang := TAU * float(i) / 40.0
					ring.append(Vector2(dir * 40.0 + cos(ang) * r, sin(ang) * r * 0.22))
				draw_polyline(ring, Color(ORANGE if j == 0 else CORE, 0.85 * a), 9.0 - 3.0 * float(j), true)
			_paw(Vector2(dir * 120.0, -6.0), 16.0 * grow, a)
			_capsule(Vector2(dir * -60.0, -230.0), Vector2(dir * 30.0, -40.0), 14.0, a * (1.0 - k))
		"roll":
			_sweep(_arc_pts(Vector2(0.0, -70.0), 90.0, 90.0, 90.0, 450.0, grow), 18.0, a)
			_capsule(Vector2(dir * -120.0, -20.0), Vector2(dir * -20.0, -20.0), 8.0, a * 0.8)
		"rush":
			for i in 3:
				var y := -55.0 - 22.0 * float(i)
				var ln := 140.0 + 70.0 * float((i + int(_t * 18.0)) % 3)
				_capsule(Vector2(dir * 50.0, y), Vector2(dir * (50.0 + ln), y), 10.0, a)
			_capsule(Vector2(dir * -200.0, -70.0), Vector2(dir * -40.0, -70.0), 18.0, a * 0.5, STRIPE)
		"spin_down":
			_sweep(_arc_pts(Vector2(dir * 50.0, -100.0), 170.0, 170.0, -200.0, 80.0, grow), 26.0, a)
		"leap":
			_capsule(Vector2(dir * 40.0, -60.0), Vector2(dir * (40.0 + 150.0 * grow), -60.0), 12.0, a)
			for i in 3:
				var p := Vector2(dir * (-30.0 - 50.0 * float(i)) * grow, -8.0)
				draw_circle(p, (14.0 - 3.0 * float(i)) * a + 2.0, Color(CORE, 0.7 * a))
	for d in _dots:
		draw_circle(d[0], 6.0 * a + 1.0, Color(CORE, 0.85 * a))
		draw_circle(d[0], 3.0, Color(ORANGE, a))
