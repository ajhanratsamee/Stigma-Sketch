class_name MonsterLook
extends RefCounted
## หน้าตามอนหลายแบบ ไม่ใช่แคปซูล วาดเส้นหมึกระบายสี ด้านล่างสุดอยู่ที่พื้น y = 0
## ใต้ท้องเข้มกว่าด้านบนให้ดูมีมิติ

const LOOKS := ["slime", "mushroom", "wolf", "bat", "treant", "scorpion", "golem", "crab"]
const TOP := {"slime": 96.0, "mushroom": 128.0, "wolf": 118.0, "bat": 190.0, "treant": 200.0, "scorpion": 104.0, "golem": 190.0, "crab": 96.0}

static func top(look: String) -> float:
	if CatLook.TOP.has(look):
		return CatLook.top(look)
	return float(TOP.get(look, 140.0))

static func draw(c: CanvasItem, look: String, t: float, face: float, ink: Color) -> void:
	match look:
		"slime": _slime(c, t, ink)
		"mushroom": _mushroom(c, t, face, ink)
		"wolf": _wolf(c, t, face, ink)
		"bat": _bat(c, t, face, ink)
		"treant": _treant(c, t, face, ink)
		"scorpion": _scorpion(c, t, face, ink)
		"golem": _golem(c, t, face, ink)
		"crab": _crab(c, t, face, ink)

static func _part(c: CanvasItem, pts: PackedVector2Array, color: Color, seed_no: int, ink: Color, step := 8.0) -> void:
	c.draw_colored_polygon(pts, Sketch.PAPER)
	Sketch.hatch(c, pts, color, seed_no, step)
	pts.append(pts[0])
	Sketch.line(c, pts, seed_no + 1, 2.8, 0.4, ink)

static func _eye(c: CanvasItem, at: Vector2, r: float, face: float, ink: Color) -> void:
	c.draw_circle(at, r, Color.WHITE)
	c.draw_arc(at, r, 0.0, TAU, 14, ink, 2.2, true)
	c.draw_circle(at + Vector2(face * r * 0.35, 0.0), r * 0.5, ink)

static func _slime(c: CanvasItem, t: float, ink: Color) -> void:
	var squash := sin(t * 4.0) * 5.0
	var pts := PackedVector2Array()
	for i in 21:
		var a := PI + PI * float(i) / 20.0
		pts.append(Vector2(cos(a) * (62.0 + squash), sin(a) * (86.0 - squash) - 6.0))
	pts.append(Vector2(62.0 + squash, 0.0))
	pts.append(Vector2(-62.0 - squash, 0.0))
	_part(c, pts, Color(0.36, 0.72, 0.4), 3100, ink)
	Sketch.line(c, PackedVector2Array([Vector2(-34.0, -62.0), Vector2(-22.0, -74.0)]), 3102, 5.0, 0.2, Color.WHITE)
	_eye(c, Vector2(-18.0, -44.0), 11.0, 1.0, ink)
	_eye(c, Vector2(18.0, -44.0), 11.0, 1.0, ink)

static func _mushroom(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var sway := sin(t * 2.5) * 4.0
	_part(c, PackedVector2Array([Vector2(-26.0, 0.0), Vector2(-20.0, -62.0), Vector2(20.0, -62.0), Vector2(26.0, 0.0)]), Color(0.9, 0.8, 0.62), 3104, ink)
	var cap := PackedVector2Array()
	for i in 21:
		var a := PI + PI * float(i) / 20.0
		cap.append(Vector2(cos(a) * 60.0 + sway, sin(a) * 66.0 - 60.0))
	_part(c, cap, Color(0.84, 0.2, 0.2), 3106, ink)
	for s in [[-28.0, -92.0, 9.0], [10.0, -108.0, 11.0], [34.0, -80.0, 7.0]]:
		c.draw_circle(Vector2(float(s[0]) + sway, float(s[1])), float(s[2]), Color.WHITE)
	_eye(c, Vector2(face * 8.0 - 9.0, -38.0), 8.0, face, ink)
	_eye(c, Vector2(face * 8.0 + 9.0, -38.0), 8.0, face, ink)

static func _wolf(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var run := sin(t * 8.0) * 8.0
	var f := face
	var fur := Color(0.46, 0.44, 0.5)
	for i in 4:
		var x := f * (-46.0 + float(i) * 30.0)
		var swing := run if i % 2 == 0 else -run
		Sketch.line(c, PackedVector2Array([Vector2(x, -36.0), Vector2(x + swing, 0.0)]), 3108 + i, 7.0, 0.3, ink)
	_part(c, PackedVector2Array([Vector2(f * -66.0, -74.0), Vector2(f * 20.0, -82.0), Vector2(f * 48.0, -58.0), Vector2(f * 36.0, -30.0), Vector2(f * -58.0, -30.0)]), fur, 3112, ink)
	_part(c, PackedVector2Array([Vector2(f * -60.0, -68.0), Vector2(f * -96.0, -94.0 + run), Vector2(f * -74.0, -56.0)]), fur, 3114, ink, 5.0)
	_part(c, PackedVector2Array([Vector2(f * 28.0, -84.0), Vector2(f * 38.0, -116.0), Vector2(f * 52.0, -92.0), Vector2(f * 92.0, -70.0), Vector2(f * 56.0, -52.0), Vector2(f * 30.0, -56.0)]), fur, 3116, ink, 6.0)
	_eye(c, Vector2(f * 54.0, -78.0), 6.0, f, ink)

static func _bat(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var y := -140.0 + sin(t * 3.0) * 12.0
	var flap := sin(t * 14.0) * 26.0
	var skin := Color(0.42, 0.26, 0.58)
	for s in [-1.0, 1.0]:
		var side := float(s)
		_part(c, PackedVector2Array([Vector2(side * 14.0, y - 8.0), Vector2(side * 66.0, y - 36.0 - flap), Vector2(side * 96.0, y - 4.0 - flap), Vector2(side * 66.0, y + 2.0 - flap * 0.5), Vector2(side * 44.0, y + 18.0 - flap * 0.3), Vector2(side * 14.0, y + 12.0)]), skin, 3118, ink, 7.0)
		_part(c, PackedVector2Array([Vector2(side * 6.0, y - 26.0), Vector2(side * 18.0, y - 50.0), Vector2(side * 24.0, y - 20.0)]), skin, 3120, ink, 5.0)
	_part(c, Sketch.oval(Vector2(0.0, y), 28.0, 30.0, 18), skin, 3122, ink, 6.0)
	_eye(c, Vector2(face * 2.0 - 10.0, y - 6.0), 7.0, face, ink)
	_eye(c, Vector2(face * 2.0 + 10.0, y - 6.0), 7.0, face, ink)

static func _treant(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var sway := sin(t * 1.8) * 5.0
	var bark := Color(0.46, 0.3, 0.16)
	for s in [-1.0, 1.0]:
		Sketch.line(c, PackedVector2Array([Vector2(float(s) * 20.0, -30.0), Vector2(float(s) * 42.0, 0.0)]), 3124, 10.0, 0.5, ink)
		Sketch.line(c, PackedVector2Array([Vector2(float(s) * 34.0, -110.0), Vector2(float(s) * 78.0, -80.0 + sway * float(s)), Vector2(float(s) * 92.0, -52.0)]), 3125, 9.0, 0.5, ink)
	_part(c, PackedVector2Array([Vector2(-44.0, -22.0), Vector2(-36.0, -140.0), Vector2(36.0, -140.0), Vector2(44.0, -22.0)]), bark, 3126, ink, 9.0)
	for blob in [[-44.0, -160.0, 44.0], [40.0, -164.0, 46.0], [0.0, -192.0, 52.0]]:
		_part(c, Sketch.oval(Vector2(float(blob[0]) + sway, float(blob[1])), float(blob[2]), float(blob[2]) * 0.8, 18), Color(0.24, 0.56, 0.26), 3128, ink, 12.0)
	_eye(c, Vector2(face * 6.0 - 14.0, -106.0), 10.0, face, ink)
	_eye(c, Vector2(face * 6.0 + 14.0, -106.0), 10.0, face, ink)
	Sketch.line(c, PackedVector2Array([Vector2(-16.0, -74.0), Vector2(0.0, -66.0), Vector2(16.0, -74.0)]), 3130, 3.0, 0.4, ink)

static func _scorpion(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var f := face
	var shell := Color(0.76, 0.5, 0.2)
	var wave := sin(t * 6.0) * 6.0
	for i in 3:
		for s in [-1.0, 1.0]:
			var x := -24.0 + float(i) * 24.0
			Sketch.line(c, PackedVector2Array([Vector2(x, -18.0), Vector2(x + float(s) * 16.0, -30.0), Vector2(x + float(s) * 22.0 + wave * float(s) * 0.4, 0.0)]), 3131 + i, 3.2, 0.2, ink)
	_part(c, Sketch.oval(Vector2(0.0, -24.0), 54.0, 22.0, 20), shell, 3134, ink)
	var tail := PackedVector2Array([Vector2(f * -48.0, -28.0), Vector2(f * -78.0, -48.0), Vector2(f * -76.0, -82.0), Vector2(f * -48.0, -100.0 + wave), Vector2(f * -22.0, -88.0 + wave)])
	Sketch.line(c, tail, 3136, 11.0, 0.3, ink)
	Sketch.line(c, tail, 3137, 7.0, 0.3, shell)
	for s in [-1.0, 1.0]:
		_part(c, Sketch.oval(Vector2(f * (64.0 + float(s) * 2.0), -22.0 + float(s) * 14.0), 18.0, 10.0, 12), shell, 3138, ink, 5.0)
	_eye(c, Vector2(f * 34.0, -34.0), 6.0, f, ink)

static func _golem(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var stone := Color(0.56, 0.54, 0.5)
	var step := sin(t * 3.0) * 4.0
	for s in [-1.0, 1.0]:
		_part(c, PackedVector2Array([Vector2(float(s) * 16.0, -56.0), Vector2(float(s) * 50.0, -56.0), Vector2(float(s) * 54.0, 0.0), Vector2(float(s) * 12.0, 0.0)]), stone, 3140, ink, 10.0)
		_part(c, PackedVector2Array([Vector2(float(s) * 54.0, -140.0), Vector2(float(s) * 92.0, -130.0), Vector2(float(s) * 100.0, -54.0 + step * float(s)), Vector2(float(s) * 62.0, -50.0 + step * float(s))]), stone, 3142, ink, 10.0)
	_part(c, PackedVector2Array([Vector2(-58.0, -52.0), Vector2(-64.0, -146.0), Vector2(64.0, -146.0), Vector2(58.0, -52.0)]), stone, 3144, ink, 12.0)
	_part(c, PackedVector2Array([Vector2(-32.0, -146.0), Vector2(-30.0, -188.0), Vector2(30.0, -188.0), Vector2(32.0, -146.0)]), Color(0.66, 0.64, 0.6), 3146, ink, 8.0)
	c.draw_circle(Vector2(face * 10.0, -168.0), 8.0, Color(0.96, 0.4, 0.2))
	Sketch.line(c, PackedVector2Array([Vector2(-24.0, -110.0), Vector2(-6.0, -96.0), Vector2(-16.0, -80.0)]), 3148, 2.6, 0.3, ink)

static func _crab(c: CanvasItem, t: float, face: float, ink: Color) -> void:
	var shell := Color(0.44, 0.72, 0.88)
	var snap := sin(t * 5.0) * 8.0
	for s in [-1.0, 1.0]:
		var side := float(s)
		for i in 3:
			Sketch.line(c, PackedVector2Array([Vector2(side * (28.0 + float(i) * 8.0), -28.0), Vector2(side * (56.0 + float(i) * 10.0), -34.0), Vector2(side * (62.0 + float(i) * 10.0), 0.0)]), 3150 + i, 3.4, 0.2, ink)
		Sketch.line(c, PackedVector2Array([Vector2(side * 40.0, -52.0), Vector2(side * 70.0, -82.0)]), 3153, 6.0, 0.2, ink)
		_part(c, PackedVector2Array([Vector2(side * 62.0, -82.0), Vector2(side * 88.0, -108.0 - snap), Vector2(side * 76.0, -82.0), Vector2(side * 96.0, -74.0 + snap), Vector2(side * 74.0, -64.0)]), shell, 3154, ink, 5.0)
	_part(c, Sketch.oval(Vector2(0.0, -40.0), 58.0, 32.0, 22), shell, 3156, ink)
	for s in [-1.0, 1.0]:
		Sketch.line(c, PackedVector2Array([Vector2(float(s) * 14.0, -68.0), Vector2(float(s) * 16.0, -86.0)]), 3158, 3.0, 0.2, ink)
		_eye(c, Vector2(float(s) * 16.0, -92.0), 7.0, face, ink)
