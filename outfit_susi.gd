class_name OutfitSusi
## ชุดของ CAT SUSI (แมวสฟิงซ์ม่วง) แต่ละคลาส  BASIC (cat_staff) ไม่ใส่ชุด
## ไม่มีหมวก ไม่บังหู เน้นผ้าคลุมไหล่ ผ้าคลุมหลัง ปกคอ กระโปรงสั้น ผ้าคาดเอว ยังเห็นขนกับพุง

const P := ChibiModel.CAT_PROFILE
const D := ChibiModel.CAT_DEPTH

static func build(m: ChibiModel, body: MeshInstance3D, _foot_mesh: Mesh) -> void:
	match m.style:
		"cat_staff_arch":
			_arch(m, body)
		"cat_staff_element":
			_element(m, body)
		"cat_staff_battle":
			_battle(m, body)
		"cat_staff_dimension":
			_dimension(m, body)
		"cat_staff_dark":
			_dark(m, body)
		"cat_staff_eclipse":
			_eclipse(m, body)
		"cat_staff_alch":
			_alch(m, body)
		"cat_staff_trans":
			_trans(m, body)

# ---------------------------------------------------------------- ชิ้นส่วนพื้นฐาน

static func _at(m: ChibiModel, t: float) -> Vector2:
	return m._profile_at(P, t)

## แถบผ้ารอบตัวจาก t0 ถึง t1 พองออกจากผิว flare คือบานออกที่ขอบล่าง
static func _band(m: ChibiModel, body: MeshInstance3D, t0: float, t1: float, puff: float, flare: float, mat: Material) -> void:
	var pts := []
	for i in 10:
		var k := float(i) / 9.0
		var p := _at(m, lerpf(t0, t1, k))
		pts.append(Vector2(p.x - flare * 0.25 * (1.0 - k), p.y * (1.0 + puff + flare * (1.0 - k)) + 0.012))
	m._part(body, m._lathe(pts, D, 0.0, false), mat, Vector3.ZERO)

## เส้นขอบรอบตัวที่ความสูง t
static func _ring(m: ChibiModel, body: MeshInstance3D, t: float, scale: float, thick: float, mat: Material) -> void:
	var q := _at(m, t)
	m._part(body, m._rod(q.y * scale, thick, 40), mat, Vector3(0.0, q.x, 0.0), Vector3(1.0, 1.0, D))

## ปกคอฟูเป็นลูกกลมเรียงรอบคอ rise คือยกขึ้นด้านหลังให้ดูเหมือนฮู้ดพับ
static func _collar(m: ChibiModel, body: MeshInstance3D, size: float, mat: Material, rise := 0.0, count := 14) -> void:
	var q := _at(m, 0.64)
	for n in count:
		var a := TAU * float(n) / float(count)
		var back := maxf(-cos(a), 0.0)
		var at := Vector3(sin(a) * q.y * 1.08, q.x + back * rise, cos(a) * q.y * 1.08 * D)
		m._part(body, m._ball(size * (1.0 + back * rise * 2.0)), mat, at, Vector3(1.0, 0.8, 1.0))

## ผ้าโค้งห่อรอบตัวช่วงมุม a0 ถึง a1 (0 คือด้านหน้า PI คือด้านหลัง) จาก t_top ลงไปถึง t_low
## แผ่นผ้าโค้งชิ้นเดียว แนบตามรูปตัวทุกระดับความสูง ขอบล่างบานออกนิด มุมมนที่ขอบข้าง
static func _drape(m: ChibiModel, body: MeshInstance3D, a0: float, a1: float, t_top: float, t_low: float, mat: Material, out := 1.12, _cols := 0) -> void:
	const ROWS := 10
	const COLS := 18
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var grid := []
	for r in ROWS:
		var k := float(r) / float(ROWS - 1)
		var p := _at(m, lerpf(t_top, t_low, k))
		var row := []
		for c in COLS:
			var u := float(c) / float(COLS - 1)
			var a := lerpf(a0, a1, u)
			# ขอบข้างด้านล่างโค้งมนเข้าหากลาง ไม่เป็นมุมเหลี่ยม
			var edge := absf(u - 0.5) * 2.0
			var drop := k * k * edge * edge * 0.12
			var rad := p.y * (out + 0.1 * k * k) + 0.012
			row.append(Vector3(sin(a) * rad, p.x + drop, cos(a) * rad * D))
		grid.append(row)
	for r in ROWS - 1:
		for c in COLS - 1:
			var v00: Vector3 = grid[r][c]
			var v01: Vector3 = grid[r][c + 1]
			var v10: Vector3 = grid[r + 1][c]
			var v11: Vector3 = grid[r + 1][c + 1]
			var n := Vector3(v00.x + v11.x, 0.0, v00.z + v11.z).normalized()
			# หันหน้าผ้าออกนอกตัวเสมอ ไม่ให้เห็นด้านในแล้วมืด
			var order := [v00, v10, v01, v01, v10, v11]
			if (v10 - v00).cross(v01 - v00).dot(n) > 0.0:
				order = [v00, v01, v10, v01, v11, v10]
			for v in order:
				st.set_normal(n)
				st.add_vertex(v)
	if mat is BaseMaterial3D:
		(mat as BaseMaterial3D).cull_mode = BaseMaterial3D.CULL_DISABLED
	m._part(body, st.commit(), mat, Vector3.ZERO)

## ผ้าคลุมหลัง ห่อรอบด้านหลังจากไหล่ลงมา คืนจุดกลางหลังไว้ติดลวดลาย
static func _cape(m: ChibiModel, body: MeshInstance3D, mat: Material, long := 1.0, wide := 1.0) -> Node3D:
	var t_low := lerpf(0.3, 0.03, clampf(long, 0.0, 1.0))
	var span := 1.15 * wide
	_drape(m, body, PI - span, PI + span, 0.62, t_low, mat, 1.14)
	var back := _at(m, 0.38)
	var spot := m._group(body)
	spot.position = Vector3(0.0, 0.0, -(back.y * 1.14 * D + 0.035))
	return spot

## จุดกลมตกแต่งบนผ้าคลุมหลัง (แทนดาว)
static func _dots(m: ChibiModel, cape: Node3D, mats: Array, count: int, seed_no: int) -> void:
	var neck := _at(m, 0.6)
	var low := _at(m, 0.12)
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_no
	for n in count:
		var h := rng.randf_range(low.x, neck.x)
		var x := rng.randf_range(-0.28, 0.28)
		m._part(cape, m._ball(rng.randf_range(0.018, 0.04)), mats[n % mats.size()], Vector3(x, h, -0.025), Vector3(1.0, 1.0, 0.4))

## ลูกกลมติดหน้าอก (เข็มกลัด ปุ่ม)
static func _front(m: ChibiModel, body: MeshInstance3D, t: float, r: float, mat: Material, x := 0.0, sz := Vector3(1.0, 1.0, 0.45)) -> void:
	var q := _at(m, t)
	m._part(body, m._ball(r), mat, Vector3(x, q.x, q.y * D * 1.05 + 0.015), sz)

## ขวดยาเล็กห้อยเข็มขัด
static func _potion(m: ChibiModel, body: MeshInstance3D, t: float, ang: float, col: Color) -> void:
	var q := _at(m, t)
	var at := Vector3(sin(ang) * q.y * 1.12, q.x - 0.07, cos(ang) * q.y * 1.12 * D)
	m._part(body, m._ball(0.055), m._mat(col, 0.2, 0.8), at)
	m._part(body, m._rod(0.022, 0.05, 10), m._mat(Color(0.95, 0.95, 1.0), 0.3, 0.6), at + Vector3(0.0, 0.07, 0.0))
	m._part(body, m._ball(0.025), m._mat(Color(0.65, 0.45, 0.3), 0.8, 0.2), at + Vector3(0.0, 0.1, 0.0))

# ---------------------------------------------------------------- แต่ละคลาส

## ARCH MAGE: ผ้าคลุมไหล่สั้นสีม่วงลาเวนเดอร์ขอบขาว เข็มกลัดทอง ผ้าคลุมหลังสั้น
static func _arch(m: ChibiModel, body: MeshInstance3D) -> void:
	var cloth := m._mat(Color(0.72, 0.6, 0.95), 0.85, 0.2)
	var white := m._mat(Color(0.98, 0.97, 1.0), 0.9, 0.1)
	var gold := m._mat(Color(1.0, 0.82, 0.35), 0.3, 0.8)
	_band(m, body, 0.5, 0.66, 0.06, 0.12, cloth)
	_ring(m, body, 0.5, 1.2, 0.035, white)
	_cape(m, body, cloth, 0.55)
	_front(m, body, 0.62, 0.05, gold)

## ELEMENT MASTER: กระโปรงสามชั้นไฟ น้ำแข็ง สายฟ้า (สีพาสเทล) ผ้าคลุมไหล่ขาว ลูกแก้วสามสีที่เอว
static func _element(m: ChibiModel, body: MeshInstance3D) -> void:
	var fire := m._mat(Color(1.0, 0.62, 0.55), 0.85, 0.2)
	var ice := m._mat(Color(0.6, 0.85, 1.0), 0.85, 0.2)
	var bolt := m._mat(Color(1.0, 0.92, 0.55), 0.85, 0.2)
	var white := m._mat(Color(0.98, 0.97, 1.0), 0.9, 0.1)
	_band(m, body, 0.04, 0.14, 0.08, 0.16, fire)
	_band(m, body, 0.12, 0.2, 0.07, 0.1, ice)
	_band(m, body, 0.18, 0.26, 0.06, 0.06, bolt)
	_band(m, body, 0.52, 0.66, 0.05, 0.1, white)
	var q := _at(m, 0.26)
	var cols := [Color(1.0, 0.5, 0.45), Color(0.5, 0.8, 1.0), Color(1.0, 0.88, 0.4)]
	for i in 3:
		var a := deg_to_rad(-30.0 + 30.0 * float(i))
		m._part(body, m._ball(0.04), m._glow(cols[i], 0.6), Vector3(sin(a) * q.y * 1.1, q.x, cos(a) * q.y * 1.1 * D))

## BATTLE MAGE: เกราะอกเบาสีม่วงเหล็ก ผ้าคาดทแยงสีชมพู เกราะไหล่กลม
static func _battle(m: ChibiModel, body: MeshInstance3D) -> void:
	var plate := m._mat(Color(0.62, 0.55, 0.8), 0.35, 0.8)
	plate.metallic = 0.4
	var sash := m._mat(Color(0.95, 0.5, 0.7), 0.85, 0.2)
	var gold := m._mat(Color(1.0, 0.82, 0.35), 0.3, 0.8)
	_band(m, body, 0.36, 0.6, 0.05, 0.0, plate)
	_ring(m, body, 0.6, 1.1, 0.04, gold)
	_ring(m, body, 0.36, 1.1, 0.04, gold)
	# ผ้าคาดทแยงจากไหล่ลงเอว ลูกกลมเรียงต่อกัน
	for i in 9:
		var k := float(i) / 8.0
		var t := lerpf(0.6, 0.24, k)
		var q := _at(m, t)
		var a := lerpf(0.9, -0.9, k)
		m._part(body, m._ball(0.05), sash, Vector3(sin(a) * q.y * 1.1, q.x, cos(a) * q.y * 1.1 * D), Vector3(1.0, 1.0, 0.7))
	var sh := _at(m, ChibiModel.PAULDRON_AT)
	for side in [-1.0, 1.0]:
		m._part(body, m._ball(0.15), plate, Vector3(side * sh.y * 1.02, sh.x, 0.0), Vector3(1.0, 0.6, 1.0))

## DIMENSION CASTER: ผ้าคลุมหลังยาวสีกรมท่า ลายจุดกลมกับวงแหวนแบบกาแล็กซี ปกคอฟู
static func _dimension(m: ChibiModel, body: MeshInstance3D) -> void:
	var navy := m._mat(Color(0.3, 0.3, 0.62), 0.85, 0.2)
	var trim := m._mat(Color(0.7, 0.6, 1.0), 0.6, 0.4)
	var cape := _cape(m, body, navy, 0.95, 1.05)
	_dots(m, cape, [m._glow(Color(1.0, 0.95, 0.75), 0.8), m._glow(Color(0.7, 0.85, 1.0), 0.8), m._glow(Color(1.0, 0.7, 0.9), 0.8)], 16, 7)
	# วงแหวนดาวเคราะห์กลางผ้าคลุม
	var mid := _at(m, 0.38)
	for n in 12:
		var a := TAU * float(n) / 12.0
		m._part(cape, m._ball(0.02), trim, Vector3(cos(a) * 0.13, mid.x + sin(a) * 0.05, -0.03))
	m._part(cape, m._ball(0.06), m._glow(Color(0.85, 0.75, 1.0), 0.7), Vector3(0.0, mid.x, -0.035), Vector3(1.0, 1.0, 0.4))
	_collar(m, body, 0.06, navy)

## DARK MAGE: ปกคอสูงแบบฮู้ดพับด้านหลัง กระโปรงยาวสีม่วงเข้ม ขอบชมพู
static func _dark(m: ChibiModel, body: MeshInstance3D) -> void:
	var robe := m._mat(Color(0.38, 0.28, 0.55), 0.85, 0.2)
	var trim := m._mat(Color(0.95, 0.55, 0.8), 0.7, 0.3)
	_band(m, body, 0.03, 0.3, 0.07, 0.14, robe)
	_ring(m, body, 0.3, 1.1, 0.03, trim)
	_collar(m, body, 0.075, robe, 0.12, 16)
	_front(m, body, 0.6, 0.045, trim)

## ECLIPSE: ผ้าคลุมหลังดำ ตราวงแหวนสุริยุปราคาสีทองกลางหลัง ปกคอทอง
static func _eclipse(m: ChibiModel, body: MeshInstance3D) -> void:
	var black := m._mat(Color(0.18, 0.16, 0.24), 0.8, 0.25)
	var gold := m._mat(Color(1.0, 0.8, 0.35), 0.3, 0.85)
	var cape := _cape(m, body, black, 0.85, 1.1)
	var mid := _at(m, 0.4)
	for n in 16:
		var a := TAU * float(n) / 16.0
		m._part(cape, m._ball(0.025), gold, Vector3(cos(a) * 0.12, mid.x + sin(a) * 0.12, -0.03))
	m._part(cape, m._ball(0.09), black, Vector3(0.0, mid.x, -0.035), Vector3(1.0, 1.0, 0.3))
	_ring(m, body, 0.64, 1.12, 0.05, gold)
	_front(m, body, 0.6, 0.05, gold)

## ALCHEMIST: ผ้ากันเปื้อนสีครีมด้านหน้า กระเป๋ากลม เข็มขัดหนังห้อยขวดยาสามขวด
static func _alch(m: ChibiModel, body: MeshInstance3D) -> void:
	var apron := m._mat(Color(0.98, 0.93, 0.82), 0.9, 0.1)
	var leather := m._mat(Color(0.62, 0.42, 0.3), 0.8, 0.2)
	_drape(m, body, -0.75, 0.75, 0.52, 0.06, apron, 1.1, 9)
	var fat := _at(m, 0.3)
	var pin := m._group(body)
	pin.position = Vector3(0.0, 0.0, fat.y * 1.1 * D + 0.03)
	m._part(pin, m._ball(0.07), m._mat(Color(0.92, 0.82, 0.68), 0.9, 0.1), Vector3(0.0, _at(m, 0.22).x, 0.02), Vector3(1.3, 0.8, 0.3))
	_ring(m, body, 0.3, 1.1, 0.045, leather)
	_potion(m, body, 0.3, deg_to_rad(70.0), Color(0.55, 0.9, 0.6))
	_potion(m, body, 0.3, deg_to_rad(-70.0), Color(1.0, 0.6, 0.8))
	_potion(m, body, 0.3, deg_to_rad(110.0), Color(0.6, 0.75, 1.0))

## TRANSMUTATION MASTER: เสื้อโค้ทนักแปรธาตุสีครีม ขอบทอง ชายโค้ทด้านหลัง ปกคอ กระดุมทอง
static func _trans(m: ChibiModel, body: MeshInstance3D) -> void:
	var coat := m._mat(Color(0.97, 0.92, 0.8), 0.85, 0.2)
	var gold := m._mat(Color(1.0, 0.8, 0.32), 0.3, 0.85)
	_band(m, body, 0.04, 0.22, 0.07, 0.1, coat)
	_ring(m, body, 0.22, 1.12, 0.035, gold)
	_ring(m, body, 0.05, 1.22, 0.03, gold)
	_band(m, body, 0.52, 0.66, 0.05, 0.08, coat)
	_ring(m, body, 0.52, 1.17, 0.03, gold)
	_cape(m, body, coat, 0.75, 0.8)
	for i in 3:
		_front(m, body, 0.5 - 0.1 * float(i), 0.03, gold)
