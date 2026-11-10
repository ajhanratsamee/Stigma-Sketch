class_name PairLinePsyche
## คอมโบสาย PSYCHE PAW / ID EGO SAGE ของ CAT AZURE & LAPIS พลัง ID (ดิบ ชมพู) กับ EGO (สติ ฟ้า)
## ชื่อท่าและเอฟเฟกต์ขึ้นต้น pc_py_ (PSYCHE PAW) pc_ie_ (ID EGO SAGE)  ท่า ID ขยับเกจไปทาง ID ท่า EGO ไปทาง EGO
## PSYCHE PAW: zzx ข่วนดิบรัว 3 ที   >>zx พุ่งตั้งสติ คลื่นสะท้อน   ^xz ดิ่งลงวงจิตสองสี
## ID EGO SAGE: xxz พายุข่วนดิบ ปิดล้ม   >>xz กำแพงสติผลักมอน   ^zx ลูก ID กับ EGO ปะทะ

const NEXT := {
	"PSYCHE PAW": {
		"pc_az_z2": {"x": "pc_py_az_id"}, "pc_lp_z2": {"x": "pc_py_lp_id"},
		"pc_az_dz": {"x": "pc_py_az_ego"}, "pc_lp_dz": {"x": "pc_py_lp_ego"},
		"pc_az_ax": {"z": "pc_py_az_dual"}, "pc_lp_ax": {"z": "pc_py_lp_dual"},
	},
	"ID EGO SAGE": {
		"pc_az_x2": {"z": "pc_ie_az_storm"}, "pc_lp_x2": {"z": "pc_ie_lp_storm"},
		"pc_az_dx": {"z": "pc_ie_az_wall"}, "pc_lp_turn_shot": {"z": "pc_ie_lp_wall"},
		"pc_az_az": {"x": "pc_ie_az_clash"}, "pc_lp_az": {"x": "pc_ie_lp_clash"},
	},
}
const START := {}

const ID_COL := Color(1.0, 0.7, 0.8)
const EGO_COL := Color(0.72, 0.9, 1.0)
const BASE := Color(0.5, 0.52, 0.9)

static func add_moves(m: Dictionary) -> void:
	var claw: Dictionary = m["pc_az_z1"]
	var shoot: Dictionary = m["pc_lp_x1"]
	var slash: Dictionary = m["pc_lp_z1"]
	# ---- PSYCHE PAW ----
	m["pc_py_az_id"] = PairCombo._mv(claw, {"name": "ข่วนดิบรัว", "time": 0.5, "wind": 0.1, "strike": 0.7, "next": 0.82, "dmg": 6.0, "lunge": 0.6, "multi": 0.1, "multi_ahead": 90.0,
		"multi_half": 100.0, "front_hit": true, "fx": "pc_py_id", "hit": {"kb": 0.6, "stun": 0.45}})
	m["pc_py_lp_id"] = PairCombo._mv(slash, {"name": "ฟันดิบรัว", "time": 0.5, "wind": 0.1, "strike": 0.7, "next": 0.82, "dmg": 6.0, "multi": 0.1, "multi_ahead": 90.0,
		"multi_half": 100.0, "front_hit": true, "fx": "pc_py_id", "hit": {"kb": 0.6, "stun": 0.45}})
	m["pc_py_az_ego"] = PairCombo._mv(claw, {"name": "ตั้งสติ คลื่นสะท้อน", "time": 0.42, "next": 0.8, "dmg": 0.0, "no_hit": true, "lunge": -0.1, "fx": "pc_py_ego"})
	m["pc_py_lp_ego"] = PairCombo._mv(shoot, {"name": "ตั้งสติ ยิงคลื่น", "time": 0.42, "next": 0.8, "fx": "pc_py_ego"})
	m["pc_py_az_dual"] = PairCombo._mv(claw, {"name": "ดิ่งวงจิต", "dive": true, "wind_hand": Vector3(0.2, 0.55, 0.1), "end_hand": Vector3(0.45, -0.6, 0.05), "time": 0.42, "strike": 0.55,
		"next": 0.82, "dmg": 14.0, "lean": 30.0, "shake": 0.14, "wide": true, "wide_half": 150.0, "fx": "pc_py_dual", "hit": {"kb": 1.5, "stun": 0.8}})
	m["pc_py_lp_dual"] = PairCombo._mv(slash, {"name": "ดิ่งวงจิต", "dive": true, "time": 0.42, "strike": 0.55, "next": 0.82, "dmg": 14.0, "wide": true, "wide_half": 150.0,
		"fx": "pc_py_dual", "hit": {"kb": 1.5, "stun": 0.8}})
	# ---- ID EGO SAGE ----
	m["pc_ie_az_storm"] = PairCombo._mv(claw, {"name": "พายุข่วนดิบ", "time": 0.6, "wind": 0.1, "strike": 0.8, "next": 0.9, "spin": 720.0, "dmg": 5.0, "multi": 0.08, "multi_ahead": 0.0,
		"multi_half": 170.0, "fx": "pc_ie_storm", "hit": {"kb": 0.4, "stun": 0.4}, "auto": "pc_ie_az_finish"})
	m["pc_ie_lp_storm"] = PairCombo._mv(slash, {"name": "พายุฟันดิบ", "time": 0.6, "wind": 0.1, "strike": 0.8, "next": 0.9, "spin": 720.0, "dmg": 5.0, "multi": 0.08, "multi_ahead": 0.0,
		"multi_half": 170.0, "fx": "pc_ie_storm", "hit": {"kb": 0.4, "stun": 0.4}, "auto": "pc_ie_lp_finish"})
	m["pc_ie_az_finish"] = PairCombo._mv(claw, {"name": "ข่วนดิบปิด", "time": 0.36, "next": 0.75, "dmg": 18.0, "lunge": 0.5, "shake": 0.16, "fx": "pc_claw2", "hit": {"type": "knockdown", "fly": 5.0}})
	m["pc_ie_lp_finish"] = PairCombo._mv(slash, {"name": "ฟันดิบปิด", "time": 0.36, "next": 0.75, "dmg": 18.0, "front_hit": true, "shake": 0.16, "hit": {"type": "knockdown", "fly": 5.0}})
	m["pc_ie_az_wall"] = PairCombo._mv(claw, {"name": "กำแพงสติ", "time": 0.44, "next": 0.9, "dmg": 0.0, "no_hit": true, "lunge": -0.1, "fx": "pc_ie_wall"})
	m["pc_ie_lp_wall"] = PairCombo._mv(shoot, {"name": "กำแพงสติ", "time": 0.44, "next": 0.9, "fx": "pc_ie_wall"})
	m["pc_ie_az_clash"] = PairCombo._mv(claw, {"name": "จิตปะทะ", "hover": true, "time": 0.46, "next": 0.9, "dmg": 0.0, "no_hit": true, "fx": "pc_ie_clash"})
	m["pc_ie_lp_clash"] = PairCombo._mv(shoot, {"name": "จิตปะทะ", "hover": true, "time": 0.46, "next": 0.9, "fx": "pc_ie_clash"})

static func cast(page: WalkPage, fx: String) -> bool:
	if not (fx.begins_with("pc_py_") or fx.begins_with("pc_ie_")):
		return false
	var f := page.hero.facing
	var hp := page.hero.position
	var U := CombatData.UNIT
	var K := SkillScale.K
	match fx:
		"pc_py_id":
			_shift(page, 0.15)
			PairLineSync.fx_node(page, "burst", hp + Vector2(f * 100.0, -70.0), 80.0, 0.35, null, Vector2.ZERO, BASE, ID_COL)
		"pc_py_ego":
			_shift(page, -0.15)
			PairLineSync.fx_node(page, "bubble", hp + Vector2(0.0, -80.0), 1.3 * U, 0.6, page.hero, Vector2.ZERO, BASE, EGO_COL)
			PairLineSync._after(page, 0.18, func() -> void:
				var c := page.hero.position + Vector2(f * 0.8 * U * K, 0.0)
				PairLineSync.fx_node(page, "ring", c, 2.8 * U, 0.4, null, Vector2.ZERO, BASE, EGO_COL)
				page._hit_area(c.x, 2.4 * U * K, 14.0, f, null, {"kb": 3.0, "stun": 0.6}))
		"pc_py_dual":
			PairLineSync.fx_node(page, "ring", Vector2(hp.x - 40.0, 0.0), 1.8 * U, 0.45, null, Vector2.ZERO, BASE, ID_COL)
			PairLineSync.fx_node(page, "ring", Vector2(hp.x + 40.0, 0.0), 1.8 * U, 0.45, null, Vector2.ZERO, BASE, EGO_COL)
		"pc_ie_storm":
			_shift(page, 0.2)
			PairLineSync.fx_node(page, "ring", hp, 2.2 * U, 0.6, page.hero, Vector2.ZERO, BASE, ID_COL)
		"pc_ie_wall":
			_shift(page, -0.2)
			var at := Vector2(hp.x + f * 1.4 * U * K, 0.0)
			PairLineSync.fx_node(page, "bar", at, 1.0 * U, 1.0, null, Vector2.ZERO, BASE, EGO_COL)
			for e in page.get_tree().get_nodes_in_group("monsters"):
				var mo := e as Monster
				if mo != null and mo.state != "dead" and (mo.position.x - at.x) * f > -60.0 and (mo.position.x - at.x) * f < 1.6 * U and mo.role != "boss" and mo.role != "boss_raid":
					mo.take_hit({"type": "knockdown", "fly": 6.0, "dmg": 16.0, "skill": true}, f)
		"pc_ie_clash":
			var meet := hp + Vector2(f * 2.2 * U * K, -80.0)
			PairLineSync.fx_node(page, "burst", meet + Vector2(-f * 60.0, 0.0), 70.0, 0.3, null, Vector2.ZERO, BASE, ID_COL)
			PairLineSync.fx_node(page, "burst", meet + Vector2(f * 60.0, 0.0), 70.0, 0.3, null, Vector2.ZERO, BASE, EGO_COL)
			PairLineSync._after(page, 0.2, func() -> void:
				PairLineSync.fx_node(page, "burst", meet, 1.6 * U, 0.45, null, Vector2.ZERO, BASE, ID_COL)
				PairLineSync.fx_node(page, "ring", Vector2(meet.x, 0.0), 2.2 * U, 0.45, null, Vector2.ZERO, BASE, EGO_COL)
				page._hit_area(meet.x, 1.6 * U * K, 26.0, f, null, {"type": "knockdown", "fly": 5.0}))
	return true

static func _shift(page: WalkPage, v: float) -> void:
	if page.susi != null and page.susi.has_method("psy_shift"):
		page.susi.psy_shift(v)
