class_name CatBloodPool
extends Node2D
## DARK KNIGHT 30.1 บ่อเลือดกว้างครึ่งจอบนพื้น มีหนามเลือดหลายแบบพุ่งขึ้นทิ่มสลับไปมาต่อเนื่อง
## หนามแต่ละอันทำดาเมจมอนที่อยู่ตรงนั้น วางที่พื้น y 0 จุดกึ่งกลางบ่อ

const WIDTH := 780.0
const DEPTH := 34.0
const LIFE := 3.5
const SPAWN_EVERY := 0.045
const SPIKE_LIFE := 0.42
const DMG := 4.0
const HIT_HALF := 40.0
const POOL := Color(0.45, 0.06, 0.2)
const POOL_SHINE := Color(0.75, 0.18, 0.36)
const SPIKE := Color(0.72, 0.12, 0.32)
const SPIKE_LIGHT := Color(1.0, 0.5, 0.65)

var dir := 1.0
var hitter: Callable
var _t := 0.0
var _spawn := 0.0
var _spikes: Array = []   # [x ชนิด เกิดตอน สูง เอียง ตีแล้ว]

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	_spawn -= delta
	while _spawn <= 0.0 and _t < LIFE - SPIKE_LIFE:
		_spawn += SPAWN_EVERY
		_spikes.append([randf_range(-WIDTH, WIDTH) * 0.45, randi() % 4, _t, randf_range(90.0, 190.0), randf_range(-0.35, 0.35), false])
	for s in _spikes.duplicate():
		var age: float = _t - float(s[2])
		if age > SPIKE_LIFE:
			_spikes.erase(s)
		elif not s[5] and age > 0.08:
			s[5] = true
			if hitter.is_valid():
				hitter.call(position.x + float(s[0]), HIT_HALF, DMG, dir, null, {"kb": 0.2, "stun": 0.35})
	queue_redraw()

## รูปหนามตามชนิด 0 หนามตรง 1 เขี้ยวโค้ง 2 กอสามแฉก 3 เข็มยาวเรียว
func _spike_shape(x: float, kind: int, hgt: float, tilt: float) -> Array:
	var out: Array = []
	var top := Vector2(x + tilt * hgt, -hgt)
	match kind:
		0:
			out.append(PackedVector2Array([Vector2(x - 16.0, 0.0), top, Vector2(x + 16.0, 0.0)]))
		1:
			out.append(PackedVector2Array([Vector2(x - 18.0, 0.0), Vector2(x - 12.0 + tilt * hgt * 0.4, -hgt * 0.5), top + Vector2(18.0, 6.0), Vector2(x + 6.0 + tilt * hgt * 0.5, -hgt * 0.45), Vector2(x + 14.0, 0.0)]))
		2:
			for n in 3:
				var off := float(n - 1) * 16.0
				var h := hgt * (0.65 if n != 1 else 1.0)
				out.append(PackedVector2Array([Vector2(x + off - 10.0, 0.0), Vector2(x + off * 2.2 + tilt * h, -h), Vector2(x + off + 10.0, 0.0)]))
		_:
			out.append(PackedVector2Array([Vector2(x - 7.0, 0.0), Vector2(x + tilt * hgt * 1.3, -hgt * 1.3), Vector2(x + 7.0, 0.0)]))
	return out

func _draw() -> void:
	var open := clampf(_t / 0.2, 0.0, 1.0) * CatGlow.pop(_t, 0.3)
	var fade := clampf((LIFE - _t) / 0.4, 0.0, 1.0)
	# แสงแดงฟุ้งรอบบ่อ กว้างกว่าบ่อ และวงคลื่นเลือดขยายตอนเปิด
	CatGlow.glow_oval(self, Vector2.ZERO, WIDTH * 0.75 * open, DEPTH * 2.6 * open, Color(1.0, 0.3, 0.5, 0.8 * fade), 4)
	var wave := fposmod(_t * 1.2, 1.0)
	CatGlow.ring(self, Vector2.ZERO, WIDTH * 0.5 * (0.8 + wave * 0.6), DEPTH * (0.8 + wave * 0.6) * 1.4, Color(1.0, 0.6, 0.75, 0.6 * (1.0 - wave) * fade), 5.0)
	var pool := PackedVector2Array()
	for i in 40:
		var a := TAU * float(i) / 40.0
		var wob := 1.0 + 0.05 * sin(a * 5.0 + _t * 3.0)
		pool.append(Vector2(cos(a) * WIDTH * 0.5 * open * wob, sin(a) * DEPTH * open * wob))
	SoftDraw.poly(self, pool, Color(POOL, 0.9 * fade))
	var shine := PackedVector2Array()
	for p in pool:
		shine.append(p * Vector2(0.7, 0.45) + Vector2(-20.0, -4.0))
	SoftDraw.poly(self, shine, Color(POOL_SHINE, 0.6 * fade))
	# ฟองเลือดผุดในบ่อ
	for i in 6:
		var x := sin(float(i) * 12.9 + floor(_t * 3.0 + float(i) * 0.3)) * WIDTH * 0.4
		var k := fmod(_t * 3.0 + float(i) * 0.3, 1.0)
		draw_arc(Vector2(x, -2.0), 4.0 + 6.0 * k, PI, TAU, 8, Color(SPIKE_LIGHT, (1.0 - k) * 0.6 * fade), 2.0)
	CatGlow.embers(self, Vector2.ZERO, WIDTH * 0.45, 260.0, 18, _t, Color(1.0, 0.45, 0.6, 0.8 * fade), 4.0, 7.0)
	CatGlow.sparkles(self, Vector2(0.0, -120.0), WIDTH * 0.45, 110.0, 14, _t, Color(1.0, 0.85, 0.9, 0.85 * fade), 5.0, 10.0)
	# รอยเท้าแมวแบนๆ บนผิวบ่อ
	for i in 7:
		var px := (float(i) - 3.0) * WIDTH * 0.12 * open
		CatGlow.paw(self, Vector2(px, -2.0 + (4.0 if i % 2 == 0 else -4.0)), 16.0, Color(SPIKE_LIGHT, 0.55 * fade), PI * 0.5, 0.32)
	for s in _spikes:
		var age: float = _t - float(s[2])
		var rise := clampf(age / 0.09, 0.0, 1.0)
		var sink := clampf((SPIKE_LIFE - age) / 0.15, 0.0, 1.0)
		var hgt: float = float(s[3]) * rise * sink * 1.45
		if hgt < 2.0:
			continue
		# แสงที่ปลายหนามตอนพุ่งขึ้น
		var tip := Vector2(float(s[0]) + float(s[4]) * hgt, -hgt)
		draw_circle(tip, 22.0 * sink, Color(1.0, 0.6, 0.75, 0.3 * sink))
		CatGlow.star4(self, tip, 16.0 * sink * rise, Color(1.0, 0.95, 0.95, 0.85 * sink))
		for shape in _spike_shape(float(s[0]), int(s[1]), hgt, float(s[4])):
			SoftDraw.poly(self, shape, SPIKE)
			var lit := PackedVector2Array()
			for p in shape:
				lit.append(Vector2(lerpf(float(s[0]), p.x, 0.45) - 3.0, p.y))
			SoftDraw.poly(self, lit, Color(SPIKE_LIGHT, 0.6))
			SoftDraw.pline(self, shape, Color(0.15, 0.0, 0.02), 2.0, true)
