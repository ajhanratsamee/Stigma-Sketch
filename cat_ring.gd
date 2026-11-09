class_name CatRing
extends Node2D
## GRAND KNIGHT 55.1 คลื่นดาบสีแดงขยายเป็นวงรีแนวนอนรอบตัว โดนมอนแต่ละตัวครั้งเดียวเมื่อวงขยายผ่าน
## วางที่ตำแหน่งตัวละครบนพื้น y 0

const LIFE := 0.55
const REACH := 560.0
const RY_K := 0.16
const DMG := 30.0
const RED := Color(1.0, 0.18, 0.15)
const PALE := Color(1.0, 0.85, 0.82)

var hitter: Callable
var extra := {"kb": 0.0, "stun": 2.0, "real_stun": true}
var _t := 0.0
var _hit := {}

func _radius() -> float:
	return REACH * (1.0 - pow(1.0 - clampf(_t / (LIFE * 0.75), 0.0, 1.0), 2.0))

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	if hitter.is_valid():
		hitter.call(position.x, _radius(), DMG, 1.0, _hit, extra)
	queue_redraw()

func _draw() -> void:
	var r := _radius()
	var fade := clampf((LIFE - _t) / 0.25, 0.0, 1.0)
	# แสงวาบกลางตัวตอนปล่อย พื้นเรืองตามวง ลำแสงพุ่งออกรอบตัว
	var flash := clampf(1.0 - _t / 0.25, 0.0, 1.0)
	CatGlow.halo(self, Vector2(0.0, -60.0), 260.0 * (1.0 + (1.0 - flash)), Color(1.0, 0.6, 0.55, flash), 4)
	CatGlow.rays(self, Vector2(0.0, -60.0), 40.0, 380.0 * (1.2 - flash * 0.4), 16, Color(1.0, 0.9, 0.85, 0.5 * flash), 0.15, 0.05)
	CatGlow.glow_oval(self, Vector2(0.0, -50.0), r * 1.08, r * RY_K * 1.6 + 20.0, Color(1.0, 0.4, 0.4, 0.55 * fade), 3)
	# วงที่สองขยายตามหลัง (ภาพเท่านั้น)
	var r2 := r * 1.3
	CatGlow.ring(self, Vector2(0.0, -50.0), r2, r2 * RY_K, Color(PALE, 0.35 * fade), 6.0)
	for n in 3:
		var k := 1.0 - float(n) * 0.08
		var pts := PackedVector2Array()
		for i in 49:
			var a := TAU * float(i) / 48.0
			pts.append(Vector2(cos(a) * r * k, -50.0 + sin(a) * r * k * RY_K))
		draw_polyline(pts, Color(RED, (0.85 - float(n) * 0.2) * fade), 30.0 - float(n) * 7.0, true)
	var core := PackedVector2Array()
	for i in 49:
		var a := TAU * float(i) / 48.0
		core.append(Vector2(cos(a) * r, -50.0 + sin(a) * r * RY_K))
	draw_polyline(core, Color(PALE, 0.85 * fade), 3.0, true)
	# รอยเท้าแมวแปะบนวงที่ขยาย
	for i in 10:
		var a := TAU * float(i) / 10.0 + 0.3
		CatGlow.paw(self, Vector2(cos(a) * r, -50.0 + sin(a) * r * RY_K), 30.0, Color(PALE, 0.9 * fade), a + PI * 0.5, 0.5)
	for i in 16:
		var a := TAU * float(i) / 16.0 + _t * 3.0
		var tw := 0.5 + 0.5 * sin(_t * 20.0 + float(i))
		CatGlow.star4(self, Vector2(cos(a) * r * 1.04, -50.0 + sin(a) * r * RY_K * 1.04 - 10.0), 14.0 * tw, Color(1.0, 0.95, 0.9, fade * tw))
