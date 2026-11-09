class_name SmokeCloud
extends Node2D
## ควันฟุ้งบนพื้น เป็นก้อนกลมเส้นวาดมือ ขยายแล้วจางหาย ตั้ง tick_dmg แล้วทำดาเมจต่อเนื่อง

const U := CombatData.UNIT
const SHORT_LIFE := 0.8
const TICK_GAP := 0.3
const REACH := 1.7
const PUFFS := [[-1.0, 0.25, 0.55], [-0.45, 0.55, 0.75], [0.15, 0.3, 0.85], [0.7, 0.6, 0.7], [1.1, 0.22, 0.5], [0.0, 1.05, 0.6], [-0.6, 1.1, 0.42], [0.65, 1.2, 0.4]]
const FILL := Color(0.8, 0.88, 0.72)

var pos := Vector2.ZERO
var life := SHORT_LIFE
var tick_dmg := 0.0
var hero: Hero
var fill := FILL
var drift := 0.0               # ไหลไปข้างหน้าต่อวินาที
var burn := ""
var wide := 1.0                # ขนาดกับระยะควันเท่าไรของปกติ
var ticks_done := 0
var _t := 0.0
var _next_tick := 0.0

func _ready() -> void:
	z_index = 2
	position = Vector2(pos.x, -pos.y) * U

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	if _t >= life:
		queue_free()
		return
	if drift != 0.0:
		pos.x += drift * delta
		position = Vector2(pos.x, -pos.y) * U
	if tick_dmg > 0.0 and _t >= _next_tick:
		_next_tick = _t + TICK_GAP
		ticks_done += 1
		_hit_all()

func _hit_all() -> void:
	var hit := {"type": "flinch", "dmg": tick_dmg, "kb": 0.0, "skill": true}
	if burn != "":
		hit["burn"] = burn
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - pos.x) > REACH * wide or e.pos.y > REACH:
			continue
		var hp_before: float = e.hp
		var dir := signf(e.pos.x - pos.x)
		if e.take_hit(hit, dir if dir != 0.0 else 1.0) and is_instance_valid(hero):
			hero.count_hit(hp_before - e.hp, hit)

func _draw() -> void:
	var u := _t / life
	var grow := minf(u * 3.5, 1.0)
	var fade := clampf((1.0 - u) * 2.5, 0.0, 1.0)
	for i in PUFFS.size():
		var p: Array = PUFFS[i]
		var sway := sin(_t * 2.6 + float(i)) * 8.0
		var c := Vector2(float(p[0]) * U * 1.15 * grow * wide + sway, -float(p[1]) * U * grow)
		var r := float(p[2]) * U * 0.75 * grow * sqrt(wide)
		if r < 2.0:
			continue
		var puff := Sketch.oval(c, r, r * 0.85, 22)
		Sketch.hatch(self, puff, Color(fill, fade * 0.85))
		puff.append(puff[0])
		Sketch.line(self, puff, 2310 + i, 2.6, 0.8, Color(Sketch.INK, fade))
