class_name JobData
extends RefCounted
## สายอาชีพของตัวละคร เรียงจากต้นไปปลาย ท่า Z X ตอนนี้ใช้ชุดเดียวกันทุกสาย

# ลำดับตรงกับแถวรายชื่อหน้าสร้างตัวละคร
const CHARACTERS := [
	{"id": "boy", "name": "BOY", "theme": Color(0.84, 0.16, 0.16)},
	{"id": "gwen", "name": "GWEN", "theme": Color(0.5, 0.26, 0.8)},
	# ธีมขาว: พื้นขาวขึ้น เส้นบอกการเลือกใช้สีเทา เพราะเส้นขาวบนกระดาษมองไม่เห็น
	{"id": "aid", "name": "AID", "theme": Color(0.55, 0.57, 0.62), "paper": Color(1.0, 1.0, 1.0), "paper_mix": 0.8},
]
# parent คือสายก่อนหน้า col row คือตำแหน่งบนผังหน้าสร้างตัวละคร
const JOBS := [
	{"id": "boy", "name": "BOY", "tier": "ตัวละครเริ่มต้น", "parent": "", "col": 1.0, "row": 0,
		"desc": "เพิ่งได้ดาบเล่มแรก ยังต้องฝึกอีกเยอะ"},
	{"id": "sword_knight", "name": "SWORD KNIGHT", "tier": "สายแรก", "parent": "boy", "col": 0.0, "row": 1,
		"desc": "ฝึกดาบจนคล่อง พร้อมออกเดินทาง"},
	{"id": "lord_knight", "sword_style": "slim", "name": "LORD KNIGHT", "tier": "สายต่อยอด", "parent": "sword_knight", "col": 0.0, "row": 2,
		"desc": "อัศวินชั้นสูง มีสกิล Hyper เรียกดาบยักษ์ลงมาปัก", "hyper": "lord"},
	{"id": "magic_knight", "name": "MAGIC KNIGHT", "tier": "สายแรก", "parent": "boy", "col": 1.0, "row": 1,
		"desc": "อัศวินที่เริ่มหัดใช้เวทควบคู่กับดาบ"},
	{"id": "blade_weaver", "sword_style": "square", "name": "BLADE WEAVER", "tier": "สายต่อยอด", "parent": "magic_knight", "col": 1.0, "row": 2,
		"desc": "มือมีไฟลุก ถักทอธาตุทั้งห้าเป็นลูกบอล สกิล Hyper ขยำให้ระเบิด", "hyper": "weaver", "hand_fire": true},
	{"id": "rampart_knight", "name": "RAMPART KNIGHT", "tier": "สายแรก", "parent": "boy", "col": 2.0, "row": 1,
		"desc": "อัศวินแนวรับ ยืนหยัดเป็นกำแพงให้พวกพ้อง"},
	{"id": "vanguard", "name": "VANGUARD", "tier": "สายต่อยอด", "parent": "rampart_knight", "col": 2.0, "row": 2,
		"desc": "ทัพหน้าผู้ไม่ถอย ถือโล่ มีสกิล Hyper ตะโกนปล่อยคลื่นเสียงรอบตัว", "hyper": "vanguard", "shield": true},
	{"id": "gwen", "name": "GWEN", "tier": "ตัวละครเริ่มต้น", "character": "gwen", "parent": "", "col": 1.0, "row": 0, "weapon": "staff",
		"desc": "เพิ่งเรียนเวทบทแรก ถือคทาคู่ใจไปทุกที่"},
	{"id": "high_mage", "name": "HIGH MAGE", "tier": "สายแรก", "character": "gwen", "parent": "gwen", "col": 0.0, "row": 1, "weapon": "staff",
		"desc": "จอมเวทผู้ร่ำเรียนเวทหลากธาตุ"},
	{"id": "omni_prime", "staff_spiral": true, "name": "OMNI PRIME", "tier": "สายต่อยอด", "character": "gwen", "parent": "high_mage", "col": 0.0, "row": 2, "weapon": "staff", "book": true,
		"desc": "มีหนังสือเวทลอยตามตลอดเวลา สกิล Hyper เสกวงเวทสามธาตุพุ่งขึ้นฟ้า", "hyper": "omni"},
	{"id": "alchemic_mage", "name": "ALCHEMIC MAGE", "tier": "สายแรก", "character": "gwen", "parent": "gwen", "col": 1.0, "row": 1, "weapon": "staff",
		"desc": "จอมเวทผู้ปลุกพลังชีวิตจากเมล็ดพันธุ์"},
	{"id": "lord_essence", "staff_cube": true, "name": "LORD ESSENCE", "tier": "สายต่อยอด", "character": "gwen", "parent": "alchemic_mage", "col": 1.0, "row": 2, "weapon": "staff",
		"desc": "โยนเมล็ดขึ้นฟ้า สกิล Hyper ปลูกต้นไม้ทองใบหนาม แล้วระเบิด", "hyper": "essence"},
	{"id": "ore_magic", "name": "ORE MAGIC", "tier": "สายแรก", "character": "gwen", "parent": "gwen", "col": 2.0, "row": 1, "weapon": "staff",
		"desc": "จอมเวทผู้ปลุกพลังจากแร่และมิติ"},
	{"id": "dimension_strike", "staff_heart": true, "name": "DIMENSION STRIKE", "tier": "สายต่อยอด", "character": "gwen", "parent": "ore_magic", "col": 2.0, "row": 2, "weapon": "staff",
		"desc": "สกิล Hyper แปลงร่าง คทางอกปีก กดอีกครั้งยิงบีมสีชมพูม่วงครึ่งจอ", "hyper": "dimension"},
	{"id": "aid", "name": "AID", "tier": "ตัวละครเริ่มต้น", "character": "aid", "parent": "", "col": 1.0, "row": 0, "weapon": "drones", "drone": "rotor",
		"desc": "สั่งโดรนเรียวสามลำให้ลอยตามและพุ่งโจมตี"},
	{"id": "sync_core", "name": "SYNC CORE", "tier": "สายแรก", "character": "aid", "parent": "aid", "col": 0.0, "row": 1, "weapon": "drones", "drone": "rotor",
		"desc": "ซิงก์โดรนทั้งสามเข้ากับแกนกลางได้แม่นยำขึ้น"},
	{"id": "twin_node", "name": "TWIN NODE", "tier": "สายต่อยอด", "character": "aid", "parent": "sync_core", "col": 0.0, "row": 2, "weapon": "drones", "drone": "cube",
		"desc": "สกิล Hyper จิ้มจอ ปล่อยลูกบาศก์ขยายเป็นยักษ์ พลิกตัวไปมาอยู่ที่เดิม", "hyper": "twin"},
	{"id": "sync_time", "name": "SYNC TIME", "tier": "สายแรก", "character": "aid", "parent": "aid", "col": 1.0, "row": 1, "weapon": "drones", "drone": "rotor",
		"desc": "เริ่มซิงก์โดรนเข้ากับจังหวะของเวลา"},
	{"id": "psi_clock", "name": "PSI CLOCK", "tier": "สายต่อยอด", "character": "aid", "parent": "sync_time", "col": 1.0, "row": 2, "weapon": "drones", "drone": "blade",
		"desc": "สกิล Hyper เปิดรอยแยกเวลาด้านหลัง แล้วลอยถอยหลังเข้าไป", "hyper": "psi"},
	{"id": "sync_cure", "name": "SYNC CURE", "tier": "สายแรก", "character": "aid", "parent": "aid", "col": 2.0, "row": 1, "weapon": "drones", "drone": "rotor",
		"desc": "ซิงก์โดรนเข้ากับระบบเวชภัณฑ์"},
	{"id": "rogue_medic", "name": "ROGUE MEDIC", "tier": "สายต่อยอด", "character": "aid", "parent": "sync_cure", "col": 2.0, "row": 2, "weapon": "drones", "drone": "syringe",
		"desc": "โดรนเข็มฉีดยาน้ำยาม่วง สกิล Hyper เสกหน้าจอไฟฟ้ารอบตัว ปัดแล้วระเบิด", "hyper": "medic"},
]

static func find(id: String) -> Dictionary:
	for j in JOBS:
		if j["id"] == id:
			return j
	return {}

## สายนี้เป็นของตัวละครไหน สายรุ่นแรกไม่ได้ระบุคือ BOY
static func character_of(job: Dictionary) -> String:
	return str(job.get("character", "boy"))

static func has_hyper(id: String) -> bool:
	return find(id).has("hyper")

