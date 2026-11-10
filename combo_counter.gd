class_name ComboCounter
extends Node2D
## ตัวนับคอมโบนุ่มๆ ขึ้นเมื่อตีโดนต่อเนื่อง 3 ฮิตขึ้นไป ป้ายกลมสีพาสเทลด้านขวากลางจอ เด้งเบาๆ ทุกฮิต
## ไม่ตีต่อ 1.5 วิแล้วจางหาย  ระหว่าง HYPER ซ่อน

const SHOW_FROM := 3
const GAP_MS := 1500
const FADE := 0.35
const CARD := Color(1.0, 0.97, 0.93, 0.92)
const ACCENT := Color(0.93, 0.6, 0.52)
const INK := Color(0.42, 0.36, 0.33)

var page: Node
var _shown := 0
var _pop := 0.0
var _alpha := 0.0

func _ready() -> void:
	z_index = 44

func _process(delta: float) -> void:
	var now := Time.get_ticks_msec()
	var n := Monster.chain if now - Monster.chain_ms <= GAP_MS else 0
	var want := n >= SHOW_FROM and not _in_hyper()
	if n != _shown and n >= SHOW_FROM:
		_pop = 1.0
	if n >= SHOW_FROM:
		_shown = n
	_pop = maxf(_pop - delta * 5.0, 0.0)
	_alpha = move_toward(_alpha, 1.0 if want else 0.0, delta / FADE)
	if _alpha > 0.0 or want:
		queue_redraw()

func _in_hyper() -> bool:
	return page != null and is_instance_valid(page) and page.get("hyper") != null and is_instance_valid(page.get("hyper"))

func _draw() -> void:
	if _alpha <= 0.0 or _shown < SHOW_FROM:
		return
	var v := get_viewport_rect().size
	var c := Vector2(v.x - 250.0, v.y * 0.36)
	var k := 1.0 + 0.18 * sin(_pop * PI) * _pop
	draw_set_transform(c, 0.0, Vector2.ONE * k)
	var font := Sketch.font()
	var num := str(_shown)
	var nw := font.get_string_size(num, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 44).x
	var word := "คอมโบ"
	var ww := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20).x
	var w := maxf(nw, ww) + 46.0
	var r := Rect2(Vector2(-w * 0.5, -40.0), Vector2(w, 80.0))
	UiStyle.fill(self, Rect2(r.position + Vector2(2.0, 3.0), r.size), Color(0.0, 0.0, 0.0, 0.07 * _alpha), 26.0)
	UiStyle.fill(self, r, Color(CARD, CARD.a * _alpha), 26.0)
	UiStyle.frame(self, r, 870, 2.4, Color(ACCENT, _alpha), 26.0)
	draw_string(font, Vector2(-nw * 0.5, 10.0), num, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 44, Color(ACCENT.darkened(0.15), _alpha))
	draw_string(font, Vector2(-ww * 0.5, 32.0), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20, Color(INK, _alpha))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
