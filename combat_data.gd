class_name CombatData
extends RefCounted
## ตารางท่าชุดเดียวกับสาย C-Alis ของ Stigma Zero ตัวเลขเท่าเดิมทุกค่า
## หน่วยในตารางเป็นหน่วยโลก เวลาวาดคูณด้วย UNIT
##   sw0/sw1 = องศาดาบตอนง้าง/ปลายการฟัน  ry0/ry1 = หมุนดาบรอบแกนตั้ง  p0/p1 = ตำแหน่งมือ
##   wind/strike = สัดส่วนเวลาง้าง/ฟัน  lunge = แรงพุ่ง  hit_reach/hit_back = ระยะ hitbox หน้า/หลัง
##   hit.type: flinch / launch / knockdown / drop / slam / fall
##   ชื่อคอมโบ: >> แดช  ^ กระโดด  >z กดหน้าแล้ว z  (x) กดค้าง
##   hold = ท่ากดค้าง ปล่อยแล้วจบ  sa = super armor ขอบตัวแดง ไม่ชะงัก  sa_until = ติดถึงวินาทีที่เท่าไรของท่า
##   tick = ตีซ้ำทุกกี่วินาที  tick_max = ตีได้กี่ครั้ง  stabs = มือแทงเข้าออกตามจังหวะ tick
##   flame = เปลวไฟตามแนวฟาด  flame_blast = พ่นไฟจากมือรอง  off_hand = ตำแหน่งมือรองหรือโล่ระหว่างท่า
##   shot = ยิงลูกบอลไฟ  detonate = สั่งระเบิดลูกบอลที่ปล่อยไว้  hit.burn = ทำให้ติดไฟ fire poison ice
##   from_ground = ท่าอากาศที่ต่อจากการดิ่งลงถึงพื้น  no_dash = ไม่บวกแรงพุ่งจากแดช
##   fx_ram = เส้นวิ่งตอนพุ่งและดาวแตกตอนชน  fx_slam = รอยแตก เศษหิน ฝุ่น ตอนกระแทกพื้น
##   <x> ท้ายชื่อ = กดรัว ออกท่าซ้ำได้สูงสุด mash_max ครั้ง  <z กลางชื่อ = กดถอยหลังแล้ว z
##   hop = กระโดดตอนเริ่มท่า  hop_back = ความเร็วถอยหลังระหว่างลอย  shots = ยิงหลายอย่างพร้อมกัน  shot.type = ball potion ground_flame ice_hook
##   wind = ลมพัดด้านหน้า  fx_hit = เอฟเฟกที่ตัวมอน  fx_smoke = ควันตรงหน้า
##   fx_circle = วงเวท ground ใต้ตัว tip ที่หัวคทา หรือ sky บนฟ้าด้านหน้า
##   drone_to = โดรนไปตรงไหน hand foot front ahead orbit  kick = ยื่นเท้าเตะ  stomp = กระทืบพื้น
##   drone_beam = โดรนปล่อยคลื่นกระบอกสั้น  gate_warp = กางประตูวาป ไปข้างหน้ากี่หน่วย
##   tether = โดรนยิงเส้นไฟฟ้าติดตามมอน ตอนกดค้าง  mash_last = ผลของครั้งสุดท้ายในท่ากดรัว  rift_boom = สั่งระเบิดรอยแยก
##   no_turn = ออกจากประตูวาปแล้วไม่หันกลับ
##   rise = ความเร็วลอยขึ้นตอนออกท่า  warp = down วาปลงพื้น target วาปไปหามอน  keeps_chain = ถึงพื้นแล้วคอมโบยังต่อได้
##   dust_gather = สั่งละอองมิติลอยเข้าหาตัว
##   plunge = ความเร็วดิ่งลงหลังง้าง  spin = หมุนตัวกี่รอบ  linear = ดาบหมุนความเร็วคงที่

const UNIT := 90.0     # จุดภาพต่อหนึ่งหน่วยโลก

# สายที่ยังไม่ได้ออกแบบคอมโบใช้ท่าเดี่ยวไปก่อน ท่าอื่นในตารางยังเก็บไว้
# ชุดเต็ม: "zzzz", "xxx", "zzzx", "xxz", ">>zzz", ">>x", ">>^zzz", ">>^xx", "^z", "^x"
const COMBOS := ["z", "x"]
const FLAME := {
	"fire": [Color(0.92, 0.3, 0.12), Color(0.98, 0.72, 0.2)],
	"blood": [Color(0.6, 0.02, 0.06), Color(0.9, 0.15, 0.15)],
	"time": [Color(0.56, 0.28, 0.86), Color(0.86, 0.76, 1.0)],
	"elec": [Color(0.74, 0.62, 0.96), Color(0.93, 0.89, 1.0)],
	"void": [Color(0.3, 0.12, 0.5), Color(0.1, 0.04, 0.18)],
	"poison": [Color(0.3, 0.72, 0.22), Color(0.72, 0.92, 0.3)],
	"ice": [Color(0.3, 0.66, 0.95), Color(0.78, 0.93, 1.0)],
	"water": [Color(0.14, 0.42, 0.86), Color(0.5, 0.78, 0.98)],
	"wind": [Color(0.32, 0.72, 0.58), Color(0.72, 0.94, 0.84)],
}
const JOB_COMBOS := {
	"gwen": ["zzz", "xxxx", ">>zz", ">>x", ">>^z", ">>^x", "^z", "^x", "zz↓z"],
	"high_mage": [">>xx", ">>^xxx", "zzx"],
	"omni_prime": ["zzx<x>", "xxz<z>", ">>xz"],
	"alchemic_mage": [">>xz", "xx↓x", "zz<z"],
	"lord_essence": [">>^xz", ">>zzx", "zzx"],
	"ore_magic": ["zzzzz", ">>^xzz", ">>zx"],
	"dimension_strike": [">>xzz", "zx", ">>^zx"],
	"aid": ["zzzz", "xxx", ">>z", ">>xx", ">>^xx", ">>^zzz", "^z", "^x", "zzxx"],
	"sync_core": ["zzxx", "xx↓(x)", ">>^zx"],
	"twin_node": [">>^xz", ">>z<xx", "zxx"],
	"sync_time": ["xxxx", ">>zx", "zzxx"],
	"psi_clock": [">>^xzz", ">>xzz", "zxxx"],
	"sync_cure": [">>xz", "zxx", ">>^zx"],
	"rogue_medic": ["xzz", "xxxz", "xxzz<z>"],
	"boy": ["zzzz", "xxx", "^z", "^x", ">>^z", ">>^xx", ">>zzz", ">>x"],
	"sword_knight": [">>z(x)x", ">>^zzz", "xxxxx"],
	"lord_knight": ["zzz>z", ">>x(x)x", ">>^xxx"],
	"magic_knight": [">>zzx", ">>^xz", "xzz"],
	"blade_weaver": [">>^zxx", ">>xzz", "zzzx"],
	"rampart_knight": ["xzz", ">>^zx", "zzxxx"],
	"vanguard": [">>^xzz", ">>xxx", "zzz↓z"],
}
## ท่าเฉพาะสาย มี dur คือท่าใหม่ทั้งท่า ไม่มี dur คือแก้บางค่าของท่าที่สืบทอดมา
const JOB_MOVES := {
	"sync_core": {
		# เรียกโดรนโทรโข่งเล็ก 3 ตัว ยิงลำแสงติดตามมอนด้านหน้า 6 ฮิต
		"zzxx": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.0, "shot": {"type": "horn"}},
		# โดรนมาที่มือ ยิงเส้นไฟฟ้าติดตามมอน กดค้างช็อตเล็กๆ และดึงมอนเข้าหาตัว ปล่อยแล้วมอนดีดลอย ติด super armor ตอนกดค้าง
		"xx↓(x)": {"dur": 3.0, "wind": 0.04, "strike": 0.04, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(0.0, 0.15), "p1": Vector2(0.6, 0.2), "drone_to": "hand", "lunge": 0.0, "hold": "x", "hold_min": 0.3, "sa": true, "tether": true, "lean_w": 0.0, "lean_s": -6.0},
		# ยิงคลื่นบอลไฟฟ้า 3 แฉกจากเท้าลงด้านล่าง
		">>^zx": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.0,
			"shots": [{"type": "elec_wave", "from_foot": true, "dir": Vector2(-0.6, -1.0), "dmg": 7.0}, {"type": "elec_wave", "from_foot": true, "dir": Vector2(0.0, -1.0), "dmg": 7.0}, {"type": "elec_wave", "from_foot": true, "dir": Vector2(0.6, -1.0), "dmg": 7.0}]},
	},
	"twin_node": {
		# ยิงลูกข่างไปด้านหน้า ถึงพื้นแล้วไถล 2.3 วินาทีแล้วระเบิด โดนมอนระเบิดทันที มอนลอย
		">>^xz": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.0, "shot": {"type": "spin_top", "dmg": 14.0}},
		# วาปเข้าประตูโดรน ถอยหลัง
		">>z<x": {"dur": 0.5, "wind": 0.1, "strike": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "gate_warp": -4.5, "no_turn": true, "hit_at": 0.6},
		# ยิงคลื่นบอลไฟฟ้าไปด้านหน้า มอนกระเด็น
		">>z<xx": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.3, "shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 14.0, "extra": {"type": "knockdown", "fly": 11.0, "kd": 100}}},
		# ยิงบอลไฟฟ้าไปด้านหน้า แล้วต่ออีกฮิต มอนชะงัก
		"zx": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.3, "shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 7.0}},
		"zxx": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.3, "shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 9.0}},
	},
	"sync_time": {
		# ฮิตที่สามไม่ล้ม
		"xxx": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0, "shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 10.0}},
		# เตะบอลกลมมิติเวลา มอนชะงัก
		"xxxx": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.3, "shot": {"kind": "time", "pierce": true, "dir": Vector2(1.0, 0.0), "speed": 10.0, "dmg": 10.0}},
		# หลังไถแล้วพุ่งกระแทก มอนชะงัก ติด super armor
		">>zx": {"dur": 0.5, "wind": 0.2, "strike": 0.25, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 13.0, "no_dash": true, "sa": true, "fx_ram": true, "hit_reach": 2.4, "lean_s": -30.0,
			"hit": {"type": "flinch", "dmg": 10, "kd": 20, "kb": 0.0}},
		# สร้างรอยแยกหลังมอนที่ลอยอยู่ ผลักมาหาเรากลางอากาศ
		"zzxx": {"dur": 0.7, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "shot": {"type": "rift_push", "dmg": 10.0}},
	},
	"psi_clock": {
		# สร้างรอยแยกเวลาที่พื้นแบบเฉียง
		">>^xz": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "shot": {"type": "time_rift", "ahead": 3.0, "ground": true, "slant": 0.5, "dmg": 6.0}},
		# วาปไปที่รอยแยก ทำดาเมจ มอนชะงัก
		">>^xzz": {"dur": 0.5, "wind": 0.1, "strike": 0.3, "sw0": 20.0, "sw1": -100.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.6, 0.2), "drone_to": "front", "lunge": 0.0, "warp": "rift", "from_ground": true, "hit_reach": 2.8, "hit_back": 2.8, "hit_height": 3.0,
			"hit": {"type": "flinch", "dmg": 14, "kd": 20, "kb": 0.0}},
		# พุ่งใส่มอน ติด super armor
		">>xz": {"dur": 0.5, "wind": 0.15, "strike": 0.3, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 13.0, "sa": true, "fx_ram": true, "hit_reach": 2.4, "lean_s": -24.0,
			"hit": {"type": "flinch", "dmg": 8, "kd": 15, "kb": 0.0}},
		# เตะบอลกลมมิติเวลาไปทางทิศที่พุ่ง ตัวไม่พุ่ง มอนลอย
		">>xzz": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.3, "shot": {"kind": "time", "pierce": true, "dir": Vector2(1.0, 0.0), "speed": 10.0, "dmg": 10.0, "extra": {"type": "launch", "vy": 11.0, "kd": 30}}},
		# รอยแยกเล็กด้านหน้า สร้างซ้ำได้ มีได้อันเดียว
		"zx": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "shot": {"type": "time_rift", "ahead": 2.8, "dmg": 5.0}},
		"zxx": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "shot": {"type": "time_rift", "ahead": 3.6, "dmg": 5.0}},
		# ระเบิดรอยแยก
		"zxxx": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "rift_boom": true},
	},
	"sync_cure": {
		# ยิงเข็มฉีดยา มอนชะงัก
		">>xz": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.0, "shot": {"type": "needle", "dmg": 8.0}},
		"zx": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.0, "shot": {"type": "needle", "dmg": 7.0}},
		# ช็อตไฟฟ้าตามเข็ม มอนชะงัก
		"zxx": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "fx_hit": "bolt", "hit_reach": 5.0, "hit_back": 0.3,
			"hit": {"type": "flinch", "dmg": 9, "kd": 15, "kb": 0.0}},
		# พุ่งลงจากฟ้า กระแทกพื้นด้วยคลื่นจากโดรน
		">>^zx": {"dur": 0.6, "wind": 0.2, "strike": 0.4, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "foot", "lunge": 5.0, "plunge": 15.0, "no_dash": true, "fx_slam": true, "fx_hit": "pillar", "hit_at": 0.95, "hit_reach": 2.8, "hit_back": 1.6, "hit_height": 3.0, "lean_s": -20.0,
			"hit": {"type": "flinch", "dmg": 12, "kd": 25, "kb": 0.0}},
	},
	"rogue_medic": {
		# พุ่งชนด้านหน้า
		"xz": {"dur": 0.42, "sw0": -10.0, "sw1": -10.0, "p0": Vector2(-0.5, 0.0), "p1": Vector2(-0.5, 0.0), "drone_to": "front", "lunge": 10.0, "fx_ram": true, "lean_s": -40.0, "hit_reach": 2.2,
			"hit": {"type": "flinch", "dmg": 7, "kd": 15, "kb": 0.0}},
		# สั่งโดรนฟันเป็นวงกลมแนวนอนรอบตัว
		"xzz": {"dur": 0.6, "wind": 0.15, "strike": 0.6, "sw0": -28.0, "sw1": -28.0, "drone_to": "orbit", "lunge": 0.0, "hit_at": 0.5, "hit_reach": 2.6, "hit_back": 2.6,
			"hit": {"type": "flinch", "dmg": 10, "kd": 20, "kb": 0.0}},
		# ฮิตที่สามไม่ล้ม
		"xxx": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0, "shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 10.0}},
		# ปาเข็มไปด้านหน้า มอนชะงัก
		"xxxz": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.0, "shot": {"type": "needle", "dmg": 10.0}},
		# ไถมอน ผลักไปด้านหน้า
		"xxz": {"dur": 0.5, "wind": 0.15, "strike": 0.2, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 9.0, "tick": 0.1, "tick_max": 3, "hit_reach": 2.5, "hit_back": 0.3, "hitstop": 0.02, "lean_s": -20.0,
			"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 9.0}},
		# สั่งโดรนล็อคเท้ามอน 1 ฮิต
		"xxzz": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 0.0, "fx_hit": "pillar", "hit_reach": 3.6, "hit_back": 0.3,
			"hit": {"type": "flinch", "dmg": 6, "kd": 10, "kb": 0.0, "stun": 1.2}},
		# กดรัว ปาเข็มไปด้านหน้ารัวๆ เข็มสุดท้ายมอนล้ม
		"xxzz<z>": {"dur": 0.2, "wind": 0.1, "strike": 0.3, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.0, "mash_max": 6, "lean_w": 0.0, "lean_s": -8.0,
			"mash_last": {"type": "fall", "dmg": 8, "kd": 100},
			"shot": {"type": "needle", "dmg": 3.0}},
	},
	"aid": {
		# ตีด้วยโดรน 4 ฮิต ฮิตสุดท้ายล้ม
		"z": {"dur": 0.34, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 2.5, "hit_reach": 2.7, "hit": {"type": "flinch", "dmg": 4, "kd": 10, "kb": 0.0}},
		"zz": {"dur": 0.34, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 2.5, "hit_reach": 2.7, "hit": {"type": "flinch", "dmg": 4, "kd": 10, "kb": 0.0}},
		"zzz": {"dur": 0.36, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 3.0, "hit_reach": 2.7, "hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
		"zzzz": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 4.0, "hit_reach": 2.7, "hit": {"type": "fall", "dmg": 10, "kd": 100}},
		# เตะยิงคลื่นบอลไฟฟ้าเลียดพื้น ลูกสุดท้ายล้ม
		"x": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 6.0}},
		"xx": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 7.0}},
		"xxx": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 10.0, "extra": {"type": "fall", "kd": 100}}},
		# พุ่ง โดรนมาอยู่หน้า ไถมอนให้ไถลออกไป
		">>z": {"dur": 0.5, "wind": 0.15, "strike": 0.2, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "lunge": 10.0, "lean_s": -22.0,
			"tick": 0.1, "tick_max": 4, "hit_at": 0.1, "hit_reach": 2.5, "hit_back": 0.3, "hitstop": 0.02,
			"hit": {"type": "flinch", "dmg": 3, "kd": 6, "kb": 9.0}},
		# วิ่งไปข้างหน้า โดรนกางประตูวาป ออกอีกฝั่งห่าง 5 ช่วงตัว
		">>x": {"dur": 0.6, "wind": 0.15, "strike": 0.6, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "ahead", "lunge": 8.0, "no_dash": true, "gate_warp": 5.5, "hit_at": 0.9, "lean_s": -18.0},
		# เตะคลื่นบอลไฟฟ้าเลียดพื้น โดน 1 ฮิต กระเด็น
		">>xx": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 14.0, "extra": {"type": "knockdown", "fly": 11.0, "kd": 100}}},
		# โดรนปล่อยคลื่นกระบอกความถี่สูงสั้นๆ 3 ฮิต
		">>^x": {"dur": 0.5, "wind": 0.15, "strike": 0.2, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "drone_beam": true, "lunge": 0.5, "tick": 0.09, "tick_max": 3, "hit_at": 0.1, "hit_reach": 2.4, "hit_back": 0.3, "hit_height": 3.0, "hitstop": 0.02,
			"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0}},
		# ง้างขาเตะ ยิงคลื่นเฉียง มอนชะงัก
		">>^xx": {"dur": 0.45, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, -1.0), "dmg": 9.0}},
		# ยิงคลื่นบอลไฟฟ้าเฉียง 3 ลูก มอนชะงัก
		">>^z": {"dur": 0.36, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, -1.0), "dmg": 5.0}},
		">>^zz": {"dur": 0.36, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, -1.0), "dmg": 5.0}},
		">>^zzz": {"dur": 0.4, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "hand", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, -1.0), "dmg": 7.0}},
		# โดรนยิงคลื่นความถี่สูงสั้นๆ 3 ฮิตรัวๆ
		"^z": {"dur": 0.5, "wind": 0.15, "strike": 0.2, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "drone_to": "front", "drone_beam": true, "lunge": 0.5, "tick": 0.09, "tick_max": 3, "hit_at": 0.1, "hit_reach": 2.4, "hit_back": 0.3, "hit_height": 3.0, "hitstop": 0.02,
			"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0}},
		# โดรนหมุนรอบตัว มอนล้ม 1 ฮิต
		"^x": {"dur": 0.6, "wind": 0.15, "strike": 0.6, "sw0": -28.0, "sw1": -28.0, "drone_to": "orbit", "lunge": 0.0, "hit_at": 0.5, "hit_reach": 2.4, "hit_back": 2.4, "hit_height": 3.0,
			"hit": {"type": "knockdown", "dmg": 10, "kd": 100}},
		# กระทืบพื้น โดรนงัดมอนด้วยคลื่นไฟฟ้าทรงกระบอก เฉพาะมอนในระยะ 3 ช่วงตัว
		"zzx": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "stomp": true, "drone_to": "ahead", "fx_hit": "pillar", "lunge": 0.0, "hit_at": 0.9, "hit_reach": 3.3, "hit_back": 0.3, "lean_w": 8.0, "lean_s": -8.0,
			"hit": {"type": "launch", "vy": 10.0, "dmg": 8, "kd": 20}},
		# เตะคลื่นบอลไฟฟ้าเลียดพื้น มอนกระเด็น
		"zzxx": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "p0": Vector2(-0.1, 0.1), "p1": Vector2(0.6, 0.15), "kick": true, "drone_to": "foot", "lunge": 0.5, "lean_w": 6.0, "lean_s": -10.0,
			"shot": {"type": "elec_wave", "dir": Vector2(1.0, 0.0), "dmg": 12.0, "extra": {"type": "knockdown", "fly": 11.0, "kd": 100}}},
	},
	"ore_magic": {
		# ฮิต 2 ถึง 4 ควงคทาหมุนแขนฟาดขึ้น มอนไม่ลอย
		"zz": {"dur": 0.42, "wind": 0.5, "strike": 0.28, "sw0": -525.0, "sw1": -375.0, "arm_spin": 0.3, "p0": Vector2(0.1, 0.37), "p1": Vector2(0.8, 0.8), "lunge": 2.0, "lean_w": -6.0, "lean_s": 10.0, "hit_reach": 2.5,
			"hit": {"type": "flinch", "dmg": 4, "kd": 10, "kb": 0.0}},
		"zzz": {"dur": 0.42, "wind": 0.5, "strike": 0.28, "sw0": -525.0, "sw1": -375.0, "arm_spin": 0.3, "p0": Vector2(0.1, 0.37), "p1": Vector2(0.8, 0.8), "lunge": 2.0, "lean_w": -6.0, "lean_s": 10.0, "hit_reach": 2.5,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
		"zzzz": {"dur": 0.42, "wind": 0.5, "strike": 0.28, "sw0": -525.0, "sw1": -375.0, "arm_spin": 0.3, "p0": Vector2(0.1, 0.37), "p1": Vector2(0.8, 0.8), "lunge": 2.0, "lean_w": -6.0, "lean_s": 10.0, "hit_reach": 2.5,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
		# กระโดดสั้นๆ หมุนตัว เอาคทาทุบหัวเฉียงลง มอนล้ม
		"zzzzz": {"dur": 0.6, "wind": 0.4, "strike": 0.3, "sw0": 170.0, "sw1": -135.0, "hop": 6.0, "spin": 1.0, "lunge": 2.0, "hit_at": 0.8, "big": 1.2, "hit_height": 3.0, "lean_s": -20.0,
			"hit": {"type": "fall", "dmg": 12, "kd": 100}},
		# วาปลงพื้น โปรยละอองมิติ ทำดาเมจ 1 ฮิต
		">>^xz": {"dur": 0.5, "sw0": -30.0, "sw1": -80.0, "p0": Vector2(-0.1, 0.4), "p1": Vector2(0.7, 0.4), "lunge": 0.0, "no_dash": true, "lean_w": 0.0, "lean_s": 0.0, "warp": "down", "keeps_chain": true,
			"shot": {"type": "dim_dust", "ahead": 2.4, "dmg": 8.0}},
		# หมุนตัวพริ้วๆ ละอองลอยเข้าหาตัว ทำดาเมจต่อเนื่อง ลากมอนมาด้วย
		">>^xzz": {"dur": 0.85, "wind": 0.1, "strike": 0.7, "sw0": 0.0, "sw1": -720.0, "linear": true, "spin": 2.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.1, 0.6), "lunge": 0.0, "no_dash": true, "dust_gather": true, "from_ground": true, "lean_w": 0.0, "lean_s": 0.0},
		# วาปไปหามอน ฟาดคทาลงแนวดิ่ง ติด super armor ตอนวาปลงมา มอนชะงัก
		">>zx": {"dur": 0.55, "wind": 0.2, "strike": 0.35, "sw0": 15.0, "sw1": -175.0, "p0": Vector2(0.1, 0.7), "p1": Vector2(0.5, 0.37), "lunge": 0.0, "no_dash": true,
			"warp": "target", "plunge": 12.0, "sa": true, "sa_until": 0.3, "hit_at": 0.9, "hit_reach": 2.4, "hit_back": 1.2, "hit_height": 3.0, "lean_s": -18.0,
			"hit": {"type": "flinch", "dmg": 12, "kd": 20, "kb": 0.0}},
	},
	"dimension_strike": {
		# โปรยละอองมิติ ทำดาเมจ 1 ฮิต
		">>xz": {"dur": 0.5, "sw0": -30.0, "sw1": -80.0, "p0": Vector2(-0.1, 0.4), "p1": Vector2(0.7, 0.4), "lunge": 0.0, "no_dash": true, "lean_w": 0.0, "lean_s": 0.0,
			"shot": {"type": "dim_dust", "ahead": 2.6, "dmg": 8.0}},
		">>xzz": {"dur": 0.85, "wind": 0.1, "strike": 0.7, "sw0": 0.0, "sw1": -720.0, "linear": true, "spin": 2.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.1, 0.6), "lunge": 0.0, "no_dash": true, "dust_gather": true, "from_ground": true, "lean_w": 0.0, "lean_s": 0.0},
		# พุ่งเอาคทาฟาดไปด้านหน้า ทำดาเมจระหว่างพุ่ง มอนชะงัก
		"zx": {"dur": 0.5, "wind": 0.15, "strike": 0.2, "sw0": -60.0, "sw1": -95.0, "p0": Vector2(-0.3, 0.3), "p1": Vector2(0.9, 0.2), "lunge": 12.0, "lean_s": -24.0,
			"tick": 0.1, "tick_max": 3, "hit_reach": 2.2, "hit_back": 0.8, "hitstop": 0.02,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
		# หมุนคทา 1 รอบ พุ่งลงเฉียง ทำดาเมจระหว่างพุ่ง มอนชะงัก
		">>^zx": {"dur": 0.7, "wind": 0.4, "strike": 0.35, "sw0": -388.0, "sw1": -480.0, "p0": Vector2(0.2, 0.6), "p1": Vector2(0.7, 0.2), "lunge": 9.0, "plunge": 10.0, "no_dash": true, "lean_s": -24.0,
			"tick": 0.1, "tick_max": 4, "hit_at": 0.1, "hit_reach": 2.2, "hit_back": 1.0, "hit_height": 3.0, "hitstop": 0.02,
			"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0}},
	},
	"high_mage": {
		# ยิงลูกบอลไฟเพิ่มอีกหนึ่งลูก
		">>xx": {"dur": 0.42, "sw0": -60.0, "sw1": -90.0, "p0": Vector2(-0.1, 0.3), "p1": Vector2(0.7, 0.3), "lunge": 0.0,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 12.0, "dmg": 10.0}},
		# ยิงเฉียงลงเพิ่มอีก 2 ลูก
		">>^xx": {"dur": 0.38, "sw0": -70.0, "sw1": -125.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.6, 0.15), "lunge": 0.3,
			"shot": {"pierce": true, "dir": Vector2(1.0, -1.0), "speed": 11.0, "dmg": 8.0}},
		">>^xxx": {"dur": 0.4, "sw0": -60.0, "sw1": -135.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.6, 0.1), "lunge": 0.3,
			"shot": {"pierce": true, "dir": Vector2(1.0, -1.0), "speed": 11.0, "dmg": 10.0}},
		# ยิงเปลวไฟวิ่งไปตามพื้นด้านหน้า
		"zzx": {"dur": 0.5, "sw0": 15.0, "sw1": -135.0, "p0": Vector2(-0.2, 0.5), "p1": Vector2(0.7, 0.15), "lunge": 0.5, "lean_s": -16.0,
			"shot": {"type": "ground_flame", "dmg": 12.0, "reach": 5.5}},
	},
	"omni_prime": {
		# กดรัว ยิงลูกบอลไฟรัวๆ สูงสุด 8 ลูก
		"zzx<x>": {"dur": 0.2, "wind": 0.15, "strike": 0.25, "sw0": -75.0, "sw1": -90.0, "p0": Vector2(0.3, 0.3), "p1": Vector2(0.8, 0.3), "lunge": 0.0, "mash_max": 8, "sa": true,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 13.0, "dmg": 4.0}},
		# ลมพัดใส่มอนด้านหน้า 3 ฮิต
		"xxz": {"dur": 0.8, "wind": 0.15, "strike": 0.15, "sw0": -40.0, "sw1": -85.0, "p0": Vector2(-0.2, 0.4), "p1": Vector2(0.6, 0.3), "lunge": 0.3, "wind_fx": true,
			"tick": 0.18, "tick_max": 3, "hit_reach": 3.4, "hit_back": 0.4, "hitstop": 0.02, "lean_s": -10.0,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 1.5}},
		# กดรัว สายฟ้าเล็กๆ ชอตรัวๆ สูงสุด 6 ฮิต
		"xxz<z>": {"dur": 0.22, "wind": 0.1, "strike": 0.2, "sw0": -10.0, "sw1": -30.0, "p0": Vector2(0.1, 0.8), "p1": Vector2(0.2, 0.9), "lunge": 0.0, "mash_max": 6, "sa": true, "fx_hit": "bolt",
			"hit_reach": 4.5, "hit_back": 0.5, "hitstop": 0.02, "lean_w": 0.0, "lean_s": 0.0,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
		# เสกน้ำแข็งเลยไปข้างหน้า แล้วน้ำแข็งลากมอนกลับมาหาเรา
		">>xz": {"dur": 0.75, "wind": 0.2, "strike": 0.2, "sw0": -60.0, "sw1": -95.0, "p0": Vector2(0.0, 0.3), "p1": Vector2(0.7, 0.2), "lunge": 0.0, "sa": true, "sa_until": 0.54,
			"shot": {"type": "ice_hook", "dmg": 10.0}},
	},
	"alchemic_mage": {
		# กระโดดพร้อมโยนขวดยาลงพื้นสั้นๆ
		">>xz": {"dur": 0.5, "sw0": -30.0, "sw1": -60.0, "lunge": 0.0, "hop": 7.5, "hop_back": 5.0,
			"shot": {"type": "potion", "vx": 3.0, "vy": 2.0, "dmg": 10.0}},
		# ฟาดคทาลงพื้น ควันฟุ้ง มอนลอย
		"xx↓x": {"dur": 0.55, "sw0": 170.0, "sw1": -170.0, "p1": Vector2(0.4, 0.37), "lunge": 1.0, "fx_smoke": true, "hit_at": 0.9, "hit_reach": 2.6, "hit_back": 0.6, "lean_s": -22.0,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 12, "kd": 40}},
		# กดถอยหลังแล้ว z กระโดดโยนขวดยาสั้นๆ
		"zz<z": {"dur": 0.5, "sw0": -30.0, "sw1": -60.0, "lunge": 0.0, "hop": 7.5, "hop_back": 5.0,
			"shot": {"type": "potion", "vx": 3.0, "vy": 2.0, "dmg": 10.0}},
	},
	"lord_essence": {
		# โปรยขวดยา 3 ขวดเฉียงลงพื้น ติด super armor
		">>^xz": {"dur": 0.6, "wind": 0.3, "strike": 0.25, "sw0": -30.0, "sw1": -60.0, "lunge": 0.0, "sa": true,
			"shots": [{"type": "potion", "vx": 2.5, "vy": 1.0, "dmg": 8.0}, {"type": "potion", "vx": 5.0, "vy": 1.0, "dmg": 8.0}, {"type": "potion", "vx": 7.5, "vy": 1.0, "dmg": 8.0}]},
		# เสกวงเวทบนฟ้าด้านหน้า โปรยขวดยาผ่านวงลงมากระทบมอน ควันค้าง 1.2 วินาที ทำดาเมจ มอนชะงัก
		">>zzx": {"dur": 0.55, "wind": 0.3, "strike": 0.25, "sw0": 0.0, "sw1": -20.0, "p0": Vector2(0.0, 0.6), "p1": Vector2(0.2, 0.9), "lunge": 0.0, "fx_circle": "sky", "lean_w": 0.0, "lean_s": 0.0,
			"shots": [
				{"type": "potion", "from": Vector2(2.2, 5.0), "vx": 0.0, "vy": 0.0, "delay": 0.0, "hit_monster": true, "dmg": 6.0, "smoke_life": 1.2, "smoke_tick": 3.0},
				{"type": "potion", "from": Vector2(3.2, 5.0), "vx": 0.0, "vy": 0.0, "delay": 0.14, "hit_monster": true, "dmg": 6.0, "smoke_life": 1.2, "smoke_tick": 3.0},
				{"type": "potion", "from": Vector2(4.2, 5.0), "vx": 0.0, "vy": 0.0, "delay": 0.28, "hit_monster": true, "dmg": 6.0, "smoke_life": 1.2, "smoke_tick": 3.0},
			]},
		# ฟาดคทา ควันฟุ้ง มอนกระเด็น
		"zzx": {"dur": 0.5, "sw0": 150.0, "sw1": -110.0, "lunge": 3.0, "fx_smoke": true, "big": 1.1, "lean_w": 8.0, "lean_s": -24.0,
			"hit": {"type": "knockdown", "dmg": 14, "kd": 100, "fly": 11.0}},
	},
	"gwen": {
		# ฮิตที่ 3 ฟาดคทาจากเหนือหัว มอนล้ม
		"zzz": {"dur": 0.55, "sw0": 170.0, "sw1": -150.0, "p1": Vector2(0.0, 0.2), "lunge": 4.0, "big": 1.25,
			"hit": {"type": "knockdown", "dmg": 10, "kd": 100}},
		# ยิงลูกบอลไฟ มุมคทาต่างกันทุกนัด
		"x": {"dur": 0.42, "sw0": -40.0, "sw1": -80.0, "p0": Vector2(-0.2, 0.3), "p1": Vector2(0.7, 0.3), "lunge": 0.5, "lean_s": -12.0,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 11.0, "dmg": 5.0}},
		"xx": {"dur": 0.42, "sw0": -110.0, "sw1": -75.0, "p0": Vector2(-0.2, 0.3), "p1": Vector2(0.7, 0.3), "lunge": 0.5, "lean_s": -12.0,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 11.0, "dmg": 6.0}},
		"xxx": {"dur": 0.42, "sw0": -50.0, "sw1": -90.0, "p0": Vector2(-0.2, 0.3), "p1": Vector2(0.7, 0.3), "lunge": 0.5, "lean_s": -12.0,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 11.0, "dmg": 7.0}},
		# นัดสุดท้าย ลูกบอลทำมอนกระเด็น
		"xxxx": {"dur": 0.6, "wind": 0.45, "strike": 0.25, "sw0": 20.0, "sw1": -85.0, "p0": Vector2(-0.3, 0.5), "p1": Vector2(0.8, 0.3), "lunge": 1.0, "lean_w": 12.0, "lean_s": -18.0,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 12.0, "dmg": 12.0, "extra": {"type": "knockdown", "fly": 10.0, "kd": 100}}},
		# พุ่งเอาคทาฟาดหน้า ไถลมอนไปด้วย
		">>z": {"dur": 0.45, "sw0": -55.0, "sw1": -105.0, "p0": Vector2(-0.2, 0.3), "p1": Vector2(0.9, 0.1), "lunge": 10.0, "lean_s": -22.0, "hit_reach": 2.4,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 9.0}},
		# ฟาดขึ้น มอนลอย
		">>zz": {"dur": 0.45, "sw0": -165.0, "sw1": -15.0, "p0": Vector2(0.3, 0.37), "p1": Vector2(0.9, 0.9), "lunge": 3.0, "lean_w": -8.0, "lean_s": 12.0, "hit_reach": 2.6,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 8, "kd": 30}},
		# วิ่งทะลุมอน แล้วหันหลังยิงลูกบอลไฟทะลุมอน
		">>x": {"dur": 0.65, "wind": 0.15, "strike": 0.3, "sw0": -70.0, "sw1": -90.0, "p0": Vector2(-0.2, 0.3), "p1": Vector2(0.8, 0.3), "lunge": 13.0, "pierce": true, "turn_shot": true, "lean_s": -18.0,
			"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0},
			"shot": {"dir": Vector2(1.0, 0.0), "speed": 13.0, "dmg": 12.0, "pierce": true}},
		# ชี้คทาเฉียงลง กางวงเวทที่หัวคทา มอนชะงัก
		">>^z": {"dur": 0.55, "wind": 0.3, "strike": 0.25, "sw0": -70.0, "sw1": -125.0, "p0": Vector2(0.0, 0.4), "p1": Vector2(0.5, 0.2), "lunge": 0.5, "fx_circle": "tip",
			"hit_reach": 3.0, "hit_back": 0.4, "hit_height": 3.0,
			"hit": {"type": "flinch", "dmg": 8, "kd": 12, "kb": 0.0}},
		# ยิงลูกบอลเฉียงลงมา ตัวเองถอยหลังลอยขึ้น
		">>^x": {"dur": 0.45, "wind": 0.3, "strike": 0.25, "sw0": -60.0, "sw1": -130.0, "p0": Vector2(0.0, 0.5), "p1": Vector2(0.6, 0.1), "lunge": -6.0, "rise": 6.0,
			"shot": {"pierce": true, "dir": Vector2(1.0, -1.0), "speed": 11.0, "dmg": 10.0}},
		# ยิงลูกบอลไปด้านหน้า ไม่เฉียง
		"^x": {"dur": 0.45, "wind": 0.3, "strike": 0.25, "sw0": -60.0, "sw1": -90.0, "p0": Vector2(-0.1, 0.3), "p1": Vector2(0.7, 0.3), "lunge": 0.5,
			"shot": {"pierce": true, "dir": Vector2(1.0, 0.0), "speed": 11.0, "dmg": 10.0}},
		# เสกวงเวทใต้ตัว กว้างเลยตัวไปนิดเดียว มอนลอย
		"zz↓z": {"dur": 0.55, "wind": 0.35, "strike": 0.3, "sw0": -28.0, "sw1": -5.0, "p0": Vector2(0.0, 0.3), "p1": Vector2(0.1, 0.8), "lunge": 0.0, "fx_circle": "ground", "lean_w": 0.0, "lean_s": 0.0,
			"hit_reach": 1.25, "hit_back": 1.25,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 12, "kd": 30}},
	},
	"sword_knight": {
		"xxx": {"hit": {"type": "flinch", "dmg": 16, "kd": 30, "kb": 0.0}},
	},
	"lord_knight": {
		">>x": {"hit": {"type": "launch", "vy": 6.0, "dmg": 8, "kd": 15}},
		">>^xx": {"hit": {"type": "flinch", "dmg": 14, "kd": 30, "kb": 0.0, "stun": 0.7}},
	},
	"magic_knight": {
		# ทะลุมอน ยิงลูกบอลไฟไปด้านหลังตอนกำลังทะลุ
		">>zzx": {"dur": 0.42, "sw0": -80.0, "sw1": -100.0, "lunge": 13.0, "lean_s": -22.0, "pierce": true, "hit_back": 0.6,
			"shot": {"dir": Vector2(-1.0, 0.0), "speed": 11.0, "dmg": 10.0, "pierce": true},
			"hit": {"type": "flinch", "dmg": 8, "kd": 20, "kb": 0.0}},
		# ยิงลูกบอลไฟเฉียงลงไปข้างหน้า
		">>^xz": {"dur": 0.45, "wind": 0.3, "strike": 0.25, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(95.0, 0.0), "lunge": 0.5,
			"shot": {"dir": Vector2(1.0, -1.0), "speed": 11.0, "dmg": 12.0}},
		# ชกด้วยมือไฟ
		"xz": {"dur": 0.34, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(95.0, 0.0), "lunge": 3.0, "lean_s": -24.0, "hit_reach": 2.2,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
		# พ่นไฟจากมือหลายฮิต
		"xzz": {"dur": 0.85, "wind": 0.15, "strike": 0.1, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(95.0, 0.0), "flame_blast": "fire",
			"tick": 0.12, "tick_max": 5, "hit_reach": 2.6, "hitstop": 0.02, "lean_s": -16.0,
			"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0}},
	},
	"blade_weaver": {
		# ฟาดเป็นวงกลมรอบตัว เปลวเขียว ติดไฟพิษ
		">>^zx": {"dur": 0.55, "wind": 0.12, "strike": 0.7, "sw0": 40.0, "sw1": -320.0, "linear": true, "trail": 0.35, "flame": "poison",
			"lunge": 0.5, "hit_reach": 2.6, "hit_back": 2.4, "hit_height": 3.0,
			"hit": {"type": "flinch", "dmg": 8, "kd": 12, "kb": 0.0, "burn": "poison"}},
		# ฟาดวงกลมอีกรอบ เปลวแดง ติดไฟแดง
		">>^zxx": {"dur": 0.6, "wind": 0.12, "strike": 0.7, "sw0": 40.0, "sw1": -320.0, "linear": true, "trail": 0.35, "flame": "fire",
			"lunge": 0.5, "hit_reach": 2.6, "hit_back": 2.4, "hit_height": 3.0,
			"hit": {"type": "flinch", "dmg": 10, "kd": 15, "kb": 0.0, "burn": "fire"}},
		# มีฮิตต่อ ลดแรงงัดให้ลูกบอลยังโดน
		">>x": {"hit": {"type": "launch", "vy": 6.0, "dmg": 8, "kd": 15}},
		# ปล่อยลูกบอลไฟสีฟ้า ลอยรอคำสั่ง
		">>xz": {"dur": 0.42, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(95.0, 0.0), "lunge": 0.0, "no_dash": true,
			"shot": {"dir": Vector2(1.0, 0.0), "speed": 3.5, "dmg": 14.0, "touch_dmg": 8.0, "kind": "ice", "burn": "ice", "holding": true}},
		# สั่งระเบิด
		">>xzz": {"dur": 0.35, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(95.0, 0.0), "lunge": 0.0, "no_dash": true, "detonate": true},
		# ฟาดแนวนอน เปลวแดงรอบดาบ
		"zzzx": {"dur": 0.5, "sw0": -90.0, "sw1": -90.0, "ry0": 75.0, "ry1": -75.0, "flame": "fire",
			"p0": Vector2(-0.3, 0.0), "p1": Vector2(0.5, 0.0), "lunge": 3.0, "lean_w": 3.0, "lean_s": -10.0, "hit_reach": 2.8,
			"hit": {"type": "flinch", "dmg": 10, "kd": 20, "kb": 0.0, "burn": "fire"}},
	},
	"rampart_knight": {
		# เอาไหล่ชน ติด super armor
		"xz": {"dur": 0.42, "sw0": -10.0, "sw1": -10.0, "p0": Vector2(-0.7, -0.1), "p1": Vector2(-0.7, -0.1), "lean_w": 8.0, "lean_s": -50.0, "hit_reach": 1.9, "fx_ram": true, "lunge": 9.0, "sa": true,
			"hit": {"type": "flinch", "dmg": 7, "kd": 15, "kb": 0.0}},
		# ฟาดดาบขึ้น มอนลอย
		"xzz": {"dur": 0.5, "sw0": -165.0, "sw1": -15.0, "p0": Vector2(0.3, 0.37), "p1": Vector2(0.9, 0.9), "lunge": 2.0,
			"lean_w": -8.0, "lean_s": 12.0, "hit_reach": 2.7,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 10, "kd": 30}},
		# พุ่งเฉียงลงมา เอาดาบกระแทกพื้น มอนลอย
		">>^zx": {"dur": 0.6, "wind": 0.2, "strike": 0.4, "sw0": -60.0, "sw1": -180.0, "p0": Vector2(0.3, 0.6), "p1": Vector2(0.5, 0.37),
			"lunge": 7.0, "plunge": 14.0, "no_dash": true, "fx_slam": true, "hit_at": 0.95, "hit_reach": 2.8, "hit_back": 1.6, "hit_height": 3.0, "lean_s": -24.0,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 12, "kd": 40}},
		# ไหล่ชนสองครั้ง
		"zzx": {"dur": 0.42, "sw0": -10.0, "sw1": -10.0, "p0": Vector2(-0.7, -0.1), "p1": Vector2(-0.7, -0.1), "lean_w": 8.0, "lean_s": -50.0, "hit_reach": 1.9, "fx_ram": true, "lunge": 8.0,
			"hit": {"type": "flinch", "dmg": 6, "kd": 12, "kb": 0.0}},
		"zzxx": {"dur": 0.42, "sw0": -10.0, "sw1": -10.0, "p0": Vector2(-0.7, -0.1), "p1": Vector2(-0.7, -0.1), "lean_w": 8.0, "lean_s": -50.0, "hit_reach": 1.9, "fx_ram": true, "lunge": 8.0,
			"hit": {"type": "flinch", "dmg": 7, "kd": 14, "kb": 0.0}},
		# ไหล่ชนอย่างแรง กระเด็น
		"zzxxx": {"dur": 0.7, "wind": 0.45, "strike": 0.25, "sw0": -10.0, "sw1": -10.0, "p0": Vector2(-0.7, -0.1), "p1": Vector2(-0.7, -0.1), "lean_w": 8.0, "lean_s": -50.0, "hit_reach": 1.9, "fx_ram": true, "lunge": 12.0, "big": 1.0,
			"hit": {"type": "knockdown", "dmg": 16, "kd": 100, "fly": 13.0}},
	},
	"vanguard": {
		# พุ่งเฉียงลงพื้น ยกโล่ชน รอบตัวแคบๆ มอนชะงัก
		">>^xz": {"dur": 0.5, "wind": 0.2, "strike": 0.4, "sw0": -10.0, "sw1": -10.0, "off_hand": Vector2(80.0, 0.0),
			"lunge": 6.0, "plunge": 14.0, "no_dash": true, "fx_ram": true, "fx_slam": true, "hit_at": 0.95, "hit_reach": 1.7, "hit_back": 1.2, "hit_height": 3.0, "lean_s": -30.0,
			"hit": {"type": "flinch", "dmg": 8, "kd": 15, "kb": 0.0, "stun": 0.7}},
		# โล่กระแทกพื้น มอนลอย
		">>^xzz": {"dur": 0.5, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(72.0, 85.0), "lean_w": 10.0, "lean_s": -24.0, "fx_slam": true, "from_ground": true, "lunge": 0.0, "no_dash": true, "hit_reach": 2.6, "hit_back": 1.4, "hit_height": 3.0,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 14, "kd": 40}},
		# พุ่งเอาโล่ชน
		">>x": {"dur": 0.5, "sw0": -10.0, "sw1": -10.0, "off_hand": Vector2(80.0, 0.0), "lunge": 11.0, "lean_s": -30.0, "hit_reach": 2.1, "fx_ram": true,
			"no_dash": true, "spin": 0.0,
			"hit": {"type": "flinch", "dmg": 8, "kd": 15, "kb": 0.0, "stun": 0.7}},
		# ตั้งท่าแล้วชนต่อเนื่อง 4 ฮิต ติด super armor
		">>xx": {"dur": 1.0, "wind": 0.35, "strike": 0.1, "sw0": -10.0, "sw1": -10.0, "off_hand": Vector2(80.0, 0.0), "lunge": 6.0, "sa": true, "fx_ram": true,
			"tick": 0.14, "tick_max": 4, "hit_reach": 2.1, "hitstop": 0.02, "no_dash": true, "lean_w": 14.0, "lean_s": -30.0,
			"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0, "stun": 0.5}},
		# ปล่อยโล่ลงพื้น มอนลอย
		">>xxx": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(72.0, 85.0), "lean_w": 10.0, "lean_s": -24.0, "fx_slam": true, "lunge": 1.0, "no_dash": true, "hit_reach": 2.6, "hit_back": 1.4,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 14, "kd": 40}},
		# กดลงแล้ว z เอาโล่กระแทกพื้น มอนลอย
		"zzz↓z": {"dur": 0.55, "sw0": -28.0, "sw1": -28.0, "off_hand": Vector2(72.0, 85.0), "lean_w": 10.0, "lean_s": -24.0, "fx_slam": true, "lunge": 1.0, "hit_reach": 2.6, "hit_back": 1.4,
			"hit": {"type": "launch", "vy": 11.0, "dmg": 14, "kd": 40}},
	},
}

static var active: Array = COMBOS
static var job_moves: Dictionary = {}

## เลือกชุดคอมโบตามสาย สายต่อยอดสืบทอดทุกอย่างจากสายก่อนหน้า แล้วเพิ่มหรือแก้ท่าของตัวเอง
static func use_job(id: String) -> void:
	var line: Array = []
	var at := id
	while at != "":
		line.push_front(at)
		at = str(JobData.find(at).get("parent", ""))
	var combos: Array = []
	job_moves = {}
	for job in line:
		combos.append_array(JOB_COMBOS.get(job, []))
		job_moves.merge(JOB_MOVES.get(job, {}), true)
	active = combos if not combos.is_empty() else COMBOS

## กดค้าง: ดันดาบไปข้างหน้า ติด super armor ตีซ้ำและดันมอนไปด้วย
const CHARGE := {"dur": 1.3, "wind": 0.12, "strike": 0.12, "sw0": -70.0, "sw1": -90.0,
	"p0": Vector2(-0.2, 0.1), "p1": Vector2(1.0, 0.1), "lunge": 5.0, "hold": "x", "hold_min": 0.32, "tick": 0.18, "sa": true, "no_dash": true,
	"lean_s": -18.0, "hit_reach": 3.0, "hit_height": 3.0, "hitstop": 0.02,
	"hit": {"type": "flinch", "dmg": 3, "kd": 6, "kb": 5.0, "kb_air": 5.0, "air_lift": -1.0, "air_stall": 0.0, "stun": 0.4}}
## ปิดท้ายกดค้าง: ฟาดดาบลงมา มอนลอยต่ำ
const CHARGE_END := {"dur": 0.5, "sw0": 150.0, "sw1": -130.0, "p1": Vector2(0.4, 0.1), "lunge": 3.0, "big": 1.3, "no_dash": true,
	"hit": {"type": "launch", "vy": 6.0, "dmg": 12, "kd": 40}}

const BODY_MOVES := {
	"z": {"dur": 0.34, "sw0": -90.0, "sw1": -90.0, "ry0": 75.0, "ry1": -75.0,
		"p0": Vector2(-0.3, 0), "p1": Vector2(0.5, 0), "lunge": 2.5, "lean_w": 3.0, "lean_s": -8.0, "hit_reach": 2.6,
		"hit": {"type": "flinch", "dmg": 4, "kd": 10, "kb": 0.0}},
	"zz": {"dur": 0.34, "sw0": -150.0, "sw1": -60.0,
		"p0": Vector2(-0.1, 0.2), "p1": Vector2(0.9, 0.8), "lunge": 2.5,
		"hit": {"type": "flinch", "dmg": 4, "kd": 10, "kb": 0.0}},
	"zzz": {"dur": 0.38, "sw0": -15.0, "sw1": -125.0,
		"p0": Vector2(-0.1, 0.8), "p1": Vector2(0.8, -0.2), "lunge": 4.0, "lean_s": -20.0, "hit_reach": 2.7,
		"hit": {"type": "flinch", "dmg": 5, "kd": 12, "kb": 0.0}},
	"zzzz": {"dur": 0.55, "sw0": 170.0, "sw1": -150.0, "p1": Vector2(0.0, 0.2), "lunge": 4.0, "big": 1.25,
		"hit": {"type": "fall", "dmg": 10, "kd": 100}},
	"zzz>z": {"dur": 0.42, "sw0": -85.0, "sw1": -92.0,
		"p0": Vector2(-0.4, 0.1), "p1": Vector2(1.1, 0.05), "lunge": 6.0, "lean_s": -20.0, "hit_reach": 3.0,
		"hit": {"type": "flinch", "dmg": 8, "kd": 20, "kb": 0.0}},
	"zzzx": {"dur": 0.5, "sw0": -90.0, "sw1": -90.0, "ry0": 90.0, "ry1": -270.0, "lunge": 3.0, "hit_back": 2.2,
		"hit": {"type": "knockdown", "dmg": 12, "kd": 100}},
	"x": {"dur": 0.5, "sw0": -20.0, "sw1": -70.0,
		"p0": Vector2(-0.3, 0.9), "p1": Vector2(0.9, -0.6), "lunge": 4.0, "hit_reach": 2.6,
		"hit": {"type": "flinch", "dmg": 6, "kd": 14, "kb": 0.0}},
	"xx": {"dur": 0.5, "sw0": -90.0, "sw1": -90.0, "ry0": -75.0, "ry1": 75.0,
		"p0": Vector2(0.5, 0), "p1": Vector2(-0.3, 0), "lunge": 2.0, "lean_w": -3.0, "lean_s": 6.0, "hit_back": 1.4,
		"hit": {"type": "flinch", "dmg": 7, "kd": 16, "kb": 0.0}},
	"xxx": {"dur": 0.95, "wind": 0.6, "strike": 0.2, "sw0": 180.0, "sw1": -100.0, "lunge": 5.0, "big": 1.5,
		"lean_w": 18.0, "lean_s": -22.0, "hit_reach": 2.8,
		"hit": {"type": "knockdown", "dmg": 16, "kd": 100}},
	"xxxx": {"dur": 0.5, "sw0": -160.0, "sw1": -20.0,
		"p0": Vector2(-0.1, 0.3), "p1": Vector2(0.9, 0.8), "lunge": 3.0, "lean_w": -6.0, "lean_s": 10.0, "hit_reach": 2.7,
		"hit": {"type": "flinch", "dmg": 9, "kd": 20, "kb": 0.0}},
	"xxxxx": {"dur": 0.8, "wind": 0.2, "strike": 0.1, "sw0": -90.0, "sw1": -90.0, "stabs": true, "tick": 0.12, "tick_max": 4,
		"p0": Vector2(-0.3, 0.1), "p1": Vector2(1.1, 0.1), "lunge": 8.0, "lean_s": -18.0, "hit_reach": 3.0, "hitstop": 0.02,
		"hit": {"type": "flinch", "dmg": 5, "kd": 10, "kb": 0.0}},
	"z(x)": CHARGE,
	"x(x)": CHARGE,
	"z(x)x": CHARGE_END,
	"x(x)x": CHARGE_END,
	"xxz": {"dur": 0.4, "sw0": -25.0, "sw1": 15.0,
		"p0": Vector2(0, -0.6), "p1": Vector2(0.1, 0.9), "lunge": 3.0,
		"hit": {"type": "launch", "vy": 11.0, "dmg": 9, "kd": 20}},
}

## กระโดดแล้วตี ^z ^x
const UP_MOVES := {
	"z": {"dur": 0.4, "sw0": 10.0, "sw1": -175.0,
		"p0": Vector2(0.2, 0.9), "p1": Vector2(0.4, -0.5), "lunge": 1.0, "big": 1.1,
		"hit": {"type": "flinch", "dmg": 6, "kd": 15, "kb": 0.0}},
	"x": {"dur": 0.5, "wind": 0.4, "strike": 0.16, "sw0": 25.0, "sw1": -165.0,
		"p0": Vector2(-0.1, 0.5), "p1": Vector2(0.7, -0.3), "lunge": 2.0, "big": 1.4,
		"hit": {"type": "knockdown", "dmg": 14, "kd": 100}},
}

## ฮิตแรกของ >>^z >>^x
const DASH_UP_MOVES := {
	"z": {"dur": 0.4, "sw0": -30.0, "sw1": -130.0,
		"p0": Vector2(-0.2, 0.4), "p1": Vector2(0.8, -0.2), "lunge": 1.0,
		"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0}},
	"x": {"dur": 0.45, "sw0": 150.0, "sw1": -110.0, "lunge": 2.0, "big": 1.2,
		"hit": {"type": "flinch", "dmg": 6, "kd": 10, "kb": 0.0}},
}

## ฮิตต่อๆ มาในคอมโบอากาศ >>^zzz >>^xx
const AIR_MOVES := {
	"zz": {"dur": 0.34, "sw0": -90.0, "sw1": -90.0, "ry0": 75.0, "ry1": -75.0,
		"p0": Vector2(-0.3, 0), "p1": Vector2(0.5, 0), "lunge": 1.5,
		"hit": {"type": "flinch", "dmg": 4, "kd": 8}},
	# ยกดาบขึ้นหัว ตีลังกาหมุนทั้งตัวแนวตั้งลงมา ทุกจังหวะหมุนได้ดาเมจ
	"zzz": {"dur": 0.85, "wind": 0.18, "strike": 0.72, "sw0": 0.0, "sw1": 0.0, "wheel": 3.0, "hit_at": 0.1,
		"p0": Vector2(0.0, 0.75), "p1": Vector2(0.0, 0.75), "lunge": 2.0, "plunge": 4.0, "no_dash": true,
		"hit_reach": 2.6, "hit_back": 1.6, "hit_height": 3.0, "tick": 0.12, "tick_max": 5, "hitstop": 0.02, "lean_w": 0.0, "lean_s": 0.0,
		"hit": {"type": "flinch", "dmg": 4, "kd": 8, "kb": 0.0}},
	# งัดดาบขึ้นจากพื้น มอนลอย
	"xxx": {"dur": 0.6, "wind": 0.25, "strike": 0.3, "sw0": -165.0, "sw1": -15.0,
		"p0": Vector2(0.4, 0.37), "p1": Vector2(0.9, 0.9), "lunge": 1.0, "hit_reach": 2.8, "hit_back": 1.6, "hit_height": 3.0, "from_ground": true,
		"lean_w": -8.0, "lean_s": 12.0,
		"hit": {"type": "launch", "vy": 12.0, "dmg": 10, "kd": 30}},
	# หมุนแขนหนึ่งรอบกลางอากาศ แล้วดิ่งลงฟาดแนวดิ่งที่พื้น
	"xx": {"dur": 0.75, "wind": 0.5, "strike": 0.25, "sw0": -388.0, "sw1": -540.0, "arm_spin": 0.4,
		"p0": Vector2(0.2, 0.7), "p1": Vector2(0.5, 0.37), "lunge": 0.5, "big": 1.5, "plunge": 18.0, "hit_at": 0.9, "hit_height": 3.0, "hit_back": 1.6,
		"lean_w": -6.0, "lean_s": -22.0,
		"hit": {"type": "slam", "dmg": 14, "kd": 100}},
}

## >>x หมุนตัวหนึ่งรอบ ฟาดดาบจากล่างขึ้นบนอย่างแรง ทำให้ลอย
const DASH_X := {"dur": 0.6, "wind": 0.35, "strike": 0.35, "sw0": -170.0, "sw1": -20.0, "spin": 1.0,
	"p0": Vector2(-0.1, 0.37), "p1": Vector2(0.9, 0.8), "lunge": 2.0, "hit_reach": 2.6, "hit_back": 1.4,
	"hit": {"type": "launch", "vy": 13.0, "dmg": 8, "kd": 15}}

## >>zzz ฮิตสุดท้ายฟันทะลุมอน
const DASH_ZZZ := {"dur": 0.42, "sw0": -80.0, "sw1": -100.0, "lunge": 13.0, "lean_s": -22.0, "pierce": true, "hit_back": 0.6,
	"hit": {"type": "flinch", "dmg": 8, "kd": 20, "kb": 0.0}}

## รายการคอมโบของสายนี้สำหรับแผงบนจอ ไล่จากต้นสาย แต่ละแถวบอกชั้นของสายที่ให้ท่านั้น
static func combo_rows(id: String) -> Array:
	var line: Array = []
	var at := id
	while at != "":
		line.push_front(at)
		at = str(JobData.find(at).get("parent", ""))
	var rows: Array = []
	for job in line:
		for combo in JOB_COMBOS.get(job, []):
			rows.append({"name": str(combo).replace("↓", "ลง"), "tier": str(JobData.find(job).get("tier", ""))})
	if rows.is_empty():
		for combo in COMBOS:
			rows.append({"name": combo, "tier": ""})
	return rows

## ท่าจากชื่อคอมโบ เช่น ">>^zz" สำเนาใหม่ทุกครั้ง แก้ค่าได้ไม่กระทบตาราง
static func spec(c: String) -> Dictionary:
	var dash := c.begins_with(">>")
	var body := c.trim_prefix(">>")
	var up := body.begins_with("^")
	body = body.trim_prefix("^")
	var m: Dictionary
	if job_moves.has(c) and (job_moves[c] as Dictionary).has("dur"):
		m = (job_moves[c] as Dictionary).duplicate(true)
		if up:
			m["air"] = true
		return m
	if up and body.length() == 1:
		m = ((DASH_UP_MOVES if dash else UP_MOVES)[body] as Dictionary).duplicate(true)
	elif up and AIR_MOVES.has(body):
		m = (AIR_MOVES[body] as Dictionary).duplicate(true)
	elif dash and body == "x":
		m = DASH_X.duplicate(true)
	elif dash and body == "zzz":
		m = DASH_ZZZ.duplicate(true)
	else:
		m = (BODY_MOVES[body] as Dictionary).duplicate(true)
	if up:
		m["air"] = true
	if dash and not m.get("pierce", false) and not m.has("plunge") and not m.get("no_dash", false) and not (body == "x" and not up):
		m["lunge"] = float(m.get("lunge", 2.0)) + (6.0 if body.length() == 1 else 2.0)
	if job_moves.has(c):
		m.merge((job_moves[c] as Dictionary).duplicate(true), true)
	return m

## ชื่อนี้เป็นส่วนต้นของคอมโบไหนสักชุดหรือไม่
static func valid(c: String) -> bool:
	for combo in active:
		if (combo as String).begins_with(c):
			return true
	return false

## มีคอมโบที่กดถอยหลังต่อจากตรงนี้หรือไม่ ไม่นับ <x> ที่แปลว่ากดรัว
static func has_back_step(c: String) -> bool:
	for combo in active:
		var name := combo as String
		if name.begins_with(c) and (name.length() == c.length() or name[c.length()] != ">"):
			return true
	return false

## ท่านี้คือฮิตสุดท้ายของคอมโบหรือไม่
static func is_final(c: String) -> bool:
	for combo in active:
		if (combo as String).begins_with(c) and (combo as String).length() > c.length():
			return false
	return true
