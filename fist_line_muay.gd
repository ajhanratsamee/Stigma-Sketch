class_name FistLineMuay
## คอมโบสาย WAR MUAY / MUAY THAI ของ CAT ASH ชื่อท่าขึ้นต้น fsm_
## WAR MUAY: xzzz เตะ ต่อยตรง 2 ที ต่อยมืออีกข้าง เตะกระเด็น   >>^zzx เข่าแล้วศอกมอนลอย   >>xxx เข่า ต่อย งัดลอย
## MUAY THAI: zxxx หมุนศอกแนวนอน หมุนกลับต่อยท้อง ศอกเสยลอย   xxz กระโดดเข่าทืบพื้น   >>zx พุ่งเข่าชะงัก

const NEXT := {
	"WAR MUAY": {
		"fs_x1": {"z": "fsm_dbl"}, "fsm_dbl": {"z": "fsm_punch"}, "fsm_punch": {"z": "fsm_kick_fly"},
		"fs_adz2": {"x": "fsm_knee_elbow"},
		"fs_dx": {"x": "fsm_dx_punch"}, "fsm_dx_punch": {"x": "fsm_lift"},
	},
	"MUAY THAI": {
		"fs_z1": {"x": "fsm_elbow_spin"}, "fsm_elbow_spin": {"x": "fsm_belly"}, "fsm_belly": {"x": "fsm_elbow_up"},
		"fs_x2": {"z": "fsm_jump_knee"},
		"fs_dz": {"x": "fsm_dash_knee"},
	},
}
const START := {}

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

static func add_moves(m: Dictionary) -> void:
	var jab: Dictionary = m["fs_z1"]
	var kick: Dictionary = m["fs_x1"]
	var knee: Dictionary = m["fs_dx"]
	# WAR MUAY xzzz
	m["fsm_dbl"] = _mv(jab, {"name": "ต่อยตรง 2 ที", "time": 0.36, "next": 0.66, "dmg": 6.0, "multi": 0.12, "multi_ahead": 110.0, "multi_half": 110.0, "lunge": 0.35})
	m["fsm_punch"] = _mv(m["fs_z2"], {"name": "ต่อยมืออีกข้าง", "dmg": 11.0, "lunge": 0.3})
	m["fsm_kick_fly"] = _mv(kick, {"name": "เตะกระเด็น", "dmg": 18.0, "time": 0.44, "wind": 0.3, "strike": 0.55, "next": 0.88, "lunge": 0.45, "lean": 15.0,
		"shake": 0.2, "stop": 0.08, "fx": "fs_round", "hit": {"type": "knockdown", "fly": 8.0}})
	# >>^zzx เข่าแล้วศอก มอนลอย
	m["fsm_knee_elbow"] = _mv(knee, {"name": "เข่าแล้วศอก", "dmg": 8.0, "time": 0.5, "wind": 0.2, "strike": 0.6, "next": 0.86, "lunge": 0.6, "leap": 3.5,
		"multi": 0.14, "multi_ahead": 90.0, "multi_half": 110.0, "fx": "fs_knee", "hit": {"type": "launch", "vy": 9.0}})
	# >>xxx เข่า (fs_dx) ต่อยอีกที แล้วงัดลอย
	m["fsm_dx_punch"] = _mv(jab, {"name": "ต่อยตาม", "dmg": 11.0, "lunge": 0.4, "next": 0.64})
	m["fsm_lift"] = _mv(m["fs_z4"], {"name": "งัดมอนลอย", "dmg": 15.0})
	# MUAY THAI zxxx
	m["fsm_elbow_spin"] = _mv(jab, {"name": "หมุนศอกแนวนอน", "wind_hand": Vector3(-0.2, 0.15, 0.3), "end_hand": Vector3(0.5, 0.15, -0.2), "spin": 360.0, "time": 0.38,
		"next": 0.66, "dmg": 12.0, "lunge": 0.3, "fx": "fs_spin", "hit": {"kb": 0.8, "stun": 0.5}})
	m["fsm_belly"] = _mv(jab, {"name": "หมุนกลับต่อยท้อง", "wind_hand": Vector3(0.1, -0.15, 0.2), "end_hand": Vector3(0.8, -0.2, 0.05), "spin": -360.0, "time": 0.38,
		"next": 0.66, "dmg": 13.0, "lunge": 0.3, "fx": "fs_hook", "hit": {"kb": 0.6, "stun": 0.6}})
	m["fsm_elbow_up"] = _mv(m["fs_z4"], {"name": "ศอกเสยลอย", "dmg": 17.0, "fx": "fs_upper"})
	# xxz กระโดดเข่าทืบพื้น
	m["fsm_jump_knee"] = _mv(knee, {"name": "กระโดดเข่าทืบพื้น", "dmg": 18.0, "time": 0.55, "wind": 0.3, "strike": 0.6, "next": 0.9, "lunge": 0.4, "leap": 6.0, "dive": true,
		"shake": 0.25, "stop": 0.08, "wide": true, "wide_half": 220.0, "fx": "fs_dive", "hit": {"type": "launch", "vy": 7.0}})
	# >>zx พุ่งเข่าชะงัก
	m["fsm_dash_knee"] = _mv(knee, {"name": "พุ่งเข่า", "dmg": 15.0, "leap": 2.0, "lunge": 1.6, "hit": {"kb": 0.6, "stun": 1.2, "real_stun": true}})

static func cast(_page: WalkPage, _fx: String) -> bool:
	return false
