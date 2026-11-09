class_name Joystick
extends Node2D
## จอยสติ๊กลอย แตะตรงไหนก็ได้ในโซนฝั่งซ้ายของจอ (ไม่ทับช่องสกิล) จอยจะไปเกิดตรงนิ้ว แล้วลากเพื่อเดิน
## ปล่อยแล้วกลับไปจุดพักจางๆ  ลากลงคือกดลง  ลากเร็วไปทางเดิมสองครั้งคือแดช (ตัวละครจับเอง)

const RADIUS := 84.0
const KNOB := 38.0
const DEAD_ZONE := 0.3
const GRAB := 1.35

var _finger := -1
var enabled := true             # ปิดแล้วไม่รับนิ้วและไม่วาด
var zone := Rect2()             # พื้นที่ที่แตะแล้วจอยไปเกิด ว่างคือแตะได้แค่ในวงเดิม
var home := Vector2.ZERO        # จุดพักตอนไม่ได้แตะ
var _knob := Vector2.ZERO

## นิ้วที่จับจอยอยู่ (-1 คือไม่มี) ปุ่มอื่นจะไม่สนนิ้วนี้
func finger() -> int:
	return _finger

## -1 ซ้าย 0 หยุด 1 ขวา
func direction() -> float:
	var x := _knob.x / RADIUS
	return 0.0 if absf(x) < DEAD_ZONE else signf(x)

## ดันจอยแนวนอนเกือบสุดขอบ = วิ่ง ไม่ต้องแตะสองที
const RUN_AT := 0.85
func running() -> bool:
	return _finger != -1 and absf(_knob.x) >= RADIUS * RUN_AT

## ทิศสองแกน -1 ถึง 1  ลงคือ y บวก
func vector() -> Vector2:
	var v := _knob / RADIUS
	return Vector2.ZERO if v.length() < DEAD_ZONE else v

func _input(event: InputEvent) -> void:
	if not visible or not enabled:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			if _finger != -1:
				return
			var inside: bool = zone.has_point(event.position) if zone.size != Vector2.ZERO else event.position.distance_to(position) <= RADIUS * GRAB
			if inside:
				_finger = event.index
				# จอยลอย เกิดตรงนิ้วที่แตะ
				if zone.size != Vector2.ZERO:
					position = event.position
				_move_to(event.position)
		elif event.index == _finger:
			release()
	elif event is InputEventScreenDrag and event.index == _finger:
		_move_to(event.position)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		release()

func _move_to(at: Vector2) -> void:
	_knob = (at - position).limit_length(RADIUS)
	queue_redraw()

func release() -> void:
	_finger = -1
	_knob = Vector2.ZERO
	if zone.size != Vector2.ZERO and home != Vector2.ZERO:
		position = home
	queue_redraw()

func _draw() -> void:
	if not enabled:
		return
	# ไม่ได้แตะ วาดจางๆ ให้รู้ว่าแตะตรงนี้ได้
	var a := 1.0 if _finger != -1 else 0.45
	var ring := Sketch.oval(Vector2.ZERO, RADIUS, RADIUS, 64)
	draw_colored_polygon(ring, Color(Sketch.PAPER, 0.85 * a))
	ring.append(ring[0])
	Sketch.line(self, ring, 300, TouchPad.RING, Sketch.WOBBLE, Color(Sketch.INK, a))
	# ลูกศรบอกทิศ ซ้าย ขวา ลง
	for d in [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]:
		var tip: Vector2 = d * (RADIUS - 12.0)
		var side: Vector2 = d.orthogonal() * 9.0
		draw_colored_polygon(PackedVector2Array([tip, tip - d * 14.0 + side, tip - d * 14.0 - side]), Color(Sketch.INK, 0.5 * a))
	# ดันสุดขอบกำลังวิ่ง ขอบวงเรืองส้มให้รู้
	if running():
		draw_arc(Vector2.ZERO, RADIUS + 6.0, 0.0, TAU, 48, Color(1.0, 0.6, 0.25, 0.8), 6.0, true)
	draw_circle(_knob, KNOB, Color(Sketch.INK, a))
