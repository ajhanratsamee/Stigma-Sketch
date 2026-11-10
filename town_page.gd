class_name TownPage
extends WalkPage
## เมืองแห่งอัศวิน ใช้หน้าเดียวกับห้องฝึกซ้อม ปุ่ม การเดิน ระยะกล้อง เหมือนห้องฝึกทุกอย่าง เดินได้แค่ซ้ายขวา
## ต่างกันที่ฉากเป็นเมืองยาว กล้องเลื่อนตามตัวละคร ไม่มีหุ่นซ้อม และมีปุ่ม เข้าดันเจี้ยน ใต้ปุ่มสกิลกับคอมโบ
## ฉากแบ่งชั้นเลื่อนเร็วช้าต่างกัน ท้องฟ้า ภูเขา ปราการแมวใหญ่ กำแพงเมือง แถวบ้านแมว ถนนหิน ของหน้าสุด
## ชั้นไกลเป็นสีน้ำนุ่มๆ ชั้นถนนเป็นกระดาษตัดมีเส้นหมึก แต่ละชั้นวาดครั้งเดียวแล้วเลื่อนตามกล้อง

const TOWN := 0
const TOWN_HALF := 40.0           # ถนนยาวข้างละเท่านี้ หน่วยเกม (ค่าเริ่มต้น แต่ละชั้นของแต่ละเมืองกำหนดเองได้)
const NEAR := 1.8                 # เข้าใกล้ของในเมืองไม่เกินเท่านี้ (หน่วยเกม) ขึ้นปุ่มให้กด
const PLANET_R := 1500.0          # รัศมีดาวของเมืองแบบพื้นโค้ง (จุดภาพบนจอ)
const INK := Color(0.2, 0.17, 0.15)
const ROW_BACK := 74.0            # แถวบ้านถอยไปด้านหลังเท่านี้ ตัวละครเดินบนถนนด้านหน้า ไม่ทับเส้นฐานบ้าน
const STREET_FRONT := 46.0        # ขอบถนนด้านหน้า ถัดไปเป็นราวกำแพงกับชั้นล่าง
const ROW_SCALE := 0.8           # ย่อแถวบ้านให้ยอดไม่ชนขอบจอ (เหนือพื้นมีแค่ครึ่งจอเท่าห้องฝึก)
const PAPER := Color(0.97, 0.95, 0.9)
const WALLS := [Color(0.99, 0.93, 0.82), Color(0.98, 0.86, 0.8), Color(0.88, 0.92, 0.98), Color(0.92, 0.96, 0.86), Color(0.99, 0.9, 0.95)]
const ROOFS := [Color(0.95, 0.6, 0.35), Color(0.45, 0.55, 0.85), Color(0.9, 0.45, 0.5), Color(0.55, 0.7, 0.45), Color(0.7, 0.5, 0.85)]

var map: TownMap
var quests: QuestPanel
var cam := 0.0                    # กล้องเลื่อนไปกี่จุดภาพบนจอ
var _layers: Array = []           # [โหนด ตัวคูณการเลื่อน]
var _rng := RandomNumberGenerator.new()
var _ui: Node2D
var town_half := TOWN_HALF
var style := "street"
var _town: Dictionary = {}
var _floor := 0
var _front: Node2D
var _haze: Node2D
var _props: Node2D
var _planet: Node2D
var _npcs: Array = []             # TownNpc บนชั้นปัจจุบัน
var dialog: DialogBox
var _fade: Node2D
var _fade_a := 0.0
var _warping := false
var _near: Dictionary = {}        # ของที่ใกล้ที่สุดตอนนี้ {kind, x, ...}
var _mail_count := 0
var _poll := 0.0
var _warm_task := -1              # งานสร้างผิว NPC ล่วงหน้า
var _warm_wait := 0.0
var _npc_made_frame := -1         # สร้างโมเดล NPC ได้เฟรมละตัว ไม่ให้กระตุก
var _tdata: Dictionary = {}       # ภูมิประเทศของชั้นนี้ (เนิน ทางลาด สะพาน ทางโค้ง) ว่างคือพื้นเรียบ
var _terrain: Node2D
var cam_y := 0.0                  # กล้องเลื่อนขึ้นลงตามความสูงพื้น (จุดภาพ)

## ภูมิประเทศของชั้นปัจจุบัน
func terrain_data() -> Dictionary:
	return _tdata

## ความสูงพื้นที่ตำแหน่ง x (หน่วยเกม) ต่อเส้นตรงระหว่างจุดของ path
func ground_h(x: float) -> float:
	var pts: Array = _tdata.get("path", [])
	if pts.is_empty():
		return 0.0
	if x <= float(pts[0][0]):
		return float(pts[0][1])
	for i in range(1, pts.size()):
		var bx := float(pts[i][0])
		if x <= bx:
			var ax := float(pts[i - 1][0])
			var k := (x - ax) / maxf(bx - ax, 0.001)
			return lerpf(float(pts[i - 1][1]), float(pts[i][1]), k)
	return float(pts[pts.size() - 1][1])

func _exit_tree() -> void:
	Hero.ground_fn = Callable()
	# รองานสร้างผิว NPC เบื้องหลังให้จบก่อนออกจากฉาก กันเธรดเรียกโมเดลตอนสคริปต์ถูกปิด
	if _warm_task >= 0:
		WorkerThreadPool.wait_for_task_completion(_warm_task)
		_warm_task = -1

func is_town() -> bool:
	return true

func _home_x() -> float:
	return _view.x * 0.5 - cam

## พื้นตามเนิน + กล้องยกตามของที่ลอย
func _home_y() -> float:
	return _view.y * GROUND_AT + cam_y + air_y

func _ready() -> void:
	super._ready()
	_town = TownData.town(current_town) if current_town < TownData.TOWNS.size() else {}
	style = str(_town.get("style", "street"))
	# ในเมืองโจมตีและใช้สกิลไม่ได้ ซ่อนปุ่มโจมตี ช่องสกิล HYPER
	for id in ["z", "x", "hyper", "swap", "down", "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7"]:
		pad.buttons.erase(id)
	pad.queue_redraw()
	# หมอกจางๆ คลุมฉากทั้งหมด ฉากดูไกลขึ้น ตัวละครเด่น
	_haze = Node2D.new()
	_haze.draw.connect(func() -> void: _haze.draw_rect(Rect2(Vector2.ZERO, _view), Color(1.0, 0.98, 0.95, 0.22 if style != "underground" else 0.1)))
	add_child(_haze)
	move_child(_haze, world.get_index())
	_props = Node2D.new()
	_props.draw.connect(_draw_props)
	world.add_child(_props)
	world.move_child(_props, 0)
	# ผิวตัว NPC ทุกตัวในเมือง สร้างในเบื้องหลังก่อน ระหว่างนี้ NPC ยังไม่โผล่
	var looks := []
	var later := []
	for d in _town.get("npcs", []):
		(looks if int((d as Dictionary).get("floor", 0)) == 0 else later).append((d as Dictionary).get("look", {}))
	looks.append_array(later)
	if not looks.is_empty():
		_warm_task = ChibiModel.prewarm_looks(looks)
	_build_floor()
	_fade = Node2D.new()
	_fade.z_index = 70
	_fade.draw.connect(func() -> void:
		if _fade_a > 0.0:
			_fade.draw_rect(Rect2(Vector2.ZERO, _view), Color(1.0, 0.98, 0.94, _fade_a)))
	add_child(_fade)
	dialog = DialogBox.new()
	dialog.page = self
	dialog.closed.connect(_map_closed)
	add_child(dialog)
	_ui = Node2D.new()
	_ui.z_index = 40
	_ui.draw.connect(_draw_ui)
	add_child(_ui)
	map = TownMap.new()
	map.town = current_town
	map.visible = false
	map.z_index = 80
	map.closed.connect(_map_closed)
	add_child(map)
	quests = QuestPanel.new()
	quests.visible = false
	quests.z_index = 80
	quests.closed.connect(_map_closed)
	add_child(quests)
	_follow(0.0)

## ในเมืองโจมตีไม่ได้
func press_attack(_button: String) -> void:
	pass

## ในเมืองใช้สกิลไม่ได้
func _use_skill(_id: String) -> void:
	pass

func _layer(factor: float, painter: Callable) -> Node2D:
	var node := Node2D.new()
	var seed_no := 1000 + _layers.size()
	node.draw.connect(func() -> void:
		_rng.seed = seed_no
		painter.call(node))
	add_child(node)
	_layers.append([node, factor])
	return node

func _process(delta: float) -> void:
	super._process(delta)
	_follow(delta)
	_tick_town(delta)

## กล้องตามตัวละคร ไม่เลยหัวท้ายเมือง  เมืองดาวพื้นโค้งกล้องอยู่กลางตัวละครตลอด ดาวหมุนแทน
func _follow(delta: float) -> void:
	var edge := maxf(town_half * CombatData.UNIT * ZOOM - _view.x * 0.5, 0.0)
	if _planet == null:
		_tick_look(delta)
	var want := clampf(hero.position.x * ZOOM + look, -edge, edge) if _planet == null else hero.position.x * ZOOM
	cam = want if delta <= 0.0 else lerpf(cam, want, 1.0 - exp(-8.0 * delta))
	var want_y := ground_h(hero.pos.x) * CombatData.UNIT * ZOOM if not _tdata.is_empty() else 0.0
	cam_y = want_y if delta <= 0.0 else lerpf(cam_y, want_y, 1.0 - exp(-6.0 * delta))
	if _planet == null:
		_tick_air(delta, -ground_h(hero.pos.x) * CombatData.UNIT if not _tdata.is_empty() else 0.0)
	if hyper == null and shake_left <= 0.0:
		world.position.x = _home_x()
		if not _warping:
			world.position.y = _home_y()
	for l in _layers:
		var f: float = l[1]
		if not is_instance_valid(l[0]):
			continue
		(l[0] as Node2D).position.x = 0.0 if f <= 0.0 else _view.x * 0.5 - cam * f
		(l[0] as Node2D).position.y = 0.0 if f <= 0.0 else cam_y * minf(f, 1.0) * 0.5 + air_y
	# เมฆลอยเองช้าๆ (เลื่อนตำแหน่ง ไม่วาดใหม่) พุ่มไม้หน้าสุดติดขอบล่างจอเสมอ
	if is_instance_valid(_cloud_node):
		_cloud_node.position.x += fposmod(float(Time.get_ticks_msec()) * 0.001 * CLOUD_DRIFT, CLOUD_TILE)
	if is_instance_valid(_tufts):
		_tufts.position.y = 0.0
	if _planet != null:
		_planet.position = Vector2(_view.x * 0.5, _ground_y() + PLANET_R)
		_planet.rotation = -cam / PLANET_R
		_curve_actors()

## ปุ่มตั้งค่า > ย้อนกลับ ในเมืองกลับหน้าคลังตัวละคร
func go_back() -> void:
	get_tree().change_scene_to_file("res://roster.tscn")

# ---------------------------------------------------------------- ปุ่มเมนูพับเก็บ (เข้าดันเจี้ยน เควส) ซ้ายของปุ่มสกิล
var menu_open := false            # เมนูด่วนกางอยู่

## ปุ่มเมนูกลม (สามขีด) ซ้ายของปุ่มสกิล
func menu_center() -> Vector2:
	return pad.buttons["skill"] + Vector2(-TouchPad.SLOT_RADIUS * 2.0 - 20.0, 0.0)

## รายการในเมนูที่กางลงมาใต้แถวปุ่มขวาบน ชิดขวา
func dungeon_rect() -> Rect2:
	var r := TouchPad.SLOT_RADIUS
	var right: Vector2 = pad.buttons["back"]
	var w := 290.0
	return Rect2(Vector2(right.x + r - w, right.y + r + 16.0), Vector2(w, 62.0))

func quest_rect() -> Rect2:
	var d := dungeon_rect()
	return Rect2(d.position + Vector2(0.0, d.size.y + 10.0), d.size)

func _menu_hit(at: Vector2) -> bool:
	return at.distance_to(menu_center()) <= TouchPad.SLOT_RADIUS * TouchPad.TOUCH_GROW

func set_menu(on: bool) -> void:
	menu_open = on
	_ui.queue_redraw()

func open_quests() -> void:
	quests.open()
	pad.reset()
	pad.visible = false
	_ui.visible = false

## มีเควสที่รับได้หรือส่งได้ ขึ้น ! บนปุ่ม
func quest_alert() -> bool:
	var entry := roster_entry()
	var q := QuestData.next_quest(chosen_weapon, chosen_class)
	if entry.is_empty() or q.is_empty():
		return false
	var p := QuestData.progress(entry, q)
	if p.is_empty():
		return chosen_level >= int(q["level"]) and current_town == int(q["town"])
	return QuestData.is_done(entry, q)

func open_map() -> void:
	map.open()
	pad.reset()
	pad.visible = false
	_ui.visible = false

func _map_closed() -> void:
	pad.visible = true
	_ui.visible = true
	_poll = 0.0

func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch and event.pressed):
		return
	if settings_open():
		super._input(event)
		return
	if dialog.visible:
		dialog.tap(event.position)
		return
	if _warping:
		return
	if _ui.visible and hyper == null and not panel.visible and not map.visible and not quests.visible:
		if not _near.is_empty() and action_rect().has_point(event.position):
			_act(_near)
			return
		var tapped := _npc_at(event.position)
		# แตะตัว NPC คุยได้เฉพาะตอนยืนใกล้เท่านั้น อยู่ไกลแตะไม่ได้ ต้องเดินไปหา
		if tapped != null and absf(hero.pos.x - float(tapped.data.get("x", 0.0))) < NEAR:
			_talk(tapped.data)
			return
	if map.visible:
		map.tap(event.position)
	elif quests.visible:
		quests.tap(event.position)
	elif _ui.visible and hyper == null and not panel.visible and _menu_hit(event.position):
		set_menu(not menu_open)
	elif _ui.visible and hyper == null and not panel.visible and menu_open and dungeon_rect().has_point(event.position):
		set_menu(false)
		open_map()
	elif _ui.visible and hyper == null and not panel.visible and menu_open and quest_rect().has_point(event.position):
		set_menu(false)
		open_quests()
	elif menu_open:
		set_menu(false)

func _draw_ui() -> void:
	_draw_action()
	var font := Sketch.font()
	var alert := quest_alert()
	# ปุ่มเมนูกลม สามขีด
	var mc := menu_center()
	var mr := TouchPad.SLOT_RADIUS
	_ui.draw_circle(mc, mr, Sketch.PAPER)
	var ring := Sketch.oval(mc, mr, mr, 48)
	ring.append(ring[0])
	Sketch.line(_ui, ring, 705, TouchPad.RING_DOWN if menu_open else TouchPad.RING, Sketch.WOBBLE)
	for k in [-1.0, 0.0, 1.0]:
		var yy: float = mc.y + k * 11.0
		_ui.draw_line(Vector2(mc.x - 16.0, yy), Vector2(mc.x + 16.0, yy), UiStyle.INK, 4.5, true)
		_ui.draw_circle(Vector2(mc.x - 16.0, yy), 2.25, UiStyle.INK)
		_ui.draw_circle(Vector2(mc.x + 16.0, yy), 2.25, UiStyle.INK)
	if alert and not menu_open:
		var ac := mc + Vector2(mr * 0.72, -mr * 0.72)
		_ui.draw_circle(ac, 14.0, Color(0.9, 0.25, 0.25))
		_ui.draw_string(font, ac + Vector2(-4.0, 9.0), "!", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 24, Color.WHITE)
	if menu_open:
		var r := dungeon_rect()
		UiStyle.box(_ui, r, 703)
		UiStyle.text(_ui, r.get_center(), "เข้าดันเจี้ยน", 28, UiStyle.INK, r.size.x - 20.0)
		var qr := quest_rect()
		UiStyle.box(_ui, qr, 704)
		UiStyle.text(_ui, qr.get_center(), "เควส", 28, UiStyle.INK, qr.size.x - 20.0)
		if alert:
			var qc := Vector2(qr.end.x - 6.0, qr.position.y + 4.0)
			_ui.draw_circle(qc, 16.0, Color(0.9, 0.25, 0.25))
			_ui.draw_string(font, qc + Vector2(-4.0, 9.0), "!", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 26, Color.WHITE)
	# ชื่อเมืองบนริบบิ้นกลางด้านบน
	var title: String = DungeonData.town_name(current_town)
	var tw := font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30).x
	var c := Vector2(_view.x * 0.5 - 60.0, 50.0)
	var rib := PackedVector2Array([c + Vector2(-tw * 0.5 - 50.0, -26.0), c + Vector2(tw * 0.5 + 50.0, -26.0), c + Vector2(tw * 0.5 + 32.0, 0.0), c + Vector2(tw * 0.5 + 50.0, 26.0), c + Vector2(-tw * 0.5 - 50.0, 26.0), c + Vector2(-tw * 0.5 - 32.0, 0.0)])
	_ui.draw_colored_polygon(rib, UiStyle.SOFT_PRIMARY)   # ริบบิ้นชื่อเมือง ชมพูฝุ่นนุ่ม
	var rim := rib.duplicate()
	rim.append(rib[0])
	Sketch.line(_ui, rim, 702, 3.0, Sketch.WOBBLE, INK)
	_ui.draw_string(font, c + Vector2(-tw * 0.5, 11.0), title, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, UiStyle.SOFT_TEXT)

# ---------------------------------------------------------------- ฉาก
func _ground_y() -> float:
	return _view.y * GROUND_AT

# ตัวคูณพารัลแลกซ์ ไกลเลื่อนช้า ใกล้เลื่อนเร็ว ไล่ระดับชัดๆ ให้ฉากมีมิติลึก
const PAR_CLOUDS := 0.1
const PAR_FAR := 0.2          # ภูเขา ฉากไกล
const PAR_FORT := 0.35        # ป้อมแมวกลางเมือง
const PAR_MID := 0.6          # กำแพงเมือง ฉากกลาง
const PAR_FRONT := 1.35       # ชั้นหน้าใกล้กล้อง
const CLOUD_TILE := 1800.0    # เมฆวาดเป็นลายซ้ำทุกช่วงนี้ เลื่อนลอยเองได้ไม่มีช่องโหว่
const CLOUD_DRIFT := 9.0      # เมฆลอยเองกี่จุดภาพต่อวินาที
var _cloud_node: Node2D
var _tufts: Node2D

func _span(factor: float) -> float:
	return town_half * CombatData.UNIT * ZOOM * factor + _view.x

## จุด x ที่ต้องวาดลายซ้ำของเมฆ (ครอบช่วงเลื่อนกล้องบวกระยะลอยหนึ่งช่วง)
func cloud_tiles() -> Array:
	var span := _span(PAR_CLOUDS) + CLOUD_TILE
	var out := []
	var x := -ceilf(span / CLOUD_TILE) * CLOUD_TILE
	while x < span:
		out.append(x)
		x += CLOUD_TILE
	return out

func _soft(c: CanvasItem, pts: PackedVector2Array, color: Color) -> void:
	SoftPaint.shape(c, pts, color, 0.06)

## ทุกชิ้นในฉากเมืองวาดเบลอนุ่มแบบสีน้ำ ไม่มีเส้นหมึก ให้ดูไกลและไม่แย่งสายตาตัวละคร
func _cut(c: CanvasItem, pts: PackedVector2Array, color: Color, _seed_no: int, _width := 2.4) -> void:
	SoftPaint.shape(c, pts, Color(color, color.a * 0.92), 0.05)

func _rect(x: float, y: float, w: float, h: float) -> PackedVector2Array:
	return PackedVector2Array([Vector2(x, y), Vector2(x + w, y), Vector2(x + w, y + h), Vector2(x, y + h)])

func _arc_top(cx: float, base: float, rx: float, ry: float, n := 20) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n + 1:
		var a := PI + PI * float(i) / float(n)
		pts.append(Vector2(cx + cos(a) * rx, base + sin(a) * ry))
	return pts

## หูแมวสองข้างบนหลังคา
func _ears(c: CanvasItem, cx: float, top: float, gap: float, size: float, color: Color, seed_no: int, soft := false) -> void:
	for side in [-1.0, 1.0]:
		var base := Vector2(cx + side * gap, top + size * 0.25)
		var pts := PackedVector2Array([base + Vector2(-size * 0.55, 0.0), base + Vector2(side * size * 0.15, -size), base + Vector2(size * 0.55, 0.0)])
		if soft:
			_soft(c, pts, color)
		else:
			_cut(c, pts, color, seed_no + int(side))
			c.draw_colored_polygon(PackedVector2Array([base + Vector2(-size * 0.25, -size * 0.1), base + Vector2(side * size * 0.12, -size * 0.7), base + Vector2(size * 0.25, -size * 0.1)]), Color(1.0, 0.75, 0.78))

func _paint_sky(c: Node2D) -> void:
	var low := _ground_y()
	var steps := 16
	for i in steps:
		var k := float(i) / float(steps - 1)
		c.draw_rect(Rect2(0.0, low * float(i) / float(steps), _view.x, low / float(steps) + 1.0), Color(0.58, 0.76, 0.94).lerp(Color(1.0, 0.92, 0.8), k))
	SoftPaint.oval(c, Vector2(_view.x * 0.8, low * 0.3), 70.0, 70.0, Color(1.0, 0.97, 0.82, 0.8), 0.6)
	SoftPaint.oval(c, Vector2(_view.x * 0.8, low * 0.3), 36.0, 36.0, Color(1.0, 1.0, 0.94), 0.3)

func _paint_clouds(c: Node2D) -> void:
	# ลายเมฆหนึ่งช่วง แล้ววาดซ้ำ เมฆลอยเองได้ไม่ขาดช่วง
	var puffs := []
	var x := 0.0
	while x < CLOUD_TILE - 200.0:
		var y := _rng.randf_range(30.0, 120.0)
		for n in 4:
			puffs.append([Vector2(x + float(n) * 40.0, y + _rng.randf_range(-10.0, 10.0)), _rng.randf_range(40.0, 64.0), _rng.randf_range(18.0, 28.0)])
		x += _rng.randf_range(320.0, 520.0)
	for t in cloud_tiles():
		for p in puffs:
			SoftPaint.oval(c, (p[0] as Vector2) + Vector2(t, 0.0), p[1], p[2], Color(1.0, 1.0, 1.0, 0.75), 0.5)

func _paint_mountains(c: Node2D) -> void:
	var span := _span(PAR_FAR)
	var low := _ground_y()
	for layer in 2:
		var pts := PackedVector2Array([Vector2(-span, low)])
		var x := -span
		while x <= span:
			pts.append(Vector2(x, low - _rng.randf_range(90.0, 170.0) + float(layer) * 50.0))
			x += _rng.randf_range(120.0, 220.0)
		pts.append(Vector2(span, low))
		_soft(c, pts, [Color(0.72, 0.76, 0.9, 0.5), Color(0.68, 0.76, 0.8, 0.55)][layer])

## หอคอยหลังคาหัวแมวมีหู
func _cat_tower(c: CanvasItem, x: float, base: float, w: float, h: float, wall: Color, roof: Color, soft: bool, seed_no: int) -> void:
	var body := _rect(x - w * 0.5, base - h, w, h)
	var head := _arc_top(x, base - h, w * 0.62, w * 0.55)
	if soft:
		_soft(c, body, wall)
		_soft(c, head, roof)
	else:
		_cut(c, body, wall, seed_no)
		_cut(c, head, roof, seed_no + 1)
	_ears(c, x, base - h - w * 0.45, w * 0.32, w * 0.4, roof, seed_no + 3, soft)
	for i in 2:
		var wy := base - h * (0.35 + 0.3 * float(i))
		if soft:
			SoftPaint.oval(c, Vector2(x, wy), w * 0.1, w * 0.14, Color(0.45, 0.4, 0.5, 0.5), 0.2)
		else:
			c.draw_circle(Vector2(x, wy), w * 0.1, Color(0.35, 0.3, 0.4))

## ปราการแมวใหญ่ไกลๆ กลางเมือง ป้อมหัวแมวยักษ์ ตาเป็นหน้าต่างเรือง ประตูโค้ง ธงแดง
func _paint_fortress(c: Node2D) -> void:
	var low := _ground_y() - ROW_BACK + 6.0
	var stone := Color(0.93, 0.88, 0.8)
	var roof := Color(0.4, 0.52, 0.8)
	_soft(c, _rect(-380.0, low - 150.0, 760.0, 150.0), stone.darkened(0.06))
	for i in 13:
		var x := -380.0 + float(i) * 60.0
		_soft(c, _arc_top(x + 14.0, low - 150.0, 15.0, 18.0, 10), stone.darkened(0.06))
	for t in [[-330.0, 70.0, 230.0], [330.0, 70.0, 230.0], [-180.0, 80.0, 280.0], [180.0, 80.0, 280.0]]:
		_cat_tower(c, t[0], low, t[1], t[2], stone, roof, true, 0)
	_soft(c, _rect(-110.0, low - 300.0, 220.0, 300.0), stone)
	_soft(c, _arc_top(0.0, low - 300.0, 140.0, 120.0), Color(0.98, 0.72, 0.45))
	_ears(c, 0.0, low - 400.0, 80.0, 90.0, Color(0.98, 0.72, 0.45), 0, true)
	for side in [-1.0, 1.0]:
		SoftPaint.oval(c, Vector2(side * 48.0, low - 345.0), 20.0, 26.0, Color(1.0, 0.95, 0.6, 0.95), 0.2)
	SoftPaint.oval(c, Vector2(0.0, low - 60.0), 60.0, 60.0, Color(0.45, 0.32, 0.25, 0.85), 0.2)
	SoftPaint.box(c, Rect2(-60.0, low - 60.0, 120.0, 60.0), Color(0.45, 0.32, 0.25, 0.85), 6.0)
	for side in [-1.0, 1.0]:
		_soft(c, PackedVector2Array([Vector2(side * 250.0 - 22.0, low - 140.0), Vector2(side * 250.0 + 22.0, low - 140.0), Vector2(side * 250.0 + 22.0, low - 70.0), Vector2(side * 250.0, low - 84.0), Vector2(side * 250.0 - 22.0, low - 70.0)]), Color(0.8, 0.25, 0.25, 0.9))

## กำแพงเมือง เชิงเทินเป็นหูแมวคู่ หอคอยหัวแมวเป็นช่วงๆ ธงน้ำเงิน
func _paint_wall(c: Node2D) -> void:
	var span := _span(PAR_MID)
	var low := _ground_y() - ROW_BACK + 4.0
	var stone := Color(0.86, 0.8, 0.72)
	_soft(c, _rect(-span, low - 90.0, span * 2.0, 90.0), stone)
	var x := -span
	while x < span:
		_soft(c, _arc_top(x + 16.0, low - 90.0, 16.0, 16.0, 10), stone)
		x += 52.0
	x = -span + 100.0
	while x < span:
		_cat_tower(c, x, low, 60.0, 150.0, stone.darkened(0.05), Color(0.78, 0.4, 0.34), true, 0)
		var bx := x + 150.0
		_soft(c, PackedVector2Array([Vector2(bx - 20.0, low - 86.0), Vector2(bx + 20.0, low - 86.0), Vector2(bx + 20.0, low - 26.0), Vector2(bx, low - 36.0), Vector2(bx - 20.0, low - 26.0)]), Color(0.38, 0.5, 0.8, 0.9))
		SoftPaint.oval(c, Vector2(bx, low - 58.0), 7.0, 6.0, Color(1.0, 0.9, 0.6), 0.2)
		x += 420.0

## ทางเท้าหน้าบ้าน ถนนที่ตัวละครเดิน ราวกำแพงหินขอบหน้า แล้วชั้นล่างเป็นคลองที่ลงไปไม่ได้
func _paint_ground(c: Node2D) -> void:
	var g := _ground_y()
	var walk := g - ROW_BACK
	var front := g + STREET_FRONT
	var span := _span(1.0)
	# ทางเท้าหน้าบ้าน หินแผ่นสีครีม
	c.draw_rect(Rect2(-span, walk, span * 2.0, g - 24.0 - walk), Color(0.93, 0.88, 0.78))
	var x := -span
	while x < span:
		c.draw_line(Vector2(x, walk), Vector2(x - 10.0, g - 24.0), Color(0.78, 0.72, 0.62), 1.5, true)
		x += 120.0
	# ขอบทางเท้า
	c.draw_rect(Rect2(-span, g - 28.0, span * 2.0, 8.0), Color(0.72, 0.66, 0.58))
	# ถนนหินที่ตัวละครเดิน
	c.draw_rect(Rect2(-span, g - 20.0, span * 2.0, front - g + 20.0), Color(0.84, 0.74, 0.62))
	for row in 3:
		var y := g - 10.0 + float(row) * 20.0
		var size := 14.0 + float(row) * 2.0
		x = -span + float(row % 2) * size
		while x < span:
			var w := size * _rng.randf_range(1.5, 2.1)
			c.draw_colored_polygon(Sketch.oval(Vector2(x + w * 0.5, y), w * 0.5, size * 0.42, 10), Color(0.7, 0.6, 0.5, 0.18))
			x += w + size * 0.3
	# ชั้นล่าง คลองน้ำใต้ราวกำแพง
	var bands := 8
	for i in bands:
		var k := float(i) / float(bands)
		c.draw_rect(Rect2(-span, front + (_view.y - front) * k, span * 2.0, (_view.y - front) / float(bands) + 1.0), Color(0.55, 0.75, 0.88).lerp(Color(0.35, 0.55, 0.75), k))
	x = -span
	while x < span:
		var y := _rng.randf_range(front + 70.0, _view.y - 10.0)
		c.draw_line(Vector2(x, y), Vector2(x + _rng.randf_range(40.0, 90.0), y), Color(0.85, 0.95, 1.0, 0.35), 2.5, true)
		x += _rng.randf_range(220.0, 400.0)
	# ราวกำแพงหินขอบหน้าถนน มีเสาลูกกรงโค้งมน
	c.draw_rect(Rect2(-span, front, span * 2.0, 46.0), Color(0.86, 0.82, 0.76))
	x = -span
	while x < span:
		c.draw_colored_polygon(_arc_top(x + 18.0, front + 40.0, 12.0, 18.0, 10) + PackedVector2Array([Vector2(x + 30.0, front + 40.0), Vector2(x + 6.0, front + 40.0)]), Color(0.95, 0.92, 0.86))
		x += 40.0
	c.draw_rect(Rect2(-span, front - 6.0, span * 2.0, 14.0), Color(0.78, 0.73, 0.66))
	c.draw_rect(Rect2(-span, front + 40.0, span * 2.0, 10.0), Color(0.72, 0.66, 0.6))
	c.draw_line(Vector2(-span, front - 6.0), Vector2(span, front - 6.0), Color(INK, 0.25), 2.0)
	c.draw_line(Vector2(-span, front + 50.0), Vector2(span, front + 50.0), Color(INK, 0.25), 2.0)
	c.draw_line(Vector2(-span, walk), Vector2(span, walk), Color(INK, 0.2), 2.0)

## บ้านหัวแมว หลังคาโค้งเป็นหัวแมวมีหู หน้าต่างกลมเป็นตา จมูก ประตูโค้ง หนวดบนผนัง
func _cat_head_house(c: CanvasItem, x: float, base: float, n: int) -> float:
	var w := _rng.randf_range(170.0, 210.0)
	var h := _rng.randf_range(110.0, 140.0)
	var wall: Color = WALLS[n % WALLS.size()]
	var roof: Color = ROOFS[(n + 1) % ROOFS.size()]
	var cx := x + w * 0.5
	_ears(c, cx, base - h - w * 0.4, w * 0.3, w * 0.28, roof, 300 + n)
	_cut(c, _arc_top(cx, base - h + 6.0, w * 0.58, w * 0.45), roof, 310 + n)
	_cut(c, _rect(x, base - h, w, h), wall, 320 + n)
	for side in [-1.0, 1.0]:
		var e := Vector2(cx + side * w * 0.24, base - h - w * 0.14)
		_cut(c, Sketch.oval(e, 18.0, 20.0, 18), Color(0.6, 0.82, 0.95), 330 + n, 2.0)
		c.draw_circle(e + Vector2(0.0, 3.0), 7.0, INK)
		c.draw_circle(e + Vector2(-3.0, -3.0), 3.0, Color.WHITE)
		for k in 2:
			c.draw_line(Vector2(cx + side * w * 0.36, base - h * 0.55 + float(k) * 10.0), Vector2(cx + side * w * 0.48, base - h * 0.6 + float(k) * 14.0), INK, 2.0, true)
	c.draw_colored_polygon(PackedVector2Array([Vector2(cx - 7.0, base - h - w * 0.02), Vector2(cx + 7.0, base - h - w * 0.02), Vector2(cx, base - h + 6.0)]), Color(0.95, 0.5, 0.55))
	var door := _arc_top(cx, base - 50.0, 26.0, 26.0, 12)
	door.append(Vector2(cx + 26.0, base))
	door.append(Vector2(cx - 26.0, base))
	_cut(c, door, Color(0.6, 0.4, 0.26), 340 + n)
	c.draw_circle(Vector2(cx + 14.0, base - 26.0), 3.0, Color(1.0, 0.85, 0.35))
	return w

## คอนโดแมว เสาพันเชือก ชั้นเบาะหลายชั้น กล่องรูกลมมีตาแมวมอง แมวนอนบนสุด ของเล่นห้อย
func _condo(c: CanvasItem, x: float, base: float, n: int) -> float:
	var w := 230.0
	var rope := Color(0.85, 0.72, 0.5)
	var pad_col: Color = (ROOFS[n % ROOFS.size()] as Color).lightened(0.25)
	for post in [[x + 40.0, base, base - 330.0], [x + 170.0, base, base - 160.0], [x + 110.0, base - 160.0, base - 250.0]]:
		var px: float = post[0]
		var low: float = post[1]
		var high: float = post[2]
		_cut(c, _rect(px - 12.0, high, 24.0, low - high), rope, 400 + n)
		var y := high + 6.0
		while y < low - 4.0:
			c.draw_line(Vector2(px - 12.0, y), Vector2(px + 12.0, y + 5.0), Color(0.65, 0.52, 0.34), 1.6, true)
			y += 9.0
	for lv in [[base - 70.0, 0.0, 230.0], [base - 160.0, 30.0, 170.0], [base - 250.0, 0.0, 150.0], [base - 330.0, 50.0, 120.0]]:
		_cut(c, _rect(x + float(lv[1]), float(lv[0]) - 14.0, float(lv[2]), 18.0), pad_col, 410 + n)
	for bx in [[x + 10.0, base - 70.0], [x + 60.0, base - 250.0]]:
		var bx0: float = bx[0]
		var by: float = bx[1]
		_cut(c, _rect(bx0, by - 80.0, 80.0, 66.0), pad_col.darkened(0.12), 420 + n)
		c.draw_circle(Vector2(bx0 + 40.0, by - 46.0), 22.0, Color(0.3, 0.25, 0.28))
		c.draw_circle(Vector2(bx0 + 34.0, by - 46.0), 3.0, Color(1.0, 0.9, 0.4))
		c.draw_circle(Vector2(bx0 + 46.0, by - 46.0), 3.0, Color(1.0, 0.9, 0.4))
	var cat_col: Color = [Color(1.0, 0.75, 0.45), Color(0.6, 0.6, 0.65), Color(0.98, 0.97, 0.94)][n % 3]
	var top := Vector2(x + 110.0, base - 344.0)
	_cut(c, Sketch.oval(top, 46.0, 20.0, 20), cat_col, 430 + n)
	_ears(c, top.x - 28.0, top.y - 30.0, 10.0, 18.0, cat_col, 440 + n)
	c.draw_arc(top + Vector2(-34.0, -4.0), 5.0, 0.2, PI - 0.2, 6, INK, 2.0, true)
	c.draw_arc(top + Vector2(-22.0, -4.0), 5.0, 0.2, PI - 0.2, 6, INK, 2.0, true)
	c.draw_line(Vector2(x + 200.0, base - 160.0), Vector2(x + 200.0, base - 110.0), INK, 1.6, true)
	c.draw_circle(Vector2(x + 200.0, base - 104.0), 9.0, Color(0.95, 0.4, 0.5))
	return w

## ร้านปลา กันสาดลายทาง ป้ายปลาบนหลังคา ปลาแขวนหน้าร้าน
func _fish_shop(c: CanvasItem, x: float, base: float, n: int) -> float:
	var w := _rng.randf_range(180.0, 220.0)
	var h := 150.0
	var wall: Color = WALLS[(n + 2) % WALLS.size()]
	_cut(c, _rect(x, base - h, w, h), wall, 500 + n)
	_cut(c, _arc_top(x + w * 0.5, base - h + 4.0, w * 0.5 + 16.0, 74.0), Color(0.45, 0.6, 0.85), 510 + n)
	for k in 3:
		var sh := _arc_top(x + w * 0.5, base - h + 4.0 - float(k + 1) * 18.0, (w * 0.5 + 16.0) * (1.0 - float(k + 1) * 0.2), 74.0 * (1.0 - float(k + 1) * 0.24))
		c.draw_polyline(sh, Color(0.35, 0.48, 0.72), 2.0, true)
	for i in 6:
		var sx := x - 8.0 + (w + 16.0) * float(i) / 6.0
		c.draw_colored_polygon(PackedVector2Array([Vector2(sx, base - 96.0), Vector2(sx + (w + 16.0) / 6.0, base - 96.0), Vector2(sx + (w + 16.0) / 6.0, base - 74.0), Vector2(sx, base - 74.0)]), Color(0.9, 0.3, 0.3) if i % 2 == 0 else Color.WHITE)
	c.draw_line(Vector2(x - 8.0, base - 74.0), Vector2(x + w + 8.0, base - 74.0), INK, 2.0, true)
	var fc := Vector2(x + w * 0.5, base - h - 100.0)
	_cut(c, PackedVector2Array([fc + Vector2(-40.0, 0.0), fc + Vector2(-10.0, -18.0), fc + Vector2(26.0, -10.0), fc + Vector2(40.0, -24.0), fc + Vector2(40.0, 24.0), fc + Vector2(26.0, 10.0), fc + Vector2(-10.0, 18.0)]), Color(0.55, 0.78, 0.95), 520 + n)
	c.draw_circle(fc + Vector2(-26.0, -3.0), 3.5, INK)
	for i in 3:
		var hx := x + 30.0 + float(i) * (w - 60.0) / 2.0
		c.draw_line(Vector2(hx, base - 74.0), Vector2(hx, base - 60.0), INK, 1.5, true)
		c.draw_colored_polygon(PackedVector2Array([Vector2(hx, base - 60.0), Vector2(hx + 9.0, base - 46.0), Vector2(hx, base - 30.0), Vector2(hx - 9.0, base - 46.0)]), Color(0.7, 0.8, 0.88))
	_cut(c, _rect(x + w * 0.35, base - 56.0, w * 0.3, 56.0), Color(0.6, 0.4, 0.26), 530 + n)
	return w

## บ้านกล่องกระดาษซ้อนกัน ฝาพับเปิด หน้าต่างรูปรอยเท้า แมวโผล่หู
func _box_house(c: CanvasItem, x: float, base: float, n: int) -> float:
	var box := Color(0.86, 0.68, 0.45)
	_cut(c, _rect(x, base - 110.0, 120.0, 110.0), box, 600 + n)
	_cut(c, _rect(x + 110.0, base - 90.0, 90.0, 90.0), box.darkened(0.08), 601 + n)
	_cut(c, _rect(x + 30.0, base - 200.0, 100.0, 90.0), box.lightened(0.05), 602 + n)
	_cut(c, PackedVector2Array([Vector2(x + 30.0, base - 200.0), Vector2(x + 8.0, base - 228.0), Vector2(x + 60.0, base - 214.0)]), box.darkened(0.12), 603 + n)
	_cut(c, PackedVector2Array([Vector2(x + 130.0, base - 200.0), Vector2(x + 152.0, base - 226.0), Vector2(x + 100.0, base - 214.0)]), box.darkened(0.12), 604 + n)
	_ears(c, x + 80.0, base - 218.0, 18.0, 22.0, Color(0.55, 0.55, 0.6), 605 + n)
	for p in [Vector2(x + 60.0, base - 60.0), Vector2(x + 80.0, base - 156.0), Vector2(x + 155.0, base - 50.0)]:
		c.draw_circle(p, 12.0, Color(0.45, 0.32, 0.22))
		for t in 3:
			c.draw_circle(p + Vector2(-11.0 + float(t) * 11.0, -15.0), 5.0, Color(0.45, 0.32, 0.22))
	c.draw_line(Vector2(x + 10.0, base - 100.0), Vector2(x + 110.0, base - 100.0), Color(0.7, 0.5, 0.3), 3.0, true)
	return 200.0

## บ้านโดมไหมพรม ลายเส้นไหมโค้ง ปลายไหมห้อยลงพื้น
func _yarn_house(c: CanvasItem, x: float, base: float, n: int) -> float:
	var r := 95.0
	var col: Color = (ROOFS[(n + 3) % ROOFS.size()] as Color).lightened(0.15)
	var cc := Vector2(x + r, base - r * 0.9)
	_cut(c, Sketch.oval(cc, r, r * 0.95, 36), col, 700 + n)
	for i in 4:
		var a := -0.9 + float(i) * 0.6
		var pts := PackedVector2Array()
		for k in 13:
			var t := -PI * 0.5 + PI * float(k) / 12.0
			pts.append(cc + Vector2(cos(t + a) * r * 0.85 * cos(a * 0.6), sin(t) * r * 0.9).rotated(a * 0.4))
		c.draw_polyline(pts, col.darkened(0.25), 2.4, true)
	var door := _arc_top(cc.x, base - 44.0, 24.0, 22.0, 12)
	door.append(Vector2(cc.x + 24.0, base))
	door.append(Vector2(cc.x - 24.0, base))
	_cut(c, door, Color(0.6, 0.4, 0.26), 710 + n)
	var tail := PackedVector2Array()
	for k in 10:
		var t := float(k) / 9.0
		tail.append(cc + Vector2(r * 0.9 + t * 60.0, r * 0.2 + t * t * (r * 0.7) + sin(t * 9.0) * 8.0))
	c.draw_polyline(tail, col.darkened(0.25), 3.0, true)
	return r * 2.0 + 50.0

## หอคอยยามหลังคาหัวแมว ธงบนยอด
func _watch_tower(c: CanvasItem, x: float, base: float, n: int) -> float:
	_cat_tower(c, x + 50.0, base, 90.0, 230.0, Color(0.88, 0.84, 0.78), ROOFS[n % ROOFS.size()], false, 800 + n)
	c.draw_line(Vector2(x + 50.0, base - 320.0), Vector2(x + 50.0, base - 360.0), INK, 2.0, true)
	c.draw_colored_polygon(PackedVector2Array([Vector2(x + 50.0, base - 360.0), Vector2(x + 84.0, base - 352.0), Vector2(x + 50.0, base - 344.0)]), Color(0.88, 0.25, 0.22))
	return 110.0

## เต็นท์ร้านเบาะนอนแมว หลังคาแหลมลายทาง กระดิ่ง เบาะกองหน้าร้าน
func _cushion_tent(c: CanvasItem, x: float, base: float, n: int) -> float:
	var w := 180.0
	var col: Color = ROOFS[(n + 2) % ROOFS.size()]
	_cut(c, _rect(x + 10.0, base - 100.0, w - 20.0, 100.0), Color(0.98, 0.95, 0.88), 900 + n)
	_cut(c, _arc_top(x + w * 0.5, base - 30.0, 30.0, 34.0, 12) + PackedVector2Array([Vector2(x + w * 0.5 + 30.0, base), Vector2(x + w * 0.5 - 30.0, base)]), Color(0.6, 0.4, 0.26), 905 + n)
	# หลังคาโดมลายทางโค้ง ยอดมีลูกกลม
	var dome := _arc_top(x + w * 0.5, base - 98.0, w * 0.55, 104.0, 24)
	c.draw_colored_polygon(dome, col.lightened(0.4))
	for i in 3:
		var k := (float(i) - 1.0) * 0.36
		var band := PackedVector2Array()
		for j in 13:
			var t := float(j) / 12.0
			band.append(Vector2(x + w * 0.5 + w * 0.55 * (k - 0.13) * sin(t * PI * 0.5), base - 98.0 - 104.0 * cos(t * PI * 0.5)))
		for j in range(12, -1, -1):
			var t := float(j) / 12.0
			band.append(Vector2(x + w * 0.5 + w * 0.55 * (k + 0.13) * sin(t * PI * 0.5), base - 98.0 - 104.0 * cos(t * PI * 0.5)))
		c.draw_colored_polygon(band, col)
	var rim := dome.duplicate()
	c.draw_circle(Vector2(x + w * 0.5, base - 206.0), 8.0, Color(1.0, 0.85, 0.3))
	c.draw_circle(Vector2(x + w * 0.5, base - 92.0), 9.0, Color(1.0, 0.85, 0.3))
	for i in 3:
		_cut(c, Sketch.oval(Vector2(x + 50.0 + float(i) * 40.0, base - 14.0 - float(i % 2) * 22.0), 28.0, 12.0, 14), [Color(0.95, 0.6, 0.65), Color(0.6, 0.75, 0.95), Color(0.95, 0.85, 0.5)][i], 920 + n + i, 1.8)
	return w

## รูปปั้นอัศวินแมวบนแท่น ถือดาบ
func _statue(c: CanvasItem, x: float, base: float, k: float, seed_no: int) -> void:
	var stone := Color(0.82, 0.82, 0.86)
	_cut(c, _rect(x - 40.0 * k, base - 56.0 * k, 80.0 * k, 56.0 * k), stone.darkened(0.12), seed_no)
	var top := base - 56.0 * k
	_cut(c, Sketch.oval(Vector2(x, top - 50.0 * k), 50.0 * k, 46.0 * k, 24), stone, seed_no + 1)
	_ears(c, x, top - 96.0 * k, 24.0 * k, 26.0 * k, stone, seed_no + 2)
	c.draw_arc(Vector2(x - 16.0 * k, top - 56.0 * k), 6.0 * k, 0.2, PI - 0.2, 6, INK, 2.0, true)
	c.draw_arc(Vector2(x + 16.0 * k, top - 56.0 * k), 6.0 * k, 0.2, PI - 0.2, 6, INK, 2.0, true)
	_cut(c, _rect(x + 46.0 * k, top - 130.0 * k, 9.0 * k, 130.0 * k), Color(0.75, 0.78, 0.84), seed_no + 3)
	_cut(c, _rect(x + 34.0 * k, top - 96.0 * k, 34.0 * k, 8.0 * k), Color(0.95, 0.8, 0.35), seed_no + 4)

## โคมไฟรูปปลา
func _lamp(c: CanvasItem, x: float, base: float, seed_no: int) -> void:
	_cut(c, _rect(x - 5.0, base - 170.0, 10.0, 170.0), Color(0.3, 0.3, 0.36), seed_no)
	var fc := Vector2(x + 26.0, base - 176.0)
	c.draw_line(Vector2(x, base - 170.0), fc + Vector2(-10.0, 0.0), Color(0.3, 0.3, 0.36), 4.0, true)
	_cut(c, PackedVector2Array([fc + Vector2(-16.0, 0.0), fc + Vector2(0.0, -10.0), fc + Vector2(14.0, -6.0), fc + Vector2(22.0, -14.0), fc + Vector2(22.0, 14.0), fc + Vector2(14.0, 6.0), fc + Vector2(0.0, 10.0)]), Color(1.0, 0.88, 0.5), seed_no + 1, 1.8)

## ลานกลางเมือง น้ำพุรูปปั้นแมวพ่นน้ำ
func _fountain(c: CanvasItem, x: float, base: float) -> void:
	_cut(c, Sketch.oval(Vector2(x, base - 16.0), 140.0, 26.0, 40), Color(0.85, 0.85, 0.88), 950)
	c.draw_colored_polygon(Sketch.oval(Vector2(x, base - 20.0), 122.0, 18.0, 40), Color(0.55, 0.78, 0.95))
	_cut(c, _rect(x - 16.0, base - 90.0, 32.0, 72.0), Color(0.85, 0.85, 0.88), 951)
	_cut(c, Sketch.oval(Vector2(x, base - 112.0), 34.0, 30.0, 24), Color(0.85, 0.85, 0.88), 952)
	_ears(c, x, base - 140.0, 16.0, 20.0, Color(0.85, 0.85, 0.88), 953)
	for side in [-1.0, 1.0]:
		var pts := PackedVector2Array()
		for i in 9:
			var k := float(i) / 8.0
			pts.append(Vector2(x + side * (10.0 + 100.0 * k), base - 104.0 - 40.0 * sin(k * PI) + 80.0 * k * k))
		c.draw_polyline(pts, Color(0.7, 0.88, 1.0, 0.9), 5.0, true)

## ประตูเมืองหัวท้าย ซุ้มหัวแมวยักษ์ระหว่างหอคอยสองข้าง
func _gate(c: CanvasItem, x: float, base: float) -> void:
	var stone := Color(0.84, 0.78, 0.7)
	for side in [-1.0, 1.0]:
		_cat_tower(c, x + side * 120.0, base, 80.0, 250.0, stone, Color(0.78, 0.4, 0.34), false, 960 + int(side))
	_cut(c, _rect(x - 80.0, base - 240.0, 160.0, 60.0), stone, 965)
	_cut(c, _arc_top(x, base - 240.0, 90.0, 60.0), Color(0.98, 0.72, 0.45), 966)
	_ears(c, x, base - 300.0, 46.0, 40.0, Color(0.98, 0.72, 0.45), 967)

func _paint_row(c: Node2D) -> void:
	var base := (_ground_y() - ROW_BACK) / ROW_SCALE
	var span := (town_half * CombatData.UNIT * ZOOM + 300.0) / ROW_SCALE
	var kinds := [_cat_head_house, _condo, _fish_shop, _box_house, _yarn_house, _cat_head_house, _cushion_tent, _watch_tower]
	var x := -span
	var n := 0
	while x < span:
		# เว้นลานน้ำพุกลางเมือง
		if x > -500.0 and x < 230.0:
			x = 230.0
			continue
		var w: float = (kinds[(n * 3 + 1) % kinds.size()] as Callable).call(c, x, base, n)
		x += w + _rng.randf_range(50.0, 90.0)
		if n % 4 == 3:
			_lamp(c, x + 10.0, base, 1000 + n)
			x += 50.0
		if n % 7 == 6:
			_statue(c, x + 50.0, base, 0.9, 1100 + n)
			x += 140.0
		n += 1
	_fountain(c, 0.0, base + 14.0)
	_statue(c, -170.0, base, 1.1, 1200)
	_statue(c, 170.0, base, 1.1, 1210)
	for side in [-1.0, 1.0]:
		_gate(c, side * (span + 60.0), base)

## ชั้นล่างใกล้กล้อง หลังคาบ้านย่านล่างโค้งมนโผล่เหนือคลอง เรือ โคมแขวน บอกว่ามีชั้นล่างแต่ลงไปไม่ได้
func _paint_front(c: Node2D) -> void:
	var span := _span(PAR_FRONT)
	var top := _ground_y() + STREET_FRONT + 80.0
	var x := -span
	var n := 0
	while x < span:
		var w := _rng.randf_range(150.0, 230.0)
		var roof: Color = ROOFS[n % ROOFS.size()]
		var cx := x + w * 0.5
		var peak := top + _rng.randf_range(0.0, 50.0)
		if n % 3 == 1:
			# เรือลำเล็กในคลอง
			var by := _view.y - 40.0
			_cut(c, PackedVector2Array([Vector2(cx - 70.0, by), Vector2(cx + 70.0, by), Vector2(cx + 50.0, by + 26.0), Vector2(cx - 50.0, by + 26.0)]), Color(0.7, 0.48, 0.3), 1500 + n)
			_cut(c, Sketch.oval(Vector2(cx - 10.0, by - 18.0), 22.0, 18.0, 16), Color(1.0, 0.75, 0.45), 1510 + n)
			_ears(c, cx - 10.0, by - 44.0, 9.0, 14.0, Color(1.0, 0.75, 0.45), 1520 + n)
		else:
			# บ้านย่านล่าง เห็นแค่หลังคาโดมหัวแมวกับผนังส่วนบน
			_cut(c, _rect(x + 14.0, peak + 40.0, w - 28.0, _view.y - peak), WALLS[(n + 1) % WALLS.size()], 1600 + n)
			_cut(c, _arc_top(cx, peak + 44.0, w * 0.5, 64.0), roof, 1610 + n)
			if n % 2 == 0:
				_ears(c, cx, peak - 26.0, w * 0.26, 30.0, roof, 1620 + n)
			c.draw_circle(Vector2(cx, peak + 74.0), 14.0, Color(1.0, 0.9, 0.55))
			c.draw_arc(Vector2(cx, peak + 74.0), 14.0, 0.0, TAU, 16, INK, 2.0, true)
		x += w + _rng.randf_range(260.0, 480.0)
		n += 1

# ---------------------------------------------------------------- เมืองหลายแบบ ชั้น วาป NPC
## สีของเมืองนี้
func pal(key: String) -> Color:
	var p: Dictionary = _town.get("palette", {})
	var fallback := {"sky": Color(0.75, 0.88, 1.0), "ground": Color(0.86, 0.78, 0.62), "wall": Color(0.99, 0.93, 0.82), "roof": Color(0.95, 0.6, 0.35), "accent": Color(0.9, 0.45, 0.5)}
	return p.get(key, fallback.get(key, Color.WHITE))

func floors() -> Array:
	var list: Array = _town.get("floors", [])
	return list if not list.is_empty() else [{"name": "ถนนหลัก", "y": 0.0, "half": float(_town.get("half", TOWN_HALF)), "deco": "houses"}]

func floor_data() -> Dictionary:
	var list := floors()
	return list[clampi(_floor, 0, list.size() - 1)]

func current_floor() -> int:
	return _floor

## NPC สร้างโมเดลตอนนี้ได้ไหม: ผิวที่สร้างล่วงหน้าเสร็จแล้ว (หรือรอเกิน 4 วิ) และเฟรมนี้ยังไม่มีตัวไหนสร้าง
func npc_can_build() -> bool:
	if _warm_task >= 0:
		if WorkerThreadPool.is_task_completed(_warm_task) or _warm_wait > 6.0:
			WorkerThreadPool.wait_for_task_completion(_warm_task)
			_warm_task = -1
		else:
			return false
	var f := Engine.get_process_frames()
	if f == _npc_made_frame:
		return false
	_npc_made_frame = f
	return true

## สร้างฉากของชั้นปัจจุบันใหม่ทั้งหมด (ตอนเข้าเมืองและตอนวาปขึ้นลงชั้น)
func _build_floor() -> void:
	for l in _layers:
		if is_instance_valid(l[0]):
			(l[0] as Node2D).queue_free()
	_layers.clear()
	if _front != null:
		_front.queue_free()
		_front = null
	if _planet != null:
		_planet.queue_free()
		_planet = null
	town_half = float(floor_data().get("half", _town.get("half", TOWN_HALF)))
	hero.half_width = town_half
	if _terrain != null:
		_terrain.queue_free()
		_terrain = null
	_tdata = TownData.terrain(current_town, _floor) if style != "curve" else {}
	Hero.ground_fn = Callable(self, "ground_h") if not _tdata.is_empty() else Callable()
	var classic := style == "street" and str(floor_data().get("deco", "houses")) == "houses"
	var painters: Array
	if classic:
		painters = [[0.0, _paint_sky], [PAR_CLOUDS, _paint_clouds], [PAR_FAR, _paint_mountains], [PAR_FORT, _paint_fortress], [PAR_MID, _paint_wall], [1.0, _paint_ground], [1.0, _paint_row]]
	elif style == "curve":
		painters = [[0.0, func(c: Node2D) -> void: TownScene.sky(c, self)], [PAR_CLOUDS, func(c: Node2D) -> void: TownScene.clouds(c, self)], [PAR_FAR, func(c: Node2D) -> void: TownScene.far(c, self)]]
	else:
		painters = [[0.0, func(c: Node2D) -> void: TownScene.sky(c, self)], [PAR_CLOUDS, func(c: Node2D) -> void: TownScene.clouds(c, self)], [PAR_FAR, func(c: Node2D) -> void: TownScene.far(c, self)],
			[PAR_MID, func(c: Node2D) -> void: TownScene.mid(c, self)], [1.0, func(c: Node2D) -> void: TownScene.ground(c, self)], [1.0, func(c: Node2D) -> void: TownScene.row(c, self)]]
	# ชั้นที่มีภูมิประเทศ พื้นกับแถวบ้านวาดในโลกตามเนินแทน (ไม่ใช้ชั้นพื้นเรียบ)
	if not _tdata.is_empty():
		painters = painters.filter(func(pp: Array) -> bool: return float(pp[0]) < 1.0)
	_cloud_node = null
	_tufts = null
	for i in painters.size():
		var node := _layer(float(painters[i][0]), painters[i][1])
		move_child(node, i)
		if float(painters[i][0]) == PAR_CLOUDS:
			_cloud_node = node
		if classic and i == painters.size() - 1:
			node.scale = Vector2.ONE * ROW_SCALE
		# ฉากไกลจางลง ไม่แย่งสายตากับแถวบ้าน
		if (classic and (i == 3 or i == 4)) or (not classic and i == 3):
			node.modulate = Color(1.0, 1.0, 1.0, 0.7)
	if style == "curve":
		_planet = Node2D.new()
		var seed_no := 1300 + _floor
		_planet.draw.connect(func() -> void:
			_rng.seed = seed_no
			TownScene.planet(_planet, self, PLANET_R)
			_draw_props_on(_planet, true))
		add_child(_planet)
		move_child(_planet, painters.size())
	if _tdata.is_empty():
		var front_painter: Callable = _paint_front if classic else (func(c: Node2D) -> void: TownScene.front(c, self))
		_front = _layer(PAR_FRONT, front_painter)
		move_child(_front, world.get_index() + 1)
		_front.modulate = Color(1.0, 1.0, 1.0, 0.75)
	else:
		# ชั้นมีเนิน ไม่มีชั้นหน้าแบบเดิม ใส่พุ่มไม้กระดาษตัดชิดขอบล่างจอแทน เลื่อนเร็วกว่าพื้น
		var tkind := ForeTufts.kind_for_town(style)
		if tkind != "":
			_tufts = _layer(ForeTufts.FACTOR, func(c: Node2D) -> void: ForeTufts.paint(c, tkind, _span(ForeTufts.FACTOR), _view.y, _rng))
			move_child(_tufts, world.get_index() + 1)
		_terrain = Node2D.new()
		_terrain.scale = Vector2.ONE / ZOOM
		var tseed := 1700 + current_town * 10 + _floor
		_terrain.draw.connect(func() -> void:
			_rng.seed = tseed
			TownScene.terrain(_terrain, self))
		world.add_child(_terrain)
		world.move_child(_terrain, 0)
		hero.pos.y = ground_h(hero.pos.x)
	_build_npcs()
	_props.visible = style != "curve"
	_props.queue_redraw()
	_follow(0.0)

func _build_npcs() -> void:
	for n in _npcs:
		if is_instance_valid(n):
			n.queue_free()
	_npcs.clear()
	for d in _town.get("npcs", []):
		if int(d.get("floor", 0)) != _floor:
			continue
		var npc := TownNpc.new()
		npc.data = d
		npc.page = self
		# NPC ยืนแถวหลังติดฉาก (หน้าบ้าน) ยกขึ้นจากทางเดิน วาดหลังตัวละคร ทางเดินโล่ง
		npc.position = Vector2(float(d.get("x", 0.0)) * CombatData.UNIT, -ground_h(float(d.get("x", 0.0))) * CombatData.UNIT - TownNpc.back_lift())
		world.add_child(npc)
		world.move_child(npc, 1)
		_npcs.append(npc)

## เมืองดาว ตัวละครอื่นวางตามผิวโค้งของดาว เอียงตาม
func _curve_actors() -> void:
	for n in _npcs:
		if not is_instance_valid(n):
			continue
		var sx: float = float(n.data.get("x", 0.0)) * CombatData.UNIT * ZOOM
		var phi := (sx - cam) / PLANET_R
		n.position = Vector2((cam + PLANET_R * sin(phi)) / ZOOM, PLANET_R * (1.0 - cos(phi)) / ZOOM) + Vector2(sin(phi), -cos(phi)) * TownNpc.back_lift()
		n.rotation = phi

## ของที่กดใช้ได้บนชั้นนี้ [{kind x label up to to_x ...}]
func interactables() -> Array:
	var out := []
	for key in ["board", "mailbox", "dungeon_gate"]:
		var d: Dictionary = _town.get(key, {})
		if d.is_empty() or int(d.get("floor", 0)) != _floor:
			continue
		var kind: String = "gate" if key == "dungeon_gate" else key
		out.append({"kind": kind, "x": float(d.get("x", 0.0))})
	for w in _town.get("warps", []):
		if int(w.get("from", 0)) != _floor:
			continue
		var to := int(w.get("to", 0))
		out.append({"kind": "warp", "x": float(w.get("x", 0.0)), "to": to, "to_x": float(w.get("to_x", 0.0)), "warp": str(w.get("kind", "door")), "up": to > _floor})
	for n in _npcs:
		if is_instance_valid(n):
			out.append({"kind": "npc", "x": float(n.data.get("x", 0.0)), "npc": n})
	return out

func _prop_label(it: Dictionary) -> String:
	match str(it["kind"]):
		"board":
			return "กระดานเควส"
		"mailbox":
			return "ตู้จดหมาย"
		"gate":
			return "ไปผจญภัย →" if WalkPage.current_town == 0 else "ประตูดันเจี้ยน"
		"warp":
			var fl: Array = floors()
			var to := int(it["to"])
			return str((fl[to] as Dictionary).get("name", "")) if to >= 0 and to < fl.size() else ""
	return ""

## ของชิ้นนี้คือของที่ใกล้ตัวละครที่สุดตอนนี้ (ป้ายชื่อขึ้นเฉพาะอันนี้)
func _is_near(it: Dictionary) -> bool:
	return not _near.is_empty() and str(_near.get("kind", "")) == str(it.get("kind", "")) and float(_near.get("x", 0.0)) == float(it.get("x", 0.0))

## NPC ตัวนี้อยู่ใกล้พอให้ขึ้นป้ายชื่อ
func npc_label_on(n: TownNpc) -> bool:
	return hero != null and absf(hero.pos.x - n.x_units()) < NEAR * 1.4

func _draw_props() -> void:
	_draw_props_on(_props, false)

## วาดกระดาน ตู้จดหมาย ประตูดันเจี้ยน ทางวาป  on_planet วาดบนดาวพื้นโค้ง (พิกัดจอ หมุนตามผิว)
func _draw_props_on(c: CanvasItem, on_planet: bool) -> void:
	for it in interactables():
		if it["kind"] == "npc":
			continue
		var x: float = float(it["x"]) * CombatData.UNIT
		var kind: String = it["warp"] if it["kind"] == "warp" else it["kind"]
		if on_planet:
			var a := x * ZOOM / PLANET_R
			c.draw_set_transform(Vector2(sin(a), -cos(a)) * PLANET_R, a, Vector2.ONE * ZOOM)
			TownScene.prop(c, kind, Vector2.ZERO, _prop_label(it) if _is_near(it) else "", pal("accent"), bool(it.get("up", true)))
			c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			TownScene.prop(c, kind, Vector2(x, -4.0 - ground_h(float(it["x"])) * CombatData.UNIT), _prop_label(it) if _is_near(it) else "", pal("accent"), bool(it.get("up", true)))
	# จดหมายใหม่ ขึ้นเลขบนตู้
	var mb: Dictionary = _town.get("mailbox", {})
	if _mail_count > 0 and not mb.is_empty() and int(mb.get("floor", 0)) == _floor:
		var mx := float(mb.get("x", 0.0)) * CombatData.UNIT
		if on_planet:
			var ma := mx * ZOOM / PLANET_R
			c.draw_set_transform(Vector2(sin(ma), -cos(ma)) * PLANET_R, ma, Vector2.ONE * ZOOM)
			mx = 0.0
		var at := Vector2(mx + 40.0, -190.0 - (ground_h(float(mb.get("x", 0.0))) * CombatData.UNIT if not on_planet else 0.0))
		c.draw_circle(at, 22.0, Color(0.9, 0.25, 0.25))
		c.draw_string(Sketch.font(), at + Vector2(-7.0, 10.0), str(_mail_count), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 28, Color.WHITE)
		c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _tick_town(delta: float) -> void:
	_warm_wait += delta
	if _warping or dialog == null or dialog.visible:
		return
	# หาของที่ใกล้ที่สุด
	var best := {}
	var best_d := NEAR
	for it in interactables():
		var d := absf(hero.pos.x - float(it["x"]))
		if d < best_d:
			best_d = d
			best = it
	if str(best.get("kind", "")) != str(_near.get("kind", "")) or float(best.get("x", 0.0)) != float(_near.get("x", 0.0)):
		_near = best
		_ui.queue_redraw()
		# ป้ายชื่อขึ้นเฉพาะของที่อยู่ใกล้ วาดใหม่ตอนของใกล้เปลี่ยน
		if _props != null:
			_props.queue_redraw()
		if _planet != null:
			_planet.queue_redraw()
	# เช็กเควสที่ NPC ให้ได้ กับจดหมายใหม่ ทุก 1.5 วิ
	_poll -= delta
	if _poll <= 0.0:
		_poll = 1.5
		_refresh_marks()

func _refresh_marks() -> void:
	var entry := roster_entry()
	if DialogBox.quest_has("talk"):
		for n in _npcs:
			if not is_instance_valid(n):
				continue
			var r = DialogBox.qcall("talk", [str(n.data.get("id", "")), entry])
			n.talk_mark = r is Dictionary and (str(r.get("offer", "")) != "" or str(r.get("turn_in", "")) != "")
	var count := 0
	if DialogBox.quest_has("mail") and not entry.is_empty():
		var box = DialogBox.qcall("mail", [entry])
		if box is Array:
			for m in box:
				if m is Dictionary and not bool(m.get("read", false)):
					count += 1
	if count != _mail_count:
		_mail_count = count
		_props.queue_redraw()
		if _planet != null:
			_planet.queue_redraw()

## ปุ่มกดใช้ของที่อยู่ใกล้ กลางจอด้านล่าง
func action_rect() -> Rect2:
	return Rect2(Vector2(_view.x * 0.5 - 170.0, _view.y - 118.0), Vector2(340.0, 84.0))

func _action_label(it: Dictionary) -> String:
	match str(it.get("kind", "")):
		"npc":
			return "คุยกับ " + str(it["npc"].data.get("name", ""))
		"board":
			return "ดูกระดานเควส"
		"mailbox":
			return "เปิดตู้จดหมาย" + (" (%d)" % _mail_count if _mail_count > 0 else "")
		"gate":
			return "เข้าดันเจี้ยน"
		"warp":
			return ("ขึ้นไป " if bool(it["up"]) else "ลงไป ") + _prop_label(it)
	return ""

func _draw_action() -> void:
	if _near.is_empty() or dialog == null or dialog.visible:
		return
	var r := action_rect()
	UiStyle.box(_ui, r, 705, UiStyle.LINE_BOLD, UiStyle.INK, UiStyle.PICKED)
	UiStyle.paw(_ui, r.position + Vector2(30.0, r.size.y * 0.5), 12.0)
	UiStyle.text(_ui, r.get_center() + Vector2(14.0, 0.0), _action_label(_near), 28, UiStyle.INK, r.size.x - 70.0)

func _act(it: Dictionary) -> void:
	pad.reset()
	match str(it.get("kind", "")):
		"npc":
			_talk(it["npc"].data)
		"board":
			if quests.has_method("open_board"):
				quests.call("open_board", current_town)
			else:
				quests.open()
			pad.visible = false
			_ui.visible = false
		"mailbox":
			Snd.play("mail", -3.0)
			if quests.has_method("open_mail"):
				quests.call("open_mail")
			else:
				quests.open()
			pad.visible = false
			_ui.visible = false
		"gate":
			Snd.play("door", -3.0)
			open_map()
		"warp":
			Snd.play("warp", -4.0)
			warp_to(int(it["to"]), float(it["to_x"]), bool(it["up"]))

func _talk(data: Dictionary) -> void:
	pad.reset()
	joy.release()
	pad.visible = false
	_ui.visible = false
	dialog.open(data)
	_poll = 0.0

## NPC ที่ถูกแตะบนจอ
func _npc_at(at: Vector2) -> TownNpc:
	for n in _npcs:
		if not is_instance_valid(n):
			continue
		var c: Vector2 = (n as Node2D).get_global_transform_with_canvas().origin
		if Rect2(c + Vector2(-60.0, -150.0), Vector2(120.0, 160.0)).has_point(at):
			return n
	return null

## ชั้นใหม่อาจเป็นในบ้าน/สวน เปลี่ยนชนิดสัตว์ตัวเล็กตาม
func _rebuild_critters() -> void:
	var old = get_meta("critters", null)
	if old is Node and is_instance_valid(old):
		(old as Node).queue_free()
	if style == "curve":
		return
	var critters := AmbientCritters.new()
	critters.page = self
	critters.kind = AmbientCritters.kind_for(self)
	world.add_child(critters)
	world.move_child(critters, 0)
	set_meta("critters", critters)

## วาปไปชั้นอื่น วงกลมหดรอบตัวละคร ฉากเลื่อนขึ้นหรือลง แล้วสร้างชั้นใหม่
func warp_to(to: int, to_x: float, up: bool) -> void:
	if _warping or to < 0 or to >= floors().size():
		return
	_warping = true
	_near = {}
	_ui.queue_redraw()
	var dir := 1.0 if up else -1.0
	var base_y := _view.y * GROUND_AT
	var tw := create_tween()
	tw.tween_method(func(k: float) -> void:
		IrisFx.set_amount(k)
		world.position.y = base_y + dir * 120.0 * k, 0.0, 1.0, 0.3)
	tw.tween_callback(func() -> void:
		_floor = to
		_build_floor()
		hero.pos.x = clampf(to_x, -town_half, town_half)
		hero.pos.y = ground_h(hero.pos.x)
		hero.vel = Vector2.ZERO
		_follow(0.0))
	tw.tween_method(func(k: float) -> void:
		IrisFx.set_amount(1.0 - k)
		world.position.y = base_y - dir * 120.0 * (1.0 - k), 0.0, 1.0, 0.3)
	tw.tween_callback(func() -> void:
		world.position.y = base_y
		IrisFx.set_amount(0.0)
		_rebuild_critters()
		_warping = false)
