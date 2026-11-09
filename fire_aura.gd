class_name FireAura
extends Node2D
## เส้นไฟวนรอบตัวละครแนวนอน ตามตัวไปตลอด ทำดาเมจต่อเนื่องโดยมอนไม่ชะงัก

const U := CombatData.UNIT
const LIFE := 6.0
const FADE := 0.4
const REACH := 2.6
const TICK := 0.25
const DMG := 6.0
const RX := 165.0
const RY := 34.0
const CENTER_UP := 105.0
const COIL_RISE := 70.0
const COIL_TURNS := 2.5
const COIL_STEPS := 90
const COIL_SPEED := 7.0
const LINE := Color(0.96, 0.42, 0.1)

var hero: Hero
var ticks_done := 0
var _t := 0.0
var _next := 0.0

func _ready() -> void:
	z_index = 2

func _physics_process(delta: float) -> void:
	_t += delta
	position = Vector2(hero.pos.x, -hero.pos.y) * U
	queue_redraw()
	if _t >= LIFE:
		queue_free()
		return
	if _t >= _next:
		_next = _t + TICK
		ticks_done += 1
		_burn()

func _burn() -> void:
	var hit := {"type": "none", "dmg": DMG, "skill": true}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - hero.pos.x) > REACH or absf(e.pos.y - hero.pos.y) > REACH:
			continue
		var before: float = e.hp
		if e.take_hit(hit, hero.facing):
			hero.count_hit(before - e.hp, hit)

## เส้นไฟเส้นเดียว วนรอบตัวในแนวนอนซ้อนกันเป็นขด
func _draw() -> void:
	var k := clampf((LIFE - _t) / FADE, 0.0, 1.0) * minf(_t / 0.2, 1.0)
	if k <= 0.0:
		return
	var coil := PackedVector2Array()
	for i in COIL_STEPS + 1:
		var t := float(i) / COIL_STEPS
		var a := t * TAU * COIL_TURNS + _t * COIL_SPEED
		coil.append(Vector2(cos(a) * RX * k, -CENTER_UP - COIL_RISE * (t - 0.5) + sin(a) * RY * k))
	Sketch.line(self, coil, 2460, 6.0, 0.6, Color(Sketch.INK, k))
	Sketch.line(self, coil, 2460, 3.4, 0.6, Color(LINE, k))
