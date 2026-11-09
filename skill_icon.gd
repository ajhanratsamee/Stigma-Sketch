class_name SkillIcon
## ไอคอนสกิลแบบแมว วาดในวงกลมสีพาสเทล ขอบหมึก เลือกรูปจากคำในรหัสสกิล
## ใช้ในช่องสกิลและการ์ดในแผงสกิล

const INK := Color(0.36, 0.31, 0.29)
const SOFTEN := 0.3              # พื้นไอคอนผสมครีม ให้เป็นสีพาสเทลนุ่ม
## [คำในรหัส ชนิดรูป สีพื้น] ตรวจตามลำดับ
const RULES := [
	["hyper", "crown", Color(1.0, 0.85, 0.4)],
	["ck_", "drop", Color(1.0, 0.72, 0.8)], ["dk_", "drop", Color(1.0, 0.72, 0.8)],
	["roll", "yarn", Color(1.0, 0.78, 0.8)],
	["curse", "blackcat", Color(0.78, 0.72, 0.9)],
	["roar", "meow", Color(0.85, 0.9, 1.0)], ["loud", "meow", Color(0.85, 0.9, 1.0)], ["horn", "meow", Color(0.85, 0.9, 1.0)], ["rally", "meow", Color(0.85, 0.9, 1.0)], ["taunt", "meow", Color(0.85, 0.9, 1.0)], ["banner", "meow", Color(0.85, 0.9, 1.0)], ["calm", "meow", Color(0.85, 0.9, 1.0)],
	["storm", "swirl", Color(0.8, 0.92, 0.95)], ["vortex", "swirl", Color(1.0, 0.85, 0.7)], ["gust", "swirl", Color(0.8, 0.92, 0.95)], ["whirl", "swirl", Color(0.8, 0.92, 0.95)],
	["wave", "wave", Color(0.8, 0.88, 1.0)], ["trail", "wave", Color(0.8, 0.88, 1.0)], ["ring", "wave", Color(0.8, 0.88, 1.0)],
	["fk_", "flame", Color(1.0, 0.82, 0.65)], ["mk_", "flame", Color(1.0, 0.82, 0.65)], ["fire", "flame", Color(1.0, 0.82, 0.65)],
	["sa", "shield", Color(0.88, 0.9, 0.98)], ["guard", "shield", Color(0.88, 0.9, 0.98)], ["iron", "shield", Color(0.88, 0.9, 0.98)], ["wall", "shield", Color(0.88, 0.9, 0.98)], ["dome", "shield", Color(0.88, 0.9, 0.98)], ["body", "shield", Color(0.88, 0.9, 0.98)], ["bash", "shield", Color(0.88, 0.9, 0.98)], ["sh_", "shield", Color(0.88, 0.9, 0.98)],
	["charge", "claw", Color(1.0, 0.85, 0.8)], ["rush", "claw", Color(1.0, 0.85, 0.8)], ["ram", "claw", Color(1.0, 0.85, 0.8)], ["lunge", "claw", Color(1.0, 0.85, 0.8)], ["stab", "claw", Color(1.0, 0.85, 0.8)], ["spin", "claw", Color(1.0, 0.85, 0.8)], ["cleave", "claw", Color(1.0, 0.85, 0.8)],
	["escape", "dash", Color(0.85, 0.95, 0.85)], ["haste", "dash", Color(0.85, 0.95, 0.85)],
	["sword", "sword", Color(0.92, 0.9, 0.98)], ["sky", "sword", Color(0.92, 0.9, 0.98)], ["blade", "sword", Color(0.92, 0.9, 0.98)], ["crack", "sword", Color(0.92, 0.9, 0.98)], ["hilt", "sword", Color(0.92, 0.9, 0.98)], ["spark", "sword", Color(0.92, 0.9, 0.98)], ["might", "sword", Color(0.92, 0.9, 0.98)], ["aura", "sword", Color(1.0, 0.85, 0.85)],
]

## ไอคอนสกิลของ CAT SUSI (รหัสขึ้นต้น su_)
const SU_RULES := [
	["warp", "dash", Color(0.92, 0.85, 1.0)],
	["ice", "ice", Color(0.82, 0.93, 1.0)], ["pillar", "ice", Color(0.82, 0.93, 1.0)],
	["bolt", "bolt", Color(1.0, 0.95, 0.75)], ["chain", "bolt", Color(1.0, 0.95, 0.75)],
	["dark", "moon", Color(0.82, 0.74, 0.95)], ["bat", "moon", Color(0.82, 0.74, 0.95)], ["web", "moon", Color(0.82, 0.74, 0.95)], ["smoke", "moon", Color(0.82, 0.74, 0.95)], ["void", "moon", Color(0.82, 0.74, 0.95)], ["sky_burst", "moon", Color(0.82, 0.74, 0.95)], ["ec_", "moon", Color(0.82, 0.74, 0.95)], ["dk_", "moon", Color(0.82, 0.74, 0.95)],
	["fire", "flame", Color(1.0, 0.82, 0.65)], ["meteor", "flame", Color(1.0, 0.82, 0.65)],
	["storm", "swirl", Color(0.8, 0.92, 0.95)], ["wind", "swirl", Color(0.8, 0.92, 0.95)],
	["guard", "shield", Color(0.88, 0.9, 0.98)], ["ward", "shield", Color(0.88, 0.9, 0.98)], ["bind", "shield", Color(0.88, 0.9, 0.98)],
	["rage", "meow", Color(1.0, 0.85, 0.8)],
	["mana", "star", Color(0.8, 0.88, 1.0)], ["drain", "star", Color(0.8, 0.88, 1.0)],
	["trail", "wave", Color(0.8, 0.88, 1.0)],
	["al_", "potion", Color(0.85, 0.95, 0.8)], ["tm_", "potion", Color(0.85, 0.95, 0.8)],
]

static func kind_of(id: String) -> Array:
	if id.begins_with("su_"):
		for r in SU_RULES:
			if id.contains(str(r[0])):
				return [r[1], r[2]]
		return ["star", Color(1.0, 0.85, 0.95)]
	var key := id.trim_prefix("cat_")
	for r in RULES:
		if key.contains(str(r[0])):
			return [r[1], r[2]]
	return ["paw", Color(1.0, 0.9, 0.75)]

static func _paw(c: CanvasItem, at: Vector2, r: float, color: Color) -> void:
	var pts := PackedVector2Array()
	for i in 16:
		var a := TAU * float(i) / 16.0
		pts.append(at + Vector2(cos(a) * r * 0.62, sin(a) * r * 0.5 + r * 0.25))
	c.draw_colored_polygon(pts, color)
	for i in 4:
		var a := -2.4 + float(i) * 0.53
		c.draw_circle(at + Vector2(cos(a), sin(a)) * r * 0.82 + Vector2(0.0, r * 0.1), r * 0.22, color)

## วาดไอคอนกึ่งกลางที่ at ขนาดเส้นผ่านศูนย์กลาง size dim คือจาง (ใช้ไม่ได้)
static func draw(c: CanvasItem, at: Vector2, size: float, id: String, dim := false) -> void:
	var r := size * 0.5
	var info := kind_of(id)
	var back: Color = (info[1] as Color).lerp(Color(0.97, 0.95, 0.92), SOFTEN)
	var a := 0.45 if dim else 1.0
	c.draw_circle(at, r, Color(back, a))
	var ink := Color(INK, a)
	var s := r * 0.62
	match str(info[0]):
		"potion":
			c.draw_circle(at + Vector2(0.0, s * 0.2), s * 0.6, Color(0.5, 0.8, 0.3, a))
			c.draw_rect(Rect2(at + Vector2(-s * 0.18, -s * 0.75), Vector2(s * 0.36, s * 0.45)), Color(0.85, 0.95, 1.0, a))
			c.draw_rect(Rect2(at + Vector2(-s * 0.22, -s * 0.95), Vector2(s * 0.44, s * 0.22)), Color(0.72, 0.5, 0.27, a))
			_paw(c, at + Vector2(0.0, s * 0.15), s * 0.35, Color(1.0, 0.75, 0.85, a))
		"ice":
			for k in 3:
				var ang := float(k) * PI / 3.0
				var d := Vector2(cos(ang), sin(ang)) * s
				c.draw_line(at - d, at + d, Color(0.3, 0.6, 0.9, a), 3.0, true)
			c.draw_circle(at, s * 0.2, Color(0.3, 0.6, 0.9, a))
		"bolt":
			c.draw_polyline(PackedVector2Array([at + Vector2(s * 0.2, -s), at + Vector2(-s * 0.35, s * 0.05), at + Vector2(s * 0.15, s * 0.05), at + Vector2(-s * 0.2, s)]), Color(0.95, 0.7, 0.1, a), 4.0, true)
		"moon":
			c.draw_circle(at, s * 0.8, Color(0.45, 0.25, 0.7, a))
			c.draw_circle(at + Vector2(s * 0.35, -s * 0.2), s * 0.65, Color(back, a))
			c.draw_circle(at + Vector2(-s * 0.25, s * 0.1), s * 0.12, Color(1.0, 0.85, 0.3, a))
		"star":
			var pts := PackedVector2Array()
			for i in 10:
				var ang := -PI * 0.5 + float(i) * PI / 5.0
				pts.append(at + Vector2(cos(ang), sin(ang)) * (s if i % 2 == 0 else s * 0.45))
			c.draw_colored_polygon(pts, Color(0.95, 0.45, 0.75, a))
		"paw":
			_paw(c, at + Vector2(0.0, -s * 0.15), s, Color(0.85, 0.45, 0.5, a))
		"yarn":
			c.draw_circle(at, s * 0.85, Color(1.0, 0.5, 0.6, a))
			for k in 3:
				c.draw_arc(at, s * (0.3 + 0.25 * float(k)), 0.4 + float(k), 2.8 + float(k), 10, Color(0.75, 0.25, 0.35, a), 2.0, true)
			c.draw_line(at + Vector2(s * 0.7, s * 0.5), at + Vector2(s * 1.1, s * 0.9), Color(0.75, 0.25, 0.35, a), 2.0, true)
		"wave":
			for k in 3:
				var pts := PackedVector2Array()
				for i in 9:
					var t := float(i) / 8.0
					pts.append(at + Vector2(-s + t * s * 2.0, -s * 0.45 + float(k) * s * 0.45 + sin(t * TAU) * s * 0.18))
				c.draw_polyline(pts, Color(0.3, 0.5, 0.9, a), 3.0, true)
		"swirl":
			var pts := PackedVector2Array()
			for i in 20:
				var t := float(i) / 19.0
				var ang := t * TAU * 1.6
				pts.append(at + Vector2(cos(ang), sin(ang)) * s * (0.15 + t * 0.85))
			c.draw_polyline(pts, Color(0.3, 0.55, 0.65, a), 3.0, true)
		"flame":
			var fl := PackedVector2Array([at + Vector2(0.0, -s), at + Vector2(s * 0.55, -s * 0.1), at + Vector2(s * 0.6, s * 0.45), at + Vector2(0.0, s * 0.8), at + Vector2(-s * 0.6, s * 0.45), at + Vector2(-s * 0.55, -s * 0.1)])
			c.draw_colored_polygon(fl, Color(1.0, 0.45, 0.15, a))
			_paw(c, at + Vector2(0.0, s * 0.2), s * 0.45, Color(1.0, 0.9, 0.5, a))
		"shield":
			var sh := PackedVector2Array([at + Vector2(-s * 0.75, -s * 0.75), at + Vector2(s * 0.75, -s * 0.75), at + Vector2(s * 0.7, s * 0.15), at + Vector2(0.0, s * 0.9), at + Vector2(-s * 0.7, s * 0.15)])
			c.draw_colored_polygon(sh, Color(0.35, 0.5, 0.85, a))
			_paw(c, at + Vector2(0.0, -s * 0.15), s * 0.5, Color(1.0, 0.85, 0.35, a))
		"claw":
			for k in 3:
				var off := (float(k) - 1.0) * s * 0.4
				c.draw_line(at + Vector2(off - s * 0.35, -s * 0.8), at + Vector2(off + s * 0.35, s * 0.8), Color(0.85, 0.25, 0.3, a), 3.5, true)
		"dash":
			_paw(c, at + Vector2(s * 0.2, 0.0), s * 0.6, Color(0.4, 0.7, 0.45, a))
			for k in 3:
				c.draw_line(at + Vector2(-s, -s * 0.35 + float(k) * s * 0.35), at + Vector2(-s * 0.4, -s * 0.35 + float(k) * s * 0.35), Color(0.4, 0.7, 0.45, a), 2.5, true)
		"sword":
			c.draw_line(at + Vector2(-s * 0.6, s * 0.6), at + Vector2(s * 0.7, -s * 0.7), Color(0.6, 0.62, 0.72, a), s * 0.32, true)
			c.draw_circle(at + Vector2(-s * 0.35, s * 0.35), s * 0.28, Color(1.0, 0.65, 0.74, a))
			c.draw_circle(at + Vector2(-s * 0.72, s * 0.72), s * 0.18, Color(1.0, 0.8, 0.3, a))
		"meow":
			c.draw_circle(at + Vector2(-s * 0.2, 0.0), s * 0.6, Color(1.0, 0.75, 0.5, a))
			for side in [-1.0, 1.0]:
				var base := at + Vector2(-s * 0.2 + side * s * 0.35, -s * 0.45)
				c.draw_colored_polygon(PackedVector2Array([base + Vector2(-s * 0.18, 0.0), base + Vector2(side * s * 0.05, -s * 0.35), base + Vector2(s * 0.18, 0.0)]), Color(1.0, 0.75, 0.5, a))
			c.draw_circle(at + Vector2(-s * 0.2, s * 0.15), s * 0.15, ink)
			for k in 2:
				c.draw_arc(at + Vector2(s * 0.25, 0.0), s * (0.45 + 0.3 * float(k)), -0.6, 0.6, 8, Color(0.3, 0.45, 0.85, a), 2.5, true)
		"drop":
			var dr := PackedVector2Array()
			for i in 16:
				var ang := TAU * float(i) / 16.0
				dr.append(at + Vector2(cos(ang) * s * 0.65, s * 0.2 + sin(ang) * s * 0.65))
			dr.append(at + Vector2(0.0, -s))
			c.draw_colored_polygon(dr, Color(0.9, 0.25, 0.45, a))
			_paw(c, at + Vector2(0.0, s * 0.15), s * 0.38, Color(1.0, 0.8, 0.86, a))
		"blackcat":
			c.draw_circle(at + Vector2(0.0, s * 0.1), s * 0.7, Color(0.2, 0.18, 0.24, a))
			for side in [-1.0, 1.0]:
				var base := at + Vector2(side * s * 0.4, -s * 0.35)
				c.draw_colored_polygon(PackedVector2Array([base + Vector2(-s * 0.2, 0.0), base + Vector2(side * s * 0.05, -s * 0.45), base + Vector2(s * 0.2, 0.0)]), Color(0.2, 0.18, 0.24, a))
				c.draw_circle(at + Vector2(side * s * 0.25, 0.0), s * 0.12, Color(0.75, 1.0, 0.4, a))
		"crown":
			var cr := PackedVector2Array([at + Vector2(-s * 0.8, s * 0.5), at + Vector2(-s * 0.8, -s * 0.4), at + Vector2(-s * 0.4, 0.0), at + Vector2(0.0, -s * 0.7), at + Vector2(s * 0.4, 0.0), at + Vector2(s * 0.8, -s * 0.4), at + Vector2(s * 0.8, s * 0.5)])
			c.draw_colored_polygon(cr, Color(1.0, 0.7, 0.2, a))
			_paw(c, at + Vector2(0.0, s * 0.15), s * 0.3, Color(1.0, 0.95, 0.8, a))
	c.draw_arc(at, r, 0.0, TAU, 28, ink, 2.0, true)
