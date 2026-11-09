class_name BoySkill
extends HyperBase
## สกิลของสาย BOY กดแล้วเวลาหยุด 0.7 วินาที มอนนิ่งทั้งจอโดยไม่สตั๊น แล้วเวลาเดินต่อระหว่างท่า
## ไม่ซ่อนปุ่ม ไม่ถอยกล้อง ไม่มีแถบจอภาพ เหล่านั้นเป็นของ Hyper เท่านั้น
## aura_slash storm triple_wave tornado fury

const RED := Color(0.86, 0.14, 0.14)
const RED_LIGHT := Color(1.0, 0.5, 0.42)
const CHEST := 1.1
const ARC_R := 3.9
const ARC_FROM := -70.0
const ARC_TO := 40.0
const ARC_STEPS := 34
const ARC_THICK := 0.3
const FREEZE := 0.7
const AURA_LONG := 195.0
const AURA_WIDE := 30.0
const AURA_STROKES := 15
const BEAM_HIGH := 3.4
const BEAM_STEP := 15.0
const STORM_FILL := Color(0.95, 0.42, 0.36, 0.42)
const STORM_R := 4.6
const STORM_TICK := 0.2
const STORM_HITS := 12
const WAVE_FIRST := 2.2
const WAVE_GAP := 2.6
const WAVE_R := 1.7
const RING_TIME := 0.5
const BEAM_TIME := 0.55
const TORNADO_GO := 14.0
const TORNADO_TIME := 2.4
const TORNADO_GRAB := 1.6
const TORNADO_HIGH := 5.0
const DASH_GAP := 1.0
const BURST_MIN := 9.0
const BURST_GAP := 4
const FURY_HITS := 6
const FURY_REACH := 3.6
const FLINCH := {"type": "flinch", "kd": 0, "kb": 0.0}

var kind := "aura_slash"
var aura_k := 0.0
var arc_u := -1.0
var storm_k := 0.0
var tornado_on := false
var tornado_x := 0.0
var rings: Array = []
var beams: Array = []
var grabbed: Array = []
var waves_done := 0
var _wave_from := 0.0
var _dir := 1.0
var _clock := 0.0
var _arc_flip := 1.0
var _arc_x := 0.0
var _burst_x := 0.0
var _burst_wait := 0
var storm_x := 0.0

func _init() -> void:
	keep_camera = true

func _prepare() -> void:
	_dir = hero.facing

## สกิลไม่มีแถบจอภาพ
func _tween_bars(_to: float, _time: float) -> void:
	pass

## หยุดเวลา มอนนิ่งทั้งจอ ไม่ใช่สตั๊น จึงไม่มีดาวบนหัว
func _stun_all() -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if e.state == "dead":
			continue
		e.frozen = true
		_targets.append(e)
	get_tree().create_timer(FREEZE).timeout.connect(_release_all)

func _release_all() -> void:
	for e in _targets:
		if is_instance_valid(e):
			e.frozen = false

func _run() -> void:
	match kind:
		"aura_slash": await _run_aura_slash()
		"storm": await _run_storm()
		"triple_wave": await _run_triple_wave()
		"tornado": await _run_tornado()
		"fury": await _run_fury()
	_rest_hero()
	_end_plain()

## คืนท่ายืน ถ้าปล่อยตัวละครไปแล้วไม่ไปยุ่งกับท่าที่เล่นอยู่
func _rest_hero() -> void:
	if released:
		return
	hero.set_spin(0.0)
	hero.set_pose(Hero.REST_SW, Vector2.ZERO)

func _hit(dmg: float, extra := {}) -> Dictionary:
	var h := FLINCH.duplicate()
	h["dmg"] = dmg
	h["skill"] = true
	h.merge(extra, true)
	return h

## ตีมอนในช่วงแกน X ตั้งแต่ x0 ถึง x1
func _hit_span(x0: float, x1: float, hit: Dictionary) -> void:
	hits_on_target += 1
	var low := minf(x0, x1) - hero.skill_reach_bonus()
	var high := maxf(x0, x1) + hero.skill_reach_bonus()
	_burst_x = (low + high) * 0.5
	for e in _targets:
		if not is_instance_valid(e) or e.state == "dead" or e.pos.x < low or e.pos.x > high:
			continue
		var before: float = e.hp
		if e.take_hit(hit, _dir):
			hero.count_hit(before - e.hp, hit)

## จังหวะกระแทก แสงอนิเมะตรงจุดที่ตี
func _shake(power: float) -> void:
	super(power)
	if not Sketch.anime or power < BURST_MIN or Engine.get_process_frames() < _burst_wait:
		return
	_burst_wait = Engine.get_process_frames() + BURST_GAP
	var fx := AnimeBurst.new()
	fx.pos = Vector2(_burst_x, 1.2)
	fx.color = RED if int(power) % 2 == 0 else Color(0.98, 0.62, 0.14)
	fx.size_k = clampf(power / 14.0, 0.8, 2.4)
	get_parent().add_child(fx)

func _pose_tween(sw0: float, sw1: float, hand0: Vector2, hand1: Vector2, time: float) -> void:
	create_tween().tween_method(func(u: float):
		if not released:
			hero.set_pose(lerpf(sw0, sw1, u), hand0.lerp(hand1, u)), 0.0, 1.0, time)

func _arc_swing(from_sw: float, to_sw: float, time: float) -> void:
	_pose_tween(from_sw, to_sw, Vector2(0.0, 0.6), Vector2(0.6, 0.1), time)
	arc_u = 0.0
	_arc_x = hero.pos.x
	create_tween().tween_property(self, "arc_u", 1.0, time + 0.35)

# ---------------------------------------------------------------- ขั้นตอนแต่ละท่า

## 1.2 หน้าจอหยุดสักพัก รวมออร่าที่ดาบ ฟาดเฉียงลงมา
func _run_aura_slash() -> void:
	_pose_tween(Hero.REST_SW, 15.0, Vector2.ZERO, Vector2(0.0, 0.7), 0.3)
	create_tween().tween_property(self, "aura_k", 1.0, 0.45)
	await _wait(0.75)
	_arc_swing(15.0, -125.0, 0.14)
	await _wait(0.12)
	aura_k = 0.0
	_hit_span(hero.pos.x, hero.pos.x + _dir * ARC_R * 1.3, _hit(42.0))
	_shake(20.0)
	_free_hero()
	await _wait(0.45)

## 5.1 ปักดาบ ออร่าพายุรอบตัว ดาเมจต่อเนื่อง แล้วค่อยๆ หายไป
func _run_storm() -> void:
	await _tween_bars(1.0, BAR_TIME)
	_pose_tween(Hero.REST_SW, 180.0, Vector2.ZERO, Hero.STAB_HAND, 0.2)
	await _wait(0.22)
	_shake(14.0)
	# ปักดาบแล้วเดินได้เลย พายุอยู่ตรงที่ปัก
	storm_x = hero.pos.x
	_free_hero()
	create_tween().tween_property(self, "storm_k", 1.0, 0.3)
	for i in STORM_HITS:
		_hit_span(storm_x - STORM_R, storm_x + STORM_R, _hit(12.0))
		_shake(4.0)
		await _wait(STORM_TICK)
	create_tween().tween_property(self, "storm_k", 0.0, 0.7)
	await _wait(0.7)

## 10.1 พุ่งสั้นๆ หมุนตัว ฟาด คลื่นกระแทก 3 วง แล้วคลื่นจากฟ้าสีแดงตามลำดับ
func _run_triple_wave() -> void:
	await _tween_bars(1.0, BAR_TIME)
	create_tween().tween_property(hero, "pos:x", _dash_stop(2.0), 0.18)
	await _wait(0.2)
	await _spin_body(0.38)
	_arc_swing(160.0, -120.0, 0.12)
	await _wait(0.1)
	_hit_span(hero.pos.x, hero.pos.x + _dir * FURY_REACH, _hit(20.0))
	_free_hero_after_waves()
	await _waves(3)

## ฟันลงแล้วเดินต่อได้ คลื่นออกจากจุดที่ฟัน
func _free_hero_after_waves() -> void:
	_wave_from = hero.pos.x
	_free_hero()

## จุดหยุดของการพุ่ง ไม่เกินระยะและไม่ทะลุมอนตัวแรกด้านหน้า
func _dash_stop(long: float) -> float:
	var go := long
	for e in _targets:
		if not is_instance_valid(e) or e.state == "dead":
			continue
		var ahead: float = (e.pos.x - hero.pos.x) * _dir
		if ahead >= 0.0:
			go = minf(go, maxf(ahead - DASH_GAP, 0.0))
	return clampf(hero.pos.x + _dir * go, -half_width, half_width)

func _spin_body(time: float) -> void:
	hero.set_pose(160.0, Vector2(-0.3, 0.6))
	create_tween().tween_method(func(a: float): hero.set_spin(a), 0.0, TAU, time)
	await _wait(time)
	hero.set_spin(0.0)

## คลื่นกระแทกตามลำดับ ตามด้วยคลื่นจากฟ้า วงสุดท้ายทำมอนลอย
func _waves(count: int) -> void:
	var from_x: float = _wave_from
	var spots: Array = []
	for i in count:
		var x: float = clampf(from_x + _dir * (WAVE_FIRST + WAVE_GAP * i), -half_width - 4.0, half_width + 4.0)
		spots.append(x)
		rings.append({"x": x, "u": 0.0})
		# วงแรกคลุมตั้งแต่หน้าตัว มอนที่ยืนชิดก็โดน
		_hit_span(from_x if i == 0 else x - _dir * WAVE_R, x + _dir * WAVE_R, _hit(14.0))
		_shake(10.0)
		await _wait(0.16)
	for i in count:
		var x: float = spots[i]
		beams.append({"x": x, "u": 0.0})
		for n in 3:
			var last := n == 2
			_hit_span(from_x if i == 0 else x - _dir * WAVE_R, x + _dir * WAVE_R, _hit(12.0, {"type": "launch", "vy": 11.0, "kd": 40} if last else {}))
			await _wait(0.05)
		waves_done += 1
		_shake(14.0)
		await _wait(0.06)
	await _wait(0.45)

## 15.1 หมุนตัวเอาดาบเสียดพื้น เกิดพายุสีแดงพัดไปข้างหน้า ลากมอนไปด้วย
func _run_tornado() -> void:
	await _tween_bars(1.0, BAR_TIME)
	hero.set_pose(-165.0, Vector2(0.4, 0.37))
	create_tween().tween_method(func(a: float): hero.set_spin(a), 0.0, TAU * 2.0, 0.6)
	await _wait(0.6)
	hero.set_spin(0.0)
	tornado_on = true
	storm_k = 1.0
	tornado_x = hero.pos.x + _dir * 1.5
	_free_hero()
	var goal: float = clampf(tornado_x + _dir * TORNADO_GO, -half_width, half_width)
	create_tween().tween_property(self, "tornado_x", goal, TORNADO_TIME).set_trans(Tween.TRANS_SINE)
	var t := 0.0
	while t < TORNADO_TIME:
		_hit_span(tornado_x - TORNADO_GRAB, tornado_x + TORNADO_GRAB, _hit(10.0))
		for e in _targets:
			if is_instance_valid(e) and not (e in grabbed) and absf(e.pos.x - tornado_x) <= TORNADO_GRAB:
				grabbed.append(e)
		await _wait(0.2)
		t += 0.2
	create_tween().tween_property(self, "storm_k", 0.0, 0.3)
	await _wait(0.3)
	tornado_on = false

## 20.1 ฟาดหลายฮิตรุนแรง ฮิตสุดท้ายคลื่นกระแทกกับคลื่นจากฟ้าหนึ่งวง
func _run_fury() -> void:
	await _tween_bars(1.0, BAR_TIME)
	for i in FURY_HITS:
		_arc_flip = 1.0 if i % 2 == 0 else -1.0
		var high := 40.0 if i % 2 == 0 else -150.0
		_arc_swing(high, -60.0 if i % 2 == 0 else -20.0, 0.1)
		await _wait(0.1)
		_hit_span(hero.pos.x, hero.pos.x + _dir * FURY_REACH, _hit(14.0))
		_shake(9.0)
		await _wait(0.06)
	_arc_flip = 1.0
	await _spin_body(0.25)
	_arc_swing(160.0, -120.0, 0.12)
	await _wait(0.1)
	_free_hero_after_waves()
	await _waves(1)

# ---------------------------------------------------------------- วาด

func _process(delta: float) -> void:
	_clock += delta
	for r in rings:
		r["u"] = float(r["u"]) + delta / RING_TIME
	for b in beams:
		b["u"] = float(b["u"]) + delta / BEAM_TIME
	rings = rings.filter(func(r): return float(r["u"]) < 1.0)
	beams = beams.filter(func(b): return float(b["u"]) < 1.0)
	if tornado_on:
		for e in grabbed:
			if is_instance_valid(e):
				e.pos.x = tornado_x
	queue_redraw()

func _px(x: float, y: float) -> Vector2:
	return Vector2(x, -y) * U

func _draw() -> void:
	if aura_k > 0.0:
		_draw_aura()
	if storm_k > 0.0 and not tornado_on and kind == "storm":
		Sketch.storm(self, _px(storm_x, 0.0), STORM_R * U * 0.28, STORM_R * U, 4.6 * U, _clock * 7.0, STORM_FILL, Sketch.INK, 2430, storm_k)
	if tornado_on:
		Sketch.storm(self, _px(tornado_x, 0.0), 0.5 * U, TORNADO_GRAB * U, TORNADO_HIGH * U, _clock * 7.0, STORM_FILL, RED, 2430, storm_k)
	if arc_u >= 0.0 and arc_u < 1.0:
		_draw_arc()
	for r in rings:
		_draw_ring(float(r["x"]), float(r["u"]))
	for b in beams:
		_draw_beam(float(b["x"]), float(b["u"]))

## ออร่ารอบดาบ เส้นหมึกเป็นทรงเปลว ระบายขีดเฉียงสีแดงข้างใน
func _draw_aura() -> void:
	var base := _px(hero.pos.x + _dir * 0.69, 1.77)
	var long := AURA_LONG * aura_k
	var wide := AURA_WIDE * aura_k
	var sway := sin(_clock * 8.0) * 7.0
	if Sketch.anime:
		var fire := Sketch.flame(base, Vector2.UP, long * 1.15, wide * 1.6, sway)
		Sketch.fx_fill(self, fire, RED)
		fire.append(fire[0])
		Sketch.line(self, fire, 2411, 3.0, 0.6)
		return
	for n in AURA_STROKES:
		var t := (float(n) + 0.5) / AURA_STROKES
		var half := wide * sin(PI * pow(t, 0.55)) * (1.0 - 0.25 * t) * (0.7 + 0.3 * absf(sin(float(n) * 7.1)))
		var mid := base + Vector2(sway * t * t, -long * t)
		Sketch.line(self, PackedVector2Array([mid + Vector2(-half, 8.0), mid + Vector2(half, -8.0)]), 2412 + n, 2.6, 0.5, RED)
	var edge := Sketch.flame(base, Vector2.UP, long, wide, sway)
	edge.append(edge[0])
	Sketch.line(self, edge, 2411, 3.0, 0.6)

## รอยฟันพระจันทร์เสี้ยว เส้นหมึกขอบ ระบายขีดเฉียงสีแดงเหมือนใบดาบ
func _draw_arc() -> void:
	var fade := 1.0 - arc_u * arc_u
	var c := _px(_arc_x, CHEST)
	if Sketch.anime:
		_draw_arc_anime(c, fade)
		return
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in ARC_STEPS + 1:
		var t := float(i) / ARC_STEPS
		var a := deg_to_rad(lerpf(ARC_FROM, ARC_TO, t)) * _arc_flip
		var d := Vector2(cos(a) * _dir, sin(a))
		var thick := sin(t * PI)
		outer.append(c + d * ARC_R * U)
		inner.append(c + d * ARC_R * U * (1.0 - ARC_THICK * thick))
	for i in ARC_STEPS - 1:
		var seed_no := 2460 + i
		var reach := 0.75 + 0.25 * absf(sin(float(i) * 12.9))
		Sketch.line(self, PackedVector2Array([inner[i], inner[i].lerp(outer[i + 2], reach)]), seed_no, 3.0, 0.5, Color(RED, fade))
	Sketch.line(self, outer, 2420, 3.4, 0.6, Color(Sketch.INK, fade))
	Sketch.line(self, inner, 2421, 2.6, 0.6, Color(Sketch.INK, fade))

## รอยฟันอนิเมะ พระจันทร์เสี้ยวสีสด ขอบหมึก มีแกนสว่าง
func _draw_arc_anime(c: Vector2, fade: float) -> void:
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in ARC_STEPS + 1:
		var t := float(i) / ARC_STEPS
		var a := deg_to_rad(lerpf(ARC_FROM, ARC_TO, t)) * _arc_flip
		var d := Vector2(cos(a) * _dir, sin(a))
		outer.append(c + d * ARC_R * U)
		inner.append(c + d * ARC_R * U * (1.0 - ARC_THICK * sin(t * PI)))
	var band := outer.duplicate()
	var back := inner.duplicate()
	back.reverse()
	band.append_array(back)
	Sketch.fx_fill(self, band, Color(RED, fade))
	Sketch.line(self, outer, 2420, 4.2, 0.6, Color(Sketch.INK, fade))

## คลื่นกระแทกเตี้ยๆ บนพื้น เป็นเส้นวงซ้อน
func _draw_ring(x: float, u: float) -> void:
	var fade := 1.0 - u
	var r := WAVE_R * U * minf(u * 2.0, 1.0)
	for k in [1.0, 0.68, 0.38]:
		var ring := Sketch.oval(_px(x, 0.0), r * k, r * k * 0.2, 30)
		ring.append(ring[0])
		Sketch.line(self, ring, 2440 + int(k * 10.0), 3.6, 0.8, Color(Sketch.INK if k == 1.0 else RED, fade))

## คลื่นจากฟ้าเตี้ยลง เป็นเส้นหยักหลายเส้นลงมาถึงพื้น ระบายขีดเฉียงสีแดง
func _draw_beam(x: float, u: float) -> void:
	var fade := 1.0 - u
	var w := WAVE_R * U * 0.55 * minf(u * 4.0, 1.0)
	if w < 2.0:
		return
	var top := -BEAM_HIGH * U
	var cx := x * U
	if Sketch.anime:
		Sketch.fx_fill(self, PackedVector2Array([Vector2(cx - w, top), Vector2(cx + w, top), Vector2(cx + w * 0.7, 0.0), Vector2(cx - w * 0.7, 0.0)]), Color(RED, fade))
		return
	var rows := int(BEAM_HIGH * U / BEAM_STEP)
	for n in rows:
		var y := top + (float(n) + 0.5) * BEAM_STEP
		var half := w * lerpf(1.0, 0.7, float(n) / rows) * (0.75 + 0.25 * absf(sin(float(n) * 7.1)))
		Sketch.line(self, PackedVector2Array([Vector2(cx - half, y + 9.0), Vector2(cx + half, y - 9.0)]), 2474 + n, 2.8, 0.5, Color(RED, fade))
	for s in [-1.0, 1.0]:
		Sketch.line(self, PackedVector2Array([Vector2(cx + s * w, top), Vector2(cx + s * w * 0.7, 0.0)]), 2450, 3.2, 0.9, Color(Sketch.INK, fade))
