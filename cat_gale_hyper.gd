class_name CatGaleHyper
extends HyperStage
## HYPER ของ GALE TEMPEST (CAT MATCHA สาย WINDSTARKER) จอดำ กล้องถอยไกล มอนสตั๊น
## ซ่อนธนู ยกมือขึ้น พายุลูกเล็กเกิดด้านหน้าแล้วค่อยๆ ใหญ่ขึ้น ดูดมอนเข้าไปหมุนในพายุ
## แมววิ่งเข้าไปในพายุ วิ่งวนเป็นเกลียวไต่ขึ้นไปตามกรวยพายุเร็วขึ้นเรื่อยๆ (เงาเขียวมีภาพติดตา ผ่านหน้าและหลังพายุ) ฮิตรัวๆ
## ถึงยอดพายุ พายุสลาย แมวดีดตัวขึ้นเหนือยอด แล้วดิ่งกระทืบลงพื้น คลื่นกระแทกวงใหญ่ ฮิตสุดท้ายแรง

const RAISE_AT := 0.3
const STORM_AT := 0.7            # พายุลูกเล็กเกิด
const GROW_TO := 2.0             # พายุใหญ่เต็มที่
const RUN_IN := 2.0              # วิ่งเข้าพายุ
const ORBIT_FROM := 2.4
const ORBIT_TO := 4.8
const FADE_TO := 5.2             # พายุสลายหมด
const LEAP_TO := 5.8             # ลอยถึงจุดสูงสุด
const STOMP_AT := 6.05           # กระทืบถึงพื้น
const AHEAD := 4.5               # พายุอยู่หน้าตัวละคร (หน่วยเกม)
const ORBIT_R := 2.6             # รัศมีวิ่งวน (หน่วยเกม)
const LEAP_Y := 7.5
const STORM_H := 620.0           # ความสูงพายุเต็มที่ (จุดภาพ) ยอดพายุอยู่ในจอ
const STORM_TOP_W := 480.0
const STORM_BOT_W := 150.0
const TICK := 0.25
const TICK_DMG := 10.0
const RUN_GAP := 0.12
const RUN_DMG := 16.0
const STOMP_DMG := 200.0
# สีหลัก MATCHA เขียว แซมขาวลม
const JADE := Color(0.6, 0.84, 0.42)
const DEEP := Color(0.3, 0.52, 0.22)
const MINT := Color(0.93, 1.0, 0.9)
const PINK := Color(1.0, 0.72, 0.82)

var _sx := 0.0                   # ตำแหน่งพายุ (หน่วยเกม)
var _home_x := 0.0
var _facing := 1.0
var _tick := 0.0
var _run_hit := 0.0
var _stomped := false
var _ghosts: Array = []          # ภาพติดตาตอนวิ่งวน [ตำแหน่ง อายุ]
var _ghost_t := 0.0
var _raise_move := {}
var _leaves: Array = []          # เศษใบไม้/อุ้งเท้าที่หมุนในพายุ [มุม ความสูง 0-1 ความเร็ว ชนิด]
var _top_y := 0.0                # ความสูงที่แมวไต่ถึงยอดพายุ (หน่วยเกม)
var _apex_y := 0.0               # จุดสูงสุดก่อนดิ่งลงกระทืบ
const CLIMB_MAX := 0.9           # ไต่ขึ้นไปถึงกี่ส่วนของความสูงพายุ
const RUN_UP := 50.0             # กึ่งกลางตัวแมวสูงจากทางวิ่ง (จุดภาพ)

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = STOMP_AT + 0.7
	end_time = close_from + 0.45
	Monster.hide_bars = true
	_facing = hero.facing if hero.facing != 0.0 else 1.0
	_home_x = hero.pos.x
	_sx = clampf(hero.pos.x + _facing * AHEAD, -hero.half_width + ORBIT_R, hero.half_width - ORBIT_R)
	# ท่ายกมือขึ้นฟ้า ใช้ระบบท่าคอมโบของโมเดล
	_raise_move = {"name": "ยกมือเรียกพายุ", "wind_hand": Vector3(0.25, 1.05, 0.2), "wind_aim": Vector2(-90.0, 0.0), "end_hand": Vector3(0.3, 1.1, 0.2), "end_aim": Vector2(-90.0, 0.0), "wind_off": Vector3(0.35, 0.2, 0.1), "end_off": Vector3(0.35, 0.2, 0.1), "ease": 2.0, "time": 1.0, "wind": 0.45, "strike": 0.6, "next": 0.9, "dmg": 0.0, "lunge": 0.0, "no_hit": true, "shake": 0.0, "stop": 0.0, "lean": -8.0, "twist": 0.0}
	for i in 46:
		_leaves.append([randf() * TAU, randf(), randf_range(4.0, 9.0), i % 3])

func _hit_all(dmg: float) -> void:
	for monster in caught:
		if is_instance_valid(monster):
			monster.take_hit({"type": "none", "dmg": dmg, "skill": true}, 0.0)

## ขนาดพายุ 0 ถึง 1
func _storm_k() -> float:
	if _t < STORM_AT:
		return 0.0
	if _t < GROW_TO:
		var g := (_t - STORM_AT) / (GROW_TO - STORM_AT)
		return 0.12 + 0.88 * g * g
	if _t < ORBIT_TO:
		return 1.0
	return 1.0 - _ease((_t - ORBIT_TO) / (FADE_TO - ORBIT_TO))

## ไต่ขึ้นไปตามกรวยพายุ 0 ถึง CLIMB_MAX ช่วงท้ายไต่เร็วขึ้น
func _climb() -> float:
	return _climb_at(_t)

func _climb_at(t: float) -> float:
	var u := clampf((t - ORBIT_FROM) / (ORBIT_TO - ORBIT_FROM), 0.0, 1.0)
	return CLIMB_MAX * (0.55 * u + 0.45 * u * u)

## กว้างของกรวยพายุที่ความสูง u (0 ฐาน 1 ยอด) ตอนพายุเต็มขนาด
func _funnel_w(u: float) -> float:
	return lerpf(STORM_BOT_W, STORM_TOP_W, pow(u, 1.25))

## ตำแหน่งบนเกลียวรอบกรวยพายุ (จุดภาพ) ที่มุม ang ความสูง u
func _helix_at(ang: float, u: float) -> Vector2:
	var w := _funnel_w(u) * 0.92
	var sway := sin(_t * 3.0 + u * 4.0) * 40.0
	return Vector2(_sx * CombatData.UNIT + sway + cos(ang) * w * -_facing, -STORM_H * u + sin(ang) * w * 0.16 - RUN_UP)

## ตำแหน่งตัวแมวตอนวิ่ง (จุดภาพ)
func _runner_px() -> Vector2:
	if _t < RUN_IN:
		return Vector2(_home_x * CombatData.UNIT, -RUN_UP)
	var entry := _helix_at(0.0, 0.0)
	if _t < ORBIT_FROM:
		var k := _ease((_t - RUN_IN) / (ORBIT_FROM - RUN_IN))
		return Vector2(lerpf(_home_x * CombatData.UNIT, entry.x, k), lerpf(-RUN_UP, entry.y, k))
	return _helix_at(_orbit_a(), _climb())

## ตัวแมวตอนวิ่ง (หน่วยเกม)
func _runner_x() -> float:
	return _runner_px().x / CombatData.UNIT

## มุมวิ่งวน เร่งขึ้นเรื่อยๆ
func _orbit_a() -> float:
	return _orbit_a_at(_t)

func _orbit_a_at(t: float) -> float:
	var u := clampf(t - ORBIT_FROM, 0.0, ORBIT_TO - ORBIT_FROM)
	return u * 9.0 + u * u * 2.2

## แมวอยู่ด้านหน้าพายุ (ใกล้กล้อง) หรือไม่
func _runner_front() -> bool:
	return _t < ORBIT_FROM or sin(_orbit_a()) > 0.0

func _running() -> bool:
	return _t >= RUN_IN and _t < ORBIT_TO

func _stage_tick(delta: float) -> void:
	hero.vel = Vector2.ZERO
	if hero.plain_model != null:
		hero.plain_model.hide_blade = _t >= RAISE_AT - 0.1
		hero.plain_model.visible = not _running()
	# ยกมือ
	if _t >= RAISE_AT and _t < RUN_IN:
		hero.plain_swing_kind = "combo"
		hero.plain_move = _raise_move
		hero.plain_swing = clampf(0.25 + (_t - RAISE_AT) * 0.4, 0.25, 0.5)
	elif _t >= RUN_IN:
		hero.plain_swing_kind = "hyper"
		hero.plain_swing = 0.5
	# ตำแหน่งแมว วิ่งเกลียวขึ้นไปตามพายุ ถึงยอดแล้วดีดขึ้นเหนือยอด ค้างนิดหนึ่ง แล้วดิ่งลงกระทืบ
	if _t < ORBIT_TO:
		var rp := _runner_px()
		hero.pos.x = rp.x / CombatData.UNIT
		hero.pos.y = maxf((-rp.y - RUN_UP) / CombatData.UNIT, 0.0)
		_top_y = hero.pos.y
		_apex_y = _top_y + 0.3
	elif _t < FADE_TO:
		var k := _ease((_t - ORBIT_TO) / (FADE_TO - ORBIT_TO))
		hero.pos.x = lerpf(hero.pos.x, _sx, k)
		hero.pos.y = lerpf(_top_y, _apex_y, k)
		hero.facing = _facing
	elif _t < LEAP_TO:
		hero.pos.x = _sx
		hero.pos.y = _apex_y + 0.15 * sin((_t - FADE_TO) / (LEAP_TO - FADE_TO) * PI)
		hero.facing = _facing
	elif _t < STOMP_AT:
		var k := (_t - LEAP_TO) / (STOMP_AT - LEAP_TO)
		hero.pos.x = _sx
		hero.pos.y = _apex_y * (1.0 - k * k)
	else:
		hero.pos.y = 0.0
	if _t >= ORBIT_FROM and _t < ORBIT_TO:
		var s_dir := sin(_orbit_a()) * _facing
		hero.facing = signf(s_dir) if s_dir != 0.0 else _facing
	# ภาพติดตา
	_ghost_t -= delta
	if _running() and _ghost_t <= 0.0:
		_ghost_t = 0.025
		_ghosts.append([_runner_px(), 0.0, _runner_front()])
	for g in _ghosts:
		g[1] = float(g[1]) + delta
	_ghosts = _ghosts.filter(func(g): return float(g[1]) < 0.32)
	# ดูดมอนเข้าพายุ หมุนลอยในพายุ
	var sk := _storm_k()
	var n := 0
	for monster in caught:
		if not is_instance_valid(monster):
			continue
		var start: Vector2 = _start_at[monster]
		if _t >= STORM_AT and _t < STOMP_AT:
			var pull := _ease((_t - STORM_AT) / (GROW_TO - STORM_AT + 0.3))
			var spin := _t * (3.0 + float(n % 3)) + float(n) * 1.7
			var inside_x := _sx + sin(spin) * ORBIT_R * 0.55 * sk
			var inside_y := (1.0 + float(n % 4) * 1.1 + sin(spin * 1.3) * 0.4) * sk
			monster.pos.x = lerpf(start.x, inside_x, pull)
			monster.pos.y = lerpf(0.0, inside_y, pull) if _t < FADE_TO else maxf(monster.pos.y - delta * 14.0, 0.0)
		elif _t >= STOMP_AT:
			monster.pos.y = maxf(monster.pos.y - delta * 18.0, 0.0)
		n += 1
	# ดาเมจลมพายุ
	if sk > 0.4 and _t < ORBIT_TO:
		_tick -= delta
		if _tick <= 0.0:
			_tick = TICK
			_hit_all(TICK_DMG)
	# ฮิตรัวตอนวิ่งวน
	if _t >= ORBIT_FROM and _t < ORBIT_TO:
		_run_hit -= delta
		if _run_hit <= 0.0:
			_run_hit = RUN_GAP
			_hit_all(RUN_DMG)
			_shake = maxf(_shake, 5.0)
	if not _stomped and _t >= STOMP_AT:
		_stomped = true
		_hit_all(STOMP_DMG)
		_shake = 26.0

func _finish() -> void:
	_restore()
	super._finish()

func _exit_tree() -> void:
	_restore()
	super._exit_tree()

func _restore() -> void:
	Monster.hide_bars = false
	if is_instance_valid(hero):
		hero.pos.y = 0.0
		hero.facing = _facing
		if hero.plain_model != null:
			hero.plain_model.hide_blade = false
			hero.plain_model.visible = true

# ---------------------------------------------------------------- ลายแมว
func _paw(c: Vector2, s: float, col: Color, ry_k := 1.0) -> void:
	# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
	draw_circle(c, s * 0.75, Color(col, col.a * 0.35 * 1.0))
	draw_circle(c, s * 0.45, Color(col, col.a * 0.7 * 1.0))

func _ears(c: Vector2, r: float, col: Color) -> void:
	# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
	pass

func _star(at: Vector2, r: float, col: Color) -> void:
	# ประกายกลมนุ่ม ไม่มีแฉก
	if r < 1.0:
		return
	draw_circle(at, r * 0.75, Color(col, col.a * 0.3))
	draw_circle(at, r * 0.4, col)

## เงาแมวเขียววิ่งเร็ว ตัวกลมมีหู ลายสลิด
func _blur_cat(c: Vector2, a: float, dir: float) -> void:
	draw_circle(c, 52.0, Color(JADE, 0.25 * a))
	draw_circle(c, 40.0, Color(0.55, 0.8, 0.45, a))
	_ears(c + Vector2(0.0, -6.0), 40.0, Color(0.55, 0.8, 0.45, a))
	for i in 3:
		draw_line(c + Vector2(-dir * (10.0 + float(i) * 12.0), -30.0), c + Vector2(-dir * (14.0 + float(i) * 12.0), 30.0), Color(0.25, 0.5, 0.25, 0.8 * a), 5.0, true)
	draw_circle(c + Vector2(dir * 16.0, -6.0), 5.0, Color(0.1, 0.1, 0.1, a))

## แมววิ่งเกลียวรอบพายุ front=true วาดฝั่งหน้า false วาดฝั่งหลัง (หลังพายุจางและเล็กลง)
func _draw_runner(front: bool) -> void:
	# ริบบิ้นลมเรืองแสงตามเกลียวที่วิ่งผ่านมา เห็นชัดว่าไต่วนขึ้นไป
	if _t >= ORBIT_FROM:
		var seg := PackedVector2Array()
		var seg_front := true
		for k in 46:
			var tt := _t - float(k) * 0.022
			if tt < ORBIT_FROM:
				break
			var ang := _orbit_a_at(tt)
			var p := _helix_at(ang, _climb_at(tt)) + Vector2(0.0, RUN_UP * 0.4)
			var f2 := sin(ang) > 0.0
			if seg.size() > 0 and f2 != seg_front:
				_ribbon(seg, seg_front == front, float(k) / 46.0)
				seg = PackedVector2Array([seg[seg.size() - 1]])
			seg_front = f2
			seg.append(p)
		if seg.size() > 1:
			_ribbon(seg, seg_front == front, 1.0)
	# ภาพติดตาตามเกลียว
	for g in _ghosts:
		if bool(g[2]) != front:
			continue
		var gk := 1.0 - float(g[1]) / 0.32
		var gp: Vector2 = g[0]
		_blur_cat_k(gp, 0.45 * gk * (1.0 if front else 0.55), hero.facing, 1.6 if front else 1.25)
	if _runner_front() != front:
		return
	var cur := _runner_px()
	# ทิศวิ่งตามเกลียว ใช้ทำเส้นความเร็วตามแนวสัมผัส
	var ahead := _helix_at(_orbit_a() + 0.12, _climb() + 0.004) if _t >= ORBIT_FROM else cur + Vector2(_facing * 10.0, 0.0)
	var tdir := (ahead - cur).normalized() if ahead != cur else Vector2(hero.facing, 0.0)
	var nrm := tdir.orthogonal()
	var a := 1.0 if front else 0.6
	for i in 6:
		var off := nrm * (-40.0 + float(i) * 16.0)
		draw_line(cur + off - tdir * 60.0, cur + off - tdir * (200.0 + 60.0 * float(i % 3)), Color(1.0, 1.0, 1.0, 0.7 * a), 4.0, true)
	_blur_cat_k(cur, a, signf(tdir.x) if tdir.x != 0.0 else hero.facing, 1.6 if front else 1.25)
	# รอยเท้าลมเรืองตามทางวิ่งบนเกลียว
	if _t >= ORBIT_FROM:
		for i in 8:
			var ang := _orbit_a() - float(i) * 0.3
			var u := maxf(_climb() - float(i) * 0.01, 0.0)
			var p := _helix_at(ang, u) + Vector2(0.0, RUN_UP - 4.0)
			if (sin(ang) > 0.0) == front:
				_paw(p, 14.0, Color(MINT, 0.6 * a * (1.0 - float(i) / 8.0)), 0.35)

## เส้นลมตามเกลียว วาดเฉพาะฝั่งเดียวกับที่กำลังวาด (หน้า/หลังพายุ)
func _ribbon(pts: PackedVector2Array, this_side: bool, age: float) -> void:
	if not this_side or pts.size() < 2:
		return
	var a := 1.0 - age * 0.7
	draw_polyline(pts, Color(JADE, 0.35 * a), 26.0, true)
	draw_polyline(pts, Color(MINT, 0.8 * a), 10.0, true)
	draw_polyline(pts, Color(1.0, 1.0, 1.0, 0.9 * a), 3.5, true)

func _blur_cat_k(c: Vector2, a: float, dir: float, size_k: float) -> void:
	draw_set_transform(c, 0.0, Vector2.ONE * size_k)
	_blur_cat(Vector2.ZERO, a, dir)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

# ---------------------------------------------------------------- วาด
func _draw() -> void:
	var fade := 1.0 - clampf((_t - close_from) / 0.3, 0.0, 1.0)
	var base := Vector2(_sx * CombatData.UNIT, 0.0)
	var sk := _storm_k()
	# ลมรวมที่มือตอนยกมือ
	if _t >= RAISE_AT and _t < GROW_TO:
		var hand := hero.position + Vector2(hero.facing * 20.0, -230.0)
		var hk := clampf((_t - RAISE_AT) / 0.6, 0.0, 1.0)
		draw_circle(hand, 70.0 * hk, Color(JADE, 0.25))
		for i in 3:
			var pts := PackedVector2Array()
			for j in 14:
				var u := float(j) / 13.0
				var ang := _t * 12.0 + float(i) * TAU / 3.0 + u * 4.0
				pts.append(hand + Vector2(cos(ang), sin(ang) * 0.6) * (20.0 + u * 90.0 * hk))
			draw_polyline(pts, Color(MINT, 0.8 * hk), 5.0, true)
		# เส้นลมจากมือพุ่งไปที่พายุ
		if _t >= STORM_AT:
			draw_line(hand, base + Vector2(0.0, -120.0), Color(MINT, 0.35), 10.0, true)
	# แมวที่วิ่งอยู่หลังพายุ วาดก่อนตัวพายุ
	if _running():
		_draw_runner(false)
	if sk > 0.0 and fade > 0.0:
		var h := STORM_H * sk
		var bot := STORM_BOT_W * (0.4 + 0.6 * sk)
		var top_w := STORM_TOP_W * sk
		# แสงฟุ้งรอบพายุ
		for k in 3:
			draw_circle(base + Vector2(0.0, -h * 0.5), (h * 0.55 + float(k) * 90.0), Color(JADE, 0.06 * fade))
		# ฝุ่นวนที่ฐาน
		for i in 3:
			var rr := bot * (1.6 + float(i) * 0.7) + 40.0 * sin(_t * 6.0 + float(i))
			var ring := PackedVector2Array()
			for j in 33:
				var ang := TAU * float(j) / 32.0 + _t * (4.0 - float(i))
				ring.append(base + Vector2(cos(ang) * rr, sin(ang) * rr * 0.18))
			draw_polyline(ring, Color(MINT, (0.55 - float(i) * 0.15) * fade), 6.0, true)
		# เนื้อพายุโปร่งแสง ไล่สีเขียวหยกเข้มล่างไปขาวมิ้นต์บน
		var body := PackedVector2Array()
		var cols := PackedColorArray()
		for side in [-1.0, 1.0]:
			for j in 13:
				var u2 := float(j) / 12.0 if side < 0.0 else 1.0 - float(j) / 12.0
				var w2 := lerpf(bot, top_w, pow(u2, 1.25))
				body.append(base + Vector2(sin(_t * 3.0 + u2 * 4.0) * 40.0 * sk + side * w2, -h * u2))
				cols.append(Color(DEEP.lerp(MINT, u2), (0.22 + 0.18 * u2) * fade))
		if h > 20.0:
			draw_polygon(body, cols)
		# ตัวกรวยพายุ วงรีซ้อนหมุน
		var layers := 15
		for i in layers:
			var u := float(i) / float(layers - 1)
			var y := -h * u
			var w := lerpf(bot, top_w, pow(u, 1.25))
			var sway := sin(_t * 3.0 + u * 4.0) * 40.0 * sk
			var c := base + Vector2(sway, y)
			var ph := _t * 10.0 + u * 7.0
			var arc := PackedVector2Array()
			for j in 25:
				var ang := ph + PI * float(j) / 24.0
				arc.append(c + Vector2(cos(ang) * w, sin(ang) * w * 0.16))
			draw_polyline(arc, Color(JADE.lerp(MINT, u), (0.55 + 0.35 * u) * fade), 9.0 * (0.6 + u), true)
			var back := PackedVector2Array()
			for j in 25:
				var ang := ph + PI + PI * float(j) / 24.0
				back.append(c + Vector2(cos(ang) * w, sin(ang) * w * 0.16))
			draw_polyline(back, Color(DEEP, 0.35 * fade), 6.0 * (0.6 + u), true)
		# ปลายลมรูปหูแมวรอบขอบบน
		var top_c := base + Vector2(sin(_t * 3.0 + 4.0) * 40.0 * sk, -h)
		for i in 6:
			var ang := _t * 5.0 + TAU * float(i) / 6.0
			var p := top_c + Vector2(cos(ang) * top_w, sin(ang) * top_w * 0.16)
			var tip_h := 70.0 * sk
			draw_colored_polygon(PackedVector2Array([p + Vector2(-26.0 * sk, 0.0), p + Vector2(6.0 * sk, -tip_h), p + Vector2(26.0 * sk, 0.0)]), Color(MINT, 0.85 * fade))
			draw_colored_polygon(PackedVector2Array([p + Vector2(-11.0 * sk, -4.0), p + Vector2(4.0 * sk, -tip_h * 0.6), p + Vector2(11.0 * sk, -4.0)]), Color(PINK, 0.8 * fade))
		# เส้นลมเฉียงหมุนรอบกรวย
		for i in 20:
			var u := fposmod(float(i) * 0.137 + _t * 0.5, 1.0)
			var ang := _t * 9.0 + float(i) * 1.9
			var w := lerpf(bot, top_w, u) * 1.08
			var p := base + Vector2(cos(ang) * w, -h * u + sin(ang) * w * 0.16)
			var q := base + Vector2(cos(ang - 0.5) * w, -h * u + sin(ang - 0.5) * w * 0.16 + 26.0)
			draw_line(q, p, Color(1.0, 1.0, 1.0, 0.7 * fade), 4.0, true)
		# ใบไม้ อุ้งเท้า ดาว หมุนในพายุ
		for lf in _leaves:
			var u: float = lf[1]
			var ang: float = float(lf[0]) + _t * float(lf[2])
			var w := lerpf(bot, top_w, u) * 0.9
			var p := base + Vector2(cos(ang) * w, -h * u + sin(ang) * w * 0.16)
			var kind: int = lf[3]
			if kind == 0:
				_paw(p, 16.0 * sk + 3.0, Color(MINT, 0.9 * fade))
			elif kind == 1:
				draw_colored_polygon(PackedVector2Array([p + Vector2(-12.0, 0.0), p + Vector2(0.0, -7.0), p + Vector2(12.0, 0.0), p + Vector2(0.0, 7.0)]), Color(0.5, 0.85, 0.35, 0.9 * fade))
			else:
				_star(p, 10.0 * sk + 2.0, Color(1.0, 1.0, 0.85, 0.9 * fade))
		# ตาแมวสองดวงกลางพายุ
		if sk > 0.5:
			var ec := base + Vector2(0.0, -h * 0.55)
			for side in [-1.0, 1.0]:
				var e := ec + Vector2(side * 60.0 * sk, 0.0)
				draw_arc(e, 22.0 * sk, PI * 1.1, PI * 1.9, 10, Color(1.0, 1.0, 1.0, 0.75 * fade), 7.0, true)
	# แมวที่วิ่งอยู่หน้าพายุ วาดทับตัวพายุ
	if _running():
		_draw_runner(true)
	# ดีดตัวขึ้นจากยอดพายุ เกลียวลมตามตัว
	if _t >= ORBIT_TO and _t < LEAP_TO:
		var pc := hero.position + Vector2(0.0, -60.0)
		for i in 3:
			var pts := PackedVector2Array()
			for j in 16:
				var u := float(j) / 15.0
				var ang := _t * 14.0 + float(i) * TAU / 3.0 + u * 5.0
				pts.append(pc + Vector2(cos(ang) * (40.0 + 70.0 * u), 30.0 + u * 160.0 + sin(ang) * 14.0))
			draw_polyline(pts, Color(MINT, 0.75 * fade), 5.0, true)
	# ลอยขึ้น เส้นลมใต้เท้า
	if _t >= FADE_TO and _t < STOMP_AT:
		var feet := hero.position
		for i in 5:
			var x := feet.x + (float(i) - 2.0) * 24.0
			draw_line(Vector2(x, feet.y + 10.0), Vector2(x, feet.y + 140.0 + 40.0 * float(i % 2)), Color(MINT, 0.6), 5.0, true)
		draw_circle(feet + Vector2(0.0, -60.0), 90.0, Color(JADE, 0.18))
	# กระทืบลง คลื่นกระแทกวงใหญ่
	if _t >= STOMP_AT and fade > 0.0:
		var k := clampf((_t - STOMP_AT) / 0.7, 0.0, 1.0)
		var a := (1.0 - k) * fade
		var c := base
		for i in 3:
			var rr := (300.0 + 2200.0 * k) * (1.0 - float(i) * 0.22)
			var ring := PackedVector2Array()
			for j in 49:
				var ang := TAU * float(j) / 48.0
				ring.append(c + Vector2(cos(ang) * rr, sin(ang) * rr * 0.16))
			draw_polyline(ring, Color(MINT if i == 0 else JADE, a * (1.0 - float(i) * 0.25)), 16.0 * (1.0 - k) + 3.0, true)
		for i in 18:
			var ang := TAU * float(i) / 18.0 + 0.15
			var d := Vector2(cos(ang), sin(ang) * 0.6)
			var tip := c + Vector2(0.0, -60.0) + d * (300.0 + 1300.0 * k) * (1.0 if i % 2 == 0 else 0.6)
			var side := d.orthogonal() * 16.0 * (1.0 - k)
			draw_colored_polygon(PackedVector2Array([c + Vector2(0.0, -60.0) + side, tip, c + Vector2(0.0, -60.0) - side]), Color(1.0, 1.0, 1.0, 0.7 * a))
		draw_circle(c + Vector2(0.0, -60.0), 340.0 * (1.0 - k), Color(MINT, 0.5 * a))
		# รอยแตกพื้นสีหยกแผ่ซ้ายขวา
		for i in 8:
			var side := -1.0 if i % 2 == 0 else 1.0
			var p0 := c
			for j in 5:
				var p1 := p0 + Vector2(side * (90.0 + 40.0 * float((i + j) % 3)) * minf(k * 4.0, 1.0), (float((i * 7 + j * 3) % 5) - 2.0) * 9.0)
				draw_line(p0, p1, Color(JADE.lerp(MINT, 0.5), a), 7.0 - float(j), true)
				p0 = p1
		_paw(c + Vector2(0.0, 10.0), 260.0 * (0.6 + 0.4 * k), Color(JADE, 0.6 * a), 0.3)
		for i in 10:
			var ang := TAU * float(i) / 10.0
			var p := c + Vector2(cos(ang) * (500.0 + 900.0 * k), -30.0 - 220.0 * sin(k * PI) * (0.5 + 0.5 * float(i % 2)))
			draw_circle(p, 60.0 * (1.0 - k) + 10.0, Color(0.85, 0.95, 0.88, 0.45 * a))
