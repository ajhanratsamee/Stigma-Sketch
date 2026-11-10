class_name CatDuetHyper
extends PairHyperBase
## HYPER ของ HARMONY DUET  ทั้งคู่ขึ้นเวที ผลัดกันพุ่งตีสลับซ้ายขวารัว 10 จังหวะ
## แล้วจับมือหมุนตัวกลางจอ ปล่อยคลื่นวงกลมประสาน 3 ระลอก  น้ำเงินแซมพีชอุ่น

const BEAT_FROM := 0.7
const BEAT_GAP := 0.22
const BEATS := 10
const BEAT_DMG := 26.0
const SPIN_FROM := BEAT_FROM + BEAT_GAP * float(BEATS) + 0.2
const WAVE_AT := SPIN_FROM + 0.8
const WAVE_DMG := 90.0
const TOTAL := WAVE_AT + 1.4

var _hits: Array = []           # วงตีกลม [ตำแหน่ง เวลาเกิด]

func _stage_start() -> void:
	accent = Color(1.0, 0.82, 0.64)
	_begin(TOTAL)

func _stage_tick(delta: float) -> void:
	var hand := Vector3(0.5, 0.3, 0.3)
	var off := Vector3(-0.35, 0.3, 0.1)
	var x := _cx
	var mx := _cx - _dir * 160.0
	if _t >= BEAT_FROM and _t < SPIN_FROM:
		var step := (_t - BEAT_FROM) / BEAT_GAP
		var i := clampi(floori(step), 0, BEATS - 1)
		var k := clampf(step - float(i), 0.0, 1.0)
		var side := 1.0 if i % 2 == 0 else -1.0
		# ตัวที่ตีพุ่งไปข้างหน้า อีกตัวถอยมาตั้งท่า
		if i % 2 == 0:
			x = _cx + _dir * 240.0 * _ease(k)
			hand = Vector3(0.9, 0.3, 0.3)
		else:
			mx = _cx + _dir * 260.0 * _ease(k)
		if _once("beat%d" % i, BEAT_FROM + BEAT_GAP * float(i) + BEAT_GAP * 0.5):
			var at := Vector2(_cx + _dir * 360.0 + side * 30.0, -110.0 + side * 20.0)
			_hits.append([at, _t])
			_pops.append([at, _t, 70.0, 0.3])
			_shake = 8.0
			_hit_range(_cx, 0.0, 1500.0, BEAT_DMG)
	elif _t >= SPIN_FROM:
		# จับมือหมุนกลางจอ
		var a := (_t - SPIN_FROM) * 9.0
		x = _cx + cos(a) * 90.0
		mx = _cx - cos(a) * 90.0
		hand = Vector3(0.6, 0.5, 0.3)
	_pose(hand, off, 0.0, 0.0, 0.08, x - _cx)
	_pose_mate(Vector3(0.6, 0.4, 0.3), Vector3(-0.3, 0.3, 0.1), mx)
	if _once("wave", WAVE_AT):
		_shake = 20.0
		for j in 3:
			_rings.append([_cx, _t + float(j) * 0.18, 900.0 + float(j) * 400.0, 22.0, 0.9])
		_puff(Vector2(_cx, -80.0), 12, 700.0, 50.0, false)
		_hit_all(WAVE_DMG)
	_hits = _hits.filter(func(h: Array) -> bool: return _t - float(h[1]) < 0.4)
	_tick_fx(delta)

func _draw_extra(fade: float) -> void:
	for h in _hits:
		var k := (_t - float(h[1])) / 0.4
		over.draw_circle(h[0], 50.0 * (0.6 + k), Color(accent, 0.5 * (1.0 - k) * fade))
		over.draw_circle(h[0], 26.0 * (1.0 - k) + 4.0, Color(LIGHT, 0.9 * (1.0 - k) * fade))
	if _t >= SPIN_FROM and _t < WAVE_AT + 0.6:
		var a := clampf((_t - SPIN_FROM) / 0.3, 0.0, 1.0) * fade
		var c := Vector2(_cx, -120.0)
		for i in 8:
			var ang := (_t - SPIN_FROM) * 5.0 + TAU * float(i) / 8.0
			over.draw_circle(c + Vector2(cos(ang), sin(ang) * 0.5) * 200.0, 12.0, Color(accent, 0.7 * a))
		over.draw_circle(c, 60.0, Color(LIGHT, 0.25 * a))
