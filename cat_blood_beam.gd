class_name CatBloodBeam
extends Node2D
## DARK KNIGHT 15.3 ลำคลื่นเลือดยิงต่อเนื่องไปข้างหน้า ชาร์จนานยิ่งยาว
## ลำแสงหลายชั้น ขอบหยักเต้น ลูกพลังที่ปากลำ ปลายลำแตกกระเซ็น ทำดาเมจเป็นจังหวะ

const LIFE := 1.1
const GROW := 0.14
const HIT_EVERY := 0.12
const DMG := 5.0
const DARK := Color(0.5, 0.08, 0.22)
const RED := Color(0.92, 0.25, 0.45)
const PINK := Color(1.0, 0.7, 0.8)
const CORE := Color(1.0, 0.92, 0.92)

var dir := 1.0
var length := 600.0
var thick := 60.0
var hitter: Callable
var _t := 0.0
var _hit_t := 0.0
var _drops: Array = []    # [ตำแหน่ง ความเร็ว อายุ]

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	var reach := length * clampf(_t / GROW, 0.0, 1.0)
	_hit_t -= delta
	if _hit_t <= 0.0 and hitter.is_valid():
		_hit_t = HIT_EVERY
		hitter.call(position.x + dir * reach * 0.5, reach * 0.5 + 30.0, DMG, dir, null, {"kb": 0.4, "stun": 0.3})
	for i in 2:
		_drops.append([Vector2(dir * reach, randf_range(-thick, thick) * 0.4), Vector2(dir * randf_range(60.0, 260.0), randf_range(-240.0, 80.0)), 0.0])
	for d in _drops.duplicate():
		d[2] += delta
		d[1] = (d[1] as Vector2) + Vector2(0.0, 900.0) * delta
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		if d[2] > 0.5:
			_drops.erase(d)
	queue_redraw()

func _band(reach: float, half: float, wob: float, seed_f: float) -> PackedVector2Array:
	var top := PackedVector2Array()
	var bottom := PackedVector2Array()
	var steps := 24
	for i in steps + 1:
		var k := float(i) / float(steps)
		var x := dir * reach * k
		var w := half * (0.75 + 0.25 * sin(k * 18.0 - _t * 40.0 + seed_f)) + wob * sin(k * 31.0 + _t * 55.0 + seed_f)
		top.append(Vector2(x, -w))
		bottom.append(Vector2(x, w))
	bottom.reverse()
	top.append_array(bottom)
	return top

func _draw() -> void:
	var reach := length * clampf(_t / GROW, 0.0, 1.0)
	var fade := clampf((LIFE - _t) / 0.2, 0.0, 1.0)
	var half := thick * 0.8 * fade * CatGlow.pop(_t, 0.16)
	# ลำแสงฟุ้งรอบนอกและพื้นเรืองใต้ลำ
	draw_colored_polygon(_band(reach, half * 2.8, 10.0, 5.2), Color(RED, 0.12))
	draw_colored_polygon(_band(reach, half * 2.1, 8.0, 4.4), Color(PINK, 0.16))
	draw_colored_polygon(_band(reach, half * 1.5, 6.0, 0.0), Color(DARK, 0.45))
	draw_colored_polygon(_band(reach, half, 4.0, 1.3), Color(RED, 0.9))
	draw_colored_polygon(_band(reach, half * 0.5, 2.0, 2.6), Color(PINK, 0.95))
	draw_colored_polygon(_band(reach, half * 0.2, 1.0, 3.9), CORE)
	CatGlow.sparkles(self, Vector2(dir * reach * 0.5, 0.0), reach * 0.5, half * 1.4, 18, _t, Color(1.0, 0.95, 0.95, 0.9 * fade), 3.0, 11.0)
	# ลูกพลังที่ปากลำ
	var pulse := 1.0 + 0.12 * sin(_t * 50.0)
	CatGlow.halo(self, Vector2.ZERO, thick * 2.4 * fade, Color(PINK, fade))
	CatGlow.rays(self, Vector2.ZERO, thick * 0.5, thick * 2.6 * fade, 10, Color(1.0, 0.9, 0.92, 0.45 * fade), _t * 4.0)
	draw_circle(Vector2.ZERO, thick * 0.9 * pulse * fade, Color(DARK, 0.5))
	draw_circle(Vector2.ZERO, thick * 0.65 * pulse * fade, RED)
	draw_circle(Vector2.ZERO, thick * 0.35 * pulse * fade, CORE)
	if fade > 0.05:
		var hr := thick * 0.65 * pulse * fade
		CatGlow.ears(self, Vector2.ZERO, hr, RED, PINK)
		CatGlow.face(self, Vector2.ZERO, hr, Color(0.45, 0.05, 0.15))
		CatGlow.whiskers(self, Vector2.ZERO, hr, Color(1.0, 0.9, 0.9, 0.8), 2.0)
	# รอยเท้าแมวไหลไปตามลำ
	for i in 5:
		var k := fposmod(_t * 2.5 + float(i) * 0.2, 1.0)
		if dir * reach * k == 0.0:
			continue
		CatGlow.paw(self, Vector2(dir * reach * k, sin(k * 12.0) * half * 0.15), half * 0.32, Color(PINK, 0.85 * fade), PI * 0.5 * dir)
	# ปลายลำกระแทกกระเซ็น
	var end := Vector2(dir * reach, 0.0)
	CatGlow.halo(self, end, half * 3.2, Color(RED, fade))
	draw_circle(end, half * 1.8, Color(RED, 0.7))
	draw_circle(end, half * 1.0, Color(PINK, 0.9))
	CatGlow.rays(self, end, half * 0.6, half * 3.6, 12, Color(1.0, 0.85, 0.9, 0.55 * fade), -_t * 5.0)
	CatGlow.ring(self, end, half * (2.0 + fposmod(_t * 4.0, 1.0) * 2.0), half * (2.0 + fposmod(_t * 4.0, 1.0) * 2.0), Color(1.0, 0.8, 0.88, 0.6 * fade * (1.0 - fposmod(_t * 4.0, 1.0))), 5.0)
	for d in _drops:
		var k: float = 1.0 - float(d[2]) / 0.5
		draw_circle(d[0], 5.0 + 7.0 * k, Color(RED, k))
