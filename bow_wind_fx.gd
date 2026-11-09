class_name BowWindFx
extends Node2D
## เอฟเฟกต์ลมเขียวของสาย WINDSTARKER / GALE TEMPEST โทนเดียวกับ KickTrail
## kind: gust (ลมพุ่งไปข้างหน้าสั้นๆ ม้วนเป็นเกลียว) lift (ลมหมุนพัดขึ้น ช่วยให้มอนลอย)
##       ram (เส้นความเร็วตอนพุ่งชน ตามตัว) ring (วงลมรอบตัวตอนหมุนเตะกับพื้น) knee (วงกระแทกพื้นตอนเข่าลง)

const GREEN := KickTrail.GREEN
const CORE := KickTrail.CORE
const DEEP := KickTrail.DEEP

var kind := "gust"
var dir := 1.0
var life := 0.45
var reach := 330.0               # gust ไปไกลเท่านี้ จุดภาพ
var follow: Node2D
var _t := 0.0

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if follow != null and is_instance_valid(follow):
		position = follow.position
	queue_redraw()

func _soft_line(a: Vector2, b: Vector2, w: float, al: float) -> void:
	draw_line(a, b, Color(GREEN, 0.25 * al), w * 2.2, true)
	draw_line(a, b, Color(GREEN, 0.8 * al), w, true)
	draw_line(a, b, Color(CORE, al), maxf(1.0, w * 0.35), true)

func _curl(pts: PackedVector2Array, w: float, al: float) -> void:
	for i in pts.size() - 1:
		var k := float(i + 1) / float(pts.size())
		_soft_line(pts[i], pts[i + 1], w * k + 1.0, al * k)

func _draw() -> void:
	var k := clampf(_t / life, 0.0, 1.0)
	var a := 1.0 - clampf((k - 0.5) / 0.5, 0.0, 1.0)
	match kind:
		"gust":
			# ลมม้วนพุ่งไปข้างหน้า 3 เส้นกับเกลียวกลมๆ ที่ปลาย
			var front := reach * clampf(k * 1.8, 0.0, 1.0)
			for j in 3:
				var y := -70.0 + float(j - 1) * 34.0
				var pts := PackedVector2Array()
				for i in 12:
					var t := float(i) / 11.0
					pts.append(Vector2(dir * (front * t), y + sin(t * 9.0 + _t * 20.0 + float(j)) * 8.0))
				_curl(pts, 14.0 - float(j) * 3.0, a)
			for i in 3:
				var c := Vector2(dir * front * (0.55 + float(i) * 0.2), -70.0 + float(i - 1) * 26.0)
				var sp := PackedVector2Array()
				for s in 14:
					var ang := float(s) / 13.0 * TAU * 1.2 + _t * 14.0
					var r := 26.0 * (1.0 - float(s) / 16.0)
					sp.append(c + Vector2(cos(ang) * r * dir, sin(ang) * r))
				_curl(sp, 8.0, a * 0.9)
		"lift":
			# ลมหมุนพัดขึ้น เกลียววงรีซ้อนกันไล่ขึ้น
			for j in 5:
				var f := fmod(k * 1.6 + float(j) * 0.2, 1.0)
				var c := Vector2(dir * 60.0, -30.0 - f * 260.0)
				var rx := 70.0 + f * 40.0
				var pts := PackedVector2Array()
				for s in 16:
					var ang := float(s) / 15.0 * PI * 1.6 + _t * 10.0 + float(j)
					pts.append(c + Vector2(cos(ang) * rx, sin(ang) * rx * 0.28))
				_curl(pts, 10.0, a * (1.0 - f * 0.6))
		"ram":
			# เส้นความเร็วด้านหลังตัว
			for j in 6:
				var y := -30.0 - float(j) * 22.0
				var f := fmod(_t * 4.0 + float(j) * 0.37, 1.0)
				var x0 := -dir * (40.0 + f * 120.0)
				_soft_line(Vector2(x0, y), Vector2(x0 - dir * (90.0 + float(j % 3) * 30.0), y), 6.0, a * (1.0 - f))
			draw_circle(Vector2(dir * 70.0, -95.0), 34.0 * (0.6 + k), Color(GREEN, 0.25 * a))
		"ring":
			# วงลมรอบตัวเลียดพื้น สองชั้นหมุนสวนกัน
			for j in 2:
				var rx := 150.0 + float(j) * 70.0
				var pts := PackedVector2Array()
				var start := _t * (12.0 if j == 0 else -10.0)
				for s in 20:
					var ang := start + float(s) / 19.0 * PI * 1.5
					pts.append(Vector2(cos(ang) * rx, -40.0 + sin(ang) * rx * 0.22))
				_curl(pts, 14.0, a)
		"knee":
			# วงกระแทกพื้นกับฝุ่นเขียวตอนเข่าลง
			var r := 60.0 + k * 170.0
			var pts := PackedVector2Array()
			for s in 24:
				var ang := PI + float(s) / 23.0 * PI
				pts.append(Vector2(cos(ang) * r, sin(ang) * r * 0.25 - 4.0))
			_curl(pts, 12.0, a)
			for i in 6:
				var sx := (float(i) - 2.5) * 40.0
				draw_circle(Vector2(sx, -14.0 - k * 50.0 * (1.0 - absf(sx) / 120.0)), 12.0 + k * 10.0, Color(DEEP.lightened(0.5), 0.5 * a))
