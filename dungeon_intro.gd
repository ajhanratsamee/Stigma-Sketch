class_name DungeonIntro
extends Node2D
## ท่าเปิดดัน: เข้าดันห้องแรก ตัวละครเล่นท่าชุดสั้นๆ 5-8 วิ ตามอาวุธและสาย (สายสุดท้ายท่าเยอะกว่า)
## ระหว่างเล่น ล็อกปุ่ม มอนหยุดนิ่ง ตัวละครไม่โดนดาเมจ ไม่มีการข้าม
## DefeatPose ท่าแพ้นุ่มๆ ตอนเลือดหมด (ล้มหงาย ตาวน แล้ว X_X เด้งเบาๆ)

const WAIT_MIN := 0.3            # รอหลังฉากพร้อมอย่างน้อยเท่านี้ (และรอวงกลมเปลี่ยนฉากเปิดสุด)
const CREAM := Color(1.0, 0.97, 0.92)
const COLORS := {
	"cat": Color(0.95, 0.56, 0.55), "sword": Color(0.95, 0.56, 0.55), "mage": Color(0.78, 0.62, 0.95),
	"bow": Color(0.58, 0.84, 0.55), "spear": Color(1.0, 0.72, 0.42), "fist": Color(0.74, 0.74, 0.8),
	"azure": Color(0.58, 0.76, 1.0),
}
const FIST_ACCENT := {"HEAVYWEIGHT": Color(0.98, 0.6, 0.45), "ZEPHYR": Color(0.45, 0.82, 0.78), "WAR MUAY": Color(0.98, 0.82, 0.4), "SYSTEMA GRAPPLER": Color(0.55, 0.68, 0.95)}
const STRIP := ["auto", "fx", "fx_start", "dive", "dive_forward", "leap", "hover", "turn_around", "drag", "front_hit", "multi", "wide", "sa", "plunge", "rise", "lunge"]

var page: WalkPage
var hero: Hero
var duration := 6.0
var _events: Array = []          # [เวลา, Callable] เรียงตามเวลา
var _next_ev := 0
var _t := -1.0                   # ติดลบคือยังรอฉากพร้อม
var _wait := 0.0
var _tw: Tween
var _frozen: Array = []
var _fx: Array = []              # {"kind", "at", "t", "life", "r", "c"}
var _partner: Hero
var _color := Color.WHITE
var _face0 := 1.0
var done := false

## เรียกจากหน้าดันตอนเริ่ม เล่นเฉพาะห้องแรก
static func begin(p: WalkPage) -> DungeonIntro:
	if p == null or p.hero == null or DungeonPage.stage != 0:
		return null
	var n := DungeonIntro.new()
	n.page = p
	n.hero = p.hero
	p.world.add_child(n)
	return n

func _ready() -> void:
	z_index = 4
	page.intro_lock = true
	_face0 = hero.facing if hero.facing != 0.0 else 1.0
	_color = COLORS.get(WalkPage.chosen_weapon, Color(0.9, 0.8, 0.75))
	if WalkPage.chosen_weapon == "fist":
		_color = _color.lerp(FIST_ACCENT.get(_line(), _color), 0.45)
	_color = _color.lerp(CREAM, 0.25)
	_build()

# ---------------------------------------------------------------- สาย / ตารางท่า
## สายขั้นแรกของคลาสที่เล่นอยู่ (BASIC คืน BASIC)
static func line_of(weapon: String, cls: String) -> String:
	if cls == "" or cls == "BASIC" or cls == "BOYS":
		return "BASIC"
	for tier in [SkillPanel.BOW_TIER2, SkillPanel.SPEAR_TIER2, SkillPanel.FIST_TIER2, SkillPanel.PAIR_TIER2, SkillPanel.CLASS_NEXT]:
		for k in tier:
			if k != "BASIC" and cls in (tier[k] as Array):
				return str(k)
	return cls

## เป็นคลาสขั้นสุดท้าย (ท่าเปิดดันยาวและเยอะกว่า)
static func is_final(weapon: String, cls: String) -> bool:
	return line_of(weapon, cls) != cls and cls != "BASIC"

func _line() -> String:
	return line_of(WalkPage.chosen_weapon, WalkPage.chosen_class)

func _start_id(button: String) -> String:
	var cls := WalkPage.chosen_class
	match WalkPage.chosen_weapon:
		"bow":
			return BowCombo.start(cls, "ground", button)
		"spear":
			return SpearCombo.start(cls, "ground", button)
		"fist":
			return FistCombo.start(cls, "ground", button)
		"azure":
			return PairCombo.start(cls, "ground", button)
		"mage":
			return MageCombo.start(cls, "ground", button)
	return "z1" if button == "z" else "x1"

func _next_id(cur: String, button: String) -> String:
	if cur == "":
		return ""
	var cls := WalkPage.chosen_class
	match WalkPage.chosen_weapon:
		"bow":
			return BowCombo.next(cls, cur, button, false, false)
		"spear":
			return SpearCombo.next(cls, cur, button, false, false)
		"fist":
			return FistCombo.next(cls, cur, button, false, false)
		"azure":
			return PairCombo.next(cls, cur, button, false, false)
		"mage":
			return MageCombo.next(cls, cur, button, false, false)
	return Hero.chibi_next(cls, cur, button)

## ท่าในสายของคลาสนี้: กด button ต่อกันได้กี่ท่า (ไม่ซ้ำ)
func _chain(button: String, n: int, first := "") -> Array:
	var out := []
	var id := first if first != "" else _start_id(button)
	while id != "" and out.size() < n and not id in out:
		out.append(id)
		id = _next_id(id, button)
	return out

# ---------------------------------------------------------------- สร้างท่าชุด
var _cur := 0.0

func _at(dt: float, fn: Callable) -> void:
	_events.append([_cur + dt, fn])

func _wait_for(dt: float) -> void:
	_cur += dt

func _build() -> void:
	var w := WalkPage.chosen_weapon
	var line := _line()
	var final := is_final(w, WalkPage.chosen_class)
	var zs := _chain("z", 4)
	var xs := _chain("x", 3)
	# 1) เดินเข้าฉาก มองซ้ายขวา
	_at(0.0, func() -> void: _walk(1.0); hero.show_face("big", 1.2))
	_wait_for(0.95)
	_at(0.0, func() -> void: _walk(0.0))
	_wait_for(0.25)
	_at(0.0, func() -> void: hero.facing = -_face0; hero.show_face("idle", 0.4))
	_wait_for(0.35)
	_at(0.0, func() -> void: hero.facing = _face0; hero.show_face("big", 0.4))
	_wait_for(0.35)
	# 2) ท่าประจำอาวุธ / สาย
	match w:
		"mage":
			_staff_spin(xs)
		"bow":
			_bow_draw(xs, zs)
		"spear":
			_spear_plant(zs)
		"fist":
			_fist_line(line, zs, xs)
		"azure":
			_duo(zs, xs)
		_:
			_sword_twirl(zs, xs)
	# 3) สายขั้นแรก เพิ่มท่าประจำสายอีกหนึ่งท่า  สายสุดท้ายเพิ่มอีกชุดใหญ่
	if not final and WalkPage.chosen_class != "BASIC" and WalkPage.chosen_class != "":
		_wait_for(0.1)
		_at(0.0, func() -> void: _move(_pick(xs, 1), 0.55); hero.show_face("fierce", 0.6); _ring(_hand(), 110.0, 0.6))
		_wait_for(0.7)
	if final:
		_wait_for(0.15)
		_at(0.0, func() -> void: _hop(0.55); _ring(hero.position, 120.0, 0.7))
		_wait_for(0.25)
		_at(0.0, func() -> void: _spin_flips(4, 0.08))
		_wait_for(0.45)
		var last: String = xs[xs.size() - 1] if not xs.is_empty() else (zs[0] if not zs.is_empty() else "")
		_at(0.0, func() -> void: _move(last, 0.6); hero.show_face("fierce", 0.7))
		_wait_for(0.5)
		_at(0.0, func() -> void: _ring(_hand(), 150.0, 0.8); _ring(_hand(), 90.0, 0.6))
		_wait_for(0.45)
	# 4) ท่าจบ หน้ายิ้ม
	_at(0.0, func() -> void: hero.facing = _face0; hero.show_face("happy", 1.4); _dots(hero.position + Vector2(0.0, -150.0), 1.2))
	_wait_for(0.25)
	var pose: String = zs[0] if not zs.is_empty() else ""
	_at(0.0, func() -> void: _move(pose, 0.55))
	_wait_for(0.9)
	duration = clampf(_cur, 5.0, 8.0)
	_events.sort_custom(func(a: Array, b: Array) -> bool: return float(a[0]) < float(b[0]))

## CAT BOYS / สายดาบ: หมุนตัวดาบควง ชี้ดาบ ฟันชุดของสาย
func _sword_twirl(zs: Array, xs: Array) -> void:
	_at(0.0, func() -> void: _hop(0.45); _spin_flips(4, 0.07))
	_wait_for(0.6)
	_at(0.0, func() -> void: _move(_pick(xs, 0), 0.55); hero.show_face("fierce", 0.8); _ring(_hand(), 100.0, 0.6))
	_wait_for(0.65)
	for i in mini(zs.size(), 3):
		var id: String = zs[i]
		_at(0.0, func() -> void: _move(id, 0.38))
		_wait_for(0.36)
	_at(0.0, func() -> void: _move(_pick(zs, 0), 0.6); hero.show_face("happy", 0.8))
	_wait_for(0.6)

## CAT SUSI: หมุนคฑาลอยตัว จุดนุ่มวนรอบ ร่ายท่าของสาย
func _staff_spin(xs: Array) -> void:
	_at(0.0, func() -> void: _hop(0.3); _spin_flips(6, 0.1); _dots(hero.position + Vector2(0.0, -80.0), 1.4))
	_wait_for(0.8)
	_at(0.0, func() -> void: _move(_pick(xs, 0), 0.6); hero.show_face("squint", 0.6); _ring(_hand(), 110.0, 0.7))
	_wait_for(0.75)
	_at(0.0, func() -> void: _move(_pick(xs, 1), 0.55); hero.show_face("happy", 0.6))
	_wait_for(0.65)
	_at(0.0, func() -> void: _hop(0.25); _ring(hero.position, 90.0, 0.6))
	_wait_for(0.5)

## CAT MATCHA: ง้างธนู เล็ง ยิ้มขยิบ ยิงท่าของสาย
func _bow_draw(xs: Array, zs: Array) -> void:
	_at(0.0, func() -> void: _move(_pick(xs, 0), 0.9); hero.show_face("fierce", 0.9))
	_wait_for(0.95)
	_at(0.0, func() -> void: hero.show_face("happy", 0.7); _dots(hero.position + Vector2(0.0, -150.0), 0.8))
	_wait_for(0.5)
	_at(0.0, func() -> void: _hop(0.3); _move(_pick(zs, 0), 0.4))
	_wait_for(0.45)
	_at(0.0, func() -> void: _move(_pick(zs, 1), 0.4); _ring(_hand(), 90.0, 0.5))
	_wait_for(0.5)

## CAT CITRUS: กระโดดปักหอก ฝุ่นนุ่ม ตั้งท่า แทงชุดของสาย
func _spear_plant(zs: Array) -> void:
	_at(0.0, func() -> void: _hop(0.45))
	_wait_for(0.4)
	_at(0.0, func() -> void: _move(_pick(zs, 0), 0.5); hero.show_face("fierce", 0.9))
	_wait_for(0.25)
	_at(0.0, func() -> void: _puff(hero.position, 6); _ring(hero.position, 110.0, 0.6))
	_wait_for(0.45)
	for i in range(1, mini(zs.size(), 4)):
		var id: String = zs[i]
		_at(0.0, func() -> void: _move(id, 0.4))
		_wait_for(0.4)
	_at(0.0, func() -> void: hero.show_face("happy", 0.6))
	_wait_for(0.3)

## CAT ASH แต่ละสายมวย
func _fist_line(line: String, zs: Array, xs: Array) -> void:
	match line:
		"HEAVYWEIGHT":
			# ซูโม่ กระทืบเท้าสองที ฝุ่นนุ่ม แล้วผลักฝ่ามือ
			for i in 2:
				_at(0.0, func() -> void: _hop(0.32); hero.show_face("fierce", 0.5))
				_wait_for(0.42)
				_at(0.0, func() -> void: _puff(hero.position, 7); _ring(hero.position, 120.0, 0.55))
				_wait_for(0.3)
			_at(0.0, func() -> void: _move(_pick(xs, 0), 0.55))
			_wait_for(0.6)
			_at(0.0, func() -> void: _move(_pick(zs, 0), 0.4))
			_wait_for(0.45)
		"ZEPHYR":
			# กังฟู ท่ากระเรียน ลอยตัวเตะ ลมวนนุ่ม
			_at(0.0, func() -> void: _hop(0.65); _move(_pick(zs, 0), 0.7); hero.show_face("squint", 0.8))
			_wait_for(0.4)
			_at(0.0, func() -> void: _ring(hero.position + Vector2(0.0, -90.0), 100.0, 0.7))
			_wait_for(0.45)
			for i in range(1, mini(zs.size(), 3)):
				var id: String = zs[i]
				_at(0.0, func() -> void: _move(id, 0.4))
				_wait_for(0.4)
			_at(0.0, func() -> void: _move(_pick(xs, 0), 0.5))
			_wait_for(0.55)
		"WAR MUAY":
			# มวยไทย ไหว้ครู ย่อตัวหลับตา แล้วตั้งการ์ด ตีเข่า
			_at(0.0, func() -> void: hero.show_face("shut", 1.0); _dip(0.9))
			_wait_for(1.0)
			_at(0.0, func() -> void: hero.facing = -_face0)
			_wait_for(0.3)
			_at(0.0, func() -> void: hero.facing = _face0; _dip(0.6))
			_wait_for(0.4)
			_at(0.0, func() -> void: hero.show_face("fierce", 0.8); _move(_pick(xs, 0), 0.5); _ring(_hand(), 100.0, 0.55))
			_wait_for(0.55)
			_at(0.0, func() -> void: _move(_pick(zs, 0), 0.4))
			_wait_for(0.45)
		"SYSTEMA GRAPPLER":
			# ซิสเทม่า สบายๆ โยกตัว หายใจ แล้วจับทุ่มเบาๆ
			for i in 2:
				_at(0.0, func() -> void: hero.facing = -_face0; hero.show_face("idle", 0.4))
				_wait_for(0.4)
				_at(0.0, func() -> void: hero.facing = _face0; _dip(0.4))
				_wait_for(0.4)
			_at(0.0, func() -> void: _move(_pick(zs, 0), 0.45); hero.show_face("happy", 0.6))
			_wait_for(0.5)
			_at(0.0, func() -> void: _move(_pick(xs, 0), 0.5); _ring(_hand(), 90.0, 0.5))
			_wait_for(0.55)
		_:
			# BASIC ชกลม ชนหมัด
			_at(0.0, func() -> void: _move(_pick(zs, 0), 0.3); hero.show_face("fierce", 0.7))
			_wait_for(0.32)
			_at(0.0, func() -> void: _move(_pick(zs, 1), 0.3))
			_wait_for(0.32)
			_at(0.0, func() -> void: _move(_pick(zs, 2), 0.35); _ring(_hand(), 80.0, 0.45))
			_wait_for(0.4)
			_at(0.0, func() -> void: _move(_pick(xs, 0), 0.5))
			_wait_for(0.55)
			_at(0.0, func() -> void: _hop(0.3); hero.show_face("happy", 0.6))
			_wait_for(0.5)

## AZURE/LAPIS: อีกตัวโผล่มาข้างๆ โพสด้วยกัน แล้วค่อยๆ จางไป
func _duo(zs: Array, xs: Array) -> void:
	_at(0.0, func() -> void: _spawn_partner())
	_wait_for(0.45)
	_at(0.0, func() -> void: _hop(0.4); _hop_partner(0.4); hero.show_face("happy", 0.7))
	_wait_for(0.6)
	_at(0.0, func() -> void: _move(_pick(zs, 0), 0.45); _partner_move(_pick(zs, 1), 0.45))
	_wait_for(0.5)
	_at(0.0, func() -> void: _move(_pick(xs, 0), 0.55); _partner_move(_pick(xs, 0), 0.55); _ring(hero.position + Vector2(-_face0 * 45.0, -60.0), 120.0, 0.7))
	_wait_for(0.65)
	_at(0.0, func() -> void: _fade_partner())
	_wait_for(0.3)

func _pick(list: Array, i: int) -> String:
	if list.is_empty():
		return ""
	return str(list[mini(i, list.size() - 1)])

# ---------------------------------------------------------------- ท่าพื้นฐาน
## เล่นท่าจากตารางคอมโบ ใช้แค่ภาพ ไม่ทำดาเมจ
func _move(id: String, time: float, who: Hero = null) -> void:
	var h := hero if who == null else who
	if id == "" or not is_instance_valid(h):
		return
	var m: Dictionary = Hero.chibi_move_for(WalkPage.chosen_class, id).duplicate(true)
	if m.is_empty():
		return
	for k in STRIP:
		m.erase(k)
	h.plain_prev = {}
	h.plain_move = m
	h.plain_swing_kind = "combo"
	h.plain_combo_id += 1
	h.plain_swing = 0.001
	var tw := create_tween()
	tw.tween_property(h, "plain_swing", 1.0, maxf(time, 0.25))
	tw.tween_callback(func() -> void:
		if is_instance_valid(h):
			h.plain_swing = 0.0)
	if who == null:
		if _tw != null and _tw.is_valid():
			_tw.kill()
		_tw = tw

func _hop(k: float) -> void:
	if hero.on_floor():
		hero.vel.y = Hero.JUMP_VELOCITY * k

func _walk(dir: float) -> void:
	hero.input_dir = dir * _face0

## ย่อตัว (ไหว้ / หายใจ)
func _dip(time: float) -> void:
	var tw := create_tween()
	tw.tween_property(hero, "plain_jump_wind", 0.8, time * 0.45)
	tw.tween_property(hero, "plain_jump_wind", 0.0, time * 0.55)

## หมุนตัวเร็วๆ (สลับทิศ n ครั้ง) จบหันทางเดิม
func _spin_flips(n: int, gap: float) -> void:
	var tw := create_tween()
	for i in n:
		tw.tween_callback(func() -> void: hero.facing = -hero.facing)
		tw.tween_interval(gap)
	tw.tween_callback(func() -> void: hero.facing = _face0)

func _hand() -> Vector2:
	return hero.position + Vector2(_face0 * 55.0, -95.0)

# ---------------------------------------------------------------- เพื่อนคู่ (AZURE/LAPIS)
func _spawn_partner() -> void:
	var p := Hero.new()
	p.plain = true
	p.plain_weapon = "azure"
	p.set_job("boy")
	p.facing = _face0
	p.half_width = hero.half_width
	p.pos = Vector2(clampf(hero.pos.x + _face0 * 1.3, -hero.half_width, hero.half_width), hero.pos.y)
	p.modulate = Color(1.0, 1.0, 1.0, 0.0)
	page.world.add_child(p)
	p.remove_from_group("hero")
	var other := SkillPanel.pair_partner(WalkPage.pair_form)
	p.use_model(SkillPanel.pair_style(other, WalkPage.chosen_class))
	_partner = p
	create_tween().tween_property(p, "modulate:a", 1.0, 0.35)

func _hop_partner(k: float) -> void:
	if is_instance_valid(_partner) and _partner.on_floor():
		_partner.vel.y = Hero.JUMP_VELOCITY * k

func _partner_move(id: String, time: float) -> void:
	if is_instance_valid(_partner):
		_partner.facing = _face0
		_move(id, time, _partner)

func _fade_partner() -> void:
	if not is_instance_valid(_partner):
		return
	var p := _partner
	var tw := create_tween()
	tw.tween_property(p, "modulate:a", 0.0, 0.4)
	tw.tween_callback(p.queue_free)
	_partner = null

# ---------------------------------------------------------------- เอฟเฟกต์นุ่มๆ (วงกลม จุด ฝุ่น)
func _ring(at: Vector2, r: float, life: float) -> void:
	_fx.append({"kind": "ring", "at": at, "t": 0.0, "life": life, "r": r * SkillScale.K})

func _dots(at: Vector2, life: float) -> void:
	_fx.append({"kind": "dots", "at": at, "t": 0.0, "life": life, "r": 70.0 * SkillScale.K})

func _puff(at: Vector2, n: int) -> void:
	for i in n:
		var a := PI + PI * (float(i) + 0.5) / float(n)
		_fx.append({"kind": "puff", "at": at + Vector2(0.0, -6.0), "t": 0.0, "life": 0.6, "r": 14.0, "v": Vector2(cos(a), sin(a) * 0.35) * 140.0})

func _draw() -> void:
	for f in _fx:
		var k: float = float(f["t"]) / float(f["life"])
		var a := (1.0 - k) * (1.0 - k)
		var at: Vector2 = f["at"]
		match str(f["kind"]):
			"ring":
				var rr: float = float(f["r"]) * (0.3 + 0.7 * (1.0 - (1.0 - k) * (1.0 - k)))
				draw_arc(at, rr, 0.0, TAU, 40, Color(_color, 0.55 * a), 5.0 * (1.0 - k) + 1.5, true)
				draw_circle(at, rr * 0.9, Color(_color, 0.08 * a))
			"dots":
				var r: float = f["r"]
				for i in 6:
					var ang := TAU * float(i) / 6.0 + _t * 3.0
					draw_circle(at + Vector2(cos(ang), sin(ang) * 0.5) * r, 6.0, Color(_color.lerp(CREAM, 0.3), 0.75 * a))
			"puff":
				var p: Vector2 = at + (f["v"] as Vector2) * float(f["t"])
				draw_circle(p, float(f["r"]) * (0.6 + k), Color(Color(0.86, 0.8, 0.74), 0.5 * a))

# ---------------------------------------------------------------- เวลา
func _process(delta: float) -> void:
	_freeze()
	hero.invuln_t = maxf(hero.invuln_t, 0.3)
	if _t < 0.0:
		_wait += delta
		var iris := get_node_or_null("/root/Iris")
		var iris_busy: bool = iris != null and iris.has_method("busy") and iris.busy()
		if _wait >= WAIT_MIN and not iris_busy:
			_t = 0.0
		return
	_t += delta
	while _next_ev < _events.size() and float(_events[_next_ev][0]) <= _t:
		(_events[_next_ev][1] as Callable).call()
		_next_ev += 1
	for f in _fx.duplicate():
		f["t"] = float(f["t"]) + delta
		if float(f["t"]) >= float(f["life"]):
			_fx.erase(f)
	queue_redraw()
	if _t >= duration:
		_end()

## ระยะเวลาที่เหลือ (วิ) รวมช่วงรอ
func elapsed() -> float:
	return maxf(_t, 0.0)

func _freeze() -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		var m := e as Monster
		if m != null and not m.frozen:
			m.frozen = true
			_frozen.append(m)

func _end() -> void:
	if done:
		return
	done = true
	set_process(false)
	for m in _frozen:
		if is_instance_valid(m):
			m.frozen = false
	_frozen.clear()
	if _tw != null and _tw.is_valid():
		_tw.kill()
	hero.plain_swing = 0.0
	hero.plain_move = {}
	hero.plain_jump_wind = 0.0
	hero.input_dir = 0.0
	hero.facing = _face0
	hero.invuln_t = 0.4
	if is_instance_valid(_partner):
		_partner.queue_free()
	if is_instance_valid(page):
		page.intro_lock = false
		# ป้าย START บอกว่าเริ่มเล่นได้แล้ว
		StartBanner.show_on(page)
	queue_free()

func _exit_tree() -> void:
	for m in _frozen:
		if is_instance_valid(m):
			m.frozen = false
	if not done and is_instance_valid(page):
		page.intro_lock = false


## ท่าแพ้: ตาวน แล้วล้มหงายนุ่มๆ เด้งเบาๆ หน้า X_X  ล็อกปุ่มไว้จนจบ (ฉากแพ้เดิมทำงานต่อ)
class DefeatPose:
	static func play(p: WalkPage) -> void:
		if p == null or p.hero == null:
			return
		var h := p.hero
		p.intro_lock = true
		h.input_dir = 0.0
		h.plain_swing = 0.0
		h.plain_move = {}
		h.show_face("dizzy", 0.7)
		var f := h.facing if h.facing != 0.0 else 1.0
		# โมเดลล้มหงายเองตอนเลือดหมด (ChibiModel._dead_pose) ตรงนี้เพิ่มตัวโยกมึนๆ กับเด้งเบาๆ ตอนถึงพื้น
		var model: Node2D = h.plain_model
		var tw := p.create_tween()
		if model != null:
			tw.tween_property(model, "rotation", f * 0.12, 0.12)
			tw.tween_property(model, "rotation", -f * 0.1, 0.14)
			tw.tween_property(model, "rotation", 0.0, 0.1)
			tw.tween_property(model, "position:y", -16.0, 0.12).set_ease(Tween.EASE_OUT)
			tw.tween_property(model, "position:y", 0.0, 0.16).set_ease(Tween.EASE_IN)
			tw.tween_property(model, "position:y", -6.0, 0.08)
			tw.tween_property(model, "position:y", 0.0, 0.1)
		tw.tween_callback(func() -> void:
			if is_instance_valid(h):
				h.show_face("ko", 5.0))
		# กระดอนเบาๆ ตอนล้ม
		var dust := DefeatDust.new()
		dust.position = h.position
		p.world.add_child(dust)


## ฝุ่นนุ่มตอนล้ม
class DefeatDust:
	extends Node2D
	var _t := 0.0
	func _ready() -> void:
		z_index = 4
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
		if _t > 1.8:
			queue_free()
	func _draw() -> void:
		var k := clampf((_t - 0.3) / 0.8, 0.0, 1.0)
		if _t < 0.3:
			return
		var a := (1.0 - k) * (1.0 - k)
		for i in 6:
			var s := -1.0 if i % 2 == 0 else 1.0
			var d := 20.0 + 60.0 * k * (1.0 + float(i / 2) * 0.4)
			draw_circle(Vector2(s * d, -8.0 - 10.0 * float(i / 2)), 12.0 * (0.6 + k), Color(0.86, 0.8, 0.74, 0.5 * a))
