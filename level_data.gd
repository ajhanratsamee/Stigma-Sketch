class_name LevelData
extends RefCounted
## เลเวลและ EXP  ตีมอนในดันเจี้ยนได้ EXP ผ่านดันได้โบนัส  EXP ครบแล้วเลเวลขึ้น สูงสุด 99
## ดันยิ่งเลเวลสูง มอนให้ EXP ยิ่งเยอะ  ตัวละครเลเวลสูงกว่าดันมากๆ ได้ EXP น้อยลง

const MAX_LEVEL := 99
const ROLE_EXP := {"hopper": 6.0, "melee": 8.0, "ranged": 10.0, "tank": 18.0, "support": 12.0, "rusher": 10.0, "midboss": 80.0}
const BOSS_EXP := 220.0
const CLEAR_EXP := 120.0

## EXP ที่ต้องเก็บให้ครบจากเลเวลนี้ไปเลเวลถัดไป
static func need(level: int) -> int:
	if level >= MAX_LEVEL:
		return 0
	return int(round(100.0 * pow(float(level), 1.6)))

## ตัวคูณตามเลเวลของดัน
static func _dungeon_mult(dungeon_level: int) -> float:
	return 1.0 + 0.25 * float(dungeon_level - 1)

## เลเวลเกินดันมาก EXP ลดลง เกิน 10 เลเวลได้แค่ 20%
static func _gap_mult(level: int, dungeon_level: int) -> float:
	var gap := level - dungeon_level
	if gap <= 5:
		return 1.0
	return maxf(1.0 - float(gap - 5) * 0.16, 0.2)

## EXP จากมอนหนึ่งตัว
static func monster_exp(role: String, dungeon_level: int, level: int) -> int:
	var base: float = BOSS_EXP if role.begins_with("boss_") else float(ROLE_EXP.get(role, 8.0))
	return maxi(1, int(round(base * _dungeon_mult(dungeon_level) * _gap_mult(level, dungeon_level))))

## โบนัสผ่านดัน
static func clear_exp(dungeon_level: int, level: int) -> int:
	return int(round(CLEAR_EXP * _dungeon_mult(dungeon_level) * _gap_mult(level, dungeon_level)))

## พลังโจมตีตามเลเวล และเลือดมอนตามเลเวลของดัน ใช้สูตรเดียวกัน เลเวลเท่าดันจึงตีมอนได้พอดีมือ
static func power(level: int) -> float:
	return 1.0 + 0.06 * float(maxi(level, 1) - 1)

## เพิ่ม EXP คืน [เลเวลใหม่ EXP ที่เหลือ ขึ้นกี่เลเวล]
static func add(level: int, exp_now: int, gain: int) -> Array:
	var lv := level
	var e := exp_now + gain
	var ups := 0
	while lv < MAX_LEVEL and e >= need(lv):
		e -= need(lv)
		lv += 1
		ups += 1
	if lv >= MAX_LEVEL:
		e = 0
	return [lv, e, ups]
