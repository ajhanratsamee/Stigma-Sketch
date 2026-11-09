class_name CatEruption
extends Node2D
## คลื่นพลังแดงทะลุขึ้นจากดินของสกิล 15.1 และ 20.1 ปะทุเป็นลูกๆ ไล่ไปข้างหน้า
## แต่ละลูกเป็นเปลวพลังแดงเตี้ยๆ หยักๆ พร้อมรอยแตกและเศษดินกระเด็น วางที่พื้น y 0

const BURSTS := 5
const STEP := 72.0           # ระยะห่างแต่ละลูก
const GAP := 0.08            # เวลาห่างแต่ละลูก
const RISE := 0.12
const HOLD := 0.18
const FADE := 0.3
const HEIGHT := 105.0
const WIDTH := 34.0
const DMG := 10.0
const HIT_HALF := 55.0
const DARK := Color(0.45, 0.02, 0.04, 0.9)
const RED := Color(0.9, 0.1, 0.1, 0.92)
const HOT := Color(1.0, 0.55, 0.3)
const CRACK := Color(0.3, 0.12, 0.08)
const DIRT := Color(0.5, 0.36, 0.26)

var dir := 1.0
var bursts := BURSTS              # จำนวนลูกที่ปะทุ
var linger := 0.0                # ค้างลุกไหม้ต่ออีกกี่วินาที ทำดาเมจเป็นจังหวะ
var _burn_hit := 0.0
var dark := false               # เลือดดำแดงของ DARK KNIGHT
const DARK_DEEP := Color(0.18, 0.0, 0.03, 0.92)
const DARK_RED := Color(0.55, 0.02, 0.08, 0.92)
const DARK_HOT := Color(0.95, 0.25, 0.3)
var fire := false               # คลื่นไฟของ MAGIC KNIGHT สีส้มเหลือง ติดไฟ
const FIRE_DARK := Color(0.85, 0.25, 0.05, 0.9)
const FIRE_MID := Color(1.0, 0.55, 0.1, 0.92)
const FIRE_HOT := Color(1.0, 0.92, 0.5)
var hitter: Callable
var _t := 0.0
var _hit := {}
var _fired := []
var _bits: Array = []        # [ตำแหน่ง ความเร็ว ขนาด]

func _process(delta: float) -> void:
	_t += delta
	for i in bursts:
		if i in _fired or _t < float(i) * GAP:
			continue
		_fired.append(i)
		var x := float(i) * STEP * dir
		if hitter.is_valid():
			var extra := {"type": "launch", "vy": 6.0}
			if fire:
				extra = {"kb": 1.5, "stun": 0.5, "magic": true, "burn": "fire"}
			hitter.call(position.x + x, HIT_HALF, DMG, dir, _hit, extra)
		for n in 9:
			_bits.append([Vector2(x + randf_range(-20.0, 20.0), -4.0), Vector2(randf_range(-170.0, 170.0), randf_range(-620.0, -300.0)), randf_range(3.0, 8.0)])
	for b in _bits:
		b[1] = (b[1] as Vector2) + Vector2(0.0, 1200.0) * delta
		b[0] = (b[0] as Vector2) + (b[1] as Vector2) * delta
	if linger > 0.0 and _t > float(bursts) * GAP and _t < float(bursts) * GAP + linger and hitter.is_valid():
		_burn_hit -= delta
		if _burn_hit <= 0.0:
			_burn_hit = 0.5
			var span := float(bursts - 1) * STEP
			hitter.call(position.x + dir * span * 0.5, span * 0.5 + HIT_HALF, DMG * 0.5, dir, null, {"kb": 0.3, "stun": 0.3, "magic": true, "burn": "fire"} if fire else {"kb": 0.3, "stun": 0.3})
	if _t > float(bursts) * GAP + RISE + HOLD + FADE + linger:
		queue_free()
	queue_redraw()

## เปลวพลังหยักๆ ฐานกว้างที่พื้น ปลายแหลมหลายยอด
func _spike(x: float, h: float, w: float, seed_f: float) -> PackedVector2Array:
	var pts := PackedVector2Array([Vector2(x - w, 0.0)])
	var tips := 3
	for i in tips * 2 + 1:
		var k := float(i) / float(tips * 2)
		var px := x - w + k * w * 2.0
		var high := i % 2 == 1
		var top := h * (1.0 - absf(k - 0.5) * 1.1) * (1.0 if high else 0.78)
		top *= 0.85 + 0.15 * sin(_t * 30.0 + seed_f + float(i) * 1.9)
		pts.append(Vector2(px, -top))
	pts.append(Vector2(x + w, 0.0))
	return pts

func _draw() -> void:
	for i in _fired:
		var age := _t - float(i) * GAP
		var x := float(i) * STEP * dir
		var grow := clampf(age / RISE, 0.0, 1.0)
		var fade := clampf(1.0 - (age - RISE - HOLD - linger) / FADE, 0.0, 1.0)
		# ภาพใหญ่กว่าระยะโดน 1.5 เท่า เด้งตอนผุด
		var h := HEIGHT * 1.55 * grow * CatGlow.pop(age, 0.2) * (0.85 + 0.15 * float((i * 7) % 3)) * (0.6 + 0.4 * fade)
		var w := WIDTH * 1.45
		draw_line(Vector2(x - w * 1.4, 2.0), Vector2(x + w * 1.4, 0.0), Color(CRACK, fade), 5.0, true)
		if fade <= 0.0:
			continue
		var c1 := FIRE_DARK if fire else (DARK_DEEP if dark else DARK)
		var c2 := FIRE_MID if fire else (DARK_RED if dark else RED)
		var c3 := FIRE_HOT if fire else (DARK_HOT if dark else HOT)
		# แสงฟุ้งหลังเปลว พื้นเรือง ลำแสงพุ่งขึ้น
		CatGlow.glow_oval(self, Vector2(x, -2.0), w * 2.6, 26.0, Color(c3, 0.8 * fade), 3)
		CatGlow.halo(self, Vector2(x, -h * 0.45), h * 0.75, Color(c2, fade), 3)
		SoftDraw.poly(self, PackedVector2Array([Vector2(x - w * 0.5, 0.0), Vector2(x - w * 0.12, -h * 1.7), Vector2(x + w * 0.12, -h * 1.7), Vector2(x + w * 0.5, 0.0)]), Color(c3, 0.25 * fade))
		SoftDraw.poly(self, _spike(x, h * 1.12, w * 1.25, float(i) + 4.0), Color(c1, c1.a * 0.35 * fade))
		SoftDraw.poly(self, _spike(x, h, w, float(i)), Color(c1, c1.a * fade))
		SoftDraw.poly(self, _spike(x, h * 0.78, w * 0.72, float(i) + 1.3), Color(c2, c2.a * fade))
		SoftDraw.poly(self, _spike(x, h * 0.5, w * 0.42, float(i) + 2.6), Color(c3, fade))
		CatGlow.star4(self, Vector2(x, -h * 1.02), 18.0 * fade, Color(1.0, 0.97, 0.9, fade))
		CatGlow.embers(self, Vector2(x, -h * 0.3), w * 1.2, h * 1.4, 6, _t, Color(c3, 0.85 * fade), float(i), 5.0)
		# หูแมวบนเปลว หน้าเหมียวกลางเปลว
		if h > 30.0:
			CatGlow.ears(self, Vector2(x, -h * 0.62), w * 0.9, Color(c2, c2.a * fade), Color(c3, fade))
			CatGlow.face(self, Vector2(x, -h * 0.3), w * 0.55, Color(c1.darkened(0.4), fade))
		CatGlow.paw(self, Vector2(x, 2.0), 14.0, Color(CRACK, 0.6 * fade), PI, 0.35)
	for b in _bits:
		if (b[0] as Vector2).y < 0.0:
			draw_circle(b[0], float(b[2]) * 1.3, DIRT)
