class_name CatBloodAura
extends Node2D
## DARK KNIGHT 30.2 เลือดอาบรอบตัวตอนพุ่ง หยดเลือดและไอแดงหมุนวนรอบตัว ทิ้งหยดไว้ตามทาง
## เดินตามเป้าหมาย หายเองเมื่อหมดเวลา

const LIFE := 0.9
const RED := Color(0.9, 0.25, 0.45)
const MIST := Color(1.0, 0.45, 0.6)

var target: Node2D
var _t := 0.0
var _trail: Array = []    # [ตำแหน่งในโลก ความเร็ว อายุ ขนาด]

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE + 0.5 or not is_instance_valid(target):
		queue_free()
		return
	if _t < LIFE:
		position = target.position
		for i in 3:
			_trail.append([position + Vector2(randf_range(-50.0, 50.0), randf_range(-120.0, -10.0)), Vector2(randf_range(-80.0, 80.0), randf_range(-160.0, -40.0)), 0.0, randf_range(3.0, 7.0)])
	for d in _trail.duplicate():
		d[2] += delta
		d[1] = (d[1] as Vector2) + Vector2(0.0, 800.0) * delta
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		if d[2] > 0.6:
			_trail.erase(d)
	queue_redraw()

func _draw() -> void:
	var on := clampf((LIFE - _t) / 0.2, 0.0, 1.0) * clampf(CatGlow.pop(_t, 0.18), 0.0, 1.3)
	if on > 0.0:
		CatGlow.glow_oval(self, Vector2(0.0, -4.0), 150.0, 30.0, Color(RED, 0.7 * on))
		CatGlow.halo(self, Vector2(0.0, -70.0), 150.0, Color(MIST, on), 5)
		CatGlow.ring(self, Vector2(0.0, -70.0), 120.0 + 14.0 * sin(_t * 14.0), 100.0, Color(1.0, 0.75, 0.85, 0.5 * on), 5.0)
		for i in 10:
			var a := _t * 9.0 + TAU * float(i) / 10.0
			var p := Vector2(cos(a) * 100.0, -70.0 + sin(a) * 76.0)
			draw_circle(p, 36.0, Color(MIST, 0.16 * on))
			CatGlow.paw(self, p * 0.92, 15.0, Color(RED, 0.9 * on), a + PI * 0.5)
		CatGlow.embers(self, Vector2(0.0, 0.0), 90.0, 220.0, 14, _t, Color(1.0, 0.55, 0.7, 0.85 * on), 2.0, 7.0)
		CatGlow.sparkles(self, Vector2(0.0, -80.0), 130.0, 100.0, 12, _t, Color(1.0, 0.92, 0.95, 0.9 * on), 1.0, 10.0)
	for d in _trail:
		var k: float = 1.0 - float(d[2]) / 0.6
		draw_circle((d[0] as Vector2) - position, float(d[3]) * k * 1.6, Color(RED, k))
