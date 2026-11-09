class_name DungeonPage
extends WalkPage
## ดันเจี้ยนแบบเกมแอ็กชันเลื่อนข้าง ใช้หน้าเดียวกับห้องฝึก (ปุ่ม กล้อง การต่อสู้เหมือนกัน)
## แบ่งเป็นห้อง (วอร์มอัพ ต่อสู้หลัก กับดัก มินิบอส บอส) เข้าห้องแล้วถอยไม่ได้ ต้องเคลียร์มอนทั้งห้องประตูถัดไปถึงเปิด
## บางห้องมอนมาเป็นระลอก ระลอกสองตกลงมาจากฟ้า มีแท่นลอยสองชั้นให้กระโดด มีหนามพุ่งเป็นจังหวะ
## มอนแบ่งบทบาท ตัวยิงไกล แทงค์เกราะ ซัพพอร์ตฮีล ตัวพุ่งชน  บอสมีเฟส 2 และท่าใหญ่ทั้งลานที่ต้องกระโดดหลบ
## ฉากหลังแต่ละดันไม่ซ้ำกัน (ทุ่ง ป่า ซากป้อม หอคอย ลานประลอง) วาดเบลอนุ่มทั้งหมด

const STAGE_HALF := 22.0          # ห้องปกติกว้างข้างละเท่านี้ หน่วยเกม
const BOSS_HALF := 20.0           # ลานบอสกว้าง
const SPIKE_W := 1.3              # หนามกว้างข้างละ
const MOB_SHOT_SPEED := 520.0
const AGGRO := 7.5                # มอนเห็นตัวละครในระยะนี้แล้วถึงไล่
const END_WAIT := 2.6
const INK := Color(0.2, 0.17, 0.15)

static var stage := 0             # ห้องที่เล่นอยู่ ห้องสุดท้ายคือลานบอส

var data: Dictionary = {}
var half := STAGE_HALF
var cam := 0.0
var alive := 0
var total := 0
var result := ""
var _end_t := 0.0
var _layers: Array = []
var _rng := RandomNumberGenerator.new()
var _hud: Node2D
var _gate: Node2D
var _flash := ""
var _flash_t := 0.0
var room_data: Dictionary = {}
var wave := 0
var boss: Monster
var _spikes: Node2D
var _spike_t := 0.0
var _spike_hit := false
var _mob_shots: Array = []            # ลูกยิงของมอน [โหนด ความเร็ว]
var _ult_warn := 0.0
var _plats: Node2D

func is_dungeon() -> bool:
	return true

func is_boss_stage() -> bool:
	return stage >= DungeonData.stage_count(dungeon_town, dungeon_index) - 1

func _home_x() -> float:
	return _view.x * 0.5 - cam

func _ready() -> void:
	data = DungeonData.dungeon(dungeon_town, dungeon_index)
	super._ready()
	_rng.seed = 400 + dungeon_index * 10 + stage
	var list := DungeonData.rooms(dungeon_town, dungeon_index)
	room_data = list[clampi(stage, 0, list.size() - 1)]
	# ห้องยาวตามข้อมูลห้อง (เมืองแรกยาวสุด) ลานบอสกว้างคงที่
	half = BOSS_HALF if is_boss_stage() else float(room_data.get("half", STAGE_HALF))
	hero.half_width = half
	hero.pos.x = -half + 2.0
	Hero.platforms = room_data.get("platforms", []).duplicate()
	var theme := str(data.get("theme", "meadow"))
	var painters := [[0.0, _paint_sky.bind(theme)], [PAR_FAR, _paint_far.bind(theme)], [PAR_MID, _paint_mid.bind(theme)], [1.0, _paint_ground.bind(theme)]]
	for i in painters.size():
		var node := _layer(float(painters[i][0]), painters[i][1])
		move_child(node, i)
	# ชั้นหน้าสุด พุ่มไม้ ก้อนหิน สาหร่าย กระดาษตัดชิดขอบล่างจอ เลื่อนเร็วกว่าพื้น (ฉากในอาคารไม่มี)
	var tkind := ForeTufts.kind_for_theme(theme)
	if tkind != "":
		var tufts := _layer(ForeTufts.FACTOR, func(c: Node2D) -> void: ForeTufts.paint(c, tkind, _span(ForeTufts.FACTOR), _view.y, _rng))
		move_child(tufts, world.get_index() + 1)
	# ฉากพิเศษที่ขยับได้ (รถไฟวิ่ง ใต้ทะเล ฯลฯ) วาดทุกเฟรม อยู่หน้าฉากกลาง หลังพื้น
	Hero.gravity_k = DungeonLook.gravity_k(theme)
	if DungeonLook.has_anim(theme):
		_anim_layer = Node2D.new()
		_anim_layer.draw.connect(func() -> void: DungeonLook.anim(_anim_layer, theme, _anim_t, _view, _ground_y(), cam))
		add_child(_anim_layer)
		move_child(_anim_layer, 3)
	var haze := Node2D.new()
	haze.draw.connect(func() -> void: haze.draw_rect(Rect2(Vector2.ZERO, _view), _haze_color(theme)))
	add_child(haze)
	move_child(haze, painters.size())
	_gate = Node2D.new()
	_gate.draw.connect(_draw_gate)
	world.add_child(_gate)
	world.move_child(_gate, 0)
	_gate.position = Vector2((half - 1.6) * CombatData.UNIT, 0.0)
	_gate.visible = not is_boss_stage()
	# แท่นลอยกับหนาม วาดในโลก
	_plats = Node2D.new()
	_plats.draw.connect(_draw_platforms.bind(theme))
	world.add_child(_plats)
	world.move_child(_plats, 0)
	_spikes = Node2D.new()
	_spikes.draw.connect(_draw_spikes)
	world.add_child(_spikes)
	_hud = Node2D.new()
	_hud.z_index = 60
	_hud.draw.connect(_draw_hud)
	add_child(_hud)
	_spawn_stage.call_deferred()
	_follow(0.0)

var _anim_layer: Node2D
var _anim_t := 0.0

func _exit_tree() -> void:
	Hero.gravity_k = 1.0

func _layer(factor: float, painter: Callable) -> Node2D:
	var node := Node2D.new()
	var seed_no := 2000 + dungeon_index * 50 + stage * 7 + _layers.size()
	node.draw.connect(func() -> void:
		_rng.seed = seed_no
		painter.call(node))
	add_child(node)
	_layers.append([node, factor])
	return node

# ---------------------------------------------------------------- มอน
func _spawn(role: String, look: String, x: float, plat_i: int, drop: bool) -> Monster:
	var rd := DungeonData.raid(dungeon_town, dungeon_index) if role == "boss_raid" else {}
	var m: Monster = RaidBoss.new() if role == "boss_raid" else Monster.new()
	m.role = role
	m.look = look
	var spec: Dictionary = Monster.ROLES[role]
	m.pos = Vector2(clampf(x, -half + 0.5, half - 0.5), 0.0)
	var plats: Array = room_data.get("platforms", [])
	if plat_i >= 0 and plat_i < plats.size():
		var p: Array = plats[plat_i]
		m.floor_h = float(p[2])
		m.plat = Vector2(float(p[0]) + 0.3, float(p[1]) - 0.3)
		m.pos = Vector2((float(p[0]) + float(p[1])) * 0.5, m.floor_h)
	if drop:
		# ระลอกสองตกลงมาจากฟ้า
		m.pos.y = m.floor_h + 9.0
	var boss_like := role.begins_with("boss_") or role == "midboss"
	var hp_now := float(spec["hp"]) * DungeonData.hp_scale(dungeon_town, dungeon_index) * (0.6 if room_data.get("type", "") == "warm" else 1.0)
	m.half_width = half
	m.hero = hero
	# ห้องยาว มอนกระจาย ไล่เฉพาะตอนตัวละครเข้าใกล้ ตัวยิง/พุ่ง/ซัพพอร์ตเห็นไกลกว่า
	m.aggro = 0.0 if boss_like else (AGGRO * 1.6 if role in ["ranged", "rusher", "support"] else AGGRO)
	m.ai_face = -1.0
	m.ai_cool = _rng.randf_range(0.3, 1.5)
	# เมืองแรกๆ ตีเบาลง บอสออกท่าช้าลง
	m.easy_dmg = DungeonData.early_dmg(dungeon_town)
	if boss_like:
		m.easy_slow = DungeonData.early_boss_slow(dungeon_town)
	if role == "boss_raid":
		# บอสยักษ์ ตั้งค่าตามเมือง ตำแหน่งยืนชิดขวาหรือกลางลาน
		var rb := m as RaidBoss
		rb.page = self
		rb.town = dungeon_town
		rb.anchor = str(rd.get("anchor", "right"))
		rb.phases = int(rd.get("phases", 2))
		rb.giant = float(rd.get("giant", 3.6))
		rb.dmg_k = float(rd.get("dmg_k", 1.0))
		rb.speed_k = float(rd.get("speed_k", 1.0))
		rb.body_half = 1.3 * rb.giant
		rb.anchor_x = (half - rb.body_half - 1.0) if rb.anchor == "right" else 0.0
		hp_now *= float(rd.get("hp_mult", 3.0))
		m.body_radius = 0.5
	elif boss_like:
		m.body_radius = 1.0
		m.scale = Vector2.ONE * float(spec.get("size", 1.0))
	if boss_like:
		m.slammed.connect(func(_b: Monster) -> void: shake_left = maxf(shake_left, 0.45))
		m.shockwave.connect(_boss_wave)
		m.vanished.connect(_boss_poof)
		m.phase_two.connect(_boss_phase)
		m.ult_warn.connect(func(_b: Monster) -> void: _ult_warn = 1.6)
		m.ult_hit.connect(_boss_ult)
		if role.begins_with("boss_"):
			boss = m
	m.shoot.connect(_monster_shoot)
	m.healed.connect(func(_a: Monster, _b: Monster) -> void: pass)
	m.died.connect(_on_died)
	world.add_child(m)
	# ตั้งเลือดหลังเข้าฉาก เพราะมอนตั้งเลือดตามบทบาทเองตอนเริ่ม
	m.max_hp = hp_now
	m.hp = hp_now
	alive += 1
	return m

func _spawn_mob_wave() -> void:
	var waves: Array = room_data.get("waves", [])
	if wave >= waves.size():
		return
	for e in waves[wave]:
		_spawn(str(e[0]), str(e[1]), float(e[2]), int(e[3]), wave > 0)
	if wave > 0:
		_flash = "ระลอก %d" % (wave + 1)
		_flash_t = 1.5
		shake_left = maxf(shake_left, 0.3)

func _spawn_stage() -> void:
	total = DungeonData.stage_monsters(dungeon_town, dungeon_index, stage).size()
	wave = 0
	_spawn_mob_wave()
	var names := {"warm": "ห้องวอร์มอัพ", "core": "ห้องต่อสู้", "trap": "ห้องกับดัก", "mid": "มินิบอส", "boss": "บอส  " + (CatLook.raid_name(str(data.get("boss", "")), dungeon_town) if not DungeonData.raid(dungeon_town, dungeon_index).is_empty() else CatLook.name_of(str(data.get("boss", "")), dungeon_town))}
	_flash = "ห้อง %d / %d  %s" % [stage + 1, DungeonData.stage_count(dungeon_town, dungeon_index), names.get(room_data.get("type", ""), "")]
	_flash_t = 2.0

func _on_died(m: Monster) -> void:
	alive = maxi(alive - 1, 0)
	# ได้ EXP ขึ้นเลขเหนือมอน นับให้เควส
	var dl := DungeonData.dungeon_level(dungeon_town, dungeon_index)
	var got := LevelData.monster_exp(m.role, dl, chosen_level)
	m._numbers.append({"text": "+%d EXP" % got, "t": -0.25, "x": 0.0})
	gain_exp(got)
	quest_count(dungeon_town, 1, -1, m.look if m.look != "" else m.role)
	if alive == 0 and result == "":
		# ระลอกต่อไปยังมี ตกลงมาจากฟ้า
		if wave < (room_data.get("waves", []) as Array).size() - 1:
			wave += 1
			_spawn_mob_wave.call_deferred()
			return
		if is_boss_stage():
			result = "win"
			_end_t = END_WAIT
			SaveData.mark_cleared(dungeon_town, dungeon_index)
			gain_exp(LevelData.clear_exp(DungeonData.dungeon_level(dungeon_town, dungeon_index), chosen_level))
			quest_count(dungeon_town, 0, dungeon_index)
		else:
			_flash = "ประตูเปิดแล้ว ไปทางขวา"
			_flash_t = 2.5
		_gate.queue_redraw()

## บอสค้อนทุบพื้น คลื่นวิ่งตามพื้นไปหาตัวละคร
func _boss_wave(boss: Monster, dir: float) -> void:
	shake_left = maxf(shake_left, 0.4)
	var w := GroundWave.new()
	w.dir = dir
	w.hero = hero
	w.dmg = float(Monster.ROLES[boss.role].get("wave_dmg", 12.0))
	w.position = Vector2(boss.position.x + dir * 120.0, 0.0)
	world.add_child(w)

func _boss_poof(_boss: Monster, from: Vector2) -> void:
	for at in [from, _boss.position]:
		var p := MageFx.Poof.new()
		p.position = at
		world.add_child(p)

## ตัวยิงไกลยิงลูกขนแมวใส่ตัวละคร
func _monster_shoot(m: Monster) -> void:
	var from := m.position + Vector2(m.ai_face * 40.0, -60.0)
	var to := hero.position + Vector2(0.0, -50.0)
	var shot := HairBall.new()
	shot.position = from
	world.add_child(shot)
	_mob_shots.append([shot, (to - from).normalized() * MOB_SHOT_SPEED, float(Monster.ROLES[m.role].get("shot_dmg", 6.0)) * m.easy_dmg])

## บอสยักษ์ทุบพื้น คลื่นวิ่งตามพื้นไปทางตัวละคร กระโดดข้าม
func _raid_wave(_b: Monster, x: float, dir: float, dmg: float) -> void:
	var w := GroundWave.new()
	w.dir = dir
	w.hero = hero
	w.dmg = dmg
	w.position = Vector2(x * CombatData.UNIT, 0.0)
	world.add_child(w)

## บอสยักษ์เรียกลูกน้องตามธีมเมือง ตกลงมาจากฟ้า
func _raid_summon(b: Monster, count: int) -> void:
	var fod: String = DungeonData.FODDER[dungeon_index % DungeonData.FODDER.size()]
	for i in count:
		var x := clampf(hero.pos.x + _rng.randf_range(-6.0, 6.0), -half + 1.0, half - 1.0)
		if absf(x - b.pos.x) < 2.0:
			x = b.pos.x - 3.0
		_spawn("hopper", fod, x, -1, true)
	_flash = "บอสเรียกลูกน้อง!"
	_flash_t = 1.4

## บอสเข้าเฟส 2 บางตัวเรียกลูกน้องมาช่วย
func _boss_phase(b: Monster) -> void:
	_flash = "บอสโกรธแล้ว!"
	_flash_t = 2.0
	shake_left = maxf(shake_left, 0.5)
	if b.role in ["boss_club", "boss_king"]:
		var fod: String = DungeonData.FODDER[dungeon_index % DungeonData.FODDER.size()]
		for side in [-1.0, 1.0]:
			_spawn("hopper", fod, b.pos.x + side * 4.0, -1, true)

## ท่าใหญ่ทั้งลาน คนที่ยืนบนพื้นโดนหมด อยู่บนแท่นหรือลอยกลางอากาศหลบได้
func _boss_ult(b: Monster) -> void:
	_ult_warn = 0.0
	shake_left = maxf(shake_left, 0.8)
	var w := GroundWave.new()
	w.full = true
	w.hero = hero
	w.dmg = 30.0 * b.easy_dmg
	w.position = Vector2(b.position.x, 0.0)
	world.add_child(w)
	if hero.pos.y < 0.3:
		hero.take_damage(30.0 * b.easy_dmg, signf(hero.pos.x - b.pos.x), "ult")

## ลูกขนแมวที่ตัวยิงไกลยิง
class HairBall extends Node2D:
	var _t := 0.0
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _draw() -> void:
		draw_circle(Vector2.ZERO, 16.0, Color(0.85, 0.6, 0.95, 0.35))
		draw_circle(Vector2.ZERO, 11.0, Color(0.7, 0.45, 0.85))
		for i in 3:
			draw_arc(Vector2.ZERO, 4.0 + float(i) * 3.0, _t * 6.0 + float(i), _t * 6.0 + float(i) + 2.2, 8, Color(1.0, 0.85, 1.0), 1.6, true)

## คลื่นพื้นของบอสค้อน วิ่งตามพื้น โดนตัวละครครั้งเดียว
class GroundWave extends Node2D:
	var dir := 1.0
	var hero: Hero
	var dmg := 12.0
	var full := false              # ท่าใหญ่ทั้งลาน วงกระแทกแผ่ไปทั้งลาน
	var _t := 0.0
	var _hit := false
	func _process(delta: float) -> void:
		_t += delta
		if full:
			if _t > 0.8:
				queue_free()
			queue_redraw()
			return
		position.x += dir * 700.0 * delta
		if not _hit and is_instance_valid(hero) and absf(hero.position.x - position.x) < 70.0 and hero.pos.y < 1.2:
			_hit = true
			hero.take_damage(dmg, dir, "ranged")
		if _t > 1.6:
			queue_free()
		queue_redraw()
	func _draw() -> void:
		if full:
			var k := _t / 0.8
			draw_rect(Rect2(-3000.0, -40.0 * (1.0 - k), 6000.0, 40.0 * (1.0 - k) + 6.0), Color(1.0, 0.4, 0.3, 0.6 * (1.0 - k)))
			for i in 30:
				var x := -2400.0 + float(i) * 160.0
				draw_colored_polygon(PackedVector2Array([Vector2(x - 30.0, 0.0), Vector2(x, -120.0 * (1.0 - k)), Vector2(x + 30.0, 0.0)]), Color(0.9, 0.5, 0.35, 0.8 * (1.0 - k)))
			return
		var f := 1.0 - clampf((_t - 1.2) / 0.4, 0.0, 1.0)
		for i in 3:
			var x := -dir * float(i) * 40.0
			draw_colored_polygon(PackedVector2Array([Vector2(x - 40.0, 0.0), Vector2(x, -90.0 + float(i) * 22.0), Vector2(x + 40.0, 0.0)]), Color(0.75, 0.6, 0.45, 0.8 * f))
		draw_rect(Rect2(-60.0, -6.0, 120.0, 8.0), Color(0.5, 0.38, 0.28, 0.6 * f))

# ---------------------------------------------------------------- กล้อง ประตู ผลลัพธ์
## เปิดหน้าสกิล คอมโบ หรือตั้งค่าอยู่ เวลาในดันเจี้ยนหยุด
func ui_paused() -> bool:
	return result == "" and (settings_open() or (combo_panel != null and combo_panel.visible) or (panel != null and panel.visible))

func _physics_process(delta: float) -> void:
	var stop := ui_paused()
	world.process_mode = Node.PROCESS_MODE_DISABLED if stop else Node.PROCESS_MODE_INHERIT
	if stop:
		return
	super._physics_process(delta)

func _process(delta: float) -> void:
	if ui_paused():
		return
	super._process(delta)
	_follow(delta)
	_flash_t = maxf(_flash_t - delta, 0.0)
	_ult_warn = maxf(_ult_warn - delta, 0.0)
	_tick_mob_shots(delta)
	_tick_spikes(delta)
	if _anim_layer != null:
		_anim_t += delta
		_anim_layer.queue_redraw()
	if result != "":
		_end_t -= delta
		if _end_t <= 0.0:
			set_process(false)
			stage = 0
			get_tree().change_scene_to_file("res://town.tscn")
	elif hero.hp <= 0.0:
		result = "lose"
		_end_t = END_WAIT
	elif not is_boss_stage() and alive == 0 and total > 0 and wave >= (room_data.get("waves", []) as Array).size() - 1 and hero.pos.x > half - 3.0:
		# เข้าประตูไปด่านต่อไป
		stage += 1
		set_process(false)
		get_tree().change_scene_to_file("res://dungeon.tscn")
	_hud.queue_redraw()

func _tick_mob_shots(delta: float) -> void:
	for sh in _mob_shots.duplicate():
		var node := sh[0] as Node2D
		if not is_instance_valid(node):
			_mob_shots.erase(sh)
			continue
		node.position += (sh[1] as Vector2) * delta
		if node.position.distance_to(hero.position + Vector2(0.0, -50.0)) < 50.0:
			hero.take_damage(float(sh[2]), signf((sh[1] as Vector2).x), "ranged")
			node.queue_free()
			_mob_shots.erase(sh)
		elif node.position.y > 10.0 or absf(node.position.x - hero.position.x) > 2500.0:
			node.queue_free()
			_mob_shots.erase(sh)

## หนามพุ่งเป็นจังหวะ เตือน 0.7 วิ พุ่ง 0.8 วิ หด 1.6 วิ โดนตัวละครที่ยืนบนพื้นตรงนั้น
func _tick_spikes(delta: float) -> void:
	if (room_data.get("spikes", []) as Array).is_empty():
		return
	_spike_t = fposmod(_spike_t + delta, 3.1)
	var up := _spike_t >= 0.7 and _spike_t < 1.5
	if not up:
		_spike_hit = false
	elif not _spike_hit and hero.pos.y < 0.4:
		for x in room_data["spikes"]:
			if absf(hero.pos.x - float(x)) < SPIKE_W:
				_spike_hit = true
				hero.take_damage(12.0, signf(hero.pos.x - float(x)) if hero.pos.x != float(x) else 1.0, "trap")
				break
	_spikes.queue_redraw()

func _draw_spikes() -> void:
	var warn := _spike_t < 0.7
	var up := _spike_t >= 0.7 and _spike_t < 1.5
	for x in room_data.get("spikes", []):
		var cx := float(x) * CombatData.UNIT
		var w := SPIKE_W * CombatData.UNIT
		# กับดักเล็บแมวโผล่จากพื้น ทรงมนปลายกลม ไม่แหลม
		UiStyle.fill(_spikes, Rect2(cx - w, -10.0, w * 2.0, 12.0), Color(0.5, 0.44, 0.46), 6.0)
		var h := 110.0 if up else (14.0 if warn else 6.0)
		if warn:
			UiStyle.fill(_spikes, Rect2(cx - w, -16.0, w * 2.0, 16.0), Color(1.0, 0.45, 0.5, 0.25 + 0.25 * sin(_spike_t * 20.0)), 8.0)
		for i in 6:
			var sx := cx - w + w * 2.0 * (float(i) + 0.5) / 6.0
			var tip := Vector2(sx + 6.0, -6.0 - h)
			_spikes.draw_colored_polygon(PackedVector2Array([Vector2(sx - 13.0, -6.0), Vector2(sx - 9.0, -6.0 - h * 0.6), tip + Vector2(-6.0, 4.0), tip + Vector2(6.0, 6.0), Vector2(sx + 13.0, -6.0)]), Color(1.0, 0.95, 0.97))
			_spikes.draw_circle(tip + Vector2(0.0, 6.0), 7.0, Color(1.0, 0.95, 0.97))
			_spikes.draw_polyline(PackedVector2Array([Vector2(sx - 13.0, -6.0), Vector2(sx - 9.0, -6.0 - h * 0.6), tip + Vector2(-6.0, 4.0)]), Color(PaperFront.INK, 0.5), 2.0, true)

## แท่นลอย แผ่นหินหรือไม้ตามธีม ขอบนุ่ม มีเงาใต้แท่น
func _draw_platforms(theme: String) -> void:
	var col := {"meadow": Color(0.62, 0.5, 0.36), "forest": Color(0.5, 0.4, 0.3), "ruins": Color(0.85, 0.68, 0.45), "tower": Color(0.5, 0.44, 0.6), "arena": Color(0.85, 0.78, 0.68)}.get(theme, Color(0.6, 0.5, 0.4)) as Color
	if DungeonLook.has(theme):
		col = DungeonLook.plat(theme)
	for p in room_data.get("platforms", []):
		var x0 := float(p[0]) * CombatData.UNIT
		var x1 := float(p[1]) * CombatData.UNIT
		var y := -float(p[2]) * CombatData.UNIT
		UiStyle.fill(_plats, Rect2(x0 + 10.0, y + 26.0, x1 - x0 - 20.0, 16.0), Color(0.0, 0.0, 0.0, 0.1), 8.0)
		UiStyle.fill(_plats, Rect2(x0, y, x1 - x0, 26.0), col, 12.0)
		UiStyle.fill(_plats, Rect2(x0 + 4.0, y + 2.0, x1 - x0 - 8.0, 7.0), col.lightened(0.3), 3.5)
		# ขอบกระดาษตัดมีเส้นหมึกบางๆ ให้เข้ากับพื้นหน้า
		UiStyle.frame(_plats, Rect2(x0, y, x1 - x0, 26.0), int(x0), 2.0, Color(PaperFront.INK, 0.6), 12.0)
		if theme in ["meadow", "forest"]:
			UiStyle.fill(_plats, Rect2(x0 - 4.0, y - 6.0, x1 - x0 + 8.0, 9.0), Color(0.45, 0.68, 0.38), 4.5)

func _follow(delta: float) -> void:
	var edge := maxf(half * CombatData.UNIT * ZOOM - _view.x * 0.5, 0.0)
	var want := clampf(hero.position.x * ZOOM, -edge, edge)
	cam = want if delta <= 0.0 else lerpf(cam, want, 1.0 - exp(-8.0 * delta))
	if hyper == null and shake_left <= 0.0:
		world.position.x = _home_x()
	for l in _layers:
		var f: float = l[1]
		(l[0] as Node2D).position.x = 0.0 if f <= 0.0 else _view.x * 0.5 - cam * f

## ปุ่มตั้งค่า > ย้อนกลับ ออกจากดันกลับเมือง
func go_back() -> void:
	stage = 0
	get_tree().change_scene_to_file("res://town.tscn")

## ประตูท้ายแมพ ซุ้มหินมีรอยอุ้งเท้า ปิดอยู่เป็นลูกกรง ตีมอนหมดแล้วเปิดเรืองแสง
func _draw_gate() -> void:
	var open := alive == 0 and total > 0 and wave >= (room_data.get("waves", []) as Array).size() - 1
	var w := 170.0
	var h := 300.0
	var stone := Color(0.78, 0.74, 0.7)
	_gate.draw_rect(Rect2(-w * 0.5 - 40.0, -h, 40.0, h), stone)
	_gate.draw_rect(Rect2(w * 0.5, -h, 40.0, h), stone)
	var arch := PackedVector2Array()
	for i in 21:
		var a := PI + PI * float(i) / 20.0
		arch.append(Vector2(cos(a) * (w * 0.5 + 40.0), -h + sin(a) * 70.0))
	arch.append(Vector2(w * 0.5 + 40.0, -h + 20.0))
	arch.append(Vector2(-w * 0.5 - 40.0, -h + 20.0))
	_gate.draw_colored_polygon(arch, stone.darkened(0.08))
	if open:
		_gate.draw_rect(Rect2(-w * 0.5, -h, w, h), Color(1.0, 0.95, 0.7, 0.85))
		_gate.draw_circle(Vector2(0.0, -h * 0.5), 80.0, Color(1.0, 1.0, 0.85, 0.5))
	else:
		_gate.draw_rect(Rect2(-w * 0.5, -h, w, h), Color(0.25, 0.22, 0.28, 0.8))
		for i in 5:
			var x := -w * 0.5 + w * (float(i) + 0.5) / 5.0
			_gate.draw_line(Vector2(x, -h), Vector2(x, 0.0), Color(0.55, 0.5, 0.45), 8.0)
	var p := Vector2(0.0, -h - 30.0)
	_gate.draw_circle(p, 18.0, Color(1.0, 0.8, 0.35))
	for i in 4:
		_gate.draw_circle(p + Vector2((float(i) - 1.5) * 13.0, -20.0 - (5.0 if i == 1 or i == 2 else 0.0)), 7.0, Color(1.0, 0.8, 0.35))

func _text(at: Vector2, word: String, size: int, color: Color) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
	_hud.draw_string_outline(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, 8, Color.WHITE)
	_hud.draw_string(font, at + Vector2(-w * 0.5, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _draw_hud() -> void:
	var cx := _view.x * 0.5 - 60.0
	_text(Vector2(cx, 32.0), str(data.get("name", "")), 28, INK)
	var stage_word := "ลานบอส" if is_boss_stage() else "ห้อง %d / %d   มอนเหลือ %d" % [stage + 1, DungeonData.stage_count(dungeon_town, dungeon_index), alive]
	_text(Vector2(cx, 66.0), stage_word, UiStyle.BODY, INK)
	# หลอดเลือดบอสหลายชั้น
	if is_instance_valid(boss) and boss.state != "dead":
		var raid := boss is RaidBoss
		var layers := 1 if raid else 3
		var per := boss.max_hp / float(layers)
		var left := maxf(boss.hp, 0.0)
		var layer := clampi(ceili(left / per), 1, layers)
		var k := (left - per * float(layer - 1)) / per
		var bar := Rect2(Vector2(_view.x * 0.5 - 360.0, _view.y * 0.2), Vector2(560.0, 24.0))
		var cols := [Color(0.95, 0.75, 0.25), Color(0.95, 0.5, 0.2), Color(0.9, 0.2, 0.25)]
		# หลอดมุมมน พื้นกระดาษ ขอบหมึก ตามกติกา UI เดียวกัน
		UiStyle.fill(_hud, bar.grow(4.0), Color(UiStyle.PAPER, 1.0), 14.0)
		UiStyle.fill(_hud, bar, cols[layer - 2] if layer >= 2 else Color(0.85, 0.82, 0.78), 10.0)
		if k > 0.02:
			UiStyle.fill(_hud, Rect2(bar.position, Vector2(bar.size.x * k, bar.size.y)), cols[layer - 1], 10.0)
		UiStyle.frame(_hud, bar.grow(4.0), 880, UiStyle.LINE, UiStyle.INK, 14.0)
		if raid:
			# บอสยักษ์ หลอดยาวเดียว มีขีดแบ่งเฟส บอกเฟสที่อยู่
			var rb := boss as RaidBoss
			for th in rb.thresholds():
				var mx := bar.position.x + bar.size.x * float(th)
				UiStyle.fill(_hud, Rect2(mx - 3.0, bar.position.y - 6.0, 6.0, bar.size.y + 12.0), UiStyle.INK, 3.0)
			_text(bar.position + Vector2(bar.size.x + 60.0, 12.0), "เฟส %d/%d" % [rb.phase_i + 1, rb.phases], 22, INK)
			_text(bar.position + Vector2(bar.size.x * 0.5, -18.0), CatLook.raid_name(str(boss.look), dungeon_town), 22, Color(0.75, 0.2, 0.2))
		else:
			_text(bar.position + Vector2(bar.size.x + 40.0, 12.0), "x%d" % layer, 26, INK)
			_text(bar.position + Vector2(bar.size.x * 0.5, -18.0), CatLook.name_of(str(boss.look), dungeon_town) + ("  (โกรธ)" if boss.phase == 2 else ""), 20, Color(0.75, 0.2, 0.2))
	if _ult_warn > 0.0:
		_text(Vector2(_view.x * 0.5, _view.y * 0.42), "ท่าใหญ่! กระโดดขึ้นแท่นหลบ!", 46, Color(0.9, 0.2, 0.2, 0.6 + 0.4 * sin(_ult_warn * 20.0)))
	if _flash_t > 0.0 and result == "":
		_text(Vector2(_view.x * 0.5, _view.y * 0.3), _flash, 44, Color(0.75, 0.2, 0.2, minf(_flash_t * 2.0, 1.0)))
	if result == "win":
		_text(Vector2(_view.x * 0.5, _view.y * 0.34), "ผ่านดันเจี้ยน!", 72, Color(0.85, 0.55, 0.1))
	elif result == "lose":
		_text(Vector2(_view.x * 0.5, _view.y * 0.34), "พ่ายแพ้...", 72, Color(0.4, 0.4, 0.5))

# ---------------------------------------------------------------- ฉากหลังแต่ละดัน วาดเบลอนุ่มทั้งหมด
func _ground_y() -> float:
	return _view.y * GROUND_AT

# ตัวคูณพารัลแลกซ์ ฉากไกลเลื่อนช้า ฉากกลางเร็วขึ้น ให้เห็นมิติลึกชัด
const PAR_FAR := 0.22
const PAR_MID := 0.55

func _span(factor: float) -> float:
	return half * CombatData.UNIT * ZOOM * factor + _view.x

func _haze_color(theme: String) -> Color:
	if DungeonLook.has(theme):
		return DungeonLook.haze(theme)
	match theme:
		"tower":
			return Color(0.6, 0.5, 0.75, 0.1)
		"forest":
			return Color(0.9, 1.0, 0.9, 0.18)
	return Color(1.0, 0.98, 0.95, 0.2)

func _soft(c: CanvasItem, pts: PackedVector2Array, color: Color) -> void:
	SoftPaint.shape(c, pts, color, 0.06)

func _blob(c: CanvasItem, at: Vector2, rx: float, ry: float, color: Color) -> void:
	SoftPaint.oval(c, at, rx, ry, color, 0.45)

func _paint_sky(c: Node2D, theme: String) -> void:
	# ฉากของเมืองอื่น วาดตามธีมเมืองใน DungeonLook
	if DungeonLook.has(theme):
		DungeonLook.sky(c, theme, _view, _ground_y(), _rng)
		return
	var top: Color
	var low: Color
	match theme:
		"forest":
			top = Color(0.62, 0.82, 0.78)
			low = Color(0.88, 0.95, 0.85)
		"ruins":
			top = Color(0.96, 0.72, 0.6)
			low = Color(1.0, 0.9, 0.75)
		"tower":
			# หอคอยโทนม่วงลาเวนเดอร์ยามเย็น สว่างกลางๆ ไม่มืดทึบ
			top = Color(0.62, 0.58, 0.8)
			low = Color(0.88, 0.82, 0.92)
		"arena":
			top = Color(0.6, 0.76, 0.95)
			low = Color(1.0, 0.92, 0.82)
		_:
			top = Color(0.6, 0.8, 0.96)
			low = Color(0.92, 0.96, 0.98)
	var g := _ground_y()
	for i in 14:
		var k := float(i) / 13.0
		c.draw_rect(Rect2(0.0, g * float(i) / 14.0, _view.x, g / 14.0 + 1.0), top.lerp(low, k))
	if theme == "tower":
		for i in 30:
			_blob(c, Vector2(_rng.randf_range(0.0, _view.x), _rng.randf_range(10.0, g * 0.6)), 3.0, 3.0, Color(1.0, 1.0, 0.9, 0.6))
		_blob(c, Vector2(_view.x * 0.75, g * 0.25), 50.0, 50.0, Color(1.0, 0.95, 0.85, 0.7))
	elif theme == "ruins":
		_blob(c, Vector2(_view.x * 0.3, g * 0.55), 90.0, 90.0, Color(1.0, 0.75, 0.5, 0.7))
	else:
		_blob(c, Vector2(_view.x * 0.8, g * 0.25), 60.0, 60.0, Color(1.0, 0.98, 0.85, 0.75))
		for i in 6:
			var cc := Vector2(_rng.randf_range(0.0, _view.x), g * _rng.randf_range(0.1, 0.45))
			for n in 3:
				_blob(c, cc + Vector2(float(n) * 40.0, _rng.randf_range(-8.0, 8.0)), 50.0, 22.0, Color(1.0, 1.0, 1.0, 0.65))

func _paint_far(c: Node2D, theme: String) -> void:
	if DungeonLook.has(theme):
		DungeonLook.far(c, theme, _ground_y(), _span(PAR_FAR), _rng)
		return
	var g := _ground_y()
	var span := _span(PAR_FAR)
	match theme:
		"meadow":
			# กำแพงเมืองไกลๆ กับเนินเขา
			var hills := PackedVector2Array([Vector2(-span, g)])
			var x := -span
			while x < span:
				hills.append(Vector2(x, g - _rng.randf_range(60.0, 130.0)))
				x += 180.0
			hills.append(Vector2(span, g))
			_soft(c, hills, Color(0.62, 0.78, 0.62, 0.6))
			_soft(c, PackedVector2Array([Vector2(-300.0, g - 60.0), Vector2(300.0, g - 60.0), Vector2(300.0, g - 140.0), Vector2(-300.0, g - 140.0)]), Color(0.85, 0.8, 0.72, 0.6))
			for t in [-260.0, -90.0, 90.0, 260.0]:
				_soft(c, PackedVector2Array([Vector2(t - 30.0, g - 60.0), Vector2(t + 30.0, g - 60.0), Vector2(t + 30.0, g - 200.0), Vector2(t - 30.0, g - 200.0)]), Color(0.85, 0.8, 0.72, 0.6))
				_blob(c, Vector2(t, g - 210.0), 40.0, 30.0, Color(0.9, 0.55, 0.45, 0.55))
		"forest":
			var x := -span
			while x < span:
				_blob(c, Vector2(x, g - 140.0), 90.0, 140.0, Color(0.4, 0.6, 0.48, 0.5))
				x += 110.0
		"ruins":
			var x := -span
			while x < span:
				var h := _rng.randf_range(80.0, 200.0)
				_soft(c, PackedVector2Array([Vector2(x, g), Vector2(x + 120.0, g), Vector2(x + 110.0, g - h), Vector2(x + 60.0, g - h - 30.0), Vector2(x + 10.0, g - h)]), Color(0.75, 0.6, 0.5, 0.5))
				x += 200.0
		"tower":
			_soft(c, PackedVector2Array([Vector2(-span, g), Vector2(span, g), Vector2(span, 0.0), Vector2(-span, 0.0)]), Color(0.55, 0.5, 0.72, 0.3))
			var x := -span
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x - 30.0, g * 0.3), Vector2(x + 30.0, g * 0.3), Vector2(x + 30.0, g * 0.7), Vector2(x - 30.0, g * 0.7)]), Color(0.75, 0.65, 0.95, 0.5))
				x += 260.0
		"arena":
			# อัฒจันทร์โค้งของลานประลอง
			for row in 4:
				var y := g - 40.0 - float(row) * 50.0
				_soft(c, PackedVector2Array([Vector2(-span, y), Vector2(span, y), Vector2(span, y - 40.0), Vector2(-span, y - 40.0)]), Color(0.85, 0.78, 0.68, 0.55))
				var x := -span
				while x < span:
					_blob(c, Vector2(x, y - 45.0), 12.0, 12.0, [Color(1.0, 0.75, 0.5, 0.5), Color(0.75, 0.75, 0.8, 0.5), Color(1.0, 0.95, 0.85, 0.5)][int(absf(x)) % 3])
					x += 36.0

func _paint_mid(c: Node2D, theme: String) -> void:
	if DungeonLook.has(theme):
		DungeonLook.mid(c, theme, _ground_y(), _span(PAR_MID), _rng)
		return
	var g := _ground_y()
	var span := _span(PAR_MID)
	var x := -span
	match theme:
		"meadow":
			while x < span:
				_blob(c, Vector2(x, g - 40.0), 60.0, 40.0, Color(0.45, 0.68, 0.42, 0.55))
				if _rng.randf() < 0.4:
					_soft(c, PackedVector2Array([Vector2(x + 30.0, g), Vector2(x + 38.0, g), Vector2(x + 38.0, g - 90.0), Vector2(x + 30.0, g - 90.0)]), Color(0.55, 0.42, 0.3, 0.5))
					_blob(c, Vector2(x + 34.0, g - 120.0), 50.0, 45.0, Color(0.4, 0.62, 0.38, 0.55))
				x += _rng.randf_range(120.0, 220.0)
		"forest":
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x - 14.0, g), Vector2(x + 14.0, g), Vector2(x + 10.0, g - 260.0), Vector2(x - 10.0, g - 260.0)]), Color(0.45, 0.32, 0.25, 0.6))
				_blob(c, Vector2(x, g - 290.0), 100.0, 90.0, Color(0.32, 0.55, 0.35, 0.6))
				_blob(c, Vector2(x + 50.0, g - 230.0), 70.0, 60.0, Color(0.38, 0.62, 0.4, 0.55))
				x += _rng.randf_range(160.0, 260.0)
		"ruins":
			while x < span:
				# กล่องกระดาษพังกับกำแพงแตก
				var h := _rng.randf_range(60.0, 160.0)
				_soft(c, PackedVector2Array([Vector2(x, g), Vector2(x + 90.0, g), Vector2(x + 90.0, g - h), Vector2(x, g - h)]), Color(0.82, 0.64, 0.42, 0.6))
				_soft(c, PackedVector2Array([Vector2(x, g - h), Vector2(x - 20.0, g - h - 30.0), Vector2(x + 30.0, g - h - 10.0)]), Color(0.75, 0.58, 0.38, 0.6))
				x += _rng.randf_range(150.0, 260.0)
		"tower":
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x - 30.0, g), Vector2(x + 30.0, g), Vector2(x + 30.0, g - 320.0), Vector2(x - 30.0, g - 320.0)]), Color(0.6, 0.54, 0.74, 0.55))
				_blob(c, Vector2(x + 60.0, g - 160.0), 14.0, 20.0, Color(1.0, 0.8, 0.45, 0.7))
				_blob(c, Vector2(x + 60.0, g - 160.0), 40.0, 40.0, Color(1.0, 0.8, 0.45, 0.2))
				x += _rng.randf_range(220.0, 320.0)
		"arena":
			while x < span:
				# ธงรอยเท้าแขวนรอบลาน
				_soft(c, PackedVector2Array([Vector2(x - 25.0, g - 300.0), Vector2(x + 25.0, g - 300.0), Vector2(x + 25.0, g - 200.0), Vector2(x, g - 215.0), Vector2(x - 25.0, g - 200.0)]), [Color(0.85, 0.3, 0.3, 0.6), Color(0.38, 0.5, 0.8, 0.6)][int(absf(x)) % 2])
				_soft(c, PackedVector2Array([Vector2(x - 6.0, g), Vector2(x + 6.0, g), Vector2(x + 6.0, g - 300.0), Vector2(x - 6.0, g - 300.0)]), Color(0.6, 0.45, 0.3, 0.6))
				x += 260.0

func _paint_ground(c: Node2D, theme: String) -> void:
	var g := _ground_y()
	var span := _span(1.0)
	var far: Color
	var near: Color
	match theme:
		"forest":
			far = Color(0.45, 0.66, 0.4)
			near = Color(0.3, 0.5, 0.3)
		"ruins":
			far = Color(0.86, 0.72, 0.55)
			near = Color(0.7, 0.55, 0.4)
		"tower":
			far = Color(0.72, 0.67, 0.82)
			near = Color(0.58, 0.53, 0.7)
		"arena":
			far = Color(0.92, 0.82, 0.62)
			near = Color(0.8, 0.66, 0.48)
		_:
			far = Color(0.6, 0.82, 0.48)
			near = Color(0.4, 0.66, 0.32)
	if DungeonLook.has(theme):
		var gc := DungeonLook.ground(theme)
		far = gc[0]
		near = gc[1]
	for i in 8:
		var k := float(i) / 8.0
		c.draw_rect(Rect2(-span, g + (_view.y - g) * k, span * 2.0, (_view.y - g) / 8.0 + 1.0), far.lerp(near, k))
	for i in int(span / 40.0):
		var p := Vector2(_rng.randf_range(-span, span), g + (_view.y - g) * pow(_rng.randf(), 0.8))
		_blob(c, p, 16.0, 5.0, Color(near.darkened(0.2), 0.3))
	# ชั้นหน้ากระดาษตัด ขอบพื้นหยักมีเส้นหมึก กับรอยเท้าแมวจางๆ
	PaperFront.lip(c, -span, span, g, far, 300 + dungeon_index)
	for i in int(span / 160.0):
		var pp := Vector2(_rng.randf_range(-span, span), g + (_view.y - g) * _rng.randf_range(0.3, 0.85))
		PaperFront.paw(c, pp, _rng.randf_range(9.0, 14.0), Color(near.darkened(0.25), 0.22))
