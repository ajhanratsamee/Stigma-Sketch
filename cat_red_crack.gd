class_name CatRedCrack
extends Node2D
## SWORD KNIGHT 25.1 ปักดาบแล้วดินแตกเป็นรอยร้าวหยักไล่ไปข้างหน้า
## ในรอยมีแสงแดงลาวาเรือง มีลำแสงแดงพุ่งขึ้นเป็นช่วงๆ เศษหินกระเด็นตามรอย ฝุ่นฟุ้ง วางที่พื้น y 0

const LENGTH := 900.0
const RUN_TIME := 0.38
const LIFE := 1.5
const DMG := 18.0
const HIT_HALF := 60.0
const INK := Color(0.16, 0.07, 0.05)
const LAVA := Color(1.0, 0.22, 0.08)
const LAVA_HOT := Color(1.0, 0.75, 0.4)
const ROCK := Color(0.45, 0.36, 0.3)
const DUST := Color(0.62, 0.5, 0.42)

var dir := 1.0
var hitter: Callable
var _t := 0.0
var _path := PackedVector2Array()     # รอยหลัก
var _branches: Array = []             # รอยแตกแขนง [จุดเริ่มบนรอยหลักเป็นสัดส่วน เส้น]
var _rocks: Array = []                # [ตำแหน่ง ความเร็ว ขนาด มุม]
var _dust: Array = []                 # [ตำแหน่ง ขนาด เกิดตอน]
var _shafts: Array = []               # ลำแสง [x เกิดตอน สูง]
var _hit := {}
var _spawned := 0.0

func _ready() -> void:
	var x := 0.0
	_path.append(Vector2.ZERO)
	while x < LENGTH:
		x += randf_range(26.0, 48.0)
		_path.append(Vector2(x * dir, randf_range(-5.0, 6.0)))
	for i in 9:
		var k := randf_range(0.05, 0.95)
		var start := Vector2(LENGTH * k * dir, 0.0)
		var pts := PackedVector2Array([start])
		var at := start
		for n in 3:
			at += Vector2(dir * randf_range(14.0, 30.0), randf_range(-4.0, 8.0) * (1.0 if i % 2 == 0 else -1.0))
			pts.append(at)
		_branches.append([k, pts])

func _front() -> float:
	return LENGTH * clampf(_t / RUN_TIME, 0.0, 1.0)

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	var front := _front()
	# เศษหิน ฝุ่น และลำแสงเกิดตามหัวรอยร้าว
	while _spawned < front:
		_spawned += 40.0
		var px := _spawned * dir
		for n in 2:
			_rocks.append([Vector2(px + randf_range(-10.0, 10.0), -3.0), Vector2(dir * randf_range(-80.0, 200.0), randf_range(-680.0, -320.0)), randf_range(5.0, 13.0), randf() * TAU])
		_dust.append([Vector2(px, -8.0), randf_range(26.0, 44.0), _t])
		if randf() < 0.6:
			_shafts.append([px, _t, randf_range(160.0, 320.0)])
	for r in _rocks:
		r[1] = (r[1] as Vector2) + Vector2(0.0, 1400.0) * delta
		r[0] = (r[0] as Vector2) + (r[1] as Vector2) * delta
		r[3] += delta * 9.0
	if hitter.is_valid() and _t <= RUN_TIME + 0.05:
		hitter.call(position.x + dir * front * 0.5, front * 0.5 + HIT_HALF * 0.5, DMG, dir, _hit, {"type": "launch", "vy": 6.0})
	queue_redraw()

func _draw() -> void:
	var front := _front()
	var fade := clampf((LIFE - _t) / 0.5, 0.0, 1.0)
	var glow := fade * (0.75 + 0.25 * sin(_t * 30.0))
	var shown := PackedVector2Array()
	for p in _path:
		if absf(p.x) <= front:
			shown.append(p)
	# พื้นเรืองลาวาตามรอย และแสงจ้าที่หัวรอยร้าว
	if front > 10.0:
		CatGlow.glow_oval(self, Vector2(dir * front * 0.5, 0.0), front * 0.55, 40.0, Color(LAVA, 0.7 * fade), 3)
	if _t < RUN_TIME + 0.1:
		var head := Vector2(dir * front, -6.0)
		CatGlow.halo(self, head, 160.0, Color(LAVA_HOT, fade), 4)
		CatGlow.rays(self, head, 20.0, 200.0, 10, Color(1.0, 0.85, 0.6, 0.5 * fade), _t * 6.0)
	CatGlow.embers(self, Vector2(dir * front * 0.5, 0.0), maxf(front * 0.5, 20.0), 240.0, 20, _t, Color(1.0, 0.55, 0.25, 0.85 * fade), 17.0, 6.0)
	if shown.size() >= 2:
		draw_polyline(shown, Color(LAVA, 0.25 * glow), 30.0, true)
		draw_polyline(shown, Color(INK, fade), 11.0, true)
		draw_polyline(shown, Color(LAVA, glow), 5.0, true)
		draw_polyline(shown, Color(LAVA_HOT, glow * 0.9), 2.0, true)
	for b in _branches:
		if LENGTH * float(b[0]) <= front:
			draw_polyline(b[1], Color(INK, fade), 4.0, true)
			draw_polyline(b[1], Color(LAVA, glow * 0.7), 1.6, true)
	# รอยเท้าแมวเรืองแดงประทับตามรอยร้าว เดินตามหัวรอย
	var step := 120.0
	var px := step * 0.5
	while px <= front:
		CatGlow.paw(self, Vector2(px * dir, -2.0 + (5.0 if int(px / step) % 2 == 0 else -5.0)), 18.0, Color(LAVA, 0.75 * glow), PI * 0.5 * dir, 0.35)
		px += step
	# ลำแสงแดงพุ่งขึ้นจากรอยแล้วจางลง
	for s in _shafts:
		var age: float = _t - float(s[1])
		var k := clampf(1.0 - age / 0.35, 0.0, 1.0)
		if k <= 0.0:
			continue
		var hgt: float = float(s[2]) * (1.0 - k * 0.3)
		var x: float = s[0]
		draw_colored_polygon(PackedVector2Array([Vector2(x - 34.0, 0.0), Vector2(x - 10.0, -hgt), Vector2(x + 10.0, -hgt), Vector2(x + 34.0, 0.0)]), Color(LAVA, 0.25 * k))
		draw_colored_polygon(PackedVector2Array([Vector2(x - 20.0, 0.0), Vector2(x - 6.0, -hgt), Vector2(x + 6.0, -hgt), Vector2(x + 20.0, 0.0)]), Color(LAVA, 0.4 * k))
		draw_colored_polygon(PackedVector2Array([Vector2(x - 8.0, 0.0), Vector2(x - 2.0, -hgt * 0.9), Vector2(x + 2.0, -hgt * 0.9), Vector2(x + 8.0, 0.0)]), Color(LAVA_HOT, 0.8 * k))
		CatGlow.star4(self, Vector2(x, -hgt), 16.0 * k, Color(1.0, 0.95, 0.85, k))
		CatGlow.paw(self, Vector2(x, -hgt - 12.0), 11.0, Color(LAVA_HOT, 0.8 * k))
	for d in _dust:
		var age: float = _t - float(d[2])
		var k := clampf(age / 0.8, 0.0, 1.0)
		draw_circle((d[0] as Vector2) + Vector2(0.0, -30.0 * k), float(d[1]) * (1.0 + k), Color(DUST, 0.35 * (1.0 - k) * fade))
	for r in _rocks:
		if (r[0] as Vector2).y > 4.0:
			continue
		var pts := PackedVector2Array()
		for i in 5:
			var a: float = float(r[3]) + TAU * float(i) / 5.0
			pts.append((r[0] as Vector2) + Vector2(cos(a), sin(a) * 0.8) * float(r[2]) * (0.8 + 0.2 * sin(float(i) * 2.3)))
		draw_colored_polygon(pts, Color(ROCK, fade))
