class_name CatDome
extends Node2D
## ป้อมปราการโล่ของ SHIELD KNIGHT 35.1 โดมแสงสีแดงอ่อนขนาดใหญ่กินพื้นที่เกือบทั้งจอ เดินตามตัวละคร
## ไม่ผลักมอน มอนที่อยู่ในโดมชะงักตลอด และโดนดาเมจทุก 3 วินาที

const LIFE := 9.0
const RX := 760.0
const RY := 520.0
const STUN_EVERY := 0.3
const DMG_EVERY := 3.0
const DMG := 20.0
const FILL := Color(1.0, 0.4, 0.4, 0.2)
const RIM := Color(1.0, 0.3, 0.3, 0.9)

var target: Node2D
var hitter: Callable
var _t := 0.0
var _stun_t := 0.0
var _dmg_t := DMG_EVERY

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE or not is_instance_valid(target):
		queue_free()
		return
	position = target.position * Vector2(1.0, 0.0)
	_stun_t -= delta
	_dmg_t -= delta
	if _stun_t <= 0.0:
		_stun_t = STUN_EVERY
		for e in get_tree().get_nodes_in_group("monsters"):
			var monster := e as Monster
			if monster != null and absf(monster.position.x - position.x) < RX and monster.state in ["idle", "walk", "flinch", "stun"]:
				monster.state = "flinch"
				monster.state_t = maxf(monster.state_t, STUN_EVERY + 0.1)
	if _dmg_t <= 0.0 and hitter.is_valid():
		_dmg_t = DMG_EVERY
		hitter.call(position.x, RX, DMG, 1.0, null, {"kb": 0.0, "stun": 0.5})
	queue_redraw()

func _draw() -> void:
	var grow := clampf(_t / 0.3, 0.0, 1.0)
	var fade := clampf((LIFE - _t) / 0.4, 0.0, 1.0)
	var pulse := 1.0 + 0.015 * sin(_t * 5.0)
	var rx := RX * grow * pulse * CatGlow.pop(_t, 0.35)
	var ry := RY * grow * pulse * CatGlow.pop(_t, 0.35)
	# พื้นเรืองใต้โดม ไล่สีสามชั้นในโดม
	CatGlow.glow_oval(self, Vector2.ZERO, rx * 1.1, 70.0, Color(1.0, 0.45, 0.45, 0.8 * fade), 4)
	for g in 3:
		var shell := PackedVector2Array()
		var k := 1.0 - float(g) * 0.22
		for i in 33:
			var a := PI + PI * float(i) / 32.0
			shell.append(Vector2(cos(a) * rx * k, sin(a) * ry * k))
		draw_colored_polygon(shell, Color(1.0, 0.55 + 0.12 * float(g), 0.55 + 0.12 * float(g), 0.07 * fade))
	# คลื่นวงแหวนแผ่จากกลางเป็นจังหวะ
	var wave := fposmod(_t * 0.7, 1.0)
	CatGlow.ring(self, Vector2(0.0, -4.0), rx * wave, 40.0 * wave + 8.0, Color(1.0, 0.85, 0.85, 0.6 * (1.0 - wave) * fade), 6.0)
	CatGlow.rays(self, Vector2(0.0, -ry), 20.0, ry * 0.5, 10, Color(1.0, 0.9, 0.85, 0.2 * fade), _t * 0.6)
	CatGlow.sparkles(self, Vector2(0.0, -ry * 0.45), rx * 0.85, ry * 0.45, 24, _t, Color(1.0, 0.92, 0.9, 0.85 * fade), 10.0, 13.0)
	var pts := PackedVector2Array()
	for i in 49:
		var a := PI + PI * float(i) / 48.0
		pts.append(Vector2(cos(a) * rx, sin(a) * ry))
	draw_colored_polygon(pts, Color(FILL, FILL.a * fade))
	# ขอบด้านในเรืองกว่าตรงกลาง
	var inner := PackedVector2Array()
	for p in pts:
		inner.append(p * 0.93)
	draw_polyline(inner, Color(RIM, 0.2 * fade), 18.0, true)
	draw_polyline(pts, Color(1.0, 0.6, 0.6, 0.2 * fade), 30.0, true)
	draw_polyline(pts, Color(RIM, RIM.a * fade), 7.0, true)
	# เส้นแวววับวิ่งบนผิวโดม
	var sweep := fmod(_t * 0.5, 1.0)
	var arc := PackedVector2Array()
	for i in 12:
		var a := PI + PI * clampf(sweep + float(i) * 0.012, 0.0, 1.0)
		arc.append(Vector2(cos(a) * rx * 0.97, sin(a) * ry * 0.97))
	draw_polyline(arc, Color(1.0, 0.9, 0.9, 0.6 * fade), 6.0, true)
	draw_line(Vector2(-rx, 0.0), Vector2(rx, 0.0), Color(RIM, 0.5 * fade), 3.0)
	# หูแมวบนยอดโดม
	for side in [-1.0, 1.0]:
		var ang: float = PI * (1.5 + side * 0.17)
		var base := Vector2(cos(ang) * rx, sin(ang) * ry)
		var up := Vector2(cos(ang), sin(ang) * 1.6).normalized()
		var along := Vector2(-up.y, up.x)
		var ear := PackedVector2Array([base - along * rx * 0.12, base + up * ry * 0.3 + along * side * rx * 0.02, base + along * rx * 0.12])
		draw_colored_polygon(ear, Color(FILL, 0.35 * fade))
		draw_polyline(PackedVector2Array([ear[0], ear[1], ear[2]]), Color(RIM, RIM.a * fade), 5.0, true)
		var mid := (ear[0] + ear[1] + ear[2]) / 3.0
		draw_colored_polygon(PackedVector2Array([ear[0].lerp(mid, 0.5), ear[1].lerp(mid, 0.5), ear[2].lerp(mid, 0.5)]), Color(1.0, 0.7, 0.78, 0.45 * fade))
	# หนวดแมวด้านข้าง และรอยเท้าแมวบนผิวโดม
	for side in [-1.0, 1.0]:
		for i in 3:
			var y := -ry * (0.3 + 0.08 * float(i))
			draw_line(Vector2(side * rx * 0.86, y), Vector2(side * rx * 1.02, y - ry * 0.04 * (float(i) - 1.0)), Color(RIM, 0.55 * fade), 3.0, true)
	for i in 5:
		var a := PI + PI * (0.18 + 0.16 * float(i))
		CatGlow.paw(self, Vector2(cos(a) * rx * 0.8, sin(a) * ry * 0.8), 22.0, Color(1.0, 0.55, 0.6, 0.35 * fade), a + PI * 0.5)
