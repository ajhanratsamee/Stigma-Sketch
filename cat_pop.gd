class_name CatPop
extends Node2D
## ลูกเล่นน่ารักแบบแมวตอนปล่อยสกิล วงแสงขยาย ดาววิ้งปลิวหมุน รอยเท้าแมวลอยขึ้น สีตามสาย
## paw_hit เป็นรอยเท้าแมวใหญ่เด้งขึ้นตรงจุดที่สกิลโดนมอน

const LIFE := 0.6

var tint := Color(1.0, 0.4, 0.35)
var paw_hit := false
var _t := 0.0
var _stars: Array = []     # [ตำแหน่ง ความเร็ว มุม ขนาด]
var _paws: Array = []      # [ตำแหน่ง ความเร็ว มุม]

func _ready() -> void:
	var stars := 4 if paw_hit else 8
	for i in stars:
		var a := TAU * float(i) / float(stars) + randf() * 0.4
		_stars.append([Vector2.ZERO, Vector2(cos(a), sin(a)) * randf_range(220.0, 420.0), randf() * TAU, randf_range(10.0, 18.0)])
	if not paw_hit:
		for i in 3:
			_paws.append([Vector2(randf_range(-60.0, 60.0), randf_range(-20.0, 20.0)), Vector2(randf_range(-60.0, 60.0), randf_range(-220.0, -140.0)), randf_range(-0.5, 0.5)])

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	for s in _stars:
		s[1] = (s[1] as Vector2) * 0.9
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
		s[2] += delta * 8.0
	for p in _paws:
		p[0] = (p[0] as Vector2) + (p[1] as Vector2) * delta
	queue_redraw()

## หัวใจเล็กๆ ปลิวหมุน (แทนดาวแฉก)
func _star(c: Vector2, r: float, turn: float, color: Color) -> void:
	var pts := PackedVector2Array()
	var rot := Transform2D(turn * 0.3, c)
	for i in 24:
		var t := TAU * float(i) / 24.0
		var p := Vector2(16.0 * pow(sin(t), 3.0), -(13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t))) * (r / 16.0)
		pts.append(rot * p)
	draw_colored_polygon(pts, color)

## รอยเท้าแมว อุ้งใหญ่หนึ่งก้อน นิ้วสี่ก้อน
func _paw(c: Vector2, r: float, turn: float, fill: Color, edge: Color) -> void:
	var rot := Transform2D(turn, c)
	var pads := [[Vector2(0.0, 0.25), 0.55], [Vector2(-0.55, -0.3), 0.24], [Vector2(-0.2, -0.62), 0.25], [Vector2(0.2, -0.62), 0.25], [Vector2(0.55, -0.3), 0.24]]
	for pad in pads:
		var at: Vector2 = rot * ((pad[0] as Vector2) * r)
		draw_circle(at, float(pad[1]) * r + 3.0, edge)
	for pad in pads:
		var at: Vector2 = rot * ((pad[0] as Vector2) * r)
		draw_circle(at, float(pad[1]) * r, fill)

func _draw() -> void:
	var k := _t / LIFE
	var fade := 1.0 - k
	if paw_hit:
		var pop := 1.0 + 0.35 * sin(minf(_t / 0.15, 1.0) * PI)
		_paw(Vector2.ZERO, 30.0 * pop, -0.2, Color(1.0, 1.0, 1.0, fade), Color(tint, fade))
	else:
		var r := 40.0 + 150.0 * (1.0 - pow(1.0 - k, 2.0))
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, Color(tint, 0.7 * fade), 8.0 * fade + 1.0, true)
		draw_circle(Vector2.ZERO, r * 0.6, Color(1.0, 1.0, 1.0, 0.25 * fade))
		for p in _paws:
			_paw(p[0], 16.0, p[2], Color(1.0, 0.75, 0.8, fade), Color(tint, fade))
	for s in _stars:
		_star(s[0], float(s[3]) * (1.0 - k * 0.6), s[2], Color(1.0, 0.95, 0.5, fade))
		draw_circle(s[0], float(s[3]) * 0.25, Color(1.0, 1.0, 1.0, fade))


# ---------------------------------------------------------------- ความอลังการ (ภาพล้วน ไม่ยุ่งกับการโดน)
## โหนดขยายใหญ่ขึ้นพร้อมเด้งตอนเกิด มีแสงฟุ้งด้านหลัง วงช็อก ลำแสง และประกายรอยเท้าแมวด้านหน้า
const GRAND_K := 1.45
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
	const R := 75.0
	const AT := Vector2.ZERO
	const LIFE := 0.60
	const RAYS := true
	const SPARK := false
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		var v = get_parent().get("tint")
		return v if v is Color else Color(1.0, 0.5, 0.4)
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
					# แสงพุ่งเป็นแคปซูลปลายมน ไม่ใช่แฉกแหลม
					var rc := Color(1.0, 0.98, 0.85, 0.55 * (1.0 - k))
					draw_line(at + u * r * 0.3, tip, rc, maxf(2.0, w.length() * 2.0), true)
					draw_circle(tip, maxf(1.0, w.length()), rc)
		# ประกายดาวและรอยเท้าแมววนลอยขึ้น
		if SPARK:
			for i in 8:
				var ph := fmod(_t * 0.9 + float(i) * 0.125, 1.0)
				var ang := float(i) * 0.785 + _t * 2.2
				var p := at + Vector2(cos(ang) * r * (0.7 + 0.5 * ph), sin(ang) * r * 0.45 - ph * r * 0.9)
				var a := sin(ph * PI) * 0.9 * fade
				var s := r * 0.07 + 3.0
				if i % 2 == 0:
					# ประกายกลมฟุ้ง ไม่มีดาวแฉก
					draw_circle(p, s * 0.9, Color(1.0, 0.97, 0.7, a * 0.35))
					draw_circle(p, s * 0.5, Color(1.0, 0.97, 0.7, a))
				else:
					draw_circle(p + Vector2(0.0, s * 0.25), s * 0.55, Color(c.lightened(0.3), a))
					for t in 3:
						draw_circle(p + Vector2((float(t) - 1.0) * s * 0.55, -s * 0.45 - (s * 0.12 if t == 1 else 0.0)), s * 0.24, Color(c.lightened(0.3), a))
