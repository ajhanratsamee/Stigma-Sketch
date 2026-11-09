class_name StatBars
extends Node2D
## หลอดเลือดกับหลอดมานา มุมซ้ายบน อยู่ในการ์ดพื้นกระดาษขอบหมึก ไม่กลืนกับฉาก ดูชัดไม่ลายตา
## ใต้การ์ดมีไอคอนบัพ (ขอบเขียว) และดีบัพ (ขอบแดง) พร้อมวินาทีที่เหลือ

const AT := Vector2(96.0, 46.0)          # การ์ดเลือดเล็ก อยู่ขวาวงเลเวลมุมซ้ายบน ชื่อตัวละครอยู่เหนือการ์ด
const SIZE := Vector2(270.0, 24.0)
const GAP := 6.0
const CARD_PAD := Vector2(10.0, 8.0)
const LV_AT := Vector2(46.0, 50.0)       # วงเลเวลมุมซ้ายบน
const LV_R := 25.0
const LINE := 2.4
const SCRIBBLE := 1.0
const TEXT_SIZE := 19
const TEXT_COLOR := Color.WHITE
const TEXT_SHADOW := Color(0.3, 0.2, 0.2, 0.4)
const HP_COLOR := Color(0.87, 0.39, 0.39)      # แดงนุ่ม ยังเห็นชัดว่าเลือด
const MP_COLOR := Color(0.4, 0.56, 0.86)       # ฟ้านุ่ม
const CARD := Color(0.975, 0.96, 0.94)
const ICON_R := 22.0
const ICON_GAP := 12.0
const BUFF_RING := Color(0.42, 0.66, 0.46)
const DEBUFF_RING := Color(0.8, 0.42, 0.4)
## [ตัวแปรเวลาใน Hero ชื่อสั้น สีไอคอน บัพหรือไม่]
const EFFECTS := [
	["plain_sa_t", "SA", Color(1.0, 0.55, 0.45), true],
	["plain_atk_t", "ATK", Color(1.0, 0.8, 0.35), true],
	["plain_boost_t", "ดาเมจ", Color(0.95, 0.4, 0.4), true],
	["plain_fire_t", "ไฟ", Color(1.0, 0.6, 0.25), true],
	["plain_blood_t", "เลือด", Color(0.75, 0.15, 0.2), true],
	["plain_aura_t", "ออร่า", Color(1.0, 0.6, 0.7), true],
	["plain_guard_t", "การ์ด", Color(0.5, 0.65, 0.95), true],
	["plain_mana_t", "MP+", Color(0.45, 0.6, 1.0), true],
	["invuln_t", "อมตะ", Color(1.0, 0.95, 0.6), true],
	["ranged_guard_t", "กันไกล", Color(0.7, 0.9, 0.8), true],
	["melee_guard_t", "กันใกล้", Color(1.0, 0.75, 0.9), true],
	["susi_counter_t", "สะท้อน", Color(0.85, 0.7, 1.0), true],
	["susi_save_t", "ประหยัด", Color(0.6, 0.85, 1.0), true],
	["susi_mana_t", "MP+", Color(0.45, 0.6, 1.0), true],
]

var hero: Hero
var level := 1
var exp_ratio := 0.0              # EXP ในเลเวลนี้ 0 ถึง 1 วาดเป็นวงรอบวงกลมเลเวล
var _shown := ""
var _notice := ""
var _notice_t := 0.0

var guide: GuideHud

## ตัวช่วยผู้เล่นใหม่ (เป้าหมาย ลูกศรชี้ทาง คำใบ้ครั้งแรก) ติดไปกับหน้าที่มีแถบเลือด
func _ready() -> void:
	# เลื่อนการ์ดเลือดพ้นรูกล้อง / ขอบโค้ง
	position.x = UiStyle.safe_side()
	var p := get_parent()
	if p != null and not p.is_node_ready():
		p.ready.connect(_add_guide, CONNECT_ONE_SHOT)
	else:
		_add_guide()

func _add_guide() -> void:
	var page := get_parent() as WalkPage
	if page == null or not GuideHud.wanted():
		return
	guide = GuideHud.new()
	guide.page = page
	page.add_child(guide)
	if page.pad != null:
		page.pad.captions = WalkPage.current_town <= 1 and WalkPage.chosen_level <= 15

## ข้อความสั้นใต้การ์ด เช่น เลเวลไม่ถึง
func notice(text: String) -> void:
	_notice = text
	_notice_t = 1.6
	queue_redraw()

func hp_text() -> String:
	return "%d/%d" % [ceili(hero.hp), ceili(hero.hp_max())]

func mp_text() -> String:
	return "%d/%d" % [ceili(hero.mp), ceili(hero.mp_max())]

## บัพดีบัพที่ติดอยู่ [ชื่อ สี บัพ วินาทีที่เหลือ]
func effects() -> Array:
	var out := []
	if hero == null:
		return out
	for e in EFFECTS:
		var left = hero.get(e[0])
		if left != null and float(left) > 0.05:
			out.append([e[1], e[2], e[3], float(left)])
	return out

func card_rect() -> Rect2:
	return Rect2(AT - CARD_PAD, Vector2(SIZE.x, SIZE.y * 2.0 + GAP) + CARD_PAD * 2.0)

func _process(delta: float) -> void:
	if _notice_t > 0.0:
		_notice_t = maxf(_notice_t - delta, 0.0)
		queue_redraw()
	var now := hp_text() + mp_text()
	for e in effects():
		now += "%s%d" % [e[0], ceili(e[3])]
	if now != _shown:
		_shown = now
		queue_redraw()

func _bar(at: Vector2, value: float, top: float, color: Color, word: String, seed_no: int) -> void:
	# หลอดมุมมนแบบเดียวกับ UI หน้าอื่น
	var rad := SIZE.y * 0.5
	UiStyle.fill(self, Rect2(at, SIZE), Color(0.89, 0.86, 0.83), rad)
	var ratio := clampf(value / top, 0.0, 1.0) if top > 0.0 else 0.0
	if ratio > 0.0:
		var fw := maxf(SIZE.x * ratio, SIZE.y)
		UiStyle.fill(self, Rect2(at, Vector2(fw, SIZE.y)), color, rad)
		UiStyle.fill(self, Rect2(at + Vector2(rad * 0.5, 3.0), Vector2(maxf(fw - rad, 4.0), SIZE.y * 0.28)), Color(1.0, 1.0, 1.0, 0.25), SIZE.y * 0.14)
	UiStyle.frame(self, Rect2(at, SIZE), seed_no, LINE, UiStyle.INK, rad)
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TEXT_SIZE).x
	var spot := at + Vector2((SIZE.x - w) * 0.5, SIZE.y * 0.5 + float(TEXT_SIZE) * 0.36)
	draw_string(font, spot + Vector2(1.5, 1.5), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TEXT_SIZE, TEXT_SHADOW)
	draw_string(font, spot, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TEXT_SIZE, TEXT_COLOR)

## ชื่อตัวละครกับชื่อสายบนหลอดเลือด
func _draw_title(card: Rect2) -> void:
	var w := WalkPage.chosen_weapon
	var name: String = PickPage.NAMES.get(w, "")
	if w == "azure":
		name = "CAT AZURE" if WalkPage.pair_form == "azure" else "CAT LAPIS"
	var cls := WalkPage.chosen_class if WalkPage.chosen_class != "" else "BASIC"
	var word := "%s  ·  %s" % [name, cls]
	var font := Sketch.font()
	var at := Vector2(card.position.x + 4.0, card.position.y - 7.0)
	draw_string_outline(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20, 6, Sketch.PAPER)
	draw_string(font, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 20, Sketch.INK)

func _draw() -> void:
	if hero == null:
		return
	var card := card_rect()
	_draw_title(card)
	UiStyle.fill(self, Rect2(card.position + Vector2(4.0, 5.0), card.size), Color(0.0, 0.0, 0.0, 0.12))
	UiStyle.box(self, card, 699, UiStyle.LINE, UiStyle.INK, CARD)
	_bar(AT, hero.hp, hero.hp_max(), HP_COLOR, hp_text(), 700)
	# วงกลมเลเวลเล็ก มุมซ้ายบน วง EXP รอบนอก
	var lc := LV_AT
	draw_circle(lc + Vector2(2.0, 3.0), LV_R, Color(0.0, 0.0, 0.0, 0.12))
	draw_circle(lc, LV_R, Color(1.0, 0.86, 0.45))
	var lring := Sketch.oval(lc, LV_R, LV_R, 28)
	lring.append(lring[0])
	Sketch.line(self, lring, 698, 3.0, SCRIBBLE)
	draw_arc(lc, LV_R + 6.0, 0.0, TAU, 36, Color(0.85, 0.82, 0.76), 5.0, true)
	if exp_ratio > 0.0:
		draw_arc(lc, LV_R + 6.0, -PI * 0.5, -PI * 0.5 + TAU * exp_ratio, 36, Color(0.35, 0.78, 0.4), 5.0, true)
	var lf := Sketch.font()
	var lw := lf.get_string_size("Lv", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13).x
	draw_string(lf, lc + Vector2(-lw * 0.5, -7.0), "Lv", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Sketch.INK)
	var num := str(level)
	var nw0 := lf.get_string_size(num, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22).x
	draw_string(lf, lc + Vector2(-nw0 * 0.5, 15.0), num, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22, Sketch.INK)
	if _notice_t > 0.0:
		var mw := lf.get_string_size(_notice, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 24).x
		var mp := Vector2(card.position.x, card.end.y + 90.0)
		draw_string_outline(lf, mp, _notice, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 24, 6, Color.WHITE)
		draw_string(lf, mp, _notice, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 24, Color(0.8, 0.2, 0.2, minf(_notice_t * 2.0, 1.0)))
	_bar(AT + Vector2(0.0, SIZE.y + GAP), hero.mp, hero.mp_max(), MP_COLOR, mp_text(), 701)
	# ไอคอนบัพดีบัพใต้การ์ด
	var font := Sketch.font()
	var x := card.position.x + ICON_R
	var y := card.end.y + 74.0 + ICON_R   # ใต้แถบเป้าหมาย
	for e in effects():
		var c := Vector2(x, y)
		draw_circle(c, ICON_R, Color.WHITE)
		draw_circle(c, ICON_R - 4.0, e[1])
		var ring := Sketch.oval(c, ICON_R, ICON_R, 24)
		ring.append(ring[0])
		Sketch.line(self, ring, 710, 3.0, SCRIBBLE, BUFF_RING if e[2] else DEBUFF_RING)
		var name_size := 14 if str(e[0]).length() > 3 else 16
		var nw := font.get_string_size(e[0], HORIZONTAL_ALIGNMENT_LEFT, -1.0, name_size).x
		draw_string(font, c + Vector2(-nw * 0.5, float(name_size) * 0.36), e[0], HORIZONTAL_ALIGNMENT_LEFT, -1.0, name_size, Sketch.INK)
		var t := "%ds" % ceili(e[3])
		var tw := font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16).x
		draw_string_outline(font, c + Vector2(-tw * 0.5, ICON_R + 18.0), t, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, 5, Color.WHITE)
		draw_string(font, c + Vector2(-tw * 0.5, ICON_R + 18.0), t, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, Sketch.INK)
		x += ICON_R * 2.0 + ICON_GAP
