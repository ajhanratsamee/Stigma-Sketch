class_name FistLineHeavy
## คอมโบสาย HEAVYWEIGHT / GRAND SUMO ของ CAT ASH ชื่อท่าขึ้นต้น fsh_
## HEAVYWEIGHT: ลงกลางอากาศ กระแทกพื้นรอบตัวชะงัก (walk_page เรียก fsh_slam)  xzzz ผลักฝ่ามือ 2 ที ไหล่ชนล้ม  zzz↓z กระทืบพื้นมอนลอย
## GRAND SUMO: ↓x กระโดดทืบพื้นวงกว้างมอนลอย  >>zxx ไหล่ชน ทืบพื้นมอนลอยต่ำ  xx(z) กดค้างตบฝ่ามือรัว สูงสุด 10 ฮิต

const SLAPS := 10

const NEXT := {
	"HEAVYWEIGHT": {
		"fs_x1": {"z": "fsh_push1"}, "fsh_push1": {"z": "fsh_push2"}, "fsh_push2": {"z": "fsh_shoulder"},
		"fs_z3": {"down_z": "fsh_stomp"},
	},
	"GRAND SUMO": {
		"fs_dz": {"x": "fsh_ram"}, "fsh_ram": {"x": "fsh_foot_stomp"},
		"fs_x2": {"z": "fsh_slap1"},
	},
}
const START := {
	"GRAND SUMO": {"ground_down_x": "fsh_big_stomp"},
}

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

static func add_moves(m: Dictionary) -> void:
	var jab: Dictionary = m["fs_z1"]
	var kick: Dictionary = m["fs_x1"]
	# ฝ่ามือผลัก มือยื่นตรงไปข้างหน้า
	var push := _mv(jab, {"name": "ฝ่ามือผลัก", "wind_hand": Vector3(0.1, 0.05, 0.15), "end_hand": Vector3(0.85, 0.08, 0.05), "time": 0.34, "wind": 0.35, "strike": 0.55,
		"next": 0.66, "dmg": 11.0, "lunge": 0.45, "lean": 20.0, "twist": -15.0, "fx": "fs_jab", "hit": {"kb": 1.6, "stun": 0.5}})
	# กลางอากาศกดลง กระแทกพื้นรอบตัว มอนชะงัก
	m["fsh_slam"] = _mv(jab, {"name": "กระแทกพื้นรอบตัว", "end_hand": Vector3(0.3, -0.6, 0.05), "end_aim": Vector2(-80.0, 0.0), "dive": true, "time": 0.4, "wind": 0.15,
		"strike": 0.55, "next": 0.8, "dmg": 14.0, "lunge": 0.0, "lean": 25.0, "shake": 0.25, "stop": 0.06, "wide": true, "wide_half": 260.0, "fx": "fs_dive",
		"front_hit": false, "hit": {"kb": 0.4, "stun": 1.0, "real_stun": true}})
	m["fsh_push1"] = _mv(push, {"name": "ฝ่ามือผลัก"})
	m["fsh_push2"] = _mv(push, {"name": "สลับฝ่ามือผลัก", "wind_hand": Vector3(0.25, -0.05, -0.1), "end_hand": Vector3(0.05, -0.08, -0.1),
		"wind_off": Vector3(0.1, 0.05, 0.15), "end_off": Vector3(0.85, 0.08, 0.05), "twist": 15.0})
	m["fsh_shoulder"] = _mv(jab, {"name": "ไหล่ชนล้ม", "wind_hand": Vector3(-0.1, 0.0, 0.2), "end_hand": Vector3(0.2, 0.0, 0.25), "time": 0.46, "wind": 0.3, "strike": 0.6,
		"next": 0.9, "dmg": 18.0, "lunge": 1.4, "lean": 35.0, "twist": 30.0, "shake": 0.2, "stop": 0.08, "fx": "fs_dash", "hit": {"type": "knockdown", "fly": 5.0}})
	# zzz↓z กระทืบพื้นมอนลอย
	m["fsh_stomp"] = _mv(kick, {"name": "กระทืบพื้น", "dmg": 16.0, "time": 0.44, "wind": 0.35, "strike": 0.55, "next": 0.85, "lunge": 0.1, "leap": 2.5, "lean": 15.0,
		"shake": 0.22, "stop": 0.06, "wide": true, "wide_half": 220.0, "fx": "fs_axe", "hit": {"type": "launch", "vy": 9.0}})
	# GRAND SUMO ↓x กระโดดทืบพื้นวงกว้าง
	m["fsh_big_stomp"] = _mv(kick, {"name": "กระโดดทืบพื้นวงกว้าง", "dmg": 22.0, "time": 0.6, "wind": 0.35, "strike": 0.6, "next": 0.9, "lunge": 0.0, "leap": 6.0, "dive": true,
		"lean": 10.0, "shake": 0.32, "stop": 0.1, "wide": true, "wide_half": 380.0, "fx": "fs_dive", "hit": {"type": "launch", "vy": 10.0}})
	# >>zxx ไหล่ชน แล้วเท้าข้างเดียวทืบพื้นมอนลอยต่ำ
	m["fsh_ram"] = _mv(m["fsh_shoulder"], {"name": "ไหล่ชน", "time": 0.4, "next": 0.66, "dmg": 14.0, "lunge": 1.2, "hit": {"kb": 1.2, "stun": 0.6}})
	m["fsh_foot_stomp"] = _mv(kick, {"name": "ทืบพื้นข้างเดียว", "dmg": 16.0, "time": 0.44, "wind": 0.35, "strike": 0.55, "next": 0.85, "lunge": 0.2, "lean": 12.0,
		"shake": 0.2, "wide": true, "wide_half": 230.0, "fx": "fs_axe", "hit": {"type": "launch", "vy": 6.0}})
	# xx(z) กดค้าง z ตบฝ่ามือรัว สูงสุด 10 ฮิต ปล่อยปุ่มแล้วหยุด
	for i in SLAPS:
		var last := i == SLAPS - 1
		var hy := 0.1 if i % 2 == 0 else -0.05
		var slap := _mv(push, {"name": "ตบฝ่ามือรัว %d" % (i + 1), "wind_hand": Vector3(0.3, hy, 0.15 if i % 2 == 0 else -0.1), "end_hand": Vector3(0.85, hy, 0.05 if i % 2 == 0 else -0.05),
			"time": 0.4 if last else 0.16, "wind": 0.3, "strike": 0.5, "next": 0.8 if last else 0.55, "dmg": 18.0 if last else 5.0, "lunge": 0.4 if last else 0.06,
			"twist": -20.0 if i % 2 == 0 else 20.0, "shake": 0.22 if last else 0.05, "stop": 0.08 if last else 0.02,
			"hit": {"type": "knockdown", "fly": 6.0} if last else {"kb": 0.15, "stun": 0.5}})
		if not last:
			slap["auto"] = "fsh_slap%d" % (i + 2)
			slap["auto_hold"] = true
			slap["hold_button"] = "z"
		m["fsh_slap%d" % (i + 1)] = slap

static func cast(_page: WalkPage, _fx: String) -> bool:
	return false
