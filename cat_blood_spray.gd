class_name CatBloodSpray
extends Node2D
## CRIMSON KNIGHT 45.2 เลือดพุ่งกระจายขึ้นด้านบนจากตัว แล้วตกลงมาเป็นหยด วางที่ตำแหน่งตัวละคร

const LIFE := 1.4

var _t := 0.0
var _drops: Array = []     # [ตำแหน่ง ความเร็ว ขนาด]

func _ready() -> void:
	for i in 110:
		var a := deg_to_rad(randf_range(-160.0, -20.0))
		_drops.append([Vector2(randf_range(-30.0, 30.0), -80.0), Vector2(cos(a), sin(a)) * randf_range(500.0, 1500.0), randf_range(5.0, 15.0)])

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	for d in _drops:
		d[1] = (d[1] as Vector2) + Vector2(0.0, 1400.0) * delta
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
	queue_redraw()

func _draw() -> void:
	var fade := clampf((LIFE - _t) / 0.4, 0.0, 1.0)
	var burst := clampf(1.0 - _t / 0.3, 0.0, 1.0)
	var c := Vector2(0.0, -80.0)
	# น้ำพุเลือดพุ่งขึ้นฟ้า แสงฟุ้ง ลำแสง วงคลื่น
	CatGlow.halo(self, c, 260.0 * (1.2 - burst * 0.4), Color(1.0, 0.3, 0.5, fade), 5)
	CatGlow.rays(self, c, 40.0, 420.0 * (1.0 - burst * 0.4), 14, Color(1.0, 0.75, 0.85, 0.5 * fade), _t * 1.5)
	var w := clampf(_t / 0.6, 0.0, 1.0)
	CatGlow.ring(self, Vector2(0.0, -4.0), 80.0 + 380.0 * w, 20.0 + 60.0 * w, Color(1.0, 0.6, 0.75, 0.7 * (1.0 - w)), 6.0)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-50.0 * fade, 0.0), c + Vector2(-14.0, -640.0 * (1.0 - burst * 0.6)), c + Vector2(14.0, -640.0 * (1.0 - burst * 0.6)), c + Vector2(50.0 * fade, 0.0)]), Color(1.0, 0.4, 0.6, 0.3 * fade))
	CatGlow.sparkles(self, c + Vector2(0.0, -150.0), 260.0, 220.0, 16, _t, Color(1.0, 0.9, 0.95, 0.9 * fade), 6.0, 12.0)
	draw_circle(Vector2(0.0, -80.0), 160.0 * (1.0 - burst * 0.5), Color(0.85, 0.05, 0.1, 0.3 * burst))
	if burst > 0.0:
		CatGlow.ears(self, Vector2(0.0, -80.0), 100.0, Color(0.9, 0.2, 0.4, 0.6 * burst), Color(1.0, 0.7, 0.8, 0.6 * burst))
		CatGlow.face(self, Vector2(0.0, -80.0), 100.0, Color(1.0, 0.85, 0.9, burst))
	var idx := 0
	for d in _drops:
		var p: Vector2 = d[0]
		idx += 1
		if p.y > 4.0:
			continue
		if idx % 6 == 0:
			CatGlow.paw(self, p, float(d[2]) * 1.4, Color(0.95, 0.3, 0.5, fade), (d[1] as Vector2).angle() + PI * 0.5)
			continue
		var v: Vector2 = d[1]
		draw_line(p, p - v.normalized() * float(d[2]) * 2.2, Color(0.6, 0.0, 0.06, fade), float(d[2]) * 0.8, true)
		draw_circle(p, float(d[2]) * 0.5, Color(0.75, 0.02, 0.08, fade))
