class_name FistLineZephyr
## คอมโบสาย ZEPHYR / KUNG FU ของ CAT ASH ชื่อท่าขึ้นต้น fsz_
## ZEPHYR: zzxxxxxxx วิชากังฟูเตะ ฟาดแขน ตวัดเตะ เตะเสย x สุดท้ายกระโดดหมุนเตะล้ม
##         xx ตวัดขามอนลอย แล้วผลักมือล้ม   xzz ฟาดมือวงกลมแนวนอน แล้วผลักล้ม
## KUNG FU: >>^zxx พุ่งลงเฉียง ตวัดขามอนลอย   >>zxx ฟาดมือเฉียงหน้า งัดลอย   zxx ตวัดมือวงกลม ต่อยงัดขึ้น

const NEXT := {
	"ZEPHYR": {
		"fs_z2": {"x": "fsz_f1"},
		"fsz_f1": {"x": "fsz_f2"}, "fsz_f2": {"x": "fsz_f3"}, "fsz_f3": {"x": "fsz_f4"}, "fsz_f4": {"x": "fsz_f5"},
		"fsz_f5": {"x": "fsz_f6"}, "fsz_f6": {"x": "fsz_f7"},
		"fsz_x1": {"x": "fsz_x2", "z": "fsz_circle"},
		"fsz_circle": {"z": "fsz_push"},
	},
	"KUNG FU": {
		"fs_adz1": {"x": "fsz_dive"}, "fsz_dive": {"x": "fsz_sweep_up"},
		"fs_dz": {"x": "fsz_diag"}, "fsz_diag": {"x": "fsz_lift"},
		"fs_z1": {"x": "fsz_round"}, "fsz_round": {"x": "fsz_rise"},
	},
}
const START := {
	# ZEPHYR x แรกเปลี่ยนเป็นตวัดขามอนลอย
	"ZEPHYR": {"ground_x": "fsz_x1"},
}

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

static func add_moves(m: Dictionary) -> void:
	var jab: Dictionary = m["fs_z1"]
	var kick: Dictionary = m["fs_x1"]
	var chop := _mv(jab, {"name": "ฟาดสันมือ", "wind_hand": Vector3(0.1, 0.5, 0.1), "end_hand": Vector3(0.75, -0.2, 0.05), "time": 0.3, "wind": 0.3, "strike": 0.5,
		"next": 0.62, "dmg": 10.0, "lunge": 0.3, "lean": 15.0, "twist": 25.0, "fx": "fs_hook", "hit": {"kb": 0.8, "stun": 0.45}})
	# zz แล้ว xxxxxxx กังฟูหลายท่าไม่ซ้ำ
	m["fsz_f1"] = _mv(kick, {"name": "เตะต่ำ", "dmg": 9.0, "time": 0.28, "wind": 0.3, "strike": 0.5, "next": 0.6, "lunge": 0.3, "lean": 25.0, "fx": "fs_kick", "hit": {"kb": 0.6, "stun": 0.45}})
	m["fsz_f2"] = _mv(chop, {"name": "ฟาดแขน"})
	m["fsz_f3"] = _mv(kick, {"name": "ตวัดเตะ", "dmg": 10.0, "time": 0.32, "wind": 0.25, "strike": 0.5, "next": 0.62, "lunge": 0.3, "spin": 180.0, "fx": "fs_round", "hit": {"kb": 0.8, "stun": 0.45}})
	m["fsz_f4"] = _mv(chop, {"name": "สันมือฟาดย้อน", "wind_hand": Vector3(0.6, -0.2, 0.05), "end_hand": Vector3(0.2, 0.5, 0.1), "twist": -25.0})
	m["fsz_f5"] = _mv(kick, {"name": "ปัดขาต่ำ", "dmg": 10.0, "time": 0.32, "wind": 0.25, "strike": 0.5, "next": 0.62, "lunge": 0.25, "spin": 360.0, "lean": 35.0, "fx": "fs_sweep", "hit": {"kb": 0.6, "stun": 0.55}})
	m["fsz_f6"] = _mv(kick, {"name": "เตะเสย", "dmg": 11.0, "time": 0.34, "wind": 0.25, "strike": 0.5, "next": 0.64, "lunge": 0.25, "lean": -20.0, "fx": "fs_upper", "hit": {"kb": 0.4, "stun": 0.55}})
	m["fsz_f7"] = _mv(kick, {"name": "กระโดดหมุนตัวเตะล้ม", "dmg": 19.0, "time": 0.5, "wind": 0.2, "strike": 0.6, "next": 0.9, "lunge": 0.5, "leap": 5.0, "spin": 540.0,
		"shake": 0.22, "stop": 0.08, "fx": "fs_spin", "hit": {"type": "knockdown", "fly": 6.0}})
	# ZEPHYR xx ตวัดขามอนลอย แล้วผลักมือล้ม
	m["fsz_x1"] = _mv(kick, {"name": "ตวัดขามอนลอย", "dmg": 12.0, "time": 0.36, "wind": 0.25, "strike": 0.52, "next": 0.68, "lunge": 0.3, "spin": 360.0, "lean": 30.0,
		"fx": "fs_sweep", "hit": {"type": "launch", "vy": 8.0}})
	var push := _mv(jab, {"name": "ผลักมือล้ม", "wind_hand": Vector3(0.1, 0.05, 0.15), "end_hand": Vector3(0.85, 0.1, 0.05), "time": 0.4, "wind": 0.3, "strike": 0.55,
		"next": 0.88, "dmg": 15.0, "lunge": 0.5, "lean": 22.0, "shake": 0.18, "stop": 0.06, "fx": "fs_jab", "hit": {"type": "knockdown", "fly": 5.0}})
	m["fsz_x2"] = _mv(push, {})
	# xzz ฟาดมือวงกลมแนวนอน แล้วผลักล้ม
	m["fsz_circle"] = _mv(chop, {"name": "ฟาดมือวงกลม", "wind_hand": Vector3(-0.3, 0.1, 0.3), "end_hand": Vector3(0.6, 0.1, -0.3), "spin": 360.0, "time": 0.38,
		"next": 0.66, "dmg": 12.0, "fx": "fs_spin", "wide": true, "wide_half": 170.0})
	m["fsz_push"] = _mv(push, {})
	# KUNG FU >>^zxx พุ่งลงเฉียง แล้วตวัดขามอนลอย
	m["fsz_dive"] = _mv(kick, {"name": "พุ่งลงเฉียง", "dmg": 13.0, "dive": true, "dive_forward": 4.0, "time": 0.4, "wind": 0.2, "strike": 0.55, "next": 0.75, "lunge": 0.2,
		"lean": 30.0, "shake": 0.2, "front_hit": true, "fx": "fs_dive", "hit": {"kb": 0.4, "stun": 0.8}})
	m["fsz_sweep_up"] = _mv(m["fsz_x1"], {"name": "ตวัดขามอนลอย", "next": 0.85})
	# >>zxx ฟาดมือเฉียงหน้า แล้วงัดลอย
	m["fsz_diag"] = _mv(chop, {"name": "ฟาดมือเฉียงหน้า", "wind_hand": Vector3(0.0, 0.55, 0.1), "end_hand": Vector3(0.8, -0.3, 0.05), "dmg": 12.0, "lunge": 0.4})
	m["fsz_lift"] = _mv(jab, {"name": "งัดลอย", "wind_hand": Vector3(0.3, -0.45, 0.2), "end_hand": Vector3(0.5, 0.6, 0.05), "time": 0.4, "next": 0.85, "dmg": 15.0, "lean": -12.0,
		"shake": 0.15, "fx": "fs_upper", "hit": {"type": "launch", "vy": 10.0}})
	# zxx ตวัดมือวงกลม แล้วต่อยงัดขึ้น
	m["fsz_round"] = _mv(m["fsz_circle"], {"name": "ตวัดมือวงกลม", "wide": false})
	m["fsz_rise"] = _mv(m["fsz_lift"], {"name": "ต่อยงัดขึ้น", "dmg": 16.0})

static func cast(_page: WalkPage, _fx: String) -> bool:
	return false
