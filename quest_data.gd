class_name QuestData
extends RefCounted
## เควสเปลี่ยนคลาส
## เลเวล 15 รับ "เควสปลดคลาส" ที่เมืองที่สอง  ผ่านแล้วเลือกคลาสแรก (เช่น SWORD KNIGHT / ARCH MAGE)
## เลเวล 35 รับ "เควสเปลี่ยนคลาสต่อยอด" ที่เมืองที่สาม  ผ่านแล้วต่อยอดเป็นคลาสขั้นสอง (เช่น GRAND KNIGHT)
## ความคืบหน้าเก็บในตัวละครแต่ละตัว entry["quest"] = {"id", "kills", "clears"}

const QUESTS := [
	{"id": "unlock", "tier": 0, "level": 15, "town": 1, "kills": 30, "clears": 1, "title": "เควสปลดคลาส",
		"text": "หัวหน้ากิลด์แมวอยากเห็นฝีมือ ปราบมอนในดันเจี้ยนของเมืองนี้ แล้วผ่านดันเจี้ยนให้ได้ จะได้เลือกคลาสของตัวเอง"},
	{"id": "advance", "tier": 1, "level": 35, "town": 2, "kills": 50, "clears": 2, "title": "เควสเปลี่ยนคลาสต่อยอด",
		"text": "ปรมาจารย์แมวบนภูเขาจะสอนวิชาขั้นสูง ปราบมอนในดันเจี้ยนของเมืองนี้ และผ่านดันเจี้ยนสองแห่ง พิสูจน์ว่าพร้อมแล้ว"},
]

## ขั้นของคลาส 0 คลาสพื้นฐาน 1 คลาสแรก 2 คลาสต่อยอด
static func tier(weapon: String, class_id: String) -> int:
	var base: String = SkillPanel.BASE_CLASS.get(weapon, "BASIC")
	if class_id == "" or class_id == base:
		return 0
	var first: Array = SkillPanel.first_classes(weapon)
	return 1 if class_id in first else 2

## เควสถัดไปของตัวละคร ไม่มีแล้วคืนค่าว่าง
static func next_quest(weapon: String, class_id: String) -> Dictionary:
	var t := tier(weapon, class_id)
	for q in QUESTS:
		if int(q["tier"]) == t:
			return q
	return {}

## คลาสที่เลือกได้ตอนส่งเควส
static func choices(weapon: String, class_id: String) -> Array:
	var t := tier(weapon, class_id)
	if t == 0:
		return SkillPanel.first_classes(weapon)
	if t == 1:
		return SkillPanel.next_of(class_id, weapon)
	return []

## ความคืบหน้าเควสนี้ ไม่ได้รับไว้คืนค่าว่าง
static func progress(entry: Dictionary, q: Dictionary) -> Dictionary:
	var p = entry.get("quest", {})
	if p is Dictionary and str(p.get("id", "")) == str(q.get("id", "")):
		return p
	return {}

static func is_done(entry: Dictionary, q: Dictionary) -> bool:
	var p := progress(entry, q)
	if p.is_empty():
		return false
	return int(p.get("kills", 0)) >= int(q["kills"]) and (p.get("clears", []) as Array).size() >= int(q["clears"])

## ตีมอนตาย หรือผ่านดัน นับให้เควสที่รับไว้ ถ้าอยู่เมืองของเควส
static func count(entry: Dictionary, town: int, kills: int, cleared_index := -1) -> bool:
	var p = entry.get("quest", {})
	if not p is Dictionary or str(p.get("id", "")) == "":
		return false
	var q := find(str(p["id"]))
	if q.is_empty() or int(q["town"]) != town:
		return false
	p["kills"] = int(p.get("kills", 0)) + kills
	if cleared_index >= 0:
		var c: Array = p.get("clears", [])
		if not cleared_index in c:
			c.append(cleared_index)
		p["clears"] = c
	entry["quest"] = p
	return true

static func find(id: String) -> Dictionary:
	for q in QUESTS:
		if q["id"] == id:
			return q
	return {}

# ================================================================ ระบบเควสทั้งเกม (เควสหลัก รอง กระดาน จดหมาย)
## ความคืบหน้าเก็บในตัวละคร entry["qs"] = {id: {"s": "active" | "done", "n": จำนวน, "day": วันที่ทำ (เควสกระดาน)}}
## จดหมาย entry["mail"] = [{"id", "from", "title", "text", "quest", "reward": {"exp"}, "read", "claimed"}]
## ฉายา entry["title"]
## หน้าที่เรียกใช้: ตีมอนตาย on_kill  ผ่านดัน on_clear  คุย NPC talk/on_talk  เลเวลอัป on_level  แล้ว commit(entry) บันทึก
## ส่งเควสได้รางวัล turn_in(entry, id) -> {"exp", "title"} แล้วเรียก grant(reward) ให้ EXP เข้าตัวละครที่เล่นอยู่

const TALK_KEY := "talk"

static func quest(id: String) -> Dictionary:
	return QuestStory.find(id)

static func today() -> int:
	return int(Time.get_unix_time_from_system() / 86400.0)

static func _qs(entry: Dictionary) -> Dictionary:
	var v = entry.get("qs", {})
	if not v is Dictionary:
		v = {}
	entry["qs"] = v
	return v

## NPC ในเมืองตามบทบาท ไม่มีบทบาทนั้นเลือก NPC ตัวอื่นในเมืองตามลำดับ ไม่มีเลยคืนค่าว่าง
static func npc_for(town: int, role: String, salt := 0) -> String:
	if role == "" or town < 0 or town >= TownData.TOWNS.size():
		return ""
	var list: Array = (TownData.TOWNS[town] as Dictionary).get("npcs", [])
	for n in list:
		if str(n.get("role", "")) == role:
			return str(n["id"])
	if role == "guild":
		for n in list:
			if str(n["id"]).ends_with("_guild"):
				return str(n["id"])
	var others := []
	for n in list:
		if str(n.get("role", "")) != "guild":
			others.append(str(n["id"]))
	if not others.is_empty():
		return str(others[absi(salt + role.length()) % others.size()])
	return str(list[0]["id"]) if not list.is_empty() else ""

## NPC ที่ให้เควสนี้
static func giver_of(q: Dictionary) -> String:
	return npc_for(int(q["town"]), str(q.get("giver", "")), str(q["id"]).hash())

## NPC ที่ต้องไปส่งเควสนี้ เควสคุยส่งที่ NPC ปลายทาง นอกนั้นส่งที่คนให้
static func turn_in_npc(q: Dictionary) -> String:
	var g: Dictionary = q["goal"]
	if str(g["type"]) == TALK_KEY:
		return npc_for(int(g.get("town", q["town"])), str(g.get("role", "")), str(q["id"]).hash() + 7)
	return giver_of(q)

## สถานะ "" ยังไม่รับ  "active" กำลังทำ  "ready" ทำครบรอส่ง  "done" ส่งแล้ว
static func state(entry: Dictionary, id: String) -> String:
	var q := quest(id)
	if q.is_empty():
		return ""
	var p = _qs(entry).get(id, {})
	if not p is Dictionary or (p as Dictionary).is_empty():
		return ""
	if str(q["chain"]) == "board" and str(p.get("s", "")) == "done" and int(p.get("day", -1)) != today():
		return ""
	if str(p.get("s", "")) == "done":
		return "done"
	return "ready" if _goal_met(entry, q, p) else "active"

static func need_of(q: Dictionary) -> int:
	var g: Dictionary = q["goal"]
	match str(g["type"]):
		"kill":
			return int(g.get("n", 1))
		"level":
			return int(g.get("lv", 1))
	return 1

## ความคืบหน้า [ได้แล้ว ต้องได้]
static func progress_of(entry: Dictionary, id: String) -> Vector2i:
	var q := quest(id)
	if q.is_empty():
		return Vector2i.ZERO
	var p = _qs(entry).get(id, {})
	var got := int(p.get("n", 0)) if p is Dictionary else 0
	if str(q["goal"]["type"]) == "level":
		got = int(entry.get("level", 1))
	if str(q["goal"]["type"]) == TALK_KEY and state(entry, id) == "ready":
		got = 1
	return Vector2i(mini(got, need_of(q)), need_of(q))

static func _goal_met(entry: Dictionary, q: Dictionary, p: Dictionary) -> bool:
	match str(q["goal"]["type"]):
		"level":
			return int(entry.get("level", 1)) >= int(q["goal"]["lv"])
		TALK_KEY:
			return true
	return int(p.get("n", 0)) >= need_of(q)

## รับเควสนี้ได้ไหม
static func can_accept(entry: Dictionary, q: Dictionary) -> bool:
	if q.is_empty() or int(entry.get("level", 1)) < int(q["level"]):
		return false
	if state(entry, str(q["id"])) != "":
		return false
	var after := str(q.get("after", ""))
	if after != "" and state(entry, after) != "done":
		return false
	if str(q["chain"]) == "board":
		return q in board_quests(entry, int(q["town"]))
	return true

static func accept(entry: Dictionary, id: String) -> bool:
	var q := quest(id)
	if not can_accept(entry, q):
		return false
	_qs(entry)[id] = {"s": "active", "n": 0, "day": today()}
	return true

## ส่งเควส ได้รางวัล EXP ตามเลเวลตอนส่ง ปลดจดหมายถัดไป
static func turn_in(entry: Dictionary, id: String) -> Dictionary:
	if state(entry, id) != "ready":
		return {}
	var q := quest(id)
	var qs := _qs(entry)
	qs[id] = {"s": "done", "n": need_of(q), "day": today()}
	var lv := int(entry.get("level", 1))
	var reward := {"exp": maxi(10, int(round(float(LevelData.need(lv)) * float(q["reward"]["k"])))), "title": str(q["reward"].get("title", ""))}
	if str(reward["title"]) != "":
		entry["title"] = reward["title"]
	# เควสหลักที่ส่งแล้ว ส่งจดหมายบอกขั้นต่อไป
	if str(q["chain"]) == "main":
		var nid := _next_main(id)
		if nid != "":
			var nq := quest(nid)
			mail(entry)
			_send(entry, "main_" + nid, DungeonData.town_name(int(nq["town"])), "งานต่อไป: " + str(nq["title"]), str(nq["text"]), nid, 0.0)
	return reward

static func _next_main(id: String) -> String:
	for q in QuestStory.all():
		if str(q["chain"]) == "main" and str(q.get("after", "")) == id:
			return str(q["id"])
	return ""

## ตีมอนตาย นับให้เควสปราบที่รับไว้ในเมืองนั้น คืนรายการเควสที่เพิ่งทำครบ
static func on_kill(entry: Dictionary, town: int, kind: String) -> Array:
	var done := []
	var qs := _qs(entry)
	for id in qs.keys():
		var q := quest(str(id))
		if q.is_empty() or state(entry, str(id)) != "active":
			continue
		var g: Dictionary = q["goal"]
		if str(g["type"]) != "kill" or int(g.get("town", q["town"])) != town:
			continue
		if str(g.get("kind", "")) != "" and str(g["kind"]) != kind:
			continue
		qs[id]["n"] = int(qs[id].get("n", 0)) + 1
		if state(entry, str(id)) == "ready":
			done.append(str(id))
	return done

## ผ่านดันเจี้ยน นับให้เควสผ่านดัน
static func on_clear(entry: Dictionary, town: int, dungeon_index: int) -> Array:
	var done := []
	var qs := _qs(entry)
	for id in qs.keys():
		var q := quest(str(id))
		if q.is_empty() or state(entry, str(id)) != "active":
			continue
		var g: Dictionary = q["goal"]
		if str(g["type"]) != "clear" or int(g.get("town", q["town"])) != town:
			continue
		if int(g.get("dungeon", -1)) >= 0 and int(g["dungeon"]) != dungeon_index:
			continue
		qs[id]["n"] = 1
		done.append(str(id))
	return done

## คุยกับ NPC เควสคุยที่ปลายทางเป็น NPC นี้ ส่งได้ที่ NPC นี้ คืนรายการเควสนั้น
static func on_talk(entry: Dictionary, npc_id: String) -> Array:
	var out := []
	for id in _qs(entry).keys():
		var q := quest(str(id))
		if not q.is_empty() and str(q["goal"]["type"]) == TALK_KEY and state(entry, str(id)) == "ready" and turn_in_npc(q) == npc_id:
			out.append(str(id))
	return out

## เลเวลอัป ส่งจดหมายฉลองทุก 10 เลเวล จดหมายปลดเควสคลาส และเมืองใหม่ คืนเควสที่เพิ่งครบ
static func on_level(entry: Dictionary, level: int) -> Array:
	entry["level"] = level
	mail(entry)
	for m in range(10, level + 1, 10):
		_send(entry, "lv%d" % m, "กิลด์แมว", "ยินดีด้วย เลเวล %d!" % m, "เก่งมากเหมียว นี่ของขวัญเล็กๆ จากกิลด์ ขอให้เดินทางสนุกนะ", "", 0.2)
	if level >= 15:
		_send(entry, "class15", "หัวหน้ากิลด์แมว", "ถึงเวลาเลือกคลาสแล้ว", "เลเวล 15 แล้ว ไปที่%s รับเควสปลดคลาสได้เลย" % DungeonData.town_name(1), "", 0.0)
	if level >= 35:
		_send(entry, "class35", "ปรมาจารย์แมว", "วิชาขั้นสูงรออยู่", "เลเวล 35 แล้ว ขึ้นมาหาเราที่%s ได้เลย" % DungeonData.town_name(2), "", 0.0)
	for t in range(1, QuestStory.TOWN_COUNT):
		if level >= DungeonData.town_levels(t).x:
			_send(entry, "town%d" % t, "นกพิราบสื่อสาร", "%sเปิดแล้ว" % DungeonData.town_name(t), "เส้นทางไป%sปลอดภัยแล้ว ลองไปเที่ยวดูนะเหมียว" % DungeonData.town_name(t), "", 0.1)
	var out := []
	for id in _qs(entry).keys():
		var q := quest(str(id))
		if not q.is_empty() and str(q["goal"]["type"]) == "level" and state(entry, str(id)) == "ready":
			out.append(str(id))
	return out

## เควสกระดานของวันนี้ เมืองละ 3 แบบ สลับทุกวัน
static func board_quests(_entry: Dictionary, town: int) -> Array:
	var list := []
	for q in QuestStory.all():
		if str(q["chain"]) == "board" and int(q["town"]) == town:
			list.append(q)
	if list.size() <= 3:
		return list
	var start := (today() + town * 2) % list.size()
	var out := []
	for i in 3:
		out.append(list[(start + i) % list.size()])
	return out

## คุยกับ NPC: ส่งเควสก่อน รองลงมาให้เควสใหม่ (เควสหลักก่อน) ไม่มีก็พูดทั่วไป
static func talk(npc_id: String, entry: Dictionary) -> Dictionary:
	var res := {"lines": [], "offer": "", "turn_in": ""}
	var info := TownData.npc(npc_id)
	for id in _qs(entry).keys():
		var q := quest(str(id))
		if not q.is_empty() and state(entry, str(id)) == "ready" and turn_in_npc(q) == npc_id:
			res["turn_in"] = str(id)
			res["lines"] = ["เยี่ยมมากเหมียว! \"%s\" เรียบร้อยแล้ว" % str(q["title"]), "นี่รางวัลของเธอ"]
			return res
	var town := int(info.get("town", -1))
	var best := {}
	for q in QuestStory.all():
		if int(q["town"]) != town or str(q["chain"]) == "board" or giver_of(q) != npc_id:
			continue
		if can_accept(entry, q) and (best.is_empty() or (str(q["chain"]) == "main" and str(best["chain"]) != "main")):
			best = q
	if not best.is_empty():
		res["offer"] = str(best["id"])
		res["lines"] = [str(best["text"]), "ช่วยหน่อยได้ไหมเหมียว?"]
		return res
	for id in _qs(entry).keys():
		var q := quest(str(id))
		if not q.is_empty() and state(entry, str(id)) == "active" and giver_of(q) == npc_id:
			res["lines"] = ["\"%s\" เป็นยังไงบ้าง สู้ๆ นะเหมียว" % str(q["title"])]
			return res
	var talk_lines: Array = info.get("lines", [])
	res["lines"] = [str(talk_lines[randi() % talk_lines.size()])] if not talk_lines.is_empty() else ["เหมียว~"]
	return res

## เครื่องหมายเหนือหัว NPC  "?" ส่งเควสได้  "!" มีเควสให้  "" ไม่มี
static func npc_mark(entry: Dictionary, npc_id: String) -> String:
	if entry.is_empty():
		return ""
	var r := talk(npc_id, entry)
	if str(r["turn_in"]) != "":
		return "?"
	return "!" if str(r["offer"]) != "" else ""

## มีอะไรให้ทำในเมืองนี้ไหม (เควสรับได้ ส่งได้ จดหมายยังไม่อ่าน) ไว้ขึ้น ! บนปุ่ม
static func quest_alert(entry: Dictionary, town: int) -> bool:
	if entry.is_empty():
		return false
	if unread(entry) > 0:
		return true
	for id in _qs(entry).keys():
		if state(entry, str(id)) == "ready":
			return true
	return not offers(entry, town).is_empty()

## เควสที่รับไว้ (ยังไม่ส่ง) เรียงหลัก รอง กระดาน
static func active_list(entry: Dictionary) -> Array:
	var out := []
	for chain in ["main", "side", "board"]:
		for id in _qs(entry).keys():
			var q := quest(str(id))
			if not q.is_empty() and str(q["chain"]) == chain and state(entry, str(id)) in ["active", "ready"]:
				out.append(str(id))
	return out

## เควสหลักขั้นถัดไปที่ยังไม่รับ (ไว้บอกทาง)
static func next_main(entry: Dictionary) -> Dictionary:
	for q in QuestStory.all():
		if str(q["chain"]) == "main" and state(entry, str(q["id"])) == "":
			return q
	return {}

## เควสหลักกับเควสรองที่รับได้ในเมืองนี้ตอนนี้
static func offers(entry: Dictionary, town: int) -> Array:
	var out := []
	for q in QuestStory.all():
		if int(q["town"]) == town and str(q["chain"]) != "board" and can_accept(entry, q):
			out.append(q)
	return out

# ---------------------------------------------------------------- จดหมาย
## จดหมายทั้งหมด มีจดหมายต้อนรับเสมอ
static func mail(entry: Dictionary) -> Array:
	var v = entry.get("mail", [])
	if not v is Array:
		v = []
	entry["mail"] = v
	if (v as Array).is_empty():
		_send(entry, "welcome", "หัวหน้ากิลด์แมว", "ยินดีต้อนรับ นักผจญภัยเหมียว!",
			"ยินดีต้อนรับสู่%s ไปคุยกับหัวหน้ากิลด์ในเมืองเพื่อรับเควสแรก แล้วเปิดกระดานเควสดูงานประจำวันได้ด้วยนะ" % DungeonData.town_name(0), "m0_01", 0.3)
	return entry["mail"]

static func _send(entry: Dictionary, id: String, from: String, title: String, text: String, quest_id: String, exp_k: float) -> void:
	var list: Array = entry.get("mail", [])
	for m in list:
		if str(m["id"]) == id:
			return
	var lv := int(entry.get("level", 1))
	var gift := int(round(float(LevelData.need(lv)) * exp_k)) if exp_k > 0.0 else 0
	list.push_front({"id": id, "from": from, "title": title, "text": text, "quest": quest_id, "reward": {"exp": gift}, "read": false, "claimed": gift <= 0})
	entry["mail"] = list

static func read_mail(entry: Dictionary, id: String) -> void:
	for m in mail(entry):
		if str(m["id"]) == id:
			m["read"] = true

## รับรางวัลจากจดหมาย ได้ครั้งเดียว
static func claim_mail(entry: Dictionary, id: String) -> Dictionary:
	for m in mail(entry):
		if str(m["id"]) == id and not bool(m.get("claimed", false)):
			m["claimed"] = true
			m["read"] = true
			return {"exp": int(m["reward"].get("exp", 0)), "title": ""}
	return {}

static func unread(entry: Dictionary) -> int:
	var c := 0
	for m in mail(entry):
		if not bool(m.get("read", false)):
			c += 1
	return c

# ---------------------------------------------------------------- บันทึกและให้รางวัล
## บันทึกเควส จดหมาย ฉายา ลงตัวละครที่เล่นอยู่
static func commit(entry: Dictionary) -> void:
	if WalkPage.roster_index < 0 or entry.is_empty():
		return
	SaveData.update_character(WalkPage.roster_index, {"qs": entry.get("qs", {}), "mail": entry.get("mail", []), "title": entry.get("title", "")})

## ให้ EXP ตามรางวัล ถ้าอยู่หน้าที่มีตัวละคร (เมือง ดัน) ให้ผ่าน gain_exp จะมีเลเวลอัปบนจอ
static func grant(reward: Dictionary) -> void:
	var gift := int(reward.get("exp", 0))
	if gift <= 0:
		return
	var tree := Engine.get_main_loop() as SceneTree
	var scene: Node = tree.current_scene if tree != null else null
	if scene != null and scene.has_method("gain_exp"):
		scene.call("gain_exp", gift)
		return
	if WalkPage.roster_index < 0:
		return
	var r := LevelData.add(WalkPage.chosen_level, WalkPage.chosen_exp, gift)
	WalkPage.chosen_level = int(r[0])
	WalkPage.chosen_exp = int(r[1])
	SaveData.update_character(WalkPage.roster_index, {"level": WalkPage.chosen_level, "exp": WalkPage.chosen_exp})
