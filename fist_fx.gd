class_name FistFx
extends Node2D
## เอฟเฟกต์หมัดกับเท้าของ CAT ASH สีเทานุ่ม ทรงกลมมน มีวงแรงกระแทก ควันฟุ้งกลมๆ ไม่มีดาวแฉก
## kind: jab hook upper kick round spin axe knee dash dive sweep

const GRAY := Color(0.66, 0.66, 0.72)
const LIGHT := Color(0.93, 0.93, 0.96)
const DEEP := Color(0.45, 0.45, 0.52)

var kind := "jab"
var dir := 1.0
var life := 0.3
var follow: Node2D
var _t := 0.0
var _puffs: Array = []

## เรียกจาก walk_page._cast ชื่อเอฟเฟกต์ขึ้นต้น fs_
static func cast(page: WalkPage, fx: String) -> void:
	var node := FistFx.new()
	node.kind = fx.get_slice("_", 1)
	node.dir = page.hero.facing
	node.position = page.hero.position
	if node.kind in ["spin", "dash"]:
		node.follow = page.hero
		node.life = 0.4
	if node.kind in ["axe", "dive", "sweep"]:
		node.life = 0.42
	page.world.add_child(node)

func _ready() -> void:
	var at := _center()
	for i in 7:
		var a := randf() * TAU
		_puffs.append([at, Vector2(cos(a), sin(a) * 0.7) * randf_range(80.0, 200.0), randf_range(10.0, 20.0)])

## จุดศูนย์กลางเอฟเฟกต์ เทียบตำแหน่งตัวละคร
func _center() -> Vector2:
	match kind:
		"upper":
			return Vector2(dir * 80.0, -150.0)
		"axe", "dive", "sweep":
			return Vector2(dir * 90.0, -10.0)
		"knee":
			return Vector2(dir * 80.0, -120.0)
		"spin":
			return Vector2(0.0, -80.0)
	return Vector2(dir * 100.0, -80.0)

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if is_instance_valid(follow):
		position = follow.position
	for p in _puffs:
		p[0] = (p[0] as Vector2) + (p[1] as Vector2) * delta
		p[1] = (p[1] as Vector2) * 0.88
	queue_redraw()

## เส้นโค้งปลายมน แสงฟุ้งรอบนอก แกนสว่าง
func _soft_arc(c: Vector2, r: float, a0: float, a1: float, w: float, a: float) -> void:
	draw_arc(c, r, a0, a1, 24, Color(GRAY, 0.35 * a), w * 2.0, true)
	draw_arc(c, r, a0, a1, 24, Color(LIGHT, 0.9 * a), w, true)
	for ang in [a0, a1]:
		var p := c + Vector2(cos(ang), sin(ang)) * r
		draw_circle(p, w * 0.5, Color(LIGHT, 0.9 * a))

func _draw() -> void:
	var k := _t / life
	var a := 1.0 - k
	var c := _center()
	var grow := 1.0 - pow(1.0 - minf(k * 2.0, 1.0), 3.0)
	# วงแรงกระแทกกลมขยายออก
	draw_arc(c, 30.0 + 60.0 * grow, 0.0, TAU, 32, Color(GRAY, 0.6 * a), 8.0 * a + 1.0, true)
	draw_circle(c, 26.0 * (1.0 - k * 0.6), Color(LIGHT, 0.55 * a))
	match kind:
		"hook":
			_soft_arc(c - Vector2(dir * 60.0, 0.0), 80.0, -0.9 if dir > 0.0 else PI - 0.9, 0.9 if dir > 0.0 else PI + 0.9, 12.0, a)
		"upper":
			_soft_arc(c + Vector2(-dir * 40.0, 60.0), 90.0, -PI * 0.5 - 0.6, -PI * 0.5 + 0.6, 12.0, a)
		"kick", "round", "knee":
			var start := -0.7 if dir > 0.0 else PI - 0.7
			_soft_arc(c - Vector2(dir * 70.0, 0.0), 95.0, start, start + 1.4, 14.0, a)
		"spin":
			_soft_arc(c, 120.0 * grow + 30.0, _t * 18.0, _t * 18.0 + 4.2, 12.0, a)
		"axe", "dive":
			# วงฝุ่นบนพื้นเป็นวงรี
			draw_set_transform(c, 0.0, Vector2(1.0, 0.3))
			draw_arc(Vector2.ZERO, 50.0 + 150.0 * grow, 0.0, TAU, 40, Color(GRAY, 0.7 * a), 10.0 * a + 2.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			_soft_arc(c + Vector2(-dir * 30.0, -110.0), 110.0, PI * 0.5 - 0.5, PI * 0.5 + 0.5, 12.0, a)
		"sweep":
			draw_set_transform(c - Vector2(dir * 60.0, 0.0), 0.0, Vector2(1.0, 0.35))
			_soft_arc(Vector2.ZERO, 120.0, 0.0, PI, 14.0, a)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"dash":
			for i in 4:
				var y := -40.0 - float(i) * 30.0
				var x0 := -dir * (60.0 + float(i) * 25.0)
				draw_line(Vector2(x0, y), Vector2(x0 - dir * 90.0 * a, y), Color(LIGHT, 0.7 * a), 8.0, true)
				draw_circle(Vector2(x0, y), 4.0, Color(LIGHT, 0.7 * a))
	# ควันกลมๆ ฟุ้งออก
	for p in _puffs:
		draw_circle(p[0], float(p[2]) * (1.0 + k), Color(GRAY.lerp(LIGHT, 0.4), 0.55 * a))
