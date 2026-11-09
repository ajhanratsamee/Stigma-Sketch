class_name OutfitAsh
## ชุดของ CAT ASH แต่ละคลาส ทุกชิ้นติดกับตัว มือ เท้า เลยขยับตามท่า ขนเทายังเห็นบางส่วน
## รูปตัดตัวแมว: _profile_at(t) คืน Vector2(ความสูง, รัศมี) หน้าตัวคือแกน z บวก

static func build(m: ChibiModel, body: MeshInstance3D, foot_mesh: Mesh) -> void:
	var kind := m.style.trim_prefix("cat_fist").trim_prefix("_")
	match kind:
		"heavy":
			_heavy(m, body)
		"sumo":
			_sumo(m, body)
		"zephyr":
			_zephyr(m, body)
		"kungfu":
			_kungfu(m, body)
		"muay":
			_muay(m, body, false)
		"muaythai":
			_muay(m, body, true)
		"systema":
			_systema(m, body)
		"sambo":
			_sambo(m, body, foot_mesh)

static func _mat(m: ChibiModel, c: Color, rough := 0.75) -> StandardMaterial3D:
	return m._mat(c, rough, 0.2)

## ผ้าพันรอบตัวช่วง t0-t1 ของความสูงตัว ยื่นออกจากผิว puff เท่า
static func _band(m: ChibiModel, body: MeshInstance3D, t0: float, t1: float, puff: float, mat: Material) -> void:
	var pts := []
	for i in 10:
		var t := lerpf(t0, t1, float(i) / 9.0)
		var p := m._profile_at(ChibiModel.CAT_PROFILE, t)
		pts.append(Vector2(p.x, p.y * puff + 0.012))
	m._part(body, m._lathe(pts, ChibiModel.CAT_DEPTH, 0.0, false), mat, Vector3.ZERO)

## วงขอบรอบตัวที่ความสูง t หนา thick
static func _ring(m: ChibiModel, body: MeshInstance3D, t: float, k: float, thick: float, mat: Material) -> void:
	# ห่วงท่อกลมรอบตัว ไม่ใช่แผ่นแบน มองจากมุมบนจะไม่เป็นจาน
	var p := m._profile_at(ChibiModel.CAT_PROFILE, t)
	var ring := TorusMesh.new()
	var r := p.y * (1.0 + (k - 1.0) * 0.5)
	ring.inner_radius = r - thick * 0.5
	ring.outer_radius = r + thick * 0.5
	ring.rings = 40
	ring.ring_segments = 10
	m._part(body, ring, mat, Vector3(0.0, p.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))

## จุดหน้าตัว / หลังตัว ที่ความสูง t
static func _front(m: ChibiModel, t: float, k := 1.1) -> Vector3:
	var p := m._profile_at(ChibiModel.CAT_PROFILE, t)
	return Vector3(0.0, p.x, p.y * ChibiModel.CAT_DEPTH * k + 0.02)

static func _back(m: ChibiModel, t: float, k := 1.1) -> Vector3:
	var p := m._profile_at(ChibiModel.CAT_PROFILE, t)
	return Vector3(0.0, p.x, -p.y * ChibiModel.CAT_DEPTH * k - 0.02)

## ห่วงรอบหัว (มงคล)
static func _head_ring(m: ChibiModel, body: MeshInstance3D, mat: Material, thick: float) -> void:
	var hp := m._profile_at(ChibiModel.CAT_PROFILE, 0.8)
	var ring := TorusMesh.new()
	ring.inner_radius = hp.y * 1.02
	ring.outer_radius = hp.y * 1.02 + thick
	ring.rings = 40
	ring.ring_segments = 12
	m._part(body, ring, mat, Vector3(0.0, hp.x, 0.0), Vector3(1.0, 1.6, ChibiModel.CAT_DEPTH))

## ห่วงที่ข้อมือ
static func _wrist(m: ChibiModel, mat: Material, k: float, y := 0.75) -> void:
	for hand in [m._sword, m._off_hand]:
		var ring := TorusMesh.new()
		ring.inner_radius = ChibiModel.CAT_HAND_R * 0.9 * k
		ring.outer_radius = ChibiModel.CAT_HAND_R * 1.12 * k
		ring.rings = 24
		ring.ring_segments = 10
		m._part(hand, ring, mat, Vector3(0.0, -ChibiModel.CAT_HAND_R * y, 0.0))

## HEAVYWEIGHT กางเกงมวยสากลขอบทอง นวมกลมใหญ่ที่มือ
static func _heavy(m: ChibiModel, body: MeshInstance3D) -> void:
	var shorts := _mat(m, Color(0.45, 0.4, 0.62))
	var gold := m._mat(Color(0.98, 0.82, 0.35), 0.35, 0.8)
	_band(m, body, 0.07, 0.3, 1.08, shorts)
	_ring(m, body, 0.3, 1.11, 0.06, gold)
	var glove := _mat(m, Color(0.88, 0.25, 0.28), 0.45)
	var cuff := _mat(m, Color(0.98, 0.97, 0.95))
	for hand in [m._sword, m._off_hand]:
		m._part(hand, m._ball(ChibiModel.CAT_HAND_R * 1.6), glove, Vector3(0.0, 0.02, 0.0))
		m._part(hand, m._rod(ChibiModel.CAT_HAND_R * 1.15, 0.07, 20), cuff, Vector3(0.0, -ChibiModel.CAT_HAND_R * 1.15, 0.0))

## GRAND SUMO มาวาชิหนาพันสะโพก มองข้างก็เห็น ด้านหน้ามีพู่ห้อยเป็นแถว
static func _sumo(m: ChibiModel, body: MeshInstance3D) -> void:
	var cloth := _mat(m, Color(0.96, 0.88, 0.62))
	var dark := _mat(m, Color(0.82, 0.7, 0.45))
	_band(m, body, 0.08, 0.36, 1.12, cloth)
	_ring(m, body, 0.36, 1.15, 0.09, dark)
	_ring(m, body, 0.1, 1.14, 0.06, dark)
	# ปมผ้าด้านหลัง และพู่ห้อยด้านหน้า
	m._part(body, m._ball(0.11), dark, _back(m, 0.32, 1.16), Vector3(1.3, 1.0, 0.7))
	var f := _front(m, 0.32, 1.16)
	for i in 5:
		var x := (float(i) - 2.0) * 0.07
		m._part(body, m._ball(0.03), dark, f + Vector3(x, -0.06, 0.0), Vector3(1.0, 1.0, 0.8))
		m._part(body, m._pill(0.022, 0.16), cloth, f + Vector3(x, -0.18, 0.01))

## ZEPHYR เสื้อกั๊กบางสีฟ้า ผ้าคาดเอวมีริบบิ้นปลิวไปด้านหลัง
static func _zephyr(m: ChibiModel, body: MeshInstance3D) -> void:
	var vest := _mat(m, Color(0.62, 0.84, 0.95))
	var sash := _mat(m, Color(0.3, 0.55, 0.88))
	var trim := _mat(m, Color(0.97, 0.98, 1.0))
	_band(m, body, 0.3, 0.64, 1.06, vest)
	_ring(m, body, 0.64, 1.07, 0.04, trim)
	_band(m, body, 0.24, 0.32, 1.1, sash)
	var b := _back(m, 0.28, 1.12)
	m._part(body, m._ball(0.07), sash, b)
	for side in [-1.0, 1.0]:
		for k in 6:
			var u := float(k + 1) / 6.0
			m._part(body, m._ball(0.045 * (1.0 - u * 0.35)), sash, b + Vector3(side * (0.04 + u * 0.12), -u * 0.22 + sin(u * PI) * 0.06, -u * 0.2), Vector3(1.0, 0.6, 1.0))

## KUNG FU เสื้อชางซานแดง กระดุมปมสีทองเรียงหน้า คอตั้ง ผ้าคาดเอวดำ
static func _kungfu(m: ChibiModel, body: MeshInstance3D) -> void:
	var red := _mat(m, Color(0.86, 0.22, 0.24))
	var gold := m._mat(Color(0.98, 0.8, 0.32), 0.35, 0.8)
	var black := _mat(m, Color(0.16, 0.15, 0.18))
	_band(m, body, 0.2, 0.68, 1.06, red)
	_ring(m, body, 0.68, 1.08, 0.07, red)
	_ring(m, body, 0.69, 1.09, 0.02, gold)
	for i in 4:
		var t := 0.36 + 0.08 * float(i)
		var p := _front(m, t, 1.07)
		m._part(body, m._pill(0.018, 0.07), gold, p, Vector3.ONE, Vector3(0.0, 0.0, 90.0))
		m._part(body, m._ball(0.022), gold, p)
	_band(m, body, 0.2, 0.27, 1.1, black)
	var f := _front(m, 0.23, 1.12)
	m._part(body, m._ball(0.05), black, f + Vector3(0.1, 0.0, 0.0))
	m._part(body, m._pill(0.03, 0.14), black, f + Vector3(0.13, -0.12, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 12.0))

## WAR MUAY / MUAY THAI มงคลคาดหัว ประเจียดที่ข้อมือชัดๆ มีชายผ้าห้อย กางเกงมวยไทย
static func _muay(m: ChibiModel, body: MeshInstance3D, thai: bool) -> void:
	var main := _mat(m, Color(0.88, 0.22, 0.26) if thai else Color(0.3, 0.42, 0.86))
	var gold := m._mat(Color(0.98, 0.82, 0.32), 0.35, 0.8)
	var white := _mat(m, Color(0.98, 0.97, 0.95))
	var band_mat: Material = gold if thai else main
	# กางเกงมวยไทยขอบขาว (MUAY THAI ขอบทอง)
	_band(m, body, 0.07, 0.29, 1.08, main)
	_ring(m, body, 0.29, 1.11, 0.07, gold if thai else white)
	# มงคลรอบหัว มีหางผ้าด้านหลัง
	_head_ring(m, body, band_mat, 0.06 if thai else 0.05)
	var hb := _back(m, 0.8, 1.05)
	m._part(body, m._ball(0.06), band_mat, hb)
	m._part(body, m._pill(0.025, 0.2), band_mat, hb + Vector3(0.0, -0.12, -0.03), Vector3.ONE, Vector3(-20.0, 0.0, 0.0))
	# ประเจียดที่ข้อมือ ใหญ่จนเห็นชัด มีชายผ้าห้อย
	_wrist(m, main, 1.12, 0.1)
	for hand in [m._sword, m._off_hand]:
		m._part(hand, m._pill(0.02, 0.12), main, Vector3(0.05, -ChibiModel.CAT_HAND_R * 1.1, -0.03), Vector3.ONE, Vector3(0.0, 0.0, 20.0))
	if thai:
		# ผ้าพันมือสีขาว
		for k in 3:
			for hand in [m._sword, m._off_hand]:
				m._part(hand, m._rod(ChibiModel.CAT_HAND_R * (1.02 - float(k) * 0.05), 0.025, 18), white, Vector3(0.0, ChibiModel.CAT_HAND_R * (0.2 - float(k) * 0.3), 0.0))

## SYSTEMA GRAPPLER เสื้อยืดเข้ารูปสีเขียวทหาร เข็มขัดดำหัวทอง
static func _systema(m: ChibiModel, body: MeshInstance3D) -> void:
	var shirt := _mat(m, Color(0.42, 0.5, 0.4))
	var black := _mat(m, Color(0.15, 0.15, 0.17))
	var gold := m._mat(Color(0.95, 0.8, 0.35), 0.35, 0.8)
	_band(m, body, 0.26, 0.62, 1.05, shirt)
	_ring(m, body, 0.62, 1.06, 0.035, black)
	_band(m, body, 0.2, 0.27, 1.09, black)
	m._part(body, m._box(Vector3(0.12, 0.08, 0.03)), gold, _front(m, 0.235, 1.11))

## SAMBO เสื้อแซมโบสีแดงคอวี เข็มขัดผูกปม รองเท้ามวยปล้ำแดง
static func _sambo(m: ChibiModel, body: MeshInstance3D, foot_mesh: Mesh) -> void:
	var red := _mat(m, Color(0.85, 0.2, 0.22))
	var white := _mat(m, Color(0.98, 0.96, 0.94))
	_band(m, body, 0.18, 0.66, 1.07, red)
	# ปกเสื้อคอวีสีขาว
	for side in [-1.0, 1.0]:
		var p := _front(m, 0.58, 1.08)
		m._part(body, m._pill(0.03, 0.2), white, p + Vector3(side * 0.06, -0.02, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -side * 28.0))
	_band(m, body, 0.2, 0.26, 1.11, red)
	_ring(m, body, 0.23, 1.13, 0.025, white)
	var f := _front(m, 0.23, 1.14)
	m._part(body, m._ball(0.05), red, f)
	for side in [-1.0, 1.0]:
		m._part(body, m._pill(0.026, 0.13), red, f + Vector3(side * 0.04, -0.1, 0.0), Vector3.ONE, Vector3(0.0, 0.0, side * 15.0))
	# รองเท้ามวยปล้ำหุ้มเท้า
	for leg in m._legs:
		var foot: Node3D = leg[3]
		m._part(foot, foot_mesh, red, Vector3(0.0, -0.05, 0.04), Vector3(1.1, 0.75, 1.3))
		m._part(foot, m._rod(0.12, 0.03, 20), white, Vector3(0.0, 0.03, 0.0), Vector3(1.0, 1.0, 1.15))
