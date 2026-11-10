class_name DungeonRank
extends RefCounted
## คะแนนการเล่นดันเจี้ยนหนึ่งรอบ (นับต่อเนื่องข้ามห้อง) แล้วให้แรงก์ D C B A S SS SSS
## คิดจาก เวลาเคลียร์เทียบเวลามาตรฐาน คอมโบสูงสุด และจำนวนครั้งที่โดนตี  แรงก์คูณ EXP เคลียร์ (ดันพิเศษ/เรดได้โบนัสเพิ่ม)
## เก็บแรงก์ดีที่สุดของแต่ละดันไว้กับตัวละคร  จำกัดรอบดันพิเศษ (ต่อวัน) และเรด (ต่อสัปดาห์ หลังผ่านครั้งแรก)

const GRADES := ["D", "C", "B", "A", "S", "SS", "SSS"]
const NEED := [0.0, 35.0, 52.0, 68.0, 80.0, 88.0, 95.0]        # คะแนนขั้นต่ำของแต่ละแรงก์ (เต็ม 100)
const MULT := [1.0, 1.1, 1.2, 1.35, 1.5, 1.75, 2.0]            # ตัวคูณ EXP เคลียร์ตามแรงก์
const SPECIAL_EXP := 2.5         # ดันพิเศษได้ EXP เคลียร์เพิ่ม
const RAID_EXP := 1.5            # เรดได้ EXP เคลียร์เพิ่ม
const TIME_PTS := 40.0
const COMBO_PTS := 30.0
const HIT_PTS := 30.0
const HIT_ALLOW := 12.0          # โดนตีเกินนี้ คะแนนส่วนโดนตีเหลือ 0
const ROOM_PAR := {"warm": 50.0, "core": 70.0, "trap": 65.0, "mid": 45.0, "boss": 60.0}

const SPECIAL_PER_DAY := 3
const RAID_PER_WEEK := 3

# ---------------------------------------------------------------- สถิติรอบที่เล่นอยู่
static var run_time := 0.0
static var hits_taken := 0
static var max_combo := 0
static var total_hits := 0
static var _last_combo := 0

static func reset() -> void:
	run_time = 0.0
	hits_taken = 0
	max_combo = 0
	total_hits = 0
	_last_combo = 0

static func tick(delta: float) -> void:
	run_time += delta

static func on_hurt(_kind := "") -> void:
	hits_taken += 1

## ดูตัวนับคอมโบของตัวละครทุกเฟรม เก็บคอมโบสูงสุดและจำนวนฮิตรวม
static func observe_combo(n: int) -> void:
	if n > _last_combo:
		total_hits += n - _last_combo
	_last_combo = n
	max_combo = maxi(max_combo, n)

# ---------------------------------------------------------------- คะแนน
## เวลามาตรฐานของดัน รวมทุกห้อง (วินาที) ห้องยาวเวลามาตรฐานยาวตาม
static func par_time(town: int, index: int) -> float:
	var t := 0.0
	for r in DungeonData.rooms(town, index):
		var base := float(ROOM_PAR.get(str(r.get("type", "core")), 60.0))
		var h := float(r.get("half", 50.0))
		t += base * clampf(h / 100.0, 0.5, 1.2) if str(r.get("type", "")) != "boss" else base
	return maxf(t, 60.0)

## เป้าคอมโบที่ได้คะแนนเต็ม เมืองแรกต่ำกว่า
static func combo_target(town: int) -> float:
	return 20.0 if town == 0 else 30.0

static func grade_of(score: float) -> int:
	var g := 0
	for i in NEED.size():
		if score >= NEED[i]:
			g = i
	return g

static func compute(town: int, index: int, t := -1.0, combo := -1, hits := -1) -> Dictionary:
	var tt := run_time if t < 0.0 else t
	var cc := max_combo if combo < 0 else combo
	var hh := hits_taken if hits < 0 else hits
	var par := par_time(town, index)
	var tp := TIME_PTS * clampf((2.0 * par - tt) / par, 0.0, 1.0)
	var cp := COMBO_PTS * clampf(float(cc) / combo_target(town), 0.0, 1.0)
	var hp := HIT_PTS * clampf(1.0 - float(hh) / HIT_ALLOW, 0.0, 1.0)
	var score := tp + cp + hp
	var g := grade_of(score)
	return {"score": score, "grade": GRADES[g], "g": g, "mult": MULT[g], "time": tt, "par": par,
		"combo": cc, "hits": hh, "time_pts": tp, "combo_pts": cp, "hit_pts": hp}

## โบนัส EXP เคลียร์ของประเภทดัน
static func exp_bonus(town: int, index: int) -> float:
	if DungeonData.is_special(index):
		return SPECIAL_EXP
	return RAID_EXP if not DungeonData.raid(town, index).is_empty() else 1.0

## EXP เคลียร์หลังคูณแรงก์และโบนัสประเภทดัน
static func clear_exp(base: int, town: int, index: int, g: int) -> int:
	return int(round(float(base) * float(MULT[clampi(g, 0, MULT.size() - 1)]) * exp_bonus(town, index)))

# ---------------------------------------------------------------- เก็บกับตัวละคร
static func _entry() -> Dictionary:
	var list := SaveData.roster()
	var i := WalkPage.roster_index
	return list[i] if i >= 0 and i < list.size() else {}

static func key(town: int, index: int) -> String:
	return "%d_%d" % [town, index]

## แรงก์ดีที่สุดของดันนี้ "" ถ้ายังไม่เคย
static func best(town: int, index: int, entry := {}) -> String:
	var e: Dictionary = entry if not entry.is_empty() else _entry()
	return str((e.get("ranks", {}) as Dictionary).get(key(town, index), ""))

## บันทึกแรงก์ถ้าดีกว่าเดิม คืน true ถ้าเป็นสถิติใหม่
static func save_best(town: int, index: int, grade: String) -> bool:
	if WalkPage.roster_index < 0:
		return false
	var e := _entry()
	var ranks: Dictionary = (e.get("ranks", {}) as Dictionary).duplicate()
	var old := str(ranks.get(key(town, index), ""))
	if old != "" and GRADES.find(old) >= GRADES.find(grade):
		return false
	ranks[key(town, index)] = grade
	SaveData.update_character(WalkPage.roster_index, {"ranks": ranks})
	return true

# ---------------------------------------------------------------- จำกัดรอบ
## วันที่ตามเวลาในเครื่อง (รีเซ็ตเที่ยงคืน)
static func today(now := {}) -> String:
	var d: Dictionary = now if not now.is_empty() else Time.get_date_dict_from_system()
	return "%04d-%02d-%02d" % [int(d["year"]), int(d["month"]), int(d["day"])]

## สัปดาห์ (เริ่มวันจันทร์) ใช้วันจันทร์ของสัปดาห์เป็นรหัส
static func week(now := {}) -> String:
	var d: Dictionary = now if not now.is_empty() else Time.get_date_dict_from_system()
	var unix := Time.get_unix_time_from_datetime_dict({"year": int(d["year"]), "month": int(d["month"]), "day": int(d["day"]), "hour": 12, "minute": 0, "second": 0})
	var wd := int(Time.get_datetime_dict_from_unix_time(unix)["weekday"])   # 0 อาทิตย์
	var back := (wd + 6) % 7
	return today(Time.get_date_dict_from_unix_time(unix - back * 86400))

## ดันนี้นับรอบไหม: ดันพิเศษทุกครั้ง  เรดหลังผ่านครั้งแรกแล้ว (ครั้งแรกเล่นได้เสมอ ไม่ติดเนื้อเรื่อง)
static func limited(town: int, index: int) -> String:
	if DungeonData.is_special(index):
		return "day"
	if not DungeonData.raid(town, index).is_empty() and index in SaveData.cleared(town):
		return "week"
	return ""

## รอบที่เหลือ -1 คือไม่จำกัด
static func left(town: int, index: int, entry := {}, now := {}) -> int:
	var kind := limited(town, index)
	if kind == "" or WalkPage.roster_index < 0 and entry.is_empty():
		return -1
	var e: Dictionary = entry if not entry.is_empty() else _entry()
	var lim: Dictionary = e.get("lim", {})
	if kind == "day":
		var used := int(lim.get("sp_used", 0)) if str(lim.get("sp_day", "")) == today(now) else 0
		return maxi(SPECIAL_PER_DAY - used, 0)
	var wused := int(lim.get("rd_used", 0)) if str(lim.get("rd_week", "")) == week(now) else 0
	return maxi(RAID_PER_WEEK - wused, 0)

## ใช้รอบ 1 ครั้งตอนเข้าดัน คืน false ถ้าหมดรอบ
static func use_entry(town: int, index: int, now := {}) -> bool:
	var kind := limited(town, index)
	if kind == "" or WalkPage.roster_index < 0:
		return true
	if left(town, index, {}, now) <= 0:
		return false
	var e := _entry()
	var lim: Dictionary = (e.get("lim", {}) as Dictionary).duplicate()
	if kind == "day":
		var d := today(now)
		lim["sp_used"] = (int(lim.get("sp_used", 0)) if str(lim.get("sp_day", "")) == d else 0) + 1
		lim["sp_day"] = d
	else:
		var w := week(now)
		lim["rd_used"] = (int(lim.get("rd_used", 0)) if str(lim.get("rd_week", "")) == w else 0) + 1
		lim["rd_week"] = w
	SaveData.update_character(WalkPage.roster_index, {"lim": lim})
	return true
