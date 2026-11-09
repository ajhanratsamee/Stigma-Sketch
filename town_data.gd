class_name TownData
## ข้อมูลเมืองทั้ง 9 เมือง (เลเวล 1-99) ฉาก NPC กระดานเควส ตู้จดหมาย ทางวาร์ป
## โครงข้อมูลกลาง ใช้ร่วมกันระหว่าง town_page.gd (วาดฉาก/เดิน/คุย) กับ quest_data.gd (เควส/จดหมาย)
##
## TOWNS[i] = {
##   "name": String,                  # ตรงกับ DungeonData.TOWN_NAMES[i]
##   "style": String,                 # รูปแบบฉาก: "street" ถนนตรง | "curve" พื้นโค้งเหมือนเดินรอบดาวเล็ก
##                                    #   | "floors" หลายชั้นมีวาปขึ้นลง | "underground" เมืองใต้ดิน | "sky" เกาะลอยบนฟ้า
##                                    #   | "harbor" ท่าเรือ | "snow" | "desert" | "lava" | ...
##   "palette": {"sky": Color, "ground": Color, "wall": Color, "roof": Color, "accent": Color},
##   "half": float,                   # ความยาวครึ่งหนึ่งของแต่ละชั้น หน่วยเกม
##   "floors": [ {"name": String, "y": float, "half": float, "deco": String}, ... ],   # ชั้นที่ 0 คือชั้นหลัก
##   "warps": [ {"from": int ชั้น, "x": float, "to": int ชั้น, "to_x": float, "kind": "door"|"ladder"|"pad"|"cloud"|"pipe"}, ... ],
##   "npcs": [ {"id": String (ไม่ซ้ำทั้งเกม), "name": String, "role": String (เช่น "guild" "shop" "elder" "kid" "mail" "board" "smith"),
##              "floor": int, "x": float, "look": {"fur": Color, "stripe": Color, "ears": float, "hat": String, "size": float},
##              "lines": [String, ...] (พูดทั่วไป สุ่ม)}, ... ],
##   "board": {"floor": int, "x": float},     # กระดานเควส
##   "mailbox": {"floor": int, "x": float},   # ตู้จดหมาย
##   "dungeon_gate": {"floor": int, "x": float},
## }
##
## สัญญาระหว่างไฟล์ (ห้ามเปลี่ยนชื่อ):
##   QuestData.talk(npc_id: String, entry: Dictionary) -> Dictionary   # {"lines": [String], "offer": quest_id or "", "turn_in": quest_id or ""}
##   QuestData.accept(entry, quest_id) / QuestData.turn_in(entry, quest_id) -> Dictionary (รางวัล)
##   QuestData.on_kill(entry, town, monster_kind) / on_clear(entry, town, dungeon_index) / on_talk(entry, npc_id) / on_level(entry, level)
##   QuestData.board_quests(entry, town) -> Array   # เควสบนกระดานของเมืองนี้
##   QuestData.mail(entry) -> Array                 # จดหมายในตู้ [{"id","from","title","text","quest","reward","read"}]
##   QuestPanel.open_log() / open_board(town) / open_mail()   # แผง UI
##   TownData.town(i) -> Dictionary ; TownData.npc(id) -> Dictionary (มี "town" ด้วย)

const TOWNS := [
	{
		"name": "เมืองอัศวินเหมียว",
		"style": "street",
		"palette": {"sky": Color(0.75, 0.88, 1.00), "ground": Color(0.86, 0.78, 0.62), "wall": Color(0.99, 0.93, 0.82), "roof": Color(0.95, 0.60, 0.35), "accent": Color(0.90, 0.45, 0.50)},
		"half": 40.0,
		"floors": [
			{"name": "ถนนหลัก", "y": 0.0, "half": 40.0, "deco": "houses"},
		],
		"warps": [
		],
		"npcs": [
			{"id": "t0_guild", "name": "หัวหน้ากิลด์เหมียว", "role": "guild", "floor": 0, "x": -33.0, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "helm", "size": 1.10}, "lines": ["ยินดีต้อนรับสู่เมืองอัศวินเหมียว!", "อัศวินหน้าใหม่ต้องเริ่มจากเควสบนกระดานนะ", "ถ้าเก่งพอ เดี๋ยวกิลด์มีงานใหญ่ให้"]},
			{"id": "t0_baker", "name": "ป้าขนมปังนุ่ม", "role": "shop", "floor": 0, "x": -27.5, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.45, "hat": "chef", "size": 1.00}, "lines": ["ขนมปังรูปปลาเพิ่งออกจากเตาจ้า", "หิวก็แวะมานะ ไม่ต้องเกรงใจ"]},
			{"id": "t0_smith", "name": "ลุงตีดาบหนวดฟู", "role": "smith", "floor": 0, "x": -22.0, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.40, "hat": "bandana", "size": 1.20}, "lines": ["ดาบดีต้องตีด้วยใจ... กับอุ้งเท้า", "ร้อนจัง แต่หนวดยังสวยอยู่"]},
			{"id": "t0_guard", "name": "ยามประตูขี้ง่วง", "role": "guard", "floor": 0, "x": -16.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.50, "hat": "helm", "size": 1.10}, "lines": ["ฟ้าว... อ๊ะ ไม่ได้หลับนะ!", "ข้างนอกมีไหมพรมเด้งเยอะ ระวังด้วย"]},
			{"id": "t0_kid1", "name": "เจ้าเหมียวจิ๋ว", "role": "kid", "floor": 0, "x": -11.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["พี่ๆ เล่นไล่จับกันไหม", "โตขึ้นหนูจะเป็นอัศวิน!", "เหมียว เหมียว เหมียว~"]},
			{"id": "t0_kid2", "name": "มินิส้มซน", "role": "kid", "floor": 0, "x": -5.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "beanie", "size": 0.80}, "lines": ["หนูหาไหมพรมสีชมพูไม่เจอ", "แอบกินขนมของแม่ไปชิ้นนึง ชู่ว"]},
			{"id": "t0_elder", "name": "คุณยายเล่านิทาน", "role": "elder", "floor": 0, "x": 0.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.40, "hat": "flower", "size": 0.95}, "lines": ["สมัยยายยังสาว แมวทุกตัวต้องหัดกระโดดกำแพง", "หนูๆ อยากฟังนิทานราชาไหมพรมไหม"]},
			{"id": "t0_florist", "name": "สาวร้านดอกไม้", "role": "shop", "floor": 0, "x": 10.5, "look": {"fur": Color(0.98, 0.78, 0.85), "stripe": Color(0.90, 0.55, 0.65), "ears": 0.50, "hat": "flower", "size": 0.95}, "lines": ["ดอกแคทนิปหอมๆ จ้า", "ดอกไม้สีฟ้าเหมาะกับเธอนะ"]},
			{"id": "t0_mail", "name": "บุรุษไปรษณีย์ตีนไว", "role": "mail", "floor": 0, "x": 13.5, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["มีจดหมายมาส่งจ้า!", "วิ่งทั้งวันอุ้งเท้าพองแล้ว"]},
			{"id": "t0_trainer", "name": "ครูฝึกดาบแมวส้ม", "role": "trainer", "floor": 0, "x": 16.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "bandana", "size": 1.10}, "lines": ["ฟันให้เร็ว หลบให้ไว แล้วนอนให้พอ", "ลองคอมโบ z z z ดูสิ"]},
			{"id": "t0_musician", "name": "นักดนตรีเหมียวเหมียว", "role": "musician", "floor": 0, "x": 22.0, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.55, "hat": "straw", "size": 1.00}, "lines": ["เพลงนี้ชื่อ เหมียวในคืนจันทร์~", "ฟังแล้วอยากนอนกลางวันใช่ไหมล่ะ"]},
			{"id": "t0_knight", "name": "อัศวินฝึกหัดขี้อาย", "role": "knight", "floor": 0, "x": 27.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.45, "hat": "helm", "size": 1.00}, "lines": ["ข-ขอโทษที่ขวางทางนะ", "วันนี้ผมจะไม่หนีไหมพรมแล้ว!"]},
			{"id": "t0_cafe", "name": "เจ้าของคาเฟ่นมอุ่น", "role": "shop", "floor": 0, "x": 31.5, "look": {"fur": Color(0.97, 0.85, 0.70), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["นมอุ่นๆ ช่วยให้หลับสบาย", "ร้านเปิดตลอดจนกว่าแมวจะง่วง"]},
		],
		"board": {"floor": 0, "x": 4.0},
		"mailbox": {"floor": 0, "x": 8.0},
		"dungeon_gate": {"floor": 0, "x": 34.0},
	},
	{
		"name": "เมืองตลาดปลาทู",
		"style": "curve",
		"palette": {"sky": Color(0.82, 0.92, 1.00), "ground": Color(0.78, 0.86, 0.66), "wall": Color(0.98, 0.88, 0.78), "roof": Color(0.40, 0.60, 0.85), "accent": Color(0.98, 0.70, 0.30)},
		"half": 36.0,
		"floors": [
			{"name": "ลานตลาดวงกลม", "y": 0.0, "half": 36.0, "deco": "stalls"},
			{"name": "หอนาฬิกาปลาทู", "y": 8.0, "half": 12.0, "deco": "tower_top"},
		],
		"warps": [
			{"from": 0, "x": -2.0, "to": 1, "to_x": 0.0, "kind": "ladder"},
			{"from": 1, "x": 0.0, "to": 0, "to_x": -2.0, "kind": "ladder"},
		],
		"npcs": [
			{"id": "t1_guild", "name": "ผู้ดูแลกิลด์ตลาด", "role": "guild", "floor": 0, "x": 3.0, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "helm", "size": 1.10}, "lines": ["ตลาดนี้กลมเหมือนลูกบอล เดินไปเรื่อยๆ จะวนกลับมาที่เดิม", "เควสปลดคลาสอยู่ที่นี่นะ เลเวล 15 แล้วมาหาฉัน"]},
			{"id": "t1_fishmonger", "name": "แม่ค้าปลาทูเสียงดัง", "role": "shop", "floor": 0, "x": -4.0, "look": {"fur": Color(0.97, 0.85, 0.70), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.45, "hat": "bandana", "size": 1.05}, "lines": ["ปลาทูสดๆ จ้า สดกว่านี้ต้องว่ายเอง!", "ซื้อสองตัว แถมหางปลาหนึ่งชิ้น"]},
			{"id": "t1_grill", "name": "พ่อค้าปลาย่างควันฉุย", "role": "chef", "floor": 0, "x": -12.0, "look": {"fur": Color(0.70, 0.50, 0.35), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "chef", "size": 1.15}, "lines": ["กลิ่นปลาย่างลอยไปถึงหอนาฬิกาเลย", "ย่างไหม้นิดๆ อร่อยกว่า เชื่อลุง"]},
			{"id": "t1_clock", "name": "ช่างซ่อมนาฬิกาตาโต", "role": "scholar", "floor": 1, "x": 4.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "goggles", "size": 0.95}, "lines": ["นาฬิกาเดินช้าไปสามนาทีแมว", "ข้างบนนี้เห็นตลาดโค้งเป็นวงกลมสวยมาก"]},
			{"id": "t1_juggler", "name": "นักโยนลูกบอลไหมพรม", "role": "musician", "floor": 0, "x": 14.0, "look": {"fur": Color(0.98, 0.78, 0.85), "stripe": Color(0.90, 0.55, 0.65), "ears": 0.55, "hat": "straw", "size": 1.00}, "lines": ["หนึ่ง สอง สาม... ไหมพรมพันหางอีกแล้ว", "ปรบมือหน่อยสิ~"]},
			{"id": "t1_kid1", "name": "เด็กขายพวงมาลัยปลา", "role": "kid", "floor": 0, "x": 9.0, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "flower", "size": 0.80}, "lines": ["พวงมาลัยปลาหอมๆ ห้าเหรียญจ้า", "หนูเก็บเงินซื้อกระดิ่งใหม่"]},
			{"id": "t1_kid2", "name": "ฝาแฝดเหมียวซ้าย", "role": "kid", "floor": 0, "x": -20.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["น้องหายไปไหนอีกแล้วเนี่ย", "เราเหมือนกันทุกอย่าง ยกเว้นความซน"]},
			{"id": "t1_kid3", "name": "ฝาแฝดเหมียวขวา", "role": "kid", "floor": 0, "x": 20.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.15, 0.14, 0.16), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["พี่ตามหาอยู่เหรอ ชู่ว อย่าบอกนะ", "แอบมาซื้อขนมปลาดิบ"]},
			{"id": "t1_elder", "name": "คุณตาขายพัดลายปลา", "role": "elder", "floor": 0, "x": -28.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.40, "hat": "straw", "size": 0.95}, "lines": ["อากาศร้อนต้องมีพัด", "ตลาดนี้อยู่มาร้อยปีแมวแล้ว"]},
			{"id": "t1_traveler", "name": "นักเดินทางเป้หนัก", "role": "traveler", "floor": 0, "x": 26.0, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "beanie", "size": 1.10}, "lines": ["ผมเดินรอบตลาดสามรอบแล้ว ยังหาทางออกไม่เจอ", "ได้ข่าวว่าบนภูเขามีหมู่บ้านใต้ดินด้วยนะ"]},
			{"id": "t1_mail", "name": "ไปรษณีย์ปั่นจักรยาน", "role": "mail", "floor": 0, "x": -10.0, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["ตลาดโค้งแบบนี้ปั่นสนุกมาก!", "จดหมายด่วนจ้า"]},
			{"id": "t1_priest", "name": "หลวงเหมียวใจดี", "role": "priest", "floor": 1, "x": -6.0, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.45, "hat": "none", "size": 1.05}, "lines": ["ขอให้ปลาทูมีทุกมื้อ", "ทำดีแล้วจะได้นอนตรงแดด"]},
			{"id": "t1_guard", "name": "ยามตลาดตาคม", "role": "guard", "floor": 0, "x": 30.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.45, "hat": "helm", "size": 1.15}, "lines": ["ห้ามขโมยปลาเด็ดขาด!", "ข้างนอกมีแตงกวาตกใจเพียบ"]},
			{"id": "t1_spice", "name": "แม่มดขายเครื่องเทศ", "role": "shop", "floor": 0, "x": 18.0, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.50, "hat": "witch", "size": 1.00}, "lines": ["ผงแคทนิปพิเศษ โรยแล้วกระโดดสูงขึ้น", "หึๆ อย่ากินเยอะล่ะ"]},
		],
		"board": {"floor": 0, "x": 6.0},
		"mailbox": {"floor": 0, "x": -8.0},
		"dungeon_gate": {"floor": 0, "x": 32.0},
	},
	{
		"name": "หมู่บ้านแมวภูเขา",
		"style": "underground",
		"palette": {"sky": Color(0.78, 0.86, 0.98), "ground": Color(0.62, 0.58, 0.52), "wall": Color(0.92, 0.86, 0.76), "roof": Color(0.55, 0.70, 0.45), "accent": Color(0.60, 0.85, 0.95)},
		"half": 30.0,
		"floors": [
			{"name": "หมู่บ้านบนไหล่เขา", "y": 0.0, "half": 30.0, "deco": "chalets"},
			{"name": "เหมืองแร่หอมปลา", "y": -8.0, "half": 26.0, "deco": "mine"},
			{"name": "ถ้ำคริสตัลหลับ", "y": -16.0, "half": 20.0, "deco": "crystals"},
		],
		"warps": [
			{"from": 0, "x": 12.0, "to": 1, "to_x": 12.0, "kind": "pipe"},
			{"from": 1, "x": 12.0, "to": 0, "to_x": 12.0, "kind": "pipe"},
			{"from": 1, "x": -14.0, "to": 2, "to_x": -10.0, "kind": "ladder"},
			{"from": 2, "x": -10.0, "to": 1, "to_x": -14.0, "kind": "ladder"},
		],
		"npcs": [
			{"id": "t2_master", "name": "ปรมาจารย์แมวภูเขา", "role": "master", "floor": 0, "x": -21.5, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.40, "hat": "none", "size": 1.20}, "lines": ["ฝึกหนักแล้วต้องพักกลางแดดให้พอ", "เลเวล 35 แล้วมาหาข้า จะสอนวิชาขั้นสูง"]},
			{"id": "t2_miner", "name": "หัวหน้าคนงานเหมือง", "role": "smith", "floor": 1, "x": -17.5, "look": {"fur": Color(0.50, 0.35, 0.28), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.40, "hat": "goggles", "size": 1.20}, "lines": ["ในเหมืองมีแร่กลิ่นปลา หายากมาก", "ระวังหัวโขกเพดานนะ"]},
			{"id": "t2_miner2", "name": "คนงานเหมืองหน้ามอม", "role": "worker", "floor": 1, "x": -9.0, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "helm", "size": 1.05}, "lines": ["ขุดทั้งวันได้หินมาหนึ่งก้อน", "หินก้อนนี้เหมือนหน้าแมวเลย"]},
			{"id": "t2_crystal", "name": "นักวิจัยคริสตัลหลับ", "role": "scholar", "floor": 2, "x": -12.5, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "goggles", "size": 0.95}, "lines": ["คริสตัลพวกนี้ส่งเสียงกรนเบาๆ", "ถ้าแตะแรงไปมันจะตื่นนะ"]},
			{"id": "t2_cheese", "name": "ร้านชีสภูเขา", "role": "shop", "floor": 0, "x": -13.0, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["ชีสบ่มในถ้ำ หอมมาก", "แมวกินชีสได้นิดหน่อยนะ"]},
			{"id": "t2_goat", "name": "คนเลี้ยงแพะขี้เล่น", "role": "farmer", "floor": 0, "x": -6.5, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "straw", "size": 1.00}, "lines": ["แพะชอบมาเลียหูฉัน", "บนเขาลมแรง ถือหางไว้ดีๆ"]},
			{"id": "t2_kid1", "name": "เด็กปีนเขาขาสั้น", "role": "kid", "floor": 2, "x": 0.0, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "beanie", "size": 0.80}, "lines": ["หนูปีนถึงหลังคาแล้ว!", "ลงไม่ได้... ช่วยด้วย"]},
			{"id": "t2_kid2", "name": "เหมียวจิ๋วถือตะเกียง", "role": "kid", "floor": 1, "x": 0.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["มืดจัง แต่หนูไม่กลัว", "ตะเกียงอันนี้พ่อให้มา"]},
			{"id": "t2_elder", "name": "ปู่ผู้เฝ้าทางลงถ้ำ", "role": "elder", "floor": 1, "x": 9.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.40, "hat": "bandana", "size": 0.95}, "lines": ["ทางลงเหมืองอยู่ตรงท่อนั่นแหละ", "ข้างล่างสุดมีถ้ำคริสตัล อย่าส่งเสียงดัง"]},
			{"id": "t2_yodel", "name": "นักร้องโยเดลเหมียว", "role": "musician", "floor": 0, "x": 6.5, "look": {"fur": Color(0.92, 0.50, 0.42), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "straw", "size": 1.05}, "lines": ["เหมียว~ โอ~ เล~ อี~", "เสียงสะท้อนกลับมาเป็นเหมียวสามตัว"]},
			{"id": "t2_mail", "name": "ไปรษณีย์ไต่เขา", "role": "mail", "floor": 0, "x": 14.5, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["ส่งจดหมายบนเขาต้องใช้เชือก", "จดหมายเปียกหิมะนิดหน่อยนะ"]},
			{"id": "t2_guard", "name": "ยามประตูเหมือง", "role": "guard", "floor": 1, "x": 17.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.45, "hat": "helm", "size": 1.15}, "lines": ["เหมืองชั้นลึกมีแต่ของอันตราย", "ถ้าแข็งแรงพอ เชิญผ่านไปได้"]},
			{"id": "t2_healer", "name": "หมอแมวสมุนไพร", "role": "priest", "floor": 0, "x": 21.5, "look": {"fur": Color(0.70, 0.90, 0.80), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "flower", "size": 0.95}, "lines": ["ชาสมุนไพรภูเขาแก้เหนื่อย", "อย่าลืมนอนกลางวันนะ"]},
			{"id": "t2_bat", "name": "ค้างคาวเพื่อนแมว", "role": "friend", "floor": 2, "x": 10.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.70, "hat": "none", "size": 0.85}, "lines": ["อี๊ด อี๊ด หมายถึงสวัสดี", "ฉันห้อยหัวนอน เธอขดตัวนอน เท่ากัน"]},
		],
		"board": {"floor": 0, "x": -4.0},
		"mailbox": {"floor": 0, "x": 4.0},
		"dungeon_gate": {"floor": 1, "x": 22.0},
	},
	{
		"name": "ท่าเรือแมวน้ำ",
		"style": "harbor",
		"palette": {"sky": Color(0.72, 0.88, 0.98), "ground": Color(0.82, 0.74, 0.60), "wall": Color(0.95, 0.95, 0.98), "roof": Color(0.30, 0.55, 0.80), "accent": Color(0.95, 0.50, 0.40)},
		"half": 34.0,
		"floors": [
			{"name": "ถนนท่าเรือ", "y": 0.0, "half": 34.0, "deco": "docks"},
			{"name": "ดาดฟ้าเรือแมวน้ำ", "y": 4.0, "half": 16.0, "deco": "ship_deck"},
		],
		"warps": [
			{"from": 0, "x": 24.0, "to": 1, "to_x": -12.0, "kind": "boat"},
			{"from": 1, "x": -12.0, "to": 0, "to_x": 24.0, "kind": "boat"},
		],
		"npcs": [
			{"id": "t3_captain", "name": "กัปตันแมวน้ำหนวดเฟื้อย", "role": "captain", "floor": 1, "x": -9.5, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.40, "hat": "crown", "size": 1.25}, "lines": ["ขึ้นเรือมาเลย เดี๋ยวพาชมทะเล", "ลมดี คลื่นดี ปลาเยอะ!"]},
			{"id": "t3_guild", "name": "กิลด์นักเดินเรือ", "role": "guild", "floor": 0, "x": -26.5, "look": {"fur": Color(0.70, 0.50, 0.35), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "bandana", "size": 1.10}, "lines": ["เควสที่ท่าเรือส่วนใหญ่เกี่ยวกับปลา", "จับปลาได้ก็มาส่งที่นี่"]},
			{"id": "t3_fisher", "name": "คุณลุงตกปลาเงียบ", "role": "fisher", "floor": 0, "x": -20.0, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.45, "hat": "straw", "size": 1.00}, "lines": ["...", "ชู่ว ปลากำลังจะกินเหยื่อ"]},
			{"id": "t3_fisher2", "name": "สาวตกปลาโชคดี", "role": "fisher", "floor": 0, "x": -13.5, "look": {"fur": Color(0.98, 0.78, 0.85), "stripe": Color(0.90, 0.55, 0.65), "ears": 0.50, "hat": "straw", "size": 0.95}, "lines": ["วันนี้ได้ปลาสามตัวแล้ว!", "ลุงข้างๆ ยังไม่ได้สักตัวเลย คิกๆ"]},
			{"id": "t3_seal", "name": "แมวน้ำตัวจริงมาเที่ยว", "role": "friend", "floor": 0, "x": -6.5, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.30, "hat": "none", "size": 1.15}, "lines": ["อ๊าวๆ (แปลว่า ขอปลาหน่อย)", "ฉันไม่ใช่แมว แต่ชื่อเหมือนกันนะ"]},
			{"id": "t3_sushi", "name": "เชฟซูชิปลาหน้าบาน", "role": "chef", "floor": 1, "x": -6.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["ซูชิหน้าปลาทูน่าคำโต", "ข้าวต้องปั้นเบาๆ เหมือนลูบหัวแมว"]},
			{"id": "t3_sailor", "name": "กะลาสีหางคด", "role": "sailor", "floor": 1, "x": -2.0, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.50, "hat": "beanie", "size": 1.05}, "lines": ["ผูกเชือกเป็นรูปปลาได้นะ", "ทะเลเมาเรือ แต่ฉันเมาแคทนิป"]},
			{"id": "t3_lighthouse", "name": "ผู้เฝ้าประภาคาร", "role": "elder", "floor": 0, "x": 0.5, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.45, "hat": "beanie", "size": 0.95}, "lines": ["ไฟประภาคารต้องสว่างทุกคืน", "บางคืนเห็นเงาปลาวาฬยักษ์ด้วยนะ"]},
			{"id": "t3_kid1", "name": "เด็กเก็บเปลือกหอย", "role": "kid", "floor": 0, "x": 8.5, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["เปลือกหอยอันนี้ได้ยินเสียงเหมียว!", "หนูจะทำสร้อยให้แม่"]},
			{"id": "t3_kid2", "name": "เหมียวจิ๋วกลัวน้ำ", "role": "kid", "floor": 0, "x": 13.5, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.60, "hat": "beanie", "size": 0.80}, "lines": ["น้ำเปียก ไม่ชอบเลย", "แต่ปลาอร่อยนะ..."]},
			{"id": "t3_merchant", "name": "พ่อค้าข้ามทะเล", "role": "shop", "floor": 1, "x": 2.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "goggles", "size": 1.10}, "lines": ["ของจากเมืองไกลจ้า ตุ๊กตาไหมพรมรุ่นหายาก", "ราคาคุยกันได้ แต่ห้ามต่อด้วยการอ้อน"]},
			{"id": "t3_mail", "name": "ไปรษณีย์นกนางนวลแมว", "role": "mail", "floor": 0, "x": 20.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["จดหมายมาทางเรือจ้า", "มีกลิ่นทะเลนิดหน่อยนะ"]},
			{"id": "t3_guard", "name": "ยามท่าเรือตัวโต", "role": "guard", "floor": 1, "x": 6.0, "look": {"fur": Color(0.50, 0.35, 0.28), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "helm", "size": 1.25}, "lines": ["ทางนี้ไปดันเจี้ยนริมทะเล", "ระวังปลาปักเป้าลอยมานะ"]},
			{"id": "t3_singer", "name": "นักร้องท่าเรือเสียงหวาน", "role": "musician", "floor": 0, "x": 26.5, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.90, 0.55, 0.65), "ears": 0.55, "hat": "flower", "size": 1.00}, "lines": ["เพลงกล่อมคลื่น ฟังแล้วง่วง", "ทะเลสีฟ้า เหมือนตาเธอเลย~"]},
			{"id": "t3_diver", "name": "นักดำน้ำแว่นโต", "role": "traveler", "floor": 1, "x": 10.0, "look": {"fur": Color(0.70, 0.90, 0.80), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "goggles", "size": 1.00}, "lines": ["ใต้ทะเลมีเมืองปลาด้วยนะ", "ฉันกลั้นหายใจได้ห้าวินาทีแมว!"]},
		],
		"board": {"floor": 0, "x": -2.0},
		"mailbox": {"floor": 0, "x": 6.0},
		"dungeon_gate": {"floor": 0, "x": -30.0},
	},
	{
		"name": "เมืองแมวทะเลทราย",
		"style": "desert",
		"palette": {"sky": Color(0.98, 0.88, 0.70), "ground": Color(0.95, 0.82, 0.56), "wall": Color(0.97, 0.86, 0.68), "roof": Color(0.85, 0.55, 0.35), "accent": Color(0.30, 0.70, 0.65)},
		"half": 34.0,
		"floors": [
			{"name": "ตลาดเนินทราย", "y": 0.0, "half": 34.0, "deco": "tents"},
			{"name": "โอเอซิสใต้ทราย", "y": -8.0, "half": 24.0, "deco": "oasis"},
		],
		"warps": [
			{"from": 0, "x": -16.0, "to": 1, "to_x": -16.0, "kind": "pipe"},
			{"from": 1, "x": -16.0, "to": 0, "to_x": -16.0, "kind": "pipe"},
			{"from": 0, "x": 18.0, "to": 1, "to_x": 16.0, "kind": "ladder"},
			{"from": 1, "x": 16.0, "to": 0, "to_x": 18.0, "kind": "ladder"},
		],
		"npcs": [
			{"id": "t4_sultan", "name": "สุลต่านเหมียวทอง", "role": "noble", "floor": 1, "x": -18.5, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.45, "hat": "crown", "size": 1.25}, "lines": ["ยินดีต้อนรับสู่โอเอซิสลับของเรา", "น้ำเย็นๆ ที่นี่ดีที่สุดในทะเลทราย"]},
			{"id": "t4_guild", "name": "กิลด์นักล่าทะเลทราย", "role": "guild", "floor": 0, "x": -26.0, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "bandana", "size": 1.10}, "lines": ["กลางวันร้อน กลางคืนหนาว แมวต้องปรับตัว", "เควสที่นี่ต้องอึดหน่อยนะ"]},
			{"id": "t4_camel", "name": "คนเลี้ยงอูฐหูยาว", "role": "farmer", "floor": 0, "x": -19.0, "look": {"fur": Color(0.70, 0.50, 0.35), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.60, "hat": "bandana", "size": 1.05}, "lines": ["อูฐเดินช้าแต่ไม่เคยบ่น", "นั่งบนโหนกอูฐอุ่นดีนะ"]},
			{"id": "t4_rug", "name": "พ่อค้าพรมบิน", "role": "shop", "floor": 0, "x": -11.0, "look": {"fur": Color(0.92, 0.50, 0.42), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "bandana", "size": 1.00}, "lines": ["พรมนี้บินได้... ถ้าเธอเชื่อ", "พรมลายปลา ลดราคาวันนี้!"]},
			{"id": "t4_potter", "name": "ช่างปั้นโอ่งดินเผา", "role": "smith", "floor": 0, "x": -3.5, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.45, "hat": "straw", "size": 1.05}, "lines": ["โอ่งใบนี้แมวนอนได้สามตัว", "ปั้นโค้งๆ เหมือนแมวขดตัว"]},
			{"id": "t4_diviner", "name": "หมอดูลูกแก้วทราย", "role": "scholar", "floor": 1, "x": -11.5, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.50, "hat": "witch", "size": 0.95}, "lines": ["ลูกแก้วบอกว่าเธอจะได้ปลาตัวโต", "ชะตาเธอ... หิวตอนบ่ายสาม"]},
			{"id": "t4_kid1", "name": "เด็กปั้นปราสาททราย", "role": "kid", "floor": 1, "x": -5.5, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "straw", "size": 0.80}, "lines": ["ปราสาททรายของหนูมีหอคอยแมว", "ลมพัดพังอีกแล้ว!"]},
			{"id": "t4_kid2", "name": "เหมียวจิ๋วขี่แมงป่องไม้", "role": "kid", "floor": 0, "x": 4.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["แมงป่องไม้ตัวนี้ชื่อปุยฝ้าย", "ไม่ต่อยนะ มันเป็นของเล่น"]},
			{"id": "t4_dancer", "name": "นักเต้นทะเลทราย", "role": "musician", "floor": 1, "x": 0.0, "look": {"fur": Color(0.98, 0.78, 0.85), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "flower", "size": 1.00}, "lines": ["เต้นตามจังหวะกลองหาง!", "หมุนสามรอบแล้วเวียนหัว"]},
			{"id": "t4_elder", "name": "ผู้เฒ่าเฝ้าโอเอซิส", "role": "elder", "floor": 1, "x": 5.5, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.40, "hat": "bandana", "size": 0.95}, "lines": ["โอเอซิสนี้เกิดจากน้ำตาแมวดีใจ", "ใช้น้ำอย่างประหยัดนะลูก"]},
			{"id": "t4_mail", "name": "ไปรษณีย์อูฐด่วน", "role": "mail", "floor": 0, "x": 11.0, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "bandana", "size": 1.00}, "lines": ["ฝ่าพายุทรายมาส่งจดหมาย", "ทรายเข้าหูหมดแล้ว"]},
			{"id": "t4_guard", "name": "ยามประตูดวงอาทิตย์", "role": "guard", "floor": 0, "x": 20.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "helm", "size": 1.20}, "lines": ["นอกประตูมีพีระมิดกล่องกระดาษ", "อย่าลืมพกน้ำไปด้วย"]},
			{"id": "t4_chef", "name": "แม่ครัวแกงปลาเครื่องเทศ", "role": "chef", "floor": 1, "x": 11.5, "look": {"fur": Color(0.97, 0.85, 0.70), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["แกงปลาเผ็ดนิดๆ หอมเครื่องเทศ", "ใส่นมแพะให้หายเผ็ด"]},
			{"id": "t4_explorer", "name": "นักสำรวจพีระมิด", "role": "traveler", "floor": 0, "x": 26.0, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "goggles", "size": 1.10}, "lines": ["ในพีระมิดมีรูปแมวสลักเต็มผนัง", "ผมหลงอยู่ข้างในสามวัน แต่หลับไปสองวัน"]},
			{"id": "t4_snake", "name": "งูเพื่อนบ้านใจดี", "role": "friend", "floor": 1, "x": 18.5, "look": {"fur": Color(0.70, 0.90, 0.80), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.20, "hat": "none", "size": 0.90}, "lines": ["ฟ่อ... สวัสดีจ้า", "ไม่ต้องกลัว ฉันกินแต่ผลไม้"]},
		],
		"board": {"floor": 0, "x": 2.0},
		"mailbox": {"floor": 0, "x": -6.0},
		"dungeon_gate": {"floor": 0, "x": 30.0},
	},
	{
		"name": "หมู่บ้านแมวหิมะ",
		"style": "snow",
		"palette": {"sky": Color(0.86, 0.92, 1.00), "ground": Color(0.96, 0.97, 1.00), "wall": Color(0.90, 0.82, 0.72), "roof": Color(0.85, 0.40, 0.40), "accent": Color(0.50, 0.75, 0.95)},
		"half": 32.0,
		"floors": [
			{"name": "หมู่บ้านกลางหิมะ", "y": 0.0, "half": 32.0, "deco": "igloos"},
			{"name": "เนินสกีหางฟู", "y": 6.0, "half": 20.0, "deco": "slope"},
			{"name": "ถ้ำน้ำแข็งเรืองแสง", "y": -6.0, "half": 18.0, "deco": "ice_cave"},
		],
		"warps": [
			{"from": 0, "x": 20.0, "to": 1, "to_x": -14.0, "kind": "ladder"},
			{"from": 1, "x": -14.0, "to": 0, "to_x": 20.0, "kind": "ladder"},
			{"from": 0, "x": -20.0, "to": 2, "to_x": 10.0, "kind": "door"},
			{"from": 2, "x": 10.0, "to": 0, "to_x": -20.0, "kind": "door"},
		],
		"npcs": [
			{"id": "t5_chief", "name": "หัวหน้าหมู่บ้านขนปุย", "role": "elder", "floor": 0, "x": -24.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.40, "hat": "beanie", "size": 1.20}, "lines": ["ขนหนาๆ คือของขวัญจากหิมะ", "อย่าออกไปตอนพายุนะ"]},
			{"id": "t5_guild", "name": "กิลด์นักผจญภัยหิมะ", "role": "guild", "floor": 0, "x": -16.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "helm", "size": 1.10}, "lines": ["เควสที่นี่ต้องใส่ผ้าพันคอด้วย", "ในถ้ำน้ำแข็งมีของล้ำค่า"]},
			{"id": "t5_cocoa", "name": "ร้านโกโก้ร้อน", "role": "shop", "floor": 0, "x": -8.5, "look": {"fur": Color(0.50, 0.35, 0.28), "stripe": Color(0.95, 0.88, 0.72), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["โกโก้ร้อนแบบแมวดื่มได้จ้า", "มาร์ชเมลโลว์รูปอุ้งเท้าฟรี!"]},
			{"id": "t5_ski", "name": "ครูสอนสกีหางพลิ้ว", "role": "trainer", "floor": 1, "x": -11.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.50, "hat": "goggles", "size": 1.05}, "lines": ["ไถลลงเนินแล้วหางชี้ฟ้า!", "ล้มก็ไม่เจ็บ หิมะนุ่ม"]},
			{"id": "t5_snowman", "name": "คนปั้นตุ๊กตาหิมะแมว", "role": "worker", "floor": 0, "x": 2.5, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["ตุ๊กตาหิมะตัวนี้มีหนวดทำจากกิ่งไม้", "จมูกแครอทหายไปไหนนะ"]},
			{"id": "t5_ice", "name": "นักแกะสลักน้ำแข็ง", "role": "smith", "floor": 2, "x": -9.5, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.50, "hat": "goggles", "size": 1.00}, "lines": ["น้ำแข็งก้อนนี้จะเป็นรูปปลาบิน", "มือเย็นจนไม่รู้สึกแล้ว"]},
			{"id": "t5_kid1", "name": "เด็กปาหิมะแม่นยำ", "role": "kid", "floor": 2, "x": 0.0, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "beanie", "size": 0.80}, "lines": ["ปุ๊! โดนแล้ว คิกๆ", "มาสู้ปาหิมะกันไหม"]},
			{"id": "t5_kid2", "name": "เหมียวจิ๋วหางแข็ง", "role": "kid", "floor": 0, "x": 8.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.60, "hat": "beanie", "size": 0.80}, "lines": ["หางหนูแข็งเป็นไอติมแล้ว", "กอดหน่อยได้ไหม หนาว"]},
			{"id": "t5_penguin", "name": "เพนกวินเพื่อนแมว", "role": "friend", "floor": 1, "x": -4.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.20, "hat": "none", "size": 0.90}, "lines": ["แก๊กๆ (ปลาอยู่ไหน)", "เราเดินเตาะแตะเหมือนกันนะ"]},
			{"id": "t5_knitter", "name": "คุณยายถักผ้าพันคอ", "role": "shop", "floor": 0, "x": 16.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.90, 0.55, 0.65), "ears": 0.40, "hat": "flower", "size": 0.95}, "lines": ["ผ้าพันคอไหมพรมสีชมพู ถักด้วยรัก", "ระวังลูกไหมพรมกลิ้งหนีนะ"]},
			{"id": "t5_aurora", "name": "นักดูแสงเหนือ", "role": "scholar", "floor": 1, "x": 4.0, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "beanie", "size": 0.95}, "lines": ["คืนนี้ฟ้าจะเป็นสีหางแมวเลย", "แสงเหนือสวยกว่าเลเซอร์แดงอีก"]},
			{"id": "t5_mail", "name": "ไปรษณีย์เลื่อนหิมะ", "role": "mail", "floor": 0, "x": 24.0, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["ลากเลื่อนมาส่งจดหมายจ้า", "จดหมายเย็นเจี๊ยบเลยนะ"]},
			{"id": "t5_guard", "name": "ยามด่านพายุหิมะ", "role": "guard", "floor": 1, "x": 12.0, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "helm", "size": 1.15}, "lines": ["เลยเนินไปคือป่าสนน้ำแข็ง", "ห่มผ้าให้ดีก่อนไป"]},
			{"id": "t5_bard", "name": "นักขลุ่ยหิมะ", "role": "musician", "floor": 2, "x": 7.5, "look": {"fur": Color(0.70, 0.90, 0.80), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["เสียงขลุ่ยก้องในถ้ำเพราะดี", "เพลงนี้ทำให้น้ำแข็งเปล่งแสง"]},
		],
		"board": {"floor": 0, "x": 0.0},
		"mailbox": {"floor": 0, "x": -6.0},
		"dungeon_gate": {"floor": 1, "x": 16.0},
	},
	{
		"name": "เกาะแมวภูเขาไฟ",
		"style": "lava",
		"palette": {"sky": Color(0.98, 0.78, 0.65), "ground": Color(0.45, 0.38, 0.38), "wall": Color(0.85, 0.70, 0.62), "roof": Color(0.75, 0.30, 0.25), "accent": Color(1.00, 0.55, 0.20)},
		"half": 32.0,
		"floors": [
			{"name": "ท่าเรือเกาะร้อน", "y": 0.0, "half": 32.0, "deco": "rocks"},
			{"name": "ขอบปล่องภูเขาไฟ", "y": 8.0, "half": 18.0, "deco": "crater"},
			{"name": "อุโมงค์ลาวาอุ่น", "y": -8.0, "half": 20.0, "deco": "lava_tunnel"},
		],
		"warps": [
			{"from": 0, "x": 14.0, "to": 1, "to_x": -10.0, "kind": "pad"},
			{"from": 1, "x": -10.0, "to": 0, "to_x": 14.0, "kind": "pad"},
			{"from": 0, "x": -14.0, "to": 2, "to_x": -8.0, "kind": "pipe"},
			{"from": 2, "x": -8.0, "to": 0, "to_x": -14.0, "kind": "pipe"},
		],
		"npcs": [
			{"id": "t6_guild", "name": "กิลด์นักสู้ไฟ", "role": "guild", "floor": 0, "x": -23.5, "look": {"fur": Color(0.92, 0.50, 0.42), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "helm", "size": 1.15}, "lines": ["ที่นี่ร้อน แต่ใจพวกเราร้อนกว่า!", "เควสบนเกาะต้องระวังลาวานะ"]},
			{"id": "t6_smith", "name": "จ้าวแห่งเตาหลอมลาวา", "role": "smith", "floor": 2, "x": -12.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.75, 0.30, 0.25), "ears": 0.40, "hat": "goggles", "size": 1.30}, "lines": ["ดาบที่ตีด้วยลาวาไม่มีวันเย็น", "อยู่ใกล้ๆ เตาระวังหนวดไหม้"]},
			{"id": "t6_hotspring", "name": "เจ้าของบ่อน้ำพุร้อน", "role": "shop", "floor": 0, "x": -11.5, "look": {"fur": Color(0.97, 0.85, 0.70), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.50, "hat": "flower", "size": 1.05}, "lines": ["แช่น้ำพุร้อนแล้วขนนุ่มขึ้นสามเท่า", "แมวไม่ชอบน้ำ แต่ชอบน้ำอุ่น"]},
			{"id": "t6_egg", "name": "คนต้มไข่ในบ่อลาวา", "role": "chef", "floor": 1, "x": -12.5, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["ไข่ต้มลาวา หอมกลิ่นกำมะถันนิดๆ", "สุกในสามวินาทีแมว"]},
			{"id": "t6_geologist", "name": "นักธรณีหนวดไหม้", "role": "scholar", "floor": 1, "x": -3.5, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "goggles", "size": 0.95}, "lines": ["ภูเขาไฟนี้หลับอยู่... มั้งนะ", "หินนี้อุ่นดี เอาไว้นอนทับได้"]},
			{"id": "t6_islander", "name": "ชาวเกาะพวงมาลัย", "role": "traveler", "floor": 0, "x": -4.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.50, "hat": "flower", "size": 1.00}, "lines": ["อโลฮ่าเหมียว!", "ทะเลรอบเกาะอุ่นเหมือนอ่างอาบน้ำ"]},
			{"id": "t6_drummer", "name": "มือกลองจังหวะภูเขาไฟ", "role": "musician", "floor": 0, "x": 3.5, "look": {"fur": Color(0.50, 0.35, 0.28), "stripe": Color(0.75, 0.30, 0.25), "ears": 0.50, "hat": "bandana", "size": 1.10}, "lines": ["ตุ้ม ตุ้ม ตุ้ม! เหมือนภูเขาไฟเต้น", "ตีกลองให้ภูเขาไฟอารมณ์ดี"]},
			{"id": "t6_kid1", "name": "เด็กย่างมาร์ชเมลโลว์", "role": "kid", "floor": 2, "x": -4.0, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["มาร์ชเมลโลว์ไหม้อีกแล้ว!", "ใช้ลาวาย่างเร็วไปหน่อย"]},
			{"id": "t6_kid2", "name": "เหมียวจิ๋วหางพอง", "role": "kid", "floor": 1, "x": 3.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["หางหนูพองเพราะตกใจภูเขาไฟเรอ", "เมื่อกี้เสียงดังมากเลย"]},
			{"id": "t6_salamander", "name": "ซาลาแมนเดอร์ใจดี", "role": "friend", "floor": 2, "x": 4.0, "look": {"fur": Color(0.92, 0.50, 0.42), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.30, "hat": "none", "size": 0.90}, "lines": ["ฉันว่ายในลาวาได้ แต่ไม่ชอบหิมะ", "อุ่นจัง อุ่นจัง"]},
			{"id": "t6_priest", "name": "นักบวชเทพไฟแมว", "role": "priest", "floor": 1, "x": 10.5, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(0.75, 0.30, 0.25), "ears": 0.45, "hat": "crown", "size": 1.05}, "lines": ["เทพไฟแมวจะปกป้องเกาะนี้", "จุดเทียนรูปปลาเพื่อขอพร"]},
			{"id": "t6_mail", "name": "ไปรษณีย์บอลลูนลมร้อน", "role": "mail", "floor": 0, "x": 16.5, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "goggles", "size": 1.00}, "lines": ["บอลลูนลอยด้วยไอร้อนภูเขาไฟ", "ส่งจดหมายจากฟ้าจ้า"]},
			{"id": "t6_guard", "name": "ยามอุโมงค์ลาวา", "role": "guard", "floor": 2, "x": 11.5, "look": {"fur": Color(0.50, 0.35, 0.28), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "helm", "size": 1.20}, "lines": ["ข้างหน้าคือดันเจี้ยนในภูเขาไฟ", "ใส่รองเท้ากันร้อนหรือยัง"]},
			{"id": "t6_fisher", "name": "ชาวประมงปลาไฟ", "role": "fisher", "floor": 0, "x": 23.5, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.85, 0.50, 0.20), "ears": 0.45, "hat": "straw", "size": 1.00}, "lines": ["ปลาไฟตกมาแล้วสุกเลย สะดวกดี", "วันนี้ทะเลเดือดนิดหน่อย"]},
		],
		"board": {"floor": 0, "x": -2.0},
		"mailbox": {"floor": 0, "x": 6.0},
		"dungeon_gate": {"floor": 2, "x": 14.0},
	},
	{
		"name": "ปราสาทแมวเงา",
		"style": "floors",
		"palette": {"sky": Color(0.60, 0.58, 0.78), "ground": Color(0.55, 0.52, 0.65), "wall": Color(0.78, 0.74, 0.88), "roof": Color(0.35, 0.30, 0.50), "accent": Color(0.75, 0.60, 1.00)},
		"half": 30.0,
		"floors": [
			{"name": "ห้องโถงใหญ่", "y": 0.0, "half": 30.0, "deco": "hall"},
			{"name": "หอสมุดเงา", "y": 8.0, "half": 22.0, "deco": "library"},
			{"name": "ดาดฟ้าจันทร์เสี้ยว", "y": 16.0, "half": 16.0, "deco": "roof"},
		],
		"warps": [
			{"from": 0, "x": -20.0, "to": 1, "to_x": -16.0, "kind": "door"},
			{"from": 1, "x": -16.0, "to": 0, "to_x": -20.0, "kind": "door"},
			{"from": 1, "x": 16.0, "to": 2, "to_x": 10.0, "kind": "ladder"},
			{"from": 2, "x": 10.0, "to": 1, "to_x": 16.0, "kind": "ladder"},
			{"from": 0, "x": 20.0, "to": 2, "to_x": -10.0, "kind": "pad"},
			{"from": 2, "x": -10.0, "to": 0, "to_x": 20.0, "kind": "pad"},
		],
		"npcs": [
			{"id": "t7_queen", "name": "ราชินีแมวเงา", "role": "noble", "floor": 2, "x": -7.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.45, "hat": "crown", "size": 1.20}, "lines": ["ปราสาทนี้มืด แต่ไม่ได้น่ากลัวนะ", "จันทร์คืนนี้สวยเหมือนเล็บแมว"]},
			{"id": "t7_guild", "name": "กิลด์อัศวินรัตติกาล", "role": "guild", "floor": 0, "x": -22.5, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.15, 0.14, 0.16), "ears": 0.50, "hat": "helm", "size": 1.15}, "lines": ["ศัตรูในเงามีมากขึ้นทุกคืน", "เควสที่นี่ยาก แต่รางวัลดี"]},
			{"id": "t7_butler", "name": "พ่อบ้านหนวดเป๊ะ", "role": "butler", "floor": 0, "x": -13.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.45, "hat": "none", "size": 1.10}, "lines": ["ยินดีต้อนรับครับ คุณแขก", "ขอโทษครับ ผมเผลอเลียขนต่อหน้าแขก"]},
			{"id": "t7_librarian", "name": "บรรณารักษ์แว่นหนา", "role": "scholar", "floor": 1, "x": -13.5, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.50, "hat": "goggles", "size": 0.95}, "lines": ["ชู่ว ห้องสมุดต้องเงียบ", "หนังสือเล่มนี้ชื่อ ร้อยวิธีงีบหลับ"]},
			{"id": "t7_ghost", "name": "ผีแมวขี้เหงา", "role": "friend", "floor": 1, "x": -4.5, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.50, "hat": "none", "size": 0.90}, "lines": ["บู้... เอ่อ ขอโทษที่ทำให้ตกใจ", "เป็นเพื่อนกันไหม ฉันเหงามาร้อยปีแล้ว"]},
			{"id": "t7_alchemist", "name": "นักเล่นแร่แปรธาตุเงา", "role": "shop", "floor": 1, "x": 4.5, "look": {"fur": Color(0.50, 0.35, 0.28), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.50, "hat": "witch", "size": 1.00}, "lines": ["ยาน้ำสีม่วงนี้ทำให้ขนเงา", "ขวดนั้นอย่าแตะ มันกำลังตื่น"]},
			{"id": "t7_knight", "name": "อัศวินเกราะดำใจดี", "role": "knight", "floor": 0, "x": -6.5, "look": {"fur": Color(0.72, 0.74, 0.78), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "helm", "size": 1.25}, "lines": ["เกราะดำเพราะซื้อลดราคา", "ผมกลัวหนูนิดนึง อย่าบอกใคร"]},
			{"id": "t7_chef", "name": "เชฟซุปจันทร์เพ็ญ", "role": "chef", "floor": 0, "x": 6.5, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["ซุปปลาใต้แสงจันทร์ อร่อยกว่าปกติ", "ใส่เห็ดเรืองแสงนิดหน่อย"]},
			{"id": "t7_bard", "name": "นักไวโอลินรัตติกาล", "role": "musician", "floor": 2, "x": -4.5, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.15, 0.14, 0.16), "ears": 0.55, "hat": "none", "size": 1.00}, "lines": ["เพลงนี้แต่งให้พระจันทร์", "สายไวโอลินทำจากหนวด... ล้อเล่น"]},
			{"id": "t7_kid1", "name": "เจ้าหญิงแมวน้อย", "role": "kid", "floor": 2, "x": 0.0, "look": {"fur": Color(0.98, 0.78, 0.85), "stripe": Color(0.60, 0.50, 0.78), "ears": 0.60, "hat": "crown", "size": 0.80}, "lines": ["มงกุฎนี้หนักจัง", "แม่บอกห้ามขึ้นดาดฟ้า แต่วิวสวยมาก"]},
			{"id": "t7_kid2", "name": "เด็กฝึกเวทเงา", "role": "kid", "floor": 2, "x": 5.0, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.60, "hat": "witch", "size": 0.80}, "lines": ["ดูนะ! ทำเงาเป็นรูปปลาได้", "เวทแรกที่เรียนคือหายตัว... ยังทำไม่ได้"]},
			{"id": "t7_mail", "name": "ไปรษณีย์ค้างคาวกลางคืน", "role": "mail", "floor": 0, "x": 13.0, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.15, 0.14, 0.16), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["ส่งจดหมายตอนกลางคืนเท่านั้น", "ปราสาทนี้บันไดเยอะจัง"]},
			{"id": "t7_guard", "name": "ยามประตูเงามืด", "role": "guard", "floor": 0, "x": 22.5, "look": {"fur": Color(0.25, 0.24, 0.28), "stripe": Color(0.45, 0.47, 0.52), "ears": 0.45, "hat": "helm", "size": 1.20}, "lines": ["ข้างหน้าคือดันเจี้ยนเงา", "ถ้ากลัวความมืด พกไฟฉายด้วย"]},
			{"id": "t7_astronomer", "name": "นักดาราศาสตร์หางยาว", "role": "scholar", "floor": 2, "x": 12.5, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(0.35, 0.45, 0.70), "ears": 0.50, "hat": "witch", "size": 1.00}, "lines": ["ดาวดวงนั้นเหมือนตาแมว", "คืนนี้มีฝนดาวปลาตก"]},
			{"id": "t7_painter", "name": "จิตรกรภาพเหมือนแมว", "role": "worker", "floor": 1, "x": 13.5, "look": {"fur": Color(0.97, 0.85, 0.70), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["นั่งนิ่งๆ นะ จะวาดให้", "วาดหนวดยากที่สุด"]},
		],
		"board": {"floor": 0, "x": -4.0},
		"mailbox": {"floor": 0, "x": 4.0},
		"dungeon_gate": {"floor": 0, "x": 26.0},
	},
	{
		"name": "สวรรค์แมวทอง",
		"style": "sky",
		"palette": {"sky": Color(0.98, 0.94, 0.80), "ground": Color(0.98, 0.96, 0.90), "wall": Color(0.99, 0.95, 0.85), "roof": Color(0.95, 0.78, 0.35), "accent": Color(0.98, 0.70, 0.85)},
		"half": 26.0,
		"floors": [
			{"name": "เกาะลอยประตูทอง", "y": 0.0, "half": 26.0, "deco": "clouds"},
			{"name": "สวนเมฆสายรุ้ง", "y": 8.0, "half": 20.0, "deco": "garden"},
			{"name": "วิหารแมวทอง", "y": 16.0, "half": 16.0, "deco": "temple"},
		],
		"warps": [
			{"from": 0, "x": 16.0, "to": 1, "to_x": -12.0, "kind": "cloud"},
			{"from": 1, "x": -12.0, "to": 0, "to_x": 16.0, "kind": "cloud"},
			{"from": 1, "x": 14.0, "to": 2, "to_x": -8.0, "kind": "cloud"},
			{"from": 2, "x": -8.0, "to": 1, "to_x": 14.0, "kind": "cloud"},
			{"from": 0, "x": -16.0, "to": 2, "to_x": 8.0, "kind": "pad"},
			{"from": 2, "x": 8.0, "to": 0, "to_x": -16.0, "kind": "pad"},
		],
		"npcs": [
			{"id": "t8_goddess", "name": "เทพีแมวทองคำ", "role": "noble", "floor": 2, "x": -10.5, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.45, "hat": "crown", "size": 1.30}, "lines": ["ยินดีด้วยที่มาถึงที่นี่ได้", "เลเวล 99 คือจุดเริ่มต้นของตำนาน"]},
			{"id": "t8_guild", "name": "กิลด์ผู้พิทักษ์สวรรค์", "role": "guild", "floor": 0, "x": -18.5, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "helm", "size": 1.15}, "lines": ["เควสสุดท้ายรออยู่บนวิหาร", "เธอมาไกลมากแล้วนะ"]},
			{"id": "t8_angel", "name": "นางฟ้าแมวปีกเล็ก", "role": "friend", "floor": 1, "x": -14.5, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.90, 0.55, 0.65), "ears": 0.55, "hat": "flower", "size": 0.90}, "lines": ["ปีกเล็กแต่บินได้นะ", "เมฆก้อนนี้นุ่มเหมือนพุงแมว"]},
			{"id": "t8_gardener", "name": "คนสวนเมฆสายรุ้ง", "role": "farmer", "floor": 1, "x": -6.5, "look": {"fur": Color(0.70, 0.90, 0.80), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "straw", "size": 1.00}, "lines": ["รดน้ำเมฆทุกเช้า ดอกไม้จะเป็นสีรุ้ง", "ดอกนี้กลิ่นแคทนิปจางๆ"]},
			{"id": "t8_harpist", "name": "นักพิณสวรรค์", "role": "musician", "floor": 1, "x": 0.0, "look": {"fur": Color(0.80, 0.72, 0.92), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "crown", "size": 1.00}, "lines": ["เสียงพิณทำให้เมฆลอยสูงขึ้น", "เพลงนี้ชื่อ งีบบนก้อนเมฆ"]},
			{"id": "t8_sage", "name": "ปราชญ์แมวเฒ่าหนวดยาว", "role": "elder", "floor": 2, "x": -5.0, "look": {"fur": Color(0.86, 0.88, 0.92), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.40, "hat": "none", "size": 1.00}, "lines": ["ความรู้ที่แท้คือรู้ว่าเมื่อไหร่ควรนอน", "เธอเติบโตขึ้นมากจริงๆ"]},
			{"id": "t8_baker", "name": "ร้านขนมเมฆปุยฝ้าย", "role": "shop", "floor": 0, "x": -9.0, "look": {"fur": Color(0.98, 0.78, 0.85), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.50, "hat": "chef", "size": 1.05}, "lines": ["ขนมเมฆละลายในปาก", "รสปลาทูน่ากับรสนม"]},
			{"id": "t8_smith", "name": "ช่างทองแห่งสวรรค์", "role": "smith", "floor": 0, "x": 0.5, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(0.35, 0.30, 0.28), "ears": 0.45, "hat": "goggles", "size": 1.20}, "lines": ["อาวุธทองคำสะท้อนแสงอาทิตย์", "ขัดจนเห็นหนวดตัวเอง"]},
			{"id": "t8_kid1", "name": "เทวดาน้อยหัดบิน", "role": "kid", "floor": 0, "x": 9.0, "look": {"fur": Color(0.98, 0.92, 0.78), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.60, "hat": "none", "size": 0.80}, "lines": ["หนูบินได้สามวินาทีแล้ว!", "ตกลงไปบนเมฆ ไม่เจ็บเลย"]},
			{"id": "t8_kid2", "name": "เหมียวจิ๋วไล่จับรุ้ง", "role": "kid", "floor": 1, "x": 6.5, "look": {"fur": Color(0.98, 0.68, 0.35), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.60, "hat": "flower", "size": 0.80}, "lines": ["รุ้งวิ่งหนีอีกแล้ว", "สีม่วงอร่อยที่สุด... ล้อเล่น"]},
			{"id": "t8_traveler", "name": "นักเดินทางจากโลกล่าง", "role": "traveler", "floor": 2, "x": 0.0, "look": {"fur": Color(0.88, 0.75, 0.55), "stripe": Color(0.50, 0.35, 0.22), "ears": 0.50, "hat": "beanie", "size": 1.10}, "lines": ["ผมปีนบันไดเมฆมาเจ็ดวัน", "ข้างล่างดูเล็กนิดเดียว"]},
			{"id": "t8_mail", "name": "ไปรษณีย์นกพิราบทอง", "role": "mail", "floor": 0, "x": 18.5, "look": {"fur": Color(0.62, 0.72, 0.88), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.50, "hat": "beanie", "size": 1.00}, "lines": ["จดหมายจากสวรรค์จ้า", "ส่งถึงทุกเมืองในพริบตา"]},
			{"id": "t8_guard", "name": "ผู้พิทักษ์ประตูวิหาร", "role": "guard", "floor": 2, "x": 5.0, "look": {"fur": Color(0.98, 0.98, 0.97), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.45, "hat": "helm", "size": 1.25}, "lines": ["ผู้ที่ผ่านประตูนี้ต้องใจกล้า", "ข้างหน้าคือดันเจี้ยนสุดท้าย"]},
			{"id": "t8_priest", "name": "นักบวชแสงอรุณ", "role": "priest", "floor": 2, "x": 14.5, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(1.00, 1.00, 1.00), "ears": 0.45, "hat": "crown", "size": 1.05}, "lines": ["ขอแสงทองคุ้มครองเธอ", "สวดภาวนาให้มีปลาทุกมื้อ"]},
			{"id": "t8_star", "name": "ดาวตกน้อยหลงทาง", "role": "friend", "floor": 1, "x": 11.5, "look": {"fur": Color(0.98, 0.84, 0.40), "stripe": Color(0.85, 0.65, 0.20), "ears": 0.30, "hat": "none", "size": 0.80}, "lines": ["วิ้ง! ฉันตกมาจากฟ้าข้างบนอีก", "ช่วยพาฉันกลับบ้านได้ไหม"]},
		],
		"board": {"floor": 0, "x": -2.0},
		"mailbox": {"floor": 0, "x": 4.0},
		"dungeon_gate": {"floor": 2, "x": 12.0},
	},
]

## ภูมิประเทศของแต่ละชั้น เดินขึ้นลงเนิน ทางลาด บันได สะพาน และช่วงทางโค้งหักเข้าไปไกล
## PATHS[เมือง][ชั้น] = {"path": [[x, สูง] ...] (หน่วยเกม เส้นตรงต่อกัน), "stairs": [[x0, x1]], "bridges": [[x0, x1, แบบ]], "bends": [[x0, x1]],
##   "below": "water"|"void"|"lava"|"rock" (ใต้สะพานเห็นอะไร), "valley": true (หุบเขา หน้าผาสูงด้านหลัง)}
const PATHS := {
	0: {0: {"path": [[-40.0, 0.0], [-27.0, 0.0], [-22.0, 2.5], [-8.0, 2.5], [-4.0, 4.5], [8.0, 4.5], [12.0, 2.0], [19.0, 2.0], [22.0, 0.0], [40.0, 0.0]],
		"stairs": [[-27.0, -22.0], [-8.0, -4.0]], "bridges": [[24.0, 30.0, "plank"]], "bends": [[8.0, 16.0]], "below": "water"}},
	2: {0: {"path": [[-30.0, 9.0], [-22.0, 9.0], [-15.0, 6.0], [-9.0, 6.0], [-4.0, 3.5], [4.0, 3.5], [10.0, 0.0], [30.0, 0.0]],
		"stairs": [[-22.0, -15.0], [4.0, 10.0]], "bridges": [[-9.0, -5.5, "rope"]], "bends": [[-4.0, 2.0]], "below": "rock", "valley": true}},
	3: {0: {"path": [[-34.0, 3.5], [-9.0, 3.5], [-4.0, 0.0], [34.0, 0.0]],
		"stairs": [[-9.0, -4.0]], "bridges": [[8.0, 17.0, "pier"], [24.0, 30.0, "pier"]], "bends": [[-20.0, -14.0]], "below": "water"}},
	4: {0: {"path": [[-34.0, 0.0], [-27.0, 1.6], [-20.0, 0.6], [-12.0, 2.6], [-3.0, 2.6], [5.0, 1.0], [13.0, 3.2], [22.0, 3.2], [28.0, 0.0], [34.0, 0.0]],
		"stairs": [], "bridges": [], "bends": [[-3.0, 5.0], [22.0, 28.0]], "below": "rock"}},
	5: {0: {"path": [[-32.0, 8.0], [-24.0, 8.0], [-11.0, 3.0], [-5.0, 3.0], [2.0, 3.0], [8.0, 0.0], [32.0, 0.0]],
		"stairs": [[2.0, 8.0]], "bridges": [[-5.0, 2.0, "ice"]], "bends": [[14.0, 20.0]], "below": "void"},
		1: {"path": [[-20.0, 4.0], [-8.0, 4.0], [10.0, 0.0], [20.0, 0.0]], "stairs": [], "bridges": [], "bends": [], "below": "void"}},
	6: {0: {"path": [[-32.0, 6.0], [-22.0, 6.0], [-14.0, 1.0], [-6.0, 0.0], [6.0, 0.0], [14.0, 1.0], [22.0, 5.0], [32.0, 5.0]],
		"stairs": [[-22.0, -14.0], [14.0, 22.0]], "bridges": [[-4.0, 4.0, "stone"]], "bends": [[-30.0, -24.0]], "below": "lava", "valley": true}},
	7: {0: {"path": [[-30.0, 0.0], [-20.0, 0.0], [-14.0, 3.0], [-8.0, 3.0], [-2.0, 6.0], [6.0, 6.0], [12.0, 3.0], [18.0, 3.0], [24.0, 0.0], [30.0, 0.0]],
		"stairs": [[-20.0, -14.0], [-8.0, -2.0], [6.0, 12.0], [18.0, 24.0]], "bridges": [], "bends": [[-8.0, -2.0], [6.0, 12.0]], "below": "rock"},
		1: {"path": [[-22.0, 0.0], [-10.0, 0.0], [-4.0, 3.0], [8.0, 3.0], [14.0, 0.0], [22.0, 0.0]], "stairs": [[-10.0, -4.0], [8.0, 14.0]], "bridges": [], "bends": [], "below": "rock"}},
	8: {0: {"path": [[-26.0, 2.0], [-18.0, 2.0], [-15.0, 5.0], [-8.0, 5.0], [-5.0, 8.0], [3.0, 8.0], [6.0, 4.0], [14.0, 4.0], [17.0, 1.0], [26.0, 1.0]],
		"stairs": [], "bridges": [[-18.0, -15.0, "cloud"], [-8.0, -5.0, "cloud"], [3.0, 6.0, "cloud"], [14.0, 17.0, "cloud"]], "bends": [[-5.0, 3.0]], "below": "void"}},
}

static func terrain(t: int, fl: int) -> Dictionary:
	var td: Dictionary = PATHS.get(t, {})
	return td.get(fl, {})

static func town(i: int) -> Dictionary:
	return TOWNS[i] if i >= 0 and i < TOWNS.size() else (TOWNS[0] as Dictionary)

static func npc(id: String) -> Dictionary:
	for t in TOWNS.size():
		for n in (TOWNS[t] as Dictionary).get("npcs", []):
			if str(n["id"]) == id:
				var d: Dictionary = (n as Dictionary).duplicate()
				d["town"] = t
				return d
	return {}
