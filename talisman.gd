class_name Talisman
extends WolfBall
## ยันต์กระดาษน่ารักของ CAT CITRUS สาย PETIT SHELL / GENBU TITAN
## แผ่นกระดาษมุมมน ลายอุ้งเท้าแดงขอบทอง แสงฟุ้งเขียวทองแบบกระดองเต่า หมุนติ้วตอนลอย
## ใช้ระบบเคลื่อนที่และโดนมอนของ WolfBall (pierce ทะลุ / ไม่ทะลุโดนตัวแรกแล้วแตก)

const PAPER := Color(1.0, 0.97, 0.86)
const EDGE := Color(0.95, 0.75, 0.3)
const SIGIL := Color(0.88, 0.22, 0.25)
const SHELL_GLOW := Color(0.55, 0.85, 0.45)
const GOLD := Color(1.0, 0.85, 0.35)

var spin_speed := 9.0

func _draw() -> void:
	if _pop >= 0.0:
		# แตกเป็นวงเขียวทอง กับเศษกระดาษกลมๆ
		var k := _pop / 0.25
		draw_arc(Vector2.ZERO, radius * (0.9 + k * 1.0), 0.0, TAU, 40, Color(SHELL_GLOW, 1.0 - k), 8.0 * (1.0 - k) + 1.0, true)
		draw_arc(Vector2.ZERO, radius * (0.6 + k * 0.8), 0.0, TAU, 40, Color(GOLD, 0.8 * (1.0 - k)), 5.0 * (1.0 - k) + 1.0, true)
		for i in 8:
			var a := TAU * float(i) / 8.0 + 0.3
			draw_circle(Vector2(cos(a), sin(a)) * radius * (0.5 + k * 1.3), 7.0 * (1.0 - k) + 0.5, Color(PAPER if i % 2 == 0 else SIGIL, 1.0 - k))
		return
	var f := signf(vel.x) if vel.x != 0.0 else 1.0
	var r := radius
	# หางแสงเม็ดกลมเขียวทอง
	var back := -vel.normalized() if vel.length() > 1.0 else Vector2(-f, 0.0)
	for i in 5:
		var k := float(i + 1) / 6.0
		draw_circle(back * r * (0.6 + k * 1.7), r * (0.42 - k * 0.32), Color(SHELL_GLOW if i % 2 == 0 else GOLD, 0.35 * (1.0 - k)))
	# แสงฟุ้งรูปหกเหลี่ยมมนแบบกระดองเต่า
	draw_circle(Vector2.ZERO, r * 1.35, Color(SHELL_GLOW, 0.12))
	draw_circle(Vector2.ZERO, r * 1.1, Color(GOLD, 0.15))
	# แผ่นยันต์หมุน
	var ang := _t * spin_speed * f
	draw_set_transform(Vector2.ZERO, ang, Vector2.ONE)
	var w := r * 0.62
	var h := r * 1.0
	UiStyle.fill(self, Rect2(-w - 3.0, -h - 3.0, (w + 3.0) * 2.0, (h + 3.0) * 2.0), EDGE, r * 0.22)
	UiStyle.fill(self, Rect2(-w, -h, w * 2.0, h * 2.0), PAPER, r * 0.18)
	# แถบทองบนล่าง
	UiStyle.fill(self, Rect2(-w * 0.8, -h * 0.82, w * 1.6, h * 0.16), Color(GOLD, 0.85), h * 0.08)
	UiStyle.fill(self, Rect2(-w * 0.8, h * 0.66, w * 1.6, h * 0.16), Color(GOLD, 0.85), h * 0.08)
	# ลายอุ้งเท้าแดงกลางแผ่น
	draw_circle(Vector2(0.0, h * 0.12), w * 0.42, SIGIL)
	for i in 3:
		var tx := (float(i) - 1.0) * w * 0.42
		draw_circle(Vector2(tx, -h * 0.3 - (w * 0.06 if i == 1 else 0.0)), w * 0.17, SIGIL)
	draw_circle(Vector2(-w * 0.62, -h * 0.05), w * 0.13, SIGIL)
	draw_circle(Vector2(w * 0.62, -h * 0.05), w * 0.13, SIGIL)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
