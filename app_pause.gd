extends CanvasLayer
## พักเกมเองเมื่อสลับแอป / จอดับ / หน้าต่างหลุดโฟกัส (มือถือ เว็บ) ระหว่างอยู่ในหน้าเล่น (autoload "AppPause")
## เซฟเลเวล EXP ของตัวละครไว้ก่อน แล้วขึ้นป้ายนุ่มๆ "พักอยู่ แตะเพื่อเล่นต่อ"

var paused_by_me := false
var _dim: Control

func _ready() -> void:
	layer = 120
	process_mode = Node.PROCESS_MODE_ALWAYS
	_dim = Control.new()
	_dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_dim.visible = false
	_dim.draw.connect(_draw_dim)
	add_child(_dim)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED:
			pause_now()
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			# เดสก์ท็อปสลับหน้าต่างบ่อย พักเฉพาะมือถือกับเว็บ
			if OS.has_feature("mobile") or OS.has_feature("web"):
				pause_now()

## พักเกม (เรียกตรงๆ ได้ในเทสต์)
func pause_now() -> void:
	if paused_by_me:
		return
	var sc := get_tree().current_scene
	if not (sc is WalkPage):
		return
	_save_progress(sc as WalkPage)
	paused_by_me = true
	get_tree().paused = true
	_dim.visible = true
	_dim.queue_redraw()

func resume() -> void:
	if not paused_by_me:
		return
	paused_by_me = false
	get_tree().paused = false
	_dim.visible = false
	var sc := get_tree().current_scene
	if sc is WalkPage:
		var wp := sc as WalkPage
		if wp.pad != null:
			wp.pad.reset()
		if wp.joy != null:
			wp.joy.release()
	Snd.play("confirm", -4.0)

func _save_progress(wp: WalkPage) -> void:
	if WalkPage.trial or WalkPage.roster_index < 0:
		return
	SaveData.update_character(WalkPage.roster_index, {"level": WalkPage.chosen_level, "exp": WalkPage.chosen_exp})

func _input(event: InputEvent) -> void:
	if not paused_by_me:
		return
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed):
		get_viewport().set_input_as_handled()
		resume()

func _draw_dim() -> void:
	var v := _dim.get_viewport_rect().size
	_dim.draw_rect(Rect2(Vector2.ZERO, v), Color(0.93, 0.9, 0.87, 0.82))
	var card := Rect2(v * 0.5 - Vector2(250.0, 95.0), Vector2(500.0, 190.0))
	UiStyle.box(_dim, card, 1201, UiStyle.LINE, UiStyle.INK, UiStyle.PAPER)
	# แมวหลับเล็กๆ
	var c := card.position + Vector2(90.0, 98.0)
	_dim.draw_circle(c, 34.0, Color(0.8, 0.75, 0.7))
	_dim.draw_arc(c + Vector2(-12.0, -2.0), 8.0, 0.2, PI - 0.2, 10, UiStyle.INK, 3.0, true)
	_dim.draw_arc(c + Vector2(12.0, -2.0), 8.0, 0.2, PI - 0.2, 10, UiStyle.INK, 3.0, true)
	UiStyle.text(_dim, card.get_center() + Vector2(50.0, -22.0), "พักอยู่", 40, UiStyle.INK)
	UiStyle.text(_dim, card.get_center() + Vector2(50.0, 34.0), "แตะเพื่อเล่นต่อ", 28, UiStyle.INK)
