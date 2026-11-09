class_name SoftWorld
extends Node2D
## ฟิลเตอร์นุ่มทับฉากโลก (ฉากหลัง ตัวละคร มอน NPC) ให้โทนเดียวกับหน้าโหลด "แมวมั้ย"
## เส้นดำกลายเป็นน้ำตาลเทาอ่อน สีจัดลดลงเป็นพาสเทลอุ่น มืดสุดยกขึ้น  UI อยู่เหนือชั้นนี้ ไม่โดนฟิลเตอร์
## ของในโลกใช้ z_index ไม่เกิน 5 ชั้นนี้อยู่ z 10  ปุ่ม จอย การ์ดเลือด ยกขึ้นเหนือ (z 12)

const Z := 10
const UI_Z := 12
const ENABLED := true

const SHADER := """
shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture, filter_linear_mipmap;
uniform vec3 ink = vec3(0.47, 0.42, 0.39);     // เส้นดำ -> น้ำตาลเทา (120,108,100)
uniform vec3 paper = vec3(0.925, 0.902, 0.871); // ครีมเทาของหน้าโหลด
uniform float sat = 0.72;        // ความอิ่มสีที่เหลือ
uniform float lift = 0.85;      // ยกส่วนมืดเข้าหาสีหมึกนุ่ม
uniform float veil = 0.11;      // ม่านครีมบางๆ
void fragment() {
	vec3 c = texture(screen, SCREEN_UV).rgb;
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, sat);
	// ส่วนมืดยกเข้าหาสีหมึกนุ่ม ส่วนสว่างคงเดิม
	float dark = 1.0 - smoothstep(0.0, 0.72, l);
	vec3 soft_dark = ink + c * (vec3(1.0) - ink) * 0.6;
	c = mix(c, max(c, soft_dark), dark * lift);
	// บีบคอนทราสต์ลงนิดหน่อย ภาพนุ่มขึ้น
	c = mix(c, vec3(0.62, 0.58, 0.55), 0.08);
	c = mix(c, paper, veil);
	COLOR = vec4(c, 1.0);
}
"""

var _view := Vector2.ZERO

func _ready() -> void:
	z_index = Z
	z_as_relative = false
	if not ENABLED:
		visible = false
		return
	var mat := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = SHADER
	mat.shader = sh
	material = mat
	_view = get_viewport_rect().size
	get_viewport().size_changed.connect(func() -> void:
		_view = get_viewport_rect().size
		queue_redraw())
	_raise_ui.call_deferred()

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

func _draw() -> void:
	draw_rect(Rect2(Vector2(-200.0, -200.0), _view + Vector2(400.0, 400.0)), Color.WHITE)
