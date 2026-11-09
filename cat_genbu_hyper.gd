class_name CatGenbuHyper
extends HyperStage
## HYPER ของ GENBU TITAN (สาย PETIT SHELL ของ CAT CITRUS แมวส้มหอกยาว)
## ปักหอกลงพื้น ดึงหอกขึ้นแล้วกระโดดขึ้นฟ้าหายไป
## แมวตัวเรา (โมเดล 3 มิติ) ร่างยักษ์มีกระดองเต่าเขียวติดหลัง หางงูน้อยน่ารัก ร่วงลงมาจากฟ้า กระทืบพื้น 3 ที
## ยกมือตะโกน 2 ที มีวงเสียง ตัวโน้ต หัวใจ แล้วกระทืบเท้าซ้ายขวาสลับกัน 8 ที แล้วค่อยๆ จางหาย CITRUS ร่วงกลับลงที่เดิม

const RAISE_AT := 0.35
const PLANT_AT := 0.75
const PULL_AT := 1.0
const LEAP_FROM := 1.25
const LEAP_TO := 1.7
const DROP_FROM := 1.9
const LAND_AT := 2.5
const LAND_HITS := [2.5, 2.85, 3.2]
const ROAR_HITS := [3.65, 4.15]
const STOMP_FROM := 4.65
const STOMP_GAP := 0.28
const STOMP_COUNT := 8
const FADE_FROM := 6.85
const FADE_TO := 7.4
const RETURN_AT := 7.05
const RETURN_TO := 7.45
const END_AT := 7.8
const LAND_DMG := 40.0
const ROAR_DMG := 45.0
const STOMP_DMG := 30.0
const FINAL_DMG := 120.0
const LEAP_H := 1100.0
const DROP_H := 1600.0           # ร่างยักษ์ร่วงจากความสูงนี้
const TITAN_SIZE := 4.0          # ขนาดโมเดลร่างยักษ์ เท่ากับ HYPER อื่นของ CITRUS
const HEAD_UP := 420.0           # ระยะจากเท้าถึงหัวร่างยักษ์ (จุดภาพโลก)
# สีหลัก CITRUS ส้ม แซมเขียวมิ้นต์ (เต่า)
const GOLD := Color(1.0, 0.72, 0.38)
const CITRUS := Color(1.0, 0.6, 0.2)
const DUST := Color(1.0, 0.97, 0.9)
const PINK := Color(1.0, 0.62, 0.74)
const MINT := Color(0.6, 0.95, 0.7)

var _x0 := 0.0
var _y0 := 0.0
var _dir := 1.0
var _cx := 0.0                   # จุดยืนของร่างยักษ์
var _puffs: Array = []           # ฝุ่นฟู [ตำแหน่ง ความเร็ว อายุ ขนาด]
var _rings: Array = []           # วงแผ่นดินไหว [จุด เวลาเกิด ขนาด]
var _waves: Array = []           # คลื่นเสียงตะโกน [เวลาเกิด]
var _prints: Array = []          # รอยเท้าแมวบนพื้น [x เวลาเกิด]
var _land_done := 0
var _roar_done := 0
var _stomp_done := 0
var _plant_done := false
var _hidden := false
var _back := false
var _rng := RandomNumberGenerator.new()

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = 7.2
	end_time = END_AT
	Monster.hide_bars = true
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_rng.seed = 33
	_x0 = hero.position.x
	_y0 = hero.pos.y
	_dir = hero.facing if hero.facing != 0.0 else 1.0
	# ร่างยักษ์ลงกลางกลุ่มมอนด้านหน้า
	var sum := 0.0
	var n := 0
	for m in caught:
		if is_instance_valid(m):
			sum += (m as Monster).position.x
			n += 1
	_cx = sum / float(n) if n > 0 else _x0 + _dir * 900.0
	if (_cx - _x0) * _dir < 600.0:
		_cx = _x0 + _dir * 800.0
	# แมวกระดองเต่า หันเฉียงให้เห็นกระดองกับหางงู
	add_actor(Vector2(_cx, -DROP_H), TITAN_SIZE, -_dir * 120.0, "cat_spirit_turtle")
	actor.sword_on = false
	actor.visible = false
	add_over()

func _hit_all(dmg: float, extra := {}) -> void:
	for m in caught:
		if is_instance_valid(m):
			var h := {"type": "none", "dmg": dmg, "skill": true}
			h.merge(extra, true)
			var d := signf((m as Monster).position.x - _cx)
			(m as Monster).take_hit(h, d if d != 0.0 else _dir)

func _set_model_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

func _stage_tick(delta: float) -> void:
	hero.vel = Vector2.ZERO
	# ปักหอก
	if not _plant_done and _t >= PLANT_AT:
		_plant_done = true
		_shake = 12.0
		_dust(_spear_foot(), 5, 500.0)
		_rings.append([_spear_foot(), _t, 420.0])
	# กระโดดขึ้นฟ้า
	if _t >= LEAP_FROM and _t < RETURN_AT:
		var k := _ease((_t - LEAP_FROM) / (LEAP_TO - LEAP_FROM))
		hero.pos.y = _y0 + LEAP_H / CombatData.UNIT * k
		if not _hidden and _t >= LEAP_TO - 0.08:
			_hidden = true
			_set_model_visible(false)
	# กลับลงที่เดิม
	if _t >= RETURN_AT:
		if not _back:
			_back = true
			_set_model_visible(true)
		var b := _ease((_t - RETURN_AT) / (RETURN_TO - RETURN_AT))
		hero.pos.y = lerpf(_y0 + LEAP_H / CombatData.UNIT, _y0, b)
	_pose_titan()
	# ร่วงลงกระทืบพื้น 3 ที
	while _land_done < LAND_HITS.size() and _t >= float(LAND_HITS[_land_done]):
		_land_done += 1
		_shake = 22.0
		_hit_all(LAND_DMG)
		_quake(Vector2(_cx, 0.0), 900.0, 12)
	# ยกมือตะโกน 2 ที
	while _roar_done < ROAR_HITS.size() and _t >= float(ROAR_HITS[_roar_done]):
		_roar_done += 1
		_shake = 14.0
		_hit_all(ROAR_DMG)
		_waves.append([_t])
	# กระทืบเท้าซ้ายขวาสลับกัน 8 ที
	while _stomp_done < STOMP_COUNT and _t >= STOMP_FROM + float(_stomp_done) * STOMP_GAP + STOMP_GAP * 0.6:
		var side := -1.0 if _stomp_done % 2 == 0 else 1.0
		_stomp_done += 1
		_shake = 16.0
		var last := _stomp_done == STOMP_COUNT
		_hit_all(FINAL_DMG if last else STOMP_DMG, {"type": "knockdown", "fly": 12.0} if last else {})
		_quake(Vector2(_cx + side * 150.0, 0.0), 520.0 if not last else 950.0, 6 if not last else 14)
	for p in _puffs:
		p[2] = float(p[2]) + delta
		p[1] = (p[1] as Vector2) * 0.94 + Vector2(0.0, -40.0) * delta
		p[0] = (p[0] as Vector2) + (p[1] as Vector2) * delta
	_puffs = _puffs.filter(func(p: Array) -> bool: return float(p[2]) < 1.1)
	_rings = _rings.filter(func(r: Array) -> bool: return _t - float(r[1]) < 0.9)
	_waves = _waves.filter(func(w: Array) -> bool: return _t - float(w[0]) < 1.2)

## ท่าของร่างยักษ์ตามเวลา ร่วงลง กระเด้งตอนกระทืบ ยกมือตะโกน โยกซ้ายขวากระทืบเท้า จางหาย
func _pose_titan() -> void:
	if actor == null:
		return
	if _t < DROP_FROM:
		actor.visible = false
		return
	actor.visible = true
	var y := 0.0
	var tilt := 0.0
	var hand := Vector3(0.42, 0.68, 0.3)
	var off := Vector3(-0.42, 0.68, 0.02)
	if _t < LAND_AT:
		# ร่วงจากฟ้า เร่งลง ยกมือชูขึ้น
		var k := clampf((_t - DROP_FROM) / (LAND_AT - DROP_FROM), 0.0, 1.0)
		y = -DROP_H * (1.0 - k * k)
		hand = Vector3(0.5, 1.2, 0.2)
		off = Vector3(-0.5, 1.2, 0.0)
	elif _t < float(ROAR_HITS[0]) - 0.3:
		# กระเด้งขึ้นแล้วกระทืบลงพื้น 3 ที
		var since := 99.0
		for h in LAND_HITS:
			if _t >= float(h):
				since = _t - float(h)
		if since < 0.35 and _land_done < LAND_HITS.size():
			y = -sin(clampf(since / 0.35, 0.0, 1.0) * PI) * 110.0
	elif _t < STOMP_FROM:
		# หันหน้ามาทางกล้อง ยกมือทั้งสองขึ้นตะโกน ตัวเด้งนิดๆ ทุกครั้งที่ตะโกน
		actor.stage_turn = 0.0
		var rk := clampf((_t - (float(ROAR_HITS[0]) - 0.3)) / 0.25, 0.0, 1.0)
		hand = hand.lerp(Vector3(0.55, 1.35, 0.25), rk)
		off = off.lerp(Vector3(-0.55, 1.35, 0.05), rk)
		var last_roar := float(ROAR_HITS[1]) if _t >= float(ROAR_HITS[1]) else float(ROAR_HITS[0])
		var since_r := _t - last_roar
		if since_r >= 0.0:
			y = -sin(clampf(since_r / 0.3, 0.0, 1.0) * PI) * 50.0
	else:
		# หันกลับไปด้านข้าง โยกตัวยกขาสลับซ้ายขวา แล้วกระทืบลง
		actor.stage_turn = -_dir * 120.0
		var step := (_t - STOMP_FROM) / STOMP_GAP
		var i := floori(step)
		var f := step - float(i)
		if i < STOMP_COUNT:
			var side := -1.0 if i % 2 == 0 else 1.0
			tilt = side * 0.12 * sin(f * PI)
			y = -sin(minf(f / 0.6, 1.0) * PI) * 70.0
	var fade := 1.0 - clampf((_t - FADE_FROM) / (FADE_TO - FADE_FROM), 0.0, 1.0)
	actor.stage_hand = hand
	actor.stage_off = off
	actor.position = Vector2(_cx, y)
	actor.rotation = tilt
	actor.modulate = Color(1.0, 1.0, 1.0, fade)
	actor.visible = fade > 0.0

func _quake(at: Vector2, size: float, puffs: int) -> void:
	_rings.append([at, _t, size])
	_dust(at, puffs, size * 0.7)
	_prints.append([at.x + _rng.randf_range(-80.0, 80.0), _t])
	if _prints.size() > 16:
		_prints = _prints.slice(_prints.size() - 16)

func _dust(at: Vector2, count: int, speed: float) -> void:
	for i in count:
		var a := _rng.randf_range(PI * 1.05, PI * 1.95)
		_puffs.append([at, Vector2(cos(a) * 1.6, sin(a) * 0.5) * _rng.randf_range(speed * 0.35, speed), 0.0, _rng.randf_range(26.0, 54.0)])
	if _puffs.size() > 60:
		_puffs = _puffs.slice(_puffs.size() - 60)

func _spear_foot() -> Vector2:
	return Vector2(_x0 + _dir * 80.0, 0.0)

func _finish() -> void:
	Monster.hide_bars = false
	_set_model_visible(true)
	hero.pos.y = _y0
	if hero.plain_model != null:
		hero.plain_model.hide_blade = false
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
		hero.plain_model.hide_blade = false
	super._exit_tree()

# ---------------------------------------------------------------- วาด
func _oval(c: Vector2, rx: float, ry: float, n := 32) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## รอยเท้าแมวแบนบนพื้น
func _paw(c: Vector2, s: float, col: Color) -> void:
	# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
	draw_circle(c, s * 0.75, Color(col, col.a * 0.35 * 1.0))
	draw_circle(c, s * 0.45, Color(col, col.a * 0.7 * 1.0))

## หอกยาว ด้ามไม้ส้ม หัวหอกทอง พู่ส้ม
func _draw_spear(foot: Vector2, top: Vector2, fade: float) -> void:
	var u := (top - foot).normalized()
	var n := u.orthogonal()
	draw_line(foot, top, Color(0.55, 0.32, 0.15, fade), 14.0, true)
	draw_line(foot + n * 3.0, top + n * 3.0, Color(CITRUS, 0.8 * fade), 4.0, true)
	var tip := top + u * 90.0
	draw_colored_polygon(PackedVector2Array([top + n * 22.0, tip, top - n * 22.0, top - u * 14.0]), Color(GOLD, fade))
	draw_colored_polygon(PackedVector2Array([top + n * 8.0, tip - u * 10.0, top - n * 8.0]), Color(1.0, 1.0, 0.85, fade))
	for i in 5:
		var a := float(i - 2) * 0.25
		draw_line(top - u * 10.0, top - u * 10.0 - u.rotated(a) * 60.0 + n * sin(_t * 8.0 + float(i)) * 8.0, Color(CITRUS, fade), 6.0, true)

func _draw() -> void:
	var fade := 1.0 - clampf((_t - 7.35) / 0.35, 0.0, 1.0)
	if fade <= 0.0:
		return
	# ---------- หอก ปักลงพื้นแล้วดึงขึ้น ----------
	if _t >= RAISE_AT and _t < LEAP_TO:
		var foot := _spear_foot()
		var lift := 0.0
		if _t < PLANT_AT:
			lift = 260.0 * (1.0 - (_t - RAISE_AT) / (PLANT_AT - RAISE_AT))
		elif _t >= PULL_AT:
			lift = 200.0 * _ease((_t - PULL_AT) / 0.25)
			if _t >= LEAP_FROM:
				lift += LEAP_H * _ease((_t - LEAP_FROM) / (LEAP_TO - LEAP_FROM))
		_draw_spear(foot + Vector2(0.0, -lift - 10.0), foot + Vector2(_dir * 30.0, -lift - 360.0), 1.0)
		if _t >= PLANT_AT and _t < PULL_AT + 0.2:
			var g := 1.0 - (_t - PLANT_AT) / 0.45
			draw_circle(foot, 120.0 * (1.2 - g), Color(GOLD, 0.4 * g))
	# รอยกระโดด ลำแสงส้มพุ่งขึ้นฟ้า
	if _t >= LEAP_FROM and _t < LEAP_TO + 0.3:
		var lk := clampf((_t - LEAP_FROM) / (LEAP_TO + 0.3 - LEAP_FROM), 0.0, 1.0)
		draw_line(Vector2(_x0, -40.0), Vector2(_x0, -40.0 - LEAP_H * minf(lk * 1.6, 1.0)), Color(CITRUS, 0.6 * (1.0 - lk)), 30.0 * (1.0 - lk) + 2.0, true)
	# เงาบนพื้นตอนร่างยักษ์ร่วงลง ใหญ่ขึ้นเรื่อยๆ
	if _t >= DROP_FROM and _t < FADE_TO:
		var sk := clampf((_t - DROP_FROM) / (LAND_AT - DROP_FROM), 0.0, 1.0)
		var tf := 1.0 - clampf((_t - FADE_FROM) / (FADE_TO - FADE_FROM), 0.0, 1.0)
		draw_colored_polygon(_oval(Vector2(_cx, 6.0), 420.0 * (0.3 + 0.7 * sk), 60.0 * (0.3 + 0.7 * sk), 28), Color(0.0, 0.0, 0.0, 0.35 * tf))
	# รอยเท้าแมวบนพื้น
	for c in _prints:
		var age := _t - float(c[1])
		var ca := clampf(1.0 - (age - 1.4) / 0.6, 0.0, 1.0) * fade
		if ca <= 0.0:
			continue
		_paw(Vector2(float(c[0]), 8.0), 90.0 * minf(age / 0.15, 1.0) + 2.0, Color(0.55, 0.85, 0.6, 0.55 * ca))
	# วงแผ่นดินไหว
	for r in _rings:
		var k := (_t - float(r[1])) / 0.9
		var size := float(r[2]) * (0.3 + 0.9 * k)
		var ring := _oval(r[0], size, size * 0.18, 40)
		ring.append(ring[0])
		draw_polyline(ring, Color(1.0, 0.95, 0.75, (1.0 - k) * 0.8 * fade), 12.0 * (1.0 - k) + 2.0, true)

## ชั้นหน้าร่างยักษ์: ฝุ่นฟูนุ่มๆ และวงเสียงตะโกน ตัวโน้ต หัวใจ
func _draw_over() -> void:
	var fade := 1.0 - clampf((_t - 7.35) / 0.35, 0.0, 1.0)
	if fade <= 0.0:
		return
	for p in _puffs:
		var s := float(p[3])
		var pa := (1.0 - float(p[2]) / 1.1) * fade
		over.draw_circle(p[0], s * (1.0 + 0.4 * float(p[2])), Color(DUST, 0.8 * pa))
	if actor == null:
		return
	var head := Vector2(_cx, actor.position.y - HEAD_UP)
	# ตะโกนวงกว้างน่ารักๆ วงกลมนุ่มสีพาสเทลแผ่ออกทั่วจอ มีตัวโน้ต หัวใจ ดาวลอยออกรอบทิศ
	var ring_cols := [Color(1.0, 0.92, 0.75), Color(1.0, 0.75, 0.85), Color(0.75, 0.95, 0.85)]
	for w in _waves:
		var k := (_t - float(w[0])) / 1.2
		var a := (1.0 - k) * fade
		for j in 4:
			var rr := 120.0 + (k + float(j) * 0.15) * 1500.0
			var col: Color = ring_cols[j % 3]
			over.draw_arc(head, rr, 0.0, TAU, 64, Color(col, a * (0.85 - float(j) * 0.15)), 16.0 * (1.0 - k) + 4.0, true)
		for j in 12:
			var ang := float(j) * TAU / 12.0 + 0.2
			var p := head + Vector2(cos(ang), sin(ang) * 0.8) * (200.0 + k * 1100.0)
			match j % 3:
				0:
					_note(p, 44.0, Color(MINT, a))
				1:
					_heart(p, 40.0, Color(PINK, a))
				_:
					_star5(p, 26.0, Color(1.0, 0.9, 0.5, a))

func _star5(c: Vector2, s: float, col: Color) -> void:
	# ประกายกลมนุ่ม ไม่มีแฉก
	over.draw_circle(c, s * 0.75, Color(col, col.a * 0.3))
	over.draw_circle(c, s * 0.42, col)

func _note(c: Vector2, s: float, col: Color) -> void:
	over.draw_colored_polygon(_oval(c, s * 0.42, s * 0.3, 14), col)
	over.draw_line(c + Vector2(s * 0.38, 0.0), c + Vector2(s * 0.38, -s * 1.2), col, s * 0.14, true)
	over.draw_line(c + Vector2(s * 0.38, -s * 1.2), c + Vector2(s * 0.8, -s * 0.95), col, s * 0.14, true)

func _heart(c: Vector2, s: float, col: Color) -> void:
	over.draw_circle(c + Vector2(-s * 0.26, -s * 0.1), s * 0.3, col)
	over.draw_circle(c + Vector2(s * 0.26, -s * 0.1), s * 0.3, col)
	over.draw_colored_polygon(PackedVector2Array([c + Vector2(-s * 0.54, 0.0), c + Vector2(s * 0.54, 0.0), c + Vector2(0.0, s * 0.6)]), col)
