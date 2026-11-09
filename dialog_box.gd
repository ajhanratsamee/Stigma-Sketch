class_name DialogBox
extends Node2D
## กล่องคำพูดของ NPC ด้านล่างจอ มุมโค้ง ตัวหนังสือใหญ่ แตะเพื่ออ่านต่อ
## ถ้า NPC มีเควสให้รับหรือส่ง มีปุ่ม รับเควส / ส่งเควส ใช้ QuestData ตามสัญญาใน town_data.gd
## ระบบเควสยังไม่พร้อม (ไม่มีฟังก์ชัน) ก็ยังคุยได้ ใช้คำพูดทั่วไปของ NPC

signal closed

var page: WalkPage
var npc: Dictionary = {}
var lines: Array = []
var line_i := 0
var offer := ""
var turn_in := ""
var reward_text := ""
var _view := Vector2.ZERO

func _ready() -> void:
	z_index = 85
	visible = false

static func quest_has(name: String) -> bool:
	for m in (QuestData as GDScript).get_script_method_list():
		if str(m["name"]) == name:
			return true
	return false

## เรียกฟังก์ชัน static ของ QuestData ตามชื่อ (ระบบเควสยังเพิ่มฟังก์ชันอยู่ เลยไม่ผูกตายตอนคอมไพล์)
static func qcall(name: String, args: Array) -> Variant:
	var script: Variant = load("res://quest_data.gd")
	return script.callv(name, args)

func open(data: Dictionary) -> void:
	_view = get_viewport_rect().size
	npc = data
	offer = ""
	turn_in = ""
	reward_text = ""
	lines = []
	var entry: Dictionary = page.roster_entry() if page != null else {}
	if quest_has("talk"):
		var r = DialogBox.qcall("talk", [str(npc.get("id", "")), entry])
		if r is Dictionary:
			lines = (r as Dictionary).get("lines", [])
			offer = str((r as Dictionary).get("offer", ""))
			turn_in = str((r as Dictionary).get("turn_in", ""))
	if quest_has("on_talk") and not entry.is_empty():
		DialogBox.qcall("on_talk", [entry, str(npc.get("id", ""))])
		_save(entry)
	if lines.is_empty():
		var pool: Array = npc.get("lines", [])
		lines = [pool[randi() % pool.size()]] if not pool.is_empty() else ["เหมียว~"]
	line_i = 0
	visible = true
	queue_redraw()

func _save(entry: Dictionary) -> void:
	if entry.is_empty() or WalkPage.roster_index < 0:
		return
	SaveData.update_character(WalkPage.roster_index, entry)

func box_rect() -> Rect2:
	return Rect2(Vector2(_view.x * 0.12, _view.y * 0.58), Vector2(_view.x * 0.76, _view.y * 0.36))

func _buttons() -> Array:
	var out := []
	if line_i < lines.size() - 1 or reward_text != "":
		return out
	var r := box_rect()
	var w := 220.0
	var y := r.end.y - 78.0
	var x := r.end.x - 24.0
	out.append(["close", Rect2(Vector2(x - w, y), Vector2(w, 60.0)), "ปิด"])
	x -= w + 16.0
	if turn_in != "":
		out.append(["turn_in", Rect2(Vector2(x - w, y), Vector2(w, 60.0)), "ส่งเควส"])
		x -= w + 16.0
	if offer != "":
		out.append(["offer", Rect2(Vector2(x - w, y), Vector2(w, 60.0)), "รับเควส"])
	return out

func tap(at: Vector2) -> void:
	for b in _buttons():
		if (b[1] as Rect2).has_point(at):
			_press(str(b[0]))
			return
	if reward_text != "":
		reward_text = ""
		queue_redraw()
		return
	if line_i < lines.size() - 1:
		line_i += 1
		queue_redraw()
		return
	if _buttons().size() <= 1:
		_close()

func _press(id: String) -> void:
	var entry: Dictionary = page.roster_entry() if page != null else {}
	match id:
		"close":
			_close()
		"offer":
			if quest_has("accept") and not entry.is_empty():
				DialogBox.qcall("accept", [entry, offer])
				_save(entry)
			reward_text = "รับเควสแล้ว!"
			offer = ""
			queue_redraw()
		"turn_in":
			var got = {}
			if quest_has("turn_in") and not entry.is_empty():
				got = DialogBox.qcall("turn_in", [entry, turn_in])
				_save(entry)
			reward_text = "ส่งเควสแล้ว!"
			if got is Dictionary and (got as Dictionary).has("exp"):
				reward_text += "  ได้ EXP %d" % int(got["exp"])
				if page != null and page.has_method("gain_exp"):
					page.gain_exp(int(got["exp"]))
			turn_in = ""
			queue_redraw()

func _close() -> void:
	visible = false
	closed.emit()

func _draw() -> void:
	if not visible:
		return
	var r := box_rect()
	draw_rect(Rect2(Vector2.ZERO, _view), Color(0.2, 0.18, 0.2, 0.15))
	UiStyle.box(self, r, 911, UiStyle.LINE_BOLD)
	# ป้ายชื่อ NPC มุมซ้ายบนของกล่อง
	var nm := str(npc.get("name", ""))
	var font := Sketch.font()
	var nw := font.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1.0, UiStyle.NAME).x
	var tag := Rect2(r.position + Vector2(28.0, -30.0), Vector2(nw + 48.0, 56.0))
	UiStyle.box(self, tag, 912, UiStyle.LINE, UiStyle.INK, UiStyle.PICKED)
	UiStyle.paw(self, tag.position + Vector2(18.0, tag.size.y * 0.5), 10.0)
	draw_string(font, tag.position + Vector2(32.0, tag.size.y * 0.5 + 10.0), nm, HORIZONTAL_ALIGNMENT_LEFT, -1.0, UiStyle.NAME, UiStyle.INK)
	var text: String = reward_text if reward_text != "" else str(lines[line_i]) if line_i < lines.size() else ""
	var tw := r.size.x - 70.0
	var y := r.position.y + 70.0
	for row in _wrap(text, tw, 30):
		draw_string(font, Vector2(r.position.x + 36.0, y), row, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, UiStyle.INK)
		y += 42.0
	for b in _buttons():
		UiStyle.button(self, b[1], b[2], 913 + int(b[1].position.x), true, b[0] != "close")
	if (line_i < lines.size() - 1) or reward_text != "":
		var c := r.end - Vector2(40.0, 34.0)
		draw_colored_polygon(PackedVector2Array([c + Vector2(-12.0, -6.0), c + Vector2(12.0, -6.0), c + Vector2(0.0, 8.0)]), UiStyle.INK)

## ตัดบรรทัดตามความกว้าง ภาษาไทยไม่มีช่องว่าง เลยตัดทีละตัวอักษร
func _wrap(text: String, width: float, size: int) -> Array:
	var font := Sketch.font()
	var out := []
	var cur := ""
	for ch in text:
		var next := cur + ch
		var code := ch.unicode_at(0)
		var mark := code == 0x0E31 or (code >= 0x0E34 and code <= 0x0E3A) or (code >= 0x0E47 and code <= 0x0E4E)
		if not mark and font.get_string_size(next, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x > width and cur != "":
			out.append(cur)
			cur = ch
		else:
			cur = next
	if cur != "":
		out.append(cur)
	return out
