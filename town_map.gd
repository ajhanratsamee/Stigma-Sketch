class_name TownMap
extends Node2D

signal closed
## แผงแผนที่ดันเจี้ยนของเมือง กระดาษแผนที่สีครีม จุดดันเจี้ยนต่อกันด้วยทางเส้นประ
## แตะจุดเพื่อดูรายละเอียดทางขวา มีหน้าตามอนที่เจอและบอส กด "เข้าดันเจี้ยน" เพื่อเข้า ปุ่ม X ปิด

const PANEL := Vector2(1480.0, 660.0)   # กว้างเกือบเต็มจอ บอสไม่ล้นขอบ
const MAP_W := 880.0
const NODE_R := 44.0
const INK := Color(0.22, 0.17, 0.12)
const PARCH := Color(0.97, 0.91, 0.77)
const PARCH_DARK := Color(0.85, 0.74, 0.55)
const GO := Vector2(280.0, 74.0)

var town := 0
var selected := 0
var _view := Vector2.ZERO
var _previews: Array = []

## ตัวอย่างหน้าตามอนบนแผง
## ใช้โมเดล 3D ตัวกลมแบบเดียวกับมอนในเกม ถ้าไม่มีโมเดลค่อยวาด 2D แบบเดิม
class Preview extends Node2D:
	var look := ""
	var _t := 0.0
	var _model: MonsterModel
	func _ready() -> void:
		if MonsterModel.has_look(look):
			_model = MonsterModel.new()
			_model.look = look
			_model.face = -1.0
			add_child(_model)
	func _process(delta: float) -> void:
		if _model != null:
			return
		_t += delta
		queue_redraw()
	func _draw() -> void:
		if _model == null:
			CatLook.draw(self, look, _t, 1.0)

func _process(delta: float) -> void:
	if _denied_t > 0.0:
		_denied_t = maxf(_denied_t - delta, 0.0)
		queue_redraw()
	if _travel_t > 0.0:
		_travel_t = maxf(_travel_t - delta, 0.0)
		queue_redraw()

func _ready() -> void:
	_view = get_viewport_rect().size

func open() -> void:
	visible = true
	selected = 0
	var done := SaveData.cleared(town)
	# เปิดมาที่ดันเจี้ยนแรกที่ยังไม่ผ่าน
	for i in DungeonData.dungeon_count(town):
		if not i in done:
			selected = i
			break
	_make_previews()
	queue_redraw()

func panel_rect() -> Rect2:
	return Rect2((_view - PANEL) * 0.5, PANEL)

func node_at(i: int) -> Vector2:
	var p: Vector2 = DungeonData.dungeon(town, i).get("map", Vector2(0.5, 0.5))
	var r := panel_rect()
	return r.position + Vector2(40.0, 90.0) + p * Vector2(MAP_W - 80.0, PANEL.y - 150.0)

func close_center() -> Vector2:
	return panel_rect().position + Vector2(PANEL.x - 40.0, 40.0)

func go_rect() -> Rect2:
	var r := panel_rect()
	return Rect2(Vector2(r.position.x + MAP_W + (PANEL.x - MAP_W - GO.x) * 0.5, r.end.y - 30.0 - GO.y), GO)

func _make_previews() -> void:
	for p in _previews:
		(p as Node).queue_free()
	_previews.clear()
	var d := DungeonData.dungeon(town, selected)
	var looks := []
	var rooms := DungeonData.rooms(town, selected)
	for ri in rooms.size() - 1:
		for wave in rooms[ri]["waves"]:
			for e in wave:
				if not e[1] in looks:
					looks.append(e[1])
	var r := panel_rect()
	var x0 := r.position.x + MAP_W + 40.0
	var y := r.position.y + 385.0
	for i in looks.size():
		var p := Preview.new()
		p.look = looks[i]
		p.position = Vector2(x0 + 34.0 + float(i) * 70.0, y)
		p.scale = Vector2.ONE * 0.42
		add_child(p)
		_previews.append(p)
	var boss := Preview.new()
	boss.look = d.get("boss", "boss_club")
	boss.position = Vector2(x0 + (PANEL.x - MAP_W - 80.0) * 0.5, r.position.y + 560.0)
	boss.scale = Vector2.ONE * 0.34
	add_child(boss)
	_previews.append(boss)

var _denied_t := 0.0
var _travel_note := ""
var _travel_t := 0.0

func arrow_center(side: int) -> Vector2:
	var r := panel_rect()
	return r.position + Vector2(44.0 if side < 0 else MAP_W - 44.0, 44.0)

## ย้ายไปเมืองอื่น เลเวลต้องถึงต้นช่วงของเมืองนั้น
func travel(to: int) -> void:
	if to < 0 or to >= DungeonData.town_total():
		return
	var need := DungeonData.town_levels(to).x
	if WalkPage.chosen_level < need:
		_travel_note = "ต้องเลเวล %d ถึงไป%sได้" % [need, DungeonData.town_name(to)]
		_travel_t = 1.6
		queue_redraw()
		return
	WalkPage.current_town = to
	if WalkPage.roster_index >= 0:
		SaveData.update_character(WalkPage.roster_index, {"town": to})
	get_tree().change_scene_to_file("res://town.tscn")

func tap(at: Vector2) -> void:
	if at.distance_to(close_center()) <= 36.0:
		visible = false
		closed.emit()
		return
	# ลูกศรเดินทางไปเมืองก่อนหน้า / เมืองถัดไป
	for side in [-1, 1]:
		if at.distance_to(arrow_center(side)) <= 30.0:
			travel(town + side)
			return
	if go_rect().has_point(at):
		# เลเวลไม่ถึง เข้าไม่ได้
		if not DungeonData.can_enter(town, selected, WalkPage.chosen_level):
			_denied_t = 1.2
			queue_redraw()
			return
		WalkPage.dungeon_town = town
		WalkPage.dungeon_index = selected
		WalkPage.trial = false
		WalkPage.return_to = "res://town.tscn"
		DungeonPage.stage = 0
		get_tree().change_scene_to_file("res://dungeon.tscn")
		return
	for i in DungeonData.dungeon_count(town):
		if DungeonData.dungeon(town, i).is_empty():
			continue
		if at.distance_to(node_at(i)) <= NODE_R * 1.25:
			selected = i
			_make_previews()
			queue_redraw()
			return

func _text(at: Vector2, word: String, size: int, color := INK, center := true) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x if center else 0.0
	draw_string(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

## ทางเส้นประโค้งระหว่างสองจุด
func _dotted(p0: Vector2, p1: Vector2) -> void:
	var mid := (p0 + p1) * 0.5 + Vector2(0.0, -40.0)
	var steps := int(p0.distance_to(p1) / 18.0)
	for i in steps:
		if i % 2 == 0:
			var t0 := float(i) / float(steps)
			var t1 := float(i + 1) / float(steps)
			draw_line(_bez(p0, mid, p1, t0), _bez(p0, mid, p1, t1), Color(0.55, 0.38, 0.22), 4.0, true)

func _bez(p: Vector2, m: Vector2, q: Vector2, t: float) -> Vector2:
	return p.lerp(m, t).lerp(m.lerp(q, t), t)

## ภาพประกอบรอบจุดดันเจี้ยนตามธีม จางๆ บนแผนที่
func _scenery(c: Vector2, theme: String) -> void:
	match theme:
		"meadow":
			draw_colored_polygon(Sketch.oval(c + Vector2(0.0, 30.0), 90.0, 32.0, 24), Color(0.7, 0.86, 0.55, 0.8))
			for i in 6:
				draw_circle(c + Vector2(-70.0 + float(i) * 28.0, 40.0 + float(i % 2) * 8.0), 4.0, [Color(1.0, 0.85, 0.4), Color(1.0, 0.7, 0.8)][i % 2])
		"forest":
			for i in 5:
				var p := c + Vector2(-80.0 + float(i) * 40.0, 34.0 + float(i % 2) * 10.0)
				# ต้นไม้ยอดกลมฟู ไม่ใช้ต้นสนแหลม
				draw_rect(Rect2(p.x - 3.0, p.y - 14.0, 6.0, 14.0), Color(0.55, 0.4, 0.28, 0.85))
				draw_circle(p + Vector2(0.0, -24.0), 16.0, Color(0.35, 0.6, 0.38, 0.85))
				draw_circle(p + Vector2(-9.0, -18.0), 11.0, Color(0.35, 0.6, 0.38, 0.85))
				draw_circle(p + Vector2(9.0, -18.0), 11.0, Color(0.35, 0.6, 0.38, 0.85))
				draw_circle(p + Vector2(-4.0, -29.0), 5.0, Color(0.55, 0.78, 0.5, 0.8))
		"ruins":
			for i in 4:
				var p := c + Vector2(-70.0 + float(i) * 46.0, 40.0)
				UiStyle.fill(self, Rect2(p.x - 14.0, p.y - 18.0 - float(i % 2) * 14.0, 28.0, 18.0 + float(i % 2) * 14.0), Color(0.82, 0.66, 0.45, 0.85), 7.0)
		"tower":
			draw_colored_polygon(Sketch.oval(c + Vector2(0.0, 36.0), 80.0, 26.0, 24), Color(0.6, 0.55, 0.72, 0.6))
		"arena":
			draw_colored_polygon(Sketch.oval(c + Vector2(0.0, 36.0), 92.0, 30.0, 24), Color(0.92, 0.82, 0.62, 0.8))
			for side in [-1.0, 1.0]:
				UiStyle.fill(self, Rect2(c.x + side * 76.0 - 10.0, c.y - 20.0, 20.0, 56.0), Color(0.85, 0.78, 0.7), 6.0)
				# หลังคาโดมกลม
				draw_circle(Vector2(c.x + side * 76.0, c.y - 20.0), 13.0, Color(0.85, 0.35, 0.3))

## ดาวทองบอกว่าผ่านแล้ว
## แม่กุญแจเล็กบนดันที่เลเวลยังไม่ถึง
func _lock(c: Vector2) -> void:
	draw_arc(c + Vector2(0.0, -8.0), 9.0, PI, TAU, 12, INK, 4.0, true)
	draw_rect(Rect2(c + Vector2(-13.0, -8.0), Vector2(26.0, 20.0)), Color(0.95, 0.75, 0.3))
	draw_rect(Rect2(c + Vector2(-13.0, -8.0), Vector2(26.0, 20.0)), INK, false, 2.5)
	draw_circle(c + Vector2(0.0, 1.0), 3.5, INK)

## ตราผ่านแล้ว วงกลมทองมีรอยเท้าแมวขาว ขอบหมึก (แทนดาวแฉก)
func _paw_badge(c: Vector2, r: float) -> void:
	draw_circle(c, r, Color(1.0, 0.78, 0.2))
	draw_arc(c, r, 0.0, TAU, 24, INK, 2.0, true)
	draw_circle(c + Vector2(0.0, r * 0.22), r * 0.36, Color.WHITE)
	for i in 3:
		var a := -2.2 + float(i) * 0.7
		draw_circle(c + Vector2(cos(a), sin(a)) * r * 0.5 + Vector2(0.0, r * 0.08), r * 0.15, Color.WHITE)

## รูปเล็กกลางจุดดันเจี้ยน
func _icon(c: Vector2, kind: String) -> void:
	match kind:
		"meadow":
			for i in 3:
				var x := c.x - 16.0 + float(i) * 16.0
				draw_circle(Vector2(x, c.y + 6.0), 8.0, Color(0.4, 0.7, 0.35))
			draw_circle(c + Vector2(10.0, -14.0), 7.0, Color(1.0, 0.8, 0.3))
		"forest":
			for i in 2:
				var x := c.x - 12.0 + float(i) * 24.0
				draw_rect(Rect2(x - 3.0, c.y + 4.0, 6.0, 14.0), Color(0.5, 0.35, 0.2))
				draw_circle(Vector2(x, c.y - 6.0), 13.0, Color(0.3, 0.55, 0.32))
		"ruins":
			for i in 3:
				var h: float = [30.0, 18.0, 26.0][i]
				draw_rect(Rect2(c.x - 22.0 + float(i) * 16.0, c.y + 16.0 - h, 11.0, h), Color(0.7, 0.65, 0.6))
		"tower":
			draw_rect(Rect2(c.x - 10.0, c.y - 16.0, 20.0, 34.0), Color(0.45, 0.4, 0.55))
			draw_circle(Vector2(c.x, c.y - 16.0), 13.0, Color(0.35, 0.25, 0.45))
			draw_circle(Vector2(c.x - 5.0, c.y - 30.0), 4.0, Color(0.35, 0.25, 0.45))
			draw_circle(Vector2(c.x + 5.0, c.y - 30.0), 4.0, Color(0.35, 0.25, 0.45))
		"arena":
			draw_colored_polygon(Sketch.oval(c + Vector2(0.0, 6.0), 26.0, 14.0, 20), Color(0.85, 0.75, 0.6))
			draw_arc(c + Vector2(0.0, 6.0), 20.0, PI, TAU, 12, INK, 2.0, true)
			draw_colored_polygon(PackedVector2Array([c + Vector2(-8.0, -6.0), c + Vector2(-8.0, -24.0), c + Vector2(0.0, -14.0), c + Vector2(8.0, -24.0), c + Vector2(8.0, -6.0)]), Color(1.0, 0.82, 0.3))
		# ไอคอนฉากของเมืองอื่น ทรงกลมมน
		"fishmarket", "canal":
			draw_circle(c + Vector2(0.0, 4.0), 16.0, Color(0.55, 0.78, 0.95))
			draw_circle(c + Vector2(-4.0, 2.0), 3.0, INK)
			draw_circle(c + Vector2(14.0, 4.0), 7.0, Color(0.55, 0.78, 0.95))
		"mine", "crystal":
			for i in 3:
				var col := Color(0.75, 0.68, 0.98) if kind == "crystal" else Color(0.7, 0.55, 0.4)
				UiStyle.fill(self, Rect2(c.x - 18.0 + float(i) * 13.0, c.y - 14.0 + float(i % 2) * 6.0, 10.0, 30.0 - float(i % 2) * 6.0), col, 5.0)
		"shipwreck", "seacave":
			draw_circle(c + Vector2(0.0, 8.0), 18.0, Color(0.45, 0.72, 0.9))
			UiStyle.fill(self, Rect2(c.x - 3.0, c.y - 22.0, 6.0, 26.0), Color(0.6, 0.45, 0.32), 3.0)
			draw_circle(c + Vector2(8.0, -12.0), 9.0, Color(1.0, 1.0, 0.96))
		"dunes", "oasis", "pyramid":
			draw_circle(c + Vector2(-8.0, 10.0), 16.0, Color(0.98, 0.82, 0.55))
			draw_circle(c + Vector2(10.0, 12.0), 13.0, Color(0.95, 0.76, 0.5))
			draw_circle(c + Vector2(10.0, -14.0), 7.0, Color(1.0, 0.8, 0.3) if kind != "oasis" else Color(0.45, 0.72, 0.48))
		"skislope", "frozenlake", "icecave":
			draw_circle(c + Vector2(0.0, 6.0), 18.0, Color(0.85, 0.93, 1.0))
			draw_circle(c + Vector2(-8.0, -8.0), 9.0, Color(1.0, 1.0, 1.0))
			draw_circle(c + Vector2(9.0, -6.0), 7.0, Color(0.7, 0.85, 0.98))
		"crater", "lavatunnel":
			draw_circle(c + Vector2(0.0, 8.0), 18.0, Color(0.7, 0.5, 0.45))
			draw_circle(c + Vector2(0.0, -6.0), 9.0, Color(1.0, 0.6, 0.35))
		"library", "cells", "rooftop":
			UiStyle.fill(self, Rect2(c.x - 14.0, c.y - 14.0, 28.0, 32.0), Color(0.62, 0.56, 0.78), 7.0)
			draw_circle(c + Vector2(0.0, -16.0), 12.0, Color(0.55, 0.48, 0.72))
		"cloudgarden", "skytemple":
			draw_circle(c + Vector2(-10.0, 8.0), 12.0, Color(1.0, 1.0, 1.0))
			draw_circle(c + Vector2(8.0, 6.0), 14.0, Color(1.0, 1.0, 1.0))
			draw_circle(c + Vector2(0.0, -10.0), 9.0, Color(1.0, 0.85, 0.4))
		"train":
			UiStyle.fill(self, Rect2(c.x - 22.0, c.y - 12.0, 44.0, 22.0), Color(0.85, 0.35, 0.3), 7.0)
			UiStyle.fill(self, Rect2(c.x - 16.0, c.y - 8.0, 10.0, 8.0), Color(0.95, 0.95, 1.0), 3.0)
			UiStyle.fill(self, Rect2(c.x + 4.0, c.y - 8.0, 10.0, 8.0), Color(0.95, 0.95, 1.0), 3.0)
			draw_circle(c + Vector2(-12.0, 13.0), 6.0, Color(0.3, 0.3, 0.35))
			draw_circle(c + Vector2(12.0, 13.0), 6.0, Color(0.3, 0.3, 0.35))
		"underwater":
			draw_circle(c, 18.0, Color(0.45, 0.75, 0.9))
			draw_circle(c + Vector2(-6.0, -6.0), 4.0, Color(1.0, 1.0, 1.0, 0.8))
			draw_circle(c + Vector2(6.0, -12.0), 3.0, Color(1.0, 1.0, 1.0, 0.8))
			UiStyle.fill(self, Rect2(c.x - 10.0, c.y + 2.0, 20.0, 10.0), Color(1.0, 0.65, 0.3), 5.0)
		"airship":
			draw_circle(c + Vector2(0.0, -8.0), 15.0, Color(0.95, 0.75, 0.4))
			UiStyle.fill(self, Rect2(c.x - 16.0, c.y + 8.0, 32.0, 10.0), Color(0.6, 0.42, 0.28), 5.0)
		"minecart":
			UiStyle.fill(self, Rect2(c.x - 16.0, c.y - 8.0, 32.0, 18.0), Color(0.55, 0.45, 0.4), 5.0)
			draw_circle(c + Vector2(-8.0, -10.0), 6.0, Color(0.7, 0.65, 0.8))
			draw_circle(c + Vector2(-9.0, 13.0), 5.0, Color(0.3, 0.3, 0.35))
			draw_circle(c + Vector2(9.0, 13.0), 5.0, Color(0.3, 0.3, 0.35))
		"kitchen":
			UiStyle.fill(self, Rect2(c.x - 16.0, c.y - 6.0, 32.0, 20.0), Color(0.75, 0.75, 0.8), 8.0)
			draw_circle(c + Vector2(-6.0, -14.0), 5.0, Color(1.0, 1.0, 1.0, 0.85))
			draw_circle(c + Vector2(4.0, -18.0), 6.0, Color(1.0, 1.0, 1.0, 0.85))
		"toybox":
			UiStyle.fill(self, Rect2(c.x - 18.0, c.y - 2.0, 14.0, 14.0), Color(0.95, 0.45, 0.45), 3.0)
			UiStyle.fill(self, Rect2(c.x + 2.0, c.y - 2.0, 14.0, 14.0), Color(0.45, 0.65, 0.95), 3.0)
			UiStyle.fill(self, Rect2(c.x - 8.0, c.y - 16.0, 14.0, 14.0), Color(1.0, 0.85, 0.35), 3.0)
		"waterfall":
			UiStyle.fill(self, Rect2(c.x - 8.0, c.y - 18.0, 16.0, 30.0), Color(0.6, 0.85, 1.0), 6.0)
			draw_circle(c + Vector2(-10.0, 14.0), 7.0, Color(1.0, 1.0, 1.0, 0.8))
			draw_circle(c + Vector2(10.0, 14.0), 7.0, Color(1.0, 1.0, 1.0, 0.8))
		"cattree":
			UiStyle.fill(self, Rect2(c.x - 5.0, c.y - 10.0, 10.0, 26.0), Color(0.75, 0.6, 0.45), 4.0)
			draw_circle(c + Vector2(0.0, -14.0), 13.0, Color(0.45, 0.72, 0.4))
		"nightmarket":
			for i in 3:
				var p := c + Vector2(-14.0 + float(i) * 14.0, -6.0 + float(i % 2) * 8.0)
				draw_circle(p, 7.0, Color(1.0, 0.6 + 0.1 * float(i), 0.4))
				draw_circle(p, 3.0, Color(1.0, 0.95, 0.75))

func _draw() -> void:
	if not visible:
		return
	draw_rect(Rect2(Vector2.ZERO, _view), Color(1.0, 0.98, 0.94, 0.45))
	var r := panel_rect()
	draw_rect(r.grow(10.0), PARCH_DARK)
	draw_rect(r, PARCH)
	var a := r.position
	var b := r.end
	Sketch.line(self, PackedVector2Array([a, Vector2(b.x, a.y), b, Vector2(a.x, b.y), a]), 800, 4.0, Sketch.WOBBLE, INK)
	var lv := DungeonData.town_levels(town)
	_text(a + Vector2(MAP_W * 0.5, 44.0), "%s  (Lv.%d-%d)" % [DungeonData.town_name(town), lv.x, lv.y], 32)
	for side in [-1, 1]:
		var to: int = town + side
		if to < 0 or to >= DungeonData.town_total():
			continue
		var ac := arrow_center(side)
		var ok := WalkPage.chosen_level >= DungeonData.town_levels(to).x
		draw_circle(ac, 26.0, Color(0.85, 0.3, 0.25) if ok else Color(0.66, 0.62, 0.6))
		draw_arc(ac, 26.0, 0.0, TAU, 24, INK, 3.0, true)
		var s := float(side)
		draw_colored_polygon(PackedVector2Array([ac + Vector2(s * 12.0, 0.0), ac + Vector2(-s * 8.0, -12.0), ac + Vector2(-s * 8.0, 12.0)]), Color(1.0, 0.97, 0.9))
	if _travel_t > 0.0:
		_text(a + Vector2(MAP_W * 0.5, 86.0), _travel_note, 24, Color(0.8, 0.2, 0.2))
	# พื้นแผนที่ ทุ่งเขียวอ่อน แม่น้ำ ภาพประกอบตามธีมรอบแต่ละจุด เมืองจุดเริ่ม เข็มทิศ
	var mr := Rect2(a + Vector2(30.0, 80.0), Vector2(MAP_W - 60.0, PANEL.y - 120.0))
	draw_rect(mr, Color(0.86, 0.9, 0.72))
	var river := PackedVector2Array()
	for i in 21:
		var t := float(i) / 20.0
		river.append(mr.position + Vector2(mr.size.x * (0.2 + 0.6 * t), mr.size.y * t + sin(t * 9.0) * 26.0))
	draw_polyline(river, Color(0.55, 0.75, 0.92), 16.0, true)
	draw_polyline(river, Color(0.75, 0.88, 0.98), 6.0, true)
	for i in DungeonData.dungeon_count(town):
		var d0 := DungeonData.dungeon(town, i)
		if not d0.is_empty():
			_scenery(node_at(i), str(d0.get("theme", "")))
	var home := mr.position + Vector2(44.0, mr.size.y - 40.0)
	for k in 3:
		var hx := home.x - 26.0 + float(k) * 26.0
		draw_rect(Rect2(hx - 10.0, home.y - 24.0, 20.0, 24.0), Color(0.98, 0.9, 0.8))
		draw_colored_polygon(PackedVector2Array([Vector2(hx - 13.0, home.y - 24.0), Vector2(hx - 6.0, home.y - 38.0), Vector2(hx, home.y - 30.0), Vector2(hx + 6.0, home.y - 38.0), Vector2(hx + 13.0, home.y - 24.0)]), Color(0.9, 0.5, 0.4))
	_text(home + Vector2(0.0, 18.0), "เมือง", 18)
	var cp := mr.end - Vector2(46.0, 46.0)
	draw_circle(cp, 30.0, Color(1.0, 0.97, 0.88, 0.9))
	draw_arc(cp, 30.0, 0.0, TAU, 24, INK, 2.0, true)
	SoftDraw.poly(self, PackedVector2Array([cp + Vector2(0.0, -26.0), cp + Vector2(7.0, 0.0), cp + Vector2(-7.0, 0.0)]), Color(0.85, 0.3, 0.25))
	SoftDraw.poly(self, PackedVector2Array([cp + Vector2(0.0, 26.0), cp + Vector2(7.0, 0.0), cp + Vector2(-7.0, 0.0)]), Color(0.5, 0.5, 0.55))
	_text(cp + Vector2(0.0, -40.0), "N", 16)
	Sketch.line(self, PackedVector2Array([mr.position, Vector2(mr.end.x, mr.position.y), mr.end, Vector2(mr.position.x, mr.end.y), mr.position]), 801, 2.0, Sketch.WOBBLE, PARCH_DARK.darkened(0.2))
	var count := DungeonData.dungeon_count(town)
	var done := SaveData.cleared(town)
	# ทางเส้นประระหว่างจุด
	for i in count - 1:
		if DungeonData.dungeon(town, i + 1).is_empty():
			continue
		_dotted(node_at(i), node_at(i + 1))
	_dotted(a + Vector2(74.0, PANEL.y - 80.0), node_at(0))
	for i in count:
		var d := DungeonData.dungeon(town, i)
		if d.is_empty():
			continue
		var c := node_at(i)
		draw_circle(c, NODE_R + 6.0, Color(0.85, 0.3, 0.25) if i == selected else PARCH_DARK)
		draw_circle(c, NODE_R, Color(1.0, 0.97, 0.88))
		var ring := Sketch.oval(c, NODE_R, NODE_R, 30)
		ring.append(ring[0])
		Sketch.line(self, ring, 810 + i, 5.0 if i == selected else 2.6, Sketch.WOBBLE, INK)
		_icon(c, d.get("icon", ""))
		draw_circle(c + Vector2(-NODE_R * 0.75, -NODE_R * 0.75), 15.0, Color(0.38, 0.5, 0.8))
		_text(c + Vector2(-NODE_R * 0.75, -NODE_R * 0.75), str(i + 1), 18, Color.WHITE)
		if i in done:
			_paw_badge(c + Vector2(NODE_R * 0.8, -NODE_R * 0.8), 16.0)
		_text(c + Vector2(0.0, NODE_R + 24.0), d.get("name", ""), 20)
		# เลเวลที่ต้องการ แดงถ้ายังไม่ถึง มีแม่กุญแจ
		var ok := DungeonData.can_enter(town, i, WalkPage.chosen_level)
		_text(c + Vector2(0.0, NODE_R + 50.0), "Lv.%d+" % DungeonData.dungeon_level(town, i), 18, Color(0.25, 0.5, 0.3) if ok else Color(0.8, 0.2, 0.2))
		if not ok:
			draw_circle(c, NODE_R, Color(0.3, 0.25, 0.25, 0.45))
			_lock(c + Vector2(NODE_R * 0.75, NODE_R * 0.6))
	# รายละเอียดดันเจี้ยนที่เลือก
	var sd := DungeonData.dungeon(town, selected)
	var x0 := a.x + MAP_W + 30.0
	_text(Vector2(x0, a.y + 110.0), "%d. %s" % [selected + 1, sd.get("name", "")], 30, INK, false)
	Sketch.draw_wrapped(self, Vector2(x0, a.y + 140.0), sd.get("text", ""), 22, PANEL.x - MAP_W - 60.0, 70.0, INK)
	var total := 0
	for st in DungeonData.stage_count(town, selected) - 1:
		total += DungeonData.stage_monsters(town, selected, st).size()
	_text(Vector2(x0, a.y + 235.0), "%d ห้อง + ห้องบอส   มอนรวม %d ตัว" % [DungeonData.stage_count(town, selected) - 1, total], 20, INK, false)
	_text(Vector2(x0, a.y + 280.0), "มอนที่เจอ", 22, INK, false)
	var info_mid := x0 + (PANEL.x - MAP_W - 80.0) * 0.5
	_text(Vector2(info_mid, a.y + 420.0), "บอส  " + CatLook.name_of(str(sd.get("boss", "")), town), 22, Color(0.75, 0.2, 0.2))
	if selected in done:
		_paw_badge(Vector2(x0 + 14.0, a.y + 200.0), 12.0)
		_text(Vector2(x0 + 32.0, a.y + 200.0), "ผ่านแล้ว", 20, Color(0.85, 0.6, 0.1), false)
	var need := DungeonData.dungeon_level(town, selected)
	var enter_ok := DungeonData.can_enter(town, selected, WalkPage.chosen_level)
	_text(Vector2(x0 + 200.0, a.y + 200.0), "ต้องเลเวล %d ขึ้นไป  (ตอนนี้ Lv.%d)" % [need, WalkPage.chosen_level], 20, Color(0.25, 0.5, 0.3) if enter_ok else Color(0.8, 0.2, 0.2), false)
	var g := go_rect()
	draw_rect(g, Color(0.85, 0.3, 0.25) if enter_ok else Color(0.6, 0.56, 0.54))
	Sketch.line(self, PackedVector2Array([g.position, Vector2(g.end.x, g.position.y), g.end, Vector2(g.position.x, g.end.y), g.position]), 830, 4.0, Sketch.WOBBLE, INK)
	_text(g.get_center(), "เข้าดันเจี้ยน" if enter_ok else "เลเวลไม่ถึง Lv.%d" % need, 32, Color(1.0, 0.97, 0.9))
	if _denied_t > 0.0:
		_text(g.get_center() + Vector2(0.0, -g.size.y * 0.5 - 26.0), "ต้องเลเวล %d ก่อนนะเหมียว!" % need, 24, Color(0.8, 0.2, 0.2))
	# ปุ่มปิด
	var cc := close_center()
	draw_circle(cc, 28.0, Color(1.0, 0.97, 0.88))
	Sketch.line(self, PackedVector2Array([cc + Vector2(-11.0, -11.0), cc + Vector2(11.0, 11.0)]), 840, 4.0, Sketch.WOBBLE, INK)
	Sketch.line(self, PackedVector2Array([cc + Vector2(11.0, -11.0), cc + Vector2(-11.0, 11.0)]), 841, 4.0, Sketch.WOBBLE, INK)
