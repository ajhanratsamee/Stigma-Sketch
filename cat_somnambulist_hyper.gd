class_name CatSomnambulistHyper
extends HyperStage
## HYPER ของ SOMNAMBULIST (ตัวละครคู่ CAT AZURE / CAT LAPIS สาย SPARK DREAMER)
## ทั้งคู่แปลงร่างเป็นปีศาจเต็มตัว (cat_azure_demon_a / cat_lapis_demon)
## AZURE ลอยตัวด้านหน้า LAPIS ยืนชิดด้านหลังเธอ ทั้งคู่รวมพลังพร้อมกัน 3 วิ
## (LAPIS เล็งดาบปลายปืนส่งพลังม่วงเข้าลูกพลังหน้า AZURE ดาวกลางหลังเรือง)
## แล้วยิงพร้อมกัน: คลื่นน้ำเงินดำของ AZURE กับลำแสงม่วงของ LAPIS รวมเป็นลำเดียว
## สูงเกือบครึ่งจอ ยาว 2 จอครึ่ง แล้วทั้งคู่กลับร่างเดิม  จอดำ กล้องถอย

const U := CombatData.UNIT
const SHOW_AT := 0.45            # แปลงร่างปรากฏ
const CHARGE_FROM := 0.9
const CHARGE_TO := 3.9           # รวมพลัง 3 วิ
const BEAM_FROM := 3.9
const BEAM_TO := 5.4
const BACK_FROM := 5.6           # กลับร่างเดิม
const CLOSE_AT := 6.1
const END_AT := 6.7
const BEAM_TICK := 0.1
const BEAM_DMG := 26.0
const FINAL_DMG := 320.0
const BEAM_SCREEN := 0.45        # ความสูงลำแสงเทียบความสูงจอ
# สีหลัก AZURE ฟ้าอ่อน แซมน้ำเงินดำ (คลื่นปีศาจ)
const BLUE := Color(0.5, 0.74, 1.0)
const NAVY := Color(0.08, 0.1, 0.3)
const INKY := Color(0.04, 0.03, 0.1)
const VIOLET := Color(0.42, 0.62, 0.98)
const SKY := Color(0.72, 0.88, 1.0)
const WHITE := Color(1.0, 1.0, 1.0)

var _f := 1.0
var _start_pos := Vector2.ZERO
var _az_at := Vector2.ZERO        # ตำแหน่งของ AZURE (จุดภาพโลก)
var _lp_at := Vector2.ZERO
var _orb := Vector2.ZERO          # ลูกพลังหน้า AZURE
var _muzzle := Vector2.ZERO       # ปลายดาบปลายปืน LAPIS
var _reach := 0.0                 # 2 จอครึ่ง
var _lapis: ChibiModel
var _beam_h := 0.0                # ความสูงลำแสงรวม (หน่วยโลก)
var _beam_t := 0.0
var _final := false
var _shown := false
var _back := false
var _sparks: Array = []           # [ตำแหน่ง ความเร็ว อายุ สี]
var _rng := RandomNumberGenerator.new()
var _sz := 1.0                    # ขนาดตัวละครเท่าตัวผู้เล่นปกติ
var _k := 1.0                     # ระยะที่ผูกกับขนาดตัว (เทียบกับขนาด 3)

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = CLOSE_AT
	end_time = END_AT
	Monster.hide_bars = true
	_rng.seed = 77
	_f = hero.facing if hero.facing != 0.0 else 1.0
	_start_pos = hero.pos
	_reach = 2.5 * 2.0 * screen_half_world().x
	_beam_h = BEAM_SCREEN * 2.0 * screen_half_world().y
	# ขนาดปกติเท่าตัวผู้เล่นบนจอ ไม่ทำตัวใหญ่
	_sz = ChibiModel.PX_PER_UNIT / ChibiModel.LEGACY_PX * absf(hero.scale.y)
	if hero.plain_model != null:
		_sz *= absf(hero.plain_model.scale.y)
	_k = _sz / 3.0
	var base := Vector2(hero.position.x, 0.0)
	# AZURE ลอยด้านหน้า LAPIS ยืนชิดด้านหลังเธอ
	# AZURE ลอยสูงขึ้นหน่อย ให้ลำแสงของ LAPIS ลอดใต้เท้าเธอไป
	_az_at = base + Vector2(_f * 60.0, -290.0) * _k
	_lp_at = base + Vector2(-_f * 230.0, 0.0) * _k
	# ลูกพลังอยู่ห่างหน้า AZURE พอให้ลำแสงสูงครึ่งจอไม่ทับตัวทั้งคู่
	_orb = Vector2(_az_at.x + _f * (300.0 * _k + _beam_h * 0.58), base.y - 230.0 * _k)
	_muzzle = _lp_at + Vector2(_f * 290.0, -150.0) * _k
	# AZURE ปีศาจลอย หันไปข้างหน้า
	add_actor(_az_at, _sz, ChibiModel.TURN * _f, "cat_azure_demon_a")
	actor.floating = true
	actor.visible = false
	# LAPIS ปีศาจยืนด้านหลัง AZURE เล็งดาบปลายปืนไปข้างหน้า
	_lapis = ChibiModel.new()
	_lapis.hero = hero
	_lapis.style = "cat_lapis_demon"
	_lapis.stage_mode = true
	_lapis.stage_turn = ChibiModel.TURN * _f
	_lapis.view_size = 1024
	add_over()
	# LAPIS อยู่ชั้นหลัง AZURE
	add_child(_lapis)
	move_child(_lapis, actor.get_index())
	_lapis.place_stage(_lp_at, _sz)
	_lapis.visible = false

## มอนที่อยู่ในแนวด้านหน้าภายในระยะ 2 จอครึ่ง
func _hit_front(h: Dictionary, from_x: float) -> void:
	for m in caught:
		if not is_instance_valid(m):
			continue
		var d := ((m as Monster).position.x - from_x) * _f
		if d > -160.0 and d < _reach:
			(m as Monster).take_hit(h, _f)

func _set_model_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

func _spark(at: Vector2, count: int, speed: float, col: Color) -> void:
	for i in count:
		var a := _rng.randf() * TAU
		_sparks.append([at, Vector2(cos(a), sin(a)) * _rng.randf_range(speed * 0.3, speed), 0.0, col])
	if _sparks.size() > 90:
		_sparks = _sparks.slice(_sparks.size() - 90)

func _charge_k() -> float:
	return clampf((_t - CHARGE_FROM) / (CHARGE_TO - CHARGE_FROM), 0.0, 1.0)

func _stage_tick(delta: float) -> void:
	# 1 แปลงร่างปีศาจ ทั้งคู่ปรากฏ
	if not _shown and _t >= SHOW_AT:
		_shown = true
		_set_model_visible(false)
		actor.visible = true
		_lapis.visible = true
		_spark(_az_at + Vector2(0.0, -150.0 * _k), 18, 700.0, SKY)
		_spark(_lp_at + Vector2(0.0, -150.0 * _k), 18, 700.0, VIOLET)
		_shake = maxf(_shake, 8.0)
	if _shown and not _back:
		var bob := sin(_t * 3.0) * 14.0
		actor.place_stage(_az_at + Vector2(0.0, bob * _k), _sz)
		# AZURE ยื่นสองมือไปข้างหน้ารวมพลัง ตอนยิงดันมือสุด
		var push := 1.0 if _t >= BEAM_FROM else 0.4 + _charge_k() * 0.4
		actor.stage_hand = Vector3(0.42, 0.68, 0.3).lerp(Vector3(0.3, 0.95, 0.75), push)
		actor.stage_off = Vector3(-0.42, 0.68, 0.02).lerp(Vector3(-0.15, 0.95, 0.75), push)
		# LAPIS รวมพลังพร้อมกัน เล็งดาบปลายปืนไปข้างหน้า ยกขึ้นเรื่อยๆ ตอนยิงสั่นแรงถอย
		var charging := _t >= CHARGE_FROM and _t < BEAM_FROM
		var firing := _t >= BEAM_FROM and _t < BEAM_TO
		var recoil := sin(_t * 70.0) * 0.04 if firing else (sin(_t * 30.0) * 0.01 * _charge_k() if charging else 0.0)
		_lapis.stage_hand = Vector3(0.42, 0.68, 0.3).lerp(Vector3(0.45, 0.88, 0.6), push) + Vector3(0.0, 0.0, recoil)
		_lapis.stage_off = Vector3(-0.42, 0.68, 0.02).lerp(Vector3(-0.1, 0.85, 0.5), push)
		_lapis.stage_sw = lerpf(-28.0, -100.0, clampf(push * 1.4, 0.0, 1.0))
		_lapis.place_stage(_lp_at + Vector2(-_f * absf(recoil) * 350.0, 0.0) * _k, _sz)
		# ปลายดาบปลายปืนจริงของ LAPIS (มือ + ความยาวดาบไปข้างหน้า)
		_muzzle = to_local(_lapis.weapon_hand_global()) + Vector2(_f * 150.0, -10.0) * _k
	# 2 รวมพลังพร้อมกัน: ประกายดูดเข้าทั้งตัว AZURE ตัว LAPIS และลูกพลัง
	if _t >= CHARGE_FROM and _t < BEAM_FROM:
		var ck := _charge_k()
		for c in [[_orb, SKY], [_az_at + Vector2(0.0, -150.0 * _k), SKY], [_lp_at + Vector2(0.0, -150.0 * _k), VIOLET], [_muzzle, VIOLET]]:
			if _rng.randf() < 0.35:
				var a := _rng.randf() * TAU
				var at: Vector2 = c[0]
				var src := at + Vector2(cos(a), sin(a)) * (150.0 + 90.0 * ck) * maxf(_k, 0.5)
				_sparks.append([src, (at - src) * 2.2, 0.0, c[1]])
		# พลังม่วงไหลจากปลายปืน LAPIS เข้าลูกพลัง
		if _rng.randf() < 0.6:
			_sparks.append([_muzzle, (_orb - _muzzle) * 1.6 + Vector2(0.0, _rng.randf_range(-60.0, 60.0)), 0.0, VIOLET])
		_shake = maxf(_shake, 1.5 + 4.0 * ck)
	# 3 ยิงพร้อมกัน คลื่นรวมลำเดียว
	if _t >= BEAM_FROM and _t < BEAM_TO:
		_beam_t -= delta
		if _beam_t <= 0.0:
			_beam_t = BEAM_TICK
			_hit_front({"type": "none", "dmg": BEAM_DMG, "skill": true}, _lp_at.x)
		_shake = maxf(_shake, 12.0)
		for i in 2:
			var along := _rng.randf() * _reach
			_sparks.append([_orb + Vector2(_f * along, _rng.randf_range(-0.5, 0.5) * _beam_h), Vector2(_f * 900.0, _rng.randf_range(-120.0, 120.0)), 0.0, SKY if i == 0 else VIOLET])
	if not _final and _t >= BEAM_TO - 0.15:
		_final = true
		_hit_front({"type": "none", "dmg": FINAL_DMG, "skill": true, "armor_break": true}, _lp_at.x)
		_shake = 20.0
	# 5 กลับร่างเดิม
	if not _back and _t >= BACK_FROM:
		_back = true
		_spark(_az_at + Vector2(0.0, -150.0 * _k), 16, 600.0, WHITE)
		_spark(_lp_at + Vector2(0.0, -150.0 * _k), 16, 600.0, WHITE)
		actor.visible = false
		_lapis.visible = false
		hero.pos = _start_pos
		_set_model_visible(true)
	for s in _sparks:
		s[2] = float(s[2]) + delta
		s[1] = (s[1] as Vector2) * 0.94
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
	_sparks = _sparks.filter(func(s: Array) -> bool: return float(s[2]) < 0.8)
	queue_redraw()
	if over != null:
		over.queue_redraw()

func _finish() -> void:
	Monster.hide_bars = false
	_set_model_visible(true)
	hero.pos = _start_pos
	for m in caught:
		if is_instance_valid(m):
			(m as Monster).frozen = false
			(m as Monster).take_hit({"type": "knockdown", "fly": 7.0, "dmg": 0.0, "skill": true}, _f)
	super._finish()

func _exit_tree() -> void:
	Monster.hide_bars = false
	if hero != null and hero.plain_model != null:
		hero.plain_model.visible = true
	super._exit_tree()

# ---------------------------------------------------------------- วาด
func _star4(cv: CanvasItem, c: Vector2, r: float, col: Color) -> void:
	# ประกายกลมนุ่ม ไม่มีแฉก
	if r < 2.0:
		return
	cv.draw_circle(c, r * 0.75, Color(col, col.a * 0.3))
	cv.draw_circle(c, r * 0.4, col)

## ด้านหลังตัวละคร: ออร่า ดาวกลางหลังเรือง วงเวทใต้ AZURE
func _draw() -> void:
	if not _shown:
		return
	var vis := 1.0 - clampf((_t - BACK_FROM) / 0.3, 0.0, 1.0)
	if vis <= 0.0:
		return
	var beat := 0.85 + 0.15 * sin(_t * 6.0)
	for p in [_az_at + Vector2(0.0, -150.0 * _k), _lp_at + Vector2(0.0, -150.0 * _k)]:
		draw_circle(p, 260.0 * _k * beat, Color(NAVY, 0.35 * vis))
		draw_circle(p, 190.0 * _k * beat, Color(BLUE, 0.12 * vis))
	var star_r := (120.0 + 90.0 * _charge_k()) * _k
	_star4(self, _az_at + Vector2(-_f * 40.0, -170.0) * _k, star_r * beat, Color(WHITE, 0.35 * vis))
	var ring := PackedVector2Array()
	for i in 41:
		var a := float(i) * TAU / 40.0 + _t * 0.8
		ring.append(_az_at + Vector2(cos(a) * 220.0, 40.0 + sin(a) * 50.0) * _k)
	draw_polyline(ring, Color(SKY, 0.55 * vis), 4.0, true)
	_star4(self, _az_at + Vector2(0.0, 40.0) * _k, 60.0 * _k, Color(SKY, 0.4 * vis))
	# ลำแสงม่วงของ LAPIS พุ่งจากปลายปืนผ่านหลัง AZURE ไปรวมเข้ากับคลื่น (วาดชั้นหลังตัวละคร)
	if _t >= BEAM_FROM and _t < BEAM_TO + 0.2:
		var bv := 1.0 - clampf((_t - BEAM_TO) / 0.2, 0.0, 1.0)
		var lw := _beam_h * 0.09 * bv * (1.0 + 0.08 * sin(_t * 50.0))
		if lw > 3.0:
			draw_line(_muzzle, _orb, Color(VIOLET, 0.45), lw * 1.7, true)
			draw_line(_muzzle, _orb, Color(VIOLET.lightened(0.3), 0.95), lw, true)
			draw_line(_muzzle, _orb, Color(WHITE, 0.95), lw * 0.3, true)
			draw_circle(_muzzle, lw * 0.6, Color(VIOLET.lightened(0.3), 0.95))
	# สายพลังน้ำเงินจากสองมือ AZURE เข้าลูกพลัง ตอนรวมพลังบาง ตอนยิงหนา
	if _t >= CHARGE_FROM and _t < BEAM_TO + 0.2:
		var hand := _az_at + Vector2(_f * 130.0, -150.0) * _k
		var bw2 := (_beam_h * 0.1 * (1.0 - clampf((_t - BEAM_TO) / 0.2, 0.0, 1.0))) if _t >= BEAM_FROM else (4.0 + 10.0 * _charge_k())
		if bw2 > 2.0:
			draw_line(hand, _orb, Color(BLUE, 0.4), bw2 * 1.7, true)
			draw_line(hand, _orb, Color(SKY, 0.95), bw2, true)
			draw_line(hand, _orb, Color(WHITE, 0.95), bw2 * 0.3, true)
			draw_circle(hand, bw2 * 0.6, Color(SKY, 0.95))

## ด้านหน้า: แสงวาบแปลงร่าง กระสุน ลูกพลัง คลื่น ประกาย
func _draw_over() -> void:
	var cv := over
	for at in [SHOW_AT, BACK_FROM]:
		var fk := (_t - float(at)) / 0.35
		if fk >= 0.0 and fk < 1.0:
			for p in [_az_at + Vector2(0.0, -150.0 * _k), _lp_at + Vector2(0.0, -150.0 * _k)]:
				cv.draw_circle(p, (140.0 + 260.0 * fk) * _k, Color(WHITE, 0.6 * (1.0 - fk)))
				_ring(p, (160.0 + 340.0 * fk) * _k, Color(SKY, 1.0 - fk), 8.0 * (1.0 - fk) + 2.0)
	# ปลายปืน LAPIS เรืองม่วง ส่งสายพลังเข้าลูกพลังหน้า AZURE
	if _t >= CHARGE_FROM and _t < BEAM_TO:
		var ck := _charge_k()
		var mf := 0.75 + 0.25 * sin(_t * 30.0)
		cv.draw_circle(_muzzle, (24.0 + 40.0 * ck) * mf, Color(VIOLET, 0.45))
		cv.draw_circle(_muzzle, (10.0 + 18.0 * ck) * mf, Color(WHITE, 0.9))
		if _t < BEAM_FROM:
			var w := 6.0 + 14.0 * ck
			cv.draw_line(_muzzle, _orb, Color(VIOLET, 0.35), w * 2.0, true)
			cv.draw_line(_muzzle, _orb, Color(WHITE, 0.7), w * 0.4, true)
	# ลูกพลังน้ำเงินดำที่โตขึ้นเรื่อยๆ
	if _t >= CHARGE_FROM and _t < BEAM_TO:
		var orb_max := _beam_h * 0.22
		var orb_r := orb_max * (0.2 + 0.8 * _charge_k())
		if _t >= BEAM_FROM:
			orb_r = orb_max * (1.0 - clampf((_t - BEAM_TO + 0.3) / 0.3, 0.0, 1.0))
		if orb_r > 2.0:
			cv.draw_circle(_orb, orb_r * 1.6, Color(BLUE, 0.15))
			cv.draw_circle(_orb, orb_r * 1.15, Color(NAVY, 0.6))
			cv.draw_circle(_orb, orb_r, Color(INKY, 0.95))
			cv.draw_circle(_orb, orb_r * 0.62, Color(BLUE, 0.9))
			cv.draw_circle(_orb, orb_r * 0.3, Color(WHITE, 0.95))
			for i in 5:
				var a := _t * 3.0 + float(i) * TAU / 5.0
				_ring(_orb, orb_r * (1.25 + 0.1 * float(i % 2)), Color(SKY, 0.4), 3.0, a, a + 1.4)
	# คลื่นรวมของทั้งคู่ น้ำเงินดำ (AZURE) + ม่วง (LAPIS) สูงเกือบครึ่งจอ ยาว 2 จอครึ่ง
	if _t >= BEAM_FROM and _t < BEAM_TO + 0.2:
		var grow := clampf((_t - BEAM_FROM) / 0.25, 0.0, 1.0)
		var bv := 1.0 - clampf((_t - BEAM_TO) / 0.2, 0.0, 1.0)
		var tip := _orb + Vector2(_f * _reach * grow, 0.0)
		var bw := (_beam_h / 1.45) * (1.0 + 0.05 * sin(_t * 40.0)) * bv
		_band(_orb, tip, bw * 1.45, Color(BLUE, 0.22))
		_band(_orb, tip, bw * 1.2, Color(VIOLET, 0.35))
		_band(_orb, tip, bw, Color(INKY, 0.92))
		_band(_orb, tip, bw * 0.66, NAVY)
		_band(_orb, tip, bw * 0.42, BLUE)
		_band(_orb, tip, bw * 0.16, WHITE)
		if bw > 4.0 and grow > 0.05:
			for i in 6:
				var d := fposmod(_t * 2600.0 + float(i) * (_reach / 6.0), _reach * grow)
				var rx := _orb.x + _f * d
				var ring := PackedVector2Array()
				for n in 25:
					var a := float(n) * TAU / 24.0
					ring.append(Vector2(rx + cos(a) * bw * 0.15, _orb.y + sin(a) * bw * 0.75))
				cv.draw_polyline(ring, Color(SKY, 0.5 * bv), 4.0, true)
	for s in _sparks:
		var sa := 1.0 - float(s[2]) / 0.8
		cv.draw_circle(s[0] as Vector2, 9.0 * sa + 2.0, Color(s[3] as Color, sa))

func _band(a: Vector2, b: Vector2, w: float, col: Color) -> void:
	if w < 4.0 or absf(b.x - a.x) < 8.0:
		return
	var hw := w * 0.5
	# ลำกว้างมากตอนเพิ่งงอก ไม่ให้มุมหัวลำย้อนเลยจุดเริ่ม
	var back := minf(hw * 0.4, absf(b.x - a.x) * 0.8)
	var pts := PackedVector2Array([
		a + Vector2(0.0, -hw),
		b + Vector2(-_f * back, -hw * 0.7),
		b + Vector2(_f * hw * 0.5, 0.0),
		b + Vector2(-_f * back, hw * 0.7),
		a + Vector2(0.0, hw),
	])
	if _f < 0.0:
		pts.reverse()
	over.draw_colored_polygon(pts, col)
	over.draw_circle(a, hw, col)

func _ring(c: Vector2, r: float, col: Color, width: float, from := 0.0, to := TAU) -> void:
	if r < 2.0 or width <= 0.0:
		return
	var pts := PackedVector2Array()
	for i in 33:
		var a := lerpf(from, to, float(i) / 32.0)
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	over.draw_polyline(pts, col, width, true)
