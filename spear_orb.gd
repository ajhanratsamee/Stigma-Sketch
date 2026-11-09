class_name SpearOrb
extends WolfBall
## ลูกพลังกลมของ CAT CITRUS สกิล 1.1 ลูกกลมสีเหลืองขอบดำ เห็นชัด มีแสงฟุ้งเหลืองกับหางเม็ดกลม

const YELLOW := Color(1.0, 0.86, 0.2)
const CORE := Color(1.0, 0.97, 0.7)
const INK := Color(0.08, 0.06, 0.05)

func _draw() -> void:
	var f := signf(vel.x) if vel.x != 0.0 else 1.0
	if _pop >= 0.0:
		var k := _pop / 0.25
		draw_arc(Vector2.ZERO, radius * (1.0 + k * 0.9), 0.0, TAU, 40, Color(YELLOW, 1.0 - k), 9.0 * (1.0 - k) + 1.0, true)
		draw_arc(Vector2.ZERO, radius * (0.8 + k * 0.6), 0.0, TAU, 40, Color(INK, 0.8 * (1.0 - k)), 5.0 * (1.0 - k) + 1.0, true)
		for i in 8:
			var a := TAU * float(i) / 8.0
			draw_circle(Vector2(cos(a), sin(a)) * radius * (0.6 + k * 1.3), 8.0 * (1.0 - k) + 0.5, Color(YELLOW, 1.0 - k))
		return
	var r := radius * (1.0 + 0.05 * sin(_t * 16.0))
	# หางเม็ดกลมเหลืองไล่จาง
	for i in 6:
		var k := float(i + 1) / 7.0
		draw_circle(Vector2(-f * r * (0.6 + k * 1.8), sin(_t * 10.0 + float(i)) * r * 0.12), r * (0.5 - k * 0.38), Color(YELLOW, 0.45 * (1.0 - k)))
	# แสงฟุ้ง
	draw_circle(Vector2.ZERO, r * 1.45, Color(YELLOW, 0.14))
	draw_circle(Vector2.ZERO, r * 1.2, Color(YELLOW, 0.25))
	# ขอบดำหนา ตัวเหลือง แกนสว่าง
	draw_circle(Vector2.ZERO, r, INK)
	draw_circle(Vector2.ZERO, r * 0.82, YELLOW)
	draw_circle(Vector2.ZERO, r * 0.45, CORE)
	draw_arc(Vector2.ZERO, r * 0.62, _t * 6.0, _t * 6.0 + PI * 0.8, 16, Color(INK, 0.55), maxf(2.0, r * 0.08), true)
	draw_circle(Vector2(-r * 0.3, -r * 0.35), r * 0.14, Color(1.0, 1.0, 1.0, 0.7))
