class_name CatKungFuHyper
extends FistHyperBase
## HYPER ของ KUNG FU  จอดำ กล้องถอย
## ตั้งท่ากังฟู ลมหมุนรอบตัวเป็นวงโค้งมน → ผลักฝ่ามือลมสลับซ้ายขวา 8 ที ฝ่ามือลมกลมพุ่งไปข้างหน้า
## → ย่อตัวรวมลม แล้วหมัดมังกรลม ลำลมกลมยาวพุ่งทะลุทั้งจอ  เทาแซมเขียวฟ้าของสายลม

const STANCE_END := 1.1
const PALM_FROM := 1.2
const PALM_GAP := 0.24
const PALMS := 8
const PALM_DMG := 24.0
const GATHER_FROM := PALM_FROM + PALM_GAP * float(PALMS) + 0.1
const DRAGON_AT := GATHER_FROM + 0.7
const DRAGON_DMG := 230.0
const TOTAL := DRAGON_AT + 1.3

## ฝ่ามือลมที่บินอยู่ [ตำแหน่ง, เวลาเกิด, ซ้าย]
var _palms: Array = []

func _stage_start() -> void:
	accent = Color(0.5, 0.88, 0.8)
	_begin(TOTAL)

func _stage_tick(delta: float) -> void:
	var hand := Vector3(0.5, 0.3, 0.3)
	var off := Vector3(-0.35, 0.55, 0.1)
	var squat := 0.12
	var tilt := 0.0
	if _t < STANCE_END:
		# ตั้งท่า มือหน้ายื่นฝ่ามือ มือหลังตั้งเหนือหัว ตัวโยกตามลม
		var k := _ease((_t - 0.3) / 0.4)
		hand = Vector3(0.2, 0.1, 0.2).lerp(Vector3(0.75, 0.35, 0.3), k)
		off = Vector3(-0.2, 0.1, 0.1).lerp(Vector3(-0.45, 0.9, 0.05), k)
		tilt = sin(_t * 6.0) * 0.03
	elif _t < GATHER_FROM:
		var step := (_t - PALM_FROM) / PALM_GAP
		var i := clampi(floori(step), 0, PALMS - 1)
		var f := clampf(step - float(i), 0.0, 1.0)
		var push := Vector3(0.95, 0.35, 0.3)
		var pull := Vector3(0.25, 0.3, 0.3)
		var arm := pull.lerp(push, _ease(f / 0.4)) if f < 0.7 else push.lerp(pull, (f - 0.7) / 0.3)
		if i % 2 == 0:
			hand = arm
			off = Vector3(-0.3, 0.4, 0.1)
		else:
			off = Vector3(arm.x, arm.y, 0.1)
			hand = Vector3(0.3, 0.4, 0.3)
		tilt = _dir * 0.06
	elif _t < DRAGON_AT:
		# ย่อตัวรวมลม สองมือดึงมาข้างเอว
		var k := _ease((_t - GATHER_FROM) / 0.5)
		hand = Vector3(-0.1, 0.0, 0.35).lerp(Vector3(-0.25, -0.05, 0.35), k)
		off = Vector3(-0.15, 0.0, 0.1)
		squat = 0.12 + 0.12 * k
		tilt = -_dir * 0.08 * k
	else:
		# หมัดมังกร ยื่นสุดแขน ตัวเอนไปข้างหน้า
		var k := _ease((_t - DRAGON_AT) / 0.15)
		hand = Vector3(1.05, 0.35, 0.25)
		off = Vector3(-0.5, 0.3, 0.05)
		squat = 0.08
		tilt = _dir * 0.12 * k
	_pose(hand, off, 0.0, tilt, squat)
	# ฝ่ามือลมสลับ
	for i in PALMS:
		if _once("palm%d" % i, PALM_FROM + PALM_GAP * float(i) + PALM_GAP * 0.35):
			var y := -90.0 if i % 2 == 0 else -130.0
			_palms.append([Vector2(_cx + _dir * 90.0, y), _t, i % 2 == 1])
			_pops.append([Vector2(_cx + _dir * 120.0, y), _t, 70.0, 0.3])
			_shake = 9.0 if i < PALMS - 1 else 14.0
			_hit_range(_cx, -60.0, 1400.0, PALM_DMG)
	if _once("gather", GATHER_FROM):
		_rings.append([_cx, _t, 420.0, 18.0, 0.8])
	if _once("dragon", DRAGON_AT):
		_shake = 30.0
		_rings.append([_cx, _t, 1500.0, 40.0, 1.0])
		_puff(Vector2(_cx + _dir * 200.0, -100.0), 14, 900.0, 60.0, false)
		_hit_range(_cx, -200.0, 3000.0, DRAGON_DMG)
	for p in _palms:
		p[0] = (p[0] as Vector2) + Vector2(_dir * 1500.0 * delta, 0.0)
	_palms = _palms.filter(func(p: Array) -> bool: return _t - float(p[1]) < 0.9)
	_tick_fx(delta)

func _draw_extra(fade: float) -> void:
	# ลมหมุนรอบตัวตอนตั้งท่า วงโค้งมนปลายกลม
	if _t < GATHER_FROM + 0.7:
		var a := clampf(_t / 0.4, 0.0, 1.0) * fade * (1.0 if _t < GATHER_FROM else 1.0 - (_t - GATHER_FROM) / 0.7)
		var c := Vector2(_cx, -110.0)
		for i in 3:
			var start := _t * 5.0 + TAU * float(i) / 3.0
			var r := 150.0 + float(i) * 22.0
			over.draw_arc(c, r, start, start + 1.4, 20, Color(accent, 0.7 * a), 9.0, true)
			var tip := c + Vector2(cos(start + 1.4), sin(start + 1.4)) * r
			over.draw_circle(tip, 7.0, Color(LIGHT, 0.9 * a))
	# ฝ่ามือลมกลม หางลมจาง
	for p in _palms:
		var k := (_t - float(p[1])) / 0.9
		var at: Vector2 = p[0]
		var a := (1.0 - k) * fade
		for j in 4:
			over.draw_circle(at - Vector2(_dir * float(j + 1) * 34.0, 0.0), 40.0 - float(j) * 8.0, Color(accent, 0.2 * a))
		over.draw_circle(at, 52.0, Color(LIGHT, 0.85 * a))
		over.draw_circle(at, 38.0, Color(accent, 0.75 * a))
		for t in 4:
			var q := at + Vector2(_dir * 30.0, (float(t) - 1.5) * 20.0)
			over.draw_circle(q, 10.0, Color(LIGHT, a))
	# รวมลม: วงลมกลมหดเข้าที่มือ
	if _t >= GATHER_FROM and _t < DRAGON_AT:
		var k := (_t - GATHER_FROM) / (DRAGON_AT - GATHER_FROM)
		var c := Vector2(_cx - _dir * 30.0, -100.0)
		for i in 6:
			var ang := TAU * float(i) / 6.0 + _t * 3.0
			var p := c + Vector2(cos(ang), sin(ang)) * 260.0 * (1.0 - k)
			over.draw_circle(p, 16.0, Color(accent, 0.8 * fade))
		over.draw_circle(c, 30.0 + 40.0 * k, Color(LIGHT, 0.4 * fade))
	# หมัดมังกรลม ลำลมกลมยาวพุ่งทะลุจอ หัวลำกลมใหญ่
	if _t >= DRAGON_AT:
		var k := clampf((_t - DRAGON_AT) / 0.35, 0.0, 1.0)
		var out := clampf((_t - DRAGON_AT - 0.7) / 0.6, 0.0, 1.0)
		var a := (1.0 - out) * fade
		var from := Vector2(_cx + _dir * 110.0, -110.0)
		var to := from + Vector2(_dir * 2600.0 * _ease(k), 0.0)
		var w := 120.0 * (1.0 - out * 0.5)
		over.draw_line(from, to, Color(accent, 0.25 * a), w * 1.6, true)
		over.draw_line(from, to, Color(accent, 0.7 * a), w, true)
		over.draw_line(from, to, Color(LIGHT, 0.9 * a), w * 0.4, true)
		over.draw_circle(to, w * 0.9, Color(accent, 0.75 * a))
		over.draw_circle(to, w * 0.55, Color(LIGHT, 0.95 * a))
		for i in 8:
			var s := float(i) / 8.0
			var p := from.lerp(to, s) + Vector2(0.0, sin(_t * 18.0 + float(i)) * w * 0.55)
			over.draw_circle(p, w * 0.18, Color(LIGHT, 0.7 * a))
