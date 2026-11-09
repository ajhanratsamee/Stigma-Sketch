class_name FistHyperBase
extends HyperStage
## ฐานของ HYPER สาย CAT ASH (KUNG FU / MUAY THAI / SAMBO) จอดำ กล้องถอย
## มีตัวช่วย: วงคลื่นบนพื้น ฝุ่นกลม วงแรงกระแทกกลางอากาศ ท่าตัวละคร ดาเมจมอนในระยะ
## สีหลักเทาของ ASH แซมสีเดียวของสาย (accent) ทุกอย่างทรงกลม ไม่มีดาว

const SIZE := 1.29
const GRAY := Color(0.62, 0.63, 0.68)
const LIGHT := Color(0.9, 0.9, 0.94)
const DARK := Color(0.4, 0.41, 0.46)

var accent := Color(1.0, 1.0, 1.0)
var _dir := 1.0
var _cx := 0.0
## วงคลื่นบนพื้น [x, เวลาเกิด, รัศมีสุด, หนา, อายุ]
var _rings: Array = []
## วงแรงกระแทกกลางอากาศ [ตำแหน่ง, เวลาเกิด, รัศมีสุด, อายุ]
var _pops: Array = []
## ฝุ่นกลม [ตำแหน่ง, ความเร็ว, เวลาเกิด, ขนาด, สีแซม]
var _dust: Array = []
var _beats_done := {}

func _begin(total: float) -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = total
	end_time = total + 0.5
	Monster.hide_bars = true
	_dir = signf(hero.facing) if hero.facing != 0.0 else 1.0
	_cx = hero.position.x
	add_actor(Vector2(_cx, 0.0), SIZE, ChibiModel.TURN * _dir, SkillPanel.model_style("fist", WalkPage.chosen_class))
	actor.sword_on = false
	add_over()
	if hero.plain_model != null:
		hero.plain_model.visible = false

## ทำครั้งเดียวเมื่อเวลาถึง at
func _once(key: String, at: float) -> bool:
	if _t < at or _beats_done.has(key):
		return false
	_beats_done[key] = true
	return true

## วางท่า: มือ มืออีกข้าง ตำแหน่ง y เอียง ย่อ
func _pose(hand: Vector3, off: Vector3, y := 0.0, tilt := 0.0, squat := 0.0, x_shift := 0.0, size := SIZE) -> void:
	actor.stage_hand = hand
	actor.stage_off = off
	var base := size * ChibiModel.LEGACY_PX / ChibiModel.PX_PER_UNIT
	actor.scale = Vector2(base * (1.0 + squat * 0.6), base * (1.0 - squat))
	actor.position = Vector2(_cx + x_shift, y)
	actor.rotation = tilt

## ดาเมจมอนที่อยู่ในช่วง x ห่างจากจุด from (ด้านหน้า) ระหว่าง near ถึง far
func _hit_range(from: float, near: float, far: float, dmg: float) -> void:
	for m in caught:
		if not is_instance_valid(m):
			continue
		var d := ((m as Monster).pos.x * CombatData.UNIT - from) * _dir
		if d >= near and d <= far:
			(m as Monster).take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _hit_all(dmg: float) -> void:
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

func _puff(at: Vector2, count: int, speed: float, size: float, up_only := true) -> void:
	for i in count:
		var a := (PI + PI * (float(i) + 0.5) / float(count)) if up_only else TAU * float(i) / float(count)
		_dust.append([at + Vector2(randf_range(-20.0, 20.0), -10.0), Vector2(cos(a), sin(a) * 0.6) * speed * randf_range(0.6, 1.0), _t, size * randf_range(0.7, 1.2), i % 3 == 0])

func _tick_fx(delta: float) -> void:
	for d in _dust:
		d[1] = (d[1] as Vector2) * 0.9
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
	_dust = _dust.filter(func(d: Array) -> bool: return _t - float(d[2]) < 0.9)
	_rings = _rings.filter(func(r: Array) -> bool: return _t - float(r[1]) < float(r[4]))
	_pops = _pops.filter(func(p: Array) -> bool: return _t - float(p[1]) < float(p[3]))

func _fade() -> float:
	return 1.0 - clampf((_t - close_from) / 0.5, 0.0, 1.0)

## วงคลื่นแบนบนพื้น
func _draw_ground_ring(x: float, k: float, rmax: float, w: float) -> void:
	if k <= 0.0 or k >= 1.0:
		return
	var r := rmax * _ease(k)
	var a := (1.0 - k) * _fade()
	var pts := PackedVector2Array()
	for i in 49:
		var t := TAU * float(i) / 48.0
		pts.append(Vector2(x + cos(t) * r, sin(t) * r * 0.16))
	draw_polyline(pts, Color(GRAY, 0.35 * a), w * 2.0, true)
	draw_polyline(pts, Color(accent, 0.85 * a), w, true)
	draw_polyline(pts, Color(1.0, 1.0, 1.0, 0.6 * a), w * 0.3, true)

func _draw() -> void:
	var fade := _fade()
	if fade <= 0.0:
		return
	if actor != null:
		var lift := clampf(-actor.position.y / 300.0, 0.0, 1.0)
		draw_set_transform(Vector2(actor.position.x, 6.0), 0.0, Vector2(1.0, 0.22))
		draw_circle(Vector2.ZERO, 120.0 * (1.0 - lift * 0.6), Color(0.0, 0.0, 0.0, 0.25 * fade))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	for r in _rings:
		_draw_ground_ring(float(r[0]), (_t - float(r[1])) / float(r[4]), float(r[2]), float(r[3]))

func _draw_over() -> void:
	var fade := _fade()
	if fade <= 0.0:
		return
	for p in _pops:
		var k := (_t - float(p[1])) / float(p[3])
		var r := float(p[2]) * _ease(k)
		var a := (1.0 - k) * fade
		over.draw_circle(p[0], r, Color(accent, 0.12 * a))
		over.draw_arc(p[0], r, 0.0, TAU, 40, Color(LIGHT, 0.9 * a), 10.0 * (1.0 - k) + 2.0, true)
		over.draw_arc(p[0], r * 0.7, 0.0, TAU, 40, Color(accent, 0.8 * a), 6.0 * (1.0 - k) + 1.0, true)
	for d in _dust:
		var k := (_t - float(d[2])) / 0.9
		var c: Color = accent if d[4] else LIGHT
		over.draw_circle(d[0], float(d[3]) * (0.6 + k * 0.8), Color(c, 0.7 * (1.0 - k) * fade))
	_draw_extra(fade)

## วาดของเฉพาะท่า (ลูกหลานเขียนเอง)
func _draw_extra(_fade_k: float) -> void:
	pass

func _finish() -> void:
	var targets := caught.duplicate()
	Monster.hide_bars = false
	if hero.plain_model != null:
		hero.plain_model.visible = true
	super._finish()
	for m in targets:
		if is_instance_valid(m) and (m as Monster).state != "dead":
			(m as Monster).take_hit({"type": "launch", "vy": 10.0, "dmg": 1.0, "skill": true}, signf((m as Monster).position.x - _cx))

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
	super._exit_tree()
