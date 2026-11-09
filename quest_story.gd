class_name QuestStory
extends RefCounted
## เนื้อเรื่องและเควสทั้งเกม สร้างจากแบบตามเมือง 9 เมือง (เลเวล 1-99)
## main  เควสหลัก ต่อกันเป็นสายเดียวจากเมืองแรกถึงเมืองสุดท้าย เมืองละ 11 ขั้น
## side  เควสรอง เมืองละ 7 ขั้น รับจาก NPC ในเมือง ทำเมื่อไรก็ได้หลังมาถึงเมืองนั้น
## board เควสกระดาน เมืองละ 5 แบบ วันหนึ่งขึ้นกระดาน 3 แบบ ทำซ้ำได้ทุกวัน
##
## เควสหนึ่งข้อ {"id", "chain", "town", "level", "giver" (บทบาท NPC), "title", "text", "after" (เควสที่ต้องผ่านก่อน),
##   "goal": {"type": "talk" | "kill" | "clear" | "level", "role": บทบาท NPC ที่ต้องไปคุย, "town": เมืองของ NPC ปลายทาง,
##            "kind": หน้าตามอนที่ต้องปราบ ("" คือตัวไหนก็ได้), "n": จำนวน, "dungeon": ลำดับดัน, "lv": เลเวล},
##   "reward": {"k": สัดส่วน EXP ของเลเวลตอนส่ง, "title": ฉายา}}

const TOWN_COUNT := 9
const KINDS := ["cat_mochi", "cat_long", "cat_cyclops", "cat_box", "cat_ghost", "cat_puff"]
const ITEMS := ["ปลาทูตากแห้ง", "ลูกไหมพรมสีชมพู", "กระดิ่งทอง", "ขนมแมวเลีย", "จดหมายปิดผนึก", "ตะกร้าแคทนิป", "หมอนนุ่มนิ่ม", "ปลอกคอลายปลา", "กล่องกระดาษใบโปรด"]
const SIDE_ROLES := ["shop", "kid", "smith", "elder", "fisher", "chef", "mail"]
const SIDE_TITLES := [
	["ไหมพรมพันกัน", "ช่วยกันคลายปมไหมพรมที่ทำให้ลูกแมวในเมืองติดอยู่"],
	["ปลาทูหายไปไหน", "ปลาทูของร้านหายไปทั้งเข่ง ต้องมีคนแอบเอาไปแน่ๆ"],
	["งีบให้สบาย", "แมวเฒ่าอยากได้หมอนนุ่มๆ ไว้งีบตอนบ่าย"],
	["กระดิ่งของหนู", "ลูกแมวทำกระดิ่งหล่นหายตอนวิ่งเล่น"],
	["ส่งของด่วน", "ฝากของไปให้เพื่อนอีกฝั่งเมืองหน่อยนะเหมียว"],
	["ล้างแค้นให้หาง", "เจ้ามอนตัวนั้นเหยียบหางเรา! ไปสั่งสอนให้หน่อย"],
	["ฝึกซ้อมกล้ามเหมียว", "อยากเห็นแมวที่แข็งแรงพอจะปกป้องเมือง"],
]
const BOARD_TITLES := [
	["กวาดล้างประจำวัน", "ใบประกาศจากกิลด์: ช่วยลดจำนวนมอนรอบเมืองหน่อย"],
	["ล่าตัวป่วน", "มีมอนชนิดนี้ป่วนแถวนี้เยอะผิดปกติ"],
	["ตรวจดันเจี้ยน", "กิลด์อยากให้ไปเช็กว่าดันเจี้ยนยังปลอดภัย"],
	["ล่าระดับโหด", "เควสสำหรับแมวมือฉมัง ปราบมอนจำนวนมาก"],
	["ลาดตระเวนท้ายเมือง", "เดินตรวจดันเจี้ยนลึกสุดของเมืองแล้วกลับมารายงาน"],
]
const TOWN_STORY := [
	"กิลด์แมวอัศวินกำลังรับสมาชิกใหม่ ไหมพรมเด้งเริ่มบุกทุ่งหญ้า",
	"ตลาดปลาทูวุ่นวายเพราะปลาหายทุกคืน มีเงาประหลาดเดินอยู่ท้ายตลาด",
	"หมู่บ้านบนภูเขาลมแรง ปรมาจารย์แมวกำลังหาศิษย์ฝีมือดี",
	"ท่าเรือแมวน้ำถูกหุ่นดูดฝุ่นบุก เรือออกหาปลาไม่ได้เลย",
	"ทะเลทรายร้อนจนหนวดม้วน กองคาราวานแมวหายไประหว่างทาง",
	"หิมะตกไม่หยุด หมู่บ้านแมวหิมะกำลังจะหมดฟืนผิงไฟ",
	"ภูเขาไฟเริ่มคุกรุ่น เกาะแมวต้องการผู้กล้าไปปิดปากปล่อง",
	"ปราสาทเงาปกคลุมไปด้วยหมอก ราชาเงาหนูกำลังตื่นขึ้น",
	"สวรรค์แมวทองคือปลายทางของการเดินทาง ที่นั่นมีความลับของแมวทั้งหลาย",
]

static var _all: Array = []
static var _by_id: Dictionary = {}

static func all() -> Array:
	if _all.is_empty():
		_build()
	return _all

static func find(id: String) -> Dictionary:
	if _all.is_empty():
		_build()
	return _by_id.get(id, {})

static func _q(id: String, chain: String, town: int, level: int, giver: String, title: String, text: String, after: String, goal: Dictionary, k: float, honor := "") -> Dictionary:
	return {"id": id, "chain": chain, "town": town, "level": clampi(level, 1, LevelData.MAX_LEVEL), "giver": giver, "title": title, "text": text,
		"after": after, "goal": goal, "reward": {"k": k, "title": honor}}

static func _dname(town: int, i: int) -> String:
	return str(DungeonData.dungeon(town, i).get("name", "ดันเจี้ยน"))

static func _kname(kind: String) -> String:
	return str(CatLook.NAMES.get(kind, "มอน"))

static func _build() -> void:
	_all = []
	_by_id = {}
	var prev := ""
	for t in TOWN_COUNT:
		var r := DungeonData.town_levels(t)
		var lo := r.x
		var hi := r.y
		var n := DungeonData.dungeon_count(t)
		var tn := DungeonData.town_name(t)
		var kind: String = KINDS[(t + 1) % KINDS.size()]
		var item: String = ITEMS[t % ITEMS.size()]
		var lv := func(step: int) -> int: return lo + floori(float(hi - lo) * float(step) / 11.0)
		var dl := func(i: int) -> int: return DungeonData.dungeon_level(t, i)
		var steps := [
			_q("m%d_01" % t, "main", t, lv.call(0), "guild", "มาถึง%s" % tn, TOWN_STORY[t] + " หัวหน้ากิลด์ฝากจดหมายไปให้ผู้อาวุโสของเมือง",
				prev, {"type": "talk", "role": "elder", "town": t}, 0.3),
			_q("m%d_02" % t, "main", t, lv.call(1), "elder", "อุ่นเครื่องก่อนลุย", "ผู้อาวุโสอยากเห็นฝีมือ ปราบมอนในดันเจี้ยนรอบ%s" % tn,
				"m%d_01" % t, {"type": "kill", "kind": "", "n": 12 + t * 2, "town": t}, 0.3),
			_q("m%d_03" % t, "main", t, maxi(lv.call(2), dl.call(0)), "guild", "บุก%s" % _dname(t, 0), "ไปให้ถึงห้องบอสของ%s แล้วกลับมาเล่าให้ฟังนะเหมียว" % _dname(t, 0),
				"m%d_02" % t, {"type": "clear", "dungeon": 0, "town": t}, 0.4),
			_q("m%d_04" % t, "main", t, lv.call(3), "guild", "%sเยอะเกินไปแล้ว" % _kname(kind), "%sออกมาป่วนชาวเมือง ไปจัดการให้หน่อย" % _kname(kind),
				"m%d_03" % t, {"type": "kill", "kind": kind, "n": 8 + t, "town": t}, 0.35),
			_q("m%d_05" % t, "main", t, maxi(lv.call(4), dl.call(1)), "elder", "เสียงประหลาดจาก%s" % _dname(t, 1), "มีคนได้ยินเสียงดังจาก%s ไปสำรวจให้ที" % _dname(t, 1),
				"m%d_04" % t, {"type": "clear", "dungeon": 1, "town": t}, 0.4),
			_q("m%d_06" % t, "main", t, lv.call(5), "elder", "ฝาก%sหน่อย" % item, "เอา%sไปให้ช่างตีเหล็กแมว เขาจะช่วยเตรียมของให้" % item,
				"m%d_05" % t, {"type": "talk", "role": "smith", "town": t}, 0.3),
			_q("m%d_07" % t, "main", t, lv.call(6), "smith", "แข็งแกร่งขึ้นอีกนิด", "ช่างบอกว่าอาวุธดีต้องคู่กับแมวที่เก่ง ฝึกให้ถึงเลเวล %d ก่อนนะ" % lv.call(7),
				"m%d_06" % t, {"type": "level", "lv": lv.call(7)}, 0.3),
			_q("m%d_08" % t, "main", t, maxi(lv.call(7), dl.call(floori(float(n) * 0.5))), "guild", "ลึกเข้าไปใน%s" % _dname(t, floori(float(n) * 0.5)), "ร่องรอยของเจ้าตัวการนำไปสู่%s" % _dname(t, floori(float(n) * 0.5)),
				"m%d_07" % t, {"type": "clear", "dungeon": floori(float(n) * 0.5), "town": t}, 0.45),
			_q("m%d_09" % t, "main", t, maxi(lv.call(8), dl.call(n - 2)), "guild", "ประตูสุดท้าย", "ผ่าน%sให้ได้ ทางไปหาหัวหน้าใหญ่จะเปิด" % _dname(t, n - 2),
				"m%d_08" % t, {"type": "clear", "dungeon": n - 2, "town": t}, 0.5),
			_q("m%d_10" % t, "main", t, maxi(lv.call(9), dl.call(n - 1)), "elder", "หัวหน้าใหญ่แห่ง%s" % tn, "ทุกอย่างมาจาก%s ไปปราบบอสให้เมืองกลับมาสงบ" % _dname(t, n - 1),
				"m%d_09" % t, {"type": "clear", "dungeon": n - 1, "town": t}, 0.7, "ผู้พิทักษ์%s" % tn),
		]
		if t < TOWN_COUNT - 1:
			steps.append(_q("m%d_11" % t, "main", t, lv.call(10), "guild", "เดินทางสู่%s" % DungeonData.town_name(t + 1),
				"เมืองสงบแล้ว แต่มีข่าวร้ายจาก%s ถือจดหมายไปหาหัวหน้ากิลด์ที่นั่น" % DungeonData.town_name(t + 1),
				"m%d_10" % t, {"type": "talk", "role": "guild", "town": t + 1}, 0.4))
		else:
			steps.append(_q("m%d_11" % t, "main", t, LevelData.MAX_LEVEL, "elder", "ตำนานแมวทอง", "แมวที่ไปถึงเลเวลสูงสุดเท่านั้นจะได้รับฉายาในตำนาน",
				"m%d_10" % t, {"type": "level", "lv": LevelData.MAX_LEVEL}, 0.0, "ตำนานแมวทอง"))
		for s in steps:
			_add(s)
		prev = str((steps[steps.size() - 1] as Dictionary)["id"])
		# เควสรอง
		for k in 7:
			var role: String = SIDE_ROLES[k % SIDE_ROLES.size()]
			var tt: Array = SIDE_TITLES[k]
			var slv := lo + floori(float(hi - lo) * float(k) / 7.0)
			var goal: Dictionary
			var text := str(tt[1])
			match k:
				0, 5:
					var kk: String = KINDS[(t + k) % KINDS.size()]
					goal = {"type": "kill", "kind": kk, "n": 6 + t + k, "town": t}
					text += " (ปราบ%s)" % _kname(kk)
				1, 3:
					var di := (k + t) % n
					goal = {"type": "clear", "dungeon": di, "town": t}
					slv = maxi(slv, DungeonData.dungeon_level(t, di))
					text += " (ผ่าน%s)" % _dname(t, di)
				2, 4:
					var to: String = SIDE_ROLES[(k + 2) % SIDE_ROLES.size()]
					goal = {"type": "talk", "role": to, "town": t}
					text += " (เอา%sไปส่ง)" % ITEMS[(t + k) % ITEMS.size()]
				_:
					goal = {"type": "kill", "kind": "", "n": 25 + t * 3, "town": t}
			_add(_q("s%d_%d" % [t, k + 1], "side", t, slv, role, str(tt[0]), text, "m%d_01" % t, goal, 0.25))
		# เควสกระดาน ทำซ้ำได้
		for k in BOARD_TITLES.size():
			var bt: Array = BOARD_TITLES[k]
			var goal: Dictionary
			var text := str(bt[1])
			match k:
				0:
					goal = {"type": "kill", "kind": "", "n": 20 + t * 2, "town": t}
				1:
					var kk: String = KINDS[(t + 3) % KINDS.size()]
					goal = {"type": "kill", "kind": kk, "n": 10 + t, "town": t}
					text += " (%s)" % _kname(kk)
				2:
					goal = {"type": "clear", "dungeon": -1, "town": t}
					text += " (ผ่านดันเจี้ยนไหนก็ได้ของเมืองนี้)"
				3:
					goal = {"type": "kill", "kind": "", "n": 45 + t * 4, "town": t}
				_:
					goal = {"type": "clear", "dungeon": n - 1, "town": t}
					text += " (%s)" % _dname(t, n - 1)
			_add(_q("b%d_%d" % [t, k + 1], "board", t, lo, "", str(bt[0]), text, "m%d_01" % t, goal, 0.12))

static func _add(q: Dictionary) -> void:
	_all.append(q)
	_by_id[str(q["id"])] = q
