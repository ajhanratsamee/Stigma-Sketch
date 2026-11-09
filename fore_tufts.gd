class_name ForeTufts
## ชั้นหน้าสุดใกล้กล้อง พุ่มไม้ ใบหญ้า ดอกไม้ ก้อนหิน แบบกระดาษตัดมีเส้นหมึก วางห่างๆ ชิดขอบล่างจอ
## เลื่อนเร็วกว่าพื้น (ตัวคูณ > 1) ให้ฉากมีมิติลึก เตี้ย ไม่บังตัวละคร ทุกรูปทรงมน ไม่มีดาวแฉก

const INK := Color(0.22, 0.18, 0.16)
const FACTOR := 1.35          # เลื่อนเร็วกว่าพื้น
const ALPHA := 0.82           # โปร่งนิดๆ ไม่แย่งสายตา
const MAX_H := 62.0           # สูงสุดเหนือขอบล่างจอ

## ชนิดชั้นหน้าของธีมดันเจี้ยน "" คือไม่มี (ฉากในอาคาร หรือฉากที่มีของวิ่งผ่านอยู่แล้ว)
static func kind_for_theme(theme: String) -> String:
	match theme:
		"meadow", "forest", "ruins", "oasis", "cattree", "waterfall", "canal":
			return "bush"
		"arena":
			return "grass"
		"dunes", "shipwreck", "pyramid":
			return "sand"
		"skislope", "frozenlake", "icecave":
			return "snow"
		"mine", "crater", "lavatunnel", "seacave":
			return "rock"
		"crystal":
			return "crystal"
		"underwater":
			return "seaweed"
		"cloudgarden", "skytemple":
			return "cloud"
	return DungeonLookMore.tufts(theme)

## ชนิดชั้นหน้าของเมือง (ใช้กับชั้นที่มีภูมิประเทศ ซึ่งไม่มีชั้นหน้าแบบเดิม)
static func kind_for_town(style: String) -> String:
	match style:
		"street":
			return "bush"
		"desert":
			return "sand"
		"snow":
			return "snow"
		"lava":
			return "rock"
		"underground":
			return "crystal"
		"sky":
			return "cloud"
	return ""

## วาดชั้นหน้าเต็มช่วง -span..span  bottom คือขอบล่างจอ
static func paint(c: CanvasItem, kind: String, span: float, bottom: float, rng: RandomNumberGenerator) -> void:
	if kind == "":
		return
	var x := -span + rng.randf_range(0.0, 300.0)
	var n := 0
	while x < span:
		var s := rng.randf_range(0.8, 1.15)
		_clump(c, kind, Vector2(x, bottom + 8.0), s, n, rng)
		x += rng.randf_range(520.0, 860.0)
		n += 1

static func _shadowed(c: CanvasItem, at: Vector2, rx: float, ry: float, col: Color) -> void:
	var pts := Sketch.oval(at, rx, ry, 28)
	var sh := PackedVector2Array()
	for p in pts:
		sh.append(p + Vector2(4.0, 5.0))
	c.draw_colored_polygon(sh, Color(0.0, 0.0, 0.0, 0.08 * ALPHA))
	c.draw_colored_polygon(pts, Color(col, ALPHA))
	pts.append(pts[0])
	c.draw_polyline(pts, Color(INK, 0.7 * ALPHA), 2.2, true)

## ใบมนยาว (แคปซูล) ปลายมน หมุนตามมุม
static func _leaf(c: CanvasItem, base: Vector2, ang: float, length: float, w: float, col: Color) -> void:
	var dir := Vector2(sin(ang), -cos(ang))
	var side := Vector2(-dir.y, dir.x)
	var pts := PackedVector2Array()
	for i in 13:
		var t := float(i) / 12.0
		var half := w * sin(t * PI) * 0.5 + w * 0.12
		pts.append(base + dir * length * t + side * half)
	for i in range(12, -1, -1):
		var t := float(i) / 12.0
		var half := w * sin(t * PI) * 0.5 + w * 0.12
		pts.append(base + dir * length * t - side * half)
	c.draw_colored_polygon(pts, Color(col, ALPHA))
	pts.append(pts[0])
	c.draw_polyline(pts, Color(INK, 0.65 * ALPHA), 2.0, true)

static func _clump(c: CanvasItem, kind: String, at: Vector2, s: float, n: int, rng: RandomNumberGenerator) -> void:
	var h := MAX_H * s
	match kind:
		"bush":
			var greens := [Color(0.55, 0.76, 0.5), Color(0.48, 0.7, 0.46), Color(0.62, 0.8, 0.54)]
			var g: Color = greens[n % greens.size()]
			_shadowed(c, at + Vector2(-38.0 * s, -h * 0.35), 40.0 * s, 32.0 * s, g.darkened(0.08))
			_shadowed(c, at + Vector2(36.0 * s, -h * 0.3), 36.0 * s, 28.0 * s, g.darkened(0.04))
			_shadowed(c, at + Vector2(0.0, -h * 0.55), 46.0 * s, 38.0 * s, g)
			# ดอกไม้กลมเล็กๆ บนพุ่ม
			var petals := [Color(1.0, 0.72, 0.8), Color(1.0, 0.9, 0.5), Color(1.0, 1.0, 0.96)]
			for k in 3:
				var p := at + Vector2(rng.randf_range(-44.0, 44.0) * s, -h * rng.randf_range(0.45, 0.85))
				c.draw_circle(p, 7.0 * s, Color(petals[(n + k) % 3], ALPHA))
				c.draw_arc(p, 7.0 * s, 0.0, TAU, 14, Color(INK, 0.55 * ALPHA), 1.6, true)
				c.draw_circle(p, 2.6 * s, Color(1.0, 0.8, 0.35, ALPHA))
		"grass":
			var g2 := Color(0.6, 0.78, 0.48)
			for k in 5:
				_leaf(c, at + Vector2((float(k) - 2.0) * 14.0 * s, 0.0), (float(k) - 2.0) * 0.28, h * rng.randf_range(0.75, 1.0), 14.0 * s, g2.darkened(0.06 * float(k % 2)))
		"sand":
			_shadowed(c, at + Vector2(0.0, -h * 0.15), 90.0 * s, 34.0 * s, Color(0.97, 0.86, 0.64))
			for k in 3:
				var p2 := at + Vector2((float(k) - 1.0) * 34.0 * s, -h * 0.42 - rng.randf_range(0.0, 8.0))
				_shadowed(c, p2, 9.0 * s, 7.0 * s, Color(0.86, 0.72, 0.56))
		"snow":
			_shadowed(c, at + Vector2(0.0, -h * 0.18), 96.0 * s, 36.0 * s, Color(0.98, 0.99, 1.0))
			_shadowed(c, at + Vector2(40.0 * s, -h * 0.6), 16.0 * s, 16.0 * s, Color(1.0, 1.0, 1.0))
			_shadowed(c, at + Vector2(14.0 * s, -h * 0.55), 11.0 * s, 11.0 * s, Color(0.94, 0.97, 1.0))
		"rock":
			_shadowed(c, at + Vector2(-26.0 * s, -h * 0.3), 46.0 * s, 30.0 * s, Color(0.66, 0.62, 0.62))
			_shadowed(c, at + Vector2(30.0 * s, -h * 0.22), 34.0 * s, 24.0 * s, Color(0.74, 0.7, 0.68))
		"crystal":
			var cc: Color = [Color(0.78, 0.7, 0.98), Color(0.65, 0.85, 1.0)][n % 2]
			_leaf(c, at + Vector2(-16.0 * s, 0.0), -0.3, h * 0.8, 26.0 * s, cc)
			_leaf(c, at, 0.05, h, 30.0 * s, cc.lightened(0.1))
			_leaf(c, at + Vector2(18.0 * s, 0.0), 0.35, h * 0.7, 24.0 * s, cc.darkened(0.06))
		"seaweed":
			var sw := Color(0.42, 0.72, 0.6)
			for k in 3:
				_leaf(c, at + Vector2((float(k) - 1.0) * 22.0 * s, 0.0), (float(k) - 1.0) * 0.2 + rng.randf_range(-0.1, 0.1), h * rng.randf_range(0.9, 1.25), 18.0 * s, sw.darkened(0.05 * float(k)))
			for k in 3:
				var b := at + Vector2(rng.randf_range(-30.0, 40.0) * s, -h * (1.1 + 0.3 * float(k)))
				c.draw_arc(b, (5.0 + float(k) * 2.0) * s, 0.0, TAU, 14, Color(1.0, 1.0, 1.0, 0.6 * ALPHA), 2.0, true)
		"cloud":
			for k in 3:
				_shadowed(c, at + Vector2((float(k) - 1.0) * 52.0 * s, -h * (0.3 + 0.15 * float(k % 2))), 44.0 * s, 30.0 * s, Color(1.0, 1.0, 1.0))
