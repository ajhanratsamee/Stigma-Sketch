class_name SpearLineTiger
## คอมโบสาย PETIT TIGER / FIERCE PROWLER ของ CAT CITRUS
## ใช้ชื่อท่าและชื่อเอฟเฟกต์ขึ้นต้นด้วย spt_ เท่านั้น
## PETIT TIGER: >>^zx / >>^xz / zzxx  พุ่งลงเฉียง กระทบพื้นติด sa กลิ้งไปหน้านิดหนึ่งแล้วหันกลับ
## FIERCE PROWLER: >>xz พุ่งแทงรัว 3 ฮิต sa   ^^xxz ฟาดลอยซ้ำแล้วหมุนหอกฟาดลงหน้าชะงัก
##                 >>z(x) กดค้าง x ชาร์จ ปล่อยพุ่งแทงมอนกระเด็น

const NEXT := {
	"PETIT TIGER": {
		# >>^zx
		# ฟาดกลางอากาศแบบชะงัก ไม่เสยลอย ท่าพุ่งลงตามมาจะได้โดน
		"spt_adz1": {"x": "spt_dive", "z": "sp_adz2"},
		# >>^xz (กดระหว่างตวัดข้ามหรือหลังหันกลับก็ได้)
		"sp_adx": {"z": "spt_dive"},
		"sp_adx_turn": {"z": "spt_dive"},
		# zzxx: zzx ดีดตัวถอยหลังเสยลอยแล้ว x ดีดขึ้นนิดแล้วพุ่งลงเฉียง
		"sp_z2": {"x": "spt_zzx"}, "spt_zzx": {"x": "spt_hop_dive"}, "sp_zzx": {"x": "spt_hop_dive"},
	},
	"FIERCE PROWLER": {
		# >>xz
		"sp_dx": {"z": "spt_rush3"},
		# ^^xxz
		"sp_ax": {"x": "spt_ax2"},
		"spt_ax2": {"z": "spt_spin_down"},
		# >>z(x) แทงรัวแล้วกดค้าง x ชาร์จ ปล่อยพุ่งแทงมอนกระเด็น
		"sp_dz": {"x": "spt_charge_stab"},
	},
}
const START := {
	"PETIT TIGER": {"airdash_z": "spt_adz1"},
}

static func _mv(base: Dictionary, over: Dictionary) -> Dictionary:
	var d := base.duplicate(true)
	d.merge(over, true)
	return d

## เพิ่มท่าลงตาราง m (มีท่า sp_ ของ BASIC อยู่แล้ว ใช้เป็นแม่แบบ)
static func add_moves(m: Dictionary) -> void:
	var stab: Dictionary = m["sp_z1"]
	var down: Dictionary = m["sp_x9"]
	var chop: Dictionary = m["sp_az"]
	var lift: Dictionary = m["sp_ax"]
	# พุ่งลงเฉียง แทงหอกเฉียงลง ค้างจนถึงพื้นแล้วค่อยโดน ติด sa ตอนกระแทก
	var dive := _mv(down, {"name": "พุ่งลงเฉียงกระแทกพื้น", "dive": true, "dive_forward": 3.2, "time": 0.42, "wind": 0.25, "strike": 0.55, "next": 0.7,
		"dmg": 28.0, "lunge": 0.0, "front_hit": true, "shake": 0.28, "stop": 0.08, "fx": "spt_impact", "auto": "spt_roll",
		"hit": {"kb": 0.8, "stun": 0.8}})
	m["spt_dive"] = dive
	# จากพื้น ดีดตัวขึ้นนิดหนึ่งก่อนพุ่งลง
	m["spt_hop_dive"] = _mv(dive, {"name": "ดีดขึ้นแล้วพุ่งลงเฉียง", "leap": 5.0, "wind": 0.4, "strike": 0.62, "dive_forward": 5.0, "dmg": 15.0})
	# zzx ของสายเสือ ดีดตัวถอยแล้วฟาดให้มอนชะงักอยู่กับที่ (ไม่ลอย ไม่ล้ม) ท่าพุ่งลงตามมาจะกระแทกโดน
	m["spt_adz1"] = _mv(m["sp_adz1"], {"name": "ฟาดกลางอากาศชะงัก", "hit": {"kb": 0.3, "stun": 1.2}})
	m["spt_zzx"] = _mv(m["sp_zzx"], {"name": "ดีดตัวถอยฟาดชะงัก", "hit": {"kb": 0.2, "stun": 1.3}})
	# กลิ้งไปหน้านิดหนึ่ง ยังติด sa แล้วหันกลับ
	m["spt_roll"] = _mv(stab, {"name": "กลิ้งไปหน้า", "roll_once": true, "ghost": true, "sa": true, "time": 0.36, "wind": 0.05, "strike": 0.5, "next": 0.9,
		"lunge": 1.7, "dmg": 6.0, "lean": 30.0, "front_hit": true, "multi": 0.1, "multi_once": true, "multi_ahead": 40.0, "multi_half": 130.0, "shake": 0.05, "stop": 0.0, "fx_start": "spt_roll", "fx": "",
		"hit": {"kb": 0.3, "stun": 0.4}})
	# หันกลับแล้วฟาดหอกกวาด ทำดาเมจ
	m["spt_turn"] = _mv(m["sp_z4"], {"name": "หันหลังฟาด", "turn_around": true, "spin": 0.0, "time": 0.42, "wind": 0.3, "strike": 0.6, "next": 0.75, "lunge": 0.2, "dmg": 18.0,
		"multi": null, "front_hit": true, "shake": 0.15, "stop": 0.06, "fx": "sp_sweep", "fx_start": "", "hit": {"kb": 1.2, "stun": 0.6}})
	m["spt_turn"].erase("multi")
	# FIERCE PROWLER >>xz พุ่งแทงรัว 3 ฮิต ติด sa
	m["spt_rush3"] = _mv(stab, {"name": "พุ่งแทงรัว 3 ฮิต", "ease": 1.0, "time": 0.42, "wind": 0.12, "strike": 0.8, "next": 0.88, "dmg": 9.0, "lunge": 1.9, "sa": true,
		"multi": 0.09, "multi_ahead": 150.0, "multi_half": 140.0, "fx_start": "spt_rush", "fx": "sp_thrust", "hit": {"kb": 0.4, "stun": 0.55}})
	# ^^xxz x ที่สองฟาดลอยอีกที
	m["spt_ax2"] = _mv(lift, {"name": "ฟาดลอยซ้ำ", "roll_once": true, "dmg": 13.0, "hit": {"type": "launch", "vy": 10.0}})
	# z หมุนหอกฟาดลงด้านหน้า ชะงัก
	# ^^xxz z สุดท้าย ดิ่งลงทั้งตัวพร้อมหอกกระแทกพื้น โดนตอนถึงพื้น
	m["spt_spin_down"] = _mv(down, {"name": "ดิ่งทั้งตัวพร้อมหอกกระแทกพื้น", "dive": true, "time": 0.42, "wind": 0.15, "strike": 0.55, "next": 0.85, "dmg": 22.0,
		"lunge": 0.0, "lean": 45.0, "front_hit": true, "shake": 0.3, "stop": 0.08, "fx": "spt_impact", "hit": {"kb": 0.4, "stun": 1.2}})
	# >>z(x) กดค้างชาร์จได้นานสุด 1 วิ ปล่อยแล้วพุ่งแทง ชาร์จยิ่งนานยิ่งแรงและกระเด็นไกล
	m["spt_charge_stab"] = _mv(stab, {"name": "ชาร์จพุ่งแทง", "hold": 1.0, "hold_button": "x", "charge_glow": true, "time": 0.5, "wind": 0.35, "strike": 0.7, "next": 0.9,
		"dmg": 12.0, "lunge": 2.4, "lean": 30.0, "shake": 0.2, "stop": 0.06, "fx_start": "spt_rush", "fx": "spt_charge_hit",
		"hit": {"type": "knockdown", "fly": 4.0}})

## เล่นเอฟเฟกต์ของสายนี้ คืน true ถ้าเป็นของสายนี้
static func cast(page: WalkPage, fx: String) -> bool:
	if not fx.begins_with("spt_"):
		return false
	# พุ่งแทงหลังชาร์จ ฮิตเสริมตามแรงชาร์จ มอนกระเด็นไกลขึ้น
	if fx == "spt_charge_hit":
		var charge := clampf(page._hold_t / 1.0, 0.0, 1.0)
		if charge > 0.1:
			var f := page.hero.facing
			page._hit_area(page.hero.position.x + f * 120.0, 170.0, 30.0 * charge, f, null, {"type": "knockdown", "fly": 4.0 + 7.0 * charge}, page._body_span())
			page.shake_left = maxf(page.shake_left, 0.2 + 0.2 * charge)
		SpearTigerFx.cast(page, "spt_impact")
		return true
	SpearTigerFx.cast(page, fx)
	return true
