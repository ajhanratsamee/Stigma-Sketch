class_name ComboPanel
extends Control
## แผงรายการคอมโบ โผล่ใต้ปุ่มย้อนกลับ กว้างเท่าปุ่มคอมโบกับปุ่มย้อนกลับรวมกัน
## สองคอลัมน์ เห็นทีละ 4 แถว จะได้ไม่ยาวลงไปทับปุ่ม JUMP เกินจากนั้นลากขึ้นลงเพื่อเลื่อน หัวข้อชื่อสายกินเต็มแถว

const ROWS_VISIBLE := 4
const COLUMNS := 2
const ROW_H := 40.0
const PANEL_W := 800.0
const KEY_W := 112.0
const PAD := 10.0
const KEY_SIZE := 22
const TEXT_SIZE := UiStyle.SMALL
const LINE := UiStyle.LINE
const BAR_W := 4.0
# ปุ่มที่กด คำอธิบาย ^ คือกระโดด >> คือแดช
const COMBOS := [
	["zzzz", "ฟัน 4 ที"],
	["xxx", "หนัก 3 ที กระเด็น"],
	["zzzx", "ทีสุดท้ายกระเด็น"],
	["xxz", "เสยมอนลอยขึ้น"],
	["^z", "ฟันลงกลางอากาศ"],
	["^x", "ฟันหนัก มอนล้ม"],
	[">>zzz", "ฟัน 2 ที ทีสามทะลุ"],
	[">>x", "พุ่งงัดมอนขึ้น"],
	[">>^zzz", "กลางอากาศ 3 ที"],
	[">>^xx", "ฟาดพื้น มอนชะงัก"],
]
# คอมโบเพิ่มของ SWORD KNIGHT sa คือเกราะ ขอบตัวแดง
const SWORD_COMBOS := [
	["xxxxx", "เกราะ ฟันซ้ำแล้วแทง"],
	[">>zxx", "เกราะ เอาดาบดัน ทุบลอย"],
	["", "กด x แรกค้างเพื่อหน่วง"],
	[">>^zzz", "ทีสามตีลังกาพุ่งลง"],
]
const MAGIC_COMBOS := [
	["xzz", "ลูกไฟระเบิด มอนลอย"],
	["", "กด z แรกค้างชาร์จ เต็มแล้วไม่ลอย"],
	[">>zzx", "ฟัน 2 ที พุ่งทะลุ หันยิงไฟ"],
	[">>zzz", "ทีสามดาบไฟฟันทะลุ"],
	[">>^zxx", "ดาบไฟฟันโค้ง 2 ที"],
	[">>^xz", "ยิงลูกไฟเฉียงลง"],
]
const SHIELD_COMBOS := [
	["zzx", "เกราะ กระแทกโล่ กระเด็น"],
	["xxz", "เกราะ ตั้งโล่แล้วสวนฟัน"],
	[">>zx", "เกราะ ดันโล่พุ่ง หลายฮิต"],
	["^zx", "โล่ทุบพื้น โดนรอบตัว"],
]
const DARK_COMBOS := [
	[">>zz<x>", "รัว x ยิงลูกเลือด ทะลุ 2"],
	[">>^zzx", "ยิงลูกเลือดเฉียงลง"],
	["zzzxx", "ฟาดเลือด 2 ที ทีสองชะงัก"],
]

# คอมโบของ CAT SUSI <> กดรัว () กดค้าง ↓ กดลง > กดไปข้างหน้า
const MAGE_COMBOS := [
	["zzz", "ฟาดคฑา ทีสามมอนล้ม"],
	["xxxx", "ยิงลูกไฟ ลูกสุดท้ายล้ม"],
	[">>zz", "พุ่งตี แล้วงัดลอย"],
	[">>x", "พุ่ง หันกลับยิงลูกไฟ"],
	["^z", "ฟาดลงแนวดิ่ง"],
	["^x", "ยิงลูกไฟไปด้านหน้า"],
	[">>^z", "วงเวทเฉียงลง"],
	[">>^xx", "ลูกไฟเฉียงลง 2 ลูก"],
	["zz↓z", "วงเวทขาว มอนลอย"],
]
const BOW_COMBOS := [
	["zzzz", "เตะ 4 ที ทีสุดท้ายกระเด็น"],
	["zzzx", "เตะ 3 ที แล้วเตะเสยมอนลอย"],
	["xxxx", "ยิงธนู 4 ดอก ดอกสุดท้ายกระเด็น"],
	[">>zz", "สไลด์ แล้วหมุนเตะเสย มอนลอย"],
	[">>x", "อ้อมหลังแล้วหันยิง"],
	["^z", "พุ่งกระทืบลงพื้น"],
	["^x", "ยิงธนูลงมา 3 ดอก"],
	[">>^z", "เตะเฉียงกลางอากาศ"],
	[">>^xxx", "ยิงเฉียง 3 ดอก 3 ครั้ง ครั้งสุดท้ายล้ม"],
]
# คอมโบของแต่ละสาย CAT MATCHA  ↓ กดลง > กดไปหน้า ← กดถอยหลัง ^^ กระโดดซ้ำ
const BOW_LINE := {
	"WINDSTARKER": [
		["zzz>zz", "เข่าพุ่งกระแทก แล้วเตะลมเสยลอย"],
		[">>zzz", "สไลด์ซ้ำอีกครั้ง"],
		["^^zz", "กระทืบพื้น ยันพื้นหมุนเตะรอบตัว"],
	],
	"GALE TEMPEST": [
		["xxzzz", "ยิง 2 ดอก หัวชน เตะกลับหลัง กระเด็น"],
		[">>zx", "สไลด์เตะ อ้อมหลัง ปล่อยลมเขียว"],
		[">>^xzz", "ยิงเฉียง พุ่งเข่าลง เตะงัดลอย"],
	],
	"SNIPESTARKER": [
		["xxxxxx", "x สุดท้ายตั้งธนู"],
		[">>xx", "อ้อมหันหลังยิง แล้วตั้งธนู"],
		["ตั้งธนู z", "ยิงตรง 5 ดอก"],
		["ตั้งธนู x", "โปรยขึ้นฟ้า 5 ดอก"],
		[">>^zxx", "เตะ ศรลมเฉียงลง ยิงเฉียง 3 ดอก"],
	],
	"APEX SNIPER": [
		["zxxx", "กระโดดถอยยิง หมุนยิง ตั้งธนู"],
		[">>^xzz", "ยิง ศรลมเฉียงลง ยิงเฉียง 3 ดอก"],
		["xz", "ลมจากบนหัว มอนลอย"],
	],
	"MANASTARKER": [
		["zxxx", "พลังฟ้า แดง เหลืองกระเด็น"],
		["xzx", "z สายพลัง 3 สี / x ลูก 3 สีระเบิดลอย"],
		[">>zx", "สไลด์ พลัง 3 แฉก"],
	],
	"ESSENCE WEAVER": [
		[">>^xz", "พุ่งลงด้วยพลัง 3 สี"],
		[">>^zx", "ศร 3 สีเฉียงลง"],
		["zzx", "โปรยพลัง 3 สีช้าๆ หลายฮิต"],
	],
	"TRAPSTARKER": [
		["zzzzzzz", "เตะ 2 ฟันดาบ แทง ดึงออกมอนล้ม"],
		[">>zx", "สไลด์ ดาบฟันทะลุ"],
		[">>^zx", "เตะกลางอากาศ พุ่งดาบลงพื้น"],
	],
	"TWILIGHT": [
		[">>xz<z>", "แทงเร็ว รัวแทง 8 ฮิต ฟาดล้ม"],
		["zxxx", "เตะ ฟาดดาบหนัก ชะงัก"],
		[">>^xz", "ดาบแทงเฉียงลงพื้น"],
	],
}
# คอมโบของ CAT CITRUS
const SPEAR_COMBOS := [
	["zzzzz", "แทง ดึง หมุนแทง 3 ฟาด 2 กระเด็น"],
	["zzx", "ดีดตัวถอยหลังสูง มอนลอย"],
	["xxxxxxxxx", "ตวัด หมุนหอก เกราะควง แทงล้ม"],
	[">>z", "พุ่งแทงรัว"],
	[">>x", "ฟาดยาวลงพื้น ชะงัก"],
	[">>^zzz", "ฟาดลอย 2 ที ฟาดลงล้ม"],
	[">>^x", "ตวัดข้ามไปอีกด้าน หันกลับ"],
	["^z", "ฟาดลงแนวดิ่ง ชะงัก"],
	["^x", "ฟาดยาว มอนลอย"],
	["^^", "กระโดดซ้ำกลางอากาศ"],
	[">>^^", "กระโดดซ้ำไปข้างหน้า"],
	["^>>", "ย่ำอากาศไปข้างหน้า"],
]
# คอมโบของ CAT ASH หมัดกับเท้า
# คอมโบของแต่ละสาย CAT ASH
const FIST_LINE := {
	"HEAVYWEIGHT": [
		["↓ กลางอากาศ", "กระแทกพื้นรอบตัว ชะงัก"],
		["xzzz", "ผลักฝ่ามือ 2 ที ไหล่ชนล้ม"],
		["zzz↓z", "กระทืบพื้น มอนลอย"],
	],
	"GRAND SUMO": [
		["↓x", "กระโดดทืบพื้นวงกว้าง มอนลอย"],
		[">>zxx", "ไหล่ชน ทืบพื้นมอนลอยต่ำ"],
		["xx(z)", "กดค้างตบฝ่ามือรัว 10 ฮิต"],
	],
	"ZEPHYR": [
		["zzxxxxxxx", "กังฟูหลายท่า กระโดดหมุนเตะล้ม"],
		["xx", "ตวัดขาลอย ผลักมือล้ม"],
		["xzz", "ฟาดมือวงกลม ผลักล้ม"],
	],
	"KUNG FU": [
		[">>^zxx", "พุ่งลงเฉียง ตวัดขามอนลอย"],
		[">>zxx", "ฟาดมือเฉียง งัดลอย"],
		["zxx", "ตวัดมือวงกลม ต่อยงัดขึ้น"],
	],
	"WAR MUAY": [
		["xzzz", "เตะ ต่อย 2 ที ต่อย เตะกระเด็น"],
		[">>^zzx", "เข่าแล้วศอก มอนลอย"],
		[">>xxx", "เข่า ต่อย งัดลอย"],
	],
	"MUAY THAI": [
		["zxxx", "หมุนศอก ต่อยท้อง ศอกเสยลอย"],
		["xxz", "กระโดดเข่าทืบพื้น"],
		[">>zx", "พุ่งเข่า ชะงัก"],
	],
	"SYSTEMA GRAPPLER": [
		["zzz", "ฟาดมือลง ไหล่ดัน ปัดมือเสยลอย"],
		["xz", "เตะ ต่อยหน้า ลอยต่ำ"],
		[">>zzz", "ฟาดมือหน้า หมุนเตะเฉียงลง ชะงัก"],
	],
	"SAMBO": [
		["zz<xz>", "ไหล่ดัน รัวสลับฟาดมือกับเตะ 8 ที"],
		[">>x(x)", "กดค้างเตะสลับ 5 ที"],
		["^zx", "พุ่งชนมอน ชะงัก"],
	],
}
const FIST_COMBOS := [
	["zzzz", "จิ้ม จิ้ม ฮุก อัปเปอร์คัตลอย"],
	["zzx", "เตะกวาดขา มอนล้ม"],
	["xxxx", "เตะหน้า เหวี่ยง หมุนเตะ จามขวานล้ม"],
	[">>z", "พุ่งต่อย"],
	[">>x", "เข่าลอย มอนชะงัก"],
	["^z", "ต่อยพุ่งลงพื้น"],
	["^x", "หมุนเตะกลางอากาศ"],
	[">>^zz", "ต่อยกลางอากาศ ทุบลงชะงัก"],
]
const SPEAR_LINE := {
	"PETIT TIGER": [
		[">>^zx", "พุ่งลงเฉียง เกราะ กลิ้ง หันกลับ"],
		[">>^xz", "พุ่งลงเฉียง เกราะ กลิ้ง หันกลับ"],
		["zzxx", "พุ่งลงเฉียง เกราะ กลิ้ง หันกลับ"],
	],
	"FIERCE PROWLER": [
		[">>xz", "เกราะ พุ่งแทงรัว 3 ฮิต"],
		["^^xxz", "ฟาดลอยซ้ำ ดิ่งลงทั้งตัวพร้อมหอก"],
		[">>z(x)", "ค้าง x ชาร์จ พุ่งแทงมอนกระเด็น"],
	],
	"PETIT FANG": [
		[">>zx", "บอลหมาป่า 3 ลูก ทะลุ"],
		[">>xzx", "หมุนอ้อมหลัง บอลหมาป่า 3 ลูก"],
		[">>^zx", "บอลหมาป่า 3 ลูกเฉียงลง"],
	],
	"LUPINE DIRE": [
		["zzzz>z", "บอลหมาป่า 1 ลูก"],
		[">>^xzx", "ตวัดทะลุแล้วกลับ หันยิงบอลหมาป่า"],
		["xx↓x", "บอลหมาป่า 3 ลูก ทะลุ"],
	],
	"PETIT VIXEN": [
		[">>^zxx", "วาปกระทืบ รอยข่วนจิ้งจอก 4 รอย"],
		["xx↓x<x>", "แทงดึง รัวข่วน 10 ที กระเด็น"],
		["zzzx", "อ้อมหลัง เรียกเล็บข่วน"],
	],
	"PHANTOM VULPINE": [
		[">>^xz", "ปิ่นปักผมเฉียงลง 3 ฮิต"],
		[">>^xxz", "วาปกระทืบวงกว้าง ปาปิ่น 3 อัน"],
		[">>zzx", "แทงซ้ำ เล็บข่วนขึ้น มอนลอย"],
		["xx↓x", "แทงดึง ข่วนต่อเอง 10 ที กระเด็น"],
	],
	"PETIT SHELL": [
		[">>^zx", "ปายันต์เฉียงลง 2 ใบ"],
		[">>xz", "ปายันต์ไปหน้า ทะลุมอน"],
		[">>^xz", "ปายันต์เฉียงลง"],
	],
	"GENBU TITAN": [
		["zzxx", "ปายันต์ลง 2 ใบ"],
		[">>^zxx", "แทงหอกขึ้นฟ้า กระทืบพื้น มอนลอยต่ำ"],
		[">>zx", "พุ่งชน มอนลอย"],
	],
}
# คอมโบของ CAT AZURE & LAPIS แยกตามตัวที่ออกหน้า
const PAIR_AZURE := [
	["zzzzx", "ข่วน 3 ที เสยลอย LAPIS กระโดดเตะ"],
	["xxxxz", "ต่อยไถล 3 ที ทุบพื้นลอย LAPIS เตะ"],
	[">>^zx", "ข่วน แล้วคลื่นพลังน้ำเงิน"],
	[">>^xxxxz", "ดีดขึ้น พุ่งลง ต่อย ตวัดขึ้น LAPIS เตะ"],
	[">>z", "พุ่งข่วนมอนลอย"],
	[">>x", "กระโดดกำหมัดทุบพื้น"],
	["^z", "ข่วนลงแนวดิ่ง"],
	["^x", "ข่วนแรง มอนล้ม"],
]
const PAIR_LAPIS := [
	["zzzzx", "ฟันดาบปลายปืน 3 ที ยิงลอย AZURE เตะ"],
	["xxxxz", "ยิง 3 นัด นัดที่ 4 แรง AZURE เตะ"],
	[">>^zx", "ฟันตวัดรอบตัว ปาระเบิดน้ำเงิน"],
	[">>^xxxxz", "ยิงเฉียงลง 4 นัด AZURE พุ่งลงต่อย"],
	[">>z", "สไลด์เตะ"],
	[">>x", "อ้อมหลังแล้วยิง"],
	["^z", "ฟันลงแนวดิ่ง"],
	["^x", "ยิงไปข้างหน้า"],
]
## คอมโบสายต่อยอดของคู่ ท่าเดียวกันแต่ AZURE กับ LAPIS ออกท่าต่างกัน (AZURE / LAPIS)
const PAIR_LINE := {
	"SPARK DREAMER": [
		["zzx", "หมอนเสยลอย / ยิงฟองฝันหลับ"],
		[">>zx", "หมุนเพลงกล่อม / ฟองกล่อม 3 ลูก"],
		["^xz", "ดิ่งกล่อมหลับ / ปาแกะฝัน"],
	],
	"SOMNAMBULIST": [
		["xxz", "ละเมอต่อยรัว หมัดปิดล้ม / ยิงกระจาย 3 นัด"],
		[">>xz", "ประตูฝันดูด แล้วพ่นมอนลอย"],
		["^zx", "ทุบหมอนพื้น / คลื่นกรนผลัก"],
	],
	"SPARK FIEND": [
		["zzx", "เสยไฟฟ้ามอนลอย / กระสุนช็อตต่อ 2 ตัว"],
		[">>zx", "พุ่งไฟฟ้า / ยิงบอลไฟฟ้า"],
		["^xz", "ดิ่งฟ้าผ่า / ยิงเสาฟ้าผ่า"],
	],
	"NEON BOLT": [
		["xxz", "พุ่งฟันนีออน / ลำแสงราง"],
		[">>xz", "กากบาทนีออน / พุ่งฟันนีออนกลับ"],
		["^zx", "แท่งนีออนตก 2 แท่ง / ฝนนีออน 3 สาย"],
	],
}
const MAGE_LINE := {
	"ARCH MAGE": [
		["xxz<z>", "เกราะ กวาดลม เมฆสายฟ้า รัว 10"],
		["zzx<x>", "ไฟเลื้อยพื้น รัวลูกไฟ 10"],
		[">>^xxx", "ลูกไฟเฉียงลงลูกที่สาม"],
	],
	"ELEMENT MASTER": [
		[">>xx", "ยิงลูกไฟเพิ่มอีกลูก"],
		[">>xz", "น้ำแข็งไกล 6 ช่วงตัว แตกลากมอนมา"],
		[">>^xz(z)", "ไฟฟ้าเฉียงลง ค้างลอยช็อตรัว"],
	],
	"BATTLE MAGE": [
		["zzzzz", "ท่าใหม่ ตวัด หมุนตัว ปัดมอน"],
		[">>^zxxx", "วาร์ปฟาดหัว แทง ยกลอย"],
		[">>xx", "โปรยผงมิติ ดาเมจต่อเนื่อง"],
	],
	"DIMENSION CASTER": [
		[">>xxz", "เรียกผงมิติกลับ ลากมอน"],
		[">>^zxxxx", "บอลมิติฟาด กดมอนลงพื้น"],
		["zzxx", "โปรยผงมิติ แล้วดึงกลับ"],
	],
	"DARK MAGE": [
		[">>xx", "ลูกบอลมืดลอยค้าง"],
		["zz↓z", "คฑาทุบพื้น มอนชะงัก"],
		["xx<z>", "รัวลูกบอลมืด ชะงักต่อเนื่อง"],
	],
	"ECLIPSE": [
		["zz(x)", "ค้างยิงลูกบอลมืดช้า 8 ลูก"],
		[">>^xx", "ลูกบอลมืดเฉียงลงช้าๆ"],
		["xzzz", "ตีคฑา 3 ฮิต ทุบพื้นชะงัก"],
	],
	"ALCHEMIST MAGE": [
		[">>xx", "กระโดดถอยปาขวดยา"],
		["zz↓z", "ปาขวดยา มอนลอย"],
		["xxz", "ปาขวดยา กระโดดถอย"],
	],
	"TRANSMUTATION MASTER": [
		[">>zzxx", "ขวดยาจากฟ้า หม้อปรุงยาทับ"],
		[">>^xz", "หมุนตัวโปรยขวดยา 3 ขวด"],
		["zz>z", "ถือขวดยาฟาด"],
	],
}

var rows: Array = COMBOS

## แสดงคอมโบของ BASIC และของสายที่เลือกเพิ่ม
func set_class(class_id: String, weapon := "") -> void:
	# CAT SUSI คอมโบ BASIC ของตัวเอง แล้วสายแม่ แล้วสายที่เลือก
	if weapon == "fist":
		rows = FIST_COMBOS.duplicate()
		var fchain := FistCombo.chain(class_id)
		fchain.reverse()
		for id in fchain:
			if FIST_LINE.has(id):
				rows.append([id, ""])
				rows.append_array(FIST_LINE[id])
		scroll = 0.0
		return
	if weapon == "azure":
		rows = [["AZURE", ""]]
		rows.append_array(PAIR_AZURE)
		rows.append(["LAPIS", ""])
		rows.append_array(PAIR_LAPIS)
		var pchain := PairCombo.chain(class_id)
		pchain.reverse()
		for id in pchain:
			if PAIR_LINE.has(id):
				rows.append([id, ""])
				rows.append_array(PAIR_LINE[id])
		scroll = 0.0
		return
	if weapon == "bow" or weapon == "spear":
		rows = (BOW_COMBOS if weapon == "bow" else SPEAR_COMBOS).duplicate()
		var table: Dictionary = BOW_LINE if weapon == "bow" else SPEAR_LINE
		var chain_ids := BowCombo.chain(class_id)
		chain_ids.reverse()
		for id in chain_ids:
			if table.has(id):
				rows.append([id, ""])
				rows.append_array(table[id])
		scroll = 0.0
		return
	if weapon == "mage":
		rows = MAGE_COMBOS.duplicate()
		var line := MageCombo.chain(class_id)
		line.reverse()
		for id in line:
			if MAGE_LINE.has(id):
				rows.append([id, ""])
				rows.append_array(MAGE_LINE[id])
		scroll = 0.0
		return
	# สายต่อยอดใช้คอมโบของสายแม่
	class_id = {"GRAND KNIGHT": "SWORD KNIGHT", "FLAME KNIGHT": "MAGIC KNIGHT", "GUARDIAN KNIGHT": "SHIELD KNIGHT", "CRIMSON KNIGHT": "DARK KNIGHT"}.get(class_id, class_id)
	rows = COMBOS.duplicate()
	if class_id == "SWORD KNIGHT" or class_id == "GRAND KNIGHT":
		rows.append(["SWORD KNIGHT", ""])
		rows.append_array(SWORD_COMBOS)
	if class_id == "MAGIC KNIGHT":
		rows.append(["MAGIC KNIGHT", ""])
		rows.append_array(MAGIC_COMBOS)
	if class_id == "SHIELD KNIGHT":
		rows.append(["SHIELD KNIGHT", ""])
		rows.append_array(SHIELD_COMBOS)
	if class_id == "DARK KNIGHT":
		rows.append(["DARK KNIGHT", ""])
		rows.append_array(DARK_COMBOS)
	scroll = 0.0

var scroll := 0.0
var _list: Node2D

func _ready() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_list = Node2D.new()
	_list.draw.connect(_draw_list)
	add_child(_list)

## วางแผงใต้ปุ่มย้อนกลับ ชิดขอบซ้ายของปุ่มคอมโบถึงขอบขวาของปุ่มย้อนกลับ
func place(combo_button: Vector2, back_button: Vector2, radius: float) -> void:
	var right := back_button.x + radius
	var left := minf(combo_button.x - radius, right - PANEL_W)
	position = Vector2(left, back_button.y + radius + 12.0)
	size = Vector2(right - left, ROW_H * float(ROWS_VISIBLE) + PAD * 2.0)

## จัดรายการลงช่อง [แถว คอลัมน์ รายการ เต็มแถว] หัวข้อขึ้นแถวใหม่และกินเต็มแถว
func _cells() -> Array:
	var out := []
	var line := 0
	var col := 0
	for item in rows:
		if str(item[1]) == "" and str(item[0]) != "":
			if col > 0:
				line += 1
				col = 0
			out.append([line, 0, item, true])
			line += 1
			continue
		out.append([line, col, item, false])
		col += 1
		if col >= COLUMNS:
			col = 0
			line += 1
	return out

func line_count() -> int:
	var cells := _cells()
	if cells.is_empty():
		return 0
	var last: Array = cells[cells.size() - 1]
	return int(last[0]) + 1

func max_scroll() -> float:
	return maxf(ROW_H * float(line_count()) - ROW_H * float(ROWS_VISIBLE), 0.0)

func scroll_by(dy: float) -> void:
	scroll = clampf(scroll + dy, 0.0, max_scroll())
	_list.queue_redraw()
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenDrag and Rect2(global_position, size).has_point(event.position):
		scroll_by(-event.relative.y)
		get_viewport().set_input_as_handled()

func _draw() -> void:
	var box := Rect2(Vector2.ZERO, size)
	UiStyle.box(self, box.grow(-1.5), 700, LINE, UiStyle.INK, Color(UiStyle.PAPER, 1.0))
	# แถบบอกตำแหน่งเลื่อน
	if max_scroll() > 0.0:
		var track := size.y - PAD * 2.0
		var bar := track * float(ROWS_VISIBLE) / float(maxi(line_count(), 1))
		var y := PAD + (track - bar) * scroll / max_scroll()
		draw_rect(Rect2(size.x - BAR_W - 4.0, y, BAR_W, bar), TouchPad.EMPTY_RING)

func _draw_list() -> void:
	var font := Sketch.font()
	var col_w := (size.x - PAD * 2.0 - 10.0) / float(COLUMNS)
	var lines := line_count()
	for cell in _cells():
		var top := PAD + float(cell[0]) * ROW_H - scroll
		if top + ROW_H < 0.0 or top > size.y:
			continue
		var item: Array = cell[2]
		var x := PAD + col_w * float(cell[1])
		if cell[3]:
			# หัวข้อชื่อสาย มีอุ้งเท้านำหน้า
			UiStyle.paw(_list, Vector2(x + 14.0, top + 20.0), 12.0)
			_list.draw_string(font, Vector2(x + 32.0, top + 27.0), item[0], HORIZONTAL_ALIGNMENT_LEFT, col_w * float(COLUMNS), KEY_SIZE, Color(0.75, 0.2, 0.2))
		else:
			# ปุ่มยาวหรือคำอธิบายยาว ย่อให้พอดีช่อง ไม่โดนตัด
			var key_px := Sketch.fit_size(item[0], KEY_SIZE, KEY_W - 8.0, 14)
			var text_px := Sketch.fit_size(item[1], TEXT_SIZE, col_w - KEY_W - 8.0, 14)
			_list.draw_string(font, Vector2(x + 4.0, top + 27.0), item[0], HORIZONTAL_ALIGNMENT_LEFT, -1.0, key_px, Sketch.INK)
			_list.draw_string(font, Vector2(x + KEY_W, top + 26.0), item[1], HORIZONTAL_ALIGNMENT_LEFT, -1.0, text_px, Sketch.INK)
		if int(cell[0]) < lines - 1:
			_list.draw_line(Vector2(x, top + ROW_H - 2.0), Vector2(x + (col_w * float(COLUMNS) if cell[3] else col_w) - 8.0, top + ROW_H - 2.0), TouchPad.EMPTY_RING, 1.5)
	# เส้นแบ่งคอลัมน์
	_list.draw_line(Vector2(PAD + col_w, 0.0), Vector2(PAD + col_w, size.y), TouchPad.EMPTY_RING, 1.5)
