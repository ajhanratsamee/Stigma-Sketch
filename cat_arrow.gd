class_name CatArrow
extends CatFireball
## ลูกศรของ CAT MATCHA ใช้ระบบลูกยิงเดียวกับลูกไฟ (radius size burst tail)
## ก้านไม้ หัวศรรูปหูแมว หางเป็นขนนกรูปรอยเท้า มีแสงเขียวลากตามหลัง ระเบิดเป็นประกายใบไม้เล็กๆ

const SHAFT := Color(0.62, 0.42, 0.24)
const HEAD := Color(0.85, 0.95, 0.8)
const FLETCH := Color(0.45, 0.78, 0.38)
const TRAIL := Color(0.6, 0.95, 0.5)

func _draw() -> void:
	var r := size()
	var fwd := -tail if tail != Vector2.ZERO else Vector2.RIGHT
	var side := fwd.orthogonal()
	if bursting:
		var k := clampf(_burst_t / BURST_TIME, 0.0, 1.0)
		var a := 1.0 - k
		draw_arc(Vector2.ZERO, r * (0.6 + 1.6 * k), 0.0, TAU, 24, Color(TRAIL, a), 4.0 * a + 1.0, true)
		for i in 6:
			var ang := TAU * float(i) / 6.0 + 0.4
			var p := Vector2(cos(ang), sin(ang)) * r * (0.4 + 1.4 * k)
			draw_colored_polygon(PackedVector2Array([p + Vector2(0.0, -6.0) * a, p + Vector2(4.0, 0.0) * a, p + Vector2(0.0, 6.0) * a, p + Vector2(-4.0, 0.0) * a]), Color(1.0, 1.0, 0.85, a))
		return
	var length := r * 3.2
	var tip := fwd * length * 0.5
	var back := -fwd * length * 0.5
	# แสงลากตามหลัง
	for i in 5:
		var k := float(i) / 5.0
		draw_line(back - fwd * k * length * 0.9, back - fwd * (k + 0.2) * length * 0.9, Color(TRAIL, 0.5 * (1.0 - k)), r * 0.5 * (1.0 - k) + 2.0, true)
	draw_circle(Vector2.ZERO, r * 0.9, Color(TRAIL, 0.12))
	# ก้าน
	draw_line(back, tip - fwd * r * 0.4, SHAFT, maxf(3.0, r * 0.16), true)
	# หัวศรรูปหูแมว (สามเหลี่ยมมีด้านในชมพู)
	var hb := tip - fwd * r * 0.6
	draw_colored_polygon(PackedVector2Array([tip + fwd * r * 0.2, hb + side * r * 0.42, hb - side * r * 0.42]), HEAD)
	draw_colored_polygon(PackedVector2Array([tip, hb + side * r * 0.2 + fwd * r * 0.15, hb - side * r * 0.2 + fwd * r * 0.15]), Color(1.0, 0.7, 0.8))
	# ขนนกหางเป็นรอยเท้าแมว
	var fb := back + fwd * r * 0.3
	draw_circle(fb, r * 0.3, FLETCH)
	for i in 3:
		var t := (float(i) - 1.0) * 0.55
		draw_circle(fb - fwd * r * 0.35 + side * r * t, r * 0.14, FLETCH)
