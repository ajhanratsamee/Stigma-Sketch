class_name WolfBall
extends Node2D
## ลูกบอลมืดหน้าแมวหมาป่าของ CAT CITRUS สาย PETIT FANG / LUPINE DIRE
## ทรงกลมสีม่วงดำ แสงฟุ้งม่วง หูแหลมปลายมน ตาเรืองแสง จมูกกับปากเล็กๆ ลอยไปตามทิศ
## pierce true ทะลุโดนทุกตัวตัวละครั้ง  false โดนตัวแรกแล้วแตก

const BODY := Color(0.07, 0.05, 0.06)
const RIM := Color(1.0, 0.55, 0.15)
const GLOW := Color(1.0, 0.6, 0.2)
const EYE := Color(0.18, 0.12, 0.12)
const FACE := Color(1.0, 0.99, 0.97)
const PINK := Color(0.95, 0.6, 0.85)

var vel := Vector2.ZERO
var radius := 52.0
var dmg := 10.0
var pierce := true
var extra := {}
var life := 1.2
var _t := 0.0
var _hit := {}
var _pop := -1.0               # เวลาแตก ถ้า >= 0 กำลังแตกอยู่

func _process(delta: float) -> void:
	_t += delta
	if _pop >= 0.0:
		_pop += delta
		if _pop >= 0.25:
			queue_free()
		queue_redraw()
		return
	position += vel * delta
	life -= delta
	if life <= 0.0 or position.y >= -10.0:
		_burst()
		return
	var page := get_tree().current_scene as WalkPage
	if page != null:
		for e in get_tree().get_nodes_in_group("monsters"):
			var m := e as Monster
			if m == null or _hit.has(m) or m.state == "dead":
				continue
			if (m.position + Vector2(0.0, -WalkPage.MONSTER_MID)).distance_to(position) > radius + WalkPage.MONSTER_HIT_R:
				continue
			_hit[m] = true
			var h := {"type": "flinch", "dmg": dmg, "skill": true, "kb": 0.8, "stun": 0.5, "magic": true}
			h.merge(extra, true)
			page._strike(m, h, signf(vel.x) if vel.x != 0.0 else 1.0)
			if not pierce:
				_burst()
				return
	queue_redraw()

func _burst() -> void:
	_pop = 0.0
	queue_redraw()

func _draw() -> void:
	var f := signf(vel.x) if vel.x != 0.0 else 1.0
	if _pop >= 0.0:
		# แตกเป็นวงแหวนม่วงกับเม็ดกลมๆ
		var k := _pop / 0.25
		draw_arc(Vector2.ZERO, radius * (1.0 + k * 0.8), 0.0, TAU, 40, Color(GLOW, 1.0 - k), 8.0 * (1.0 - k) + 1.0, true)
		for i in 8:
			var a := TAU * float(i) / 8.0
			draw_circle(Vector2(cos(a), sin(a)) * radius * (0.6 + k * 1.2), 8.0 * (1.0 - k) + 0.5, Color(RIM, 1.0 - k))
		return
	var r := radius * (1.0 + 0.04 * sin(_t * 14.0))
	# หางม่วงจางๆ เป็นเม็ดกลมไล่ขนาด
	var back := -vel.normalized()
	for i in 5:
		var k := float(i + 1) / 6.0
		draw_circle(back * r * (0.7 + k * 1.6), r * (0.55 - k * 0.4), Color(GLOW, 0.3 * (1.0 - k)))
	# แสงฟุ้ง
	draw_circle(Vector2.ZERO, r * 1.35, Color(GLOW, 0.14))
	draw_circle(Vector2.ZERO, r * 1.15, Color(GLOW, 0.22))
	# ลูกบอลดำขอบส้ม
	draw_circle(Vector2.ZERO, r, RIM)
	draw_circle(Vector2.ZERO, r * 0.88, BODY)
	draw_circle(Vector2(-r * 0.36, -r * 0.42), r * 0.16, Color(1.0, 0.7, 0.4, 0.18))
	# หน้าแมวสีขาวอยู่ในลูกบอล หันไปตามทิศ
	var fc := Vector2(f * r * 0.08, r * 0.08)
	var fr := r * 0.5
	for side in [-1.0, 1.0]:
		var ea := fc + Vector2(side * fr * 0.25, -fr * 0.7)
		var eb := fc + Vector2(side * fr * 0.95, -fr * 0.35)
		var et := fc + Vector2(side * fr * 0.8, -fr * 1.25)
		draw_colored_polygon(PackedVector2Array([ea, et, eb]), FACE)
		draw_circle(et + Vector2(0.0, fr * 0.08), fr * 0.1, FACE)
		var mid := (ea + eb) * 0.5
		draw_colored_polygon(PackedVector2Array([ea.lerp(mid, 0.4), et.lerp(mid, 0.35), eb.lerp(mid, 0.4)]), PINK)
	draw_set_transform(fc, 0.0, Vector2(1.12, 0.92))
	draw_circle(Vector2.ZERO, fr, FACE)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# ตากลมดำ มีประกาย
	for side in [-1.0, 1.0]:
		var c := fc + Vector2(f * fr * 0.1 + side * fr * 0.42, -fr * 0.08)
		draw_circle(c, fr * 0.16, EYE)
		draw_circle(c + Vector2(-fr * 0.05, -fr * 0.06), fr * 0.06, Color.WHITE)
	# จมูกชมพูกับปาก
	var nose := fc + Vector2(f * fr * 0.1, fr * 0.22)
	draw_circle(nose, fr * 0.08, PINK)
	var mw := fr * 0.14
	draw_arc(nose + Vector2(-mw, fr * 0.07), mw, 0.0, PI, 10, EYE, maxf(1.5, fr * 0.05), true)
	draw_arc(nose + Vector2(mw, fr * 0.07), mw, 0.0, PI, 10, EYE, maxf(1.5, fr * 0.05), true)
