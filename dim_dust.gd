class_name DimDust
extends Node2D
## ละอองลูกบอลเวทมิติ เล็กมากหลายลูก สีขาวชมพูจาง โปรยแล้วทำดาเมจ 1 ฮิต ลอยค้างรอคำสั่ง
## ท่าถัดไปสั่ง gather ละอองลอยเข้าหาตัวละคร ทำดาเมจต่อเนื่องและลากมอนมาด้วย

const U := CombatData.UNIT
const COUNT := 46
const REACH_X := 2.7
const SPREAD_Y := 1.5
const MID_Y := 1.3
const SCATTER_TIME := 0.25
const WAIT_LIFE := 3.0
const GATHER_TIME := 0.75
const TICK_GAP := 0.14
const DRAG_SPEED := 8.0
const STOP_GAP := 1.0
const HOLD_STUN := 0.2
const PINK := Color(1.0, 0.82, 0.9)
const EDGE := Color(0.88, 0.58, 0.74)

var center := Vector2.ZERO
var hero: Hero
var scatter_dmg := 8.0
var tick_dmg := 3.0
var state_name := "scatter"    # scatter wait gather
var hit_once := 0
var ticks_done := 0
var _t := 0.0
var _tick := 0.0
var _pts: Array = []

func _ready() -> void:
	z_index = 2
	for i in COUNT:
		# กระจายสม่ำเสมอแบบกำหนดตายตัว ภาพเหมือนเดิมทุกครั้ง
		var a := float(i) * 2.399963
		var r := sqrt((float(i) + 0.5) / COUNT)
		_pts.append({"off": Vector2(cos(a) * r * REACH_X, sin(a) * r * SPREAD_Y), "size": 2.6 + 2.6 * absf(sin(float(i) * 1.9)), "phase": float(i) * 0.7})
	_hit_scatter()

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	match state_name:
		"scatter":
			if _t >= SCATTER_TIME:
				state_name = "wait"
				_t = 0.0
		"wait":
			if _t >= WAIT_LIFE:
				queue_free()
		"gather":
			_tick -= delta
			if _tick <= 0.0:
				_tick = TICK_GAP
				ticks_done += 1
				_hit_gather()
			_drag(delta)
			if _t >= GATHER_TIME:
				queue_free()

## สั่งจากท่าถัดไป ละอองลอยเข้าหาตัว
func gather() -> void:
	if state_name != "gather":
		state_name = "gather"
		_t = 0.0

func _in_reach(e: Node2D, reach: float) -> bool:
	return absf(e.pos.x - center.x) <= reach and e.pos.y <= SPREAD_Y + MID_Y

func _hit(e: Node2D, dmg: float) -> bool:
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	var hp_before: float = e.hp
	var dir := signf(hero.pos.x - e.pos.x)
	if e.take_hit(hit, dir if dir != 0.0 else 1.0):
		hero.count_hit(hp_before - e.hp, hit)
		return true
	return false

func _hit_scatter() -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if _in_reach(e, REACH_X) and _hit(e, scatter_dmg):
			hit_once += 1

func _hit_gather() -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if _in_reach(e, REACH_X + 1.0):
			_hit(e, tick_dmg)

## ลากมอนในระยะเข้าหาตัวละคร หยุดห่างหนึ่งช่วง
func _drag(delta: float) -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if e.is_invulnerable() or not _in_reach(e, REACH_X + 1.0):
			continue
		var side := signf(e.pos.x - hero.pos.x)
		if side == 0.0:
			continue
		e.pos.x = move_toward(e.pos.x, hero.pos.x + side * STOP_GAP, DRAG_SPEED * delta)
		e.vel.x = 0.0
		if e.state == "flinch":
			e.state_t = maxf(e.state_t, HOLD_STUN)

func _draw() -> void:
	var grow := 1.0
	var pull := 0.0
	if state_name == "scatter":
		grow = 1.0 - pow(1.0 - minf(_t / SCATTER_TIME, 1.0), 2.0)
	elif state_name == "gather":
		pull = minf(_t / GATHER_TIME, 1.0)
		pull = pull * pull
	var clock := Time.get_ticks_msec() / 1000.0
	var to_hero := Vector2(hero.pos.x, -(hero.pos.y + MID_Y)) * U
	for p in _pts:
		var off: Vector2 = p["off"]
		var phase: float = p["phase"]
		var at := Vector2(center.x + off.x * grow, -(center.y + off.y * grow)) * U
		at += Vector2(sin(clock * 1.7 + phase), cos(clock * 2.1 + phase)) * 5.0
		at = at.lerp(to_hero, pull)
		var r: float = p["size"]
		draw_circle(at, r, Color.WHITE if int(phase * 10.0) % 3 == 0 else PINK)
		draw_arc(at, r, 0.0, TAU, 10, EDGE, 1.0, true)
