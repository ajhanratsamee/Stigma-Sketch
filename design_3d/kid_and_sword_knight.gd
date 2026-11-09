extends SceneTree
## ภาพตัวอย่างตัวละครเด็ก 3 มิติ แบบเดิมเทียบกับชุด SWORD KNIGHT หน้า เฉียง หลัง ไม่แก้ไฟล์เกม
const OUT := "C:/Users/ADMINI~1.DES/AppData/Local/Temp/claude/54a2f3993fe301a6/cff036b7-20f9-45ac-81c2-38159b41e6d4/scratchpad/kid3d_preview.png"

const SKIN := Color(1.0, 0.82, 0.68)
const HAIR := Color(0.46, 0.05, 0.07)
const TUNIC := Color(0.95, 0.36, 0.2)
const TRIM := Color(0.5, 0.08, 0.1)
const PANTS := Color(0.34, 0.08, 0.1)
const SHOE := Color(0.62, 0.1, 0.1)
const BELT := Color(0.3, 0.19, 0.11)
const EYE := Color(0.08, 0.06, 0.06)
const STEEL := Color(0.7, 0.75, 0.82)
const MOUTH := Color(0.6, 0.22, 0.22)

func _mat(color: Color, rough := 0.75) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rough
	return m

func _part(parent: Node3D, mesh: Mesh, color: Color, at: Vector3, size := Vector3.ONE, turn := Vector3.ZERO, rough := 0.75) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.material_override = _mat(color, rough)
	node.position = at
	node.scale = size
	node.rotation_degrees = turn
	parent.add_child(node)
	return node

func _ball(r: float) -> SphereMesh:
	var m := SphereMesh.new()
	m.radius = r
	m.height = r * 2.0
	m.radial_segments = 48
	m.rings = 24
	return m

func _pill(r: float, h: float) -> CapsuleMesh:
	var m := CapsuleMesh.new()
	m.radius = r
	m.height = h
	m.radial_segments = 32
	m.rings = 12
	return m

func _cone(top: float, low: float, h: float) -> CylinderMesh:
	var m := CylinderMesh.new()
	m.top_radius = top
	m.bottom_radius = low
	m.height = h
	m.radial_segments = 40
	return m

func _box(size: Vector3) -> BoxMesh:
	var m := BoxMesh.new()
	m.size = size
	return m

## ขอบผมตามมุมรอบหัว 0 คือหน้า หน่วยองศาเหนือแนวตา หน้าม้าสูงกว่าตา ด้านข้างและหลังยาวลงมา ปลายหยักเล็กน้อย
func _hair_edge(az: float, style := "kid") -> float:
	var around := absf(wrapf(az, -PI, PI))
	if style == "knight":
		# ผมสั้นเรียบร้อย ปัดหน้าม้าเฉียงเล็กน้อย คลุมหน้าผาก ด้านข้างและหลังสั้น
		var side_k := clampf((around - deg_to_rad(48.0)) / deg_to_rad(60.0), 0.0, 1.0)
		side_k = side_k * side_k * (3.0 - 2.0 * side_k)
		var swept := 22.0 + sin(wrapf(az, -PI, PI)) * 9.0
		# ด้านหลังยาวลงมาถึงท้ายทอย
		var back_k := clampf((around - deg_to_rad(100.0)) / deg_to_rad(45.0), 0.0, 1.0)
		back_k = back_k * back_k * (3.0 - 2.0 * back_k)
		return lerpf(lerpf(swept, -8.0, side_k), -52.0, back_k) - absf(sin(az * 7.0)) * 5.0
	var k := clampf((around - deg_to_rad(52.0)) / deg_to_rad(68.0), 0.0, 1.0)
	k = k * k * (3.0 - 2.0 * k)
	var edge := lerpf(22.0, -30.0, k)
	var tips := absf(sin(az * 11.0)) * lerpf(5.0, 3.0, k)
	return edge - tips

## ผิวผมต่อเนื่องครอบหัว แถวท้ายพับเข้าหาหัวให้ขอบมีความหนา มีแถบเงาวงรอบแบบเกม
func _hair_mesh(style := "kid") -> ArrayMesh:
	const AROUND := 132
	const DOWN := 26
	const LIP := 3
	var radii := Vector3(0.52, 0.494, 0.4992)
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	var colors := PackedColorArray()
	var index := PackedInt32Array()
	var rows := DOWN + LIP + 1
	for a in AROUND + 1:
		var az := TAU * float(a) / float(AROUND)
		var edge := _hair_edge(az, style)
		for r in rows:
			var el: float
			var puff: float
			if r <= DOWN:
				var t := float(r) / float(DOWN)
				el = lerpf(89.5, edge, t)
				puff = 1.075 + 0.02 * sin(t * PI)
			else:
				el = edge + float(r - DOWN) * 1.2
				puff = lerpf(1.075, 0.985, float(r - DOWN) / float(LIP))
			var e := deg_to_rad(el)
			var dir := Vector3(sin(az) * cos(e), sin(e), cos(az) * cos(e))
			verts.append(Vector3(dir.x * radii.x, dir.y * radii.y, dir.z * radii.z) * puff)
			norms.append(Vector3(dir.x / radii.x, dir.y / radii.y, dir.z / radii.z).normalized())
			var band := clampf(1.0 - absf(el - 42.0) / 11.0, 0.0, 1.0)
			colors.append(HAIR.lerp(Color(0.86, 0.22, 0.2), band * band * (0.55 + 0.45 * sin(az * 22.0) * sin(az * 22.0))))
	for a in AROUND:
		for r in rows - 1:
			var i0 := a * rows + r
			var i1 := (a + 1) * rows + r
			index.append_array(PackedInt32Array([i0, i1, i0 + 1, i1, i1 + 1, i0 + 1]))
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = index
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh

## เด็กหันหน้าไปทาง +z สูงราว 2.2 หน่วย หัวโตตามสัดส่วนเด็ก
func _kid(turn_y: float, x: float) -> Node3D:
	var kid := Node3D.new()
	kid.position = Vector3(x, 0.0, 0.0)
	kid.rotation_degrees.y = turn_y
	root.add_child(kid)
	# ขาและรองเท้า
	for side in [-1.0, 1.0]:
		_part(kid, _pill(0.1, 0.56), SKIN, Vector3(side * 0.16, 0.36, 0.0))
		# กางเกงขาสั้น
		_part(kid, _cone(0.15, 0.17, 0.24), PANTS, Vector3(side * 0.16, 0.56, 0.0))
		_part(kid, _ball(0.16), SHOE, Vector3(side * 0.17, 0.09, 0.05), Vector3(0.95, 0.62, 1.35))
	# เอวกางเกง และเสื้อกล้ามแขนกุด
	_part(kid, _cone(0.27, 0.3, 0.1), PANTS, Vector3(0.0, 0.7, 0.0))
	_part(kid, _cone(0.24, 0.285, 0.52), TUNIC, Vector3(0.0, 0.97, 0.0))
	_part(kid, _cone(0.285, 0.29, 0.04), TRIM, Vector3(0.0, 0.73, 0.0))
	# แขนซ้าย ปล่อยข้างตัว
	_part(kid, _pill(0.08, 0.46), SKIN, Vector3(-0.34, 0.96, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -18.0))
	_part(kid, _ball(0.1), SKIN, Vector3(-0.43, 0.72, 0.0))
	# แขนขวา ยกถือดาบไม้
	_part(kid, _pill(0.08, 0.5), SKIN, Vector3(0.42, 0.98, 0.08), Vector3.ONE, Vector3(-20.0, 0.0, 55.0))
	var hand := Vector3(0.62, 0.84, 0.18)
	_part(kid, _ball(0.1), SKIN, hand)
	_part(kid, _box(Vector3(0.1, 0.9, 0.04)), STEEL, hand + Vector3(0.17, 0.5, 0.03), Vector3.ONE, Vector3(5.0, 0.0, -20.0), 0.35)
	_part(kid, _box(Vector3(0.34, 0.07, 0.09)), TRIM, hand + Vector3(0.03, 0.08, 0.01), Vector3.ONE, Vector3(0.0, 0.0, -20.0))
	# หัวโต
	var head := Vector3(0.0, 1.62, 0.0)
	_part(kid, _ball(0.52), SKIN, head, Vector3(1.0, 0.95, 0.96))
	for side in [-1.0, 1.0]:
		_part(kid, _ball(0.09), SKIN, head + Vector3(side * 0.52, -0.02, 0.0))
		# ตากลมโต มีจุดสะท้อน
		_part(kid, _ball(0.082), EYE, head + Vector3(side * 0.19, 0.0, 0.45), Vector3(0.9, 1.25, 0.35), Vector3.ZERO, 0.2)
		_part(kid, _ball(0.024), Color.WHITE, head + Vector3(side * 0.19 + 0.025, 0.045, 0.485), Vector3.ONE, Vector3.ZERO, 0.2)
	# จมูกเล็กนิดเดียว
	_part(kid, _ball(0.026), Color(0.96, 0.72, 0.58), head + Vector3(0.0, -0.09, 0.492))
	# ปากยิ้ม เรียงจุดเล็กตามผิวหน้า
	for i in 11:
		var u := float(i) / 5.0 - 1.0
		var mx := u * 0.095
		var my := -0.17 - 0.04 * (1.0 - u * u)
		var mz := 0.4992 * sqrt(maxf(1.0 - mx * mx / 0.2704 - my * my / 0.244, 0.0))
		_part(kid, _ball(0.0135), MOUTH, head + Vector3(mx, my, mz))
	# ผมก้อนเดียวปั้นตามทรงหัว หน้าม้าเรียบแนบหัว ไม่มีรอยต่อ
	var hair := MeshInstance3D.new()
	hair.mesh = _hair_mesh()
	var hair_mat := StandardMaterial3D.new()
	hair_mat.vertex_color_use_as_albedo = true
	hair_mat.albedo_color = Color.WHITE
	hair_mat.roughness = 0.55
	hair_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	hair.material_override = hair_mat
	hair.position = head
	kid.add_child(hair)
	return kid

## ชุด SWORD KNIGHT หน้าเดิมของเด็ก ผมสั้นปัดเฉียงมีปอยชี้ไปด้านหลัง เกราะอกเหล็กทับเสื้อแดง ดาบยาวจริงจัง
func _knight(turn_y: float, x: float) -> Node3D:
	var kid := Node3D.new()
	kid.position = Vector3(x, 0.0, 0.0)
	kid.rotation_degrees.y = turn_y
	root.add_child(kid)
	var steel := Color(0.66, 0.7, 0.77)
	var steel_dark := Color(0.4, 0.43, 0.5)
	var red := Color(0.72, 0.09, 0.1)
	var gold := Color(0.92, 0.72, 0.28)
	var cloth := Color(0.22, 0.13, 0.14)
	# ขาเกราะและรองเท้าเหล็ก
	for side in [-1.0, 1.0]:
		_part(kid, _pill(0.115, 0.56), cloth, Vector3(side * 0.16, 0.38, 0.0))
		# สนับแข้งเรียบเรียว สนับเข่าแบน รองเท้าเหล็กหัวมน
		_part(kid, _cone(0.128, 0.105, 0.3), steel, Vector3(side * 0.16, 0.27, 0.0), Vector3.ONE, Vector3.ZERO, 0.35)
		_part(kid, _ball(0.1), steel, Vector3(side * 0.16, 0.43, 0.03), Vector3(1.05, 0.5, 0.95), Vector3.ZERO, 0.35)
		_part(kid, _cone(0.132, 0.128, 0.025), gold, Vector3(side * 0.16, 0.39, 0.0), Vector3.ONE, Vector3.ZERO, 0.35)
		_part(kid, _ball(0.15), steel_dark, Vector3(side * 0.16, 0.08, 0.05), Vector3(0.9, 0.52, 1.35), Vector3.ZERO, 0.35)
	# เสื้อแดงยาวถึงต้นขา เข็มขัด เกราะอก
	_part(kid, _cone(0.26, 0.36, 0.56), red, Vector3(0.0, 0.76, 0.0))
	_part(kid, _cone(0.3, 0.31, 0.08), Color(0.28, 0.17, 0.11), Vector3(0.0, 0.76, 0.0))
	_part(kid, _box(Vector3(0.14, 0.11, 0.03)), gold, Vector3(0.0, 0.76, 0.31), Vector3.ONE, Vector3.ZERO, 0.35)
	_part(kid, _cone(0.285, 0.31, 0.32), steel, Vector3(0.0, 1.0, 0.0), Vector3.ONE, Vector3.ZERO, 0.35)
	_part(kid, _box(Vector3(0.06, 0.28, 0.03)), gold, Vector3(0.0, 1.0, 0.3), Vector3.ONE, Vector3.ZERO, 0.35)
	# เกราะไหล่ แขน ถุงมือเหล็ก
	for side in [-1.0, 1.0]:
		_part(kid, _ball(0.18), steel, Vector3(side * 0.34, 1.16, 0.0), Vector3(1.05, 0.72, 1.05), Vector3(0.0, 0.0, side * -20.0), 0.35)
		_part(kid, _ball(0.11), red, Vector3(side * 0.34, 1.21, 0.0), Vector3(1.3, 0.3, 1.3))
	_part(kid, _pill(0.085, 0.46), cloth, Vector3(-0.37, 0.92, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -14.0))
	_part(kid, _ball(0.115), steel, Vector3(-0.44, 0.7, 0.0), Vector3.ONE, Vector3.ZERO, 0.35)
	_part(kid, _pill(0.085, 0.5), cloth, Vector3(0.45, 0.96, 0.08), Vector3.ONE, Vector3(-20.0, 0.0, 55.0))
	var hand := Vector3(0.64, 0.82, 0.18)
	_part(kid, _ball(0.115), steel, hand, Vector3.ONE, Vector3.ZERO, 0.35)
	# ดาบยาว ใบกว้างปลายแหลม ร่องกลาง กันโกร่งทอง หัวด้าม
	var sword := Node3D.new()
	sword.position = hand
	sword.rotation_degrees = Vector3(5.0, 0.0, -18.0)
	kid.add_child(sword)
	_part(sword, _box(Vector3(0.14, 1.02, 0.035)), Color(0.84, 0.87, 0.92), Vector3(0.0, 0.66, 0.0), Vector3.ONE, Vector3.ZERO, 0.25)
	_part(sword, _box(Vector3(0.035, 0.96, 0.05)), steel_dark, Vector3(0.0, 0.64, 0.0), Vector3.ONE, Vector3.ZERO, 0.25)
	var point := PrismMesh.new()
	point.size = Vector3(0.14, 0.18, 0.035)
	_part(sword, point, Color(0.84, 0.87, 0.92), Vector3(0.0, 1.26, 0.0), Vector3.ONE, Vector3.ZERO, 0.25)
	_part(sword, _box(Vector3(0.42, 0.07, 0.09)), gold, Vector3(0.0, 0.13, 0.0), Vector3.ONE, Vector3.ZERO, 0.35)
	_part(sword, _pill(0.035, 0.28), Color(0.28, 0.1, 0.1), Vector3(0.0, -0.02, 0.0))
	_part(sword, _ball(0.055), gold, Vector3(0.0, -0.17, 0.0), Vector3.ONE, Vector3.ZERO, 0.35)
	# หน้าเดิม
	var head := Vector3(0.0, 1.62, 0.0)
	_part(kid, _ball(0.52), SKIN, head, Vector3(1.0, 0.95, 0.96))
	for side in [-1.0, 1.0]:
		_part(kid, _ball(0.09), SKIN, head + Vector3(side * 0.52, -0.02, 0.0))
		_part(kid, _ball(0.082), EYE, head + Vector3(side * 0.19, 0.0, 0.45), Vector3(0.9, 1.25, 0.35), Vector3.ZERO, 0.2)
		_part(kid, _ball(0.024), Color.WHITE, head + Vector3(side * 0.19 + 0.025, 0.045, 0.485), Vector3.ONE, Vector3.ZERO, 0.2)
	_part(kid, _ball(0.026), Color(0.96, 0.72, 0.58), head + Vector3(0.0, -0.09, 0.492))
	for i in 11:
		var u := float(i) / 5.0 - 1.0
		var mx := u * 0.08
		var my := -0.18 - 0.018 * (1.0 - u * u)
		var mz := 0.4992 * sqrt(maxf(1.0 - mx * mx / 0.2704 - my * my / 0.244, 0.0))
		_part(kid, _ball(0.0135), MOUTH, head + Vector3(mx, my, mz))
	# ผมปัดเฉียงเล็กน้อย ด้านหลังยาวถึงท้ายทอย
	var hair := MeshInstance3D.new()
	hair.mesh = _hair_mesh("knight")
	var hair_mat := StandardMaterial3D.new()
	hair_mat.vertex_color_use_as_albedo = true
	hair_mat.roughness = 0.55
	hair_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	hair.material_override = hair_mat
	hair.position = head
	kid.add_child(hair)
	return kid

func _initialize():
	get_root().mouse_passthrough = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, true)
	_run.call_deferred()

func _run():
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.72, 0.85, 0.93)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(1.0, 0.97, 0.92)
	env.ambient_light_energy = 0.55
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	root.add_child(world_env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48.0, 28.0, 0.0)
	sun.light_energy = 0.8
	sun.shadow_enabled = false
	root.add_child(sun)
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(30.0, 30.0)
	_part_floor(floor_mesh)
	_kid(25.0, -4.5)
	_knight(0.0, -1.5)
	_knight(35.0, 1.3)
	_knight(180.0, 4.2)
	var cam := Camera3D.new()
	cam.position = Vector3(0.0, 1.45, 9.2)
	cam.rotation_degrees.x = -4.0
	cam.fov = 38.0
	root.add_child(cam)
	cam.make_current()
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUT)
	print("TOTAL_FAILS=0")
	quit()

func _part_floor(mesh: PlaneMesh) -> void:
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.material_override = _mat(Color(0.62, 0.74, 0.56), 1.0)
	root.add_child(node)
