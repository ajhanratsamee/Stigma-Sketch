class_name MageCaster
extends Node2D
## ปล่อยเวทของคอมโบ CAT SUSI (fx ที่ขึ้นต้นด้วย mg_) คุมดาเมจ การลากมอน ขวดยาที่ลอย และโซนดาเมจต่อเนื่อง
## อยู่ใน world ของหน้าฝึกซ้อม พิกัดเป็นจุดภาพ พื้นอยู่ที่ y 0

const UNIT := CombatData.UNIT
const SHOT_R := 24.0
const SHOT_DMG := 14.0
const BASIC_SHOT_K := 0.66       # ยิงธนู/ลูกไฟพื้นฐาน (xxxx) ลดให้ดาเมจต่อวินาทีพอๆ กับคอมโบระยะประชิด
const ICE_PULL := 0.7          # น้ำแข็งลากมอนมาถึงตัวในเวลานี้

var page: WalkPage
var hero: Hero
var cloud: MageFx.Cloud
var ball: MageFx.DimBall
var _potions: Array = []   # [ขวด จุดเริ่ม จุดตก เวลา เวลาทั้งหมด ชนิด]
var _flames: Array = []    # [เปลวไฟ มอนที่โดนแล้ว]
var _dusts: Array = []     # ผงมิติที่ยังลอยอยู่
var _dust_tick := 0.0
var _drags: Array = []     # [มอน x เริ่ม x ปลาย เวลา]
var _darks: Array = []     # ลูกบอลมืด [ลูก ความเร็ว ลดความเร็ว จังหวะ ดาเมจ ถึงพื้นแล้วหาย]

func _hit(monster: Monster, dmg: float, extra: Dictionary) -> void:
	var h := {"type": "flinch", "dmg": dmg, "skill": true, "stun": 0.5, "kb": 1.0}
	h.merge(extra, true)
	page._strike(monster, h, hero.facing)

func _monsters() -> Array:
	var out := []
	for e in get_tree().get_nodes_in_group("monsters"):
		if e is Monster and (e as Monster).state != "dead":
			out.append(e)
	return out

## ตีทุกตัวที่อยู่ห่างจาก x ไม่เกิน half จุดภาพ
func _hit_near(x: float, half: float, dmg: float, extra: Dictionary) -> Array:
	var got := []
	for m in _monsters():
		if absf((m as Monster).position.x - x) <= half:
			_hit(m, dmg, extra)
			got.append(m)
	return got

## มอนตัวใกล้สุดด้านหน้าในระยะ จุดภาพ
func _front_target(reach: float) -> Monster:
	var best: Monster = null
	var best_d := reach
	for m in _monsters():
		var d: float = ((m as Monster).position.x - hero.position.x) * hero.facing
		if d > -30.0 and d < best_d:
			best_d = d
			best = m
	return best

func _add(node: Node2D, at: Vector2) -> Node2D:
	node.position = at
	page.world.add_child(node)
	return node

func _hand() -> Vector2:
	return page._cast_point(hero.position + Vector2(hero.facing * 70.0, -80.0))

## ลูกศรของ CAT MATCHA ออกจากมือที่ถือคันธนู
func _arrow(dir: Vector2, dmg: float, extra: Dictionary, r := 26.0) -> void:
	page._fire(page._cast_point(hero.position + Vector2(hero.facing * 70.0, -80.0)), dir.normalized() * WalkPage.SHOT_SPEED * 1.35, r, dmg, extra)

func cast(fx: String) -> void:
	for line in BowCombo.lines():
		if line.cast(self, fx):
			return
	var f := hero.facing
	match fx:
		"bw_kick_front", "bw_kick_spin", "bw_kick_up", "bw_kick_flip", "bw_kick_down", "bw_kick_slide":
			var trail := KickTrail.new()
			trail.kind = fx.trim_prefix("bw_kick_")
			trail.dir = f
			trail.position = hero.position
			if trail.kind == "slide":
				trail.follow = hero
				trail.life = 0.6
			page.world.add_child(trail)
		"bw_shot":
			_arrow(Vector2(f, 0.0), SHOT_DMG * BASIC_SHOT_K, {"kb": 1.0, "stun": 0.45})
		"bw_shot_down":
			_arrow(Vector2(f, 0.0), SHOT_DMG * 1.4 * BASIC_SHOT_K, {"type": "knockdown", "fly": 7.0}, 32.0)
		"bw_shot3_down":
			# ยิงจากตัวลงมาแนวดิ่ง 3 ดอกเรียงกัน
			for dx in [-32.0, 0.0, 32.0]:
				page._fire(hero.position + Vector2(dx, -40.0), Vector2(0.0, 1.0) * WalkPage.SHOT_SPEED * 1.35, 26.0, SHOT_DMG * 0.7, {"kb": 0.4, "stun": 0.45})
		"bw_shot3_diag", "bw_shot3_diag_kd":
			var last := fx == "bw_shot3_diag_kd"
			for a in [35.0, 45.0, 55.0]:
				_arrow(Vector2(f * cos(deg_to_rad(a)), sin(deg_to_rad(a))), SHOT_DMG * 0.7, {"type": "knockdown", "fly": 6.0} if last else {"kb": 0.8, "stun": 0.45})
		"mg_shot":
			page._fire(_hand(), Vector2(f, 0.0) * WalkPage.SHOT_SPEED, SHOT_R, SHOT_DMG * BASIC_SHOT_K, {"kb": 1.2, "stun": 0.5})
		"mg_shot_down":
			page._fire(_hand(), Vector2(f, 0.0) * WalkPage.SHOT_SPEED, SHOT_R * 1.3, SHOT_DMG * 1.4 * BASIC_SHOT_K, {"type": "knockdown", "fly": 6.0})
		"mg_shot_quick":
			page._fire(_hand() + Vector2(0.0, randf_range(-20.0, 20.0)), Vector2(f, 0.0) * WalkPage.SHOT_SPEED * 1.15, SHOT_R * 0.8, SHOT_DMG * 0.6, {"kb": 0.4, "stun": 0.35})
		"mg_shot45":
			page._fire(_hand(), Vector2(f, 1.0).normalized() * WalkPage.SHOT_SPEED, SHOT_R, SHOT_DMG, {"kb": 1.2, "stun": 0.5})
		"mg_tilt_circle":
			var tc := MageFx.TiltCircle.new()
			tc.dir = f
			_add(tc, hero.position + Vector2(f * 110.0, -40.0))
			var land := tc.position.x + f * (-tc.position.y)
			get_tree().create_timer(0.12).timeout.connect(func() -> void: _hit_near(land, 150.0, 18.0, {"kb": 1.0, "stun": 0.6}))
		"mg_lift":
			var c := MageFx.Circle.new()
			c.tint = Color(1.0, 1.0, 1.0)
			_add(c, Vector2(hero.position.x, 0.0))
			_hit_near(hero.position.x, 200.0, 16.0, {"type": "launch", "vy": 13.0})
		"mg_wind":
			var g := MageFx.Gust.new()
			g.dir = f
			_add(g, Vector2(hero.position.x + f * 40.0, 0.0))
			_hit_near(hero.position.x + f * 300.0, 260.0, 10.0, {"kb": 2.6, "stun": 0.4})
		"mg_wind_cloud":
			cast("mg_wind")
			cast("mg_cloud")
		"mg_cloud":
			if is_instance_valid(cloud):
				cloud.queue_free()
			cloud = MageFx.Cloud.new()
			var target := _front_target(900.0)
			cloud.target = target
			var x := target.position.x if target != null else hero.position.x + f * 400.0
			_add(cloud, Vector2(x, -230.0))
		"mg_bolt":
			if not is_instance_valid(cloud):
				return
			cloud.refresh()
			cloud.bolt()
			_hit_near(cloud.position.x, 80.0, 9.0, {"kb": 0.0, "stun": 0.4})
		"mg_gflame":
			var fl := MageFx.FloorFlame.new()
			fl.dir = f
			_add(fl, Vector2(hero.position.x + f * 80.0, 0.0))
			_flames.append([fl, {}])
		"mg_ice":
			# น้ำแข็งงอกห่างไป 6 ช่วงตัว แล้วแตกเป็นแนวไล่เข้ามาหาเรา พามอนติดมาด้วย
			var far_x := hero.position.x + f * 6.0 * UNIT
			var near_x := hero.position.x + f * 1.1 * UNIT
			var trail := MageFx.IceTrail.new()
			trail.to_x = near_x - far_x
			trail.travel = ICE_PULL
			_add(trail, Vector2(far_x, 0.0))
			for m in _hit_near(far_x, 130.0, 12.0, {"kb": 0.0, "stun": ICE_PULL + 0.4}):
				_drags.append([m, (m as Monster).pos.x, hero.pos.x + f * 1.1, 0.0, ICE_PULL])
		"mg_spark":
			var from := _hand()
			var sp := MageFx.Spark.new()
			sp.to = Vector2(f, 1.0) * maxf(-from.y, 60.0)
			_add(sp, from)
			_hit_near(from.x + sp.to.x, 140.0, 8.0, {"kb": 1.8, "stun": 0.35})
		"mg_warp":
			var target := _front_target(2.5 * UNIT + 60.0)
			_add(MageFx.Poof.new(), hero.position)
			if target != null:
				hero.pos.x = clampf(target.pos.x - f * 0.5, -hero.half_width, hero.half_width)
				hero.pos.y = maxf(hero.pos.y, 2.2)
				hero.vel = Vector2.ZERO
				_add(MageFx.Poof.new(), Vector2(hero.pos.x * UNIT, -hero.pos.y * UNIT))
		"mg_rise":
			var target := _front_target(3.0 * UNIT)
			var x := target.position.x if target != null else hero.position.x + f * 1.5 * UNIT
			var c := MageFx.Circle.new()
			c.tint = Color(1.0, 0.55, 0.9)
			c.radius = 160.0
			_add(c, Vector2(x, 0.0))
			_hit_near(x, 170.0, 14.0, {"type": "launch", "vy": 12.0})
		"mg_dust":
			var d := MageFx.Dust.new()
			d.vel = Vector2(f * 220.0, 0.0)
			_add(d, Vector2(hero.position.x + f * 140.0, 0.0))
			_dusts.append(d)
		"mg_recall":
			for d in _dusts:
				if not is_instance_valid(d) or (d as MageFx.Dust).returning:
					continue
				for m in _hit_near((d as Node2D).position.x, 150.0, 10.0, {"kb": 0.0, "stun": 0.6}):
					_drags.append([m, (m as Monster).pos.x, hero.pos.x + f * 1.0, 0.0])
				(d as MageFx.Dust).recall(hero.position + Vector2(0.0, -40.0))
		"mg_dimball":
			if is_instance_valid(ball):
				ball.queue_free()
			ball = MageFx.DimBall.new()
			_add(ball, hero.position + Vector2(0.0, -260.0))
		"mg_dimslam":
			if not is_instance_valid(ball):
				return
			var at := Vector2(hero.position.x + f * 380.0, -40.0)
			ball.throw(at)
			get_tree().create_timer(0.14).timeout.connect(func() -> void:
				page.shake_left = maxf(page.shake_left, 0.35)
				for m in _hit_near(at.x, 220.0, 26.0, {"type": "knockdown", "fly": 0.0, "stun": 0.8}):
					# ลอยอยู่ก็ถูกกดลงพื้นทันที
					if not (m as Monster).on_floor():
						(m as Monster).vel.y = -30.0)
		"mg_toss_short":
			_toss(Vector2(hero.position.x + f * 220.0, 0.0), "short")
		"mg_toss_lift":
			_toss(Vector2(hero.position.x + f * 180.0, 0.0), "lift")
		"mg_toss_three":
			for n in 3:
				_toss(Vector2(hero.position.x + f * (130.0 + 140.0 * float(n)), 0.0), "short")
		"mg_potion_rain":
			for n in 6:
				var x := hero.position.x + f * randf_range(140.0, 700.0)
				var p := MageFx.Potion.new()
				_add(p, Vector2(x, -950.0 - float(n) * 90.0))
				_potions.append([p, p.position, Vector2(x, 0.0), 0.0, 0.45 + float(n) * 0.06, "rain"])
		"mg_cauldron":
			var x := hero.position.x + f * 380.0
			_add(MageFx.Cauldron.new(), Vector2(x, 0.0))
			get_tree().create_timer(0.32).timeout.connect(func() -> void:
				page.shake_left = maxf(page.shake_left, 0.45)
				_hit_near(x, 240.0, 30.0, {"type": "knockdown", "fly": 4.0}))
		"mg_dark_stay":
			_dark(Vector2(f * 900.0, 0.0), 5.0, 3.0, 6.0, false)
		"mg_dark_flinch":
			_dark(Vector2(f * 1000.0, 0.0), 6.0, 2.4, 5.0, false)
		"mg_dark_slow":
			_dark(Vector2(f * 260.0, 0.0), 0.0, 3.0, 4.0, false)
		"mg_dark45":
			_dark(Vector2(f, 1.0).normalized() * 230.0, 0.0, 4.0, 5.0, true)
		"mg_quake":
			var q := MageFx.Quake.new()
			_add(q, Vector2(hero.position.x + f * 110.0, 0.0))
		"mg_bash_splash":
			var s := MageFx.Splash.new()
			s.radius = 90.0
			_add(s, Vector2(hero.position.x + f * 120.0, 0.0))

## ลูกบอลมืด พุ่งออกแล้วช้าลงจนลอยค้าง (slow = แรงหน่วง) ทำดาเมจชะงักรอบตัวเป็นจังหวะจนหายไป
func _dark(vel: Vector2, slow: float, life: float, dmg: float, ground_end: bool) -> void:
	var orb := MageFx.DarkOrb.new()
	orb.life = life
	_add(orb, _hand())
	_darks.append([orb, vel, slow, 0.0, dmg, ground_end])

## ปาขวดยาโค้งจากมือลงพื้น
func _toss(to: Vector2, kind: String) -> void:
	var p := MageFx.Potion.new()
	_add(p, _hand())
	_potions.append([p, p.position, to, 0.0, 0.4, kind])

func _splash(at: Vector2, kind: String) -> void:
	var s := MageFx.Splash.new()
	_add(s, at)
	match kind:
		"lift":
			_hit_near(at.x, 160.0, 14.0, {"type": "launch", "vy": 12.0})
		"rain":
			s.radius = 110.0
			_hit_near(at.x, 120.0, 8.0, {"kb": 0.4, "stun": 0.4})
		_:
			_hit_near(at.x, 150.0, 14.0, {"kb": 1.0, "stun": 0.5})

func _process(delta: float) -> void:
	for p in _potions.duplicate():
		if not is_instance_valid(p[0]):
			_potions.erase(p)
			continue
		var node := p[0] as MageFx.Potion
		p[3] = float(p[3]) + delta
		var k := clampf(float(p[3]) / float(p[4]), 0.0, 1.0)
		var from: Vector2 = p[1]
		var to: Vector2 = p[2]
		var arc := 0.0 if p[5] == "rain" else -220.0 * 4.0 * k * (1.0 - k)
		node.position = from.lerp(to, k * k if p[5] == "rain" else k) + Vector2(0.0, arc)
		node.spin += delta * 12.0
		if k >= 1.0:
			_splash(to, p[5])
			node.queue_free()
			_potions.erase(p)
	for fl in _flames.duplicate():
		if not is_instance_valid(fl[0]):
			_flames.erase(fl)
			continue
		var node := fl[0] as Node2D
		for m in _monsters():
			if (fl[1] as Dictionary).has(m) or absf((m as Monster).position.x - node.position.x) > 70.0:
				continue
			fl[1][m] = true
			_hit(m, 14.0, {"kb": 0.8, "stun": 0.5})
	_dust_tick -= delta
	if _dust_tick <= 0.0:
		_dust_tick = 0.2
		for d in _dusts.duplicate():
			if not is_instance_valid(d):
				_dusts.erase(d)
				continue
			if not (d as MageFx.Dust).returning:
				_hit_near((d as Node2D).position.x, 120.0, 4.0, {"kb": 0.1, "stun": 0.25})
	for dr in _drags.duplicate():
		if not is_instance_valid(dr[0]):
			_drags.erase(dr)
			continue
		var m := dr[0] as Monster
		dr[3] = float(dr[3]) + delta
		var k := clampf(float(dr[3]) / (float(dr[4]) if dr.size() > 4 else 0.35), 0.0, 1.0)
		m.pos.x = lerpf(float(dr[1]), float(dr[2]), k if dr.size() > 4 else 1.0 - (1.0 - k) * (1.0 - k))
		m.vel.x = 0.0
		if k >= 1.0:
			_drags.erase(dr)
	for dk in _darks.duplicate():
		if not is_instance_valid(dk[0]):
			_darks.erase(dk)
			continue
		var orb := dk[0] as MageFx.DarkOrb
		orb.position += (dk[1] as Vector2) * delta
		dk[1] = (dk[1] as Vector2) * exp(-float(dk[2]) * delta)
		if dk[5] and orb.position.y >= -30.0:
			orb.pop()
			_darks.erase(dk)
			_hit_near(orb.position.x, 120.0, float(dk[4]) * 2.0, {"kb": 0.3, "stun": 0.6})
			continue
		dk[3] = float(dk[3]) - delta
		if float(dk[3]) <= 0.0 and not orb.popping:
			dk[3] = 0.3
			for m in _monsters():
				if ((m as Monster).position + Vector2(0.0, -WalkPage.MONSTER_MID)).distance_to(orb.position) <= 110.0:
					_hit(m, float(dk[4]), {"kb": 0.0, "stun": 0.45})
	# ขวดยาในมือตอนฟาดขวดยา
	queue_redraw()

func _draw() -> void:
	if hero == null or hero.plain_swing <= 0.0 or not hero.plain_move.get("potion_hand", false) or hero.plain_model == null:
		return
	var at: Vector2 = to_local(hero.plain_model.off_hand_global())
	draw_circle(at, 18.0, Color(0.85, 0.95, 1.0, 0.55))
	draw_circle(at + Vector2(0.0, 4.0), 13.0, Color(0.9, 0.08, 0.15))
	draw_rect(Rect2(at.x - 5.0, at.y - 28.0, 10.0, 12.0), Color(0.85, 0.95, 1.0, 0.65))
	draw_rect(Rect2(at.x - 6.0, at.y - 33.0, 12.0, 7.0), Color(0.72, 0.5, 0.27))
	for side in [-1.0, 1.0]:
		draw_colored_polygon(PackedVector2Array([at + Vector2(side * 1.0, -33.0), at + Vector2(side * 5.0, -40.0), at + Vector2(side * 6.5, -32.0)]), Color(0.72, 0.5, 0.27))
	draw_circle(at + Vector2(0.0, 5.0), 7.0, Color(1.0, 0.95, 0.85))
	draw_circle(at + Vector2(0.0, 6.5), 3.2, Color(0.9, 0.3, 0.45))
	for i in 3:
		draw_circle(at + Vector2((float(i) - 1.0) * 3.0, 2.0 - (0.8 if i == 1 else 0.0)), 1.4, Color(0.9, 0.3, 0.45))
