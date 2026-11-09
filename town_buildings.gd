class_name TownBuildings
## อาคารของแต่ละเมือง (9 เมือง) สไตล์สีน้ำ + กระดาษตัด ขอบหมึกบาง ทรงมน ไม่มีดาว
## kinds(town) คืนรายชื่อแบบอาคารของเมืองนั้น  draw(...) วาดอาคารโดยจุดกึ่งกลางล่างอยู่ที่ base
## base คือพื้น (y ขึ้นเป็นลบ) width/height ขนาดโดยประมาณ seed_no ทำให้สีกับรายละเอียดต่างกันนิดหน่อย

const INK := Color(0.2, 0.17, 0.15, 0.85)
const WARM := Color(1.0, 0.86, 0.5)
const WARM_DIM := Color(0.98, 0.78, 0.45)
const LINE_W := 2.0

const KINDS := {
	0: ["timber", "bakery", "guild", "clock", "inn", "smithy", "tower_house", "flower_shop"],
	1: ["fish_stall", "round_hut", "net_rack", "sardine_can", "fish_sign_shop", "fish_house", "dock_shed"],
	2: ["chalet", "mine_gate", "water_wheel", "mushroom", "stone_house", "lookout"],
	3: ["warehouse", "lighthouse", "boat_house", "seal_fountain", "buoy_shop", "harbor_inn", "crane"],
	4: ["adobe", "tent", "cat_pyramid", "palm_pavilion", "canopy", "minaret", "well"],
	5: ["igloo", "log_cabin", "ice_tower", "hot_spring", "snow_shop", "ice_igloo_big"],
	6: ["stone_hut", "forge", "obsidian_arch", "steam_vent", "lava_lamp_house", "ash_tower"],
	7: ["gothic_tower", "library", "arcade", "bat_banner_house", "cat_spire", "lantern_hall"],
	8: ["cloud_temple", "dome_pavilion", "gazebo", "rainbow_arch", "bell_tower", "cloud_house"],
}

## สีหลักของแต่ละเมือง [ผนัง, หลังคา, เน้น, ไม้/โครง]
const PALETTE := {
	0: [Color(0.99, 0.93, 0.82), Color(0.9, 0.48, 0.38), Color(0.95, 0.75, 0.3), Color(0.55, 0.38, 0.26)],
	1: [Color(0.92, 0.95, 0.98), Color(0.4, 0.6, 0.85), Color(0.95, 0.55, 0.45), Color(0.6, 0.48, 0.36)],
	2: [Color(0.88, 0.85, 0.8), Color(0.55, 0.42, 0.32), Color(0.55, 0.75, 0.45), Color(0.48, 0.36, 0.26)],
	3: [Color(0.9, 0.92, 0.95), Color(0.35, 0.5, 0.72), Color(0.92, 0.4, 0.38), Color(0.55, 0.45, 0.38)],
	4: [Color(0.96, 0.84, 0.66), Color(0.86, 0.6, 0.38), Color(0.35, 0.62, 0.7), Color(0.68, 0.5, 0.32)],
	5: [Color(0.95, 0.97, 1.0), Color(0.62, 0.42, 0.32), Color(0.55, 0.78, 0.95), Color(0.55, 0.4, 0.3)],
	6: [Color(0.5, 0.46, 0.48), Color(0.36, 0.32, 0.36), Color(1.0, 0.55, 0.25), Color(0.4, 0.34, 0.32)],
	7: [Color(0.72, 0.68, 0.82), Color(0.42, 0.38, 0.58), Color(0.95, 0.75, 0.4), Color(0.4, 0.34, 0.45)],
	8: [Color(1.0, 0.98, 0.93), Color(0.98, 0.84, 0.45), Color(0.75, 0.85, 1.0), Color(0.9, 0.75, 0.45)],
}

static func kinds(town: int) -> Array:
	return (KINDS.get(clampi(town, 0, 8), KINDS[0]) as Array).duplicate()

static func draw(canvas: CanvasItem, town: int, kind: String, base: Vector2, width: float, height: float, seed_no: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_no * 7919 + town * 131 + kind.hash()
	var pal: Array = PALETTE.get(clampi(town, 0, 8), PALETTE[0])
	var wall: Color = _vary(pal[0], rng)
	var roof: Color = _vary(pal[1], rng)
	var accent: Color = _vary(pal[2], rng)
	var wood: Color = pal[3]
	var c := canvas
	var w := width
	var h := height
	var b := base
	# เงานุ่มใต้อาคาร
	_oval(c, b + Vector2(0.0, 2.0), w * 0.55, 7.0, Color(0, 0, 0, 0.1))
	match kind:
		# ---------------- เมือง 0 อัศวินเหมียว
		"timber":
			_box(c, b, w * 0.8, h * 0.6, wall)
			for i in 3:
				var x := b.x - w * 0.4 + w * 0.8 * float(i + 1) / 4.0
				c.draw_line(Vector2(x, b.y), Vector2(x, b.y - h * 0.6), wood, 4.0)
			c.draw_line(Vector2(b.x - w * 0.4, b.y - h * 0.32), Vector2(b.x + w * 0.4, b.y - h * 0.32), wood, 4.0)
			_roof(c, b.x, b.y - h * 0.6, w * 0.95, h * 0.4, roof)
			_window(c, b + Vector2(-w * 0.2, -h * 0.45), w * 0.12)
			_window(c, b + Vector2(w * 0.2, -h * 0.45), w * 0.12)
			_door(c, b.x, b.y, w * 0.16, h * 0.26, wood)
			_plant(c, b + Vector2(w * 0.36, 0.0), w * 0.08, rng)
		"bakery":
			_box(c, b, w * 0.8, h * 0.62, wall)
			_awning(c, b.x - w * 0.42, b.y - h * 0.5, w * 0.84, h * 0.1, accent, Color(1, 1, 1), 6)
			_ears(c, b.x, b.y - h * 0.5, w * 0.36, w * 0.1, accent)
			_roof(c, b.x, b.y - h * 0.62, w * 0.9, h * 0.32, roof)
			_window(c, b + Vector2(-w * 0.22, -h * 0.25), w * 0.16)
			_door(c, b.x + w * 0.18, b.y, w * 0.16, h * 0.3, wood)
			_sign(c, b + Vector2(0.0, -h * 0.78), w * 0.1, "bread", accent)
			_chimney(c, b.x + w * 0.25, b.y - h * 0.8, w * 0.08, h * 0.16, wood, true)
		"guild":
			_box(c, b, w, h * 0.6, wall)
			_roof(c, b.x, b.y - h * 0.6, w * 1.08, h * 0.32, roof)
			for s in [-1.0, 1.0]:
				_banner(c, Vector2(b.x + s * w * 0.32, b.y - h * 0.58), w * 0.1, h * 0.26, accent)
			_door(c, b.x, b.y, w * 0.22, h * 0.36, wood, true)
			_sign(c, b + Vector2(0.0, -h * 0.5), w * 0.11, "paw", accent)
			_window(c, b + Vector2(-w * 0.18, -h * 0.3), w * 0.1)
			_window(c, b + Vector2(w * 0.18, -h * 0.3), w * 0.1)
		"clock":
			_box(c, b, w * 0.42, h * 0.85, wall)
			_roof(c, b.x, b.y - h * 0.85, w * 0.55, h * 0.18, roof)
			var cc := b + Vector2(0.0, -h * 0.66)
			c.draw_circle(cc, w * 0.15, Color(1, 1, 0.95))
			c.draw_arc(cc, w * 0.15, 0.0, TAU, 24, INK, LINE_W, true)
			c.draw_line(cc, cc + Vector2(0.0, -w * 0.1), INK, 3.0)
			c.draw_line(cc, cc + Vector2(w * 0.07, 0.0), INK, 3.0)
			_ears(c, b.x, b.y - h * 0.85, w * 0.22, w * 0.07, roof)
			_door(c, b.x, b.y, w * 0.14, h * 0.2, wood, true)
		"inn":
			_box(c, b, w * 0.9, h * 0.68, wall)
			c.draw_line(Vector2(b.x - w * 0.45, b.y - h * 0.36), Vector2(b.x + w * 0.45, b.y - h * 0.36), wood, 5.0)
			_roof(c, b.x, b.y - h * 0.68, w, h * 0.3, roof)
			for i in 3:
				_window(c, b + Vector2(-w * 0.28 + w * 0.28 * float(i), -h * 0.52), w * 0.1)
			_door(c, b.x - w * 0.2, b.y, w * 0.16, h * 0.28, wood)
			_sign(c, b + Vector2(w * 0.3, -h * 0.25), w * 0.1, "fish", accent)
			_laundry(c, b + Vector2(-w * 0.45, -h * 0.4), w * 0.9, rng)
		"smithy":
			_box(c, b, w * 0.8, h * 0.5, wall.darkened(0.08))
			_roof(c, b.x, b.y - h * 0.5, w * 0.92, h * 0.25, roof)
			_chimney(c, b.x - w * 0.25, b.y - h * 0.7, w * 0.12, h * 0.3, Color(0.5, 0.45, 0.45), true)
			c.draw_rect(Rect2(b.x - w * 0.12, b.y - h * 0.32, w * 0.3, h * 0.32), Color(0.95, 0.55, 0.3, 0.9))
			_outline_rect(c, Rect2(b.x - w * 0.12, b.y - h * 0.32, w * 0.3, h * 0.32))
			_sign(c, b + Vector2(-w * 0.28, -h * 0.3), w * 0.09, "paw", accent)
		"tower_house":
			_box(c, b + Vector2(-w * 0.15, 0.0), w * 0.55, h * 0.55, wall)
			_box(c, b + Vector2(w * 0.25, 0.0), w * 0.3, h * 0.8, wall.darkened(0.05))
			_roof(c, b.x - w * 0.15, b.y - h * 0.55, w * 0.65, h * 0.28, roof)
			_cone_roof(c, b.x + w * 0.25, b.y - h * 0.8, w * 0.38, h * 0.22, roof)
			_window(c, b + Vector2(w * 0.25, -h * 0.6), w * 0.09, true)
			_window(c, b + Vector2(-w * 0.2, -h * 0.35), w * 0.12)
			_door(c, b.x - w * 0.05, b.y, w * 0.14, h * 0.24, wood)
		"flower_shop":
			_box(c, b, w * 0.75, h * 0.55, wall)
			_awning(c, b.x - w * 0.4, b.y - h * 0.44, w * 0.8, h * 0.1, Color(0.95, 0.6, 0.7), Color(1, 1, 1), 5)
			_roof(c, b.x, b.y - h * 0.55, w * 0.85, h * 0.28, roof)
			for i in 5:
				_plant(c, b + Vector2(-w * 0.32 + w * 0.16 * float(i), 0.0), w * 0.07, rng)
			_window(c, b + Vector2(0.0, -h * 0.25), w * 0.18)
		# ---------------- เมือง 1 ตลาดปลาทู
		"fish_stall":
			c.draw_rect(Rect2(b.x - w * 0.42, b.y - h * 0.22, w * 0.84, h * 0.22), wood)
			_outline_rect(c, Rect2(b.x - w * 0.42, b.y - h * 0.22, w * 0.84, h * 0.22))
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.4, b.y - h * 0.22), Vector2(b.x + s * w * 0.4, b.y - h * 0.62), wood, 4.0)
			_awning(c, b.x - w * 0.48, b.y - h * 0.7, w * 0.96, h * 0.14, accent, Color(1, 1, 1), 7)
			for i in 4:
				_fish(c, b + Vector2(-w * 0.28 + w * 0.18 * float(i), -h * 0.27), w * 0.07, Color(0.6, 0.75, 0.9))
		"round_hut":
			_dome(c, b, w * 0.42, h * 0.62, wall)
			_cone_roof(c, b.x, b.y - h * 0.5, w * 0.7, h * 0.32, roof)
			_door(c, b.x, b.y, w * 0.18, h * 0.3, wood, true)
			_window(c, b + Vector2(w * 0.2, -h * 0.3), w * 0.09, true)
		"net_rack":
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.4, b.y), Vector2(b.x + s * w * 0.4, b.y - h * 0.7), wood, 5.0)
			c.draw_line(Vector2(b.x - w * 0.45, b.y - h * 0.68), Vector2(b.x + w * 0.45, b.y - h * 0.68), wood, 5.0)
			var net := PackedVector2Array()
			for i in 13:
				var t := float(i) / 12.0
				net.append(Vector2(b.x - w * 0.38 + w * 0.76 * t, b.y - h * 0.66 + sin(t * PI) * h * 0.25))
			c.draw_polyline(net, Color(0.4, 0.55, 0.65), 3.0, true)
			for i in 6:
				c.draw_line(Vector2(b.x - w * 0.35 + w * 0.14 * float(i), b.y - h * 0.66), net[mini(i * 2 + 1, 12)], Color(0.4, 0.55, 0.65, 0.7), 2.0)
			_fish(c, b + Vector2(0.0, -h * 0.35), w * 0.08, accent)
		"sardine_can":
			var r := Rect2(b.x - w * 0.42, b.y - h * 0.5, w * 0.84, h * 0.5)
			_fill_round(c, r, Color(0.78, 0.82, 0.88), 18.0)
			_fill_round(c, Rect2(r.position + Vector2(6, 6), r.size - Vector2(12, 12)), accent, 14.0)
			_outline_round(c, r, 18.0)
			_fish(c, b + Vector2(0.0, -h * 0.25), w * 0.18, Color(0.55, 0.7, 0.9))
			c.draw_arc(Vector2(r.end.x - 4.0, r.position.y - 6.0), 10.0, PI, TAU, 10, INK, 3.0, true)
			_door(c, b.x - w * 0.25, b.y, w * 0.14, h * 0.26, wood, true)
		"fish_sign_shop":
			_box(c, b, w * 0.75, h * 0.55, wall)
			_roof(c, b.x, b.y - h * 0.55, w * 0.85, h * 0.25, roof)
			_fish(c, b + Vector2(0.0, -h * 0.92), w * 0.3, accent)
			_window(c, b + Vector2(-w * 0.18, -h * 0.3), w * 0.14)
			_door(c, b.x + w * 0.2, b.y, w * 0.14, h * 0.28, wood)
		"fish_house":
			# บ้านทรงปลา ตัวรี หางเป็นหลังคา
			_oval(c, b + Vector2(0.0, -h * 0.35), w * 0.42, h * 0.35, wall)
			c.draw_arc(b + Vector2(0.0, -h * 0.35), w * 0.42, 0.0, TAU, 32, INK, LINE_W, true)
			_poly(c, PackedVector2Array([b + Vector2(w * 0.38, -h * 0.35), b + Vector2(w * 0.55, -h * 0.6), b + Vector2(w * 0.55, -h * 0.1)]), roof)
			c.draw_circle(b + Vector2(-w * 0.25, -h * 0.45), w * 0.05, INK)
			_door(c, b.x, b.y, w * 0.16, h * 0.28, wood, true)
		"dock_shed":
			_box(c, b, w * 0.8, h * 0.5, wood.lightened(0.35))
			for i in 5:
				var x := b.x - w * 0.4 + w * 0.8 * float(i) / 4.0
				c.draw_line(Vector2(x, b.y), Vector2(x, b.y - h * 0.5), wood, 2.0)
			_roof(c, b.x, b.y - h * 0.5, w * 0.9, h * 0.22, roof)
			_buoy(c, b + Vector2(w * 0.3, -h * 0.25), w * 0.06)
		# ---------------- เมือง 2 หมู่บ้านภูเขา
		"chalet":
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.32, b.y), Vector2(b.x + s * w * 0.32, b.y - h * 0.2), wood, 6.0)
			_box(c, b + Vector2(0.0, -h * 0.2), w * 0.75, h * 0.42, wall)
			_roof(c, b.x, b.y - h * 0.62, w * 1.0, h * 0.36, roof)
			_window(c, b + Vector2(0.0, -h * 0.42), w * 0.14)
			c.draw_line(Vector2(b.x - w * 0.37, b.y - h * 0.22), Vector2(b.x + w * 0.37, b.y - h * 0.22), wood, 5.0)
		"mine_gate":
			_dome(c, b, w * 0.42, h * 0.55, Color(0.55, 0.5, 0.48))
			_dome(c, b, w * 0.28, h * 0.4, Color(0.18, 0.15, 0.15))
			c.draw_line(Vector2(b.x - w * 0.3, b.y), Vector2(b.x - w * 0.3, b.y - h * 0.42), wood, 7.0)
			c.draw_line(Vector2(b.x + w * 0.3, b.y), Vector2(b.x + w * 0.3, b.y - h * 0.42), wood, 7.0)
			c.draw_line(Vector2(b.x - w * 0.36, b.y - h * 0.42), Vector2(b.x + w * 0.36, b.y - h * 0.42), wood, 8.0)
			c.draw_circle(b + Vector2(w * 0.36, -h * 0.5), w * 0.05, WARM)
			_cart(c, b + Vector2(-w * 0.1, 0.0), w * 0.2)
		"water_wheel":
			_box(c, b + Vector2(-w * 0.15, 0.0), w * 0.55, h * 0.5, wall)
			_roof(c, b.x - w * 0.15, b.y - h * 0.5, w * 0.65, h * 0.26, roof)
			var wc := b + Vector2(w * 0.25, -h * 0.25)
			c.draw_circle(wc, h * 0.24, wood.lightened(0.2))
			c.draw_arc(wc, h * 0.24, 0.0, TAU, 28, INK, LINE_W, true)
			for i in 8:
				var a := TAU * float(i) / 8.0
				c.draw_line(wc, wc + Vector2(cos(a), sin(a)) * h * 0.24, wood, 3.0)
			c.draw_circle(wc, h * 0.05, wood)
			_window(c, b + Vector2(-w * 0.2, -h * 0.3), w * 0.12)
		"mushroom":
			c.draw_rect(Rect2(b.x - w * 0.16, b.y - h * 0.45, w * 0.32, h * 0.45), Color(0.98, 0.95, 0.88))
			_outline_rect(c, Rect2(b.x - w * 0.16, b.y - h * 0.45, w * 0.32, h * 0.45))
			_dome(c, b + Vector2(0.0, -h * 0.4), w * 0.48, h * 0.48, accent.lerp(Color(0.9, 0.4, 0.4), 0.6))
			for i in 4:
				c.draw_circle(b + Vector2(-w * 0.28 + w * 0.18 * float(i), -h * (0.62 + 0.08 * float(i % 2))), w * 0.05, Color(1, 1, 1, 0.9))
			_door(c, b.x, b.y, w * 0.14, h * 0.26, wood, true)
		"stone_house":
			_box(c, b, w * 0.8, h * 0.55, Color(0.75, 0.72, 0.68))
			for i in 6:
				c.draw_circle(b + Vector2(-w * 0.3 + w * 0.12 * float(i), -h * (0.12 + 0.2 * float(i % 3))), w * 0.05, Color(0.62, 0.6, 0.58))
			_roof(c, b.x, b.y - h * 0.55, w * 0.92, h * 0.3, roof)
			_window(c, b + Vector2(w * 0.18, -h * 0.35), w * 0.12)
			_door(c, b.x - w * 0.18, b.y, w * 0.16, h * 0.28, wood)
		"lookout":
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.22, b.y), Vector2(b.x + s * w * 0.15, b.y - h * 0.65), wood, 5.0)
			c.draw_line(Vector2(b.x - w * 0.2, b.y - h * 0.3), Vector2(b.x + w * 0.18, b.y - h * 0.45), wood, 3.0)
			_box(c, b + Vector2(0.0, -h * 0.65), w * 0.4, h * 0.18, wall)
			_cone_roof(c, b.x, b.y - h * 0.83, w * 0.5, h * 0.17, roof)
			_banner(c, b + Vector2(w * 0.2, -h * 0.98), w * 0.06, h * 0.1, accent)
		# ---------------- เมือง 3 ท่าเรือแมวน้ำ
		"warehouse":
			_box(c, b, w, h * 0.55, wall.darkened(0.04))
			_arch_roof(c, b.x, b.y - h * 0.55, w * 1.02, h * 0.22, roof)
			_dome(c, b, w * 0.2, h * 0.36, wood)
			c.draw_circle(b + Vector2(w * 0.12, -h * 0.17), 4.0, Color(0.95, 0.8, 0.4))
			for s in [-1.0, 1.0]:
				_window(c, b + Vector2(s * w * 0.33, -h * 0.38), w * 0.09, true)
			_sign(c, b + Vector2(0.0, -h * 0.62), w * 0.09, "fish", accent)
		"lighthouse":
			var lh := PackedVector2Array([b + Vector2(-w * 0.2, 0.0), b + Vector2(-w * 0.12, -h * 0.82), b + Vector2(w * 0.12, -h * 0.82), b + Vector2(w * 0.2, 0.0)])
			_poly(c, lh, Color(1, 1, 1))
			for i in 3:
				var y := b.y - h * (0.18 + 0.24 * float(i))
				var hw := w * (0.19 - 0.025 * float(i))
				_poly(c, PackedVector2Array([Vector2(b.x - hw, y), Vector2(b.x - hw + 3.0, y - h * 0.1), Vector2(b.x + hw - 3.0, y - h * 0.1), Vector2(b.x + hw, y)]), accent)
			c.draw_circle(b + Vector2(0.0, -h * 0.9), w * 0.12, WARM)
			c.draw_circle(b + Vector2(0.0, -h * 0.9), w * 0.22, Color(WARM, 0.25))
			_cone_roof(c, b.x, b.y - h * 0.98, w * 0.3, h * 0.1, roof)
			_door(c, b.x, b.y, w * 0.12, h * 0.16, wood, true)
		"boat_house":
			for i in 4:
				c.draw_line(Vector2(b.x - w * 0.36 + w * 0.24 * float(i), b.y), Vector2(b.x - w * 0.36 + w * 0.24 * float(i), b.y - h * 0.18), wood, 5.0)
			_box(c, b + Vector2(0.0, -h * 0.18), w * 0.8, h * 0.38, wood.lightened(0.4))
			_roof(c, b.x, b.y - h * 0.56, w * 0.92, h * 0.26, roof)
			_boat(c, b + Vector2(0.0, -h * 0.02), w * 0.35, accent)
			_window(c, b + Vector2(w * 0.2, -h * 0.4), w * 0.1, true)
		"seal_fountain":
			_oval(c, b + Vector2(0.0, -h * 0.08), w * 0.42, h * 0.1, Color(0.8, 0.85, 0.9))
			c.draw_rect(Rect2(b.x - w * 0.42, b.y - h * 0.08, w * 0.84, h * 0.08), Color(0.8, 0.85, 0.9))
			_oval(c, b + Vector2(0.0, -h * 0.14), w * 0.36, h * 0.06, Color(0.55, 0.78, 0.95))
			_oval(c, b + Vector2(0.0, -h * 0.35), w * 0.16, h * 0.2, Color(0.72, 0.76, 0.82))
			c.draw_circle(b + Vector2(-w * 0.05, -h * 0.45), 3.0, INK)
			c.draw_circle(b + Vector2(w * 0.05, -h * 0.45), 3.0, INK)
			for i in 5:
				c.draw_circle(b + Vector2(-w * 0.1 + w * 0.05 * float(i), -h * (0.62 + 0.04 * sin(float(i)))), 4.0, Color(0.6, 0.85, 1.0, 0.8))
		"buoy_shop":
			_box(c, b, w * 0.75, h * 0.55, wall)
			_roof(c, b.x, b.y - h * 0.55, w * 0.85, h * 0.25, roof)
			for i in 3:
				_buoy(c, b + Vector2(-w * 0.25 + w * 0.25 * float(i), -h * 0.62), w * 0.06)
			_window(c, b + Vector2(-w * 0.15, -h * 0.3), w * 0.14)
			_door(c, b.x + w * 0.2, b.y, w * 0.14, h * 0.28, wood)
		"harbor_inn":
			_box(c, b, w * 0.9, h * 0.65, wall)
			for i in 4:
				c.draw_line(Vector2(b.x - w * 0.45, b.y - h * (0.1 + 0.15 * float(i))), Vector2(b.x + w * 0.45, b.y - h * (0.1 + 0.15 * float(i))), Color(0.75, 0.8, 0.88), 2.0)
			_arch_roof(c, b.x, b.y - h * 0.65, w * 0.95, h * 0.2, roof)
			for i in 3:
				_window(c, b + Vector2(-w * 0.27 + w * 0.27 * float(i), -h * 0.48), w * 0.09, true)
			_door(c, b.x, b.y, w * 0.16, h * 0.26, wood, true)
			_laundry(c, b + Vector2(-w * 0.45, -h * 0.32), w * 0.9, rng)
		"crane":
			c.draw_line(Vector2(b.x - w * 0.1, b.y), Vector2(b.x - w * 0.1, b.y - h * 0.85), wood, 7.0)
			c.draw_line(Vector2(b.x - w * 0.15, b.y - h * 0.82), Vector2(b.x + w * 0.42, b.y - h * 0.75), wood, 6.0)
			c.draw_line(Vector2(b.x + w * 0.38, b.y - h * 0.75), Vector2(b.x + w * 0.38, b.y - h * 0.4), INK, 2.0)
			_fill_round(c, Rect2(b.x + w * 0.28, b.y - h * 0.4, w * 0.2, h * 0.14), accent, 6.0)
			_box(c, b + Vector2(-w * 0.1, 0.0), w * 0.24, h * 0.16, wall)
		# ---------------- เมือง 4 ทะเลทราย
		"adobe":
			_box(c, b, w * 0.75, h * 0.55, wall)
			_dome(c, b + Vector2(0.0, -h * 0.55), w * 0.3, h * 0.28, roof)
			_door(c, b.x, b.y, w * 0.16, h * 0.3, wood, true)
			for s in [-1.0, 1.0]:
				_window(c, b + Vector2(s * w * 0.24, -h * 0.35), w * 0.08, true)
			for i in 3:
				c.draw_line(Vector2(b.x - w * 0.37 + w * 0.06 * float(i), b.y - h * 0.48), Vector2(b.x - w * 0.37 + w * 0.06 * float(i) - 8.0, b.y - h * 0.48), wood, 4.0)
		"tent":
			_poly(c, PackedVector2Array([b + Vector2(-w * 0.45, 0.0), b + Vector2(0.0, -h * 0.65), b + Vector2(w * 0.45, 0.0)]), accent)
			_poly(c, PackedVector2Array([b + Vector2(-w * 0.12, 0.0), b + Vector2(0.0, -h * 0.4), b + Vector2(w * 0.12, 0.0)]), accent.darkened(0.3))
			for i in 5:
				var t := float(i) / 4.0
				c.draw_circle(b + Vector2(-w * 0.4 + w * 0.8 * t, -h * 0.05 - absf(t - 0.5) * 0.0), 5.0, Color(0.95, 0.75, 0.3))
			_banner(c, b + Vector2(0.0, -h * 0.65), w * 0.05, h * 0.12, roof)
		"cat_pyramid":
			_poly(c, PackedVector2Array([b + Vector2(-w * 0.48, 0.0), b + Vector2(0.0, -h * 0.75), b + Vector2(w * 0.48, 0.0)]), wall.darkened(0.08))
			for i in 4:
				var y := b.y - h * 0.18 * float(i + 1)
				var hw := w * 0.48 * (1.0 - 0.24 * float(i + 1))
				c.draw_line(Vector2(b.x - hw, y), Vector2(b.x + hw, y), Color(INK, 0.35), 2.0)
			_ears(c, b.x, b.y - h * 0.68, w * 0.18, w * 0.08, wall.darkened(0.08))
			_door(c, b.x, b.y, w * 0.14, h * 0.2, Color(0.3, 0.22, 0.18), true)
			c.draw_circle(b + Vector2(-w * 0.06, -h * 0.45), 4.0, accent)
			c.draw_circle(b + Vector2(w * 0.06, -h * 0.45), 4.0, accent)
		"palm_pavilion":
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.32, b.y), Vector2(b.x + s * w * 0.32, b.y - h * 0.45), wood, 5.0)
			_dome(c, b + Vector2(0.0, -h * 0.45), w * 0.42, h * 0.18, accent)
			_palm(c, b + Vector2(-w * 0.5, 0.0), h * 0.9)
			_oval(c, b + Vector2(0.0, -2.0), w * 0.28, 6.0, Color(0.5, 0.8, 0.9))
		"canopy":
			for i in 3:
				var x := b.x - w * 0.36 + w * 0.36 * float(i)
				c.draw_line(Vector2(x, b.y), Vector2(x, b.y - h * 0.5), wood, 4.0)
			_awning(c, b.x - w * 0.46, b.y - h * 0.58, w * 0.92, h * 0.12, accent, Color(1.0, 0.95, 0.8), 6)
			for i in 3:
				c.draw_circle(b + Vector2(-w * 0.25 + w * 0.25 * float(i), -h * 0.1), w * 0.06, [Color(0.95, 0.6, 0.3), Color(0.6, 0.8, 0.4), Color(0.95, 0.8, 0.3)][i])
		"minaret":
			_box(c, b, w * 0.24, h * 0.8, wall)
			c.draw_line(Vector2(b.x - w * 0.16, b.y - h * 0.6), Vector2(b.x + w * 0.16, b.y - h * 0.6), wood, 5.0)
			_dome(c, b + Vector2(0.0, -h * 0.8), w * 0.15, h * 0.14, roof)
			c.draw_circle(b + Vector2(0.0, -h * 0.97), 4.0, accent)
			_window(c, b + Vector2(0.0, -h * 0.4), w * 0.06, true)
		"well":
			_box(c, b, w * 0.4, h * 0.2, Color(0.82, 0.72, 0.58))
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.18, b.y - h * 0.2), Vector2(b.x + s * w * 0.18, b.y - h * 0.5), wood, 4.0)
			_roof(c, b.x, b.y - h * 0.5, w * 0.5, h * 0.15, roof)
			c.draw_line(Vector2(b.x, b.y - h * 0.5), Vector2(b.x, b.y - h * 0.3), INK, 1.5)
			_fill_round(c, Rect2(b.x - 6.0, b.y - h * 0.32, 12.0, 12.0), wood, 3.0)
		# ---------------- เมือง 5 หิมะ
		"igloo":
			_dome(c, b, w * 0.42, h * 0.45, Color(0.95, 0.97, 1.0))
			for i in 3:
				c.draw_arc(b, w * 0.42 * (0.4 + 0.2 * float(i)), PI, TAU, 16, Color(0.75, 0.85, 0.95), 2.0, true)
			_dome(c, b + Vector2(w * 0.28, 0.0), w * 0.14, h * 0.2, Color(0.9, 0.94, 1.0))
			_dome(c, b + Vector2(w * 0.28, 0.0), w * 0.08, h * 0.13, Color(0.35, 0.3, 0.32))
		"log_cabin":
			_box(c, b, w * 0.8, h * 0.5, wood.lightened(0.15))
			for i in 5:
				c.draw_line(Vector2(b.x - w * 0.4, b.y - h * 0.1 * float(i + 1)), Vector2(b.x + w * 0.4, b.y - h * 0.1 * float(i + 1)), wood.darkened(0.15), 2.0)
			_roof(c, b.x, b.y - h * 0.5, w * 0.95, h * 0.32, roof)
			_snow_cap(c, b.x, b.y - h * 0.5, w * 0.95, h * 0.32)
			_window(c, b + Vector2(-w * 0.2, -h * 0.3), w * 0.12)
			_door(c, b.x + w * 0.18, b.y, w * 0.14, h * 0.26, wood.darkened(0.2))
			_chimney(c, b.x - w * 0.25, b.y - h * 0.72, w * 0.08, h * 0.12, Color(0.6, 0.55, 0.52), true)
		"ice_tower":
			_box(c, b, w * 0.34, h * 0.7, accent.lightened(0.45))
			_cone_roof(c, b.x, b.y - h * 0.7, w * 0.42, h * 0.26, accent)
			_box(c, b + Vector2(-w * 0.3, 0.0), w * 0.2, h * 0.45, accent.lightened(0.55))
			_cone_roof(c, b.x - w * 0.3, b.y - h * 0.45, w * 0.26, h * 0.16, accent)
			_window(c, b + Vector2(0.0, -h * 0.45), w * 0.08, true)
			_door(c, b.x, b.y, w * 0.12, h * 0.2, accent.darkened(0.2), true)
		"hot_spring":
			_box(c, b + Vector2(-w * 0.15, 0.0), w * 0.5, h * 0.45, wall)
			_roof(c, b.x - w * 0.15, b.y - h * 0.45, w * 0.62, h * 0.24, roof)
			_snow_cap(c, b.x - w * 0.15, b.y - h * 0.45, w * 0.62, h * 0.24)
			_oval(c, b + Vector2(w * 0.28, -4.0), w * 0.2, 9.0, Color(0.55, 0.82, 0.92))
			for i in 3:
				var sp := b + Vector2(w * (0.2 + 0.08 * float(i)), -h * 0.2)
				c.draw_arc(sp, 9.0, PI * 0.9, PI * 1.6, 8, Color(1, 1, 1, 0.7), 3.0, true)
				c.draw_arc(sp + Vector2(4.0, -16.0), 8.0, PI * 0.2, PI * 0.9, 8, Color(1, 1, 1, 0.6), 3.0, true)
			_sign(c, b + Vector2(-w * 0.15, -h * 0.25), w * 0.09, "paw", accent)
		"snow_shop":
			_box(c, b, w * 0.72, h * 0.52, wall.lerp(Color(0.95, 0.85, 0.75), 0.4))
			_awning(c, b.x - w * 0.38, b.y - h * 0.42, w * 0.76, h * 0.1, Color(0.9, 0.4, 0.4), Color(1, 1, 1), 5)
			_roof(c, b.x, b.y - h * 0.52, w * 0.85, h * 0.28, roof)
			_snow_cap(c, b.x, b.y - h * 0.52, w * 0.85, h * 0.28)
			_window(c, b + Vector2(0.0, -h * 0.22), w * 0.16)
			_snowman(c, b + Vector2(w * 0.42, 0.0), w * 0.1)
		"ice_igloo_big":
			_dome(c, b, w * 0.48, h * 0.58, Color(0.88, 0.95, 1.0))
			for i in 4:
				c.draw_arc(b, w * 0.48 * (0.3 + 0.18 * float(i)), PI, TAU, 18, Color(0.7, 0.85, 0.98), 2.0, true)
			_dome(c, b, w * 0.14, h * 0.24, Color(0.35, 0.3, 0.32))
			_banner(c, b + Vector2(0.0, -h * 0.58), w * 0.05, h * 0.12, accent)
		# ---------------- เมือง 6 ภูเขาไฟ
		"stone_hut":
			_dome(c, b, w * 0.42, h * 0.48, wall)
			for i in 5:
				c.draw_circle(b + Vector2(-w * 0.25 + w * 0.12 * float(i), -h * (0.1 + 0.12 * float(i % 3))), w * 0.05, wall.darkened(0.15))
			_door(c, b.x, b.y, w * 0.16, h * 0.26, Color(0.25, 0.2, 0.2), true)
			_lava_lamp(c, b + Vector2(w * 0.32, -h * 0.25), w * 0.05, accent)
		"forge":
			_box(c, b, w * 0.85, h * 0.5, wall)
			_roof(c, b.x, b.y - h * 0.5, w * 0.95, h * 0.22, roof)
			_chimney(c, b.x + w * 0.25, b.y - h * 0.75, w * 0.14, h * 0.32, wall.darkened(0.2), true)
			c.draw_circle(b + Vector2(-w * 0.12, -h * 0.2), w * 0.15, Color(1.0, 0.6, 0.25))
			c.draw_circle(b + Vector2(-w * 0.12, -h * 0.2), w * 0.09, Color(1.0, 0.85, 0.45))
			c.draw_arc(b + Vector2(-w * 0.12, -h * 0.2), w * 0.15, 0.0, TAU, 20, INK, LINE_W, true)
			_sign(c, b + Vector2(w * 0.25, -h * 0.3), w * 0.09, "paw", accent)
		"obsidian_arch":
			for s in [-1.0, 1.0]:
				_fill_round(c, Rect2(b.x + s * w * 0.32 - w * 0.08, b.y - h * 0.6, w * 0.16, h * 0.6), Color(0.25, 0.22, 0.28), 8.0)
			c.draw_arc(b + Vector2(0.0, -h * 0.6), w * 0.32, PI, TAU, 20, Color(0.25, 0.22, 0.28), w * 0.14, true)
			c.draw_arc(b + Vector2(0.0, -h * 0.6), w * 0.32, PI, TAU, 20, Color(0.55, 0.45, 0.65), 3.0, true)
			for i in 3:
				c.draw_circle(b + Vector2(-w * 0.25 + w * 0.25 * float(i), -h * 0.82), 5.0, accent)
		"steam_vent":
			_oval(c, b + Vector2(0.0, -4.0), w * 0.3, 10.0, Color(0.38, 0.34, 0.36))
			_oval(c, b + Vector2(0.0, -6.0), w * 0.16, 5.0, accent)
			for i in 4:
				var r := w * (0.08 + 0.04 * float(i))
				c.draw_circle(b + Vector2(sin(float(i) * 1.7 + float(seed_no)) * w * 0.06, -h * (0.15 + 0.18 * float(i))), r, Color(1, 1, 1, 0.55 - 0.1 * float(i)))
		"lava_lamp_house":
			_box(c, b, w * 0.7, h * 0.55, wall)
			_arch_roof(c, b.x, b.y - h * 0.55, w * 0.75, h * 0.2, roof)
			for s in [-1.0, 1.0]:
				_lava_lamp(c, b + Vector2(s * w * 0.42, -h * 0.3), w * 0.05, accent)
			_window(c, b + Vector2(0.0, -h * 0.35), w * 0.14, true)
			_door(c, b.x, b.y, w * 0.14, h * 0.22, Color(0.25, 0.2, 0.2), true)
		"ash_tower":
			_box(c, b, w * 0.32, h * 0.75, wall.darkened(0.08))
			c.draw_line(Vector2(b.x - w * 0.16, b.y - h * 0.5), Vector2(b.x + w * 0.16, b.y - h * 0.5), accent, 4.0)
			_cone_roof(c, b.x, b.y - h * 0.75, w * 0.42, h * 0.22, roof)
			c.draw_circle(b + Vector2(0.0, -h * 0.62), w * 0.06, WARM)
			_ears(c, b.x, b.y - h * 0.9, w * 0.12, w * 0.05, roof)
		# ---------------- เมือง 7 ปราสาทแมวเงา
		"gothic_tower":
			_box(c, b, w * 0.4, h * 0.7, wall)
			_cone_roof(c, b.x, b.y - h * 0.7, w * 0.52, h * 0.3, roof)
			_ears(c, b.x, b.y - h * 0.9, w * 0.14, w * 0.06, roof)
			for i in 2:
				_window(c, b + Vector2(0.0, -h * (0.25 + 0.25 * float(i))), w * 0.09, true)
			_door(c, b.x, b.y, w * 0.14, h * 0.18, wood, true)
		"library":
			_box(c, b, w * 0.9, h * 0.6, wall)
			_roof(c, b.x, b.y - h * 0.6, w, h * 0.22, roof)
			for i in 4:
				_window(c, b + Vector2(-w * 0.32 + w * 0.21 * float(i), -h * 0.38), w * 0.08, true)
			_book(c, b + Vector2(0.0, -h * 0.72), w * 0.12, accent)
			_door(c, b.x, b.y, w * 0.16, h * 0.22, wood, true)
		"arcade":
			c.draw_rect(Rect2(b.x - w * 0.46, b.y - h * 0.5, w * 0.92, h * 0.1), wall)
			for i in 4:
				var x := b.x - w * 0.36 + w * 0.24 * float(i)
				c.draw_line(Vector2(x, b.y), Vector2(x, b.y - h * 0.4), wall.darkened(0.1), 7.0)
			for i in 3:
				var x := b.x - w * 0.24 + w * 0.24 * float(i)
				c.draw_arc(Vector2(x, b.y - h * 0.4), w * 0.12, PI, TAU, 12, wall.darkened(0.1), 6.0, true)
				_lantern(c, Vector2(x, b.y - h * 0.32), w * 0.04)
			_outline_rect(c, Rect2(b.x - w * 0.46, b.y - h * 0.5, w * 0.92, h * 0.1))
		"bat_banner_house":
			_box(c, b, w * 0.75, h * 0.58, wall)
			_roof(c, b.x, b.y - h * 0.58, w * 0.85, h * 0.3, roof)
			_bat(c, b + Vector2(0.0, -h * 0.72), w * 0.12, roof.darkened(0.2))
			_window(c, b + Vector2(-w * 0.18, -h * 0.35), w * 0.1, true)
			_window(c, b + Vector2(w * 0.18, -h * 0.35), w * 0.1, true)
			_door(c, b.x, b.y, w * 0.14, h * 0.24, wood, true)
		"cat_spire":
			_poly(c, PackedVector2Array([b + Vector2(-w * 0.18, 0.0), b + Vector2(-w * 0.1, -h * 0.75), b + Vector2(w * 0.1, -h * 0.75), b + Vector2(w * 0.18, 0.0)]), wall.darkened(0.05))
			_dome(c, b + Vector2(0.0, -h * 0.75), w * 0.14, h * 0.12, roof)
			_ears(c, b.x, b.y - h * 0.84, w * 0.12, w * 0.06, roof)
			c.draw_circle(b + Vector2(0.0, -h * 0.5), w * 0.07, WARM)
			c.draw_arc(b + Vector2(0.0, -h * 0.5), w * 0.07, 0.0, TAU, 14, INK, LINE_W, true)
		"lantern_hall":
			_box(c, b, w * 0.85, h * 0.5, wall)
			_arch_roof(c, b.x, b.y - h * 0.5, w * 0.9, h * 0.25, roof)
			for i in 4:
				_lantern(c, b + Vector2(-w * 0.3 + w * 0.2 * float(i), -h * 0.55), w * 0.04)
			_door(c, b.x, b.y, w * 0.2, h * 0.3, wood, true)
		# ---------------- เมือง 8 สวรรค์ทอง
		"cloud_temple":
			_clouds(c, b, w * 0.5)
			for i in 4:
				var x := b.x - w * 0.3 + w * 0.2 * float(i)
				c.draw_line(Vector2(x, b.y - 8.0), Vector2(x, b.y - h * 0.5), Color(1, 0.98, 0.92), 8.0)
				c.draw_line(Vector2(x, b.y - 8.0), Vector2(x, b.y - h * 0.5), Color(INK, 0.3), 1.5)
			_roof(c, b.x, b.y - h * 0.5, w * 0.85, h * 0.25, roof)
			c.draw_circle(b + Vector2(0.0, -h * 0.62), w * 0.05, accent)
		"dome_pavilion":
			_clouds(c, b, w * 0.45)
			_box(c, b + Vector2(0.0, -6.0), w * 0.6, h * 0.35, wall)
			_dome(c, b + Vector2(0.0, -h * 0.4), w * 0.32, h * 0.3, roof)
			c.draw_circle(b + Vector2(0.0, -h * 0.72), 5.0, accent)
			_door(c, b.x, b.y - 6.0, w * 0.14, h * 0.22, Color(0.95, 0.85, 0.6), true)
		"gazebo":
			var gb := b + Vector2(0.0, -h * 0.15 - sin(float(seed_no)) * 6.0)
			_clouds(c, gb + Vector2(0.0, 6.0), w * 0.4)
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(gb.x + s * w * 0.26, gb.y), Vector2(gb.x + s * w * 0.26, gb.y - h * 0.35), Color(1, 0.98, 0.92), 6.0)
			_cone_roof(c, gb.x, gb.y - h * 0.35, w * 0.65, h * 0.22, roof)
			c.draw_circle(gb + Vector2(0.0, -h * 0.58), 4.0, accent)
		"rainbow_arch":
			var cols := [Color(1.0, 0.6, 0.6), Color(1.0, 0.85, 0.5), Color(0.7, 0.9, 0.6), Color(0.6, 0.8, 1.0), Color(0.8, 0.7, 1.0)]
			for i in 5:
				c.draw_arc(b, w * (0.45 - 0.05 * float(i)), PI, TAU, 24, cols[i], w * 0.05, true)
			_clouds(c, b + Vector2(-w * 0.42, 0.0), w * 0.15)
			_clouds(c, b + Vector2(w * 0.42, 0.0), w * 0.15)
		"bell_tower":
			_box(c, b, w * 0.3, h * 0.6, wall)
			c.draw_rect(Rect2(b.x - w * 0.15, b.y - h * 0.82, w * 0.3, h * 0.22), Color(0, 0, 0, 0))
			for s in [-1.0, 1.0]:
				c.draw_line(Vector2(b.x + s * w * 0.13, b.y - h * 0.6), Vector2(b.x + s * w * 0.13, b.y - h * 0.82), wall, 6.0)
			_dome(c, b + Vector2(0.0, -h * 0.82), w * 0.2, h * 0.14, roof)
			_bell(c, b + Vector2(0.0, -h * 0.72), w * 0.07, accent.lerp(Color(1.0, 0.85, 0.4), 0.7))
			_door(c, b.x, b.y, w * 0.12, h * 0.18, Color(0.95, 0.85, 0.6), true)
		"cloud_house":
			_clouds(c, b, w * 0.5)
			_dome(c, b + Vector2(0.0, -8.0), w * 0.36, h * 0.45, Color(1, 1, 1))
			_window(c, b + Vector2(-w * 0.12, -h * 0.28), w * 0.08, true)
			_window(c, b + Vector2(w * 0.12, -h * 0.28), w * 0.08, true)
			_ears(c, b.x, b.y - h * 0.48, w * 0.24, w * 0.08, Color(1, 1, 1))
			_door(c, b.x, b.y - 8.0, w * 0.12, h * 0.18, roof, true)
		_:
			_box(c, b, w * 0.8, h * 0.55, wall)
			_roof(c, b.x, b.y - h * 0.55, w * 0.9, h * 0.3, roof)
			_door(c, b.x, b.y, w * 0.16, h * 0.28, wood)

# ---------------------------------------------------------------- helpers
static func _vary(col: Color, rng: RandomNumberGenerator) -> Color:
	return Color(col.r + rng.randf_range(-0.04, 0.04), col.g + rng.randf_range(-0.04, 0.04), col.b + rng.randf_range(-0.04, 0.04), col.a)

static func _poly(c: CanvasItem, pts: PackedVector2Array, col: Color) -> void:
	SoftDraw.poly(c, pts, col)
	var line := pts.duplicate()
	line.append(pts[0])
	c.draw_polyline(line, INK, LINE_W, true)

static func _fill_round(c: CanvasItem, r: Rect2, col: Color, rad: float) -> void:
	# มุมโค้งเต็มครึ่งความกว้างทำให้จุดซ้อนกัน วาดไม่ออก เลยลดลงนิดหนึ่ง
	var pts := UiStyle.round_pts(r, minf(rad, minf(r.size.x, r.size.y) * 0.5 - 0.6))
	pts.remove_at(pts.size() - 1)
	c.draw_colored_polygon(pts, col)

static func _outline_round(c: CanvasItem, r: Rect2, rad: float) -> void:
	c.draw_polyline(UiStyle.round_pts(r, minf(rad, minf(r.size.x, r.size.y) * 0.5 - 0.6)), INK, LINE_W, true)

static func _outline_rect(c: CanvasItem, r: Rect2) -> void:
	c.draw_polyline(PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y), r.position]), INK, LINE_W, true)

## กล่องผนังมุมมนเล็กน้อย จุดกึ่งกลางล่างที่ b
static func _box(c: CanvasItem, b: Vector2, w: float, h: float, col: Color) -> void:
	var r := Rect2(b.x - w * 0.5, b.y - h, w, h)
	_fill_round(c, r, col, 6.0)
	_outline_round(c, r, 6.0)

static func _roof(c: CanvasItem, cx: float, base_y: float, w: float, h: float, col: Color) -> void:
	_poly(c, PackedVector2Array([Vector2(cx - w * 0.5, base_y + 2.0), Vector2(cx, base_y - h), Vector2(cx + w * 0.5, base_y + 2.0)]), col)

static func _cone_roof(c: CanvasItem, cx: float, base_y: float, w: float, h: float, col: Color) -> void:
	_poly(c, PackedVector2Array([Vector2(cx - w * 0.5, base_y + 2.0), Vector2(cx - w * 0.08, base_y - h * 0.85), Vector2(cx, base_y - h), Vector2(cx + w * 0.08, base_y - h * 0.85), Vector2(cx + w * 0.5, base_y + 2.0)]), col)

static func _arch_roof(c: CanvasItem, cx: float, base_y: float, w: float, h: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in 17:
		var a := PI + PI * float(i) / 16.0
		pts.append(Vector2(cx + cos(a) * w * 0.5, base_y + 2.0 + sin(a) * h))
	_poly(c, pts, col)

static func _dome(c: CanvasItem, b: Vector2, rx: float, ry: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in 21:
		var a := PI + PI * float(i) / 20.0
		pts.append(Vector2(b.x + cos(a) * rx, b.y + sin(a) * ry))
	_poly(c, pts, col)

static func _oval(c: CanvasItem, at: Vector2, rx: float, ry: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in 24:
		var a := TAU * float(i) / 24.0
		pts.append(at + Vector2(cos(a) * rx, sin(a) * ry))
	c.draw_colored_polygon(pts, col)

static func _window(c: CanvasItem, at: Vector2, s: float, round_top := false) -> void:
	var r := Rect2(at.x - s * 0.5, at.y - s * 0.6, s, s * 1.2)
	_fill_round(c, r, WARM, s * (0.5 if round_top else 0.18))
	_outline_round(c, r, s * (0.5 if round_top else 0.18))
	c.draw_line(Vector2(at.x, r.position.y + 3.0), Vector2(at.x, r.end.y - 2.0), Color(INK, 0.5), 1.5)

static func _door(c: CanvasItem, cx: float, base_y: float, w: float, h: float, col: Color, arch := false) -> void:
	var r := Rect2(cx - w * 0.5, base_y - h, w, h)
	_fill_round(c, r, col, w * (0.5 if arch else 0.15))
	_outline_round(c, r, w * (0.5 if arch else 0.15))
	c.draw_circle(Vector2(cx + w * 0.25, base_y - h * 0.45), maxf(2.0, w * 0.07), WARM_DIM)

static func _ears(c: CanvasItem, cx: float, top: float, gap: float, size: float, col: Color) -> void:
	for s in [-1.0, 1.0]:
		var x: float = cx + s * gap * 0.5
		_poly(c, PackedVector2Array([Vector2(x - size * 0.6, top + 2.0), Vector2(x, top - size * 1.1), Vector2(x + size * 0.6, top + 2.0)]), col)

static func _awning(c: CanvasItem, x0: float, y: float, w: float, h: float, a: Color, b: Color, n: int) -> void:
	var sw := w / float(n)
	for i in n:
		var r := Rect2(x0 + sw * float(i), y, sw, h)
		c.draw_rect(r, a if i % 2 == 0 else b)
		c.draw_circle(Vector2(r.get_center().x, y + h), sw * 0.5, a if i % 2 == 0 else b)
	c.draw_line(Vector2(x0, y), Vector2(x0 + w, y), INK, LINE_W)

static func _banner(c: CanvasItem, top: Vector2, w: float, h: float, col: Color) -> void:
	var pts := PackedVector2Array([top + Vector2(-w * 0.5, 0.0), top + Vector2(w * 0.5, 0.0), top + Vector2(w * 0.5, h), top + Vector2(0.0, h * 0.82), top + Vector2(-w * 0.5, h)])
	_poly(c, pts, col)
	UiStyle.paw(c, top + Vector2(0.0, h * 0.4), w * 0.45, Color(1, 1, 1, 0.85))

static func _sign(c: CanvasItem, at: Vector2, s: float, icon: String, col: Color) -> void:
	c.draw_circle(at, s, Color(1.0, 0.97, 0.88))
	c.draw_arc(at, s, 0.0, TAU, 20, INK, LINE_W, true)
	match icon:
		"fish":
			_fish(c, at, s * 0.7, col)
		"bread":
			_oval(c, at, s * 0.6, s * 0.38, Color(0.9, 0.65, 0.35))
		_:
			UiStyle.paw(c, at, s * 0.6, col)

static func _fish(c: CanvasItem, at: Vector2, s: float, col: Color) -> void:
	_oval(c, at, s, s * 0.55, col)
	c.draw_colored_polygon(PackedVector2Array([at + Vector2(s * 0.8, 0.0), at + Vector2(s * 1.4, -s * 0.5), at + Vector2(s * 1.4, s * 0.5)]), col)
	c.draw_circle(at + Vector2(-s * 0.5, -s * 0.1), maxf(1.5, s * 0.12), INK)

static func _plant(c: CanvasItem, at: Vector2, s: float, rng: RandomNumberGenerator) -> void:
	_fill_round(c, Rect2(at.x - s * 0.5, at.y - s * 0.7, s, s * 0.7), Color(0.8, 0.5, 0.35), 3.0)
	var g := Color(0.45, 0.7, 0.4)
	c.draw_circle(at + Vector2(0.0, -s * 1.1), s * 0.55, g)
	c.draw_circle(at + Vector2(-s * 0.35, -s * 0.9), s * 0.35, g)
	c.draw_circle(at + Vector2(s * 0.35, -s * 0.9), s * 0.35, g)
	if rng.randf() < 0.6:
		c.draw_circle(at + Vector2(0.0, -s * 1.3), s * 0.18, [Color(1, 0.6, 0.7), Color(1, 0.9, 0.4), Color(0.8, 0.7, 1.0)][rng.randi() % 3])

static func _laundry(c: CanvasItem, at: Vector2, w: float, rng: RandomNumberGenerator) -> void:
	var pts := PackedVector2Array()
	for i in 9:
		var t := float(i) / 8.0
		pts.append(at + Vector2(w * t, sin(t * PI) * 10.0))
	c.draw_polyline(pts, Color(INK, 0.6), 1.5, true)
	for i in 4:
		var p := pts[1 + i * 2]
		_fill_round(c, Rect2(p.x - 7.0, p.y, 14.0, 16.0), [Color(1, 0.75, 0.8), Color(0.7, 0.85, 1.0), Color(1, 0.95, 0.7), Color(0.8, 0.95, 0.8)][(i + rng.randi()) % 4], 4.0)

static func _chimney(c: CanvasItem, cx: float, top: float, w: float, h: float, col: Color, smoke: bool) -> void:
	var r := Rect2(cx - w * 0.5, top, w, h)
	_fill_round(c, r, col, 3.0)
	_outline_round(c, r, 3.0)
	if smoke:
		for i in 3:
			c.draw_circle(Vector2(cx + float(i) * 6.0, top - 10.0 - float(i) * 12.0), 6.0 + float(i) * 3.0, Color(1, 1, 1, 0.55 - float(i) * 0.12))

static func _buoy(c: CanvasItem, at: Vector2, s: float) -> void:
	c.draw_circle(at, s, Color(1, 1, 1))
	c.draw_arc(at, s, -0.6, 0.6, 6, Color(0.92, 0.35, 0.35), s * 0.6, false)
	c.draw_arc(at, s, PI - 0.6, PI + 0.6, 6, Color(0.92, 0.35, 0.35), s * 0.6, false)
	c.draw_circle(at, s * 0.45, Color(0.6, 0.8, 0.95))
	c.draw_arc(at, s, 0.0, TAU, 16, INK, LINE_W, true)

static func _boat(c: CanvasItem, at: Vector2, w: float, col: Color) -> void:
	_poly(c, PackedVector2Array([at + Vector2(-w * 0.5, -w * 0.18), at + Vector2(w * 0.5, -w * 0.18), at + Vector2(w * 0.35, 0.0), at + Vector2(-w * 0.35, 0.0)]), col)

static func _cart(c: CanvasItem, at: Vector2, w: float) -> void:
	_fill_round(c, Rect2(at.x - w * 0.5, at.y - w * 0.5, w, w * 0.4), Color(0.55, 0.45, 0.4), 4.0)
	for s in [-1.0, 1.0]:
		c.draw_circle(at + Vector2(s * w * 0.3, -w * 0.08), w * 0.1, Color(0.3, 0.28, 0.28))
	for i in 3:
		c.draw_circle(at + Vector2(-w * 0.2 + w * 0.2 * float(i), -w * 0.55), w * 0.1, Color(0.7, 0.8, 0.95))

static func _palm(c: CanvasItem, at: Vector2, h: float) -> void:
	var pts := PackedVector2Array()
	for i in 8:
		var t := float(i) / 7.0
		pts.append(at + Vector2(sin(t * 1.5) * h * 0.12, -h * t))
	c.draw_polyline(pts, Color(0.62, 0.45, 0.3), 7.0, true)
	var top := pts[7]
	for i in 5:
		var a := PI + PI * float(i) / 4.0
		var tip := top + Vector2(cos(a), sin(a) * 0.5 + 0.35) * h * 0.25
		c.draw_line(top, tip, Color(0.4, 0.68, 0.38), 8.0)
		c.draw_circle(tip, 5.0, Color(0.4, 0.68, 0.38))

static func _snow_cap(c: CanvasItem, cx: float, base_y: float, w: float, h: float) -> void:
	var pts := PackedVector2Array([Vector2(cx - w * 0.3, base_y - h * 0.4), Vector2(cx, base_y - h - 3.0), Vector2(cx + w * 0.3, base_y - h * 0.4)])
	for i in 4:
		var t := float(3 - i) / 3.0
		pts.append(Vector2(cx - w * 0.3 + w * 0.6 * t, base_y - h * 0.4 + (6.0 if i % 2 == 0 else 0.0)))
	c.draw_colored_polygon(pts, Color(1, 1, 1, 0.95))

static func _snowman(c: CanvasItem, at: Vector2, s: float) -> void:
	c.draw_circle(at + Vector2(0.0, -s), s, Color(1, 1, 1))
	c.draw_circle(at + Vector2(0.0, -s * 2.4), s * 0.65, Color(1, 1, 1))
	c.draw_arc(at + Vector2(0.0, -s), s, 0.0, TAU, 16, INK, 1.5, true)
	c.draw_arc(at + Vector2(0.0, -s * 2.4), s * 0.65, 0.0, TAU, 16, INK, 1.5, true)
	c.draw_circle(at + Vector2(s * 0.15, -s * 2.4), s * 0.12, Color(1.0, 0.6, 0.3))

static func _lava_lamp(c: CanvasItem, at: Vector2, s: float, col: Color) -> void:
	c.draw_circle(at, s * 2.4, Color(col, 0.22))
	_fill_round(c, Rect2(at.x - s * 0.6, at.y - s, s * 1.2, s * 2.0), col, s * 0.6)
	c.draw_circle(at, s * 0.45, Color(1.0, 0.9, 0.55))

static func _lantern(c: CanvasItem, at: Vector2, s: float) -> void:
	c.draw_line(at + Vector2(0.0, -s * 2.0), at + Vector2(0.0, -s), Color(INK, 0.6), 1.5)
	c.draw_circle(at, s * 2.2, Color(WARM, 0.25))
	_fill_round(c, Rect2(at.x - s * 0.7, at.y - s, s * 1.4, s * 2.0), WARM, s * 0.6)

static func _bat(c: CanvasItem, at: Vector2, s: float, col: Color) -> void:
	c.draw_circle(at, s * 0.45, col)
	for side in [-1.0, 1.0]:
		c.draw_circle(at + Vector2(side * s * 0.75, -s * 0.05), s * 0.35, col)
		c.draw_circle(at + Vector2(side * s * 1.1, s * 0.05), s * 0.25, col)
	c.draw_circle(at + Vector2(-s * 0.15, -s * 0.05), s * 0.08, WARM)
	c.draw_circle(at + Vector2(s * 0.15, -s * 0.05), s * 0.08, WARM)

static func _book(c: CanvasItem, at: Vector2, s: float, col: Color) -> void:
	_fill_round(c, Rect2(at.x - s, at.y - s * 0.6, s, s * 1.2), col, 3.0)
	_fill_round(c, Rect2(at.x, at.y - s * 0.6, s, s * 1.2), col.lightened(0.2), 3.0)
	c.draw_line(at + Vector2(0.0, -s * 0.6), at + Vector2(0.0, s * 0.6), INK, 1.5)

static func _clouds(c: CanvasItem, at: Vector2, w: float) -> void:
	for i in 5:
		var t := float(i) / 4.0
		c.draw_circle(at + Vector2(-w + w * 2.0 * t, -sin(t * PI) * w * 0.18), w * (0.22 + 0.1 * sin(t * PI)), Color(1, 1, 1, 0.95))

static func _bell(c: CanvasItem, at: Vector2, s: float, col: Color) -> void:
	_dome(c, at + Vector2(0.0, s), s, s * 1.4, col)
	c.draw_circle(at + Vector2(0.0, s * 1.2), s * 0.25, col.darkened(0.3))
