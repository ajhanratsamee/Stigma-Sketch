class_name MageFx
## เอฟเฟกต์ภาพของคอมโบ CAT SUSI ทุกตัววาดอย่างเดียว ไม่ทำดาเมจ MageCaster เป็นคนคุมดาเมจและตำแหน่ง
## ทุกตัวหายเองเมื่อครบ life

class Base extends Node2D:
	var life := 1.0
	var t := 0.0
	var grand := 1.45            # ขยายภาพทั้งชิ้นให้ใหญ่อลังการ (ภาพอย่างเดียว ไม่เกี่ยวกับระยะโดน)
	var _grown := false
	func _process(delta: float) -> void:
		if not _grown:
			_grown = true
			scale *= grand
		t += delta
		if t >= life:
			queue_free()
			return
		_step(delta)
		queue_redraw()
	func _step(_delta: float) -> void:
		pass
	func fade() -> float:
		return clampf((life - t) / 0.25, 0.0, 1.0)
	## แสงฟุ้งหลายชั้น
	func halo(c: Vector2, r: float, color: Color, a: float) -> void:
		draw_circle(c, r * 1.6, Color(color, 0.06 * a))
		draw_circle(c, r * 1.25, Color(color, 0.12 * a))
		draw_circle(c, r, Color(color, 0.2 * a))
	## รังสีแสงแผ่ออกจากจุด
	func rays(c: Vector2, n: int, r0: float, r1: float, color: Color, a: float, spin := 0.0, w := 14.0) -> void:
		# แสงฟุ้งกลมกับเม็ดกลมกระจายออก แทนรังสีแฉก
		draw_circle(c, lerpf(r0, r1, 0.5), Color(color, 0.12 * a))
		draw_circle(c, lerpf(r0, r1, 0.25), Color(color, 0.18 * a))
		for i in n:
			var ang := spin + TAU * float(i) / float(n)
			var d := Vector2(cos(ang), sin(ang))
			draw_circle(c + d * lerpf(r0, r1, 0.55), w * 0.55, Color(color, 0.45 * a))
			draw_circle(c + d * lerpf(r0, r1, 0.85), w * 0.35, Color(color, 0.3 * a))
	## คลื่นวงรีกระจายสองชั้น k 0 ถึง 1
	func shock(c: Vector2, rx: float, ry: float, k: float, color: Color) -> void:
		for i in 2:
			var kk := clampf(k - float(i) * 0.2, 0.0, 1.0)
			if kk <= 0.0:
				continue
			ring(c, rx * (0.3 + kk), ry * (0.3 + kk), Color(color, (1.0 - kk)), 10.0 * (1.0 - kk) + 1.5)
	## ประกายสี่แฉก
	func twinkle(c: Vector2, s: float, color: Color) -> void:
		if s < 1.5:
			return
		SoftDraw.sparkle(self, c, s * 0.7, color)
	func star(c: Vector2, r: float, spin: float, color: Color) -> void:
		# เม็ดกลมแทนดาวห้าแฉก
		SoftDraw.sparkle(self, c, r * 0.8, color)
	func oval(c: Vector2, rx: float, ry: float, n := 40) -> PackedVector2Array:
		var pts := PackedVector2Array()
		for i in n:
			var a := TAU * float(i) / float(n)
			pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
		return pts
	func ring(c: Vector2, rx: float, ry: float, color: Color, w: float) -> void:
		var pts := oval(c, rx, ry)
		pts.append(pts[0])
		SoftDraw.pline(self, pts, color, w, true)
	## รอยเท้าแมว อุ้งใหญ่หนึ่ง นิ้วสาม หมุนได้
	func paw(c: Vector2, r: float, color: Color, rot := 0.0) -> void:
		# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
		draw_circle(c, r * 0.75, Color(color, color.a * 0.35 * 1.0))
		draw_circle(c, r * 0.45, Color(color, color.a * 0.7 * 1.0))
	func _tx(tr: Transform2D, pts: PackedVector2Array) -> PackedVector2Array:
		var out := PackedVector2Array()
		for p in pts:
			out.append(tr * p)
		return out
	## หูแมวคู่ ด้านในชมพู ฐานอยู่ที่ c ห่างกัน gap
	func ears(c: Vector2, r: float, gap: float, color: Color, inner := Color(1.0, 0.72, 0.85)) -> void:
		# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
		pass
	## หน้าแมวยิ้ม ตา ^ ^ ปาก ω
	func cat_face(c: Vector2, r: float, ink: Color) -> void:
		# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
		pass
	## ตาแมวรีมีม่านตาแนวตั้ง
	func cat_eye(c: Vector2, rx: float, ry: float, iris: Color, slit: Color) -> void:
		var lens := PackedVector2Array()
		for i in 13:
			var u := float(i) / 12.0
			lens.append(c + Vector2(lerpf(-rx, rx, u), -ry * sin(u * PI)))
		for i in 13:
			var u := float(i) / 12.0
			lens.append(c + Vector2(lerpf(rx, -rx, u), ry * sin(u * PI)))
		SoftDraw.poly(self, lens, iris)
		SoftDraw.poly(self, oval(c, rx * 0.16, ry * 0.85, 16), slit)
		draw_circle(c + Vector2(-rx * 0.3, -ry * 0.35), ry * 0.18, Color(1, 1, 1, iris.a * 0.9))
	## ก้างปลา
	func fishbone(c: Vector2, s: float, color: Color, rot := 0.0) -> void:
		var tr := Transform2D(rot, c)
		var w := maxf(1.5, s * 0.1)
		draw_line(tr * Vector2(-s, 0.0), tr * Vector2(s * 0.7, 0.0), color, w, true)
		for i in 3:
			var x := -s * 0.6 + float(i) * s * 0.45
			draw_line(tr * Vector2(x, -s * 0.35), tr * Vector2(x, s * 0.35), color, w, true)
		SoftDraw.poly(self, _tx(tr, PackedVector2Array([Vector2(-s, 0.0), Vector2(-s * 1.4, -s * 0.4), Vector2(-s * 1.4, s * 0.4)])), color)
		draw_circle(tr * Vector2(s * 0.85, 0.0), s * 0.25, color)

## ลมพัดไปข้างหน้า เส้นลมโค้งเป็นเกลียว ใบไม้เล็กปลิว
class Gust extends Base:
	var dir := 1.0
	func _init() -> void:
		life = 0.6
	func _draw() -> void:
		var k := t / life
		var f := fade()
		halo(Vector2(dir * (k * 520.0 + 40.0), -100.0), 110.0, Color(0.7, 1.0, 0.9), f)
		for n in 7:
			var y := -30.0 - float(n) * 26.0
			var x0 := dir * (k * 520.0 - 80.0 + float(n % 2) * 40.0)
			twinkle(Vector2(x0 + dir * 60.0, y - 14.0), 10.0 * f, Color(1.0, 1.0, 1.0, 0.8 * f))
			var pts := PackedVector2Array()
			for i in 12:
				var u := float(i) / 11.0
				pts.append(Vector2(x0 + dir * u * 220.0, y + sin(u * 6.0 + t * 12.0 + float(n)) * 12.0))
			SoftDraw.pline(self, pts, Color(0.85, 1.0, 0.95, 0.75 * f), 5.0, true)
			draw_arc(Vector2(x0 + dir * 230.0, y - 10.0), 14.0, -PI * 0.5, PI, 10, Color(0.85, 1.0, 0.95, 0.75 * f), 4.0, true)
			# รอยเท้าแมวปลิวตามลม
			paw(Vector2(x0 + dir * 140.0, y + sin(t * 9.0 + float(n)) * 16.0), 9.0, Color(0.7, 1.0, 0.9, 0.8 * f), t * 6.0 * dir + float(n))

## เมฆสายฟ้าเล็กกว่ามอน ลอยตามเป้าหมาย สายฟ้าลงทีละเส้นตอน bolt()
class Cloud extends Base:
	var target: Node2D
	var _flash := 0.0
	var _bolt := PackedVector2Array()
	func _init() -> void:
		life = 3.0
	func refresh() -> void:
		life = t + 2.0
	func bolt() -> void:
		_flash = 0.14
		_bolt = PackedVector2Array([Vector2.ZERO])
		var y := 0.0
		var x := 0.0
		var ground := -position.y / grand
		while y < ground:
			y = minf(y + randf_range(30.0, 60.0), ground)
			x = randf_range(-22.0, 22.0)
			_bolt.append(Vector2(x, y))
	func _step(delta: float) -> void:
		_flash = maxf(_flash - delta, 0.0)
		if is_instance_valid(target):
			position.x = lerpf(position.x, target.position.x, 1.0 - exp(-10.0 * delta))
	func _draw() -> void:
		var f := fade() * clampf(t / 0.2, 0.0, 1.0)
		halo(Vector2(0.0, 0.0), 70.0, Color(0.7, 0.7, 1.0), f)
		if _flash > 0.0 and _bolt.size() > 1:
			var end := _bolt[_bolt.size() - 1]
			var fk := 1.0 - _flash / 0.14
			SoftDraw.pline(self, _bolt, Color(1.0, 0.95, 0.5, 0.25 * f), 40.0, true)
			shock(end, 120.0, 30.0, fk, Color(1.0, 0.95, 0.6))
			rays(end + Vector2(0.0, -20.0), 8, 20.0, 160.0, Color(1.0, 1.0, 0.7), f, t * 3.0, 10.0)
			SoftDraw.pline(self, _bolt, Color(1.0, 0.95, 0.5, 0.6 * f), 14.0, true)
			SoftDraw.pline(self, _bolt, Color(1.0, 1.0, 0.92, f), 5.0, true)
			draw_circle(_bolt[_bolt.size() - 1], 30.0, Color(1.0, 1.0, 0.7, 0.5 * f))
			paw(_bolt[_bolt.size() - 1] + Vector2(0.0, -10.0), 22.0, Color(1.0, 0.95, 0.5, f))
		var gray := Color(0.42, 0.42, 0.55, 0.95 * f)
		ears(Vector2(0.0, -28.0), 26.0, 26.0, gray, Color(1.0, 0.85, 0.5))
		for c in [Vector2(-34.0, 6.0), Vector2(0.0, -8.0), Vector2(34.0, 4.0), Vector2(-14.0, 14.0), Vector2(18.0, 14.0)]:
			draw_circle(c, 30.0, gray)
		for c in [Vector2(-20.0, -4.0), Vector2(14.0, -14.0)]:
			draw_circle(c, 16.0, Color(0.62, 0.62, 0.75, 0.9 * f))
		cat_face(Vector2(0.0, 6.0), 30.0, Color(1.0, 0.95, 0.6, f))
		if _flash > 0.0:
			draw_circle(Vector2(0.0, 6.0), 46.0, Color(1.0, 1.0, 0.7, 0.35 * f))

## เปลวไฟเลื้อยไปตามพื้น เปลวสูงต่ำเป็นลูกคลื่น ไฟชมพูม่วงของ SUSI
class FloorFlame extends Base:
	var dir := 1.0
	var speed := 1100.0
	var trail: Array = []
	func _init() -> void:
		life = 0.95
	func _step(delta: float) -> void:
		if t < 0.7:
			position.x += dir * speed * delta
			trail.append([position.x, t])
	func _draw() -> void:
		for tr in trail:
			var age: float = t - float(tr[1])
			if age > 0.35:
				continue
			var k := 1.0 - age / 0.35
			var x: float = (float(tr[0]) - position.x) / grand
			var h := (50.0 + 30.0 * sin(float(tr[0]) * 0.05 + t * 20.0)) * k
			draw_circle(Vector2(x, -h * 0.4), h * 0.7, Color(0.85, 0.4, 1.0, 0.12 * k))
			if int(absf(float(tr[0])) / 40.0) % 3 == 0:
				twinkle(Vector2(x, -h - 20.0 - 40.0 * (1.0 - k)), 9.0 * k, Color(1.0, 0.75, 0.95, k))
			var flame := PackedVector2Array([Vector2(x - 26.0, 0.0), Vector2(x - 10.0, -h * 0.6), Vector2(x, -h), Vector2(x + 10.0, -h * 0.6), Vector2(x + 26.0, 0.0)])
			SoftDraw.poly(self, flame, Color(0.65, 0.3, 1.0, 0.65 * k))
			var core := PackedVector2Array([Vector2(x - 12.0, 0.0), Vector2(x, -h * 0.6), Vector2(x + 12.0, 0.0)])
			SoftDraw.poly(self, core, Color(1.0, 0.6, 0.85, 0.9 * k))
			# ยอดเปลวมีหูแมวคู่เล็ก
			if h > 30.0:
				ears(Vector2(x, -h * 0.82), h * 0.22, h * 0.13, Color(0.65, 0.3, 1.0, 0.65 * k))
			if int(absf(float(tr[0])) / 60.0) % 2 == 0:
				paw(Vector2(x, -6.0), 9.0, Color(0.45, 0.15, 0.6, 0.5 * k))

## ผลึกน้ำแข็งงอกจากพื้น มีโซ่น้ำแข็งเส้นลากมาหาตัวละคร
class Ice extends Base:
	var pull_to := Vector2.ZERO
	func _init() -> void:
		life = 0.9
	func _draw() -> void:
		var grow := clampf(t / 0.15, 0.0, 1.0)
		var f := fade()
		# ไอเย็นบนพื้นและแสงฟ้า
		SoftDraw.poly(self, oval(Vector2(0.0, -4.0), 170.0 * grow, 34.0 * grow), Color(0.7, 0.92, 1.0, 0.35 * f))
		halo(Vector2(0.0, -60.0), 90.0 * grow, Color(0.6, 0.88, 1.0), f)
		shock(Vector2(0.0, -4.0), 190.0, 40.0, clampf(t / 0.4, 0.0, 1.0), Color(0.85, 0.97, 1.0))
		for n in 6:
			twinkle(Vector2(cos(float(n) * 1.9 + t * 2.0) * 110.0, -40.0 - fposmod(t * 160.0 + float(n) * 30.0, 160.0)), 9.0 * f, Color(1.0, 1.0, 1.0, 0.9 * f))
		for n in 5:
			var x := (float(n) - 2.0) * 24.0
			var h := (110.0 - absf(float(n) - 2.0) * 28.0) * grow
			SoftDraw.poly(self, PackedVector2Array([Vector2(x - 16.0, 0.0), Vector2(x + (float(n) - 2.0) * 8.0, -h), Vector2(x + 16.0, 0.0)]), Color(0.6, 0.88, 1.0, 0.85 * f))
			draw_line(Vector2(x, 0.0), Vector2(x + (float(n) - 2.0) * 8.0, -h), Color(1, 1, 1, 0.8 * f), 3.0, true)
		# ผลึกกลางมีหูแมวและหน้าเหมียว
		if grow > 0.5:
			ears(Vector2(0.0, -104.0 * grow), 22.0, 15.0, Color(0.75, 0.95, 1.0, 0.95 * f), Color(1.0, 0.8, 0.92))
			cat_face(Vector2(0.0, -62.0 * grow), 20.0, Color(0.2, 0.45, 0.7, f))
		paw(Vector2(-80.0, -6.0), 13.0, Color(0.85, 0.97, 1.0, 0.8 * f), -0.3)
		paw(Vector2(78.0, -6.0), 11.0, Color(0.85, 0.97, 1.0, 0.8 * f), 0.3)
		if t > 0.15 and t < 0.6:
			var to := (pull_to - position) / grand
			var k := clampf((t - 0.15) / 0.4, 0.0, 1.0)
			draw_line(Vector2(0.0, -50.0), Vector2(0.0, -50.0).lerp(to + Vector2(0.0, -60.0), 1.0 - k), Color(0.75, 0.95, 1.0, 0.9 * f), 6.0, true)

## น้ำแข็งแตกเป็นแนวจากจุดไกลไล่เข้ามาหาตัวละคร แท่งน้ำแข็งงอกทีละแท่งแล้วแตกเป็นเศษ
class IceTrail extends Base:
	var to_x := 0.0
	var travel := 0.7
	var _spikes: Array = []    # [x เวลาเกิด ขนาด]
	var _next := 0.0
	func _init() -> void:
		life = 1.4
	func _step(_delta: float) -> void:
		while t >= _next and _next <= travel:
			var k := _next / travel
			_spikes.append([to_x * k / grand + randf_range(-10.0, 10.0), _next, randf_range(0.8, 1.2)])
			_next += 0.035
	func _draw() -> void:
		for sp in _spikes:
			var age: float = t - float(sp[1])
			var x: float = sp[0]
			var s: float = sp[2]
			if age < 0.22:
				var g := clampf(age / 0.07, 0.0, 1.0)
				SoftDraw.poly(self, oval(Vector2(x, -3.0), 50.0 * s * g, 12.0 * s * g, 16), Color(0.75, 0.95, 1.0, 0.45))
				draw_circle(Vector2(x, -50.0 * s), 60.0 * s * g, Color(0.6, 0.9, 1.0, 0.12))
				for n in 3:
					var dx := (float(n) - 1.0) * 18.0 * s
					var h := (95.0 - absf(float(n) - 1.0) * 35.0) * s * g
					SoftDraw.poly(self, PackedVector2Array([Vector2(x + dx - 14.0 * s, 0.0), Vector2(x + dx * 1.4, -h), Vector2(x + dx + 14.0 * s, 0.0)]), Color(0.6, 0.88, 1.0, 0.9))
					draw_line(Vector2(x + dx, 0.0), Vector2(x + dx * 1.4, -h), Color(1, 1, 1, 0.85), 3.0, true)
				if g >= 1.0:
					ears(Vector2(x, -88.0 * s), 14.0 * s, 9.0 * s, Color(0.75, 0.95, 1.0, 0.95), Color(1.0, 0.8, 0.92))
			elif age < 0.6:
				# แตกเป็นเศษน้ำแข็งกระเด็น
				var k := (age - 0.22) / 0.38
				for n in 5:
					var a := PI + PI * (float(n) + 0.5) / 5.0
					var p := Vector2(x, -40.0 * s) + Vector2(cos(a), sin(a)) * 120.0 * k + Vector2(0.0, 260.0 * k * k)
					var r := 9.0 * s * (1.0 - k)
					if n == 2:
						paw(p, r * 1.4, Color(0.85, 0.97, 1.0, 1.0 - k), k * 4.0)
					else:
						SoftDraw.poly(self, PackedVector2Array([p + Vector2(0.0, -r), p + Vector2(r * 0.6, 0.0), p + Vector2(0.0, r), p + Vector2(-r * 0.6, 0.0)]), Color(0.75, 0.95, 1.0, 1.0 - k))

## สายฟ้าช็อตจากมือเฉียงลงถึงพื้น ประกายกระแทกที่พื้น
class Spark extends Base:
	var to := Vector2.ZERO
	var _pts := PackedVector2Array()
	func _init() -> void:
		life = 0.22
	func _ready() -> void:
		var d := to / grand
		for i in 9:
			var k := float(i) / 8.0
			var side := Vector2(-d.y, d.x).normalized() * (0.0 if i == 0 or i == 8 else randf_range(-24.0, 24.0))
			_pts.append(d * k + side)
	func _draw() -> void:
		var f := 1.0 - t / life
		var end := to / grand
		SoftDraw.pline(self, _pts, Color(0.7, 0.85, 1.0, 0.25 * f), 40.0, true)
		SoftDraw.pline(self, _pts, Color(0.7, 0.85, 1.0, 0.6 * f), 16.0, true)
		SoftDraw.pline(self, _pts, Color(1.0, 1.0, 1.0, f), 5.0, true)
		rays(end, 10, 30.0, 190.0, Color(0.9, 0.95, 1.0), f, t * 8.0, 9.0)
		shock(end, 130.0, 34.0, t / life, Color(0.85, 0.92, 1.0))
		draw_circle(end, 50.0 * (0.6 + t / life), Color(0.8, 0.9, 1.0, 0.45 * f))
		paw(end + Vector2(0.0, -14.0), 26.0, Color(1.0, 1.0, 0.75, f))
		for i in 5:
			var a := PI + PI * (float(i) + 0.5) / 5.0
			paw(end + Vector2(cos(a), sin(a)) * 80.0 * (0.5 + t / life), 10.0, Color(0.85, 0.92, 1.0, f), a)

## วงเวทบนพื้น ขาว (ใต้เท้า) หรือชมพูม่วง (ใต้มอน) ลำแสงทรงกระบอกพุ่งขึ้น
class Circle extends Base:
	var tint := Color(1.0, 1.0, 1.0)
	var radius := 190.0
	var high := 420.0
	func _init() -> void:
		life = 0.8
	func _draw() -> void:
		var g := clampf(t / 0.12, 0.0, 1.0)
		var f := fade()
		var r := radius * g
		var ry := r * 0.22
		# วงนอกสุดขีดหมุน แสงบนพื้นกว้าง
		SoftDraw.poly(self, oval(Vector2.ZERO, r * 1.35, ry * 1.35), Color(tint, 0.08 * f))
		for i in 16:
			var a := -t * 1.4 + TAU * float(i) / 16.0
			draw_line(Vector2(cos(a) * r * 1.15, sin(a) * ry * 1.15), Vector2(cos(a + 0.18) * r * 1.15, sin(a + 0.18) * ry * 1.15), Color(tint, 0.8 * f), 4.0, true)
		SoftDraw.poly(self, oval(Vector2.ZERO, r, ry), Color(tint, 0.18 * f))
		ring(Vector2.ZERO, r, ry, Color(tint, 0.95 * f), 6.0)
		ring(Vector2.ZERO, r * 0.7, ry * 0.7, Color(tint, 0.75 * f), 3.0)
		for i in 6:
			var a := t * 2.0 + TAU * float(i) / 6.0
			var b := a + TAU / 3.0
			draw_line(Vector2(cos(a) * r * 0.7, sin(a) * ry * 0.7), Vector2(cos(b) * r * 0.7, sin(b) * ry * 0.7), Color(tint, 0.6 * f), 2.5, true)
			draw_set_transform(Vector2(cos(a) * r, sin(a) * ry), 0.0, Vector2(1.0, 0.45))
			paw(Vector2.ZERO, r * 0.09, Color(tint, 0.95 * f))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.3))
		ears(Vector2(0.0, -r * 0.3), r * 0.22, r * 0.2, Color(tint, 0.5 * f))
		cat_face(Vector2.ZERO, r * 0.35, Color(tint, 0.7 * f))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var rise := clampf((t - 0.08) / 0.2, 0.0, 1.0) * f
		if rise > 0.0:
			var h := high * rise
			var lo := Color(tint, 0.4 * rise)
			var hi := Color(tint, 0.0)
			SoftDraw.poly_c(self, PackedVector2Array([Vector2(-r * 1.15, 0.0), Vector2(r * 1.15, 0.0), Vector2(r * 0.7, -h * 1.5), Vector2(-r * 0.7, -h * 1.5)]), PackedColorArray([lo, lo, hi, hi]))
			SoftDraw.poly(self, PackedVector2Array([Vector2(-r, 0.0), Vector2(-r * 0.9, -h), Vector2(r * 0.9, -h), Vector2(r, 0.0)]), Color(tint, 0.22 * rise))
			draw_line(Vector2(-r, 0.0), Vector2(-r * 0.9, -h), Color(tint, 0.6 * rise), 4.0, true)
			draw_line(Vector2(r, 0.0), Vector2(r * 0.9, -h), Color(tint, 0.6 * rise), 4.0, true)
			for i in 5:
				var y := -fposmod(t * 600.0 + float(i) * 90.0, h)
				if i % 2 == 0:
					star(Vector2((float(i) - 2.0) * r * 0.35, y), 8.0, t * 5.0, Color(tint.lightened(0.3), 0.8 * rise))
				else:
					paw(Vector2((float(i) - 2.0) * r * 0.35, y), 9.0, Color(tint.lightened(0.3), 0.8 * rise), sin(t * 4.0 + float(i)) * 0.4)

## วงเวทตั้งเฉียงลงด้านหน้า ปล่อยลำแสงลงพื้น
class TiltCircle extends Base:
	var dir := 1.0
	func _init() -> void:
		life = 0.75
	func _draw() -> void:
		var g := clampf(t / 0.12, 0.0, 1.0)
		var f := fade()
		draw_set_transform(Vector2.ZERO, dir * PI * 0.25, Vector2(1.0, 1.0))
		var r := 110.0 * g
		SoftDraw.poly(self, oval(Vector2.ZERO, r * 0.3, r), Color(1.0, 0.6, 0.9, 0.25 * f))
		ring(Vector2.ZERO, r * 0.3, r, Color(1.0, 0.75, 0.95, 0.95 * f), 5.0)
		ring(Vector2.ZERO, r * 0.2, r * 0.68, Color(0.75, 0.45, 1.0, 0.8 * f), 3.0)
		paw(Vector2.ZERO, r * 0.16, Color(1.0, 0.85, 0.97, 0.9 * f), -dir * PI * 0.25)
		draw_set_transform(Vector2.ZERO, dir * PI * 0.25, Vector2(1.0, 1.0))
		for side in [-1.0, 1.0]:
			var b := Vector2(0.0, side * r * 0.62)
			SoftDraw.poly(self, PackedVector2Array([b + Vector2(-r * 0.18, -side * r * 0.12), b + Vector2(-r * 0.62, side * r * 0.08), b + Vector2(-r * 0.22, side * r * 0.34)]), Color(1.0, 0.75, 0.95, 0.9 * f))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var beam := clampf((t - 0.1) / 0.15, 0.0, 1.0) * f
		if beam > 0.0:
			var to := Vector2(dir, 1.0) * (-position.y) / grand
			draw_line(Vector2.ZERO, to, Color(1.0, 0.55, 0.9, 0.2 * beam), 120.0, true)
			rays(to, 10, 30.0, 220.0, Color(1.0, 0.75, 0.95), beam, t * 4.0, 12.0)
			shock(to, 160.0, 40.0, clampf((t - 0.1) / 0.5, 0.0, 1.0), Color(1.0, 0.8, 0.95))
			draw_line(Vector2.ZERO, to, Color(1.0, 0.55, 0.9, 0.45 * beam), 60.0, true)
			draw_line(Vector2.ZERO, to, Color(1.0, 0.9, 1.0, 0.9 * beam), 16.0, true)
			draw_circle(to, 70.0, Color(1.0, 0.6, 0.9, 0.35 * beam))
			paw(to + Vector2(0.0, -16.0), 30.0, Color(1.0, 0.85, 0.97, 0.9 * beam))

## ผงมิติสีชมพูม่วงระยิบ ลอยไปข้างหน้าช้าๆ เรียกกลับได้
class Dust extends Base:
	var vel := Vector2.ZERO
	var back_to := Vector2.ZERO
	var returning := false
	var _bits: Array = []
	func _init() -> void:
		life = 2.4
		for i in 26:
			_bits.append([Vector2(randf_range(-110.0, 110.0), randf_range(-150.0, -10.0)), randf() * TAU, randf_range(4.0, 9.0)])
	func recall(to: Vector2) -> void:
		returning = true
		back_to = to
		life = t + 0.4
	func _step(delta: float) -> void:
		if returning:
			position = position.lerp(back_to, 1.0 - exp(-12.0 * delta))
		else:
			position += vel * delta
	func _draw() -> void:
		var f := fade() * clampf(t / 0.15, 0.0, 1.0)
		halo(Vector2(0.0, -80.0), 150.0, Color(0.85, 0.4, 1.0), f)
		for i in 3:
			var a := t * 1.2 + TAU * float(i) / 3.0
			draw_arc(Vector2(0.0, -80.0), 140.0 + 10.0 * float(i), a, a + 1.6, 16, Color(1.0, 0.65, 0.95, 0.5 * f), 4.0, true)
		for b in _bits:
			var p: Vector2 = (b[0] as Vector2) + Vector2(sin(t * 3.0 + float(b[1])) * 12.0, cos(t * 2.5 + float(b[1])) * 10.0)
			if returning:
				p *= 0.6
			var tw := 0.6 + 0.4 * sin(t * 10.0 + float(b[1]))
			if int(float(b[1]) * 10.0) % 3 == 0:
				paw(p, float(b[2]) * tw * 1.2, Color(1.0, 0.7, 0.95, 0.9 * f), float(b[1]))
			else:
				star(p, float(b[2]) * tw, t * 3.0 + float(b[1]), Color(1.0, 0.55, 0.9, 0.9 * f) if int(b[2]) % 2 == 0 else Color(0.75, 0.55, 1.0, 0.9 * f))
		var blink := clampf(absf(sin(t * 1.7)) * 1.6, 0.0, 1.0)
		for side in [-1.0, 1.0]:
			cat_eye(Vector2(side * 34.0, -86.0), 22.0, 12.0 * blink + 1.0, Color(1.0, 0.6, 0.95, 0.35 * f), Color(0.45, 0.1, 0.5, 0.45 * f))

## บอลมิติชมพูเหนือหัว แล้วพุ่งฟาดเฉียงลงพื้น
class DimBall extends Base:
	var radius := 70.0
	var flying := false
	var from := Vector2.ZERO
	var to := Vector2.ZERO
	var _fly_t := 0.0
	var landed := false
	func _init() -> void:
		life = 2.0
	func throw(at: Vector2) -> void:
		flying = true
		from = position
		to = at
		_fly_t = 0.0
	func _step(delta: float) -> void:
		if flying and not landed:
			_fly_t += delta
			var k := clampf(_fly_t / 0.14, 0.0, 1.0)
			position = from.lerp(to, k * k)
			if k >= 1.0:
				landed = true
				life = t + 0.45
	func _draw() -> void:
		var g := clampf(t / 0.2, 0.0, 1.0)
		var r := radius * g
		if landed:
			var k := clampf((life - t) / 0.45, 0.0, 1.0)
			ring(Vector2.ZERO, 280.0 * (1.2 - k), 60.0 * (1.2 - k), Color(1.0, 0.6, 0.9, k), 10.0 * k + 2.0)
			ring(Vector2.ZERO, 420.0 * (1.2 - k), 90.0 * (1.2 - k), Color(0.8, 0.5, 1.0, 0.7 * k), 6.0 * k + 1.0)
			rays(Vector2(0.0, -40.0), 12, 60.0, 340.0 * (1.3 - k), Color(1.0, 0.75, 0.95), k, 0.2, 16.0)
			var lo := Color(1.0, 0.7, 0.95, 0.5 * k)
			var hi := Color(1.0, 0.7, 0.95, 0.0)
			SoftDraw.poly_c(self, PackedVector2Array([Vector2(-90.0, 0.0), Vector2(90.0, 0.0), Vector2(40.0, -700.0), Vector2(-40.0, -700.0)]), PackedColorArray([lo, lo, hi, hi]))
			draw_circle(Vector2(0.0, -r), r * k, Color(1.0, 0.5, 0.85, 0.8 * k))
			draw_set_transform(Vector2(0.0, -6.0), 0.0, Vector2(1.0, 0.35))
			paw(Vector2.ZERO, 110.0 * (1.2 - k * 0.4), Color(1.0, 0.55, 0.88, 0.75 * k))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			return
		halo(Vector2.ZERO, r * 1.4, Color(1.0, 0.45, 0.85), 1.0)
		for i in 6:
			var a := t * 3.0 + TAU * float(i) / 6.0
			twinkle(Vector2(cos(a) * r * 1.6, sin(a) * r * 0.7), r * 0.18, Color(1.0, 0.9, 1.0, 0.9))
		draw_circle(Vector2.ZERO, r * 1.3, Color(1.0, 0.45, 0.85, 0.2))
		ears(Vector2(0.0, -r * 0.72), r * 0.5, r * 0.55, Color(0.7, 0.3, 0.95, 0.95))
		draw_circle(Vector2.ZERO, r, Color(0.7, 0.3, 0.95, 0.95))
		for arm in 3:
			var pts := PackedVector2Array()
			for n in 14:
				var k := float(n) / 13.0
				var a := t * 6.0 + TAU * float(arm) / 3.0 + k * 4.0
				pts.append(Vector2(cos(a), sin(a)) * r * 0.85 * (1.0 - k * 0.9))
			SoftDraw.pline(self, pts, Color(1.0, 0.7, 0.95, 0.9), maxf(2.0, r * 0.08), true)
		draw_circle(Vector2.ZERO, r * 0.2, Color(1, 0.9, 1))
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, Color(1.0, 0.8, 0.95), 3.0, true)
		if r > 20.0:
			cat_face(Vector2(0.0, r * 0.1), r * 0.6, Color(1.0, 0.92, 1.0, 0.95))

## ขวดยาทรงกลมน้ำยาแดง หมุนตอนลอย
class Potion extends Base:
	var spin := 0.0
	func _init() -> void:
		life = 5.0
	func _draw() -> void:
		draw_set_transform(Vector2.ZERO, spin, Vector2.ONE)
		draw_circle(Vector2.ZERO, 20.0, Color(0.85, 0.95, 1.0, 0.5))
		draw_circle(Vector2(0.0, 5.0), 15.0, Color(0.9, 0.08, 0.15))
		draw_rect(Rect2(-6.0, -32.0, 12.0, 14.0), Color(0.85, 0.95, 1.0, 0.6))
		draw_rect(Rect2(-7.0, -38.0, 14.0, 8.0), Color(0.72, 0.5, 0.27))
		ears(Vector2(0.0, -38.0), 7.0, 4.5, Color(0.72, 0.5, 0.27))
		draw_circle(Vector2(0.0, 6.0), 8.5, Color(1.0, 0.95, 0.85))
		paw(Vector2(0.0, 7.0), 6.5, Color(0.9, 0.3, 0.45))
		draw_circle(Vector2(-7.0, -5.0), 4.0, Color(1, 1, 1, 0.8))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## ขวดแตก น้ำยาแดงกระเซ็น แอ่งน้ำยาบนพื้น ฟองลอยขึ้น
class Splash extends Base:
	var radius := 140.0
	var tint := Color(0.92, 0.1, 0.18)
	var _drops: Array = []
	func _init() -> void:
		life = 0.8
	func _ready() -> void:
		for i in 14:
			var a := randf_range(PI * 1.05, PI * 1.95)
			_drops.append([Vector2(cos(a), sin(a)) * randf_range(250.0, 600.0), randf_range(5.0, 11.0)])
	func _draw() -> void:
		var k := t / life
		var f := fade()
		shock(Vector2.ZERO, radius * 1.3, radius * 0.3, k, Color(1.0, 0.85, 0.75))
		halo(Vector2(0.0, -40.0), radius * 0.6, tint, f)
		SoftDraw.poly(self, oval(Vector2.ZERO, radius * minf(k * 3.0, 1.0), radius * 0.22 * minf(k * 3.0, 1.0)), Color(tint, 0.55 * f))
		ring(Vector2.ZERO, radius * (0.5 + k), radius * 0.25 * (0.5 + k), Color(1.0, 0.75, 0.6, 0.8 * (1.0 - k)), 4.0)
		for d in _drops:
			var p: Vector2 = (d[0] as Vector2) * t + Vector2(0.0, 1400.0 * t * t)
			if p.y < 0.0:
				if int(float(d[1])) % 3 == 0:
					paw(p, float(d[1]) * 1.4 * (1.0 - k), Color(tint, f), t * 8.0)
				else:
					draw_circle(p, float(d[1]) * (1.0 - k), Color(tint, f))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.3))
		paw(Vector2.ZERO, radius * 0.4 * minf(k * 3.0, 1.0), Color(1.0, 0.8, 0.75, 0.55 * f))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		for i in 4:
			var y := -fposmod(t * 160.0 + float(i) * 30.0, 120.0)
			if i == 1:
				fishbone(Vector2((float(i) - 1.5) * radius * 0.35, y), 12.0, Color(1.0, 0.85, 0.8, 0.85 * f), sin(t * 6.0) * 0.4)
			else:
				draw_arc(Vector2((float(i) - 1.5) * radius * 0.35, y), 7.0, 0.0, TAU, 12, Color(1.0, 0.7, 0.75, 0.8 * f), 2.0, true)

## หม้อปรุงยาสีม่วงตกจากฟ้าทับ ขอบทองมีขาสามขา ลายดาว น้ำยาม่วงเรืองเดือดเป็นฟอง
class Cauldron extends Base:
	var fall_from := -1100.0
	var landed := false
	func _init() -> void:
		life = 1.6
	func _step(_delta: float) -> void:
		var k := clampf(t / 0.32, 0.0, 1.0)
		position.y = lerpf(fall_from, 0.0, k * k)
		landed = k >= 1.0
	func _draw() -> void:
		var f := fade()
		var body := PackedVector2Array()
		for i in 25:
			var a := PI * float(i) / 24.0
			body.append(Vector2(cos(a) * 150.0, -95.0 + sin(a) * 105.0))
		body.append(Vector2(-150.0, -150.0))
		body.append(Vector2(150.0, -150.0))
		for side in [-1.0, 0.0, 1.0]:
			draw_rect(Rect2(side * 95.0 - 12.0, -20.0, 24.0, 22.0), Color(0.85, 0.65, 0.2, f))
		ears(Vector2(0.0, -160.0), 46.0, 120.0, Color(0.42, 0.18, 0.62, f))
		SoftDraw.poly(self, body, Color(0.42, 0.18, 0.62, f))
		SoftDraw.poly(self, PackedVector2Array([Vector2(-110.0, -60.0), Vector2(-80.0, -40.0), Vector2(-120.0, -20.0)]), Color(0.62, 0.38, 0.85, 0.6 * f))
		paw(Vector2(0.0, -70.0), 34.0, Color(1.0, 0.85, 0.35, f))
		cat_face(Vector2(-92.0, -100.0), 26.0, Color(1.0, 0.85, 0.35, 0.9 * f))
		for side in [-1.0, 1.0]:
			for w in 2:
				draw_line(Vector2(side * 120.0, -86.0 + float(w) * 14.0), Vector2(side * 168.0, -92.0 + float(w) * 22.0), Color(1.0, 0.85, 0.35, 0.8 * f), 3.0, true)
		draw_rect(Rect2(-168.0, -170.0, 336.0, 28.0), Color(0.95, 0.75, 0.25, f))
		SoftDraw.poly(self, oval(Vector2(0.0, -170.0), 150.0, 26.0), Color(0.75, 0.35, 1.0, f))
		SoftDraw.poly(self, oval(Vector2(0.0, -172.0), 110.0, 16.0), Color(0.9, 0.6, 1.0, 0.8 * f))
		for i in 5:
			var y := -180.0 - fposmod(t * 140.0 + float(i) * 25.0, 110.0)
			var bx := (float(i) - 2.0) * 45.0 + sin(t * 4.0 + float(i)) * 8.0
			if i == 2:
				fishbone(Vector2(bx, y), 16.0, Color(0.95, 0.85, 1.0, 0.9 * f), sin(t * 5.0) * 0.5)
			else:
				draw_circle(Vector2(bx, y), 10.0 + float(i % 2) * 5.0, Color(0.85, 0.55, 1.0, 0.8 * f))
		if landed:
			var k := clampf((t - 0.32) / 0.4, 0.0, 1.0)
			ring(Vector2.ZERO, 200.0 + 300.0 * k, 40.0 + 60.0 * k, Color(0.85, 0.6, 1.0, 1.0 - k), 8.0 * (1.0 - k) + 1.0)
			shock(Vector2.ZERO, 520.0, 110.0, k, Color(0.8, 0.55, 1.0))
			rays(Vector2(0.0, -100.0), 12, 120.0, 420.0, Color(0.9, 0.7, 1.0), (1.0 - k) * f, 0.1, 18.0)
			# ไอม่วงพวยพุ่งขึ้นจากหม้อ
			var lo := Color(0.75, 0.45, 1.0, 0.4 * f)
			var hi := Color(0.75, 0.45, 1.0, 0.0)
			SoftDraw.poly_c(self, PackedVector2Array([Vector2(-130.0, -170.0), Vector2(130.0, -170.0), Vector2(60.0, -700.0), Vector2(-60.0, -700.0)]), PackedColorArray([lo, lo, hi, hi]))

## ลูกบอลมืด แกนดำ ขอบม่วงเรือง เกลียวม่วงหมุน มีเศษมืดถูกดูดเข้า ลอยขึ้นลงเบาๆ
class DarkOrb extends Base:
	var popping := false
	var _pop_t := 0.0
	func pop() -> void:
		popping = true
		_pop_t = 0.0
		life = t + 0.3
	func _draw() -> void:
		var g := clampf(t / 0.15, 0.0, 1.0) * fade()
		var bob := Vector2(0.0, sin(t * 4.0) * 6.0)
		var r := 42.0 * g
		if popping:
			var k := clampf((0.3 - (life - t)) / 0.3, 0.0, 1.0)
			ring(bob, 60.0 + 120.0 * k, 60.0 + 120.0 * k, Color(0.7, 0.4, 1.0, 1.0 - k), 8.0 * (1.0 - k) + 1.0)
			ring(bob, 40.0 + 220.0 * k, 40.0 + 220.0 * k, Color(0.9, 0.7, 1.0, 0.7 * (1.0 - k)), 5.0 * (1.0 - k) + 1.0)
			rays(bob, 10, 30.0, 260.0 * k + 40.0, Color(0.8, 0.55, 1.0), 1.0 - k, 0.3, 12.0)
			draw_circle(bob, r * (1.0 - k), Color(0.1, 0.0, 0.18, 1.0 - k))
			return
		halo(bob, r * 1.8, Color(0.5, 0.2, 0.85), g)
		for i in 3:
			var a := -t * 2.0 + TAU * float(i) / 3.0
			draw_arc(bob, r * 1.9, a, a + 1.4, 14, Color(0.75, 0.45, 1.0, 0.6 * g), 4.0, true)
		draw_circle(bob, r * 1.6, Color(0.5, 0.2, 0.85, 0.15 * g))
		draw_circle(bob, r * 1.15, Color(0.6, 0.3, 1.0, 0.55 * g))
		ears(bob + Vector2(0.0, -r * 0.7), r * 0.55, r * 0.55, Color(0.06, 0.0, 0.12, g), Color(0.6, 0.3, 1.0))
		draw_circle(bob, r, Color(0.06, 0.0, 0.12, g))
		for arm in 3:
			var pts := PackedVector2Array()
			for n in 12:
				var k := float(n) / 11.0
				var a := -t * 5.0 + TAU * float(arm) / 3.0 + k * 3.5
				pts.append(bob + Vector2(cos(a), sin(a)) * r * 0.95 * (1.0 - k * 0.85))
			SoftDraw.pline(self, pts, Color(0.55, 0.25, 0.9, 0.85 * g), maxf(2.0, r * 0.08), true)
		draw_arc(bob, r, 0.0, TAU, 36, Color(0.8, 0.55, 1.0, g), 3.0, true)
		var blink := clampf(absf(sin(t * 1.3)) * 2.0, 0.0, 1.0)
		cat_eye(bob + Vector2(0.0, -r * 0.05), r * 0.62, r * 0.36 * blink + 1.0, Color(0.85, 0.55, 1.0, g), Color(0.05, 0.0, 0.1, g))
		for i in 6:
			var a := TAU * float(i) / 6.0 + t * 1.5
			var d := r * (2.2 - fposmod(t * 1.6 + float(i) * 0.17, 1.0) * 1.2)
			draw_circle(bob + Vector2(cos(a), sin(a)) * d, 4.0, Color(0.7, 0.45, 1.0, 0.8 * g))

## คฑาทุบพื้น พื้นแตกม่วงมืดเป็นแฉก คลื่นกระแทกวงรี
class Quake extends Base:
	var _cracks: Array = []
	func _init() -> void:
		life = 0.7
		for i in 7:
			var a := PI + PI * (float(i) + 0.5) / 7.0
			_cracks.append([a, randf_range(90.0, 170.0)])
	func _draw() -> void:
		var k := t / life
		var f := fade()
		shock(Vector2.ZERO, 420.0, 90.0, k, Color(0.75, 0.5, 1.0))
		var lo := Color(0.6, 0.3, 0.95, 0.45 * f * (1.0 - k))
		var hi := Color(0.6, 0.3, 0.95, 0.0)
		SoftDraw.poly_c(self, PackedVector2Array([Vector2(-120.0, 0.0), Vector2(120.0, 0.0), Vector2(50.0, -420.0), Vector2(-50.0, -420.0)]), PackedColorArray([lo, lo, hi, hi]))
		ring(Vector2.ZERO, 60.0 + 260.0 * k, 14.0 + 50.0 * k, Color(0.65, 0.35, 1.0, 1.0 - k), 8.0 * (1.0 - k) + 1.0)
		for c in _cracks:
			var a: float = c[0]
			var reach: float = float(c[1]) * minf(k * 5.0, 1.0)
			var mid := Vector2(cos(a) * reach * 0.5, sin(a) * reach * 0.12 + 4.0)
			SoftDraw.pline(self, PackedVector2Array([Vector2.ZERO, mid + Vector2(8.0, 0.0), Vector2(cos(a) * reach, 6.0 + sin(a) * reach * 0.15)]), Color(0.25, 0.05, 0.4, f), 5.0, true)
		draw_set_transform(Vector2(0.0, 2.0), 0.0, Vector2(1.0, 0.3))
		paw(Vector2.ZERO, 70.0 * minf(k * 4.0, 1.0), Color(0.3, 0.08, 0.45, 0.75 * f))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		for i in 5:
			var x := (float(i) - 2.0) * 50.0
			var y := -120.0 * k + absf(float(i) - 2.0) * 10.0
			paw(Vector2(x, y), 11.0 * (1.0 - k), Color(0.55, 0.3, 0.8, 0.8 * f), k * 5.0 + float(i))

## ควันวาร์ป วงดาวแตกกระจาย
class Poof extends Base:
	func _init() -> void:
		life = 0.35
	func _draw() -> void:
		var k := t / life
		for i in 8:
			var a := TAU * float(i) / 8.0
			var p := Vector2(cos(a), sin(a)) * 70.0 * k + Vector2(0.0, -60.0)
			if i % 2 == 0:
				star(p, 12.0 * (1.0 - k), a, Color(1.0, 0.65, 0.95, 1.0 - k))
			else:
				paw(p, 11.0 * (1.0 - k), Color(1.0, 0.75, 0.95, 1.0 - k), a + PI * 0.5)
		draw_circle(Vector2(0.0, -60.0), 50.0 * (1.0 - k), Color(0.9, 0.6, 1.0, 0.4 * (1.0 - k)))
		ring(Vector2(0.0, -60.0), 30.0 + 110.0 * k, 30.0 + 110.0 * k, Color(1.0, 0.8, 0.97, 0.8 * (1.0 - k)), 6.0 * (1.0 - k) + 1.0)
		ears(Vector2(0.0, -60.0 - 40.0 * (1.0 - k)), 22.0 * (1.0 - k), 22.0 * (1.0 - k), Color(0.9, 0.6, 1.0, 0.5 * (1.0 - k)))
