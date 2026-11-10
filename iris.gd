extends CanvasLayer
## เปลี่ยนฉากแบบวงกลมหดนุ่มๆ (autoload "Iris") วงกลมรอบตัวละครค่อยๆ หดจนปิด แล้วขยายออกในฉากใหม่
## Iris.go(path) เปลี่ยนหน้า  Iris.set_amount(k) ปิดเอง 0 เปิดสุด 1 ปิดสุด (ใช้ตอนวาปชั้นในเมือง)

const CLOSE_TIME := 0.35
const OPEN_TIME := 0.35
const COLOR := Color(0.93, 0.9, 0.86)
const EDGE := Color(0.78, 0.7, 0.66)
const FEATHER := 18.0

var _k := 0.0
var _center := Vector2.ZERO
var _busy := false
var _canvas: Node2D

func _ready() -> void:
	layer = 90
	process_mode = Node.PROCESS_MODE_ALWAYS
	_canvas = Node2D.new()
	_canvas.draw.connect(_draw_iris)
	add_child(_canvas)

func busy() -> bool:
	return _busy

## ตำแหน่งตัวละครบนจอของหน้าปัจจุบัน ไม่มีใช้กลางจอ
func _hero_center() -> Vector2:
	var v := get_viewport().get_visible_rect().size
	var scene := get_tree().current_scene
	if scene != null:
		var h = scene.get("hero")
		if h is Node2D and is_instance_valid(h):
			return (h as Node2D).get_global_transform_with_canvas().origin + Vector2(0.0, -60.0)
	return v * 0.5

func set_amount(k: float, center := Vector2.INF) -> void:
	_k = clampf(k, 0.0, 1.0)
	_center = _hero_center() if center == Vector2.INF else center
	_canvas.queue_redraw()

## หดวงกลม เปลี่ยนหน้า แล้วขยายออกในหน้าใหม่
func go(path: String) -> void:
	if _busy:
		return
	_busy = true
	var tw := create_tween()
	tw.tween_method(func(k: float) -> void: set_amount(k), 0.0, 1.0, CLOSE_TIME)
	await tw.finished
	get_tree().change_scene_to_file(path)
	# รอหน้าใหม่พร้อม
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	var tw2 := create_tween()
	tw2.tween_method(func(k: float) -> void: set_amount(1.0 - k), 0.0, 1.0, OPEN_TIME)
	await tw2.finished
	set_amount(0.0)
	_busy = false

func _draw_iris() -> void:
	if _k <= 0.0:
		return
	var v := get_viewport().get_visible_rect().size
	var far := 0.0
	for corner in [Vector2.ZERO, Vector2(v.x, 0.0), v, Vector2(0.0, v.y)]:
		far = maxf(far, _center.distance_to(corner))
	var r := (far + FEATHER * 2.0) * (1.0 - _k)
	var w := far * 2.0 + 40.0
	_canvas.draw_arc(_center, r + w * 0.5, 0.0, TAU, 96, COLOR, w, true)
	# ขอบนุ่ม ไล่จางเข้าด้านใน
	for i in 4:
		var rr := r - float(i) * FEATHER * 0.25 - 2.0
		if rr > 0.0:
			_canvas.draw_arc(_center, rr, 0.0, TAU, 72, Color(COLOR, 0.5 - float(i) * 0.12), FEATHER * 0.25 + 1.0, true)
	if r > 1.0:
		_canvas.draw_arc(_center, r + 1.0, 0.0, TAU, 72, Color(EDGE, 0.55), 2.2, true)
	if _k >= 1.0:
		_canvas.draw_rect(Rect2(Vector2.ZERO, v), COLOR)
