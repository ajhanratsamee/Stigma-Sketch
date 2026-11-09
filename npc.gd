class_name TownNpc
extends Node2D
## NPC แมวในเมือง โมเดล 3D แบบเดียวกับตัวละคร (style "cat_npc") ยืนเฉยๆ ตัวเด้งเบาๆ หันหาตัวละครเมื่อเข้าใกล้
## สร้างโมเดลเฉพาะตอนอยู่ใกล้จอ ไกลออกไปลบโมเดลทิ้ง ผิวตัวแมวมีแคชไว้ สร้างใหม่ได้เร็ว

const NAME_SIZE := 36
const ACTIVE_RANGE := 1700.0      # ระยะจากกล้อง (จุดของ world) ที่ยังสร้างโมเดลไว้

var data: Dictionary = {}
var page: WalkPage
var _body: Hero
var _t := 0.0
var _label: Node2D
var talk_mark := false            # มีเควสให้รับ/ส่ง ขึ้น ! บนหัว

func _ready() -> void:
	_t = randf() * 6.0
	_label = Node2D.new()
	_label.z_index = 5
	_label.draw.connect(_draw_label)
	add_child(_label)

func x_units() -> float:
	return float(data.get("x", 0.0))

func _process(delta: float) -> void:
	_t += delta
	if page == null or page.hero == null:
		return
	var near := absf(page.hero.position.x - global_position_world()) < ACTIVE_RANGE
	if near and _body == null and (not page.has_method("npc_can_build") or page.npc_can_build()):
		_make_body()
	elif not near and _body != null:
		_body.queue_free()
		_body = null
	if _body != null:
		# ตัวเด้งเบาๆ หันหาตัวละครเมื่ออยู่ใกล้
		var d := page.hero.position.x - global_position_world()
		if absf(d) < 300.0 and absf(d) > 4.0:
			_body.facing = signf(d)
		_body.position.y = -absf(sin(_t * 2.2)) * 4.0
	_label.queue_redraw()

## ตำแหน่งแนวนอนในพิกัดของ world (ใช้เทียบกับตัวละคร)
func global_position_world() -> float:
	return x_units() * CombatData.UNIT

func _make_body() -> void:
	_body = Hero.new()
	_body.plain = true
	_body.plain_weapon = "cat"
	_body.set_job("boy")
	_body.facing = -1.0 if randf() < 0.5 else 1.0
	add_child(_body)
	move_child(_body, 0)
	var model := ChibiModel.new()
	model.hero = _body
	model.style = "cat_npc"
	model.npc_look = (data.get("look", {}) as Dictionary)
	_body.plain_model = model
	_body.add_child(model)

func _draw_label() -> void:
	var nm := str(data.get("name", ""))
	if nm == "":
		return
	var y := -250.0 * float((data.get("look", {}) as Dictionary).get("size", 1.0))
	var font := Sketch.font()
	var w := font.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1.0, NAME_SIZE).x
	var r := Rect2(Vector2(-w * 0.5 - 16.0, y - 30.0), Vector2(w + 32.0, 54.0))
	UiStyle.fill(_label, r, Color(1.0, 0.99, 0.96, 0.85), 14.0)
	_label.draw_string(font, Vector2(-w * 0.5, y + 12.0), nm, HORIZONTAL_ALIGNMENT_LEFT, -1.0, NAME_SIZE, UiStyle.INK)
	if talk_mark:
		# เมืองแรกๆ เครื่องหมายใหญ่ขึ้น ผู้เล่นใหม่เห็นชัด
		var k := 1.6 if WalkPage.current_town <= 1 else 1.0
		var c := Vector2(0.0, y - 64.0 * k + sin(_t * 4.0) * 4.0 * k)
		_label.draw_circle(c, 18.0 * k, Color(1.0, 0.75, 0.25))
		_label.draw_arc(c, 18.0 * k, 0.0, TAU, 24, UiStyle.INK, 2.5 * k, true)
		var fs := int(28.0 * k)
		var mw := font.get_string_size("!", HORIZONTAL_ALIGNMENT_LEFT, -1.0, fs).x
		_label.draw_string(font, c + Vector2(-mw * 0.5, float(fs) * 0.36), "!", HORIZONTAL_ALIGNMENT_LEFT, -1.0, fs, UiStyle.INK)
