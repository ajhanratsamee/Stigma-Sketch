class_name Stats
extends RefCounted
## ค่าสถานะพื้นฐานกับหน่วยที่พาสซีฟและบัพเพิ่มให้ ใช้กับทุกตัวละครเสมอ
## พลังโจมตี +100  ป้องกัน +100  MP +100  ความเร็ว +30  ลดพลังโจมตีศัตรู -50  ลดป้องกันศัตรู -50

const ATK_BASE := 1000.0
const DEF_BASE := 1000.0
const MP_BASE := 300.0
const SPEED_BASE := 300.0

const ATK_UP := 100.0
const DEF_UP := 100.0
const MP_UP := 100.0
const SPEED_UP := 30.0
const ATK_DOWN := 50.0
const DEF_DOWN := 50.0

## ตัวคูณที่ได้จากหน่วยข้างบน
const ATK_MULT := (ATK_BASE + ATK_UP) / ATK_BASE            # ตีแรงขึ้น 10%
const GUARD_MULT := DEF_BASE / (DEF_BASE + DEF_UP)          # โดนเบาลง ~9%
const SPEED_MULT := (SPEED_BASE + SPEED_UP) / SPEED_BASE    # เดินเร็วขึ้น 10%
const WEAK_MULT := (ATK_BASE - ATK_DOWN) / ATK_BASE         # ศัตรูตีเบาลง 5%
const BREAK_MULT := DEF_BASE / (DEF_BASE - DEF_DOWN)        # ศัตรูโดนแรงขึ้น ~5%

## มานาของสกิล ตามขั้นคลาส (0 พื้นฐาน 1 คลาสแรก 2 คลาสต่อยอด) และเลขหน้าชื่อสกิล
const MP_COST := {
	"mage": [
		{"1.1": 10.0, "1.2": 150.0, "5.1": 100.0, "10.1": 300.0, "15.1": 250.0, "20.1": 300.0, "20.2": 150.0},
		{"15.2": 30.0, "15.3": 150.0, "25.1": 75.0, "30.1": 250.0, "30.2": 270.0, "35.1": 100.0, "40.1": 150.0},
		{"35.2": 300.0, "35.3": 300.0, "45.1": 250.0, "45.2": 150.0, "50.1": 40.0, "55.1": 120.0},
	],
	"bow": [
		{"1.1": 30.0, "1.2": 200.0, "5.1": 80.0, "10.1": 300.0, "15.1": 120.0, "20.1": 300.0, "20.2": 80.0},
		{"15.2": 250.0, "15.3": 120.0, "15.5": 100.0, "30.1": 300.0, "30.2": 60.0, "35.1": 300.0, "40.1": 50.0},
		{"35.2": 25.0, "35.3": 250.0, "45.1": 200.0, "45.2": 120.0, "50.1": 80.0, "55.1": 120.0},
	],
	"cat": [
		{"1.1": 30.0, "1.2": 100.0, "5.1": 300.0, "10.1": 120.0, "15.1": 50.0, "20.1": 300.0, "20.2": 100.0},
		{"15.2": 30.0, "15.3": 150.0, "25.1": 100.0, "30.1": 200.0, "30.2": 30.0, "35.1": 300.0},
		{"35.2": 200.0, "35.3": 100.0, "40.1": 100.0, "45.1": 300.0, "45.2": 150.0, "50.1": 40.0, "50.2": 270.0, "55.1": 120.0},
	],
}
const HYPER_MP := 300.0
const HYPER_CD := 60.0
const BUFF_CD := 20.0
## สกิลบัพของ CAT BOYS คูลดาวน์นานกว่าปกติ
const BUFF_SKILLS := ["cat_sa", "cat_mk_ignite", "cat_gk_guard", "cat_fk_guard", "cat_gd_rally", "cat_gd_guard", "cat_gd_banner", "cat_ck_offer", "cat_sh_taunt", "cat_dk_orb"]

## คูลดาวน์ของสกิล CAT BOYS (และ HYPER ทุกตัว)  มานา / 15 วินาที อย่างน้อย 3 วิ
static func skill_cd(weapon: String, id: String) -> float:
	if id.ends_with("_hyper"):
		return HYPER_CD
	if id in BUFF_SKILLS:
		return BUFF_CD
	return maxf(3.0, skill_mp(weapon, id) / 15.0)
const HIT_MP := 3.0             # ตีคอมโบโดนได้มานาคืน

static func skill_mp(weapon: String, id: String) -> float:
	var info := SkillPanel.find_skill(id)
	if info.is_empty() or info.get("passive", false):
		return 0.0
	if id.ends_with("_hyper"):
		return HYPER_MP
	# สกิลธนูเก็บมานาต่อสกิล (เลขเลเวลซ้ำกันข้ามสาย)
	if SpearSkills.SPEAR_MP.has(id):
		return float(SpearSkills.SPEAR_MP[id])
	if FistSkills.FIST_MP.has(id):
		return float(FistSkills.FIST_MP[id])
	if BowSkills.BOW_MP.has(id):
		return float(BowSkills.BOW_MP[id])
	if PairSkills.PAIR_MP.has(id):
		return float(PairSkills.PAIR_MP[id])
	var tag := str(info.get("level", str(info.get("name", "")).get_slice(" ", 0)))
	var t := QuestData.tier(weapon, str(info.get("class", "BASIC")))
	var key := "cat" if weapon == "spear" or weapon == "azure" or weapon == "fist" else weapon
	var table: Array = MP_COST.get(key, MP_COST["cat"])
	var row: Dictionary = table[clampi(t, 0, 2)]
	return float(row.get(tag, 50.0))
