class_name ChibiWave
extends Node2D
## คลื่นแดงพุ่งขึ้นฟ้า ล่างแคบบนกว้าง ปากคลื่นวิ่งทะลุขอบจอ มีแถบและหยดวิ่งขึ้น
## ตอนจบฐานหลุดจากพื้นพุ่งตามขึ้นไป

const LIFE := 0.95
const HIT_GAP := 0.14
const HIT_COUNT := 4
const RISE := 0.22               # เวลาที่ปากคลื่นพุ่งถึงยอด
const LAUNCH := 0.7              # เวลาที่ฐานเริ่มหลุดจากพื้น
const HEIGHT := 720.0            # สูงกว่าขอบจอบน
const LOW_RX := 30.0
const TOP_RX := 130.0
const LOW_Y := -6.0
const TOP_SQUASH := 0.2
const LOW_SQUASH := 0.3
const FLARE := 1.5               # ยิ่งมาก ยิ่งบานเฉพาะช่วงบน
const STEPS := 16
const BASE_STEPS := 12

const STREAKS := 7
const STREAK_SPEED := 1250.0
const STREAK_LONG := 95.0
const STREAK_LOW_W := 7.0
const STREAK_TOP_W := 15.0
const STREAK_SPREAD := 0.68

const DROPS := 8
const DROP_CYCLE := 0.45
const DROP_SPEED := 1150.0
const DROP_OUT := 22.0
const DROP_R := 11.0

const FILL := Color(0.96, 0.04, 0.08)
const LIGHT := Color(1.0, 0.48, 0.44)
const OUTLINE := 3.5
const SCRIBBLE := 2.6            # ความขยุกขยิกของเส้น

var height := HEIGHT
var top_width := TOP_RX
var hitter: Callable             # เรียกเมื่อทำดาเมจ
var hit_half := 100.0
var hit_dmg := 12.0
var _hits_done := 0
var _t := 0.0

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	var due := mini(int(_t / HIT_GAP) + 1, HIT_COUNT)
	while _hits_done < due and hitter.is_valid():
		_hits_done += 1
		hitter.call(position.x, hit_half, hit_dmg, 1.0)
	queue_redraw()

## ความกว้างครึ่งหนึ่งที่ระยะ up จากพื้น
func _rx(up: float) -> float:
	return lerpf(LOW_RX, top_width, pow(clampf(up / height, 0.0, 1.0), FLARE))

func _top_up() -> float:
	var k := minf(_t / RISE, 1.0)
	return height * (1.0 - (1.0 - k) * (1.0 - k))

func _low_up() -> float:
	if _t <= LAUNCH:
		return 0.0
	var k := (_t - LAUNCH) / (LIFE - LAUNCH)
	return height * k * k

func _draw_body(low: float, top: float) -> void:
	var body := PackedVector2Array()
	for i in range(STEPS, -1, -1):
		var up := lerpf(low, top, float(i) / float(STEPS))
		body.append(Vector2(-_rx(up), LOW_Y - up))
	var low_rx := _rx(low)
	for i in range(1, BASE_STEPS):
		var a := PI * (1.0 - float(i) / float(BASE_STEPS))
		body.append(Vector2(cos(a) * low_rx, LOW_Y - low + sin(a) * low_rx * LOW_SQUASH))
	for i in STEPS + 1:
		var up := lerpf(low, top, float(i) / float(STEPS))
		body.append(Vector2(_rx(up), LOW_Y - up))
	SoftDraw.poly(self, body, FILL)
	SoftDraw.sketch_line(self, body, 620, OUTLINE, SCRIBBLE)

## แถบสว่างวิ่งขึ้นในตัวคลื่น
func _draw_streaks(low: float, top: float) -> void:
	for n in STREAKS:
		var head := fposmod(_t * STREAK_SPEED + float(n) * 311.0, height + STREAK_LONG)
		var a := maxf(head - STREAK_LONG, low)
		var b := minf(head, top)
		if b <= a:
			continue
		var f := lerpf(-STREAK_SPREAD, STREAK_SPREAD, fposmod(float(n) * 0.382, 1.0))
		var thick := lerpf(STREAK_LOW_W, STREAK_TOP_W, b / height)
		var from := Vector2(f * _rx(a), LOW_Y - a)
		var to := Vector2(f * _rx(b), LOW_Y - b)
		SoftDraw.sketch_line(self, PackedVector2Array([from, to]), 630 + n, thick, SCRIBBLE, LIGHT)

## หยดกลมพุ่งขึ้นข้างตัวคลื่น
func _draw_drops() -> void:
	if _t > LAUNCH:
		return
	for n in DROPS:
		var age := fposmod(_t - float(n) * DROP_CYCLE / float(DROPS), DROP_CYCLE)
		var up := age * DROP_SPEED * height / HEIGHT
		var side := -1.0 if n % 2 == 0 else 1.0
		var at := Vector2(side * (_rx(up) + DROP_OUT + float(n % 3) * 12.0), LOW_Y - up)
		var r := DROP_R + float(n % 3) * 4.0
		if n % 2 == 1:
			_cat_paw(at, r * 0.85, LIGHT, FILL)
			continue
		var drop := Sketch.oval(at, r, r, 16)
		SoftDraw.poly(self, drop, LIGHT)
		drop.append(drop[0])
		SoftDraw.sketch_line(self, drop, 640 + n, OUTLINE, SCRIBBLE * 0.5)

func _draw() -> void:
	var top := _top_up()
	var low := _low_up()
	_draw_drops()
	if top - low < 1.0:
		return
	_draw_body(low, top)
	_draw_streaks(low, top)
	var top_rx := _rx(top)
	var mouth := Sketch.oval(Vector2(0.0, LOW_Y - top), top_rx, top_rx * TOP_SQUASH, 32)
	SoftDraw.poly(self, mouth, LIGHT)
	mouth.append(mouth[0])
	SoftDraw.sketch_line(self, mouth, 621, OUTLINE, SCRIBBLE)
	# ปากคลื่นเป็นหัวแมว มีหูคู่
	_cat_ears(Vector2(0.0, LOW_Y - top - top_rx * TOP_SQUASH * 0.5), top_rx * 0.6, top_rx * 0.45, top_rx * 0.55, FILL, LIGHT)


# ---------------------------------------------------------------- ลายแมว
const CAT_BEAN := Color(1.0, 0.62, 0.74)

## รอยเท้าแมว อุ้งใหญ่ นิ้วสี่นิ้ว มีถั่วชมพูข้างใน หมุนได้
func _cat_paw(at: Vector2, r: float, base: Color, bean: Color = CAT_BEAN, spin: float = 0.0) -> void:
	if r < 1.0 or base.a <= 0.01:
		return
	var pad := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in 14:
		var a := TAU * float(i) / 14.0
		pad.append(at + Vector2(cos(a) * r, sin(a) * r * 0.8 + r * 0.3).rotated(spin))
		inner.append(at + Vector2(cos(a) * r * 0.58, sin(a) * r * 0.45 + r * 0.36).rotated(spin))
	SoftDraw.poly(self, pad, base)
	SoftDraw.poly(self, inner, Color(bean, bean.a * base.a))
	for t in 4:
		var ang := -PI * 0.5 + (float(t) - 1.5) * 0.52
		var toe := at + (Vector2(cos(ang), sin(ang)) * r * 1.15).rotated(spin)
		draw_circle(toe, r * 0.34, base)
		draw_circle(toe, r * 0.2, Color(bean, bean.a * base.a))

## หูแมวคู่ ฐานอยู่ที่ center ห่างกัน gap ชี้ไปทาง up
func _cat_ears(center: Vector2, gap: float, w: float, h: float, color: Color, inner: Color = CAT_BEAN, up: Vector2 = Vector2.UP) -> void:
	if color.a <= 0.01 or h < 1.0:
		return
	var side_v := Vector2(-up.y, up.x)
	for s in [-1.0, 1.0]:
		var base: Vector2 = center + side_v * gap * s
		var tri := PackedVector2Array([base - side_v * w * 0.5, base + up * h + side_v * w * 0.12 * s, base + side_v * w * 0.5])
		SoftDraw.poly(self, tri, color)
		var mid := (tri[0] + tri[1] + tri[2]) / 3.0
		SoftDraw.poly(self, PackedVector2Array([tri[0].lerp(mid, 0.5), tri[1].lerp(mid, 0.4), tri[2].lerp(mid, 0.5)]), Color(inner, inner.a * color.a))

## หน้าแมว ตายิ้ม ^ ^ ปาก ω แก้มชมพู
func _cat_face(c: Vector2, r: float, ink: Color) -> void:
	if ink.a <= 0.01 or r < 4.0:
		return
	var w := maxf(1.5, r * 0.09)
	for s in [-1.0, 1.0]:
		var e: Vector2 = c + Vector2(s * r * 0.36, -r * 0.1)
		SoftDraw.pline(self, PackedVector2Array([e + Vector2(-r * 0.13, r * 0.07), e + Vector2(0.0, -r * 0.07), e + Vector2(r * 0.13, r * 0.07)]), ink, w, true)
		draw_circle(c + Vector2(s * r * 0.58, r * 0.14), r * 0.11, Color(1.0, 0.55, 0.62, 0.55 * ink.a))
	var m := c + Vector2(0.0, r * 0.18)
	draw_arc(m + Vector2(-r * 0.09, 0.0), r * 0.09, 0.0, PI, 8, ink, w * 0.85, true)
	draw_arc(m + Vector2(r * 0.09, 0.0), r * 0.09, 0.0, PI, 8, ink, w * 0.85, true)

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
	const R := 130.0
	const AT := Vector2(0.0, -220.0)
	const LIFE := 0.95
	const RAYS := true
	const SPARK := true
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.3, 0.25)
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
