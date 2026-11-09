class_name PairSkillFx
extends Node2D
## ภาพสกิลของ CAT AZURE & LAPIS (pr_sk_) ทรงมนทั้งหมด ไม่มีดาวแฉก
## สีหลักน้ำเงินของคู่ + สีแซมหนึ่งสีต่อสาย (BASIC ขาว  DREAMER เหลืองนวล  FIEND ฟ้านีออน)
## kind: ring burst pillow door zone bolt column coil bar beam line notes moon bubble drops zzz sheep cross

var kind := "ring"
var base := Color(0.35, 0.55, 0.95)
var accent := Color(1.0, 1.0, 1.0)
var size := 100.0
var life := 0.5
var dir := 1.0
var to := Vector2.ZERO          # ปลายทาง (bolt line beam) เทียบกับตำแหน่งตัวเอง
var follow: Node2D
var offset := Vector2.ZERO
var seed_no := 0
var _t := 0.0

func _ready() -> void:
	seed_no = randi() % 1000

func _process(delta: float) -> void:
	_t += delta
	if is_instance_valid(follow):
		position = follow.position + offset
	if _t >= life:
		queue_free()
		return
	queue_redraw()

## ค่าจางเข้า-ออก 0..1
func _fade(inn := 0.1, out := 0.25) -> float:
	return clampf(_t / maxf(inn, 0.001), 0.0, 1.0) * clampf((life - _t) / maxf(out, 0.001), 0.0, 1.0)

func _draw() -> void:
	var k := clampf(_t / life, 0.0, 1.0)
	var a := _fade()
	match kind:
		"ring":
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.45))
			draw_arc(Vector2.ZERO, size * (0.3 + 0.7 * k), 0.0, TAU, 48, Color(base, 0.8 * (1.0 - k)), 12.0 * (1.0 - k) + 2.0, true)
			draw_arc(Vector2.ZERO, size * (0.2 + 0.6 * k), 0.0, TAU, 48, Color(accent, 1.0 - k), 5.0 * (1.0 - k) + 1.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"burst":
			draw_circle(Vector2.ZERO, size * (0.3 + 0.7 * k), Color(base, 0.3 * (1.0 - k)))
			draw_arc(Vector2.ZERO, size * (0.35 + 0.75 * k), 0.0, TAU, 40, Color(accent, 1.0 - k), 6.0 * (1.0 - k) + 1.0, true)
			for i in 8:
				var ang := TAU * float(i) / 8.0 + float(seed_no)
				draw_circle(Vector2(cos(ang), sin(ang)) * size * (0.4 + 0.8 * k), size * 0.09 * (1.0 - k) + 1.5, Color(accent if i % 2 == 0 else base, 1.0 - k))
		"pillow":
			# หมอนนุ่มสี่เหลี่ยมมุมมน ตกลงมา (k ช่วงแรก) แล้วแบนตอนกระแทก
			var drop := clampf(_t / 0.18, 0.0, 1.0)
			var squash := 1.0 + 0.35 * clampf((_t - 0.18) / 0.12, 0.0, 1.0) * (1.0 - clampf((_t - 0.3) / 0.3, 0.0, 1.0))
			var c := Vector2(0.0, -size * 0.5 - (1.0 - drop) * size * 2.2)
			var w := size * 1.2 * squash
			var h := size * 0.75 / squash
			var r := Rect2(c - Vector2(w, h) * 0.5, Vector2(w, h))
			UiStyle.fill(self, r, Color(accent.lerp(Color.WHITE, 0.4), a), h * 0.4)
			UiStyle.fill(self, r.grow(-h * 0.14), Color(base.lerp(Color.WHITE, 0.55), a), h * 0.32)
			for sx in [-1.0, 1.0]:
				draw_circle(c + Vector2(sx * w * 0.5, -h * 0.42), h * 0.13, Color(accent.lerp(Color.WHITE, 0.3), a))
				draw_circle(c + Vector2(sx * w * 0.5, h * 0.42), h * 0.13, Color(accent.lerp(Color.WHITE, 0.3), a))
		"door":
			# ประตูฝันกลม เปิดขยายแล้วหดหาย มีวงหมุนข้างใน
			var open := clampf(_t / 0.25, 0.0, 1.0) * clampf((life - _t) / 0.3, 0.0, 1.0)
			var rr := size * open
			draw_circle(Vector2.ZERO, rr * 1.15, Color(base, 0.25 * a))
			draw_circle(Vector2.ZERO, rr, Color(base.darkened(0.35), 0.85 * a))
			for i in 3:
				var rot := _t * (3.0 + float(i)) + float(i) * 2.0
				draw_arc(Vector2.ZERO, rr * (0.3 + 0.22 * float(i)), rot, rot + PI * 1.2, 24, Color(accent, 0.8 * a), 5.0, true)
			draw_arc(Vector2.ZERO, rr, 0.0, TAU, 48, Color(accent, a), 6.0, true)
		"zone":
			# พื้นที่วงรีบนพื้น (ผ้าห่ม ฟองฝัน) มีวงกลมเล็กลอยขึ้น
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.28))
			draw_circle(Vector2.ZERO, size, Color(base, 0.32 * a))
			draw_arc(Vector2.ZERO, size, 0.0, TAU, 56, Color(accent, 0.8 * a), 5.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for i in 6:
				var ph := fmod(_t * 0.8 + float(i) / 6.0, 1.0)
				var x := (float(i) / 5.0 - 0.5) * size * 1.5
				draw_circle(Vector2(x, -ph * size * 0.8), 6.0 * (1.0 - ph) + 2.0, Color(accent, a * (1.0 - ph)))
		"bolt", "line":
			_bolt(Vector2.ZERO, to, a, kind == "line")
		"column":
			# เสาแสงฟ้าผ่าลงจุดเดียว ขอบมน
			var w2 := size * (1.0 - k * 0.6)
			var top := Vector2(0.0, -size * 6.0)
			draw_line(top, Vector2.ZERO, Color(base, 0.45 * a), w2, true)
			draw_line(top, Vector2.ZERO, Color(accent, a), w2 * 0.35, true)
			draw_circle(Vector2.ZERO, w2 * 0.9, Color(accent, 0.6 * a))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.3))
			draw_arc(Vector2.ZERO, size * (0.6 + 1.6 * k), 0.0, TAU, 40, Color(base, 1.0 - k), 6.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"coil":
			# เสาเทสลาเล็ก ปลายลูกกลม เรืองแสงกะพริบ
			var glow := 0.6 + 0.4 * sin(_t * 18.0)
			draw_line(Vector2(0.0, 0.0), Vector2(0.0, -size), Color(base.darkened(0.3), a), size * 0.16, true)
			for i in 3:
				draw_arc(Vector2(0.0, -size * (0.3 + 0.2 * float(i))), size * 0.18, 0.0, TAU, 20, Color(accent, a), 3.0, true)
			draw_circle(Vector2(0.0, -size), size * 0.28, Color(base, a))
			draw_circle(Vector2(0.0, -size), size * 0.4, Color(accent, 0.25 * glow * a))
			draw_circle(Vector2(0.0, -size), size * 0.14, Color(accent, a))
		"bar":
			# แท่งนีออนตั้งตรง ตกลงมาจากบนแล้วกระแทก
			var drop2 := clampf(_t / 0.15, 0.0, 1.0)
			var hgt := size * 3.0
			var y0 := -hgt - (1.0 - drop2) * hgt
			var rr2 := Rect2(Vector2(-size * 0.18, y0), Vector2(size * 0.36, hgt))
			UiStyle.fill(self, rr2.grow(10.0), Color(base, 0.35 * a), size * 0.25)
			UiStyle.fill(self, rr2, Color(accent, a), size * 0.18)
			if drop2 >= 1.0:
				draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.3))
				draw_arc(Vector2.ZERO, size * (0.5 + 1.2 * k), 0.0, TAU, 32, Color(base, 1.0 - k), 5.0, true)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"beam":
			# ลำแสงยาวแนวนอนไปทาง to หัวท้ายมน
			var wb := size * (1.0 - k * 0.7)
			draw_line(Vector2.ZERO, to, Color(base, 0.4 * a), wb, true)
			draw_line(Vector2.ZERO, to, Color(accent, a), wb * 0.4, true)
			draw_circle(Vector2.ZERO, wb * 0.6, Color(accent, a))
			draw_circle(to, wb * 0.5, Color(base, a))
		"notes":
			# วงโน้ตกลมหมุนรอบจุด (เพลงกล่อมนอน)
			for i in 8:
				var ang2 := TAU * float(i) / 8.0 + _t * 2.5
				var p := Vector2(cos(ang2), sin(ang2) * 0.5) * size * (0.4 + 0.6 * minf(k * 3.0, 1.0))
				draw_circle(p, size * 0.07 + 2.0, Color(accent, a))
				draw_line(p + Vector2(size * 0.06, 0.0), p + Vector2(size * 0.06, -size * 0.18), Color(accent, a), 3.0, true)
				draw_circle(p + Vector2(size * 0.06, -size * 0.18), 3.0, Color(base, a))
		"moon":
			# จันทร์เสี้ยวฝัน วาดด้วยวงกลมสองวง หันตามทิศ
			draw_circle(Vector2.ZERO, size * 1.25, Color(accent, 0.2 * a))
			draw_circle(Vector2.ZERO, size, Color(accent, a))
			draw_circle(Vector2(-dir * size * 0.45, -size * 0.15), size * 0.85, Color(base.darkened(0.2), a))
		"bubble":
			# ฟองฝันใหญ่ครอบพื้นที่
			var grow := minf(k * 4.0, 1.0)
			draw_circle(Vector2.ZERO, size * grow, Color(base, 0.22 * a))
			draw_arc(Vector2.ZERO, size * grow, 0.0, TAU, 56, Color(accent, 0.9 * a), 6.0, true)
			draw_circle(Vector2(-size * 0.4, -size * 0.45) * grow, size * 0.12 * grow, Color(1.0, 1.0, 1.0, 0.6 * a))
			for i in 5:
				var ang3 := _t * 1.5 + TAU * float(i) / 5.0
				draw_circle(Vector2(cos(ang3), sin(ang3)) * size * 0.6 * grow, size * 0.08, Color(accent, 0.6 * a))
		"drops":
			# เม็ดประกายกลมตกในพื้นที่กว้าง size ครึ่งหนึ่ง
			for i in 14:
				var ph2 := fmod(_t * 2.2 + float((i * 37 + seed_no) % 100) / 100.0, 1.0)
				var x2 := (float((i * 53 + seed_no) % 100) / 100.0 - 0.5) * size * 2.0
				var y2 := -size * 2.2 * (1.0 - ph2)
				draw_line(Vector2(x2, y2 - 26.0), Vector2(x2, y2), Color(base, 0.5 * a), 7.0, true)
				draw_circle(Vector2(x2, y2), 7.0, Color(accent, a))
		"zzz":
			# วงฟองเล็กลอยขึ้น (หลับ)
			for i in 3:
				var ph3 := fmod(_t * 1.2 + float(i) * 0.33, 1.0)
				draw_arc(Vector2(dir * ph3 * size * 0.6, -ph3 * size), size * (0.08 + 0.08 * float(i)), 0.0, TAU, 20, Color(accent, a * (1.0 - ph3)), 3.0, true)
		"cross":
			# กากบาทเส้นนีออนสองเส้นตัดกัน
			var d1 := Vector2(size, -size * 0.55) * minf(k * 4.0, 1.0)
			var d2 := Vector2(size, size * 0.55) * minf(k * 4.0, 1.0)
			for d in [d1, d2]:
				draw_line(-d, d, Color(base, 0.45 * a), 22.0, true)
				draw_line(-d, d, Color(accent, a), 8.0, true)
				draw_circle(d, 9.0, Color(accent, a))
				draw_circle(-d, 9.0, Color(accent, a))

## สายฟ้าซิกแซกปลายมน  straight เส้นตรงนีออน
func _bolt(from: Vector2, end: Vector2, a: float, straight: bool) -> void:
	var pts := PackedVector2Array()
	var n := 1 if straight else 7
	var nrm := (end - from).orthogonal().normalized()
	var flick := int(_t * 20.0)
	for i in n + 1:
		var kk := float(i) / float(n)
		var p := from.lerp(end, kk)
		if not straight and i > 0 and i < n:
			p += nrm * (float(((i * 31 + flick * 17 + seed_no) % 21)) - 10.0) * 2.2
		pts.append(p)
	draw_polyline(pts, Color(base, 0.45 * a), size * 0.22 + 10.0, true)
	draw_polyline(pts, Color(accent, a), size * 0.08 + 3.0, true)
	draw_circle(from, size * 0.12 + 4.0, Color(accent, a))
	draw_circle(end, size * 0.12 + 4.0, Color(accent, a))


## ลูกพลังของคู่หู (ฟอง แกะฝัน ประกายไฟฟ้า นีออน) ใช้ระบบชนของ WolfBall
class PairOrb extends WolfBall:
	var style := "bubble"
	var base := Color(0.35, 0.55, 0.95)
	var accent := Color(1.0, 1.0, 1.0)
	var bounce := 0                # กระเด้งบนพื้นได้กี่ครั้ง (ฟอง แกะ)
	var gravity := 0.0
	func _process(delta: float) -> void:
		if gravity != 0.0 and _pop < 0.0:
			vel.y += gravity * delta
			if position.y + vel.y * delta >= -radius and vel.y > 0.0:
				if bounce > 0:
					bounce -= 1
					vel.y = -absf(vel.y) * 0.85
				else:
					position.y = -radius - 1.0
					vel.y = 0.0
					gravity = 0.0
		super._process(delta)
	func _draw() -> void:
		if _pop >= 0.0:
			var k := _pop / 0.25
			draw_circle(Vector2.ZERO, radius * (1.0 + k), Color(base, 0.35 * (1.0 - k)))
			draw_arc(Vector2.ZERO, radius * (1.0 + k * 1.2), 0.0, TAU, 32, Color(accent, 1.0 - k), 6.0 * (1.0 - k) + 1.0, true)
			for i in 6:
				var ang := TAU * float(i) / 6.0
				draw_circle(Vector2(cos(ang), sin(ang)) * radius * (0.8 + k * 1.2), 6.0 * (1.0 - k) + 1.0, Color(accent, 1.0 - k))
			return
		var f := signf(vel.x) if vel.x != 0.0 else 1.0
		var r := radius * (1.0 + 0.05 * sin(_t * 14.0))
		match style:
			"sheep":
				# แกะฝันปุยกลม หน้าน้ำเงินเข้ม
				for i in 7:
					var ang2 := TAU * float(i) / 7.0
					draw_circle(Vector2(cos(ang2) * r * 0.62, sin(ang2) * r * 0.5), r * 0.45, Color(1.0, 0.99, 0.96))
				draw_circle(Vector2.ZERO, r * 0.7, Color(1.0, 0.99, 0.96))
				draw_circle(Vector2(f * r * 0.62, -r * 0.05), r * 0.36, base.darkened(0.3))
				draw_circle(Vector2(f * r * 0.72, -r * 0.12), r * 0.06, Color.WHITE)
				draw_arc(Vector2.ZERO, r * 0.9, 0.0, TAU, 32, Color(accent, 0.8), 3.0, true)
			"spark":
				# ลูกไฟฟ้ากลม มีเส้นโค้งไฟฟ้าวนรอบ
				draw_circle(Vector2.ZERO, r * 1.5, Color(accent, 0.18))
				draw_circle(Vector2.ZERO, r, base)
				draw_circle(Vector2.ZERO, r * 0.55, accent)
				for i in 3:
					var rot := _t * 12.0 + float(i) * TAU / 3.0
					draw_arc(Vector2.ZERO, r * 1.25, rot, rot + 1.0, 10, Color(accent, 0.9), 4.0, true)
			"neon":
				# ลูกนีออนขาวน้ำเงินหางกลมยาว
				for i in 6:
					var kk := float(i + 1) / 7.0
					draw_circle(Vector2(-f * r * (0.6 + kk * 2.4), 0.0), r * (0.7 - kk * 0.5), Color(base, 0.5 * (1.0 - kk)))
				draw_circle(Vector2.ZERO, r * 1.2, Color(base, 0.4))
				draw_circle(Vector2.ZERO, r * 0.8, accent)
			"moon":
				draw_circle(Vector2.ZERO, r * 1.3, Color(accent, 0.2))
				draw_circle(Vector2.ZERO, r, accent)
				draw_circle(Vector2(-f * r * 0.62, -r * 0.18), r * 0.7, Color(base.lightened(0.35), 0.9))
			_:
				# ฟองใส ขอบสีแซม มีจุดสะท้อน
				draw_circle(Vector2.ZERO, r, Color(base, 0.35))
				draw_arc(Vector2.ZERO, r, 0.0, TAU, 32, Color(accent, 0.95), 4.0, true)
				draw_circle(Vector2(-r * 0.35, -r * 0.35), r * 0.18, Color(1.0, 1.0, 1.0, 0.8))


## อีกตัวของคู่โผล่ออกมาช่วยชั่วครู่ (ไม่สลับตัว) ทำท่าตาม move แล้วจางหาย
class PairPartner extends Node2D:
	var page: WalkPage
	var actor: Hero
	var at := Vector2.ZERO          # ตำแหน่งเริ่ม (หน่วยเกม)
	var facing := 1.0
	var move: Dictionary = {}
	var swing_time := 0.4
	var life := 0.9
	var fn: Callable                # เรียกตอนท่าออก (fn_at วินาที)
	var fn_at := 0.25
	var ghost := false              # ร่างฝันโปร่งแสง
	var hop := 0.0
	var _t := 0.0
	var _fired := false
	func _ready() -> void:
		actor = Hero.new()
		actor.plain = true
		actor.plain_weapon = "azure"
		actor.set_job("boy")
		add_child(actor)
		actor.use_model("cat_" + SkillPanel.pair_partner(WalkPage.pair_form))
		actor.remove_from_group("hero")
		actor.facing = facing
		actor.pos = at
		actor.position = Vector2(at.x, -at.y) * CombatData.UNIT
		actor.vel = Vector2(0.0, Hero.JUMP_VELOCITY * hop)
		if not move.is_empty():
			actor.plain_move = move
			actor.plain_swing_kind = "combo"
			actor.plain_combo_id += 1
			actor.plain_swing = 0.001
	func _process(delta: float) -> void:
		_t += delta
		if not is_instance_valid(actor) or not is_instance_valid(page):
			queue_free()
			return
		actor.input_dir = 0.0
		if not move.is_empty():
			actor.plain_swing = clampf(_t / swing_time, 0.001, 1.0)
		if not _fired and _t >= fn_at:
			_fired = true
			if fn.is_valid():
				fn.call(self)
		if actor.plain_model != null:
			var fade := clampf((life - _t) / 0.3, 0.0, 1.0) * clampf(_t / 0.12, 0.0, 1.0)
			actor.plain_model.shade = Color(1.0, 1.0, 1.0, fade * (0.55 if ghost else 1.0))
		if _t >= life:
			queue_free()
	## จุดภาพในโลกของตัวช่วย
	func world_pos() -> Vector2:
		return actor.position if is_instance_valid(actor) else Vector2(at.x, -at.y) * CombatData.UNIT
