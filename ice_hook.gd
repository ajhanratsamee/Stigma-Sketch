class_name IceHook
extends Node2D
## น้ำแข็งเสกขึ้นจากพื้นด้านหน้า ห่างออกไป 5 ช่วงตัว โดนมอนตรงจุดเสกก็ทำดาเมจ แล้วแตกกระจาย
## เศษน้ำแข็งไถลตามพื้นกลับมาหาตัวละคร ลากมอนที่ขวางทางมาด้วย

const U := CombatData.UNIT
const FAR := 5.5               # 5 ช่วงตัว ตัวละครกว้างราว 1.1 หน่วยโลก
const RISE_REACH := 1.0        # ระยะโดนตอนน้ำแข็งงอกขึ้น
const NEAR := 1.2
const RISE_TIME := 0.18
const HOLD_TIME := 0.12
const SLIDE_TIME := 0.42
const FADE_TIME := 0.14
const GRAB_R := 0.85
const HOLD_STUN := 0.2
const SPIKE_W := 34.0
const SPIKE_H := 118.0
const SIDE_K := 0.62
const SHARDS := 9
const SHARD_SPREAD := 62.0     # เศษกระจายรอบหน้าคลื่น จุดภาพ
const SHARD_SIZE := 15.0
const SHARD_HOP := 26.0

var hero: Hero
var dmg := 10.0
var dir := 1.0
var x := 0.0                   # หน้าคลื่นเศษน้ำแข็ง
var grabbed: Array = []
var state_name := "rise"       # rise hold slide fade
var _t := 0.0
var _far_x := 0.0
var rise_hits := 0
var _rise_done := false
var _clock := 0.0

func _ready() -> void:
	z_index = 2
	dir = hero.facing
	_far_x = hero.pos.x + dir * FAR
	x = _far_x
	position = Vector2(x, 0.0) * U

func _physics_process(delta: float) -> void:
	_t += delta
	_clock += delta
	match state_name:
		"rise":
			if not _rise_done:
				_rise_done = true
				_hit_rise()
			if _t >= RISE_TIME:
				state_name = "hold"
				_t = 0.0
		"hold":
			if _t >= HOLD_TIME:
				state_name = "slide"
				_t = 0.0
		"slide":
			var near_x: float = hero.pos.x + dir * NEAR
			var u := minf(_t / SLIDE_TIME, 1.0)
			x = lerpf(_far_x, near_x, u * u)
			_grab()
			_drag()
			if u >= 1.0:
				state_name = "fade"
				_t = 0.0
		"fade":
			if _t >= FADE_TIME:
				queue_free()
				return
	position = Vector2(x, 0.0) * U
	queue_redraw()

## น้ำแข็งงอกใส่มอนที่ยืนตรงจุดเสก
func _hit_rise() -> void:
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	for e in get_tree().get_nodes_in_group("monsters"):
		if absf(e.pos.x - _far_x) > RISE_REACH or e.pos.y > 2.0:
			continue
		var hp_before: float = e.hp
		if e.take_hit(hit, -dir):
			rise_hits += 1
			hero.count_hit(hp_before - e.hp, hit)

func _grab() -> void:
	var hit := {"type": "flinch", "dmg": dmg, "kb": 0.0}
	for e in get_tree().get_nodes_in_group("monsters"):
		if e in grabbed or absf(e.pos.x - x) > GRAB_R or e.pos.y > 2.0:
			continue
		var hp_before: float = e.hp
		if e.take_hit(hit, -dir):
			grabbed.append(e)
			hero.count_hit(hp_before - e.hp, hit)

## มอนที่โดนเศษน้ำแข็งถูกดึงตามมา
func _drag() -> void:
	for e in grabbed:
		if not is_instance_valid(e) or e.is_invulnerable():
			continue
		e.pos.x = x + dir * 0.3
		e.vel.x = 0.0
		if e.state == "flinch":
			e.state_t = maxf(e.state_t, HOLD_STUN)

func _draw() -> void:
	match state_name:
		"rise":
			_draw_spikes(1.0 - pow(1.0 - minf(_t / RISE_TIME, 1.0), 2.0))
		"hold":
			_draw_spikes(1.0)
		"slide":
			_draw_shards(1.0)
		"fade":
			_draw_shards(1.0 - _t / FADE_TIME)

## ก้อนน้ำแข็งแหลมสามยอดงอกจากพื้น
func _draw_spikes(grow: float) -> void:
	var colors: Array = CombatData.FLAME["ice"]
	for s in [[-34.0, SIDE_K], [34.0, SIDE_K], [0.0, 1.0]]:
		var cx := float(s[0])
		var k := float(s[1])
		var high := SPIKE_H * k * grow
		var pts := PackedVector2Array([Vector2(cx - SPIKE_W * k, 0.0), Vector2(cx - SPIKE_W * 0.3 * k, -high * 0.75), Vector2(cx, -high), Vector2(cx + SPIKE_W * 0.45 * k, -high * 0.62), Vector2(cx + SPIKE_W * k, 0.0)])
		Sketch.hatch(self, pts, colors[1])
		draw_line(Vector2(cx, -8.0 * grow), Vector2(cx, -high * 0.85), colors[0], 3.0, true)
		pts.append(pts[0])
		SoftDraw.sketch_line(self, pts, 2330 + int(k * 10.0), 3.0, 0.4)

## เศษน้ำแข็งเล็กๆ กระจายรอบหน้าคลื่น กระเด้งไถลไปตามพื้น
func _draw_shards(k: float) -> void:
	if k <= 0.0:
		return
	var colors: Array = CombatData.FLAME["ice"]
	for i in SHARDS:
		var off := lerpf(-1.0, 1.0, float(i) / (SHARDS - 1)) * SHARD_SPREAD
		var hop := absf(sin(_clock * 11.0 + float(i) * 1.7)) * SHARD_HOP * (1.0 - absf(off) / SHARD_SPREAD * 0.6)
		var c := Vector2(off, -hop - SHARD_SIZE * 0.5)
		var size := SHARD_SIZE * (0.65 + 0.45 * absf(sin(float(i) * 2.9))) * k
		var turn := _clock * 7.0 * (1.0 if i % 2 == 0 else -1.0) + float(i)
		var pts := PackedVector2Array()
		for n in 3:
			var a := turn + TAU * n / 3.0
			pts.append(c + Vector2(cos(a), sin(a)) * size)
		Sketch.hatch(self, pts, colors[1])
		pts.append(pts[0])
		SoftDraw.sketch_line(self, pts, 2340 + i, 2.2, 0.2)
