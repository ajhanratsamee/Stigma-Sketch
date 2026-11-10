class_name StartBanner
extends Node2D
## ป้าย START หลังท่าเปิดดันจบ: แถบเฉียงสองเส้นพาดตัดกลางจอ มีคำว่า START ตรงกลาง โทนนุ่ม แล้วจางหาย
## ไม่ล็อกปุ่ม เกมเริ่มทันทีที่ป้ายขึ้น

const LIFE := 1.6
const IN_T := 0.28          # แถบพุ่งเข้า
const OUT_T := 0.4          # ช่วงท้ายจางออก
const BAND_H := 92.0
const TILT := -0.12         # เอียงแถบ (เรเดียน)
const TEXT_SIZE := 78

var _t := 0.0
var _view := Vector2.ZERO

static func show_on(page: Node) -> void:
	if page == null or not is_instance_valid(page):
		return
	var b := StartBanner.new()
	b.z_index = 60
	page.add_child(b)

func _ready() -> void:
	_view = get_viewport_rect().size
	Snd.play("confirm", -4.0)

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	queue_redraw()

func _ease(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return 1.0 - pow(1.0 - x, 3.0)

func _draw() -> void:
	var c := _view * 0.5 + Vector2(0.0, -40.0)
	var a := 1.0 - clampf((_t - (LIFE - OUT_T)) / OUT_T, 0.0, 1.0)
	var k := _ease(_t / IN_T)
	var w := _view.x * 1.4
	# แถบหลังสีชมพูฝุ่น หนา เอียงมากกว่า พุ่งจากซ้าย
	var off1 := lerpf(-w, 0.0, k)
	draw_set_transform(c, TILT - 0.07, Vector2.ONE)
	draw_rect(Rect2(Vector2(off1 - w * 0.5, -BAND_H * 0.62), Vector2(w, BAND_H * 1.24)), Color(UiStyle.SOFT_PRIMARY, 0.9 * a))
	draw_line(Vector2(off1 - w * 0.5, -BAND_H * 0.62), Vector2(off1 + w * 0.5, -BAND_H * 0.62), Color(UiStyle.SOFT_ACCENT, a), 3.0, true)
	draw_line(Vector2(off1 - w * 0.5, BAND_H * 0.62), Vector2(off1 + w * 0.5, BAND_H * 0.62), Color(UiStyle.SOFT_ACCENT, a), 3.0, true)
	# แถบหน้าสีครีม บางกว่า เอียงน้อยกว่า พุ่งจากขวา ตัดผ่านแถบชมพู
	var off2 := lerpf(w, 0.0, _ease((_t - 0.06) / IN_T))
	draw_set_transform(c, TILT + 0.03, Vector2.ONE)
	draw_rect(Rect2(Vector2(off2 - w * 0.5, -BAND_H * 0.38), Vector2(w, BAND_H * 0.76)), Color(UiStyle.SOFT_CARD, 0.96 * a))
	draw_line(Vector2(off2 - w * 0.5, -BAND_H * 0.38), Vector2(off2 + w * 0.5, -BAND_H * 0.38), Color(UiStyle.SOFT_INK, 0.6 * a), 2.0, true)
	draw_line(Vector2(off2 - w * 0.5, BAND_H * 0.38), Vector2(off2 + w * 0.5, BAND_H * 0.38), Color(UiStyle.SOFT_INK, 0.6 * a), 2.0, true)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# START ตรงกลาง เด้งเบาๆ ตอนแถบเข้าที่
	var pop := _ease((_t - IN_T * 0.7) / 0.22)
	if pop <= 0.0:
		return
	var s := 0.7 + 0.3 * pop + 0.06 * sin(clampf((_t - IN_T) / 0.3, 0.0, 1.0) * PI)
	var font := Sketch.font()
	var word := "START"
	var tw := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TEXT_SIZE).x
	draw_set_transform(c, TILT + 0.03, Vector2.ONE * s)
	var at := Vector2(-tw * 0.5, float(TEXT_SIZE) * 0.36)
	draw_string_outline(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TEXT_SIZE, 12, Color(UiStyle.SOFT_CARD, a * pop))
	draw_string(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TEXT_SIZE, Color(UiStyle.SOFT_TEXT, a * pop))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
