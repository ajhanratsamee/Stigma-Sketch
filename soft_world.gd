class_name SoftWorld
extends Node2D
## ฟิลเตอร์นุ่มแบบหน้าโหลด "แมวมั้ย" สองชั้น
##   ชั้นหลัง (mode "back")  อยู่ในลำดับวาดก่อนโลก ทับแค่ฉากหลัง: พาสเทล ม่านครีมบางๆ ให้ฉากดูไกล นุ่ม
##   ชั้นรวม (mode "all")   อยู่เหนือโลก z 10: แค่ลดสีจัดนิดหน่อยและยกเส้นดำเป็นน้ำตาลเทา ตัวละคร มอน เอฟเฟกต์ยังคมชัด เด่นจากฉาก
## UI (ปุ่ม จอย การ์ดเลือด) ยกขึ้นเหนือ z 12 ไม่โดนฟิลเตอร์
## โหมดลื่น (GameSettings.smooth) ปิดฟิลเตอร์ทั้งสองชั้น ประหยัดเครื่อง
## มือถือที่เฟรมเรตต่ำกว่า AUTO_FPS ต่อเนื่อง เปิดโหมดลื่นให้เองครั้งเดียว พร้อมบอกผู้เล่น

const Z := 10
const UI_Z := 12
const ENABLED := true
const AUTO_FPS := 45.0
const AUTO_WARMUP := 4.0          # วินาทีแรกหลังเข้าฉากไม่นับ (โหลดของ)
const AUTO_SECONDS := 5           # ต่ำกว่าเกณฑ์ติดกันกี่วินาทีถึงเปิดโหมดลื่น

const SHADER := """
shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture, filter_linear_mipmap;
uniform vec3 ink = vec3(0.47, 0.42, 0.39);     // เส้นดำ -> น้ำตาลเทา (120,108,100)
uniform vec3 paper = vec3(0.925, 0.902, 0.871); // ครีมเทาของหน้าโหลด
uniform float sat = 0.72;        // ความอิ่มสีที่เหลือ
uniform float lift = 0.85;       // ยกส่วนมืดเข้าหาสีหมึกนุ่ม
uniform float squash = 0.08;     // บีบคอนทราสต์
uniform float veil = 0.11;       // ม่านครีมบางๆ
void fragment() {
	vec3 c = texture(screen, SCREEN_UV).rgb;
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, sat);
	float dark = 1.0 - smoothstep(0.0, 0.72, l);
	vec3 soft_dark = ink + c * (vec3(1.0) - ink) * 0.6;
	c = mix(c, max(c, soft_dark), dark * lift);
	c = mix(c, vec3(0.62, 0.58, 0.55), squash);
	c = mix(c, paper, veil);
	COLOR = vec4(c, 1.0);
}
"""

## ค่าของแต่ละชั้น [sat, lift, squash, veil]
const BACK_PARAMS := [0.74, 0.8, 0.07, 0.07]   # ฉากหลัง นุ่ม ไกล (หน้าเมือง/ดันมีหมอกฉากหลังของตัวเองอยู่แล้ว ม่านจึงบาง)
const ALL_PARAMS := [0.88, 0.5, 0.025, 0.0]    # ทั้งจอ เบามาก ตัวละครคมชัด

var mode := "all"
var _view := Vector2.ZERO
var _back: SoftWorld = null
var _bb: BackBufferCopy = null    # จับภาพจอใหม่ก่อนชั้นรวม (ไม่งั้นได้ภาพเดิมของชั้นหลังที่ยังไม่มีตัวละคร)
var _auto_t := 0.0
var _auto_low := 0
var _auto_tick := 0.0

static var _shader: Shader = null

static func _get_shader() -> Shader:
	if _shader == null:
		_shader = Shader.new()
		_shader.code = SHADER
	return _shader

func _ready() -> void:
	add_to_group("soft_world")
	var is_back := mode == "back"
	var params: Array = BACK_PARAMS if is_back else ALL_PARAMS
	var mat := ShaderMaterial.new()
	mat.shader = _get_shader()
	mat.set_shader_parameter("sat", params[0])
	mat.set_shader_parameter("lift", params[1])
	mat.set_shader_parameter("squash", params[2])
	mat.set_shader_parameter("veil", params[3])
	material = mat
	if is_back:
		z_index = 0
	else:
		z_index = Z
		z_as_relative = false
	_view = get_viewport_rect().size
	get_viewport().size_changed.connect(func() -> void:
		_view = get_viewport_rect().size
		queue_redraw())
	if not is_back:
		_add_back.call_deferred()
		_raise_ui.call_deferred()
	refresh()

## ชั้นหลัง แทรกไว้ก่อนโลกในลำดับวาด จับภาพแค่ฉากหลังที่วาดไปแล้ว
func _add_back() -> void:
	var page := get_parent()
	if page == null or _back != null:
		return
	var world = page.get("world")
	if not (world is Node2D) or (world as Node).get_parent() != page:
		return
	_back = SoftWorld.new()
	_back.mode = "back"
	page.add_child(_back)
	page.move_child(_back, (world as Node).get_index())
	_bb = BackBufferCopy.new()
	_bb.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	_bb.z_index = Z
	_bb.z_as_relative = false
	page.add_child(_bb)
	page.move_child(_bb, get_index())
	_bb.visible = visible

## ปุ่ม จอย การ์ดเลือด ที่เป็น z 0 ยกขึ้นเหนือฟิลเตอร์
func _raise_ui() -> void:
	var p := get_parent()
	if p == null:
		return
	for c in p.get_children():
		if c is TouchPad or c is Joystick or c is StatBars:
			var ci := c as CanvasItem
			if ci.z_index < UI_Z:
				ci.z_index = UI_Z

## เปิด/ปิดตามโหมดลื่น
func refresh() -> void:
	visible = ENABLED and not GameSettings.is_smooth()
	if _bb != null and is_instance_valid(_bb):
		_bb.visible = visible
	set_process(mode == "all" and visible and _auto_wanted())

static func refresh_all(tree: SceneTree) -> void:
	if tree == null:
		return
	for n in tree.get_nodes_in_group("soft_world"):
		(n as SoftWorld).refresh()

## วัดเฟรมเรตเฉพาะมือถือ/เว็บมือถือ และยังไม่เคยเปิดโหมดลื่นอัตโนมัติ
func _auto_wanted() -> bool:
	GameSettings.ensure()
	if GameSettings.smooth_auto_done:
		return false
	return OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")

func _process(delta: float) -> void:
	_auto_t += delta
	if _auto_t < AUTO_WARMUP or get_tree().paused:
		return
	_auto_tick += delta
	if _auto_tick < 1.0:
		return
	_auto_tick = 0.0
	if Engine.get_frames_per_second() < AUTO_FPS:
		_auto_low += 1
	else:
		_auto_low = 0
	if _auto_low >= AUTO_SECONDS:
		GameSettings.smooth = true
		GameSettings.smooth_auto_done = true
		GameSettings.save()
		refresh_all(get_tree())
		var page := get_parent()
		var bars = page.get("bars") if page != null else null
		if bars != null and bars.has_method("notice"):
			bars.notice("เปิดโหมดลื่นให้แล้ว (ปิดได้ในตั้งค่า)")

func _draw() -> void:
	draw_rect(Rect2(Vector2(-200.0, -200.0), _view + Vector2(400.0, 400.0)), Color.WHITE)
