class_name CatMuayThaiHyper
extends FistHyperBase
## HYPER ของ MUAY THAI  จอดำ กล้องถอย
## ไหว้ครูพนมมือ วงทองค่อยๆ ขยายใต้เท้า → ตีเข่า ศอก เตะสลับเป็นจังหวะกลอง 9 ที วงทองกลมเด้งตรงจุดโดน
## → กระโดดสูง เข่าทุบลงพื้น คลื่นทองแผ่ทั้งจอ  เทาแซมทองของสายมวย

const WAI_END := 1.2
const BEAT_FROM := 1.3
const BEAT_GAP := 0.26
const BEATS := 9
const BEAT_DMG := 24.0
const JUMP_FROM := BEAT_FROM + BEAT_GAP * float(BEATS) + 0.15
const JUMP_UP := 0.45
const HANG := 0.2
const DROP := 0.16
const SLAM_AT := JUMP_FROM + JUMP_UP + HANG + DROP
const SLAM_DMG := 230.0
const JUMP_H := 300.0
const TOTAL := SLAM_AT + 1.1
## ท่าแต่ละจังหวะ: 0 เข่า 1 ศอก 2 เตะ
const KINDS := [0, 1, 2, 0, 1, 2, 1, 0, 2]

func _stage_start() -> void:
	accent = Color(1.0, 0.8, 0.3)
	_begin(TOTAL)

func _stage_tick(delta: float) -> void:
	var hand := Vector3(0.45, 0.55, 0.3)
	var off := Vector3(0.2, 0.55, 0.05)
	var y := 0.0
	var tilt := 0.0
	var squat := 0.08
	if _t < WAI_END:
		# พนมมือไหว้ครู ก้มหัวเล็กน้อย
		var k := _ease((_t - 0.25) / 0.4)
		hand = Vector3(0.3, 0.2, 0.3).lerp(Vector3(0.25, 0.75, 0.12), k)
		off = Vector3(-0.2, 0.2, 0.1).lerp(Vector3(0.18, 0.75, 0.08), k)
		tilt = _dir * 0.1 * sin(clampf((_t - 0.5) / 0.6, 0.0, 1.0) * PI)
	elif _t < JUMP_FROM:
		var step := (_t - BEAT_FROM) / BEAT_GAP
		var i := clampi(floori(step), 0, BEATS - 1)
		var f := clampf(step - float(i), 0.0, 1.0)
		var hit := sin(clampf(f / 0.55, 0.0, 1.0) * PI)
		match int(KINDS[i]):
			0:
				# เข่า ยกตัว มือดึงคอลง
				hand = Vector3(0.7, 0.75, 0.25)
				off = Vector3(0.55, 0.75, 0.05)
				y = -40.0 * hit
				tilt = -_dir * 0.1 * hit
			1:
				# ศอก หมุนตัวฟาดศอกแนวนอน
				hand = Vector3(0.35, 0.65, 0.4).lerp(Vector3(0.65, 0.7, -0.1), hit)
				off = Vector3(-0.3, 0.6, 0.05)
				tilt = _dir * 0.12 * hit
			_:
				# เตะ เอนตัวไปหลัง แขนกาง
				hand = Vector3(-0.3, 0.55, 0.3)
				off = Vector3(0.4, 0.75, 0.05)
				tilt = -_dir * 0.28 * hit
				y = -20.0 * hit
	elif _t < SLAM_AT:
		var since := _t - JUMP_FROM
		if since < JUMP_UP:
			y = -JUMP_H * _ease(since / JUMP_UP)
		elif since < JUMP_UP + HANG:
			y = -JUMP_H - 20.0 * sin((since - JUMP_UP) / HANG * PI)
		else:
			var dk := clampf((since - JUMP_UP - HANG) / DROP, 0.0, 1.0)
			y = -JUMP_H * (1.0 - dk * dk)
		hand = Vector3(0.6, 1.1, 0.2)
		off = Vector3(0.4, 1.1, 0.05)
		tilt = -_dir * 0.15
	else:
		var bk := clampf((_t - SLAM_AT) / 0.3, 0.0, 1.0)
		squat = 0.22 * (1.0 - bk) + 0.05
		hand = Vector3(0.6, 0.5, 0.3)
		off = Vector3(-0.3, 0.55, 0.05)
	_pose(hand, off, y, tilt, squat)
	if _once("wai", 0.6):
		_rings.append([_cx, _t, 380.0, 16.0, 1.0])
	for i in BEATS:
		if _once("beat%d" % i, BEAT_FROM + BEAT_GAP * float(i) + BEAT_GAP * 0.4):
			var at := Vector2(_cx + _dir * (130.0 + float(i % 3) * 30.0), -150.0 + float(int(KINDS[i])) * 30.0)
			_pops.append([at, _t, 90.0 if i < BEATS - 1 else 140.0, 0.35])
			_puff(at, 5, 300.0, 22.0, false)
			_shake = 10.0 if i < BEATS - 1 else 16.0
			_hit_range(_cx, -80.0, 1300.0, BEAT_DMG)
	if _once("slam", SLAM_AT):
		_shake = 34.0
		_rings.append([_cx, _t, 1700.0, 44.0, 1.0])
		_rings.append([_cx, _t + 0.12, 1200.0, 28.0, 1.0])
		_puff(Vector2(_cx, 0.0), 20, 1000.0, 70.0)
		_hit_all(SLAM_DMG)
	_tick_fx(delta)

func _draw_extra(fade: float) -> void:
	# วงทองใต้เท้าตอนไหว้ครู กลมนุ่ม
	if _t < JUMP_FROM:
		var a := clampf((_t - 0.3) / 0.5, 0.0, 1.0) * fade * clampf((JUMP_FROM - _t) / 0.4, 0.0, 1.0)
		var c := Vector2(_cx, 0.0)
		over.draw_set_transform(c, 0.0, Vector2(1.0, 0.2))
		over.draw_arc(Vector2.ZERO, 230.0, 0.0, TAU, 48, Color(accent, 0.6 * a), 10.0, true)
		over.draw_arc(Vector2.ZERO, 190.0, 0.0, TAU, 48, Color(LIGHT, 0.5 * a), 4.0, true)
		for i in 8:
			var ang := TAU * float(i) / 8.0 + _t * 0.8
			over.draw_circle(Vector2(cos(ang), sin(ang)) * 210.0, 12.0, Color(accent, 0.8 * a))
		over.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# กลองจังหวะ: จุดกลมทองเหนือหัว นับจังหวะที่ตีไปแล้ว
	if _t >= BEAT_FROM and _t < JUMP_FROM + 0.3:
		var done := clampi(floori((_t - BEAT_FROM) / BEAT_GAP) + 1, 0, BEATS)
		for i in BEATS:
			var p := Vector2(_cx + (float(i) - 4.0) * 34.0, -330.0)
			var on := i < done
			over.draw_circle(p, 13.0 if on else 9.0, Color(accent if on else LIGHT, (0.95 if on else 0.4) * fade))
