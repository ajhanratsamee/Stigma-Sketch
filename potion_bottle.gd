class_name PotionBottle
extends Node2D
## ขวดยาที่โยนเป็นวิถีโค้ง ถึงพื้นแล้วแตก ทำดาเมจรอบจุดตก แล้วเกิดควันฟุ้ง
## พิกัด pos เป็นหน่วยโลก y คือความสูงจากพื้น

const U := CombatData.UNIT
const GRAVITY := 18.0
const SPIN := 9.0
const BREAK_R := 1.5
const SIZE := Vector2(12.0, 17.0)
const NECK := 9.0
const LIQUID := Color(0.42, 0.72, 0.34)
const TOUCH_X := 0.7
const TOUCH_TOP := 2.0

var pos := Vector2.ZERO
var vel := Vector2.ZERO
var dmg := 8.0
var smoke_life := SmokeCloud.SHORT_LIFE
var smoke_tick := 0.0          # มากกว่าศูนย์คือควันทำดาเมจต่อเนื่อง
var hero: Hero
var broken := false
var delay := 0.0               # รอก่อนปรากฏ ใช้ตอนโปรยทีละขวด
var smoke_wide := 1.0
var hit_monster := false       # ชนตัวมอนก็แตก ไม่ต้องรอถึงพื้น

func _ready() -> void:
	z_index = 2
	position = Vector2(pos.x, -pos.y) * U

func _physics_process(delta: float) -> void:
	if delay > 0.0:
		delay -= delta
		visible = false
		return
	visible = true
	vel.y -= GRAVITY * delta
	pos += vel * delta
	position = Vector2(pos.x, -pos.y) * U
	rotation += SPIN * delta * signf(vel.x if vel.x != 0.0 else 1.0)
	if pos.y <= 0.0 or (hit_monster and _touching_monster()):
		_break()

func _touching_monster() -> bool:
	for e in get_tree().get_nodes_in_group("monsters"):
		if not e.is_invulnerable() and absf(e.pos.x - pos.x) < TOUCH_X and pos.y - e.pos.y < TOUCH_TOP and pos.y > e.pos.y:
			return true
	return false

func _break() -> void:
	broken = true
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) > BREAK_R or absf(e.pos.y - pos.y) > BREAK_R + TOUCH_TOP:
			continue
		var hp_before: float = e.hp
		var dir := signf(e.pos.x - pos.x)
		if e.take_hit(hit, dir if dir != 0.0 else 1.0) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)
	var smoke := SmokeCloud.new()
	smoke.pos = Vector2(pos.x, 0.0)
	smoke.life = smoke_life
	smoke.tick_dmg = smoke_tick
	smoke.wide = smoke_wide
	smoke.hero = hero
	get_parent().add_child(smoke)
	queue_free()

func _draw() -> void:
	draw_bottle(self, Vector2.ZERO)

## รูปขวด ใช้ซ้ำตอนถือในมือ
static func draw_bottle(c: CanvasItem, at: Vector2) -> void:
	var w := SIZE.x
	var h := SIZE.y
	var body := PackedVector2Array([at + Vector2(-w, -h * 0.2), at + Vector2(w, -h * 0.2), at + Vector2(w, h), at + Vector2(-w, h)])
	c.draw_colored_polygon(body, Color.WHITE)
	c.draw_rect(Rect2(at + Vector2(-w, h * 0.2), Vector2(w * 2.0, h * 0.8)), LIQUID)
	body.append(body[0])
	Sketch.line(c, body, 2300, 2.6, 0.3)
	var neck := PackedVector2Array([at + Vector2(-w * 0.45, -h * 0.2), at + Vector2(-w * 0.45, -h * 0.2 - NECK), at + Vector2(w * 0.45, -h * 0.2 - NECK), at + Vector2(w * 0.45, -h * 0.2)])
	Sketch.line(c, neck, 2301, 2.6, 0.2)
