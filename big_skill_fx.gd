class_name BigSkillFx
extends Node2D
## ความอลังการของสกิลใหญ่ (มานาเกิน 150) ภาพล้วน ไม่ยุ่งกับดาเมจ เวลา หรือมานา
## ตอนร่าย: แสงฟุ้งรอบตัวหลายชั้น วงบนพื้นมีตราอุ้งเท้า แสงเสาทรงแคปซูลจางๆ อนุภาคตามสายลอยวน
## ตอนโดน: วงซ้อนกับควันกลม และอนุภาคตามสาย
## สีหลักตามตัวละคร แซมหนึ่งสีตามสาย อนุภาคต่างกันตามสาย ทรงมนทั้งหมด ไม่มีดาว

const MIN_MP := 150.0
static var enabled := true      # ปิดไว้ได้ (ใช้เทียบภาพก่อน/หลัง)

var kind := "cast"
var base := Color.WHITE
var accent := Color.WHITE
var bits := "dot"          # ชนิดอนุภาค
var k := 1.0               # ความใหญ่ตามมานา
var life := 1.1
var follow: Node2D
var _t := 0.0
var _seeds: Array = []

# ---------------------------------------------------------------- เรียกใช้
## เรียกตอนเริ่มสกิล ไม่ทำอะไรถ้ามานาไม่เกิน 150 หรือเป็น HYPER
static func cast(page: WalkPage, id: String, mp: float) -> void:
	if not enabled or page == null or mp <= MIN_MP or id.ends_with("_hyper") or page.hero == null:
		return
	var look := style_of(WalkPage.chosen_weapon, WalkPage.chosen_class)
	var kk := 1.0 + clampf((mp - MIN_MP) / 150.0, 0.0, 1.0) * 0.6
	var hero := page.hero
	# แสงฟุ้งรอบตัว + เสาแสง ตามตัวละคร
	var c := _make(page, "cast", look, kk, 1.0 + 0.2 * kk)
	c.position = hero.position
	c.follow = hero
	# วงบนพื้นมีตราอุ้งเท้า
	var g := _make(page, "decal", look, kk, 1.3)
	g.position = Vector2(hero.position.x, 0.0)
	g.show_behind_parent = true
	g.z_index = -1
	# ขยายเอฟเฟกต์หลักของสกิลชั่วครู่ (SusiSkills._fx อ่านค่านี้)
	page.set_meta("big_boost_k", 1.3 if mp < 250.0 else 1.55)
	page.set_meta("big_boost_until", Time.get_ticks_msec() + 1600)
	# ตัวเฝ้า: มอนโดนดาเมจช่วงนี้ เกิดเอฟเฟกต์ตอนโดน  CAT BOYS ขยายเอฟเฟกต์ที่เกิดใหม่ช่วงต้น
	var w := Watch.new()
	w.page = page
	w.look = look
	w.k = kk
	w.left = 2.6 if mp >= 250.0 else 1.9
	w.grow = WalkPage.chosen_weapon == "cat"
	w.grow_k = 1.3 if mp < 250.0 else 1.5
	page.world.add_child(w)

## ตัวคูณขนาดเอฟเฟกต์หลักตอนนี้ (1 ถ้าไม่ได้อยู่ในช่วงสกิลใหญ่)
static func boost(page: Node) -> float:
	if not enabled or page == null or not page.has_meta("big_boost_until"):
		return 1.0
	if Time.get_ticks_msec() > int(page.get_meta("big_boost_until")):
		return 1.0
	return float(page.get_meta("big_boost_k"))

## สีหลัก สีแซม และอนุภาคของแต่ละตัวละครกับสาย
static func style_of(weapon: String, cls: String) -> Dictionary:
	var b := Color(1.0, 0.5, 0.45)
	var a := Color(1.0, 0.92, 0.8)
	var p := "petal"
	match weapon:
		"cat":
			b = Color(1.0, 0.48, 0.42)
			if cls in ["MAGIC KNIGHT", "FLAME KNIGHT"]:
				a = Color(1.0, 0.75, 0.3)
				p = "ember"
			elif cls in ["SHIELD KNIGHT", "GUARDIAN KNIGHT"]:
				a = Color(1.0, 0.9, 0.55)
				p = "dot"
			elif cls in ["DARK KNIGHT", "CRIMSON KNIGHT"]:
				a = Color(0.95, 0.45, 0.6)
				p = "petal"
			else:
				a = Color(0.95, 0.95, 1.0)
				p = "petal"
		"mage":
			b = Color(0.78, 0.62, 1.0)
			if cls in ["ARCH MAGE", "ELEMENT MASTER"]:
				a = Color(1.0, 0.85, 0.6)
				p = "tri"
			elif cls in ["BATTLE MAGE", "DIMENSION CASTER"]:
				a = Color(1.0, 0.7, 0.9)
				p = "bubble"
			elif cls in ["DARK MAGE", "ECLIPSE"]:
				a = Color(0.45, 0.35, 0.6)
				p = "feather"
			elif cls in ["ALCHEMIST MAGE", "TRANSMUTATION MASTER"]:
				a = Color(1.0, 0.86, 0.45)
				p = "bubble"
			else:
				a = Color(0.95, 0.9, 1.0)
				p = "note"
		"bow":
			b = Color(0.55, 0.88, 0.52)
			if cls in ["SNIPESTARKER", "APEX SNIPER"]:
				a = Color(1.0, 0.86, 0.45)
				p = "feather"
			elif cls in ["MANASTARKER", "ESSENCE WEAVER"]:
				a = Color(0.7, 0.85, 1.0)
				p = "tri"
			elif cls == "TRAPSTARKER":
				a = Color(0.8, 0.62, 0.38)
				p = "leaf"
			elif cls == "TWILIGHT":
				a = Color(0.75, 0.55, 1.0)
				p = "feather"
			else:
				a = Color(0.88, 1.0, 0.95)
				p = "leaf"
		"spear":
			b = Color(1.0, 0.66, 0.28)
			if cls in ["PETIT TIGER", "FIERCE PROWLER"]:
				a = Color(1.0, 0.95, 0.85)
				p = "ember"
			elif cls in ["PETIT FANG", "LUPINE DIRE"]:
				a = Color(0.2, 0.16, 0.18)
				p = "dot"
			elif cls in ["PETIT VIXEN", "PHANTOM VULPINE"]:
				a = Color(0.75, 0.9, 1.0)
				p = "petal"
			elif cls in ["PETIT SHELL", "GENBU TITAN"]:
				a = Color(0.6, 0.95, 0.75)
				p = "bubble"
			else:
				a = Color(1.0, 0.92, 0.6)
				p = "dot"
		"azure":
			b = Color(0.6, 0.82, 1.0)
			a = Color(0.25, 0.35, 0.75)
			p = "note"
		"fist":
			b = Color(0.7, 0.72, 0.78)
			a = Color(1.0, 0.93, 0.78)
			p = "dot"
	return {"base": b, "accent": a, "bits": p}

static func _make(page: WalkPage, kind_name: String, look: Dictionary, kk: float, life_s: float) -> BigSkillFx:
	var n := BigSkillFx.new()
	n.kind = kind_name
	n.base = look["base"]
	n.accent = look["accent"]
	n.bits = look["bits"]
	n.k = kk
	n.life = life_s
	n.scale = Vector2.ONE * SkillScale.K
	page.world.add_child(n)
	return n

# ---------------------------------------------------------------- ตัวเฝ้าระหว่างสกิล
class Watch extends Node:
	var page: WalkPage
	var look := {}
	var k := 1.0
	var left := 2.0
	var grow := false
	var grow_k := 1.3
	var _hp := {}
	var _last := {}
	var _grow_left := 0.5
	func _ready() -> void:
		if not is_instance_valid(page):
			return
		for e in page.get_tree().get_nodes_in_group("monsters"):
			_hp[e] = float((e as Monster).hp)
		if grow:
			page.world.child_entered_tree.connect(_on_child)
	func _on_child(n: Node) -> void:
		if _grow_left <= 0.0 or not (n is Node2D) or n is Monster or n is Hero or n is BigSkillFx or n is Watch:
			return
		var nd := n as Node2D
		# ขยายเฉพาะเอฟเฟกต์ที่วางตำแหน่งของตัวเอง (วาดรอบจุดของตัวเอง)
		if nd.position == Vector2.ZERO:
			return
		nd.scale *= grow_k
	func _process(delta: float) -> void:
		left -= delta
		_grow_left -= delta
		if not is_instance_valid(page) or left <= 0.0:
			if grow and is_instance_valid(page) and page.world.child_entered_tree.is_connected(_on_child):
				page.world.child_entered_tree.disconnect(_on_child)
			queue_free()
			return
		var now := Time.get_ticks_msec()
		for e in page.get_tree().get_nodes_in_group("monsters"):
			var m := e as Monster
			if m == null:
				continue
			var hp := float(m.hp)
			var before := float(_hp.get(m, hp))
			_hp[m] = hp
			if hp < before and now - int(_last.get(m, -1000)) > 120:
				_last[m] = now
				var fx := BigSkillFx._make(page, "impact", look, k, 0.55)
				fx.position = m.position + Vector2(randf_range(-16.0, 16.0), -WalkPage.MONSTER_MID + randf_range(-24.0, 24.0))

# ---------------------------------------------------------------- วาด
func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var n := 0
	match kind:
		"cast":
			n = int(4.0 + 3.0 * (k - 1.0) / 0.6)
		"impact":
			n = 0
		"decal":
			n = 0
	for i in n:
		# [มุม ระยะเริ่ม ความเร็ว ขนาด หมุน หน่วง]
		_seeds.append([rng.randf() * TAU, rng.randf_range(20.0, 70.0), rng.randf_range(160.0, 320.0), rng.randf_range(0.7, 1.3), rng.randf_range(-3.0, 3.0), rng.randf_range(0.0, 0.25)])

func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	if is_instance_valid(follow):
		position = follow.position
	queue_redraw()

func _draw() -> void:
	var u := clampf(_t / life, 0.0, 1.0)
	match kind:
		"cast":
			_draw_cast(u)
		"decal":
			_draw_decal(u)
		"impact":
			_draw_impact(u)

func _ease(x: float) -> float:
	return 1.0 - pow(1.0 - clampf(x, 0.0, 1.0), 3.0)

## ตอนร่าย: แสงฟุ้งนุ่มวงเดียวค่อยๆ ขยายแล้วจาง อนุภาคไม่กี่เม็ดลอยขึ้นช้าๆ (ไม่มีเสาแสง ไม่มีวงซ้อน)
func _draw_cast(u: float) -> void:
	var fade := 1.0 - clampf((u - 0.5) / 0.5, 0.0, 1.0)
	var mid := Vector2(0.0, -80.0)
	var e := _ease(u * 1.4)
	draw_circle(mid, (70.0 + 50.0 * e) * k, Color(base, 0.1 * fade))
	draw_circle(mid, (40.0 + 30.0 * e) * k, Color(accent, 0.08 * fade))
	draw_arc(mid, (60.0 + 110.0 * e) * k, 0.0, TAU, 48, Color(base, 0.35 * (1.0 - e) * fade), 3.0 * k, true)
	for s2 in _seeds:
		var tt := clampf((_t - float(s2[5])) / (life * 0.9), 0.0, 1.0)
		if tt <= 0.0:
			continue
		var ang := float(s2[0]) + tt * float(s2[4]) * 0.4
		var dist := float(s2[1]) + float(s2[2]) * 0.45 * _ease(tt) * k
		var p := mid + Vector2(cos(ang) * dist, sin(ang) * dist * 0.5 - 70.0 * tt * k)
		_bit(p, 10.0 * float(s2[3]) * k, ang, 0.55 * (1.0 - tt))

## วงบนพื้น: วงรีจางวงเดียว ไม่มีตราอุ้งเท้า
func _draw_decal(u: float) -> void:
	var fade := 1.0 - clampf((u - 0.5) / 0.5, 0.0, 1.0)
	var e := _ease(u * 2.0)
	var rx := 190.0 * k * e
	var ry := 40.0 * k * e
	if rx < 2.0:
		return
	var pts := PackedVector2Array()
	for j in 49:
		var a2 := TAU * float(j) / 48.0
		pts.append(Vector2(cos(a2) * rx, sin(a2) * ry))
	draw_polyline(pts, Color(base, 0.35 * fade), 3.0 * k, true)

## ตอนโดน: วงนุ่มวงเดียว จางเร็ว
func _draw_impact(u: float) -> void:
	var e := _ease(u)
	var a2 := 1.0 - u
	draw_circle(Vector2.ZERO, (20.0 + 30.0 * e) * k, Color(base, 0.18 * a2))
	draw_arc(Vector2.ZERO, (24.0 + 60.0 * e) * k, 0.0, TAU, 32, Color(base, 0.45 * a2), 3.0 * a2 + 1.0, true)

## อนุภาคแต่ละชนิด ทรงมนทั้งหมด
func _bit(p: Vector2, s: float, rot: float, a: float) -> void:
	if a <= 0.0 or s < 1.0:
		return
	match bits:
		"petal":
			draw_set_transform(p, rot, Vector2(1.0, 0.55))
			draw_circle(Vector2.ZERO, s, Color(accent, a))
			draw_circle(Vector2(s * 0.3, 0.0), s * 0.55, Color(base.lightened(0.3), a))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"leaf":
			draw_set_transform(p, rot, Vector2(1.0, 0.45))
			draw_circle(Vector2.ZERO, s, Color(base.darkened(0.1), a))
			draw_line(Vector2(-s, 0.0), Vector2(s, 0.0), Color(accent, a), maxf(1.5, s * 0.15), true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"ember":
			draw_circle(p, s * 1.3, Color(accent, 0.3 * a))
			draw_circle(p, s * 0.7, Color(base.lightened(0.25), a))
			draw_circle(p + Vector2(0.0, s * 0.9), s * 0.35, Color(base, 0.6 * a))
		"bubble":
			draw_arc(p, s, 0.0, TAU, 20, Color(accent, a), maxf(1.5, s * 0.18), true)
			draw_circle(p + Vector2(-s * 0.35, -s * 0.35), s * 0.25, Color(1.0, 1.0, 1.0, 0.8 * a))
		"feather":
			draw_set_transform(p, rot, Vector2(1.0, 0.38))
			draw_circle(Vector2.ZERO, s * 1.2, Color(accent, a))
			draw_circle(Vector2(s * 0.5, 0.0), s * 0.6, Color(base.lightened(0.2), 0.8 * a))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"tri":
			var cols := [Color(1.0, 0.55, 0.45), Color(0.6, 0.85, 1.0), Color(1.0, 0.9, 0.45)]
			draw_circle(p, s * 0.7, Color(cols[int(absf(rot * 3.0)) % 3], a))
			draw_circle(p, s * 0.3, Color(1.0, 1.0, 1.0, 0.8 * a))
		"note":
			draw_circle(p, s * 0.55, Color(accent, a))
			draw_line(p + Vector2(s * 0.5, 0.0), p + Vector2(s * 0.5, -s * 1.5), Color(accent, a), maxf(1.5, s * 0.16), true)
			draw_circle(p + Vector2(s * 0.75, -s * 1.5), s * 0.28, Color(accent, a))
		"yarn":
			draw_circle(p, s * 0.75, Color(base.lightened(0.15), a))
			draw_arc(p, s * 0.5, rot, rot + PI, 10, Color(accent, a), maxf(1.5, s * 0.14), true)
			draw_arc(p, s * 0.3, rot + PI, rot + TAU, 8, Color(accent, a), maxf(1.2, s * 0.12), true)
		"fish":
			draw_set_transform(p, rot * 0.3, Vector2.ONE)
			draw_circle(Vector2.ZERO, s * 0.6, Color(accent, a))
			draw_circle(Vector2(-s * 0.75, 0.0), s * 0.32, Color(accent, a))
			draw_circle(Vector2(s * 0.25, -s * 0.15), s * 0.1, Color(0.2, 0.2, 0.25, a))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		_:
			draw_circle(p, s * 0.8, Color(accent, 0.35 * a))
			draw_circle(p, s * 0.45, Color(base.lightened(0.3), a))
