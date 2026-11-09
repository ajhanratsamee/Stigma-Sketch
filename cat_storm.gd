class_name CatStorm
extends Node2D
## พายุหมุนของสกิล 5.1 กรวยลมสีขาวเทาหมุนวน ฐานมีฝุ่นฟุ้ง มีเศษฝุ่นปลิวขึ้นรอบกรวย เคลื่อนไปข้างหน้า
## ทำดาเมจมอนที่อยู่ในกรวยเป็นจังหวะ วางที่พื้น y 0

const LIFE := 1.8
const SPEED := 280.0
const BANDS := 16
const BAND_GAP := 18.0
const HIT_EVERY := 0.2
const HIT_HALF := 90.0
const DMG := 6.0
# ลมขาวเคลือบแดงนิดๆ
const WIND := Color(1.0, 0.86, 0.86)
const WIND_SHADE := Color(0.86, 0.55, 0.57)
const DUST := Color(0.7, 0.48, 0.42)

var dir := 1.0
var hitter: Callable
var _t := 0.0
var _hit_t := 0.0
var _specks: Array = []   # [มุม ความสูง ความเร็วขึ้น ขนาด]

func _ready() -> void:
	for i in 26:
		_specks.append([randf() * TAU, randf() * BANDS * BAND_GAP, randf_range(60.0, 140.0), randf_range(2.0, 4.0)])

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	position.x += dir * SPEED * delta * (1.0 - _t / LIFE * 0.5)
	_hit_t -= delta
	if _hit_t <= 0.0 and hitter.is_valid() and _t > 0.15:
		_hit_t = HIT_EVERY
		hitter.call(position.x, HIT_HALF, DMG, dir, null, {"kb": 0.6, "stun": 0.3, "air_lift": 3.0})
	for s in _specks:
		s[0] += delta * 7.0
		s[1] += float(s[2]) * delta
		if s[1] > BANDS * BAND_GAP:
			s[1] = 0.0
	queue_redraw()

## ความกว้างของกรวยที่ความสูงนี้ ฐานแคบ ยอดกว้าง ส่ายไปมา
func _band(k: float) -> Vector2:
	var sway := sin(_t * 3.2 + k * 0.45) * k * 1.6
	return Vector2(sway, 14.0 + k * 8.0)

func _draw() -> void:
	var grow := clampf(_t / 0.25, 0.0, 1.0)
	var fade := clampf((LIFE - _t) / 0.4, 0.0, 1.0) * grow
	# ฝุ่นที่ฐาน
	for i in 7:
		var a := _t * 5.0 + float(i) * 0.9
		draw_circle(Vector2(cos(a) * 34.0, -6.0 + sin(a) * 6.0), 20.0 + 6.0 * sin(_t * 4.0 + float(i)), Color(DUST, 0.22 * fade))
	# กรวยลม แต่ละชั้นเป็นวงรีจางๆ มีเส้นลมพาดหมุนวน
	for n in BANDS:
		var k := float(n)
		var band := _band(k)
		var y := -k * BAND_GAP * grow
		var rx := band.y
		var ry := rx * 0.28
		var center := Vector2(band.x, y)
		var body := PackedVector2Array()
		for i in 20:
			var a := TAU * float(i) / 20.0
			body.append(center + Vector2(cos(a) * rx, sin(a) * ry))
		SoftDraw.poly(self, body, Color(WIND_SHADE, 0.07 * fade))
		for streak in 2:
			var start := _t * (9.0 - k * 0.25) + float(streak) * PI + k * 0.6
			var arc := PackedVector2Array()
			for i in 9:
				var a := start + float(i) * 0.2
				arc.append(center + Vector2(cos(a) * rx, sin(a) * ry))
			var front := 0.5 + 0.5 * sin(start + 0.8)
			SoftDraw.pline(self, arc, Color(WIND, (0.25 + 0.45 * front) * fade), 2.5 + front * 1.5, true)
	for s in _specks:
		var k: float = float(s[1]) / BAND_GAP
		var band := _band(k)
		var p := Vector2(band.x + cos(s[0]) * band.y, -float(s[1]) * grow + sin(s[0]) * band.y * 0.28)
		if _specks.find(s) % 4 == 0:
			_cat_paw(p, float(s[3]) * 2.2, Color(1.0, 0.9, 0.9, 0.8 * fade), CAT_BEAN, float(s[0]))
		else:
			draw_circle(p, s[3], Color(DUST.darkened(0.3), 0.7 * fade))
	# ยอดกรวยเป็นหัวแมว มีหูคู่และหน้ายิ้ม
	var top_k := float(BANDS - 1)
	var top_band := _band(top_k)
	var top_c := Vector2(top_band.x, -top_k * BAND_GAP * grow)
	_cat_ears(top_c + Vector2(0.0, -top_band.y * 0.2), top_band.y * 0.55, top_band.y * 0.45, top_band.y * 0.5, Color(WIND, 0.85 * fade), Color(CAT_BEAN, 0.9))
	_cat_face(top_c + Vector2(0.0, BAND_GAP * 2.0), top_band.y * 0.5, Color(WIND_SHADE.darkened(0.4), 0.85 * fade))


# ---------------------------------------------------------------- ลายแมว
const CAT_BEAN := Color(1.0, 0.62, 0.74)

## รอยเท้าแมว อุ้งใหญ่ นิ้วสี่นิ้ว มีถั่วชมพูข้างใน หมุนได้
func _cat_paw(at: Vector2, r: float, base: Color, bean: Color = CAT_BEAN, spin: float = 0.0) -> void:
	# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
	if r < 1.0 or base.a <= 0.01:
		return
	draw_circle(at, r * 0.75, Color(base, base.a * 0.35))
	draw_circle(at, r * 0.45, Color(base, base.a * 0.7))

## หูแมวคู่ ฐานอยู่ที่ center ห่างกัน gap ชี้ไปทาง up
func _cat_ears(center: Vector2, gap: float, w: float, h: float, color: Color, inner: Color = CAT_BEAN, up: Vector2 = Vector2.UP) -> void:
	# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
	pass

## หน้าแมว ตายิ้ม ^ ^ ปาก ω แก้มชมพู
func _cat_face(c: Vector2, r: float, ink: Color) -> void:
	# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
	pass

## หนวดแมวสามเส้นออกจากจุด ไปทาง dir
func _cat_whiskers(at: Vector2, dir_x: float, long: float, color: Color, width: float = 3.0) -> void:
	for n in 3:
		var tilt := (float(n) - 1.0) * 0.22
		var d := Vector2(dir_x * cos(tilt), sin(tilt))
		draw_line(at + d * long * 0.15, at + d * long, color, width, true)

## ก้างปลา หัวสามเหลี่ยม หางสองแฉก
func _fishbone(at: Vector2, long: float, color: Color, spin: float = 0.0) -> void:
	var a := at + Vector2(-long * 0.5, 0.0).rotated(spin)
	var b := at + Vector2(long * 0.32, 0.0).rotated(spin)
	draw_line(a, b, color, maxf(2.0, long * 0.07), true)
	for n in 3:
		var x := -long * 0.3 + float(n) * long * 0.18
		draw_line(at + Vector2(x, -long * 0.16).rotated(spin), at + Vector2(x, long * 0.16).rotated(spin), color, maxf(1.5, long * 0.05), true)
	SoftDraw.poly(self, PackedVector2Array([b + Vector2(0.0, -long * 0.14).rotated(spin), at + Vector2(long * 0.55, 0.0).rotated(spin), b + Vector2(0.0, long * 0.14).rotated(spin)]), color)
	SoftDraw.poly(self, PackedVector2Array([a, a + Vector2(-long * 0.16, -long * 0.16).rotated(spin), a + Vector2(-long * 0.16, long * 0.16).rotated(spin)]), color)


# ---------------------------------------------------------------- ความอลังการ (ภาพล้วน ไม่ยุ่งกับการโดน)
## โหนดขยายใหญ่ขึ้นพร้อมเด้งตอนเกิด มีแสงฟุ้งด้านหลัง วงช็อก ลำแสง และประกายรอยเท้าแมวด้านหน้า
const GRAND_K := 1.35
var _g_t := 0.0
var _g_base := Vector2.ZERO

func _grand_tick(delta: float) -> void:
	if _g_base == Vector2.ZERO:
		_g_base = scale
		if false:  # ไม่ใส่แสงฟุ้ง วงช็อก ลำแสงตกแต่ง (ผู้เล่นบอกว่าเวอร์แปลก)
			var back := _GrandAura.new()
			back.front = false
			back.show_behind_parent = true
			add_child(back)
			var top := _GrandAura.new()
			top.front = true
			add_child(top)
	_g_t += delta
	if GRAND_K != 1.0:
		var k := minf(_g_t / 0.16, 1.0)
		var pop := lerpf(0.78, 1.0, k) + 0.12 * sin(minf(_g_t / 0.32, 1.0) * PI)
		scale = _g_base * GRAND_K * pop

class _GrandAura extends Node2D:
	var front := true
	var _t := 0.0
	const R := 115.0
	const AT := Vector2(0.0, -140.0)
	const LIFE := 1.80
	const RAYS := false
	const SPARK := true
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.82, 0.82)
	func _radius() -> float:
		return R
	func _at() -> Vector2:
		var p := get_parent()
		var d = p.get("dir")
		var s := 1.0
		if d is float and AT.x != 0.0:
			s = signf(d) if d != 0.0 else 1.0
			# โหนดที่พลิกด้วย scale.x แล้ว ไม่ต้องคูณทิศซ้ำ
			if (p as Node2D).scale.x < 0.0:
				s = 1.0
		return Vector2(AT.x * s, AT.y)
	func _draw() -> void:
		var c := _color()
		var r := _radius()
		if r <= 1.0:
			return
		var at := _at()
		var fade := clampf(1.0 - (_t - LIFE * 0.6) / (LIFE * 0.4), 0.0, 1.0) if LIFE < 50.0 else 1.0
		if not front:
			# แสงฟุ้งนุ่มๆ หลายชั้นด้านหลัง เต้นเบาๆ
			var pulse := 1.0 + 0.06 * sin(_t * 9.0)
			for i in 5:
				var k := float(i) / 4.0
				draw_circle(at, r * (1.75 - k * 0.95) * pulse, Color(c, (0.05 + 0.07 * k) * fade))
			draw_circle(at, r * 0.45, Color(1.0, 1.0, 1.0, 0.16 * fade))
			return
		# วงช็อกสองชั้นตอนเกิด
		if RAYS:
			for n in 2:
				var tt := _t - float(n) * 0.09
				if tt > 0.0 and tt < 0.45:
					var k := tt / 0.45
					draw_arc(at, r * (0.5 + 1.5 * k), 0.0, TAU, 40, Color(c.lightened(0.45), (1.0 - k) * 0.85), 12.0 * (1.0 - k) + 2.0, true)
			# ลำแสงพุ่งออกรอบจุดกลาง
			if _t < 0.5:
				var k := _t / 0.5
				for i in 10:
					var ang := float(i) / 10.0 * TAU + _t * 1.5
					var u := Vector2(cos(ang), sin(ang))
					var w := u.orthogonal() * r * 0.07 * (1.0 - k)
					var tip := at + u * r * (1.1 + 1.4 * k)
					draw_circle(tip, r * 0.07 * (1.0 - k) + 1.5, Color(1.0, 0.98, 0.85, 0.55 * (1.0 - k)))
		# ประกายดาวและรอยเท้าแมววนลอยขึ้น
		if SPARK:
			for i in 8:
				var ph := fmod(_t * 0.9 + float(i) * 0.125, 1.0)
				var ang := float(i) * 0.785 + _t * 2.2
				var p := at + Vector2(cos(ang) * r * (0.7 + 0.5 * ph), sin(ang) * r * 0.45 - ph * r * 0.9)
				var a := sin(ph * PI) * 0.9 * fade
				var s := r * 0.07 + 3.0
				if i % 2 == 0:
					var pts := PackedVector2Array()
					for j in 8:
						var aa := -PI * 0.5 + float(j) * PI / 4.0 + _t * 3.0
						pts.append(p + Vector2(cos(aa), sin(aa)) * (s if j % 2 == 0 else s * 0.4))
					SoftDraw.sparkle(self, p, s, Color(1.0, 0.97, 0.7, a))
				else:
					draw_circle(p + Vector2(0.0, s * 0.25), s * 0.55, Color(c.lightened(0.3), a))
					for t in 3:
						draw_circle(p + Vector2((float(t) - 1.0) * s * 0.55, -s * 0.45 - (s * 0.12 if t == 1 else 0.0)), s * 0.24, Color(c.lightened(0.3), a))
