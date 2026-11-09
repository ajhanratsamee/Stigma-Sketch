class_name CatSamboHyper
extends FistHyperBase
## HYPER ของ SAMBO  จอดำ กล้องถอย
## ยื่นมือคว้า มอนทั้งจอถูกดึงเข้ามากองหน้าตัว → หมุนตัวทุ่มสลับซ้ายขวาเป็นวงล้อ 6 ที วงกระแทกฟ้าครามที่พื้น
## → กอดมอนกระโดดสูง ทุ่มลงพื้น หิมะกลมฟุ้งทั้งจอ  เทาแซมฟ้าครามของสายปล้ำ

const GRAB_END := 1.1
const THROW_FROM := 1.2
const THROW_GAP := 0.32
const THROWS := 6
const THROW_DMG := 30.0
const JUMP_FROM := THROW_FROM + THROW_GAP * float(THROWS) + 0.1
const JUMP_UP := 0.45
const HANG := 0.25
const DROP := 0.16
const SLAM_AT := JUMP_FROM + JUMP_UP + HANG + DROP
const SLAM_DMG := 230.0
const JUMP_H := 300.0
const TOTAL := SLAM_AT + 1.3

## เกล็ดหิมะกลม [ตำแหน่ง, ความเร็ว, เวลาเกิด, ขนาด]
var _snow: Array = []

func _stage_start() -> void:
	accent = Color(0.55, 0.66, 1.0)
	_begin(TOTAL)

func _stage_tick(delta: float) -> void:
	var hand := Vector3(0.55, 0.45, 0.3)
	var off := Vector3(0.3, 0.45, 0.05)
	var y := 0.0
	var tilt := 0.0
	var squat := 0.1
	var shift := 0.0
	if _t < GRAB_END:
		# ยื่นสองมือคว้า แล้วดึงกลับมากอด
		var k := sin(clampf((_t - 0.3) / 0.7, 0.0, 1.0) * PI)
		hand = Vector3(0.4, 0.45, 0.3).lerp(Vector3(1.0, 0.5, 0.3), k)
		off = Vector3(0.25, 0.45, 0.05).lerp(Vector3(0.9, 0.5, 0.05), k)
		tilt = _dir * 0.1 * k
	elif _t < JUMP_FROM:
		var step := (_t - THROW_FROM) / THROW_GAP
		var i := clampi(floori(step), 0, THROWS - 1)
		var f := clampf(step - float(i), 0.0, 1.0)
		# หมุนตัวแอ่นหลังทุ่มสลับข้าง
		var side := 1.0 if i % 2 == 0 else -1.0
		var arc := sin(f * PI)
		hand = Vector3(0.3, 0.9, 0.3).lerp(Vector3(0.7, 0.2, 0.3), f)
		off = Vector3(0.1, 0.9, 0.05).lerp(Vector3(0.5, 0.2, 0.05), f)
		tilt = -_dir * side * 0.35 * arc
		y = -30.0 * arc
		squat = 0.14 * (1.0 - arc)
	elif _t < SLAM_AT:
		var since := _t - JUMP_FROM
		if since < JUMP_UP:
			y = -JUMP_H * _ease(since / JUMP_UP)
		elif since < JUMP_UP + HANG:
			y = -JUMP_H - 20.0 * sin((since - JUMP_UP) / HANG * PI)
		else:
			var dk := clampf((since - JUMP_UP - HANG) / DROP, 0.0, 1.0)
			y = -JUMP_H * (1.0 - dk * dk)
		hand = Vector3(0.6, 0.55, 0.3)
		off = Vector3(0.45, 0.55, 0.05)
		tilt = -_dir * PI * 0.15 * clampf((since - JUMP_UP) / HANG, 0.0, 1.0)
	else:
		var bk := clampf((_t - SLAM_AT) / 0.35, 0.0, 1.0)
		squat = 0.25 * (1.0 - bk) + 0.05
		hand = Vector3(0.6, 0.4, 0.3)
		off = Vector3(-0.3, 0.45, 0.05)
	_pose(hand, off, y, tilt, squat, shift)
	# ดึงมอนเข้ามากองหน้าตัวตอนคว้า
	if _t >= 0.4 and _t < GRAB_END:
		for m in caught:
			if is_instance_valid(m):
				var mm := m as Monster
				var want := (_cx + _dir * 150.0) / CombatData.UNIT
				mm.pos.x = move_toward(mm.pos.x, want, 14.0 * delta)
	if _once("grab", GRAB_END - 0.2):
		_pops.append([Vector2(_cx + _dir * 150.0, -100.0), _t, 120.0, 0.4])
		_shake = 8.0
	for i in THROWS:
		if _once("throw%d" % i, THROW_FROM + THROW_GAP * float(i) + THROW_GAP * 0.55):
			var side := 1.0 if i % 2 == 0 else -1.0
			var x := _cx - _dir * side * 200.0
			_rings.append([x, _t, 520.0, 18.0, 0.8])
			_puff(Vector2(x, 0.0), 7, 420.0, 34.0)
			_shake = 12.0 if i < THROWS - 1 else 18.0
			_hit_all(THROW_DMG)
			for m in caught:
				if is_instance_valid(m):
					(m as Monster).pos.x = x / CombatData.UNIT
	if _once("slam", SLAM_AT):
		_shake = 34.0
		_rings.append([_cx, _t, 1700.0, 44.0, 1.1])
		_puff(Vector2(_cx, 0.0), 22, 1000.0, 70.0)
		_hit_all(SLAM_DMG)
		var half := screen_half_world().x
		for i in 70:
			_snow.append([Vector2(_cx + randf_range(-half, half), randf_range(-900.0, -100.0)), Vector2(randf_range(-40.0, 40.0), randf_range(60.0, 160.0)), _t, randf_range(6.0, 16.0)])
	for s in _snow:
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
	_snow = _snow.filter(func(s: Array) -> bool: return _t - float(s[2]) < 1.4)
	_tick_fx(delta)

func _draw_extra(fade: float) -> void:
	# มือคว้า วงดึงฟ้าครามหดเข้าหาตัว
	if _t >= 0.3 and _t < GRAB_END:
		var k := (_t - 0.3) / (GRAB_END - 0.3)
		var c := Vector2(_cx + _dir * 150.0, -100.0)
		for i in 3:
			var r := 700.0 * (1.0 - k) + float(i) * 60.0
			over.draw_arc(c, r, 0.0, TAU, 48, Color(accent, 0.5 * fade * (1.0 - k)), 8.0, true)
	for s in _snow:
		var k := (_t - float(s[2])) / 1.4
		over.draw_circle(s[0], float(s[3]), Color(1.0, 1.0, 1.0, 0.85 * (1.0 - k) * fade))
		over.draw_circle(s[0], float(s[3]) * 0.5, Color(accent, 0.5 * (1.0 - k) * fade))
