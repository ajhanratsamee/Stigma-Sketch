class_name PotionBubble
extends Node2D
## ขวดยาในวงฟองสบู่ เดินไปโดนได้บัพตามขวด เก็บได้ทุกขวด บัพซ้อนกันได้
## red เหลือง ตัวแดง ติด SA  mana ฟ้าอ่อน เพิ่มมานา  cost ม่วง ลดการใช้มานา

const U := CombatData.UNIT
const COLORS := {"red": Color(0.96, 0.82, 0.24), "mana": Color(0.6, 0.84, 1.0), "cost": Color(0.72, 0.5, 0.92)}
const R := 40.0
const FLOAT_Y := 0.75
const TOUCH_X := 0.95
const TOUCH_Y := 2.2
const LIFE := 15.0

var x := 0.0
var kind := "red"
var hero: Hero
var _t := 0.0

func _ready() -> void:
	z_index = 2
	add_to_group("bubbles")
	position = Vector2(x, -FLOAT_Y) * U

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	if _t >= LIFE:
		queue_free()
		return
	if is_instance_valid(hero) and absf(hero.pos.x - x) < TOUCH_X and hero.pos.y < TOUCH_Y:
		hero.apply_potion(kind)
		queue_free()

func _draw() -> void:
	var bob := Vector2(0.0, sin(_t * 3.0) * 6.0)
	var color: Color = COLORS[kind]
	Sketch.hatch_circle(self, bob, R, Color(color, 0.28))
	var ring := Sketch.oval(bob, R, R, 26)
	ring.append(ring[0])
	Sketch.line(self, ring, 2770, 2.6, 0.4)
	draw_arc(bob + Vector2(-R * 0.3, -R * 0.3), R * 0.28, 2.6, 4.2, 8, Color.WHITE, 3.0, true)
	var body := PackedVector2Array([bob + Vector2(-10.0, -6.0), bob + Vector2(10.0, -6.0), bob + Vector2(10.0, 16.0), bob + Vector2(-10.0, 16.0)])
	Sketch.hatch(self, body, color)
	body.append(body[0])
	Sketch.line(self, body, 2771, 2.2, 0.2)
	Sketch.line(self, PackedVector2Array([bob + Vector2(-5.0, -6.0), bob + Vector2(-5.0, -15.0), bob + Vector2(5.0, -15.0), bob + Vector2(5.0, -6.0)]), 2772, 2.2, 0.2)
