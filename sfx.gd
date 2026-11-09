extends Node
## เสียงทั้งเกม (autoload "Sfx"): เสียงสั้นจากกองผู้เล่นเสียง กันเสียงรัว เพลงประกอบเปลี่ยนตามหน้า (ค่อยๆ สลับ) สั่นมือถือ
## เสียงทุกไฟล์สร้างเองใน res://sfx/ โทนนุ่ม ไม่แสบหู

const NAMES := ["tap", "confirm", "back", "press", "hit", "hit2", "hit_heavy", "defeat", "jump", "land", "dash",
	"skill_air", "skill_bell", "skill_spark", "hyper", "levelup", "quest", "quest_done", "coin", "hurt", "warp", "door", "mail"]
const MUSIC := {"town": "bgm_town", "dungeon": "bgm_dungeon", "menu": "bgm_menu"}
const POOL := 10
const HIT_WINDOW := 0.08          # ในช่วงนี้เล่นเสียงตีได้ไม่เกิน HIT_MAX ครั้ง (สกิลหลายฮิตไม่รัวเป็นปืนกล)
const HIT_MAX := 2
const SAME_GAP := 0.05            # เสียงชื่อเดียวกันห่างกันอย่างน้อยเท่านี้
const FADE := 1.2                 # สลับเพลงค่อยๆ จาง
const MUSIC_DB := -9.0            # เพลงเบากว่าเสียงเอฟเฟกต์
const DUCK_DB := -8.0             # ระหว่าง HYPER เพลงเบาลงอีก
const BUZZ_GAP := 0.12

var _streams := {}
var _pool: Array[AudioStreamPlayer] = []
var _next := 0
var _last := {}                   # ชื่อ -> เวลาเล่นล่าสุด
var _hits: Array[float] = []
var _buzz_t := -1.0
var _music_a: AudioStreamPlayer
var _music_b: AudioStreamPlayer
var _track := ""
var _scene: Node = null
var _tween: Tween
var played := 0                   # นับเสียงที่เล่นจริง (ใช้ในเทสต์)
var buzzed := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameSettings.ensure()
	for bus in ["Music", "Sfx"]:
		if AudioServer.get_bus_index(bus) == -1:
			AudioServer.add_bus()
			var i := AudioServer.bus_count - 1
			AudioServer.set_bus_name(i, bus)
			AudioServer.set_bus_send(i, "Master")
	for n in NAMES:
		var path := "res://sfx/%s.wav" % n
		if ResourceLoader.exists(path):
			_streams[n] = load(path)
	for i in POOL:
		var p := AudioStreamPlayer.new()
		p.bus = "Sfx"
		add_child(p)
		_pool.append(p)
	_music_a = _make_music()
	_music_b = _make_music()
	apply_volumes()

func _make_music() -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.bus = "Music"
	p.volume_db = -60.0
	p.finished.connect(func() -> void:
		if p.stream != null and p.volume_db > -59.0:
			p.play())
	add_child(p)
	return p

func _now() -> float:
	return float(Time.get_ticks_msec()) / 1000.0

## ปรับความดังตามค่าตั้ง (0 คือปิดเสียงบัสนั้น)
func apply_volumes() -> void:
	for pair in [["Music", GameSettings.music], ["Sfx", GameSettings.sfx]]:
		var i := AudioServer.get_bus_index(pair[0])
		if i == -1:
			continue
		var v: float = pair[1]
		AudioServer.set_bus_mute(i, v <= 0.001)
		AudioServer.set_bus_volume_db(i, linear_to_db(maxf(v, 0.001)))

func play(name: String, vol_db := 0.0, pitch := 0.0) -> void:
	if not _streams.has(name):
		return
	var now := _now()
	if now - float(_last.get(name, -10.0)) < SAME_GAP:
		return
	_last[name] = now
	var p := _pool[_next]
	_next = (_next + 1) % POOL
	p.stream = _streams[name]
	p.volume_db = vol_db
	p.pitch_scale = 1.0 + (randf_range(-pitch, pitch) if pitch > 0.0 else 0.0)
	p.play()
	played += 1

func hit(heavy := false) -> void:
	var now := _now()
	while not _hits.is_empty() and now - _hits[0] > HIT_WINDOW:
		_hits.pop_front()
	if _hits.size() >= HIT_MAX:
		return
	_hits.append(now)
	if heavy:
		play("hit_heavy", -2.0, 0.06)
	else:
		# สลับสองเสียง ไม่ซ้ำซาก
		play("hit" if randf() < 0.5 else "hit2", -3.0, 0.08)

func buzz(ms := 20) -> void:
	if not GameSettings.vibrate:
		return
	var now := _now()
	if now - _buzz_t < BUZZ_GAP:
		return
	_buzz_t = now
	buzzed += 1
	if OS.has_feature("mobile"):
		Input.vibrate_handheld(clampi(ms, 10, 40))

# ---------------------------------------------------------------- เพลง
func music(key: String) -> void:
	var file: String = MUSIC.get(key, "")
	if file == _track:
		return
	_track = file
	var old := _music_a if _music_a.playing else _music_b
	var nxt := _music_b if old == _music_a else _music_a
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	if file != "":
		var path := "res://sfx/%s.wav" % file
		if ResourceLoader.exists(path):
			var st: AudioStream = load(path)
			if st is AudioStreamWAV and (st as AudioStreamWAV).loop_mode == AudioStreamWAV.LOOP_DISABLED:
				var w := st as AudioStreamWAV
				w.loop_mode = AudioStreamWAV.LOOP_FORWARD
				w.loop_begin = 0
				w.loop_end = int(w.get_length() * float(w.mix_rate))
			nxt.stream = st
			nxt.volume_db = -40.0
			nxt.play()
			_tween.tween_property(nxt, "volume_db", MUSIC_DB, FADE)
	if old.playing:
		_tween.tween_property(old, "volume_db", -60.0, FADE)
		_tween.chain().tween_callback(old.stop)

func current_track() -> String:
	return _track

func _process(_delta: float) -> void:
	var sc := get_tree().current_scene
	if sc != _scene:
		_scene = sc
		music(_track_for(sc))
	# ระหว่าง HYPER เพลงเบาลง
	var duck := sc is WalkPage and (sc as WalkPage).hyper != null
	var bus := AudioServer.get_bus_index("Music")
	if bus != -1:
		var base := linear_to_db(maxf(GameSettings.music, 0.001))
		var want := base + (DUCK_DB if duck else 0.0)
		AudioServer.set_bus_volume_db(bus, lerpf(AudioServer.get_bus_volume_db(bus), want, 0.1))

func _track_for(sc: Node) -> String:
	if sc is RosterPage or sc is PickPage:
		return "menu"
	if sc is DungeonPage:
		return "dungeon"
	if sc is WalkPage:
		return "town"
	return ""

# ---------------------------------------------------------------- เสียงแตะเมนู
func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch and event.pressed):
		return
	var sc := get_tree().current_scene
	if sc is RosterPage or sc is PickPage or _overlay_open(sc):
		play("tap", -4.0, 0.05)

## หน้าเล่นกำลังเปิดแผง/เมนูอยู่ (แผงสกิล คอมโบ ตั้งค่า บทสนทนา เควส แผนที่)
func _overlay_open(sc: Node) -> bool:
	if not (sc is WalkPage):
		return false
	var wp := sc as WalkPage
	if wp.panel != null and wp.panel.visible:
		return true
	if wp.combo_panel != null and wp.combo_panel.visible:
		return true
	if wp.settings_open():
		return true
	if wp.settings_panel != null and wp.settings_panel.visible:
		return true
	if sc is TownPage:
		var tp := sc as TownPage
		if (tp.dialog != null and tp.dialog.visible) or (tp.quests != null and tp.quests.visible) or (tp.map != null and tp.map.visible):
			return true
	return false
