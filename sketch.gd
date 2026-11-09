class_name Sketch
extends RefCounted
## เส้นวาดมือ หยักน้อยๆ เลข seed เดิมได้รูปเดิม ภาพจึงไม่สั่นตอนวาดซ้ำ

const INK := Color(0.36, 0.31, 0.29)       # หมึกน้ำตาลเทานุ่ม (โทนหน้าโหลด แมวมั้ย)
const PAPER := Color(0.975, 0.96, 0.94)
const WIDTH := 2.5
const WOBBLE := 0.7
const STEP := 12.0
const FONT := preload("res://fonts/Mali.ttf")
const ENERGY_TAIL := 0.2       # หางยาวตามความเร็วจุดภาพต่อวินาที
const ENERGY_TAIL_MAX := 125.0
const ENERGY_STEPS := 8
const STORM_EDGE := 14
const STORM_STEPS := 170
const STORM_TURNS := 8.0
const STORM_FLAT := 0.2
const STORM_BEND := 0.24
const STORM_BITS := 12
const STORM_BIT_LONG := 26.0
const HATCH_DOT := 7.0
const LINE_GAP := 1.4
const WASH_LAYERS := 3
const WASH_ALPHA := 0.34
const WASH_WOBBLE := 5.0
const CUT_SHIFT := Vector2(3.0, 2.0)
const CUT_PALE := 0.16
const CUT_MASK := 0.82
const CUT_MASK_MIN := 24.0
const CUT_BIG := 260.0
const CUT_BIG_ALPHA := 0.72
const TOON_LIGHT := Vector2(-0.45, -0.7)
const TOON_DEPTH := 0.22
const TOON_DARK := 0.36
const TOON_TINT := Color(0.2, 0.16, 0.42)
const FX_BIG_ALPHA := 0.82
const FX_GLOW := 1.14
const FX_GLOW_ALPHA := 0.34
const FX_GLOW_MIN := 14.0
const STORM_ANIME_A := 0.8
const FX_MID := 0.74
const FX_MID_GOLD := 0.7
const FX_GOLD := Color(1.0, 0.72, 0.16)
const FX_CORE := 0.42
const FX_WHITE := Color(1.0, 0.97, 0.78)
const FX_CORE_MIN := 22.0
const ANIME_BODY_SHADE := Color(0.72, 0.72, 0.84)
const ANIME_SCARF := Color(0.86, 0.14, 0.18)
const ANIME_SCARF_LONG := 76.0
const SHAPE_MASK_S := 0.2

## ลงสีฉากแบบสีน้ำ ซ้อนหลายชั้นโปร่ง ขอบไม่ตรงกัน pale มากคือของไกล
static func area(c: CanvasItem, poly: PackedVector2Array, color: Color, seed_no := 0, _step := 0.0, pale := 0.4) -> void:
	if poly.size() < 3:
		return
	var tone := Color(color.r, color.g, color.b).lerp(PAPER, pale)
	var center := Vector2.ZERO
	for p in poly:
		center += p
	center /= float(poly.size())
	for layer in WASH_LAYERS:
		var pts := PackedVector2Array()
		for i in poly.size():
			var wob := sin(float(seed_no + layer * 11) + float(i) * 2.7) * WASH_WOBBLE
			pts.append(poly[i] + (poly[i] - center).normalized() * wob + Vector2(float(layer) * 1.6, -float(layer) * 1.2))
		var tris := Geometry2D.triangulate_polygon(pts)
		if not tris.is_empty():
			RenderingServer.canvas_item_add_triangle_array(c.get_canvas_item(), tris, pts, PackedColorArray([Color(tone, WASH_ALPHA * color.a)]))

## โหมดเซลอนิเมะ ตอนนี้ใช้กับสาย LORD KNIGHT
static var anime := false

static func _is_fx(c: CanvasItem) -> bool:
	return c is HyperBase or c is ImpactFx or c is RedWave or c is SwordWave

## ตัวละครและมอน สีฐาน เงาขอบแข็งฝั่งตรงข้ามแสง
static func toon_fill(c: CanvasItem, poly: PackedVector2Array, color: Color, shaded := true) -> void:
	var tris := Geometry2D.triangulate_polygon(poly)
	if tris.is_empty():
		return
	var item := c.get_canvas_item()
	RenderingServer.canvas_item_add_triangle_array(item, tris, poly, PackedColorArray([color]))
	if not shaded:
		return
	var low := poly[0]
	var high := poly[0]
	for p in poly:
		low = Vector2(minf(low.x, p.x), minf(low.y, p.y))
		high = Vector2(maxf(high.x, p.x), maxf(high.y, p.y))
	var depth := minf(high.x - low.x, high.y - low.y) * TOON_DEPTH
	if depth < 2.0:
		return
	var lit := PackedVector2Array()
	lit.resize(poly.size())
	for i in poly.size():
		lit[i] = poly[i] + TOON_LIGHT * depth
	var shade := Color(color.darkened(TOON_DARK).lerp(TOON_TINT, 0.18), color.a)
	for part in Geometry2D.clip_polygons(poly, lit):
		var part_tris := Geometry2D.triangulate_polygon(part)
		if not part_tris.is_empty():
			RenderingServer.canvas_item_add_triangle_array(item, part_tris, part, PackedColorArray([shade]))

## สกิล สีจัด มีแสงเรืองรอบนอก และแกนสว่างเกือบขาวตรงกลาง
static func fx_fill(c: CanvasItem, poly: PackedVector2Array, color: Color) -> void:
	var tris := Geometry2D.triangulate_polygon(poly)
	if tris.is_empty():
		return
	var item := c.get_canvas_item()
	var center := Vector2.ZERO
	var low := poly[0]
	var high := poly[0]
	for p in poly:
		center += p
		low = Vector2(minf(low.x, p.x), minf(low.y, p.y))
		high = Vector2(maxf(high.x, p.x), maxf(high.y, p.y))
	center /= float(poly.size())
	var size := minf(high.x - low.x, high.y - low.y)
	var alpha := color.a * (FX_BIG_ALPHA if size >= CUT_BIG else 1.0)
	if size >= FX_GLOW_MIN:
		RenderingServer.canvas_item_add_triangle_array(item, tris, _scaled(poly, center, FX_GLOW), PackedColorArray([Color(color.lightened(0.25), alpha * FX_GLOW_ALPHA)]))
	RenderingServer.canvas_item_add_triangle_array(item, tris, poly, PackedColorArray([Color(color, alpha)]))
	if size >= FX_CORE_MIN:
		# ไล่สีเข้าหาแกน สีหลัก สีทอง เกือบขาว
		RenderingServer.canvas_item_add_triangle_array(item, tris, _scaled(poly, center, FX_MID), PackedColorArray([Color(color.lerp(FX_GOLD, FX_MID_GOLD), alpha)]))
		RenderingServer.canvas_item_add_triangle_array(item, tris, _scaled(poly, center, FX_CORE), PackedColorArray([Color(FX_WHITE, alpha)]))

static func _scaled(poly: PackedVector2Array, center: Vector2, k: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	out.resize(poly.size())
	for i in poly.size():
		out[i] = center + (poly[i] - center) * k
	return out

## รายละเอียดอนิเมะบนตัว เงาตัว ไฮไลต์ ตาคม ผ้าพันคอแดงปลิว ด้านหน้าคือแกน +x
static func anime_body(c: CanvasItem, center: Vector2, radius: float, height: float, clock: float, ink: Color) -> void:
	var body := capsule(center, radius, height, 22)
	var lit := PackedVector2Array()
	for p in body:
		lit.append(p + Vector2(0.55, -0.45) * radius * 0.5)
	for part in Geometry2D.clip_polygons(body, lit):
		var tris := Geometry2D.triangulate_polygon(part)
		if not tris.is_empty():
			RenderingServer.canvas_item_add_triangle_array(c.get_canvas_item(), tris, part, PackedColorArray([ANIME_BODY_SHADE]))
	c.draw_colored_polygon(oval(center + Vector2(radius * 0.32, -height * 0.34), radius * 0.2, radius * 0.11, 10), Color.WHITE)
	# ตาคม
	var eye := center + Vector2(radius * 0.46, -height * 0.2)
	var slit := PackedVector2Array([eye + Vector2(-13.0, -5.0), eye + Vector2(13.0, -9.0), eye + Vector2(9.0, 3.0), eye + Vector2(-9.0, 4.0)])
	c.draw_colored_polygon(slit, ink)
	c.draw_circle(eye + Vector2(4.0, -3.0), 2.6, Color.WHITE)
	# ผ้าพันคอ
	var neck_y := center.y - height * 0.04
	var wrap := PackedVector2Array([Vector2(center.x - radius, neck_y - 9.0), Vector2(center.x + radius, neck_y - 12.0), Vector2(center.x + radius, neck_y + 8.0), Vector2(center.x - radius, neck_y + 11.0)])
	c.draw_colored_polygon(wrap, ANIME_SCARF)
	var tail := PackedVector2Array()
	var low_edge := PackedVector2Array()
	for i in 8:
		var t := float(i) / 7.0
		var wave := sin(clock * 7.0 + t * 5.0) * 12.0 * t
		var at := Vector2(center.x - radius - t * ANIME_SCARF_LONG, neck_y + wave + t * 14.0)
		var half := 11.0 * (1.0 - t * 0.6)
		tail.append(at + Vector2(0.0, -half))
		low_edge.append(at + Vector2(0.0, half))
	low_edge.reverse()
	tail.append_array(low_edge)
	c.draw_colored_polygon(tail, ANIME_SCARF)
	var loop := tail.duplicate()
	loop.append(tail[0])
	c.draw_polyline(loop, ink, 2.6, true)
	c.draw_line(wrap[0], wrap[1], ink, 2.6, true)
	c.draw_line(wrap[3], wrap[2], ink, 2.6, true)

## ลงสีตัวละคร อาวุธ มอน สกิล และสิ่งของ แบบกระดาษตัด สีเรียบเป็นแผ่น เหลื่อมจากเส้นหมึกนิดหน่อย
## มีพื้นกระดาษรองบังเส้นฉากหลัง รูปใหญ่มากโปร่งลงเพื่อยังเห็นมอนข้างหลัง
static func hatch(c: CanvasItem, poly: PackedVector2Array, color: Color, seed_no := 0, _step := 0.0) -> void:
	var n := poly.size()
	if n < 3 or color.a <= 0.01:
		return
	if anime:
		if _is_fx(c):
			fx_fill(c, poly, color)
		else:
			toon_fill(c, poly, color)
		return
	var low := poly[0]
	var high := poly[0]
	for p in poly:
		low = Vector2(minf(low.x, p.x), minf(low.y, p.y))
		high = Vector2(maxf(high.x, p.x), maxf(high.y, p.y))
	var size := minf(high.x - low.x, high.y - low.y)
	var tris := Geometry2D.triangulate_polygon(poly)
	if tris.is_empty():
		return
	var item := c.get_canvas_item()
	var alpha := color.a * (CUT_BIG_ALPHA if size >= CUT_BIG else 1.0)
	if size >= CUT_MASK_MIN:
		RenderingServer.canvas_item_add_triangle_array(item, tris, poly, PackedColorArray([Color(PAPER, alpha * CUT_MASK)]))
	var shift := CUT_SHIFT * minf(size * 0.04, 1.0) * (0.8 + 0.4 * absf(sin(float(seed_no))))
	var pts := PackedVector2Array()
	pts.resize(n)
	for i in n:
		pts[i] = poly[i] + shift
	var tone := Color(color.r, color.g, color.b).lerp(PAPER, CUT_PALE)
	RenderingServer.canvas_item_add_triangle_array(item, tris, pts, PackedColorArray([Color(tone, alpha)]))

## แบ่งข้อความเป็นบรรทัดตามความกว้าง ตัดที่ช่องว่างก่อน ไม่แยกสระกับวรรณยุกต์ออกจากพยัญชนะ
static func wrap_lines(text: String, size_px: int, max_w: float) -> PackedStringArray:
	var lines := PackedStringArray()
	var line := ""
	var last_space := -1
	var i := 0
	while i < text.length():
		var cluster := text[i]
		while i + 1 < text.length() and _is_mark(text.unicode_at(i + 1)):
			i += 1
			cluster += text[i]
		i += 1
		if cluster == "\n":
			lines.append(line)
			line = ""
			last_space = -1
			continue
		var next := line + cluster
		if font().get_string_size(next, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size_px).x > max_w and line != "":
			if last_space > 0:
				lines.append(line.substr(0, last_space))
				line = line.substr(last_space + 1) + cluster
			else:
				lines.append(line)
				line = cluster
			last_space = -1
		else:
			line = next
		if cluster == " ":
			last_space = line.length() - 1
	if line != "":
		lines.append(line)
	return lines

## สระบน สระล่าง และวรรณยุกต์ไทย ต้องอยู่กับตัวหน้า
static func _is_mark(code: int) -> bool:
	return code == 0x0E31 or (code >= 0x0E34 and code <= 0x0E3A) or (code >= 0x0E47 and code <= 0x0E4E)

## ขนาดที่ข้อความหลายบรรทัดพอดีกรอบ แล้ววาด ใช้แทน draw_multiline_string
static func draw_wrapped(c: CanvasItem, at: Vector2, text: String, size_px: int, max_w: float, max_h: float, color := INK, min_px := 11) -> void:
	var px := size_px
	var lines := wrap_lines(text, px, max_w)
	while px > min_px and float(lines.size()) * float(px) * LINE_GAP > max_h:
		px -= 1
		lines = wrap_lines(text, px, max_w)
	for i in lines.size():
		c.draw_string(font(), at + Vector2(0.0, float(px) + float(i) * float(px) * LINE_GAP), lines[i], HORIZONTAL_ALIGNMENT_LEFT, -1.0, px, color)

## ขนาดตัวอักษรที่ทำให้ข้อความบรรทัดเดียวพอดีความกว้าง ข้อความจึงไม่ถูกตัด
static func fit_size(text: String, size_px: int, max_w: float, min_px := 10) -> int:
	var s := size_px
	while s > min_px and font().get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, s).x > max_w:
		s -= 1
	return s

## ขนาดตัวอักษรที่ทำให้ข้อความหลายบรรทัดพอดีกรอบ
static func fit_multi(text: String, size_px: int, max_w: float, max_h: float, min_px := 10) -> int:
	var s := size_px
	while s > min_px and font().get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, max_w, s).y > max_h:
		s -= 1
	return s

## ระบายวงกลม จุดเล็กมากยังเป็นจุด
static func hatch_circle(c: CanvasItem, center: Vector2, r: float, color: Color, seed_no := 0) -> void:
	if r < HATCH_DOT:
		c.draw_circle(center, r, color)
		return
	hatch(c, oval(center, r, r, 24), color, seed_no)

## ทรงเปลวไฟ: ฐานมน ป่องตรงโคน ปลายเรียวและโค้งไปตาม sway เป็นเส้นโค้งทั้งเปลว
static func flame(base: Vector2, dir: Vector2, long: float, wide: float, sway: float) -> PackedVector2Array:
	var across := dir.orthogonal()
	var count := 10
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for i in count + 1:
		var t := float(i) / count
		var half := wide * sin(PI * pow(t, 0.55)) * (1.0 - 0.25 * t)
		var mid := base + dir * long * t + across * sway * t * t
		left.append(mid - across * half)
		right.append(mid + across * half)
	right.reverse()
	left.append_array(right.slice(1, right.size() - 1))
	return left

## ลูกบอลพลังงานพุ่งนำหน้า หัวกลมสว่าง หางเรียวลากตามหลังทิศที่พุ่ง
static func energy_ball(c: CanvasItem, vel_screen: Vector2, r: float, outer: Color, inner: Color, clock: float) -> void:
	var speed := vel_screen.length()
	var dir := vel_screen / speed if speed > 0.01 else Vector2.RIGHT
	var long := minf(speed * ENERGY_TAIL, ENERGY_TAIL_MAX)
	if long > r:
		for layer in [[1.0, outer], [0.6, inner]]:
			var k: float = layer[0]
			var left := PackedVector2Array()
			var right := PackedVector2Array()
			for i in ENERGY_STEPS + 1:
				var t := float(i) / ENERGY_STEPS
				var half := r * k * pow(1.0 - t, 1.4)
				var wiggle := sin(clock * 22.0 + t * 7.0) * r * 0.16 * t
				var mid := -dir * long * t * k + dir.orthogonal() * wiggle
				left.append(mid + dir.orthogonal() * half)
				right.append(mid - dir.orthogonal() * half)
			right.reverse()
			left.append_array(right.slice(1, right.size()))
			Sketch.hatch(c, left, layer[1])
	Sketch.hatch_circle(c, Vector2.ZERO, r * 1.28, Color(outer, 0.3))
	Sketch.hatch_circle(c, Vector2.ZERO, r, outer)
	Sketch.hatch_circle(c, dir * r * 0.14, r * 0.66, inner)
	c.draw_arc(Vector2.ZERO, r, 0.0, TAU, 22, INK, 2.2, true)

## พายุทรงกรวย พื้นหลังชัด เส้นเดียวต่อเนื่องวนเป็นเกลียวจากล่างขึ้นบน
static func storm(c: CanvasItem, foot: Vector2, low_r: float, high_r: float, high: float, phase: float, fill: Color, line_color: Color, seed_no: int, k := 1.0) -> void:
	if k <= 0.0:
		return
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for i in STORM_EDGE + 1:
		var t := float(i) / STORM_EDGE
		var r := lerpf(low_r, high_r, t * t) * k
		var bend := sin(t * 5.0 + phase * 0.6) * r * STORM_BEND * t
		left.append(foot + Vector2(-r + bend, -high * t * k))
		right.append(foot + Vector2(r + bend, -high * t * k))
	right.reverse()
	left.append_array(right)
	Sketch.hatch(c, left, Color(fill, (STORM_ANIME_A if anime else fill.a) * k))
	var coil := PackedVector2Array()
	for i in STORM_STEPS + 1:
		var t := float(i) / STORM_STEPS
		var a := t * TAU * STORM_TURNS + phase
		var r := lerpf(low_r, high_r, t * t) * k
		var bend := sin(t * 5.0 + phase * 0.6) * r * STORM_BEND * t
		coil.append(foot + Vector2(cos(a) * r + bend, -high * t * k + sin(a) * r * STORM_FLAT))
	# เส้นดำล้วนใช้เส้นเดียวหนาๆ สีอื่นมีขอบหมึก
	if line_color == INK:
		line(c, coil, seed_no, 4.0, 0.7, Color(INK, k))
	else:
		line(c, coil, seed_no, 5.5, 0.7, Color(INK, k))
		line(c, coil, seed_no, 2.6, 0.7, Color(line_color, k))
	# เศษที่ถูกพัดหมุนรอบกรวย
	for i in STORM_BITS:
		var t := fposmod(float(i) * 0.37, 1.0)
		var a := phase * 1.3 + float(i) * 2.4
		var r := lerpf(low_r, high_r, t * t) * k * 1.18
		var at := foot + Vector2(cos(a) * r, -high * t * k + sin(a) * r * STORM_FLAT)
		var along := Vector2(-sin(a), cos(a) * STORM_FLAT).normalized()
		line(c, PackedVector2Array([at, at + along * STORM_BIT_LONG]), seed_no + 3 + i, 3.0, 0.3, Color(INK, k))

## ฟอนต์ลายมือ มีทั้งไทยและอังกฤษ
static func font() -> Font:
	return FONT

## เส้นผ่านจุดต่างๆ
static func line(c: CanvasItem, pts: PackedVector2Array, seed_no: int, width := WIDTH, wobble := WOBBLE, color := INK) -> void:
	var phase_a := float(seed_no) * 1.7
	var phase_b := float(seed_no) * 3.1
	var out := PackedVector2Array()
	var run := 0.0
	for i in pts.size() - 1:
		var a: Vector2 = pts[i]
		var b: Vector2 = pts[i + 1]
		var long := a.distance_to(b)
		if long < 0.01:
			continue
		var side := (b - a).normalized().orthogonal()
		var count := maxi(int(long / STEP), 1)
		var last := i == pts.size() - 2
		for k in count + (1 if last else 0):
			var u := float(k) / count
			var d := run + long * u
			var push := wobble * (sin(d * 0.06 + phase_a) + 0.5 * sin(d * 0.15 + phase_b))
			out.append(a.lerp(b, u) + side * push)
		run += long
	if out.size() >= 2:
		c.draw_polyline(out, color, width, true)

## รูปปิด เติมสีกระดาษเพื่อบังของข้างหลัง
static func shape(c: CanvasItem, pts: PackedVector2Array, seed_no: int, width := WIDTH, fill := PAPER, ink := INK) -> void:
	# สีกระดาษคือหน้ากากปิดเส้นด้านหลัง สีอื่นเป็นเส้นระบาย ไม่เทสี
	if fill.s < SHAPE_MASK_S:
		c.draw_colored_polygon(pts, fill)
	else:
		c.draw_colored_polygon(pts, PAPER)
		hatch(c, pts, fill, seed_no)
	var closed := pts.duplicate()
	closed.append(pts[0])
	line(c, closed, seed_no, width, WOBBLE, ink)

## จุดรอบวงรี
static func oval(center: Vector2, rx: float, ry: float, steps := 44) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in steps:
		var a := TAU * i / steps
		pts.append(center + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## จุดรอบแคปซูลตั้งตรง
static func capsule(center: Vector2, radius: float, height: float, steps := 26) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var reach := height * 0.5 - radius
	for i in steps + 1:
		var a := PI + PI * i / steps
		pts.append(center + Vector2(cos(a) * radius, -reach + sin(a) * radius))
	for i in steps + 1:
		var a := PI * i / steps
		pts.append(center + Vector2(cos(a) * radius, reach + sin(a) * radius))
	return pts
