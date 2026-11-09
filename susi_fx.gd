class_name SusiFx
extends Node2D
## ภาพเอฟเฟกต์สกิลของ CAT SUSI ทุกสาย วาดอย่างเดียว ตัวสกิล (SusiSkills) เป็นคนขยับ เช็กโดน และลบ
## ทุกชิ้นมีลายแมว หูแมว หน้า ^ ^ ω รอยเท้าแมว หนวด ตาแมว ค้างคาวหูแมว
## kind: fire ice dim dark bolt_orb trail storm wind meteor circle pillar web bat smoke staff boom ellipse beam chain field mem poof ward

const INK := Color(0.25, 0.12, 0.2)
const PINK := Color(1.0, 0.62, 0.75)
const COLORS := {
	"fire": [Color(1.0, 0.45, 0.15), Color(1.0, 0.85, 0.35)],
	"ice": [Color(0.45, 0.8, 1.0), Color(0.88, 0.97, 1.0)],
	"bolt": [Color(0.4, 0.75, 1.0), Color(0.95, 0.98, 1.0)],
	"bolt_pink": [Color(1.0, 0.45, 0.8), Color(1.0, 0.9, 0.98)],
	"dim": [Color(1.0, 0.42, 0.75), Color(1.0, 0.85, 0.95)],
	"dark": [Color(0.45, 0.2, 0.7), Color(0.85, 0.6, 1.0)],
	"arcane": [Color(0.75, 0.4, 1.0), Color(1.0, 0.85, 1.0)],
	"wind": [Color(0.55, 0.85, 0.7), Color(0.92, 1.0, 0.95)],
	"leaf": [Color(0.3, 0.72, 0.35), Color(0.82, 1.0, 0.78)],
	"redwind": [Color(1.0, 0.42, 0.35), Color(0.6, 0.95, 0.6)],
	"poison": [Color(0.55, 0.85, 0.3), Color(0.85, 0.6, 1.0)],
	"mana": [Color(0.35, 0.6, 1.0), Color(0.85, 0.95, 1.0)],
	"ore": [Color(1.0, 0.74, 0.87), Color(1.0, 0.95, 0.98)],
	"silver": [Color(0.75, 0.8, 0.9), Color(1.0, 1.0, 1.0)],
	"sun": [Color(1.0, 0.84, 0.3), Color(1.0, 0.97, 0.75)],
}

var kind := "fire"
var element := "fire"           # ชุดสีจาก COLORS
var r := 30.0                   # ขนาดหลัก (จุดภาพ)
var rx := 0.0                   # วงรี / ลำแสง
var ry := 0.0
var angle := 0.0                # มุมลำแสง
var length := 0.0
var dir := 1.0
var points: PackedVector2Array = PackedVector2Array()   # สายฟ้าชิ่ง
var life := 1.0                 # อายุทั้งหมด ใช้ทำจางตอนท้าย
var age := 0.0
var fade_in := 0.12
var auto_free := false          # ลบตัวเองเมื่อหมดอายุ (เอฟเฟกต์ประกอบ)
var spin := 0.0
var segs: Array = []            # ผลึกแตกกิ่ง [จุดเริ่ม จุดปลาย ระยะที่เริ่มงอก]
var front := 0.0                # ผลึกงอกไปถึงระยะนี้แล้ว

func _process(delta: float) -> void:
	age += delta
	spin += delta
	if auto_free and age >= life:
		queue_free()
		return
	queue_redraw()

func _c(i: int) -> Color:
	var pair: Array = COLORS.get(element, COLORS["arcane"])
	return pair[i]

func _alpha() -> float:
	var a := 1.0
	if fade_in > 0.0:
		a = minf(age / fade_in, 1.0)
	if life > 0.0 and age > life - 0.25:
		a *= clampf((life - age) / 0.25, 0.0, 1.0)
	return a

# ---------------------------------------------------------------- ลายแมว
func paw(at: Vector2, size: float, color: Color) -> void:
	draw_circle(at + Vector2(0.0, size * 0.25), size * 0.55, color)
	for i in 4:
		var a := -2.45 + float(i) * 0.55
		draw_circle(at + Vector2(cos(a), sin(a)) * size * 0.85 + Vector2(0.0, size * 0.15), size * 0.24, color)

func ears(c: Vector2, size: float, color: Color, inner := PINK) -> void:
	for side in [-1.0, 1.0]:
		var base := c + Vector2(side * size * 0.55, -size * 0.6)
		var tri := PackedVector2Array([base + Vector2(-side * size * 0.32, size * 0.1), base + Vector2(side * size * 0.12, -size * 0.6), base + Vector2(side * size * 0.36, size * 0.2)])
		draw_colored_polygon(tri, color)
		var m := (tri[0] + tri[1] + tri[2]) / 3.0
		draw_colored_polygon(PackedVector2Array([tri[0].lerp(m, 0.45), tri[1].lerp(m, 0.45), tri[2].lerp(m, 0.45)]), Color(inner, color.a))

func face(c: Vector2, size: float, ink: Color) -> void:
	if size < 10.0:
		return
	var w := maxf(2.0, size * 0.08)
	for side in [-1.0, 1.0]:
		var e := c + Vector2(side * size * 0.3, -size * 0.08)
		draw_polyline(PackedVector2Array([e + Vector2(-size * 0.12, size * 0.06), e + Vector2(0.0, -size * 0.06), e + Vector2(size * 0.12, size * 0.06)]), ink, w, true)
		draw_circle(c + Vector2(side * size * 0.48, size * 0.14), size * 0.1, Color(1.0, 0.55, 0.6, 0.6 * ink.a))
	draw_arc(c + Vector2(-size * 0.08, size * 0.2), size * 0.08, 0.0, PI, 8, ink, w * 0.8, true)
	draw_arc(c + Vector2(size * 0.08, size * 0.2), size * 0.08, 0.0, PI, 8, ink, w * 0.8, true)

func whiskers(c: Vector2, size: float, color: Color) -> void:
	for side in [-1.0, 1.0]:
		for k in 2:
			draw_line(c + Vector2(side * size * 0.45, size * (0.1 + 0.12 * float(k))), c + Vector2(side * size * 1.05, size * (0.02 + 0.2 * float(k))), color, 2.0, true)

func cat_eye(c: Vector2, size: float, iris: Color) -> void:
	var pts := PackedVector2Array()
	for i in 24:
		var a := TAU * float(i) / 24.0
		pts.append(c + Vector2(cos(a) * size, sin(a) * size * 0.55))
	draw_colored_polygon(pts, Color(1.0, 0.95, 0.6, iris.a))
	draw_circle(c, size * 0.5, iris)
	var blink := 0.5 + 0.5 * sin(spin * 3.0)
	draw_colored_polygon(PackedVector2Array([c + Vector2(0.0, -size * 0.5), c + Vector2(size * 0.1 * (0.6 + blink), 0.0), c + Vector2(0.0, size * 0.5), c + Vector2(-size * 0.1 * (0.6 + blink), 0.0)]), Color(0.08, 0.02, 0.12, iris.a))

## เม็ดแสงกลมฟุ้ง (แทนดาวแฉก)
func _star(at: Vector2, size: float, color: Color) -> void:
	draw_circle(at, size * 0.8, Color(color, color.a * 0.35))
	draw_circle(at, size * 0.45, color)

## ลูกกลมหน้าแมว มีแสงฟุ้ง หู และหน้า
func cat_orb(c: Vector2, size: float, a: float) -> void:
	draw_circle(c, size * 1.45, Color(_c(0), 0.18 * a))
	draw_circle(c, size * 1.15, Color(_c(0), 0.35 * a))
	ears(c, size, Color(_c(0), a))
	draw_circle(c, size, Color(_c(0), a))
	draw_circle(c, size * 0.72, Color(_c(1), 0.9 * a))
	face(c, size, Color(INK, a))

func _zig(a: Vector2, b: Vector2, jag: float, seed_no: int) -> PackedVector2Array:
	var pts := PackedVector2Array([a])
	var n := maxi(int(a.distance_to(b) / 40.0), 2)
	var nrm := (b - a).normalized().orthogonal()
	for i in range(1, n):
		var t := float(i) / float(n)
		var s := sin(float(seed_no) * 12.9898 + float(i) * 78.233 + floorf(spin * 18.0)) * 43758.5453
		pts.append(a.lerp(b, t) + nrm * (fmod(absf(s), 1.0) - 0.5) * 2.0 * jag)
	pts.append(b)
	return pts

# ---------------------------------------------------------------- วาด
## เด้งขยายตอนเกิด แล้วหดกลับ
func _pop() -> float:
	var t := clampf(age / 0.18, 0.0, 1.0)
	return 1.0 + 0.3 * sin(t * PI) * (1.0 - t * 0.4)

## แสงฟุ้งรอบชิ้น ประกายดาวกับรอยเท้าลอยรอบ ใช้กับลูกพลัง วงเวท พายุ
func _aura(c: Vector2, size: float, a: float) -> void:
	for k in 3:
		draw_circle(c, size * (1.9 - float(k) * 0.3), Color(_c(0), 0.07 * a))
	for i in 8:
		var ang := spin * (2.0 + float(i % 3)) + float(i) * TAU / 8.0
		var d := size * (1.35 + 0.35 * sin(spin * 3.0 + float(i)))
		var p := c + Vector2(cos(ang), sin(ang)) * d
		if i % 2 == 0:
			_star(p, size * 0.11 + 2.0, Color(_c(1), a * 0.9))
		else:
			paw(p, size * 0.09 + 2.0, Color(_c(0), a * 0.8))

func _draw() -> void:
	var a := _alpha()
	var pop := _pop()
	if kind in ["fire", "ice", "dim", "dark", "bolt_orb", "arcane", "meteor", "potion", "homun", "staff", "bat", "ring"]:
		_aura(Vector2.ZERO, r, a)
	elif kind == "wind":
		_aura(Vector2(0.0, -r * 0.6), r * 0.9, a * 0.8)
	elif kind in ["storm", "smoke", "mem", "field"]:
		_aura(Vector2(0.0, -r * 1.2), r * 1.1, a * 0.8)
	if kind != "chain" and kind != "rays":
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE * pop)
	match kind:
		"fire", "ice", "dim", "dark", "bolt_orb", "arcane":
			_draw_orb(a)
		"trail":
			_draw_trail(a)
		"storm":
			_draw_storm(a)
		"wind":
			_draw_wind(a)
		"meteor":
			_draw_meteor(a)
		"circle":
			_draw_circle_fx(a)
		"pillar":
			_draw_pillar(a)
		"web":
			_draw_web(a)
		"bat":
			_draw_bat(a)
		"smoke":
			_draw_smoke(a)
		"staff":
			_draw_staff(a)
		"boom":
			_draw_boom()
		"ellipse":
			_draw_ellipse()
		"beam":
			_draw_beam(a)
		"chain":
			_draw_chain()
		"field", "mem":
			_draw_field(a)
		"poof":
			_draw_poof()
		"ward":
			_draw_ward(a)
		"charge":
			_draw_charge(a)
		"potion", "bottle":
			_draw_potion(a)
		"cauldron":
			_draw_cauldron(a)
		"rain":
			_draw_rain(a)
		"ore":
			_draw_ore(a)
		"homun":
			_draw_homun(a)
		"ring":
			_draw_ring(a)
		"branch":
			_draw_branch(a)
		"flare":
			_draw_flare(a)
		"rays":
			_draw_rays()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_orb(a: float) -> void:
	# หางประกายด้านหลัง
	for i in 5:
		var k := float(i) / 5.0
		var back := Vector2(-dir * (r * 0.9 + k * r * 1.8), sin(spin * 9.0 + float(i)) * r * 0.25)
		if kind == "ice":
			_star(back, r * 0.28 * (1.0 - k), Color(_c(1), a * (1.0 - k)))
		elif i % 2 == 0:
			paw(back, r * 0.22 * (1.0 - k) + 2.0, Color(_c(0), a * (1.0 - k) * 0.8))
		else:
			draw_circle(back, r * 0.3 * (1.0 - k), Color(_c(0), a * (1.0 - k) * 0.6))
	cat_orb(Vector2.ZERO, r, a)
	if kind == "dark":
		cat_eye(Vector2(0.0, -r * 0.05), r * 0.5, Color(0.7, 0.3, 1.0, a))
	if kind == "ice":
		for i in 3:
			var ang := spin * 1.5 + float(i) * PI / 3.0
			draw_line(Vector2(cos(ang), sin(ang)) * r * 0.55, -Vector2(cos(ang), sin(ang)) * r * 0.55, Color(1.0, 1.0, 1.0, 0.6 * a), 2.5, true)
	if kind == "dim":
		for i in 4:
			var ang := spin * 4.0 + float(i) * TAU / 4.0
			_star(Vector2(cos(ang), sin(ang)) * r * 1.3, r * 0.16, Color(1.0, 1.0, 1.0, a))

func _draw_trail(a: float) -> void:
	# ลูกเลียดพื้น มีฝุ่นรอยเท้าแมวด้านหลัง
	for i in 6:
		var k := float(i) / 6.0
		paw(Vector2(-dir * (20.0 + k * r * 3.0), -4.0), r * 0.3 * (1.0 - k) + 3.0, Color(_c(0), a * (1.0 - k) * 0.6))
	var c := Vector2(0.0, -r * 0.8)
	cat_orb(c, r * 0.8, a)
	if element == "dark":
		cat_eye(c, r * 0.4, Color(0.7, 0.3, 1.0, a))

func _draw_storm(a: float) -> void:
	# กรวยหมุน ยอดเป็นหัวแมว
	var h := r * 3.2
	for i in 9:
		var k := float(i) / 8.0
		var y := -k * h
		var w := r * (0.35 + k * 0.9)
		var ph := spin * 9.0 + k * 5.0
		draw_arc(Vector2(sin(ph) * r * 0.12, y), w, 0.0, TAU, 20, Color(_c(0), a * (0.4 + 0.5 * k)), 5.0, true)
		if i % 3 == 1:
			paw(Vector2(cos(ph) * w, y), r * 0.14, Color(_c(1), a))
	var top := Vector2(0.0, -h - r * 0.2)
	ears(top + Vector2(0.0, r * 0.3), r * 0.8, Color(_c(0), a))
	face(top + Vector2(0.0, r * 0.25), r * 0.6, Color(INK, a))

func _draw_wind(a: float) -> void:
	# พายุลมยักษ์ วงก้นหอยหลายชั้น มีหูแมวกับหนวด
	for i in 4:
		var k := float(i) / 4.0
		var pts := PackedVector2Array()
		for n in 24:
			var t := float(n) / 23.0
			var ang := spin * (6.0 + k * 3.0) + t * TAU * 1.3
			pts.append(Vector2(cos(ang) * r * (0.3 + t * 0.9) * (1.0 - k * 0.2), -r * 0.62 + sin(ang) * r * 0.5 * (0.3 + t * 0.9) - k * r * 0.18))
		draw_polyline(pts, Color(_c(0), a * (0.8 - k * 0.15)), 6.0, true)
	var c := Vector2(0.0, -r * 0.75)
	ears(c + Vector2(0.0, -r * 0.35), r * 0.7, Color(_c(0), a))
	whiskers(c, r * 0.7, Color(_c(1), a))

func _draw_meteor(a: float) -> void:
	# ลูกไฟยักษ์หน้าแมวตกลงมาเฉียงๆ หางไฟยาว
	for i in 7:
		var k := float(i) / 7.0
		var back := Vector2(-dir * k * r * 2.2, -k * r * 3.0)
		draw_circle(back, r * (0.9 - k * 0.6), Color(_c(0), a * (0.6 - k * 0.5)))
	cat_orb(Vector2.ZERO, r, a)

func _draw_circle_fx(a: float) -> void:
	# วงเวทแบนบนพื้น มีรอยเท้าแมวรอบวง หมุนช้าๆ
	var w := rx if rx > 0.0 else r
	var h := ry if ry > 0.0 else r * 0.3
	for k in [1.0, 0.75]:
		var pts := PackedVector2Array()
		for i in 41:
			var ang := TAU * float(i) / 40.0
			pts.append(Vector2(cos(ang) * w * k, sin(ang) * h * k))
		draw_polyline(pts, Color(_c(0), a), 4.0, true)
	var fill := PackedVector2Array()
	for i in 40:
		var ang := TAU * float(i) / 40.0
		fill.append(Vector2(cos(ang) * w, sin(ang) * h))
	draw_colored_polygon(fill, Color(_c(0), 0.18 * a))
	for i in 8:
		var ang := spin * 0.8 + TAU * float(i) / 8.0
		paw(Vector2(cos(ang) * w * 0.87, sin(ang) * h * 0.87), w * 0.06 + 3.0, Color(_c(1), a))
	ears(Vector2(0.0, -h * 0.2), w * 0.18, Color(_c(0), 0.6 * a))

func _draw_pillar(a: float) -> void:
	# เสาน้ำแข็ง ยอดเป็นหูแมว
	var h := r * 3.0 * minf(age / 0.15, 1.0)
	var w := r * 0.7
	draw_colored_polygon(PackedVector2Array([Vector2(-w, 0.0), Vector2(-w * 0.8, -h), Vector2(0.0, -h - w * 0.6), Vector2(w * 0.8, -h), Vector2(w, 0.0)]), Color(_c(0), 0.85 * a))
	draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.3, -4.0), Vector2(-w * 0.25, -h * 0.9), Vector2(w * 0.1, -h * 0.95), Vector2(0.0, -4.0)]), Color(_c(1), 0.7 * a))
	ears(Vector2(0.0, -h + w * 0.2), w * 0.9, Color(_c(0), a), Color(1.0, 1.0, 1.0))
	paw(Vector2(0.0, -6.0), w * 0.45, Color(1.0, 1.0, 1.0, 0.7 * a))

func _draw_web(a: float) -> void:
	# ใยแมงมุมม่วงบนพื้น กลางเป็นรอยเท้าแมว
	var w := r
	var h := r * 0.35
	for i in 10:
		var ang := TAU * float(i) / 10.0
		draw_line(Vector2.ZERO, Vector2(cos(ang) * w, sin(ang) * h), Color(_c(1), a * 0.9), 2.5, true)
	for k in 4:
		var s := float(k + 1) / 4.0
		var pts := PackedVector2Array()
		for i in 11:
			var ang := TAU * float(i) / 10.0
			pts.append(Vector2(cos(ang) * w * s, sin(ang) * h * s))
		draw_polyline(pts, Color(_c(0), a), 2.5, true)
	paw(Vector2(0.0, -4.0), w * 0.12, Color(_c(1), a))

func _draw_bat(a: float) -> void:
	# ค้างคาวหูแมว กระพือปีก
	var flap := sin(spin * 22.0) * 0.5
	for side in [-1.0, 1.0]:
		var root := Vector2(side * r * 0.3, 0.1 * r)
		var tip := Vector2(side * r * 1.45, -r * (0.6 + flap))
		var mid := Vector2(side * r * 1.5, r * (0.2 - flap * 0.4))
		draw_colored_polygon(PackedVector2Array([root, tip, Vector2(side * r * 1.15, -r * 0.05)]), Color(_c(0), a))
		draw_colored_polygon(PackedVector2Array([root, Vector2(side * r * 1.15, -r * 0.05), mid]), Color(_c(0), a))
		draw_colored_polygon(PackedVector2Array([root, mid, Vector2(side * r * 0.6, r * 0.45)]), Color(_c(0), a))
	draw_circle(Vector2.ZERO, r * 0.55, Color(_c(0).darkened(0.2), a))
	ears(Vector2(0.0, -r * 0.05), r * 0.55, Color(_c(0).darkened(0.2), a))
	for side in [-1.0, 1.0]:
		draw_circle(Vector2(side * r * 0.2, -r * 0.08), r * 0.1, Color(1.0, 0.3, 0.4, a))
	draw_colored_polygon(PackedVector2Array([Vector2(-r * 0.12, r * 0.2), Vector2(-r * 0.06, r * 0.36), Vector2(0.0, r * 0.2)]), Color(1.0, 1.0, 1.0, a))
	draw_colored_polygon(PackedVector2Array([Vector2(r * 0.12, r * 0.2), Vector2(r * 0.06, r * 0.36), Vector2(0.0, r * 0.2)]), Color(1.0, 1.0, 1.0, a))

func _draw_smoke(a: float) -> void:
	# ควันมืดทรงสี่เหลี่ยม มีสายฟ้าม่วงชอตลงมา ตาแมวสองดวงในควัน
	var w := r
	var h := r * 1.5
	for i in 10:
		var k := float(i) / 10.0
		var p := Vector2(-w + fmod(k * 7.3, 1.0) * w * 2.0, -h + fmod(k * 3.7, 1.0) * h * 0.9) + Vector2(sin(spin * 2.0 + float(i)) * 6.0, cos(spin * 1.7 + float(i)) * 5.0)
		draw_circle(p, w * 0.42, Color(_c(0).darkened(0.35), 0.55 * a))
	draw_rect(Rect2(Vector2(-w, -h), Vector2(w * 2.0, h)), Color(_c(0).darkened(0.4), 0.35 * a))
	cat_eye(Vector2(-w * 0.3, -h * 0.6), w * 0.16, Color(0.8, 0.4, 1.0, a))
	cat_eye(Vector2(w * 0.3, -h * 0.6), w * 0.16, Color(0.8, 0.4, 1.0, a))
	if fmod(spin, 0.4) < 0.15:
		var x := fmod(spin * 371.0, 1.0) * w * 1.6 - w * 0.8
		draw_polyline(_zig(Vector2(x, -h * 0.4), Vector2(x * 0.8, 0.0), 14.0, 3), Color(_c(1), a), 4.0, true)

func _draw_staff(a: float) -> void:
	# คฑายักษ์หมุนแนวตั้ง หัวคฑามีหูแมว
	var rot := spin * 14.0 * dir
	var tip := Vector2(cos(rot), sin(rot)) * r * 1.8
	draw_line(-tip, tip, Color(0.3, 0.12, 0.35, a), r * 0.22, true)
	draw_line(-tip * 0.95, tip * 0.95, Color(0.55, 0.3, 0.65, a), r * 0.1, true)
	draw_circle(tip, r * 0.5, Color(_c(0), a))
	ears(tip, r * 0.5, Color(_c(0), a))
	cat_eye(tip, r * 0.28, Color(0.8, 0.4, 1.0, a))
	for i in 6:
		var ang := rot - float(i) * 0.18 * dir
		draw_arc(Vector2.ZERO, r * 1.8, ang - 0.05, ang + 0.05, 4, Color(_c(1), a * (0.5 - float(i) * 0.08)), 6.0, true)

func _draw_boom() -> void:
	# ระเบิดวงกลมขยาย มีรอยเท้าแมวกับดาวพุ่งออก
	var k := clampf(age / maxf(life, 0.01), 0.0, 1.0)
	var a := 1.0 - k
	var w := (rx if rx > 0.0 else r) * (0.4 + 0.6 * k)
	var h := (ry if ry > 0.0 else r) * (0.4 + 0.6 * k)
	var pts := PackedVector2Array()
	for i in 40:
		var ang := TAU * float(i) / 40.0
		pts.append(Vector2(cos(ang) * w, sin(ang) * h))
	draw_colored_polygon(pts, Color(_c(0), 0.3 * a))
	pts.append(pts[0])
	draw_polyline(pts, Color(_c(1), a), 8.0 * a + 2.0, true)
	for i in 8:
		var ang := TAU * float(i) / 8.0 + 0.3
		var p := Vector2(cos(ang) * w * 0.85, sin(ang) * h * 0.85)
		if i % 2 == 0:
			paw(p, maxf(w, h) * 0.08 + 4.0, Color(_c(1), a))
		else:
			_star(p, maxf(w, h) * 0.07 + 4.0, Color(1.0, 0.95, 0.6, a))

func _draw_ellipse() -> void:
	_draw_boom()

func _draw_beam(a: float) -> void:
	# ลำแสง/สายฟ้า ไปตามมุม angle กว้าง ry ยาว length
	var u := Vector2(cos(angle), sin(angle))
	var tip := u * length
	var nrm := u.orthogonal()
	var w := ry * (0.85 + 0.15 * sin(spin * 30.0))
	if element.begins_with("bolt"):
		for k in 3:
			draw_polyline(_zig(Vector2.ZERO, tip, w * 0.5, k + 1), Color(_c(0), a * 0.8), w * (0.5 - float(k) * 0.12), true)
		draw_polyline(_zig(Vector2.ZERO, tip, w * 0.3, 7), Color(_c(1), a), w * 0.18, true)
	else:
		draw_colored_polygon(PackedVector2Array([nrm * w, tip + nrm * w, tip - nrm * w, -nrm * w]), Color(_c(0), 0.75 * a))
		draw_colored_polygon(PackedVector2Array([nrm * w * 0.4, tip + nrm * w * 0.4, tip - nrm * w * 0.4, -nrm * w * 0.4]), Color(_c(1), 0.9 * a))
	# ปากลำแสงเป็นหัวแมว ปลายลำแสงเป็นรอยเท้า
	cat_orb(Vector2.ZERO, w * 0.9, a)
	paw(tip, w * 0.6, Color(_c(1), a))

func _draw_chain() -> void:
	var a := 1.0 - clampf(age / maxf(life, 0.01), 0.0, 1.0)
	for i in range(points.size() - 1):
		draw_polyline(_zig(points[i], points[i + 1], 18.0, i + 3), Color(_c(0), a), 9.0, true)
		draw_polyline(_zig(points[i], points[i + 1], 10.0, i + 9), Color(_c(1), a), 3.5, true)
		paw(points[i + 1], 14.0, Color(_c(1), a))

func _draw_field(a: float) -> void:
	# วงใหญ่ มีลูกเล็กหน้าแมวชิ่งไปมาข้างใน
	var w := r
	var h := r * (0.55 if kind == "mem" else 0.45)
	var c := Vector2(0.0, -h)
	var ring := PackedVector2Array()
	for i in 41:
		var ang := TAU * float(i) / 40.0
		ring.append(c + Vector2(cos(ang) * w, sin(ang) * h))
	draw_colored_polygon(ring.slice(0, 40), Color(_c(0), 0.2 * a))
	draw_polyline(ring, Color(_c(0), a), 5.0, true)
	for i in 6:
		var ph := spin * (2.3 + float(i) * 0.37) + float(i) * 1.3
		var p := c + Vector2(sin(ph * 1.7) * w * 0.75, cos(ph * 1.3) * h * 0.7)
		var q := c + Vector2(sin(ph * 1.7 - 0.25) * w * 0.75, cos(ph * 1.3 - 0.25) * h * 0.7)
		draw_line(q, p, Color(_c(1), 0.6 * a), 6.0, true)
		if element.begins_with("bolt"):
			draw_polyline(_zig(q, p, 8.0, i), Color(_c(1), a), 3.0, true)
		ears(p, 14.0, Color(_c(0), a))
		draw_circle(p, 14.0, Color(_c(0), a))
		face(p, 14.0, Color(INK, a))
	if kind == "mem":
		paw(c, w * 0.15, Color(_c(1), 0.7 * a))

func _draw_poof() -> void:
	var k := clampf(age / maxf(life, 0.01), 0.0, 1.0)
	var a := 1.0 - k
	for i in 7:
		var ang := TAU * float(i) / 7.0
		var p := Vector2(cos(ang), sin(ang) * 0.7) * r * (0.3 + k)
		draw_circle(p, r * 0.35 * (1.0 - k * 0.4), Color(_c(1), 0.85 * a))
	_star(Vector2(0.0, -r * 0.2), r * 0.3 * a + 2.0, Color(1.0, 0.9, 0.5, a))
	paw(Vector2(0.0, r * 0.1), r * 0.25 * a + 2.0, Color(_c(0), a))

func _draw_ward(a: float) -> void:
	# ม่านป้องกันรอบตัว ฟองหูแมว
	var pulse := 0.85 + 0.15 * sin(spin * 5.0)
	var c := Vector2(0.0, -r * 0.9)
	draw_circle(c, r * pulse, Color(_c(0), 0.12 * a))
	draw_arc(c, r * pulse, 0.0, TAU, 40, Color(_c(1), 0.7 * a), 4.0, true)
	ears(c + Vector2(0.0, -r * 0.55 * pulse), r * 0.5, Color(_c(0), 0.6 * a))
	for i in 4:
		var ang := spin * 1.5 + TAU * float(i) / 4.0
		paw(c + Vector2(cos(ang), sin(ang)) * r * pulse, 8.0, Color(_c(1), 0.8 * a))

func _draw_potion(a: float) -> void:
	# ขวดยากลม จุกหูแมว ฉลากรอยเท้า  bottle คือขวดวางบนพื้นให้เก็บ เด้งดึ๋งๆ
	var bob := sin(spin * 5.0) * 5.0 if kind == "bottle" else 0.0
	var c := Vector2(0.0, -r + bob)
	if kind == "potion":
		c = Vector2.ZERO
	var tilt := spin * 8.0 * dir if kind == "potion" else 0.0
	draw_set_transform(c, tilt, Vector2.ONE)
	draw_circle(Vector2.ZERO, r * 0.75, Color(1.0, 1.0, 1.0, 0.6 * a))
	draw_circle(Vector2(0.0, r * 0.1), r * 0.62, Color(_c(0), a))
	draw_rect(Rect2(Vector2(-r * 0.22, -r * 1.05), Vector2(r * 0.44, r * 0.4)), Color(1.0, 1.0, 1.0, 0.7 * a))
	draw_rect(Rect2(Vector2(-r * 0.26, -r * 1.25), Vector2(r * 0.52, r * 0.24)), Color(0.72, 0.5, 0.27, a))
	ears(Vector2(0.0, -r * 1.05), r * 0.3, Color(0.72, 0.5, 0.27, a))
	paw(Vector2(0.0, r * 0.05), r * 0.22, Color(_c(1), a))
	draw_circle(Vector2(-r * 0.25, -r * 0.15), r * 0.12, Color(1.0, 1.0, 1.0, 0.7 * a))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if kind == "bottle":
		draw_arc(Vector2(0.0, -4.0), r * 0.9, 0.0, TAU, 24, Color(_c(1), 0.5 * a * (0.5 + 0.5 * sin(spin * 6.0))), 3.0, true)

func _draw_cauldron(a: float) -> void:
	# หม้อปรุงยาหูแมว ไอพิษลอยขึ้น
	var w := r
	draw_colored_polygon(PackedVector2Array([Vector2(-w, -w * 0.9), Vector2(w, -w * 0.9), Vector2(w * 0.8, -w * 0.1), Vector2(w * 0.4, 0.0), Vector2(-w * 0.4, 0.0), Vector2(-w * 0.8, -w * 0.1)]), Color(0.25, 0.22, 0.3, a))
	ears(Vector2(0.0, -w * 0.8), w * 0.7, Color(0.25, 0.22, 0.3, a))
	draw_rect(Rect2(Vector2(-w * 1.05, -w * 1.0), Vector2(w * 2.1, w * 0.15)), Color(0.4, 0.35, 0.45, a))
	draw_circle(Vector2(0.0, -w * 0.95), w * 0.85, Color(_c(0), 0.6 * a))
	face(Vector2(0.0, -w * 0.45), w * 0.5, Color(1.0, 1.0, 1.0, 0.8 * a))
	for i in 5:
		var f := fmod(spin * 0.8 + float(i) * 0.2, 1.0)
		draw_circle(Vector2(sin(f * 6.0 + float(i)) * w * 0.4, -w * (1.1 + f * 3.0)), w * (0.15 + f * 0.25), Color(_c(0), 0.6 * a * (1.0 - f)))

func _draw_rain(a: float) -> void:
	# เมฆพิษเหนือหัว ฝนกรดตกลงมาเป็นเส้น บางหยดเป็นรอยเท้า
	var w := rx if rx > 0.0 else r
	var top := -ry if ry > 0.0 else -r
	for i in 9:
		var x := -w + float(i) / 8.0 * w * 2.0
		draw_circle(Vector2(x, top + sin(float(i) * 1.7) * 14.0), w * 0.16, Color(_c(0).darkened(0.2), 0.75 * a))
	for i in 34:
		var f := fmod(spin * 1.6 + float(i) * 0.137, 1.0)
		var x := -w + fmod(float(i) * 0.618, 1.0) * w * 2.0
		var y := top + 30.0 + f * (-top - 30.0)
		if i % 6 == 0:
			paw(Vector2(x, y), 6.0, Color(_c(0), a))
		else:
			draw_line(Vector2(x, y), Vector2(x - 6.0, y + 26.0), Color(_c(0), 0.85 * a), 3.0, true)

func _draw_ore(a: float) -> void:
	# แร่ผลึกชมพู (หรือเงิน) ผุดจากพื้น ยอดเป็นหูแมว
	var grow := minf(age / 0.18, 1.0)
	var h := r * 2.2 * grow
	if h < 6.0:
		return
	var w := r * 0.8
	for side in [-1.0, 0.0, 1.0]:
		var bx: float = side * w * 0.8
		var hh: float = h * (1.0 if side == 0.0 else 0.65)
		draw_colored_polygon(PackedVector2Array([Vector2(bx - w * 0.45, 0.0), Vector2(bx - w * 0.3, -hh * 0.8), Vector2(bx, -hh), Vector2(bx + w * 0.3, -hh * 0.8), Vector2(bx + w * 0.45, 0.0)]), Color(_c(0), a))
		draw_colored_polygon(PackedVector2Array([Vector2(bx - w * 0.1, -4.0), Vector2(bx - w * 0.05, -hh * 0.85), Vector2(bx + w * 0.12, -hh * 0.8), Vector2(bx + w * 0.08, -4.0)]), Color(_c(1), 0.8 * a))
	ears(Vector2(0.0, -h + w * 0.25), w * 0.55, Color(_c(0), a), Color(1.0, 1.0, 1.0))

func _draw_homun(a: float) -> void:
	# โฮมุนครูสแมวลอยได้ หูเป็นปีก
	var bob := sin(spin * 4.0) * 8.0
	var c := Vector2(0.0, bob)
	var flap := sin(spin * 16.0) * 0.4
	for side in [-1.0, 1.0]:
		var base := c + Vector2(side * r * 0.5, -r * 0.6)
		draw_colored_polygon(PackedVector2Array([base, base + Vector2(side * r * 1.3, -r * (0.7 + flap)), base + Vector2(side * r * 1.1, -r * 0.1), base + Vector2(side * r * 1.25, r * (0.3 - flap * 0.5)), base + Vector2(side * r * 0.3, r * 0.3)]), Color(1.0, 1.0, 1.0, 0.85 * a))
	draw_circle(c, r, Color(0.98, 0.85, 0.55, a))
	ears(c, r, Color(0.98, 0.85, 0.55, a))
	face(c, r, Color(INK, a))
	draw_circle(c + Vector2(0.0, r * 0.95), r * 0.18, Color(1.0, 0.82, 0.3, a))

func _draw_ring(a: float) -> void:
	# ห่วงพิษหมุน มีรอยเท้าแมววนบนห่วง
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 28, Color(_c(0), a), 8.0, true)
	draw_arc(Vector2.ZERO, r * 0.7, 0.0, TAU, 24, Color(_c(1), 0.7 * a), 4.0, true)
	for i in 3:
		var ang := spin * 6.0 + TAU * float(i) / 3.0
		paw(Vector2(cos(ang), sin(ang)) * r, 7.0, Color(_c(1), a))

func _draw_branch(a: float) -> void:
	# ผลึกเงินแตกกิ่ง ขอบเรืองฟ้าเงิน แกนขาว ปลายกิ่งเป็นผลึกเหลี่ยม
	for sg in segs:
		var from: Vector2 = sg[0]
		var to: Vector2 = sg[1]
		var at := float(sg[2])
		if front < at:
			continue
		var seg_len := from.distance_to(to)
		var k := clampf((front - at) / maxf(seg_len, 1.0), 0.0, 1.0)
		var end := from.lerp(to, k)
		var w := 14.0 if absf(to.y - from.y) < 40.0 else 8.0
		draw_line(from, end, Color(0.7, 0.85, 1.0, 0.35 * a), w * 2.4, true)
		draw_line(from, end, Color(0.85, 0.9, 0.98, a), w, true)
		draw_line(from, end, Color(1.0, 1.0, 1.0, a), w * 0.35, true)
		if k >= 1.0:
			var d := (to - from).normalized()
			var n := d.orthogonal()
			var s := w * 1.6
			draw_colored_polygon(PackedVector2Array([to + d * s * 1.6, to + n * s * 0.6, to - d * s * 0.4, to - n * s * 0.6]), Color(0.92, 0.96, 1.0, a))

func _draw_flare(a: float) -> void:
	# วงเวทร่ายใต้เท้า หมุน ขยาย มีลำแสงบางๆ พุ่งขึ้น
	var k := clampf(age / maxf(life, 0.01), 0.0, 1.0)
	var w := rx * (0.6 + 0.6 * k)
	var h := ry * (0.6 + 0.6 * k)
	var fade := a * (1.0 - k * 0.6)
	for ring in [1.0, 0.72, 0.45]:
		var pts := PackedVector2Array()
		for i in 37:
			var ang := TAU * float(i) / 36.0 + spin * (1.5 if ring > 0.7 else -2.0)
			pts.append(Vector2(cos(ang) * w * ring, sin(ang) * h * ring))
		draw_polyline(pts, Color(_c(0), fade), 4.0 * ring + 1.0, true)
	for i in 6:
		var ang := spin * 1.5 + TAU * float(i) / 6.0
		paw(Vector2(cos(ang) * w * 0.86, sin(ang) * h * 0.86), w * 0.07 + 2.0, Color(_c(1), fade))
	for i in 7:
		var x := (float(i) / 6.0 - 0.5) * w * 1.4
		var hh := (60.0 + 90.0 * fmod(float(i) * 0.37, 1.0)) * (1.0 - k)
		draw_line(Vector2(x, 0.0), Vector2(x, -hh), Color(_c(1), 0.45 * fade), 5.0, true)

func _draw_rays() -> void:
	# แสงพุ่งจากจุดระเบิด ยาวสลับสั้น ปลายมนเป็นเม็ดกลม
	var k := clampf(age / maxf(life, 0.01), 0.0, 1.0)
	var a := 1.0 - k
	var reach := (rx if rx > 0.0 else r) * (0.5 + 1.1 * k)
	for i in 12:
		var ang := TAU * float(i) / 12.0 + 0.2
		var len_k := 1.0 if i % 2 == 0 else 0.6
		var u := Vector2(cos(ang), sin(ang) * 0.75)
		var tip := u * reach * len_k
		# แสงพุ่งเป็นแคปซูลปลายมน
		draw_line(Vector2.ZERO, tip, Color(_c(1), 0.75 * a), 20.0 * a + 2.0, true)
		draw_circle(tip, 10.0 * a + 1.0, Color(_c(1), 0.75 * a))
		if i % 2 == 0:
			_star(tip, 9.0 * a + 2.0, Color(1.0, 0.95, 0.6, a))
	draw_circle(Vector2.ZERO, reach * 0.25 * a, Color(1.0, 1.0, 1.0, 0.8 * a))

func _draw_charge(a: float) -> void:
	# รวมพลังที่หัวคฑา จุดแสงไหลเข้า
	var k := clampf(age / maxf(life, 0.01), 0.0, 1.0)
	for i in 8:
		var ang := TAU * float(i) / 8.0 + spin * 3.0
		var p := Vector2(cos(ang), sin(ang)) * r * 2.5 * (1.0 - fmod(k * 2.0 + float(i) * 0.12, 1.0))
		paw(p, 6.0, Color(_c(1), a))
	cat_orb(Vector2.ZERO, r * (0.4 + 0.6 * k), a)
