class_name OmniSkill
extends BoySkill
## สกิลของ OMNI PRIME ทุกท่าเส้นระบาย ไม่เทสี
## op_cross ลูกไฟใหญ่สองลูกจากด้านหลังพุ่งไขว้  op_ice ลูกน้ำแข็งสองลูกตกจากฟ้า แตกกระจายตามพื้น
## op_wind พายุครึ่งจอพัดไปข้างหน้า  op_bolts ลอยเรียกสายฟ้าสุ่ม กดค้างปล่อยต่อ  op_triple ไฟ ไฟฟ้า น้ำแข็งทะลุมอน
## ฟังก์ชัน static ใช้ซ้ำตอนเกจธาตุเต็ม ปล่อยฟรีไม่หยุดเวลา

const CROSS_R := 76.0
const CROSS_SPEED := 12.0
const CROSS_HIGH := 3.8
const CROSS_LOW := 1.4
const CROSS_TILT := 1.4
const CROSS_BACK := 1.6
const CROSS_DMG := 36.0
const ICE_R := 72.0
const ICE_HIGH := 9.0
const ICE_FALL := 12.0
const ICE_DMG := 30.0
const ICE_SPOTS := [3.0, 7.0]
const ELEC_R := 100.0
const ELEC_SPEED := 8.0
const ELEC_SCREENS := 1.5
const ELEC_DMG := 10.0
const ELEC_REPEAT := 0.25
const WIND_TIME := 2.2
const WIND_TICK := 0.25
const WIND_DMG := 10.0
const WIND_HIGH := 6.0
const WIND_FILL := Color(0.32, 0.72, 0.58)
const BOLT_HOVER := 1.3
const BOLT_GAP := 0.12
const BOLT_BASE := 8
const BOLT_REACH := 1.4
const BOLT_DMG := 15.0
const BOLT_DRAIN := 22.0
const BOLT_SCALE := 3.0
const TRIPLE_KINDS := ["fire", "elec", "ice"]
const TRIPLE_R := 62.0
const TRIPLE_SPEED := 14.0
const TRIPLE_GAP := 0.16
const TRIPLE_DMG := 32.0

var wind_on := false
var wind_x := 0.0
var wind_half := 6.0
var wind_ticks := 0
var bolts_out := 0

static func fire_cross(h: Hero) -> void:
	for pair in [[CROSS_HIGH, -CROSS_TILT], [CROSS_LOW, CROSS_TILT]]:
		var ball := FireBall.new()
		ball.hero = h
		ball.radius = CROSS_R
		ball.dmg = CROSS_DMG
		ball.is_skill = true
		ball.pierce = true
		ball.pos = Vector2(h.pos.x - h.facing * CROSS_BACK, float(pair[0]))
		ball.vel = Vector2(h.facing * CROSS_SPEED, float(pair[1]))
		h.boost_ball(ball)
		h.get_parent().add_child(ball)

static func ice_drops(h: Hero) -> void:
	for ahead in ICE_SPOTS:
		var ball := FireBall.new()
		ball.hero = h
		ball.kind = "ice"
		ball.radius = ICE_R
		ball.dmg = ICE_DMG
		ball.is_skill = true
		ball.spread_kind = "ice"
		ball.blast_units = ICE_R / U + 0.8
		ball.pos = Vector2(h.pos.x + h.facing * float(ahead), ICE_HIGH)
		ball.vel = Vector2(0.0, -ICE_FALL)
		h.get_parent().add_child(ball)

static func elec_ball(h: Hero) -> void:
	var ball := FireBall.new()
	ball.hero = h
	ball.kind = "elec"
	ball.radius = ELEC_R
	ball.dmg = ELEC_DMG
	ball.is_skill = true
	ball.pierce = true
	ball.repeat_gap = ELEC_REPEAT
	var world: Node2D = h.get_parent()
	ball.stop_range = h.get_viewport_rect().size.x * ELEC_SCREENS / (U * world.scale.x)
	ball.life_mult = 3.0
	ball.pos = h.pos + Vector2(h.facing * (ELEC_R / U + 0.4), ELEC_R / U + 0.15)
	ball.vel = Vector2(h.facing * ELEC_SPEED, 0.0)
	world.add_child(ball)

func _run() -> void:
	match kind:
		"op_cross": await _run_cross()
		"op_ice": await _run_ice()
		"op_wind": await _run_wind()
		"op_bolts": await _run_bolts()
		"op_triple": await _run_triple()
	_rest_hero()
	_end_plain()

func _staff_up(time: float) -> void:
	_pose_tween(Hero.REST_SW, -5.0, Vector2.ZERO, Vector2(0.1, 0.8), time)
	await _wait(time)

func _run_cross() -> void:
	await _staff_up(0.3)
	fire_cross(hero)
	_shake(10.0)
	_free_hero()

func _run_ice() -> void:
	await _staff_up(0.3)
	ice_drops(hero)
	_free_hero()

func _run_wind() -> void:
	await _staff_up(0.25)
	wind_half = get_viewport_rect().size.x * 0.25 / (U * zoom_scale)
	wind_x = hero.pos.x + _dir * (wind_half + 0.5)
	wind_on = true
	storm_k = 0.0
	create_tween().tween_property(self, "storm_k", 1.0, 0.25)
	var far: float = wind_x + _dir * get_viewport_rect().size.x / (U * zoom_scale)
	create_tween().tween_property(self, "wind_x", far, WIND_TIME).set_trans(Tween.TRANS_SINE)
	_free_hero()
	var t := 0.0
	while t < WIND_TIME:
		_hit_span(wind_x - wind_half, wind_x + wind_half, _hit(WIND_DMG))
		for e in _targets:
			if is_instance_valid(e) and not (e in grabbed) and absf(e.pos.x - wind_x) <= wind_half * 0.6:
				grabbed.append(e)
		wind_ticks += 1
		await _wait(WIND_TICK)
		t += WIND_TICK
	create_tween().tween_property(self, "storm_k", 0.0, 0.3)
	await _wait(0.3)
	wind_on = false

func _run_bolts() -> void:
	_pose_tween(Hero.REST_SW, -5.0, Vector2.ZERO, Vector2(0.1, 0.8), 0.2)
	create_tween().tween_property(hero, "pos:y", hero.pos.y + BOLT_HOVER, 0.25).set_trans(Tween.TRANS_SINE)
	await _wait(0.25)
	var half: float = get_viewport_rect().size.x * 0.25 / (U * zoom_scale)
	for i in BOLT_BASE:
		_bolt(half)
		await _wait(BOLT_GAP)
	# กดค้างปล่อยต่อ สูบมานาตามเวลาจริง
	var last_ms := Time.get_ticks_msec()
	while hero.held_keys.get("skill", false) and hero.mp > 0.0:
		var now_ms := Time.get_ticks_msec()
		hero.mp = maxf(hero.mp - BOLT_DRAIN * (now_ms - last_ms) / 1000.0, 0.0)
		last_ms = now_ms
		_bolt(half)
		await _wait(BOLT_GAP)
	_free_hero()

func _bolt(half: float) -> void:
	var x: float = hero.pos.x + randf_range(-half, half)
	var fx := ImpactFx.new()
	fx.kind = "bolt"
	fx.pos = Vector2(x, 0.0)
	fx.scale = Vector2.ONE * BOLT_SCALE
	get_parent().add_child(fx)
	_hit_span(x - BOLT_REACH, x + BOLT_REACH, _hit(BOLT_DMG))
	_shake(5.0)
	bolts_out += 1

func _run_triple() -> void:
	_pose_tween(Hero.REST_SW, -85.0, Vector2.ZERO, Vector2(0.6, 0.3), 0.15)
	await _wait(0.15)
	var from: Vector2 = hero.pos + Vector2(_dir * 1.3, 1.2)
	for k in TRIPLE_KINDS:
		var ball := FireBall.new()
		ball.hero = hero
		ball.kind = k
		ball.radius = TRIPLE_R
		ball.dmg = TRIPLE_DMG
		ball.is_skill = true
		ball.pierce = true
		ball.pos = from
		ball.vel = Vector2(_dir * TRIPLE_SPEED, 0.0)
		get_parent().add_child(ball)
		_shake(6.0)
		await _wait(TRIPLE_GAP)
	_free_hero()

func _process(delta: float) -> void:
	super(delta)
	if wind_on:
		for e in grabbed:
			if is_instance_valid(e):
				e.pos.x = wind_x

func _draw() -> void:
	super()
	if wind_on:
		Sketch.storm(self, _px(wind_x, 0.0), wind_half * U * 0.3, wind_half * U, WIND_HIGH * U, _clock * 7.0, WIND_FILL, Sketch.INK, 2910, storm_k)
