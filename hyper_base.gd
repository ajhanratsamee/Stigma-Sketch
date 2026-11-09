class_name HyperBase
extends Node2D
## ของร่วมของท่า Hyper: จอภาพ สตั๊นมอนในจอ ตีมอน จอสั่น จบท่าโดยจอไม่ดับ
## วางเป็นลูกของ world พิกัดหน่วยโลก ลูกแต่ละท่าเขียน _run กับ _draw เอง

signal finished

const U := CombatData.UNIT
const BAR_H := 70.0
const BAR_TIME := 0.25
const FADE_OUT := 0.4
const STUN_LONG := 99.0

var hero: Hero
var half_width := 7.0
var zoom_scale := 1.0          # มาตราส่วนของฉากตอนกล้องถอยเต็มที่
var ending := false
var starts_cooldown := true     # ท่าแปลงร่างยังไม่ติดคูลดาวน์
var keep_camera := false        # สกิลสั้นๆ กล้องไม่ถอย
var hits_on_target := 0
var released := false           # Action Cancel ตัวละครเป็นอิสระแล้ว เอฟเฟกยังเล่นต่อ
var _layer: CanvasLayer
var _bars: Array[ColorRect] = []
var _targets: Array = []

func start() -> void:
	_prepare()
	hero.lock_for_hyper()
	_stun_all()
	_build_screen()
	_run()

## ตัวละครอยู่ห่างจากขอบจอด้านหลังเท่านี้ของความกว้างจอ ค่าลบคือกล้องไม่เลื่อน
func camera_back_share() -> float:
	return -1.0

## ลูกคำนวณตำแหน่งเริ่มต้นก่อนล็อกตัวละคร
func _prepare() -> void:
	pass

func _run() -> void:
	pass

## มอนตัวนี้โดนดาเมจของท่าหรือไม่ มอนที่ไม่โดนยังสตั๊นอยู่
func _hits(_e: Node2D) -> bool:
	return true

func _wait(sec: float) -> void:
	await get_tree().create_timer(sec).timeout

## ท่าที่ฉากมืด ซ่อนเส้นพื้นชั่วคราว
var hide_ground := false

func _process(_delta: float) -> void:
	queue_redraw()

# ---------------------------------------------------------------- มอน

func _stun_all() -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if e.state == "dead":
			continue
		e.vel = Vector2.ZERO
		e.ai_state = "move"
		if e.state == "idle" or e.state == "stun" or e.state == "flinch":
			e.state = "stun"
			e.state_t = STUN_LONG
		_targets.append(e)

func _release_all() -> void:
	for e in _targets:
		if is_instance_valid(e) and e.state == "stun":
			e.state_t = 0.2

func _strike(hit: Dictionary) -> void:
	hits_on_target += 1
	for e in _targets:
		if not is_instance_valid(e) or e.state == "dead" or not _hits(e):
			continue
		var before: float = e.hp
		var dir := signf(e.pos.x - hero.pos.x)
		if e.take_hit(hit, dir if dir != 0.0 else hero.facing):
			hero.count_hit(before - e.hp, hit)

# ---------------------------------------------------------------- จอภาพ

func _build_screen() -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 5
	get_parent().add_child(_layer)
	for top in [true, false]:
		var bar := ColorRect.new()
		bar.color = Sketch.INK
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE if top else Control.PRESET_BOTTOM_WIDE)
		bar.grow_vertical = Control.GROW_DIRECTION_END if top else Control.GROW_DIRECTION_BEGIN
		bar.custom_minimum_size.y = BAR_H
		bar.scale.y = 0.0
		bar.set_meta("top", top)
		_layer.add_child(bar)
		_bars.append(bar)

func _tween_bars(to: float, time: float) -> void:
	for bar in _bars:
		bar.pivot_offset = Vector2(0.0, 0.0 if bar.get_meta("top") else BAR_H)
		create_tween().tween_property(bar, "scale:y", to, time)
	await _wait(time)

func _shake(power: float) -> void:
	var w: Node2D = get_parent()
	var home: Vector2 = w.position
	var tw := create_tween()
	for i in 4:
		var k := 1.0 - i / 4.0
		tw.tween_property(w, "position", home + Vector2(randf_range(-power, power), randf_range(-power, power)) * k, 0.03)
	tw.tween_property(w, "position", home, 0.03)

## Action Cancel ตัดช่วงหลังของท่า ตัวละครเดิน หลบ หรือออกท่าอื่นได้ทันที เอฟเฟกของท่าเล่นต่อจนจบเอง
func _free_hero() -> void:
	if released:
		return
	released = true
	hero.set_spin(0.0)
	hero.unlock_from_hyper()
	finished.emit()

## จบท่าโดยไม่มืด เก็บแถบจอภาพแล้วกลับมาเล่นต่อ
func _end_plain() -> void:
	_release_all()
	var was_free := released
	if not released:
		released = true
		hero.set_spin(0.0)
		hero.unlock_from_hyper()
	await _tween_bars(0.0, BAR_TIME)
	if not was_free:
		finished.emit()
	_layer.queue_free()
	queue_free()

## ของในท่าจางหาย แล้วจบท่าโดยจอไม่ดับ
func _fade_and_end(clean: Callable) -> void:
	ending = true
	create_tween().tween_property(self, "modulate:a", 0.0, FADE_OUT)
	await _wait(FADE_OUT)
	clean.call()
	_end_plain()
