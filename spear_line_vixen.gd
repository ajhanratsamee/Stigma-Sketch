class_name SpearLineVixen
## คอมโบสาย PETIT VIXEN / PHANTOM VULPINE ของ CAT CITRUS
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย spv_ เท่านั้น
## NEXT: ต่อท่าตามคลาส {คลาส: {ท่าปัจจุบัน: {ปุ่ม: ท่าถัดไป}}} ปุ่มเป็น "z" "x" "fwd_z" "down_x" เป็นต้น (คลาสลูกได้ท่าของคลาสแม่ด้วย)
## START: ท่าแรกตามคลาส {คลาส: {"สถานะ_ปุ่ม": ท่า}} สถานะ ground dash air airdash เช่น "dash_z"
## PETIT VIXEN: >>^zxx ฟาดเสย วาปกระทืบพื้นรอบตัว ยกขามีรอยข่วนจิ้งจอกเก้าหางข่วนขึ้น 4 รอย
##              xx ลงx <x> แทงแล้วดึง ซ่อนหอกข่วนมือไปมาพร้อมรอยข่วนจิ้งจอก สูงสุด 10 ที ทีสุดท้ายกระเด็น
##              zzzzx อ้อมไปด้านหลังแล้วเรียกเล็บมาข่วน
## PHANTOM VULPINE: >>^xz ยิงปิ่นปักผมเฉียงลง 3 อัน  >>^xxz วาปกระทืบพื้นวงกว้าง แล้วเขวี้ยงปิ่น 3 อันไปหน้า
##                  >>zzx แทงซ้ำ แล้วเรียกเล็บข่วนขึ้นมอนลอย

const SWIPES := 10

const NEXT := {
	"PETIT VIXEN": {
		"sp_adz1": {"x": "spv_stomp"}, "spv_stomp": {"x": "spv_claw4"},
		"sp_x2": {"down_x": "spv_stabpull"}, "spv_stabpull": {"x": "spv_sw1"},
		"spv_sw1": {"x": "spv_sw2"}, "spv_sw2": {"x": "spv_sw3"}, "spv_sw3": {"x": "spv_sw4"}, "spv_sw4": {"x": "spv_sw5"}, "spv_sw5": {"x": "spv_sw6"},
		"spv_sw6": {"x": "spv_sw7"}, "spv_sw7": {"x": "spv_sw8"}, "spv_sw8": {"x": "spv_sw9"}, "spv_sw9": {"x": "spv_sw10"},
		# zzzzx: z ที่ 5 ของสายจิ้งจอกกระเด็นไม่ไกล อ้อมหลังไปข่วนทัน
		# zzzx อ้อมไปด้านหลังแล้วเรียกเล็บข่วน
		"sp_z3": {"x": "spv_behind"},
	},
	"PHANTOM VULPINE": {
		"sp_adx": {"z": "spv_pins_diag", "x": "spv_pv_stomp"}, "sp_adx_turn": {"z": "spv_pins_diag", "x": "spv_pv_stomp"},
		"spv_pv_stomp": {"z": "spv_pv_pins"},
		"sp_dz": {"z": "spv_pv_stab"}, "spv_pv_stab": {"x": "spv_pv_claw"},
		# xx ลงx ไม่ต้องรัว ลงx แทงดึงแล้วข่วนจิ้งจอกต่อเองจนครบ 10 ทีกระเด็น
		"sp_x2": {"down_x": "spv_pa_stabpull"},
	},
}
const START := {}

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	for k in over:
		if over[k] == null:
			d.erase(k)
	return d

## เพิ่มท่าลงตาราง m
static func add_moves(m: Dictionary) -> void:
	var stab: Dictionary = m["sp_z1"]
	var sweep: Dictionary = m["sp_x1"]
	var chop: Dictionary = m["sp_dx"]
	var lift: Dictionary = m["sp_ax"]
	var kick: Dictionary = Hero.CAT_SKILLS["cat_sk_kick"]
	# >>^z x วาปลงพื้นกระทืบแรง โดนรอบตัว
	m["spv_stomp"] = _mv(chop, {"name": "วาปกระทืบพื้น", "hover": null, "lunge": 0.15, "time": 0.5, "wind": 0.25, "strike": 0.45, "next": 0.72, "dmg": 26.0,
		"wide": true, "wide_half": 280.0, "shake": 0.3, "stop": 0.1, "fx_start": "spv_warp", "fx": "spv_stomp", "hit": {"kb": 0.5, "stun": 0.9}})
	# x ยกขาขึ้น รอยข่วนจิ้งจอกเก้าหางโผล่ข่วนขึ้น 4 รอย
	m["spv_claw4"] = _mv(kick, {"name": "ยกขาเรียกรอยข่วนจิ้งจอก", "dmg": 0.0, "no_hit": true, "time": 0.55, "wind": 0.2, "strike": 0.4, "next": 0.85, "lunge": 0.0,
		"lean": -30.0, "shake": 0.12, "fx": "spv_claw4"})
	# xx ลงx แทงแล้วดึงกลับ 2 ฮิต
	m["spv_stabpull"] = _mv(stab, {"name": "แทงแล้วดึงกลับ", "time": 0.5, "wind": 0.25, "strike": 0.7, "next": 0.76, "dmg": 8.0, "lunge": 0.5,
		"multi": 0.13, "multi_ahead": 150.0, "multi_half": 120.0, "fx_start": "sp_thrust", "fx": "", "hit": {"kb": 0.2, "stun": 0.6}})
	# <x> ซ่อนหอก ข่วนมือไปมา มีรอยข่วนจิ้งจอกเก้าหาง สูงสุด 10 ที ทีสุดท้ายกระเด็น
	for i in SWIPES:
		var last := i == SWIPES - 1
		var hy := 0.12 if i % 2 == 0 else -0.08
		m["spv_sw%d" % (i + 1)] = _mv(sweep, {"name": "ข่วนจิ้งจอก %d" % (i + 1) if not last else "ข่วนจิ้งจอกกระเด็น", "hide_sword": true,
			"wind_off": Vector3(0.0, hy + 0.2, 0.1), "end_off": Vector3(0.75, hy - 0.2, 0.1), "twist": 25.0 if i % 2 == 0 else -25.0,
			"time": 0.4 if last else 0.18, "wind": 0.25, "strike": 0.5, "next": 0.8 if last else 0.5, "lunge": 0.3 if last else 0.05,
			"dmg": 16.0 if last else 4.8, "front_hit": true, "shake": 0.25 if last else 0.05, "stop": 0.08 if last else 0.02, "spin": 360.0 if last else 0.0,
			"fx": "spv_swipe_big" if last else ("spv_swipe_a" if i % 2 == 0 else "spv_swipe_b"),
			"hit": {"type": "knockdown", "fly": 9.0} if last else {"kb": 0.05, "stun": 0.5}})
	# PHANTOM VULPINE xx ลงx ทั้งชุดต่อกันเอง
	m["spv_pa_stabpull"] = _mv(m["spv_stabpull"], {"auto": "spv_pa_sw1"})
	for i in SWIPES:
		var nxt := {"auto": "spv_pa_sw%d" % (i + 2)} if i < SWIPES - 1 else {}
		m["spv_pa_sw%d" % (i + 1)] = _mv(m["spv_sw%d" % (i + 1)], nxt)
	# zzzzx อ้อมไปด้านหลัง แล้วหันกลับเรียกเล็บข่วน
	m["spv_z5"] = _mv(m["sp_z5"], {"hit": {"type": "knockdown", "fly": 3.5}, "next": 0.95})
	m["spv_behind"] = _mv(sweep, {"name": "อ้อมไปด้านหลัง", "spin": 360.0, "ghost": true, "lunge": 2.3, "time": 0.38, "wind": 0.15, "strike": 0.6, "next": 0.8,
		"no_hit": true, "dmg": 0.0, "fx_start": "spv_poof", "fx": "", "auto": "spv_behind_claw"})
	m["spv_behind_claw"] = _mv(kick, {"name": "เรียกเล็บข่วน", "turn_around": true, "no_hit": true, "dmg": 0.0, "time": 0.45, "wind": 0.2, "strike": 0.4, "next": 0.82,
		"lunge": 0.0, "lean": 10.0, "fx": "spv_claws"})
	# PHANTOM VULPINE >>^x z ยิงปิ่นปักผมเฉียงลง 3 อัน
	m["spv_pins_diag"] = _mv(sweep, {"name": "ยิงปิ่นปักผมเฉียงลง", "hover": true, "hide_sword": true, "no_hit": true, "dmg": 0.0, "time": 0.42, "wind": 0.3, "strike": 0.45,
		"next": 0.8, "lunge": 0.0, "fx": "spv_pins_diag"})
	# >>^xx วาปลงกระทืบพื้นวงกว้าง
	m["spv_pv_stomp"] = _mv(chop, {"name": "วาปกระทืบพื้นวงกว้าง", "hover": null, "lunge": 0.1, "time": 0.55, "wind": 0.25, "strike": 0.45, "next": 0.75, "dmg": 22.0,
		"wide": true, "wide_half": 440.0, "shake": 0.4, "stop": 0.12, "fx_start": "spv_warp", "fx": "spv_stomp_big", "hit": {"kb": 0.8, "stun": 1.0}})
	# z เขวี้ยงปิ่นปักผม 3 อันไปหน้า
	m["spv_pv_pins"] = _mv(sweep, {"name": "เขวี้ยงปิ่นปักผม 3 อัน", "hide_sword": true, "no_hit": true, "dmg": 0.0, "time": 0.4, "wind": 0.3, "strike": 0.45, "next": 0.8,
		"lunge": 0.1, "fx": "spv_pins3"})
	# >>z z แทงหอกซ้ำ
	m["spv_pv_stab"] = _mv(stab, {"name": "แทงหอกซ้ำ", "dmg": 14.0, "lunge": 0.6, "next": 0.66})
	# x เรียกเล็บข่วนขึ้น มอนลอย
	m["spv_pv_claw"] = _mv(lift, {"name": "เรียกเล็บข่วนขึ้นมอนลอย", "hover": null, "no_hit": true, "dmg": 0.0, "time": 0.48, "next": 0.82, "lunge": 0.1, "fx": "spv_claw_launch"})

## รอยข่วนหนึ่งชุด โดนมอนตรงนั้นด้วย
static func _claw(page: WalkPage, at: Vector2, ang: float, size: float, n: int, dmg: float, extra: Dictionary, half := 110.0) -> void:
	if not is_instance_valid(page):
		return
	var node := SpearVixenFx.new()
	node.kind = "claw"
	node.dir = page.hero.facing
	node.angle = ang
	node.size = size
	node.lines = n
	node.life = 0.45
	node.position = at
	page.world.add_child(node)
	if dmg > 0.0:
		page._hit_area(at.x, half, dmg, page.hero.facing, null, extra, Vector2(at.y - size * 0.7, at.y + size * 0.7))

static func _later(page: WalkPage, t: float, f: Callable) -> void:
	if t <= 0.0:
		f.call()
		return
	page.get_tree().create_timer(t, false).timeout.connect(func() -> void:
		if is_instance_valid(page):
			f.call())

static func _fx(page: WalkPage, kind: String, at: Vector2, life: float, radius := 260.0) -> void:
	var node := SpearVixenFx.new()
	node.kind = kind
	node.dir = page.hero.facing
	node.life = life
	node.radius = radius
	node.position = at
	page.world.add_child(node)

static func _pin(page: WalkPage, at: Vector2, vel: Vector2, dmg: float, extra: Dictionary) -> void:
	var node := SpearVixenFx.new()
	node.kind = "pin"
	node.page = page
	node.dir = signf(vel.x) if vel.x != 0.0 else page.hero.facing
	node.vel = vel
	node.dmg = dmg
	node.extra = extra
	node.life = 1.1
	node.position = at
	page.world.add_child(node)

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(page: WalkPage, fx: String) -> bool:
	if not fx.begins_with("spv_"):
		return false
	var f := page.hero.facing
	var hp := page.hero.position
	match fx:
		"spv_warp":
			# วาปลงพื้นทันที ทิ้งควันไว้ที่เดิม
			_fx(page, "poof", hp + Vector2(0.0, 60.0), 0.4)
			page.hero.pos.y = 0.0
			page.hero.vel = Vector2.ZERO
			_fx(page, "poof", Vector2(hp.x, 0.0) + Vector2(0.0, 40.0), 0.4)
		"spv_poof":
			_fx(page, "poof", hp + Vector2(0.0, 40.0), 0.4)
		"spv_stomp":
			_fx(page, "ring", Vector2(hp.x, 0.0), 0.5, 300.0)
		"spv_stomp_big":
			_fx(page, "ring", Vector2(hp.x, 0.0), 0.6, 470.0)
			_fx(page, "ring", Vector2(hp.x, 0.0), 0.8, 330.0)
		"spv_claw4":
			# รอยข่วนจิ้งจอก 4 รอยโผล่จากพื้นข่วนขึ้น ไล่ไปข้างหน้า
			for i in 4:
				var at := Vector2(hp.x + f * (110.0 + float(i) * 95.0), -90.0)
				var last := i == 3
				_later(page, float(i) * 0.08, func() -> void:
					_claw(page, at, -PI * 0.5 + 0.25, 200.0, 4, 48.0 if last else 36.0, {"type": "launch", "vy": 6.0} if last else {"kb": 0.1, "stun": 0.6}, 70.0))
		"spv_swipe_a", "spv_swipe_b":
			var ang := 0.6 if fx == "spv_swipe_a" else -0.6
			_claw(page, hp + Vector2(f * 130.0, -70.0), ang, 150.0, 3, 0.0, {})
		"spv_swipe_big":
			_claw(page, hp + Vector2(f * 150.0, -80.0), -0.5, 240.0, 4, 0.0, {})
		"spv_claws":
			# หันกลับแล้วเล็บข่วนสองชุดไขว้กัน
			var at := hp + Vector2(f * 140.0, -80.0)
			_claw(page, at, 0.7, 210.0, 4, 14.0, {"kb": 0.6, "stun": 0.8}, 120.0)
			_later(page, 0.12, func() -> void:
				_claw(page, at, -0.7, 210.0, 4, 14.0, {"kb": 1.2, "stun": 0.8}, 120.0))
		"spv_claw_launch":
			# เล็บข่วนขึ้นจากพื้น 3 ชุดซ้อน มอนลอย
			for i in 3:
				var at := Vector2(hp.x + f * (130.0 + float(i) * 40.0), -100.0)
				_later(page, float(i) * 0.07, func() -> void:
					_claw(page, at, -PI * 0.5 + 0.3, 230.0, 4, 10.0, {"type": "launch", "vy": 11.0}, 120.0))
		"spv_pins_diag":
			# ปิ่นปักผม 3 อัน พุ่งเฉียงลงด้านหน้า ไล่กันทีละอัน
			for i in 3:
				var at := hp + Vector2(f * 40.0, -90.0)
				var v := Vector2(f, 0.75 + float(i) * 0.12).normalized() * 1500.0
				_later(page, float(i) * 0.07, func() -> void:
					_pin(page, at, v, 12.0, {"kb": 0.6, "stun": 0.6}))
		"spv_pins3":
			# เขวี้ยงปิ่น 3 อันไปหน้า กระจายสูงต่ำนิดหน่อย
			for i in 3:
				var at := hp + Vector2(f * 40.0, -70.0 - float(i - 1) * 30.0)
				var v := Vector2(f, float(i - 1) * -0.06).normalized() * 1600.0
				_later(page, float(i) * 0.05, func() -> void:
					_pin(page, at, v, 14.0, {"kb": 1.0, "stun": 0.6}))
	return true
