class_name BowLineSnipe
## คอมโบสาย SNIPESTARKER / APEX SNIPER ของ CAT MATCHA
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย bws_ เท่านั้น
## NEXT: ต่อท่าตามคลาส {คลาส: {ท่าปัจจุบัน: {ปุ่ม: ท่าถัดไป}}} ปุ่มเป็น "z" "x" "fwd_z" "down_x" เป็นต้น (คลาสลูกได้ท่าของคลาสแม่ด้วย)
## START: ท่าแรกตามคลาส {คลาส: {"สถานะ_ปุ่ม": ท่า}} สถานะ ground dash air airdash เช่น "dash_z"
##
## โหมดตั้งธนู (bws_stance): ย่อตัวตั้งคันธนูนิ่ง มีวงเล็งเขียวใต้เท้า
##   กด z ยิงตรงไปด้านหน้า 5 ดอก  กด x ยิงโปรยขึ้นฟ้าโค้งตกไปด้านหน้า 5 ดอก  ยิงเสร็จกลับมาท่าตั้งธนูเอง
##   ออกจากโหมด: ไม่กดอะไรราว 2.4 วินาที หรือกดเดิน/กระโดด (walk_page)
## SNIPESTARKER: xxxxxx ดอกที่ 4 ไม่ล้ม ดอกสุดท้ายเข้าโหมดตั้งธนู
##               >>^zxx เตะกลางอากาศ หมุนตัวไปข้างหน้ายิงศรลม แล้วยิงเฉียง 3 ดอก
##               >>xx ยิงแล้วเข้าโหมดตั้งธนู
## APEX SNIPER:  zxxx เตะ หันหลังยิง หมุนตัวกลับยิงไปด้านหน้า แล้วเข้าโหมดตั้งธนู
##               >>^xzz ยิง หมุนตัวไปข้างหน้ายิงศรลม แล้วยิงเฉียง 3 ดอก
##               xz  z ปล่อยลมจากเหนือหัวพุ่งลงเฉียงไปด้านหน้า มอนลอย

const NEXT := {
	"SNIPESTARKER": {
		"bw_x3": {"x": "bws_x4"}, "bws_x4": {"x": "bws_x5"}, "bws_x5": {"x": "bws_x6"},
		# >>x อ้อมผ่านหันหลังยิงแบบ BASIC แล้ว x ตั้งธนู
		"bws_dx1": {"x": "bws_stance"}, "bw_dx": {"x": "bws_stance"}, "bw_turn_shot": {"x": "bws_stance"},
		"bws_adz": {"x": "bws_spin_wind"}, "bws_spin_wind": {"x": "bws_diag3", "z": "bws_diag3"},
		# ตั้งธนูยิงได้ 3 ชุดต่อครั้ง ชุดที่ 3 แล้วออกจากโหมด
		"bws_stance": {"z": "bws_st_z", "x": "bws_st_x"},
		"bws_st_z": {"z": "bws_st_z2", "x": "bws_st_x2"}, "bws_st_x": {"z": "bws_st_z2", "x": "bws_st_x2"}, "bws_stance2": {"z": "bws_st_z2", "x": "bws_st_x2"},
		"bws_st_z2": {"z": "bws_st_z3", "x": "bws_st_x3"}, "bws_st_x2": {"z": "bws_st_z3", "x": "bws_st_x3"}, "bws_stance3": {"z": "bws_st_z3", "x": "bws_st_x3"},
	},
	"APEX SNIPER": {
		"bw_z1": {"x": "bws_back_shot"}, "bws_back_shot": {"x": "bws_front_spin"}, "bws_front_spin": {"x": "bws_stance"},
		"bws_adx": {"z": "bws_spin_wind"},
		"bw_x1": {"z": "bws_sky_wind"},
	},
}
const START := {
	"SNIPESTARKER": {"airdash_z": "bws_adz"},
	"APEX SNIPER": {"airdash_x": "bws_adx"},
}

const STANCE_TIME := 2.4         # ท่าตั้งธนูค้างไว้ได้นานเท่านี้ถ้าไม่กดอะไร
const STANCE_CD := 2.0           # ออกจากโหมดตั้งธนูแล้ว ต้องรอเท่านี้ถึงตั้งใหม่ได้
const VOLLEY_DMG := 6.5
const RAIN_DMG := 9.0
static var _stance_exit_ms := -100000
const WIND_DMG := 18.0
const SKY_DMG := 20.0
const GRAVITY := 2400.0

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

## เพิ่มท่าลงตาราง m  base มี "kick" "shoot" "shoot45" "shoot_down" ของ BowCombo
static func add_moves(m: Dictionary, base: Dictionary) -> void:
	var kick: Dictionary = base["kick"]
	var shoot: Dictionary = base["shoot"]
	var shoot45: Dictionary = base["shoot45"]
	# ท่าตั้งธนู ย่อตัวโน้มหน้า คันธนูนิ่งต่ำระดับอก ไม่ขยับมือ
	var aim := {"wind_hand": Vector3(0.7, -0.04, 0.12), "end_hand": Vector3(0.7, -0.04, 0.12), "wind_aim": Vector2(90.0, 0.0), "end_aim": Vector2(90.0, 0.0),
		"wind_off": Vector3(0.04, 0.0, 0.12), "end_off": Vector3(0.04, 0.0, 0.12), "lean": 16.0, "twist": -30.0}
	# xxxxxx ดอกที่ 4 5 ยิงธรรมดา ดอก 6 ยิงแรงแล้วเข้าท่าตั้งธนูเอง
	# ดอก 4-6 เบากว่าดอกปกติ ยิงหกดอกรวดเลยไม่แรงเกินคอมโบอื่น
	m["bws_x4"] = _mv(shoot, {"name": "ยิงธนู 4", "fx": "bws_shot_light"})
	m["bws_x5"] = _mv(shoot, {"name": "ยิงธนู 5", "fx": "bws_shot_light"})
	m["bws_x6"] = _mv(shoot, {"name": "ยิงแล้วตั้งธนู", "auto": "bws_stance", "next": 0.75, "shake": 0.1, "fx": "bws_shot_light"})
	m["bws_stance"] = _mv(shoot, aim.merged({"name": "ตั้งธนู", "time": STANCE_TIME, "wind": 0.02, "strike": 0.04, "next": 0.05, "ease": 1.0,
		"no_hit": true, "shake": 0.0, "fx": "bws_stance_on", "stance": true}, true))
	# ยิงในท่าตั้งธนู ดึงสายถอยนิดแล้วปล่อย ยิงเสร็จกลับท่าตั้งธนู กดต่อระหว่างยิงได้เลย
	var volley := _mv(shoot, aim.merged({"time": 0.42, "wind": 0.25, "strike": 0.4, "next": 0.7, "auto": "bws_stance", "repeat": 99,
		"wind_off": Vector3(0.45, 0.02, 0.12), "end_off": Vector3(0.04, 0.0, 0.12), "stance": true, "stance_shot": true, "shake": 0.08}, true))
	m["bws_st_z"] = _mv(volley, {"name": "ตั้งธนูยิงตรง 5 ดอก", "fx": "bws_volley", "auto": "bws_stance2"})
	m["bws_st_x"] = _mv(volley, {"name": "ตั้งธนูยิงโปรย 5 ดอก", "fx": "bws_rain", "end_aim": Vector2(40.0, 0.0), "wind_aim": Vector2(40.0, 0.0),
		"end_hand": Vector3(0.6, 0.25, 0.12), "wind_hand": Vector3(0.6, 0.25, 0.12), "lean": -10.0, "auto": "bws_stance2"})
	# ชุดที่ 2 กลับท่าตั้งธนูขั้นที่ 3 ชุดที่ 3 ยิงแล้วจบท่า ออกจากโหมด
	m["bws_stance2"] = _mv(m["bws_stance"], {"fx": "bws_stance_keep"})
	m["bws_stance3"] = _mv(m["bws_stance"], {"fx": "bws_stance_keep"})
	m["bws_st_z2"] = _mv(m["bws_st_z"], {"auto": "bws_stance3"})
	m["bws_st_x2"] = _mv(m["bws_st_x"], {"auto": "bws_stance3"})
	m["bws_st_z3"] = _mv(m["bws_st_z"], {"next": 0.9})
	m["bws_st_x3"] = _mv(m["bws_st_x"], {"next": 0.9})
	for id in ["bws_st_z3", "bws_st_x3"]:
		(m[id] as Dictionary).erase("auto")
		(m[id] as Dictionary).erase("stance_shot")
	# >>xx ยิงตอนแดชแล้วเข้าท่าตั้งธนู
	m["bws_dx1"] = _mv(shoot, {"name": "แดชยิง", "lunge": 0.6, "time": 0.36})
	# >>^zxx เตะกลางอากาศ หมุนตัวไปข้างหน้ายิงศรลม ยิงเฉียง 3 ดอก
	m["bws_adz"] = _mv(kick, {"name": "เตะกลางอากาศ", "dmg": 14.0, "hover": true, "lunge": 0.4, "time": 0.36, "wind": 0.2, "strike": 0.5, "next": 0.62, "fx": "bw_kick_front", "hit": {"kb": 1.0, "stun": 0.6}})
	m["bws_spin_wind"] = _mv(shoot, {"name": "หมุนตัวยิงศรลม", "hover": true, "roll_once": true, "lunge": 0.9, "time": 0.46, "wind": 0.15, "strike": 0.6, "next": 0.7, "fx": "bws_wind_arrow_diag", "shake": 0.14})
	m["bws_diag3"] = _mv(shoot45, {"name": "ยิงเฉียง 3 ดอก", "fx": "bw_shot3_diag", "next": 0.8})
	# APEX zxxx หันหลังยิง หมุนตัวกลับมายิงข้างหน้า แล้วตั้งธนู
	m["bws_back_shot"] = _mv(shoot, {"name": "กระโดดถอยหลังยิง", "leap": 4.5, "lunge": -1.4, "time": 0.42, "wind": 0.3, "strike": 0.55, "next": 0.72, "lean": -12.0, "fx": "bws_shot_apex"})
	m["bws_front_spin"] = _mv(shoot, {"name": "หมุนตัวยิงไปข้างหน้า", "spin": 360.0, "time": 0.42, "wind": 0.35, "strike": 0.6, "next": 0.7, "fx": "bws_shot_apex"})
	# APEX >>^x ยิงกลางอากาศ
	m["bws_adx"] = _mv(shoot, {"name": "ยิงกลางอากาศ", "hover": true, "time": 0.34})
	# APEX xz ลมพุ่งลงจากเหนือหัวเฉียงไปข้างหน้า
	m["bws_sky_wind"] = _mv(shoot, {"name": "ลมจากฟ้า", "wind_hand": Vector3(0.3, 0.45, 0.12), "end_hand": Vector3(0.35, 0.62, 0.12), "wind_aim": Vector2(-10.0, 0.0), "end_aim": Vector2(-20.0, 0.0),
		"lean": -18.0, "time": 0.44, "wind": 0.3, "strike": 0.5, "next": 0.8, "fx": "bws_sky_wind", "shake": 0.12})

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(caster: MageCaster, fx: String) -> bool:
	if not fx.begins_with("bws_"):
		return false
	var page := caster.page
	var hero := caster.hero
	var f := hero.facing
	match fx:
		"bws_shot_apex":
			# APEX ยิงแรงกว่าลูกธนูพื้นฐานหน่อย
			caster._arrow(Vector2(f, 0.0), MageCaster.SHOT_DMG * MageCaster.BASIC_SHOT_K * 1.45, {"kb": 1.0, "stun": 0.45})
		"bws_shot_light":
			caster._arrow(Vector2(f, 0.0), MageCaster.SHOT_DMG * MageCaster.BASIC_SHOT_K * 0.45, {"kb": 0.8, "stun": 0.45})
		"bws_stance_keep":
			# ตั้งธนูต่อระหว่างชุดยิง วงเล็งเดิมยังอยู่
			pass
		"bws_stance_on":
			# เริ่มโหมดตั้งธนูใหม่ วงเล็งเดิมที่ยังค้างแปลว่าเพิ่งออกจากโหมด
			for c in page.world.get_children():
				if c is StanceMark and not (c as StanceMark).leaving():
					_stance_exit_ms = Time.get_ticks_msec()
					c.queue_free()
			# เพิ่งออกจากโหมดไม่ถึง 2 วิ ยังตั้งธนูใหม่ไม่ได้
			if Time.get_ticks_msec() - _stance_exit_ms < int(STANCE_CD * 1000.0):
				page._end_combo()
				return true
			var mark := StanceMark.new()
			mark.page = page
			mark.position = Vector2(hero.position.x, 0.0)
			page.world.add_child(mark)
		"bws_volley":
			# 5 ดอกตรงไปข้างหน้า ปล่อยถี่ๆ เรียงสูงต่ำนิดหน่อย
			var offs := [0.0, -16.0, 16.0, -8.0, 8.0]
			for i in 5:
				var dy: float = offs[i]
				var fire := func() -> void:
					if is_instance_valid(page):
						page._fire(caster._hand() + Vector2(0.0, dy), Vector2(f, 0.0) * WalkPage.SHOT_SPEED * 1.5, 24.0, VOLLEY_DMG, {"kb": 0.5, "stun": 0.4}, false, 1)
				if i == 0:
					fire.call()
				else:
					caster.get_tree().create_timer(0.05 * float(i)).timeout.connect(fire)
		"bws_rain":
			# 5 ดอกโปรยขึ้นฟ้า ตกลงไกลไม่เท่ากัน
			for i in 5:
				var dist := 380.0 + float(i) * 150.0
				var ang := deg_to_rad(62.0)
				var speed := sqrt(dist * GRAVITY / sin(2.0 * ang))
				var shot := func() -> void:
					if not is_instance_valid(page):
						return
					var lob := LobArrow.new()
					lob.caster = caster
					lob.radius = 24.0
					lob.vel = Vector2(f * cos(ang), -sin(ang)) * speed
					lob.tail = -lob.vel.normalized()
					lob.position = caster._hand()
					page.world.add_child(lob)
				if i == 0:
					shot.call()
				else:
					caster.get_tree().create_timer(0.06 * float(i)).timeout.connect(shot)
		"bws_wind_arrow", "bws_wind_arrow_diag":
			# ศรลมดอกใหญ่ มีเกลียวลมหมุนรอบ ผลักมอนกระเด็น ทะลุได้ 3 ตัว  แบบ diag ยิงเฉียงลง
			var wdir := Vector2(f, 0.85).normalized() if fx == "bws_wind_arrow_diag" else Vector2(f, 0.0)
			page._fire(caster._hand(), wdir * WalkPage.SHOT_SPEED * 1.6, 36.0, WIND_DMG, {"kb": 2.4, "stun": 0.6}, false, 3)
			var last: Array = page._shots.back()
			var swirl := WindSwirl.new()
			swirl.dir = f
			(last[0] as Node2D).add_child(swirl)
		"bws_sky_wind":
			var sky := SkyWind.new()
			sky.caster = caster
			sky.dir = f
			sky.from = Vector2(hero.position.x + f * 40.0, -520.0)
			sky.to = Vector2(hero.position.x + f * 560.0, 0.0)
			sky.position = sky.from
			page.world.add_child(sky)
		_:
			return false
	return true

## วงเล็งเขียวใต้เท้าตอนตั้งธนู หายเองเมื่อออกจากโหมด
class StanceMark extends Node2D:
	var page: WalkPage
	var t := 0.0
	var _out := -1.0
	func leaving() -> bool:
		return _out >= 0.0
	func _process(delta: float) -> void:
		t += delta
		if not is_instance_valid(page):
			queue_free()
			return
		var on: bool = page.combo_nth >= 0 and page.hero.plain_move.get("stance", false)
		if not on and _out < 0.0:
			_out = 0.0
			BowLineSnipe._stance_exit_ms = Time.get_ticks_msec()
		if _out >= 0.0:
			_out += delta
			if _out > 0.2:
				queue_free()
				return
		position.x = page.hero.position.x
		queue_redraw()
	func _draw() -> void:
		var a := clampf(t / 0.15, 0.0, 1.0)
		if _out >= 0.0:
			a *= 1.0 - clampf(_out / 0.2, 0.0, 1.0)
		var f := signf(page.hero.facing) if is_instance_valid(page) else 1.0
		var green := Color(0.55, 0.95, 0.5)
		# วงรีใต้เท้า มีจุดเล็งหมุนรอบช้าๆ
		var pts := PackedVector2Array()
		for i in 41:
			var ang := TAU * float(i) / 40.0
			pts.append(Vector2(cos(ang) * 120.0, sin(ang) * 26.0))
		draw_polyline(pts, Color(green, 0.35 * a), 10.0, true)
		draw_polyline(pts, Color(1.0, 1.0, 1.0, 0.7 * a), 3.0, true)
		for i in 4:
			var ang := t * 1.6 + TAU * float(i) / 4.0
			draw_circle(Vector2(cos(ang) * 120.0, sin(ang) * 26.0), 7.0, Color(green, 0.9 * a))
		# เส้นเล็งจางๆ ชี้ไปด้านหน้า
		for i in 6:
			var x := f * (160.0 + float(i) * 90.0 + fmod(t * 300.0, 90.0))
			draw_line(Vector2(x, -70.0), Vector2(x + f * 40.0, -70.0), Color(green, 0.5 * a * (1.0 - float(i) / 6.0)), 4.0, true)

## ลูกศรโปรย พุ่งขึ้นแล้วโค้งตกตามแรงโน้มถ่วง หัวชี้ตามทาง โดนตัวแรกแล้วแตก ตกพื้นแตก
class LobArrow extends CatArrow:
	var caster: MageCaster
	var vel := Vector2.ZERO
	func _process(delta: float) -> void:
		super._process(delta)
		if bursting:
			return
		vel.y += GRAVITY * delta
		position += vel * delta
		tail = -vel.normalized()
		if not is_instance_valid(caster):
			queue_free()
			return
		for m in caster._monsters():
			var mon := m as Monster
			if (mon.position + Vector2(0.0, -WalkPage.MONSTER_MID)).distance_to(position) <= size() + WalkPage.MONSTER_HIT_R:
				caster._hit(mon, RAIN_DMG, {"kb": 0.4, "stun": 0.55})
				burst()
				return
		if position.y >= -8.0:
			burst()

## เกลียวลมรอบศรลม
class WindSwirl extends Node2D:
	var dir := 1.0
	var t := 0.0
	func _process(delta: float) -> void:
		t += delta
		queue_redraw()
	func _draw() -> void:
		for i in 3:
			var ph := t * 18.0 + float(i) * TAU / 3.0
			var pts := PackedVector2Array()
			for k in 14:
				var u := float(k) / 13.0
				pts.append(Vector2(-dir * u * 150.0, sin(ph + u * 7.0) * (30.0 + u * 20.0)))
			draw_polyline(pts, Color(0.75, 1.0, 0.85, 0.75 - float(i) * 0.15), 5.0 - float(i), true)
		draw_arc(Vector2.ZERO, 46.0, t * 12.0, t * 12.0 + PI * 1.3, 16, Color(1.0, 1.0, 1.0, 0.8), 4.0, true)

## ลมก้อนใหญ่พุ่งลงเฉียงจากเหนือหัว โดนตามทางแล้วตกพื้นกระแทกให้มอนลอย
class SkyWind extends Node2D:
	const TIME := 0.32
	var caster: MageCaster
	var dir := 1.0
	var from := Vector2.ZERO
	var to := Vector2.ZERO
	var t := 0.0
	var _landed := false
	var _done := {}
	func _process(delta: float) -> void:
		t += delta
		if not is_instance_valid(caster):
			queue_free()
			return
		var k := clampf(t / TIME, 0.0, 1.0)
		position = from.lerp(to, k * k)
		if not _landed:
			for m in caster._monsters():
				var mon := m as Monster
				if not _done.has(mon) and (mon.position + Vector2(0.0, -WalkPage.MONSTER_MID)).distance_to(position) < 150.0:
					_done[mon] = true
					caster._hit(mon, SKY_DMG * 0.5, {"type": "launch", "vy": 11.0})
			if k >= 1.0:
				_landed = true
				for m in caster._monsters():
					var mon := m as Monster
					if absf(mon.position.x - to.x) <= 230.0:
						caster._hit(mon, SKY_DMG, {"type": "launch", "vy": 13.0})
				caster.page.shake_left = maxf(caster.page.shake_left, 0.22)
		if t > TIME + 0.4:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var d := (to - from).normalized()
		var n := d.orthogonal()
		if not _landed:
			# ก้อนลมหัวกลม หางเกลียวยาวย้อนขึ้นไปทางที่มา
			draw_circle(Vector2.ZERO, 70.0, Color(0.7, 1.0, 0.85, 0.25))
			draw_circle(Vector2.ZERO, 46.0, Color(0.85, 1.0, 0.92, 0.55))
			for i in 3:
				var pts := PackedVector2Array()
				for k in 16:
					var u := float(k) / 15.0
					pts.append(-d * u * 300.0 + n * sin(t * 30.0 + u * 8.0 + float(i) * 2.1) * (20.0 + u * 40.0))
				draw_polyline(pts, Color(1.0, 1.0, 1.0, 0.8 - float(i) * 0.2), 6.0 - float(i) * 1.5, true)
			draw_arc(Vector2.ZERO, 58.0, t * 20.0, t * 20.0 + PI * 1.4, 18, Color(1.0, 1.0, 1.0, 0.9), 5.0, true)
		else:
			# ตกพื้นแตกเป็นวงลมแผ่ออก
			var k := clampf((t - TIME) / 0.4, 0.0, 1.0)
			var a := 1.0 - k
			var r := 80.0 + k * 220.0
			var pts := PackedVector2Array()
			for i in 33:
				var ang := PI + PI * float(i) / 32.0
				pts.append(Vector2(cos(ang) * r, sin(ang) * r * 0.45))
			draw_polyline(pts, Color(0.75, 1.0, 0.85, 0.7 * a), 12.0 * a + 2.0, true)
			for i in 5:
				var x := (float(i) - 2.0) * 70.0
				draw_line(Vector2(x * (1.0 + k), 0.0), Vector2(x * (1.0 + k) * 1.2, -60.0 - k * 120.0), Color(1.0, 1.0, 1.0, 0.7 * a), 5.0, true)
