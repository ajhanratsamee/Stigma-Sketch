class_name SaveData
extends RefCounted
## เก็บข้อมูลในเครื่อง คลังตัวละครที่สร้างไว้ และค่าตั้งต่างๆ

const PATH := "user://save.cfg"

static func character() -> String:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return ""
	return str(cfg.get_value("hero", "id", ""))

static func set_character(id: String) -> void:
	var cfg := ConfigFile.new()
	cfg.load(PATH)
	cfg.set_value("hero", "id", id)
	cfg.save(PATH)

static func language() -> int:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return 0
	return int(cfg.get_value("options", "language", 0))

static func set_language(code: int) -> void:
	var cfg := ConfigFile.new()
	cfg.load(PATH)
	cfg.set_value("options", "language", code)
	cfg.save(PATH)

## รหัสสกิลในปุ่มทั้ง 4 ช่อง ของสายนี้ ไม่เคยตั้งคืนค่าว่าง
static func slots(job: String) -> Array:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return []
	return cfg.get_value("slots", job, [])

static func set_slots(job: String, list: Array) -> void:
	var cfg := ConfigFile.new()
	cfg.load(PATH)
	cfg.set_value("slots", job, list)
	cfg.save(PATH)

## คลังตัวละครที่สร้างไว้ แต่ละตัวเป็น {"weapon": รหัสตัว, "class": คลาส, "level": เลเวล}
const ROSTER_MAX := 10

static func roster() -> Array:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return []
	var raw = cfg.get_value("roster", "list", [])
	var out: Array = []
	if not raw is Array:
		return out
	# เกมเวอร์ชันเก่าเก็บช่องนี้เป็นข้อความ แปลงที่เป็นรหัสตัวละคร ที่อ่านไม่ออกข้ามไป
	for item in raw:
		if item is Dictionary and item.has("weapon"):
			# ชื่อคลาสเก่าของ CAT MATCHA
			if str(item.get("class", "")) == "ELEMENTAL MASTER":
				item["class"] = "ESSENCE WEAVER"
			out.append(item)
		elif item is String and item in ["cat", "mage", "bow", "spear", "azure", "fist"]:
			out.append({"weapon": item, "class": ""})
	return out

static func _set_roster(list: Array) -> void:
	var cfg := ConfigFile.new()
	cfg.load(PATH)
	cfg.set_value("roster", "list", list)
	cfg.save(PATH)

## เพิ่มตัวละครเข้าคลัง เต็มแล้วไม่เพิ่ม คืนค่าลำดับในคลัง หรือ -1
static func add_character(weapon: String, class_id: String, level := 1) -> int:
	var list := roster()
	if list.size() >= ROSTER_MAX:
		return -1
	# "tut" false = ยังไม่ผ่านโหมดฝึกสอน กดเล่นครั้งแรกจะเข้าฝึกสอนก่อน (ตัวเก่าไม่มีฟิลด์นี้ ถือว่าผ่านแล้ว)
	list.append({"weapon": weapon, "class": class_id, "level": level, "tut": false})
	_set_roster(list)
	return list.size() - 1

## แก้ข้อมูลของตัวละครลำดับนี้ เช่น เลเวล EXP คลาส เควส
## ฟิลด์ของระบบเควส: "quest" เควสเปลี่ยนคลาส  "qs" เควสหลัก/รอง/กระดาน  "mail" จดหมาย  "title" ฉายา (ดู QuestData)
static func update_character(index: int, fields: Dictionary) -> void:
	var list := roster()
	if index < 0 or index >= list.size():
		return
	var entry: Dictionary = list[index]
	entry.merge(fields, true)
	list[index] = entry
	_set_roster(list)

static func remove_character(index: int) -> void:
	var list := roster()
	if index >= 0 and index < list.size():
		list.remove_at(index)
		_set_roster(list)

## ดันเจี้ยนที่ผ่านแล้วของเมืองนี้
static func cleared(town: int) -> Array:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return []
	return cfg.get_value("cleared", "town%d" % town, [])

static func mark_cleared(town: int, index: int) -> void:
	var list := cleared(town)
	if index in list:
		return
	list.append(index)
	var cfg := ConfigFile.new()
	cfg.load(PATH)
	cfg.set_value("cleared", "town%d" % town, list)
	cfg.save(PATH)

static func clear() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH))
