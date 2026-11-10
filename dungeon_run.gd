class_name DungeonRun
extends Node2D
## คุมการเล่นดันเจี้ยนในหน้าต่อสู้ ปล่อยลูกน้องแมวทีละคลื่น ตามด้วยบอส ชนะแล้วบันทึกว่าผ่าน แพ้หรือชนะกลับเมือง
## วาดชื่อดันเจี้ยน คลื่นที่เท่าไร และป้ายผลตอนจบ

const WAVE_GAP := 1.2
const END_WAIT := 2.6
const TITLE_SIZE := 30
const BANNER_SIZE := 72

var page: WalkPage
var town := 0
var index := 0
var data: Dictionary = {}
var wave := -1                    # คลื่นที่เล่นอยู่ คลื่นสุดท้าย +1 คือบอส
var alive := 0
var result := ""                  # win lose
var _next_t := 0.6
var _end_t := 0.0
var _flash := ""
var _flash_t := 0.0

func _ready() -> void:
	z_index = 60
	data = DungeonData.dungeon(town, index)

func waves() -> int:
	return (data.get("waves", []) as Array).size()

func _spawn(look: String, boss: bool, slot: int) -> void:
	var m := Monster.new()
	m.role = "boss" if boss else "hopper"
	m.look = look
	var side := 1.0 if slot % 3 != 2 else -1.0
	var x := page.hero.pos.x + side * (4.0 + float(slot) * 1.3)
	if boss:
		x = page.hero.pos.x + (5.0 if page.hero.pos.x < page.hero.half_width - 6.0 else -5.0)
		m.body_radius = 1.0
	m.pos = Vector2(clampf(x, -page.hero.half_width + 0.5, page.hero.half_width - 0.5), 0.0)
	m.max_hp = float(Monster.ROLES[m.role]["hp"]) * DungeonData.hp_scale(town, index)
	m.hp = m.max_hp
	m.half_width = page.hero.half_width
	m.hero = page.hero
	m.ai_cool = randf_range(0.4, 1.2)
	m.died.connect(_on_died)
	m.slammed.connect(func(_b: Monster) -> void: page.shake_left = maxf(page.shake_left, 0.45))
	page.world.add_child(m)
	alive += 1

func _start_wave() -> void:
	wave += 1
	if wave < waves():
		var list: Array = data["waves"][wave]
		for i in list.size():
			_spawn(str(list[i]), false, i)
		_flash = "คลื่นที่ %d / %d" % [wave + 1, waves()]
	else:
		_spawn(str(data.get("boss", "boss_club")), true, 0)
		_flash = "บอส  " + CatLook.name_of(str(data.get("boss", "")), town)
	_flash_t = 1.6

func _on_died(_m: Monster) -> void:
	alive = maxi(alive - 1, 0)
	if alive == 0 and result == "":
		if wave >= waves():
			_finish("win")
		else:
			_next_t = WAVE_GAP

func _finish(how: String) -> void:
	result = how
	_end_t = END_WAIT
	if how == "win":
		SaveData.mark_cleared(town, index)

func _process(delta: float) -> void:
	_flash_t = maxf(_flash_t - delta, 0.0)
	if result != "":
		_end_t -= delta
		if _end_t <= 0.0:
			set_process(false)
			IrisFx.go("res://town.tscn")
		queue_redraw()
		return
	if page.hero.hp <= 0.0:
		_finish("lose")
		return
	if alive == 0 and wave <= waves():
		_next_t -= delta
		if _next_t <= 0.0:
			_start_wave()
	queue_redraw()

func _text(at: Vector2, word: String, size: int, color: Color) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
	draw_string_outline(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, 8, Color.WHITE)
	draw_string(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _draw() -> void:
	var view := get_viewport_rect().size
	_text(Vector2(view.x * 0.5, 34.0), str(data.get("name", "")), TITLE_SIZE, Sketch.INK)
	var stage := "บอส" if wave >= waves() else "คลื่น %d / %d" % [maxi(wave + 1, 1), waves()]
	_text(Vector2(view.x * 0.5, 72.0), stage, 22, Sketch.INK)
	if _flash_t > 0.0 and result == "":
		_text(Vector2(view.x * 0.5, view.y * 0.32), _flash, 48, Color(0.74, 0.42, 0.4, minf(_flash_t * 2.0, 1.0)))
	if result == "win":
		_text(Vector2(view.x * 0.5, view.y * 0.36), "ผ่านดันเจี้ยน!", BANNER_SIZE, Color(0.82, 0.6, 0.35))
	elif result == "lose":
		_text(Vector2(view.x * 0.5, view.y * 0.36), "พ่ายแพ้...", BANNER_SIZE, Color(0.4, 0.4, 0.5))
