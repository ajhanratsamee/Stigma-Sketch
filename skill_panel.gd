class_name SkillPanel
extends Node2D
## แผงสกิลของหน้าฝึกซ้อม แยกแท็บตามคลาส แตะการ์ดเพื่อใส่ลงช่องว่างแรก แตะอีกครั้งเพื่อถอด

signal toggled(id: String)
signal closed

const SKILLS := {
	"sword": [
		{"id": "storm_up", "name": "Paw-some Storm", "text": "ปัดดาบขึ้น ส่งพายุแดงหมุนพุ่งไปข้างหน้า", "slot": "พายุ"},
		{"id": "ground_wave", "name": "Red Purr-wave", "text": "ปักดาบลงพื้น เกิดคลื่นแดงพุ่งขึ้นฟ้า", "slot": "คลื่น"},
		{"id": "slash_slide", "name": "Slidey Scratch x5", "text": "ฟันไปข้างหน้า 5 ครั้ง ไถลตัวตามไปด้วย", "slot": "ฟัน"},
		{"id": "pound_waves", "name": "Thump Thump Waves", "text": "ทุบดาบลงพื้น เกิดคลื่นสั้น 3 ลูกไล่ไปข้างหน้า", "slot": "ทุบ"},
		{"id": "ground_crack", "class": "SWORD KNIGHT", "name": "Clawquake", "text": "ปักดาบลงพื้น จอสั่น พื้นดินประทุสีแดงไล่ไปข้างหน้า", "slot": "ประทุ"},
		{"id": "lord_hyper", "class": "WARLORD", "name": "HYPER SKILL", "text": "ออร่าแดงเลือด หายวับ ฟันคลั่งทั่วจอ ฟาดสุดท้ายจนจอขาดครึ่ง", "slot": "WAR"},
		{"id": "sword_row", "class": "MAGIC KNIGHT", "name": "Ten Kitty Blades", "text": "เรียกดาบใบกว้างสีแดงส้ม ผุดจากดินทีละเล่มจนครบ 10 เล่ม", "slot": "ดาบ"},
		{"id": "sky_swords", "class": "DARK KNIGHT", "name": "Meow-teor Swords", "text": "เรียกดาบยักษ์ดำแดงเสียบจากฟ้าลงพื้นทีละเล่ม", "slot": "ดาบฟ้า"},
		{"id": "abyss_hyper", "class": "ABYSS", "name": "HYPER SKILL", "text": "ขอบฟ้าเหตุการณ์ หลุมดำที่ไม่มีสิ่งใดหนีรอด", "slot": "ABYSS"},
		{"id": "divine_blade", "class": "DIVINE KNIGHT", "name": "Lumi-Paw Blade", "text": "เรียกใบดาบขนาดใหญ่ จากด้านหลังพุ่งไปด้านหน้า", "slot": "แสง"},
		{"id": "godhood_hyper", "class": "GODHOOD", "name": "HYPER SKILL", "text": "สะบัดมือปัดลง ลอยกลางฟ้า ใบดาบมหึมาค่อยๆ ไหลทะลุเมฆลงมา", "slot": "GOD"},
		{"id": "magus_hyper", "class": "MAGUS", "name": "HYPER SKILL", "text": "เสกลูกไฟใหญ่ 10 ลูก ตกลงมาระเบิดหลายฮิต", "slot": "MAGUS"},
	],
	# สกิลของ CAT BOYS ชื่อขึ้นต้นด้วยเลเวลกับช่อง 5.1 คือเลเวล 5 ช่อง 1
	"cat": [
		{"id": "cat_roll", "level": "1.1", "name": "1.1 Furball Roll", "text": "กลิ้งทะลุมอน 1 ตัว ทำดาเมจตอนกลิ้งผ่าน", "slot": "กลิ้ง"},
		{"id": "cat_wave", "level": "1.2", "name": "1.2 Paw Slap Wave", "text": "พุ่งไปข้างหน้า ตบดาบลงพื้น คลื่นแดงพุ่ง", "slot": "คลื่น"},
		{"id": "cat_storm", "level": "5.1", "name": "5.1 Fluffy Tornado", "text": "เอาดาบงัดพื้น พายุใหญ่พัดไปข้างหน้า", "slot": "พายุ"},
		{"id": "cat_charge", "level": "10.1", "name": "10.1 Hiss & Dash", "text": "รวมพลังที่ดาบ แล้วพุ่งฟันข้างหน้าแรง 1 ฮิต", "slot": "รวมพลัง"},
		{"id": "cat_escape", "level": "15.1", "name": "15.1 Nyoom Dodge", "text": "หลุดจากการโจมตี ไถลถอยหลังไปไกล", "slot": "หนี"},
		{"id": "cat_rush", "level": "20.1", "name": "20.1 Scratch Frenzy", "text": "พุ่งฟัน 5 ฮิตไถลตาม แล้วตบดินคลื่นแดง", "slot": "5 ฮิต"},
		{"id": "cat_sa", "level": "20.2", "name": "20.2 Puffed-Up Armor", "text": "บัพเกราะ SA ให้ตัวเอง 15 วินาที", "slot": "SA"},
		{"id": "cat_mk_blast", "class": "MAGIC KNIGHT", "name": "15.2 Pawsplosion", "text": "ยิงลูกไฟไประเบิดด้านหน้า", "slot": "ระเบิด"},
		{"id": "cat_mk_swords", "class": "MAGIC KNIGHT", "name": "15.3 Fire Claw Rain", "text": "ดาบเวทผุดจากดิน 10 เล่ม กว้าง 3.5 ช่วงตัว", "slot": "ดาบผุด"},
		{"id": "cat_mk_burn", "class": "MAGIC KNIGHT", "passive": true, "name": "15.4 Toasty Fur", "text": "ติดตัว เวทแรงขึ้น แรงขึ้นอีกกับศัตรูที่ติดไฟ", "slot": ""},
		{"id": "cat_mk_blade", "class": "MAGIC KNIGHT", "name": "25.1 Blaze Claw Dash", "text": "ดาบเวทเล่มยักษ์จากด้านหลัง พุ่งทะลุ 1 จอ", "slot": "ดาบพุ่ง"},
		{"id": "cat_mk_firewave", "class": "MAGIC KNIGHT", "name": "30.1 Flame Tail Wave", "text": "ปักดาบ คลื่นไฟไปไกลสองข้าง ลุกไหม้ต่อ 4 วิ", "slot": "คลื่นไฟ"},
		{"id": "cat_mk_ignite", "class": "MAGIC KNIGHT", "name": "30.2 Pawfire Blade", "text": "เอามือถูดาบ ดาบติดไฟ 20 วินาที", "slot": "ติดไฟ"},
		{"id": "cat_mk_vortex", "class": "MAGIC KNIGHT", "name": "35.1 Fire Yarn Spin", "text": "ลูกไฟยักษ์หมุนแนวนอน 18 ฮิต ระเบิด 2 ฮิต", "slot": "ไฟหมุน"},
		{"id": "cat_mk_curse", "class": "MAGIC KNIGHT", "passive": true, "name": "40.1 Black Cat Hex", "text": "ติดตัว โอกาส 50% ลดเกราะศัตรู เพิ่มพลังเรา 10 วิ", "slot": ""},
		{"id": "cat_sk_kick", "class": "SWORD KNIGHT", "name": "15.2 Kitty Kick", "text": "เตะไปข้างหน้า มอนชะงัก", "slot": "เตะ"},
		{"id": "cat_sk_sparks", "class": "SWORD KNIGHT", "name": "15.3 Sparkle Swipe", "text": "งัดดาบลงพื้น ประกายแดงกระจายเป็นรูปพัด", "slot": "ประกาย"},
		{"id": "cat_sk_might", "class": "SWORD KNIGHT", "passive": true, "name": "15.4 Claw Power", "text": "ติดตัว พลังโจมตีและสกิลแรงขึ้น", "slot": ""},
		{"id": "cat_sk_crack", "class": "SWORD KNIGHT", "name": "25.1 Claw Crack", "text": "ปักดาบ ดินร้าวลาวาแดงไล่ไปข้างหน้า หินกระเด็น", "slot": "แตกดิน"},
		{"id": "cat_sk_leap", "class": "SWORD KNIGHT", "name": "30.1 Pounce Smash", "text": "กระโดดทุ่ม พื้นแตกวงกว้าง หินกระจาย", "slot": "ทุ่ม"},
		{"id": "cat_sk_hilt", "class": "SWORD KNIGHT", "name": "30.2 Bell Bonk", "text": "เอาด้ามดาบตีไปข้างหน้า ลดเกราะเป้าหมาย", "slot": "ด้าม"},
		{"id": "cat_sk_wave", "class": "SWORD KNIGHT", "name": "35.1 Claw Wave", "text": "กระโดดฟาดแนวตั้ง คลื่นดาบแดงไหลช้า ดาเมจต่อเนื่อง", "slot": "คลื่นดาบ"},
		{"id": "cat_sk_guard", "class": "SWORD KNIGHT", "passive": true, "name": "40.1 Alert Kitty", "text": "ติดตัว ตอนมีเกราะ SA ป้องกันเพิ่มขึ้น", "slot": ""},
		{"id": "cat_gk_aura", "class": "GRAND KNIGHT", "name": "35.2 King Purr Aura", "text": "แทงไปข้างหน้า ออร่าดาบแดงจางคลุมดาบ ตีไกลขึ้น 20 วิ", "slot": "ออร่า"},
		{"id": "cat_gk_spin", "class": "GRAND KNIGHT", "name": "35.3 Whirl-a-Swipe", "text": "หมุนตัวฟาดดาบไปข้างหน้าหลายฮิต", "slot": "หมุนฟาด"},
		{"id": "cat_gk_gust", "class": "GRAND KNIGHT", "passive": true, "name": "35.4 Tail Gust", "text": "ติดตัว ตีโดน 25% เกิดคลื่นลมแดงจางเล็กๆ", "slot": ""},
		{"id": "cat_gk_ram", "class": "GRAND KNIGHT", "name": "40.1 Head Bonk Rush", "text": "พุ่งไถลชนไปข้างหน้าไกลนิดหน่อย", "slot": "ไถลชน"},
		{"id": "cat_gk_storm", "class": "GRAND KNIGHT", "name": "45.1 Red Claw Storm", "text": "พายุแดงยักษ์พัดเป้าหมายไปไกล 1 จอครึ่ง", "slot": "พายุ"},
		{"id": "cat_gk_whirl", "class": "GRAND KNIGHT", "name": "45.2 Claw Wheel", "text": "กดค้างหมุนตัว คลื่นดาบรอบตัว เดินกระโดดได้ ดูดมอน", "slot": "หมุน"},
		{"id": "cat_gk_guard", "class": "GRAND KNIGHT", "name": "50.1 Counter Kitty", "text": "ตั้งการ์ด SA ศัตรูตีหรือเข้าประชิด งัดสวนขึ้น", "slot": "การ์ด"},
		{"id": "cat_gk_cleave", "class": "GRAND KNIGHT", "name": "50.2 Mega Paw Cleave", "text": "ง้างฟาด ออร่าดาบยักษ์ฟาดจากพื้นหลังถึงพื้นหน้า", "slot": "ฟาดจอ"},
		{"id": "cat_gk_ring", "class": "GRAND KNIGHT", "name": "55.1 Claw Ring Wave", "text": "หมุนฟาด คลื่นแดงรอบตัวแนวนอน มอนสตั๊น", "slot": "วงคลื่น"},
		{"id": "cat_gk_body", "class": "GRAND KNIGHT", "passive": true, "name": "60.1 Thick Fur Plate", "text": "ติดตัว ลดดาเมจที่ได้รับ เพิ่มเลือดสูงสุด", "slot": ""},
		{"id": "cat_gk_haste", "class": "GRAND KNIGHT", "passive": true, "name": "60.2 Zoomies", "text": "ติดตัว ใช้สกิล 12% ลดคูลดาวน์ทุกช่อง", "slot": ""},
		{"id": "cat_gk_hyper", "class": "GRAND KNIGHT", "name": "65 HYPER", "text": "ดูดมอนทั้งจอ ออร่าดาบยักษ์ฟาดรอบตัว 17 ฮิต", "slot": "HYPER"},
		{"id": "cat_fk_phoenix", "class": "FLAME KNIGHT", "name": "35.2 Fluffy Phoenix", "text": "นกฟีนิกซ์ไฟพุ่งจากเท้าขึ้นฟ้าช้าๆ ดาเมจต่อเนื่อง", "slot": "ฟีนิกซ์"},
		{"id": "cat_fk_orb", "class": "FLAME KNIGHT", "name": "35.3 Hover Fire Yarn", "text": "เสกลูกไฟตรงหน้า ดาเมจต่อเนื่อง อยู่ 5 วิ", "slot": "ลูกไฟ"},
		{"id": "cat_fk_big", "class": "FLAME KNIGHT", "passive": true, "name": "35.4 Chonky Fireball", "text": "ติดตัว ลูกไฟของสายนี้ใหญ่ขึ้น", "slot": ""},
		{"id": "cat_fk_stab", "class": "FLAME KNIGHT", "name": "40.1 Fire Claw Stab", "text": "พุ่งแทงไปข้างหน้าไกลนิดหน่อย เป้าหมายติดไฟ", "slot": "แทงไฟ"},
		{"id": "cat_fk_wheel", "class": "FLAME KNIGHT", "name": "45.1 Flame Tail Wheel", "text": "ลูกไฟยักษ์หมุนแนวตั้ง เคลื่อนช้าๆ ไกล 2 จอ", "slot": "วงล้อไฟ"},
		{"id": "cat_fk_sky", "class": "FLAME KNIGHT", "name": "45.2 Sky Fire Swords", "text": "ดาบเวทปักจากฟ้าด้านหน้า แตกกระจาย", "slot": "ดาบฟ้า"},
		{"id": "cat_fk_guard", "class": "FLAME KNIGHT", "name": "50.1 Mirror Fire Fur", "text": "ตั้งการ์ด โดนโจมตีระยะไกลสะท้อนกลับ", "slot": "สะท้อน"},
		{"id": "cat_fk_circle", "class": "FLAME KNIGHT", "name": "50.2 Pawfire Circle", "text": "วงเวททรงกระบอกใหญ่ ยืนในวงได้ MP เพิ่ม", "slot": "วงเวท"},
		{"id": "cat_fk_nova", "class": "FLAME KNIGHT", "name": "55.1 Fluff Nova", "text": "ลูกไฟยักษ์ตรงหน้า บีบจนระเบิด มอนลอย", "slot": "บีบไฟ"},
		{"id": "cat_fk_power", "class": "FLAME KNIGHT", "passive": true, "name": "60.1 Fire Heart Purr", "text": "ติดตัว ลูกไฟจากคอมโบและสกิลแรงขึ้น", "slot": ""},
		{"id": "cat_fk_ward", "class": "FLAME KNIGHT", "passive": true, "name": "60.2 Fireproof Fur", "text": "ติดตัว ป้องกันเพิ่มขึ้น", "slot": ""},
		{"id": "cat_fk_hyper", "class": "FLAME KNIGHT", "name": "65 HYPER", "text": "ลูกไฟยักษ์ตกช้าๆ บีบอัดแล้วระเบิดหลายฮิต", "slot": "HYPER"},
		{"id": "cat_gd_roar", "class": "GUARDIAN KNIGHT", "name": "35.2 Earth Meow-roar", "text": "ตะโกนต่อเนื่องพื้นแตก กดค้างนานขึ้น ไกล 1 จอ", "slot": "คำราม"},
		{"id": "cat_gd_horn", "class": "GUARDIAN KNIGHT", "name": "35.3 Hiss Horn", "text": "ตะโกนเป็นกรวยครึ่งจอไปข้างหน้า มอนสตั๊น", "slot": "โทรโข่ง"},
		{"id": "cat_gd_loud", "class": "GUARDIAN KNIGHT", "passive": true, "name": "35.4 Big Loud Meow", "text": "ติดตัว สกิลโล่และตะโกนแรงขึ้น", "slot": ""},
		{"id": "cat_gd_lunge", "class": "GUARDIAN KNIGHT", "name": "40.1 Paw Shield Lunge", "text": "พุ่งแทงไปข้างหน้า แล้วกระแทกโล่", "slot": "แทงโล่"},
		{"id": "cat_gd_trail", "class": "GUARDIAN KNIGHT", "name": "45.1 Meow Echo", "text": "ตะโกนวงใหญ่ รอยเสียงไล่ไปข้างหน้า 2 จอ", "slot": "คลื่นเสียง"},
		{"id": "cat_gd_rally", "class": "GUARDIAN KNIGHT", "name": "45.2 Kitty Rally", "text": "กระโดดตะโกน โล่เรือง คอมโบได้ MP เพิ่ม", "slot": "เรืองแสง"},
		{"id": "cat_gd_guard", "class": "GUARDIAN KNIGHT", "name": "50.1 Shield Counter", "text": "ตั้งโล่ SA มอนตีหรือประชิด สวนจนสตั๊น", "slot": "ตั้งโล่"},
		{"id": "cat_gd_banner", "class": "GUARDIAN KNIGHT", "name": "50.2 Paw Banner Ring", "text": "ตะโกนเกิดวงแดงใหญ่ อยู่ในวงติด SA", "slot": "วงแดง"},
		{"id": "cat_gd_smash", "class": "GUARDIAN KNIGHT", "name": "55.1 Shield Paw Smash", "text": "กระแทกโล่ไปข้างหน้าอย่างแรง มอนชะงัก", "slot": "ทุบแรง"},
		{"id": "cat_gd_iron", "class": "GUARDIAN KNIGHT", "passive": true, "name": "60.1 Iron Fur", "text": "ติดตัว ป้องกันเพิ่มขึ้นถาวร", "slot": ""},
		{"id": "cat_gd_calm", "class": "GUARDIAN KNIGHT", "passive": true, "name": "60.2 Zen Kitty", "text": "ติดตัว สกิลโล่และตะโกนใช้ MP น้อยลง", "slot": ""},
		{"id": "cat_gd_hyper", "class": "GUARDIAN KNIGHT", "name": "65 HYPER", "text": "ตะโกนรอบจอ 15 ฮิต แล้วทุ่มโล่ยักษ์ พื้นแตก", "slot": "HYPER"},
		{"id": "cat_ck_rend", "class": "CRIMSON KNIGHT", "name": "35.2 Feral Scratch", "text": "ฟาดดาบ รอยฟันสลับไปมาด้านหน้าครึ่งจอ", "slot": "รอยฟัน"},
		{"id": "cat_ck_punch", "class": "CRIMSON KNIGHT", "name": "35.3 Marked Paw Slap", "text": "ต่อยมาร์คเป้าหมาย ดูดเลือด มอนช้าลง 10 วิ", "slot": "มาร์ค"},
		{"id": "cat_ck_price", "class": "CRIMSON KNIGHT", "passive": true, "name": "35.4 One Life Price", "text": "ติดตัว กดสกิลเลือดซ้ำก่อนออกท่า เสียเลือด 80% ดาเมจแรงขึ้น", "slot": ""},
		{"id": "cat_ck_pull", "class": "CRIMSON KNIGHT", "name": "40.1 Yarn Pull Boom", "text": "ดูดมอนด้านหน้ามาที่ปลายดาบ แล้วระเบิด", "slot": "ดูด"},
		{"id": "cat_ck_chakram", "class": "CRIMSON KNIGHT", "name": "45.1 Red Claw Chakram", "text": "กงจักรเลือดยักษ์หมุนพุ่งไป มอนช้าลง อยู่ 8 วิ", "slot": "กงจักร"},
		{"id": "cat_ck_offer", "class": "CRIMSON KNIGHT", "name": "45.2 Paw Offering", "text": "ดาบหาย เลือดพุ่งขึ้น 5 ฮิตลดเกราะ บัพพลังโจมตี", "slot": "ถวาย"},
		{"id": "cat_ck_orbit", "class": "CRIMSON KNIGHT", "name": "50.1 Red Claw Orbit", "text": "ใบเลือด 2 อันหมุนรอบตัว ดาเมจไม่ชะงัก", "slot": "ใบหมุน"},
		{"id": "cat_ck_sky", "class": "CRIMSON KNIGHT", "name": "50.2 Sky Claw Swords", "text": "ดาบเลือดยักษ์ปักลง ลำเลือดทรงกระบอก", "slot": "ดาบฟ้า"},
		{"id": "cat_ck_wheel", "class": "CRIMSON KNIGHT", "name": "55.1 Flip Spin Kitty", "text": "หมุนตัวแนวตั้งไปข้างหน้า 5 ฮิต มอนชะงัก", "slot": "หมุนเลือด"},
		{"id": "cat_ck_might", "class": "CRIMSON KNIGHT", "passive": true, "name": "60.1 Hunter Instinct", "text": "ติดตัว พลังโจมตีเพิ่มถาวร", "slot": ""},
		{"id": "cat_ck_survive", "class": "CRIMSON KNIGHT", "passive": true, "name": "60.2 Nine Lives", "text": "ติดตัว เลือดต่ำ สังเวยถูกลง หรือฟื้นเลือด คูล 20 วิ", "slot": ""},
		{"id": "cat_ck_hyper", "class": "CRIMSON KNIGHT", "name": "65 HYPER", "text": "ปักดาบ วงอุ้งเท้าแดง หนามเล็บพุ่งยาวสั้นสลับ 7 วิ", "slot": "HYPER"},
		{"id": "cat_sh_bash", "class": "SHIELD KNIGHT", "name": "15.2 Shield Bonk", "text": "พุ่งดันโล่ไปข้างหน้า มอนมึนงง", "slot": "พุ่งโล่"},
		{"id": "cat_sh_quake", "class": "SHIELD KNIGHT", "name": "15.3 Shield Quake", "text": "ทุบโล่ลงพื้นด้านหน้า ดินแตก มอนลอย", "slot": "ทุบดิน"},
		{"id": "cat_sh_iron", "class": "SHIELD KNIGHT", "passive": true, "name": "15.4 Iron Paw", "text": "ติดตัว ดาเมจเพิ่ม มอนชะงักนานขึ้น", "slot": ""},
		{"id": "cat_sh_throw", "class": "SHIELD KNIGHT", "name": "25.1 Saucer Shield Toss", "text": "ขว้างโล่หมุนออกไป แล้วบินกลับ โดน 2 รอบ", "slot": "ขว้างโล่"},
		{"id": "cat_sh_taunt", "class": "SHIELD KNIGHT", "name": "30.1 Feather Taunt", "text": "ตะโกนเคาะโล่ ดึงมอนรอบตัวเข้ามา ได้เกราะ SA", "slot": "ยั่วยุ"},
		{"id": "cat_sh_leap", "class": "SHIELD KNIGHT", "name": "30.2 Leap Shield Slam", "text": "ทุบโล่วงกว้างครึ่งจอ กดค้างปล่อยคลื่นกระแทกแดง", "slot": "กระโดดโล่"},
		{"id": "cat_sh_dome", "class": "SHIELD KNIGHT", "name": "35.1 Cat Box Dome", "text": "โดมแดงอ่อนเต็มจอ 9 วิ มอนชะงัก โดนทุก 3 วิ", "slot": "โดม"},
		{"id": "cat_sh_wall", "class": "SHIELD KNIGHT", "passive": true, "name": "40.1 Fluff Wall", "text": "ติดตัว ใช้สกิลแล้วได้เกราะ SA 2 วิ", "slot": ""},
		{"id": "cat_dk_erupt", "class": "DARK KNIGHT", "name": "15.2 Paw Eruption", "text": "ตบดาบลงพื้น เลือดดำแดงปะทุไล่ไปข้างหน้า", "slot": "ปะทุ"},
		{"id": "cat_dk_scythe", "class": "DARK KNIGHT", "name": "15.3 Red Scratch Wave", "text": "กระโดดยิงคลื่นเลือดต่อเนื่อง กดค้างชาร์จให้ยาวขึ้น", "slot": "คลื่นเลือด"},
		{"id": "cat_dk_thirst", "class": "DARK KNIGHT", "passive": true, "name": "15.4 Hungry Kitty", "text": "ติดตัว ดาเมจเพิ่ม แรงขึ้นอีกกับมอนที่เกราะแตก", "slot": ""},
		{"id": "cat_dk_orb", "class": "DARK KNIGHT", "name": "25.1 Red Claw Blade", "text": "แทงพร้อมแปรเป็นดาบเลือด 15 วิ เลือดไหล ดูดเลือด", "slot": "ดาบเลือด"},
		{"id": "cat_dk_curse", "class": "DARK KNIGHT", "name": "30.1 Red Paw Pool", "text": "กระโดดฟาดพื้น บ่อเลือดครึ่งจอ หนามทิ่มต่อเนื่อง", "slot": "บ่อเลือด"},
		{"id": "cat_dk_frenzy", "class": "DARK KNIGHT", "name": "30.2 Red Tail Dash", "text": "อาบเลือด ติด SA พุ่งลากมอนไปครึ่งจอ แล้วสตั๊น", "slot": "ลากเลือด"},
		{"id": "cat_dk_vortex", "class": "DARK KNIGHT", "name": "35.1 Twin Fluff Storm", "text": "พายุเลือดสองฝั่งพัดมอนเข้าหา บรรจบแล้วระเบิด", "slot": "พายุเลือด"},
		{"id": "cat_dk_chain", "class": "DARK KNIGHT", "passive": true, "name": "40.1 Nine Lives Power", "text": "ติดตัว MP สูงสุด +100", "slot": ""},
	],
	"azure": [
		{"id": "pr_sk_tag", "class": "BASIC", "name": "1.1 Tag Team Pop", "text": "ตีเบาๆ หนึ่งที แล้วอีกตัวโผล่จากด้านหลังช่วยยิง (AZURE นำ LAPIS ยิงกระสุน / LAPIS นำ AZURE ปาคลื่นเล็บ) ใช้กลางอากาศได้", "slot": "แท็กทีม"},
		{"id": "pr_sk_bubble", "class": "BASIC", "name": "1.5 Bubble Bounce", "text": "ปล่อยฟองน้ำเงิน 3 ลูกเด้งไปตามพื้น แตกแล้วมอนชะงัก", "slot": "ฟองเด้ง"},
		{"id": "pr_sk_highfive", "class": "BASIC", "name": "5.1 High-Five Ring", "text": "อีกตัวโผล่มาแปะมือ เกิดวงแหวนกระแทกรอบตัว มอนล้ม", "slot": "แปะมือ"},
		{"id": "pr_sk_link", "class": "BASIC", "passive": true, "name": "10.1 Duo Link", "text": "ติดตัว สลับตัวแล้ว 3 วินาทีโจมตีแรงขึ้น 20%", "slot": ""},
		{"id": "pr_sk_relay", "class": "BASIC", "name": "15.1 Relay Rush", "text": "พุ่งไปหน้าชนมอน สุดทางสลับตัวอัตโนมัติ ตัวใหม่พุ่งต่อเสยมอนลอย", "slot": "วิ่งผลัด"},
		{"id": "pr_sk_guard", "class": "BASIC", "name": "20.1 Twin Guard", "text": "ทั้งคู่ยืนประกบกัน กันดาเมจทั้งใกล้และไกล 3 วินาที", "slot": "คุ้มกันคู่"},
		{"id": "pr_sk_toss", "class": "BASIC", "name": "20.2 Partner Toss", "text": "ปาคู่หูพุ่งไปข้างหน้าเหมือนลูกปืนใหญ่ ตกถึงพื้นระเบิดวงน้ำเงิน มอนลอย", "slot": "ปาคู่หู"},
		{"id": "pr_sk_quick", "class": "BASIC", "passive": true, "name": "20.3 Quick Paws", "text": "ติดตัว คูลดาวน์ปุ่ม V สลับตัวเหลือ 2 วินาที สลับแล้วเกิดวงกระแทกเล็ก มอนรอบตัวชะงัก", "slot": ""},
		{"id": "pr_sk_sd_sheep", "class": "SPARK DREAMER", "name": "15.2 Counting Sheep", "text": "แกะฝันปุยๆ 3 ตัวกระโดดเด้งไปหน้า โดนแล้วมอนง่วงสตั๊น", "slot": "นับแกะ"},
		{"id": "pr_sk_sd_lullaby", "class": "SPARK DREAMER", "name": "15.3 Lullaby Spark", "text": "คู่หูโผล่มาร้องเพลงกล่อม วงโน้ตกลมรอบตัว มอนในวงหลับสตั๊น", "slot": "เพลงกล่อม"},
		{"id": "pr_sk_sd_nap", "class": "SPARK DREAMER", "passive": true, "name": "15.4 Cat Nap", "text": "ติดตัว ยืนนิ่ง 2 วินาทีขึ้นไป ฟื้นเลือด 1% ต่อวินาที", "slot": ""},
		{"id": "pr_sk_sd_pillow", "class": "SPARK DREAMER", "name": "20.4 Pillow Smash", "text": "ทุบหมอนยักษ์ลงด้านหน้า มอนล้ม", "slot": "ทุบหมอน"},
		{"id": "pr_sk_sd_moon", "class": "SPARK DREAMER", "name": "25.1 Dream Moon", "text": "ปล่อยจันทร์เสี้ยวฝันลอยช้าๆ ทะลุมอน โดนแล้วชะงัก", "slot": "จันทร์ฝัน"},
		{"id": "pr_sk_sd_yawn", "class": "SPARK DREAMER", "name": "25.2 Big Yawn", "text": "หาวกว้างไปด้านหน้า มอนชะงัก ได้มานาคืนตามจำนวนมอนที่โดน", "slot": "หาวใหญ่"},
		{"id": "pr_sk_sd_drift", "class": "SPARK DREAMER", "name": "30.1 Sleepwalk Drift", "text": "หลับตาลอยไปข้างหน้าช้าๆ ไม่โดนดาเมจ ชนมอนแล้วผลักและทำดาเมจ ใช้กลางอากาศได้", "slot": "ละเมอลอย"},
		{"id": "pr_sk_sd_rain", "class": "SPARK DREAMER", "name": "30.2 Spark Dream Rain", "text": "ฝนประกายเม็ดกลมตกด้านหน้า 2 วินาที", "slot": "ฝนประกาย"},
		{"id": "pr_sk_sd_blanket", "class": "SPARK DREAMER", "name": "35.1 Snuggle Blanket", "text": "ปูผ้าห่มฝันบนพื้น มอนในผ้าห่มช้าลงและโดนดาเมจ ตัวเองยืนบนผ้าห่มมานาฟื้น", "slot": "ผ้าห่มฝัน"},
		{"id": "pr_sk_sd_dream", "class": "SPARK DREAMER", "passive": true, "name": "40.1 Sweet Dreams", "text": "ติดตัว มอนที่สตั๊นอยู่โดนดาเมจแรงขึ้น 25%", "slot": ""},
		{"id": "pr_sk_so_walk", "class": "SOMNAMBULIST", "name": "35.2 Sleepwalker Combo", "text": "ละเมอเดินไปหน้าแล้วตีอัตโนมัติ 6 ที สลับตัวกันตีระหว่างทาง ฮิตสุดท้ายมอนล้ม", "slot": "ละเมอตี"},
		{"id": "pr_sk_so_door", "class": "SOMNAMBULIST", "name": "35.3 Dream Door", "text": "เปิดประตูฝันกลมด้านหน้า ดูดมอนเข้าไป แล้วพ่นออกมามอนลอย", "slot": "ประตูฝัน"},
		{"id": "pr_sk_so_sleepguard", "class": "SOMNAMBULIST", "passive": true, "name": "35.4 Sleep Guard", "text": "ติดตัว เลือดต่ำกว่า 40% โดนตีแล้วหลับไป 1 วินาที ไม่โดนดาเมจ ฟื้นเลือด 15% (คูลดาวน์ 30 วิ)", "slot": ""},
		{"id": "pr_sk_so_pillows", "class": "SOMNAMBULIST", "name": "45.1 Pillow Storm", "text": "หมอน 6 ใบตกลงมาทั่วด้านหน้าทีละใบ มอนล้ม", "slot": "พายุหมอน"},
		{"id": "pr_sk_so_twin", "class": "SOMNAMBULIST", "name": "45.2 Dream Twin", "text": "เรียกร่างฝันโปร่งใสของคู่หูมาช่วยตี 6 วินาที ไล่ตีมอนที่ใกล้ที่สุด", "slot": "ร่างฝัน"},
		{"id": "pr_sk_so_snore", "class": "SOMNAMBULIST", "name": "50.1 Snore Wave", "text": "กรนเป็นคลื่นวงกลม 3 ระลอก ผลักมอนออกและทำดาเมจ", "slot": "คลื่นกรน"},
		{"id": "pr_sk_so_float", "class": "SOMNAMBULIST", "name": "50.2 Bed Float", "text": "ยกมอนด้านหน้าลอยขึ้นเหมือนนอนบนเตียง แล้วทิ้งลงพื้น ใช้กลางอากาศได้", "slot": "เตียงลอย"},
		{"id": "pr_sk_so_nightmare", "class": "SOMNAMBULIST", "name": "55.1 Sweet Nightmare", "text": "ฟองฝันน้ำเงินเข้มครอบด้านหน้า ทำดาเมจต่อเนื่อง ปิดท้ายระเบิดมอนล้ม", "slot": "ฝันหวาน"},
		{"id": "pr_sk_so_deep", "class": "SOMNAMBULIST", "passive": true, "name": "60.1 Deep Sleep", "text": "ติดตัว สตั๊นนานขึ้น 50% MP สูงสุด +100", "slot": ""},
		{"id": "pr_sk_so_awake", "class": "SOMNAMBULIST", "passive": true, "name": "60.2 Wake-Up Call", "text": "ติดตัว สลับตัวแล้ว สกิลถัดไปไม่ใช้มานา (คูลดาวน์ 15 วิ)", "slot": ""},
		{"id": "pr_sk_sf_zap", "class": "SPARK FIEND", "name": "15.2 Zappy Paw", "text": "สายฟ้าสั้นพุ่งไปหน้า กระโดดต่อไปอีก 2 ตัว ใช้กลางอากาศได้", "slot": "ซ่าเล็บ"},
		{"id": "pr_sk_sf_ball", "class": "SPARK FIEND", "name": "15.3 Static Ball", "text": "ลูกไฟฟ้ากลมลอยช้าๆ ช็อตมอนรอบๆ ทุกครึ่งวินาที", "slot": "บอลไฟฟ้า"},
		{"id": "pr_sk_sf_static", "class": "SPARK FIEND", "passive": true, "name": "15.4 Static Fur", "text": "ติดตัว ตีคอมโบโดนมีโอกาส 15% ช็อตไฟฟ้าเพิ่ม", "slot": ""},
		{"id": "pr_sk_sf_rush", "class": "SPARK FIEND", "name": "20.4 Spark Rush", "text": "พุ่งทะลุมอนเป็นเส้นไฟฟ้า สุดทางสลับตัว", "slot": "พุ่งไฟฟ้า"},
		{"id": "pr_sk_sf_coil", "class": "SPARK FIEND", "name": "25.1 Tesla Coil", "text": "ปักเสาไฟฟ้าเล็กบนพื้น ช็อตมอนที่ใกล้ที่สุดทุกครึ่งวินาที 5 วินาที", "slot": "เสาไฟฟ้า"},
		{"id": "pr_sk_sf_tail", "class": "SPARK FIEND", "name": "25.2 Thunder Tail", "text": "หมุนตัวหางไฟฟ้าเป็นวงรอบตัว มอนชะงัก", "slot": "หางสายฟ้า"},
		{"id": "pr_sk_sf_drop", "class": "SPARK FIEND", "name": "30.1 Bolt Drop", "text": "ดิ่งลงพื้น ฟ้าผ่าลงจุดที่ตก มอนลอย ใช้กลางอากาศได้", "slot": "ฟ้าผ่าดิ่ง"},
		{"id": "pr_sk_sf_circuit", "class": "SPARK FIEND", "name": "30.2 Duo Circuit", "text": "คู่หูไปยืนข้างหน้า เส้นไฟฟ้าต่อระหว่างทั้งคู่ มอนบนเส้นโดนช็อตต่อเนื่อง", "slot": "วงจรคู่"},
		{"id": "pr_sk_sf_overcharge", "class": "SPARK FIEND", "name": "35.1 Overcharge", "text": "ชาร์จไฟเต็มตัว 10 วินาที ตีไวขึ้น 15% ตีคอมโบช็อตไฟฟ้าทุกครั้ง", "slot": "ชาร์จเต็ม"},
		{"id": "pr_sk_sf_volt", "class": "SPARK FIEND", "passive": true, "name": "40.1 Volt Paws", "text": "ติดตัว MP สูงสุด +100 เดินเร็วขึ้น", "slot": ""},
		{"id": "pr_sk_nb_dash", "class": "NEON BOLT", "name": "35.2 Neon Dash", "text": "พุ่งเป็นเส้นนีออน 4 ช่วงตัว มอนตามแนวโดนหมด ใช้กลางอากาศได้", "slot": "พุ่งนีออน"},
		{"id": "pr_sk_nb_cross", "class": "NEON BOLT", "name": "35.3 Neon Cross", "text": "ทั้งคู่พุ่งสวนกันจากสองฝั่ง เป็นกากบาทนีออน มอนลอย", "slot": "กากบาทนีออน"},
		{"id": "pr_sk_nb_after", "class": "NEON BOLT", "passive": true, "name": "35.4 Afterimage", "text": "ติดตัว โอกาส 15% หลบการโจมตีเหลือแค่ภาพติดตา", "slot": ""},
		{"id": "pr_sk_nb_grid", "class": "NEON BOLT", "name": "45.1 Neon Grid", "text": "แท่งนีออน 3 แท่งตกกระแทกพื้นด้านหน้าทีละแท่ง", "slot": "ตารางนีออน"},
		{"id": "pr_sk_nb_rail", "class": "NEON BOLT", "name": "45.2 Rail Shot", "text": "ลำแสงนีออนยาวทะลุทั้งแนว (ตอนเป็น AZURE เรียก LAPIS มายิงให้)", "slot": "ลำแสงราง"},
		{"id": "pr_sk_nb_storm", "class": "NEON BOLT", "name": "50.1 Neon Storm", "text": "สายฟ้านีออน 8 สายผ่าลงมอนรอบตัวทีละสาย", "slot": "พายุนีออน"},
		{"id": "pr_sk_nb_relay", "class": "NEON BOLT", "name": "50.2 Flash Relay", "text": "สลับตัวรัว 4 ครั้ง แต่ละครั้งพุ่งฟันผ่านมอนที่ใกล้ที่สุด", "slot": "สลับแฟลช"},
		{"id": "pr_sk_nb_overdrive", "class": "NEON BOLT", "name": "55.1 Overdrive", "text": "โหมดนีออน 6 วินาที ปุ่ม V ไม่มีคูลดาวน์ สลับตัวทุกครั้งระเบิดนีออน", "slot": "โอเวอร์ไดรฟ์"},
		{"id": "pr_sk_nb_soul", "class": "NEON BOLT", "passive": true, "name": "60.1 Neon Soul", "text": "ติดตัว โจมตีแรงขึ้น 20%", "slot": ""},
		{"id": "pr_sk_nb_trail", "class": "NEON BOLT", "passive": true, "name": "60.2 Afterspark", "text": "ติดตัว สลับตัวแล้วทิ้งวงนีออนทำดาเมจรอบตัว", "slot": ""},
		{"id": "cat_so_hyper", "class": "SOMNAMBULIST", "name": "65 HYPER", "text": "AZURE กระโดดวาร์ปเข้าประตูกลางจอ ประตูเปิด LAPIS ผายมือ แสงอวกาศดูดมอนเข้าประตู", "slot": "HYPER"},
		{"id": "cat_nb_hyper", "class": "NEON BOLT", "name": "65 HYPER", "text": "ทั้งคู่เป็นเงาเส้นนีออนขาวน้ำเงิน LAPIS พุ่งทะลุจอ AZURE ฟันตามเส้นพุ่ง สลับพุ่งทั่วจอ", "slot": "HYPER"},
	],
	# CAT ASH หมัดกับเท้า สกิลทุกสาย (ระบบ FistSkills id ขึ้นต้น fs_sk_)
	"fist": [
		{"id": "fs_sk_palm", "class": "BASIC", "name": "1.1 Paw Palm", "text": "ผลักฝ่ามือ ปล่อยลมกลมเล็กพุ่งไปด้านหน้า มอนชะงัก ใช้กลางอากาศได้", "slot": "ฝ่ามือลม"},
		{"id": "fs_sk_slam", "class": "BASIC", "name": "1.5 Meteor Paw", "text": "กระโดดทุบหมัดลงพื้น คลื่นกระแทกรอบจุดทุบ มอนลอย", "slot": "ทุบพื้น"},
		{"id": "fs_sk_combo", "class": "BASIC", "name": "5.1 One-Two Purr", "text": "พุ่งเข้าไปต่อย 1-2 ฮุก แล้วอัปเปอร์คัตมอนลอย", "slot": "วันทู"},
		{"id": "fs_sk_guard", "class": "BASIC", "passive": true, "name": "10.1 Cat Reflex", "text": "ติดตัว โอกาส 12% ปัดป้องการโจมตี ไม่เสียเลือด", "slot": ""},
		{"id": "fs_sk_flurry", "class": "BASIC", "name": "15.1 Hundred Paws", "text": "ต่อยรัว 12 ฮิต ติด SA ฮิตสุดท้ายมอนกระเด็นล้ม", "slot": "ร้อยหมัด"},
		{"id": "fs_sk_whirl", "class": "BASIC", "name": "20.1 Tornado Kick", "text": "กระโดดหมุนเตะรอบตัว 3 รอบ ดูดมอนเข้าหา รอบสุดท้ายล้ม", "slot": "เตะทอร์นาโด"},
		{"id": "fs_sk_counter", "class": "BASIC", "name": "20.2 Counter Stance", "text": "ตั้งท่ารับ 1.2 วิ มอนเข้ามาใกล้หรือโดนตี สวนหมัดหนัก มอนสตั๊น", "slot": "ท่ารับ"},
		{"id": "fs_sk_hw_bash", "class": "HEAVYWEIGHT", "name": "15.2 Belly Bash", "text": "พุ่งเอาพุงชน ลากมอนไปด้วย แล้วกระเด็นล้ม", "slot": "พุงชน"},
		{"id": "fs_sk_hw_stomp", "class": "HEAVYWEIGHT", "name": "15.3 Earth Stomp", "text": "กระทืบพื้น คลื่นหินโผล่ไล่ไปด้านหน้า 3 ลูก มอนลอย", "slot": "กระทืบ"},
		{"id": "fs_sk_hw_bulk", "class": "HEAVYWEIGHT", "passive": true, "name": "15.4 Big Bones", "text": "ติดตัว เลือดสูงสุด +80", "slot": ""},
		{"id": "fs_sk_hw_iron", "class": "HEAVYWEIGHT", "name": "15.5 Iron Belly", "text": "เบ่งพุงเหล็ก ติด SA 6 วิ โอกาสป้อง +25%", "slot": "พุงเหล็ก"},
		{"id": "fs_sk_hw_toss", "class": "HEAVYWEIGHT", "name": "25.1 Sack Toss", "text": "คว้ามอนตรงหน้า เหวี่ยงข้ามหัวทุ่มลงด้านหลัง พื้นแตก", "slot": "ทุ่มกระสอบ"},
		{"id": "fs_sk_hw_charge", "class": "HEAVYWEIGHT", "name": "30.1 Rhino Charge", "text": "กดค้างชาร์จ ปล่อยแล้วพุ่งชนแบบแรด ชาร์จนานพุ่งไกลแรงขึ้น", "slot": "ชาร์จชน"},
		{"id": "fs_sk_hw_drop", "class": "HEAVYWEIGHT", "name": "30.2 Body Drop", "text": "กระโดดทิ้งตัวลงทับ วงกระแทกกว้าง มอนล้ม ใช้กลางอากาศได้", "slot": "ทิ้งตัว"},
		{"id": "fs_sk_hw_clap", "class": "HEAVYWEIGHT", "name": "35.1 Thunder Clap", "text": "ตบมือดังสนั่น คลื่นเสียงกระจายสองข้าง มอนรอบตัวสตั๊น", "slot": "ตบมือ"},
		{"id": "fs_sk_hw_heavy", "class": "HEAVYWEIGHT", "passive": true, "name": "40.1 Heavy Hitter", "text": "ติดตัว ดาเมจคอมโบ +15%", "slot": ""},
		{"id": "fs_sk_gs_shiko", "class": "GRAND SUMO", "name": "35.2 Shiko Quake", "text": "ยกขากระทืบซ้ายขวา แผ่นดินไหววงกว้าง ครั้งที่สองมอนลอย", "slot": "ชิโกะ"},
		{"id": "fs_sk_gs_push", "class": "GRAND SUMO", "name": "35.3 Tsuppari Wall", "text": "ตบฝ่ามือรัว 12 ครั้ง เดินดันมอนไปข้างหน้า ทีสุดท้ายล้ม", "slot": "ตบรัว"},
		{"id": "fs_sk_gs_root", "class": "GRAND SUMO", "passive": true, "name": "35.4 Dohyo Root", "text": "ติดตัว เลือดสูงสุด +70 โอกาสป้อง 18%", "slot": ""},
		{"id": "fs_sk_gs_salt", "class": "GRAND SUMO", "name": "45.1 Salt Purify", "text": "โปรยเกลือเป็นวง มอนในวงอ่อนแรง ฟื้นเลือดตัวเอง 10%", "slot": "โปรยเกลือ"},
		{"id": "fs_sk_gs_throw", "class": "GRAND SUMO", "name": "45.2 Uwatenage", "text": "คว้ามอนรอบตัว 3 ตัว ทุ่มลงพื้นพร้อมกัน", "slot": "ทุ่มสามตัว"},
		{"id": "fs_sk_gs_ring", "class": "GRAND SUMO", "name": "50.1 Dohyo Ring", "text": "วาดวงเวทีซูโม่บนพื้น 8 วิ มอนในวงช้า ยืนในวงดาเมจ +20%", "slot": "วงเวที"},
		{"id": "fs_sk_gs_yokozuna", "class": "GRAND SUMO", "name": "55.1 Yokozuna Drop", "text": "กระโดดสูง ทิ้งตัวลงมา ระเบิดวงใหญ่สองชั้น", "slot": "โยโกะซึนะ"},
		{"id": "fs_sk_gs_body", "class": "GRAND SUMO", "passive": true, "name": "60.1 Sumo Body", "text": "ติดตัว ฟื้นเลือด 0.5% ต่อวินาที", "slot": ""},
		{"id": "fs_sk_gs_spirit", "class": "GRAND SUMO", "passive": true, "name": "60.2 Unmovable", "text": "ติดตัว เลือดต่ำกว่า 30% ติด SA ตลอด", "slot": ""},
		{"id": "fs_sk_zp_gust", "class": "ZEPHYR", "name": "15.2 Gust Palm", "text": "ฝ่ามือลมก้อนใหญ่ พุ่งทะลุ มอนกระเด็น ใช้กลางอากาศได้", "slot": "ฝ่ามือลม"},
		{"id": "fs_sk_zp_crane", "class": "ZEPHYR", "name": "15.3 Crane Kick", "text": "ยืนขาเดียวแบบกระเรียน เตะเสยมอนลอย", "slot": "เตะกระเรียน"},
		{"id": "fs_sk_zp_flow", "class": "ZEPHYR", "passive": true, "name": "15.4 Flowing Breeze", "text": "ติดตัว เดินเร็วขึ้น", "slot": ""},
		{"id": "fs_sk_zp_step", "class": "ZEPHYR", "name": "15.5 Wind Step", "text": "ก้าวลมพุ่งทะลุมอน ไม่โดนดาเมจระหว่างพุ่ง ทิ้งรอยลมตัด", "slot": "ก้าวลม"},
		{"id": "fs_sk_zp_cyclone", "class": "ZEPHYR", "name": "25.1 Cyclone Hands", "text": "กดค้างหมุนแขน ลมหมุนตรงหน้าดูดมอนเข้ามาโดนรัว", "slot": "มือพายุ"},
		{"id": "fs_sk_zp_rise", "class": "ZEPHYR", "name": "30.1 Rising Dragon", "text": "หมัดมังกรเหิน พุ่งขึ้นฟ้าหมุน 4 ฮิต มอนลอยตาม", "slot": "มังกรเหิน"},
		{"id": "fs_sk_zp_feather", "class": "ZEPHYR", "name": "30.2 Feather Fall", "text": "ลอยเบาเหมือนขนนก เตะเฉียงลง 3 ครั้ง ใช้กลางอากาศได้", "slot": "ขนนก"},
		{"id": "fs_sk_zp_vortex", "class": "ZEPHYR", "name": "35.1 Vortex Wall", "text": "กำแพงลมหมุนตรงหน้า 4 วิ มอนที่เข้ามาโดนดันออก", "slot": "กำแพงลม"},
		{"id": "fs_sk_zp_breath", "class": "ZEPHYR", "passive": true, "name": "40.1 Calm Breath", "text": "ติดตัว มานาฟื้นเร็วขึ้น 40%", "slot": ""},
		{"id": "fs_sk_kf_dragon", "class": "KUNG FU", "name": "35.2 Dragon Fist", "text": "หมัดมังกรลมพุ่งยาว ทะลุทุกตัว มอนล้ม", "slot": "หมัดมังกร"},
		{"id": "fs_sk_kf_mantis", "class": "KUNG FU", "name": "35.3 Mantis Hooks", "text": "ตะขอมือตั๊กแตน 6 ครั้ง ดึงมอนเข้าหาตัว ทีสุดท้ายลอย", "slot": "ตั๊กแตน"},
		{"id": "fs_sk_kf_chi", "class": "KUNG FU", "passive": true, "name": "35.4 Inner Chi", "text": "ติดตัว ตีคอมโบโดนได้มานา", "slot": ""},
		{"id": "fs_sk_kf_palm8", "class": "KUNG FU", "name": "45.1 Eight Trigram Palms", "text": "ฝ่ามือแปดทิศ ตีวนรอบตัว 8 ครั้ง ทีสุดท้ายล้ม", "slot": "แปดทิศ"},
		{"id": "fs_sk_kf_tiger", "class": "KUNG FU", "name": "45.2 Tiger Crane", "text": "เตะท่าเสือ เตะท่ากระเรียน แล้วฟาดฝ่ามือลงพื้น", "slot": "เสือกระเรียน"},
		{"id": "fs_sk_kf_phoenix", "class": "KUNG FU", "name": "50.1 Phoenix Wheel", "text": "หมุนเตะเป็นวงล้อหงส์ พุ่งลงเฉียง กระแทกพื้นมอนลอย", "slot": "วงล้อหงส์"},
		{"id": "fs_sk_kf_master", "class": "KUNG FU", "name": "55.1 Grandmaster Wind", "text": "พายุหมุนใหญ่ด้านหน้า ดูดมอนเข้ากลางแล้วระเบิด", "slot": "ปรมาจารย์"},
		{"id": "fs_sk_kf_focus", "class": "KUNG FU", "passive": true, "name": "60.1 Still Focus", "text": "ติดตัว คูลดาวน์สกิลลดลง 15%", "slot": ""},
		{"id": "fs_sk_kf_echo", "class": "KUNG FU", "passive": true, "name": "60.2 Echo Palm", "text": "ติดตัว สกิลโดนมอน มีโอกาส 20% ปล่อยฝ่ามือลมซ้ำ", "slot": ""},
		{"id": "fs_sk_wm_teep", "class": "WAR MUAY", "name": "15.2 Push Kick", "text": "ถีบตรง มอนกระเด็นไกล", "slot": "ถีบ"},
		{"id": "fs_sk_wm_elbow", "class": "WAR MUAY", "name": "15.3 Spinning Elbow", "text": "หมุนตัวศอกกลับ มอนสตั๊น", "slot": "ศอกกลับ"},
		{"id": "fs_sk_wm_shin", "class": "WAR MUAY", "passive": true, "name": "15.4 Iron Shin", "text": "ติดตัว โอกาสป้อง 15%", "slot": ""},
		{"id": "fs_sk_wm_clinch", "class": "WAR MUAY", "name": "15.5 Clinch Knees", "text": "ปล้ำคอมอนตรงหน้า ตีเข่า 4 ครั้ง ทีสุดท้ายลอย", "slot": "ปล้ำเข่า"},
		{"id": "fs_sk_wm_war", "class": "WAR MUAY", "name": "25.1 Ram Muay", "text": "ร่ายรำไหว้ครู ดาเมจ +20% 15 วิ", "slot": "ไหว้ครู"},
		{"id": "fs_sk_wm_flykick", "class": "WAR MUAY", "name": "30.1 Flying Knee", "text": "กระโดดเข่าพุ่งไกล มอนล้ม", "slot": "เข่าลอย"},
		{"id": "fs_sk_wm_combo", "class": "WAR MUAY", "name": "30.2 Muay Barrage", "text": "ต่อย ศอก เข่า ฮุก เตะ 5 ท่าติด ทีสุดท้ายล้ม", "slot": "มวยรัว"},
		{"id": "fs_sk_wm_low", "class": "WAR MUAY", "name": "35.1 Low Kick Storm", "text": "เตะต่ำสลับ 6 ครั้ง มอนเดินช้าลง", "slot": "เตะต่ำ"},
		{"id": "fs_sk_wm_spirit", "class": "WAR MUAY", "passive": true, "name": "40.1 Fighter Spirit", "text": "ติดตัว ตีเร็วขึ้น 10%", "slot": ""},
		{"id": "fs_sk_mt_skyknee", "class": "MUAY THAI", "name": "35.2 Sky Splitter Knee", "text": "กระโดดเข่าสูงมอนลอย แล้วทุบศอกลงพื้น", "slot": "เข่าผ่าฟ้า"},
		{"id": "fs_sk_mt_cobra", "class": "MUAY THAI", "name": "35.3 Cobra Punch", "text": "ก้าวกระโดดเข้าไปหมัดตรงงูเห่า แรงมาก", "slot": "หมัดงูเห่า"},
		{"id": "fs_sk_mt_crit", "class": "MUAY THAI", "passive": true, "name": "35.4 Golden Shin", "text": "ติดตัว โอกาส 20% ตีแรงขึ้น 1.5 เท่า", "slot": ""},
		{"id": "fs_sk_mt_storm", "class": "MUAY THAI", "name": "45.1 Elbow Storm", "text": "ศอกรัว 10 ครั้ง เดินดันหน้า ติด SA ทีสุดท้ายลอย", "slot": "พายุศอก"},
		{"id": "fs_sk_mt_hanuman", "class": "MUAY THAI", "name": "45.2 Hanuman Leap", "text": "หนุมานกระโดด เข่าทุบลงพื้นวงกว้าง ใช้กลางอากาศได้", "slot": "หนุมาน"},
		{"id": "fs_sk_mt_mongkol", "class": "MUAY THAI", "name": "50.1 Mongkol Aura", "text": "ออร่ามงคล 10 วิ ดาเมจ +25% ฟื้นเลือดเรื่อยๆ", "slot": "มงคล"},
		{"id": "fs_sk_mt_erawan", "class": "MUAY THAI", "name": "55.1 Erawan Kick", "text": "เตะขวานสามจังหวะ คลื่นทองไล่ไปข้างหน้า ทีสุดท้ายลอย", "slot": "เอราวัณ"},
		{"id": "fs_sk_mt_heart", "class": "MUAY THAI", "passive": true, "name": "60.1 Nak Muay Heart", "text": "ติดตัว เลือดสูงสุด +80", "slot": ""},
		{"id": "fs_sk_mt_last", "class": "MUAY THAI", "passive": true, "name": "60.2 Final Round", "text": "ติดตัว เลือดต่ำกว่า 35% ดาเมจ +30%", "slot": ""},
		{"id": "fs_sk_sy_slip", "class": "SYSTEMA GRAPPLER", "name": "15.2 Slip Counter", "text": "หลบวาปไปหลังมอนใกล้สุด แล้วฟาดสันมือ สตั๊น", "slot": "หลบสวน"},
		{"id": "fs_sk_sy_wave", "class": "SYSTEMA GRAPPLER", "name": "15.3 Body Wave", "text": "คลื่นแรงจากลำตัว ผลักมอนรอบตัวกระเด็น", "slot": "คลื่นร่าง"},
		{"id": "fs_sk_sy_relax", "class": "SYSTEMA GRAPPLER", "passive": true, "name": "15.4 Relaxed Body", "text": "ติดตัว โอกาสป้อง 15% ตีมอนอ่อนแรงแรงขึ้น 10%", "slot": ""},
		{"id": "fs_sk_sy_lock", "class": "SYSTEMA GRAPPLER", "name": "15.5 Arm Lock", "text": "ล็อกแขนมอนตรงหน้า ตรึง 2 วิ บีบดาเมจต่อเนื่อง", "slot": "ล็อกแขน"},
		{"id": "fs_sk_sy_breath", "class": "SYSTEMA GRAPPLER", "name": "25.1 Systema Breath", "text": "หายใจลึก ฟื้นเลือด 15% มานา 50", "slot": "หายใจ"},
		{"id": "fs_sk_sy_strike", "class": "SYSTEMA GRAPPLER", "name": "30.1 Pressure Strikes", "text": "จิ้มจุด 5 ครั้ง มอนอ่อนแรง ทีสุดท้ายสตั๊น", "slot": "จิ้มจุด"},
		{"id": "fs_sk_sy_roll", "class": "SYSTEMA GRAPPLER", "name": "30.2 Roll Away", "text": "ม้วนตัวหลบถอยหลัง ไม่โดนดาเมจ แล้วพุ่งเข่าสวน ใช้กลางอากาศได้", "slot": "ม้วนหลบ"},
		{"id": "fs_sk_sy_spiral", "class": "SYSTEMA GRAPPLER", "name": "35.1 Spiral Throw", "text": "คว้ามอนเหวี่ยงวนรอบตัว ชนมอนตัวอื่น แล้วปล่อยกระเด็น", "slot": "เหวี่ยงเกลียว"},
		{"id": "fs_sk_sy_flow", "class": "SYSTEMA GRAPPLER", "passive": true, "name": "40.1 Soft Flow", "text": "ติดตัว เดินเร็วขึ้น", "slot": ""},
		{"id": "fs_sk_sb_suplex", "class": "SAMBO", "name": "35.2 Bear Suplex", "text": "กอดมอนทุ่มสะพานหลัง พื้นแตกวงใหญ่", "slot": "ซุปเพล็กซ์"},
		{"id": "fs_sk_sb_leglock", "class": "SAMBO", "name": "35.3 Leg Lock", "text": "สไลด์เข้าไปล็อกขา มอนตรึง 3 วิ", "slot": "ล็อกขา"},
		{"id": "fs_sk_sb_iron", "class": "SAMBO", "passive": true, "name": "35.4 Iron Grip", "text": "ติดตัว ท่าคว้าทุ่มทั้งหมดดาเมจ +25%", "slot": ""},
		{"id": "fs_sk_sb_chain", "class": "SAMBO", "name": "45.1 Throw Chain", "text": "ทุ่มมอนรอบตัวต่อเนื่องทีละตัว สูงสุด 3 ตัว", "slot": "ทุ่มต่อ"},
		{"id": "fs_sk_sb_bear", "class": "SAMBO", "name": "45.2 Bear Hug", "text": "กดค้างกอดรัดมอนตรงหน้า บีบดาเมจต่อเนื่อง", "slot": "กอดหมี"},
		{"id": "fs_sk_sb_tank", "class": "SAMBO", "name": "50.1 Tank Charge", "text": "พุ่งไหล่แบบรถถัง ลากมอนทั้งแถว แล้วกระแทกพื้น", "slot": "รถถัง"},
		{"id": "fs_sk_sb_avalanche", "class": "SAMBO", "name": "55.1 Siberian Avalanche", "text": "คว้ามอนกระโดดสูง ทุ่มลงพื้น หิมะฟุ้ง ทั้งวงลอย", "slot": "หิมะถล่ม"},
		{"id": "fs_sk_sb_winter", "class": "SAMBO", "passive": true, "name": "60.1 Winter Body", "text": "ติดตัว เลือดสูงสุด +70 ฟื้นเลือดช้าๆ", "slot": ""},
		{"id": "fs_sk_sb_grit", "class": "SAMBO", "passive": true, "name": "60.2 Never Tap Out", "text": "ติดตัว เลือดหมดไม่ตาย ฟื้น 30% (คูลดาวน์ 120 วิ)", "slot": ""},
		{"id": "cat_gs_hyper", "class": "GRAND SUMO", "name": "65 HYPER", "text": "ตั้งท่าซูโม่กระทืบพื้น ตัวขยายยักษ์ ฟาดฝ่ามือลงพื้นด้านหน้า 10 ฮิต แล้วกระโดดทิ้งตัวลงมาตูม", "slot": "HYPER"},
		{"id": "cat_kf_hyper", "class": "KUNG FU", "name": "65 HYPER", "text": "ตั้งท่ากังฟู ลมหมุนรอบตัว ฝ่ามือลมยักษ์ผลักรัวไปข้างหน้า แล้วหมัดมังกรลมพุ่งทะลุทั้งจอ", "slot": "HYPER"},
		{"id": "cat_mt_hyper", "class": "MUAY THAI", "name": "65 HYPER", "text": "ไหว้ครูกลางเวที ตีเข่า ศอก เตะรัวเป็นจังหวะกลอง แล้วกระโดดเข่าทุบลงคลื่นทองทั้งจอ", "slot": "HYPER"},
		{"id": "cat_sb_hyper", "class": "SAMBO", "name": "65 HYPER", "text": "คว้ามอนทั้งจอ ทุ่มสลับซ้ายขวาเป็นวงล้อ แล้วกระโดดสูงทุ่มลง หิมะฟุ้งทั้งจอ", "slot": "HYPER"},
	],
	"spear": [
		{"id": "sp_sk_orb", "class": "BASIC", "name": "1.1 Purrball Pop", "text": "ปล่อยพลังกลมเล็กๆ ไปด้านหน้า ทำดาเมจ มอนชะงัก", "slot": "บอลพลัง"},
		{"id": "sp_sk_quake", "class": "BASIC", "name": "1.5 Pounce Quake", "text": "กระโดดขึ้นฟ้าแล้วฟาดหอกลงมา พื้นแตกกระจายทั้งเศษละเอียดและก้อนใหญ่", "slot": "ฟาดพื้น"},
		{"id": "sp_sk_pierce", "class": "BASIC", "name": "5.1 Claw & Pull", "text": "แทงหอกสีดำส้มไปด้านหน้าอย่างแรง แล้วดึงกลับมา ดึงมอนเข้าหาตัว", "slot": "แทงดึง"},
		{"id": "sp_sk_dodge", "class": "BASIC", "passive": true, "name": "10.1 Nine Whiskers", "text": "ติดตัว เมื่อโดนโจมตี ถอยหลังและกระโดดหนีเอง ไม่ใช้ MP (คูลดาวน์ 8 วิ)", "slot": ""},
		{"id": "sp_sk_rapid", "class": "BASIC", "name": "15.1 Pawpaw Flurry", "text": "แทงหอกรัว 10 ฮิต ฮิตสุดท้ายมอนกระเด็น", "slot": "แทงรัว"},
		{"id": "sp_sk_ring", "class": "BASIC", "name": "20.1 Tail Spin Ring", "text": "ปาหอกไปด้านหน้า แล้วหอกหมุนรอบตัว เกิดวงกลมหอกสีดำรอบๆ ทำดาเมจต่อเนื่อง", "slot": "วงหอก"},
		{"id": "sp_sk_shoulder", "class": "BASIC", "name": "20.2 Shoulder Meow", "text": "พุ่งไปด้านหน้าเอาไหล่ชน มอนสตั๊น ติด SA", "slot": "ไหล่ชน"},
		{"id": "sp_sk_tg_pounce", "class": "PETIT TIGER", "name": "15.2 Pounce-a-Paw", "text": "กระโดดตะครุบไปด้านหน้า ลงพื้นกระแทก มอนลอย", "slot": "ตะครุบ"},
		{"id": "sp_sk_tg_claw", "class": "PETIT TIGER", "name": "15.3 Claw-some Rush", "text": "พุ่งไปหน้าข่วนรัว 6 ฮิต ติด SA ฮิตสุดท้ายมอนกระเด็น", "slot": "ข่วนรัว"},
		{"id": "sp_sk_tg_eye", "class": "PETIT TIGER", "passive": true, "name": "15.4 Tiger Eye Crit", "text": "ติดตัว ตีโดนมีโอกาส 20% คริติคอล แรงขึ้น 1.5 เท่า", "slot": ""},
		{"id": "sp_sk_tg_roar", "class": "PETIT TIGER", "name": "15.5 Roar-some Up", "text": "คำรามผลักมอนรอบตัว บัพพลังโจมตี +25% 15 วิ", "slot": "คำราม"},
		{"id": "sp_sk_tg_stripes", "class": "PETIT TIGER", "name": "25.1 Stripe Streak", "text": "กลิ้งพุ่งไปหน้า ทิ้งลายเสือบนพื้น มอนที่อยู่บนลายโดนดาเมจต่อเนื่องและช้าลง", "slot": "ลายเสือ"},
		{"id": "sp_sk_tg_charge", "class": "PETIT TIGER", "name": "30.1 Fang Charge", "text": "กดค้างชาร์จหอก ปล่อยแล้วพุ่งแทงทะลุ ยิ่งชาร์จนานยิ่งแรงยิ่งไกล ชาร์จเต็มมอนล้ม", "slot": "ชาร์จแทง"},
		{"id": "sp_sk_tg_sky", "class": "PETIT TIGER", "name": "30.2 Sky Swipe", "text": "ใช้กลางอากาศได้ บนพื้นข่วนเสยมอนลอยแล้วกระโดดตาม กลางอากาศข่วนฟาดลงมอนล้ม", "slot": "ข่วนฟ้า"},
		{"id": "sp_sk_tg_tumble", "class": "PETIT TIGER", "name": "35.1 Tumble Tiger", "text": "ม้วนตัวกลิ้งทะลุไปหน้า ไม่โดนดาเมจระหว่างกลิ้ง แล้วหมุนหอกฟาดลง", "slot": "ม้วนฟาด"},
		{"id": "sp_sk_tg_stride", "class": "PETIT TIGER", "passive": true, "name": "40.1 Big Cat Stride", "text": "ติดตัว เดินเร็วขึ้น 10% ความเร็วโจมตีเพิ่ม 12%", "slot": ""},
		{"id": "sp_sk_fp_chain", "class": "FIERCE PROWLER", "name": "35.2 Pounce Chain", "text": "ตะครุบกระโดดไปหามอนที่ใกล้สุดต่อเนื่อง 3 ตัว ตัวสุดท้ายมอนลอย", "slot": "ตะครุบต่อ"},
		{"id": "sp_sk_fp_lunge", "class": "FIERCE PROWLER", "name": "35.3 Prowl Lunge", "text": "ติด SA พุ่งแทงไกลครึ่งจอ มอนกระเด็น ทิ้งลายเสือตามทาง", "slot": "พุ่งไกล"},
		{"id": "sp_sk_fp_instinct", "class": "FIERCE PROWLER", "passive": true, "name": "35.4 Hunter Instinct", "text": "ติดตัว ตีมอนที่เลือดเหลือไม่ถึงครึ่ง แรงขึ้น 20%", "slot": ""},
		{"id": "sp_sk_fp_roar", "class": "FIERCE PROWLER", "name": "45.1 Thunder Purr", "text": "คำรามใหญ่ติด SA มอนทั่วจอสตั๊นและอ่อนแรง 5 วิ", "slot": "คำรามใหญ่"},
		{"id": "sp_sk_fp_whirl", "class": "FIERCE PROWLER", "name": "45.2 Whirl-a-Claw", "text": "กดค้างหมุนหอกเป็นพายุเล็บเดินหน้า ดาเมจต่อเนื่อง ใช้มานาต่อเนื่อง", "slot": "หมุนเล็บ"},
		{"id": "sp_sk_fp_storm", "class": "FIERCE PROWLER", "name": "50.1 Stripe Storm", "text": "ปล่อยลูกไฟลายเสือ 5 ลูก บานออกแล้ววิ่งตามมอน", "slot": "ลูกไฟตาม"},
		{"id": "sp_sk_fp_king", "class": "FIERCE PROWLER", "name": "55.1 King of Claws", "text": "ติด SA แทงเสยมอนลอย กระโดดตามแล้วทุ่มหอกลงพื้นระเบิดวงกว้าง", "slot": "ราชันเสือ"},
		{"id": "sp_sk_fp_heart", "class": "FIERCE PROWLER", "passive": true, "name": "60.1 Wild Heart", "text": "ติดตัว เลือดสูงสุด +80 ตีคอมโบโดนได้มานาเพิ่ม", "slot": ""},
		{"id": "sp_sk_fp_rage", "class": "FIERCE PROWLER", "passive": true, "name": "60.2 Last Stripe Rage", "text": "ติดตัว เลือดต่ำกว่า 35% ตีแรงขึ้น 30% เดินเร็วขึ้น", "slot": ""},
		{"id": "sp_sk_fg_ball", "class": "PETIT FANG", "name": "15.2 Howl-o Ball", "text": "ใช้กลางอากาศได้ ยิงบอลหน้าแมวหมาป่าลูกใหญ่ช้าๆ ทะลุมอน", "slot": "บอลหมาป่า"},
		{"id": "sp_sk_fg_howl", "class": "PETIT FANG", "name": "15.3 Moon Meowl", "text": "หอนใต้แสงจันทร์ บัพ 20 วิ ตีแรงขึ้น 15% ตีคอมโบโดนดูดเลือด", "slot": "หอนจันทร์"},
		{"id": "sp_sk_fg_pelt", "class": "PETIT FANG", "passive": true, "name": "15.4 Dark Pelt", "text": "ติดตัว เลือดสูงสุด +60", "slot": ""},
		{"id": "sp_sk_fg_bite", "class": "PETIT FANG", "name": "15.5 Bite & Purr", "text": "พุ่งกัดด้านหน้า ดูดเลือดคืน 5% ต่อมอนที่กัดโดน", "slot": "พุ่งกัด"},
		{"id": "sp_sk_fg_pup", "class": "PETIT FANG", "name": "25.1 Shadow Pup", "text": "เรียกลูกหมาป่าเงา 1 ตัว ไล่กัดมอน 10 วิ", "slot": "หมาเงา"},
		{"id": "sp_sk_fg_fan", "class": "PETIT FANG", "name": "30.1 Fang Fan", "text": "ยิงบอลหมาป่า 5 ลูกเป็นรูปพัด", "slot": "บอลพัด"},
		{"id": "sp_sk_fg_pull", "class": "PETIT FANG", "name": "30.2 Dusk Drag", "text": "ปล่อยวังวนมืดด้านหน้า ดูดมอนเข้ามา มอนอ่อนแรง", "slot": "วังวนมืด"},
		{"id": "sp_sk_fg_leap", "class": "PETIT FANG", "name": "35.1 Moon Leap", "text": "ใช้กลางอากาศได้ กระโดดสูงแล้วพุ่งเฉียงลง ระเบิดมืดมอนลอย", "slot": "พุ่งจันทร์"},
		{"id": "sp_sk_fg_night", "class": "PETIT FANG", "passive": true, "name": "40.1 Night Prowl", "text": "ติดตัว มานาสูงสุด +100", "slot": ""},
		{"id": "sp_sk_ld_pack", "class": "LUPINE DIRE", "name": "35.2 Pack Call", "text": "เรียกฝูงหมาป่าเงา 3 ตัว ไล่กัดมอน 12 วิ", "slot": "เรียกฝูง"},
		{"id": "sp_sk_ld_crescent", "class": "LUPINE DIRE", "name": "35.3 Crescent Reap", "text": "ฟาดหอกปล่อยคลื่นจันทร์เสี้ยวทะลุไปด้านหน้า", "slot": "จันทร์เสี้ยว"},
		{"id": "sp_sk_ld_blood", "class": "LUPINE DIRE", "passive": true, "name": "35.4 Blood Moon Fang", "text": "ติดตัว สกิลโดนมอน ดูดเลือดคืน 1%", "slot": ""},
		{"id": "sp_sk_ld_eclipse", "class": "LUPINE DIRE", "name": "45.1 Eclipse Howl", "text": "เรียกจันทร์คราส มอนทั่วจออ่อนแรง บอลหมาป่าตกจากฟ้า 8 ลูก", "slot": "จันทร์คราส"},
		{"id": "sp_sk_ld_barrage", "class": "LUPINE DIRE", "name": "45.2 Lunar Barrage", "text": "กดค้างยิงบอลหมาป่ารัว ใช้มานาต่อเนื่อง", "slot": "ยิงรัว"},
		{"id": "sp_sk_ld_swap", "class": "LUPINE DIRE", "name": "50.1 Shadow Swap", "text": "ใช้กลางอากาศได้ วาปไปด้านหลังมอนที่ใกล้สุดแล้วแทงสวน มอนล้ม", "slot": "วาปหลัง"},
		{"id": "sp_sk_ld_maw", "class": "LUPINE DIRE", "name": "55.1 Fenrir Maw", "text": "ยิงหัวหมาป่ายักษ์ลอยช้าๆ ทะลุทุกตัว แล้วระเบิดมืด", "slot": "หมาป่ายักษ์"},
		{"id": "sp_sk_ld_hunter", "class": "LUPINE DIRE", "passive": true, "name": "60.1 Night Hunter", "text": "ติดตัว ตีแรงขึ้น 20%", "slot": ""},
		{"id": "sp_sk_ld_alpha", "class": "LUPINE DIRE", "passive": true, "name": "60.2 Alpha Comeback", "text": "ติดตัว เลือดหมดไม่ตาย ฟื้น 25% แล้วเรียกหมาเงา 2 ตัว (คูลดาวน์ 120 วิ)", "slot": ""},
		{"id": "sp_sk_vx_scratch", "class": "PETIT VIXEN", "name": "15.2 Fox Scratch", "text": "ใช้กลางอากาศได้ ข่วนรอยจิ้งจอก 3 ชุดไปด้านหน้า ชุดสุดท้ายมอนกระเด็น", "slot": "ข่วนจิ้งจอก"},
		{"id": "sp_sk_vx_fire", "class": "PETIT VIXEN", "name": "15.3 Foxfire Fluff", "text": "ไฟจิ้งจอก 3 ลูกหมุนรอบตัว 8 วิ โดนมอนต่อเนื่อง", "slot": "ไฟจิ้งจอก"},
		{"id": "sp_sk_vx_nimble", "class": "PETIT VIXEN", "passive": true, "name": "15.4 Nimble Tail", "text": "ติดตัว โดนโจมตีมีโอกาส 12% หลบได้", "slot": ""},
		{"id": "sp_sk_vx_blink", "class": "PETIT VIXEN", "name": "15.5 Blink-a-Meow", "text": "ใช้กลางอากาศได้ วาปไปด้านหน้า มอนตามทางโดนดาเมจ", "slot": "วาป"},
		{"id": "sp_sk_vx_pin", "class": "PETIT VIXEN", "name": "25.1 Hairpin Toss", "text": "ปาปิ่นปักผม 5 อันเป็นรูปพัด", "slot": "ปาปิ่น"},
		{"id": "sp_sk_vx_clone", "class": "PETIT VIXEN", "name": "30.1 Mirror Kit", "text": "สร้างร่างเงาจิ้งจอกด้านหน้า 6 วิ ข่วนมอนใกล้ๆ เอง", "slot": "ร่างเงา"},
		{"id": "sp_sk_vx_trap", "class": "PETIT VIXEN", "name": "30.2 Fox Snare", "text": "วางวงยันต์จิ้งจอกบนพื้น มอนเหยียบแล้วระเบิด ติดอยู่กับที่ 3 วิ", "slot": "กับดัก"},
		{"id": "sp_sk_vx_tail", "class": "PETIT VIXEN", "name": "35.1 Tail Whirl", "text": "หมุนเก้าหางรอบตัว ข่วนรอบทิศ มอนลอย", "slot": "หมุนหาง"},
		{"id": "sp_sk_vx_grace", "class": "PETIT VIXEN", "passive": true, "name": "40.1 Fox Grace", "text": "ติดตัว เดินเร็วขึ้น 10%", "slot": ""},
		{"id": "sp_sk_pv_rush", "class": "PHANTOM VULPINE", "name": "35.2 Phantom Dash", "text": "วาปข่วนสลับซ้ายขวารอบมอน 4 ครั้ง ไม่โดนดาเมจ ครั้งสุดท้ายมอนลอย", "slot": "วาปข่วน"},
		{"id": "sp_sk_pv_pins", "class": "PHANTOM VULPINE", "name": "35.3 Pin Rain", "text": "ปิ่นปักผม 9 อันตกจากฟ้าลงด้านหน้า", "slot": "ฝนปิ่น"},
		{"id": "sp_sk_pv_veil", "class": "PHANTOM VULPINE", "passive": true, "name": "35.4 Illusion Veil", "text": "ติดตัว โดนตีมีโอกาส 30% วาปหนีไปด้านหลัง ทิ้งร่างเงาที่ระเบิด (คูลดาวน์ 6 วิ)", "slot": ""},
		{"id": "sp_sk_pv_nova", "class": "PHANTOM VULPINE", "name": "45.1 Foxfire Nova", "text": "กดค้างชาร์จไฟจิ้งจอก ปล่อยวงไฟฟ้าขาวระเบิดรอบตัว มอนแข็ง ยิ่งชาร์จยิ่งกว้าง", "slot": "ไฟระเบิด"},
		{"id": "sp_sk_pv_lift", "class": "PHANTOM VULPINE", "name": "45.2 Nine Tail Lift", "text": "ใช้กลางอากาศได้ ข่วนเก้าหาง 9 รอยขึ้นฟ้า มอนลอย", "slot": "เก้าหาง"},
		{"id": "sp_sk_pv_mirage", "class": "PHANTOM VULPINE", "name": "50.1 Kitsune Mirage", "text": "สร้างร่างเงา 3 ร่างด้านหน้า ข่วนมอนแล้วระเบิด", "slot": "ร่างลวง"},
		{"id": "sp_sk_pv_beam", "class": "PHANTOM VULPINE", "name": "55.1 Moonfox Beam", "text": "ติด SA ยิงลำแสงจันทร์จิ้งจอกสีฟ้าขาวยาวไปด้านหน้า", "slot": "ลำแสง"},
		{"id": "sp_sk_pv_fortune", "class": "PHANTOM VULPINE", "passive": true, "name": "60.1 Fox Fortune", "text": "ติดตัว โอกาสหลบเป็น 18% มานาฟื้นเร็วขึ้น 30%", "slot": ""},
		{"id": "sp_sk_pv_ghost", "class": "PHANTOM VULPINE", "passive": true, "name": "60.2 Ghost Tail", "text": "ติดตัว คูลดาวน์สกิลลดลง 15%", "slot": ""},
		{"id": "sp_sk_sh_talis", "class": "PETIT SHELL", "name": "15.2 Paw Talisman", "text": "ใช้กลางอากาศได้ ปายันต์ 3 ใบทะลุไปด้านหน้า", "slot": "ปายันต์"},
		{"id": "sp_sk_sh_guard", "class": "PETIT SHELL", "name": "15.3 Shell Guard", "text": "ตั้งการ์ดกระดอง 1.5 วิ ไม่โดนดาเมจ มอนเข้าใกล้สวนกลับทันที", "slot": "การ์ดสวน"},
		{"id": "sp_sk_sh_tough", "class": "PETIT SHELL", "passive": true, "name": "15.4 Tough Shell", "text": "ติดตัว เลือดสูงสุด +80", "slot": ""},
		{"id": "sp_sk_sh_stomp", "class": "PETIT SHELL", "name": "15.5 Turtle Stomp", "text": "กระทืบพื้น แผ่นดินไหวรอบตัว หินโผล่ มอนลอย", "slot": "กระทืบ"},
		{"id": "sp_sk_sh_snake", "class": "PETIT SHELL", "name": "25.1 Water Snake Whip", "text": "ฟาดแส้งูน้ำไปด้านหน้า ดึงมอนเข้าหาตัว", "slot": "แส้งู"},
		{"id": "sp_sk_sh_ward", "class": "PETIT SHELL", "name": "30.1 Turtle Ward", "text": "กระดองครอบตัว ติด SA 8 วิ", "slot": "กระดอง SA"},
		{"id": "sp_sk_sh_seal", "class": "PETIT SHELL", "name": "30.2 Seal Charm", "text": "ปายันต์ผนึกลงพื้นด้านหน้า มอนในวงติดอยู่กับที่ 3 วิ", "slot": "ยันต์ผนึก"},
		{"id": "sp_sk_sh_rock", "class": "PETIT SHELL", "name": "35.1 Rock-a-Bye Rise", "text": "เสาหินโผล่จากพื้นไล่ไปด้านหน้า 3 ต้น มอนลอย", "slot": "เสาหิน"},
		{"id": "sp_sk_sh_steady", "class": "PETIT SHELL", "passive": true, "name": "40.1 Steady Shell", "text": "ติดตัว โดนโจมตีมีโอกาส 10% กันได้", "slot": ""},
		{"id": "sp_sk_gb_dome", "class": "GENBU TITAN", "name": "35.2 Black Tortoise", "text": "กระดองเต่าดำครอบตัว 6 วิ ไม่โดนดาเมจ ผลักมอนรอบตัว", "slot": "โดมกระดอง"},
		{"id": "sp_sk_gb_serpent", "class": "GENBU TITAN", "name": "35.3 Twin Serpent", "text": "งูน้ำคู่ฟาดไปด้านหน้าหลายฮิต", "slot": "งูคู่"},
		{"id": "sp_sk_gb_iron", "class": "GENBU TITAN", "passive": true, "name": "35.4 Iron Shell", "text": "ติดตัว เลือดสูงสุด +70 (บวกกับ Tough Shell)", "slot": ""},
		{"id": "sp_sk_gb_storm", "class": "GENBU TITAN", "name": "45.1 Talisman Storm", "text": "ยันต์ 12 ใบพุ่งออกรอบทิศ", "slot": "พายุยันต์"},
		{"id": "sp_sk_gb_drop", "class": "GENBU TITAN", "name": "45.2 Mountain Drop", "text": "ใช้กลางอากาศได้ กระโดดทิ้งตัวเหมือนภูเขาตก แผ่นดินไหววงกว้าง", "slot": "ภูเขาตก"},
		{"id": "sp_sk_gb_seals", "class": "GENBU TITAN", "name": "50.1 Five Seal Ward", "text": "ปักยันต์ 5 ใบเรียงไปด้านหน้า 1 วิแล้วระเบิดพร้อมกัน", "slot": "ยันต์ห้า"},
		{"id": "sp_sk_gb_quake", "class": "GENBU TITAN", "name": "55.1 Genbu Quake", "text": "ติด SA ปักหอก คลื่นหินแผ่นดินไหววิ่งไปด้านหน้า 7 ครั้ง", "slot": "คลื่นหิน"},
		{"id": "sp_sk_gb_body", "class": "GENBU TITAN", "passive": true, "name": "60.1 Genbu Body", "text": "ติดตัว โดนโจมตีมีโอกาส 15% กันได้ ฟื้นเลือดช้าๆ", "slot": ""},
		{"id": "sp_sk_gb_reflect", "class": "GENBU TITAN", "passive": true, "name": "60.2 Mirror Shell", "text": "ติดตัว โดนตีแล้วกระดองระเบิดสวนรอบตัว (คูลดาวน์ 3 วิ)", "slot": ""},
		{"id": "cat_fp_hyper", "class": "FIERCE PROWLER", "name": "65 HYPER", "text": "ออร่าวิญญาณเสือทองคำรามคลื่นกระแทก พุ่งแทงทะลวง เงาเสือยักษ์ตะปบซ้ำ ทำลายเกราะ", "slot": "HYPER"},
		{"id": "cat_ld_hyper", "class": "LUPINE DIRE", "name": "65 HYPER", "text": "ควงหอกเขตจันทร์เสี้ยว หายไปในความมืด หมาป่าวิญญาณรุมขย้ำ ปักหอกระเบิดคลื่นเขี้ยว", "slot": "HYPER"},
		{"id": "cat_pv_hyper", "class": "PHANTOM VULPINE", "name": "65 HYPER", "text": "ร่ายรำหอกเพลิงวิญญาณ หางจิ้งจอกพันมอนลอย แทงรูปดาวกระจาย จิ้งจอกเก้าหางพ่นไฟ", "slot": "HYPER"},
		{"id": "cat_gt2_hyper", "class": "GENBU TITAN", "name": "65 HYPER", "text": "ปักหอก กระดองบาเรียดูดซับ ระเบิดแผ่นดินไหว หอกกลายเป็นงูเหล็กกระแทกมอนกระเด็น", "slot": "HYPER"},
	],
	"bow": [
		{"id": "bw_sk_dodge_shot", "class": "BASIC", "name": "1.1 Leap & Purr Shot", "text": "กระโดดถอยหลบดาเมจ แล้วยิงลูกศร 3 ดอกแนวเฉียงลง", "slot": "หลบยิง"},
		{"id": "bw_sk_storm_arrow", "class": "BASIC", "name": "1.2 Green Purr Gale", "text": "กระโดดยิงศรลงพื้น เกิดพายุเขียวพัดไปด้านหน้าช้าๆ", "slot": "พายุเขียว"},
		{"id": "bw_sk_knee_kick", "class": "BASIC", "name": "5.1 Kneeow Kick", "text": "พุ่งเอาเข่าชน แล้วเตะซ้ำ", "slot": "เข่าเตะ"},
		{"id": "bw_sk_zigzag", "class": "BASIC", "name": "10.1 Zig-Zag Hairball", "text": "กระโดดกลางอากาศ ยิงลูกบอลลมซิกแซกไปมาด้านหน้า วงกว้าง", "slot": "บอลลม"},
		{"id": "bw_sk_spin_up", "class": "BASIC", "name": "15.1 Twirl Tail Kick", "text": "ตวัดตัวหมุนเตะ แล้วเตะเสยขึ้น", "slot": "หมุนเตะ"},
		{"id": "bw_sk_red_wind", "class": "BASIC", "name": "20.1 Ruby Wind Roar", "text": "ยิงพลังลมสีแดงผสมเขียวไปด้านหน้า กว้าง ไกล 3 จอ", "slot": "ลมแดง"},
		{"id": "bw_sk_push_shot", "class": "BASIC", "name": "20.2 Shoo Arrow", "text": "ยิงศรลมไปด้านหน้า เป้าหมายถูกผลักถอย", "slot": "ศรผลัก"},
		{"id": "bw_sk_ws_wave", "class": "WINDSTARKER", "name": "15.2 Whisker Wind", "text": "กระโดดเตะคลื่นลมเขียวกระจายไปมาด้านหน้าอย่างแรง กดค้างยิงต่อเนื่อง", "slot": "คลื่นลม"},
		{"id": "bw_sk_ws_sweep", "class": "WINDSTARKER", "name": "15.3 Swish Sweep", "text": "หมุนตัวเตะกวาด คลื่นลมแนวตรงไปด้านหน้า", "slot": "เตะกวาด"},
		{"id": "bw_sk_ws_haste", "class": "WINDSTARKER", "passive": true, "name": "15.4 Quick Paws", "text": "ติดตัว ความเร็วโจมตีเพิ่มขึ้น", "slot": ""},
		{"id": "bw_sk_ws_slide", "class": "WINDSTARKER", "name": "15.5 Slip-Thru Kick", "text": "สไลด์ไปด้านหน้า โดนเป้าหมายแล้วทะลุไปหลังมอนแล้วเตะขึ้น", "slot": "สไลด์ทะลุ"},
		{"id": "bw_sk_ws_burst", "class": "WINDSTARKER", "name": "30.1 Paw Burst", "text": "รวมพลังที่เท้า กดค้างชาร์จ แล้วเตะล่าง ลมระเบิดวงกว้างด้านหน้า", "slot": "ระเบิดลม"},
		{"id": "bw_sk_ws_back", "class": "WINDSTARKER", "name": "30.2 Mule Kitty Kick", "text": "เตะกลับหลัง (back kick) ไปด้านหน้า", "slot": "เตะกลับหลัง"},
		{"id": "bw_sk_ws_march", "class": "WINDSTARKER", "name": "35.1 Gale Paw Parade", "text": "เตะคลื่นลมหลายแนวพร้อมเดินหน้า ตรง เฉียงขึ้น เฉียงลง แล้วกระโดดทุ่มพื้น ลมรอบตัว", "slot": "พาเหรดลม"},
		{"id": "bw_sk_ws_knee", "class": "WINDSTARKER", "name": "40.1 Flying Kneeow", "text": "พุ่งไปเอาเข่าชกใส่ด้านหน้า", "slot": "เข่าพุ่ง"},
		{"id": "bw_sk_gt_tap", "class": "GALE TEMPEST", "name": "35.2 Tap-Tap Tempo", "text": "เอาเท้าเคาะพื้น บัพ ตีโดนได้มานาคืนมากขึ้น 30 วิ", "slot": "เคาะพื้น"},
		{"id": "bw_sk_gt_dropkick", "class": "GALE TEMPEST", "name": "35.3 Cannon Dropkick", "text": "กระโดดนิดนึงแล้วถีบทั้งตัวพุ่งไปด้านหน้าครึ่งจออย่างแรง", "slot": "ถีบพุ่ง"},
		{"id": "bw_sk_gt_vigor", "class": "GALE TEMPEST", "passive": true, "name": "35.4 Fluffy Vigor", "text": "ติดตัว เลือดและมานาสูงสุดเพิ่มขึ้น", "slot": ""},
		{"id": "bw_sk_gt_song", "class": "GALE TEMPEST", "name": "45.1 Wind Lullameow", "text": "ร่ายพลังแห่งสายลม วงเวทดนตรี บัพฟื้นมานา +20 ต่อวินาที 20 วิ", "slot": "เพลงลม"},
		{"id": "bw_sk_gt_slam", "class": "GALE TEMPEST", "name": "45.2 Sky Pounce", "text": "ใช้กลางอากาศได้ กระโดดทุ่มพื้น เกิดวงกว้างครึ่งจออย่างแรง", "slot": "ทุ่มพื้น"},
		{"id": "bw_sk_gt_roll", "class": "GALE TEMPEST", "name": "50.1 Roly Wind Kick", "text": "กระโดดม้วนตัวเตะคลื่นลมไปด้านหน้า", "slot": "ม้วนเตะ"},
		{"id": "bw_sk_gt_slide4", "class": "GALE TEMPEST", "name": "55.1 Quad Slide Paws", "text": "สไลด์ไปด้านหน้าต่อเนื่อง 4 ฮิต", "slot": "สไลด์ 4"},
		{"id": "bw_sk_gt_swift", "class": "GALE TEMPEST", "passive": true, "name": "60.1 Breezy Steps", "text": "ติดตัว ความเร็วการเคลื่อนที่เพิ่มขึ้น", "slot": ""},
		{"id": "bw_sk_gt_revive", "class": "GALE TEMPEST", "passive": true, "name": "60.2 Second Whisker", "text": "ติดตัว เลือดหมดไม่ตายทันที ถอยหลังไกลแล้วฟื้นเลือด 10 วิ คูลดาวน์ 120 วิ", "slot": ""},
		{"id": "bw_sk_sn_homing", "class": "SNIPESTARKER", "name": "15.2 Seeker Whiskers", "text": "ยิงศรติดตามมอน 5 ดอกไปด้านหน้า ตามได้ทั่วแมพ", "slot": "ศรติดตาม"},
		{"id": "bw_sk_sn_fan", "class": "SNIPESTARKER", "name": "15.3 Ruby Fan Shot", "text": "ยิงศรแดง 5 ดอกเป็นพัดระยะใกล้ไปด้านหน้า ติด sa", "slot": "ศรพัด"},
		{"id": "bw_sk_sn_range", "class": "SNIPESTARKER", "passive": true, "name": "15.4 Long Gaze", "text": "ติดตัว ลูกศรยิงได้ไกลขึ้น", "slot": ""},
		{"id": "bw_sk_sn_whirl", "class": "SNIPESTARKER", "name": "25.1 Hairball Twister", "text": "ยิงลมหมุนไปด้านหน้า ดูดมอนมารวมกัน", "slot": "ลมดูด"},
		{"id": "bw_sk_sn_ring", "class": "SNIPESTARKER", "name": "30.1 Paw Tap Circle", "text": "เคาะพื้นเกิดวงลมเล็กใต้เท้า อยู่ในวงใช้สกิลไม่เสียมานา", "slot": "วงลม"},
		{"id": "bw_sk_sn_bomb", "class": "SNIPESTARKER", "name": "30.2 Boom-Boom Bolt", "text": "รวมพลังที่ศรแล้วยิงไปด้านหน้า ระเบิด 5 ครั้งตามทาง ยิงเลยขอบจอได้", "slot": "ศรระเบิด"},
		{"id": "bw_sk_sn_sky", "class": "SNIPESTARKER", "name": "35.1 Sky Scatter", "text": "โยนพลังลมขึ้นฟ้า แตกกระจายตกลงรอบๆ", "slot": "ลมฟ้า"},
		{"id": "bw_sk_sn_rapid", "class": "SNIPESTARKER", "name": "40.1 Rapid Purr Fire", "text": "กดยิงรัวไปด้านหน้า กดค้างยิงต่อใช้มานา ติด sa", "slot": "ยิงรัว"},
		{"id": "bw_sk_ap_mark", "class": "APEX SNIPER", "name": "35.2 Marked Mouse", "text": "ยิงศรติดตาม โดนแล้วติดเครื่องหมาย ยิงเป้าที่ติดเครื่องหมายแรงขึ้น", "slot": "ติดเครื่องหมาย"},
		{"id": "bw_sk_ap_rain", "class": "APEX SNIPER", "name": "35.3 Purr Arrow Rain", "text": "กระโดดนิดนึงแล้วยิงฝนลูกศรลงด้านหน้า", "slot": "ฝนศร"},
		{"id": "bw_sk_ap_eagle", "class": "APEX SNIPER", "passive": true, "name": "35.4 Eagle Whisker", "text": "ติดตัว การโจมตีปกติแรงขึ้น 15%", "slot": ""},
		{"id": "bw_sk_ap_ice", "class": "APEX SNIPER", "name": "45.1 Frosty Paw Shot", "text": "ยิงศรน้ำแข็งตรงไปด้านหน้า 1.5 จอ มอนแข็ง", "slot": "ศรน้ำแข็ง"},
		{"id": "bw_sk_ap_dive", "class": "APEX SNIPER", "name": "45.2 Pounce Barrage", "text": "กระโดดตั้งท่าชาร์จ แล้วยิงเฉียงลง เกิดลมระเบิดกว้างมาก", "slot": "ยิงเฉียงลง"},
		{"id": "bw_sk_ap_trap", "class": "APEX SNIPER", "name": "50.1 Forest Snare", "text": "ปากับดักป่าไปด้านหน้า มอนที่โดนชะงักติดอยู่ 3 วิแล้วระเบิด", "slot": "กับดักป่า"},
		{"id": "bw_sk_ap_cluster", "class": "APEX SNIPER", "name": "55.1 Cluster Catnip", "text": "ชาร์จพลังที่หัวศร แล้วยิงเป็นกลุ่มพลังไปด้านหน้า", "slot": "กลุ่มพลัง"},
		{"id": "bw_sk_ap_mana", "class": "APEX SNIPER", "passive": true, "name": "60.1 Purr Recharge", "text": "ติดตัว ยิงธนูโดนได้มานาคืนมากขึ้น", "slot": ""},
		{"id": "bw_sk_ap_block", "class": "APEX SNIPER", "passive": true, "name": "60.2 Lucky Dodge", "text": "ติดตัว โดนโจมตีมีโอกาส 11% กันได้", "slot": ""},
		{"id": "bw_sk_mn_tri", "class": "MANASTARKER", "name": "15.2 Tri-Paw Volley", "text": "ยิงศรมานา 3 สีพร้อมกัน แดงติดไฟ ฟ้าแช่แข็ง เหลืองชะงัก ใช้กลางอากาศได้", "slot": "ศร 3 สี"},
		{"id": "bw_sk_mn_beam", "class": "MANASTARKER", "name": "15.3 Prism Purr Beam", "text": "กดค้าง ยิงลำแสงมานายาวไปด้านหน้า สลับสีไปเรื่อยๆ ใช้มานาต่อเนื่อง", "slot": "กดค้าง"},
		{"id": "bw_sk_mn_flow", "class": "MANASTARKER", "passive": true, "name": "15.4 Mana Meow Flow", "text": "ติดตัว มานาฟื้นเร็วขึ้น 60%", "slot": ""},
		{"id": "bw_sk_mn_pool", "class": "MANASTARKER", "name": "25.1 Mana Pool Nap", "text": "วางบ่อมานาใต้เท้า 6 วิ มอนในบ่อโดนดาเมจถี่ ยืนในบ่อฟื้นมานาเพิ่ม", "slot": "บ่อมานา"},
		{"id": "bw_sk_mn_swap", "class": "MANASTARKER", "name": "30.1 Color Swap Purr", "text": "สลับธาตุลูกศรปกติ 15 วิ แดงติดไฟ ฟ้ามีโอกาสแช่แข็ง เหลืองแรงขึ้นได้มานาคืน", "slot": "สลับธาตุ"},
		{"id": "bw_sk_mn_orbs", "class": "MANASTARKER", "name": "30.2 Tri-Orb Orbit", "text": "ลูกแก้วมานา 3 สีหมุนรอบตัว 8 วิ โดนมอนรอบตัว", "slot": "ลูกแก้วหมุน"},
		{"id": "bw_sk_mn_mines", "class": "MANASTARKER", "name": "35.1 Paw Mine Trio", "text": "ปาลูกมานา 3 สีลงพื้นด้านหน้า ระเบิดทีละลูกพร้อมผลธาตุ", "slot": "ลูกระเบิด"},
		{"id": "bw_sk_mn_chain", "class": "MANASTARKER", "name": "40.1 Spark Chain", "text": "ศรประกายเหลือง ชิ่งต่อมอนใกล้ๆ ได้ 6 ตัว มอนชะงัก", "slot": "ศรชิ่ง"},
		{"id": "bw_sk_es_fuse", "class": "ESSENCE WEAVER", "name": "35.2 Orb Fusion Mew", "text": "ลูกแก้ว 3 สีพุ่งไปรวมกันด้านหน้า ระเบิดใหญ่ ติดไฟและแช่แข็ง", "slot": "รวมลูกแก้ว"},
		{"id": "bw_sk_es_rain", "class": "ESSENCE WEAVER", "name": "35.3 Rainbow Rain", "text": "ยิงขึ้นฟ้า ฝนมานา 3 สีตกลงทั่วด้านหน้า", "slot": "ฝน 3 สี"},
		{"id": "bw_sk_es_attune", "class": "ESSENCE WEAVER", "passive": true, "name": "35.4 Essence Attune", "text": "ติดตัว สกิลแรงขึ้น 15% เป้าที่ติดไฟหรือแข็งอยู่แรงขึ้นอีก 15%", "slot": ""},
		{"id": "bw_sk_es_gravity", "class": "ESSENCE WEAVER", "name": "45.1 Gravity Prism", "text": "ปริซึมดูดมอนเข้ามารวมกัน แล้วระเบิด 3 สีต่อกัน ทีสุดท้ายมอนลอย", "slot": "ดูดแล้วระเบิด"},
		{"id": "bw_sk_es_dive", "class": "ESSENCE WEAVER", "name": "45.2 Sky Essence Dive", "text": "กระโดดยิงศร 3 สีเฉียงลง ระเบิดที่พื้น ใช้กลางอากาศได้", "slot": "ยิงเฉียงลง"},
		{"id": "bw_sk_es_spirit", "class": "ESSENCE WEAVER", "name": "50.1 Tri Spirit Kits", "text": "เรียกวิญญาณแมว 3 สี ไล่ตามมอนเอง 8 วิ", "slot": "วิญญาณแมว"},
		{"id": "bw_sk_es_nova", "class": "ESSENCE WEAVER", "name": "55.1 Essence Nova", "text": "กดค้างรวมมานา 3 สี ปล่อยวงระเบิดรอบตัว ยิ่งชาร์จยิ่งกว้าง", "slot": "กดค้างชาร์จ"},
		{"id": "bw_sk_es_echo", "class": "ESSENCE WEAVER", "passive": true, "name": "60.1 Mana Echo", "text": "ติดตัว สกิลโดนมอนได้มานาคืน", "slot": ""},
		{"id": "bw_sk_es_lucky", "class": "ESSENCE WEAVER", "passive": true, "name": "60.2 Lucky Whisker", "text": "ติดตัว ใช้สกิลมีโอกาส 15% ได้มานาคืนทั้งหมด", "slot": ""},
		{"id": "bw_sk_tr_twigs", "class": "TRAPSTARKER", "name": "15.1 Twig Trap Toss", "text": "กระโดดขึ้นนิดนึง ปากิ่งไม้กับดักไปด้านหน้าหลายอัน ระเบิดต่อเนื่อง", "slot": "กิ่งระเบิด"},
		{"id": "bw_sk_tr_dash", "class": "TRAPSTARKER", "name": "15.2 Slash-Thru Dash", "text": "พุ่งไปด้านหน้า เอาดาบฟันทะลุ", "slot": "ฟันพุ่ง"},
		{"id": "bw_sk_tr_power", "class": "TRAPSTARKER", "passive": true, "name": "15.3 Sneaky Paws", "text": "ติดตัว สกิลกับดักแรงขึ้น", "slot": ""},
		{"id": "bw_sk_tr_windarrow", "class": "TRAPSTARKER", "name": "25.1 Pop Wind Arrow", "text": "ยิงศรลมไปด้านหน้า แล้วระเบิดข้างหน้า", "slot": "ศรลมระเบิด"},
		{"id": "bw_sk_tr_skyburst", "class": "TRAPSTARKER", "name": "30.1 Paw-Up Gust", "text": "ยกมือขึ้นฟ้า ลมระเบิดจากพื้นแนวเฉียงผลักมอนออกไป ไกล 2 จอ", "slot": "ลมจากพื้น"},
		{"id": "bw_sk_tr_vines", "class": "TRAPSTARKER", "name": "30.2 Vine Snare", "text": "กระโดดปาเถาวัลย์เล็กลงพื้น มอนที่โดนติดอยู่ โดนดาเมจแต่ไม่ชะงัก", "slot": "เถาวัลย์"},
		{"id": "bw_sk_tr_shock", "class": "TRAPSTARKER", "name": "35.1 Sky-Point Quake", "text": "ชี้นิ้วขึ้นฟ้า คลื่นลมระเบิดจากพื้นแนวเฉียงใส่มอน หลายฮิต", "slot": "คลื่นลมพื้น"},
		{"id": "bw_sk_tr_ball", "class": "TRAPSTARKER", "name": "40.1 Rolly Trap Ball", "text": "ปากับดักลูกกลมกลิ้งไปด้านหน้า โดนมอนแล้วระเบิด ไกล 1 จอ", "slot": "บอลกับดัก"},
		{"id": "bw_sk_tw_stake", "class": "TWILIGHT", "name": "35.2 Stake Stack", "text": "กระโดดปาหมุดกับดักไปด้านหน้า กดซ้ำซ้อนได้ 5 อัน ครบ 5 ระเบิดแรง", "slot": "หมุดกับดัก"},
		{"id": "bw_sk_tw_zigzag", "class": "TWILIGHT", "name": "35.3 Dusk Zig-Slash", "text": "พุ่งฟันดาบไปด้านหน้า แล้วรอยดาบซิกแซกไปมาด้านหลัง", "slot": "ฟันซิกแซก"},
		{"id": "bw_sk_tw_cdr", "class": "TWILIGHT", "passive": true, "name": "35.4 Trick Cat Tempo", "text": "ติดตัว ใช้สกิลกับดักแล้วคูลดาวน์สกิลลดลง", "slot": ""},
		{"id": "bw_sk_tw_windtrap", "class": "TWILIGHT", "name": "45.1 Whirl Snare", "text": "กระโดดปากับดักกลมมีลมรอบ เป้าหมายเดินโดนแล้วลอยขึ้น", "slot": "กับดักลม"},
		{"id": "bw_sk_tw_twigs5", "class": "TWILIGHT", "name": "45.2 Five Twig Traps", "text": "กระโดดปากับดักกิ่งไม้ 5 อันไปด้านหน้า", "slot": "กิ่ง 5 อัน"},
		{"id": "bw_sk_tw_orb", "class": "TWILIGHT", "name": "50.1 Minty Pop Trap", "text": "กระโดดปากับดักกลมสีขาวเขียว โดนแล้วแตกหลายฮิต มอนชะงัก", "slot": "กับดักแตก"},
		{"id": "bw_sk_tw_six", "class": "TWILIGHT", "name": "55.1 Six-Swish Slash", "text": "พุ่งไปด้านหน้าฟาดดาบ 6 ที ทีสุดท้ายมอนลอย", "slot": "ฟาด 6 ที"},
		{"id": "bw_sk_tw_break", "class": "TWILIGHT", "passive": true, "name": "60.1 Dusk Hex", "text": "ติดตัว ใช้สกิลมานาเกิน 200 (นับมานาเดิม) ลดป้องกันและความเร็วเป้าหมาย", "slot": ""},
		{"id": "bw_sk_tw_rush", "class": "TWILIGHT", "passive": true, "name": "60.2 Trap Fever", "text": "ติดตัว ใช้สกิลกับดักครบ 5 ครั้งใน 30 วิ สกิลอื่นคูลดาวน์ลดลง 40 วิ", "slot": ""},
		{"id": "cat_gt_hyper", "class": "GALE TEMPEST", "name": "65 HYPER", "text": "ซ่อนธนู ยกมือเรียกพายุโตขึ้น วิ่งวนรอบพายุเร็วสูง แล้วโดดกระทืบพื้น", "slot": "HYPER"},
		{"id": "cat_as_hyper", "class": "APEX SNIPER", "name": "65 HYPER", "text": "ยิงศรไล่เฉียงขึ้นจนเกือบตั้งฉาก กระโดดหมุนชาร์จ ยิงศรยักษ์ครึ่งจอ ศรก่อนหน้าตามล่ามอน", "slot": "HYPER"},
		{"id": "cat_eb_hyper", "class": "ESSENCE WEAVER", "name": "65 HYPER", "text": "ลอยกลางจอ วงเวท 3 ธาตุ ยิงศรยักษ์ลงพื้น เสาพลัง 3 ธาตุพุ่งขึ้นฟ้า", "slot": "HYPER"},
		{"id": "cat_tw_hyper", "class": "TWILIGHT", "name": "65 HYPER", "text": "ตีลังกายิงศรปักพื้น ตารางกับดักนีออนทั่วจอ ศรสัญญาณจุดระเบิดลูกโซ่", "slot": "HYPER"},
	],
	"mage": [
		{"id": "su_warp", "class": "BASIC", "name": "1.1 Meow-p Warp", "text": "วาร์ปไปทิศที่กดค้าง ซ้าย ขวา ขึ้น ลง", "slot": "วาร์ป"},
		{"id": "su_blast", "class": "BASIC", "name": "1.2 Staff Purr Blast", "text": "รวมพลังที่หัวคฑา ยิงลูกพลังแรง มอนชะงัก", "slot": "ยิงพลัง"},
		{"id": "su_counter_guard", "class": "BASIC", "name": "5.1 Fluff Reflect", "text": "12 วิ โดนตีแล้วระเบิดรอบตัว ไม่ทำดาเมจ มอนกระเด็น", "slot": "สะท้อน"},
		{"id": "su_fire_storm", "class": "BASIC", "name": "10.1 Fire Whirl Kitty", "text": "พายุไฟ 3 ลูกวนรอบตัว 6 วิ ติดไฟ", "slot": "พายุไฟ"},
		{"id": "su_bolt_wide", "class": "BASIC", "name": "15.1 Tail Thunder", "text": "สายฟ้าใหญ่กว้างพุ่งไปด้านหน้า มอนสตั๊น", "slot": "สายฟ้า"},
		{"id": "su_meteor", "class": "BASIC", "name": "20.1 Meow-teor", "text": "ลูกไฟหน้าแมวยักษ์ตกลงด้านหน้า ระเบิด", "slot": "อุกกาบาต"},
		{"id": "su_bind_circle", "class": "BASIC", "name": "20.2 Kitty Bind Circle", "text": "วงเวทรอบตัว 4 วิ มอนในวงขยับไม่ได้", "slot": "ตรึง"},
		{"id": "su_ar_fire_trail", "class": "ARCH MAGE", "name": "15.2 Fire Skimmer", "text": "ลูกไฟวิ่งเลียดพื้นไปด้านหน้า ทะลุหลายตัว", "slot": "ไฟเลียด"},
		{"id": "su_ar_ice_seeker", "class": "ARCH MAGE", "name": "15.3 Ice Mouse Hunter", "text": "ลูกน้ำแข็งไล่ตามมอน ชิ่งไปมา อยู่ 8 วิ", "slot": "ไล่ล่า"},
		{"id": "su_ar_range", "class": "ARCH MAGE", "passive": true, "name": "15.4 Long Fire Shot", "text": "ติดตัว ลูกไฟคอมโบไปไกลขึ้น ทะลุเพิ่ม 2 ตัว", "slot": ""},
		{"id": "su_ar_mana_save", "class": "ARCH MAGE", "name": "25.1 Zen Cat Focus", "text": "บัพ 20 วิ ใช้มานาลดลงครึ่งหนึ่ง", "slot": "ประหยัด"},
		{"id": "su_ar_fire_rain", "class": "ARCH MAGE", "name": "30.1 Fireball Rain", "text": "ลูกไฟตกด้านหน้า กดค้างตกต่อเรื่อยๆ สูบมานา", "slot": "ฝนไฟ"},
		{"id": "su_ar_ice_pillars", "class": "ARCH MAGE", "name": "30.2 Ice Pillar Ring", "text": "เสาน้ำแข็งผุดรอบตัว กดค้างได้ สูบมานา มอนแข็ง", "slot": "เสาน้ำแข็ง"},
		{"id": "su_ar_mana_up", "class": "ARCH MAGE", "name": "35.1 Mana Overflow", "text": "8 วิ ฟื้นฟูมานา 20 หน่วยต่อวินาที", "slot": "มานา+"},
		{"id": "su_ar_chain", "class": "ARCH MAGE", "name": "40.1 Chain Zap Purr", "text": "สายฟ้าชิ่งไปมาระหว่างมอน ตัวเดียวก็โดนซ้ำ", "slot": "ชิ่ง"},
		{"id": "su_em_cross_fire", "class": "ELEMENT MASTER", "name": "35.2 Cross Fire Orbit", "text": "วงเวทด้านหลัง ลูกไฟ 2 ลูกพุ่งไขว้กันไปด้านหน้า", "slot": "ไฟไขว้"},
		{"id": "su_em_mini_storms", "class": "ELEMENT MASTER", "name": "35.3 Tiny Storms x3", "text": "พายุเล็ก 3 ลูกชิ่งไปมาระหว่างมอน", "slot": "พายุจิ๋ว"},
		{"id": "su_em_mana", "class": "ELEMENT MASTER", "passive": true, "name": "35.4 Element Mana", "text": "ติดตัว MP สูงสุด +100 ลูกไฟคอมโบโดนมอนได้มานา", "slot": ""},
		{"id": "su_em_big_wind", "class": "ELEMENT MASTER", "name": "45.1 Giant Gale", "text": "พายุลมใหญ่เคลื่อนช้าๆ ลากมอนไปด้วย", "slot": "พายุลม"},
		{"id": "su_em_float_bolts", "class": "ELEMENT MASTER", "name": "45.2 Float & Thunder", "text": "ลอยกลางอากาศ สายฟ้าฟ้าชมพูรอบตัว กดค้างยิ่งนาน", "slot": "ฟ้าผ่า"},
		{"id": "su_em_ward", "class": "ELEMENT MASTER", "name": "50.1 Bullet Veil", "text": "10 วิ ไม่โดนการโจมตีระยะไกล", "slot": "กันไกล"},
		{"id": "su_em_fire_spread", "class": "ELEMENT MASTER", "name": "55.1 Fire Scatter", "text": "ลูกไฟ 7 ลูกกระจายไปด้านหน้า หลายฮิต", "slot": "ไฟกระจาย"},
		{"id": "su_em_memory", "class": "ELEMENT MASTER", "passive": true, "name": "60.1 Element Memory", "text": "ติดตัว ใช้สกิลธาตุสะสมเกจ ครบ 100% ปล่อยวงธาตุใหญ่ไปด้านหน้า", "slot": ""},
		{"id": "su_em_flow", "class": "ELEMENT MASTER", "passive": true, "name": "60.2 Spell Flow", "text": "ติดตัว มานาฟื้นเร็วขึ้น คูลดาวน์สกิลลดลง", "slot": ""},
		{"id": "cat_em_hyper", "class": "ELEMENT MASTER", "name": "65 HYPER", "text": "วงเวทไฟ น้ำแข็ง ไฟฟ้า 3 วงเรียงสามเหลี่ยม พลังพุ่งขึ้นต่อเนื่อง", "slot": "HYPER"},
		{"id": "su_bt_dim_dust", "class": "BATTLE MAGE", "name": "15.2 Rift Dust Skim", "text": "ผงมิติวิ่งเลียดพื้นไปด้านหน้า", "slot": "ผงมิติ"},
		{"id": "su_bt_form", "class": "BATTLE MAGE", "name": "15.3 Rift Form", "text": "กดสลับร่าง ตีปกติฟื้นมานา ลูกบอลคอมโบเป็นลูกมิติชมพูใหญ่ช้า", "slot": "แปลงร่าง"},
		{"id": "su_bt_power", "class": "BATTLE MAGE", "passive": true, "name": "15.4 Brawler Kitty", "text": "ติดตัว พลังโจมตี +100 MP สูงสุด +100", "slot": ""},
		{"id": "su_bt_rage", "class": "BATTLE MAGE", "name": "25.1 Fired-Up Kitty", "text": "บัพพลังโจมตี 15 วิ", "slot": "ฮึดสู้"},
		{"id": "su_bt_implode", "class": "BATTLE MAGE", "name": "30.1 Rift Implode", "text": "รวมพลังที่หัวคฑา ดูดมอนในจอมารวม ระเบิดวงกว้าง", "slot": "ดูดระเบิด"},
		{"id": "su_bt_stomp", "class": "BATTLE MAGE", "name": "30.2 Rift Stomp", "text": "ใช้กลางอากาศเท่านั้น พุ่งลงกระทืบพื้น มอนลอย", "slot": "กระทืบ"},
		{"id": "su_bt_drain", "class": "BATTLE MAGE", "name": "35.1 Mana Nibble", "text": "ดูดมานาจากมอนด้านหน้าสูงสุด 3 ตัว", "slot": "ดูดมานา"},
		{"id": "su_bt_smash", "class": "BATTLE MAGE", "name": "40.1 Rift Staff Smash", "text": "รวมพลังหัวคฑา ฟาดด้านหน้าแรง มอนสตั๊น", "slot": "ฟาดคฑา"},
		{"id": "su_dc_pull_ball", "class": "DIMENSION CASTER", "name": "35.2 Rift Pull Ball", "text": "ลูกมิติเล็กไปช้าๆ ดูดมอนรอบๆ เข้ามา", "slot": "บอลดูด"},
		{"id": "su_dc_air_burst", "class": "DIMENSION CASTER", "name": "35.3 Sky Rift Burst", "text": "ลอยขึ้นแล้วระเบิดวงรีรอบตัว", "slot": "ระเบิดวงรี"},
		{"id": "su_dc_hurt_mana", "class": "DIMENSION CASTER", "passive": true, "name": "35.4 Fluff Absorb", "text": "ติดตัว โดนโจมตีแล้วได้มานาคืน", "slot": ""},
		{"id": "su_dc_bounce_field", "class": "DIMENSION CASTER", "name": "45.1 Bouncy Rift", "text": "กางวงมิติใหญ่ ลูกมิติชิ่งไปมาข้างใน แล้วระเบิด", "slot": "วงมิติ"},
		{"id": "su_dc_ram", "class": "DIMENSION CASTER", "name": "45.2 Rift Ram", "text": "รวมพลังหัวคฑาพุ่งชนด้านหน้า มอนชะงัก", "slot": "พุ่งชน"},
		{"id": "su_dc_ward", "class": "DIMENSION CASTER", "name": "50.1 Close Guard Veil", "text": "10 วิ ไม่โดนการโจมตีระยะประชิด", "slot": "กันใกล้"},
		{"id": "su_dc_slide", "class": "DIMENSION CASTER", "name": "55.1 Rift Slide Smash", "text": "ฟาดคฑาลงพื้น ไถลตัวลากมอน 3 ฮิต ฮิตสุดท้ายสตั๊น", "slot": "ไถล"},
		{"id": "su_dc_flow", "class": "DIMENSION CASTER", "passive": true, "name": "60.1 Inner Mana", "text": "ติดตัว ความเร็ว +30 ถาวร ตีแรงขึ้นกับมอนเลือดเหลือครึ่ง", "slot": ""},
		{"id": "su_dc_cheap_warp", "class": "DIMENSION CASTER", "passive": true, "name": "60.2 Thrifty Warp", "text": "ติดตัว วาร์ปใช้มานาน้อยลง", "slot": ""},
		{"id": "cat_dc_hyper", "class": "DIMENSION CASTER", "name": "65 HYPER", "text": "ลูกบอลมิติยักษ์ตกกระแทกพื้น แตกเป็นลูกเล็กเพิ่มขึ้นทุกครั้ง", "slot": "HYPER"},
		{"id": "su_dk_dark_trail", "class": "DARK MAGE", "name": "15.2 Shadow Skimmer", "text": "ลูกบอลมืดวิ่งเลียดพื้นไปด้านหน้า", "slot": "มืดเลียด"},
		{"id": "su_dk_smoke_box", "class": "DARK MAGE", "name": "15.3 Smoky Cat Box", "text": "ควันมืดสี่เหลี่ยมค่อยๆ ไปด้านหน้า ชอตลงมา", "slot": "ควันมืด"},
		{"id": "su_dk_orb_up", "class": "DARK MAGE", "passive": true, "name": "15.4 Dark Orb Up", "text": "ติดตัว ลูกบอลมืดในคอมโบแรงขึ้น", "slot": ""},
		{"id": "su_dk_rage", "class": "DARK MAGE", "name": "25.1 Black Cat Power", "text": "บัพพลังโจมตี 15 วิ", "slot": "แมวดำ"},
		{"id": "su_dk_chain_orb", "class": "DARK MAGE", "name": "30.1 Chain Dark Orb", "text": "รวมพลังบนหัว มัดโซ่โยนไป ระเบิดทรงกระบอก เด้งไปอีก 4 ครั้ง", "slot": "โซ่มืด"},
		{"id": "su_dk_dark_burst", "class": "DARK MAGE", "name": "30.2 Dark Circle Burst", "text": "ระเบิดวงเวทมืดรอบตัววงกว้าง มอนชะงัก", "slot": "วงมืด"},
		{"id": "su_dk_web", "class": "DARK MAGE", "name": "35.1 Purple Web", "text": "โยนลูกมืด กางใยม่วง 5 วิ ดาเมจต่อเนื่อง ยืนในใยฟื้นมานา 20 ต่อวินาที", "slot": "ใยม่วง"},
		{"id": "su_dk_staff_spin", "class": "DARK MAGE", "name": "40.1 Giant Staff Spin", "text": "โยนคฑาขยายใหญ่หมุนแนวตั้งไปด้านหน้า", "slot": "คฑาหมุน"},
		{"id": "su_ec_bat", "class": "ECLIPSE", "name": "35.2 Vampurr Bat", "text": "ค้างคาวเกาะมอน ดูดเลือด 4 วิ แล้วระเบิดมอนลอย", "slot": "ค้างคาว"},
		{"id": "su_ec_beam", "class": "ECLIPSE", "name": "35.3 Dark Beam", "text": "ยิงลำแสงมืด 10 วิ กดขึ้นลงบังคับทิศ กดสกิลซ้ำหยุด", "slot": "ลำแสงมืด"},
		{"id": "su_ec_mana_luck", "class": "ECLIPSE", "passive": true, "name": "35.4 Black Cat Luck", "text": "ติดตัว ใช้สกิลมืด 10% ได้มานาคืน", "slot": ""},
		{"id": "su_ec_void_pull", "class": "ECLIPSE", "name": "45.1 Void Nibble Orb", "text": "บอลมืดด้านหน้าดูดมอนรอบๆ มอนอ่อนแรง", "slot": "บอลดูด"},
		{"id": "su_ec_sky_burst", "class": "ECLIPSE", "name": "45.2 Sky Dark Burst", "text": "โยนบอลมืดขึ้นฟ้า ระเบิดวงกว้างรอบตัว", "slot": "แตกฟ้า"},
		{"id": "su_ec_ward", "class": "ECLIPSE", "name": "50.1 Shadow Veil", "text": "10 วิ ไม่โดนการโจมตีระยะไกล", "slot": "กันไกล"},
		{"id": "su_ec_dark_spread", "class": "ECLIPSE", "name": "55.1 Dark Scatter", "text": "ลูกบอลมืด 7 ลูกกระจายไปด้านหน้า หลายฮิต", "slot": "มืดกระจาย"},
		{"id": "su_ec_might", "class": "ECLIPSE", "passive": true, "name": "60.1 Eclipse Fang", "text": "ติดตัว พลังโจมตี +100 มีโอกาส 15% ลดป้องกันมอน -50", "slot": ""},
		{"id": "su_ec_mana", "class": "ECLIPSE", "passive": true, "name": "60.2 Endless Night", "text": "ติดตัว MP สูงสุด +100 มานาฟื้นเร็วขึ้น", "slot": ""},
		{"id": "cat_ec_hyper", "class": "ECLIPSE", "name": "65 HYPER", "text": "ลอยขึ้น ปล่อย void เล็กๆ แล้วขยายกลืนจนเต็มจอ", "slot": "HYPER"},
		{"id": "su_al_poison_trail", "class": "ALCHEMIST MAGE", "name": "15.2 Toxic Skimmer", "text": "ลูกบอลพิษวิ่งเลียดพื้นไปด้านหน้า ติดพิษ", "slot": "พิษเลียด"},
		{"id": "su_al_potion_rain", "class": "ALCHEMIST MAGE", "name": "15.3 Potion Rain", "text": "สุ่มขวดยาตกจากฟ้าในระยะ 8 ช่วงตัว สูงสุด 3 ขวด ขวดละฟื้นมานา 20", "slot": "ขวดตก"},
		{"id": "su_al_arche", "class": "ALCHEMIST MAGE", "passive": true, "name": "15.4 Arche Gauge", "text": "ติดตัว พลังโจมตีเพิ่ม ใช้สกิลได้ Arche 10 ครบ 100 ปุ่ม V รีเซ็ตคูลดาวน์", "slot": ""},
		{"id": "su_al_brew_buff", "class": "ALCHEMIST MAGE", "name": "25.1 Kitty Tonic", "text": "บัพพลังโจมตีและลดการใช้มานา 15 วิ", "slot": "ยาบำรุง"},
		{"id": "su_al_acid_rain", "class": "ALCHEMIST MAGE", "name": "30.1 Cauldron Acid Rain", "text": "หม้อปรุงยาพ่นไอขึ้นฟ้า ฝนกรดตกทั่วจอ", "slot": "ฝนกรด"},
		{"id": "su_al_glitter_bomb", "class": "ALCHEMIST MAGE", "name": "30.2 Glitter Bomb", "text": "ปาลูกพิษจากขวด ระเบิดประกายแวววาว", "slot": "ระเบิดพิษ"},
		{"id": "su_al_ore_line", "class": "ALCHEMIST MAGE", "name": "35.1 Pink Ore Pop", "text": "ทุบพื้น แร่ชมพู 10 ก้อนผุดไปด้านหน้าแล้วระเบิด เหลือวงชมพูเดินผ่านแล้วเร็วขึ้น", "slot": "แร่ชมพู"},
		{"id": "su_al_potions", "class": "ALCHEMIST MAGE", "name": "40.1 Double Potion", "text": "วางขวดมานาสีฟ้ากับขวดพิษไว้คนละฝั่ง เดินเก็บได้ภายใน 30 วิ", "slot": "ขวดยา"},
		{"id": "su_tm_homunculus", "class": "TRANSMUTATION MASTER", "name": "35.2 Homun-kitty", "text": "เรียกแมวลอยหูปีก 30 วิ ยิงลูกประกายทุก 5 วิ", "slot": "โฮมุน"},
		{"id": "su_tm_poison_pool", "class": "TRANSMUTATION MASTER", "name": "35.3 Toxic Pool", "text": "โยนขวดยาลงพื้น เกิดพิษที่พื้น 4 วิ", "slot": "บ่อพิษ"},
		{"id": "su_tm_toxic", "class": "TRANSMUTATION MASTER", "passive": true, "name": "35.4 Toxic Reopen", "text": "ติดตัว มอนที่ติดพิษโดนแรงขึ้น", "slot": ""},
		{"id": "su_tm_triple_blast", "class": "TRANSMUTATION MASTER", "name": "45.1 Triple Toxic Boom", "text": "โยนลูกพิษ ระเบิดรุนแรง 3 ลูกด้านหน้า", "slot": "ระเบิด3"},
		{"id": "su_tm_silver_crystal", "class": "TRANSMUTATION MASTER", "name": "45.2 Silver Branch", "text": "เส้นผลึกเงินพุ่งไปด้านหน้า แตกกิ่งออกไปเรื่อยๆ ราว 1 จอ ใช้กลางอากาศได้", "slot": "ผลึกเงิน"},
		{"id": "su_tm_ward", "class": "TRANSMUTATION MASTER", "name": "50.1 Potion Mist Veil", "text": "10 วิ ไม่โดนการโจมตีระยะไกล", "slot": "กันไกล"},
		{"id": "su_tm_poison_rings", "class": "TRANSMUTATION MASTER", "name": "55.1 Toxic Ring Spin", "text": "ห่วงพิษ 2 อันหมุนรอบตัว 8 วิ", "slot": "ห่วงพิษ"},
		{"id": "su_tm_homun_up", "class": "TRANSMUTATION MASTER", "passive": true, "name": "60.1 Super Homun-kitty", "text": "ติดตัว โฮมุนครูสแรงขึ้น ขวดยา 40.1 ได้มานาทันที ติด SA ไม่มีขวดพิษ", "slot": ""},
		{"id": "su_tm_mana", "class": "TRANSMUTATION MASTER", "passive": true, "name": "60.2 Mana Vault", "text": "ติดตัว MP สูงสุด +100", "slot": ""},
		{"id": "cat_tm_hyper", "class": "TRANSMUTATION MASTER", "name": "65 HYPER", "text": "ต้นไม้ทองใบหนามโตด้านหลัง วงทองแนวตั้งรอบต้นทำดาเมจต่อเนื่อง", "slot": "HYPER"},
	],
}
const BASE_CLASS := {"sword": "BOYS", "cat": "BASIC", "mage": "BASIC", "bow": "BASIC", "spear": "BASIC", "azure": "BASIC", "fist": "BASIC"}  # แมวเริ่มที่ร่าง BASIC
const CLASS_NEXT := {"BASIC": ["SWORD KNIGHT", "MAGIC KNIGHT", "SHIELD KNIGHT", "DARK KNIGHT"], "SWORD KNIGHT": ["GRAND KNIGHT"], "MAGIC KNIGHT": ["FLAME KNIGHT"], "SHIELD KNIGHT": ["GUARDIAN KNIGHT"], "DARK KNIGHT": ["CRIMSON KNIGHT"], "ARCH MAGE": ["ELEMENT MASTER"], "BATTLE MAGE": ["DIMENSION CASTER"], "DARK MAGE": ["ECLIPSE"], "ALCHEMIST MAGE": ["TRANSMUTATION MASTER"]}
## CAT SUSI เริ่มที่ BASIC เหมือนกัน แต่แยกสายเวทของตัวเอง
const MAGE_NEXT := {"BASIC": ["ARCH MAGE", "BATTLE MAGE", "DARK MAGE", "ALCHEMIST MAGE"]}
## CAT MATCHA นักธนู 4 สาย แต่ละสายต่อยอดอีกขั้น
const BOW_NEXT := {"BASIC": ["WINDSTARKER", "SNIPESTARKER", "MANASTARKER", "TRAPSTARKER"]}
const BOW_TIER2 := {"WINDSTARKER": ["GALE TEMPEST"], "SNIPESTARKER": ["APEX SNIPER"], "MANASTARKER": ["ESSENCE WEAVER"], "TRAPSTARKER": ["TWILIGHT"]}
const BOW_STYLES := {"WINDSTARKER": "cat_bow_wind", "GALE TEMPEST": "cat_bow_gale", "SNIPESTARKER": "cat_bow_snipe", "APEX SNIPER": "cat_bow_apex", "MANASTARKER": "cat_bow_mana", "ESSENCE WEAVER": "cat_bow_essence", "TRAPSTARKER": "cat_bow_trap", "TWILIGHT": "cat_bow_twilight"}

## CAT CITRUS หอกยาว 4 สาย แต่ละสายต่อยอดอีกขั้น
const FIST_NEXT := {"BASIC": ["HEAVYWEIGHT", "ZEPHYR", "WAR MUAY", "SYSTEMA GRAPPLER"]}
const FIST_TIER2 := {"HEAVYWEIGHT": ["GRAND SUMO"], "ZEPHYR": ["KUNG FU"], "WAR MUAY": ["MUAY THAI"], "SYSTEMA GRAPPLER": ["SAMBO"]}
const FIST_STYLES := {"HEAVYWEIGHT": "cat_fist_heavy", "GRAND SUMO": "cat_fist_sumo", "ZEPHYR": "cat_fist_zephyr", "KUNG FU": "cat_fist_kungfu", "WAR MUAY": "cat_fist_muay", "MUAY THAI": "cat_fist_muaythai", "SYSTEMA GRAPPLER": "cat_fist_systema", "SAMBO": "cat_fist_sambo"}
const SPEAR_NEXT := {"BASIC": ["PETIT TIGER", "PETIT FANG", "PETIT VIXEN", "PETIT SHELL"]}
const SPEAR_TIER2 := {"PETIT TIGER": ["FIERCE PROWLER"], "PETIT FANG": ["LUPINE DIRE"], "PETIT VIXEN": ["PHANTOM VULPINE"], "PETIT SHELL": ["GENBU TITAN"]}
const SPEAR_STYLES := {"PETIT TIGER": "cat_spear_tiger", "FIERCE PROWLER": "cat_spear_prowler", "PETIT FANG": "cat_spear_fang", "LUPINE DIRE": "cat_spear_lupine", "PETIT VIXEN": "cat_spear_vixen", "PHANTOM VULPINE": "cat_spear_phantom", "PETIT SHELL": "cat_spear_shell", "GENBU TITAN": "cat_spear_genbu"}

## CAT AZURE / CAT LAPIS ตัวละครคู่ (ถุงมือกรงเล็บ / ดาบปลายปืน) 2 สาย
const PAIR_NEXT := {"BASIC": ["SPARK DREAMER", "SPARK FIEND"]}
const PAIR_TIER2 := {"SPARK DREAMER": ["SOMNAMBULIST"], "SPARK FIEND": ["NEON BOLT"]}

## อีกตัวของคู่
static func pair_partner(form: String) -> String:
	return "lapis" if form == "azure" else "azure"

## คลาสแรกที่แยกสายจาก BASIC ของตัวละครนี้
## คลาสที่ซ่อนไว้ก่อน (ยังไม่เปิดให้เล่น) ไม่โผล่ในผังคลาสและเควสเปลี่ยนคลาส
const HIDDEN_CLASSES := []

static func first_classes(weapon_id: String) -> Array:
	return _first_classes_raw(weapon_id).filter(func(c) -> bool: return not c in HIDDEN_CLASSES)

static func _first_classes_raw(weapon_id: String) -> Array:
	if weapon_id == "mage":
		return MAGE_NEXT["BASIC"]
	if weapon_id == "bow":
		return BOW_NEXT["BASIC"]
	if weapon_id == "spear":
		return SPEAR_NEXT["BASIC"]
	if weapon_id == "fist":
		return FIST_NEXT["BASIC"]
	if weapon_id == "azure":
		return PAIR_NEXT["BASIC"]
	return CLASS_NEXT.get("BASIC", [])
const ALL_CLASSES := ["BOYS", "SWORD KNIGHT", "WARLORD", "MAGIC KNIGHT", "MAGUS", "DARK KNIGHT", "ABYSS", "DIVINE KNIGHT", "GODHOOD"]
const TAB_WIDTH := {"HEAVYWEIGHT": 210.0, "GRAND SUMO": 200.0, "ZEPHYR": 140.0, "KUNG FU": 150.0, "WAR MUAY": 170.0, "MUAY THAI": 170.0, "SYSTEMA GRAPPLER": 300.0, "SAMBO": 130.0, "SPARK DREAMER": 220.0, "SOMNAMBULIST": 230.0, "SPARK FIEND": 200.0, "NEON BOLT": 180.0, "PETIT TIGER": 190.0, "FIERCE PROWLER": 240.0, "PETIT FANG": 180.0, "LUPINE DIRE": 190.0, "PETIT VIXEN": 190.0, "PHANTOM VULPINE": 260.0, "PETIT SHELL": 190.0, "GENBU TITAN": 200.0, "WINDSTARKER": 200.0, "GALE TEMPEST": 210.0, "SNIPESTARKER": 210.0, "APEX SNIPER": 190.0, "MANASTARKER": 210.0, "ESSENCE WEAVER": 260.0, "TRAPSTARKER": 210.0, "TWILIGHT": 150.0, "BASIC": 100.0, "ARCH MAGE": 150.0, "BATTLE MAGE": 180.0, "DARK MAGE": 160.0, "ALCHEMIST MAGE": 225.0, "ELEMENT MASTER": 230.0, "DIMENSION CASTER": 255.0, "ECLIPSE": 125.0, "TRANSMUTATION MASTER": 320.0, "APPRENTICE": 170.0, "GRAND KNIGHT": 206.0, "FLAME KNIGHT": 200.0, "GUARDIAN KNIGHT": 236.0, "CRIMSON KNIGHT": 222.0, "SHIELD KNIGHT": 206.0, "BOYS": 92.0, "SWORD KNIGHT": 204.0, "WARLORD": 130.0, "MAGIC KNIGHT": 206.0, "MAGUS": 100.0, "DARK KNIGHT": 190.0, "ABYSS": 100.0, "DIVINE KNIGHT": 200.0, "GODHOOD": 130.0}
const TAB_Y := 86.0
const TAB_H := 42.0
const TAB_X := 340.0
const TAB_RIGHT := 1160.0          # แท็บเกินนี้ขึ้นแถวใหม่
const TAB_GAP := 10.0
const TAB_TEXT := 22
const BOX := Rect2(280.0, 30.0, 1000.0, 660.0)
const CARD := Rect2(340.0, 186.0, 430.0, 96.0)
const CARD_GAP := 10.0
const CARD_SMALL_H := 72.0        # การ์ดย่อเมื่อคลาสมีสกิลเกิน 8
const NAME_Y := 36.0
const TEXT_Y := 62.0
const CLOSE_CENTER := Vector2(1216.0, 84.0)
const CLOSE_RADIUS := 44.0
const CLOSE_GLYPH := 16.0
const TITLE_SIZE := 44
const NAME_SIZE := 30
const TEXT_SIZE := 19
const STATE_SIZE := 18
const EMPTY_SIZE := 34
const TEXT_PAD := 28.0
const LINE_THIN := UiStyle.LINE
const LINE_BOLD := UiStyle.LINE_BOLD + 0.5

var weapon := "sword"
var equipped: Array = []          # สกิลในแต่ละช่อง
var tab := 0                      # คลาสที่แสดงอยู่
var root_class := ""              # คลาสที่เลือกตอนสร้างตัวละคร
var level := 99                   # เลเวลตัวละคร สกิลที่ต้องเลเวลสูงกว่านี้ยังใส่ไม่ได้

## CAT SUSI ใช้รายการสกิลของแมว
static func skill_key(weapon_id: String) -> String:
	return weapon_id

## สกิลนี้อยู่ในรายการของตัวละครนี้ไหม (กันสกิลของตัวอื่นค้างในช่อง)
static func in_list(weapon_id: String, id: String) -> bool:
	for skill in SKILLS.get(skill_key(weapon_id), []):
		if skill["id"] == id:
			return true
	return false

## เลเวลที่ต้องมีถึงใช้สกิลนี้ได้ อ่านจากเลขหน้าชื่อ เช่น "15.2 ..." คือ 15 "65 HYPER" คือ 65 ไม่มีเลขคือ 0
static func need_level(skill: Dictionary) -> int:
	var tag := str(skill.get("level", str(skill.get("name", "")).get_slice(" ", 0)))
	var head := tag.get_slice(".", 0)
	return int(head) if head.is_valid_int() else 0

static func find_skill(id: String) -> Dictionary:
	for list in SKILLS.values():
		for skill in list:
			if skill["id"] == id:
				return skill
	return {}

## คลาสนี้และสายต่อยอดทั้งหมด เรียงจากต้นไปปลาย
## ตัว PIXEL กับ CAT ใช้โมเดลของตัวเอง สายดาบทุกคลาสใช้ตัว BOYS
const CAT_STYLES := {"SWORD KNIGHT": "cat_knight", "GRAND KNIGHT": "cat_grand", "FLAME KNIGHT": "cat_flame", "GUARDIAN KNIGHT": "cat_guardian", "CRIMSON KNIGHT": "cat_crimson", "MAGIC KNIGHT": "cat_magic", "SHIELD KNIGHT": "cat_shield", "DARK KNIGHT": "cat_dark"}

const MAGE_STYLES := {"ARCH MAGE": "cat_staff_arch", "ELEMENT MASTER": "cat_staff_element", "BATTLE MAGE": "cat_staff_battle", "DIMENSION CASTER": "cat_staff_dimension", "DARK MAGE": "cat_staff_dark", "ECLIPSE": "cat_staff_eclipse", "ALCHEMIST MAGE": "cat_staff_alch", "TRANSMUTATION MASTER": "cat_staff_trans"}

static func model_style(weapon_id: String, _class_id: String) -> String:
	if weapon_id == "cat":
		return CAT_STYLES.get(_class_id, "cat")
	if weapon_id == "mage":
		return MAGE_STYLES.get(_class_id, "cat_staff")
	if weapon_id == "bow":
		return BOW_STYLES.get(_class_id, "cat_bow")
	if weapon_id == "spear":
		return SPEAR_STYLES.get(_class_id, "cat_spear")
	if weapon_id == "fist":
		return FIST_STYLES.get(_class_id, "cat_fist")
	if weapon_id == "azure":
		return pair_style(WalkPage.pair_form, _class_id)
	return "cat" if BASE_CLASS.has(weapon_id) else ""

## ชุดของตัวละครคู่ตามคลาส ต่อท้ายด้วย ~ ให้ยังขึ้นต้นด้วย cat_azure / cat_lapis เหมือนเดิม
const PAIR_OUTFITS := {"SPARK DREAMER": "dreamer", "SOMNAMBULIST": "somna", "SPARK FIEND": "fiend", "NEON BOLT": "neon"}
static func pair_style(form: String, class_id: String) -> String:
	var suffix: String = PAIR_OUTFITS.get(class_id, "")
	return "cat_" + form + ("~" + suffix if suffix != "" else "")

## คลาสถัดไปของคลาสนี้ SUSI กับ CAT BOYS เริ่มที่ BASIC แต่แยกสายกัน
static func next_of(id: String, weapon_id: String = "") -> Array:
	return _next_of_raw(id, weapon_id).filter(func(c) -> bool: return not c in HIDDEN_CLASSES)

static func _next_of_raw(id: String, weapon_id: String = "") -> Array:
	if weapon_id == "mage" and MAGE_NEXT.has(id):
		return MAGE_NEXT[id]
	if weapon_id == "bow":
		if BOW_NEXT.has(id):
			return BOW_NEXT[id]
		return BOW_TIER2.get(id, [])
	if weapon_id == "spear":
		if SPEAR_NEXT.has(id):
			return SPEAR_NEXT[id]
		return SPEAR_TIER2.get(id, [])
	if weapon_id == "fist":
		if FIST_NEXT.has(id):
			return FIST_NEXT[id]
		return FIST_TIER2.get(id, [])
	if weapon_id == "azure":
		if PAIR_NEXT.has(id):
			return PAIR_NEXT[id]
		return PAIR_TIER2.get(id, [])
	return CLASS_NEXT.get(id, [])

static func lineage(root: String, weapon_id: String = "") -> Array:
	var out := [root]
	for next in next_of(root, weapon_id):
		out.append_array(lineage(next, weapon_id))
	return out

## คลาสก่อนหน้าทั้งหมดของคลาสนี้ เรียงจากคลาสพื้นฐาน
static func ancestors(id: String) -> Array:
	if id in MAGE_NEXT["BASIC"] or id in BOW_NEXT["BASIC"] or id in SPEAR_NEXT["BASIC"] or id in PAIR_NEXT["BASIC"] or id in FIST_NEXT["BASIC"]:
		return ["BASIC"]
	for parent in PAIR_TIER2:
		if id in PAIR_TIER2[parent]:
			return ["BASIC", parent]
	for parent in SPEAR_TIER2:
		if id in SPEAR_TIER2[parent]:
			return ["BASIC", parent]
	for parent in FIST_TIER2:
		if id in FIST_TIER2[parent]:
			return ["BASIC", parent]
	for parent in BOW_TIER2:
		if id in BOW_TIER2[parent]:
			return ["BASIC", parent]
	for parent in CLASS_NEXT:
		if id in CLASS_NEXT[parent]:
			var out := ancestors(parent)
			out.append(parent)
			return out
	return []

## คลาสก่อนหน้า คลาสที่เลือก และสายต่อยอด สายอื่นไม่แสดง
func _classes() -> Array:
	if not BASE_CLASS.has(weapon):
		return []
	# เห็นเฉพาะคลาสตัวเองกับคลาสก่อนหน้า สายต่อยอดยังไม่ได้ จึงไม่แสดง
	var root: String = root_class if root_class != "" else BASE_CLASS[weapon]
	var out := ancestors(root)
	out.append(root)
	return out

## เปิดแผงที่แท็บของคลาสที่เลือกไว้
func open_chosen_tab() -> void:
	tab = maxi(_classes().find(root_class), 0)

## สกิลของคลาสที่แสดงอยู่ สกิลที่ไม่ระบุคลาสเป็นของคลาสแรก
func _skills() -> Array:
	var classes := _classes()
	if classes.is_empty():
		return SKILLS.get(skill_key(weapon), [])
	var out := []
	for skill in SKILLS.get(skill_key(weapon), []):
		if skill.get("class", BASE_CLASS[weapon]) == classes[tab]:
			out.append(skill)
	return out

static func tab_rect(i: int, classes: Array = ALL_CLASSES) -> Rect2:
	var x := TAB_X
	var y := TAB_Y
	for n in i + 1:
		var w := float(TAB_WIDTH[classes[n]])
		if x + w > TAB_RIGHT:
			x = TAB_X
			y += TAB_H + TAB_GAP * 0.5
		if n == i:
			return Rect2(x, y, w, TAB_H)
		x += w + TAB_GAP
	return Rect2()

static func card_rect(i: int, count: int = 0) -> Rect2:
	var size := CARD.size if count <= 8 else Vector2(CARD.size.x, CARD_SMALL_H)
	var gap := CARD_GAP if count <= 8 else CARD_GAP * 0.8
	return Rect2(CARD.position + Vector2((size.x + CARD_GAP * 2.0) * float(i % 2), (size.y + gap) * float(i / 2)), size)

func _input(event: InputEvent) -> void:
	if not visible or not event is InputEventScreenTouch or not event.pressed:
		return
	if event.position.distance_to(CLOSE_CENTER) <= CLOSE_RADIUS:
		closed.emit.call_deferred()
		return
	var tabs := _classes()
	for i in tabs.size():
		if tab_rect(i, tabs).has_point(event.position):
			tab = i
			queue_redraw()
			return
	var list := _skills()
	for i in list.size():
		if card_rect(i, list.size()).has_point(event.position):
			if need_level(list[i]) > level:
				return
			toggled.emit(list[i]["id"])
			queue_redraw()
			return

func _box_line(box: Rect2, seed_no: int, width: float) -> void:
	UiStyle.frame(self, box, seed_no, width)

func _text(word: String, at: Vector2, size_px: int) -> void:
	draw_string(Sketch.font(), at, word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size_px, Sketch.INK)

func _draw() -> void:
	UiStyle.fill(self, BOX, Color(UiStyle.PAPER, 1.0))
	_box_line(BOX, 400, LINE_THIN)
	UiStyle.paw(self, BOX.position + Vector2(28.0, 34.0), 15.0)
	_text("สกิล", BOX.position + Vector2(60.0, 48.0), TITLE_SIZE)
	var ring := Sketch.oval(CLOSE_CENTER, CLOSE_RADIUS, CLOSE_RADIUS, 40)
	ring.append(ring[0])
	Sketch.line(self, ring, 410, LINE_THIN)
	var d := Vector2(CLOSE_GLYPH, CLOSE_GLYPH)
	var e := Vector2(CLOSE_GLYPH, -CLOSE_GLYPH)
	Sketch.line(self, PackedVector2Array([CLOSE_CENTER - d, CLOSE_CENTER + d]), 411, LINE_THIN)
	Sketch.line(self, PackedVector2Array([CLOSE_CENTER - e, CLOSE_CENTER + e]), 412, LINE_THIN)
	var classes := _classes()
	for i in classes.size():
		var box := tab_rect(i, classes)
		UiStyle.fill(self, box, UiStyle.PICKED if i == tab else UiStyle.PAPER)
		_box_line(box, 430 + i, LINE_BOLD if i == tab else LINE_THIN)
		var word: String = classes[i]
		var word_w := Sketch.font().get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, TAB_TEXT).x
		_text(word, box.get_center() + Vector2(-word_w * 0.5, float(TAB_TEXT) * 0.36), TAB_TEXT)
	if _skills().is_empty():
		_text("ยังไม่มีสกิล", CARD.position + Vector2(0.0, 70.0), EMPTY_SIZE)
		return
	var list := _skills()
	for i in list.size():
		var skill: Dictionary = list[i]
		var card := card_rect(i, list.size())
		var small := list.size() > 8
		var slot := equipped.find(skill["id"])
		UiStyle.fill(self, card, UiStyle.PICKED if slot >= 0 else Color(1.0, 1.0, 1.0, 0.6))
		_box_line(card, 420 + i, LINE_BOLD if slot >= 0 else LINE_THIN)
		# ไอคอนแมวของสกิลด้านซ้ายการ์ด
		var icon := minf(card.size.y - 16.0, 58.0)
		SkillIcon.draw(self, card.position + Vector2(TEXT_PAD * 0.5 + icon * 0.5, card.size.y * 0.5), icon, skill["id"], need_level(skill) > level)
		var tx := TEXT_PAD * 0.5 + icon + 10.0
		# ชื่อกับคำอธิบายย่อตัวอักษรให้พอดีการ์ด ชื่อเว้นที่ให้ข้อความสถานะด้านขวา
		var name_px := Sketch.fit_size(skill["name"], NAME_SIZE - (4 if small else 0), card.size.x - tx - (150.0 if small else 12.0), 14)
		_text(skill["name"], card.position + Vector2(tx, NAME_Y - (6.0 if small else 0.0)), name_px)
		# คำอธิบายยาวตัดขึ้นบรรทัดใหม่ ไม่ย่อจนอ่านไม่ออก
		var text_top := NAME_Y + 6.0 - (6.0 if small else 0.0)
		Sketch.draw_wrapped(self, card.position + Vector2(tx, text_top - 4.0), skill["text"], TEXT_SIZE, card.size.x - tx - 12.0, card.size.y - text_top - (10.0 if small else 22.0), UiStyle.INK, 14)
		var state := "ใส่ช่อง %d แล้ว" % (slot + 1) if slot >= 0 else ("แตะเพื่อใส่" if "" in equipped else "ช่องเต็ม")
		if skill.get("passive", false):
			state = "ติดตัวตลอด"
		elif str(skill["id"]).ends_with("_hyper"):
			state = "ปุ่ม HYPER"
		if need_level(skill) > level:
			state = "ต้องเลเวล %d" % need_level(skill)
		var w := Sketch.font().get_string_size(state, HORIZONTAL_ALIGNMENT_LEFT, -1.0, STATE_SIZE).x
		# สถานะอยู่มุมล่างขวา ไม่ทับชื่อสกิล
		# การ์ดย่อ สถานะอยู่มุมขวาบนข้างชื่อ
		_text(state, card.position + Vector2(card.size.x - TEXT_PAD - w, NAME_Y - 6.0 if small else card.size.y - 8.0), STATE_SIZE)
