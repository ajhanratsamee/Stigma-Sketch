class_name HyperStage
extends Node2D
## ฉากรวมของ HYPER SKILL หน้าฝึกซ้อม จอสั่น มอนในจอสตั๊น จอเป็นแบบภาพ กล้องถอยออก แล้วกลับปกติตอนจบ
## ท่าจริงอยู่ในคลาสลูก ผ่าน _stage_start และ _stage_tick

signal finished

const ZOOM_FAR := 0.44          # กล้องถอยไกลกว่าปกติตอน HYPER (ถอยน้อยลง HYPER จะได้ดูใหญ่)
const SHAKE_FADE := 3.0
const SHAKE_SPEED := 70.0
## HYPER ที่ออกแบบมาใหญ่เต็มจออยู่แล้ว ใช้กล้องถอยไกลแบบเดิม ไม่ล้นขอบจอ
const BIG_SET_ZOOM := {"CatCrimsonHyper": 0.34, "CatElementalBowHyper": 0.34, "CatElementHyper": 0.34, "CatFlameHyper": 0.34}
const BACK_AT := Vector2(780.0, 690.0)
const BACK_SCALE := 1.5
const BACK_HAND := Vector2(46.0, -132.0)
const BACK_OFF := Vector2(-46.0, -132.0)
const RIM := 7.0
const RIM_COLOR := Color(0.97, 0.96, 0.92)
const LINE_W := 3.0

var page: WalkPage
var hero: Hero
var frame_k := 0.0               # ความเข้มของจอแบบภาพ
var caught: Array = []           # มอนที่สตั๊นอยู่
var open_time := 0.6             # เวลาที่จอเปลี่ยนเป็นแบบภาพเสร็จ
var close_from := 4.0            # เวลาที่เริ่มกลับจอปกติ
var end_time := 4.5
var black_backdrop := true        # HYPER ทุกท่าจอดำ กล้องถอย
var behind_view := false          # มุมกล้องด้านหลัง ซ่อนฉากด้านข้างแล้ววาดฉากเอง
var back_scale := BACK_SCALE
var _start_at := {}              # มอน -> ตำแหน่งตอนเริ่ม
var _t := 0.0
var _shake := 0.0
var _home_y := 0.0
var actor: ChibiModel             # ตัวละคร 3 มิติในฉาก
var over: Node2D                  # ชั้นวาดหน้าตัวละคร

var zoom_far := ZOOM_FAR

func _ready() -> void:
	var sc := get_script() as Script
	if sc != null:
		zoom_far = float(BIG_SET_ZOOM.get(str(sc.get_global_name()), ZOOM_FAR))
	z_index = 40
	_home_y = page.world.position.y
	hero.plain_override = true
	hero.plain_swing_kind = "hyper"
	hero.plain_swing = 0.5
	hero.plain_blade_k = 0.0
	hero.plain_off_scale = 1.0
	for e in get_tree().get_nodes_in_group("monsters"):
		var monster := e as Monster
		if monster != null and _on_screen(monster):
			monster.frozen = true
			caught.append(monster)
			_start_at[monster] = monster.pos
	_stage_start()

func _stage_start() -> void:
	pass

func _stage_tick(_delta: float) -> void:
	pass

## มอนที่อยู่ในจอเมื่อกล้องถอยออกแล้ว
func _on_screen(monster: Monster) -> bool:
	return absf(monster.pos.x) <= hero.half_width * WalkPage.ZOOM / zoom_far

## จุดกลางจอในพิกัดโลก (ตอนกล้องถอยสุด) ใช้วางของที่ต้องโผล่กลางจอ
func screen_center_world() -> Vector2:
	var vp := page.get_viewport_rect().size
	return Vector2(0.0, (vp.y * 0.5 - _home_y) / zoom_far)

## ครึ่งความกว้างจอในพิกัดโลก (ตอนกล้องถอยสุด)
func screen_half_world() -> Vector2:
	var vp := page.get_viewport_rect().size
	return vp * 0.5 / zoom_far

func _ease(k: float) -> float:
	var c := clampf(k, 0.0, 1.0)
	return 1.0 - (1.0 - c) * (1.0 - c)

func _process(delta: float) -> void:
	_t += delta
	_update_camera(delta)
	if behind_view:
		page.world.visible = _t < open_time or _t >= close_from
	_stage_tick(delta)
	queue_redraw()
	if over != null:
		over.queue_redraw()
	if _t >= end_time:
		_finish()

func _update_camera(delta: float) -> void:
	_shake = move_toward(_shake, 0.0, _shake * SHAKE_FADE * delta)
	var into := _ease(_t / open_time)
	var out := _ease((_t - close_from) / (end_time - close_from))
	frame_k = into * (1.0 - out)
	if black_backdrop:
		hero.plain_rim = frame_k
	page.world.scale = Vector2.ONE * lerpf(WalkPage.ZOOM, zoom_far, frame_k)
	page.world.position = Vector2(page.get_viewport_rect().size.x * 0.5, _home_y) + Vector2(sin(_t * SHAKE_SPEED), cos(_t * SHAKE_SPEED * 1.3)) * _shake

func _release_monsters() -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.frozen = false
	caught.clear()

func _finish() -> void:
	set_process(false)
	_release_monsters()
	page.world.visible = true
	hero.plain_override = false
	hero.plain_rim = 0.0
	hero.plain_swing = 0.0
	hero.plain_blade_k = 0.0
	hero.plain_off_scale = 1.0
	page.world.scale = Vector2.ONE * WalkPage.ZOOM
	page.world.position = Vector2(page.get_viewport_rect().size.x * 0.5, _home_y)
	finished.emit()
	queue_free()

func _exit_tree() -> void:
	_release_monsters()
	if is_instance_valid(page):
		page.world.visible = true

func _view_center() -> Vector2:
	return Vector2(BACK_AT.x, 360.0) + Vector2(sin(_t * SHAKE_SPEED), cos(_t * SHAKE_SPEED * 1.3)) * _shake

## ฉากด้านหลังค่อยๆ เข้าออกพร้อมจอดำ
func _view_alpha() -> float:
	return frame_k

## ใส่ตัวละคร 3 มิติในฉาก เรียกตอนเริ่มท่า
func add_actor(at: Vector2, size: float, turn: float, style := "") -> void:
	actor = ChibiModel.new()
	actor.hero = hero
	if style != "":
		actor.style = style
	actor.stage_mode = true
	actor.stage_turn = turn
	actor.view_size = 1024
	add_child(actor)
	actor.place_stage(at, size)

## ชั้นวาดหน้าตัวละคร ต้องเรียกหลัง add_actor
func add_over() -> void:
	over = Node2D.new()
	over.draw.connect(_draw_over)
	add_child(over)

func _draw_over() -> void:
	pass
