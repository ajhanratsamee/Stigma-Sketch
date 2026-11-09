class_name QuestPanel
extends Node2D
## แผงเควสในเมือง กระดาษครีม อ่านง่าย ตัวใหญ่ มี 4 แท็บ
##  กระดาน  เควสกระดานของวันนี้ + เควสหลัก/รองที่รับได้ในเมืองนี้
##  เควสของฉัน  เควสที่รับไว้ ความคืบหน้า ปุ่มส่งเควส
##  จดหมาย  อ่านจดหมาย รับรางวัล
##  เปลี่ยนคลาส  เควสเปลี่ยนคลาส (แบบเดิม) ส่งแล้วเลือกคลาสใหม่
## เปิดจากหน้าอื่น: open_board(town) / open_log() / open_mail() / open_class() / open() (กระดานของเมืองนี้)

signal closed

const PANEL := Vector2(1240.0, 620.0)
const INK := UiStyle.INK
const PARCH := Color(0.98, 0.94, 0.84)
const PARCH_DARK := Color(0.86, 0.76, 0.58)
const OK_COLOR := Color(0.25, 0.55, 0.3)
const NO_COLOR := Color(0.8, 0.22, 0.2)
const BTN := Vector2(300.0, 76.0)
const CARD := Vector2(250.0, 170.0)

const TABS := [["board", "กระดาน"], ["log", "เควสของฉัน"], ["mail", "จดหมาย"], ["class", "เปลี่ยนคลาส"]]
const ROWS := 4
const ROW_H := 98.0
const LIST_TOP := 160.0

var mode := "board"
var town := 0
var page := 0
var detail := ""                # id เควสหรือจดหมายที่เปิดอ่านอยู่
var toast := ""
var _toast_t := 0.0
var picking := false            # ส่งเควสแล้ว กำลังเลือกคลาส
var pick := ""
var _view := Vector2.ZERO
var _t := 0.0

func _ready() -> void:
	_view = get_viewport_rect().size

func open() -> void:
	open_board(WalkPage.current_town)

func _show(m: String) -> void:
	mode = m
	page = 0
	detail = ""
	picking = false
	pick = ""
	visible = true
	queue_redraw()

func open_board(t := -1) -> void:
	town = WalkPage.current_town if t < 0 else t
	_show("board")

func open_log() -> void:
	town = WalkPage.current_town
	_show("log")

func open_mail() -> void:
	town = WalkPage.current_town
	_show("mail")

func open_class() -> void:
	town = WalkPage.current_town
	_show("class")

func _process(delta: float) -> void:
	if visible:
		_t += delta
		_toast_t = maxf(_toast_t - delta, 0.0)
		queue_redraw()

func panel_rect() -> Rect2:
	return Rect2((_view - PANEL) * 0.5, PANEL)

func close_center() -> Vector2:
	return panel_rect().position + Vector2(PANEL.x - 40.0, 40.0)

func button_rect() -> Rect2:
	var r := panel_rect()
	var size := Vector2(480.0, BTN.y) if picking else BTN
	return Rect2(Vector2(r.position.x + (PANEL.x - size.x) * 0.5, r.end.y - 30.0 - size.y), size)

func card_rect(i: int, n: int) -> Rect2:
	var r := panel_rect()
	var gap := 30.0
	var total := float(n) * CARD.x + float(n - 1) * gap
	return Rect2(Vector2(r.position.x + (PANEL.x - total) * 0.5 + float(i) * (CARD.x + gap), r.position.y + 210.0), CARD)

func tab_rect(i: int) -> Rect2:
	var r := panel_rect()
	var w := 230.0
	var gap := 14.0
	var total := float(TABS.size()) * w + float(TABS.size() - 1) * gap
	return Rect2(Vector2(r.position.x + (PANEL.x - total) * 0.5 + float(i) * (w + gap), r.position.y + 78.0), Vector2(w, 58.0))

func row_rect(i: int) -> Rect2:
	var r := panel_rect()
	return Rect2(Vector2(r.position.x + 40.0, r.position.y + LIST_TOP + float(i) * (ROW_H + 8.0)), Vector2(PANEL.x - 160.0, ROW_H))

func row_button(i: int) -> Rect2:
	var rr := row_rect(i)
	return Rect2(Vector2(rr.end.x - 200.0, rr.position.y + (ROW_H - 64.0) * 0.5), Vector2(184.0, 64.0))

func page_rect(up: bool) -> Rect2:
	var r := panel_rect()
	return Rect2(Vector2(r.end.x - 100.0, r.position.y + LIST_TOP + (0.0 if up else 3.0 * (ROW_H + 8.0) + ROW_H - 70.0)), Vector2(70.0, 70.0))

func detail_button() -> Rect2:
	var r := panel_rect()
	return Rect2(Vector2(r.position.x + (PANEL.x - 420.0) * 0.5, r.end.y - 30.0 - BTN.y), Vector2(420.0, BTN.y))

func back_rect() -> Rect2:
	var r := panel_rect()
	return Rect2(Vector2(r.position.x + 40.0, r.end.y - 30.0 - BTN.y), Vector2(200.0, BTN.y))

## รายการของแท็บนี้ [{"kind": "quest"|"mail", "id"}]
func items(entry: Dictionary) -> Array:
	var out := []
	match mode:
		"board":
			for q in QuestData.board_quests(entry, town):
				out.append({"kind": "quest", "id": str(q["id"])})
			for q in QuestData.offers(entry, town):
				out.append({"kind": "quest", "id": str(q["id"])})
		"log":
			for id in QuestData.active_list(entry):
				out.append({"kind": "quest", "id": id})
		"mail":
			for m in QuestData.mail(entry):
				out.append({"kind": "mail", "id": str(m["id"])})
	return out

## เป้าหมายของเควสเป็นข้อความสั้นๆ พร้อมความคืบหน้า
func goal_text(entry: Dictionary, q: Dictionary) -> String:
	var g: Dictionary = q["goal"]
	var p := QuestData.progress_of(entry, str(q["id"]))
	var st := QuestData.state(entry, str(q["id"]))
	var shown := st in ["active", "ready"]
	match str(g["type"]):
		"kill":
			var who := "มอน" if str(g.get("kind", "")) == "" else str(CatLook.NAMES.get(str(g["kind"]), "มอน"))
			return "ปราบ%s %s" % [who, ("%d / %d" % [p.x, p.y]) if shown else "%d ตัว" % p.y]
		"clear":
			var di := int(g.get("dungeon", -1))
			return "ผ่าน%s" % (str(DungeonData.dungeon(int(g.get("town", q["town"])), di).get("name", "")) if di >= 0 else "ดันเจี้ยนไหนก็ได้")
		"level":
			return "เลเวล %d  (ตอนนี้ %d)" % [int(g["lv"]), int(entry.get("level", 1))]
		"talk":
			var n := TownData.npc(QuestData.turn_in_npc(q))
			var who := str(n.get("name", "")) if not n.is_empty() else "คนในเมือง"
			return "ไปคุยกับ%s  %s" % [who, DungeonData.town_name(int(g.get("town", q["town"])))]
	return ""

func _chain_tag(q: Dictionary) -> String:
	return str({"main": "หลัก", "side": "รอง", "board": "กระดาน"}.get(str(q["chain"]), ""))

func _chain_color(q: Dictionary) -> Color:
	return {"main": Color(0.85, 0.4, 0.3), "side": Color(0.35, 0.55, 0.8), "board": Color(0.4, 0.62, 0.35)}.get(str(q["chain"]), INK)

## ปุ่มของเควสนี้ [ข้อความ กดได้]
func quest_action(entry: Dictionary, id: String) -> Array:
	var q := QuestData.quest(id)
	match QuestData.state(entry, id):
		"":
			if QuestData.can_accept(entry, q):
				return ["รับเควส", true]
			if int(entry.get("level", 1)) < int(q["level"]):
				return ["ต้อง Lv.%d" % int(q["level"]), false]
			return ["ทำเควสหลักก่อน", false]
		"ready":
			return ["ส่งเควส!", true]
		"active":
			return ["กำลังทำ", false]
		"done":
			return ["เสร็จแล้ว", false]
	return ["", false]

func _do_quest(entry: Dictionary, id: String) -> void:
	match QuestData.state(entry, id):
		"":
			if QuestData.accept(entry, id):
				QuestData.commit(entry)
				_say("รับเควสแล้ว เหมียว!")
		"ready":
			var reward := QuestData.turn_in(entry, id)
			QuestData.commit(entry)
			QuestData.grant(reward)
			var word := "+%d EXP" % int(reward.get("exp", 0))
			if str(reward.get("title", "")) != "":
				word += "  ได้ฉายา " + str(reward["title"])
			_say("ส่งเควสแล้ว " + word)

func _do_mail(entry: Dictionary, id: String) -> void:
	QuestData.read_mail(entry, id)
	var reward := QuestData.claim_mail(entry, id)
	QuestData.commit(entry)
	if not reward.is_empty() and int(reward.get("exp", 0)) > 0:
		QuestData.grant(reward)
		_say("ได้รับ +%d EXP" % int(reward["exp"]))

func _say(word: String) -> void:
	toast = word
	_toast_t = 2.2

func _entry() -> Dictionary:
	var list := SaveData.roster()
	var i := WalkPage.roster_index
	return list[i] if i >= 0 and i < list.size() else {}

func quest() -> Dictionary:
	return QuestData.next_quest(WalkPage.chosen_weapon, WalkPage.chosen_class)

## รับเควสได้ไหม คืนเหตุผลถ้าไม่ได้
func accept_block() -> String:
	var q := quest()
	if q.is_empty():
		return "ไม่มีเควส"
	if WalkPage.chosen_level < int(q["level"]):
		return "ต้องเลเวล %d" % int(q["level"])
	if WalkPage.current_town != int(q["town"]):
		return "ไปรับที่%s" % DungeonData.town_name(int(q["town"]))
	return ""

func tap(at: Vector2) -> void:
	if at.distance_to(close_center()) <= 36.0:
		visible = false
		closed.emit()
		return
	for i in TABS.size():
		if tab_rect(i).has_point(at):
			_show(str(TABS[i][0]))
			return
	if mode != "class":
		_tap_list(at)
		return
	var entry := _entry()
	var q := quest()
	if entry.is_empty() or q.is_empty():
		return
	if picking:
		var list := QuestData.choices(WalkPage.chosen_weapon, WalkPage.chosen_class)
		for i in list.size():
			if card_rect(i, list.size()).has_point(at):
				pick = str(list[i])
				queue_redraw()
				return
		if pick != "" and button_rect().has_point(at):
			change_class(pick)
		return
	if not button_rect().has_point(at):
		return
	var p := QuestData.progress(entry, q)
	if p.is_empty():
		if accept_block() == "":
			SaveData.update_character(WalkPage.roster_index, {"quest": {"id": q["id"], "kills": 0, "clears": []}})
	elif QuestData.is_done(entry, q):
		picking = true
		var list := QuestData.choices(WalkPage.chosen_weapon, WalkPage.chosen_class)
		pick = str(list[0]) if list.size() == 1 else ""
	queue_redraw()

func _tap_list(at: Vector2) -> void:
	var entry := _entry()
	if entry.is_empty():
		return
	if detail != "":
		if back_rect().has_point(at):
			detail = ""
		elif detail_button().has_point(at):
			if mode == "mail":
				var m := _mail(entry, detail)
				var mq := str(m.get("quest", ""))
				var gift := int(m.get("reward", {}).get("exp", 0))
				if gift > 0 and not bool(m.get("claimed", false)):
					_do_mail(entry, detail)
				elif mq != "" and QuestData.can_accept(entry, QuestData.quest(mq)):
					_do_quest(entry, mq)
			else:
				_do_quest(entry, detail)
		queue_redraw()
		return
	var list := items(entry)
	var pages := maxi(ceili(float(list.size()) / float(ROWS)), 1)
	if page_rect(true).has_point(at):
		page = maxi(page - 1, 0)
		return
	if page_rect(false).has_point(at):
		page = mini(page + 1, pages - 1)
		return
	for i in ROWS:
		var k := page * ROWS + i
		if k >= list.size():
			break
		var it: Dictionary = list[k]
		if str(it["kind"]) == "quest" and row_button(i).has_point(at):
			var act := quest_action(entry, str(it["id"]))
			if bool(act[1]):
				_do_quest(entry, str(it["id"]))
			return
		if row_rect(i).has_point(at):
			detail = str(it["id"])
			if str(it["kind"]) == "mail":
				QuestData.read_mail(entry, detail)
				QuestData.commit(entry)
			return

## เปลี่ยนคลาส ล้างเควส บันทึก แล้วโหลดเมืองใหม่ให้ร่าง สกิล คอมโบ เปลี่ยนตาม
func change_class(id: String) -> void:
	SaveData.update_character(WalkPage.roster_index, {"class": id, "quest": {}})
	WalkPage.chosen_class = id
	visible = false
	get_tree().change_scene_to_file("res://town.tscn")

func _text(at: Vector2, word: String, size: int, color := INK, center := true) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
	draw_string(font, at + Vector2(-w * 0.5 if center else 0.0, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _box(r: Rect2, fill: Color, seed_no: int, width := UiStyle.LINE) -> void:
	UiStyle.box(self, r, seed_no, width, INK, fill)

func _tick(at: Vector2, ok: bool) -> void:
	draw_circle(at, 15.0, OK_COLOR if ok else Color(0.85, 0.82, 0.76))
	if ok:
		draw_polyline(PackedVector2Array([at + Vector2(-7.0, 0.0), at + Vector2(-2.0, 6.0), at + Vector2(8.0, -6.0)]), Color.WHITE, 4.0, true)

## แมวหัวหน้ากิลด์ ใส่หมวก ถือม้วนเควส
func _npc(c: Vector2) -> void:
	var bob := sin(_t * 2.5) * 4.0
	c.y += bob
	for side in [-1.0, 1.0]:
		draw_colored_polygon(PackedVector2Array([c + Vector2(side * 22.0, -40.0), c + Vector2(side * 48.0, -78.0), c + Vector2(side * 52.0, -28.0)]), Color(0.95, 0.75, 0.5))
		draw_colored_polygon(PackedVector2Array([c + Vector2(side * 30.0, -42.0), c + Vector2(side * 46.0, -66.0), c + Vector2(side * 47.0, -36.0)]), Color(1.0, 0.7, 0.75))
	draw_circle(c, 56.0, Color(0.95, 0.75, 0.5))
	draw_arc(c, 56.0, 0.0, TAU, 40, INK, 3.0, true)
	for side in [-1.0, 1.0]:
		draw_arc(c + Vector2(side * 20.0, -6.0), 8.0, PI * 1.1, PI * 1.9, 8, INK, 4.0, true)
		draw_line(c + Vector2(side * 30.0, 14.0), c + Vector2(side * 66.0, 8.0), INK, 2.0)
		draw_line(c + Vector2(side * 30.0, 20.0), c + Vector2(side * 66.0, 22.0), INK, 2.0)
		draw_circle(c + Vector2(side * 34.0, 10.0), 8.0, Color(1.0, 0.55, 0.6, 0.5))
	draw_arc(c + Vector2(-6.0, 14.0), 6.0, 0.0, PI, 8, INK, 3.0, true)
	draw_arc(c + Vector2(6.0, 14.0), 6.0, 0.0, PI, 8, INK, 3.0, true)
	# หมวกกิลด์
	draw_rect(Rect2(c + Vector2(-40.0, -66.0), Vector2(80.0, 12.0)), Color(0.55, 0.3, 0.6))
	draw_colored_polygon(PackedVector2Array([c + Vector2(-26.0, -66.0), c + Vector2(0.0, -110.0), c + Vector2(26.0, -66.0)]), Color(0.65, 0.38, 0.72))
	draw_circle(c + Vector2(0.0, -110.0), 7.0, Color(1.0, 0.85, 0.3))
	# กระดิ่งที่คอ
	draw_circle(c + Vector2(0.0, 58.0), 10.0, Color(1.0, 0.82, 0.3))
	draw_arc(c + Vector2(0.0, 58.0), 10.0, 0.0, TAU, 16, INK, 2.0, true)

func _draw() -> void:
	if not visible:
		return
	draw_rect(Rect2(Vector2.ZERO, _view), Color(1.0, 0.98, 0.94, 0.5))
	var r := panel_rect()
	UiStyle.fill(self, r.grow(10.0), PARCH_DARK, UiStyle.RADIUS + 8.0)
	_box(r, PARCH, 900, UiStyle.LINE_BOLD * 0.7)
	UiStyle.paw(self, r.position + Vector2(40.0, 40.0), 20.0)
	UiStyle.paw(self, r.position + Vector2(r.size.x - 90.0, 40.0), 20.0)
	var a := r.position
	_text(a + Vector2(PANEL.x * 0.5, 44.0), "เควส  " + DungeonData.town_name(WalkPage.current_town), 34)
	var entry0 := _entry()
	for i in TABS.size():
		var tr := tab_rect(i)
		var on: bool = str(TABS[i][0]) == mode
		_box(tr, UiStyle.PICKED if on else Color(1.0, 0.99, 0.96), 930 + i, UiStyle.LINE_BOLD if on else UiStyle.LINE)
		var label := str(TABS[i][1])
		if str(TABS[i][0]) == "mail" and not entry0.is_empty():
			var un := QuestData.unread(entry0)
			if un > 0:
				label += " (%d)" % un
		UiStyle.text(self, tr.get_center(), label, UiStyle.BODY + 2, INK, tr.size.x - 16.0)
	# ปุ่มปิด
	var cc := close_center()
	draw_circle(cc, 28.0, Color(1.0, 0.97, 0.88))
	draw_arc(cc, 28.0, 0.0, TAU, 24, INK, 3.0, true)
	draw_line(cc + Vector2(-10.0, -10.0), cc + Vector2(10.0, 10.0), INK, 4.0)
	draw_line(cc + Vector2(10.0, -10.0), cc + Vector2(-10.0, 10.0), INK, 4.0)
	var entry := _entry()
	var q := quest()
	if entry.is_empty():
		_npc(a + Vector2(160.0, 300.0))
		_text(a + Vector2(PANEL.x * 0.5 + 80.0, 300.0), "ตัวทดลองเล่นรับเควสไม่ได้นะเหมียว", 30)
		return
	if mode != "class":
		_draw_list(entry)
		_draw_toast()
		return
	if q.is_empty():
		_npc(a + Vector2(160.0, 300.0))
		_text(a + Vector2(PANEL.x * 0.5 + 80.0, 280.0), "ผ่านเควสเปลี่ยนคลาสครบแล้ว เก่งมากเหมียว!", 30)
		_text(a + Vector2(PANEL.x * 0.5 + 80.0, 330.0), "คลาสตอนนี้  " + WalkPage.chosen_class, 26, OK_COLOR)
		return
	if picking:
		_draw_pick()
		return
	# ขยับลงให้พ้นแถบแท็บ
	draw_set_transform(Vector2(0.0, 50.0), 0.0, Vector2.ONE)
	_npc(a + Vector2(150.0, 260.0))
	var x0 := a.x + 290.0
	_text(Vector2(x0, a.y + 110.0), str(q["title"]), 34, Color(0.6, 0.25, 0.5), false)
	Sketch.draw_wrapped(self, Vector2(x0, a.y + 140.0), str(q["text"]), 24, PANEL.x - 340.0, 80.0, INK)
	var lv_ok := WalkPage.chosen_level >= int(q["level"])
	var town_ok := WalkPage.current_town == int(q["town"])
	var y := a.y + 250.0
	_tick(Vector2(x0 + 15.0, y), lv_ok)
	_text(Vector2(x0 + 44.0, y), "เลเวล %d ขึ้นไป  (ตอนนี้ Lv.%d)" % [int(q["level"]), WalkPage.chosen_level], 26, INK if lv_ok else NO_COLOR, false)
	y += 48.0
	_tick(Vector2(x0 + 15.0, y), town_ok)
	_text(Vector2(x0 + 44.0, y), "รับเควสที่%s" % DungeonData.town_name(int(q["town"])), 26, INK if town_ok else NO_COLOR, false)
	var p := QuestData.progress(entry, q)
	if not p.is_empty():
		var kills := mini(int(p.get("kills", 0)), int(q["kills"]))
		var clears := mini((p.get("clears", []) as Array).size(), int(q["clears"]))
		y += 48.0
		_tick(Vector2(x0 + 15.0, y), kills >= int(q["kills"]))
		_text(Vector2(x0 + 44.0, y), "ปราบมอนในดันเจี้ยนของเมืองนี้  %d / %d" % [kills, int(q["kills"])], 26, INK, false)
		y += 48.0
		_tick(Vector2(x0 + 15.0, y), clears >= int(q["clears"]))
		_text(Vector2(x0 + 44.0, y), "ผ่านดันเจี้ยนของเมืองนี้  %d / %d" % [clears, int(q["clears"])], 26, INK, false)
	# ปุ่ม
	var word := ""
	var on := false
	if p.is_empty():
		var why := accept_block()
		on = why == ""
		word = "รับเควส" if on else why
	elif QuestData.is_done(entry, q):
		on = true
		word = "ส่งเควส!"
	else:
		word = "กำลังทำเควส..."
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var g := button_rect()
	_box(g, Color(0.85, 0.35, 0.5) if on else Color(0.66, 0.62, 0.6), 905)
	_text(g.get_center(), word, 30, Color(1.0, 0.97, 0.92))

func _draw_toast() -> void:
	if _toast_t <= 0.0 or toast == "":
		return
	var r := panel_rect()
	var a := minf(_toast_t * 2.0, 1.0)
	# ทับหัวข้อแผงชั่วคราว ไม่บังรายการ
	var tr := Rect2(Vector2(r.position.x + PANEL.x * 0.5 - 330.0, r.position.y + 16.0), Vector2(660.0, 56.0))
	UiStyle.fill(self, tr, Color(1.0, 0.92, 0.6, a), 26.0)
	UiStyle.text(self, tr.get_center(), toast, UiStyle.BODY, Color(INK, a), tr.size.x - 20.0)

func _draw_list(entry: Dictionary) -> void:
	var r := panel_rect()
	if detail != "":
		_draw_detail(entry)
		return
	var list := items(entry)
	if list.is_empty():
		_npc(r.position + Vector2(160.0, 360.0))
		var word := str({"board": "วันนี้ไม่มีงานบนกระดานแล้ว พรุ่งนี้มาใหม่นะเหมียว", "log": "ยังไม่ได้รับเควสเลย ไปดูที่กระดานหรือคุยกับคนในเมืองสิ", "mail": "ตู้จดหมายว่างเปล่า"}.get(mode, ""))
		Sketch.draw_wrapped(self, r.position + Vector2(300.0, 330.0), word, UiStyle.NAME, PANEL.x - 360.0, 120.0, INK)
		return
	var pages := maxi(ceili(float(list.size()) / float(ROWS)), 1)
	page = clampi(page, 0, pages - 1)
	for i in ROWS:
		var k := page * ROWS + i
		if k >= list.size():
			break
		var it: Dictionary = list[k]
		var rr := row_rect(i)
		if str(it["kind"]) == "mail":
			var m := _mail(entry, str(it["id"]))
			var unread := not bool(m.get("read", false))
			_box(rr, UiStyle.PICKED if unread else Color(1.0, 0.99, 0.96), 940 + i)
			_letter(rr.position + Vector2(48.0, ROW_H * 0.5), unread)
			_text(rr.position + Vector2(96.0, 32.0), str(m.get("title", "")), UiStyle.NAME - 2, INK, false)
			_text(rr.position + Vector2(96.0, 70.0), "จาก " + str(m.get("from", "")), UiStyle.SMALL, UiStyle.DIM, false)
			if int(m.get("reward", {}).get("exp", 0)) > 0 and not bool(m.get("claimed", false)):
				_text(Vector2(rr.end.x - 110.0, rr.position.y + ROW_H * 0.5), "มีของขวัญ", UiStyle.SMALL, Color(0.8, 0.45, 0.2))
			continue
		var q := QuestData.quest(str(it["id"]))
		var st := QuestData.state(entry, str(it["id"]))
		_box(rr, Color(1.0, 0.96, 0.85) if st == "ready" else Color(1.0, 0.99, 0.96), 940 + i)
		# ป้ายสายเควส
		var tag := Rect2(rr.position + Vector2(16.0, 16.0), Vector2(84.0, 34.0))
		UiStyle.fill(self, tag, _chain_color(q), 17.0)
		UiStyle.text(self, tag.get_center(), _chain_tag(q), UiStyle.SMALL, Color.WHITE)
		_text(rr.position + Vector2(114.0, 33.0), str(q["title"]), UiStyle.NAME - 2, INK, false)
		_text(rr.position + Vector2(114.0, 72.0), goal_text(entry, q), UiStyle.SMALL + 1, OK_COLOR if st == "ready" else INK, false)
		var act := quest_action(entry, str(it["id"]))
		var b := row_button(i)
		_box(b, Color(0.85, 0.35, 0.5) if bool(act[1]) else Color(0.8, 0.77, 0.72), 950 + i)
		UiStyle.text(self, b.get_center(), str(act[0]), UiStyle.BODY + 2, Color(1.0, 0.97, 0.92), b.size.x - 12.0)
	if pages > 1:
		for up in [true, false]:
			var pr := page_rect(up)
			var on: bool = (page > 0) if up else (page < pages - 1)
			_box(pr, Color(1.0, 0.99, 0.96) if on else Color(0.9, 0.88, 0.84), 960 if up else 961)
			var c := pr.get_center()
			var d := -1.0 if up else 1.0
			draw_colored_polygon(PackedVector2Array([c + Vector2(-16.0, -8.0 * d), c + Vector2(16.0, -8.0 * d), c + Vector2(0.0, 12.0 * d)]), INK if on else UiStyle.DIM)
		_text(Vector2(r.end.x - 65.0, r.position.y + LIST_TOP + 2.0 * (ROW_H + 8.0)), "%d/%d" % [page + 1, pages], UiStyle.SMALL)

func _mail(entry: Dictionary, id: String) -> Dictionary:
	for m in QuestData.mail(entry):
		if str(m["id"]) == id:
			return m
	return {}

## ซองจดหมายเล็กๆ ยังไม่อ่านมีหัวใจแปะ
func _letter(c: Vector2, unread: bool) -> void:
	var rr := Rect2(c - Vector2(30.0, 20.0), Vector2(60.0, 40.0))
	UiStyle.fill(self, rr, Color(1.0, 0.98, 0.92), 6.0)
	UiStyle.frame(self, rr, 970, 2.5, INK, 6.0)
	draw_polyline(PackedVector2Array([rr.position, c + Vector2(0.0, 4.0), Vector2(rr.end.x, rr.position.y)]), INK, 2.5, true)
	if unread:
		draw_circle(c + Vector2(-4.0, 6.0), 6.0, Color(1.0, 0.5, 0.6))
		draw_circle(c + Vector2(4.0, 6.0), 6.0, Color(1.0, 0.5, 0.6))
		draw_colored_polygon(PackedVector2Array([c + Vector2(-10.0, 8.0), c + Vector2(10.0, 8.0), c + Vector2(0.0, 18.0)]), Color(1.0, 0.5, 0.6))

func _draw_detail(entry: Dictionary) -> void:
	var r := panel_rect()
	var a := r.position
	var x0 := a.x + 290.0
	var word := ""
	var on := false
	if mode == "mail":
		var m := _mail(entry, detail)
		_letter(a + Vector2(150.0, 300.0), false)
		_text(Vector2(x0, a.y + 185.0), str(m.get("title", "")), 32, Color(0.6, 0.25, 0.5), false)
		_text(Vector2(x0, a.y + 225.0), "จาก " + str(m.get("from", "")), UiStyle.SMALL + 2, UiStyle.DIM, false)
		Sketch.draw_wrapped(self, Vector2(x0, a.y + 255.0), str(m.get("text", "")), UiStyle.BODY + 2, PANEL.x - 340.0, 170.0, INK, UiStyle.SMALL)
		var gift := int(m.get("reward", {}).get("exp", 0))
		var mq := str(m.get("quest", ""))
		if gift > 0 and not bool(m.get("claimed", false)):
			word = "รับของขวัญ +%d EXP" % gift
			on = true
		elif mq != "" and QuestData.can_accept(entry, QuestData.quest(mq)):
			word = "รับเควสนี้"
			on = true
		else:
			word = "อ่านแล้ว"
	else:
		var q := QuestData.quest(detail)
		_npc(a + Vector2(150.0, 320.0))
		var tag := Rect2(Vector2(x0, a.y + 160.0), Vector2(84.0, 34.0))
		UiStyle.fill(self, tag, _chain_color(q), 17.0)
		UiStyle.text(self, tag.get_center(), _chain_tag(q), UiStyle.SMALL, Color.WHITE)
		_text(Vector2(x0 + 100.0, a.y + 178.0), str(q["title"]), 32, Color(0.6, 0.25, 0.5), false)
		Sketch.draw_wrapped(self, Vector2(x0, a.y + 215.0), str(q["text"]), UiStyle.BODY + 2, PANEL.x - 340.0, 120.0, INK, UiStyle.SMALL)
		var giver := TownData.npc(QuestData.giver_of(q))
		var y := a.y + 360.0
		_tick(Vector2(x0 + 15.0, y), QuestData.state(entry, detail) in ["ready", "done"])
		_text(Vector2(x0 + 44.0, y), goal_text(entry, q), UiStyle.BODY + 2, INK, false)
		y += 44.0
		_text(Vector2(x0 + 44.0, y), "ผู้ให้เควส: %s   เลเวล %d ขึ้นไป" % [str(giver.get("name", "กระดานเควส")), int(q["level"])], UiStyle.SMALL + 1, UiStyle.DIM, false)
		var act := quest_action(entry, detail)
		word = str(act[0])
		on = bool(act[1])
	var g := detail_button()
	_box(g, Color(0.85, 0.35, 0.5) if on else Color(0.66, 0.62, 0.6), 980)
	UiStyle.text(self, g.get_center(), word, 28, Color(1.0, 0.97, 0.92), g.size.x - 16.0)
	UiStyle.button(self, back_rect(), "กลับ", 981)

func _draw_pick() -> void:
	var a := panel_rect().position
	_text(a + Vector2(PANEL.x * 0.5, 130.0), "เควสสำเร็จ! เลือกคลาสใหม่ได้เลยเหมียว", 32, Color(0.6, 0.25, 0.5))
	var list := QuestData.choices(WalkPage.chosen_weapon, WalkPage.chosen_class)
	for i in list.size():
		var c := card_rect(i, list.size())
		var on: bool = str(list[i]) == pick
		_box(c, Color(1.0, 0.9, 0.93) if on else Color(1.0, 0.99, 0.96), 910 + i, 5.0 if on else 3.0)
		# รอยเท้าแมวบนการ์ด
		var pc := c.position + Vector2(CARD.x * 0.5, 62.0)
		draw_circle(pc, 24.0, Color(1.0, 0.65, 0.75))
		for j in 3:
			draw_circle(pc + Vector2((float(j) - 1.0) * 20.0, -30.0 - (6.0 if j == 1 else 0.0)), 10.0, Color(1.0, 0.65, 0.75))
		_text(c.position + Vector2(CARD.x * 0.5, 130.0), str(list[i]), 22 if str(list[i]).length() < 16 else 18)
	var g := button_rect()
	_box(g, Color(0.85, 0.35, 0.5) if pick != "" else Color(0.66, 0.62, 0.6), 920)
	_text(g.get_center(), "เปลี่ยนเป็น " + pick if pick != "" else "แตะเลือกคลาส", 26 if pick.length() < 14 else 22, Color(1.0, 0.97, 0.92))
