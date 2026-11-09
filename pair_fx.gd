class_name PairFx
extends Node2D
## เอฟเฟกต์คอมโบของ CAT AZURE & LAPIS ชื่อขึ้นต้น pc_
## AZURE รอยกรงเล็บฟ้าอ่อน ควันกลม วงกระแทกพื้น คลื่นพลังน้ำเงิน
## LAPIS รอยฟันดาบปลายปืน กระสุนน้ำเงินหางกลม ระเบิดน้ำเงิน
## pc_assist เรียกอีกตัวกระโดดออกมาจากด้านหลังแล้วเตะ แล้วหายไป  ทรงมนทั้งหมด ไม่มีดาวแฉก

const SKY := Color(0.62, 0.84, 1.0)
const BLUE := Color(0.25, 0.45, 0.95)
const WHITE := Color(0.96, 0.98, 1.0)

var kind := "claw"
var dir := 1.0
var life := 0.3
var follow: Node2D
var _t := 0.0

static func cast(page: WalkPage, fx: String) -> void:
	# คอมโบของสายต่อยอด (SPARK DREAMER / SOMNAMBULIST / SPARK FIEND / NEON BOLT)
	if PairLineDream.cast(page, fx) or PairLineFiend.cast(page, fx):
		return
	var k := fx.trim_prefix("pc_")
	var f := page.hero.facing
	match k:
		"shot", "shot_launch", "shot_big", "shot_diag":
			var b := PairBullet.new()
			var d := Vector2(f, 0.0) if k != "shot_diag" else Vector2(f, 0.75).normalized()
			b.vel = d * (1500.0 if k != "shot_big" else 1700.0)
			b.radius = 22.0 if k != "shot_big" else 34.0
			b.dmg = {"shot": 8.0, "shot_launch": 14.0, "shot_big": 16.0, "shot_diag": 9.0}[k]
			b.pierce = k == "shot_big"
			b.life = 0.7
			b.extra = {"type": "launch", "vy": 10.0} if k == "shot_launch" else ({"kb": 2.2, "stun": 0.6} if k == "shot_big" else {"kb": 0.5, "stun": 0.45})
			b.position = _muzzle(page)
			page.world.add_child(b)
			return
		"wave":
			var w := PairWave.new()
			w.vel = Vector2(f * 1000.0, 0.0)
			w.radius = 70.0
			w.dmg = 15.0
			w.pierce = true
			w.life = 0.9
			w.extra = {"kb": 1.6, "stun": 0.6}
			w.position = page.hero.position + Vector2(f * 80.0, -90.0)
			page.world.add_child(w)
			return
		"grenade":
			var g := PairGrenade.new()
			g.page = page
			g.vel = Vector2(f * 650.0, -500.0)
			g.position = _muzzle(page)
			page.world.add_child(g)
			return
		"assist", "assist_dive":
			var a := PairAssist.new()
			a.page = page
			a.dive = k == "assist_dive"
			page.world.add_child(a)
			return
	var node := PairFx.new()
	node.kind = k
	node.dir = f
	node.position = page.hero.position
	if k in ["pound", "claw_down"]:
		node.life = 0.4
	page.world.add_child(node)

## ปากกระบอกปืนของ LAPIS (มือที่ถืออาวุธ) ถ้าไม่มีโมเดลใช้หน้าอก
static func _muzzle(page: WalkPage) -> Vector2:
	if page.hero.plain_model != null:
		return page.world.to_local(page.hero.plain_model.weapon_hand_global()) + Vector2(page.hero.facing * 50.0, -6.0)
	return page.hero.position + Vector2(page.hero.facing * 70.0, -80.0)

func _process(delta: float) -> void:
	_t += delta
	if is_instance_valid(follow):
		position = follow.position
	if _t >= life:
		queue_free()
	queue_redraw()

func _draw() -> void:
	var k := clampf(_t / life, 0.0, 1.0)
	var a := 1.0 - k
	match kind:
		"claw", "claw2", "claw_up", "claw_down":
			# รอยกรงเล็บสามเส้นโค้ง ปลายมน
			var c := Vector2(dir * 110.0, -95.0)
			var ang := -0.6 if kind == "claw" else (0.6 if kind == "claw2" else (-1.2 if kind == "claw_up" else 1.3))
			var sets := 2 if kind == "claw2" else 1
			for s in sets:
				var aa := ang + (1.2 if s == 1 else 0.0)
				var dv := Vector2(cos(aa) * dir, sin(aa))
				var nv := Vector2(-dv.y, dv.x)
				for i in 3:
					var off := nv * (float(i) - 1.0) * 26.0
					var from := c + off - dv * 70.0
					var to := from + dv * 140.0 * minf(k * 3.0, 1.0)
					draw_line(from, to, Color(SKY, 0.45 * a), 16.0, true)
					draw_line(from, to, Color(WHITE, a), 6.0, true)
					draw_circle(to, 3.0, Color(WHITE, a))
		"punch", "kick":
			var c2 := Vector2(dir * 100.0, -80.0)
			draw_circle(c2, 20.0 + 50.0 * k, Color(SKY, 0.3 * a))
			draw_arc(c2, 25.0 + 60.0 * k, 0.0, TAU, 32, Color(WHITE, a), 5.0 * a + 1.0, true)
			for i in 5:
				var t := TAU * float(i) / 5.0 + 0.3
				draw_circle(c2 + Vector2(cos(t), sin(t)) * (30.0 + 70.0 * k), 7.0 * a + 1.0, Color(SKY, a))
		"swap":
			# ควันฟ้ากลมฟูตอนสลับตัว
			var cs := Vector2(0.0, -70.0)
			draw_circle(cs, 40.0 + 60.0 * k, Color(SKY, 0.35 * a))
			draw_arc(cs, 50.0 + 70.0 * k, 0.0, TAU, 32, Color(WHITE, a), 5.0 * a + 1.0, true)
			for i in 8:
				var t := TAU * float(i) / 8.0
				draw_circle(cs + Vector2(cos(t), sin(t)) * (40.0 + 80.0 * k), 12.0 * a + 2.0, Color(0.85, 0.92, 1.0, a))
		"pound":
			var c3 := Vector2(dir * 100.0, 0.0)
			draw_set_transform(c3, 0.0, Vector2(1.0, 0.3))
			draw_arc(Vector2.ZERO, 40.0 + 220.0 * k, 0.0, TAU, 48, Color(SKY, a), 10.0 * a + 2.0, true)
			draw_arc(Vector2.ZERO, 20.0 + 140.0 * k, 0.0, TAU, 48, Color(WHITE, a), 6.0 * a + 1.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for i in 6:
				var x := (float(i) - 2.5) * 50.0
				draw_circle(c3 + Vector2(x, -20.0 - 60.0 * k * (1.0 - absf(x) / 150.0)), 12.0 * a + 2.0, Color(0.85, 0.9, 1.0, 0.8 * a))
		"slash":
			# รอยฟันโค้งเสี้ยวจันทร์ฟ้า แกนขาว
			var c4 := Vector2(dir * 90.0, -90.0)
			var pts := PackedVector2Array()
			var inner := PackedVector2Array()
			for i in 17:
				var t2 := lerpf(-1.1, 1.1, float(i) / 16.0)
				pts.append(c4 + Vector2(cos(t2) * dir, sin(t2)) * 120.0)
				inner.append(c4 + Vector2(cos(t2) * dir, sin(t2)) * 120.0 * 0.82 + Vector2(-dir * 10.0, 0.0))
			inner.reverse()
			var poly := pts.duplicate()
			poly.append_array(inner)
			SoftDraw.poly(self, poly, Color(BLUE, 0.5 * a))
			draw_polyline(pts, Color(WHITE, a), 5.0, true)

## กระสุนน้ำเงินกลม หางเม็ดกลม
class PairBullet extends WolfBall:
	func _draw() -> void:
		var f := signf(vel.x) if vel.x != 0.0 else 1.0
		var back := -vel.normalized()
		if _pop >= 0.0:
			var k := _pop / 0.25
			draw_arc(Vector2.ZERO, radius * (1.0 + k * 1.2), 0.0, TAU, 32, Color(PairFx.SKY, 1.0 - k), 6.0 * (1.0 - k) + 1.0, true)
			return
		for i in 5:
			var k2 := float(i + 1) / 6.0
			draw_circle(back * radius * (0.8 + k2 * 2.2), radius * (0.7 - k2 * 0.5), Color(PairFx.BLUE, 0.4 * (1.0 - k2)))
		draw_circle(Vector2.ZERO, radius * 1.3, Color(PairFx.SKY, 0.25))
		draw_circle(Vector2.ZERO, radius, PairFx.BLUE)
		draw_circle(Vector2.ZERO, radius * 0.55, PairFx.WHITE)
		draw_circle(Vector2(-f * radius * 0.2, -radius * 0.3), radius * 0.18, Color(1, 1, 1, 0.8))

## คลื่นพลังน้ำเงินตรงไปหน้า ทรงพระจันทร์เสี้ยวมน ทะลุมอน
class PairWave extends WolfBall:
	func _draw() -> void:
		var f := signf(vel.x) if vel.x != 0.0 else 1.0
		if _pop >= 0.0:
			return
		var r := radius
		for layer in 3:
			var s := 1.0 - float(layer) * 0.22
			var pts := PackedVector2Array()
			for i in 17:
				var t := lerpf(-1.25, 1.25, float(i) / 16.0)
				pts.append(Vector2(cos(t) * f * r * 0.6 * s, sin(t) * r * 1.3 * s))
			for i in 17:
				var t := lerpf(1.25, -1.25, float(i) / 16.0)
				pts.append(Vector2(cos(t) * f * r * 0.25 * s - f * r * 0.15, sin(t) * r * 1.1 * s))
			var col: Color = [Color(PairFx.BLUE, 0.4), Color(PairFx.SKY, 0.7), Color(PairFx.WHITE, 0.95)][layer]
			SoftDraw.poly(self, pts, col)

## ระเบิดน้ำเงิน ปาเป็นวิถีโค้ง ตกถึงพื้นแล้วระเบิดเป็นวง
class PairGrenade extends Node2D:
	var page: WalkPage
	var vel := Vector2.ZERO
	var _boom := -1.0
	func _process(delta: float) -> void:
		if _boom >= 0.0:
			_boom += delta
			if _boom > 0.4:
				queue_free()
			queue_redraw()
			return
		vel.y += 1800.0 * delta
		position += vel * delta
		if position.y >= -10.0:
			position.y = 0.0
			_boom = 0.0
			if is_instance_valid(page):
				page._explode(position + Vector2(0.0, -40.0), 210.0, 22.0, {"type": "launch", "vy": 9.0})
		queue_redraw()
	func _draw() -> void:
		if _boom >= 0.0:
			var k := _boom / 0.4
			draw_circle(Vector2(0.0, -40.0), 60.0 + 180.0 * k, Color(PairFx.SKY, 0.35 * (1.0 - k)))
			draw_arc(Vector2(0.0, -40.0), 70.0 + 200.0 * k, 0.0, TAU, 40, Color(PairFx.WHITE, 1.0 - k), 8.0 * (1.0 - k) + 1.0, true)
			return
		draw_circle(Vector2.ZERO, 22.0, PairFx.BLUE)
		draw_circle(Vector2(-6.0, -6.0), 8.0, PairFx.WHITE)
		draw_circle(Vector2(0.0, -22.0), 6.0, Color(1.0, 0.85, 0.3))

## อีกตัวกระโดดออกมาจากด้านหลังตัวละคร เตะไปหน้า (หรือพุ่งลงต่อยพื้น) แล้วค่อยๆ หายไป
class PairAssist extends Node2D:
	var page: WalkPage
	var dive := false
	var actor: Hero
	var _t := 0.0
	var _hit_done := false
	const KICK_AT := 0.32
	const FADE_FROM := 0.6
	const END := 0.95
	func _ready() -> void:
		var hero := page.hero
		actor = Hero.new()
		actor.plain = true
		actor.plain_weapon = "azure"
		actor.set_job("boy")
		add_child(actor)
		actor.use_model("cat_" + SkillPanel.pair_partner(WalkPage.pair_form))
		actor.remove_from_group("hero")
		actor.facing = hero.facing
		actor.pos = Vector2(hero.pos.x - hero.facing * 1.4, hero.pos.y + (2.5 if dive else 0.0))
		actor.vel = Vector2(hero.facing * (5.0 if not dive else 3.0), Hero.JUMP_VELOCITY * (0.75 if not dive else 0.2))
		var kick: Dictionary = (Hero.CAT_SKILLS["cat_sk_kick"] as Dictionary).duplicate(true)
		if dive:
			kick = (Hero.CAT_SKILLS["cat_sk_kick"] as Dictionary).duplicate(true)
			kick["lean"] = 35.0
		actor.plain_move = kick
		actor.plain_swing_kind = "combo"
		actor.plain_combo_id += 1
		actor.plain_swing = 0.001
	func _process(delta: float) -> void:
		_t += delta
		if not is_instance_valid(actor) or not is_instance_valid(page):
			queue_free()
			return
		actor.input_dir = 0.0
		actor.plain_swing = clampf(_t / KICK_AT * 0.55, 0.001, 1.0)
		if dive and _t > 0.12:
			actor.vel = Vector2(actor.facing * 6.0, -Hero.CHIBI_DIVE_SPEED * 0.8)
		if not _hit_done and _t >= KICK_AT:
			_hit_done = true
			var f := actor.facing
			var at := actor.position.x + f * 110.0
			# คู่หูกระโดดเข้ามาตี มอนแค่ชะงักเบาๆ ไม่สตั๊น ไม่ล้ม ไม่ลอย
			if dive:
				page._hit_area(at, 190.0, 20.0, f, null, {"type": "flinch", "kb": 0.4, "stun": 0.4})
			else:
				page._hit_area(at, 150.0, 18.0, f, null, {"type": "flinch", "kb": 0.4, "stun": 0.4})
			var fx := PairFx.new()
			fx.kind = "pound" if dive else "kick"
			fx.dir = f
			fx.position = actor.position
			page.world.add_child(fx)
			# คู่หูกระโดดออกมาโจมตีนับเป็นการสลับตัว ตัวที่ออกมากลายเป็นตัวที่เล่นต่อ
			var land := Vector2(actor.pos.x, maxf(actor.pos.y, 0.0))
			if page.pair_swap(false, land, f):
				queue_free()
				return
		if _t >= FADE_FROM and actor.plain_model != null:
			actor.plain_model.shade = Color(1.0, 1.0, 1.0, clampf(1.0 - (_t - FADE_FROM) / (END - FADE_FROM), 0.0, 1.0))
		if _t >= END:
			queue_free()
