class_name CatPsycheHyper
extends PairHyperBase
## HYPER ของ ID EGO SAGE  จิต ID (ชมพู) กับ EGO (ฟ้า) แยกเป็นสองวงหมุนรอบตัว
## วงทั้งสองค่อยๆ ไปอยู่สองฝั่งหน้าจอ ตีมอนเป็นจังหวะ แล้วพุ่งปะทะกันกลางจอ ระเบิดเป็นวงสมดุลสองสี

const ID_COL := Color(1.0, 0.7, 0.8)
const EGO_COL := Color(0.72, 0.9, 1.0)
const ORBIT_TO := 2.2
const TICK_GAP := 0.3
const TICK_DMG := 18.0
const CLASH_AT := 3.0
const CLASH_DMG := 240.0
const TOTAL := CLASH_AT + 1.4

var _tick_n := 0

func _stage_start() -> void:
	accent = Color(0.85, 0.78, 1.0)
	_begin(TOTAL)

func _orb_pos(which: float) -> Vector2:
	var c := Vector2(_cx + _dir * 420.0, -150.0)
	if _t < ORBIT_TO:
		var a := _t * 5.0 + (0.0 if which > 0.0 else PI)
		var r := 120.0 + 260.0 * _ease(_t / ORBIT_TO)
		return c + Vector2(cos(a) * r, sin(a) * r * 0.45)
	if _t < CLASH_AT:
		var k := _ease((_t - ORBIT_TO) / (CLASH_AT - ORBIT_TO))
		return c + Vector2(which * 380.0 * (1.0 - k), 0.0)
	return c

func _stage_tick(delta: float) -> void:
	_pose(Vector3(0.6, 0.6, 0.3), Vector3(-0.5, 0.6, 0.1), 0.0, 0.0, 0.06)
	_pose_mate(Vector3(0.5, 0.5, 0.3), Vector3(-0.4, 0.5, 0.1), _cx - _dir * 160.0)
	while _t >= 0.6 + float(_tick_n) * TICK_GAP and _t < CLASH_AT:
		_tick_n += 1
		_pops.append([_orb_pos(1.0 if _tick_n % 2 == 0 else -1.0), _t, 60.0, 0.3])
		_hit_range(_cx, 0.0, 1500.0, TICK_DMG)
		_shake = 5.0
	if _once("clash", CLASH_AT):
		_shake = 26.0
		var c := _orb_pos(1.0)
		_rings.append([c.x, _t, 1300.0, 30.0, 1.0])
		_pops.append([c, _t, 260.0, 0.6])
		_puff(c, 14, 800.0, 55.0, false)
		_hit_all(CLASH_DMG)
	_tick_fx(delta)

func _draw_extra(fade: float) -> void:
	if _t < CLASH_AT + 0.6:
		var a := clampf(_t / 0.4, 0.0, 1.0) * fade * (1.0 if _t < CLASH_AT else 1.0 - (_t - CLASH_AT) / 0.6)
		for which in [1.0, -1.0]:
			var p := _orb_pos(which)
			var col: Color = ID_COL if which > 0.0 else EGO_COL
			for j in 4:
				over.draw_circle(p - Vector2(which * float(j + 1) * 18.0, 0.0), 44.0 - float(j) * 8.0, Color(col, 0.18 * a))
			over.draw_circle(p, 50.0, Color(col, 0.75 * a))
			over.draw_circle(p, 26.0, Color(LIGHT, 0.85 * a))
	if _t >= CLASH_AT:
		var k := clampf((_t - CLASH_AT) / 0.8, 0.0, 1.0)
		var c := _orb_pos(1.0)
		over.draw_arc(c, 300.0 * _ease(k), 0.0, PI, 40, Color(ID_COL, 0.8 * (1.0 - k) * fade), 14.0, true)
		over.draw_arc(c, 300.0 * _ease(k), PI, TAU, 40, Color(EGO_COL, 0.8 * (1.0 - k) * fade), 14.0, true)
