class_name SettingsPanel
extends Node2D
## แผงตั้งค่าโทนนุ่ม: ความดังเพลง เสียงเอฟเฟกต์ สั่น ความโปร่งช่องสกิล ขนาดปุ่ม โหมดลื่น  แตะนอกแผงหรือปุ่ม "เสร็จ" คือปิด

signal closed

const W := 720.0
const ROW_H := 70.0
const ROWS := 6
const TOP := 96.0
const STEP := 0.1
const LABEL_SIZE := 28
const VALUE_SIZE := 28

var page: Node = null              # หน้าเล่น (ปรับปุ่มทันทีเมื่อเปลี่ยนขนาด/ความโปร่ง) ว่างได้

func _ready() -> void:
	z_index = 95
	GameSettings.ensure()

func open() -> void:
	visible = true
	queue_redraw()

func close() -> void:
	visible = false
	closed.emit()

func _view() -> Vector2:
	return get_viewport_rect().size

func card() -> Rect2:
	var v := _view()
	var h := TOP + ROW_H * float(ROWS) + 104.0
	return Rect2(Vector2(v.x * 0.5 - W * 0.5, v.y * 0.5 - h * 0.5), Vector2(W, h))

func row_y(i: int) -> float:
	return card().position.y + TOP + ROW_H * float(i) + ROW_H * 0.5

## ปุ่มของแต่ละแถว: [รหัส, กรอบ]
func hit_rects() -> Array:
	var c := card()
	var out := []
	var x1 := c.end.x - 40.0
	for i in 2:
		var y := row_y(i)
		out.append(["minus%d" % i, Rect2(Vector2(x1 - 250.0, y - 28.0), Vector2(56.0, 56.0))])
		out.append(["plus%d" % i, Rect2(Vector2(x1 - 56.0, y - 28.0), Vector2(56.0, 56.0))])
	out.append(["vib", Rect2(Vector2(x1 - 250.0, row_y(2) - 28.0), Vector2(250.0, 56.0))])
	out.append(["smooth", Rect2(Vector2(x1 - 250.0, row_y(5) - 28.0), Vector2(250.0, 56.0))])
	for k in 3:
		out.append(["alpha%d" % k, Rect2(Vector2(x1 - 250.0 + 86.0 * float(k), row_y(3) - 28.0), Vector2(78.0, 56.0))])
		out.append(["size%d" % k, Rect2(Vector2(x1 - 250.0 + 86.0 * float(k), row_y(4) - 28.0), Vector2(78.0, 56.0))])
	out.append(["done", Rect2(Vector2(c.get_center().x - 110.0, c.end.y - 84.0), Vector2(220.0, 62.0))])
	return out

func tap(at: Vector2) -> void:
	if not card().has_point(at):
		close()
		return
	for h in hit_rects():
		if (h[1] as Rect2).has_point(at):
			_press(str(h[0]))
			return

func _press(id: String) -> void:
	match id:
		"minus0":
			GameSettings.music = snappedf(maxf(GameSettings.music - STEP, 0.0), 0.01)
		"plus0":
			GameSettings.music = snappedf(minf(GameSettings.music + STEP, 1.0), 0.01)
		"minus1":
			GameSettings.sfx = snappedf(maxf(GameSettings.sfx - STEP, 0.0), 0.01)
		"plus1":
			GameSettings.sfx = snappedf(minf(GameSettings.sfx + STEP, 1.0), 0.01)
		"vib":
			GameSettings.vibrate = not GameSettings.vibrate
			if GameSettings.vibrate:
				Snd.buzz(25)
		"smooth":
			GameSettings.smooth = not GameSettings.smooth
			SoftWorld.refresh_all(get_tree())
		"done":
			close()
			return
		_:
			if id.begins_with("alpha"):
				GameSettings.alpha_i = int(id.substr(5))
			elif id.begins_with("size"):
				GameSettings.size_i = int(id.substr(4))
	GameSettings.save()
	Snd.apply_volumes()
	if (id.begins_with("alpha") or id.begins_with("size")) and page != null and page.get("pad") != null:
		var pad: TouchPad = page.get("pad")
		pad.relayout(_view())
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenTouch:
		get_viewport().set_input_as_handled()
		if event.pressed:
			tap(event.position)

func _draw() -> void:
	var v := _view()
	draw_rect(Rect2(Vector2.ZERO, v), Color(0.93, 0.9, 0.87, 0.6))
	var c := card()
	UiStyle.fill(self, Rect2(c.position + Vector2(4.0, 6.0), c.size), Color(0.0, 0.0, 0.0, 0.08))
	UiStyle.box(self, c, 1301, UiStyle.LINE, UiStyle.INK, UiStyle.PAPER)
	UiStyle.text(self, Vector2(c.get_center().x, c.position.y + 52.0), "ตั้งค่า", 36, UiStyle.INK)
	var labels := ["เพลง", "เสียงเอฟเฟกต์", "สั่นเมื่อโดนตี", "ความโปร่งช่องสกิล", "ขนาดปุ่ม", "โหมดลื่น (เครื่องช้า)"]
	var font := Sketch.font()
	for i in labels.size():
		draw_string(font, Vector2(c.position.x + 44.0, row_y(i) + float(LABEL_SIZE) * 0.36), labels[i], HORIZONTAL_ALIGNMENT_LEFT, -1.0, LABEL_SIZE, UiStyle.INK)
	var hits := {}
	for h in hit_rects():
		hits[h[0]] = h[1]
	# เพลง เสียง: [-] 60% [+] พร้อมแถบเล็ก
	for i in 2:
		var val: float = GameSettings.music if i == 0 else GameSettings.sfx
		_chip(hits["minus%d" % i], "-", false, 1310 + i * 4)
		_chip(hits["plus%d" % i], "+", false, 1311 + i * 4)
		var mid := Vector2(((hits["minus%d" % i] as Rect2).end.x + (hits["plus%d" % i] as Rect2).position.x) * 0.5, row_y(i))
		UiStyle.text(self, mid + Vector2(0.0, -8.0), "%d%%" % roundi(val * 100.0), VALUE_SIZE, UiStyle.INK)
		var bar := Rect2(mid + Vector2(-56.0, 16.0), Vector2(112.0, 8.0))
		UiStyle.fill(self, bar, Color(0.85, 0.82, 0.78), 4.0)
		if val > 0.0:
			UiStyle.fill(self, Rect2(bar.position, Vector2(maxf(bar.size.x * val, 8.0), bar.size.y)), Color(0.77, 0.63, 0.55), 4.0)
	_chip(hits["vib"], "เปิด" if GameSettings.vibrate else "ปิด", GameSettings.vibrate, 1330)
	_chip(hits["smooth"], "เปิด" if GameSettings.smooth else "ปิด", GameSettings.smooth, 1335)
	for k in 3:
		_chip(hits["alpha%d" % k], "%d%%" % roundi(GameSettings.ALPHAS[k] * 100.0), GameSettings.alpha_i == k, 1340 + k)
		_chip(hits["size%d" % k], GameSettings.SIZE_NAMES[k], GameSettings.size_i == k, 1350 + k)
	var d: Rect2 = hits["done"]
	UiStyle.box(self, d, 1360, UiStyle.LINE, UiStyle.INK, Color(0.91, 0.82, 0.77))
	UiStyle.text(self, d.get_center(), "เสร็จ", 30, UiStyle.INK)

func _chip(r: Rect2, word: String, on: bool, seed_no: int) -> void:
	UiStyle.box(self, r, seed_no, UiStyle.LINE, UiStyle.INK, Color(0.91, 0.82, 0.77) if on else UiStyle.PAPER)
	UiStyle.text(self, r.get_center(), word, 26, UiStyle.INK, r.size.x - 8.0)
