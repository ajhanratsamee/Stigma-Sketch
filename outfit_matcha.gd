class_name OutfitMatcha
## ชุดของ CAT MATCHA นักธนู แต่ละคลาสไม่ซ้ำกัน ไม่มีหมวกปิดหู เห็นขนลายสลิด
## ชิ้นส่วนติดกับตัวแมว (body) จึงหายใจและขยับตามตัว
## ระบบพิกัดของตัว: y คือความสูงตามรูปตัด CAT_PROFILE ด้านหน้าคือ +z ด้านหลังคือ -z

const LEATHER := Color(0.62, 0.42, 0.26)
const LEATHER_DARK := Color(0.45, 0.3, 0.18)
const GOLD := Color(1.0, 0.82, 0.35)

static func build(m: ChibiModel, body: MeshInstance3D, _foot_mesh: Mesh) -> void:
	match m.style:
		"cat_bow_wind":
			_scarf(m, body, Color(0.92, 1.0, 0.94), Color(0.55, 0.85, 0.65), 3)
			_belt(m, body, LEATHER, GOLD)
			_quiver(m, body, LEATHER, Color(0.95, 0.98, 1.0))
		"cat_bow_gale":
			_cape(m, body, Color(0.62, 0.92, 0.78), Color(0.95, 1.0, 0.97), 1.0)
			_scarf(m, body, Color(0.95, 1.0, 0.97), Color(0.45, 0.8, 0.6), 4)
			_belt(m, body, LEATHER, GOLD)
			_quiver(m, body, LEATHER, Color(0.85, 1.0, 0.92))
			_clasp(m, body, GOLD)
		"cat_bow_snipe":
			_cape(m, body, Color(0.52, 0.45, 0.32), Color(0.4, 0.34, 0.24), 1.05)
			_leaves(m, body, Color(0.42, 0.62, 0.32), 14)
			_belt(m, body, LEATHER_DARK, Color(0.75, 0.65, 0.45))
			_quiver(m, body, LEATHER_DARK, Color(0.75, 0.9, 0.6))
		"cat_bow_apex":
			_cape(m, body, Color(0.3, 0.45, 0.32), GOLD, 1.12)
			_leaves(m, body, Color(0.38, 0.58, 0.3), 10)
			_belt(m, body, LEATHER_DARK, GOLD)
			_quiver(m, body, LEATHER_DARK, GOLD)
			_clasp(m, body, GOLD)
		"cat_bow_mana":
			_scarf(m, body, Color(0.85, 0.92, 1.0), Color(0.6, 0.72, 1.0), 2)
			_sash(m, body, Color(0.95, 0.95, 1.0), [Color(0.55, 0.8, 1.0), Color(1.0, 0.5, 0.5), Color(1.0, 0.9, 0.4)], 0.05)
			_quiver(m, body, LEATHER, Color(0.75, 0.85, 1.0))
		"cat_bow_essence":
			_cape(m, body, Color(0.95, 0.93, 1.0), Color(0.75, 0.7, 0.95), 0.95)
			_sash(m, body, Color(1.0, 0.97, 0.88), [Color(1.0, 0.55, 0.45), Color(0.6, 0.85, 1.0), Color(1.0, 0.92, 0.45)], 0.075)
			_quiver(m, body, Color(0.85, 0.8, 0.95), Color(1.0, 0.95, 0.75))
			_clasp(m, body, Color(0.8, 0.75, 1.0))
		"cat_bow_trap":
			_cape(m, body, Color(0.38, 0.3, 0.24), Color(0.55, 0.45, 0.32), 1.0)
			_belt(m, body, LEATHER_DARK, Color(0.7, 0.6, 0.45))
			_pouches(m, body, LEATHER, 4)
			_bandolier(m, body, LEATHER_DARK)
		"cat_bow_twilight":
			_cape(m, body, Color(0.16, 0.14, 0.2), Color(0.55, 0.4, 0.75), 1.1)
			_feathers(m, body, Color(0.12, 0.1, 0.15), Color(0.55, 0.4, 0.75))
			_belt(m, body, Color(0.2, 0.17, 0.24), Color(0.6, 0.45, 0.8))
			_pouches(m, body, Color(0.28, 0.24, 0.32), 3)

## ตำแหน่งบนผิวตัวที่ความสูง t (0 ก้น 1 ยอดหัว) มุม ang (0 ด้านหน้า) ยื่นออกจากผิว out
static func _at(t: float, ang: float, out := 0.0) -> Vector3:
	var p := _prof(t)
	return Vector3(sin(ang) * (p.y + out), p.x, cos(ang) * (p.y + out) * ChibiModel.CAT_DEPTH)

## ความสูงกับรัศมีตัวที่ระดับ t
static func _prof(t: float) -> Vector2:
	var pr: Array = ChibiModel.CAT_PROFILE
	var top: float = (pr[pr.size() - 1] as Vector2).x
	var y := top * t
	for i in range(1, pr.size()):
		var a: Vector2 = pr[i - 1]
		var b: Vector2 = pr[i]
		if y <= b.x:
			var k := (y - a.x) / maxf(b.x - a.x, 0.0001)
			return Vector2(y, lerpf(a.y, b.y, k))
	return Vector2(top, 0.0)

## ผ้าพันคอรอบคอ ชายผ้าปลิวไปด้านหลัง
static func _scarf(m: ChibiModel, body: MeshInstance3D, cloth: Color, stripe: Color, tails: int) -> void:
	var c := m._mat(cloth, 0.9, 0.15)
	var s := m._mat(stripe, 0.9, 0.15)
	var neck := _prof(0.6)
	for i in 18:
		var ang := TAU * float(i) / 18.0
		m._part(body, m._ball(0.075), c if i % 3 != 0 else s, _at(0.6, ang, 0.035), Vector3(1.0, 0.8, 1.0))
	for k in tails:
		var side := -1.0 if k % 2 == 0 else 1.0
		var base := Vector3(side * 0.12, neck.x - 0.02, -neck.y * ChibiModel.CAT_DEPTH - 0.04)
		for j in 7:
			var f := float(j) / 6.0
			var p := base + Vector3(side * (0.06 + f * 0.12) + sin(f * 5.0 + float(k)) * 0.04, -f * 0.22 - float(k) * 0.04, -f * 0.32)
			m._part(body, m._ball(0.055 * (1.0 - f * 0.4)), s if j % 2 == 1 else c, p, Vector3(1.0, 0.7, 1.0))

## ผ้าคลุมด้านหลังโค้งแนบหลัง เป็นแถบผ้ากลมๆ เรียงรอบหลังจากคอถึงก้น ชายมีลูกกลมสีตัด
static func _cape(m: ChibiModel, body: MeshInstance3D, cloth: Color, trim: Color, wide: float) -> void:
	var cm := m._mat(cloth, 0.9, 0.15)
	var cd := m._mat(cloth.darkened(0.12), 0.9, 0.15)
	var tr := m._mat(trim, 0.7, 0.3)
	var strips := 9
	var spread := 1.25 * wide
	for i in strips:
		var k := float(i) / float(strips - 1)
		var ang := PI + lerpf(-spread, spread, k)
		var top := _at(0.63, ang, 0.03)
		var low := _at(0.1, ang, 0.1 + 0.04 * sin(k * PI))
		var mid := (top + low) * 0.5
		var length := top.distance_to(low)
		# แถบผ้าตั้งตามแนวตัว หมุนตามมุมรอบหลัง เอียงออกตามผิวตัวที่ป่องลงล่าง
		var radial := Vector2(low.x, low.z).length() - Vector2(top.x, top.z).length()
		var tilt := rad_to_deg(atan2(radial, top.y - low.y))
		var strip := m._part(body, m._ball(0.5), cm if i % 2 == 0 else cd, mid, Vector3(0.2, length, 0.07))
		strip.rotation_degrees = Vector3(tilt, rad_to_deg(ang), 0.0)
		m._part(body, m._ball(0.04), tr, low + Vector3(0.0, -0.02, 0.0))
	# ปกคอผ้าคลุมรอบคอด้านหลัง
	for i in 9:
		var ang := PI * 0.5 + PI * float(i) / 8.0
		m._part(body, m._ball(0.07), cm, _at(0.65, ang, 0.02), Vector3(1.0, 0.75, 1.0))

## เข็มกลัดผ้าคลุมกลางอก
static func _clasp(m: ChibiModel, body: MeshInstance3D, col: Color) -> void:
	m._part(body, m._ball(0.06), m._mat(col, 0.3, 0.8), _at(0.63, 0.0, 0.05), Vector3(1.0, 1.0, 0.5))

## เข็มขัดรอบเอว หัวเข็มขัดกลม
static func _belt(m: ChibiModel, body: MeshInstance3D, col: Color, buckle: Color) -> void:
	var waist := _prof(0.2)
	m._part(body, m._rod(waist.y * 1.04, 0.05, 40), m._mat(col, 0.7, 0.2), Vector3(0.0, waist.x, 0.0), Vector3(1.0, 1.0, ChibiModel.CAT_DEPTH))
	m._part(body, m._ball(0.05), m._mat(buckle, 0.3, 0.8), _at(0.2, 0.0, 0.03), Vector3(1.2, 1.0, 0.5))

## กระบอกลูกธนูเฉียงบนหลัง ขนนกปลายลูกธนูโผล่เหนือไหล่
static func _quiver(m: ChibiModel, body: MeshInstance3D, col: Color, fletch: Color) -> void:
	var g := m._group(body)
	var mid := _prof(0.42)
	g.position = Vector3(0.12, mid.x, -mid.y * ChibiModel.CAT_DEPTH - 0.08)
	g.rotation_degrees = Vector3(0.0, 0.0, -25.0)
	m._part(g, m._rod(0.075, 0.42, 16), m._mat(col, 0.7, 0.2), Vector3.ZERO)
	m._part(g, m._rod(0.082, 0.04, 16), m._mat(GOLD, 0.3, 0.8), Vector3(0.0, 0.2, 0.0))
	var f := m._mat(fletch, 0.8, 0.2)
	var shaft := m._mat(Color(0.75, 0.6, 0.4), 0.8, 0.1)
	for i in 3:
		var x := (float(i) - 1.0) * 0.04
		m._part(g, m._rod(0.01, 0.12, 6), shaft, Vector3(x, 0.26, 0.0))
		m._part(g, m._ball(0.035), f, Vector3(x, 0.32, 0.0), Vector3(0.6, 1.3, 0.4))

## ใบไม้พรางตัวกลมๆ บนไหล่และหลัง (สายสไนเปอร์)
static func _leaves(m: ChibiModel, body: MeshInstance3D, col: Color, count: int) -> void:
	var a := m._mat(col, 0.9, 0.1)
	var b := m._mat(col.lightened(0.2), 0.9, 0.1)
	for i in count:
		var ang := PI * 0.35 + PI * 1.3 * float(i) / float(count - 1)
		var t := 0.64 - 0.04 * float(i % 3)
		var leaf := m._part(body, m._ball(0.06), a if i % 2 == 0 else b, _at(t, ang, 0.06), Vector3(1.0, 0.45, 0.7))
		leaf.rotation_degrees = Vector3(0.0, rad_to_deg(ang), 25.0 * (1.0 if i % 2 == 0 else -1.0))

## สายสะพายเฉียงอก ติดคริสตัลมานาเรืองแสง
static func _sash(m: ChibiModel, body: MeshInstance3D, cloth: Color, gems: Array, gem_r: float) -> void:
	var c := m._mat(cloth, 0.9, 0.15)
	var n := 12
	for i in n:
		var f := float(i) / float(n - 1)
		m._part(body, m._ball(0.05), c, _at(lerpf(0.6, 0.22, f), lerpf(-0.9, 0.9, f), 0.03), Vector3(1.0, 0.7, 0.7))
	for k in gems.size():
		var f := 0.25 + 0.25 * float(k)
		m._part(body, m._ball(gem_r), m._glow(gems[k], 0.9), _at(lerpf(0.6, 0.22, f), lerpf(-0.9, 0.9, f), 0.07), Vector3(0.85, 1.15, 0.7))

## กระเป๋าเล็กหลายใบรอบเข็มขัดด้านข้าง (สายนักวางกับดัก)
static func _pouches(m: ChibiModel, body: MeshInstance3D, col: Color, count: int) -> void:
	var p := m._mat(col, 0.75, 0.2)
	var flap := m._mat(col.darkened(0.25), 0.75, 0.2)
	for i in count:
		var ang := lerpf(-1.4, 1.4, float(i) / float(maxi(count - 1, 1)))
		var at := _at(0.19, ang, 0.07)
		at.y -= 0.03
		m._part(body, m._ball(0.07), p, at, Vector3(1.0, 0.85, 0.7))
		m._part(body, m._ball(0.05), flap, at + Vector3(0.0, 0.04, 0.0), Vector3(1.3, 0.45, 0.9))

## สายคาดเฉียงมีลูกกลมสำรอง (เครื่องมือกับดัก)
static func _bandolier(m: ChibiModel, body: MeshInstance3D, col: Color) -> void:
	var c := m._mat(col, 0.8, 0.2)
	var dot := m._mat(Color(0.85, 0.75, 0.5), 0.4, 0.6)
	for i in 10:
		var f := float(i) / 9.0
		var t := lerpf(0.61, 0.21, f)
		var ang := lerpf(0.9, -0.9, f)
		m._part(body, m._ball(0.045), c, _at(t, ang, 0.03), Vector3(1.0, 0.7, 0.7))
		if i % 3 == 1:
			m._part(body, m._ball(0.03), dot, _at(t, ang, 0.07))

## ขนนกดำปลายม่วงที่ไหล่ (TWILIGHT)
static func _feathers(m: ChibiModel, body: MeshInstance3D, col: Color, tip: Color) -> void:
	var c := m._mat(col, 0.6, 0.3)
	var t_m := m._mat(tip, 0.6, 0.3)
	var feather := PackedVector2Array()
	for i in 12:
		var a := TAU * float(i) / 12.0
		feather.append(Vector2(cos(a) * 0.035, sin(a) * 0.11 + 0.11))
	for side in [-1.0, 1.0]:
		for k in 4:
			var ang: float = side * (1.15 + 0.22 * float(k))
			var f := m._part(body, m._flat(feather, 0.012), c if k % 2 == 0 else t_m, _at(0.65 - 0.03 * float(k), ang, 0.04))
			f.rotation_degrees = Vector3(0.0, rad_to_deg(ang), -side * (35.0 + 12.0 * float(k)))
