class_name Phoenix
extends Node2D
## นกฟินิกซ์ขนาดใหญ่ของ BLADE WEAVER พุ่งไปข้างหน้า 2 จอครึ่ง ทะลุมอน โดนตัวละครั้ง เส้นระบายสีไฟ

const U := CombatData.UNIT
const SCREENS := 2.5
const SPEED := 22.0
const FLY_Y := 3.4
const HIT_X := 4.0
const HIT_Y := 6.0
const DMG := 70.0
const BODY := 270.0
const WING := 370.0
const FLAP := 11.0

var x := 0.0
var dir := 1.0
var distance := 60.0
var hero: Hero
var hit_list: Array = []
var went := 0.0
var _t := 0.0

func _ready() -> void:
	z_index = 3

func _physics_process(delta: float) -> void:
	_t += delta
	var step := SPEED * delta
	x += dir * step
	went += step
	position = Vector2(x, -FLY_Y) * U
	queue_redraw()
	var hit := {"type": "flinch", "dmg": DMG, "kb": 0.0, "skill": true}
	for e in get_tree().get_nodes_in_group("monsters"):
		if e in hit_list or absf(e.pos.x - x) > HIT_X or e.pos.y > HIT_Y:
			continue
		hit_list.append(e)
		var before: float = e.hp
		if e.take_hit(hit, dir) and is_instance_valid(hero):
			hero.count_hit(before - e.hp, hit)
		var fx := ImpactFx.new()
		fx.kind = "ram"
		fx.pos = e.pos + Vector2(0.0, 1.1)
		get_parent().add_child(fx)
	if went >= distance:
		queue_free()

func _pt(along: float, up: float) -> Vector2:
	return Vector2(along * dir, -up)

## หัวชี้ไปทางที่บิน หางเปลวยาว ปีกกระพือ ระบายแดงส้ม ขอบหมึก
func _draw() -> void:
	var colors: Array = CombatData.FLAME["fire"]
	var flap := sin(_t * FLAP)
	for side in [1.0, -1.0]:
		var lift: float = WING * (0.55 + 0.45 * flap) * float(side)
		var wing := PackedVector2Array([
			_pt(BODY * 0.25, 10.0 * float(side)), _pt(BODY * -0.15, lift * 1.15), _pt(BODY * -0.75, lift * 1.3),
			_pt(BODY * -0.55, lift * 0.65), _pt(BODY * -0.8, lift * 0.55), _pt(BODY * -0.35, 10.0 * float(side)),
		])
		Sketch.hatch(self, wing, colors[0] if side > 0.0 else colors[1], 2870, 15.0)
		wing.append(wing[0])
		Sketch.line(self, wing, 2871, 3.4, 0.8)
	var tail := PackedVector2Array([
		_pt(BODY * -0.45, 26.0), _pt(BODY * -1.3, 62.0 + flap * 22.0), _pt(BODY * -1.75, 14.0 - flap * 26.0),
		_pt(BODY * -1.25, -44.0 + flap * 18.0), _pt(BODY * -0.45, -26.0),
	])
	Sketch.hatch(self, tail, colors[1], 2872, 15.0)
	tail.append(tail[0])
	Sketch.line(self, tail, 2873, 3.0, 1.2)
	var body := PackedVector2Array([
		_pt(BODY * 0.95, 8.0), _pt(BODY * 0.72, 34.0), _pt(BODY * 0.45, 40.0), _pt(BODY * 0.1, 46.0), _pt(BODY * -0.55, 22.0),
		_pt(BODY * -0.55, -22.0), _pt(BODY * 0.1, -42.0), _pt(BODY * 0.5, -22.0), _pt(BODY * 0.72, -6.0),
	])
	draw_colored_polygon(body, Sketch.PAPER)
	Sketch.hatch(self, body, colors[0], 2874, 11.0)
	body.append(body[0])
	Sketch.line(self, body, 2875, 3.6, 0.6)
	var beak := PackedVector2Array([_pt(BODY * 0.92, 18.0), _pt(BODY * 1.15, 2.0), _pt(BODY * 0.92, -2.0)])
	Sketch.line(self, beak, 2876, 3.0, 0.2)
	draw_circle(_pt(BODY * 0.75, 16.0), 7.0, Sketch.INK)
	for n in 3:
		var crest := PackedVector2Array([_pt(BODY * (0.72 - 0.12 * n), 34.0), _pt(BODY * (0.62 - 0.14 * n), 66.0 + flap * 6.0)])
		Sketch.line(self, crest, 2877 + n, 3.0, 0.5, colors[0])
