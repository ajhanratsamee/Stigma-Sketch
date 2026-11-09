class_name OutfitPair
## ชุดของ CAT AZURE (ผู้หญิง) กับ CAT LAPIS (ผู้ชาย) ตามคลาส
## สไตล์ต่อท้ายด้วย ~ เช่น cat_azure~dreamer  (BASIC กับร่างปีศาจไม่ใส่ชุด)
## dreamer / somna : ชุดนอนลายจุด ตราพระจันทร์ ปกระบาย หมอนผ้าคลุมหลัง (ไม่ใส่หมวก หูยังโผล่)
## fiend / neon     : แจ็กเก็ตพังก์สั้น ขอบนีออน ผ้าพันคอปลายยาว

static var _m: ChibiModel

static func build(m: ChibiModel, body: MeshInstance3D, _foot_mesh: Mesh) -> void:
	var st := m.style
	if not st.contains("~"):
		return
	_m = m
	var kind := st.get_slice("~", 1)
	var girl := st.begins_with("cat_azure")
	match kind:
		"dreamer":
			_pajama(m, body, girl, false)
		"somna":
			_pajama(m, body, girl, true)
		"fiend":
			_punk(m, body, girl, false)
		"neon":
			_punk(m, body, girl, true)
	_m = null

static func _p(t: float) -> Vector2:
	return _m._profile_at(ChibiModel.CAT_PROFILE, t)

static func _top() -> float:
	return (ChibiModel.CAT_PROFILE[ChibiModel.CAT_PROFILE.size() - 1] as Vector2).x

## เปลือกผ้ารอบตัวจากช่วงความสูง t0 ถึง t1 พองออกจากผิวนิดหน่อย
static func _shell(m: ChibiModel, body: MeshInstance3D, t0: float, t1: float, puff: float, mat: Material) -> void:
	var pts := []
	for i in 10:
		var t := lerpf(t0, t1, float(i) / 9.0)
		var p := _p(t)
		pts.append(Vector2(p.x, p.y * puff + 0.012))
	m._part(body, m._lathe(pts, ChibiModel.CAT_DEPTH, 0.0, false), mat, Vector3.ZERO)

## วงรอบตัวที่ความสูง t (ขอบเสื้อ ปกเสื้อ)
static func _ring(m: ChibiModel, body: MeshInstance3D, t: float, puff: float, thick: float, mat: Material) -> void:
	var p := _p(t)
	m._part(body, m._rod(p.y * puff, thick, 40), mat, Vector3(0.0, p.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))

## จุดบนผิวที่ความสูง t มุม ang (0 คือกลางอก)
static func _front(t: float, ang: float, puff: float) -> Vector3:
	var p := _p(t)
	var r := p.y * puff
	return Vector3(sin(ang) * r, p.x, cos(ang) * r * ChibiModel.CAT_DEPTH)

## ชุดนอนลายจุด  deep = SOMNAMBULIST สีกลางคืนเข้มขึ้น หมอนใหญ่ขึ้น มีปลายหมวกนอนห้อยหลังคอ
static func _pajama(m: ChibiModel, body: MeshInstance3D, girl: bool, deep: bool) -> void:
	var cloth_c: Color
	if deep:
		cloth_c = Color(0.62, 0.55, 0.9) if girl else Color(0.36, 0.45, 0.78)
	else:
		cloth_c = Color(1.0, 0.78, 0.88) if girl else Color(0.68, 0.8, 0.98)
	var cloth := m._mat(cloth_c, 0.9, 0.15)
	var dot := m._mat(Color(1.0, 1.0, 1.0), 0.8, 0.2)
	var moon := m._mat(Color(1.0, 0.9, 0.45), 0.5, 0.4)
	var frill := m._mat(Color(1.0, 0.98, 0.95), 0.9, 0.1)
	# เสื้อชุดนอน ตั้งแต่สะโพกถึงอก
	_shell(m, body, 0.08, 0.56, 1.06, cloth)
	_ring(m, body, 0.09, 1.09, 0.05, frill)
	# ลายจุดกลมรอบตัว
	for row in 3:
		var t := 0.18 + float(row) * 0.13
		for k in 8:
			var ang := TAU * (float(k) + 0.5 * float(row % 2)) / 8.0
			m._part(body, m._ball(0.032), dot, _front(t, ang, 1.08), Vector3(1.0, 1.0, 0.5))
	# ปกระบายกลมๆ รอบคอ
	var neck := _p(0.57)
	for k in 12:
		var ang := TAU * float(k) / 12.0
		m._part(body, m._ball(0.06), frill, Vector3(sin(ang) * neck.y * 1.06, neck.x, cos(ang) * neck.y * 1.06 * ChibiModel.CAT_DEPTH), Vector3(1.0, 0.7, 1.0))
	# ตราพระจันทร์เสี้ยวกลางอก (วงกลมสองวงซ้อนเยื้อง)
	var c := _front(0.4, 0.0, 1.09)
	m._part(body, m._ball(0.075), moon, c, Vector3(1.0, 1.0, 0.35))
	m._part(body, m._ball(0.062), cloth, c + Vector3(0.035, 0.025, 0.012), Vector3(1.0, 1.0, 0.35))
	if girl:
		# โบว์ที่ปกเสื้อ
		var bow_c := m._mat(Color(0.98, 0.5, 0.7) if not deep else Color(0.85, 0.45, 0.95), 0.7, 0.3)
		var b := _front(0.555, 0.0, 1.12)
		for side in [-1.0, 1.0]:
			m._part(body, m._ball(0.055), bow_c, b + Vector3(side * 0.06, 0.0, 0.0), Vector3(1.2, 0.8, 0.5))
		m._part(body, m._ball(0.03), bow_c, b + Vector3(0.0, 0.0, 0.02))
	else:
		# กระดุมกลมสามเม็ดเรียงลงมา
		for k in 3:
			m._part(body, m._ball(0.025), dot, _front(0.16 + float(k) * 0.08, 0.0, 1.09), Vector3(1.0, 1.0, 0.5))
	# หมอนผ้าคลุมหลัง นุ่มกลม มีพู่สี่มุม
	var top := _top()
	var pillow_c := m._mat(Color(1.0, 0.97, 0.88) if not deep else Color(0.92, 0.9, 1.0), 0.95, 0.1)
	var sz := 1.25 if deep else 1.0
	var back_z := -_p(0.38).y * ChibiModel.CAT_DEPTH * 1.08 - 0.07
	var pillow := m._part(body, m._ball(0.24 * sz), pillow_c, Vector3(0.0, top * 0.38, back_z), Vector3(1.25, 1.0, 0.38))
	pillow.rotation_degrees = Vector3(-8.0, 0.0, 0.0)
	for sx in [-1.0, 1.0]:
		for sy in [-1.0, 1.0]:
			m._part(body, m._ball(0.04 * sz), moon if deep else dot, Vector3(sx * 0.27 * sz, top * 0.38 + sy * 0.2 * sz, back_z - 0.01))
	m._part(body, m._ball(0.06 * sz), moon, Vector3(0.0, top * 0.38, back_z - 0.08), Vector3(1.0, 1.0, 0.4))
	if deep:
		# ปลายหมวกนอนห้อยจากหลังคอ ปลายมีปอมปอม (ไม่ครอบหัว หูยังโผล่)
		var tail := m._group(body)
		tail.position = Vector3(0.0, _p(0.6).x, -_p(0.6).y * ChibiModel.CAT_DEPTH * 0.9)
		tail.rotation_degrees = Vector3(150.0, 0.0, 0.0)
		m._part(tail, m._cone(0.1, 0.36), cloth, Vector3(0.0, 0.18, 0.0), Vector3(1.0, 1.0, 0.8))
		m._part(tail, m._ball(0.06), dot, Vector3(0.0, 0.37, 0.0))

## แจ็กเก็ตพังก์สั้น ขอบนีออน ผ้าพันคอ  bright = NEON BOLT ขอบเรืองแสง เกราะไหล่กลม ผ้าพันคอยาวขึ้น
static func _punk(m: ChibiModel, body: MeshInstance3D, girl: bool, bright: bool) -> void:
	var neon_c := Color(1.0, 0.45, 0.8) if girl else Color(0.35, 1.0, 0.75)
	if bright:
		neon_c = Color(0.45, 0.95, 1.0) if girl else Color(0.75, 1.0, 0.35)
	var jacket := m._mat(Color(0.22, 0.23, 0.32) if not bright else Color(0.16, 0.2, 0.36), 0.6, 0.35)
	var neon := m._glow(neon_c, 1.2 if bright else 0.6)
	var scarf_m := m._mat(neon_c.lerp(Color.WHITE, 0.25), 0.8, 0.2)
	# แจ็กเก็ตสั้นแค่อก เห็นพุงขาวกับขน
	_shell(m, body, 0.3, 0.6, 1.08, jacket)
	_ring(m, body, 0.31, 1.1, 0.045, neon)
	_ring(m, body, 0.6, 1.1, 0.04, neon)
	# สายฟ้าแบบกลมมน: เม็ดเรืองเรียงซิกแซกที่อก
	var zig := [Vector2(-0.05, 0.53), Vector2(0.02, 0.48), Vector2(-0.03, 0.44), Vector2(0.05, 0.39)]
	for z in zig:
		var at := _front(float(z.y), float(z.x) * 3.0, 1.11)
		m._part(body, m._ball(0.035), neon, at, Vector3(1.0, 1.0, 0.5))
	# ปกตั้ง
	var neck := _p(0.6)
	for side in [-1.0, 1.0]:
		var col := m._part(body, m._ball(0.1), jacket, Vector3(side * neck.y * 0.7, neck.x + 0.03, neck.y * 0.55 * ChibiModel.CAT_DEPTH), Vector3(0.6, 1.0, 0.4))
		col.rotation_degrees = Vector3(0.0, 0.0, -side * 25.0)
	# ผ้าพันคอรอบคอ ปลายสองเส้นปลิวไปด้านหลัง
	_ring(m, body, 0.63, 1.04, 0.08, scarf_m)
	var tails := 7 if bright else 5
	for side in [-1.0, 1.0]:
		for k in tails:
			var f := float(k) / float(tails - 1)
			var at := Vector3(side * (0.12 + f * 0.08), neck.x - f * 0.28, -neck.y * ChibiModel.CAT_DEPTH - 0.05 - f * 0.22)
			m._part(body, m._ball(0.055 * (1.0 - f * 0.35)), neon if k == tails - 1 else scarf_m, at)
	if bright:
		# เกราะไหล่กลมขอบนีออน
		var r := _p(ChibiModel.PAULDRON_AT).y
		var top := _top()
		for side in [-1.0, 1.0]:
			m._part(body, m._ball(0.15), jacket, Vector3(side * r * 1.05, top * (ChibiModel.PAULDRON_AT - 0.02), 0.0), Vector3(1.0, 0.6, 1.0))
			m._part(body, m._rod(0.15, 0.025, 24), neon, Vector3(side * r * 1.05, top * (ChibiModel.PAULDRON_AT - 0.05), 0.0))
	if girl:
		# หมุดกลมเรืองสองเม็ดที่ไหล่เสื้อ
		for side in [-1.0, 1.0]:
			m._part(body, m._ball(0.03), neon, _front(0.56, side * 0.7, 1.1))
	else:
		# ซิปกลางเสื้อเป็นเม็ดเล็กเรียงลง
		for k in 4:
			m._part(body, m._ball(0.018), neon, _front(0.33 + float(k) * 0.065, 0.0, 1.1))
