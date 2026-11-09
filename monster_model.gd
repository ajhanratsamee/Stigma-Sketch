class_name MonsterModel
extends Node2D
## มอนสเตอร์ 3D ทรงกลมน่ารัก แบบเดียวกับตัวแมว (ChibiModel) ขอบดำบาง สีพาสเทล
## ธีมศัตรูของแมว: หุ่นฝนเล็บ ไหมพรม แตงกวา หนู หุ่นดูดฝุ่น ขวดสเปรย์ ปลาปักเป้า และบอสของแต่ละอย่าง
## monster.gd ตั้งท่า (เอน ยุบ สั่น) ผ่าน position rotation scale ของโหนดนี้ เหมือน draw_set_transform เดิม

const VIEW := 256                 # ขนาดภาพของมอนธรรมดา
const VIEW_BOSS := 512
const TURN := 32.0                # หันเฉียงสามส่วนสี่ไปทางที่มอนหัน
## ความสูงโมเดลเป็นหน่วย 3D และความกว้าง ใช้คำนวณกล้องกับขนาดบนจอ
const SIZE := {
	"": Vector2(1.0, 1.5), "cat_mochi": Vector2(1.2, 1.15), "cat_long": Vector2(0.9, 1.9), "cat_cyclops": Vector2(1.5, 1.2),
	"cat_box": Vector2(1.7, 1.0), "cat_ghost": Vector2(1.0, 1.6), "cat_puff": Vector2(1.5, 1.3),
	"boss_club": Vector2(2.2, 1.9), "boss_spear": Vector2(2.0, 2.4), "boss_hammer": Vector2(2.4, 1.7),
	"boss_scythe": Vector2(2.2, 2.0), "boss_king": Vector2(2.2, 2.2),
}
const NAMES := {
	"": "หุ่นฝนเล็บ", "cat_mochi": "ไหมพรมเด้ง", "cat_long": "แตงกวาตกใจ", "cat_cyclops": "หนูจอมซน", "cat_box": "หุ่นดูดฝุ่น",
	"cat_ghost": "ขวดสเปรย์ลอย", "cat_puff": "ปลาปักเป้าพอง",
	"boss_club": "ราชาไหมพรมไม้นวดแป้ง", "boss_spear": "อัศวินแตงกวาส้อมยักษ์", "boss_hammer": "หุ่นดูดฝุ่นค้อนยักษ์",
	"boss_scythe": "หนูเงาเคียวจันทร์", "boss_king": "ราชันหมาอัศวิน",
}
const INK := Color(0.08, 0.07, 0.08)

static var _meshes := {}
static var _mats := {}

var look := ""
var town := -1                    # เมืองของหน้าตา -1 คือเดาจากดันที่เล่นอยู่ / เมืองปัจจุบัน  0 คือหน้าตาเดิม
var face := -1.0
var flash := 0.0
var view_px := 0                  # ความละเอียดภาพ 0 คือค่าปกติ
## ย้อมสีทั้งตัว (บอสยักษ์เปลี่ยนสีตามเฟส)
func set_tint(c: Color) -> void:
	if _ink != null:
		_ink.set_shader_parameter("shade", c)
var tele := 0.0                   # 0-1 กำลังง้าง
var strike := 0.0                 # 0-1 เพิ่งฟาด
var viewport: SubViewport
var sprite: Sprite2D
var _root: Node3D
var _weapon: Node3D               # อาวุธบอส หมุนตอนง้างและฟาด
var _bob: Node3D
var _ink: ShaderMaterial
var _t := 0.0
var _floaty := false

static func has_look(id: String) -> bool:
	return SIZE.has(id.get_slice("@", 0))

## เมืองของหน้าตา: ระบุเองด้วย "ชนิด@เมือง" ไม่งั้นใช้ดันที่เล่นอยู่ ไม่ได้อยู่ในดันใช้เมืองปัจจุบัน
static func town_of(id: String) -> int:
	if id.contains("@"):
		return int(id.get_slice("@", 1))
	return WalkPage.dungeon_town if WalkPage.dungeon_town >= 0 else WalkPage.current_town

static func height_px(id: String) -> float:
	if CatLook.TOP.has(id):
		return CatLook.top(id)
	return 140.0

func _ready() -> void:
	if town < 0:
		town = town_of(look)
	look = look.get_slice("@", 0)
	var boss := look.begins_with("boss")
	var view := VIEW_BOSS if boss else VIEW
	if view_px > 0:
		view = view_px
	var sz: Vector2 = SIZE.get(look, SIZE[""])
	# บอสหน้าตาตามเมืองสูงกว่าแบบเดิม ขยายกรอบกล้องไม่ให้หัวโดนตัด
	if boss and town >= 1:
		sz = Vector2(maxf(sz.x, 2.6), maxf(sz.y, 2.6))
	var cam_size := maxf(sz.x, sz.y) * 1.35
	viewport = SubViewport.new()
	viewport.size = Vector2i(view, view)
	viewport.transparent_bg = true
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.msaa_3d = Viewport.MSAA_2X
	add_child(viewport)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color.WHITE
	env.ambient_light_energy = 0.5
	var we := WorldEnvironment.new()
	we.environment = env
	viewport.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-42.0, 32.0, 0.0)
	sun.light_energy = 1.4
	viewport.add_child(sun)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = cam_size
	# เท้าอยู่ล่างภาพ เหลือที่ด้านบนให้อาวุธ
	cam.position = Vector3(0.0, cam_size * 0.42, 10.0)
	viewport.add_child(cam)
	cam.current = true
	_root = Node3D.new()
	viewport.add_child(_root)
	_bob = Node3D.new()
	_root.add_child(_bob)
	_build()
	sprite = Sprite2D.new()
	sprite.texture = viewport.get_texture()
	# ความสูงโมเดลบนจอเท่าความสูงของหน้าตาเดิม
	var s := height_px(look) * cam_size / (sz.y * float(view))
	sprite.scale = Vector2.ONE * s
	sprite.position = Vector2(0.0, -0.42 * float(view) * s)
	_ink = ShaderMaterial.new()
	_ink.shader = _outline_shader()
	_ink.set_shader_parameter("line_color", INK)
	_ink.set_shader_parameter("width", 1.0)
	sprite.material = _ink
	add_child(sprite)
	# อยู่นอกจอไม่ต้องเรนเดอร์ภาพ 3D ดันเจี้ยนมอนเยอะก็ไม่หน่วง
	var vis := VisibleOnScreenNotifier2D.new()
	var hp := height_px(look)
	vis.rect = Rect2(-hp, -hp * 1.3, hp * 2.0, hp * 1.6)
	vis.screen_entered.connect(func() -> void: viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS)
	vis.screen_exited.connect(func() -> void: viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED)
	add_child(vis)
	_sync(0.0)

static var _shader: Shader

static func _outline_shader() -> Shader:
	if _shader == null:
		_shader = Shader.new()
		_shader.code = ChibiModel.THIN_OUTLINE_SHADER
	return _shader

func _process(delta: float) -> void:
	_sync(delta)

func _sync(delta: float) -> void:
	_t += delta
	# หุ่นฝนเล็บหันเป้าเข้ากล้องตลอด
	_root.rotation_degrees.y = (8.0 if look == "" else TURN) * face
	var bob := sin(_t * 4.0) * 0.03
	if _floaty:
		bob = 0.12 + sin(_t * 2.5) * 0.08
	_bob.position.y = bob
	_bob.scale = Vector3(1.0 + sin(_t * 4.0) * 0.015, 1.0 - sin(_t * 4.0) * 0.015, 1.0)
	if _weapon != null:
		# ง้างไปด้านหลัง แล้วฟาดลงด้านหน้า
		var ang := -70.0 * tele + 110.0 * strike * (1.0 - tele)
		_weapon.rotation_degrees.z = -ang
	if _ink != null:
		_ink.set_shader_parameter("flash", flash)

# ---------- ชิ้นส่วน (เก็บ mesh กับวัสดุไว้ใช้ซ้ำ โหลดดันเจี้ยนไม่หน่วง) ----------

static func _mesh(key: String, make: Callable) -> Mesh:
	if not _meshes.has(key):
		_meshes[key] = make.call()
	return _meshes[key]

static func _ball(r: float) -> Mesh:
	return _mesh("b%.3f" % r, func() -> Mesh:
		var m := SphereMesh.new()
		m.radius = r
		m.height = r * 2.0
		m.radial_segments = 24
		m.rings = 12
		return m)

static func _cyl(r: float, h: float, top := -1.0) -> Mesh:
	return _mesh("c%.3f_%.3f_%.3f" % [r, h, top], func() -> Mesh:
		var m := CylinderMesh.new()
		m.bottom_radius = r
		m.top_radius = r if top < 0.0 else top
		m.height = h
		m.radial_segments = 24
		return m)

static func _cap(r: float, h: float) -> Mesh:
	return _mesh("p%.3f_%.3f" % [r, h], func() -> Mesh:
		var m := CapsuleMesh.new()
		m.radius = r
		m.height = maxf(h, r * 2.0)
		m.radial_segments = 24
		m.rings = 8
		return m)

static func _torus(inner: float, outer: float) -> Mesh:
	return _mesh("t%.3f_%.3f" % [inner, outer], func() -> Mesh:
		var m := TorusMesh.new()
		m.inner_radius = inner
		m.outer_radius = outer
		m.rings = 28
		m.ring_segments = 10
		return m)

static func _box(size: Vector3) -> Mesh:
	return _mesh("x%s" % str(size), func() -> Mesh:
		var m := BoxMesh.new()
		m.size = size
		return m)

static func _mat(c: Color, rough := 0.85, glow := 0.0) -> Material:
	var key := "%s_%.2f_%.2f" % [c.to_html(), rough, glow]
	if not _mats.has(key):
		var m := StandardMaterial3D.new()
		m.albedo_color = c
		m.roughness = rough
		m.metallic_specular = 0.25
		if glow > 0.0:
			m.emission_enabled = true
			m.emission = c
			m.emission_energy_multiplier = glow
		if c.a < 1.0:
			m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		_mats[key] = m
	return _mats[key]

func _part(parent: Node3D, mesh: Mesh, mat: Material, at: Vector3, size := Vector3.ONE, turn := Vector3.ZERO) -> MeshInstance3D:
	var n := MeshInstance3D.new()
	n.mesh = mesh
	n.material_override = mat
	n.position = at
	n.scale = size
	n.rotation_degrees = turn
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(n)
	return n

func _group(parent: Node3D, at := Vector3.ZERO) -> Node3D:
	var g := Node3D.new()
	g.position = at
	parent.add_child(g)
	return g

## ตากลมแป๋ว มีประกาย กับแก้มชมพู ตรงหน้า (แกน z)
func _face(parent: Node3D, at: Vector3, gap: float, r: float, blush := true) -> void:
	for side in [-1.0, 1.0]:
		var e := at + Vector3(side * gap, 0.0, 0.0)
		_part(parent, _ball(r), _mat(Color(0.07, 0.06, 0.08), 0.3), e, Vector3(1.0, 1.15, 0.6))
		_part(parent, _ball(r * 0.36), _mat(Color.WHITE, 0.2), e + Vector3(-r * 0.3, r * 0.38, r * 0.45))
		if blush:
			_part(parent, _ball(r * 0.8), _mat(Color(1.0, 0.62, 0.72)), e + Vector3(side * r * 1.1, -r * 1.4, -r * 0.1), Vector3(1.0, 0.5, 0.35))

func _feet(parent: Node3D, gap: float, r: float, col: Color) -> void:
	for side in [-1.0, 1.0]:
		_part(parent, _ball(r), _mat(col), Vector3(side * gap, r * 0.6, 0.05), Vector3(1.2, 0.6, 1.1))

# ---------- หน้าตาแต่ละแบบ ----------

func _build() -> void:
	if town >= 1 and look != "" and _variant():
		return
	match look:
		"cat_mochi": _yarn(_bob, 0.55, Color(1.0, 0.62, 0.72), false)
		"cat_long": _cucumber(_bob, 1.0, false)
		"cat_cyclops": _mouse(_bob, 1.0, Color(0.72, 0.72, 0.78), false)
		"cat_box": _vacuum(_bob, 1.0, false)
		"cat_ghost":
			_floaty = true
			_spray(_bob)
		"cat_puff": _puffer(_bob)
		"boss_club": _yarn(_bob, 0.85, Color(0.68, 0.5, 0.95), true)
		"boss_spear": _cucumber(_bob, 1.25, true)
		"boss_hammer": _vacuum(_bob, 1.35, true)
		"boss_scythe":
			_floaty = true
			_mouse(_bob, 1.4, Color(0.36, 0.3, 0.5), true)
		"boss_king": _dog(_bob)
		_: _dummy(_bob)

## หุ่นฝนเล็บ เสาพันเชือกป่าน มีเป้ากลมตรงหน้า ฐานไม้ หูแมวเล็กๆ บนหัว
func _dummy(p: Node3D) -> void:
	var sisal := _mat(Color(0.86, 0.74, 0.55))
	var rope := _mat(Color(0.72, 0.58, 0.4))
	_part(p, _cyl(0.55, 0.12), _mat(Color(0.6, 0.42, 0.28)), Vector3(0.0, 0.06, 0.0))
	_part(p, _cap(0.4, 1.3), sisal, Vector3(0.0, 0.8, 0.0))
	for i in 4:
		_part(p, _torus(0.38, 0.45), rope, Vector3(0.0, 0.35 + float(i) * 0.25, 0.0))
	for side in [-1.0, 1.0]:
		_part(p, _cyl(0.12, 0.2, 0.0), sisal, Vector3(side * 0.22, 1.5, 0.0), Vector3(1.0, 1.0, 0.6), Vector3(0.0, 0.0, -side * 15.0))
	# เป้า
	var rings := [[0.3, Color(1.0, 1.0, 1.0)], [0.22, Color(0.95, 0.4, 0.45)], [0.14, Color.WHITE], [0.07, Color(0.95, 0.4, 0.45)]]
	for i in rings.size():
		var rr: Array = rings[i]
		_part(p, _cyl(float(rr[0]), 0.04), _mat(rr[1]), Vector3(0.0, 0.85, 0.4 + float(i) * 0.012), Vector3.ONE, Vector3(90.0, 0.0, 0.0))

## ไหมพรมกลม มีเส้นไหมพันรอบ ปลายเส้นห้อย ตาแป๋ว  king มีมงกุฎกับไม้นวดแป้ง
func _yarn(p: Node3D, r: float, col: Color, king: bool) -> void:
	var body := _group(p, Vector3(0.0, r, 0.0))
	_part(body, _ball(r), _mat(col), Vector3.ZERO)
	var line := _mat(col.darkened(0.2))
	for i in 5:
		_part(body, _torus(r * 0.97, r * 1.03), line, Vector3.ZERO, Vector3.ONE, Vector3(float(i) * 36.0, float(i) * 25.0, 20.0 + float(i) * 30.0))
	# ปลายเส้นห้อย
	for i in 6:
		_part(body, _ball(r * 0.05), line, Vector3(-r * 0.75 - float(i) * r * 0.06, -r * 0.5 - float(i) * r * 0.08, -r * 0.3))
	_face(body, Vector3(0.0, r * 0.1, r * 0.92), r * 0.32, r * 0.12)
	_feet(p, r * 0.4, r * 0.2, col.darkened(0.15))
	if king:
		_crown(body, Vector3(0.0, r * 0.95, 0.0), r * 0.4)
		_weapon = _group(body, Vector3(r * 0.9, 0.0, r * 0.3))
		# ไม้นวดแป้ง ด้ามสองข้าง
		_part(_weapon, _cyl(0.13, 1.0), _mat(Color(0.86, 0.66, 0.42)), Vector3(0.0, 0.5, 0.0))
		for e in [-1.0, 1.0]:
			_part(_weapon, _cyl(0.05, 0.25), _mat(Color(0.6, 0.4, 0.25)), Vector3(0.0, 0.5 + e * 0.62, 0.0))

func _crown(parent: Node3D, at: Vector3, s: float) -> void:
	var gold := _mat(Color(1.0, 0.82, 0.3), 0.4)
	_part(parent, _cyl(s, s * 0.45), gold, at)
	for i in 5:
		var a := TAU * float(i) / 5.0
		_part(parent, _ball(s * 0.18), gold, at + Vector3(cos(a) * s * 0.9, s * 0.35, sin(a) * s * 0.9))
	_part(parent, _ball(s * 0.16), _mat(Color(1.0, 0.45, 0.55), 0.3), at + Vector3(0.0, 0.0, s))

## แตงกวาตกใจ ทรงยาว ตุ่มนูน ลายเขียวอ่อน ใบเล็กบนหัว  knight ถือส้อมยักษ์
func _cucumber(p: Node3D, k: float, knight: bool) -> void:
	var green := _mat(Color(0.45, 0.78, 0.4))
	var light := _mat(Color(0.7, 0.92, 0.6))
	var body := _group(p, Vector3(0.0, 0.0, 0.0))
	_part(body, _cap(0.42 * k, 1.75 * k), green, Vector3(0.0, 0.9 * k, 0.0))
	_part(body, _cap(0.3 * k, 1.4 * k), light, Vector3(0.0, 0.9 * k, 0.16 * k), Vector3(1.0, 1.0, 0.8))
	for i in 7:
		var a := float(i) * 1.7
		_part(body, _ball(0.05 * k), _mat(Color(0.32, 0.6, 0.3)), Vector3(cos(a) * 0.4 * k, (0.35 + float(i) * 0.18) * k, sin(a) * 0.4 * k))
	_part(body, _ball(0.12 * k), _mat(Color(0.95, 0.85, 0.3)), Vector3(0.0, 1.78 * k, 0.0), Vector3(1.0, 0.6, 1.0))
	_part(body, _ball(0.16 * k), _mat(Color(0.35, 0.65, 0.3)), Vector3(0.14 * k, 1.8 * k, 0.0), Vector3(1.4, 0.35, 0.8), Vector3(0.0, 0.0, -25.0))
	_face(body, Vector3(0.0, 1.3 * k, 0.4 * k), 0.15 * k, 0.07 * k)
	# ปากโอตกใจ
	_part(body, _ball(0.05 * k), _mat(Color(0.3, 0.12, 0.15)), Vector3(0.0, 1.13 * k, 0.42 * k), Vector3(1.0, 1.3, 0.5))
	_feet(p, 0.18 * k, 0.13 * k, Color(0.35, 0.62, 0.32))
	if knight:
		_weapon = _group(body, Vector3(0.5 * k, 0.9 * k, 0.25))
		var steel := _mat(Color(0.86, 0.88, 0.95), 0.3)
		_part(_weapon, _cyl(0.05, 1.6), _mat(Color(0.75, 0.55, 0.35)), Vector3(0.0, 0.5, 0.0))
		_part(_weapon, _cap(0.07, 0.4), steel, Vector3(0.0, 1.35, 0.0), Vector3(3.0, 1.0, 1.0))
		for i in 3:
			_part(_weapon, _cap(0.04, 0.4), steel, Vector3((float(i) - 1.0) * 0.12, 1.6, 0.0))

## หนูกลม หูกลมใหญ่ด้านในชมพู หนวด หางยาว  boss ถือเคียวพระจันทร์ ลอยตัว
func _mouse(p: Node3D, k: float, col: Color, boss: bool) -> Node3D:
	var fur := _mat(col)
	var pink := _mat(Color(1.0, 0.7, 0.78))
	var body := _group(p, Vector3(0.0, 0.55 * k, 0.0))
	_part(body, _ball(0.55 * k), fur, Vector3.ZERO, Vector3(1.15, 1.0, 1.0))
	_part(body, _ball(0.42 * k), _mat(col.lightened(0.35)), Vector3(0.0, -0.08 * k, 0.2 * k), Vector3(1.0, 0.9, 0.8))
	for side in [-1.0, 1.0]:
		_part(body, _cyl(0.28 * k, 0.06 * k), fur, Vector3(side * 0.42 * k, 0.48 * k, -0.05 * k), Vector3.ONE, Vector3(90.0, 0.0, side * 20.0))
		_part(body, _cyl(0.18 * k, 0.03 * k), pink, Vector3(side * 0.42 * k, 0.48 * k, -0.01 * k), Vector3.ONE, Vector3(90.0, 0.0, side * 20.0))
		for w in 2:
			_part(body, _cyl(0.008 * k, 0.32 * k), _mat(Color(0.25, 0.22, 0.25)), Vector3(side * 0.32 * k, -0.02 * k - float(w) * 0.06 * k, 0.48 * k), Vector3.ONE, Vector3(0.0, 0.0, side * (80.0 + float(w) * 12.0)))
	_part(body, _ball(0.07 * k), pink, Vector3(0.0, 0.0, 0.6 * k))
	_face(body, Vector3(0.0, 0.14 * k, 0.5 * k), 0.17 * k, 0.07 * k)
	# หางยาวโค้ง
	for i in 12:
		var t := float(i) / 11.0
		_part(body, _ball(0.04 * k * (1.0 - t * 0.5)), pink, Vector3(-0.55 * k - t * 0.35 * k, -0.35 * k + sin(t * PI) * 0.45 * k, -0.25 * k))
	if not boss:
		_feet(p, 0.25 * k, 0.12 * k, col.darkened(0.1))
	else:
		_weapon = _group(body, Vector3(0.6 * k, 0.0, 0.3))
		_part(_weapon, _cyl(0.05, 2.0), _mat(Color(0.3, 0.25, 0.4)), Vector3(0.0, 0.6, 0.0))
		# ใบเคียวพระจันทร์เสี้ยว ปลายมน
		var blade := _mat(Color(0.75, 0.7, 1.0), 0.3, 0.4)
		for i in 16:
			var a := deg_to_rad(5.0 + float(i) * 10.0)
			_part(_weapon, _ball(0.16 * (1.0 - float(i) * 0.045)), blade, Vector3(-cos(a) * 0.65, 1.45 + sin(a) * 0.32, 0.0), Vector3(1.0, 0.8, 0.35))
	return body

## หุ่นดูดฝุ่นทรงจานกลม ตาจอกลมเรืองฟ้า เสาอากาศ แปรงหมุนข้างล่าง  boss มีแขนค้อน
func _vacuum(p: Node3D, k: float, boss: bool) -> void:
	var shell := _mat(Color(0.92, 0.93, 0.97), 0.5)
	var dark := _mat(Color(0.35, 0.37, 0.45), 0.5)
	var body := _group(p, Vector3(0.0, 0.0, 0.0))
	_part(body, _cyl(0.8 * k, 0.45 * k), shell, Vector3(0.0, 0.35 * k, 0.0))
	_part(body, _torus(0.76 * k, 0.86 * k), dark, Vector3(0.0, 0.25 * k, 0.0))
	_part(body, _ball(0.55 * k), shell, Vector3(0.0, 0.55 * k, 0.0), Vector3(1.0, 0.55, 1.0))
	# ตาจอเดียว
	_part(body, _cyl(0.24 * k, 0.05 * k), dark, Vector3(0.0, 0.6 * k, 0.55 * k), Vector3.ONE, Vector3(80.0, 0.0, 0.0))
	_part(body, _ball(0.13 * k), _mat(Color(0.45, 0.85, 1.0), 0.3, 0.9), Vector3(0.0, 0.62 * k, 0.6 * k), Vector3(1.0, 1.0, 0.5))
	_part(body, _ball(0.04 * k), _mat(Color.WHITE, 0.2), Vector3(-0.04 * k, 0.67 * k, 0.66 * k))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.08 * k), _mat(Color(1.0, 0.62, 0.72)), Vector3(side * 0.34 * k, 0.5 * k, 0.6 * k), Vector3(1.0, 0.5, 0.35))
		_part(body, _ball(0.1 * k), _mat(Color(0.6, 0.62, 0.7)), Vector3(side * 0.5 * k, 0.08 * k, 0.45 * k), Vector3(1.2, 0.5, 1.2))
	_part(body, _cyl(0.02 * k, 0.3 * k), dark, Vector3(0.0, 0.95 * k, 0.0))
	_part(body, _ball(0.06 * k), _mat(Color(1.0, 0.45, 0.5), 0.3, 0.6), Vector3(0.0, 1.12 * k, 0.0))
	if boss:
		_weapon = _group(body, Vector3(0.85 * k, 0.5 * k, 0.2))
		_part(_weapon, _cyl(0.06, 1.2), dark, Vector3(0.0, 0.6, 0.0))
		_part(_weapon, _cap(0.28, 0.75), _mat(Color(1.0, 0.65, 0.35)), Vector3(0.0, 1.25, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))

## ขวดสเปรย์น้ำ ตัวใส มีน้ำข้างใน หัวไกปืนสีขาว ลอยตัว มีละอองน้ำกลมๆ
func _spray(p: Node3D) -> void:
	var body := _group(p, Vector3(0.0, 0.0, 0.0))
	_part(body, _cap(0.38, 1.0), _mat(Color(0.7, 0.88, 1.0, 0.75), 0.2), Vector3(0.0, 0.55, 0.0))
	_part(body, _cap(0.3, 0.7), _mat(Color(0.45, 0.72, 1.0), 0.3), Vector3(0.0, 0.45, 0.0))
	_part(body, _cyl(0.22, 0.25), _mat(Color(0.97, 0.97, 1.0), 0.4), Vector3(0.0, 1.15, 0.0))
	_part(body, _box(Vector3(0.18, 0.2, 0.5)), _mat(Color(0.97, 0.97, 1.0), 0.4), Vector3(0.0, 1.32, 0.2))
	_part(body, _cyl(0.05, 0.12), _mat(Color(1.0, 0.55, 0.6)), Vector3(0.0, 1.32, 0.5), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
	_part(body, _cap(0.06, 0.3), _mat(Color(0.97, 0.97, 1.0), 0.4), Vector3(0.0, 1.1, 0.32), Vector3.ONE, Vector3(-20.0, 0.0, 0.0))
	_face(body, Vector3(0.0, 0.7, 0.37), 0.14, 0.07)
	for i in 3:
		_part(body, _ball(0.06 - float(i) * 0.012), _mat(Color(0.8, 0.93, 1.0, 0.8), 0.2), Vector3(0.0, 1.3 + float(i) * 0.05, 0.62 + float(i) * 0.12))

## ปลาปักเป้าพอง สีเหลือง หนามสั้นปลายมน ครีบ ปากจู๋
func _puffer(p: Node3D) -> void:
	var yel := _mat(Color(1.0, 0.86, 0.45))
	var body := _group(p, Vector3(0.0, 0.62, 0.0))
	_part(body, _ball(0.55), yel, Vector3.ZERO)
	_part(body, _ball(0.42), _mat(Color(1.0, 0.96, 0.82)), Vector3(0.0, -0.18, 0.22), Vector3(1.0, 0.8, 0.8))
	var spike := _mat(Color(0.95, 0.72, 0.35))
	for i in 18:
		var a := float(i) * 2.4
		var y := -0.8 + 1.6 * float(i) / 17.0
		var rr := sqrt(maxf(1.0 - y * y, 0.0))
		var d := Vector3(cos(a) * rr, y, sin(a) * rr).normalized()
		if d.z > 0.6 and absf(d.y) < 0.4:
			continue
		_part(body, _ball(0.07), spike, d * 0.6, Vector3(0.8, 0.8, 0.8))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.16), _mat(Color(1.0, 0.7, 0.45)), Vector3(side * 0.55, -0.05, 0.1), Vector3(0.5, 1.0, 0.8))
	_part(body, _ball(0.2), _mat(Color(1.0, 0.7, 0.45)), Vector3(0.0, 0.0, -0.6), Vector3(0.4, 1.0, 0.7))
	_part(body, _torus(0.04, 0.08), _mat(Color(1.0, 0.55, 0.6)), Vector3(0.0, -0.12, 0.55), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
	_face(body, Vector3(0.0, 0.1, 0.5), 0.2, 0.08)

## หมาอัศวินกลม หูตกยาว จมูกดำ มงกุฎ โล่กลมลายกระดูก ดาบปลายมน
func _dog(p: Node3D) -> void:
	var fur := _mat(Color(0.82, 0.62, 0.42))
	var light := _mat(Color(0.98, 0.9, 0.78))
	var body := _group(p, Vector3(0.0, 0.0, 0.0))
	_part(body, _ball(0.7), fur, Vector3(0.0, 0.75, 0.0), Vector3(1.0, 1.05, 1.0))
	_part(body, _ball(0.5), light, Vector3(0.0, 0.62, 0.32), Vector3(1.0, 0.9, 0.75))
	_part(body, _ball(0.3), light, Vector3(0.0, 0.95, 0.55), Vector3(1.1, 0.8, 0.8))
	_part(body, _ball(0.1), _mat(Color(0.1, 0.08, 0.08), 0.3), Vector3(0.0, 1.02, 0.82))
	for side in [-1.0, 1.0]:
		_part(body, _cap(0.16, 0.6), _mat(Color(0.6, 0.42, 0.28)), Vector3(side * 0.6, 1.0, 0.0), Vector3(1.0, 1.0, 0.6), Vector3(0.0, 0.0, side * 25.0))
	_face(body, Vector3(0.0, 1.18, 0.6), 0.22, 0.08)
	_crown(body, Vector3(0.0, 1.5, 0.0), 0.3)
	_feet(p, 0.3, 0.16, Color(0.6, 0.42, 0.28))
	# โล่กลมมีลายกระดูก
	var shield := _group(body, Vector3(-0.7, 0.7, 0.35))
	_part(shield, _cyl(0.42, 0.08), _mat(Color(0.45, 0.6, 0.95), 0.4), Vector3.ZERO, Vector3.ONE, Vector3(90.0, 0.0, -20.0))
	_part(shield, _cap(0.06, 0.4), _mat(Color.WHITE, 0.4), Vector3(0.0, 0.0, 0.06), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
	_weapon = _group(body, Vector3(0.75, 0.7, 0.3))
	_part(_weapon, _cyl(0.05, 0.3), _mat(Color(0.6, 0.4, 0.25)), Vector3(0.0, 0.0, 0.0))
	_part(_weapon, _cap(0.1, 0.32), _mat(Color(1.0, 0.82, 0.3), 0.4), Vector3(0.0, 0.18, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
	_part(_weapon, _cap(0.1, 1.2), _mat(Color(0.88, 0.9, 0.97), 0.3), Vector3(0.0, 0.85, 0.0), Vector3(1.0, 1.0, 0.35))

# ---------- หน้าตาตามธีมเมือง (เมือง 1-8) ท่าทางและระยะโดนเหมือนชนิดเดิม ----------

## เลือกหน้าตาตามเมือง คืน false ถ้าเมืองนี้ใช้หน้าตาเดิม
func _variant() -> bool:
	var boss := look.begins_with("boss")
	var key := "%d:%s" % [town, "boss" if boss else look]
	match key:
		# เมืองตลาดปลาทู
		"1:cat_mochi": _fish(_bob, 0.9, Color(0.62, 0.72, 0.88), Color(0.92, 0.95, 1.0), true)
		"1:cat_long": _fishbone(_bob, 1.0)
		"1:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(0.7, 0.55, 0.42), false), "fish", 1.0)
		"1:cat_box": _chest(_bob, 1.0, "crate")
		"1:cat_ghost":
			_floaty = true
			_squid(_bob, 1.0, Color(1.0, 0.62, 0.62), false)
		"1:cat_puff": _puffer_c(_bob, Color(0.55, 0.42, 0.75), Color(0.85, 0.78, 0.95), Color(0.4, 0.3, 0.6))
		"1:boss":
			_floaty = true
			_squid(_bob, 1.6, Color(1.0, 0.5, 0.5), true)
		# หมู่บ้านแมวภูเขา (เหมือง)
		"2:cat_mochi": _slime(_bob, 0.95, Color(0.62, 0.85, 1.0, 0.85), "crystal")
		"2:cat_long": _mole(_bob, 1.0, false)
		"2:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(0.6, 0.6, 0.66), false), "pick", 1.0)
		"2:cat_box": _chest(_bob, 1.0, "cart")
		"2:cat_ghost":
			_floaty = true
			_bat(_bob, 1.0, Color(0.5, 0.45, 0.62), Color(0.8, 0.72, 0.9))
		"2:cat_puff": _puffer_c(_bob, Color(0.62, 0.6, 0.62), Color(0.82, 0.8, 0.8), Color(0.75, 0.88, 1.0))
		"2:boss": _mole(_bob, 1.5, true)
		# ท่าเรือแมวน้ำ
		"3:cat_mochi": _crab(_bob, 0.85, Color(1.0, 0.52, 0.42), false, false)
		"3:cat_long": _gull(_bob, 1.0)
		"3:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(0.75, 0.75, 0.8), false), "sailor", 1.0)
		"3:cat_box": _chest(_bob, 1.0, "treasure")
		"3:cat_ghost":
			_floaty = true
			_jelly(_bob, 1.0, Color(0.85, 0.7, 1.0, 0.7))
		"3:cat_puff": _puffer_c(_bob, Color(0.45, 0.7, 0.95), Color(0.85, 0.94, 1.0), Color(0.3, 0.5, 0.85))
		"3:boss": _crab(_bob, 1.45, Color(0.95, 0.4, 0.35), false, true)
		# เมืองแมวทะเลทราย
		"4:cat_mochi": _cactus(_bob, 0.9)
		"4:cat_long": _snake(_bob, 1.0, Color(0.92, 0.78, 0.48))
		"4:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(0.95, 0.82, 0.6), false), "fennec", 1.0)
		"4:cat_box": _crab(_bob, 1.0, Color(0.85, 0.66, 0.42), true, false)
		"4:cat_ghost":
			_floaty = true
			_cloud(_bob, 1.0, Color(0.95, 0.85, 0.65), false)
		"4:cat_puff": _puffer_c(_bob, Color(0.72, 0.55, 0.38), Color(0.95, 0.85, 0.7), Color(0.55, 0.4, 0.28))
		"4:boss": _crab(_bob, 1.5, Color(0.8, 0.58, 0.36), true, true)
		# หมู่บ้านแมวหิมะ
		"5:cat_mochi": _slime(_bob, 0.95, Color(0.97, 0.98, 1.0), "snow")
		"5:cat_long": _penguin(_bob, 1.0, false)
		"5:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(0.96, 0.96, 1.0), false), "beanie", 1.0)
		"5:cat_box": _chest(_bob, 1.0, "sled")
		"5:cat_ghost":
			_floaty = true
			_fish(_bob, 0.85, Color(0.68, 0.88, 1.0, 0.85), Color(0.92, 0.98, 1.0), false)
		"5:cat_puff": _puffer_c(_bob, Color(0.75, 0.9, 1.0), Color(0.95, 0.98, 1.0), Color(0.55, 0.78, 0.95))
		"5:boss": _penguin(_bob, 1.5, true)
		# เกาะแมวภูเขาไฟ
		"6:cat_mochi": _slime(_bob, 0.95, Color(1.0, 0.5, 0.25), "lava")
		"6:cat_long": _candle(_bob, 1.1, Color(0.45, 0.4, 0.42), Color(1.0, 0.55, 0.2))
		"6:cat_cyclops": _mouse(_bob, 1.0, Color(0.32, 0.3, 0.33), false)
		"6:cat_box": _chest(_bob, 1.0, "pot")
		"6:cat_ghost":
			_floaty = true
			_bat(_bob, 1.0, Color(0.85, 0.35, 0.25), Color(1.0, 0.7, 0.35))
		"6:cat_puff": _puffer_c(_bob, Color(0.42, 0.36, 0.38), Color(0.62, 0.55, 0.55), Color(1.0, 0.5, 0.2))
		"6:boss": _slime(_bob, 1.6, Color(1.0, 0.45, 0.2), "lava_king")
		# ปราสาทแมวเงา
		"7:cat_mochi": _slime(_bob, 0.95, Color(0.42, 0.36, 0.6), "shadow")
		"7:cat_long": _candle(_bob, 1.1, Color(0.95, 0.92, 0.85), Color(0.7, 0.6, 1.0))
		"7:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(0.55, 0.52, 0.62), false), "helmet", 1.0)
		"7:cat_box": _chest(_bob, 1.0, "book")
		"7:cat_ghost":
			_floaty = true
			_bat(_bob, 1.0, Color(0.4, 0.34, 0.55), Color(0.75, 0.65, 0.95))
		"7:cat_puff": _puffer_c(_bob, Color(0.55, 0.45, 0.75), Color(0.78, 0.72, 0.92), Color(0.4, 0.32, 0.6))
		"7:boss": _armor_knight(_bob, 1.45)
		# สวรรค์แมวทอง
		"8:cat_mochi": _sheep(_bob, 0.9, false)
		"8:cat_long": _slime(_bob, 1.0, Color(1.0, 0.9, 0.55), "halo")
		"8:cat_cyclops": _hat(_mouse(_bob, 1.0, Color(1.0, 0.95, 0.85), false), "halo", 1.0)
		"8:cat_box": _chest(_bob, 1.0, "gold")
		"8:cat_ghost":
			_floaty = true
			_bee(_bob, 1.0)
		"8:cat_puff": _puffer_c(_bob, Color(1.0, 0.85, 0.4), Color(1.0, 0.96, 0.82), Color(1.0, 0.95, 0.75))
		"8:boss": _sheep(_bob, 1.5, true)
		_:
			return false
	if boss:
		_boss_weapon()
	return true

## อาวุธบอสตามชนิดเดิม ให้ท่าง้างฟาดเหมือนเดิม
func _boss_weapon() -> void:
	if _weapon != null:
		return
	_weapon = _group(_bob, Vector3(0.95, 0.85, 0.35))
	match look:
		"boss_club":
			_part(_weapon, _cyl(0.13, 1.0), _mat(Color(0.86, 0.66, 0.42)), Vector3(0.0, 0.5, 0.0))
			for e in [-1.0, 1.0]:
				_part(_weapon, _cyl(0.05, 0.25), _mat(Color(0.6, 0.4, 0.25)), Vector3(0.0, 0.5 + e * 0.62, 0.0))
		"boss_spear":
			var steel := _mat(Color(0.86, 0.88, 0.95), 0.3)
			_part(_weapon, _cyl(0.05, 1.6), _mat(Color(0.75, 0.55, 0.35)), Vector3(0.0, 0.5, 0.0))
			_part(_weapon, _cap(0.07, 0.4), steel, Vector3(0.0, 1.35, 0.0), Vector3(3.0, 1.0, 1.0))
			for i in 3:
				_part(_weapon, _cap(0.04, 0.4), steel, Vector3((float(i) - 1.0) * 0.12, 1.6, 0.0))
		"boss_hammer":
			_part(_weapon, _cyl(0.06, 1.2), _mat(Color(0.35, 0.37, 0.45), 0.5), Vector3(0.0, 0.6, 0.0))
			_part(_weapon, _cap(0.28, 0.75), _mat(Color(1.0, 0.65, 0.35)), Vector3(0.0, 1.25, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
		"boss_scythe":
			_part(_weapon, _cyl(0.05, 2.0), _mat(Color(0.3, 0.25, 0.4)), Vector3(0.0, 0.6, 0.0))
			var blade := _mat(Color(0.75, 0.7, 1.0), 0.3, 0.4)
			for i in 16:
				var a := deg_to_rad(5.0 + float(i) * 10.0)
				_part(_weapon, _ball(0.16 * (1.0 - float(i) * 0.045)), blade, Vector3(-cos(a) * 0.65, 1.45 + sin(a) * 0.32, 0.0), Vector3(1.0, 0.8, 0.35))
		_:
			_part(_weapon, _cyl(0.05, 0.3), _mat(Color(0.6, 0.4, 0.25)), Vector3.ZERO)
			_part(_weapon, _cap(0.1, 0.32), _mat(Color(1.0, 0.82, 0.3), 0.4), Vector3(0.0, 0.18, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
			_part(_weapon, _cap(0.1, 1.2), _mat(Color(0.88, 0.9, 0.97), 0.3), Vector3(0.0, 0.85, 0.0), Vector3(1.0, 1.0, 0.35))

## ของแต่งหัวหนู
func _hat(body: Node3D, kind: String, k: float) -> void:
	var top := Vector3(0.0, 0.55 * k, 0.0)
	match kind:
		"fish":
			_part(body, _ball(0.12 * k), _mat(Color(0.7, 0.8, 0.95)), Vector3(0.18 * k, -0.12 * k, 0.55 * k), Vector3(1.6, 0.8, 0.6))
			_part(body, _ball(0.08 * k), _mat(Color(0.55, 0.65, 0.85)), Vector3(0.4 * k, -0.12 * k, 0.55 * k), Vector3(0.5, 1.2, 0.4))
		"pick":
			_part(body, _ball(0.32 * k), _mat(Color(1.0, 0.82, 0.3), 0.5), top + Vector3(0.0, -0.05 * k, 0.0), Vector3(1.0, 0.55, 1.0))
			_part(body, _ball(0.07 * k), _mat(Color(1.0, 1.0, 0.75), 0.3, 1.2), top + Vector3(0.0, 0.0, 0.3 * k))
			var pick := _group(body, Vector3(0.6 * k, -0.1 * k, 0.2 * k))
			_part(pick, _cyl(0.04 * k, 0.8 * k), _mat(Color(0.7, 0.5, 0.32)), Vector3(0.0, 0.3 * k, 0.0))
			_part(pick, _cap(0.07 * k, 0.6 * k), _mat(Color(0.75, 0.78, 0.85), 0.4), Vector3(0.0, 0.7 * k, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
		"sailor":
			_part(body, _cyl(0.3 * k, 0.12 * k, 0.24 * k), _mat(Color.WHITE, 0.6), top)
			_part(body, _torus(0.26 * k, 0.32 * k), _mat(Color(0.3, 0.45, 0.85)), top + Vector3(0.0, -0.05 * k, 0.0))
		"fennec":
			for side in [-1.0, 1.0]:
				_part(body, _ball(0.3 * k), _mat(Color(0.95, 0.82, 0.6)), Vector3(side * 0.42 * k, 0.6 * k, -0.05 * k), Vector3(0.7, 1.3, 0.25), Vector3(0.0, 0.0, side * 25.0))
		"beanie":
			_part(body, _ball(0.36 * k), _mat(Color(0.45, 0.65, 1.0)), top + Vector3(0.0, -0.08 * k, 0.0), Vector3(1.0, 0.7, 1.0))
			_part(body, _ball(0.1 * k), _mat(Color.WHITE), top + Vector3(0.0, 0.22 * k, 0.0))
		"helmet":
			_part(body, _ball(0.42 * k), _mat(Color(0.75, 0.78, 0.86), 0.35), top + Vector3(0.0, -0.18 * k, 0.0), Vector3(1.1, 0.75, 1.05))
			_part(body, _ball(0.08 * k), _mat(Color(0.75, 0.6, 1.0), 0.4), top + Vector3(0.0, 0.12 * k, 0.0))
		"halo":
			_part(body, _torus(0.2 * k, 0.26 * k), _mat(Color(1.0, 0.88, 0.4), 0.3, 0.8), top + Vector3(0.0, 0.3 * k, 0.0))
			for side in [-1.0, 1.0]:
				_part(body, _ball(0.28 * k), _mat(Color(1.0, 1.0, 1.0)), Vector3(side * 0.55 * k, 0.1 * k, -0.35 * k), Vector3(0.5, 1.0, 0.25), Vector3(0.0, side * 30.0, side * 20.0))

## ปลากลมลอยตัวในแนวนอน ครีบหาง ครีบข้าง  angry คิ้วขมวด
func _fish(p: Node3D, k: float, col: Color, belly: Color, angry: bool) -> void:
	var body := _group(p, Vector3(0.0, 0.6 * k, 0.0))
	_part(body, _ball(0.55 * k), _mat(col), Vector3.ZERO, Vector3(1.25, 0.9, 0.85))
	_part(body, _ball(0.4 * k), _mat(belly), Vector3(0.05 * k, -0.15 * k, 0.2 * k), Vector3(1.2, 0.7, 0.7))
	var fin := _mat(col.darkened(0.2))
	_part(body, _ball(0.3 * k), fin, Vector3(-0.78 * k, 0.0, 0.0), Vector3(0.35, 1.0, 0.25))
	_part(body, _ball(0.18 * k), fin, Vector3(0.0, 0.45 * k, 0.0), Vector3(1.2, 0.6, 0.25))
	_part(body, _ball(0.14 * k), fin, Vector3(0.1 * k, -0.15 * k, 0.45 * k), Vector3(1.0, 0.5, 0.3), Vector3(0.0, 0.0, -30.0))
	_face(body, Vector3(0.25 * k, 0.1 * k, 0.42 * k), 0.17 * k, 0.07 * k)
	if angry:
		for side in [-1.0, 1.0]:
			_part(body, _cap(0.02 * k, 0.16 * k), _mat(Color(0.15, 0.12, 0.15)), Vector3(0.25 * k + side * 0.17 * k, 0.24 * k, 0.47 * k), Vector3.ONE, Vector3(0.0, 0.0, 90.0 + side * 25.0))
	_part(body, _torus(0.03 * k, 0.06 * k), _mat(Color(1.0, 0.55, 0.6)), Vector3(0.62 * k, -0.05 * k, 0.25 * k), Vector3.ONE, Vector3(0.0, 90.0, 0.0))

## ก้างปลายืนได้ หัวกลม กระดูกสันหลังตั้ง ก้างข้างมน
func _fishbone(p: Node3D, k: float) -> void:
	var bone := _mat(Color(0.97, 0.96, 0.92))
	var body := _group(p)
	for i in 8:
		var y := (0.2 + float(i) * 0.17) * k
		_part(body, _ball(0.07 * k), bone, Vector3(0.0, y, 0.0))
		if i > 0 and i < 7:
			var w := (0.35 - absf(float(i) - 3.5) * 0.06) * k
			for side in [-1.0, 1.0]:
				_part(body, _cap(0.035 * k, w), bone, Vector3(side * w * 0.5, y, 0.0), Vector3.ONE, Vector3(0.0, 0.0, side * 70.0))
	_part(body, _ball(0.34 * k), bone, Vector3(0.0, 1.62 * k, 0.05 * k), Vector3(1.0, 0.9, 0.85))
	_face(body, Vector3(0.0, 1.62 * k, 0.33 * k), 0.13 * k, 0.07 * k)
	_part(body, _ball(0.18 * k), bone, Vector3(0.0, 0.12 * k, 0.0), Vector3(1.6, 0.4, 0.5))
	_feet(p, 0.18 * k, 0.11 * k, Color(0.85, 0.83, 0.78))

## หมึกลอยตัว หัวทรงโดม หนวดกลมเป็นสาย  king ใส่มงกุฎ
func _squid(p: Node3D, k: float, col: Color, king: bool) -> void:
	var m := _mat(col)
	var body := _group(p, Vector3(0.0, 0.7 * k, 0.0))
	_part(body, _cap(0.42 * k, 1.1 * k), m, Vector3(0.0, 0.25 * k, 0.0))
	_part(body, _ball(0.22 * k), _mat(col.darkened(0.15)), Vector3(0.0, 0.75 * k, 0.0), Vector3(2.0, 0.5, 0.6))
	for i in 6:
		var a := TAU * float(i) / 6.0
		for j in 4:
			_part(body, _ball((0.09 - float(j) * 0.015) * k), m, Vector3(cos(a) * (0.25 + float(j) * 0.06) * k, (-0.35 - float(j) * 0.14) * k, sin(a) * (0.25 + float(j) * 0.06) * k))
	_face(body, Vector3(0.0, 0.05 * k, 0.4 * k), 0.15 * k, 0.07 * k)
	if king:
		_crown(body, Vector3(0.0, 0.85 * k, 0.0), 0.3 * k)

## สไลม์ทรงหยด  deco: crystal ผลึกบนหัว / snow ก้อนหิมะผ้าพันคอ / lava เรืองแสง / shadow ตาเรือง / halo วงแหวนทอง
func _slime(p: Node3D, k: float, col: Color, deco: String) -> void:
	var glow := 0.6 if deco.begins_with("lava") else 0.0
	var tall := 1.5 if deco == "halo" else 1.0
	var body := _group(p, Vector3(0.0, 0.42 * k * tall, 0.0))
	_part(body, _ball(0.55 * k), _mat(col, 0.4, glow), Vector3.ZERO, Vector3(1.1, 0.8 * tall, 1.0))
	_part(body, _ball(0.12 * k), _mat(Color(1.0, 1.0, 1.0, 0.8), 0.2), Vector3(-0.22 * k, 0.22 * k * tall, 0.38 * k))
	_face(body, Vector3(0.0, 0.05 * k, 0.5 * k), 0.17 * k, 0.07 * k)
	match deco:
		"crystal":
			for i in 3:
				var c := _part(body, _cyl(0.1 * k, 0.4 * k, 0.03 * k), _mat(Color(0.75, 0.9, 1.0), 0.2, 0.4), Vector3((float(i) - 1.0) * 0.18 * k, 0.48 * k, -0.05 * k))
				c.rotation_degrees = Vector3(0.0, 0.0, (float(i) - 1.0) * -25.0)
		"snow":
			_part(body, _torus(0.42 * k, 0.52 * k), _mat(Color(1.0, 0.45, 0.45)), Vector3(0.0, -0.2 * k, 0.0))
			_part(body, _cyl(0.04 * k, 0.18 * k, 0.0), _mat(Color(1.0, 0.6, 0.25)), Vector3(0.0, 0.0, 0.62 * k), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
		"lava", "lava_king":
			for i in 4:
				_part(body, _ball(0.07 * k), _mat(Color(1.0, 0.8, 0.3), 0.3, 1.0), Vector3(cos(float(i) * 1.6) * 0.45 * k, -0.25 * k, sin(float(i) * 1.6) * 0.45 * k))
			if deco == "lava_king":
				_crown(body, Vector3(0.0, 0.48 * k, 0.0), 0.3 * k)
		"shadow":
			_part(body, _ball(0.06 * k), _mat(Color(0.75, 0.65, 1.0), 0.3, 1.0), Vector3(0.0, 0.35 * k, 0.45 * k))
		"halo":
			_part(body, _torus(0.24 * k, 0.3 * k), _mat(Color(1.0, 0.88, 0.4), 0.3, 0.8), Vector3(0.0, 0.62 * k * tall, 0.0))

## ตัวตุ่นหิน ยืนตัวตั้ง จมูกชมพูใหญ่ หมวกนิรภัยมีไฟ  boss ผลึกบนหลังกับมงกุฎ
func _mole(p: Node3D, k: float, boss: bool) -> void:
	var fur := _mat(Color(0.55, 0.42, 0.36))
	var body := _group(p)
	_part(body, _cap(0.45 * k, 1.5 * k), fur, Vector3(0.0, 0.8 * k, 0.0))
	_part(body, _cap(0.32 * k, 1.0 * k), _mat(Color(0.78, 0.66, 0.58)), Vector3(0.0, 0.7 * k, 0.2 * k), Vector3(1.0, 1.0, 0.7))
	_part(body, _ball(0.12 * k), _mat(Color(1.0, 0.6, 0.7)), Vector3(0.0, 1.15 * k, 0.45 * k))
	_face(body, Vector3(0.0, 1.32 * k, 0.4 * k), 0.13 * k, 0.05 * k)
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.16 * k), _mat(Color(1.0, 0.78, 0.8)), Vector3(side * 0.42 * k, 0.75 * k, 0.25 * k), Vector3(1.0, 0.7, 0.7))
	_part(body, _ball(0.36 * k), _mat(Color(1.0, 0.82, 0.3), 0.5), Vector3(0.0, 1.5 * k, 0.0), Vector3(1.05, 0.5, 1.05))
	_part(body, _ball(0.08 * k), _mat(Color(1.0, 1.0, 0.75), 0.3, 1.2), Vector3(0.0, 1.55 * k, 0.32 * k))
	_feet(p, 0.22 * k, 0.13 * k, Color(0.45, 0.34, 0.3))
	if boss:
		for i in 4:
			var c := _part(body, _cyl(0.12 * k, 0.45 * k, 0.03 * k), _mat(Color(0.7, 0.85, 1.0), 0.2, 0.5), Vector3((float(i) - 1.5) * 0.18 * k, 1.0 * k, -0.42 * k))
			c.rotation_degrees = Vector3(-30.0, 0.0, (float(i) - 1.5) * -20.0)
		_crown(body, Vector3(0.0, 1.72 * k, 0.0), 0.25 * k)

## ค้างคาวลอยตัว ปีกกลมมน หูเล็ก
func _bat(p: Node3D, k: float, col: Color, belly: Color) -> void:
	var m := _mat(col)
	var body := _group(p, Vector3(0.0, 0.75 * k, 0.0))
	_part(body, _ball(0.42 * k), m, Vector3.ZERO)
	_part(body, _ball(0.3 * k), _mat(belly), Vector3(0.0, -0.08 * k, 0.18 * k), Vector3(1.0, 0.9, 0.7))
	for side in [-1.0, 1.0]:
		_part(body, _cyl(0.12 * k, 0.25 * k, 0.0), m, Vector3(side * 0.22 * k, 0.42 * k, 0.0))
		for j in 3:
			_part(body, _ball((0.22 - float(j) * 0.03) * k), m, Vector3(side * (0.5 + float(j) * 0.22) * k, (0.05 - float(j) * 0.08) * k, -0.05 * k), Vector3(1.0, 0.7, 0.2))
	_face(body, Vector3(0.0, 0.08 * k, 0.38 * k), 0.14 * k, 0.07 * k)

## ปูกลม ก้ามมน  scorpion ตัวเป็นกล่องกระดาษมีหางโค้งปลายกลม  boss ใส่หมวก/มงกุฎ
func _crab(p: Node3D, k: float, col: Color, scorpion: bool, boss: bool) -> void:
	var m := _mat(col)
	var body := _group(p, Vector3(0.0, 0.42 * k, 0.0))
	if scorpion:
		_part(body, _box(Vector3(1.0 * k, 0.55 * k, 0.75 * k)), m, Vector3.ZERO)
		_part(body, _box(Vector3(0.9 * k, 0.06 * k, 0.6 * k)), _mat(col.darkened(0.2)), Vector3(0.0, 0.29 * k, 0.0))
		for i in 7:
			var t := float(i) / 6.0
			_part(body, _ball((0.12 - t * 0.03) * k), m, Vector3((-0.5 - sin(t * 1.4) * 0.35) * k, (0.15 + t * 0.75) * k, -0.2 * k))
		_part(body, _ball(0.12 * k), _mat(Color(1.0, 0.55, 0.45)), Vector3(-0.62 * k, 0.98 * k, -0.2 * k))
	else:
		_part(body, _ball(0.5 * k), m, Vector3.ZERO, Vector3(1.3, 0.75, 1.0))
	_face(body, Vector3(0.0, 0.12 * k, 0.42 * k), 0.16 * k, 0.07 * k)
	for side in [-1.0, 1.0]:
		_part(body, _cap(0.06 * k, 0.4 * k), m, Vector3(side * 0.55 * k, 0.1 * k, 0.3 * k), Vector3.ONE, Vector3(0.0, 0.0, side * 40.0))
		_part(body, _ball(0.2 * k), m, Vector3(side * 0.72 * k, 0.32 * k, 0.4 * k), Vector3(1.0, 0.8, 0.7))
		_part(body, _ball(0.1 * k), m, Vector3(side * 0.82 * k, 0.48 * k, 0.4 * k), Vector3(0.8, 1.0, 0.6))
		for j in 3:
			_part(body, _cap(0.04 * k, 0.3 * k), _mat(col.darkened(0.15)), Vector3(side * (0.45 + float(j) * 0.1) * k, -0.3 * k, (-0.2 + float(j) * 0.2) * k), Vector3.ONE, Vector3(0.0, 0.0, side * 30.0))
	if boss:
		if scorpion:
			_crown(body, Vector3(0.0, 0.42 * k, 0.0), 0.28 * k)
		else:
			_part(body, _cyl(0.3 * k, 0.18 * k, 0.26 * k), _mat(Color(0.25, 0.3, 0.5)), Vector3(0.0, 0.48 * k, 0.0))
			_part(body, _cyl(0.42 * k, 0.04 * k), _mat(Color(0.25, 0.3, 0.5)), Vector3(0.0, 0.4 * k, 0.0))
			_part(body, _ball(0.06 * k), _mat(Color(1.0, 0.85, 0.35), 0.4), Vector3(0.0, 0.5 * k, 0.3 * k))

## นกนางนวลยืน ตัวขาวปีกเทา ปากเหลือง
func _gull(p: Node3D, k: float) -> void:
	var white := _mat(Color(0.98, 0.98, 1.0))
	var body := _group(p)
	_part(body, _cap(0.42 * k, 1.3 * k), white, Vector3(0.0, 0.75 * k, 0.0))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.3 * k), _mat(Color(0.7, 0.74, 0.8)), Vector3(side * 0.38 * k, 0.75 * k, -0.05 * k), Vector3(0.35, 1.0, 0.8))
	_part(body, _cyl(0.08 * k, 0.28 * k, 0.0), _mat(Color(1.0, 0.8, 0.3)), Vector3(0.0, 1.12 * k, 0.48 * k), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
	_face(body, Vector3(0.0, 1.25 * k, 0.38 * k), 0.15 * k, 0.07 * k)
	_feet(p, 0.16 * k, 0.11 * k, Color(1.0, 0.7, 0.3))

## แมงกะพรุนใส โดมกลม หนวดเป็นเม็ดกลม
func _jelly(p: Node3D, k: float, col: Color) -> void:
	var body := _group(p, Vector3(0.0, 0.85 * k, 0.0))
	_part(body, _ball(0.5 * k), _mat(col, 0.2), Vector3.ZERO, Vector3(1.0, 0.75, 1.0))
	_part(body, _ball(0.3 * k), _mat(col.lightened(0.3), 0.2, 0.3), Vector3(0.0, 0.05 * k, 0.0))
	for i in 5:
		var a := TAU * float(i) / 5.0
		for j in 5:
			_part(body, _ball(0.05 * k), _mat(col, 0.2), Vector3(cos(a) * 0.3 * k + sin(float(j)) * 0.04 * k, (-0.35 - float(j) * 0.13) * k, sin(a) * 0.3 * k))
	_face(body, Vector3(0.0, 0.0, 0.48 * k), 0.15 * k, 0.07 * k)

## ลูกกระบองเพชรกลม หนามสั้นปลายมน ดอกไม้บนหัว
func _cactus(p: Node3D, k: float) -> void:
	var green := _mat(Color(0.45, 0.75, 0.45))
	var body := _group(p, Vector3(0.0, 0.5 * k, 0.0))
	_part(body, _ball(0.5 * k), green, Vector3.ZERO, Vector3(1.0, 0.95, 1.0))
	var spike := _mat(Color(0.98, 0.95, 0.8))
	for i in 16:
		var a := float(i) * 2.4
		var y := -0.7 + 1.4 * float(i) / 15.0
		var rr := sqrt(maxf(1.0 - y * y, 0.0))
		var d := Vector3(cos(a) * rr, y, sin(a) * rr).normalized()
		if d.z > 0.6 and absf(d.y) < 0.4:
			continue
		_part(body, _ball(0.04 * k), spike, d * 0.52 * k)
	for i in 5:
		var a := TAU * float(i) / 5.0
		_part(body, _ball(0.08 * k), _mat(Color(1.0, 0.6, 0.75)), Vector3(cos(a) * 0.1 * k, 0.5 * k, sin(a) * 0.1 * k))
	_part(body, _ball(0.06 * k), _mat(Color(1.0, 0.9, 0.4)), Vector3(0.0, 0.53 * k, 0.0))
	_face(body, Vector3(0.0, 0.05 * k, 0.47 * k), 0.16 * k, 0.07 * k)
	_feet(p, 0.2 * k, 0.11 * k, Color(0.35, 0.6, 0.35))

## งูทรายขดตัวตั้งขึ้น หัวกลม
func _snake(p: Node3D, k: float, col: Color) -> void:
	var m := _mat(col)
	var band := _mat(col.darkened(0.25))
	var body := _group(p)
	for i in 14:
		var t := float(i) / 13.0
		var a := t * TAU * 1.4
		_part(body, _ball((0.24 - t * 0.06) * k), band if i % 3 == 0 else m, Vector3(cos(a) * 0.25 * k * (1.0 - t * 0.6), (0.2 + t * 1.3) * k, sin(a) * 0.25 * k * (1.0 - t * 0.6)))
	_part(body, _ball(0.28 * k), m, Vector3(0.0, 1.62 * k, 0.05 * k), Vector3(1.1, 0.9, 1.0))
	_face(body, Vector3(0.0, 1.65 * k, 0.3 * k), 0.12 * k, 0.06 * k)
	_part(body, _cap(0.015 * k, 0.15 * k), _mat(Color(1.0, 0.45, 0.55)), Vector3(0.0, 1.5 * k, 0.36 * k), Vector3.ONE, Vector3(90.0, 0.0, 0.0))

## ก้อนเมฆลอย (ฝุ่นทราย / เมฆทอง)
func _cloud(p: Node3D, k: float, col: Color, gold: bool) -> void:
	var m := _mat(col, 0.9, 0.3 if gold else 0.0)
	var body := _group(p, Vector3(0.0, 0.7 * k, 0.0))
	for i in 6:
		var a := TAU * float(i) / 6.0
		_part(body, _ball(0.3 * k), m, Vector3(cos(a) * 0.32 * k, sin(a) * 0.2 * k, 0.0))
	_part(body, _ball(0.38 * k), m, Vector3.ZERO)
	_face(body, Vector3(0.0, 0.0, 0.36 * k), 0.14 * k, 0.07 * k)

## เพนกวินบอท ตัวกลมยาว ท้องขาว แว่นจอฟ้า  boss มงกุฎ
func _penguin(p: Node3D, k: float, boss: bool) -> void:
	var body := _group(p)
	_part(body, _cap(0.45 * k, 1.4 * k), _mat(Color(0.25, 0.28, 0.4)), Vector3(0.0, 0.75 * k, 0.0))
	_part(body, _cap(0.33 * k, 1.0 * k), _mat(Color(0.98, 0.98, 1.0)), Vector3(0.0, 0.68 * k, 0.18 * k), Vector3(1.0, 1.0, 0.75))
	_part(body, _box(Vector3(0.55 * k, 0.16 * k, 0.1 * k)), _mat(Color(0.45, 0.85, 1.0), 0.3, 0.8), Vector3(0.0, 1.2 * k, 0.42 * k))
	_part(body, _cyl(0.07 * k, 0.16 * k, 0.0), _mat(Color(1.0, 0.75, 0.3)), Vector3(0.0, 1.05 * k, 0.47 * k), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.2 * k), _mat(Color(0.25, 0.28, 0.4)), Vector3(side * 0.45 * k, 0.75 * k, 0.0), Vector3(0.35, 1.0, 0.7), Vector3(0.0, 0.0, side * 15.0))
		_part(body, _ball(0.07 * k), _mat(Color(1.0, 0.62, 0.72)), Vector3(side * 0.25 * k, 1.0 * k, 0.4 * k), Vector3(1.0, 0.5, 0.35))
	_part(body, _cyl(0.02 * k, 0.25 * k), _mat(Color(0.35, 0.37, 0.45)), Vector3(0.0, 1.55 * k, 0.0))
	_part(body, _ball(0.06 * k), _mat(Color(1.0, 0.45, 0.5), 0.3, 0.6), Vector3(0.0, 1.7 * k, 0.0))
	_feet(p, 0.18 * k, 0.12 * k, Color(1.0, 0.75, 0.3))
	if boss:
		_crown(body, Vector3(0.0, 1.48 * k, 0.0), 0.25 * k)

## เทียนเดินได้ น้ำตาเทียนกลม เปลวไฟเรือง
func _candle(p: Node3D, k: float, wax: Color, flame: Color) -> void:
	var body := _group(p)
	_part(body, _cyl(0.32 * k, 1.2 * k), _mat(wax), Vector3(0.0, 0.62 * k, 0.0))
	for i in 3:
		_part(body, _cap(0.06 * k, 0.3 * k), _mat(wax.lightened(0.15)), Vector3((float(i) - 1.0) * 0.18 * k, 1.1 * k, 0.28 * k))
	_part(body, _cyl(0.02 * k, 0.12 * k), _mat(Color(0.2, 0.18, 0.18)), Vector3(0.0, 1.28 * k, 0.0))
	_part(body, _ball(0.14 * k), _mat(flame, 0.3, 1.2), Vector3(0.0, 1.45 * k, 0.0), Vector3(0.8, 1.3, 0.8))
	_part(body, _ball(0.07 * k), _mat(Color(1.0, 0.98, 0.85), 0.3, 1.5), Vector3(0.0, 1.42 * k, 0.03 * k))
	_face(body, Vector3(0.0, 0.75 * k, 0.32 * k), 0.13 * k, 0.07 * k)
	_feet(p, 0.18 * k, 0.12 * k, wax.darkened(0.2))

## หีบ/ลัง ตาโต  kind: crate ลังปลา / cart รถแร่ / treasure หีบสมบัติ / sled เลื่อนหิมะ / pot หม้อไฟ / book หนังสือเวท / gold หีบทอง
func _chest(p: Node3D, k: float, kind: String) -> void:
	var cols := {"crate": Color(0.85, 0.66, 0.45), "cart": Color(0.55, 0.5, 0.5), "treasure": Color(0.75, 0.45, 0.3), "sled": Color(0.45, 0.65, 0.95),
		"pot": Color(0.35, 0.33, 0.38), "book": Color(0.55, 0.4, 0.75), "gold": Color(1.0, 0.82, 0.35)}
	var col: Color = cols.get(kind, Color(0.8, 0.6, 0.4))
	var shine := 0.2 if kind == "gold" else 0.0
	var m := _mat(col, 0.7, shine)
	var body := _group(p, Vector3(0.0, 0.45 * k, 0.0))
	if kind == "pot":
		_part(body, _cyl(0.6 * k, 0.6 * k, 0.7 * k), m, Vector3.ZERO)
		_part(body, _cyl(0.62 * k, 0.06 * k), _mat(Color(1.0, 0.5, 0.25), 0.4, 0.8), Vector3(0.0, 0.32 * k, 0.0))
		for i in 3:
			_part(body, _ball(0.1 * k), _mat(Color(1.0, 0.7, 0.3), 0.4, 1.0), Vector3((float(i) - 1.0) * 0.25 * k, 0.4 * k, 0.0))
	else:
		_part(body, _box(Vector3(1.3 * k, 0.65 * k, 0.8 * k)), m, Vector3.ZERO)
		var lid := _mat(col.darkened(0.15), 0.7, shine)
		match kind:
			"treasure", "gold":
				_part(body, _cyl(0.4 * k, 1.3 * k), lid, Vector3(0.0, 0.33 * k, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
				_part(body, _ball(0.1 * k), _mat(Color(1.0, 0.88, 0.4), 0.3, 0.5), Vector3(0.0, 0.3 * k, 0.42 * k))
			"crate":
				for i in 3:
					_part(body, _box(Vector3(1.32 * k, 0.05 * k, 0.82 * k)), lid, Vector3(0.0, (-0.22 + float(i) * 0.22) * k, 0.0))
				_part(body, _ball(0.16 * k), _mat(Color(0.65, 0.75, 0.92)), Vector3(0.3 * k, 0.4 * k, 0.0), Vector3(1.8, 0.7, 0.8))
			"cart":
				for side in [-1.0, 1.0]:
					for e in [-1.0, 1.0]:
						_part(body, _cyl(0.16 * k, 0.08 * k), _mat(Color(0.3, 0.3, 0.33)), Vector3(side * 0.45 * k, -0.35 * k, e * 0.42 * k), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
				for i in 3:
					_part(body, _ball(0.14 * k), _mat(Color(0.7, 0.85, 1.0), 0.2, 0.4), Vector3((float(i) - 1.0) * 0.32 * k, 0.38 * k, 0.0))
			"sled":
				for e in [-1.0, 1.0]:
					_part(body, _cap(0.05 * k, 1.5 * k), _mat(Color(0.9, 0.3, 0.3)), Vector3(0.0, -0.38 * k, e * 0.35 * k), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
				_part(body, _torus(0.3 * k, 0.38 * k), _mat(Color(1.0, 0.45, 0.45)), Vector3(0.0, 0.33 * k, 0.0))
			"book":
				_part(body, _box(Vector3(1.34 * k, 0.5 * k, 0.7 * k)), _mat(Color(0.98, 0.96, 0.9)), Vector3(0.0, 0.0, 0.07 * k))
				_part(body, _ball(0.1 * k), _mat(Color(0.75, 0.65, 1.0), 0.3, 1.0), Vector3(0.0, 0.34 * k, 0.0))
	_face(body, Vector3(0.0, 0.0, 0.42 * k), 0.2 * k, 0.09 * k)
	_feet(p, 0.4 * k, 0.12 * k, col.darkened(0.25))

## ปลาปักเป้าเปลี่ยนสี
func _puffer_c(p: Node3D, col: Color, belly: Color, spike_col: Color) -> void:
	var body := _group(p, Vector3(0.0, 0.62, 0.0))
	_part(body, _ball(0.55), _mat(col), Vector3.ZERO)
	_part(body, _ball(0.42), _mat(belly), Vector3(0.0, -0.18, 0.22), Vector3(1.0, 0.8, 0.8))
	var spike := _mat(spike_col)
	for i in 18:
		var a := float(i) * 2.4
		var y := -0.8 + 1.6 * float(i) / 17.0
		var rr := sqrt(maxf(1.0 - y * y, 0.0))
		var d := Vector3(cos(a) * rr, y, sin(a) * rr).normalized()
		if d.z > 0.6 and absf(d.y) < 0.4:
			continue
		_part(body, _ball(0.07), spike, d * 0.6, Vector3(0.8, 0.8, 0.8))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.16), _mat(col.darkened(0.15)), Vector3(side * 0.55, -0.05, 0.1), Vector3(0.5, 1.0, 0.8))
	_part(body, _torus(0.04, 0.08), _mat(Color(1.0, 0.55, 0.6)), Vector3(0.0, -0.12, 0.55), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
	_face(body, Vector3(0.0, 0.1, 0.5), 0.2, 0.08)

## อัศวินหนูชุดเกราะเงา
func _armor_knight(p: Node3D, k: float) -> void:
	var body := _mouse(p, k, Color(0.5, 0.46, 0.6), false)
	_hat(body, "helmet", k)
	_part(body, _ball(0.5 * k), _mat(Color(0.7, 0.72, 0.82), 0.35), Vector3(0.0, -0.1 * k, 0.12 * k), Vector3(1.15, 0.8, 0.9))
	_part(body, _cyl(0.38 * k, 0.06 * k), _mat(Color(0.45, 0.35, 0.7), 0.4), Vector3(-0.62 * k, 0.0, 0.3 * k), Vector3.ONE, Vector3(90.0, 0.0, -20.0))

## แกะเมฆ ขนฟูเป็นก้อนกลม หน้าเทา  king สีทองใส่มงกุฎ
func _sheep(p: Node3D, k: float, king: bool) -> void:
	var wool := _mat(Color(1.0, 0.92, 0.6) if king else Color(0.98, 0.98, 1.0), 0.9, 0.25 if king else 0.0)
	var body := _group(p, Vector3(0.0, 0.55 * k, 0.0))
	for i in 8:
		var a := TAU * float(i) / 8.0
		_part(body, _ball(0.26 * k), wool, Vector3(cos(a) * 0.36 * k, sin(a) * 0.26 * k, -0.05 * k))
	_part(body, _ball(0.42 * k), wool, Vector3.ZERO)
	_part(body, _ball(0.26 * k), _mat(Color(0.6, 0.58, 0.62)), Vector3(0.0, 0.05 * k, 0.32 * k), Vector3(1.0, 0.9, 0.7))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.1 * k), _mat(Color(0.6, 0.58, 0.62)), Vector3(side * 0.3 * k, 0.15 * k, 0.28 * k), Vector3(1.4, 0.6, 0.6))
	_face(body, Vector3(0.0, 0.1 * k, 0.5 * k), 0.1 * k, 0.05 * k)
	_feet(p, 0.2 * k, 0.11 * k, Color(0.55, 0.53, 0.58))
	if king:
		_crown(body, Vector3(0.0, 0.55 * k, 0.0), 0.28 * k)

## ผึ้งทองลอยตัว ลายทาง ปีกใส
func _bee(p: Node3D, k: float) -> void:
	var body := _group(p, Vector3(0.0, 0.75 * k, 0.0))
	_part(body, _ball(0.45 * k), _mat(Color(1.0, 0.85, 0.35)), Vector3.ZERO, Vector3(1.1, 1.0, 1.0))
	for i in 2:
		_part(body, _torus(0.4 * k, 0.48 * k), _mat(Color(0.35, 0.28, 0.25)), Vector3((-0.12 - float(i) * 0.18) * k, 0.0, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.26 * k), _mat(Color(0.9, 0.97, 1.0, 0.6), 0.2), Vector3(side * 0.12 * k, 0.45 * k, -0.15 * k), Vector3(0.5, 1.0, 0.25), Vector3(0.0, 0.0, side * 25.0))
		_part(body, _cyl(0.015 * k, 0.25 * k), _mat(Color(0.3, 0.25, 0.25)), Vector3(side * 0.12 * k, 0.5 * k, 0.25 * k), Vector3.ONE, Vector3(20.0, 0.0, side * 15.0))
	_face(body, Vector3(0.12 * k, 0.05 * k, 0.4 * k), 0.15 * k, 0.07 * k)
