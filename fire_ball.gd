class_name FireBall
extends Node2D
## ลูกบอลไฟของสายเวท ลอยไปตามทิศ ชนมอนหรือพื้นแล้วระเบิด
## แบบ holding ไม่ระเบิดเอง ลอยช้าๆ รอคำสั่ง detonate จากท่าถัดไป หมดเวลาก็ดับไป
## พิกัด pos เป็นหน่วยโลก y คือความสูงจากพื้น

const U := CombatData.UNIT
const BALL_R := 26.0
const CONTACT := 0.9
const BODY_MID := 0.9          # ระดับกลางตัวมอน เทียบเท้า
const BODY_TOP := 2.2          # ลูกบอลสูงกว่าหัวมอนเท่านี้ไม่โดน
const FLY_BLAST := 1.3
const MIN_BLAST := 1.3
const HOLD_BLAST := 2.8
const HOLD_LIFE := 3.0
const FLY_LIFE := 2.5
const BOOM_TIME := 0.35
const SPREAD_REACH := 5.5
const SPREAD_LINGER := 2.5

var pos := Vector2.ZERO
var vel := Vector2.ZERO
var kind := "fire"
var dmg := 10.0
var burn := ""
var holding := false
var pierce := false            # ทะลุมอน โดนแล้วลอยต่อ ไม่ระเบิด
var touch_dmg := 0.0           # แบบลอยรอ แตะมอนตัวไหนก็ทำดาเมจตัวละครั้ง
var hit_list: Array = []
var radius := BALL_R
var life_mult := 1.0
var is_skill := false
var drag := false              # ไถมอนที่โดนไปด้วย
var stop_range := 0.0          # มากกว่าศูนย์ คือไปถึงระยะนี้แล้วระเบิด
var boom_extra := {}           # ผลตอนระเบิด
var _traveled := 0.0
var extra_hit := {}            # แก้ผลที่มอนโดน เช่น ทำให้กระเด็น
var blast_units := 0.0         # รัศมีระเบิดกำหนดเอง
var quake := 0.0               # ระเบิดแล้วพื้นสั่น แรงเท่านี้
var hit_boom := false          # แบบทะลุ มอนที่โดนระเบิดเป็นวงกลม
var repeat_gap := 0.0          # แบบทะลุ ดาเมจต่อเนื่อง ลืมตัวที่โดนแล้วทุกช่วงนี้
var spread_kind := ""          # กระทบพื้นแล้วแตกกระจายตามพื้นทั้งสองข้าง
var _repeat := 0.0
var hero: Hero
var exploded := false
var _life := 0.0
var _boom := 0.0
var _clock := 0.0

func _ready() -> void:
	z_index = 2
	_life = (HOLD_LIFE if holding else FLY_LIFE) * life_mult
	_place()

func _physics_process(delta: float) -> void:
	_clock += delta
	queue_redraw()
	if exploded:
		_boom += delta / BOOM_TIME
		if _boom >= 1.0:
			queue_free()
		return
	pos += vel * delta
	_traveled += vel.length() * delta
	_place()
	if drag:
		for e in hit_list:
			if is_instance_valid(e) and not e.is_invulnerable():
				e.pos.x = pos.x
				e.vel.x = 0.0
	if stop_range > 0.0 and _traveled >= stop_range:
		_explode()
		return
	_life -= delta
	if _life <= 0.0:
		queue_free()
		return
	if holding:
		if touch_dmg > 0.0:
			_touch({"type": "flinch", "dmg": touch_dmg, "kb": 0.0})
		return
	if vel.y < 0.0 and pos.y <= 0.2 + radius / U * 0.5:
		_explode()
		return
	if pierce:
		if repeat_gap > 0.0:
			_repeat -= delta
			if _repeat <= 0.0:
				_repeat = repeat_gap
				hit_list.clear()
		_touch(_blast_hit())
		return
	for e in get_tree().get_nodes_in_group("monsters"):
		if not e.is_invulnerable() and _touching(e):
			_explode()
			return

## ชนตัวมอนตลอดความสูงของลำตัว ไม่ใช่แค่จุดกลางตัว
func _touching(e: Node2D) -> bool:
	var dy: float = pos.y - e.pos.y
	var near_x := maxf(CONTACT, radius / U)
	var above := radius / U
	return absf(pos.x - e.pos.x) < near_x and dy > -0.3 - above and dy < BODY_TOP + above

## แตะมอนตัวไหนทำดาเมจตัวละครั้ง ลูกบอลยังลอยต่อ
func _touch(hit: Dictionary) -> void:
	for e in get_tree().get_nodes_in_group("monsters"):
		if e in hit_list or not _touching(e):
			continue
		hit_list.append(e)
		var hp_before: float = e.hp
		if e.take_hit(hit, signf(vel.x) if vel.x != 0.0 else 1.0) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)
		if hit_boom:
			_boom_on(e)

func _blast_hit() -> Dictionary:
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	if burn != "":
		hit["burn"] = burn
	hit.merge(extra_hit, true)
	if is_skill:
		hit["skill"] = true
	return hit

## มอนที่โดนระเบิดเป็นวงกลมม่วง กระทบตัวรอบๆ ด้วย
func _boom_on(target: Node2D) -> void:
	var fx := ImpactFx.new()
	fx.kind = "purple_boom"
	fx.pos = target.pos + Vector2(0.0, 1.0)
	get_parent().add_child(fx)
	var hit := {"type": "flinch", "dmg": dmg * 0.5, "kb": 0.0, "skill": is_skill}
	for e in get_tree().get_nodes_in_group("monsters"):
		if e == target or e in hit_list or absf(e.pos.x - target.pos.x) > ImpactFx.PURPLE_R:
			continue
		var hp_before: float = e.hp
		if e.take_hit(hit, signf(e.pos.x - target.pos.x)) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

## ท่าถัดไปสั่งระเบิด
func detonate() -> void:
	if not exploded:
		_explode()

func _explode() -> void:
	exploded = true
	if quake > 0.0:
		_rumble()
	if spread_kind != "":
		for s in [-1.0, 1.0]:
			var flame := GroundFlame.new()
			flame.hero = hero
			flame.kind = spread_kind
			flame.dmg = dmg * 0.5
			flame.reach = SPREAD_REACH
			flame.dir = s
			flame.is_skill = is_skill
			flame.linger = SPREAD_LINGER
			flame.x = pos.x + s * 0.4
			get_parent().add_child(flame)
	var reach := blast_reach()
	var hit := _blast_hit()
	hit.merge(boom_extra, true)
	for e in get_tree().get_nodes_in_group("monsters"):
		if (pierce and not drag and e in hit_list) or pos.distance_to(e.pos + Vector2(0.0, BODY_MID)) >= reach:
			continue
		var hp_before: float = e.hp
		var dir := signf(e.pos.x - pos.x)
		if e.take_hit(hit, dir if dir != 0.0 else 1.0) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

## พื้นสั่น ดินแตกตรงจุดกระทบ
func _rumble() -> void:
	var world: Node2D = get_parent()
	var home := world.position
	var tw := world.create_tween()
	var steps := int(4.0 + quake * 0.3)
	for i in steps:
		var k := 1.0 - float(i) / steps
		tw.tween_property(world, "position", home + Vector2(randf_range(-quake, quake) * 0.5, randf_range(-quake, quake)) * k, 0.035)
	tw.tween_property(world, "position", home, 0.035)
	var fx := ImpactFx.new()
	fx.kind = "slam"
	fx.tint = CombatData.FLAME[kind][0]
	fx.pos = Vector2(pos.x, 0.0)
	world.add_child(fx)

func blast_reach() -> float:
	if blast_units > 0.0:
		return blast_units
	# ลูกเล็กต้องระเบิดโดนตัวที่ชน รัศมีจึงไม่ต่ำกว่าระยะชน
	return HOLD_BLAST if holding else maxf(FLY_BLAST * radius / BALL_R, MIN_BLAST)

func _place() -> void:
	position = Vector2(pos.x, -pos.y) * U

func _draw() -> void:
	var colors: Array = CombatData.FLAME[kind]
	if exploded:
		var r := blast_reach() * U * _boom
		for n in 3:
			var ring := Sketch.oval(Vector2.ZERO, r * (1.0 - n * 0.22), r * (1.0 - n * 0.22), 48)
			ring.append(ring[0])
			Sketch.line(self, ring, 2100 + n, 4.0, 1.4, Color(colors[n % 2], 1.0 - _boom))
		return
	Sketch.energy_ball(self, Vector2(vel.x, -vel.y) * U, radius, colors[0], colors[1], _clock)
	if kind == "time":
		# บอลมิติเวลา มีเข็มนาฬิกาหมุนข้างใน
		var hand := _clock * 6.0
		draw_line(Vector2.ZERO, Vector2(cos(hand), sin(hand)) * BALL_R * 0.7, colors[0], 3.0, true)
		draw_line(Vector2.ZERO, Vector2(cos(hand * 0.25), sin(hand * 0.25)) * BALL_R * 0.45, colors[0], 3.0, true)
