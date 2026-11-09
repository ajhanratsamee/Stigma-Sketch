class_name RedWave
extends Node2D
## คลื่นพลังรูปดาบยักษ์สีแดงของ SWORD KNIGHT ใบกว้าง ตกมาแนวเฉียง ยาว 2 ใน 3 ของครึ่งจอ ไม่มีด้าม
## ทำดาเมจตั้งแต่ปล่อย จนจมดินหมดทั้งเล่มแล้วระเบิด ตัวละครเดินได้ระหว่างนั้น

const U := CombatData.UNIT
const SCREEN_SHARE := 1.0 / 3.0   # 2 ใน 3 ของครึ่งจอ
const FALL := 3.2                 # ความเร็วตามแนวดาบ
const START_TIP := 5.0
const HALF_W := 2.1
const TIP_LONG := 2.6
const TILT := 0.42                # เฉียงจากแนวตั้ง เรเดียน
const TICK := 0.25
const DMG := 9.0
const HIT_MARGIN := 0.6
const BOOM_R := 5.0
const BOOM_DMG := 40.0
const RED := Color(0.86, 0.14, 0.14)
const GLOW := Color(1.0, 0.45, 0.38)
const PAINT_STEP := 20.0
const SPARKS := 9

var tip_y := START_TIP
var x := 0.0                   # ตำแหน่งปลายดาบ
var dir := 1.0
var hero: Hero
var length := 8.0              # ความยาวดาบ หน่วยโลก
var landed := false
var ticks_done := 0
var _tick := 0.0
var _t := 0.0

func _ready() -> void:
	z_index = 2
	var world: Node2D = get_parent()
	length = get_viewport_rect().size.x * SCREEN_SHARE / (U * world.scale.x)

## แกนจากปลายขึ้นไปหาโคนดาบ เป็นหน่วยโลก แกน y ขึ้น
func _axis() -> Vector2:
	return Vector2(-dir * sin(TILT), cos(TILT))

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	var move := -_axis() * FALL * delta
	x += move.x
	tip_y += move.y
	_tick -= delta
	if _tick <= 0.0:
		_tick = TICK
		ticks_done += 1
		_hit_blade()
	if tip_y + length * cos(TILT) <= 0.0:
		_boom()

## กลางใบดาบระดับพื้นถึงหัวมอน แนวเฉียงจึงเลื่อนตามความสูง
func _hit_blade() -> void:
	var hit := {"type": "flinch", "dmg": DMG, "kb": 0.0, "skill": true}
	var ax := _axis()
	for e in get_tree().get_nodes_in_group("monsters"):
		var along: float = maxf((e.pos.y + 1.0 - tip_y) / ax.y, 0.0)
		var line_x: float = x + ax.x * along
		if absf(e.pos.x - line_x) > HALF_W + HIT_MARGIN:
			continue
		var before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(before - e.hp, hit)

## จมดินหมดทั้งเล่ม ระเบิด ดินแตกสีแดง
func _boom() -> void:
	landed = true
	var center: float = x + _axis().x * length * 0.5
	var hit := {"type": "flinch", "dmg": BOOM_DMG, "kb": 0.0, "skill": true}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - center) > BOOM_R or e.pos.y > BOOM_R:
			continue
		var before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(before - e.hp, hit)
	for s in [-1.0, 0.0, 1.0]:
		var fx := ImpactFx.new()
		fx.kind = "slam"
		fx.tint = RED
		fx.pos = Vector2(center + s * 2.6, 0.0)
		get_parent().add_child(fx)
	var pile := ImpactFx.new()
	pile.kind = "rubble"
	pile.pos = Vector2(center, 0.0)
	get_parent().add_child(pile)
	var ram := ImpactFx.new()
	ram.kind = "ram"
	ram.pos = Vector2(center, 1.0)
	get_parent().add_child(ram)
	queue_free()

## จุดบนดาบ along ตามแกน side ตามความกว้าง แปลงเป็นพิกัดจอ
func _pt(along: float, side: float) -> Vector2:
	var ax := _axis()
	var across := Vector2(ax.y, -ax.x)
	var p := Vector2(x, tip_y) + ax * along + across * side
	return Vector2(p.x, -p.y) * U

## ตัดส่วนที่จมดิน เหลือเฉพาะเหนือพื้น
func _above(poly: PackedVector2Array) -> PackedVector2Array:
	var sky := PackedVector2Array([Vector2(-9000.0, -3000.0), Vector2(9000.0, -3000.0), Vector2(9000.0, 0.0), Vector2(-9000.0, 0.0)])
	var cut := Geometry2D.intersect_polygons(poly, sky)
	return cut[0] if cut.size() > 0 else PackedVector2Array()

func _draw() -> void:
	var g := HALF_W * 1.28
	var halo := _above(PackedVector2Array([_pt(-0.5, 0.0), _pt(TIP_LONG, g), _pt(length + 0.4, g), _pt(length + 0.4, -g), _pt(TIP_LONG, -g)]))
	if halo.size() >= 3:
		Sketch.hatch(self, halo, Color(GLOW, 0.3))
	var shape := _above(PackedVector2Array([_pt(0.0, 0.0), _pt(TIP_LONG, HALF_W), _pt(length, HALF_W), _pt(length, -HALF_W), _pt(TIP_LONG, -HALF_W)]))
	if shape.size() < 3:
		return
	Sketch.hatch(self, shape, Color(1.0, 0.72, 0.68, 0.55))
	var a := length * U if Sketch.anime else 0.0
	var i := 0
	while a < length * U:
		var along := a / U
		var w := HALF_W * minf(along / TIP_LONG, 1.0) * 0.9
		var from := _pt(along, -w)
		var to := _pt(along + 0.3, HALF_W * minf((along + 0.3) / TIP_LONG, 1.0) * 0.9)
		if w > 0.05 and from.y < 0.0 and to.y < 0.0:
			Sketch.line(self, PackedVector2Array([from, to]), 2550 + i % 20, 3.4, 0.6, RED)
		a += PAINT_STEP
		i += 1
	if Sketch.anime:
		Sketch.fx_fill(self, shape, RED)
	var edge := shape.duplicate()
	edge.append(edge[0])
	Sketch.line(self, edge, 2570, 5.0, 1.1)
	for n in SPARKS:
		var u := fposmod(_t * 0.8 + float(n) * 0.31, 1.0)
		var side := HALF_W * 1.4 * (1.0 if n % 2 == 0 else -1.0)
		var at := _pt(length * u, side)
		if at.y < 0.0:
			Sketch.line(self, PackedVector2Array([at, at + Vector2(0.0, -20.0)]), 2575 + n, 3.0, 0.3, Color(RED, 1.0 - u))
