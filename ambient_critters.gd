class_name AmbientCritters
extends Node2D
## สัตว์ตัวเล็กกับบรรยากาศในฉาก: ผีเสื้อ หิ่งห้อย กลีบดอกไม้ ปลาว่ายเป็นฝูง ใบไม้ร่วง
## อยู่ในโลก (เลื่อนตามกล้องแบบเดียวกับตัวละคร) วาดหลังตัวละคร ตัวน้อย เบาเครื่อง โหมดลื่นเหลือน้อยลง

const COUNT := {"butterfly": 7, "firefly": 14, "petal": 12, "fish": 12, "leaf": 9}
const SMOOTH_K := 0.35
const MARGIN := 220.0
const INK := Color(0.42, 0.36, 0.33, 0.75)

## ธีมดันเจี้ยน -> ชนิด (ไม่อยู่ในนี้คือไม่มี เช่น หิมะ รถไฟ ที่มีของขยับอยู่แล้ว)
const THEME_KIND := {
	"meadow": "butterfly", "cattree": "butterfly", "cloudgarden": "butterfly", "waterfall": "butterfly",
	"oasis": "butterfly", "cloudisle": "butterfly",
	"metro": "firefly", "cellar": "firefly", "mushcave": "firefly", "sewer": "firefly", "mansion": "firefly",
	"cells": "firefly", "mine": "firefly", "crystal": "firefly", "tower": "firefly", "nightmarket": "firefly",
	"library": "firefly", "seacave": "firefly",
	"bamboo": "petal", "skytemple": "petal", "duskroof": "petal", "candy": "petal",
	"underwater": "fish", "shipwreck": "fish", "pier": "fish", "canal": "fish",
	"forest": "leaf", "ruins": "leaf",
}

var kind := ""
var page: Node
var _p: Array = []          # [ตำแหน่ง ความเร็ว เฟส สี]
var _t := 0.0
var _rng := RandomNumberGenerator.new()

## เลือกชนิดตามหน้า: ดันเจี้ยนดูธีม เมืองดูชั้น ห้องฝึกเป็นผีเสื้อ
static func kind_for(p: Node) -> String:
	if p is DungeonPage:
		return str(THEME_KIND.get(str((p as DungeonPage).data.get("theme", "")), ""))
	if p is TownPage:
		var tp := p as TownPage
		var deco := str(tp.floor_data().get("deco", "houses"))
		if deco in ["cellar", "kitchen", "hall", "library", "throne"]:
			return "firefly"
		if deco == "garden":
			return "butterfly"
		if tp.style == "underground":
			return "firefly"
		return "petal" if WalkPage.current_town % 3 == 1 else "butterfly"
	return "butterfly"

func _ready() -> void:
	_rng.seed = 4242
	z_index = 0
	if kind == "":
		visible = false
		set_process(false)
		return
	var n := int(COUNT.get(kind, 8))
	if GameSettings.is_smooth():
		n = maxi(2, int(float(n) * SMOOTH_K))
	var r := _view_rect()
	for i in n:
		_p.append(_spawn(r, true))

## กรอบที่มองเห็นในพิกัดโลก
func _view_rect() -> Rect2:
	var inv := get_global_transform_with_canvas().affine_inverse()
	var vs := get_viewport_rect().size
	var a := inv * Vector2.ZERO
	var b := inv * vs
	return Rect2(a, b - a).abs()

func _spawn(r: Rect2, anywhere: bool) -> Array:
	var x := _rng.randf_range(r.position.x, r.end.x)
	var y := 0.0
	var v := Vector2.ZERO
	var col := Color.WHITE
	match kind:
		"butterfly":
			y = -_rng.randf_range(60.0, 420.0)
			v = Vector2(_rng.randf_range(-40.0, 40.0), 0.0)
			col = [Color(1.0, 0.82, 0.86), Color(0.86, 0.9, 1.0), Color(1.0, 0.94, 0.7), Color(0.88, 0.96, 0.84)][_rng.randi() % 4]
		"firefly":
			y = _rng.randf_range(r.position.y, -20.0)
			v = Vector2(_rng.randf_range(-14.0, 14.0), _rng.randf_range(-10.0, 10.0))
			col = Color(1.0, 0.9, 0.55)
		"petal":
			y = r.position.y - (0.0 if not anywhere else -_rng.randf_range(0.0, r.size.y))
			v = Vector2(_rng.randf_range(30.0, 60.0), _rng.randf_range(35.0, 60.0))
			col = [Color(1.0, 0.8, 0.86), Color(1.0, 0.88, 0.9), Color(0.98, 0.74, 0.82)][_rng.randi() % 3]
		"leaf":
			y = r.position.y - (0.0 if not anywhere else -_rng.randf_range(0.0, r.size.y))
			v = Vector2(_rng.randf_range(10.0, 40.0), _rng.randf_range(40.0, 70.0))
			col = [Color(0.72, 0.84, 0.56), Color(0.95, 0.76, 0.48), Color(0.86, 0.66, 0.46)][_rng.randi() % 3]
		"fish":
			y = -_rng.randf_range(120.0, 560.0)
			var dir := 1.0 if _rng.randf() < 0.5 else -1.0
			v = Vector2(dir * _rng.randf_range(50.0, 80.0), 0.0)
			col = [Color(0.66, 0.82, 0.95), Color(1.0, 0.76, 0.56), Color(0.8, 0.88, 0.98)][_rng.randi() % 3]
	if not anywhere and (kind == "butterfly" or kind == "fish" or kind == "firefly"):
		# เกิดใหม่ที่ขอบจอด้านที่ว่าง
		x = r.position.x - 60.0 if _rng.randf() < 0.5 else r.end.x + 60.0
	return [Vector2(x, y), v, _rng.randf() * TAU, col]

func _process(delta: float) -> void:
	# ระหว่าง HYPER ซ่อน ให้จอเป็นฉาก HYPER ล้วน
	var in_hyper: bool = page != null and is_instance_valid(page) and page.get("hyper") != null and is_instance_valid(page.get("hyper"))
	visible = not in_hyper
	if in_hyper:
		return
	_t += delta
	var r := _view_rect().grow(MARGIN)
	for i in _p.size():
		var q: Array = _p[i]
		var pos: Vector2 = q[0]
		var v: Vector2 = q[1]
		var ph: float = q[2]
		match kind:
			"butterfly":
				pos += Vector2(v.x, sin(_t * 1.6 + ph) * 26.0) * delta
				if _rng.randf() < delta * 0.4:
					v.x = _rng.randf_range(-40.0, 40.0)
				pos.y = clampf(pos.y, -460.0, -40.0)
			"firefly":
				pos += (v + Vector2(sin(_t * 0.7 + ph) * 10.0, cos(_t * 0.9 + ph) * 8.0)) * delta
			"petal", "leaf":
				pos += Vector2(v.x + sin(_t * 1.4 + ph) * 30.0, v.y) * delta
			"fish":
				pos += Vector2(v.x, sin(_t * 1.2 + ph) * 10.0) * delta
		q[0] = pos
		q[1] = v
		if not r.has_point(pos):
			_p[i] = _spawn(_view_rect(), false)
	queue_redraw()

func _draw() -> void:
	for q in _p:
		var pos: Vector2 = q[0]
		var v: Vector2 = q[1]
		var ph: float = q[2]
		var col: Color = q[3]
		match kind:
			"butterfly":
				var flap := 0.35 + 0.65 * absf(sin(_t * 9.0 + ph))
				var f := signf(v.x) if v.x != 0.0 else 1.0
				for s in [-1.0, 1.0]:
					draw_set_transform(pos + Vector2(s * 10.0 * flap, -4.0), 0.0, Vector2(flap, 1.0))
					draw_circle(Vector2.ZERO, 13.0, col)
					draw_arc(Vector2.ZERO, 13.0, 0.0, TAU, 16, INK, 2.0, true)
					draw_set_transform(pos + Vector2(s * 7.0 * flap, 10.0), 0.0, Vector2(flap, 1.0))
					draw_circle(Vector2.ZERO, 9.0, col.lightened(0.15))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				draw_line(pos + Vector2(0.0, -11.0), pos + Vector2(0.0, 14.0), INK, 4.0, true)
				draw_line(pos + Vector2(0.0, -11.0), pos + Vector2(f * 7.0, -21.0), INK, 2.0, true)
			"firefly":
				var a := 0.35 + 0.65 * (0.5 + 0.5 * sin(_t * 2.2 + ph * 3.0))
				draw_circle(pos, 30.0, Color(col, 0.14 * a))
				draw_circle(pos, 14.0, Color(col, 0.35 * a))
				draw_circle(pos, 6.0, Color(1.0, 0.98, 0.85, 0.95 * a))
			"petal":
				draw_set_transform(pos, _t * 1.8 + ph, Vector2(1.0, 0.55 + 0.35 * sin(_t * 3.0 + ph)))
				draw_circle(Vector2.ZERO, 11.0, col)
				draw_circle(Vector2(-3.0, -2.5), 3.2, Color(1.0, 1.0, 1.0, 0.5))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			"leaf":
				draw_set_transform(pos, _t * 1.3 + ph, Vector2(1.0, 0.5))
				draw_circle(Vector2.ZERO, 13.0, col)
				draw_line(Vector2(-12.0, 0.0), Vector2(12.0, 0.0), Color(INK, 0.45), 2.0, true)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			"fish":
				var f2 := signf(v.x)
				draw_set_transform(pos, 0.0, Vector2(f2, 1.0))
				draw_colored_polygon(PackedVector2Array([Vector2(-18.0, 0.0), Vector2(-36.0, -12.0 + sin(_t * 8.0 + ph) * 3.0), Vector2(-36.0, 12.0 + sin(_t * 8.0 + ph) * 3.0)]), col.darkened(0.08))
				draw_set_transform(pos, 0.0, Vector2(f2 * 1.0, 0.6))
				draw_circle(Vector2.ZERO, 22.0, col)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				draw_circle(pos + Vector2(f2 * 11.0, -3.0), 3.0, INK)
