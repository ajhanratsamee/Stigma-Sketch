class_name BowManaFx
extends Node2D
## พลังสามสีของสาย MANASTARKER / ESSENCE WEAVER (ฟ้า แดง เหลือง)
## ลูกพลังกลมๆ ลอยไปเองแล้วโดนมอนเอง ใช้ดาเมจผ่าน MageCaster
## mode: once โดนตัวแรกแล้วแตก  pierce ทะลุโดนทุกตัวตัวละครั้ง  bomb โดนแล้วระเบิดเป็นวง  aura ตามตัวไม่ทำดาเมจ

const BLUE := Color(0.45, 0.82, 1.0)
const RED := Color(1.0, 0.45, 0.55)
const YELLOW := Color(1.0, 0.86, 0.32)
const TRI := [BLUE, RED, YELLOW]
const BODY := 46.0              # ครึ่งความกว้างตัวหุ่น เผื่อระยะโดน

var caster: MageCaster
var vel := Vector2.ZERO
var drag := 0.0                 # หน่วงความเร็วต่อวินาที
var life := 1.5
var colors: Array = [BLUE]
var radius := 22.0
var dmg := 10.0
var extra := {}
var mode := "once"
var dart := false               # ทรงลูกศรมน ยืดตามทิศ
var ground_pop := false         # ถึงพื้นแล้วแตก
var bomb_dmg := 20.0
var bomb_r := 170.0
var bomb_extra := {"type": "launch", "vy": 12.0}
var follow: Node2D              # ออร่าตามตัว
var follow_off := Vector2(0.0, -70.0)

var _age := 0.0
var _pop := -1.0
var _done := {}
var _trail: Array = []

func _process(delta: float) -> void:
	_age += delta
	if _pop >= 0.0:
		_pop += delta
		if _pop >= 0.28:
			queue_free()
		queue_redraw()
		return
	if follow != null and is_instance_valid(follow):
		position = follow.position + follow_off
	else:
		position += vel * delta
		vel *= exp(-drag * delta)
	_trail.push_front(position)
	if _trail.size() > 9:
		_trail.pop_back()
	if mode != "aura" and caster != null:
		_touch()
	if ground_pop and position.y >= -12.0:
		_burst()
	elif _age >= life and _pop < 0.0:
		if mode == "bomb":
			_burst()
		else:
			_pop = 0.0
	queue_redraw()

func _touch() -> void:
	for m in caster._monsters():
		var mon := m as Monster
		if _done.has(mon):
			continue
		var c := mon.position + Vector2(0.0, -WalkPage.MONSTER_MID)
		if absf(c.x - position.x) > radius + BODY or absf(c.y - position.y) > radius + 70.0:
			continue
		_done[mon] = true
		if mode == "bomb":
			_burst()
			return
		caster._hit(mon, dmg, extra)
		if mode == "once":
			_pop = 0.0
			return

func _burst() -> void:
	if _pop >= 0.0:
		return
	_pop = 0.0
	if caster == null:
		return
	if mode == "bomb":
		for m in caster._monsters():
			var c := (m as Monster).position + Vector2(0.0, -WalkPage.MONSTER_MID)
			if absf(c.x - position.x) <= bomb_r and absf(c.y - position.y) <= bomb_r + 40.0:
				caster._hit(m, bomb_dmg, bomb_extra)
		ring(caster, position, bomb_r, TRI)

## วงพลังสามสีขยายออก (ระเบิด / กระทบพื้น)
static func ring(by: MageCaster, at: Vector2, r: float, cols: Array) -> void:
	var rg := Ring.new()
	rg.max_r = r
	rg.colors = cols
	by._add(rg, at)

func _draw() -> void:
	var fade := 1.0 - clampf(_pop / 0.28, 0.0, 1.0) if _pop >= 0.0 else minf(1.0, _age / 0.06)
	var grow := 1.0 + maxf(_pop, 0.0) * 3.0
	var main: Color = colors[0]
	# รอยหางเป็นเม็ดกลมๆ จางลง
	for i in range(1, _trail.size()):
		var k := 1.0 - float(i) / float(_trail.size())
		var col: Color = colors[i % colors.size()]
		draw_circle(to_local(_trail[i]), radius * 0.55 * k, Color(col, 0.35 * k * fade))
	if dart:
		_draw_dart(main, fade)
		return
	var r := radius * grow
	draw_circle(Vector2.ZERO, r * 1.9, Color(main, 0.12 * fade))
	draw_circle(Vector2.ZERO, r * 1.35, Color(main, 0.28 * fade))
	if colors.size() >= 3:
		# สามสีหมุนวนรอบแกนขาว
		draw_circle(Vector2.ZERO, r * 0.95, Color(1.0, 0.97, 1.0, 0.85 * fade))
		for i in 3:
			var ang := _age * 7.0 + TAU * float(i) / 3.0
			draw_circle(Vector2(cos(ang), sin(ang)) * r * 0.55, r * 0.48, Color(colors[i], 0.95 * fade))
		draw_circle(Vector2.ZERO, r * 0.32, Color(1.0, 1.0, 1.0, fade))
	else:
		draw_circle(Vector2.ZERO, r, Color(main, 0.95 * fade))
		draw_circle(Vector2.ZERO, r * 0.6, Color(main.lightened(0.45), fade))
		draw_circle(Vector2(-r * 0.3, -r * 0.3), r * 0.25, Color(1.0, 1.0, 1.0, 0.9 * fade))
	# ประกายวิ้งเล็กๆ รอบลูก
	for i in 3:
		var a := _age * 3.0 + float(i) * 2.1
		var p := Vector2(cos(a), sin(a * 1.3)) * r * 1.5
		draw_circle(p, 3.0, Color(1.0, 1.0, 1.0, 0.7 * fade))

## ศรพลังทรงมน ก้านแคปซูล หัวกลม
func _draw_dart(col: Color, fade: float) -> void:
	var d := vel.normalized() if vel.length() > 1.0 else Vector2.RIGHT
	var tail := -d * radius * 3.2
	draw_line(tail, Vector2.ZERO, Color(col, 0.3 * fade), radius * 1.6, true)
	draw_circle(tail, radius * 0.8, Color(col, 0.3 * fade))
	draw_line(tail * 0.8, Vector2.ZERO, Color(col, 0.95 * fade), radius * 0.7, true)
	draw_circle(tail * 0.8, radius * 0.35, Color(col, 0.95 * fade))
	draw_circle(Vector2.ZERO, radius * 0.75, Color(col, fade))
	draw_circle(Vector2.ZERO, radius * 0.45, Color(col.lightened(0.5), fade))
	draw_circle(-d * radius * 0.2 - d.orthogonal() * radius * 0.2, radius * 0.18, Color(1.0, 1.0, 1.0, fade))

## วงพลังสามสีซ้อนกันขยายออกแล้วจาง มีเม็ดกลมกระจาย
class Ring extends Node2D:
	var max_r := 170.0
	var colors: Array = []
	var _t := 0.0
	const TIME := 0.45

	func _process(delta: float) -> void:
		_t += delta
		if _t >= TIME:
			queue_free()
		queue_redraw()

	func _draw() -> void:
		var k := clampf(_t / TIME, 0.0, 1.0)
		var e := 1.0 - (1.0 - k) * (1.0 - k)
		var a := 1.0 - k
		draw_circle(Vector2.ZERO, max_r * 0.5 * (1.0 - k), Color(1.0, 1.0, 1.0, 0.5 * a))
		for i in colors.size():
			var r := max_r * e * (1.0 - float(i) * 0.18)
			draw_arc(Vector2.ZERO, r, 0.0, TAU, 48, Color(colors[i], 0.9 * a), 10.0 * a + 2.0, true)
		for i in 10:
			var ang := TAU * float(i) / 10.0
			var col: Color = colors[i % colors.size()]
			draw_circle(Vector2(cos(ang), sin(ang) * 0.6) * max_r * e * 1.05, 9.0 * a + 1.0, Color(col, a))
