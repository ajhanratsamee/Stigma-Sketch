class_name SkillData
extends RefCounted
## ผังสกิลของแต่ละสาย เลขสกิลคือ เลเวล.ช่อง เช่น 5.1 คือเลเวล 5 ช่อง 1
## run บอกวิธีออกท่า roll buff blink mana_buff move hold ออกทันที ที่เหลือเป็นท่าหยุดเวลา
## cast = เรียกฟังก์ชันใน Hero ตามชื่อ method  cd = คูลดาวน์ของสกิลนี้ วินาที
## mp = มานาที่ใช้ตอนกด  mp_hold = ท่ากดค้าง มานาลดเรื่อยๆ ตามค่า mp_drain ในท่า
## สายต่อยอดได้สกิลของสายก่อนหน้าด้วย

const HERO_LEVEL := 70
const HYPER_ID := "hyper"
const HYPER_LV := 65

## ธาตุของสกิล ใช้กับเกจสามธาตุของ OMNI PRIME
const ELEMENTS := {
	"gwen_trio": ["fire"], "gwen_storm": ["fire"], "gwen_flame": ["fire"], "gwen_meteor": ["fire"],
	"hm_meteor": ["fire"], "op_cross": ["fire"],
	"hm_ice_flow": ["ice"], "hm_homing": ["ice"], "hm_shards": ["ice"], "op_ice": ["ice"],
	"hm_chain": ["elec"], "op_bolts": ["elec"],
	"op_triple": ["fire", "elec", "ice"],
}

const SKILLS := {
	"rogue_medic": [
		{"id": "rm_barrier", "lv": 15, "slot": 2, "name": "บาเรียพุ่ง", "run": "rm_barrier", "mp": 15.0,
			"desc": "พุ่งไปด้านหน้า กางบาเรียสีม่วง ติด SA"},
		{"id": "rm_saber", "lv": 15, "slot": 3, "name": "ดาบเซเบอร์", "run": "rm_saber", "mp": 22.0,
			"desc": "เวลาหยุด เรียกดาบเซเบอร์สี่เหลี่ยม ตัดด้านหน้าแบบไขว้ 2 ทีอย่างแรง"},
		{"id": "rm_mana", "lv": 15, "slot": 4, "name": "มานาถาวร", "passive": true,
			"desc": "เพิ่มมานาถาวร 100 หน่วย"},
		{"id": "rm_dna", "lv": 25, "slot": 1, "name": "สี่เหลี่ยม DNA", "run": "rm_dna", "mp": 20.0,
			"desc": "เวลาหยุด เสกสี่เหลี่ยม DNA ด้านหน้า ทำดาเมจ มอนชะงักต่อเนื่อง"},
		{"id": "rm_scan", "lv": 30, "slot": 1, "name": "สแกนตาราง", "run": "rm_scan", "mp": 35.0,
			"desc": "เวลาหยุด สแกนเป็นลายตารางเต็มจอ ดาเมจต่อเนื่อง"},
		{"id": "rm_vortex", "lv": 30, "slot": 2, "name": "วงหมุนดูด", "run": "rm_vortex", "mp": 25.0,
			"desc": "สร้างวงกลมตรงหน้า หมุนเกิดเส้นแนวนอน ดูดมอนมารอบๆ"},
		{"id": "rm_beam", "lv": 35, "slot": 1, "name": "ลำแสงสแกน", "run": "rm_beam", "mp": 30.0,
			"desc": "เวลาหยุด ยิงลำแสงสแกนระยะ 2 จอ มอนที่สแกนเจอโดนโดรนทดสอบเกาะ ดาเมจต่อ 5 วินาที"},
		{"id": "rm_heal", "lv": 35, "slot": 2, "name": "ขวดฟื้นฟู", "run": "rm_heal", "mp": 20.0, "cd": 20.0,
			"desc": "โดรนหิ้วขวดยาโยนใส่ตัวเอง เพิ่มเลือดและมานาวินาทีละ 80 หน่วย นาน 6 วินาที"},
		{"id": "rm_flask", "lv": 35, "slot": 3, "name": "ขวดทดลอง", "run": "rm_flask", "mp": 12.0,
			"desc": "โยนขวดทดลองลงพื้น มอนลอยสั้นๆ"},
		{"id": "rm_dna_gauge", "lv": 35, "slot": 4, "name": "จับรหัสพันธุกรรม", "passive": true,
			"desc": "ใช้สกิลของสายนี้ได้คะแนนสกิลละ 3 สะสมที่เกจ DNA กดปุ่ม V รับบัพตามขั้นและขั้นก่อนหน้า ขั้น 1 มานา ขั้น 2 ความเร็วเดิน ขั้น 3 พลังโจมตี ขั้น 4 สกิลแรง ขั้น 5 ความเร็วตี"},
		{"id": "rm_no_down", "lv": 40, "slot": 1, "name": "ล้มน้อย แรงขึ้น", "passive": true,
			"desc": "ลดอัตราการล้มของมอน และเพิ่มพลังโจมตี"},
		{"id": "rm_spin", "lv": 40, "slot": 2, "name": "โดรนหมุนดูด", "run": "rm_spin", "mp": 28.0,
			"desc": "เวลาไม่หยุด สร้างโดรนตรงหน้า หมุนแนวตั้งกับที่ ดูดมอนมาเรื่อยๆ แล้วระเบิด"},
		{"id": "rm_dome", "lv": 45, "slot": 1, "name": "อาณาเขตรหัส", "run": "rm_dome", "mp": 25.0,
			"desc": "เวลาหยุด สร้างอาณาเขตทรงกลม อยู่ในวงใช้มานาน้อยลง นาน 15 วินาที"},
		{"id": "rm_square", "lv": 45, "slot": 2, "name": "สนามสี่เหลี่ยม", "run": "rm_square", "mp": 30.0, "air_ok": true,
			"desc": "เวลาหยุด ใช้กลางอากาศได้ สนามสี่เหลี่ยมแผ่ออก 15 วินาที ทำดาเมจ อยู่ในสนามพลังโจมตีเพิ่ม มอนในสนามป้องกันลด"},
		{"id": "rm_needle", "lv": 50, "slot": 1, "name": "เข็มแทง", "run": "move", "mp": 15.0, "move": "NEEDLE_MOVE",
			"desc": "หยิบเข็มฉีดยาแทงไปข้างหน้า 4 ฮิต ติด SA"},
		{"id": "rm_cylinder", "lv": 50, "slot": 2, "name": "สแกนทรงกระบอก", "run": "rm_cylinder", "mp": 25.0,
			"desc": "เวลาหยุด สร้างพื้นที่สแกนทรงกระบอก ทำดาเมจ อยู่ในวงเคลื่อนที่เร็วขึ้น"},
		{"id": "rm_emp", "lv": 55, "slot": 1, "name": "คลื่นแม่เหล็ก", "run": "rm_emp", "mp": 35.0,
			"desc": "เวลาหยุด สร้างคลื่นแม่เหล็กไฟฟ้าทรงกลมด้านหน้า ชอตโดยรอบทั้งในและนอกวง"},
		{"id": "rm_body", "lv": 60, "slot": 1, "name": "ตีแรง ทนขึ้น", "passive": true,
			"desc": "เพิ่มความเสียหายการตีปกติ และเพิ่มพลังป้องกันถาวร"},
		{"id": "rm_dna_more", "lv": 60, "slot": 2, "name": "จับรหัสเร็ว", "passive": true,
			"desc": "เพิ่มคะแนนจับรหัสพันธุกรรมอีก 2 หน่วยต่อสกิล"},
	],
	"dimension_strike": [
		{"id": "ds_smoke", "lv": 15, "slot": 2, "name": "สาดควัน", "run": "ds_smoke", "mp": 12.0,
			"desc": "สาดควันฟุ้งเลียดไปตามพื้นด้านหน้า"},
		{"id": "ds_form", "lv": 15, "slot": 3, "name": "แปลงร่าง", "run": "ds_form", "mp": 25.0,
			"desc": "ลอยขึ้นนิดนึง เวลาหยุด แปลงร่าง มีปีกเล็กที่คทา บัพความเร็วการโจมตี พลังโจมตี และความเร็วเคลื่อนที่"},
		{"id": "ds_basic", "lv": 15, "slot": 4, "name": "ตีปกติแรง", "passive": true,
			"desc": "การตีปกติแรงขึ้น"},
		{"id": "ds_power", "lv": 25, "slot": 1, "name": "เสริมพลัง", "run": "atk_buff", "mp": 15.0,
			"desc": "บัพเสริมพลังโจมตีให้ตัวเอง"},
		{"id": "ds_stomp", "lv": 30, "slot": 1, "name": "กระทืบ", "run": "ds_stomp", "air_only": true, "mp": 25.0,
			"desc": "ใช้ได้กลางอากาศ เวลาหยุด กระทืบลงพื้นอย่างรุนแรง ดาเมจโดยรอบที่พื้น มอนสตั๊น"},
		{"id": "ds_pull", "lv": 30, "slot": 2, "name": "ดูดรวมระเบิด", "run": "ds_pull", "mp": 40.0,
			"desc": "เวลาหยุดตอนดูด ยื่นไม้เท้า ดูดมอนทุกตัวในระยะ 1 จอครึ่งมารวม แล้วระเบิดวงกว้าง"},
		{"id": "ds_drain", "lv": 35, "slot": 1, "name": "ดูดมานา", "run": "ds_drain",
			"desc": "ยื่นมือด้านหน้า ดูดมานาจากมอนในระยะครึ่งจอ ได้ตัวละ 4"},
		{"id": "ds_orb", "lv": 35, "slot": 2, "name": "ลูกบอลมิติ", "run": "ds_orb", "mp": 35.0,
			"desc": "เวลาหยุดตอนปล่อย ลูกบอลมิติลอยไปด้านหน้าเรื่อยๆ ดูดรอบตัวเข้ามาต่อเนื่อง"},
		{"id": "ds_gather", "lv": 35, "slot": 3, "name": "แสงรวม", "run": "ds_gather", "air_only": true, "mp": 35.0,
			"desc": "ใช้ได้กลางอากาศเท่านั้น เวลาหยุด แสงชมพูจากทุกทิศมารวมที่ตัว แล้วแผ่มือระเบิดรอบตัววงกว้าง"},
		{"id": "ds_no_down", "lv": 35, "slot": 4, "name": "ล้มน้อยลง", "passive": true,
			"desc": "เมื่อโจมตี อัตราการล้มของมอนลดลง"},
		{"id": "ds_leap", "lv": 40, "slot": 1, "name": "กระโดดทุบ", "run": "ds_leap", "mp": 20.0,
			"desc": "เวลาไม่หยุด กระโดดไปข้างหน้า เอาคทาทุบพื้น มอนสตั๊น"},
		{"id": "ds_split", "lv": 45, "slot": 1, "name": "ลูกบอลแตกตัว", "run": "ds_split", "mp": 45.0,
			"desc": "เวลาไม่หยุด โยนลูกบอลมิติเล็กขึ้นฟ้า ขยายครึ่งจอ ตกแล้วแตกเป็นลูกเล็กลงทวีคูณจนหมด"},
		{"id": "ds_thrust", "lv": 45, "slot": 2, "name": "แทงมิติ", "run": "ds_thrust", "mp": 25.0,
			"desc": "รวมพลังมิติที่ปลายคทา พุ่งแทงไปด้านหน้า ดูดมอนใกล้ๆ มารวม"},
		{"id": "ds_guard", "lv": 50, "slot": 1, "name": "รับเบาลง", "run": "cast", "method": "start_ds_guard", "mp": 15.0,
			"desc": "บัพให้ตัวเองรับการโจมตีเบาลง"},
		{"id": "ds_slam", "lv": 55, "slot": 1, "name": "ทุบหน้า", "run": "ds_slam", "mp": 25.0,
			"desc": "เอาคทาทุบพื้นด้านหน้า มอนสตั๊น"},
		{"id": "ds_mana_speed", "lv": 60, "slot": 1, "name": "มานาเร่งฝีเท้า", "passive": true,
			"desc": "ยิ่งมีมานาเก็บไว้มาก ความเร็วเคลื่อนที่ยิ่งเพิ่มขึ้น"},
		{"id": "ds_blink_cheap", "lv": 60, "slot": 2, "name": "วาปประหยัด", "passive": true,
			"desc": "ลดการเสียมานาเมื่อใช้สกิล 1.1"},
	],
	"twin_node": [
		{"id": "tw_cannon", "lv": 35, "slot": 2, "name": "โดรนกระบอก", "run": "tw_cannon", "mp": 25.0, "cd": 6.0, "summon": true,
			"desc": "เวลาหยุดตอนใช้ ติดตั้งโดรนกระบอกด้านหน้า ยิงเส้นพลาสม่าชมพูต่อเนื่อง มอนชะงัก"},
		{"id": "tw_ufo", "lv": 35, "slot": 3, "name": "จานบิน", "run": "tw_ufo", "mp": 30.0, "cd": 8.0, "summon": true,
			"desc": "เวลาหยุด ยกมือสองข้าง จานบินสองลำโผล่แล้วปาออกไป ทะลุมอนทั้งแมพ ไม่สนความกว้างจอ นาน 5 วินาที"},
		{"id": "tw_cheap", "lv": 35, "slot": 4, "name": "โดรนประหยัด", "passive": true,
			"desc": "สกิลเรียกโดรนใช้มานาน้อยลง และคูลดาวน์สั้นลง"},
		{"id": "tw_mine", "lv": 40, "slot": 2, "name": "โดรนกับระเบิด", "run": "tw_mine", "mp": 20.0, "cd": 4.0, "summon": true,
			"desc": "เวลาหยุดตอนติดตั้ง เสกโดรนบนพื้นด้านหน้าแบบกว้าง มอนเหยียบแล้วระเบิดเป็นทรงกระบอก มอนลอย"},
		{"id": "tw_sky", "lv": 45, "slot": 1, "name": "เลเซอร์จากฟ้า", "run": "tw_sky", "mp": 35.0, "cd": 14.0, "summon": true,
			"desc": "ติดตั้งโดรนตั้งพื้น 2 อัน สุ่มส่งเลเซอร์จากฟ้าลงหัวมอนต่อเนื่อง 10 วินาที"},
		{"id": "tw_cup", "lv": 45, "slot": 2, "name": "โดรนถ้วย", "run": "tw_cup", "mp": 25.0, "summon": true,
			"desc": "ติดตั้งโดรนถ้วยลอยตามหลัง กดอีกครั้งเวลาหยุด ยิงเลเซอร์ติดตามอย่างรุนแรงใส่มอนรอบตัว"},
		{"id": "tw_bomb", "lv": 50, "slot": 1, "name": "ระเบิดเวลา", "run": "tw_bomb", "mp": 20.0,
			"desc": "ปาระเบิดเวลาออกไป ค้างตรงนั้น 5 วินาทีแล้วระเบิด มอนลอย"},
		{"id": "tw_bowl", "lv": 50, "slot": 2, "name": "โดรนแช่แข็ง", "run": "tw_bowl", "mp": 35.0, "cd": 12.0, "summon": true,
			"desc": "เวลาหยุด ติดตั้งโดรนมีขาตั้งขนาดใหญ่ด้านหน้า ปล่อยคลื่นวงกลมฟ้า แช่แข็งมอนรอบๆ"},
		{"id": "tw_tripod", "lv": 55, "slot": 1, "name": "โดรนสามขา", "run": "tw_tripod", "mp": 25.0, "summon": true,
			"desc": "ติดตั้งโดรนสามขาลอยตามหลัง กดอีกครั้งเวลาหยุด ยิงเลเซอร์ติดตามเบาๆ ใส่มอนใกล้เคียงต่อเนื่อง 4 วินาที"},
		{"id": "tw_power", "lv": 60, "slot": 1, "name": "โดรนแรงขึ้น", "passive": true,
			"desc": "เพิ่มความแรงการโจมตีของโดรน"},
		{"id": "tw_hit_mana", "lv": 60, "slot": 2, "name": "ตีได้มานา", "passive": true,
			"desc": "เมื่อโจมตี มีโอกาส 33% ได้มานาเพิ่ม 10 ต่อหนึ่งท่า"},
	],
	"omni_prime": [
		{"id": "op_cross", "lv": 35, "slot": 2, "name": "ลูกไฟไขว้", "run": "op_cross", "mp": 30.0,
			"desc": "เวลาหยุด เสกลูกบอลไฟใหญ่สองลูกด้านหลัง พุ่งไปด้านหน้าแบบไขว้"},
		{"id": "op_ice", "lv": 35, "slot": 3, "name": "ลูกน้ำแข็งตก", "run": "op_ice", "mp": 30.0,
			"desc": "เวลาหยุด เรียกลูกบอลน้ำแข็งสองลูกจากฟ้า กระทบพื้นแล้วแตก น้ำแข็งกระจายตามพื้นต่อเนื่อง"},
		{"id": "op_mana", "lv": 35, "slot": 4, "name": "มานาเพิ่ม", "passive": true,
			"desc": "มานาสูงสุดเพิ่ม 100 สกิลธาตุไฟ น้ำแข็ง ไฟฟ้า ฟื้นมานานิดนึง"},
		{"id": "op_wind", "lv": 40, "slot": 2, "name": "พายุพัด", "run": "op_wind", "mp": 35.0,
			"desc": "เวลาหยุด เรียกพายุใหญ่ครึ่งจอมาตรงหน้า พัดไปด้านหน้าระยะ 1 จอ"},
		{"id": "op_bolts", "lv": 40, "slot": 3, "name": "สายฟ้าสุ่ม", "run": "op_bolts", "mp": 30.0,
			"desc": "เวลาหยุด ลอยขึ้นเรียกสายฟ้าฟาดลงแบบสุ่มในช่วงครึ่งจอ กดค้างปล่อยต่อได้ สูบมานา"},
		{"id": "op_speed", "lv": 50, "slot": 1, "name": "เคลื่อนไว", "run": "cast", "method": "start_haste", "mp": 15.0,
			"desc": "บัพตัวเองให้เคลื่อนที่ไวขึ้น"},
		{"id": "op_triple", "lv": 55, "slot": 1, "name": "สามธาตุทะลุ", "run": "op_triple", "mp": 35.0,
			"desc": "เวลาหยุด ยิงลูกบอลไฟ ตามด้วยไฟฟ้า และน้ำแข็ง ทะลุมอน มอนชะงัก"},
		{"id": "op_cd", "lv": 60, "slot": 1, "name": "ลดคูลดาวน์", "passive": true,
			"desc": "ลดระยะเวลาคูลดาวน์ของสกิลทั้งหมด"},
		{"id": "op_gauge", "lv": 60, "slot": 2, "name": "เกจสามธาตุ", "passive": true,
			"desc": "เกจวงกลมไฟ ไฟฟ้า น้ำแข็ง ใช้สกิลธาตุนั้นแล้วเพิ่ม เต็ม 100% แล้วใช้สกิลใดก็ตามจะปล่อยสกิลธาตุนั้นฟรี ไม่เสียมานา ไม่ติดคูลดาวน์"},
	],
	"lord_essence": [
		{"id": "le_homun", "lv": 35, "slot": 2, "name": "โฮมุนครุส", "run": "cast", "method": "start_homun", "mp": 40.0,
			"desc": "เรียกโฮมุนครุสตัวเล็กลอยตาม 1 นาที ทุกการใช้สกิลสะสมเกจ 4% เต็ม 100 แล้วกดปุ่ม V ยิงลูกบอลดำใหญ่เกือบเต็มจอ 1 ฮิต เวลาหยุด"},
		{"id": "le_bottles", "lv": 35, "slot": 3, "name": "ขวดยา 3 ทาง", "run": "move", "mp": 18.0, "move": "BOTTLES_MOVE",
			"desc": "โยนขวดยา 3 ขวดไปซ้าย ขวา และที่เท้า เกิดควันฟุ้ง ทำดาเมจเล็กๆ"},
		{"id": "le_balls", "lv": 45, "slot": 1, "name": "ลูกบอล 3 ลูก", "run": "le_balls", "mp": 35.0,
			"desc": "เวลาหยุด ปล่อยลูกบอลใหญ่กว้าง 3 ลูกไปด้านหน้า ระยะ 1 จอ ดาเมจต่อเนื่อง"},
		{"id": "le_crack", "lv": 45, "slot": 2, "name": "รอยแตกแร่", "run": "le_crack", "mp": 30.0,
			"desc": "เวลาหยุด คทาทุบด้านหน้า รอยแตกเป็นเส้นๆ วิ่งไป 1 จอครึ่ง ยิ่งไกลรอยยิ่งใหญ่ขึ้น ฮิตสุดท้ายแตกทั้งหมด"},
		{"id": "le_coat", "lv": 50, "slot": 1, "name": "เคลือบพิษ", "run": "cast", "method": "start_poison_coat", "mp": 15.0,
			"desc": "บัพตัวเองให้เคลือบพิษ ตีแล้วมอนติดพิษ"},
		{"id": "le_ring", "lv": 55, "slot": 1, "name": "ควันหมุน", "run": "le_ring", "mp": 30.0,
			"desc": "เวลาหยุด โยนขวดลงพื้น ควันแนวนอนมาหมุนรอบตัวเป็นเส้นๆ ดาเมจต่อเนื่อง"},
		{"id": "le_mana", "lv": 35, "slot": 4, "name": "มานาเพิ่ม", "passive": true,
			"desc": "มานาสูงสุดเพิ่ม 100 หน่วย"},
		{"id": "le_cost", "lv": 60, "slot": 1, "name": "ขวดลดมานา", "passive": true,
			"desc": "สกิล 40.1 ขวดฟองสบู่ ได้ขวดเพิ่มอีก 1 แบบ ลดการใช้มานา"},
		{"id": "le_v_half", "lv": 60, "slot": 2, "name": "ปุ่ม V ประหยัด", "passive": true,
			"desc": "ปุ่ม V ใช้เกจโฮมุนครุสเพียง 50"},
	],
	"blade_weaver": [
		{"id": "wv_phoenix", "lv": 35, "slot": 2, "name": "นกฟินิกซ์", "run": "wv_phoenix", "mp": 45.0,
			"desc": "เวลาหยุด เรียกนกฟินิกซ์ขนาดใหญ่ ปีกกว้างมาก พุ่งไปด้านหน้า ระยะ 2 จอครึ่ง"},
		{"id": "wv_ball", "lv": 35, "slot": 3, "name": "ลูกไฟค้าง", "run": "wv_ball", "mp": 15.0,
			"desc": "เสกลูกบอลไฟค้างไว้ตรงหน้า มอนกระทบแล้วชะงัก ตัวที่เคยโดนลูกเดิมแล้วจะไม่ชะงักอีก"},
		{"id": "wv_elements", "lv": 35, "slot": 4, "name": "ธาตุเพิ่ม", "passive": true,
			"desc": "สกิลเคลือบดาบสุ่มได้เพิ่ม ธาตุน้ำ ไฟฟ้า หรือลม"},
		{"id": "wv_thrust", "lv": 40, "slot": 2, "name": "พุ่งแทง", "run": "wv_thrust", "mp": 20.0,
			"desc": "เวลาหยุด พุ่งแทงไปด้านหน้าอย่างรวดเร็ว ลูกบอลไฟจากจุดที่พุ่งตามมาอีกที"},
		{"id": "wv_wheel", "lv": 45, "slot": 1, "name": "ลูกไฟยักษ์หมุน", "run": "wv_wheel", "mp": 45.0,
			"desc": "เวลาหยุดตอนยกดาบ เรียกลูกไฟขนาดเลยครึ่งจอไปนิดมาข้างตัว หมุนเร็วแล้วเคลื่อนไปข้างหน้าช้าๆ 1 จอครึ่ง ดาเมจต่อเนื่อง"},
		{"id": "wv_water", "lv": 45, "slot": 2, "name": "ดาบน้ำ", "run": "wv_water", "mp": 30.0,
			"desc": "เวลาหยุด เสกดาบลายน้ำใหญ่จากฟ้า ปักเฉียงลงมา ถึงพื้นแตกกระจาย ทำดาเมจตอนพุ่งและตอนแตก"},
		{"id": "wv_reflect", "lv": 50, "slot": 1, "name": "ปัดสะท้อน", "run": "move", "mp": 12.0, "move": "REFLECT_MOVE",
			"desc": "ตั้งดาบป้องกัน การโจมตีระยะไกลจะถูกปัดสะท้อนกลับไป"},
		{"id": "wv_zone", "lv": 50, "slot": 2, "name": "วงเวทแดง", "run": "wv_zone", "mp": 30.0,
			"desc": "เวลาหยุด สร้างวงเวททรงกระบอกแดงวูบวาบ กว้างครึ่งจอ ยืนข้างในสกิลแรงขึ้น คูลดาวน์ลด 2%"},
		{"id": "wv_blast", "lv": 55, "slot": 1, "name": "ลูกไฟระเบิด", "run": "wv_blast", "mp": 35.0,
			"desc": "เวลาหยุด เสกลูกบอลไฟใหญ่ตรงหน้าแล้วระเบิด มอนลอยขึ้น"},
		{"id": "wv_ball_up", "lv": 60, "slot": 1, "name": "ลูกไฟใหญ่ขึ้น", "passive": true,
			"desc": "ลูกบอลไฟใหญ่ขึ้นอีก"},
		{"id": "wv_guard", "lv": 60, "slot": 2, "name": "แกร่งและแรง", "passive": true,
			"desc": "พลังป้องกันเพิ่ม และทำความเสียหายกับมอนมากขึ้น"},
	],
	"lord_knight": [
		{"id": "lk_aura", "lv": 35, "slot": 2, "name": "ออร่าดาบ", "run": "lk_aura", "mp": 30.0,
			"desc": "เวลาหยุด จับสองมือย่อตัวชี้ไปด้านหน้า ออร่าดาบใหญ่ขึ้นมา 30 วินาที ตีและใช้สกิลระยะไกลขึ้น ทำดาเมจด้านหน้า 1 ฮิต"},
		{"id": "lk_wheel", "lv": 35, "slot": 3, "name": "ควงดาบ", "run": "lk_wheel", "mp": 15.0,
			"desc": "หมุนพร้อมควงดาบไปด้านหน้าในแนวตั้ง"},
		{"id": "lk_wave", "lv": 35, "slot": 4, "name": "คลื่นดาบ", "passive": true,
			"desc": "ตีแล้วมีโอกาส 33% ปล่อยคลื่นดาบจางๆ ระยะสั้นที่แรงกว่าไปข้างหน้า"},
		{"id": "lk_ram", "lv": 40, "slot": 2, "name": "พุ่งชน", "run": "lk_ram", "mp": 18.0,
			"desc": "เวลาหยุด พุ่งชนด้านหน้าอย่างรุนแรง มอนชะงัก"},
		{"id": "lk_storm", "lv": 45, "slot": 1, "name": "พายุดาบ", "run": "lk_storm", "mp": 40.0,
			"desc": "เวลาหยุดก่อน แล้วหมุนตัวพร้อมดาบเกิดพายุใหญ่ เดินและกระโดดได้ นาน 8 วินาที"},
		{"id": "lk_circle", "lv": 45, "slot": 2, "name": "กวาดวงกลม", "run": "lk_circle", "mp": 25.0,
			"desc": "เวลาหยุด หมุนตัวกวาดดาบแนวตั้งเป็นวงกลมวงกว้าง มอนชะงัก"},
		{"id": "lk_parry", "lv": 50, "slot": 1, "name": "ตั้งดาบปัด", "run": "move", "mp": 12.0, "move": "PARRY_MOVE",
			"desc": "ตั้งดาบขึ้นมา ติด SA ถ้ามอนโจมตีจะปัดขึ้น ไม่เสียเลือด มอนลอย"},
		{"id": "lk_arc", "lv": 50, "slot": 2, "name": "ฟาดครึ่งวง", "run": "lk_arc", "mp": 30.0,
			"desc": "เวลาหยุด ยกดาบไปด้านหน้า แล้วฟาดครึ่งวงกลมกว้าง มีรอยดาบ"},
		{"id": "lk_whirl", "lv": 55, "slot": 1, "name": "หมุนสตั๊น", "run": "lk_whirl", "mp": 28.0,
			"desc": "เวลาหยุด หมุนตัวและดาบแนวนอนระยะสั้น มอนรอบตัวสตั๊น"},
		{"id": "lk_power", "lv": 60, "slot": 1, "name": "แกร่งขึ้น", "passive": true,
			"desc": "เลือดสูงสุดและพลังโจมตีเพิ่มขึ้นถาวร"},
		{"id": "lk_aura_mana", "lv": 60, "slot": 2, "name": "ออร่าประหยัดมานา", "passive": true,
			"desc": "ขณะมีออร่าดาบ ใช้สกิลเปลืองมานาน้อยลง และมานาฟื้นเร็วขึ้นนิดนึง"},
	],
	"magic_knight": [
		{"id": "mk_burst", "lv": 15, "slot": 3, "name": "มือไฟระเบิด", "run": "move", "mp": 12.0, "move": "BURST_MOVE",
			"desc": "พุ่งเอามือจุดไฟ ระเบิดรัวๆ ติด SA"},
		{"id": "mk_swords", "lv": 15, "slot": 4, "name": "ดาบแสง 8 เล่ม", "run": "mk_swords", "mp": 20.0,
			"desc": "เวลาหยุด เอามือกระแทกพื้น เสกดาบแสงอ้วนๆ 8 เล่ม ยาวรวม 1 จอครึ่ง มอนลอย ดาบเล่มแรกโผล่แล้วเดินได้"},
		{"id": "mk_burn", "lv": 15, "slot": 5, "name": "ไฟแรงขึ้น", "passive": true,
			"desc": "ติดตัว เพิ่มความเสียหายจากการติดไฟให้ศัตรูแรงขึ้น"},
		{"id": "mk_fly", "lv": 25, "slot": 1, "name": "ดาบแสงพุ่ง", "run": "mk_fly", "mp": 18.0,
			"desc": "เวลาหยุด ยกมือเสกดาบแสงอ้วน พุ่งไปด้านหน้าอย่างเร็ว ทะลุมอน ยกแล้วเดินได้เลย"},
		{"id": "mk_erupt", "lv": 30, "slot": 1, "name": "ปักดินปะทุ", "run": "mk_erupt", "mp": 25.0,
			"desc": "เวลาหยุด กระโดดปักดาบลงดิน ไฟลามไปรอบๆ แล้วลุกไหม้ต่อเนื่อง ปักแล้วเดินได้เลย"},
		{"id": "mk_coat", "lv": 30, "slot": 2, "name": "เคลือบดาบ", "run": "cast", "method": "start_coat", "mp": 15.0,
			"desc": "ทำให้ดาบมีออร่าเคลือบสีแบบสุ่ม น้ำแข็งหรือพิษ ตีแล้วมอนติดผลนั้น"},
		{"id": "mk_carousel", "lv": 35, "slot": 1, "name": "ดาบแสงหมุน", "run": "mk_carousel", "mp": 35.0,
			"desc": "เวลาหยุด ดาบแสงใหญ่ผุดตรงที่ยืน ดาบผอมกว่าเกาะรอบแกน หมุนนานจนเห็นแถบแดงโค้ง"},
		{"id": "mk_curse", "lv": 40, "slot": 1, "name": "สาปอ่อนแรง", "passive": true,
			"desc": "ติดตัว ตีมอนแล้วมีโอกาส 20% ที่มอนถูกลดพลังโจมตีและพลังป้องกัน"},
	],
	"rampart_knight": [
		{"id": "rk_ram", "lv": 15, "slot": 3, "name": "ไหล่สตั๊น", "run": "move", "mp": 10.0, "move": "STUN_RAM_MOVE",
			"desc": "เอาไหล่พุ่งชนด้านหน้า มอนสตั๊น ติด SA"},
		{"id": "rk_shout", "lv": 15, "slot": 4, "name": "ตะโกนพัด", "run": "rk_shout", "mp": 15.0,
			"desc": "เวลาหยุด ตะโกนไปด้านหน้ารูปพัด เคลือบสีแดง มอนในระยะสตั๊น"},
		{"id": "rk_power", "lv": 15, "slot": 5, "name": "พลังถาวร", "passive": true,
			"desc": "ติดตัว เพิ่มพลังโจมตีตัวเองถาวร"},
		{"id": "rk_big", "lv": 25, "slot": 1, "name": "ตะโกนแตกดิน", "run": "rk_big", "mp": 20.0,
			"desc": "เวลาหยุด เตรียมท่าตะโกน พื้นรอบๆ เริ่มแตก แล้วตะโกนเป็นวงกลม 1 ฮิต มอนสตั๊น"},
		{"id": "rk_hold", "lv": 30, "slot": 1, "name": "ตะโกนยาว", "run": "rk_hold", "mp": 10.0,
			"desc": "เวลาหยุด กดค้างตะโกนเป็นวงกลมกว้างกว่าเดิม ต่อเนื่อง สูบมานาเรื่อยๆ ทุกการตะโกนมอนสตั๊น"},
		{"id": "rk_voice", "lv": 30, "slot": 2, "name": "เสียงฟื้นมานา", "run": "cast", "method": "start_shout_buff", "cd": 30.0,
			"desc": "บัพ 10 วินาที ทุกการตะโกน 5 ครั้ง ฟื้นมานา 3 หน่วย คูลดาวน์ 30 วินาที"},
		{"id": "rk_throw", "lv": 35, "slot": 1, "name": "ทุ่มแผ่นดิน", "run": "rk_throw", "mp": 30.0,
			"desc": "เวลาหยุด กระโดดไปข้างหน้านิดนึง ทุ่มลงพื้น หินกองรอบๆ มอนลอยสูง กระทบพื้นแล้วเดินได้เลย"},
		{"id": "rk_mana", "lv": 40, "slot": 1, "name": "มานาถาวร", "passive": true,
			"desc": "ติดตัว เพิ่มมานาถาวร 100 หน่วย"},
	],
	"alchemic_mage": [
		{"id": "am_pour", "lv": 15, "slot": 3, "name": "เทพิษ", "run": "move", "mp": 12.0, "move": "POUR_MOVE",
			"desc": "เทน้ำยาลงพื้น พิษคลุ้งค่อยๆ ไปด้านหน้าระยะหนึ่ง"},
		{"id": "am_rain", "lv": 15, "slot": 4, "name": "วงเวทขวดยา", "run": "am_rain", "mp": 22.0,
			"desc": "เวลาหยุด สร้างวงเวทเหนือหัวมอน โปรยขวดยาลงมา สูงสุด 5 วง"},
		{"id": "am_system", "lv": 15, "slot": 5, "name": "รอออกแบบ", "passive": true,
			"desc": "สกิลติดตัว ระบบของสายนี้ ยังไม่ได้กำหนดผล"},
		{"id": "am_limit", "lv": 25, "slot": 1, "name": "เพิ่มขีดจำกัด", "run": "cast", "method": "start_limit_buff", "mp": 10.0,
			"desc": "บัพ 30 วินาที เพิ่มขีดจำกัดเลือดและมานา 100 หน่วย และลดการใช้มานา"},
		{"id": "am_cauldron", "lv": 30, "slot": 1, "name": "หม้อฝนกรด", "run": "am_cauldron", "mp": 30.0,
			"desc": "เวลาหยุด เรียกหม้อแม่มดสีม่วง ไอน้ำขึ้นฟ้าแผ่เป็นเมฆ ฝนกรดตกเต็มจอนาน"},
		{"id": "am_cloud", "lv": 30, "slot": 2, "name": "ควันวงกว้าง", "run": "move", "mp": 22.0, "move": "CLOUD_MOVE",
			"desc": "ปล่อยขวดยาไปด้านหน้า แตกแล้วควันฟุ้ง ทำดาเมจต่อเนื่องวงกว้าง"},
		{"id": "am_ore", "lv": 35, "slot": 1, "name": "แร่ผุด", "run": "am_ore", "mp": 35.0,
			"desc": "เวลาหยุด กระโดดทุบพื้น แร่ก้อนยักษ์ผุดไปด้านหน้า 10 ก้อน แล้วระเบิดเป็นวงกลมมีแร่เล็กลอยกลางวง เดินเข้าวงแล้วเร็วขึ้น คงอยู่ 5 วินาที"},
		{"id": "am_bubble", "lv": 40, "slot": 1, "name": "ขวดฟองสบู่", "run": "cast", "method": "start_bubbles", "mp": 20.0,
			"desc": "โยนขวดยาในฟองสบู่ 2 ขวด เหลืองทำให้ตัวแดงติด SA ฟ้าเพิ่มมานา เก็บได้ทุกขวด บัพซ้อนกันได้ เวลาไม่หยุด"},
	],
	"sync_time": [
		{"id": "st_tear", "lv": 15, "slot": 3, "name": "ฉีกมิติ", "run": "cast", "method": "start_tear", "mp": 12.0,
			"desc": "ยื่นมือฉีกมิติ แล้วเดินได้เลย รอยแยกตามไปด้านหน้าตัวเรา ทำดาเมจต่อเนื่อง"},
		{"id": "st_gravity", "lv": 15, "slot": 4, "name": "สนามโน้มถ่วง", "run": "st_gravity", "mp": 20.0,
			"desc": "เวลาหยุด สนามโน้มถ่วงกางบนพื้นด้านหน้า คลื่นทับลงมาต่อเนื่อง"},
		{"id": "st_later", "lv": 15, "slot": 5, "name": "รอออกแบบ", "passive": true,
			"desc": "สกิลติดตัว ยังไม่ได้กำหนดผล"},
		{"id": "st_gate", "lv": 25, "slot": 1, "name": "ประตูลูกกลม", "run": "st_gate", "mp": 18.0,
			"desc": "เวลาหยุด โดรนเปิดประตูวาป โผล่ด้านหน้าแบบหันหลัง ยิงลูกกลมทะลุมอน มอนที่โดนสตั๊นและระเบิดเป็นวงกลมม่วง"},
		{"id": "st_rift", "lv": 30, "slot": 1, "name": "รอยแยกอันตราย", "run": "st_rift", "mp": 35.0,
			"desc": "เวลาหยุด ถอยนิดนึง รอยแยกมิติใหญ่มากด้านหน้า มีคลื่นวงกลมระเบิดต่อเนื่อง ฮิตสุดท้ายระเบิด"},
		{"id": "st_recall", "lv": 30, "slot": 2, "name": "จดจำชีวิต", "run": "cast", "method": "start_recall", "mp": 15.0,
			"desc": "จดจำเลือดและมานาตอนกด ถ้าตายจะฟื้นกลับมาตามนั้น คงอยู่ 50 วินาที"},
		{"id": "st_warp", "lv": 35, "slot": 1, "name": "ฝนรอยแยก", "run": "st_warp", "mp": 40.0,
			"desc": "เวลาไม่หยุด วาปหายแล้วกลับมาเดินได้เลย รอยแยกแนวนอนด้านบนปล่อยลูกกลมใหญ่ต่อเนื่อง ลูกสุดท้ายกว้างเท่ารอยแยก กระทบพื้นแล้วพื้นสั่น"},
		{"id": "st_speed", "lv": 40, "slot": 1, "name": "เร่งสกิล", "passive": true,
			"desc": "ติดตัว ทุกสกิลออกท่าเร็วขึ้น 2 เปอร์เซ็นต์ และลดโอกาสการล้มของมอน"},
	],
	"sync_core": [
		{"id": "sc_top", "lv": 15, "slot": 3, "name": "โยนลูกข่าง", "run": "move", "mp": 8.0, "move": "TOP_MOVE",
			"desc": "โยนลูกข่างออกไปพอพ้นตัวแล้วระเบิด ถ้ามีมอนเป็นเป้าในจอจะตามไปนานขึ้น"},
		{"id": "sc_beam", "lv": 15, "slot": 4, "name": "โดรนพานแสง", "run": "sc_beam", "mp": 25.0,
			"desc": "เวลาหยุด เรียกโดรนทรงพานบนพื้น ยิงลำแสงชมพูเส้นเล็กขึ้นฟ้า เคลื่อนไปด้านหน้าลากมอนไปด้วย จนสุด 1 จอครึ่ง"},
		{"id": "sc_later", "lv": 15, "slot": 5, "name": "รอออกแบบ", "passive": true,
			"desc": "สกิลติดตัว ยังไม่ได้กำหนดผล"},
		{"id": "sc_mark", "lv": 25, "slot": 1, "name": "โดรนเป้า", "run": "sc_mark", "mp": 15.0,
			"desc": "เวลาหยุด เรียกโดรนเป้า ยิงลำกว้างไปข้างหน้าครึ่งจอ ปลายทางระเบิดวงกว้างสีม่วง มอนตัวแรกชะงักและตกเป็นเป้า 8 วินาที โดรนพานกับลูกข่างจะตามมอนที่เป็นเป้าในจอ"},
		{"id": "sc_plasma", "lv": 30, "slot": 1, "name": "พลาสม่า 6 เส้น", "run": "sc_plasma", "mp": 25.0,
			"desc": "เวลาหยุด กระโดดกลางอากาศ ยิงเส้นพลาสม่าหนาๆ ระบายม่วง กระจาย 6 เส้น"},
		{"id": "sc_tops", "lv": 30, "slot": 2, "name": "ลูกข่างรอบตัว", "run": "move", "mp": 15.0, "move": "TOPS_MOVE",
			"desc": "ปาลูกข่าง 8 ลูกรอบตัวเป็นวงกลม พ้นตัวแล้วระเบิด ถ้ามีมอนเป็นเป้าในจอจะตามไปนานขึ้น"},
		{"id": "sc_blast", "lv": 35, "slot": 1, "name": "โดรนระเบิด", "run": "sc_blast", "mp": 40.0,
			"desc": "เวลาหยุด โยนโดรนขึ้นฟ้าแล้วเดินได้เลย ระเบิดสีม่วงวงกว้างเกือบทั้งจอต่อเนื่อง"},
		{"id": "sc_kd_down", "lv": 40, "slot": 1, "name": "ลด KD", "passive": true,
			"desc": "ติดตัว ลดอัตราการล้มของมอนที่เราโจมตี และเพิ่ม MP 100 หน่วย"},
	],
	"high_mage": [
		{"id": "hm_ice_flow", "lv": 15, "slot": 3, "name": "น้ำแข็งเสียดพื้น", "run": "move", "mp": 15.0, "move": "ICE_FLOW_MOVE",
			"desc": "เอาคทาเสียดพื้น ปล่อยน้ำแข็งไปตามพื้นด้านหน้า"},
		{"id": "hm_homing", "lv": 15, "slot": 4, "name": "บอลน้ำแข็งติดตาม", "run": "hm_homing", "mp": 25.0,
			"desc": "เวลาหยุด กระโดดปล่อยลูกบอลน้ำแข็งใหญ่ลูกเดียว ซิ่งตามมอนแบบสุ่มนาน 10 วินาที มอนชะงัก"},
		{"id": "hm_ball_up", "lv": 15, "slot": 5, "name": "เสริมบอลไฟ", "passive": true,
			"desc": "ติดตัว ลูกบอลไฟแรงขึ้น ใหญ่ขึ้น ยิงไกลขึ้น และมานาเพิ่ม 40 หน่วย"},
		{"id": "hm_dmg_buff", "lv": 25, "slot": 1, "name": "บัพสกิลแรง", "run": "skill_buff", "mp": 10.0,
			"desc": "บัพ 20 วินาที เพิ่มความเสียหายของสกิลนิดนึง"},
		{"id": "hm_shards", "lv": 30, "slot": 1, "name": "เศษน้ำแข็ง", "run": "hm_shards", "mp": 35.0,
			"desc": "เวลาหยุด ลอยขึ้นนิดนึง เศษน้ำแข็งตกจากฟ้ารอบตัว ทำมอนแช่แข็ง กดค้างปล่อยนานขึ้นแต่สูบมานามาก"},
		{"id": "hm_meteor", "lv": 30, "slot": 2, "name": "ลูกไฟยักษ์", "run": "hm_meteor", "mp": 45.0,
			"desc": "เวลาหยุด เรียกลูกบอลไฟใหญ่เกินครึ่งจอตกลงมาเบื้องหน้า กระทบพื้นเกิดโดมครึ่งวงกลมไฟวนๆ แล้วค่อยๆ จาง"},
		{"id": "hm_mana_up", "lv": 35, "slot": 1, "name": "สะสมมานา", "run": "regen_buff", "mp": 0.0,
			"desc": "บัพ 30 วินาที มานาเพิ่มเร็วขึ้น แต่ถ้าโดนตีบัพจะหยุดทันที"},
		{"id": "hm_chain", "lv": 40, "slot": 1, "name": "สายฟ้าชิ่ง", "run": "hm_chain", "mp": 25.0,
			"desc": "เวลาหยุด กระโดดปล่อยสายฟ้าชิ่งไปมา ตัวที่โดนถูกชอตต่อเนื่องนาน ลงพื้นแล้วเดินได้เลย"},
	],
	"sword_knight": [
		{"id": "sk_kick", "lv": 15, "slot": 3, "name": "เตะหน้า", "run": "move", "move": "KICK_MOVE",
			"desc": "เตะไปด้านหน้า มอนชะงัก"},
		{"id": "sk_pry", "lv": 15, "slot": 4, "name": "งัดพัด", "run": "sk_pry",
			"desc": "เวลาหยุด ปักดาบแล้วงัดขึ้น ดาเมจรูปพัดเคลือบแดง ออกพัดเสี้ยวเดียวก็เดินได้"},
		{"id": "sk_power", "lv": 15, "slot": 5, "name": "พลังถาวร", "passive": true,
			"desc": "ติดตัว เพิ่มพลังโจมตีถาวร 10%"},
		{"id": "sk_crack", "lv": 25, "slot": 1, "name": "ดินแตกแดง", "run": "sk_crack",
			"desc": "เวลาหยุด ปักดาบลงพื้น ดินแตกสีแดงไปด้านหน้า มอนชะงักนาน ปักแล้วเดินได้เลย"},
		{"id": "sk_dive", "lv": 30, "slot": 1, "name": "ดิ่งทลาย", "run": "sk_dive", "air_only": true,
			"desc": "ใช้ได้เฉพาะกลางอากาศ เวลาหยุด พุ่งลงแนวเฉียง ดาเมจวงกว้าง ดินแตกสีแดง หินกองรอบๆ"},
		{"id": "sk_pommel", "lv": 30, "slot": 2, "name": "ด้ามทุบเกราะ", "run": "move", "move": "POMMEL_MOVE",
			"desc": "เอาด้ามดาบตีด้านหน้า มอนที่โดนติดสถานะเกราะแตก พลังป้องกันลดลง"},
		{"id": "sk_smash", "lv": 35, "slot": 1, "name": "คลื่นไหล", "run": "sk_smash",
			"desc": "เวลาหยุด รวมแสงแดงที่ดาบ พุ่งนิดนึงฟาดลงมา คลื่นดาบยักษ์ใบกว้างตกเฉียง จนจมดินแล้วระเบิด ตัวเราเดินได้เลย"},
		{"id": "sk_guard", "lv": 40, "slot": 1, "name": "เกราะ 20.2", "passive": true,
			"desc": "ติดตัว เมื่อใช้สกิล 20.2 จะเพิ่มพลังป้องกันมากขึ้น และมีผลทั้งทีม"},
	],
	"aid": [
		{"id": "aid_pillar", "lv": 1, "slot": 1, "name": "ประตูวาป", "run": "pillar", "mp": 10.0,
			"desc": "วางประตูเทเลพอร์ตเล็กพอดีตัว ทำดาเมจรอบตัวตอนวาง กดอีกครั้งวาปกลับมาที่ประตูและทำดาเมจรอบตัว"},
		{"id": "aid_ball", "lv": 1, "slot": 2, "name": "บอลรวมพลัง", "run": "aid_ball", "mp": 15.0,
			"desc": "เวลาหยุดตอนใช้สกิล รวมพลังลูกบอลสีม่วงดำขนาดใหญ่มาก ยิงไปด้านหน้า ไถมอนไปด้วย ถึงครึ่งจอแล้วระเบิด มอนลอย"},
		{"id": "aid_prism", "lv": 5, "slot": 1, "name": "ปริซึมขัง", "run": "aid_prism", "mp": 20.0,
			"desc": "เวลาหยุดตอนใช้สกิล สร้างปริซึมสามเหลี่ยมยาวตรงหน้า ทำดาเมจ 1 ครั้ง มอนด้านในเดินได้แค่ในปริซึม คงอยู่ 5 วินาที"},
		{"id": "aid_punch", "lv": 10, "slot": 1, "name": "หมัดคลื่น", "run": "aid_punch", "mp": 20.0,
			"desc": "เวลาหยุด ต่อยไปด้านหน้า กระแทกคลื่นพลังกระจายไปด้านหน้า มอนกระเด็น"},
		{"id": "aid_shot", "lv": 15, "slot": 1, "name": "ลูกบอลด่วน", "run": "move", "mp": 8.0, "move": "AID_SHOT_MOVE",
			"desc": "ปล่อยลูกบอลขนาดเล็ก พุ่งไปกระทบมอนด้านหน้าอย่างรวดเร็ว"},
		{"id": "aid_storm", "lv": 20, "slot": 1, "name": "พายุม่วง", "run": "aid_storm", "mp": 30.0,
			"desc": "เวลาหยุด โดรนไปซ้ายขวา เกิดพายุม่วงอ้วนกว้างสองข้าง รวบมาตรงกลาง ชนกันแล้วระเบิดวงกว้าง มอนกระเด็นขึ้น"},
		{"id": "aid_power", "lv": 20, "slot": 2, "name": "บัพพลังโจมตี", "run": "atk_buff", "mp": 10.0,
			"desc": "บัพตัวเอง เพิ่มพลังโจมตี 20 วินาที"},
	],
	"gwen": [
		{"id": "gwen_blink", "lv": 1, "slot": 1, "name": "วาป", "run": "blink", "mp": 5.0,
			"desc": "วาปไปตามทิศทางที่กำลังเคลื่อนไหว กดทิศหรือกระโดดร่วมด้วยได้"},
		{"id": "gwen_trio", "lv": 1, "slot": 2, "name": "บอลไฟสามลูก", "run": "fire_trio", "mp": 15.0,
			"desc": "เวลาหยุดตอนกดสกิล ยิงลูกบอลไฟใหญ่ 2 ลูก แล้วตามด้วยลูกเล็กอีก 1 ลูก ผลักมอนกระเด็น"},
		{"id": "gwen_storm", "lv": 5, "slot": 1, "name": "ไฟวนรอบตัว", "run": "fire_storm", "mp": 20.0,
			"desc": "เวลาหยุดตอนกดสกิล เสกวงเวทใต้เท้าแล้วยกไม้เท้า เส้นไฟวนรอบตัวแนวนอน เดินไปมาทำดาเมจได้ มอนไม่ชะงัก"},
		{"id": "gwen_root", "lv": 10, "slot": 1, "name": "วงเวทตรึง", "run": "move", "mp": 20.0, "move": "ROOT_MOVE",
			"desc": "กระจายวงเวทเป็นวงกลมรอบตัว มอนที่โดนถูกตรึงกับที่ 3 วินาที ไม่จำกัดจำนวน"},
		{"id": "gwen_flame", "lv": 15, "slot": 1, "name": "เปลวเสียดพื้น", "run": "move", "mp": 15.0, "move": "FLAME_MOVE",
			"desc": "ปล่อยเปลวไฟเสียดไปตามพื้นไปด้านหน้า"},
		{"id": "gwen_meteor", "lv": 20, "slot": 1, "name": "ฝนลูกไฟ", "run": "hold", "mp": 10.0, "mp_hold": true, "move": "METEOR_MOVE",
			"desc": "ลอยขึ้นนิดนึง ชี้ไม้ไปด้านหน้า ลูกไฟหลายขนาดตกลงมาด้านหน้า ยิ่งกดค้างยิ่งปล่อยเรื่อยๆ แต่มานาลดเรื่อยๆ"},
		{"id": "gwen_mana", "lv": 20, "slot": 2, "name": "บัพประหยัดมานา", "run": "mana_buff", "mp": 10.0,
			"desc": "ทำท่าบัพ ลดมานาที่ใช้ตอนกดสกิลลงครึ่งหนึ่ง ใช้กับสกิลที่กดค้างต่อไม่ได้"},
	],
	"boy": [
		{"id": "boy_roll", "lv": 1, "slot": 1, "name": "กลิ้งตัว", "run": "roll",
			"desc": "กลิ้งตัว 1 ครั้ง ทำดาเมจตอนกลิ้ง และไม่โดนดาเมจใดๆ ตอนกลิ้ง"},
		{"id": "boy_aura_slash", "lv": 1, "slot": 2, "name": "ฟันออร่า", "run": "aura_slash",
			"desc": "หน้าจอหยุดสักพัก รวมพลังออร่าที่ดาบ แล้วฟาดเฉียงลงมา"},
		{"id": "boy_storm", "lv": 5, "slot": 1, "name": "พายุปักดาบ", "run": "storm",
			"desc": "เวลาหยุด ปักดาบลงพื้น ออร่าทรงพายุสีแดงรอบตัว ทำดาเมจต่อเนื่องแล้วค่อยๆ หายไป"},
		{"id": "boy_triple_wave", "lv": 10, "slot": 1, "name": "คลื่นสามวง", "run": "triple_wave",
			"desc": "เวลาหยุด พุ่งสั้นๆ หมุนตัวเตรียมดาบ ฟาดไปด้านหน้า เกิดคลื่นกระแทก 3 วง แล้วคลื่นจากฟ้าสีแดงตามลำดับ ทำดาเมจหลายฮิต มอนลอย"},
		{"id": "boy_tornado", "lv": 15, "slot": 1, "name": "พายุลากดิน", "run": "tornado",
			"desc": "เวลาหยุด หมุนตัวเอาดาบเสียดพื้น เกิดพายุสีแดงพัดไปด้านหน้า ลากมอนไปด้วย"},
		{"id": "boy_fury", "lv": 20, "slot": 1, "name": "ฟาดคลั่ง", "run": "fury",
			"desc": "เวลาหยุด ฟาดดาบไปด้านหน้าหลายฮิตสีแดงอย่างรุนแรง ฮิตสุดท้ายเกิดคลื่นกระแทกกับคลื่นจากฟ้าหนึ่งวง มอนลอย"},
		{"id": "boy_buff", "lv": 20, "slot": 2, "name": "บัพพลัง", "run": "buff",
			"desc": "บัพตัวเอง 20 วินาที ติด SA เพิ่มความไว และเพิ่มพลังโจมตี"},
	],
}

## ท่ากลิ้งตัว
const ROLL_MOVE := {"dur": 0.32, "wind": 0.02, "strike": 0.9, "sw0": -28.0, "sw1": -28.0, "wheel": 1.0, "curl": true, "lunge": 7.5, "invuln": true, "ghost": true,
	"hit_at": 0.05, "hit_reach": 1.6, "hit_back": 0.8, "lean_w": 0.0, "lean_s": 0.0,
	"hit": {"type": "flinch", "dmg": 10, "kd": 15, "kb": 0.0}}

## กระจายวงเวทรอบตัว มอนในวงถูกตรึง 3 วินาที
const ROOT_MOVE := {"dur": 0.55, "wind": 0.35, "strike": 0.3, "sw0": -20.0, "sw1": -5.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.1, 0.8), "lunge": 0.0, "fx_circle": "wide", "root_r": 5.0, "root_time": 3.0, "lean_w": 0.0, "lean_s": 0.0}
## เปลวไฟเสียดไปตามพื้น
const FLAME_MOVE := {"dur": 0.55, "sw0": 15.0, "sw1": -135.0, "p0": Vector2(-0.2, 0.5), "p1": Vector2(0.7, 0.15), "lunge": 0.0, "lean_s": -16.0,
	"shot": {"type": "ground_flame", "dmg": 20.0, "reach": 9.0, "skill": true}}
## ลอยขึ้นนิดนึง ชี้ไม้ไปด้านหน้า ลูกไฟตกลงมาเรื่อยๆ ตอนกดค้าง
const METEOR_MOVE := {"dur": 30.0, "wind": 0.01, "strike": 0.01, "sw0": -80.0, "sw1": -85.0, "p0": Vector2(0.2, 0.3), "p1": Vector2(0.7, 0.35), "lunge": 0.0,
	"hold": "skill", "hold_min": 0.5, "hover": 1.1, "mp_drain": 18.0, "meteor_gap": 0.09, "lean_w": 0.0, "lean_s": -6.0}
## ปล่อยลูกบอลเล็กพุ่งเร็ว
const AID_SHOT_MOVE := {"dur": 0.3, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(0.0, 0.2), "p1": Vector2(0.7, 0.2), "drone_to": "hand", "lunge": 0.0, "lean_s": -8.0,
	"shot": {"dir": Vector2(1.0, 0.0), "speed": 22.0, "dmg": 12.0, "kind": "elec", "radius": 13.0, "skill": true}}
## โยนลูกข่าง ระเบิดเล็ก
const TOP_MOVE := {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.3), "p1": Vector2(0.7, 0.3), "drone_to": "hand", "lunge": 0.0,
	"shot": {"type": "spin_top", "dmg": 12.0, "small": true, "vx": 7.0, "vy": 2.5, "slide": 0.5}}
## ปล่อยลูกข่างเล็กรอบตัว
const TOPS_MOVE := {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(0.0, 0.2), "p1": Vector2(0.2, 0.7), "drone_to": "orbit", "lunge": 0.0,
	"shots": [{"type": "spin_top", "dmg": 8.0, "small": true, "vx": 6.5, "vy": 0.0, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": 4.6, "vy": 4.6, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": 0.0, "vy": 6.5, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": -4.6, "vy": 4.6, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": -6.5, "vy": 0.0, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": -4.6, "vy": -4.6, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": -0.0, "vy": -6.5, "slide": 0.42},
		{"type": "spin_top", "dmg": 8.0, "small": true, "vx": 4.6, "vy": -4.6, "slide": 0.42}]}
## พุ่งเอามือจุดไฟระเบิดรัวๆ
const BURST_MOVE := {"dur": 0.8, "wind": 0.1, "strike": 0.2, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(95.0, 0.0), "lunge": 7.0, "sa": true, "lean_s": -24.0,
	"tick": 0.09, "tick_max": 6, "fx_hit": "ram", "hit_reach": 2.3, "hitstop": 0.02,
	"hit": {"type": "flinch", "dmg": 5, "kd": 8, "kb": 0.0, "burn": "fire", "skill": true}}
## ไหล่พุ่งชน สตั๊น
const STUN_RAM_MOVE := {"dur": 0.45, "sw0": -10.0, "sw1": -10.0, "p0": Vector2(-0.7, -0.1), "p1": Vector2(-0.7, -0.1), "lean_w": 8.0, "lean_s": -50.0, "hit_reach": 1.9, "fx_ram": true, "lunge": 10.0, "sa": true,
	"hit": {"type": "flinch", "dmg": 10, "kd": 15, "kb": 0.0, "stun": 2.0, "real_stun": true, "skill": true}}
## เทพิษลงพื้น คลุ้งไปด้านหน้า
const POUR_MOVE := {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(0.0, 0.2), "p1": Vector2(0.5, -0.2), "lunge": 0.0,
	"shot": {"type": "smoke", "ahead": 1.4, "drift": 2.2, "life": 3.0, "tick": 4.0, "burn": "poison", "fill": Color(0.62, 0.84, 0.42)}}
## ขวดยาควันวงกว้าง
const CLOUD_MOVE := {"dur": 0.45, "sw0": -30.0, "sw1": -60.0, "lunge": 0.0,
	"shot": {"type": "potion", "vx": 6.5, "vy": 4.0, "dmg": 8.0, "smoke_life": 3.0, "smoke_tick": 4.0, "smoke_wide": 2.2}}
## น้ำแข็งเสียดไปตามพื้น
const ICE_FLOW_MOVE := {"dur": 0.55, "sw0": 15.0, "sw1": -150.0, "p0": Vector2(-0.2, 0.5), "p1": Vector2(0.7, 0.2), "lunge": 0.0, "lean_s": -16.0,
	"shot": {"type": "ground_flame", "kind": "ice", "dmg": 20.0, "reach": 9.0, "skill": true}}
## เตะหน้า
const KICK_MOVE := {"dur": 0.4, "sw0": -28.0, "sw1": -28.0, "kick": true, "lunge": 2.0, "lean_w": 8.0, "lean_s": -12.0, "hit_reach": 2.3,
	"hit": {"type": "flinch", "dmg": 14, "kd": 15, "kb": 0.0, "skill": true}}
## ด้ามดาบตี เกราะแตก
const POMMEL_MOVE := {"dur": 0.42, "sw0": 170.0, "sw1": 170.0, "p0": Vector2(-0.3, 0.3), "p1": Vector2(0.9, 0.2), "lunge": 3.0, "lean_s": -18.0, "hit_reach": 2.2,
	"hit": {"type": "flinch", "dmg": 8, "kd": 15, "kb": 0.0, "skill": true, "armor_break": true}}
## ท่าบัพ
## ตั้งดาบรอปัด ติด SA มอนโจมตีเข้ามาจะถูกปัดขึ้น
const PARRY_MOVE := {"dur": 1.6, "wind": 0.08, "strike": 0.1, "sw0": -28.0, "sw1": 0.0, "p0": Vector2(0.0, 0.3), "p1": Vector2(0.45, 0.8), "lunge": 0.0, "sa": true, "parry": true, "lean_w": 0.0, "lean_s": 0.0}
## ตั้งดาบ ปัดการโจมตีระยะไกลสะท้อนกลับ
const REFLECT_MOVE := {"dur": 1.6, "wind": 0.08, "strike": 0.1, "sw0": -28.0, "sw1": 15.0, "p0": Vector2(0.0, 0.3), "p1": Vector2(0.55, 0.65), "lunge": 0.0, "sa": true, "reflect": true, "lean_w": 0.0, "lean_s": 0.0}
## โยนขวดซ้าย ขวา ที่เท้า ควันฟุ้ง
const BOTTLES_MOVE := {"dur": 0.45, "sw0": -30.0, "sw1": -60.0, "lunge": 0.0,
	"shots": [{"type": "potion", "vx": -6.0, "vy": 3.5, "dmg": 6.0, "smoke_life": 2.5, "smoke_tick": 3.0, "smoke_wide": 1.6},
		{"type": "potion", "vx": 6.0, "vy": 3.5, "dmg": 6.0, "smoke_life": 2.5, "smoke_tick": 3.0, "smoke_wide": 1.6},
		{"type": "potion", "vx": 0.0, "vy": 0.5, "dmg": 6.0, "smoke_life": 2.5, "smoke_tick": 3.0, "smoke_wide": 1.6}]}
## เข็มฉีดยาแทงรัว 4 ฮิต ติด SA
const NEEDLE_MOVE := {"dur": 0.62, "wind": 0.08, "strike": 0.6, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(0.0, 0.2), "p1": Vector2(0.9, 0.3), "drone_to": "front", "lunge": 1.0, "sa": true, "lean_s": -14.0,
	"tick": 0.12, "tick_max": 4, "fx_hit": "ram", "hit_reach": 2.8, "hit_back": 0.3, "hitstop": 0.02,
	"hit": {"type": "flinch", "dmg": 11, "kd": 5, "kb": 0.0, "skill": true}}
const MANA_MOVE := {"dur": 0.55, "wind": 0.35, "strike": 0.3, "sw0": -28.0, "sw1": -5.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.0, 0.85), "lunge": 0.0, "fx_circle": "ground", "lean_w": 0.0, "lean_s": 0.0}

static func move_of(s: Dictionary) -> Dictionary:
	match str(s.get("move", "")):
		"ROOT_MOVE": return ROOT_MOVE.duplicate(true)
		"FLAME_MOVE": return FLAME_MOVE.duplicate(true)
		"METEOR_MOVE": return METEOR_MOVE.duplicate(true)
		"AID_SHOT_MOVE": return AID_SHOT_MOVE.duplicate(true)
		"ICE_FLOW_MOVE": return ICE_FLOW_MOVE.duplicate(true)
		"BURST_MOVE": return BURST_MOVE.duplicate(true)
		"STUN_RAM_MOVE": return STUN_RAM_MOVE.duplicate(true)
		"POUR_MOVE": return POUR_MOVE.duplicate(true)
		"CLOUD_MOVE": return CLOUD_MOVE.duplicate(true)
		"TOP_MOVE": return TOP_MOVE.duplicate(true)
		"NEEDLE_MOVE": return NEEDLE_MOVE.duplicate(true)
		"BOTTLES_MOVE": return BOTTLES_MOVE.duplicate(true)
		"REFLECT_MOVE": return REFLECT_MOVE.duplicate(true)
		"PARRY_MOVE": return PARRY_MOVE.duplicate(true)
		"TOPS_MOVE": return TOPS_MOVE.duplicate(true)
		"KICK_MOVE": return KICK_MOVE.duplicate(true)
		"POMMEL_MOVE": return POMMEL_MOVE.duplicate(true)
	return {}

## สกิลทั้งหมดของสายนี้ ไล่ตามเลเวลแล้วตามช่อง
static func for_job(id: String) -> Array:
	var out: Array = []
	var at := id
	while at != "":
		out.append_array(SKILLS.get(at, []))
		at = str(JobData.find(at).get("parent", ""))
	if JobData.has_hyper(id):
		out.append(hyper_entry(id))
	out.sort_custom(func(a, b): return int(a["lv"]) * 100 + int(a["slot"]) < int(b["lv"]) * 100 + int(b["slot"]))
	return out

## ปุ่มสกิลตามเซฟ ไม่มีเซฟใช้ค่าเริ่มต้นเหมือนในเกม
static func slots_for(job: String) -> Array:
	var out: Array = ["", "", "", "", "", "", "", ""]
	var saved := SaveData.slots(job)
	if saved.size() > 0:
		for i in mini(saved.size(), out.size()):
			out[i] = saved[i]
		return out
	var skills := for_job(job).filter(func(s): return not s.get("passive", false) and s["id"] != HYPER_ID)
	var next := 0
	for i in out.size():
		if i == 0 and JobData.has_hyper(job):
			out[0] = HYPER_ID
			continue
		if next < skills.size():
			out[i] = skills[next]["id"]
			next += 1
	return out

## Hyper ของสาย แสดงในผังเหมือนสกิลทั่วไป
static func hyper_entry(job: String = "") -> Dictionary:
	var desc := "สกิล Hyper ของสายนี้ ใส่ปุ่มช่องไหนก็ได้"
	if job != "":
		desc = str(JobData.find(job).get("desc", desc))
	return {"id": HYPER_ID, "lv": HYPER_LV, "slot": 1, "name": "Hyper", "run": "hyper", "desc": desc}

static func find(id: String) -> Dictionary:
	if id == HYPER_ID:
		return hyper_entry()
	for job in SKILLS:
		for s in SKILLS[job]:
			if s["id"] == id:
				return s
	return {}

## สายนี้มีสกิลติดตัวนี้หรือไม่
static func has_passive(job: String, id: String) -> bool:
	for s in for_job(job):
		if s["id"] == id:
			return true
	return false

## เลขสกิล เช่น 5.1
static func number(s: Dictionary) -> String:
	return "%d.%d" % [int(s["lv"]), int(s["slot"])]
