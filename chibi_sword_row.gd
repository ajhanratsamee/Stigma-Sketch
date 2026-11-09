class_name ChibiSwordRow
extends Node2D
## สกิล MAGIC KNIGHT เรียกดาบใบกว้างสีแดงส้ม 10 เล่ม โผล่จากดินเรียงกันด้านหน้า เว้นช่องเล็กน้อย
## เห็นเฉพาะใบดาบปลายแหลมชี้ขึ้น ผุดทีละเล่มจากใกล้ไปไกลจนครบ ค้างไว้ แล้วหดลงดิน

const COUNT := 10
const HIT_DMG := 18.0
const BODY_W := 76.0              # ความกว้างลำตัวตัวละคร
const BLADE_W := 86.0 + BODY_W * 3.0
const GAP := 20.0                # ช่องว่างระหว่างใบดาบ
const BLADE_H := 380.0
const TIP_H := 120.0
const FULLER_W := 44.0
const LIFE := 2.5
const STAGGER := 0.15            # แต่ละเล่มผุดหลังเล่มก่อนแทบจบ จึงเห็นทีละเล่ม
const RISE := 0.16
const SINK := 0.2
const OVERSHOOT := 1.12
const FILL := Color(1.0, 0.33, 0.07)
const LIGHT := Color(1.0, 0.68, 0.32)
const OUTLINE := 3.5
const SCRIBBLE := 2.0

var dir := 1.0
var blade_w := BLADE_W          # กว้างแต่ละเล่ม ตั้งก่อนใส่ฉาก
var hitter: Callable             # เรียกเมื่อทำดาเมจ
var _swords_hit := 0
var _t := 0.0

func _ready() -> void:
	scale.x = dir

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	var due := mini(int(_t / STAGGER) + 1, COUNT)
	while _swords_hit < due and hitter.is_valid():
		hitter.call(position.x + dir * sword_x(_swords_hit), blade_w * 0.5, HIT_DMG, dir)
		_swords_hit += 1
	queue_redraw()

## ระยะกึ่งกลางเล่มที่ i จากจุดเริ่ม
func sword_x(i: int) -> float:
	return (blade_w + GAP) * float(i) + blade_w * 0.5

## ความสูงของเล่มที่ i ตามเวลา 0 ถึงประมาณ 1
func height_k(i: int) -> float:
	var age := _t - STAGGER * float(i)
	if age <= 0.0:
		return 0.0
	if age < RISE:
		return lerpf(0.0, OVERSHOOT, age / RISE)
	if age < RISE * 1.5:
		return lerpf(OVERSHOOT, 1.0, (age - RISE) / (RISE * 0.5))
	if _t > LIFE - SINK:
		return (LIFE - _t) / SINK
	return 1.0

## ใบดาบเวทเลื่อนขึ้นจากดิน ส่วนที่ยังอยู่ใต้ดินไม่แสดง มีเศษดินกระเด็นตอนผุด
func _draw_sword(x: float, k: float, i: int) -> void:
	var length := maxf(BLADE_H, blade_w * 2.4)
	var lift := length * maxf(1.0 - k, 0.0)
	draw_set_transform(Vector2(x, 0.0), 0.0, Vector2.ONE * 1.3)
	for n in 3:
		draw_circle(Vector2(0.0, -length * 0.45 + lift), blade_w * (1.25 - float(n) * 0.3), Color(1.0, 0.55, 0.2, (0.06 + 0.05 * float(n)) * minf(k, 1.0)))
	if k < 1.0:
		draw_arc(Vector2.ZERO, blade_w * (0.6 + 1.2 * k), PI, TAU, 24, Color(1.0, 0.85, 0.5, 1.0 - k), 8.0 * (1.0 - k) + 1.0, true)
	MagicBlade.draw_blade(self, length, blade_w, blade_w * 1.15, 1.0, lift, 0.0)
	# รอยเท้าแมวประทับบนพื้นข้างโคนดาบ
	_cat_paw(Vector2(blade_w * 0.62, -8.0), 11.0, Color(FILL, 0.75 * minf(k, 1.0)), Color(1.0, 0.85, 0.7))
	var age := _t - STAGGER * float(i)
	if age < 0.35:
		var fly := age / 0.35
		for n in 6:
			var a := PI * (0.15 + 0.7 * float(n) / 5.0)
			var p := Vector2(cos(a) * blade_w * 0.6 * (0.4 + fly), -sin(a) * 120.0 * fly + 260.0 * fly * fly)
			if n % 3 == 1:
				_cat_paw(p, 7.0 * (1.0 - fly) + 3.0, LIGHT, FILL)
			else:
				draw_circle(p, 7.0 * (1.0 - fly) + 2.0, Color(0.45, 0.34, 0.26))
	draw_set_transform(Vector2.ZERO)

func _draw() -> void:
	for i in COUNT:
		var k := height_k(i)
		if k > 0.02:
			_draw_sword(sword_x(i), k, i)


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
const GRAND_K := 1.00
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
	const R := 0.0
	const AT := Vector2.ZERO
	const LIFE := 1.00
	const RAYS := false
	const SPARK := false
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.5, 0.25)
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
