class_name BowLineWind
## คอมโบสาย WINDSTARKER / GALE TEMPEST ของ CAT MATCHA
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย bww_ เท่านั้น
## NEXT: ต่อท่าตามคลาส {คลาส: {ท่าปัจจุบัน: {ปุ่ม: ท่าถัดไป}}} ปุ่มเป็น "z" "x" "fwd_z" "down_x" เป็นต้น (คลาสลูกได้ท่าของคลาสแม่ด้วย)
## START: ท่าแรกตามคลาส {คลาส: {"สถานะ_ปุ่ม": ท่า}} สถานะ ground dash air airdash เช่น "dash_z"
## WINDSTARKER: zzz>zz>z เตะ 3 ที แล้วพุ่งเอาเข่ากระแทก เตะต่อ เตะเสยลอย
##              >>zzz สไลด์ แล้วสไลด์อีกรอบ แล้วหมุนเตะเสย
##              ^^zz พุ่งกระทืบลงพื้น แล้วเอามือยันพื้นยกเท้าหมุนเตะรอบตัวกว้างๆ
## GALE TEMPEST: xxzzz ยิง 2 ดอก พุ่งเร็วเอาหัวชน เตะกลับหลัง เตะกระเด็น
##               >>zx สไลด์เตะ อ้อมไปด้านหลังแล้วหันปล่อยลมเขียวสั้นๆ ไปด้านหน้า
##               >>^xzz พุ่งลงเฉียงเอาเข่ากระแทกพื้น เตะงัดมอนลอยมีลมพัดช่วย แล้วกระโดดเตะตาม

const NEXT := {
	"WINDSTARKER": {
		"bw_z3": {"fwd_z": "bww_knee"},
		"bww_knee": {"z": "bww_kickup", "fwd_z": "bww_kickup"},
		"bw_dz1": {"z": "bww_slide2"},
		"bww_slide2": {"z": "bw_dz2"},
		"bw_az": {"z": "bww_break"},
	},
	"GALE TEMPEST": {
		"bw_x2": {"z": "bww_ram"},
		"bww_ram": {"z": "bww_backkick"},
		"bww_backkick": {"z": "bww_flykick"},
		"bw_dz1": {"x": "bww_around"},
		"bww_air_shot": {"z": "bww_kneedive"},
		"bww_kneedive": {"z": "bww_pry"},
	},
}
const START := {
	"GALE TEMPEST": {"airdash_x": "bww_air_shot"},
}

const GUST_REACH := 330.0        # ลมเขียวไปไกลเท่านี้ จุดภาพ
const GUST_DMG := 18.0

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

## เพิ่มท่าลงตาราง m  base มี "kick" "shoot" "shoot45" "shoot_down" ของ BowCombo
static func add_moves(m: Dictionary, base: Dictionary) -> void:
	var kick: Dictionary = base["kick"]
	# GALE >>^x ยิงธนูเฉียงลงก่อน
	m["bww_air_shot"] = _mv(base["shoot45"], {"name": "ยิงธนูเฉียง", "next": 0.62})
	# --- WINDSTARKER ---
	# >z หลังเตะ 3 ที พุ่งไปข้างหน้าเอาเข่ากระแทก
	m["bww_knee"] = _mv(kick, {"name": "พุ่งเข่ากระแทก", "dmg": 15.0, "time": 0.42, "wind": 0.12, "strike": 0.6, "next": 0.66, "lunge": 1.7, "lean": 32.0,
		"fx_start": "bww_ram", "fx": "bw_kick_front", "shake": 0.18, "hit": {"kb": 0.8, "stun": 0.7}})
	m["bww_kick2"] = _mv(kick, {"name": "หมุนเตะต่อ", "dmg": 12.0, "time": 0.36, "wind": 0.2, "strike": 0.5, "next": 0.62, "lunge": 0.3, "spin": 360.0, "lean": -15.0,
		"fx": "bw_kick_spin", "hit": {"kb": 0.6, "stun": 0.6}})
	m["bww_kickup"] = _mv(kick, {"name": "เตะเสยลอย", "dmg": 17.0, "time": 0.45, "wind": 0.15, "strike": 0.55, "next": 0.85, "lunge": 0.25, "lean": -28.0, "roll_once": true,
		"shake": 0.18, "fx": "bww_lift_kick", "hit": {"type": "launch", "vy": 12.0}})
	# >>zzz สไลด์รอบสอง
	m["bww_slide2"] = _mv(m["bw_dz1"], {"name": "สไลด์อีกรอบ", "dmg": 12.0})
	# ^^zz ลงพื้นแล้วเอามือยันพื้นยกเท้าหมุนเตะรอบตัว โดนหลายทีรอบตัวกว้างๆ
	var brk: Dictionary = _mv(kick, {"name": "ยันพื้นหมุนเตะรอบตัว", "dmg": 7.0, "time": 0.85, "wind": 0.12, "strike": 0.86, "next": 0.95, "lunge": 0.0,
		"lean": 0.0, "invert": true, "spin_rate": 1300.0, "multi": 0.12, "multi_half": 240.0, "multi_ahead": 0.0, "wide": true, "wide_half": 240.0,
		"fx_start": "bww_ring", "fx": "bw_kick_spin", "shake": 0.2, "hit": {"kb": 0.5, "stun": 0.5}})
	brk.erase("front_hit")
	m["bww_break"] = brk
	# --- GALE TEMPEST ---
	# xxz พุ่งไปข้างหน้าเร็วๆ เอาหัวชน
	m["bww_ram"] = _mv(kick, {"name": "พุ่งเอาหัวชน", "dmg": 10.5, "time": 0.38, "wind": 0.08, "strike": 0.62, "next": 0.7, "lunge": 3.0, "lean": 48.0,
		"fx_start": "bww_ram", "shake": 0.2, "stop": 0.1, "hit": {"kb": 0.6, "stun": 0.8}})
	m["bww_backkick"] = _mv(kick, {"name": "หมุนเตะกลับหลัง", "dmg": 9.5, "time": 0.42, "wind": 0.2, "strike": 0.55, "next": 0.66, "lunge": 0.2, "spin": 360.0, "lean": -20.0, "twist": 30.0,
		"fx": "bw_kick_spin", "hit": {"kb": 0.6, "stun": 0.7}})
	m["bww_flykick"] = _mv(kick, {"name": "เตะกระเด็น", "dmg": 14.5, "time": 0.48, "wind": 0.15, "strike": 0.55, "next": 0.9, "lunge": 0.5, "lean": -22.0,
		"shake": 0.25, "fx": "bww_gust_kick", "hit": {"type": "knockdown", "fly": 9.0}})
	# >>zx สไลด์แล้วอ้อมไปด้านหลัง หันกลับปล่อยลมเขียว
	m["bww_around"] = _mv(Hero.MK_MOVES["mk_spin_through"], {"name": "อ้อมไปด้านหลัง", "auto": "bww_gust", "dmg": 0.0, "no_hit": true})
	var gust: Dictionary = _mv(Hero.MK_MOVES["mk_turn_shot"], {"name": "ปล่อยลมเขียว", "fx": "bww_gust", "time": 0.42, "next": 0.85})
	gust.erase("hand_cast")
	m["bww_gust"] = gust
	# >>^x พุ่งลงเฉียงเอาเข่ากระแทกพื้น
	# ท่าพุ่งลงยาวพอให้ค้างท่ารอถึงพื้นก่อนกระแทก (จังหวะต่อเฟรมไม่ข้ามช่วงค้าง) จะได้กระแทกตอนเข่าถึงพื้นจริง
	m["bww_kneedive"] = _mv(kick, {"name": "พุ่งเข่าลงเฉียง", "dmg": 17.0, "dive": true, "dive_forward": 5.0, "time": 0.9, "wind": 0.1, "strike": 0.6, "next": 0.78,
		"lunge": 0.1, "lean": 35.0, "shake": 0.25, "fx": "bww_knee", "hit": {"kb": 0.4, "stun": 0.9}})
	# z เตะงัดมอนลอย มีลมพัดช่วย
	m["bww_pry"] = _mv(kick, {"name": "เตะงัดลอย", "dmg": 16.0, "time": 0.45, "wind": 0.15, "strike": 0.55, "next": 0.72, "lunge": 0.2, "lean": -30.0,
		"shake": 0.18, "fx": "bww_lift_kick", "hit": {"type": "launch", "vy": 14.0}})
	# z กระโดดตามไปเตะกลางอากาศ
	m["bww_pry2"] = _mv(kick, {"name": "กระโดดเตะตาม", "dmg": 18.0, "time": 0.5, "wind": 0.15, "strike": 0.55, "next": 0.9, "lunge": 0.4, "leap": 7.0, "roll_once": true,
		"shake": 0.22, "fx": "bw_kick_flip", "hit": {"type": "knockdown", "fly": 6.0}})

static func _fx(caster: MageCaster, kind: String, life: float, follow := false) -> BowWindFx:
	var n := BowWindFx.new()
	n.kind = kind
	n.dir = caster.hero.facing
	n.life = life
	n.reach = GUST_REACH
	if follow:
		n.follow = caster.hero
	caster._add(n, caster.hero.position)
	return n

static func _trail(caster: MageCaster, kind: String) -> void:
	var t := KickTrail.new()
	t.kind = kind
	t.dir = caster.hero.facing
	caster._add(t, caster.hero.position)

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(caster: MageCaster, fx: String) -> bool:
	if not fx.begins_with("bww_"):
		return false
	var f := caster.hero.facing
	match fx:
		"bww_ram":
			_fx(caster, "ram", 0.4, true)
		"bww_ring":
			_fx(caster, "ring", 0.85, true)
		"bww_lift_kick":
			_trail(caster, "up")
			_fx(caster, "lift", 0.6)
		"bww_gust_kick":
			_trail(caster, "front")
			_fx(caster, "gust", 0.35).reach = GUST_REACH * 0.6
		"bww_knee":
			_trail(caster, "down")
			_fx(caster, "knee", 0.5)
		"bww_gust":
			# ลมเขียวสั้นๆ ไปด้านหน้า โดนมอนในช่วงลม
			_fx(caster, "gust", 0.45)
			caster._hit_near(caster.hero.position.x + f * GUST_REACH * 0.5, GUST_REACH * 0.5 + 40.0, GUST_DMG, {"kb": 2.2, "stun": 0.6})
	return true
