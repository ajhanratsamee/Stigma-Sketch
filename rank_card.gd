class_name RankCard
extends Node2D
## การ์ดผลการเล่นตอนผ่านดันเจี้ยน โทนนุ่ม พื้นครีม เส้นน้ำตาลเทา ตัวแรงก์ใหญ่สีชมพูฝุ่นเด้งเบาๆ
## แถว เวลา / คอมโบสูงสุด / โดนตี / คะแนน และรางวัล EXP (EXP เคลียร์ x แรงก์ x โบนัสดัน)

const CARD := Vector2(700.0, 440.0)
const GRADE_COL := {"D": Color(0.62, 0.6, 0.6), "C": Color(0.55, 0.66, 0.6), "B": Color(0.5, 0.64, 0.78),
	"A": Color(0.62, 0.55, 0.8), "S": Color(0.86, 0.6, 0.45), "SS": Color(0.88, 0.55, 0.55), "SSS": Color(0.9, 0.68, 0.35)}

var info: Dictionary = {}       # ผลจาก DungeonRank.compute
var reward: Dictionary = {}     # {exp, base, bonus}
var new_best := false
var _t := 0.0

func _ready() -> void:
	z_index = 75

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()

func card_rect() -> Rect2:
	var v := get_viewport_rect().size
	return Rect2((v - CARD) * 0.5 + Vector2(0.0, 10.0), CARD)

func _txt(at: Vector2, word: String, size: int, color: Color, center := true) -> void:
	var font := Sketch.font()
	var w := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size).x
	draw_string(font, at + Vector2(-w * 0.5 if center else 0.0, float(size) * 0.36), word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _draw() -> void:
	var v := get_viewport_rect().size
	var a := clampf(_t / 0.3, 0.0, 1.0)
	draw_rect(Rect2(Vector2.ZERO, v), Color(UiStyle.SOFT_BG, 0.45 * a))
	var r := card_rect()
	var rise := (1.0 - a) * 30.0
	r.position.y += rise
	UiStyle.fill(self, Rect2(r.position + Vector2(4.0, 6.0), r.size), Color(0.0, 0.0, 0.0, 0.08 * a), 26.0)
	UiStyle.fill(self, r, Color(UiStyle.SOFT_CARD, a), 26.0)
	UiStyle.frame(self, r, 1501, UiStyle.SOFT_LINE, Color(UiStyle.SOFT_INK, a), 26.0)
	_txt(Vector2(r.get_center().x, r.position.y + 42.0), "ผ่านดันเจี้ยน!", 34, Color(UiStyle.SOFT_TEXT, a))
	# ตัวแรงก์ใหญ่ เด้งเข้าแล้วโยกเบาๆ
	var g := str(info.get("grade", "D"))
	var col: Color = GRADE_COL.get(g, UiStyle.SOFT_ACCENT)
	var gt := clampf((_t - 0.25) / 0.35, 0.0, 1.0)
	var pop := 1.0 + 0.25 * sin(gt * PI) + 0.03 * sin(_t * 3.0)
	var gc := Vector2(r.position.x + 170.0, r.position.y + 215.0)
	if gt > 0.0:
		draw_circle(gc, 104.0 * pop, Color(col, 0.18 * gt))
		draw_circle(gc, 92.0 * pop, Color(1.0, 0.99, 0.97, gt))
		draw_arc(gc, 92.0 * pop, 0.0, TAU, 48, Color(col, gt), 5.0, true)
		draw_set_transform(gc, 0.0, Vector2.ONE * pop)
		var size := 96 if g.length() == 1 else (78 if g.length() == 2 else 60)
		_txt(Vector2.ZERO, g, size, Color(col.darkened(0.15), gt))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		_txt(gc + Vector2(0.0, 118.0), "แรงก์", 22, Color(UiStyle.SOFT_INK, gt))
		if new_best:
			UiStyle.fill(self, Rect2(gc + Vector2(-70.0, -136.0), Vector2(140.0, 32.0)), Color(UiStyle.SOFT_PRIMARY, gt), 16.0)
			_txt(gc + Vector2(0.0, -120.0), "สถิติใหม่!", 20, Color(UiStyle.SOFT_TEXT, gt))
	# แถวรายละเอียด
	var x0 := r.position.x + 320.0
	var y := r.position.y + 100.0
	var t := float(info.get("time", 0.0))
	var rows := [
		["เวลา", "%d:%02d" % [int(t) / 60, int(t) % 60], "(มาตรฐาน %d:%02d)" % [int(info.get("par", 0.0)) / 60, int(info.get("par", 0.0)) % 60]],
		["คอมโบสูงสุด", "%d" % int(info.get("combo", 0)), ""],
		["โดนตี", "%d ครั้ง" % int(info.get("hits", 0)), ""],
		["คะแนน", "%d" % int(round(float(info.get("score", 0.0)))), "x%.2f" % float(info.get("mult", 1.0))],
	]
	for i in rows.size():
		var ra := clampf((_t - 0.15 - 0.08 * float(i)) / 0.25, 0.0, 1.0)
		_txt(Vector2(x0, y), str(rows[i][0]), 24, Color(UiStyle.SOFT_INK, ra * a), false)
		_txt(Vector2(x0 + 170.0, y), str(rows[i][1]), 26, Color(UiStyle.SOFT_TEXT, ra * a), false)
		if str(rows[i][2]) != "":
			_txt(Vector2(x0 + 260.0, y), str(rows[i][2]), 19, Color(UiStyle.SOFT_INK, ra * a), false)
		y += 46.0
	# รางวัล
	var ry := r.position.y + 310.0
	UiStyle.fill(self, Rect2(Vector2(x0 - 16.0, ry - 26.0), Vector2(r.end.x - x0 - 14.0, 108.0)), Color(UiStyle.SOFT_PICK, a), 18.0)
	_txt(Vector2(x0, ry), "รางวัล", 22, Color(UiStyle.SOFT_INK, a), false)
	_txt(Vector2(x0, ry + 38.0), "+%d EXP" % int(reward.get("exp", 0)), 30, Color(UiStyle.SOFT_TEXT, a), false)
	var how := "%d x แรงก์ %.2f" % [int(reward.get("base", 0)), float(info.get("mult", 1.0))]
	if float(reward.get("bonus", 1.0)) > 1.0:
		how += " x โบนัส %.1f" % float(reward.get("bonus", 1.0))
	_txt(Vector2(x0, ry + 70.0), how, 19, Color(UiStyle.SOFT_INK, a), false)
