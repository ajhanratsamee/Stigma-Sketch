class_name Homunculus
extends Node2D
## โฮมุนครุสตัวเล็กน่ารัก ตัวกลมมีตา ปีกที่หัว เท้ากลมลอยแยกจากตัว สีชมพูอ่อนมาก ลอยตามตัวละคร 1 นาที
## ทุกการใช้สกิลสะสมเกจ เต็มแล้วกดปุ่ม V ยิงลูกบอลดำ

const U := CombatData.UNIT
const LIFE := 60.0
const GAIN := 4.0
const GAUGE_MAX := 100.0
const COST_FULL := 100.0
const COST_HALF := 50.0
const FOLLOW := 5.0
const BEHIND := 1.5
const HOVER := 2.2
const BOB := 0.16
const BODY_R := 24.0
const FOOT_R := 7.5
const FOOT_GAP := 20.0
const FOOT_X := 13.0
const PINK := Color(0.98, 0.72, 0.82)

var hero: Hero
var gauge := 0.0
var pos := Vector2.ZERO
var life := LIFE
var _t := 0.0

func _ready() -> void:
	z_index = 3
	pos = hero.pos + Vector2(-hero.facing * BEHIND, HOVER)
	_place()

func cost() -> float:
	return COST_HALF if hero.has_passive("le_v_half") else COST_FULL

func ready_to_fire() -> bool:
	return gauge >= cost()

## 60.2 ค่าใช้ปุ่ม V เหลือครึ่งเดียว
func spend() -> void:
	gauge = maxf(gauge - cost(), 0.0)

func gain() -> void:
	gauge = minf(gauge + GAIN, GAUGE_MAX)

func _physics_process(delta: float) -> void:
	_t += delta
	life -= delta
	if life <= 0.0 or not is_instance_valid(hero):
		queue_free()
		return
	var want: Vector2 = hero.pos + Vector2(-hero.facing * BEHIND, HOVER + sin(_t * 2.6) * BOB)
	pos = pos.lerp(want, minf(FOLLOW * delta, 1.0))
	_place()
	queue_redraw()

func _place() -> void:
	position = Vector2(pos.x, -pos.y) * U

func _draw() -> void:
	var look := -1.0 if is_instance_valid(hero) and hero.facing < 0.0 else 1.0
	var feet_lift := sin(_t * 5.0) * 2.5
	for s in [-1.0, 1.0]:
		var foot := Sketch.oval(Vector2(float(s) * FOOT_X, BODY_R + FOOT_GAP + feet_lift * float(s)), FOOT_R, FOOT_R, 14)
		draw_colored_polygon(foot, Sketch.PAPER)
		Sketch.hatch(self, foot, PINK, 2930, 4.0)
		foot.append(foot[0])
		Sketch.line(self, foot, 2931, 2.2, 0.2)
	var body := Sketch.oval(Vector2.ZERO, BODY_R, BODY_R, 26)
	draw_colored_polygon(body, Sketch.PAPER)
	Sketch.hatch(self, body, PINK, 2932, 7.0)
	body.append(body[0])
	Sketch.line(self, body, 2933, 2.8, 0.3)
	var flap := sin(_t * 12.0) * 5.0
	for s in [-1.0, 1.0]:
		var side := float(s)
		var wing := PackedVector2Array([
			Vector2(side * 6.0, -BODY_R + 2.0), Vector2(side * 16.0, -BODY_R - 16.0 - flap),
			Vector2(side * 30.0, -BODY_R - 13.0 - flap), Vector2(side * 19.0, -BODY_R - 1.0),
		])
		draw_colored_polygon(wing, Sketch.PAPER)
		wing.append(wing[0])
		Sketch.line(self, wing, 2934, 2.2, 0.2)
	var eye := Vector2(look * 7.0, -2.0)
	draw_circle(eye, 9.0, Color.WHITE)
	draw_arc(eye, 9.0, 0.0, TAU, 18, Sketch.INK, 2.2, true)
	draw_circle(eye + Vector2(look * 2.5, 0.0), 4.2, Sketch.INK)
