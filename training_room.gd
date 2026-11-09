class_name TrainingRoom
extends Node2D
## ห้องฝึกกลางแจ้ง ท้องฟ้าอ่อนๆ เมฆนุ่ม ภูเขาไกลจาง แนวต้นไม้เบลอ พื้นหญ้าสีเขียวไล่เข้มลงมา ทุกอย่างเบลอนุ่ม
## ตัวละครกับเอฟเฟกต์สกิลจึงเด่น  ขอบพื้นด้านหน้าเป็นกระดาษตัดมีเส้นหมึก (PaperFront)

const SKY_TOP := Color(0.62, 0.8, 0.96)
const SKY_LOW := Color(0.9, 0.95, 0.98)
const HILL := Color(0.62, 0.78, 0.66, 0.6)
const TREE := Color(0.42, 0.66, 0.42, 0.55)
const GRASS_FAR := Color(0.6, 0.82, 0.48)
const GRASS_NEAR := Color(0.4, 0.66, 0.32)
const TUFT := Color(0.32, 0.56, 0.26, 0.35)
const FLOWER := [Color(1.0, 0.85, 0.4, 0.55), Color(1.0, 0.7, 0.8, 0.55), Color(1.0, 1.0, 1.0, 0.55)]

var ground_y := 446.0

func _draw() -> void:
	var view := get_viewport_rect().size
	var g := ground_y
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var steps := 14
	# ท้องฟ้าเผื่อด้านบน ตอนกล้องยกขึ้นห้องเลื่อนลงไม่เห็นขอบ
	draw_rect(Rect2(0.0, -WalkPage.AIR_MAX - 20.0, view.x, WalkPage.AIR_MAX + 21.0), SKY_TOP)
	for i in steps:
		var k := float(i) / float(steps - 1)
		draw_rect(Rect2(0.0, g * float(i) / float(steps), view.x, g / float(steps) + 1.0), SKY_TOP.lerp(SKY_LOW, k))
	SoftPaint.oval(self, Vector2(view.x * 0.82, g * 0.25), 70.0, 70.0, Color(1.0, 0.98, 0.85, 0.75), 0.6)
	for i in 6:
		var c := Vector2(view.x * (0.08 + 0.17 * float(i)) + rng.randf_range(-40.0, 40.0), g * rng.randf_range(0.12, 0.42))
		for n in 4:
			SoftPaint.oval(self, c + Vector2(float(n) * 42.0, rng.randf_range(-10.0, 10.0)), rng.randf_range(44.0, 70.0), rng.randf_range(20.0, 30.0), Color(1.0, 1.0, 1.0, 0.7), 0.5)
	# ภูเขาไกล
	var hills := PackedVector2Array([Vector2(-20.0, g)])
	var x := -20.0
	while x < view.x + 40.0:
		hills.append(Vector2(x, g - rng.randf_range(70.0, 140.0)))
		x += rng.randf_range(140.0, 240.0)
	hills.append(Vector2(view.x + 40.0, g))
	SoftPaint.shape(self, hills, HILL, 0.08)
	# แนวต้นไม้เบลอ
	x = -30.0
	while x < view.x + 40.0:
		var r := rng.randf_range(40.0, 70.0)
		SoftPaint.oval(self, Vector2(x, g - r * 0.7), r, r * 0.85, TREE, 0.5)
		x += rng.randf_range(50.0, 90.0)
	# พื้นหญ้าไล่สี
	var depth := view.y - g
	var bands := 10
	for i in bands:
		var k := float(i) / float(bands)
		draw_rect(Rect2(0.0, g + depth * k, view.x, depth / float(bands) + 1.0), GRASS_FAR.lerp(GRASS_NEAR, k))
	# พุ่มหญ้ากับดอกไม้เล็กๆ จางๆ
	for i in 70:
		var p := Vector2(rng.randf_range(0.0, view.x), g + depth * pow(rng.randf(), 0.8))
		var s := 6.0 + 10.0 * (p.y - g) / depth
		SoftPaint.oval(self, p, s * 1.6, s * 0.5, TUFT, 0.4)
		if i % 4 == 0:
			SoftPaint.oval(self, p + Vector2(0.0, -s * 0.4), s * 0.35, s * 0.35, FLOWER[i % 3], 0.3)
	# ชั้นหน้ากระดาษตัด ขอบพื้นหยักมีเส้นหมึก รอยเท้าแมว ไหมพรม ป้ายปลา (อยู่ริมจอ ไม่บังหุ่นซ้อม)
	PaperFront.lip(self, -30.0, view.x + 30.0, g, GRASS_FAR, 11)
	for i in 9:
		var pp := Vector2(view.x * (0.1 + 0.09 * float(i)), g + depth * (0.35 + 0.18 * float(i % 3)))
		PaperFront.paw(self, pp, 9.0 + 3.0 * float(i % 3), Color(0.3, 0.5, 0.25, 0.22))
	PaperFront.fish_sign(self, Vector2(view.x * 0.05, g + 18.0), 46.0, Color(0.6, 0.8, 0.95))
	PaperFront.yarn(self, Vector2(view.x * 0.95, g + 34.0), 20.0, Color(1.0, 0.66, 0.72))
