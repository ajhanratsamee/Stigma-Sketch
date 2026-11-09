class_name DungeonLook
## ฉากหลังดันเจี้ยนตามธีมเมือง (เพิ่มจาก 5 ฉากเดิมของเมืองแรก)
## สีน้ำโทนกลางวันทุกฉาก แม้ในถ้ำหรือปราสาทก็ไม่มืด ทุกรูปทรงมน ไม่มีดาวแฉก
## LOOKS[ธีม] = {sky: [บน ล่าง], ceil: สีเพดานถ้ำ/ห้อง (ไม่มีคือฟ้าเปิด), sun: "sun"|"glow"|"none", clouds: "up"|"below"|"none",
##   far: ชนิดฉากไกล, far_col, mid: ชนิดฉากกลาง, mid_col, ground: [ไกล ใกล้], haze, plat: สีแท่นลอย}

const LOOKS := {
	# เมืองตลาดปลาทู
	"fishmarket": {"sky": [Color(0.62, 0.82, 0.96), Color(0.98, 0.94, 0.86)], "sun": "sun", "clouds": "up",
		"far": "stalls", "far_col": Color(0.95, 0.7, 0.55, 0.55), "mid": "barrels", "mid_col": Color(0.72, 0.55, 0.38, 0.6),
		"ground": [Color(0.86, 0.8, 0.68), Color(0.72, 0.64, 0.52)], "haze": Color(1.0, 0.97, 0.92, 0.15), "plat": Color(0.7, 0.52, 0.36)},
	"canal": {"sky": [Color(0.6, 0.84, 0.95), Color(0.9, 0.96, 0.98)], "sun": "sun", "clouds": "up",
		"far": "houses", "far_col": Color(0.92, 0.82, 0.72, 0.55), "mid": "boats", "mid_col": Color(0.55, 0.72, 0.9, 0.6),
		"ground": [Color(0.7, 0.82, 0.88), Color(0.55, 0.7, 0.8)], "haze": Color(0.9, 0.97, 1.0, 0.15), "plat": Color(0.62, 0.5, 0.38)},
	# หมู่บ้านแมวภูเขา
	"mine": {"sky": [Color(0.78, 0.7, 0.62), Color(0.95, 0.88, 0.76)], "ceil": Color(0.62, 0.52, 0.45), "sun": "glow", "clouds": "none",
		"far": "beams", "far_col": Color(0.62, 0.48, 0.36, 0.55), "mid": "lanterns", "mid_col": Color(1.0, 0.82, 0.5, 0.7),
		"ground": [Color(0.78, 0.68, 0.56), Color(0.64, 0.54, 0.44)], "haze": Color(1.0, 0.93, 0.82, 0.12), "plat": Color(0.6, 0.46, 0.34)},
	"crystal": {"sky": [Color(0.72, 0.72, 0.9), Color(0.92, 0.9, 0.98)], "ceil": Color(0.6, 0.58, 0.78), "sun": "glow", "clouds": "none",
		"far": "crystals", "far_col": Color(0.78, 0.7, 0.98, 0.5), "mid": "crystals_big", "mid_col": Color(0.65, 0.85, 1.0, 0.6),
		"ground": [Color(0.76, 0.74, 0.88), Color(0.62, 0.6, 0.78)], "haze": Color(0.92, 0.9, 1.0, 0.15), "plat": Color(0.58, 0.54, 0.74)},
	# ท่าเรือแมวน้ำ
	"shipwreck": {"sky": [Color(0.58, 0.8, 0.95), Color(0.95, 0.95, 0.9)], "sun": "sun", "clouds": "up",
		"far": "sea", "far_col": Color(0.45, 0.72, 0.9, 0.6), "mid": "wreck", "mid_col": Color(0.62, 0.46, 0.34, 0.6),
		"ground": [Color(0.94, 0.86, 0.68), Color(0.82, 0.72, 0.54)], "haze": Color(0.92, 0.98, 1.0, 0.15), "plat": Color(0.6, 0.45, 0.32)},
	"seacave": {"sky": [Color(0.55, 0.78, 0.85), Color(0.82, 0.94, 0.95)], "ceil": Color(0.48, 0.64, 0.7), "sun": "glow", "clouds": "none",
		"far": "sea", "far_col": Color(0.4, 0.7, 0.82, 0.55), "mid": "rocks", "mid_col": Color(0.5, 0.62, 0.68, 0.6),
		"ground": [Color(0.78, 0.8, 0.74), Color(0.6, 0.66, 0.62)], "haze": Color(0.85, 0.97, 1.0, 0.15), "plat": Color(0.48, 0.6, 0.64)},
	# เมืองแมวทะเลทราย
	"dunes": {"sky": [Color(0.62, 0.8, 0.98), Color(1.0, 0.93, 0.78)], "sun": "sun", "clouds": "none",
		"far": "dunes", "far_col": Color(0.98, 0.8, 0.55, 0.6), "mid": "cactus", "mid_col": Color(0.5, 0.72, 0.48, 0.65),
		"ground": [Color(0.98, 0.86, 0.62), Color(0.88, 0.72, 0.48)], "haze": Color(1.0, 0.95, 0.85, 0.15), "plat": Color(0.82, 0.64, 0.42)},
	"pyramid": {"sky": [Color(0.96, 0.76, 0.6), Color(1.0, 0.92, 0.78)], "sun": "sun", "clouds": "none",
		"far": "pyramids", "far_col": Color(0.92, 0.74, 0.5, 0.6), "mid": "pillars", "mid_col": Color(0.88, 0.74, 0.52, 0.6),
		"ground": [Color(0.95, 0.82, 0.6), Color(0.84, 0.68, 0.46)], "haze": Color(1.0, 0.92, 0.8, 0.15), "plat": Color(0.8, 0.62, 0.4)},
	"oasis": {"sky": [Color(0.55, 0.82, 0.95), Color(0.96, 0.96, 0.86)], "sun": "sun", "clouds": "up",
		"far": "dunes", "far_col": Color(0.95, 0.82, 0.6, 0.55), "mid": "palms", "mid_col": Color(0.42, 0.7, 0.45, 0.65),
		"ground": [Color(0.75, 0.86, 0.6), Color(0.62, 0.74, 0.48)], "haze": Color(0.95, 1.0, 0.92, 0.15), "plat": Color(0.68, 0.55, 0.38)},
	# หมู่บ้านแมวหิมะ
	"skislope": {"sky": [Color(0.66, 0.84, 0.98), Color(0.95, 0.97, 1.0)], "sun": "sun", "clouds": "up",
		"far": "snowhills", "far_col": Color(0.9, 0.94, 1.0, 0.7), "mid": "snowpines", "mid_col": Color(0.45, 0.66, 0.6, 0.6),
		"ground": [Color(0.96, 0.97, 1.0), Color(0.84, 0.88, 0.95)], "haze": Color(1.0, 1.0, 1.0, 0.18), "plat": Color(0.62, 0.7, 0.82)},
	"frozenlake": {"sky": [Color(0.7, 0.84, 0.96), Color(0.94, 0.96, 1.0)], "sun": "sun", "clouds": "up",
		"far": "icebergs", "far_col": Color(0.82, 0.92, 1.0, 0.65), "mid": "snowpines", "mid_col": Color(0.5, 0.7, 0.65, 0.55),
		"ground": [Color(0.82, 0.92, 0.98), Color(0.68, 0.82, 0.92)], "haze": Color(0.95, 0.98, 1.0, 0.18), "plat": Color(0.6, 0.72, 0.85)},
	"icecave": {"sky": [Color(0.7, 0.86, 0.96), Color(0.92, 0.97, 1.0)], "ceil": Color(0.62, 0.78, 0.9), "sun": "glow", "clouds": "none",
		"far": "icebergs", "far_col": Color(0.78, 0.9, 1.0, 0.55), "mid": "crystals_big", "mid_col": Color(0.75, 0.92, 1.0, 0.6),
		"ground": [Color(0.86, 0.93, 0.98), Color(0.72, 0.84, 0.93)], "haze": Color(0.92, 0.98, 1.0, 0.15), "plat": Color(0.6, 0.74, 0.86)},
	# เกาะแมวภูเขาไฟ
	"crater": {"sky": [Color(0.96, 0.7, 0.55), Color(1.0, 0.9, 0.78)], "sun": "glow", "clouds": "up",
		"far": "volcano", "far_col": Color(0.72, 0.5, 0.45, 0.6), "mid": "rocks", "mid_col": Color(0.62, 0.46, 0.42, 0.6),
		"ground": [Color(0.78, 0.62, 0.55), Color(0.64, 0.5, 0.45)], "haze": Color(1.0, 0.9, 0.82, 0.15), "plat": Color(0.62, 0.46, 0.4)},
	"lavatunnel": {"sky": [Color(0.9, 0.66, 0.55), Color(1.0, 0.86, 0.72)], "ceil": Color(0.7, 0.5, 0.45), "sun": "glow", "clouds": "none",
		"far": "lavaflow", "far_col": Color(1.0, 0.62, 0.38, 0.55), "mid": "lavapools", "mid_col": Color(1.0, 0.7, 0.4, 0.6),
		"ground": [Color(0.76, 0.6, 0.52), Color(0.62, 0.48, 0.42)], "haze": Color(1.0, 0.88, 0.78, 0.15), "plat": Color(0.6, 0.45, 0.4)},
	# ปราสาทแมวเงา (ลาเวนเดอร์กลางๆ ไม่มืด)
	"library": {"sky": [Color(0.78, 0.72, 0.88), Color(0.95, 0.9, 0.95)], "ceil": Color(0.66, 0.6, 0.78), "sun": "glow", "clouds": "none",
		"far": "shelves", "far_col": Color(0.62, 0.5, 0.62, 0.6), "mid": "candles", "mid_col": Color(1.0, 0.86, 0.6, 0.7),
		"ground": [Color(0.8, 0.72, 0.82), Color(0.66, 0.58, 0.7)], "haze": Color(0.98, 0.94, 1.0, 0.12), "plat": Color(0.58, 0.48, 0.6)},
	"cells": {"sky": [Color(0.74, 0.72, 0.84), Color(0.92, 0.9, 0.95)], "ceil": Color(0.62, 0.6, 0.74), "sun": "glow", "clouds": "none",
		"far": "windows", "far_col": Color(0.66, 0.62, 0.78, 0.55), "mid": "bars", "mid_col": Color(0.52, 0.5, 0.62, 0.6),
		"ground": [Color(0.76, 0.74, 0.84), Color(0.62, 0.6, 0.72)], "haze": Color(0.95, 0.94, 1.0, 0.12), "plat": Color(0.54, 0.5, 0.64)},
	"rooftop": {"sky": [Color(0.66, 0.62, 0.86), Color(0.98, 0.86, 0.88)], "sun": "sun", "clouds": "up",
		"far": "roofs", "far_col": Color(0.55, 0.5, 0.72, 0.55), "mid": "flags", "mid_col": Color(0.62, 0.5, 0.78, 0.6),
		"ground": [Color(0.72, 0.68, 0.82), Color(0.58, 0.54, 0.7)], "haze": Color(0.98, 0.92, 1.0, 0.12), "plat": Color(0.56, 0.5, 0.68)},
	# สวรรค์แมวทอง
	"cloudgarden": {"sky": [Color(0.66, 0.84, 1.0), Color(1.0, 0.96, 0.88)], "sun": "sun", "clouds": "below",
		"far": "islands", "far_col": Color(0.95, 0.92, 0.85, 0.6), "mid": "flowers", "mid_col": Color(1.0, 0.75, 0.82, 0.65),
		"ground": [Color(0.98, 0.96, 0.92), Color(0.9, 0.88, 0.84)], "haze": Color(1.0, 1.0, 0.95, 0.15), "plat": Color(0.95, 0.85, 0.6)},
	"skytemple": {"sky": [Color(0.98, 0.86, 0.6), Color(1.0, 0.96, 0.86)], "sun": "sun", "clouds": "below",
		"far": "columns", "far_col": Color(1.0, 0.9, 0.62, 0.55), "mid": "pillars", "mid_col": Color(0.98, 0.92, 0.75, 0.6),
		"ground": [Color(1.0, 0.94, 0.8), Color(0.92, 0.84, 0.66)], "haze": Color(1.0, 0.98, 0.9, 0.15), "plat": Color(0.95, 0.8, 0.5)},
	# ---- ฉากเคลื่อนไหวพิเศษ (anim) ----
	# บนหลังคารถไฟแมวที่กำลังวิ่ง วิวไกลเลื่อนผ่านเร็ว
	"train": {"sky": [Color(0.6, 0.82, 0.98), Color(0.98, 0.95, 0.86)], "sun": "sun", "clouds": "none",
		"far": "none", "far_col": Color(0.6, 0.78, 0.6, 0.55), "mid": "carriages", "mid_col": Color(0.92, 0.55, 0.45, 0.8),
		"ground": [Color(0.78, 0.5, 0.42), Color(0.62, 0.4, 0.34)], "haze": Color(1.0, 0.97, 0.92, 0.1), "plat": Color(0.72, 0.42, 0.36), "anim": "train"},
	# ใต้ทะเล สาหร่ายไหว ฟองลอยขึ้น ฝูงปลาว่ายผ่าน แสงคลื่นนุ่มๆ
	"underwater": {"sky": [Color(0.42, 0.72, 0.82), Color(0.62, 0.86, 0.84)], "sun": "glow", "clouds": "none",
		"far": "reef", "far_col": Color(0.36, 0.6, 0.7, 0.5), "mid": "kelp_still", "mid_col": Color(0.36, 0.66, 0.52, 0.55),
		"ground": [Color(0.86, 0.82, 0.66), Color(0.72, 0.68, 0.54)], "haze": Color(0.6, 0.9, 0.95, 0.14), "plat": Color(0.5, 0.66, 0.68), "anim": "underwater"},
	# ดาดฟ้าเรือเหาะเหนือทะเลเมฆ
	"airship": {"sky": [Color(0.6, 0.8, 1.0), Color(1.0, 0.94, 0.86)], "sun": "sun", "clouds": "none",
		"far": "none", "far_col": Color(1.0, 1.0, 1.0, 0.6), "mid": "rigging", "mid_col": Color(0.62, 0.46, 0.34, 0.7),
		"ground": [Color(0.78, 0.6, 0.42), Color(0.64, 0.48, 0.34)], "haze": Color(1.0, 1.0, 1.0, 0.1), "plat": Color(0.66, 0.5, 0.36), "anim": "airship"},
	# อุโมงค์รถแร่ รางเลื่อน รถแร่วิ่งด้านหลัง ตะเกียงแกว่ง
	"minecart": {"sky": [Color(0.8, 0.7, 0.6), Color(0.96, 0.88, 0.76)], "ceil": Color(0.6, 0.5, 0.42), "sun": "glow", "clouds": "none",
		"far": "beams", "far_col": Color(0.6, 0.46, 0.34, 0.5), "mid": "rails", "mid_col": Color(0.55, 0.45, 0.4, 0.7),
		"ground": [Color(0.76, 0.66, 0.54), Color(0.62, 0.52, 0.42)], "haze": Color(1.0, 0.93, 0.82, 0.1), "plat": Color(0.58, 0.46, 0.36), "anim": "minecart"},
	# ครัวยักษ์ ช้อนส้อมขนาดแมว ไอน้ำลอย ปลาบนจาน
	"kitchen": {"sky": [Color(0.98, 0.9, 0.82), Color(1.0, 0.97, 0.92)], "ceil": Color(0.92, 0.82, 0.72), "sun": "glow", "clouds": "none",
		"far": "cupboards", "far_col": Color(0.92, 0.76, 0.6, 0.6), "mid": "utensils", "mid_col": Color(0.8, 0.84, 0.9, 0.75),
		"ground": [Color(0.95, 0.88, 0.78), Color(0.84, 0.74, 0.62)], "haze": Color(1.0, 0.98, 0.94, 0.1), "plat": Color(0.82, 0.66, 0.5), "anim": "kitchen"},
	# กล่องของเล่น ตัวต่อ ไหมพรม หนูของเล่นกลิ้งไปมา
	"toybox": {"sky": [Color(0.86, 0.84, 1.0), Color(1.0, 0.95, 0.92)], "ceil": Color(0.8, 0.72, 0.9), "sun": "glow", "clouds": "none",
		"far": "blocks", "far_col": Color(0.9, 0.7, 0.75, 0.55), "mid": "toys", "mid_col": Color(0.95, 0.75, 0.5, 0.7),
		"ground": [Color(0.86, 0.8, 0.92), Color(0.74, 0.68, 0.84)], "haze": Color(1.0, 0.97, 1.0, 0.1), "plat": Color(0.95, 0.7, 0.55), "anim": "toybox"},
	# หน้าผาน้ำตก น้ำไหลลง ละอองหมอก รุ้งจาง
	"waterfall": {"sky": [Color(0.6, 0.84, 0.98), Color(0.92, 0.97, 0.96)], "sun": "sun", "clouds": "up",
		"far": "cliffs", "far_col": Color(0.6, 0.66, 0.62, 0.6), "mid": "ferns", "mid_col": Color(0.42, 0.68, 0.46, 0.6),
		"ground": [Color(0.66, 0.8, 0.6), Color(0.54, 0.68, 0.5)], "haze": Color(0.92, 1.0, 1.0, 0.14), "plat": Color(0.56, 0.6, 0.56), "anim": "waterfall"},
	# ป่าคอนโดแมวยักษ์ เสาฝนเล็บสูง ใบไม้ร่วง
	"cattree": {"sky": [Color(0.66, 0.86, 0.9), Color(0.95, 0.96, 0.88)], "sun": "sun", "clouds": "up",
		"far": "posts", "far_col": Color(0.82, 0.7, 0.55, 0.55), "mid": "canopy", "mid_col": Color(0.45, 0.7, 0.48, 0.6),
		"ground": [Color(0.72, 0.84, 0.6), Color(0.6, 0.72, 0.5)], "haze": Color(0.95, 1.0, 0.94, 0.12), "plat": Color(0.78, 0.62, 0.44), "anim": "cattree"},
	# ตลาดโคมกลางคืนแบบน่ารัก โทนชมพูม่วงกลางๆ ไม่มืด
	"nightmarket": {"sky": [Color(0.66, 0.62, 0.86), Color(0.98, 0.84, 0.82)], "sun": "glow", "clouds": "none",
		"far": "tents", "far_col": Color(0.85, 0.6, 0.72, 0.55), "mid": "lantern_rope", "mid_col": Color(1.0, 0.82, 0.55, 0.75),
		"ground": [Color(0.82, 0.72, 0.78), Color(0.68, 0.58, 0.66)], "haze": Color(1.0, 0.95, 0.98, 0.1), "plat": Color(0.72, 0.52, 0.62), "anim": "nightmarket"},
}

## ธีมฉากตามเมือง (ฉากพื้นฐานที่ใช้ตั้งชื่อ -> ฉากที่วาดจริง)
const TOWN_THEMES := {
	1: {"meadow": "fishmarket", "forest": "canal", "ruins": "fishmarket", "tower": "canal", "arena": "fishmarket"},
	2: {"meadow": "mine", "forest": "crystal", "ruins": "mine", "tower": "crystal", "arena": "mine"},
	3: {"meadow": "seacave", "forest": "seacave", "ruins": "shipwreck", "tower": "shipwreck", "arena": "shipwreck"},
	4: {"meadow": "dunes", "forest": "oasis", "ruins": "pyramid", "tower": "pyramid", "arena": "dunes"},
	5: {"meadow": "skislope", "forest": "frozenlake", "ruins": "icecave", "tower": "icecave", "arena": "frozenlake"},
	6: {"meadow": "crater", "forest": "lavatunnel", "ruins": "lavatunnel", "tower": "crater", "arena": "crater"},
	7: {"meadow": "rooftop", "forest": "library", "ruins": "cells", "tower": "library", "arena": "rooftop"},
	8: {"meadow": "cloudgarden", "forest": "cloudgarden", "ruins": "skytemple", "tower": "skytemple", "arena": "skytemple"},
}

## ดันพิเศษแบบเคลื่อนไหว แทนฉากบางลำดับของเมือง {เมือง: {ลำดับดัน: [ธีม, ชื่อ, คำบรรยาย]}}
const EXTRA := {
	1: {1: ["kitchen", "ครัวยักษ์ร้านซูชิ", "ครัวหลังร้านปลาดิบ หม้อเดือดปุดๆ ปลาบนจานกระดิกหางได้"], 3: ["train", "รถไฟขนปลาด่วนพิเศษ", "สู้บนหลังคารถไฟขนปลาที่วิ่งฉิว ต้นไม้ผ่านวูบๆ"]},
	2: {1: ["minecart", "อุโมงค์รถแร่ซิ่ง", "รางรถแร่คดเคี้ยว รถแร่วิ่งผ่านด้านหลังไม่หยุด"], 4: ["waterfall", "หน้าผาน้ำตกเหมียว", "น้ำตกสูงกลางหุบเขา ละอองน้ำเย็นสบาย มีรุ้งจางๆ"]},
	3: {1: ["underwater", "ก้นทะเลแมวน้ำ", "ดำลงใต้ทะเล สาหร่ายไหว ฟองลอย ฝูงปลาว่ายผ่าน ตัวลอยเบา"], 4: ["airship", "เรือเหาะโจรสลัดแมว", "สู้บนดาดฟ้าเรือเหาะเหนือทะเลเมฆ ใบพัดหมุนติ้ว"]},
	4: {1: ["train", "รถไฟข้ามทะเลทราย", "รถไฟไอน้ำวิ่งผ่านเนินทราย ต้องสู้บนหลังคาตู้"], 4: ["nightmarket", "ตลาดโคมกลางทะเลทราย", "ตลาดยามค่ำ โคมลอยขึ้นฟ้าช้าๆ"]},
	5: {1: ["toybox", "ห้องของเล่นซานตาเหมียว", "กล่องของเล่นยักษ์ หนูของเล่นกลิ้งไปมา ไหมพรมเด้งดึ๋ง"], 4: ["train", "รถไฟหิมะสายเหนือ", "รถไฟวิ่งฝ่าหิมะ ต้นสนผ่านวูบๆ"]},
	6: {1: ["minecart", "รางรถแร่ลาวา", "รถแร่ขนหินร้อนวิ่งผ่าน ตะเกียงแกว่งไปมา"], 4: ["airship", "เรือเหาะเหนือปล่องไฟ", "เรือเหาะลอยเหนือภูเขาไฟ ทะเลเมฆอุ่นๆ"]},
	7: {1: ["nightmarket", "ตลาดโคมปราสาทเงา", "ตลาดโคมน่ารักหน้าปราสาท โคมลอยวิบวับ"], 4: ["toybox", "ห้องของเล่นเจ้าชายหนู", "ห้องเก็บของเล่นในปราสาท ของเล่นวิ่งเองได้"]},
	8: {1: ["airship", "เรือเหาะสวรรค์ทอง", "เรือเหาะทองล่องเหนือทะเลเมฆ"], 3: ["waterfall", "น้ำตกสายรุ้ง", "น้ำตกจากเกาะลอยฟ้า รุ้งพาดสวยงาม"], 5: ["cattree", "ป่าคอนโดแมวยักษ์", "ป่าเสาฝนเล็บสูงเสียดฟ้า ใบไม้ร่วงพลิ้ว"]},
}

static func extra(town: int, index: int) -> Array:
	return (EXTRA.get(town, {}) as Dictionary).get(index, [])

static func has(theme: String) -> bool:
	return LOOKS.has(theme)

static func for_town(town: int, base: String) -> String:
	return str((TOWN_THEMES.get(town, {}) as Dictionary).get(base, base))

static func _soft(c: CanvasItem, pts: PackedVector2Array, color: Color) -> void:
	SoftPaint.shape(c, pts, color, 0.06)

static func _blob(c: CanvasItem, at: Vector2, rx: float, ry: float, color: Color) -> void:
	SoftPaint.oval(c, at, rx, ry, color, 0.45)

static func _box(c: CanvasItem, x: float, y: float, w: float, h: float, color: Color) -> void:
	UiStyle.fill(c, Rect2(x, y, w, h), color, minf(10.0, minf(w, h) * 0.3))

static func haze(theme: String) -> Color:
	return (LOOKS[theme] as Dictionary).get("haze", Color(1.0, 1.0, 1.0, 0.15))

static func plat(theme: String) -> Color:
	return (LOOKS[theme] as Dictionary).get("plat", Color(0.6, 0.5, 0.4))

## ฟ้า หรือผนังด้านในถ้ำ/ห้อง พร้อมเพดานมนห้อยลงมา
static func sky(c: CanvasItem, theme: String, view: Vector2, g: float, rng: RandomNumberGenerator) -> void:
	var look: Dictionary = LOOKS[theme]
	var top: Color = look["sky"][0]
	var low: Color = look["sky"][1]
	for i in 14:
		var k := float(i) / 13.0
		c.draw_rect(Rect2(0.0, g * float(i) / 14.0, view.x, g / 14.0 + 1.0), top.lerp(low, k))
	match str(look.get("sun", "sun")):
		"sun":
			_blob(c, Vector2(view.x * 0.78, g * 0.24), 60.0, 60.0, Color(1.0, 0.98, 0.85, 0.75))
		"glow":
			_blob(c, Vector2(view.x * 0.5, g * 0.5), 260.0, 140.0, Color(1.0, 0.95, 0.85, 0.25))
	match str(look.get("clouds", "none")):
		"up":
			for i in 5:
				var cc := Vector2(rng.randf_range(0.0, view.x), g * rng.randf_range(0.1, 0.4))
				for n in 3:
					_blob(c, cc + Vector2(float(n) * 40.0, rng.randf_range(-8.0, 8.0)), 50.0, 22.0, Color(1.0, 1.0, 1.0, 0.6))
		"below":
			# ทะเลเมฆอยู่ต่ำกว่าเรา
			var x := -40.0
			while x < view.x + 40.0:
				_blob(c, Vector2(x, g * 0.92), 90.0, 40.0, Color(1.0, 1.0, 1.0, 0.75))
				x += 110.0
			for i in 3:
				_blob(c, Vector2(rng.randf_range(0.0, view.x), g * rng.randf_range(0.15, 0.4)), 70.0, 24.0, Color(1.0, 1.0, 1.0, 0.5))
	if look.has("ceil"):
		var cc: Color = look["ceil"]
		c.draw_rect(Rect2(0.0, 0.0, view.x, g * 0.1), cc)
		var x2 := 0.0
		while x2 < view.x + 60.0:
			var drop := rng.randf_range(30.0, 90.0)
			_blob(c, Vector2(x2, g * 0.1), rng.randf_range(40.0, 70.0), drop * 0.6, cc)
			# หินย้อยปลายมน
			if rng.randf() < 0.5:
				_soft(c, PackedVector2Array([Vector2(x2 - 14.0, g * 0.1), Vector2(x2 + 14.0, g * 0.1), Vector2(x2 + 4.0, g * 0.1 + drop), Vector2(x2 - 4.0, g * 0.1 + drop)]), cc)
				_blob(c, Vector2(x2, g * 0.1 + drop), 6.0, 6.0, cc)
			x2 += rng.randf_range(60.0, 110.0)

## ฉากไกล
static func far(c: CanvasItem, theme: String, g: float, span: float, rng: RandomNumberGenerator) -> void:
	var look: Dictionary = LOOKS[theme]
	var col: Color = look["far_col"]
	var x := -span
	match str(look["far"]):
		"stalls":
			while x < span:
				_box(c, x, g - 110.0, 120.0, 110.0, Color(0.95, 0.9, 0.82, col.a))
				# กันสาดลายทาง ขอบโค้ง
				for s in 4:
					_blob(c, Vector2(x + 15.0 + float(s) * 30.0, g - 112.0), 16.0, 14.0, col if s % 2 == 0 else Color(1.0, 1.0, 1.0, col.a))
				x += 170.0
		"houses":
			while x < span:
				var h := rng.randf_range(110.0, 170.0)
				_box(c, x, g - h, 100.0, h, col)
				_blob(c, Vector2(x + 50.0, g - h), 58.0, 30.0, Color(0.85, 0.55, 0.45, col.a))
				_blob(c, Vector2(x + 50.0, g - h * 0.55), 14.0, 18.0, Color(1.0, 0.95, 0.75, col.a))
				x += 140.0
		"beams":
			while x < span:
				_box(c, x, g - 220.0, 22.0, 220.0, col)
				_box(c, x + 150.0, g - 220.0, 22.0, 220.0, col)
				_box(c, x - 10.0, g - 236.0, 192.0, 22.0, col)
				x += 260.0
		"crystals", "crystals_big":
			while x < span:
				for n in 3:
					var h := rng.randf_range(80.0, 170.0)
					var cx := x + float(n) * 26.0
					_soft(c, PackedVector2Array([Vector2(cx - 18.0, g), Vector2(cx + 18.0, g), Vector2(cx + 10.0, g - h), Vector2(cx - 10.0, g - h)]), col)
					_blob(c, Vector2(cx, g - h), 11.0, 11.0, col)
				x += rng.randf_range(160.0, 240.0)
		"sea":
			c.draw_rect(Rect2(-span, g - 70.0, span * 2.0, 70.0), col)
			while x < span:
				_blob(c, Vector2(x, g - 66.0), 34.0, 6.0, Color(1.0, 1.0, 1.0, 0.45))
				x += 120.0
		"dunes", "snowhills":
			var pts := PackedVector2Array([Vector2(-span, g)])
			while x < span:
				pts.append(Vector2(x, g - rng.randf_range(50.0, 140.0)))
				x += 220.0
			pts.append(Vector2(span, g))
			_soft(c, pts, col)
		"pyramids":
			while x < span:
				var w := rng.randf_range(160.0, 260.0)
				_soft(c, PackedVector2Array([Vector2(x, g), Vector2(x + w, g), Vector2(x + w * 0.56, g - w * 0.62), Vector2(x + w * 0.44, g - w * 0.62)]), col)
				_blob(c, Vector2(x + w * 0.5, g - w * 0.62), w * 0.07, w * 0.05, col)
				x += w + rng.randf_range(80.0, 160.0)
		"icebergs":
			while x < span:
				_blob(c, Vector2(x, g - 40.0), rng.randf_range(70.0, 120.0), rng.randf_range(60.0, 110.0), col)
				x += rng.randf_range(160.0, 240.0)
		"volcano":
			_soft(c, PackedVector2Array([Vector2(-480.0, g), Vector2(480.0, g), Vector2(120.0, g - 280.0), Vector2(-120.0, g - 280.0)]), col)
			_blob(c, Vector2(0.0, g - 282.0), 120.0, 24.0, col)
			_blob(c, Vector2(0.0, g - 300.0), 90.0, 40.0, Color(1.0, 0.65, 0.4, 0.4))
			for i in 4:
				_blob(c, Vector2(rng.randf_range(-60.0, 60.0), g - 340.0 - float(i) * 40.0), 40.0 + float(i) * 10.0, 26.0, Color(0.85, 0.8, 0.8, 0.35))
		"lavaflow":
			c.draw_rect(Rect2(-span, g - 30.0, span * 2.0, 30.0), col)
			while x < span:
				_blob(c, Vector2(x, g - 30.0), 50.0, 14.0, Color(1.0, 0.85, 0.5, 0.5))
				x += 150.0
		"shelves":
			while x < span:
				_box(c, x, g - 260.0, 150.0, 260.0, col)
				for r in 4:
					var y := g - 240.0 + float(r) * 62.0
					var bx := x + 10.0
					while bx < x + 135.0:
						var bw := rng.randf_range(10.0, 18.0)
						_box(c, bx, y, bw, 46.0, [Color(0.95, 0.6, 0.55, 0.6), Color(0.6, 0.75, 0.95, 0.6), Color(0.98, 0.88, 0.6, 0.6), Color(0.7, 0.88, 0.7, 0.6)][rng.randi() % 4])
						bx += bw + 3.0
				x += 190.0
		"windows":
			c.draw_rect(Rect2(-span, g - 260.0, span * 2.0, 260.0), Color(col, col.a * 0.6))
			while x < span:
				_box(c, x, g - 200.0, 60.0, 90.0, Color(0.95, 0.92, 1.0, 0.6))
				_blob(c, Vector2(x + 30.0, g - 200.0), 30.0, 26.0, Color(0.95, 0.92, 1.0, 0.6))
				x += 220.0
		"roofs":
			while x < span:
				var h := rng.randf_range(120.0, 220.0)
				_box(c, x, g - h, 110.0, h, col)
				_blob(c, Vector2(x + 55.0, g - h), 62.0, 34.0, Color(col.darkened(0.15), col.a))
				if rng.randf() < 0.5:
					_box(c, x + 75.0, g - h - 50.0, 18.0, 40.0, col)
				x += 150.0
		"islands":
			while x < span:
				var y := g - rng.randf_range(120.0, 230.0)
				_blob(c, Vector2(x, y), 90.0, 26.0, Color(0.7, 0.85, 0.55, col.a))
				_blob(c, Vector2(x, y + 22.0), 60.0, 30.0, Color(0.85, 0.75, 0.6, col.a))
				x += rng.randf_range(220.0, 320.0)
		"columns":
			_blob(c, Vector2(0.0, g - 300.0), 200.0, 90.0, col)
			while x < span:
				_box(c, x, g - 230.0, 34.0, 230.0, col)
				_blob(c, Vector2(x + 17.0, g - 232.0), 26.0, 12.0, col)
				x += 140.0
		"none":
			pass
		"reef":
			while x < span:
				_blob(c, Vector2(x, g - 60.0), 110.0, 70.0, col)
				_blob(c, Vector2(x + 70.0, g - 110.0), 50.0, 60.0, Color(0.9, 0.6, 0.65, col.a))
				x += rng.randf_range(200.0, 280.0)
		"cupboards":
			while x < span:
				_box(c, x, g - 260.0, 150.0, 120.0, col)
				_box(c, x + 8.0, g - 252.0, 64.0, 104.0, Color(1.0, 0.92, 0.8, col.a))
				_box(c, x + 78.0, g - 252.0, 64.0, 104.0, Color(1.0, 0.92, 0.8, col.a))
				_blob(c, Vector2(x + 75.0, g - 200.0), 6.0, 6.0, Color(0.7, 0.5, 0.35, col.a))
				_box(c, x - 10.0, g - 90.0, 170.0, 90.0, Color(0.85, 0.7, 0.55, col.a))
				x += 220.0
		"blocks":
			while x < span:
				var h := rng.randf_range(60.0, 150.0)
				var cols := [Color(1.0, 0.6, 0.6, col.a), Color(0.6, 0.8, 1.0, col.a), Color(1.0, 0.88, 0.5, col.a), Color(0.65, 0.9, 0.65, col.a)]
				_box(c, x, g - h, 80.0, h, cols[int(absf(x)) % 4])
				_box(c, x + 10.0, g - h - 60.0, 60.0, 60.0, cols[(int(absf(x)) + 1) % 4])
				x += rng.randf_range(130.0, 190.0)
		"cliffs":
			var pts := PackedVector2Array([Vector2(-span, g)])
			while x < span:
				pts.append(Vector2(x, g - rng.randf_range(260.0, 360.0)))
				x += 160.0
			pts.append(Vector2(span, g))
			_soft(c, pts, col)
		"posts":
			while x < span:
				_box(c, x, g - 380.0, 46.0, 380.0, col)
				for k in 5:
					_box(c, x - 6.0, g - 360.0 + float(k) * 70.0, 58.0, 12.0, Color(0.95, 0.88, 0.75, col.a))
				_blob(c, Vector2(x + 23.0, g - 390.0), 70.0, 22.0, Color(0.95, 0.75, 0.8, col.a))
				x += rng.randf_range(240.0, 320.0)
		"tents":
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x, g), Vector2(x + 140.0, g), Vector2(x + 140.0, g - 90.0), Vector2(x + 70.0, g - 150.0), Vector2(x, g - 90.0)]), col)
				_blob(c, Vector2(x + 70.0, g - 150.0), 10.0, 10.0, Color(1.0, 0.9, 0.6, col.a))
				x += rng.randf_range(190.0, 250.0)
		_:
			while x < span:
				_blob(c, Vector2(x, g - 100.0), 90.0, 100.0, col)
				x += 140.0

## ฉากกลาง
static func mid(c: CanvasItem, theme: String, g: float, span: float, rng: RandomNumberGenerator) -> void:
	var look: Dictionary = LOOKS[theme]
	var col: Color = look["mid_col"]
	var x := -span
	match str(look["mid"]):
		"barrels":
			while x < span:
				_box(c, x, g - 60.0, 48.0, 60.0, col)
				_blob(c, Vector2(x + 24.0, g - 60.0), 24.0, 8.0, Color(col.lightened(0.2), col.a))
				# ป้ายปลา
				if rng.randf() < 0.5:
					PaperFront.fish_sign(c, Vector2(x + 90.0, g - 110.0), 1.0, Color(0.55, 0.75, 0.95, 0.7))
				x += rng.randf_range(180.0, 280.0)
		"boats":
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x - 70.0, g - 40.0), Vector2(x + 70.0, g - 40.0), Vector2(x + 50.0, g - 10.0), Vector2(x - 50.0, g - 10.0)]), col)
				_box(c, x - 4.0, g - 140.0, 8.0, 100.0, Color(0.6, 0.45, 0.32, 0.6))
				_blob(c, Vector2(x + 26.0, g - 100.0), 26.0, 36.0, Color(1.0, 1.0, 1.0, 0.6))
				x += rng.randf_range(260.0, 360.0)
		"lanterns":
			while x < span:
				c.draw_line(Vector2(x, 0.0), Vector2(x, g - 220.0), Color(0.45, 0.35, 0.3, 0.5), 3.0, true)
				_blob(c, Vector2(x, g - 205.0), 14.0, 18.0, col)
				_blob(c, Vector2(x, g - 205.0), 44.0, 44.0, Color(col, 0.2))
				x += rng.randf_range(200.0, 300.0)
		"crystals_big", "crystals":
			while x < span:
				var h := rng.randf_range(120.0, 220.0)
				_soft(c, PackedVector2Array([Vector2(x - 26.0, g), Vector2(x + 26.0, g), Vector2(x + 14.0, g - h), Vector2(x - 14.0, g - h)]), col)
				_blob(c, Vector2(x, g - h), 15.0, 15.0, col)
				_blob(c, Vector2(x - 6.0, g - h * 0.6), 5.0, 18.0, Color(1.0, 1.0, 1.0, 0.45))
				x += rng.randf_range(220.0, 340.0)
		"wreck":
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x - 120.0, g), Vector2(x + 140.0, g), Vector2(x + 100.0, g - 90.0), Vector2(x - 90.0, g - 120.0)]), col)
				_box(c, x - 6.0, g - 260.0, 12.0, 160.0, col)
				_blob(c, Vector2(x + 30.0, g - 200.0), 32.0, 46.0, Color(1.0, 1.0, 0.96, 0.5))
				x += rng.randf_range(420.0, 560.0)
		"rocks":
			while x < span:
				_blob(c, Vector2(x, g - 30.0), rng.randf_range(40.0, 80.0), rng.randf_range(30.0, 60.0), col)
				x += rng.randf_range(140.0, 240.0)
		"cactus":
			while x < span:
				var h := rng.randf_range(90.0, 150.0)
				_box(c, x - 14.0, g - h, 28.0, h, col)
				_blob(c, Vector2(x, g - h), 14.0, 14.0, col)
				_box(c, x + 14.0, g - h * 0.6, 26.0, 14.0, col)
				_box(c, x + 30.0, g - h * 0.85, 14.0, h * 0.3, col)
				_blob(c, Vector2(x, g - h - 10.0), 8.0, 8.0, Color(1.0, 0.7, 0.8, 0.8))
				x += rng.randf_range(260.0, 380.0)
		"pillars":
			while x < span:
				var h := rng.randf_range(160.0, 260.0)
				_box(c, x - 22.0, g - h, 44.0, h, col)
				_blob(c, Vector2(x, g - h), 34.0, 14.0, col)
				x += rng.randf_range(240.0, 340.0)
		"palms":
			while x < span:
				_soft(c, PackedVector2Array([Vector2(x - 10.0, g), Vector2(x + 10.0, g), Vector2(x + 24.0, g - 200.0), Vector2(x + 12.0, g - 200.0)]), Color(0.7, 0.55, 0.4, 0.6))
				for a in 5:
					var ang := -PI * 0.9 + PI * 0.8 * float(a) / 4.0
					_blob(c, Vector2(x + 18.0, g - 205.0) + Vector2(cos(ang), sin(ang)) * 45.0, 46.0, 14.0, col)
				x += rng.randf_range(280.0, 380.0)
		"snowpines":
			while x < span:
				_box(c, x - 6.0, g - 40.0, 12.0, 40.0, Color(0.55, 0.42, 0.32, 0.6))
				for r in 3:
					_blob(c, Vector2(x, g - 60.0 - float(r) * 40.0), 50.0 - float(r) * 12.0, 30.0, col)
					_blob(c, Vector2(x, g - 74.0 - float(r) * 40.0), 40.0 - float(r) * 10.0, 12.0, Color(1.0, 1.0, 1.0, 0.75))
				x += rng.randf_range(180.0, 280.0)
		"lavapools":
			while x < span:
				_blob(c, Vector2(x, g - 10.0), 70.0, 16.0, col)
				_blob(c, Vector2(x, g - 40.0), 90.0, 60.0, Color(col, 0.15))
				x += rng.randf_range(260.0, 380.0)
		"candles":
			while x < span:
				_box(c, x - 8.0, g - 150.0, 16.0, 60.0, Color(1.0, 0.97, 0.9, 0.7))
				_blob(c, Vector2(x, g - 160.0), 8.0, 12.0, col)
				_blob(c, Vector2(x, g - 160.0), 34.0, 34.0, Color(col, 0.2))
				_box(c, x - 20.0, g - 92.0, 40.0, 92.0, Color(0.58, 0.48, 0.6, 0.55))
				x += rng.randf_range(240.0, 340.0)
		"bars":
			while x < span:
				for b in 5:
					_box(c, x + float(b) * 22.0, g - 200.0, 10.0, 200.0, col)
				_blob(c, Vector2(x + 50.0, g - 200.0), 60.0, 16.0, col)
				x += rng.randf_range(320.0, 440.0)
		"flags":
			while x < span:
				_box(c, x - 5.0, g - 280.0, 10.0, 280.0, Color(0.5, 0.42, 0.55, 0.6))
				_soft(c, PackedVector2Array([Vector2(x + 5.0, g - 280.0), Vector2(x + 80.0, g - 262.0), Vector2(x + 5.0, g - 230.0)]), col)
				x += rng.randf_range(300.0, 420.0)
		"flowers":
			while x < span:
				var cc := Vector2(x, g - rng.randf_range(20.0, 60.0))
				for p in 5:
					var ang := TAU * float(p) / 5.0
					_blob(c, cc + Vector2(cos(ang), sin(ang)) * 14.0, 11.0, 11.0, col)
				_blob(c, cc, 8.0, 8.0, Color(1.0, 0.92, 0.55, 0.8))
				x += rng.randf_range(90.0, 160.0)
		"carriages":
			# ตู้รถไฟเรียงต่อกัน หน้าต่างมีแมวโผล่ ล้อกลม
			while x < span:
				_box(c, x, g - 120.0, 260.0, 120.0, col)
				_box(c, x - 6.0, g - 132.0, 272.0, 18.0, Color(0.98, 0.92, 0.85, col.a))
				for w in 4:
					_box(c, x + 18.0 + float(w) * 60.0, g - 100.0, 40.0, 36.0, Color(0.85, 0.94, 1.0, col.a))
				x += 290.0
		"kelp_still":
			while x < span:
				_blob(c, Vector2(x, g - 20.0), 40.0, 26.0, Color(0.95, 0.65, 0.6, col.a))
				x += rng.randf_range(140.0, 220.0)
		"rigging":
			while x < span:
				_box(c, x, g - 300.0, 16.0, 300.0, col)
				_soft(c, PackedVector2Array([Vector2(x + 16.0, g - 290.0), Vector2(x + 120.0, g - 200.0), Vector2(x + 16.0, g - 120.0)]), Color(1.0, 0.97, 0.9, col.a))
				x += rng.randf_range(300.0, 380.0)
		"rails":
			c.draw_rect(Rect2(-span, g - 34.0, span * 2.0, 6.0), col)
			c.draw_rect(Rect2(-span, g - 18.0, span * 2.0, 6.0), col)
			while x < span:
				_box(c, x, g - 38.0, 14.0, 30.0, Color(0.62, 0.46, 0.34, col.a))
				x += 40.0
		"utensils":
			while x < span:
				var k := int(absf(x / 50.0)) % 3
				if k == 0:
					_box(c, x, g - 220.0, 18.0, 220.0, col)
					_blob(c, Vector2(x + 9.0, g - 240.0), 34.0, 46.0, col)
				elif k == 1:
					_box(c, x, g - 200.0, 16.0, 200.0, col)
					for t in 3:
						_box(c, x - 18.0 + float(t) * 18.0, g - 260.0, 10.0, 70.0, col)
				else:
					_blob(c, Vector2(x, g - 30.0), 110.0, 26.0, Color(1.0, 1.0, 1.0, col.a))
					_blob(c, Vector2(x, g - 52.0), 60.0, 22.0, Color(0.6, 0.78, 0.95, col.a))
				x += rng.randf_range(170.0, 240.0)
		"toys":
			while x < span:
				_blob(c, Vector2(x, g - 40.0), 40.0, 40.0, Color(1.0, 0.6, 0.7, col.a))
				c.draw_arc(Vector2(x, g - 40.0), 26.0, 0.4, 2.6, 12, Color(1.0, 1.0, 1.0, col.a), 3.0, true)
				_box(c, x + 70.0, g - 70.0, 60.0, 70.0, Color(0.6, 0.8, 1.0, col.a))
				x += rng.randf_range(200.0, 280.0)
		"ferns":
			while x < span:
				_blob(c, Vector2(x, g - 30.0), 70.0, 34.0, col)
				x += rng.randf_range(110.0, 170.0)
		"canopy":
			while x < span:
				_blob(c, Vector2(x, g - 300.0), 130.0, 70.0, col)
				x += rng.randf_range(180.0, 240.0)
		"lantern_rope":
			while x < span:
				for k in 6:
					var px := x + float(k) * 40.0
					var py := g - 230.0 + sin(float(k) / 5.0 * PI) * 30.0
					_blob(c, Vector2(px, py), 14.0, 18.0, Color(1.0, 0.75, 0.5, col.a) if k % 2 == 0 else Color(1.0, 0.6, 0.7, col.a))
				x += 280.0
		_:
			while x < span:
				_blob(c, Vector2(x, g - 40.0), 60.0, 40.0, col)
				x += 180.0

## ชั้นเคลื่อนไหวของฉากพิเศษ วาดทุกเฟรมบนจอ (cam คือการเลื่อนกล้อง ใช้ทำพารัลแลกซ์)
static func has_anim(theme: String) -> bool:
	return LOOKS.has(theme) and (LOOKS[theme] as Dictionary).has("anim")

static func gravity_k(theme: String) -> float:
	return 0.62 if theme == "underwater" else 1.0

static func anim(c: CanvasItem, theme: String, t: float, view: Vector2, g: float, cam: float) -> void:
	var w := view.x
	match str((LOOKS[theme] as Dictionary).get("anim", "")):
		"train":
			# เนินไกลเลื่อนช้า ต้นไม้ใกล้เลื่อนเร็ว เสาไฟผ่านวูบๆ
			var off1 := fposmod(t * 120.0, 400.0)
			var x := -off1 - 200.0
			while x < w + 400.0:
				_blob(c, Vector2(x, g - 150.0), 220.0, 90.0, Color(0.55, 0.75, 0.55, 0.5))
				x += 400.0
			var off2 := fposmod(t * 520.0, 260.0)
			x = -off2 - 100.0
			while x < w + 260.0:
				_blob(c, Vector2(x, g - 170.0), 50.0, 60.0, Color(0.38, 0.6, 0.42, 0.6))
				c.draw_rect(Rect2(x - 6.0, g - 120.0, 12.0, 60.0), Color(0.5, 0.38, 0.3, 0.6))
				x += 260.0
			var off3 := fposmod(t * 1100.0, 700.0)
			x = -off3
			while x < w + 700.0:
				c.draw_rect(Rect2(x, g - 260.0, 10.0, 220.0), Color(0.45, 0.4, 0.42, 0.5))
				_blob(c, Vector2(x + 5.0, g - 262.0), 16.0, 8.0, Color(0.45, 0.4, 0.42, 0.5))
				x += 700.0
			# ล้อหมุนใต้ตู้ (ระดับพื้น)
			var shake := sin(t * 30.0) * 2.0
			var wx := fposmod(-cam * 0.4, 145.0) - 145.0
			while wx < w + 145.0:
				c.draw_circle(Vector2(wx, g + 6.0 + shake), 22.0, Color(0.32, 0.3, 0.34, 0.8))
				var a := t * 14.0
				c.draw_line(Vector2(wx, g + 6.0 + shake), Vector2(wx + cos(a) * 18.0, g + 6.0 + shake + sin(a) * 18.0), Color(0.85, 0.8, 0.75, 0.8), 4.0, true)
				wx += 145.0
			# ลมพัดเส้นโค้งปลายมน
			for i in 6:
				var ly := g * (0.2 + float(i) * 0.1)
				var lx := w - fposmod(t * 900.0 + float(i) * 230.0, w + 300.0)
				c.draw_line(Vector2(lx, ly), Vector2(lx + 80.0, ly), Color(1.0, 1.0, 1.0, 0.35), 4.0, true)
		"underwater":
			# แสงคลื่นนุ่มด้านบน
			for i in 7:
				var cx := fposmod(float(i) * 260.0 + t * 30.0 - cam * 0.1, w + 300.0) - 150.0
				_blob(c, Vector2(cx, g * 0.18 + sin(t + float(i)) * 10.0), 90.0, 20.0, Color(0.85, 1.0, 1.0, 0.18))
			# สาหร่ายไหว
			var kx := fposmod(-cam * 0.45, 170.0) - 170.0
			var n := 0
			while kx < w + 170.0:
				var prev := Vector2(kx, g)
				for k in 8:
					var y := g - float(k + 1) * 26.0
					var p := Vector2(kx + sin(t * 1.6 + float(n) + float(k) * 0.5) * float(k) * 3.0, y)
					c.draw_line(prev, p, Color(0.3, 0.62, 0.45, 0.75), 10.0 - float(k) * 0.8, true)
					prev = p
				kx += 170.0
				n += 1
			# ฟองลอยขึ้น
			for i in 18:
				var bx := fposmod(float(i) * 97.0 - cam * 0.3, w)
				var by := g - fposmod(t * (50.0 + float(i % 5) * 12.0) + float(i) * 60.0, g)
				c.draw_arc(Vector2(bx + sin(t * 2.0 + float(i)) * 6.0, by), 5.0 + float(i % 3) * 2.0, 0.0, TAU, 12, Color(1.0, 1.0, 1.0, 0.55), 2.0, true)
			# ฝูงปลาว่ายผ่าน
			for s in 2:
				var fx := w + 200.0 - fposmod(t * (90.0 + float(s) * 40.0) + float(s) * 500.0, w + 500.0)
				var fy := g * (0.35 + float(s) * 0.2)
				for k in 6:
					var p := Vector2(fx + float(k % 3) * 34.0, fy + float(k / 3) * 22.0 + sin(t * 3.0 + float(k)) * 4.0)
					_blob(c, p, 14.0, 8.0, Color(1.0, 0.75, 0.5, 0.7) if s == 0 else Color(0.75, 0.85, 1.0, 0.7))
					c.draw_colored_polygon(PackedVector2Array([p + Vector2(12.0, 0.0), p + Vector2(22.0, -7.0), p + Vector2(22.0, 7.0)]), Color(1.0, 0.75, 0.5, 0.7) if s == 0 else Color(0.75, 0.85, 1.0, 0.7))
		"airship":
			# ทะเลเมฆด้านล่างเลื่อน กับก้อนเมฆไกล
			var off := fposmod(t * 60.0, 220.0)
			var x := -off - 110.0
			while x < w + 220.0:
				_blob(c, Vector2(x, g + 30.0), 130.0, 50.0, Color(1.0, 1.0, 1.0, 0.85))
				x += 220.0
			for i in 4:
				var cx := w + 200.0 - fposmod(t * 40.0 + float(i) * 330.0, w + 400.0)
				_blob(c, Vector2(cx, g * (0.2 + float(i) * 0.12)), 80.0, 26.0, Color(1.0, 1.0, 1.0, 0.6))
			# บอลลูนกับใบพัดหมุน
			var bx := w * 0.5 - cam * 0.2
			_blob(c, Vector2(bx, g * 0.16), 260.0, 80.0, Color(1.0, 0.75, 0.6, 0.55))
			c.draw_line(Vector2(bx - 200.0, g * 0.22), Vector2(bx - 160.0, g - 40.0), Color(0.55, 0.42, 0.32, 0.5), 3.0, true)
			c.draw_line(Vector2(bx + 200.0, g * 0.22), Vector2(bx + 160.0, g - 40.0), Color(0.55, 0.42, 0.32, 0.5), 3.0, true)
			for side in [-1.0, 1.0]:
				var pc := Vector2(bx + side * 300.0, g * 0.3)
				for k in 3:
					var a := t * 12.0 + float(k) * TAU / 3.0
					_blob(c, pc + Vector2(cos(a), sin(a)) * 20.0, 22.0, 8.0, Color(0.85, 0.8, 0.72, 0.6))
				c.draw_circle(pc, 8.0, Color(0.6, 0.5, 0.4, 0.7))
		"minecart":
			# รถแร่วิ่งผ่านด้านหลัง
			for i in 2:
				var cx := fposmod(t * (260.0 + float(i) * 80.0) + float(i) * 600.0, w + 500.0) - 250.0
				var cy := g - 70.0
				_box(c, cx, cy - 40.0, 90.0, 40.0, Color(0.55, 0.45, 0.42, 0.75))
				_blob(c, Vector2(cx + 45.0, cy - 44.0), 40.0, 14.0, Color(0.95, 0.8, 0.45, 0.8))
				for k in 2:
					c.draw_circle(Vector2(cx + 20.0 + float(k) * 50.0, cy + 2.0), 10.0, Color(0.35, 0.32, 0.34, 0.8))
			# ตะเกียงแกว่ง
			var lx := fposmod(-cam * 0.5, 320.0) - 160.0
			while lx < w + 320.0:
				var sw := sin(t * 2.0 + lx * 0.01) * 0.3
				var top := Vector2(lx, g * 0.12)
				var bob := top + Vector2(sin(sw) * 60.0, cos(sw) * 60.0)
				c.draw_line(top, bob, Color(0.4, 0.34, 0.3, 0.6), 2.0, true)
				_blob(c, bob, 26.0, 26.0, Color(1.0, 0.85, 0.5, 0.25))
				_blob(c, bob, 10.0, 12.0, Color(1.0, 0.85, 0.5, 0.9))
				lx += 320.0
		"kitchen":
			# ไอน้ำจากหม้อ ลอยเป็นก้อนกลม
			var px := fposmod(-cam * 0.4, 420.0) - 200.0
			while px < w + 420.0:
				_box(c, px - 60.0, g - 110.0, 120.0, 80.0, Color(0.72, 0.74, 0.8, 0.7))
				_blob(c, Vector2(px, g - 112.0), 66.0, 12.0, Color(0.6, 0.62, 0.68, 0.7))
				for k in 4:
					var lift := fposmod(t * 40.0 + float(k) * 30.0, 120.0)
					_blob(c, Vector2(px + sin(t + float(k)) * 14.0, g - 120.0 - lift), 18.0 + lift * 0.15, 14.0 + lift * 0.1, Color(1.0, 1.0, 1.0, 0.45 * (1.0 - lift / 120.0)))
				px += 420.0
			# ปลาบนจานกระดิกหาง
			var fx := fposmod(-cam * 0.4 + 210.0, 420.0) - 200.0
			while fx < w + 420.0:
				_blob(c, Vector2(fx, g - 34.0), 70.0, 16.0, Color(1.0, 1.0, 1.0, 0.85))
				_blob(c, Vector2(fx, g - 46.0), 38.0, 14.0, Color(0.6, 0.75, 0.9, 0.85))
				var tail := sin(t * 5.0) * 6.0
				c.draw_colored_polygon(PackedVector2Array([Vector2(fx + 34.0, g - 46.0), Vector2(fx + 54.0, g - 58.0 + tail), Vector2(fx + 54.0, g - 34.0 + tail)]), Color(0.6, 0.75, 0.9, 0.85))
				fx += 420.0
		"toybox":
			# หนูของเล่นกลิ้งไปมา กับไหมพรมเด้ง
			for i in 3:
				var span2 := w + 200.0
				var mx := fposmod(t * (120.0 + float(i) * 50.0) + float(i) * 300.0, span2 * 2.0)
				var dir := 1.0
				if mx > span2:
					mx = span2 * 2.0 - mx
					dir = -1.0
				mx -= 100.0
				var my := g - 20.0
				_blob(c, Vector2(mx, my), 24.0, 16.0, Color(0.75, 0.75, 0.82, 0.85))
				_blob(c, Vector2(mx + dir * 18.0, my - 10.0), 8.0, 8.0, Color(1.0, 0.75, 0.82, 0.85))
				c.draw_circle(Vector2(mx - 10.0, my + 14.0), 5.0, Color(0.4, 0.4, 0.45, 0.8))
				c.draw_circle(Vector2(mx + 10.0, my + 14.0), 5.0, Color(0.4, 0.4, 0.45, 0.8))
			for i in 4:
				var yx := fposmod(float(i) * 330.0 - cam * 0.3, w + 200.0) - 100.0
				var yy := g - 40.0 - absf(sin(t * 2.5 + float(i))) * 90.0
				_blob(c, Vector2(yx, yy), 24.0, 24.0, [Color(1.0, 0.6, 0.65, 0.8), Color(0.6, 0.8, 1.0, 0.8), Color(1.0, 0.88, 0.5, 0.8), Color(0.7, 0.9, 0.65, 0.8)][i])
		"waterfall":
			# สายน้ำตกไหลลง เส้นขาวเลื่อนลง ละอองหมอก รุ้งจาง
			var cx := w * 0.55 - cam * 0.15
			c.draw_rect(Rect2(cx - 80.0, 0.0, 160.0, g), Color(0.75, 0.9, 1.0, 0.55))
			for k in 8:
				var lx := cx - 70.0 + float(k) * 20.0
				var ly := fposmod(t * 300.0 + float(k) * 47.0, g + 80.0) - 80.0
				c.draw_line(Vector2(lx, ly), Vector2(lx, ly + 70.0), Color(1.0, 1.0, 1.0, 0.7), 5.0, true)
			for k in 6:
				var a := t * 0.8 + float(k)
				_blob(c, Vector2(cx + sin(a) * 120.0, g - 20.0 - fposmod(t * 30.0 + float(k) * 15.0, 60.0)), 50.0, 24.0, Color(1.0, 1.0, 1.0, 0.35))
			var rc := Vector2(cx + 60.0, g)
			var bands := [Color(1.0, 0.6, 0.6, 0.18), Color(1.0, 0.85, 0.5, 0.18), Color(0.6, 0.9, 0.6, 0.18), Color(0.6, 0.75, 1.0, 0.18)]
			for b in 4:
				c.draw_arc(rc, 220.0 - float(b) * 14.0, PI, TAU, 40, bands[b], 12.0, true)
		"cattree":
			# ใบไม้ร่วงหมุนลงช้าๆ
			for i in 20:
				var lx := fposmod(float(i) * 83.0 - cam * 0.35 + sin(t + float(i)) * 30.0, w)
				var ly := fposmod(t * (40.0 + float(i % 4) * 10.0) + float(i) * 47.0, g)
				var a := t * 2.0 + float(i)
				_blob(c, Vector2(lx, ly), 10.0, 5.0 + absf(sin(a)) * 3.0, Color(0.95, 0.7, 0.4, 0.7) if i % 3 == 0 else Color(0.5, 0.75, 0.45, 0.7))
		"nightmarket":
			# โคมลอยขึ้นช้าๆ กับแสงโคมกระพริบนุ่ม
			for i in 12:
				var lx := fposmod(float(i) * 140.0 - cam * 0.25, w + 100.0) - 50.0
				var ly := g * 0.9 - fposmod(t * 22.0 + float(i) * 70.0, g * 0.8)
				_blob(c, Vector2(lx + sin(t + float(i)) * 10.0, ly), 22.0, 22.0, Color(1.0, 0.8, 0.5, 0.18))
				_blob(c, Vector2(lx + sin(t + float(i)) * 10.0, ly), 9.0, 11.0, Color(1.0, 0.75, 0.5, 0.8))

static func ground(theme: String) -> Array:
	return (LOOKS[theme] as Dictionary)["ground"]
