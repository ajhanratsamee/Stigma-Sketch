class_name KickTrail
extends Node2D
## รอยเตะสีเขียวของ CAT MATCHA เส้นโค้งเรียวหัวหนาท้ายบาง มีแสงฟุ้ง ใบไม้เล็กๆ ปลิวออก
## kind: front (กวาดหน้า) spin (หมุนรอบตัว) up (เตะเสยขึ้น) flip (พลิกตัวเป็นวงตั้ง) down (เตะเฉียงลง) slide (สไลด์ไปกับพื้น ตามตัว)

const GREEN := Color(0.45, 0.95, 0.45)
const CORE := Color(0.92, 1.0, 0.85)
const DEEP := Color(0.15, 0.6, 0.3)

var kind := "front"
var dir := 1.0
var life := 0.32
var follow: Node2D                 # สไลด์ ตามตัวละคร
var _t := 0.0
var _leaves: Array = []

func _ready() -> void:
	for i in 7:
		var a := randf() * TAU
		_leaves.append([Vector2.ZERO, Vector2(cos(a), sin(a)) * randf_range(120.0, 260.0), randf() * TAU])

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if follow != null and is_instance_valid(follow):
		position = follow.position
	for l in _leaves:
		l[0] = (l[0] as Vector2) + (l[1] as Vector2) * delta
		l[1] = (l[1] as Vector2) * 0.9
		l[2] = float(l[2]) + delta * 8.0
	queue_redraw()

## เส้นโค้งเรียวตามจุด หัวหนาท้ายบาง 3 ชั้น
func _sweep(pts: PackedVector2Array, width: float, a: float) -> void:
	var n := pts.size()
	for i in n - 1:
		var k := float(i + 1) / float(n)
		draw_line(pts[i], pts[i + 1], Color(GREEN, 0.25 * a * k), width * 2.2 * k + 2.0, true)
		draw_line(pts[i], pts[i + 1], Color(GREEN, 0.85 * a * k), width * k + 1.5, true)
		draw_line(pts[i], pts[i + 1], Color(CORE, a * k), width * 0.35 * k + 1.0, true)

func _arc(c: Vector2, rx: float, ry: float, from: float, to: float, prog: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var end := lerpf(from, to, prog)
	var start := lerpf(from, end, 0.0 if prog < 0.6 else (prog - 0.6) / 0.4 * 0.7)
	for i in 14:
		var ang := lerpf(start, end, float(i) / 13.0)
		pts.append(c + Vector2(cos(ang) * rx * dir, sin(ang) * ry))
	return pts

func _draw() -> void:
	var k := clampf(_t / life, 0.0, 1.0)
	var prog := clampf(k * 2.2, 0.0, 1.0)
	var a := 1.0 - clampf((k - 0.45) / 0.55, 0.0, 1.0)
	match kind:
		"front":
			_sweep(_arc(Vector2(dir * 30.0, -70.0), 120.0, 60.0, -2.4, 0.6, prog), 22.0, a)
		"spin":
			_sweep(_arc(Vector2(0.0, -70.0), 130.0, 45.0, -PI * 0.5, PI * 1.6, prog), 20.0, a)
		"up":
			_sweep(_arc(Vector2(dir * 40.0, -60.0), 90.0, 120.0, 1.2, -1.9, prog), 24.0, a)
		"flip":
			_sweep(_arc(Vector2(0.0, -80.0), 95.0, 95.0, PI * 0.5, PI * 2.4, prog), 20.0, a)
		"down":
			_sweep(_arc(Vector2(dir * 20.0, -90.0), 120.0, 90.0, -1.6, 1.0, prog), 24.0, a)
		"slide":
			# รอยไถลเลียดพื้นด้านหลัง ฝุ่นเขียวฟุ้ง
			var back := PackedVector2Array()
			for i in 10:
				var t := float(i) / 9.0
				back.append(Vector2(-dir * (220.0 * (1.0 - t)), -12.0 - sin(t * PI) * 10.0))
			_sweep(back, 18.0, a)
			for i in 5:
				var f := fmod(_t * 3.0 + float(i) * 0.2, 1.0)
				draw_circle(Vector2(-dir * (40.0 + f * 160.0), -14.0 - f * 30.0), 10.0 + f * 16.0, Color(DEEP.lightened(0.5), 0.45 * (1.0 - f) * a))
	for l in _leaves:
		var p: Vector2 = l[0] + Vector2(dir * 60.0, -70.0)
		var rot := float(l[2])
		var u := Vector2(cos(rot), sin(rot)) * 8.0
		SoftDraw.poly(self, PackedVector2Array([p - u, p + u.orthogonal() * 0.45, p + u, p - u.orthogonal() * 0.45]), Color(GREEN if int(rot) % 2 == 0 else DEEP.lightened(0.3), a))
