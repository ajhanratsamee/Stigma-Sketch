class_name BowLineMana
## คอมโบสาย MANASTARKER / ESSENCE WEAVER ของ CAT MATCHA  พลังสามสี ฟ้า แดง เหลือง
## ชื่อท่าขึ้นต้น bwm_  ชื่อเอฟเฟกต์ขึ้นต้น bw_mana_ (หน้าฝึกส่งเอฟเฟกต์ที่ขึ้นต้น bw_ ให้ MageCaster)
## MANASTARKER:  zxxx เตะ แล้วยิงพลังฟ้าลอยช้า ตามด้วยแดง และเหลืองทำกระเด็น
##               xzx  ยิงศร z ปล่อยสามสีรวมเป็นสายพุ่งไปหน้า ฮิตถี่เบาแต่เยอะ  x ปล่อยลูกสามสีลอยช้า โดนแล้วระเบิดทำลอย
##               >>zx สไลด์เตะ แล้วปล่อยพลังสามสีเป็นสามแฉกไปหน้า
## ESSENCE WEAVER (ได้ท่าของ MANASTARKER ด้วย):
##               >>^xz ยิงเฉียง แล้วพุ่งลงด้วยพลังสามสีกระทบพื้น
##               >>^zx เตะกลางอากาศ แล้วยิงศรเฉียงลง 3 ดอก ดอกละสี
##               zzx  เตะสองที แล้วโปรยพลังสามสีผสมลอยไปข้างหน้าช้าๆ หลายฮิต

const NEXT := {
	"MANASTARKER": {
		"bw_z1": {"x": "bwm_blue"}, "bwm_blue": {"x": "bwm_red"}, "bwm_red": {"x": "bwm_yellow"},
		"bw_x1": {"z": "bwm_stream"}, "bwm_stream": {"x": "bwm_bomb"},
		"bw_dz1": {"x": "bwm_fan"},
	},
	"ESSENCE WEAVER": {
		"bw_adx1": {"z": "bwm_dive"},
		"bwm_air_kick": {"x": "bwm_tri"},
		"bw_z2": {"x": "bwm_scatter"},
	},
}
const START := {
	# >>^z ของ ESSENCE WEAVER เตะค้างกลางอากาศ เพื่อยิงศรสามสีเฉียงลงต่อได้
	"ESSENCE WEAVER": {"airdash_z": "bwm_air_kick"},
}

const SHOT := 14.0

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

static func add_moves(m: Dictionary, base: Dictionary) -> void:
	var kick: Dictionary = base["kick"]
	var shoot: Dictionary = base["shoot"]
	var shoot45: Dictionary = base["shoot45"]
	# ปล่อยพลังด้วยมือ ยื่นคันธนูไปข้างหน้าแล้วดันพลังออก
	var push := _mv(shoot, {"time": 0.38, "next": 0.66})
	m["bwm_blue"] = _mv(push, {"name": "พลังฟ้าลอยช้า", "fx": "bw_mana_blue"})
	m["bwm_red"] = _mv(push, {"name": "พลังแดงตาม", "fx": "bw_mana_red", "twist": -35.0})
	m["bwm_yellow"] = _mv(push, {"name": "พลังเหลืองกระเด็น", "fx": "bw_mana_yellow", "time": 0.44, "next": 0.9, "shake": 0.15, "lean": -12.0})
	m["bwm_stream"] = _mv(push, {"name": "สายพลังสามสี", "fx": "bw_mana_stream", "time": 0.55, "strike": 0.35, "next": 0.82, "shake": 0.1})
	m["bwm_bomb"] = _mv(push, {"name": "ลูกสามสีระเบิด", "fx": "bw_mana_bomb", "time": 0.46, "next": 0.9, "shake": 0.12})
	m["bwm_fan"] = _mv(push, {"name": "พลังสามแฉก", "fx": "bw_mana_fan", "time": 0.42, "next": 0.86, "shake": 0.12})
	# ESSENCE WEAVER
	m["bwm_dive"] = _mv(kick, {"name": "พุ่งลงด้วยพลังสามสี", "dmg": 16.0, "dive": true, "dive_forward": 2.0, "lunge": 0.1, "lean": 20.0, "roll_once": true,
		"front_hit": true, "shake": 0.3, "next": 0.85, "fx_start": "bw_mana_aura", "fx": "bw_mana_dive", "hit": {"kb": 0.6, "stun": 0.7}})
	m["bwm_air_kick"] = _mv(kick, {"name": "ตีลังกาเตะกลางอากาศ", "dmg": 13.0, "hover": true, "lunge": 0.4, "lean": 20.0, "roll_once": true, "next": 0.7,
		"fx": "bw_kick_flip", "hit": {"kb": 1.2, "stun": 0.6}})
	m["bwm_tri"] = _mv(shoot45, {"name": "ศรสามสีเฉียงลง", "fx": "bw_mana_tri", "next": 0.85})
	m["bwm_scatter"] = _mv(push, {"name": "โปรยพลังสามสี", "fx": "bw_mana_scatter", "time": 0.5, "next": 0.9, "twist": -40.0})

static func _orb(c: MageCaster, at: Vector2, vel: Vector2, cols: Array, r: float, dmg: float, extra: Dictionary, mode := "once") -> BowManaFx:
	var o := BowManaFx.new()
	o.caster = c
	o.vel = vel
	o.colors = cols
	o.radius = r
	o.dmg = dmg
	o.extra = extra
	o.mode = mode
	c._add(o, at)
	return o

static func cast(c: MageCaster, fx: String) -> bool:
	if not fx.begins_with("bw_mana_"):
		return false
	var f := c.hero.facing
	var hand := c._hand()
	match fx:
		"bw_mana_blue":
			var o := _orb(c, hand, Vector2(f * 520.0, 0.0), [BowManaFx.BLUE], 36.0, SHOT * 0.7, {"kb": 0.6, "stun": 0.6}, "pierce")
			o.life = 1.6
		"bw_mana_red":
			var o := _orb(c, hand, Vector2(f * 700.0, 0.0), [BowManaFx.RED], 36.0, SHOT * 0.74, {"kb": 0.8, "stun": 0.6}, "pierce")
			o.life = 1.3
		"bw_mana_yellow":
			var o := _orb(c, hand, Vector2(f * 900.0, 0.0), [BowManaFx.YELLOW], 44.0, SHOT * 1.15, {"type": "knockdown", "fly": 8.0})
			o.life = 1.1
		"bw_mana_stream":
			# สามสีรวมเป็นสายพุ่งไปหน้า เม็ดเล็กเยอะ โดนถี่แต่เบา
			for i in 18:
				var col: Color = BowManaFx.TRI[i % 3]
				var off := Vector2(0.0, sin(float(i) * 1.7) * 16.0)
				c.get_tree().create_timer(float(i) * 0.03).timeout.connect(func() -> void:
					if not is_instance_valid(c) or not is_instance_valid(c.hero):
						return
					var s := _orb(c, c._hand() + off, Vector2(c.hero.facing * 1350.0, 0.0), [col], 19.0, 1.1, {"kb": 0.15, "stun": 0.3})
					s.life = 0.55)
		"bw_mana_bomb":
			var o := _orb(c, hand, Vector2(f * 380.0, 0.0), BowManaFx.TRI, 46.0, 0.0, {}, "bomb")
			o.life = 2.0
			o.bomb_dmg = 10.0
			o.bomb_r = 180.0
		"bw_mana_fan":
			for i in 3:
				var ang := deg_to_rad(-16.0 + 16.0 * float(i))
				var o := _orb(c, hand, Vector2(f * cos(ang), sin(ang)) * 900.0, [BowManaFx.TRI[i]], 32.0, SHOT * 0.8, {"kb": 1.2, "stun": 0.6}, "pierce")
				o.life = 0.75
		"bw_mana_aura":
			# พลังสามสีห่อตัวตอนพุ่งลง
			var o := _orb(c, c.hero.position, Vector2.ZERO, BowManaFx.TRI, 62.0, 0.0, {}, "aura")
			o.follow = c.hero
			o.life = 0.7
		"bw_mana_dive":
			var at := Vector2(c.hero.position.x + f * 40.0, -20.0)
			c._hit_near(at.x, 230.0, 14.0, {"type": "launch", "vy": 9.0})
			BowManaFx.ring(c, at, 230.0, BowManaFx.TRI)
		"bw_mana_tri":
			for i in 3:
				var a := deg_to_rad(26.0 + 10.0 * float(i))
				var o := _orb(c, hand + Vector2(0.0, -14.0 + 14.0 * float(i)), Vector2(f * cos(a), sin(a)) * 1150.0, [BowManaFx.TRI[i]], 22.0, SHOT * 0.85, {"kb": 0.9, "stun": 0.5})
				o.dart = true
				o.ground_pop = true
				o.life = 1.0
		"bw_mana_scatter":
			# โปรยเม็ดสามสีผสม ลอยช้าไปหน้า ทะลุโดนหลายฮิต
			for i in 9:
				var col: Color = BowManaFx.TRI[i % 3]
				var v := Vector2(f * randf_range(340.0, 500.0), randf_range(-80.0, 50.0))
				var o := _orb(c, hand + Vector2(0.0, randf_range(-30.0, 30.0)), v, [col], randf_range(20.0, 28.0), 2.0, {"kb": 0.2, "stun": 0.4}, "pierce")
				o.drag = 0.45
				o.life = 2.0 + randf() * 0.4
	return true
