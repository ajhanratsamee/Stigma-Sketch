class_name CatPhoenix
extends Node2D
## FLAME KNIGHT 35.2 นกฟินิกซ์เปลวไฟพุ่งขึ้นจากเท้าช้าๆ ปีกกระพือ หางเปลวไฟยาวพลิ้ว เปลวไฟนุ่มลื่น
## walk_page เป็นคนทำดาเมจเป็นจังหวะตามตำแหน่งนก

const LIFE := 2.6
const RISE := 230.0
const SIZE := 1.6
const DEEP := Color(0.9, 0.22, 0.05)
const MID := Color(1.0, 0.52, 0.12)
const HOT := Color(1.0, 0.85, 0.4)
const CORE := Color(1.0, 0.98, 0.85)

var hit_half := 170.0
var _t := 0.0
var _embers: Array = []

func burst() -> void:
	queue_free()

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	position.y -= RISE * delta * (0.6 + 0.4 * minf(_t, 1.0))
	for i in 3:
		_embers.append([Vector2(randf_range(-40.0, 40.0), randf_range(20.0, 120.0)) * SIZE, Vector2(randf_range(-40.0, 40.0), randf_range(40.0, 140.0)), 0.0])
	for e in _embers.duplicate():
		e[2] += delta
		e[0] = (e[0] as Vector2) + (e[1] as Vector2) * delta
		if e[2] > 0.7:
			_embers.erase(e)
	queue_redraw()

## ลิ้นไฟนุ่ม จากโคนไปปลาย แกนพลิ้วเป็นคลื่น
func _tongue(base: Vector2, dir: Vector2, length: float, width: float, phase: float) -> PackedVector2Array:
	var side := Vector2(-dir.y, dir.x)
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for n in 11:
		var k := float(n) / 10.0
		var sway := sin(k * 4.0 - _t * 10.0 + phase) * width * 0.6 * k
		var spine := base + dir * length * k + side * sway
		var w := width * pow(1.0 - k, 0.7) * (0.6 + 0.4 * sin(k * PI + 0.3))
		left.append(spine - side * w)
		right.append(spine + side * w)
	right.reverse()
	left.append_array(right)
	return left

func _layers(base: Vector2, dir: Vector2, length: float, width: float, phase: float, fade: float) -> void:
	draw_colored_polygon(_tongue(base, dir, length, width, phase), Color(DEEP, 0.75 * fade))
	draw_colored_polygon(_tongue(base, dir, length * 0.8, width * 0.68, phase + 0.4), Color(MID, 0.85 * fade))
	draw_colored_polygon(_tongue(base, dir, length * 0.55, width * 0.4, phase + 0.8), Color(HOT, 0.9 * fade))
	draw_colored_polygon(_tongue(base, dir, length * 0.3, width * 0.18, phase + 1.2), Color(CORE, 0.9 * fade))

func _draw() -> void:
	var fade := clampf(_t / 0.2, 0.0, 1.0) * clampf((LIFE - _t) / 0.4, 0.0, 1.0)
	# ภาพนกใหญ่ขึ้น 1.4 เท่า เด้งตอนเกิด
	var s := SIZE * 1.4 * CatGlow.pop(_t, 0.3)
	CatGlow.halo(self, Vector2(0.0, 0.0), 170.0 * s, Color(1.0, 0.55, 0.15, fade), 5)
	# เสาไฟที่นกพุ่งออกมา ทิ้งไว้ใต้ตัว
	draw_colored_polygon(PackedVector2Array([Vector2(-40.0, 60.0) * s, Vector2(-90.0, 520.0) * s, Vector2(90.0, 520.0) * s, Vector2(40.0, 60.0) * s]), Color(1.0, 0.6, 0.2, 0.18 * fade))
	CatGlow.sparkles(self, Vector2(0.0, 40.0) * s, 220.0 * s, 200.0 * s, 20, _t, Color(1.0, 0.95, 0.75, 0.9 * fade), 16.0, 12.0)
	# หางเปลวไฟยาวสามเส้นห้อยลงล่าง
	for i in 3:
		var dir := Vector2(float(i - 1) * 0.28, 1.0).normalized()
		_layers(Vector2(0.0, 30.0) * s, dir, (170.0 + 30.0 * float(i % 2)) * s, 24.0 * s, float(i) * 1.3, fade)
	# ปีกกระพือ ซ้ายขวา แต่ละปีกมีขนหลายเส้น
	var flap := sin(_t * 7.0)
	for side in [-1.0, 1.0]:
		for f in 5:
			var k := float(f) / 4.0
			var ang := deg_to_rad(-25.0 - 40.0 * k + flap * 28.0)
			var dir := Vector2(cos(ang) * side, sin(ang))
			var root := Vector2(side * 14.0, -6.0 + k * 10.0) * s
			_layers(root, dir, (130.0 - 25.0 * k) * s, (22.0 - 3.0 * k) * s, float(f) * 0.9 + side, fade)
			if f == 0 or f == 2:
				CatGlow.star4(self, root + dir * (130.0 - 25.0 * k) * s, 14.0 * s * fade, Color(1.0, 0.97, 0.85, fade))
	# ตัวและคอ
	_layers(Vector2(0.0, 40.0) * s, Vector2(0.0, -1.0), 110.0 * s, 30.0 * s, 0.5, fade)
	# หัวกับหงอนเปลวไฟ
	var head := Vector2(0.0, -70.0) * s
	CatGlow.ears(self, head, 22.0 * s, Color(MID, fade), Color(CORE, fade))
	draw_circle(head, 22.0 * s, Color(HOT, fade))
	draw_circle(head, 12.0 * s, Color(CORE, fade))
	CatGlow.face(self, head, 22.0 * s, Color(0.6, 0.18, 0.05, fade))
	CatGlow.whiskers(self, head, 22.0 * s, Color(0.6, 0.18, 0.05, 0.7 * fade), 2.0)
	for c in 3:
		_layers(head + Vector2(0.0, -8.0) * s, Vector2(-0.4 + 0.25 * float(c), -1.0).normalized(), 50.0 * s, 8.0 * s, float(c) * 2.0, fade)
	draw_colored_polygon(PackedVector2Array([head + Vector2(14.0, -2.0) * s, head + Vector2(34.0, 4.0) * s, head + Vector2(14.0, 8.0) * s]), Color(HOT, fade))
	for e in _embers:
		var k: float = 1.0 - float(e[2]) / 0.7
		draw_circle(e[0], 3.0 + 5.0 * k, Color(1.0, 0.7, 0.25, k * fade))
