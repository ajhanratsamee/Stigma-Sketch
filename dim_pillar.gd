class_name DimPillar
extends Node2D
## ประตูเทเลพอร์ตที่วางไว้ ทำดาเมจรอบตัวตอนวาง กดสกิลซ้ำวาปกลับมาที่ประตูและทำดาเมจรอบตัวอีกครั้ง

const U := CombatData.UNIT
const REACH := 2.2
const DMG := 14.0
const LIFE := 12.0
const GATE_RX := 42.0           # พอดีตัวละคร
const GATE_RY := 100.0
const RINGS := 3
const FILL := Color(0.72, 0.58, 0.98, 0.55)
const EDGE := Color(0.5, 0.3, 0.86)

var pos_x := 0.0
var hero: Hero
var _t := 0.0

func _ready() -> void:
	z_index = -1
	position = Vector2(pos_x, 0.0) * U
	burst(pos_x)

func _physics_process(delta: float) -> void:
	_t += delta
	queue_redraw()
	if _t >= LIFE:
		queue_free()

## ทำดาเมจรอบจุดนี้ ครั้งเดียว ใช้ตอนวางกับตอนวาปกลับ
func burst(x: float) -> void:
	var hit := {"type": "flinch", "dmg": DMG, "kb": 0.0, "skill": true}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - x) > REACH or e.pos.y > REACH:
			continue
		var before: float = e.hp
		if e.take_hit(hit, signf(e.pos.x - x) if e.pos.x != x else 1.0):
			hero.count_hit(before - e.hp, hit)

## ประตูเทเลพอร์ตรูปรีตั้งตรง ขนาดพอดีตัวละคร มีวงหมุนข้างใน
func _draw() -> void:
	var c := Vector2(0.0, -GATE_RY)
	var open := minf(_t / 0.18, 1.0)
	var rx := GATE_RX * open
	if rx < 1.0:
		return
	var gate := Sketch.oval(c, rx, GATE_RY, 28)
	Sketch.hatch(self, gate, FILL)
	gate.append(gate[0])
	Sketch.line(self, gate, 2530, 4.0, 0.5, EDGE)
	for i in RINGS:
		var u := fposmod(_t * 0.9 + float(i) / RINGS, 1.0)
		var ring := Sketch.oval(c, rx * (1.0 - u), GATE_RY * (1.0 - u), 22)
		ring.append(ring[0])
		Sketch.line(self, ring, 2531 + i, 2.2, 0.3, Color(EDGE, u))
