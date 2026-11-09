class_name OutfitBoys
## ชุดของ CAT BOYS แต่ละคลาส (อัศวินทั้ง 8 สาย) ไม่มีหมวก
## ชุดเป็นแค่บางส่วน (เกราะอก ผ้าคาด ผ้าคลุม เกราะไหล่ ถุงมือ) ยังเห็นขนแมวสีแดง
## ทุกชิ้นติดกับตัวแมว (body) มือ (m._sword m._off_hand) จึงขยับตามท่า

const STEEL := Color(0.72, 0.75, 0.82)
const STEEL_DARK := Color(0.32, 0.33, 0.4)
const GOLD := Color(0.95, 0.76, 0.32)

static func build(m: ChibiModel, body: MeshInstance3D, _foot_mesh: Mesh) -> void:
	match m.style:
		"cat_knight":
			# SWORD KNIGHT เกราะอกเหล็กอ่อน ผ้าคาดหน้าสีแดงตราอุ้งเท้าทอง
			var steel := _metal(m, STEEL)
			_breast(m, body, steel, _metal(m, GOLD))
			_tabard(m, body, m._mat(Color(0.86, 0.2, 0.26), 0.8, 0.2), m._mat(GOLD, 0.4, 0.6))
			_belt(m, body, m._mat(Color(0.45, 0.3, 0.2), 0.7, 0.3), m._mat(GOLD, 0.4, 0.6))
		"cat_grand", "cat_grand_armor":
			# GRAND KNIGHT ใช้เกราะเหล็กที่สร้างไว้แล้ว เพิ่มผ้าคลุมสั้นสีแดงด้านหลัง
			_cape(m, body, m._mat(Color(0.82, 0.16, 0.22), 0.8, 0.2), m._mat(GOLD, 0.4, 0.6), 0.8, false)
		"cat_magic":
			# MAGIC KNIGHT เกราะเหล็ก ผ้าคลุมน้ำเงินมีวงเวทเรืองแสง
			var steel := _metal(m, STEEL)
			var sky := m._mat(Color(0.45, 0.65, 1.0), 0.4, 0.5)
			_breast(m, body, steel, sky)
			_pauldrons(m, body, steel, sky, 1.0)
			var cape := _cape(m, body, m._mat(Color(0.25, 0.42, 0.9), 0.8, 0.2), m._mat(Color(0.65, 0.8, 1.0), 0.5, 0.4), 1.0, false)
			_runes(m, cape, m._glow(Color(0.6, 0.85, 1.0), 1.2))
			_gloves(m, steel, sky)
		"cat_flame":
			# FLAME KNIGHT เกราะขอบถ่านไฟ ผ้าคาดเฉียงลายเปลวไฟ
			var steel := _metal(m, Color(0.6, 0.55, 0.55))
			var ember := m._glow(Color(1.0, 0.55, 0.2), 0.9)
			_breast(m, body, steel, ember)
			_pauldrons(m, body, steel, ember, 1.0)
			_sash(m, body, m._mat(Color(0.95, 0.35, 0.15), 0.7, 0.3), m._glow(Color(1.0, 0.85, 0.35), 1.0))
			_gloves(m, steel, ember)
		"cat_shield":
			# SHIELD KNIGHT เกราะไหล่หนากลมใหญ่ ผ้าคาดหน้าทหารรักษาป้อม (น้ำเงินขอบทอง) ไม่มีผ้าคลุมเพราะสะพายโล่
			var steel := _metal(m, STEEL)
			var gold := _metal(m, GOLD)
			_pauldrons(m, body, steel, gold, 1.45)
			_tabard(m, body, m._mat(Color(0.22, 0.3, 0.6), 0.8, 0.2), m._mat(GOLD, 0.4, 0.6))
			_belt(m, body, m._mat(Color(0.3, 0.25, 0.22), 0.7, 0.3), gold)
			_gloves(m, steel, gold)
		"cat_guardian":
			# GUARDIAN KNIGHT เกราะพาลาดินขอบทอง ผ้าคลุมขาวขอบทอง
			var steel := _metal(m, Color(0.88, 0.9, 0.95))
			var gold := _metal(m, GOLD)
			_breast(m, body, steel, gold)
			_pauldrons(m, body, steel, gold, 1.15)
			_cape(m, body, m._mat(Color(0.97, 0.97, 0.95), 0.8, 0.2), m._mat(GOLD, 0.4, 0.6), 1.05, false)
			_gloves(m, steel, gold)
		"cat_dark":
			# DARK KNIGHT เกราะเหล็กดำ ผ้าคลุมดำชายขาดเป็นลอนมน
			var steel := _metal(m, STEEL_DARK)
			var trim := m._mat(Color(0.55, 0.22, 0.3), 0.5, 0.4)
			_breast(m, body, steel, trim)
			_pauldrons(m, body, steel, trim, 1.1)
			_cape(m, body, m._mat(Color(0.12, 0.1, 0.14), 0.8, 0.2), m._mat(Color(0.35, 0.15, 0.22), 0.6, 0.3), 1.05, true)
		"cat_crimson":
			# CRIMSON KNIGHT เกราะแดงเข้ม ผ้าคลุมสีกุหลาบ ตรากุหลาบกลางอก
			var crimson := _metal(m, Color(0.62, 0.12, 0.2))
			var rose := m._mat(Color(1.0, 0.45, 0.6), 0.6, 0.3)
			_breast(m, body, crimson, rose)
			_pauldrons(m, body, crimson, rose, 1.05)
			_cape(m, body, m._mat(Color(0.9, 0.3, 0.45), 0.8, 0.2), m._mat(Color(0.55, 0.08, 0.16), 0.6, 0.3), 1.0, false)
			_rose(m, body, rose)

## วัสดุโลหะเงาเล็กน้อย
static func _metal(m: ChibiModel, c: Color) -> StandardMaterial3D:
	var mat := m._mat(c, 0.32, 0.85)
	mat.metallic = 0.45
	return mat

## รูปตัดของตัวแมวที่ t (x คือความสูง y คือรัศมี)
static func _prof(t: float) -> Vector2:
	var prof: Array = ChibiModel.CAT_PROFILE
	var n := prof.size() - 1
	var f := clampf(t, 0.0, 1.0) * float(n)
	var i := mini(int(f), n - 1)
	var u := f - float(i)
	var p0: Vector2 = prof[maxi(i - 1, 0)]
	var p1: Vector2 = prof[i]
	var p2: Vector2 = prof[i + 1]
	var p3: Vector2 = prof[mini(i + 2, n)]
	return 0.5 * ((2.0 * p1) + (-p0 + p2) * u + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * u * u + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * u * u * u)

## จุดบนผิวตัวด้านหน้า (z บวก) ที่ความสูงตามรูปตัด t และระยะข้าง x
static func _front(t: float, x: float, lift := 0.02) -> Vector3:
	var p := _prof(t)
	var r := p.y
	var k := clampf(x / maxf(r, 0.01), -0.95, 0.95)
	return Vector3(x, p.x, sqrt(1.0 - k * k) * r * ChibiModel.CAT_DEPTH + lift)

static func _top() -> float:
	return (ChibiModel.CAT_PROFILE[ChibiModel.CAT_PROFILE.size() - 1] as Vector2).x

## เกราะอก เป็นแถบรอบอกพองนิดหน่อย (เห็นขนด้านบนและด้านล่าง) ขอบสีบนล่าง ตราอุ้งเท้ากลางอก
static func _breast(m: ChibiModel, body: MeshInstance3D, mat: Material, trim: Material) -> void:
	var band := []
	for i in 8:
		var t := lerpf(0.3, 0.58, float(i) / 7.0)
		var p := _prof(t)
		band.append(Vector2(p.x, p.y * 1.06 + 0.012))
	m._part(body, m._lathe(band, ChibiModel.CAT_DEPTH, 0.0, false), mat, Vector3.ZERO)
	for t in [0.3, 0.58]:
		var q := _prof(t)
		m._part(body, m._rod(q.y * 1.09, 0.045, 40), trim, Vector3(0.0, q.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))
	var e := _front(0.44, 0.0, 0.035)
	m._part(body, m._ball(0.07), trim, e, Vector3(1.1, 0.9, 0.4))
	for k in 3:
		var a := deg_to_rad(-40.0 + 40.0 * float(k))
		m._part(body, m._ball(0.032), trim, e + Vector3(sin(a) * 0.1, 0.085 + cos(a) * 0.015, -0.005), Vector3(1.0, 1.0, 0.4))

## เกราะไหล่กลมสองข้าง ขอบสี
static func _pauldrons(m: ChibiModel, body: MeshInstance3D, mat: Material, rim: Material, size: float) -> void:
	var r := _prof(ChibiModel.PAULDRON_AT).y
	for side in [-1.0, 1.0]:
		var g := m._group(body)
		g.position = Vector3(side * r, _top() * ChibiModel.PAULDRON_AT * 0.92, 0.04)
		g.rotation_degrees = Vector3(0.0, 0.0, -side * 30.0)
		g.scale = Vector3.ONE * size
		m._part(g, m._ball(0.2), mat, Vector3.ZERO, Vector3(1.05, 0.58, 1.1))
		m._part(g, m._ball(0.15), mat, Vector3(side * 0.06, -0.08, 0.0), Vector3(1.0, 0.45, 1.0))
		m._part(g, m._rod(0.205, 0.03, 28), rim, Vector3(0.0, -0.03, 0.0), Vector3(1.05, 1.0, 1.1))

## ผ้าคาดหน้าห้อยจากอกลงเลยสะโพก ปลายมน ขอบสี ตราอุ้งเท้า
static func _tabard(m: ChibiModel, body: MeshInstance3D, cloth: Material, trim: Material) -> void:
	var top := _front(0.4, 0.0, 0.03)
	var w := 0.2
	var h := 0.72
	var poly := PackedVector2Array([Vector2(w, 0.0), Vector2(-w, 0.0)])
	for i in 9:
		var a := PI * float(i) / 8.0
		poly.append(Vector2(-cos(a) * w, -h + 0.12 - sin(a) * 0.12))
	var node := m._part(body, m._flat(poly, 0.03), cloth, top, Vector3.ONE, Vector3(-14.0, 0.0, 0.0))
	m._part(node, m._rod(0.014, 0.42, 8), trim, Vector3(0.0, -0.02, 0.02), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
	var e := Vector3(0.0, -0.3, 0.025)
	m._part(node, m._ball(0.06), trim, e, Vector3(1.1, 0.9, 0.3))
	for k in 3:
		var a := deg_to_rad(-40.0 + 40.0 * float(k))
		m._part(node, m._ball(0.027), trim, e + Vector3(sin(a) * 0.085, 0.075 + cos(a) * 0.012, 0.0), Vector3(1.0, 1.0, 0.3))

## ผ้าคลุมหลังห้อยจากไหล่ ชายผ้ากว้าง  ragged = ชายเป็นลอนมน (ขาดแบบน่ารัก)
static func _cape(m: ChibiModel, body: MeshInstance3D, cloth: Material, trim: Material, length: float, ragged: bool) -> Node3D:
	var sh := _prof(0.6)
	var g := m._group(body)
	g.position = Vector3(0.0, _top() * 0.58, -sh.y * ChibiModel.CAT_DEPTH - 0.04)
	g.rotation_degrees = Vector3(-20.0, 0.0, 0.0)
	var h := 1.0 * length
	var poly := PackedVector2Array([Vector2(-0.4, 0.04), Vector2(0.4, 0.04), Vector2(0.66, -h)])
	var waves := 5 if ragged else 1
	for i in range(1, 25):
		var u := float(i) / 24.0
		var x := lerpf(0.66, -0.66, u)
		var y := -h - absf(sin(u * PI * float(waves))) * (0.09 if ragged else 0.0) - sin(u * PI) * 0.05
		poly.append(Vector2(x, y))
	m._part(g, m._flat(poly, 0.03), cloth, Vector3.ZERO)
	for side in [-1.0, 1.0]:
		m._part(g, m._ball(0.07), trim, Vector3(side * 0.36, 0.03, 0.03), Vector3(1.0, 1.0, 0.6))
	m._part(g, m._rod(0.022, 0.74, 10), trim, Vector3(0.0, 0.05, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
	return g

## วงเวทเรืองแสงบนผ้าคลุม (ด้านหลังที่หันออก)
static func _runes(m: ChibiModel, cape: Node3D, glow: Material) -> void:
	for p in [Vector2(0.0, -0.45), Vector2(-0.22, -0.7), Vector2(0.22, -0.7)]:
		var ring := m._part(cape, m._rod(0.075, 0.012, 20), glow, Vector3(p.x, p.y, -0.025), Vector3.ONE, Vector3(90.0, 0.0, 0.0))
		m._part(ring, m._ball(0.025), glow, Vector3.ZERO)

## เข็มขัดรอบเอว หัวเข็มขัดกลม
static func _belt(m: ChibiModel, body: MeshInstance3D, strap: Material, buckle: Material) -> void:
	var hip := _prof(0.24)
	m._part(body, m._rod(hip.y * 1.05, 0.06, 40), strap, Vector3(0.0, hip.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))
	m._part(body, m._ball(0.07), buckle, Vector3(0.0, hip.x, hip.y * 1.05 * ChibiModel.CAT_DEPTH + 0.01), Vector3(1.2, 1.0, 0.5))

## ผ้าคาดเฉียงจากไหล่ลงสะโพก ลายเปลวไฟกลมๆ
static func _sash(m: ChibiModel, body: MeshInstance3D, cloth: Material, flame: Material) -> void:
	var n := 9
	var prev := Vector3.ZERO
	for i in n:
		var u := float(i) / float(n - 1)
		var t := lerpf(0.58, 0.22, u)
		var r := _prof(t).y
		var p := _front(t, lerpf(-r * 0.7, r * 0.7, u), 0.035)
		if i > 0:
			m._edge(body, prev, p, 0.06, cloth)
		m._part(body, m._ball(0.06), cloth, p)
		if i % 2 == 1:
			m._part(body, m._ball(0.035), flame, p + Vector3(0.0, 0.04, 0.03), Vector3(0.8, 1.3, 0.5))
		prev = p

## ถุงมือโลหะกลม ข้อมือมีขอบ
static func _gloves(m: ChibiModel, mat: Material, rim: Material) -> void:
	for hand in [m._sword, m._off_hand]:
		m._part(hand, m._ball(ChibiModel.CAT_HAND_R * 1.12), mat, Vector3.ZERO)
		m._part(hand, m._rod(ChibiModel.CAT_HAND_R * 1.02, 0.04, 24), rim, Vector3(0.0, -ChibiModel.CAT_HAND_R * 0.72, 0.0))

## ตรากุหลาบกลางอก กลีบกลมซ้อนกัน
static func _rose(m: ChibiModel, body: MeshInstance3D, rose: Material) -> void:
	var c := _front(0.47, 0.0, 0.06)
	for k in 5:
		var a := TAU * float(k) / 5.0
		m._part(body, m._ball(0.04), rose, c + Vector3(cos(a) * 0.045, sin(a) * 0.045, 0.0), Vector3(1.0, 1.0, 0.5))
	m._part(body, m._ball(0.035), m._mat(Color(0.85, 0.15, 0.3), 0.6, 0.3), c + Vector3(0.0, 0.0, 0.01))
