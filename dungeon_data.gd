class_name DungeonData
## ข้อมูลเมืองและดันเจี้ยน เมืองแรกมี 5 ดันเจี้ยน เมืองถัดไปเพิ่มเมืองละ 1 ดันเจี้ยน (dungeon_count)
## แต่ละดันมีด่านยาวหลายด่าน แต่ละด่านมีมอนรวม 15-30 ตัวกระจายทั่วแมพ เดินไปตีเอง ตีหมดแล้วประตูท้ายแมพเปิด
## ด่านสุดท้ายเป็นห้องบอส  theme คือฉากหลังของดัน (ไม่ซ้ำกัน)  map คือตำแหน่งบนแผงแผนที่ 0 ถึง 1

const BASE_DUNGEONS := 5

const TOWNS := [
	{
		"name": "เมืองอัศวินเหมียว",
		"dungeons": [
			{"name": "ทุ่งหญ้าไหมพรมเด้ง", "icon": "meadow", "theme": "meadow", "map": Vector2(0.1, 0.7), "text": "ทุ่งหญ้ากว้างนอกกำแพงเมือง ไหมพรมกระโดดดึ๋งๆ เต็มทุ่ง ราชาไหมพรมรออยู่ท้ายทุ่ง",
				"stages": [[["cat_mochi", 12], ["cat_puff", 4]], [["cat_mochi", 10], ["cat_puff", 6], ["cat_long", 4]]], "boss": "boss_club"},
			{"name": "ป่าแตงกวา", "icon": "forest", "theme": "forest", "map": Vector2(0.3, 0.32), "text": "ป่าลึกนอกเมือง แตงกวาตกใจซ่อนตัวอยู่หลังต้นไม้ แมวเห็นแล้วสะดุ้ง",
				"stages": [[["cat_long", 10], ["cat_mochi", 8]], [["cat_long", 12], ["cat_puff", 6], ["cat_ghost", 4]]], "boss": "boss_spear"},
			{"name": "ซากป้อมกล่องกระดาษ", "icon": "ruins", "theme": "ruins", "map": Vector2(0.5, 0.66), "text": "ป้อมเก่าริมเมืองที่ถูกหุ่นดูดฝุ่นยึดครอง เสียงดังน่ากลัวสำหรับแมว",
				"stages": [[["cat_box", 12], ["cat_cyclops", 6]], [["cat_box", 10], ["cat_cyclops", 8], ["cat_puff", 6]]], "boss": "boss_hammer"},
			{"name": "หอคอยหนูเงา", "icon": "tower", "theme": "tower", "map": Vector2(0.7, 0.28), "text": "หอคอยมืดในเมืองเก่า ขวดสเปรย์ลอยกับหนูจอมซนเฝ้าอยู่",
				"stages": [[["cat_ghost", 12], ["cat_cyclops", 8]], [["cat_ghost", 12], ["cat_cyclops", 8], ["cat_puff", 6]]], "boss": "boss_scythe"},
			{"name": "ลานประลองราชันแมว", "icon": "arena", "theme": "arena", "map": Vector2(0.9, 0.6), "text": "ลานประลองกลางปราสาท ราชันหมาอัศวินรออยู่",
				"stages": [[["cat_mochi", 6], ["cat_long", 5], ["cat_box", 5], ["cat_ghost", 6]], [["cat_puff", 6], ["cat_cyclops", 6], ["cat_long", 6], ["cat_box", 5], ["cat_ghost", 5]]], "boss": "boss_king"},
		],
	},
]

## ช่วงเลเวลของแต่ละเมือง เมืองแรก 1-15 เมืองสอง 15-30 เมืองสาม 30-40 จากนั้นเมืองละ 10 เลเวลจนถึง 99
## เลเวล 15 ทำเควสปลดคลาสได้ที่เมืองสอง  เลเวล 35 ทำเควสเปลี่ยนคลาสต่อยอดได้ที่เมืองสาม
const MAX_LEVEL := 99
const CLASS_QUESTS := [{"level": 15, "town": 1, "text": "เควสปลดคลาส"}, {"level": 35, "town": 2, "text": "เควสเปลี่ยนคลาสต่อยอด"}]

static func town_levels(town: int) -> Vector2i:
	match town:
		0:
			return Vector2i(1, 15)
		1:
			return Vector2i(15, 30)
		2:
			return Vector2i(30, 40)
	var lo := 40 + (town - 3) * 10
	return Vector2i(mini(lo, MAX_LEVEL), mini(lo + 10, MAX_LEVEL))

## จำนวนเมืองทั้งหมดจนถึงเลเวลสูงสุด
static func town_total() -> int:
	var t := 0
	while town_levels(t).y < MAX_LEVEL:
		t += 1
	return t + 1

## เลเวลขั้นต่ำที่เข้าดันนี้ได้ ไล่จากต้นช่วงของเมืองขึ้นไปตามลำดับดัน
static func dungeon_level(town: int, index: int) -> int:
	var r := town_levels(town)
	var n := dungeon_count(town)
	return r.x + floori(float(r.y - r.x) * float(index) / float(n))

## ตัวละครเลเวลนี้เข้าดันนี้ได้ไหม
static func can_enter(town: int, index: int, level: int) -> bool:
	return level >= dungeon_level(town, index)

## จำนวนดันเจี้ยนของเมืองลำดับนี้ เมืองแรก 5 เมืองถัดไปเพิ่มเมืองละ 1
static func dungeon_count(town: int) -> int:
	return BASE_DUNGEONS + town

## ชื่อเมืองทั้งหมดจนถึงเลเวล 99
const TOWN_NAMES := ["เมืองอัศวินเหมียว", "เมืองตลาดปลาทู", "หมู่บ้านแมวภูเขา", "ท่าเรือแมวน้ำ", "เมืองแมวทะเลทราย", "หมู่บ้านแมวหิมะ", "เกาะแมวภูเขาไฟ", "ปราสาทแมวเงา", "สวรรค์แมวทอง"]
const TOWN_WORDS := ["เหมียว", "ปลาทู", "ภูเขา", "แมวน้ำ", "ทะเลทราย", "หิมะ", "ภูเขาไฟ", "เงา", "ทอง"]
const THEMES := ["meadow", "forest", "ruins", "tower", "arena"]
const THEME_WORDS := {"meadow": "ทุ่งหญ้า", "forest": "ป่า", "ruins": "ซากป้อม", "tower": "หอคอย", "arena": "ลานประลอง",
	"fishmarket": "ตลาดปลา", "canal": "คลองแมว", "mine": "เหมือง", "crystal": "ถ้ำคริสตัล", "shipwreck": "ซากเรือ", "seacave": "ถ้ำทะเล",
	"dunes": "เนินทราย", "pyramid": "พีระมิด", "oasis": "โอเอซิส", "skislope": "ลานสกี", "frozenlake": "ทะเลสาบน้ำแข็ง", "icecave": "ถ้ำน้ำแข็ง",
	"crater": "ปากปล่อง", "lavatunnel": "อุโมงค์ลาวา", "library": "ห้องสมุด", "cells": "คุกใต้ปราสาท", "rooftop": "หลังคาปราสาท",
	"cloudgarden": "สวนเมฆ", "skytemple": "วิหารฟ้า",
	"train": "รถไฟ", "underwater": "ใต้ทะเล", "airship": "เรือเหาะ", "minecart": "รางรถแร่", "kitchen": "ครัวยักษ์",
	"toybox": "ห้องของเล่น", "waterfall": "น้ำตก", "cattree": "ป่าคอนโดแมว", "nightmarket": "ตลาดโคม",
	"metro": "สถานีใต้ดิน", "cellar": "ห้องใต้ดิน", "mushcave": "อุโมงค์เห็ดเรือง", "sewer": "อุโมงค์ทางน้ำ", "duskroof": "หลังคายามเย็น",
	"cloudisle": "เกาะเมฆ", "bamboo": "ป่าไผ่", "snowpass": "ช่องเขาหิมะ", "desertruin": "ซากซุ้มทราย", "toyfactory": "โรงงานของเล่น",
	"clocktower": "หอนาฬิกา", "pier": "สะพานท่าเรือ", "candy": "ดินแดนขนม", "mansion": "คฤหาสน์ผีน้อย"}
const BOSSES := ["boss_club", "boss_spear", "boss_hammer", "boss_scythe", "boss_king"]

static func town_name(town: int) -> String:
	return TOWN_NAMES[town] if town >= 0 and town < TOWN_NAMES.size() else "เมือง %d" % (town + 1)

static func dungeon(town: int, index: int) -> Dictionary:
	if town < 0 or town >= town_total() or index < 0 or index >= dungeon_count(town):
		return {}
	if town < TOWNS.size():
		var list: Array = TOWNS[town]["dungeons"]
		return list[index] if index < list.size() else {}
	return _made(town, index)

## ชื่อและคำบรรยายดันเจี้ยนของเมือง 2-9 แยกตามฉาก เรียงตามลำดับที่เจอในเมือง
const MADE_NAMES := {
	1: {
		"meadow": [["ทุ่งหญ้าตากปลา", "ทุ่งโล่งหลังตลาดที่ชาวบ้านตากปลาแห้ง ไหมพรมแอบมาขโมยกลิ่น"], ["ทุ่งดอกแคทนิปหลังตลาด", "ดอกแคทนิปบานเต็มทุ่ง ใครเข้าไปก็เผลอกลิ้งไปมา"]],
		"forest": [["ป่าไผ่ปลาทู", "ป่าไผ่ที่ลมพัดแล้วมีกลิ่นปลาย่าง แตงกวาซ่อนอยู่ตามกอไผ่"], ["ป่าเห็ดตลาดเช้า", "เห็ดยักษ์โตข้ามคืน หนูจอมซนชอบมาแทะ"]],
		"ruins": [["โกดังปลาร้าง", "โกดังเก่าที่หุ่นดูดฝุ่นยึดไว้ เสียงดังจนแมวขนลุก"], ["ซากเรือนกระดาษริมคลอง", "บ้านกล่องกระดาษริมคลองที่ถูกทิ้ง กลายเป็นรังมอน"]],
		"tower": [["หอระฆังตลาดเก่า", "หอระฆังที่ไม่มีใครตีมานาน ขวดสเปรย์ลอยวนอยู่ข้างใน"], ["หอคอยปลาทูเค็ม", "หอคอยเก็บปลาเค็ม ข้างบนมีหนูเงาเฝ้าอยู่"]],
		"arena": [["ลานประกวดปลาทูยักษ์", "ลานกลางตลาดที่จัดประกวดปลา บอสรอท้าแข่ง"], ["สนามแข่งรถเข็นปลา", "สนามแข่งรถเข็นที่วุ่นวายที่สุดในเมือง"]],
	},
	2: {
		"meadow": [["ทุ่งหญ้าไหล่เขา", "ทุ่งหญ้าลาดชันที่ลมแรงจนไหมพรมกลิ้งลงเขา"], ["ทุ่งดอกไม้ยอดเมฆ", "ทุ่งดอกไม้เหนือเมฆ หนาวนิดๆ แต่สวยมาก"]],
		"forest": [["ป่าสนหางฟู", "ป่าสนทึบ แตงกวาสวมหมวกไหมพรมกันหนาว"], ["ป่าหมอกเช้า", "หมอกหนาจนมองไม่เห็นหนวดตัวเอง"]],
		"ruins": [["เหมืองร้างกลิ่นปลา", "เหมืองเก่าที่ถูกทิ้ง หุ่นดูดฝุ่นขุดหาแร่อยู่"], ["วัดเก่ากลางเขา", "วัดเก่าที่แมวเคยมานั่งสมาธิ ตอนนี้มอนยึดไปแล้ว"]],
		"tower": [["หอสังเกตการณ์หิมะ", "หอสูงบนยอดเขา ขวดสเปรย์ลอยตามลม"], ["หอคอยคริสตัลหลับ", "หอคอยที่คริสตัลกรนดังจนผนังสั่น"]],
		"arena": [["ลานประลองยอดเขา", "ลานหินบนยอดเขา ผู้กล้าต้องสู้ท่ามกลางลมแรง"], ["ลานหินผาแมวกล้า", "หน้าผาที่แมวกล้าเท่านั้นจะกล้าขึ้นไป"]],
	},
	3: {
		"meadow": [["ทุ่งหญ้าริมหาด", "ทุ่งหญ้าติดชายหาด ปลาปักเป้าลอยมาเกยตื้น"], ["ทุ่งเปลือกหอยสีชมพู", "เปลือกหอยเต็มทุ่ง เดินแล้วดังกรุบกรับ"]],
		"forest": [["ป่าโกงกางแมวน้ำ", "ป่าโกงกางรากพันกัน แตงกวาลอยน้ำมาซ่อน"], ["ป่ามะพร้าวลมทะเล", "ลูกมะพร้าวหล่นใส่หัวบ่อยมาก ระวังด้วย"]],
		"ruins": [["ซากเรืออับปาง", "ซากเรือเก่าใต้ท้องทะเลตื้น หุ่นดูดฝุ่นกันน้ำยึดไว้"], ["ป้อมปืนใหญ่ริมทะเล", "ป้อมเก่าที่ยิงลูกไหมพรมแทนลูกปืน"]],
		"tower": [["ประภาคารผีสิง", "ประภาคารร้างที่ไฟกระพริบเอง ขวดสเปรย์ลอยวนรอบยอด"], ["หอคอยปะการัง", "หอคอยที่ปะการังขึ้นเต็ม หนูเงาว่ายน้ำได้ด้วย"]],
		"arena": [["ลานประลองบนดาดฟ้าเรือ", "สู้กันบนเรือที่โคลงไปมา อย่าเมาเรือล่ะ"], ["สนามแข่งพายเรือ", "สนามแข่งเรือที่บอสคุมอยู่"]],
	},
	4: {
		"meadow": [["ทุ่งกระบองเพชรนุ่ม", "กระบองเพชรหนามนิ่มเหมือนขนแมว แต่ไหมพรมซ่อนอยู่เยอะ"], ["ทุ่งเนินทรายสีส้ม", "เนินทรายร้อนจัด เดินแล้วอุ้งเท้าพอง"]],
		"forest": [["ป่าปาล์มโอเอซิส", "ป่าปาล์มรอบบ่อน้ำ แตงกวาแห้งเหี่ยวแต่ยังสู้"], ["ป่าหินรูปแมว", "หินที่ลมกัดกร่อนจนเป็นรูปแมวนั่ง"]],
		"ruins": [["พีระมิดกล่องกระดาษ", "พีระมิดที่สร้างจากกล่องกระดาษนับล้านใบ หุ่นดูดฝุ่นเฝ้าทางเข้า"], ["เมืองโบราณใต้ทราย", "เมืองที่จมอยู่ใต้ทราย มีรูปแมวสลักทุกผนัง"]],
		"tower": [["หอคอยนาฬิกาแดด", "หอคอยที่เงาบอกเวลา ขวดสเปรย์ลอยตามเงา"], ["หอคอยพายุทราย", "พายุหมุนรอบหอคอยตลอดเวลา"]],
		"arena": [["ลานประลองดวงอาทิตย์", "ลานร้อนระอุใต้แสงแดด บอสใส่แว่นกันแดด"], ["สนามแข่งอูฐ", "สนามแข่งอูฐที่วุ่นวาย ฝุ่นตลบ"]],
	},
	5: {
		"meadow": [["ทุ่งหิมะปุยฝ้าย", "ทุ่งหิมะนุ่มๆ ไหมพรมกลายเป็นก้อนหิมะกลิ้ง"], ["ทุ่งน้ำแข็งลื่นปรื๊ด", "พื้นน้ำแข็งลื่นมาก ระวังไถลหกล้ม"]],
		"forest": [["ป่าสนน้ำแข็ง", "ป่าสนที่ใบเป็นน้ำแข็งใส แตงกวาแช่แข็งยังขยับได้"], ["ป่าเบิร์ชสีขาว", "ต้นไม้สีขาวเหมือนหนวดแมว เงียบสงบจนน่ากลัว"]],
		"ruins": [["ปราสาทน้ำแข็งพัง", "ปราสาทน้ำแข็งที่ละลายไปครึ่งหนึ่ง หุ่นดูดฝุ่นดูดหิมะอยู่"], ["หมู่บ้านอิกลูร้าง", "อิกลูว่างเปล่าที่มอนย้ายเข้าไปอยู่"]],
		"tower": [["หอคอยแสงเหนือ", "หอคอยที่แสงเหนือส่องผ่าน ขวดสเปรย์แข็งเป็นน้ำแข็ง"], ["หอคอยระฆังหิมะ", "เสียงระฆังทำให้หิมะถล่มเบาๆ"]],
		"arena": [["ลานสเก็ตประลอง", "ลานน้ำแข็งกว้าง สู้ไปไถลไป"], ["สนามปาหิมะยักษ์", "สนามปาหิมะที่บอสปาแรงที่สุด"]],
	},
	6: {
		"meadow": [["ทุ่งหญ้าเถ้าถ่าน", "ทุ่งหญ้าสีเทาจากเถ้าภูเขาไฟ ไหมพรมสีดำเด้งไปมา"], ["ทุ่งดอกไม้ไฟ", "ดอกไม้ที่บานเป็นประกายไฟ สวยแต่ร้อน"], ["ทุ่งหินลอยอุ่น", "หินภูเขาไฟเบาจนลอยได้ เหยียบดีๆ นะ"]],
		"forest": [["ป่าปาล์มเกาะร้อน", "ป่าปาล์มริมเกาะ แตงกวาตากแดดจนเกรียม"], ["ป่าต้นไม้ไหม้", "ต้นไม้ดำทะมึนแต่ยังมีใบเขียวอยู่ปลายกิ่ง"], ["ป่าเฟิร์นไอน้ำ", "ไอน้ำร้อนพวยพุ่ง มองไม่ค่อยเห็นทาง"]],
		"ruins": [["วิหารเทพไฟร้าง", "วิหารเก่าของเทพไฟแมว หุ่นดูดฝุ่นทนไฟยึดไว้"], ["เตาหลอมโบราณ", "เตาหลอมยักษ์ที่ยังร้อนอยู่แม้ไม่มีใครใช้"], ["หมู่บ้านใต้ลาวาเย็น", "หมู่บ้านที่ลาวาไหลผ่านแล้วแข็งตัว"]],
		"tower": [["หอคอยปล่องควัน", "หอคอยที่ควันพุ่งออกมาตลอด ขวดสเปรย์ไฟลอยวน"], ["หอคอยหินแก้ว", "หอคอยหินแก้วสีดำสะท้อนเงา"], ["หอคอยกลางปล่องภูเขาไฟ", "หอคอยที่ตั้งอยู่กลางปล่อง ร้อนที่สุดบนเกาะ"]],
		"arena": [["ลานประลองขอบปล่อง", "ลานบนขอบปล่องภูเขาไฟ ลาวาเดือดอยู่ข้างล่าง"], ["สนามกลองไฟ", "บอสสู้ตามจังหวะกลอง"], ["ลานเทพไฟแมว", "ลานสุดท้ายของเกาะ เทพไฟแมวจับตาดูอยู่"]],
	},
	7: {
		"meadow": [["สวนกุหลาบสีม่วง", "สวนในปราสาทที่กุหลาบสีม่วงบานตอนกลางคืน"], ["ทุ่งหญ้าใต้แสงจันทร์", "ทุ่งหญ้าที่เปล่งแสงจางๆ ใต้แสงจันทร์"], ["สวนเขาวงกตเงา", "เขาวงกตพุ่มไม้ เดินแล้ววนกลับที่เดิม"]],
		"forest": [["ป่าต้นไม้เงา", "ป่าที่ต้นไม้ขยับได้เมื่อไม่มีใครมอง"], ["ป่าเห็ดเรืองแสง", "เห็ดเรืองแสงสีฟ้านำทางในความมืด"], ["ป่าค้างคาวหลับ", "ค้างคาวห้อยหัวเต็มป่า อย่าส่งเสียงดัง"]],
		"ruins": [["คุกใต้ปราสาท", "คุกเก่าใต้ดิน หุ่นดูดฝุ่นคุมกุญแจไว้"], ["ห้องเก็บสมบัติร้าง", "ห้องที่เคยเต็มไปด้วยไหมพรมทองคำ"], ["หอสมุดต้องห้าม", "หนังสือบินได้ ระวังโดนหนังสือหนาตบหน้า"]],
		"tower": [["หอคอยนาฬิกาเงา", "นาฬิกาที่เดินถอยหลัง ขวดสเปรย์เงาลอยวน"], ["หอดูดาวต้องคำสาป", "กล้องดูดาวที่มองเห็นแต่ดาวรูปหนู"], ["หอคอยราชินีเงา", "หอคอยสูงที่สุดของปราสาท ใกล้ดวงจันทร์ที่สุด"]],
		"arena": [["ห้องบัลลังก์รัตติกาล", "ห้องบัลลังก์ที่บอสนั่งรออยู่"], ["ลานเต้นรำเงา", "ลานเต้นรำที่เงาเต้นเองได้"], ["ลานประลองจันทร์เต็มดวง", "ลานบนหลังคาใต้จันทร์เต็มดวง"]],
	},
	8: {
		"meadow": [["ทุ่งเมฆปุยฝ้าย", "ทุ่งเมฆนุ่มๆ ไหมพรมสีทองเด้งไปมา"], ["ทุ่งดอกไม้สายรุ้ง", "ดอกไม้ทุกสีของสายรุ้งบานเต็มทุ่ง"], ["ทุ่งดาวตกนุ่มนิ่ม", "ดาวตกนุ่มๆ ตกลงมาเหมือนหมอน"]],
		"forest": [["ป่าต้นไม้ทองคำ", "ใบไม้ทองคำส่องแสงระยิบ แตงกวาทองคำก็มี"], ["ป่าขนนกสวรรค์", "ต้นไม้ที่ใบเป็นขนนกนุ่ม"], ["ป่าเมฆหมอกทอง", "หมอกสีทองหนาจนเหมือนอยู่ในน้ำผึ้ง"]],
		"ruins": [["วิหารเมฆพังทลาย", "วิหารเก่าบนเมฆที่ถูกหุ่นดูดฝุ่นดูดเมฆไปครึ่งหนึ่ง"], ["สะพานสายรุ้งขาด", "สะพานสายรุ้งที่ขาดเป็นท่อนๆ ต้องกระโดดข้าม"], ["ห้องสมุดแห่งแสง", "หนังสือที่อ่านแล้วตัวหนังสือลอยออกมา"]],
		"tower": [["หอคอยระฆังทอง", "หอคอยที่ระฆังทองดังทุกชั่วโมงแมว"], ["หอคอยดวงดาว", "หอคอยที่ยอดแตะดวงดาว"], ["หอคอยแห่งตำนาน", "หอคอยสุดท้ายก่อนถึงจุดสูงสุดของโลก"]],
		"arena": [["ลานประลองเทพแมว", "ลานประลองที่เทพแมวมาดู"], ["สนามแข่งเมฆบิน", "สนามแข่งขี่เมฆที่เร็วที่สุด"], ["ลานบัลลังก์แมวทอง", "ลานสุดท้ายของเกม ผู้ชนะจะกลายเป็นตำนาน"]],
	},
}

## ดันเจี้ยนของเมืองถัดไป สร้างจากแบบ ฉาก บอส สลับกันไปเรื่อยๆ
static func _made(town: int, index: int) -> Dictionary:
	var n := dungeon_count(town)
	var theme: String = THEMES[(index + town) % THEMES.size()]
	var word: String = TOWN_WORDS[town % TOWN_WORDS.size()]
	var name := "%s%s" % [THEME_WORDS[theme], word]
	if index >= THEMES.size():
		name += " ชั้นลึก"
	var text := "ดันเจี้ยนรอบ%s" % town_name(town)
	# ชื่อที่เขียนไว้ของเมืองนี้ ฉากนี้ ลำดับที่เท่าไหร่ของฉากนี้
	var named: Array = (MADE_NAMES.get(town, {}) as Dictionary).get(theme, [])
	var nth := 0
	for k in index:
		if THEMES[(k + town) % THEMES.size()] == theme:
			nth += 1
	if nth < named.size():
		name = str(named[nth][0])
		text = str(named[nth][1])
	var x := 0.08 + 0.84 * float(index) / float(maxi(n - 1, 1))
	var y := 0.3 if index % 2 == 0 else 0.66
	# ฉากที่วาดจริง: รายการฉากของเมืองตามลำดับดัน (ไม่ซ้ำกันในเมือง)
	var look := DungeonLook.for_dungeon(town, index, theme)
	var ex := DungeonLook.extra_for(town, look)
	if not ex.is_empty():
		name = str(ex[1])
		text = str(ex[2])
	elif look != DungeonLook.for_town(town, theme) or nth >= named.size():
		name = "%s%s" % [THEME_WORDS.get(look, THEME_WORDS[theme]), word]
		text = str(DungeonLookMore.BLURB.get(look, "ดันเจี้ยนรอบ%s" % town_name(town)))
	return {"name": name, "icon": look, "theme": look, "base": theme, "map": Vector2(x, y + 0.04 * sin(float(index) * 1.7)),
		"text": text,
		"boss": BOSSES[(index + town) % BOSSES.size()]}

## ห้องของดันเจี้ยน แบบเกมแอ็กชันเลื่อนข้าง: ห้องวอร์มอัพ ห้องต่อสู้หลัก ห้องกับดัก ห้องมินิบอส ห้องบอส
## แต่ละห้อง {type, waves: [[[บทบาท, หน้าตา, x, แท่นที่ยืน -1 คือพื้น] ...] ...], platforms: [[x ซ้าย, x ขวา, สูง] ...], spikes: [x ...], mid, boss}
## มอนระลอกสองตกลงมาจากฟ้าเมื่อระลอกแรกหมด  ยิ่งดันลึก มอนยิ่งเยอะ
const FODDER := ["cat_mochi", "cat_mochi", "cat_mochi", "cat_ghost", "cat_mochi"]
const MID := ["cat_mochi", "cat_long", "cat_box", "cat_ghost", "cat_puff"]

## ห้องยาวมาก (ราว 2 เท่าครึ่งของเดิม) มอนกระจายห่างๆ ไม่ลายตา เมืองแรกมอนน้อยสุด
static func room_half(town: int) -> float:
	return 110.0 if town == 0 else 100.0

static func _density(town: int) -> float:
	return 0.6 if town == 0 else 0.85

## จำนวนตัวหลังคูณความหนาแน่น อย่างน้อย 1
static func _n(base: int, town: int) -> int:
	return maxi(1, int(round(float(base) * _density(town))))

## วางมอนบนพื้นห่างเท่าๆ กันตลอดช่วง x0..x1 (ตัวบนแท่นไม่ขยับ)
static func _spread(list: Array, x0: float, x1: float) -> Array:
	var ground := []
	for e in list:
		if int(e[3]) < 0:
			ground.append(e)
	var n := ground.size()
	for i in n:
		var t := (float(i) + 0.5) / float(maxi(n, 1))
		ground[i][2] = lerpf(x0, x1, t)
	return list

## จำนวนชั้นแท่นเหนือพื้น เมืองแรก 2 (รวมพื้นเป็น 3 ชั้น) เมือง 2-4 มี 3 ชั้น เมืองหลังจากนั้น 4 ชั้น (รวม 5)
static func tiers(town: int) -> int:
	return 2 if town == 0 else (3 if town <= 3 else 4)

const TIER_STEP := 1.625     # แต่ละชั้นสูงกว่าชั้นล่างเท่านี้ กระโดดถึง (ค่าลงตัวฐานสอง ไม่เพี้ยนตอนเก็บใน Vector2)
const TIER_BASE := 1.75
const CLUSTER_GAP := 24.0     # กลุ่มแท่นแบบบันไดห่างกันเท่านี้

## แท่นลอยแบบบันไดหลายชั้นกระจายทั้งห้อง กระโดดไต่ขึ้นได้ทีละชั้น บางกลุ่มมีสะพานยาวชั้นสอง
## [x ซ้าย, x ขวา, สูง]  ชั้นบนเหลื่อมกับชั้นล่างนิดหน่อย ยืนปลายแท่นแล้วกระโดดขึ้นได้
static func _plats(h: float, n_tiers := 2) -> Array:
	var out := []
	var x := -h + 12.0
	var k := 0
	while x < h - 14.0:
		var dir := 1.0 if k % 2 == 0 else -1.0
		var top := n_tiers if k % 3 != 2 else maxi(1, n_tiers - 1)
		for t in top:
			var w := 5.0 - float(t) * 0.35
			var o := float(t) * 3.6
			var x0 := x + o if dir > 0.0 else x + 3.6 * float(n_tiers - 1) - o
			out.append([x0, x0 + w, TIER_BASE + float(t) * TIER_STEP])
		# สะพานยาวชั้นสองไปหากลุ่มถัดไป
		if n_tiers >= 2 and k % 2 == 1 and x + CLUSTER_GAP < h - 14.0:
			out.append([x + 9.0, x + 19.0, TIER_BASE + TIER_STEP])
		x += CLUSTER_GAP
		k += 1
	return out

## แท่นชั้นบน (ไม่ใช่ชั้นล่างสุด) เรียงตาม x ใช้วางมอนบนชั้นสูง
static func _upper(plats: Array) -> Array:
	var out := []
	for i in plats.size():
		if float(plats[i][2]) > TIER_BASE + 0.5:
			out.append(i)
	out.sort_custom(func(a, b) -> bool: return float(plats[a][0]) < float(plats[b][0]))
	return out

## เลือกแท่นชั้นบน n อันกระจายทั่วห้อง
static func _pick_upper(plats: Array, n: int, salt := 0) -> Array:
	var up := _upper(plats)
	var out := []
	if up.is_empty() or n <= 0:
		return out
	for i in n:
		var k := clampi(int(floor((float(i) + 0.5 + float(salt) * 0.37) / float(n) * float(up.size()))), 0, up.size() - 1)
		out.append(up[k])
	return out

static func rooms(town: int, index: int) -> Array:
	var d := dungeon(town, index)
	if d.is_empty():
		return []
	var fod: String = FODDER[(index + town) % FODDER.size()]
	var more := mini(index, 6)  # ดันลึกเพิ่มมอน
	var h := room_half(town)
	var nt := tiers(town)
	var plats := _plats(h, nt)
	var up_n := 2 + mini(town, 3)   # มอนบนชั้นสูงต่อระลอก
	var out := []
	# ห้อง 1 วอร์มอัพ ตัวเล็กเลือดน้อย กระจายทั้งห้อง มีบนแท่นบ้าง
	var w1 := []
	for i in _n(9 + more, town):
		w1.append(["hopper", fod, 0.0, -1])
	for p in _pick_upper(plats, up_n, 0):
		w1.append(["hopper", fod, 0.0, p])
	out.append({"type": "warm", "half": h, "waves": [_spread(w1, -h + 14.0, h - 8.0)], "platforms": plats, "spikes": []})
	# ห้อง 2 ต่อสู้หลัก แทงค์ ซัพพอร์ต ตัวยิงบนแท่นสูง ระลอกสองตัวพุ่งชน
	var core_up := _pick_upper(plats, up_n + 1, 1)
	var a1 := [["tank", "cat_box", 0.0, -1], ["support", "cat_long", 0.0, -1], ["tank", "cat_box", 0.0, -1]]
	if town > 0:
		a1.append(["tank", "cat_box", 0.0, -1])
	for i in _n(6 + more, town):
		a1.append(["hopper", fod, 0.0, -1])
	for i in core_up.size():
		a1.append(["ranged" if i % 2 == 0 else "hopper", "cat_cyclops" if i % 2 == 0 else fod, 0.0, core_up[i]])
	var a2 := [["rusher", "cat_puff", 0.0, -1], ["rusher", "cat_puff", 0.0, -1], ["rusher", "cat_puff", 0.0, -1]]
	for i in _n(5 + more, town):
		a2.append(["hopper", fod, 0.0, -1])
	out.append({"type": "core", "half": h, "waves": [_spread(a1, -h + 14.0, h - 8.0), _spread(a2, -h + 22.0, h - 6.0)], "platforms": plats, "spikes": []})
	# ห้อง 3 กับดักหนาม ต้องหลบไปพร้อมสู้ หนามกระจายตามห้อง ตัวยิงผีบนแท่นสูง
	var t1 := [["tank", "cat_box", 0.0, -1], ["tank", "cat_box", 0.0, -1]]
	for p in _pick_upper(plats, up_n, 2):
		t1.append(["ranged", "cat_ghost", 0.0, p])
	for i in _n(6 + more, town):
		t1.append(["hopper", fod, 0.0, -1])
	var t2 := [["rusher", "cat_puff", 0.0, -1], ["support", "cat_long", 0.0, -1], ["rusher", "cat_puff", 0.0, -1]]
	for i in _n(4 + more, town):
		t2.append(["hopper", fod, 0.0, -1])
	var spikes := []
	var sx := -h + 18.0
	while sx < h - 10.0:
		spikes.append(sx)
		sx += 22.0
	out.append({"type": "trap", "half": h, "waves": [_spread(t1, -h + 14.0, h - 8.0), _spread(t2, -h + 22.0, h - 6.0)], "platforms": plats, "spikes": spikes})
	# ห้อง 4 มินิบอส ลานยาวครึ่งหนึ่ง เลือดเยอะ เกราะหนา มีลูกน้องกระจาย แท่นบันไดไว้หลบ
	var mh := h * 0.5
	var mplats := _plats(mh, mini(nt, 3))
	var m1 := [["midboss", MID[(index + town) % MID.size()], 8.0, -1]]
	for i in _n(4 + more, town):
		m1.append(["hopper", fod, -mh + 10.0 + float(i) * 9.0, -1])
	for p in _pick_upper(mplats, 2, 3):
		m1.append(["hopper", fod, 0.0, p])
	out.append({"type": "mid", "half": mh, "waves": [m1], "platforms": mplats, "spikes": []})
	# ห้อง 5 บอส ลานกว้าง ไม่มีลูกน้อง มีแท่นไว้หลบท่าใหญ่ทั้งลาน
	var boss_look := str(d.get("boss", "boss_club"))
	if not raid(town, index).is_empty():
		# บอสยักษ์แบบรุม ยืนนิ่งชิดขวาหรือกลางลาน แท่นสองข้างไว้หลบของตกกับแขนกวาด
		out.append({"type": "boss", "raid": true, "waves": [[["boss_raid", boss_look, 12.0, -1]]], "platforms": [[-14.0, -10.0, 1.8], [-4.0, 0.0, 1.8]], "spikes": []})
		return out
	out.append({"type": "boss", "waves": [[[boss_look, boss_look, 6.0, -1]]], "platforms": [[-13.0, -9.0, 1.8], [9.0, 13.0, 1.8], [-2.0, 2.0, 3.5]], "spikes": []})
	return out

## บอสยักษ์แบบรุม: ดันสุดท้ายของเมืองตั้งแต่เมือง 3 (town 2) และดันเลขคี่ของเมืองโหด (town 4 ขึ้นไป)
## คืน {} ถ้าเป็นบอสปกติ  ยิ่งเมืองโหด เลือดยิ่งเยอะ เฟสยิ่งมาก ตีแรงขึ้น เร็วขึ้น
static func raid(town: int, index: int) -> Dictionary:
	var last := index == dungeon_count(town) - 1
	if not ((town >= 2 and last) or (town >= 4 and index % 2 == 1)):
		return {}
	var phases := 2 + (1 if town >= 5 else 0) + (1 if town >= 7 else 0)
	if last and town >= 3:
		phases = mini(phases + 1, 4)
	return {
		"anchor": "center" if town >= 7 and last else "right",
		"phases": phases,
		"hp_mult": 3.0 + float(town) * 0.5 + (1.0 if last else 0.0),
		"giant": minf(2.3 + float(town) * 0.08, 2.8),
		"dmg_k": 1.0 + float(town) * 0.12,
		"speed_k": 1.0 + float(town) * 0.06,
	}

## จำนวนห้องทั้งหมดรวมห้องบอส
static func stage_count(town: int, index: int) -> int:
	return rooms(town, index).size()

## มอนทั้งหมดของห้อง (ทุกระลอก)
static func stage_monsters(town: int, index: int, stage: int) -> Array:
	var list := rooms(town, index)
	var out := []
	if stage < 0 or stage >= list.size():
		return out
	for wave in list[stage]["waves"]:
		for m in wave:
			out.append(m[1])
	return out

## เมืองแรกๆ ง่ายขึ้นสำหรับผู้เล่นใหม่: เลือดมอน (เมือง 1 −40% เมือง 2 −25% เมือง 3 −8% จากนั้นเท่าเดิม)
const EARLY_HP := [0.6, 0.75, 0.92]
const EARLY_DMG := [0.7, 0.85, 0.95]
const EARLY_BOSS_SLOW := [1.35, 1.2, 1.05]

static func early_hp(town: int) -> float:
	return EARLY_HP[town] if town >= 0 and town < EARLY_HP.size() else 1.0

static func early_dmg(town: int) -> float:
	return EARLY_DMG[town] if town >= 0 and town < EARLY_DMG.size() else 1.0

static func early_boss_slow(town: int) -> float:
	return EARLY_BOSS_SLOW[town] if town >= 0 and town < EARLY_BOSS_SLOW.size() else 1.0

## ดันเจี้ยนยิ่งลึกมอนยิ่งอึด
static func hp_scale(town: int, index: int) -> float:
	return LevelData.power(dungeon_level(town, index)) * (1.0 + 0.08 * float(index)) * early_hp(town)
