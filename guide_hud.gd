class_name GuideHud
extends Node2D
## ตัวช่วยผู้เล่นใหม่ บนหน้าเมืองและดันเจี้ยน
## แบนเนอร์เป้าหมาย (เควสหลักขั้นปัจจุบัน) แตะเปิดสมุดเควส  กากบาทซ่อนไว้รอบนี้
## ลูกศรอุ้งเท้าชี้ทางในเมือง  คำใบ้ครั้งแรก (จำต่อตัวละครใน entry["hints"])

const BANNER := Rect2(26.0, 168.0, 470.0, 58.0)
const TOAST_W := 500.0
const TOAST_TIME := 5.0
const NPC_LIFT := 70.0      # จุดที่ชี้ ระดับลำตัวของ NPC
const HINTS := {
	"town": "เดินด้วยจอยซ้าย\nเข้าใกล้คนแล้วกดปุ่มกลางล่างเพื่อคุย",
	"dungeon": "Z ตี   X ท่าพิเศษ   JUMP กระโดด\nดันจอยสุดเพื่อวิ่ง",
	"skill": "มีสกิลให้ใช้แล้ว!\nแตะ สกิล มุมขวาบน แล้วจัดสกิลลงช่อง",
	"level": "เลเวลอัป! เลือดมานาเพิ่ม\nเลเวลสูงขึ้นได้สกิลกับดันเจี้ยนใหม่",
	"quest": "ทำเควสครบแล้ว!\nกลับไปส่งเควสที่ NPC ที่มี ! บนหัว",
	"lowhp": "เลือดน้อยแล้ว!\nถอยห่างจากมอนก่อน หรือกลับเมืองไปพัก",
}

var page: WalkPage
var _t := 0.0
var _poll := 0.0
var _entry: Dictionary = {}
var _goal: Dictionary = {}          # {text, npc, gate}
var _hidden := false               # ผู้เล่นกดซ่อนแบนเนอร์รอบนี้
var _toasts: Array = []            # [ข้อความ เวลาที่เหลือ]
var _start_level := 0
var _panel: QuestPanel

## เปิดตัวช่วยได้ไหม (ไม่ใช่ทดลองเล่น/ฝึกสอน และเป็นตัวละครที่บันทึกไว้)
static func wanted() -> bool:
	return not WalkPage.trial and not WalkPage.tutorial and WalkPage.roster_index >= 0

func _ready() -> void:
	z_index = 46
	_refresh()
	_start_level = int(_entry.get("level", 1))
	if page is TownPage:
		_hint("town")
	elif page is DungeonPage:
		_hint("dungeon")

func _entry_now() -> Dictionary:
	var list := SaveData.roster()
	if WalkPage.roster_index < 0 or WalkPage.roster_index >= list.size():
		return {}
	return list[WalkPage.roster_index]

func _refresh() -> void:
	_entry = _entry_now()
	_goal = objective(_entry) if not _entry.is_empty() else {}

func _process(delta: float) -> void:
	_t += delta
	_poll -= delta
	if _poll <= 0.0:
		_poll = 1.0
		_refresh()
		_check_events()
	for t in _toasts.slice(0, 1):
		t[1] = float(t[1]) - minf(delta, 0.1)
	if not _toasts.is_empty() and float(_toasts[0][1]) <= 0.0:
		_toasts.pop_front()
	queue_redraw()

# ---------------------------------------------------------------- เป้าหมาย
static func _npc_name(id: String) -> String:
	var n := TownData.npc(id)
	return str(n.get("name", "ผู้คนในเมือง"))

## เป้าหมายตอนนี้ {text: ข้อความ, npc: id ที่ต้องไปหา หรือ "", gate: true ถ้าต้องเข้าดันเจี้ยน, town: เมืองเป้าหมาย}
static func objective(entry: Dictionary) -> Dictionary:
	var main_id := ""
	for id in QuestData.active_list(entry):
		if str(QuestData.quest(str(id)).get("chain", "")) == "main":
			main_id = str(id)
			break
	if main_id != "":
		var q := QuestData.quest(main_id)
		var g: Dictionary = q["goal"]
		var t := int(g.get("town", q.get("town", 0)))
		if QuestData.state(entry, main_id) == "ready":
			var who := QuestData.turn_in_npc(q)
			var verb := "คุยกับ " if str(g.get("type", "")) == QuestData.TALK_KEY else "ส่งเควสที่ "
			return {"text": verb + _npc_name(who), "npc": who, "gate": false, "town": int(TownData.npc(who).get("town", t))}
		var p := QuestData.progress_of(entry, main_id)
		match str(g.get("type", "")):
			"talk":
				var who := QuestData.turn_in_npc(q)
				return {"text": "คุยกับ " + _npc_name(who), "npc": who, "gate": false, "town": int(TownData.npc(who).get("town", t))}
			"kill":
				return {"text": "ปราบมอน %d/%d ในดันเจี้ยนของ%s" % [p.x, p.y, DungeonData.town_name(t)], "npc": "", "gate": true, "town": t}
			"clear":
				var d := DungeonData.dungeon(t, int(g.get("dungeon", 0)))
				return {"text": "ผ่านดันเจี้ยน " + str(d.get("name", "")), "npc": "", "gate": true, "town": t}
			"level":
				return {"text": "เก็บเลเวลให้ถึง Lv.%d (ตีมอนในดันเจี้ยน)" % int(g.get("lv", 1)), "npc": "", "gate": true, "town": t}
	var nq := QuestData.next_main(entry)
	if nq.is_empty():
		return {"text": "ทำเควสรองหรือเควสกระดานในเมืองได้เลย", "npc": "", "gate": false, "town": WalkPage.current_town}
	if int(entry.get("level", 1)) >= int(nq.get("level", 1)):
		var giver := QuestData.giver_of(nq)
		return {"text": "รับเควสจาก " + _npc_name(giver), "npc": giver, "gate": false, "town": int(TownData.npc(giver).get("town", nq.get("town", 0)))}
	return {"text": "เก็บเลเวลถึง Lv.%d เพื่อรับเควสต่อ" % int(nq.get("level", 1)), "npc": "", "gate": true, "town": int(nq.get("town", 0))}

# ---------------------------------------------------------------- คำใบ้ครั้งแรก
func _hint(key: String) -> bool:
	if _entry.is_empty():
		return false
	var hints: Dictionary = (_entry.get("hints", {}) as Dictionary).duplicate()
	if hints.get(key, false):
		return false
	hints[key] = true
	_entry["hints"] = hints
	SaveData.update_character(WalkPage.roster_index, {"hints": hints})
	_toasts.append([HINTS[key], TOAST_TIME])
	return true

func _check_events() -> void:
	if _entry.is_empty():
		return
	var lv := int(_entry.get("level", 1))
	if lv > _start_level:
		_hint("level")
	if _has_skill(lv):
		_hint("skill")
	for id in QuestData.active_list(_entry):
		var qg: Dictionary = QuestData.quest(str(id)).get("goal", {})
		if str(qg.get("type", "")) != QuestData.TALK_KEY and QuestData.state(_entry, str(id)) == "ready":
			_hint("quest")
			break
	if page is DungeonPage and page.hero != null and page.hero.hp > 0.0 and page.hero.hp < page.hero.hp_max() * 0.3:
		_hint("lowhp")

## มีสกิลที่ใช้ได้ (ไม่ใช่พาสซีฟ ไม่ใช่ HYPER) ถึงเลเวลแล้วไหม
func _has_skill(lv: int) -> bool:
	for s in SkillPanel.SKILLS.get(SkillPanel.skill_key(WalkPage.chosen_weapon), []):
		var d: Dictionary = s
		if d.get("passive", false) or str(d.get("slot", "")) == "HYPER" or str(d.get("id", "")).ends_with("_hyper"):
			continue
		if SkillPanel.need_level(d) <= lv:
			return true
	return false

# ---------------------------------------------------------------- แตะ
func banner_rect() -> Rect2:
	return BANNER

func _close_rect() -> Rect2:
	return Rect2(BANNER.end.x - 44.0, BANNER.position.y + 8.0, 38.0, 38.0)

func _toast_rect() -> Rect2:
	var v := get_viewport_rect().size
	# อยู่ระหว่างวงเลเวลกับปุ่มมุมขวาบน สูงตามจำนวนบรรทัด
	var n := _wrap(str(_toasts[0][0]), UiStyle.BODY, TOAST_W - 90.0).size() if not _toasts.is_empty() else 1
	return Rect2(v.x * 0.5 - TOAST_W * 0.5 + 10.0, 98.0, TOAST_W, 34.0 + 30.0 * float(n))

func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch and event.pressed) or not visible:
		return
	if _busy():
		return
	var at: Vector2 = event.position
	if not _toasts.is_empty() and _toast_rect().has_point(at):
		_toasts.pop_front()
		get_viewport().set_input_as_handled()
		return
	if _hidden or _goal.is_empty():
		return
	if _close_rect().has_point(at):
		_hidden = true
		get_viewport().set_input_as_handled()
		return
	if BANNER.has_point(at):
		_open_log()
		get_viewport().set_input_as_handled()

## หน้ากำลังเปิดแผงอื่นอยู่ ไม่ต้องแสดง/รับแตะ
func _busy() -> bool:
	if page == null:
		return false
	if page.panel != null and page.panel.visible:
		return true
	if page.hyper != null:
		return true
	if page is TownPage:
		var tp := page as TownPage
		if tp.map.visible or tp.quests.visible or (tp.dialog != null and tp.dialog.visible):
			return true
	if _panel != null and is_instance_valid(_panel) and _panel.visible:
		return true
	return false

func _open_log() -> void:
	if page is TownPage:
		var tp := page as TownPage
		tp.quests.open_log()
		tp.pad.visible = false
		tp.joy.visible = false
		return
	if _panel == null or not is_instance_valid(_panel):
		_panel = QuestPanel.new()
		_panel.z_index = 80
		_panel.closed.connect(func() -> void:
			page.pad.visible = true
			page.joy.visible = true)
		page.add_child(_panel)
	_panel.open_log()
	page.pad.visible = false
	page.joy.visible = false

# ---------------------------------------------------------------- วาด
func _draw() -> void:
	if page == null or _busy():
		return
	if not _hidden and not _goal.is_empty():
		_draw_banner()
		if page is TownPage:
			_draw_pointer()
	if not _toasts.is_empty():
		_draw_toast(str(_toasts[0][0]), float(_toasts[0][1]))

func _draw_banner() -> void:
	var r := BANNER
	UiStyle.fill(self, Rect2(r.position + Vector2(3.0, 4.0), r.size), Color(0.0, 0.0, 0.0, 0.1))
	UiStyle.box(self, r, 811, UiStyle.LINE, UiStyle.INK, Color(1.0, 0.97, 0.88, 0.96))
	var bob := sin(_t * 4.0) * 2.0
	UiStyle.paw(self, r.position + Vector2(28.0, r.size.y * 0.5 + bob), 13.0, Color(1.0, 0.6, 0.45))
	var font := Sketch.font()
	var word := "เป้าหมาย: " + str(_goal.get("text", ""))
	var size := Sketch.fit_size(word, 24, r.size.x - 110.0, UiStyle.SMALL)
	draw_string(font, Vector2(r.position.x + 52.0, r.get_center().y + float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, UiStyle.INK)
	# กากบาทซ่อน
	var c := _close_rect().get_center()
	draw_circle(c, 15.0, Color(0.92, 0.88, 0.82))
	draw_line(c + Vector2(-6.0, -6.0), c + Vector2(6.0, 6.0), UiStyle.INK, 3.0, true)
	draw_line(c + Vector2(6.0, -6.0), c + Vector2(-6.0, 6.0), UiStyle.INK, 3.0, true)

## ตำแหน่งบนจอของของที่ต้องไปหา  คืน Vector2.INF ถ้าไม่มี
func target_screen() -> Vector2:
	var tp := page as TownPage
	if tp == null:
		return Vector2.INF
	var tx := INF
	var want_floor := -1
	var npc_id := str(_goal.get("npc", ""))
	var goal_town := int(_goal.get("town", WalkPage.current_town))
	if npc_id != "" and goal_town == WalkPage.current_town:
		var nd := TownData.npc(npc_id)
		want_floor = int(nd.get("floor", 0))
		if want_floor == tp._floor:
			for n in tp._npcs:
				if is_instance_valid(n) and str(n.data.get("id", "")) == npc_id:
					return (n as Node2D).get_global_transform_with_canvas().origin + Vector2(0.0, -NPC_LIFT)
			tx = float(nd.get("x", 0.0))
	else:
		# ไปดันเจี้ยน หรือเป้าหมายอยู่เมืองอื่น: ไปที่ประตูดันเจี้ยน (เปิดแผนที่เดินทางได้)
		var gate: Dictionary = tp._town.get("dungeon_gate", {})
		if not gate.is_empty():
			want_floor = int(gate.get("floor", 0))
			tx = float(gate.get("x", 0.0))
	if want_floor >= 0 and want_floor != tp._floor:
		# อยู่คนละชั้น ชี้ไปที่ทางวาปที่พาไปทางนั้น
		tx = INF
		for it in tp.interactables():
			if str(it["kind"]) == "warp":
				if tx == INF or int(it["to"]) == want_floor:
					tx = float(it["x"])
	if tx == INF:
		return Vector2.INF
	return _world_to_screen(tp, tx)

func _world_to_screen(tp: TownPage, x: float) -> Vector2:
	var local := Vector2(x * CombatData.UNIT, -tp.ground_h(x) * CombatData.UNIT)
	if tp.style == "curve":
		var sx := x * CombatData.UNIT * WalkPage.ZOOM
		var phi := (sx - tp.cam) / TownPage.PLANET_R
		local = Vector2((tp.cam + TownPage.PLANET_R * sin(phi)) / WalkPage.ZOOM, TownPage.PLANET_R * (1.0 - cos(phi)) / WalkPage.ZOOM)
	return tp.world.get_global_transform_with_canvas() * local + Vector2(0.0, -NPC_LIFT)

func _draw_pointer() -> void:
	var p := target_screen()
	if p == Vector2.INF:
		return
	var v := get_viewport_rect().size
	var bob := absf(sin(_t * 5.0)) * 14.0
	var col := Color(1.0, 0.55, 0.35)
	if p.x > 70.0 and p.x < v.x - 70.0:
		# อยู่ในจอ: อุ้งเท้ากับลูกศรอยู่ข้างเป้าหมาย ฝั่งที่ไม่มีตัวละคร เด้งเข้าหาเป้าหมาย
		var hx: float = page.hero.get_global_transform_with_canvas().origin.x if page.hero != null else 0.0
		var side := 1.0 if hx < p.x else -1.0
		if p.x + side * 140.0 > v.x - 40.0 or p.x + side * 140.0 < 40.0:
			side = -side
		var c := p + Vector2(side * (96.0 + bob), 0.0)
		draw_circle(c + Vector2(0.0, 3.0), 28.0, Color(0.0, 0.0, 0.0, 0.1))
		draw_circle(c, 26.0, Color(1.0, 0.97, 0.9))
		draw_arc(c, 26.0, 0.0, TAU, 32, UiStyle.INK, 3.0, true)
		UiStyle.paw(self, c, 13.0, col)
		var tip := c + Vector2(-side * 58.0, 0.0)
		draw_colored_polygon(PackedVector2Array([tip, tip + Vector2(side * 24.0, -17.0), tip + Vector2(side * 24.0, 17.0)]), col)
		return
	# อยู่นอกจอ: ลูกศรที่ขอบจอชี้ไปทางนั้น
	var right := p.x >= v.x * 0.5
	var y := v.y * 0.42
	var x := v.x - 70.0 - bob if right else 70.0 + bob
	var d := 1.0 if right else -1.0
	draw_circle(Vector2(x, y), 34.0, Color(1.0, 0.97, 0.9, 0.95))
	UiStyle.frame(self, Rect2(x - 34.0, y - 34.0, 68.0, 68.0), 812, 3.0, UiStyle.INK, 34.0)
	var a := Vector2(x + d * 18.0, y)
	draw_colored_polygon(PackedVector2Array([a, a + Vector2(-d * 22.0, -18.0), a + Vector2(-d * 22.0, 18.0)]), col)
	UiStyle.paw(self, Vector2(x - d * 10.0, y), 8.0, col)
	UiStyle.text(self, Vector2(x - d * 6.0, y + 52.0), "ไปทางนี้", UiStyle.SMALL, UiStyle.INK)

func _draw_toast(word: String, left: float) -> void:
	var r := _toast_rect()
	var a := clampf(left / 0.4, 0.0, 1.0) * clampf((TOAST_TIME - left) / 0.25, 0.0, 1.0)
	UiStyle.fill(self, Rect2(r.position + Vector2(3.0, 5.0), r.size), Color(0.0, 0.0, 0.0, 0.12 * a))
	UiStyle.box(self, r, 813, UiStyle.LINE_BOLD, Color(UiStyle.INK, a), Color(1.0, 0.95, 0.9, 0.97 * a))
	UiStyle.paw(self, r.position + Vector2(34.0, r.size.y * 0.5), 15.0, Color(1.0, 0.6, 0.7, a))
	var font := Sketch.font()
	# ตัดเป็น 2 บรรทัดถ้ายาว
	var size := UiStyle.BODY
	var max_w := r.size.x - 90.0
	var lines := _wrap(word, size, max_w)
	var y0 := r.get_center().y - float(lines.size() - 1) * 15.0 + float(size) * 0.36
	for i in lines.size():
		draw_string(font, Vector2(r.position.x + 62.0, y0 + float(i) * 30.0), str(lines[i]), HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, Color(UiStyle.INK, a))

## ตัดบรรทัดตาม \n ก่อน บรรทัดที่ยังยาวเกินตัดทีละตัวอักษร (ภาษาไทยไม่มีช่องว่าง)
func _wrap(word: String, size: int, max_w: float) -> Array:
	var font := Sketch.font()
	var out := []
	for line in word.split("\n"):
		var cur := ""
		for ch in line:
			var tryw: String = cur + ch
			if cur != "" and font.get_string_size(tryw, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x > max_w and not _is_mark(ch):
				out.append(cur)
				cur = ch
			else:
				cur = tryw
		out.append(cur)
	return out.slice(0, 3)

## สระบนล่าง วรรณยุกต์ ห้ามขึ้นต้นบรรทัด
static func _is_mark(ch: String) -> bool:
	var u := ch.unicode_at(0)
	return u == 0x0E31 or (u >= 0x0E33 and u <= 0x0E3A) or (u >= 0x0E47 and u <= 0x0E4E) or u == 0x0E30 or u == 0x0E32 or u == 0x0E45
