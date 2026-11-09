class_name OutfitCitrus
## ชุดของ CAT CITRUS (หอก แมวส้มลายเสือ) แต่ละสาย ขั้นสองดูอลังกว่าขั้นแรก ยังเห็นขนส้ม
## พิกัดบนตัวแมว: y คือความสูงตามรูปตัด รัศมีตาม _profile_at  z บวกคือด้านหน้า (พุงขาว)

static var _m: ChibiModel

static func build(m: ChibiModel, body: MeshInstance3D, _foot_mesh: Mesh) -> void:
	_m = m
	match m.style:
		"cat_spear_tiger":
			_tiger(m, body, false)
		"cat_spear_prowler":
			_tiger(m, body, true)
		"cat_spear_fang":
			_wolf(m, body, false)
		"cat_spear_lupine":
			_wolf(m, body, true)
		"cat_spear_vixen":
			_fox(m, body, false)
		"cat_spear_phantom":
			_fox(m, body, true)
		"cat_spear_shell":
			_turtle(m, body, false)
		"cat_spear_genbu":
			_turtle(m, body, true)
	_m = null

static func _prof(t: float) -> Vector2:
	return _m._profile_at(ChibiModel.CAT_PROFILE, t)

## จุดบนผิวตัวที่ความสูง t มุม ang (0 คือด้านหน้า) ยื่นออกจากผิว out
static func _skin(t: float, ang: float, out := 1.06) -> Vector3:
	var p := _prof(t)
	return Vector3(sin(ang) * p.y * out, p.x, cos(ang) * p.y * out * ChibiModel.CAT_DEPTH)

## ผ้าหรือเกราะทรงกระบอกห่อตัวตั้งแต่ t0 ถึง t1 พองจากผิว out เท่า
static func _shell(m: ChibiModel, body: Node3D, t0: float, t1: float, out: float, mat: Material, flare := 0.0) -> void:
	var pts := []
	for i in 10:
		var k := float(i) / 9.0
		var p := _prof(lerpf(t0, t1, k))
		pts.append(Vector2(p.x, p.y * (out + flare * (1.0 - k)) + 0.01))
	m._part(body, m._lathe(pts, ChibiModel.CAT_DEPTH, 0.0, false), mat, Vector3.ZERO)

static func _ring(m: ChibiModel, body: Node3D, t: float, r: float, mat: Material, count: int, out := 1.06, squash := Vector3.ONE) -> void:
	for i in count:
		var ang := TAU * float(i) / float(count)
		m._part(body, m._ball(r), mat, _skin(t, ang, out), squash)

# ---------------------------------------------------------------- เสือ
## ผ้าหนังเสือพาดไหล่ ลายทางส้มดำ หางเสือห้อยที่สะโพก  ขั้นสองมีผ้าคลุมไหล่สองข้างกับหัวเสือกลัดอก
static func _tiger(m: ChibiModel, body: Node3D, grand: bool) -> void:
	var pelt := m._mat(Color(1.0, 0.8, 0.4), 0.9, 0.2)
	var stripe := m._mat(Color(0.25, 0.16, 0.12), 0.8, 0.2)
	var cream := m._mat(Color(1.0, 0.95, 0.84), 0.9, 0.2)
	# ผ้าพาดเฉียงจากไหล่ลงสะโพกฝั่งตรงข้าม ด้านหน้าและหลัง
	for i in 22:
		var k := float(i) / 21.0
		var t := lerpf(0.62, 0.18, k)
		var ang := lerpf(0.9, -0.9, k)
		var mat: Material = stripe if (i / 2) % 3 == 1 else pelt
		m._part(body, m._ball(0.1), mat, _skin(t, ang, 1.12), Vector3(1.0, 0.8, 0.6))
		m._part(body, m._ball(0.1), mat, _skin(t, PI - ang, 1.12), Vector3(1.0, 0.8, 0.6))
	# หางเสือห้อยจากสะโพก ลายทาง ปลายครีม
	var hip := _skin(0.18, -PI * 0.5, 1.16)
	for i in 6:
		var k := float(i) / 5.0
		var mat: Material = cream if i == 5 else (stripe if i % 2 == 1 else pelt)
		m._part(body, m._ball(0.06 - 0.01 * k), mat, hip + Vector3(-0.04 * k, -0.07 * float(i), 0.02 * sin(k * PI)))
	if not grand:
		return
	# ผ้าคลุมไหล่หนังเสือสองข้าง ฟูๆ ลายทาง
	for side in [-1.0, 1.0]:
		for i in 5:
			var ang: float = side * (PI * 0.5 + (float(i) - 2.0) * 0.32)
			m._part(body, m._ball(0.14), stripe if i % 2 == 1 else pelt, _skin(0.6, ang, 1.1), Vector3(1.0, 0.65, 0.9))
	# หัวเสือกลัดอก หูกลม ลายบนหัว
	var chest := _skin(0.5, 0.0, 1.0) + Vector3(0.0, 0.0, 0.1)
	m._part(body, m._ball(0.09), pelt, chest, Vector3(1.0, 0.9, 0.5))
	for side in [-1.0, 1.0]:
		m._part(body, m._ball(0.035), pelt, chest + Vector3(side * 0.065, 0.07, 0.0))
		m._part(body, m._ball(0.012), stripe, chest + Vector3(side * 0.03, 0.01, 0.045))
	m._part(body, m._ball(0.02), stripe, chest + Vector3(0.0, 0.06, 0.035), Vector3(1.6, 0.5, 0.5))
	m._part(body, m._ball(0.03), cream, chest + Vector3(0.0, -0.03, 0.04), Vector3(1.3, 0.8, 0.6))

# ---------------------------------------------------------------- หมาป่า
## ปลอกคอขนหมาป่าฟูรอบคอ จี้พระจันทร์เสี้ยวกลางอก  ขั้นสองขนฟูสองชั้น ผ้าคลุมขนลงหลัง จันทร์ใหญ่เรืองแสง
static func _wolf(m: ChibiModel, body: Node3D, grand: bool) -> void:
	var fur := m._mat(Color(0.74, 0.76, 0.82), 1.0, 0.15)
	var fur_dark := m._mat(Color(0.52, 0.54, 0.62), 1.0, 0.15)
	var moon := m._glow(Color(1.0, 0.92, 0.55), 0.6 if grand else 0.3)
	_ring(m, body, 0.62, 0.09, fur, 20, 1.1)
	if grand:
		_ring(m, body, 0.55, 0.1, fur_dark, 20, 1.13)
		# ผ้าคลุมขนยาวด้านหลัง แผ่ลงเป็นแฉกมน
		for i in 5:
			var ang := PI + (float(i) - 2.0) * 0.38
			for j in 3:
				var t := 0.52 - 0.13 * float(j)
				m._part(body, m._ball(0.1 - 0.015 * float(j)), fur if (i + j) % 2 == 0 else fur_dark, _skin(t, ang, 1.12), Vector3(1.0, 1.1, 0.55))
	# จี้พระจันทร์เสี้ยว ห้อยด้วยเชือกเส้นบาง
	var c := _skin(0.47, 0.0, 1.0) + Vector3(0.0, 0.0, 0.12)
	var crescent := PackedVector2Array()
	var rr := 0.075 if grand else 0.055
	for i in 13:
		var a := lerpf(-2.4, 2.4, float(i) / 12.0)
		crescent.append(Vector2(sin(a), cos(a)) * rr)
	for i in 13:
		var a := lerpf(2.0, -2.0, float(i) / 12.0)
		crescent.append(Vector2(sin(a) * 0.8 + 0.25, cos(a) * 0.8) * rr)
	var pendant := m._part(body, m._flat(crescent, 0.02), moon, c)
	pendant.rotation_degrees = Vector3(0.0, 0.0, 90.0)
	var cord := m._mat(Color(0.35, 0.28, 0.25), 0.8, 0.2)
	for side in [-1.0, 1.0]:
		var to := _skin(0.6, side * 0.45, 1.04)
		for k in 3:
			m._part(body, m._ball(0.012), cord, c.lerp(to, 0.25 + 0.25 * float(k)))

# ---------------------------------------------------------------- จิ้งจอก
## ฮาโอริขาวขอบแดงแบบมิโกะ เปิดด้านหน้าเห็นพุง พู่ห้อย ปิ่นดอกไม้  ขั้นสองมีกระโปรงฮากามะแดง แขนเสื้อพอง กระดิ่งทอง
static func _fox(m: ChibiModel, body: Node3D, grand: bool) -> void:
	var white := m._mat(Color(0.99, 0.98, 0.96), 0.9, 0.15)
	var red := m._mat(Color(0.9, 0.25, 0.3), 0.7, 0.25)
	var gold := m._mat(Color(1.0, 0.82, 0.35), 0.35, 0.8)
	# ตัวเสื้อขาวห่อตัว ขอบแดงบนล่าง ปกเสื้อแดงไขว้ด้านหน้า
	_shell(m, body, 0.22, 0.6, 1.1, white)
	for t in [0.22, 0.6]:
		var q := _prof(t)
		m._part(body, m._rod(q.y * 1.13, 0.035, 36), red, Vector3(0.0, q.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))
	for i in 12:
		var k := float(i) / 11.0
		for side in [-1.0, 1.0]:
			m._part(body, m._ball(0.042), red, _skin(lerpf(0.6, 0.3, k), side * lerpf(0.55, 0.0, k), 1.16))
	# พู่ห้อยสองข้างหน้าอก
	for side in [-1.0, 1.0]:
		var top := _skin(0.5, side * 0.8, 1.16)
		for k in 3:
			m._part(body, m._ball(0.025), red, top + Vector3(0.0, -0.045 * float(k), 0.01))
		m._part(body, m._ball(0.03), gold, top + Vector3(0.0, -0.15, 0.01))
	# ปิ่นปักผมดอกไม้ข้างหู
	var head := _skin(0.86, 0.75, 1.0)
	var pin := m._part(body, m._rod(0.012, 0.22, 8), gold, head + Vector3(0.0, 0.02, -0.02))
	pin.rotation_degrees = Vector3(0.0, 0.0, 60.0)
	var petal := m._mat(Color(1.0, 0.72, 0.82), 0.7, 0.2)
	for k in 5:
		var a := TAU * float(k) / 5.0
		m._part(body, m._ball(0.03), petal, head + Vector3(cos(a) * 0.035, 0.06 + sin(a) * 0.035, 0.03))
	m._part(body, m._ball(0.02), gold, head + Vector3(0.0, 0.06, 0.045))
	if not grand:
		return
	# กระโปรงฮากามะแดงบานรอบเอว
	_shell(m, body, 0.02, 0.22, 1.12, red, 0.12)
	# แขนเสื้อพองที่ไหล่
	for side in [-1.0, 1.0]:
		m._part(body, m._ball(0.14), white, _skin(0.55, side * PI * 0.5, 1.12), Vector3(0.9, 1.1, 1.0))
		m._part(body, m._ball(0.05), red, _skin(0.45, side * PI * 0.5, 1.22))
	# กระดิ่งทองใหญ่ห้อยเอว
	var bell := _skin(0.26, 0.9, 1.2)
	m._part(body, m._ball(0.05), gold, bell)
	m._part(body, m._ball(0.015), m._mat(Color(0.3, 0.2, 0.1), 0.6, 0.3), bell + Vector3(0.0, -0.025, 0.035))

# ---------------------------------------------------------------- เต่า
## กระดองเต่าแบกหลัง ลายแผ่นกลม เข็มขัดเชือกผูกปม  ขั้นสองกระดองใหญ่ขอบทอง ปุ่มมน เกราะไหล่กระดอง งูเขียวพันเอว
static func _turtle(m: ChibiModel, body: Node3D, grand: bool) -> void:
	var shell := m._mat(Color(0.42, 0.62, 0.38), 0.6, 0.35)
	var plate := m._mat(Color(0.58, 0.76, 0.48), 0.6, 0.35)
	var rope := m._mat(Color(0.72, 0.55, 0.35), 0.9, 0.15)
	var gold := m._mat(Color(1.0, 0.82, 0.35), 0.35, 0.8)
	var k := 1.25 if grand else 1.0
	# กระดองโค้งแนบหลัง
	var back := _skin(0.38, PI, 1.0) + Vector3(0.0, 0.0, -0.1)
	m._part(body, m._ball(0.34 * k), shell, back, Vector3(1.0, 1.05, 0.42))
	# ลายแผ่นกลมบนกระดอง
	m._part(body, m._ball(0.09 * k), plate, back + Vector3(0.0, 0.0, -0.13 * k), Vector3(1.0, 1.0, 0.35))
	for i in 6:
		var a := TAU * float(i) / 6.0
		m._part(body, m._ball(0.065 * k), plate, back + Vector3(cos(a) * 0.19 * k, sin(a) * 0.2 * k, -0.11 * k), Vector3(1.0, 1.0, 0.35))
	# เข็มขัดเชือกผูกปมด้านหน้า
	var belt := _prof(0.22)
	m._part(body, m._rod(belt.y * 1.14, 0.05, 32), rope, Vector3(0.0, belt.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))
	var knot := _skin(0.22, 0.25, 1.17)
	m._part(body, m._ball(0.045), rope, knot)
	for side in [-1.0, 1.0]:
		m._part(body, m._ball(0.028), rope, knot + Vector3(side * 0.03, -0.06, 0.0))
	if not grand:
		return
	# ขอบทองรอบกระดองกับปุ่มมน
	for i in 14:
		var a := TAU * float(i) / 14.0
		m._part(body, m._ball(0.035), gold, back + Vector3(cos(a) * 0.4, sin(a) * 0.42, -0.02))
	for i in 3:
		m._part(body, m._ball(0.04), gold, back + Vector3(0.0, (float(i) - 1.0) * 0.16, -0.17))
	# เกราะไหล่ทรงกระดองเล็ก
	for side in [-1.0, 1.0]:
		var sh := _skin(0.58, side * PI * 0.5, 1.1)
		m._part(body, m._ball(0.13), shell, sh, Vector3(1.0, 0.6, 1.0))
		m._part(body, m._ball(0.06), plate, sh + Vector3(side * 0.06, 0.05, 0.0), Vector3(1.0, 0.5, 1.0))
	# งูเขียวพันเอว หัวกลมตาแป๋ว
	var snake := m._mat(Color(0.45, 0.78, 0.45), 0.8, 0.2)
	var head := _skin(0.26, -0.35, 1.2)
	m._part(body, m._ball(0.045), snake, head, Vector3(1.0, 0.85, 1.1))
	var eye := m._mat(Color(0.06, 0.06, 0.07), 0.3, 0.5)
	for side in [-1.0, 1.0]:
		m._part(body, m._ball(0.01), eye, head + Vector3(side * 0.02, 0.012, 0.04))
