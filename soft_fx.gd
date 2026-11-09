class_name SoftFx
## โทนนุ่มแบบหน้าโหลด "แมวมั้ย" สำหรับเอฟเฟกต์ที่วาดอยู่เหนือฟิลเตอร์ SoftWorld (z สูงกว่า 10) เช่นฉาก HYPER
## สูตรสีเดียวกับ SoftWorld: เส้นดำเป็นน้ำตาลเทา สีจัดลดเป็นพาสเทลอุ่น มืดสุดยกขึ้น ม่านครีมบางๆ
## เพิ่ม: แสงขาวจัด (แฟลช) โปร่งลงนิด ไม่แสบตา  ของที่ z ต่ำกว่าฟิลเตอร์โดน SoftWorld แล้ว ไม่ต้องใส่ซ้ำ

const SHADER := """
shader_type canvas_item;
uniform vec3 ink = vec3(0.47, 0.42, 0.39);
uniform vec3 paper = vec3(0.925, 0.902, 0.871);
uniform float sat = 0.72;
uniform float lift = 0.85;
uniform float veil = 0.11;
uniform float flash = 0.22;     // แสงขาวจัดโปร่งลงเท่านี้
void fragment() {
	vec4 src = COLOR;
	vec3 c = src.rgb;
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, sat);
	float dark = 1.0 - smoothstep(0.0, 0.72, l);
	vec3 soft_dark = ink + c * (vec3(1.0) - ink) * 0.6;
	c = mix(c, max(c, soft_dark), dark * lift);
	c = mix(c, vec3(0.62, 0.58, 0.55), 0.08);
	c = mix(c, paper, veil);
	float a = src.a * (1.0 - flash * smoothstep(0.9, 1.0, l));
	COLOR = vec4(c, a);
}
"""

static var _mat: ShaderMaterial = null

static func material() -> ShaderMaterial:
	if _mat == null:
		_mat = ShaderMaterial.new()
		var sh := Shader.new()
		sh.code = SHADER
		_mat.shader = sh
	return _mat

## ใส่โทนนุ่มให้โหนดนี้และลูกทุกตัว (รวมลูกที่เพิ่มทีหลัง) ข้ามโหนดที่มี material ของตัวเองอยู่แล้ว (เช่น blend add)
static func apply_tree(node: Node) -> void:
	if node == null or not is_instance_valid(node):
		return
	if node is CanvasItem:
		var ci := node as CanvasItem
		if ci.material == null:
			ci.material = material()
	for ch in node.get_children():
		apply_tree(ch)
	if not node.child_entered_tree.is_connected(_on_child):
		node.child_entered_tree.connect(_on_child)

static func _on_child(ch: Node) -> void:
	apply_tree(ch)
