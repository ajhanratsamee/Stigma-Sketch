class_name CatCrack
extends Node2D
## พื้นแตกตอนกระโดดทุ่ม รอยแตกบนพื้น เศษหินกระเด็นแล้วตกกองรอบๆ และไอสีแดงลอยขึ้นรอบตัว
## วางที่จุดลงพื้น y 0 คือพื้น

const LIFE := 1.8
const CRACK := Color(0.28, 0.18, 0.12)
const ROCK := Color(0.52, 0.44, 0.38)
const ROCK_DARK := Color(0.36, 0.3, 0.26)
const MIST := Color(0.92, 0.12, 0.12)

var big := false                 # พื้นแตกวงกว้าง รอยยาวขึ้น หินเยอะขึ้นและกระเด็นไกล
var mist_only := false           # แค่ไอแดงลอยรอบตัวตอนกระโดด ยังไม่มีพื้นแตก
var lava := false                # ไอสีลาวาแดงส้มของสาย SWORD KNIGHT แบบเดียวกับ 25.1
const LAVA_MIST := Color(1.0, 0.3, 0.08)
var no_rays := false             # ไม่วาดรังสีแฉกรอบจุดทุบ (hyper GUARDIAN)
var smoke_only := false          # แค่ควันจางๆ ลอยฟุ้งรอบจุดทุบ ไม่มีรอยแตกกับหิน
const SMOKE := Color(0.95, 0.35, 0.3)  # ควันแดงให้เห็นชัด
var _t := 0.0
var _cracks: Array = []   # เส้นรอยแตก
var _rocks: Array = []    # [ตำแหน่ง ความเร็ว ขนาด มุม ลงพื้นแล้ว]
var _mist: Array = []     # [ตำแหน่ง ความเร็ว ขนาด]

func _ready() -> void:
	if smoke_only:
		for i in 16:
			var a := randf_range(PI * 0.05, PI * 0.95)
			_mist.append([Vector2(randf_range(-40.0, 40.0), -6.0), Vector2(cos(a) * randf_range(-160.0, 160.0), -sin(a) * randf_range(20.0, 70.0)), randf_range(16.0, 28.0)])
		return
	if not mist_only:
		_make_cracks()
	for i in 22:
		_mist.append([Vector2(randf_range(-180.0, 180.0), randf_range(-30.0, 0.0)), Vector2(randf_range(-60.0, 60.0), randf_range(-130.0, -50.0)), randf_range(24.0, 46.0)])

func _make_cracks() -> void:
	for side in [-1.0, 1.0]:
		for n in (5 if big else 3):
			var pts := PackedVector2Array([Vector2.ZERO])
			var at := Vector2.ZERO
			for k in (9 if big else 5):
				at += Vector2(side * randf_range(18.0, 36.0) * (1.6 if big else 1.0), randf_range(-5.0, 7.0) + float(n - 2 if big else n - 1) * 3.0)
				pts.append(at)
			_cracks.append(pts)
	var power := 1.6 if big else 1.0
	for i in (54 if big else 22):
		var a := randf_range(PI * 0.15, PI * 0.85)
		_rocks.append([Vector2(randf_range(-30.0, 30.0) * power, -4.0), Vector2(cos(a) * randf_range(-260.0, 260.0) * power, -sin(a) * randf_range(250.0, 480.0) * (1.2 if big else 1.0)), randf_range(5.0, 12.0) * (1.3 if big else 1.0), randf() * TAU, false])

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	for r in _rocks:
		if r[4]:
			continue
		r[1] = (r[1] as Vector2) + Vector2(0.0, 1300.0) * delta
		r[0] = (r[0] as Vector2) + (r[1] as Vector2) * delta
		r[3] += delta * 8.0
		if (r[0] as Vector2).y >= 0.0:
			r[0] = Vector2((r[0] as Vector2).x, -float(r[2]) * 0.4)
			r[4] = true
	for m in _mist:
		m[0] = (m[0] as Vector2) + (m[1] as Vector2) * delta
		m[1] = (m[1] as Vector2) * (0.96 if smoke_only else 1.0)
		m[2] += delta * (30.0 if smoke_only else 22.0)
	queue_redraw()

func _rock_shape(size: float, turn: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 6:
		var a := turn + TAU * float(i) / 6.0
		pts.append(Vector2(cos(a), sin(a) * 0.75) * size * (0.75 + 0.25 * sin(float(i) * 2.7)))
	return pts

func _draw() -> void:
	var fade := clampf((LIFE - _t) / 0.5, 0.0, 1.0)
	var hue := LAVA_MIST if lava else MIST
	if not mist_only and not smoke_only:
		# พื้นเรืองร้อนใต้จุดทุบ วงคลื่นกระแทกสองชั้น ลำแสงพุ่งขึ้น
		var w := clampf(_t / 0.5, 0.0, 1.0)
		var span := 420.0 if big else 280.0
		CatGlow.glow_oval(self, Vector2.ZERO, span * 1.1, 46.0, Color(hue, 0.8 * fade), 4)
		for g in 2:
			var gw := clampf(w - float(g) * 0.18, 0.0, 1.0)
			if gw > 0.0:
				CatGlow.ring(self, Vector2(0.0, -4.0), span * (0.3 + gw * 1.1), 30.0 + gw * 46.0, Color(1.0, 0.85, 0.7, 0.75 * (1.0 - gw)), 9.0 - float(g) * 3.0)
		if not no_rays:
			CatGlow.rays(self, Vector2(0.0, -10.0), 30.0, span * 1.1 * (1.0 - w * 0.4), 12, Color(1.0, 0.8, 0.6, 0.35 * (1.0 - w)), 0.2)
		CatGlow.embers(self, Vector2.ZERO, span * 0.7, 300.0, 16, _t, Color(1.0, 0.6, 0.3, 0.85 * fade), 9.0, 7.0)
	for m in _mist:
		var k := _t / LIFE
		draw_circle(m[0], m[2], Color(SMOKE, 0.28 * (1.0 - k) * fade) if smoke_only else Color(LAVA_MIST if lava else MIST, 0.32 * (1.0 - k) * fade))
	for pts in _cracks:
		SoftDraw.pline(self, pts, Color(hue, 0.35 * fade), 16.0, true)
		SoftDraw.pline(self, pts, Color(CRACK, fade), 5.0, true)
		SoftDraw.pline(self, pts, Color(1.0, 0.75, 0.4, 0.8 * fade * (0.6 + 0.4 * sin(_t * 12.0))), 2.0, true)
	# รอยเท้าแมวยักษ์ประทับกลางรอยแตก
	if not _cracks.is_empty():
		CatGlow.paw(self, Vector2(0.0, -2.0), 70.0 if big else 46.0, Color(hue, 0.4 * fade), PI, 0.32)
		CatGlow.paw(self, Vector2(0.0, -2.0), 60.0 if big else 40.0, Color(CRACK, 0.55 * fade), PI, 0.32)
		for side in [-1.0, 1.0]:
			CatGlow.paw(self, Vector2(side * (110.0 if big else 70.0), 0.0), 14.0, Color(CRACK, 0.45 * fade), PI, 0.32)
	for r in _rocks:
		var shape := _rock_shape(r[2], r[3])
		var moved := PackedVector2Array()
		for p in shape:
			moved.append(p + (r[0] as Vector2))
		SoftDraw.poly(self, moved, Color(ROCK if int(r[2]) % 2 == 0 else ROCK_DARK, fade))
