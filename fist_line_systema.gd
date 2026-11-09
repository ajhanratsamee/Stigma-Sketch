class_name FistLineSystema
## คอมโบสาย SYSTEMA GRAPPLER / SAMBO ของ CAT ASH ชื่อท่าขึ้นต้น fss_
## SYSTEMA: zzz ฟาดมือลง ไหล่ดัน ปัดมืออีกข้างเสยลอย (ไม่มี z4)  xz เตะ ต่อยหน้า ลอยต่ำ  >>zzz ฟาดมือหน้า หมุนเตะเฉียงลง ชะงัก
## SAMBO: zz<xz> ไหล่ดัน แล้วรัว x/z สลับฟาดมือกับเตะ สูงสุด 8   >>x(x) กดค้าง x เตะสลับข้าง สูงสุด 5   ^zx พุ่งชนมอน ชะงัก

const MASH := 8
const HOLD_KICKS := 5

const NEXT := {
	"SYSTEMA GRAPPLER": {
		"fss_z1": {"z": "fss_z2"}, "fss_z2": {"z": "fss_z3"},
		"fs_x1": {"z": "fss_face"},
		"fs_dz": {"z": "fss_dz2"}, "fss_dz2": {"z": "fss_spin_kick"},
	},
	"SAMBO": {
		"fss_z2": {"x": "fss_m1"},
		"fss_m1": {"x": "fss_m2", "z": "fss_m2"}, "fss_m2": {"x": "fss_m3", "z": "fss_m3"}, "fss_m3": {"x": "fss_m4", "z": "fss_m4"},
		"fss_m4": {"x": "fss_m5", "z": "fss_m5"}, "fss_m5": {"x": "fss_m6", "z": "fss_m6"}, "fss_m6": {"x": "fss_m7", "z": "fss_m7"},
		"fss_m7": {"x": "fss_m8", "z": "fss_m8"},
		"fs_dx": {"x": "fss_k1"},
		"fs_az": {"x": "fss_ram"},
	},
}
const START := {
	# z แรกของสายนี้เป็นฟาดมือลง
	"SYSTEMA GRAPPLER": {"ground_z": "fss_z1"},
}

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

static func add_moves(m: Dictionary) -> void:
	var jab: Dictionary = m["fs_z1"]
	var kick: Dictionary = m["fs_x1"]
	var chop := _mv(jab, {"name": "ฟาดมือลง", "wind_hand": Vector3(0.1, 0.55, 0.1), "end_hand": Vector3(0.7, -0.3, 0.05), "time": 0.32, "wind": 0.3, "strike": 0.5,
		"next": 0.64, "dmg": 10.0, "lunge": 0.3, "lean": 18.0, "twist": 20.0, "fx": "fs_hook", "hit": {"kb": 0.6, "stun": 0.5}})
	# SYSTEMA zzz
	m["fss_z1"] = _mv(chop, {})
	m["fss_z2"] = _mv(jab, {"name": "ไหล่ดัน", "wind_hand": Vector3(-0.1, 0.0, 0.2), "end_hand": Vector3(0.2, 0.0, 0.25), "time": 0.36, "wind": 0.3, "strike": 0.55,
		"next": 0.66, "dmg": 11.0, "lunge": 0.7, "lean": 30.0, "twist": 25.0, "fx": "fs_dash", "hit": {"kb": 1.4, "stun": 0.55}})
	m["fss_z3"] = _mv(jab, {"name": "ปัดมือเสยลอย", "wind_hand": Vector3(0.25, -0.45, -0.1), "end_hand": Vector3(0.4, 0.6, -0.05), "time": 0.42, "next": 0.86,
		"dmg": 16.0, "lunge": 0.3, "lean": -12.0, "twist": -15.0, "shake": 0.15, "stop": 0.06, "fx": "fs_upper", "hit": {"type": "launch", "vy": 11.0}})
	# xz เตะ แล้วต่อยหน้า ลอยต่ำ
	m["fss_face"] = _mv(jab, {"name": "ต่อยหน้า", "end_hand": Vector3(0.82, 0.15, 0.05), "time": 0.36, "next": 0.8, "dmg": 14.0, "lunge": 0.35,
		"shake": 0.12, "hit": {"type": "launch", "vy": 6.0}})
	# >>zzz ฟาดมือไปหน้า แล้วหมุนเตะเฉียงลง ชะงัก
	m["fss_dz2"] = _mv(chop, {"name": "ฟาดมือไปข้างหน้า", "wind_hand": Vector3(0.0, 0.2, 0.15), "end_hand": Vector3(0.85, 0.05, 0.05), "dmg": 11.0})
	m["fss_spin_kick"] = _mv(kick, {"name": "หมุนเตะเฉียงลง", "dmg": 16.0, "time": 0.44, "wind": 0.25, "strike": 0.55, "next": 0.86, "lunge": 0.35, "spin": 360.0,
		"lean": 25.0, "shake": 0.18, "fx": "fs_axe", "hit": {"kb": 0.5, "stun": 1.2, "real_stun": true}})
	# SAMBO zz<xz> รัว สลับฟาดมือกับเตะ
	for i in MASH:
		var last := i == MASH - 1
		var mv: Dictionary
		if i % 2 == 0:
			mv = _mv(chop, {"name": "ฟาดมือรัว %d" % (i + 1), "wind_hand": Vector3(0.1, 0.25, 0.15), "end_hand": Vector3(0.85, 0.0, 0.05), "fx": "fs_dash"})
		else:
			mv = _mv(kick, {"name": "เตะรัว %d" % (i + 1), "fx": "fs_kick"})
		mv.merge({"time": 0.4 if last else 0.2, "wind": 0.25, "strike": 0.5, "next": 0.85 if last else 0.5, "dmg": 18.0 if last else 6.0,
			"lunge": 0.4 if last else 0.08, "shake": 0.2 if last else 0.05, "stop": 0.08 if last else 0.02,
			"hit": {"type": "knockdown", "fly": 6.0} if last else {"kb": 0.15, "stun": 0.5}}, true)
		m["fss_m%d" % (i + 1)] = mv
	# >>x(x) กดค้าง x เตะสลับข้าง สูงสุด 5
	for i in HOLD_KICKS:
		var last := i == HOLD_KICKS - 1
		var k := _mv(kick, {"name": "เตะสลับ %d" % (i + 1), "time": 0.36 if last else 0.22, "wind": 0.25, "strike": 0.5, "next": 0.8 if last else 0.55,
			"dmg": 15.0 if last else 7.0, "lunge": 0.3 if last else 0.12, "twist": 25.0 if i % 2 == 0 else -25.0, "spin": 0.0,
			"fx": "fs_round" if i % 2 == 0 else "fs_kick", "hit": {"type": "knockdown", "fly": 5.0} if last else {"kb": 0.3, "stun": 0.5}})
		if not last:
			k["auto"] = "fss_k%d" % (i + 2)
			k["auto_hold"] = true
			k["hold_button"] = "x"
		m["fss_k%d" % (i + 1)] = k
	# ^zx พุ่งชนมอน ชะงัก
	m["fss_ram"] = _mv(m["fss_z2"], {"name": "พุ่งชน", "time": 0.42, "next": 0.86, "dmg": 15.0, "lunge": 1.8, "drag": true, "shake": 0.18,
		"hit": {"kb": 0.8, "stun": 1.2, "real_stun": true}})

static func cast(_page: WalkPage, _fx: String) -> bool:
	return false
