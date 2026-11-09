class_name CatProwlerHyper
extends HyperStage
## HYPER ของ FIERCE PROWLER (สาย PETIT TIGER ของ CAT CITRUS แมวส้มถือหอกยาว)
## ออร่าทองคำรามเป็นคลื่น 3 วง CITRUS หายไป แมวลายเสือ (ตัวละครแบบเดียวกับที่เล่น ลายเสือ มีหาง มือมีเล็บ) โผล่มาแบเล็บ
## ย่อตัวเตรียมพุ่งช้าๆ ให้เห็นรายละเอียด แล้วพุ่งฟันไปมาทั่วจอเร็วจนมองไม่เห็นตัว เห็นแค่เส้นขาว 18 ฮิต
## ฮิตสุดท้ายเสือโผล่มาท่าวิ่ง พุ่งข้ามจอทิ้งเส้นขาวตรงยาว แล้วหายไป CITRUS กลับมาที่เดิม

const CHARGE_FROM := 0.35
const ROAR_AT := 1.1
const VANISH_AT := 1.6
const TIGER_AT := 1.7
const WIND_END := 3.0                      # ย่อตัวเตรียมพุ่งช้าๆ จนถึงตรงนี้
const DASH_FROM := 3.1
const DASH_GAP := 0.155
const DASH_COUNT := 18
const FINAL_AT := 6.35
const FINAL_RUN := 1.0                     # วิ่งข้ามจอช้าๆ ให้เห็นชัด
const RETURN_AT := 7.55
const CLOSE_AT := 7.75
const END_AT := 8.35
const DASH_DMG := 24.0
const FINAL_DMG := 230.0
const TIGER_SIZE := 4.0                    # ขนาดโมเดลเสือ (1.29 คือเท่าตัวละครปกติ) กล้องถอยจึงขยาย
const STREAK_LIFE := 0.45
# สีหลัก CITRUS ส้ม แซมขาว
const GOLD := Color(1.0, 0.62, 0.26)
const WHITE := Color(1.0, 1.0, 1.0)
const GLOW := Color(1.0, 0.82, 0.58)

var _start_x := 0.0
var _dir := 1.0
var _roared := false
var _vanished := false
var _tiger_in := false
var _dashes := 0
var _final := false
var _back := false
var _from := Vector2.ZERO
var _seg_t := 0.0
var _streaks: Array = []                 # [จุดเริ่ม จุดจบ เวลาเกิด หนา]
var _sparks: Array = []                  # รอยข่วนเล็ก [ตำแหน่ง เวลาเกิด มุม]
var _puffs: Array = []                   # ควันฟู [ตำแหน่ง เวลาเกิด ขนาด]
var _rng := RandomNumberGenerator.new()
var _targets: Array = []                 # จุดพุ่งกระจายทั่วจอ
var _hit_final := false

func _stage_start() -> void:
	black_backdrop = true
	open_time = 0.45
	close_from = CLOSE_AT
	end_time = END_AT
	Monster.hide_bars = true
	if hero.plain_model != null:
		hero.plain_model.hide_blade = true
	_rng.seed = 33
	_build_targets()
	_dir = hero.facing if hero.facing != 0.0 else 1.0
	_start_x = hero.pos.x
	add_actor(hero.position, TIGER_SIZE, ChibiModel.TURN * _dir, "cat_spirit_tiger")
	actor.sword_on = false
	actor.visible = false
	add_over()

func _hit_all(dmg: float, extra := {}) -> void:
	for m in caught:
		if is_instance_valid(m):
			var h := {"type": "none", "dmg": dmg, "skill": true}
			h.merge(extra, true)
			(m as Monster).take_hit(h, _dir)

func _set_model_visible(on: bool) -> void:
	if hero.plain_model != null:
		hero.plain_model.visible = on

## ขอบเขตจอตอนกล้องถอย (จุดภาพโลก)
func _half_view() -> float:
	return screen_half_world().x

## จุดพุ่ง 18 จุดกระจายทั่วจอ ตาราง 6 x 3 ขยับสุ่มนิดหน่อย เรียงให้จุดติดกันอยู่ห่างกัน (เส้นพาดข้ามจอ)
func _build_targets() -> void:
	var c := screen_center_world()
	var half := screen_half_world() * Vector2(0.88, 0.8)
	var cells: Array = []
	for row in 3:
		for col in 6:
			var x := c.x - half.x + (float(col) + 0.5) / 6.0 * half.x * 2.0 + _rng.randf_range(-60.0, 60.0)
			var y := c.y - half.y + (float(row) + 0.5) / 3.0 * half.y * 2.0 + _rng.randf_range(-50.0, 50.0)
			cells.append(Vector2(x, minf(y, -40.0)))
	# สลับซ้ายขวาและบนล่าง: หยิบจุดที่ไกลจากจุดก่อนหน้าที่สุดในบรรดาที่เหลือสามจุดแรก
	var order: Array = []
	var last := Vector2(c.x, 0.0)
	while not cells.is_empty():
		cells.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.distance_to(last) > b.distance_to(last))
		var pick: int = _rng.randi_range(0, mini(2, cells.size() - 1))
		var p: Vector2 = cells[pick]
		cells.remove_at(pick)
		order.append(p)
		last = p
	_targets = order

func _dash_target(i: int) -> Vector2:
	return _targets[i % _targets.size()]

func _stage_tick(_delta: float) -> void:
	hero.vel = Vector2.ZERO
	if not _roared and _t >= ROAR_AT:
		_roared = true
		_shake = 14.0
	# CITRUS หายไป
	if not _vanished and _t >= VANISH_AT:
		_vanished = true
		_set_model_visible(false)
		_puffs.append([hero.position + Vector2(0.0, -80.0), _t, 120.0])
	# แมวลายเสือโผล่มาแบเล็บ
	if not _tiger_in and _t >= TIGER_AT:
		_tiger_in = true
		actor.visible = true
		_puffs.append([hero.position + Vector2(0.0, -110.0), _t, 170.0])
	if _tiger_in and _t < DASH_FROM:
		# โผล่มาแบเล็บ แล้วค่อยๆ ย่อตัวต่ำเตรียมพุ่ง เอนไปข้างหน้า ตัวสั่นนิดๆ ก่อนพุ่ง
		var k := clampf((_t - TIGER_AT) / 0.25, 0.0, 1.0)
		var w := clampf((_t - TIGER_AT - 0.2) / (WIND_END - TIGER_AT - 0.2), 0.0, 1.0)
		var ez := w * w * (3.0 - 2.0 * w)
		var tremble := sin(_t * 40.0) * 5.0 * ez
		var squash := 1.0 - 0.12 * ez
		actor.place_stage(hero.position + Vector2(tremble, 0.0), TIGER_SIZE * (0.6 + 0.4 * k))
		actor.scale = Vector2(actor.scale.x * (1.0 + 0.06 * ez), actor.scale.y * squash)
		actor.rotation = deg_to_rad(14.0 * ez) * _dir
		# เล็บยกสูงก่อน แล้วลดลงมาข้างหน้าเหมือนจะตะปบ
		actor.stage_hand = Vector3(0.5, lerpf(0.95, 0.45, ez), lerpf(0.45, 0.75, ez))
		actor.stage_off = Vector3(-0.5, lerpf(0.95, 0.45, ez), lerpf(0.45, 0.75, ez))
		_from = hero.position + Vector2(0.0, -300.0)
		_seg_t = DASH_FROM
	# พุ่งฟันไปมาเร็วจนมองไม่เห็นตัว เห็นแค่เส้นขาว
	if _t >= DASH_FROM and _dashes < DASH_COUNT and not _final:
		if actor.visible:
			actor.visible = false
			actor.rotation = 0.0
			_puffs.append([_from, _t, 120.0])
		if _t >= _seg_t:
			var to := _dash_target(_dashes)
			_streaks.append([_from, to, _t, 24.0])
			for k in 3:
				var at: Vector2 = _from.lerp(to, 0.35 + 0.25 * float(k))
				_sparks.append([at + Vector2(0.0, _rng.randf_range(-40.0, 40.0)), _t, _rng.randf_range(-0.9, 0.9)])
			_hit_all(DASH_DMG)
			_shake = maxf(_shake, 7.0)
			_from = to
			_dashes += 1
			_seg_t = _t + DASH_GAP
	# ฮิตสุดท้าย เสือโผล่มาท่าวิ่ง พุ่งข้ามจอ ทิ้งเส้นขาวตรงยาว
	if not _final and _t >= FINAL_AT:
		_final = true
		actor.visible = true
		actor.stage_turn = ChibiModel.TURN * _dir
		_puffs.append([Vector2(-_dir * _half_view() * 0.95, -200.0), _t, 140.0])
	if _final and _t < FINAL_AT + FINAL_RUN + 0.15:
		var half := _half_view()
		var rk := clampf((_t - FINAL_AT) / FINAL_RUN, 0.0, 1.0)
		var x := lerpf(-_dir * half * 0.95, _dir * half * 1.15, rk)
		var y := -40.0
		var stride := sin(_t * 20.0)
		actor.place_stage(Vector2(x, y - absf(stride) * 30.0), TIGER_SIZE)
		actor.rotation = deg_to_rad(18.0) * _dir
		# ท่าวิ่ง แขนแกว่งสลับ เล็บชี้ไปข้างหน้า
		actor.stage_hand = Vector3(0.45, 0.6 + stride * 0.2, 0.7 - stride * 0.3)
		actor.stage_off = Vector3(-0.45, 0.6 - stride * 0.2, 0.7 + stride * 0.3)
		if not _hit_final and rk >= 0.5:
			_hit_final = true
			_streaks.append([Vector2(-_dir * half * 1.1, -200.0), Vector2(_dir * half * 1.15, -200.0), _t - 0.2, 60.0])
			_hit_all(FINAL_DMG, {"armor_break": true})
			_shake = 30.0
		if rk >= 1.0 and actor.visible:
			actor.visible = false
			actor.rotation = 0.0
	# CITRUS กลับมาที่เดิม
	if not _back and _t >= RETURN_AT:
		_back = true
		hero.pos.x = _start_x
		hero.position = Vector2(hero.pos.x, -hero.pos.y) * CombatData.UNIT
		_set_model_visible(true)
		_puffs.append([hero.position + Vector2(0.0, -80.0), _t, 110.0])

func _finish() -> void:
	Monster.hide_bars = false
	_set_model_visible(true)
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
func _fade() -> float:
	return 1.0 - clampf((_t - CLOSE_AT) / 0.5, 0.0, 1.0)

func _paw(c: Vector2, s: float, col: Color) -> void:
	if s < 1.5 or col.a <= 0.0:
		return
	draw_circle(c + Vector2(0.0, s * 0.25), s * 0.55, col)
	for i in 4:
		var a := -2.45 + float(i) * 0.55
		draw_circle(c + Vector2(cos(a), sin(a)) * s * 0.85 + Vector2(0.0, s * 0.15), s * 0.22, col)

## ด้านหลังตัวละคร: ออร่าทอง คลื่นคำราม 3 วง
func _draw() -> void:
	var fade := _fade()
	var c := hero.position + Vector2(0.0, -110.0)
	if _t >= CHARGE_FROM and _t < VANISH_AT + 0.2:
		var k := clampf((_t - CHARGE_FROM) / 0.5, 0.0, 1.0)
		var out := 1.0 - clampf((_t - VANISH_AT) / 0.2, 0.0, 1.0)
		var pulse := 0.85 + 0.15 * sin(_t * 12.0)
		draw_circle(c, 190.0 * k * pulse, Color(GOLD, 0.16 * out * fade))
		draw_circle(c, 120.0 * k * pulse, Color(GOLD, 0.22 * out * fade))
		for i in 6:
			var a := _t * 2.5 + float(i) * TAU / 6.0
			_paw(c + Vector2(cos(a), sin(a)) * 170.0 * k, 16.0, Color(GOLD, 0.8 * out * fade))
	if _t >= ROAR_AT and _t < ROAR_AT + 1.0:
		for i in 3:
			var rk := clampf((_t - ROAR_AT - float(i) * 0.12) / 0.7, 0.0, 1.0)
			if rk <= 0.0 or rk >= 1.0:
				continue
			draw_arc(c, 120.0 + rk * 900.0, 0.0, TAU, 64, Color(GOLD, (1.0 - rk) * fade), 16.0 * (1.0 - rk) + 3.0, true)

## ด้านหน้า: เส้นขาวพุ่ง รอยข่วนเล็ก ควันฟู
func _draw_over() -> void:
	var fade := _fade()
	for s in _streaks:
		var age := _t - float(s[2])
		var life := STREAK_LIFE * (1.6 if float(s[3]) > 40.0 else 1.0)
		if age < 0.0 or age > life:
			continue
		var a := 1.0 - age / life
		var p0: Vector2 = s[0]
		var p1: Vector2 = s[1]
		# เส้นวิ่งออกจากจุดเริ่มเร็วมาก หางจางตามหลัง
		var head := clampf(age / 0.06, 0.0, 1.0)
		var tail := clampf((age - 0.08) / (life - 0.08), 0.0, 1.0)
		var a0 := p0.lerp(p1, tail)
		var a1 := p0.lerp(p1, head)
		var w := float(s[3])
		over.draw_line(a0, a1, Color(GLOW, 0.35 * a * fade), w * 3.0, true)
		over.draw_line(a0, a1, Color(WHITE, a * fade), w, true)
		if head < 1.0:
			over.draw_circle(a1, w * 1.4, Color(WHITE, a * fade))
	for sp in _sparks:
		var age := _t - float(sp[1])
		if age < 0.0 or age > 0.3:
			continue
		var a := 1.0 - age / 0.3
		var at: Vector2 = sp[0]
		var u := Vector2(cos(float(sp[2]) + 0.8), sin(float(sp[2]) + 0.8))
		for k in 3:
			var off := u.orthogonal() * (float(k) - 1.0) * 16.0
			over.draw_line(at + off - u * 40.0 * (0.5 + age * 3.0), at + off + u * 40.0 * (0.5 + age * 3.0), Color(WHITE, a * fade), 5.0, true)
	for p in _puffs:
		var age := _t - float(p[1])
		if age < 0.0 or age > 0.5:
			continue
		var k := age / 0.5
		var r := float(p[2])
		for i in 6:
			var ang := float(i) * TAU / 6.0
			over.draw_circle((p[0] as Vector2) + Vector2(cos(ang), sin(ang) * 0.7) * r * (0.3 + k * 0.7), r * 0.32 * (1.0 - k * 0.5), Color(1.0, 0.95, 0.85, (1.0 - k) * 0.9 * fade))
