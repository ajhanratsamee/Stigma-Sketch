extends Node
## บนเว็บ แตะหน้าจอแล้วขอเต็มจอ และล็อกแนวนอน (เบราว์เซอร์ยอมให้เต็มจอเฉพาะตอนผู้เล่นแตะ)
## ถ้าผู้เล่นออกจากเต็มจอ แตะครั้งถัดไปจะขอเต็มจอใหม่

func _input(event: InputEvent) -> void:
	if not OS.has_feature("web"):
		return
	var tap: bool = (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed)
	if not tap:
		return
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		JavaScriptBridge.eval("try { if (screen.orientation && screen.orientation.lock) { screen.orientation.lock('landscape').catch(function(){}); } } catch (e) {}", true)
