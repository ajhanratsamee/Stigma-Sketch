class_name ChibiModel
extends Node2D
## ตัวละคร BOYS stickman 3 มิติเส้นดำ ตัว PIXEL บล็อกพิกเซล และตัว CAT แมวเทาตัวกลม ถือดาบไม้ ใช้โครงกระดูกและท่าเดียวกัน
## ตัว CAT ซ่อนแขนขา เห็นแค่ตัว มือ และเท้าที่ลอยแยกกัน เรนเดอร์โมเดลลงภาพแล้ววางที่ตำแหน่งตัวละคร
## แขนขามีสองท่อน คำนวณข้อต่อจากตำแหน่งมือและเท้า จึงงอได้และไม่ยืด มีท่ายืน วิ่ง กระโดด

const CAMERA_SIZE := 5.0         # ภาพสูงกี่หน่วยโมเดล
const CENTER_Y := 1.3
const PX_PER_UNIT := 108.0       # หน่วยโมเดลเป็นจุดของฉาก
const LEGACY_PX := 84.0          # ท่าดาบกำหนดเป็นจุด 84 จุดต่อหน่วย
const TURN := 58.0               # ตัวหันเฉียงไปทางที่เดิน
const TURN_RATE := 720.0
const BLEND_RATE := 9.0          # เปลี่ยนท่ายืน วิ่ง กระโดด ให้นุ่ม

# โครงตัว
const HIP_Y := 1.02
const THIGH := 0.5
const SHIN := 0.5
const ANKLE_Y := 0.06
const SPINE := 0.6
const SHOULDER := Vector3(0.0, 0.58, 0.0)   # เทียบสะโพก
const UPPER_ARM := 0.38
const FOREARM := 0.38
const LIMB_R := 0.046
const SPINE_R := 0.052
const HEAD_R := 0.25
const HEAD_GAP := 0.02
const HAND_R := 0.069
const INK := Color(0.045, 0.045, 0.05)

# ท่ายืน
const STAND_X := 0.17
const STAND_Z := 0.03
const OFF_REST := Vector3(-0.32, 0.98, 0.04)

# ท่าวิ่งแบบนักวิ่งลู่ เท้าที่แตะพื้นเลื่อนถอยหลังเท่าความเร็วพื้น จึงไม่ไถล
const RUN_RATE := 0.359          # กี่รอบก้าวต่อระยะ 1 หน่วยเกม คำนวณจากระยะก้าวบนจอ
const STILL_AFTER := 0.05
const RUN_STANCE := 0.38         # สัดส่วนของรอบที่เท้าแตะพื้น
const RUN_FRONT := 0.64
const RUN_BACK := -0.42
const RUN_LIFT := 0.42
const RUN_X := 0.08
const RUN_DROP := 0.07
const RUN_CROUCH := 0.1           # ย่อสะโพกตลอดตอนวิ่ง
const RUN_LEAN := 42.0
const RUN_HIP_Z := 0.16
const RUN_TWIST := 11.0
const RUN_HAND_FORE := Vector3(0.08, -0.4, -0.54)
const RUN_HAND_BACK := Vector3(0.08, -0.32, -0.66)
const RUN_GRIP_FORE := Vector3(0.08, -0.32, -0.67)
const RUN_GRIP_BACK := Vector3(0.08, -0.28, -0.69)
const RUN_OFF_LOW := Vector3(0.0, -0.16, 0.5)   # มือว่างยกเฉียงมาด้านหน้า เทียบไหล่
const RUN_OFF_HIGH := Vector3(0.0, -0.08, 0.54)
const RUN_SWORD_FORE := 94.0     # ดาบชี้ไปหลังตลอด เปลี่ยนมุมตามแขน
const RUN_SWORD_BACK := 98.0

# ท่าโจมตี
const ATTACK_STANCE := 0.42
const ATTACK_X := 0.17
const ATTACK_CROUCH := 0.14
const ATTACK_LEAN := 12.0
const BUSY_RATE := 14.0
const STEP_RATE := 11.0          # เร็วที่สลับขาหน้า
const STEP_LIFT := 0.2
# คอมโบ Z ตอนง้างเอนหลังบิดตัว ตอนฟาดพุ่งตัวไปหน้า ทีสุดท้ายย่อลึก
const COMBO_WIND_LEAN := -10.0
const COMBO_HIT_LEAN := 20.0
const COMBO_LAST_LEAN := 32.0
const COMBO_TWIST := 26.0
const COMBO_LAST_CROUCH := 0.12

# ท่ากระโดด เท้าเทียบพื้นใต้ตัว มือเทียบไหล่ แยกช่วงขึ้น ลอยค้าง ตก
const AIR_SPEED := 5.0           # ความเร็วแนวตั้งที่ถือว่าเต็มท่าขึ้นหรือตก
const RISE_FOOT_F := Vector3(0.1, 0.4, 0.26)
const RISE_FOOT_B := Vector3(-0.08, 0.02, -0.16)
const APEX_FOOT_F := Vector3(0.12, 0.5, 0.2)
const APEX_FOOT_B := Vector3(-0.12, 0.34, -0.12)
const FALL_FOOT_F := Vector3(0.14, 0.14, 0.14)
const FALL_FOOT_B := Vector3(-0.14, 0.06, -0.12)
const RISE_SWORD_HAND := Vector3(0.1, -0.4, -0.46)
const APEX_SWORD_HAND := Vector3(0.12, -0.36, -0.52)
const FALL_SWORD_HAND := Vector3(0.12, -0.3, -0.5)
const RISE_OFF_HAND := Vector3(-0.1, -0.56, 0.14)
const APEX_OFF_HAND := Vector3(-0.14, -0.5, 0.2)
const FALL_OFF_HAND := Vector3(-0.14, -0.42, 0.16)
const RISE_SWORD := 78.0
const APEX_SWORD := 92.0
const FALL_SWORD := 66.0
const RISE_LEAN := 4.0
const APEX_LEAN := 12.0
const FALL_LEAN := -5.0
# ย่อตัวก่อนกระโดด ยุบตอนลงพื้น ยืดตอนลอย
const WIND_CROUCH := 0.28
const LAND_CROUCH := 0.3
const LAND_TIME := 0.24
const STRETCH_TIME := 0.2
const SQUASH := 0.1
const STRETCH := 0.1
# แรงเฉื่อย ออกตัวตัวจะเอนหลัง หยุดกะทันหันตัวจะเอนหน้า
const INERTIA_LEAN := 15.0
const INERTIA_FADE := 75.0
const LAG_RATE := 20.0           # มือข้างที่ไม่ถือดาบตามหลังนิดหน่อย

# ท่าดาบและฉาก HYPER กำหนดมือไว้เทียบไหล่สูง 1.13 แขนยาว 0.65
const OLD_SHOULDER_Y := 1.13
const HAND_STRETCH := 1.17

# รอยวิถีดาบตอนฟาด สีเดียวกับดาบไม้
const TRAIL_TIP := 1.2           # ขอบนอกของรอย ระยะจากมือ เท่าปลายดาบ
const TRAIL_BASE := 0.28         # ขอบใน
const TRAIL_RIBBON := 0.1        # ครึ่งความกว้างของรอยท่าแทง
const TRAIL_LIFE := 0.22
const TRAIL_STEP := 5.0          # ซอยรอยทุกกี่องศา ให้โค้งเนียนแม้ท่าฟาดเร็ว
const TRAIL_COLOR := Color(0.95, 0.97, 1.0)        # รอยฟาดขาวเงินแบบเหล็กทุกสาย เพราะเป็นรอยคมดาบ
const TRAIL_EDGE_COLOR := Color(0.66, 0.71, 0.78)
const TRAIL_EDGE := 3.5
const OVERSHOOT := 0.07          # ดาบเลยไปตามแรงเหวี่ยงหลังฟาด สัดส่วนของท่า

# ตัว PIXEL เรนเดอร์ภาพเล็กแล้วขยายแบบไม่เบลอ มีเส้นขอบ 1 พิกเซล
const PIXEL_VIEW := 176
const PIXEL_SHOULDER_X := 0.37
const PIXEL_HIP_X := 0.13
const PX_LINE := Color(0.13, 0.09, 0.11)
const PX_SKIN := Color(1.0, 0.8, 0.64)
const PX_HAIR := Color(0.78, 0.13, 0.13)
const PX_HAIR_DARK := Color(0.52, 0.07, 0.1)
const PX_SHIRT := Color(0.96, 0.95, 0.9)
const PX_SHORTS := Color(0.2, 0.22, 0.38)
const PX_SHOE := Color(0.72, 0.14, 0.14)
const PX_SOLE := Color(0.95, 0.92, 0.85)
const PX_EYE := Color(0.1, 0.08, 0.12)
const PX_MOUTH := Color(0.66, 0.25, 0.24)
const OUTLINE_SHADER := """
shader_type canvas_item;
uniform vec4 line_color : source_color;
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if (c.a > 0.5) {
		COLOR = vec4(c.rgb, 1.0);
	} else {
		vec2 px = TEXTURE_PIXEL_SIZE;
		float near = max(max(texture(TEXTURE, UV + vec2(px.x, 0.0)).a, texture(TEXTURE, UV - vec2(px.x, 0.0)).a),
			max(texture(TEXTURE, UV + vec2(0.0, px.y)).a, texture(TEXTURE, UV - vec2(0.0, px.y)).a));
		COLOR = near > 0.5 ? line_color : vec4(0.0);
	}
}
"""

# ตัว CAT ตัวกลมเตี้ยแบบ chibi ลอยเหนือเท้า ขนฟูนิดๆ หน้ามีแค่ตาดำ
const CAT_SIZE := 0.7            # ย่อทั้งตัวให้เตี้ยกว่า BOYS เล็กลงอีกให้เห็นระยะสกิลชัดและน่ารักขึ้น
const CAT_FUR := Color(0.6, 0.61, 0.64)
const CAT_EYE := Color(0.06, 0.06, 0.07)
const CAT_FLOAT := 0.26          # ก้นลอยสูงจากพื้นเท่านี้
const CAT_DEPTH := 0.9
const CAT_FLUFF := 0.0          # ผิวเรียบนุ่มนวล ไม่มีขนฟู (เดิม 0.022)
const CAT_HAND_R := 0.14
const AZURE_RAISE := 0.0
const AZ_EAR_X := 0.27           # หูพับของ AZURE ห่างกลางหัว
const AZ_EAR_Y := 1.0           # ความสูงหูพับ เทียบยอดหัว        # AZURE ยกมือกรงเล็บสูงขึ้นตอนยืน
const CAT_HAND_GAP := 0.05       # มือห่างจากผิวตัวอย่างน้อยเท่านี้ เกือบชิดตัว
const CAT_RUN_HAND_DROP := 0.3    # ตอนวิ่งมือว่างยกมาข้างหน้า ต้องลดลงอีกไม่ให้ชิดตา
const CAT_HAND_DROP := 0.2      # มือแมวต่ำกว่าท่า BOYS ตอนไม่ได้ฟัน
# หูเป็นยอดแหลมดึงขึ้นจากผิวหัว ขอบหูจึงต่อกับหน้าเป็นเส้นเดียว
const CAT_EAR_X := 0.32
const CAT_EAR_H := 0.4
const CAT_EAR_W := 0.26
const CAT_EAR_FLAT := 1.9        # หูแบนหน้าหลัง
const CAT_HIP_X := 0.22
const CAT_LEAN := 0.45           # ตัวกลมเอนน้อยกว่า BOYS
# รูปตัดตัว ความสูงเทียบก้น และรัศมี ก้นกว้าง หัวกลม
# ท่าของแมว ก้าวสั้นเร็ว ตัวเด้งโยก กระโดดม้วนตัว หายใจ กะพริบตา หูกระดิก ฟันแล้วตัวยืดยุบ
const CAT_RUN_FRONT := 0.3
const CAT_RUN_BACK := -0.2
const CAT_RUN_LIFT := 0.2
const CAT_RUN_RATE := 0.912      # ก้าวสั้นจึงต้องก้าวถี่ขึ้น เท้ายังติดพื้น
const CAT_RUN_DROP := 0.12       # ตัวเด้งขึ้นลงทุกก้าว
const CAT_RUN_RAISE := -0.05
const CAT_WADDLE := 9.0
const CAT_TWIST := 1.6
const CAT_TUCK_FOOT := Vector3(0.13, 0.4, 0.04)   # กระโดดแล้วเท้าหดชิดก้น
const CAT_TUCK_HAND := Vector3(0.3, -0.64, 0.12)  # มือหดชิดตัว เทียบไหล่
const CAT_TUCK_LEAN := 16.0
const CAT_BREATH := 0.008
const CAT_SWORD := 0.85         # อาวุธเล็กพอดีมือ (เดิม 1.25 ประมาณ 68%) จุดปลายดาบ/รอยฟันคิดตามค่านี้
# วิ่ง 4 ขา ตัวก้มไปข้างหน้า มือเป็นขาหน้า ก้าวแบบควบ ขาหลังคู่หนึ่ง ขาหน้าคู่หนึ่ง
const CAT_WALK_SWING := 0.14     # เดินสองขาแกว่งมือหน้าหลังเท่านี้
const CAT_GALLOP_LEAN := 78.0
const CAT_PAW_Z := 0.62          # ขาหน้าอยู่หน้าขาหลังเท่านี้
const CAT_PAW_X := 0.24
const CAT_GALLOP_PAIR := 0.08    # สองข้างของคู่เดียวกันห่างกันในรอบก้าว
const CAT_BACK_FOOT_Z := -0.5    # ตัวนอนยาวไปข้างหลัง ขาหลังจึงอยู่ค่อนไปหลัง
const CAT_GALLOP_LOW := 0.12     # ตัวต่ำลงตอนควบ
# ตอนควบหัวงอเงยขึ้นจากลำตัว ตัวนอนแต่หน้ามองไปข้างหน้า หูตั้ง
const CAT_HEAD_LIFT := 64.0
const CAT_NECK_FROM := 0.42      # เริ่มงอที่ความสูงนี้ สัดส่วนของตัว
const CAT_NECK_TO := 0.72        # งอเต็มที่ตั้งแต่ความสูงนี้
const CAT_LOOK_UP := 1.0         # ตาเลื่อนขึ้นไปทางยอดหัว หน้าจึงหันไปข้างหน้าและเงยนิดๆ
const CAT_GALLOP_SWORD := 84.0  # ดาบชี้ไปข้างหลังตอนควบ
const CAT_BOB := 0.15
const CAT_BREATH_SPEED := 1.7
const CAT_STRETCH := 0.14        # ตอนฟาดตัวยืดตามดาบ
const CAT_SQUASH := 0.1          # ฟาดจบตัวยุบ
const CAT_SIDE_HAND := Vector3(0.62, 0.98, 0.3)   # ตอนยืนมือถือดาบอยู่ข้างตัว ค่อนไปข้างหน้า
const CAT_SIDE_ANGLE := -118.0   # ใบดาบยื่นออกไปข้างหน้าเฉียงลง ไม่บังหน้า
const CAT_SIDE_AIM := Vector3(0.4, -0.65, 0.65)    # ทิศใบดาบตอนยืน ออกข้าง ลงล่าง ไปข้างหน้า เทียบทิศตัว
# ร่าง SWORD KNIGHT แมวส้มมีลาย เท้าขาว เกราะไหล่เหล็ก ดาบเหล็กใบแดงแกนขาว ไม่ใส่เสื้อ
const KNIGHT_FUR := Color(0.97, 0.56, 0.2)
# ร่าง BASIC แมวแดงจางแซมลายส้ม
# CAT BOYS แมวโอเรียนทัลขนสั้นสีแดงล้วน หูใหญ่ ไม่มีลาย
const BASIC_FUR := Color(0.86, 0.33, 0.28)
const BASIC_STRIPE := Color(0.7, 0.22, 0.2)
# CAT MATCHA แมวลายสลิด (แมคเคอเรลแทบบี้) สีเขียวชาเขียว
const MATCHA_FUR := Color(0.55, 0.74, 0.4)
const MATCHA_STRIPE := Color(0.27, 0.45, 0.22)
const MATCHA_CREAM := Color(0.86, 0.94, 0.74)
# CAT CITRUS แมวส้มลายเสือจางๆ พุงครีม
const CITRUS_FUR := Color(0.98, 0.6, 0.24)
const ASH_FUR := Color(0.68, 0.68, 0.72)       # CAT ASH แมวเทา
const ASH_STRIPE := Color(0.44, 0.44, 0.5)
const CITRUS_STRIPE := Color(0.86, 0.4, 0.12)
# CAT MAGE แมวม่วงอ่อนลายม่วงเข้ม ถือคฑาไม้ หัวคฑาเป็นอัญมณีม่วง
const MAGE_FUR := Color(0.74, 0.6, 0.9)
const MAGE_STRIPE := Color(0.56, 0.4, 0.8)
const MAGE_GEM := Color(0.7, 0.35, 1.0)
const KNIGHT_STRIPE := Color(0.82, 0.35, 0.09)
const KNIGHT_FEET := Color(0.98, 0.97, 0.94)
const KNIGHT_WEARS_TUNIC := false
const KNIGHT_CREAM := Color(1.0, 0.9, 0.8)
const KNIGHT_TUNIC := Color(0.17, 0.23, 0.48)
const KNIGHT_TRIM := Color(0.93, 0.74, 0.3)
const KNIGHT_BELT := Color(0.33, 0.2, 0.12)
const KNIGHT_STEEL := Color(0.55, 0.58, 0.65)
const KNIGHT_BLADE := Color(0.82, 0.12, 0.13)
const KNIGHT_CORE := Color(0.97, 0.97, 0.95)
const KNIGHT_TRAIL := Color(0.9, 0.16, 0.16)
const KNIGHT_TRAIL_EDGE := Color(0.55, 0.06, 0.07)
const TUNIC_FROM := 0.16         # เสื้อคลุมช่วงความสูงนี้ของตัว
const TUNIC_TO := 0.6
const TUNIC_PUFF := 1.05
const PAULDRON_AT := 0.6
# สายของ CAT BOYS แต่ละสายมีดาบและของติดตัวต่างกัน ตัวแมวเหมือนกัน
const TRAILS := {
	"cat_magic": [Color(1.0, 0.52, 0.12), Color(0.75, 0.2, 0.05)],
	"cat_shield": [Color(0.62, 0.76, 0.98), Color(0.22, 0.36, 0.66)],
	"cat_dark": [Color(0.62, 0.05, 0.08), Color(0.08, 0.04, 0.05)],
}
const FLAME_ORANGE := Color(1.0, 0.5, 0.1)
const FLAME_YELLOW := Color(1.0, 0.86, 0.3)
const FLAME_RED := Color(0.95, 0.2, 0.08)
const MAGIC_BLADE := Color(0.3, 0.3, 0.36)
const MAGIC_CORE := Color(0.42, 0.06, 0.05)
const SHIELD_BLADE := Color(0.82, 0.85, 0.9)
const SHIELD_LINE := Color(0.25, 0.45, 0.85)
const SHIELD_GOLD := Color(0.93, 0.74, 0.3)
const SHIELD_GRIP := Color(0.16, 0.26, 0.55)
const DARK_BLADE := Color(0.09, 0.08, 0.1)
const DARK_RED := Color(0.85, 0.08, 0.1)
const DARK_GLOVE := Color(0.07, 0.07, 0.08)
const BACK_SHIELD_R := 0.3
const CAT_FOOT := [Vector2(0.0, 0.0), Vector2(0.03, 0.09), Vector2(0.08, 0.14), Vector2(0.15, 0.15), Vector2(0.22, 0.14), Vector2(0.27, 0.09), Vector2(0.3, 0.0)]
const CAT_PROFILE := [Vector2(0.0, 0.0), Vector2(0.04, 0.42), Vector2(0.16, 0.62), Vector2(0.4, 0.7), Vector2(0.7, 0.68), Vector2(0.95, 0.62), Vector2(1.15, 0.58), Vector2(1.31, 0.48), Vector2(1.43, 0.3), Vector2(1.5, 0.0)]

# ขอบดำบางมากรอบตัวแมวและอาวุธ หนา 1 จุดของภาพโมเดล ผสมตามความทึบของขอบ จึงไม่หยัก
const INK_LINE := Color(0.27, 0.23, 0.21)   # เส้นขอบตัวแมวสีน้ำตาลเทาเข้ม นุ่มกว่าดำ
const INK_WIDTH := 1.0
const ARMOR_LINE := Color(0.95, 0.1, 0.1)   # เกราะ ขอบตัวเป็นสีแดงหนาขึ้น
const ARMOR_WIDTH := 2.2
const ROLL_AXIS := Vector3(0.3, 0.0, 1.0)   # แกนตีลังกา เกือบตั้งฉากกับจอ เอียงนิดหน่อย
const ROLL_CENTER := Vector3(0.0, 0.95, 0.0)
const AURA_RED := Color(1.0, 0.12, 0.1)
const THIN_OUTLINE_SHADER := """
shader_type canvas_item;
uniform vec4 line_color : source_color;
uniform float width = 1.0;
uniform float flash = 0.0;
uniform vec4 shade : source_color = vec4(1.0);
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE * width;
	float near = 0.0;
	for (int i = 0; i < 8; i++) {
		float a = float(i) * 0.785398;
		near = max(near, texture(TEXTURE, UV + vec2(cos(a), sin(a)) * px).a);
	}
	vec3 rgb = c.a > 0.02 ? c.rgb / max(c.a, 0.001) * min(c.a * 4.0, 1.0) + line_color.rgb * (1.0 - min(c.a * 4.0, 1.0)) : line_color.rgb;
	COLOR = vec4(mix(rgb, vec3(1.0), flash) * shade.rgb, max(c.a, near) * shade.a);
}
"""

const WOOD := Color(0.72, 0.5, 0.27)
const WOOD_DARK := Color(0.47, 0.29, 0.14)
const WOOD_GRAIN := Color(0.54, 0.35, 0.17)

var hero: Hero
var style := "cat"
var view_size := 768
var viewport: SubViewport
var sprite: Sprite2D

# ฉาก HYPER สั่งท่าเอง หน่วยโมเดลในมุมกล้อง x ขวา y ขึ้น
var stage_mode := false
var stage_turn := 0.0
var stage_hand := Vector3(0.42, 0.68, 0.3)
var stage_off := Vector3(-0.42, 0.68, 0.02)
var stage_sw := -28.0
var sword_on := true
var floating := false

var _turn_node: Node3D
var _ink: ShaderMaterial
var _pivot: Node3D              # หมุนทั้งตัวรอบแกนตั้ง ใช้ในหน้าสร้างตัวละครตอนลากหมุน
var turn_extra := 0.0           # องศาที่หมุนเพิ่มจากการลาก
var _torso: Node3D
var _view: Node3D
var _sword: Node3D
var _off_hand: Node3D
var _off_blade: Node3D            # ดาบมือรอง TRAPSTARKER/TWILIGHT หมุนตามท่าด้วยคีย์ off_aim_wind/off_aim_end
const OFF_BLADE_REST := Vector3(-55.0, 0.0, 0.0)
var _blade: Node3D               # ตัวดาบไม่รวมมือ
var _legs: Array = []            # แต่ละข้าง [ต้นขา แข้ง เข่า เท้า]
var _arm_r: Array = []           # [ต้นแขน แขนท่อนล่าง ศอก ไหล่]
var _arm_l: Array = []
var _turn := TURN
var _shoulder_x := 0.0           # ไหล่ซ้ายขวาห่างจากกลางตัว ตัว BOYS ออกจากจุดเดียว
var _hip_x := 0.0
var _is_cat := false            # cat กับ cat_knight ใช้ร่างแมวเหมือนกัน
var _knight := false            # ร่าง SWORD KNIGHT มีเกราะไหล่ ดาบเหล็ก
var _tabby := false             # แมวส้มลายเท้าขาว ใช้ทั้ง BASIC และ SWORD KNIGHT
var _ear_h := CAT_EAR_H          # ความสูงหู โอเรียนทัลกับสฟิงซ์หูใหญ่
var _ear_z := 0.0                # หูลู่ไปด้านหลัง (LAPIS)
var shade := Color.WHITE         # ย้อมสีทั้งตัว (ตัวรองของตัวละครคู่เป็นเงา)
var _tall_k := 1.0               # AZURE ตัวเตี้ย
var _wide_k := 1.0               # LAPIS ตัวผอม
var _ear_w := CAT_EAR_W
var _trail_color := TRAIL_COLOR
var _trail_edge := TRAIL_EDGE_COLOR
var _tunic: MeshInstance3D
var _tunic_still: ArrayMesh
var _tunic_run: ArrayMesh
var _pauldrons: Array = []
var _flames: Array = []         # ไฟบนมือของ MAGIC KNIGHT [ชิ้น ขนาดเดิม จังหวะ]
var _flame_root: Node3D
var _sparkles: Array = []       # ประกายแดงของ DARK KNIGHT
var _blade_fire: Node3D         # ไฟลุกท่วมดาบตอนท่าไฟของ MAGIC KNIGHT
var _blade_flames: Array = []   # เปลวไฟบนดาบ [โหนด ตำแหน่ง จังหวะ ขนาด]
var _aura: Node3D               # ออร่าแดงรอบดาบของ SWORD KNIGHT
var hide_blade := false          # HYPER บางท่าซ่อนดาบ
var npc_look := {}               # NPC ในเมือง (style "cat_npc"): fur stripe ears hat size tabby
var _dash_k := 0.0               # กำลังวิ่งเร็ว ซ่อนดาบ
var wide_hands := 1.0            # หน้าสร้างตัวละคร กางมือออกห่างตัว
var _gk_aura := false               # ออร่าดาบแดงจางของ GRAND KNIGHT
var _dripping := false           # ดาบ CRIMSON มีเลือดหยดตลอด
var _splats: Array = []          # รอยหยดเลือดบนพื้น [ตำแหน่ง อายุ]
var _orbs: Array = []            # ลูกไฟลอยบนมือของ FLAME [โหนด จุดเดิม]
var _bloody := false             # ดาบเลือดของ DARK KNIGHT
var _drips: Array = []           # หยดเลือดจากดาบ [ตำแหน่ง ความเร็ว อายุ]
var _drip_spawn := 0.0
var _fire_fx: Node2D            # วาดดาบติดไฟทับตัวละคร
var _back_shield: Node3D
var _charge_fx := false         # สร้างชั้นวาดดาบเรืองแสงให้ทุกร่างแมว
var _glowing := false
var _hand_shield: Node3D        # โล่บนมือซ้าย ตอนท่าใช้โล่
const BLOOD_TRAIL := Color(0.62, 0.03, 0.06)
const SHIELD_LOW := 0.22         # ถือโล่ต่ำกว่าท่ามือปกติ
var _fire_base := Vector2.ZERO
var _fire_tip := Vector2.ZERO
var _embers: Array = []         # สะเก็ดไฟจากดาบ [ตำแหน่งบนจอ ความเร็ว อายุ]
var _ember_spawn := 0.0
const EMBER_LIFE := 0.5
const FIRE_SWAY := 0.28          # เปลวไฟพลิ้วออกข้างได้มากสุดเท่านี้ของความยาวเปลว
var _size_k := 1.0
var _lean_k := 1.0
var _run_front := RUN_FRONT
var _run_back := RUN_BACK
var _run_lift := RUN_LIFT
var _run_rate := RUN_RATE
var _run_drop := RUN_DROP
var _run_crouch := RUN_CROUCH
var _waddle := 0.0               # ตัวโยกซ้ายขวาตอนวิ่ง องศา
var _twist_k := 1.0
var _sword_k := 1.0              # ขนาดดาบ แมวตัวย่อจึงขยายดาบชดเชย
var _bob_k := 1.0                # ตัวขยับขึ้นลงตอนยืน แมวลอยจากเท้าจึงเห็นช่องว่างยืดหด ต้องน้อยกว่า
var _cat_body: MeshInstance3D
var _cat_mesh_still: ArrayMesh
var _cat_mesh_bent: ArrayMesh
var _cat_mesh_run: ArrayMesh
var _cat_eyes: Array = []
var _cat_eye_home: Array = []
var _cat_eye_up: Array = []
var _blink_t := 2.0
var _blink := 0.0
# สีหน้าแมว: ชุดตาแต่ละอารมณ์สร้างครั้งเดียว สลับเปิดปิดตามสถานะ ไม่สร้างผิวใหม่ทุกเฟรม
var _face_sets: Array = []       # ต่อตาแต่ละข้าง {อารมณ์: Node3D}
var _face_mood := "idle"
var _mouth_cat: Node3D           # ปาก ω ปกติ
var _mouth_open: Node3D          # ปากอ้ากลม ตอนออกท่าพิเศษ โดนตี
var _mouth_smile: Node3D         # ปากยิ้มกว้าง ตอนดีใจ
var face_test := ""              # บังคับสีหน้า ใช้ทดสอบ ว่างคือดูจากสถานะตัวละคร
var _twitch_t := 3.0
var _twitch := 0.0
var _rng := RandomNumberGenerator.new()
var _cat_r: Array = []           # รัศมีตัวแมวตามความสูง ใช้กันมือจมเข้าตัว
var _run_k := 0.0
var _gallop_k := 0.0             # แมววิ่ง 4 ขาเฉพาะตอนแดช เดินปกติยืนสองขา
var _air_k := 0.0
var _busy_k := 0.0
var _run_cycle := 0.0
var _last_x := 0.0
var _still_t := 0.0
var _land_k := 0.0
var _stretch_k := 0.0
var _was_ground := true
var _inertia := 0.0
var _last_speed := 0.0
var _off_lag := Vector3.ZERO
var _lag_ready := false
var _trail: Node2D
var _trail_points: Array = []    # แต่ละจุด [ปลายนอก ปลายใน อายุ ทีที่]
var _trail_on := false
var _trail_done := false
var _trail_nth := -1
var _trail_k := 0.0
var _last_shoulder := Vector3.ZERO
var _front := 1.0              # ขาหน้าตอนโจมตี สลับข้างได้

## สร้างผิวตัวแมวของสไตล์เหล่านี้ล่วงหน้าในเธรดเบื้องหลัง หน้าถัดไปเปิดแล้วไม่ต้องรอ
static func prewarm(styles: Array) -> void:
	WorkerThreadPool.add_task(func() -> void:
		for st in styles:
			var m := ChibiModel.new()
			m.style = str(st)
			m._setup_style()
			if m._is_cat:
				var fl := 0.0 if m.style.begins_with("cat_staff") else CAT_FLUFF
				m._lathe_arrays(CAT_PROFILE, CAT_DEPTH, fl, true, false, false, 1 if m._tabby else 0)
				m._lathe_arrays(CAT_PROFILE, CAT_DEPTH, fl, true, false, true, 1 if m._tabby else 0)
				m._lathe_arrays(CAT_FOOT, 1.0, 0.0 if m.style.begins_with("cat_staff") else CAT_FLUFF * 1.4, false, false)
			m.free())

## สร้างผิวตัว NPC ในเมืองล่วงหน้าในเธรดเบื้องหลัง (สีแต่ละตัวไม่เหมือนกัน ต้องสร้างผิวแยก) คืนเลขงานไว้เช็กว่าเสร็จหรือยัง
static func prewarm_looks(looks: Array) -> int:
	# สร้างตัวแบบบนเธรดหลักก่อน (สร้างโหนดในเธรดอื่นชนกับการโหลดสคริปต์ได้) แล้วให้เธรดเบื้องหลังคำนวณผิวทีละตัว
	var models := []
	for look in looks:
		var m := ChibiModel.new()
		m.style = "cat_npc"
		m.npc_look = look
		m._setup_style()
		models.append(m)
	return WorkerThreadPool.add_task(func() -> void:
		for m in models:
			m._lathe_arrays(CAT_PROFILE, CAT_DEPTH, CAT_FLUFF, true, false, false, 1)
			m._lathe_arrays(CAT_FOOT, 1.0, CAT_FLUFF * 1.4, false, false)
		for m in models:
			m.call_deferred("free"))

func _ready() -> void:
	_setup_style()
	_ready_rest()

## ค่าที่ขึ้นกับสไตล์ ใช้ทั้งตอนสร้างจริงและตอนสร้างล่วงหน้า
func _setup_style() -> void:
	_is_cat = style.begins_with("cat")
	_knight = style == "cat_knight" or style == "cat_grand" or style == "cat_grand_armor"
	_dripping = style == "cat_crimson"
	_tabby = _is_cat
	if style.begins_with("cat_lapis"):
		# หูลู่หลังแต่ตัวสูงเท่าตัวละครอื่น
		_ear_h = 0.32
		_ear_w = 0.33
		_ear_z = -0.24
		_wide_k = 0.84
		_tall_k = 1.12
	elif style.begins_with("cat_azure"):
		# หูแมวตั้งแบบสั้นๆ ตัวเตี้ยและผอมลงตามกัน
		_ear_h = 0.3
		_ear_w = 0.3
		_tall_k = 0.84
		_wide_k = 0.8
	elif style == "cat_npc":
		_ear_h = float(npc_look.get("ears", 0.5))
		_ear_w = 0.3
	elif style.begins_with("cat_bow"):
		_ear_h = 0.43
		_ear_w = 0.27
	elif style.begins_with("cat_staff"):
		_ear_h = 0.56
		_ear_w = 0.33
	elif _is_cat:
		_ear_h = 0.55
		_ear_w = 0.32

func _ready_rest() -> void:
	if _is_cat:
		_size_k = CAT_SIZE * (float(npc_look.get("size", 1.0)) if style == "cat_npc" else 1.0)
		_hip_x = CAT_HIP_X
		_lean_k = CAT_LEAN
		_run_front = CAT_RUN_FRONT
		_run_back = CAT_RUN_BACK
		_run_lift = CAT_RUN_LIFT
		_run_rate = CAT_RUN_RATE
		_run_drop = CAT_RUN_DROP
		_run_crouch = CAT_RUN_RAISE
		_waddle = CAT_WADDLE
		_twist_k = CAT_TWIST
		_sword_k = CAT_SWORD
		_bob_k = CAT_BOB
		_rng.seed = 11
	viewport = SubViewport.new()
	viewport.size = Vector2i(view_size, view_size)
	viewport.transparent_bg = true
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.msaa_3d = Viewport.MSAA_2X
	add_child(viewport)
	_build_stage()
	_build()
	sprite = Sprite2D.new()
	sprite.texture = viewport.get_texture()
	sprite.scale = Vector2.ONE * PX_PER_UNIT * CAMERA_SIZE / float(view_size)
	sprite.position = Vector2(0.0, -CENTER_Y * PX_PER_UNIT)
	if _is_cat:
		var ink := ShaderMaterial.new()
		ink.shader = Shader.new()
		ink.shader.code = THIN_OUTLINE_SHADER
		ink.set_shader_parameter("line_color", INK_LINE)
		ink.set_shader_parameter("width", INK_WIDTH)
		sprite.material = ink
		_ink = ink
	_trail = Node2D.new()
	_trail.draw.connect(_draw_trail)
	add_child(_trail)
	add_child(sprite)
	if _charge_fx and _fire_fx == null:
		_fire_fx = Node2D.new()
		_fire_fx.draw.connect(_draw_blade_fire)
		add_child(_fire_fx)
	# ดาบติดไฟต้องวาดทับตัวละคร
	if _fire_fx != null:
		move_child(_fire_fx, -1)
	if stage_mode:
		_turn = stage_turn
	_sync(0.0)

func _process(delta: float) -> void:
	_sync(delta)
	if _az_glove != null and hero != null:
		_az_glove.rotation_degrees = Vector3(0.0, AZURE_GLOVE_YAW * signf(hero.facing if hero.facing != 0.0 else 1.0), 0.0)
		# ยื่นถุงมือออกห่างจากตัว ไม่จมเข้าไปในลำตัว
		var gf := signf(hero.facing if hero.facing != 0.0 else 1.0)
		_az_glove.position = Vector3(AZURE_GLOVE_OUT.x * gf, AZURE_GLOVE_OUT.y, AZURE_GLOVE_OUT.z)
		# ตอนโจมตีโชว์กรงเล็บทั้งสองข้าง
		if _az_glove_off != null:
			var atk: bool = hero.plain_swing > 0.0
			_az_glove_off.visible = atk
			_az_glove_off.rotation_degrees = _az_glove.rotation_degrees
			if _az_off_paw != null:
				_az_off_paw.visible = not atk

## ขนาดในฉาก HYPER
func place_stage(at: Vector2, size: float) -> void:
	position = at
	scale = Vector2.ONE * size * LEGACY_PX / PX_PER_UNIT

func _build_stage() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color.WHITE
	env.ambient_light_energy = 0.5
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	viewport.add_child(world_env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-42.0, 32.0, 0.0)
	sun.light_energy = 1.4
	viewport.add_child(sun)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = CAMERA_SIZE
	cam.position = Vector3(0.0, CENTER_Y, 10.0)
	viewport.add_child(cam)
	cam.current = true

## ข้อต่อระหว่างสองจุด ความยาวท่อนคงที่ งอไปทาง hint คืน [ข้อต่อ ปลายจริง]
static func solve_joint(from: Vector3, target: Vector3, first: float, second: float, hint: Vector3) -> Array:
	var span := target - from
	var reach := clampf(span.length(), absf(first - second) + 0.002, first + second - 0.002)
	var unit := span.normalized() if span.length() > 0.0001 else Vector3.DOWN
	var along := (first * first + reach * reach - second * second) / (2.0 * reach)
	var height := sqrt(maxf(first * first - along * along, 0.0))
	var side := hint - unit * hint.dot(unit)
	side = side.normalized() if side.length() > 0.0001 else Vector3(0.0, 0.0, 1.0)
	return [from + unit * along + side * height, from + unit * reach]

## วางท่อนกระดูกจาก a ไป b แกน y ของท่อนชี้จาก a ไป b
func _place(node: Node3D, a: Vector3, b: Vector3) -> void:
	var span := b - a
	node.position = (a + b) * 0.5
	var aim := span.normalized() if span.length() > 0.0001 else Vector3.UP
	var axis := Vector3.UP.cross(aim)
	if axis.length() > 0.0001:
		node.basis = Basis(axis.normalized(), Vector3.UP.angle_to(aim))
	elif aim.y < 0.0:
		node.basis = Basis(Vector3.RIGHT, PI)
	else:
		node.basis = Basis.IDENTITY

func _sync(delta: float) -> void:
	var clock: float = hero._clock
	var ground := hero.on_floor() or stage_mode
	var busy := not stage_mode and hero.plain_swing > 0.0
	var moving := not stage_mode and ground and not busy and not hero.attacking and absf(hero.vel.x) > 0.2
	_run_k = _blend(_run_k, 1.0 if moving else 0.0, delta)
	# วิ่งสองขาเสมอ ไม่ควบสี่ขา ตอนวิ่งเร็วซ่อนดาบ
	_gallop_k = 0.0
	_dash_k = _blend(_dash_k, 1.0 if moving and _is_cat and hero.dash_t > 0.0 and not stage_mode else 0.0, delta)
	_air_k = _blend(_air_k, 0.0 if ground or busy else 1.0, delta)
	if moving:
		# ตัวไม่ขยับเกินช่วงเฟรมฟิสิกส์คือชนขอบ ให้ใช้ความเร็วแทน จะได้ไม่ค้าง
		var gone := absf(hero.pos.x - _last_x)
		_still_t = _still_t + delta if gone == 0.0 else 0.0
		if _still_t > STILL_AFTER:
			gone = absf(hero.vel.x) * delta
		_run_cycle = fposmod(_run_cycle + _run_rate * gone, 1.0)
	_last_x = hero.pos.x
	var breathe := sin(clock * Hero.BOB_SPEED) * Hero.BOB / PX_PER_UNIT * _bob_k
	_track_events(ground, delta)
	var wind := 0.0 if stage_mode else hero.plain_jump_wind
	# หันตัว
	var want := stage_turn if stage_mode else TURN * signf(hero.facing)
	_turn = move_toward(_turn, want, TURN_RATE * delta) if delta > 0.0 else want
	_turn_node.rotation_degrees.y = _turn + _combo_spin()
	var roll := _combo_roll()
	var spin_basis := Basis(Vector3.UP, deg_to_rad(turn_extra))
	if roll != 0.0:
		spin_basis = spin_basis * Basis(ROLL_AXIS.normalized(), deg_to_rad(roll))
	_pivot.transform = Transform3D(spin_basis, ROLL_CENTER - spin_basis * ROLL_CENTER)
	# ลำตัว
	_busy_k = move_toward(_busy_k, 1.0 if busy else 0.0, BUSY_RATE * delta) if delta > 0.0 else (1.0 if busy else 0.0)
	var bounce := 0.5 + 0.5 * cos(TAU * 2.0 * (_run_cycle - RUN_STANCE * 0.5))
	var drop := (bounce * _run_drop + _run_crouch) * _run_k + ATTACK_CROUCH * _busy_k + wind * WIND_CROUCH + _land_k * LAND_CROUCH
	var lean := RUN_LEAN * _run_k + _air_float(RISE_LEAN, APEX_LEAN, FALL_LEAN) * _air_k + ATTACK_LEAN * _busy_k + wind * APEX_LEAN + _land_k * APEX_LEAN + _inertia
	var twist := -cos(TAU * _run_cycle) * RUN_TWIST * _run_k
	var want_front := 1.0
	if busy and hero.plain_swing_kind == "combo":
		var body := _combo_body()
		lean += body[0]
		twist += body[1] * _twist_k
		drop += body[2]
		want_front = 1.0 if hero.plain_combo_id % 2 == 1 else -1.0
	_front = move_toward(_front, want_front, STEP_RATE * delta) if delta > 0.0 else want_front
	if _is_cat:
		drop += CAT_GALLOP_LOW * _gallop_k
	_torso.position = Vector3(0.0, HIP_Y + breathe - drop, RUN_HIP_Z * _run_k)
	if _is_cat:
		lean += CAT_TUCK_LEAN * _air_k
		# ตอนควบตัวก้มเกือบขนานพื้น ไม่ใช้ท่าเอนแบบสองขา
		lean = lerpf(lean, CAT_GALLOP_LEAN / _lean_k, _gallop_k)
	# โดนตี ตัวเอนหงายไปข้างหลังแล้วค่อยกลับ
	var hurt_k := 0.0 if stage_mode else clampf(hero.hurt_t / Hero.HURT_TIME, 0.0, 1.0)
	lean -= HURT_LEAN * sin(hurt_k * PI * 0.5)
	twist += HURT_TWIST * hurt_k
	_torso.rotation_degrees = Vector3(lean * _lean_k, twist, sin(TAU * _run_cycle) * _waddle * _run_k)
	_sync_legs(clock)
	_sync_arms(breathe, wind, busy, delta)
	_squash_sprite(wind)
	_dead_pose(delta)
	if _ink != null:
		var armored: bool = not stage_mode and hero.super_armor()
		_ink.set_shader_parameter("line_color", ARMOR_LINE if armored else INK_LINE)
		_ink.set_shader_parameter("width", ARMOR_WIDTH if armored else INK_WIDTH)
		_ink.set_shader_parameter("shade", shade)
		_ink.set_shader_parameter("flash", 0.0 if stage_mode else clampf(hero.flash_t / Hero.FLASH_TIME, 0.0, 1.0) * 0.85)
	_animate_cat(delta)

const HURT_LEAN := 26.0
const HURT_TWIST := 12.0
var _dead_k := 0.0

## เลือดหมด ล้มหงายนอนกับพื้น
func _dead_pose(delta: float) -> void:
	if sprite == null or stage_mode:
		return
	_dead_k = move_toward(_dead_k, 1.0 if hero.hp <= 0.0 else 0.0, delta * 3.0)
	if _dead_k <= 0.0:
		sprite.rotation = 0.0
		return
	var e := 1.0 - pow(1.0 - _dead_k, 3.0)
	var back := -signf(hero.facing) if hero.facing != 0.0 else -1.0
	sprite.rotation = back * deg_to_rad(84.0) * e
	sprite.position = Vector2(back * CENTER_Y * PX_PER_UNIT * 0.75 * e, lerpf(sprite.position.y, -PX_PER_UNIT * 0.32, e))

## ลงพื้น ออกจากพื้น และความเร็วเปลี่ยนทันที
func _track_events(ground: bool, delta: float) -> void:
	if stage_mode:
		return
	if ground and not _was_ground:
		_land_k = 1.0
	elif not ground and _was_ground:
		_stretch_k = 1.0
	_was_ground = ground
	_land_k = move_toward(_land_k, 0.0, delta / LAND_TIME)
	_stretch_k = move_toward(_stretch_k, 0.0, delta / STRETCH_TIME)
	var speed := absf(hero.vel.x)
	if ground and absf(speed - _last_speed) > 1.0:
		_inertia = INERTIA_LEAN * (1.0 if speed < _last_speed else -1.0)
	_last_speed = speed
	_inertia = move_toward(_inertia, 0.0, INERTIA_FADE * delta)

## ยุบและยืดทั้งตัวรอบจุดที่เท้าแตะพื้น
func _squash_sprite(wind: float) -> void:
	var tall := 1.0 + _stretch_k * STRETCH - (_land_k + wind) * SQUASH
	var wide := 1.0 / tall
	var base := PX_PER_UNIT * CAMERA_SIZE / float(view_size) * _size_k
	sprite_scale(Vector2(base * wide * _wide_k, base * tall * _tall_k), tall * _size_k * _tall_k)

func sprite_scale(size: Vector2, tall: float) -> void:
	if sprite == null:
		return
	sprite.scale = size
	sprite.position = Vector2(0.0, -CENTER_Y * PX_PER_UNIT * tall)

## ค่าตามความเร็วแนวตั้ง ขึ้น ลอยค้าง ตก
func _air_float(rise: float, apex: float, fall: float) -> float:
	var v := 0.0 if stage_mode else clampf(hero.vel.y / AIR_SPEED, -1.0, 1.0)
	return lerpf(apex, rise, v) if v >= 0.0 else lerpf(apex, fall, -v)

func _air_vec(rise: Vector3, apex: Vector3, fall: Vector3) -> Vector3:
	var v := 0.0 if stage_mode else clampf(hero.vel.y / AIR_SPEED, -1.0, 1.0)
	return apex.lerp(rise, v) if v >= 0.0 else apex.lerp(fall, -v)

## ความคืบหน้าท่าฟาดของทีนี้ ก่อนและหลังผ่อนจังหวะ
func _strike_raw(hit: Dictionary) -> float:
	return clampf((hero.plain_swing - float(hit["wind"])) / (float(hit["strike"]) - float(hit["wind"])), 0.0, 1.0)

func _strike_eased(hit: Dictionary) -> float:
	return pow(_strike_raw(hit), float(hit["ease"]))

## ลำตัวตามจังหวะคอมโบ Z คืน [เอน บิด ย่อ]
func _combo_body() -> Array:
	var hit: Dictionary = hero.plain_move
	var strike := _strike_raw(hit)
	strike = strike * strike
	var wind := minf(hero.plain_swing / float(hit["wind"]), 1.0)
	var settle := 1.0 - hero.plain_combo_rest
	var lean := lerpf(COMBO_WIND_LEAN * wind, float(hit["lean"]), strike) * settle
	var twist := lerpf(-float(hit["twist"]) * wind, float(hit["twist"]), strike) * settle
	var crouch := (COMBO_LAST_CROUCH * strike if hit.has("spin") else 0.0) * settle
	return [lean, twist, crouch]

## ท่าตีลังกา หมุนทั้งตัวพร้อมดาบในแนวตั้งเฉียงไปข้างหน้า
func _combo_roll() -> float:
	if stage_mode or hero.plain_swing <= 0.0 or hero.plain_swing_kind != "combo":
		return 0.0
	var hit: Dictionary = hero.plain_move
	# กลับหัว ยันพื้นด้วยมือ ยกขาขึ้น พลิกเข้าช่วงต้นท่า แล้วพลิกกลับตอนท้าย
	if hit.has("invert"):
		var u := hero.plain_swing
		var kin := clampf(u / 0.18, 0.0, 1.0)
		var kout := clampf((u - 0.85) / 0.15, 0.0, 1.0)
		var flip := kin * kin * (3.0 - 2.0 * kin) * (1.0 - kout * kout * (3.0 - 2.0 * kout))
		return -180.0 * flip * signf(hero.facing)
	# ม้วนหนึ่งรอบพอดีระหว่างพุ่ง
	if hit.has("roll_once"):
		var k := clampf((hero.plain_swing - float(hit["wind"])) / (float(hit["strike"]) - float(hit["wind"])), 0.0, 1.0)
		return -360.0 * k * signf(hero.facing)
	if not hit.has("roll_rate") or hero.plain_swing < float(hit["wind"]):
		return 0.0
	return -fposmod(hero._clock * float(hit["roll_rate"]), 360.0) * signf(hero.facing)

## ท่าหมุนตัวฟัน ลำตัวหมุนตามใบดาบ
func _combo_spin() -> float:
	if stage_mode or hero.plain_swing <= 0.0 or hero.plain_swing_kind != "combo":
		return 0.0
	var hit: Dictionary = hero.plain_move
	if hit.has("spin_rate"):
		return hero._clock * float(hit["spin_rate"]) * signf(hero.facing) if hero.plain_swing >= float(hit["wind"]) else 0.0
	if not hit.has("spin"):
		return 0.0
	return float(hit["spin"]) * _strike_eased(hit) * signf(hero.facing)

## ทิศใบดาบจาก เงย หัน ในมุมกล้อง
func _aim_dir(pitch: float, yaw: float, flip: float) -> Vector3:
	var p := deg_to_rad(pitch)
	var y := deg_to_rad(yaw)
	return Vector3(cos(p) * cos(y) * flip, sin(p), cos(p) * sin(y))

## ตำแหน่งมือและทิศใบดาบ ระหว่างฟาด k 0 คือท่าง้าง 1 คือท่าจบ เกิน 1 ได้เพื่อให้ดาบเลยไปตามแรงเหวี่ยง
func _blade_at(hit: Dictionary, k: float, shoulder: Vector3) -> Array:
	var flip := signf(hero.facing)
	var from_aim: Vector2 = hit["wind_aim"]
	var to_aim: Vector2 = hit["end_aim"]
	var pitch := lerpf(from_aim.x, to_aim.x, k)
	var yaw := lerpf(from_aim.y, to_aim.y, k)
	var from_hand: Vector3 = hit["wind_hand"]
	var to_hand: Vector3 = hit["end_hand"]
	var off := from_hand.lerp(to_hand, k)
	if hit.has("orbit"):
		var around := _aim_dir(0.0, yaw, 1.0) * float(hit["orbit"])
		off = Vector3(around.x, off.y, around.z)
	if hit.has("tilt"):
		var dip := float(hit["tilt"]) * sin(deg_to_rad(yaw))
		pitch += dip
		off.y += sin(deg_to_rad(dip)) * maxf(Vector2(off.x, off.z).length(), 0.3)
	return [shoulder + Vector3(off.x * flip, off.y, off.z), _aim_dir(pitch, yaw, flip)]

## ท่าคอมโบเต็มรอบ ง้าง ฟาด เลยไปตามแรงเหวี่ยง แล้วกลับท่ายืน คืน [มือ ทิศใบดาบ]
func _combo_pose(shoulder: Vector3, rest_hand: Vector3, rest_angle: float) -> Array:
	var hit: Dictionary = hero.plain_move
	var a := deg_to_rad(rest_angle)
	var rest_aim := Vector3(-sin(a), cos(a), 0.0)
	var hand: Vector3
	var aim: Vector3
	if hero.plain_swing < float(hit["wind"]):
		var before: Array = [rest_hand, rest_aim] if hero.plain_prev.is_empty() else _blade_at(hero.plain_prev, 1.0, shoulder)
		var goal: Array = _blade_at(hit, 0.0, shoulder)
		var w := hero.plain_swing / float(hit["wind"])
		w = 1.0 - (1.0 - w) * (1.0 - w)
		hand = (before[0] as Vector3).lerp(goal[0], w)
		aim = _blend_aim(before[1], goal[1], w)
	else:
		var after := clampf((hero.plain_swing - float(hit["strike"])) / (1.0 - float(hit["strike"])), 0.0, 1.0)
		var swung: Array = _blade_at(hit, _strike_eased(hit) + sin(after * PI) * OVERSHOOT, shoulder)
		hand = swung[0]
		aim = swung[1]
	if hero.plain_combo_rest > 0.0:
		hand = hand.lerp(rest_hand, hero.plain_combo_rest)
		aim = _blend_aim(aim, rest_aim, hero.plain_combo_rest)
	return [hand, aim]

## มือข้างที่ว่างระหว่างฟาด k เหมือนท่าดาบ ท่าหมุนจะอยู่ตรงข้ามใบดาบตลอดรอบ
func _off_at(hit: Dictionary, k: float, shoulder: Vector3) -> Vector3:
	var from_off: Vector3 = hit["wind_off"]
	var to_off: Vector3 = hit["end_off"]
	var off := from_off.lerp(to_off, k)
	if hit.has("off_orbit"):
		var from_aim: Vector2 = hit["wind_aim"]
		var to_aim: Vector2 = hit["end_aim"]
		var yaw := lerpf(from_aim.y, to_aim.y, k)
		var around := _aim_dir(0.0, yaw, 1.0) * -float(hit["off_orbit"])
		off = Vector3(around.x, off.y, around.z)
	return shoulder + Vector3(off.x * signf(hero.facing), off.y, off.z)

## มือข้างที่ว่างตลอดท่า ง้างยื่นออกไปข้างหน้า ฟาดแล้วเหวี่ยงสวนไปข้างหลัง
func _combo_off(shoulder: Vector3, rest_off: Vector3) -> Vector3:
	var hit: Dictionary = hero.plain_move
	var off: Vector3
	if hero.plain_swing < float(hit["wind"]):
		var before: Vector3 = rest_off if hero.plain_prev.is_empty() else _off_at(hero.plain_prev, 1.0, shoulder)
		var w := hero.plain_swing / float(hit["wind"])
		w = 1.0 - (1.0 - w) * (1.0 - w)
		off = before.lerp(_off_at(hit, 0.0, shoulder), w)
	else:
		var after := clampf((hero.plain_swing - float(hit["strike"])) / (1.0 - float(hit["strike"])), 0.0, 1.0)
		off = _off_at(hit, _strike_eased(hit) + sin(after * PI) * OVERSHOOT, shoulder)
	return off.lerp(rest_off, hero.plain_combo_rest)

func _blend_aim(a: Vector3, b: Vector3, w: float) -> Vector3:
	var mixed := a.lerp(b, w)
	return mixed.normalized() if mixed.length() > 0.001 else b

## หมุนดาบให้ใบชี้ตามทิศ และหันหน้าแบนเข้าหากล้องให้มากที่สุด
func _blade_basis(aim: Vector3) -> Basis:
	var side := aim.cross(Vector3(0.0, 0.0, 1.0))
	if side.length() < 0.05:
		side = aim.cross(Vector3.UP)
	side = side.normalized()
	return Basis(side, aim, side.cross(aim))

func _blend(now: float, goal: float, delta: float) -> float:
	return move_toward(now, goal, BLEND_RATE * delta) if delta > 0.0 else goal

## เท้าตามรอบก้าว t ช่วงแตะพื้นเลื่อนถอยหลังเป็นเส้นตรง ช่วงลอยเตะส้นขึ้นแล้วเหวี่ยงมาข้างหน้า
func _run_foot(t: float, side: float) -> Vector3:
	var x := maxf(RUN_X, _hip_x * 0.8)
	if t < RUN_STANCE:
		return Vector3(side * x, ANKLE_Y, lerpf(_run_front, _run_back, t / RUN_STANCE))
	var s := (t - RUN_STANCE) / (1.0 - RUN_STANCE)
	var swing := s * s * (3.0 - 2.0 * s)
	return Vector3(side * x, ANKLE_Y + sin(PI * pow(s, 0.7)) * _run_lift, lerpf(_run_back, _run_front, swing))

## ขาสองข้าง i 1 คือขาหน้าตอนโจมตีและกระโดด
func _sync_legs(clock: float) -> void:
	for i in 2:
		var side := -1.0 if i == 0 else 1.0
		var foot := Vector3(side * STAND_X, ANKLE_Y, side * STAND_Z)
		if _busy_k > 0.0:
			var stepping := 1.0 - absf(_front)
			foot = foot.lerp(Vector3(side * ATTACK_X, ANKLE_Y + (STEP_LIFT * stepping if side * _front < 0.0 else 0.0), side * _front * ATTACK_STANCE), _busy_k)
		elif floating:
			foot.y -= 0.05
			foot.z = side * 0.05 + sin(clock * 2.6 + float(i)) * 0.02
		# ท่าเตะ ยกเท้าหน้าเตะออกไปตอนฟาด
		if _busy_k > 0.0 and i == 1 and hero.plain_move.get("kick", false):
			var kick := sin(clampf((hero.plain_swing - float(hero.plain_move["wind"]) * 0.6) / (1.0 - float(hero.plain_move["wind"]) * 0.6), 0.0, 1.0) * PI)
			foot = foot.lerp(Vector3(side * ATTACK_X, 0.55, 0.78), kick)
		if _run_k > 0.0:
			var offset := (0.0 if i == 1 else CAT_GALLOP_PAIR) if _is_cat and _gallop_k > 0.5 else (0.0 if i == 1 else 0.5)
			var run_foot := _run_foot(fposmod(_run_cycle + offset, 1.0), side)
			if _is_cat:
				run_foot.z += CAT_BACK_FOOT_Z * _gallop_k
			foot = foot.lerp(run_foot, _run_k)
		if _air_k > 0.0:
			var air := _air_vec(RISE_FOOT_F, APEX_FOOT_F, FALL_FOOT_F) if i == 1 else _air_vec(RISE_FOOT_B, APEX_FOOT_B, FALL_FOOT_B)
			if _is_cat:
				air = Vector3(side * CAT_TUCK_FOOT.x, CAT_TUCK_FOOT.y, CAT_TUCK_FOOT.z)
			foot = foot.lerp(air, _air_k)
		var hip := _torso.position + Vector3(side * _hip_x, 0.0, 0.0)
		var solved := solve_joint(hip, foot, THIGH, SHIN, Vector3(0.0, 0.0, 1.0))
		var parts: Array = _legs[i]
		_place(parts[0], hip, solved[0])
		_place(parts[1], solved[0], solved[1])
		(parts[2] as Node3D).position = solved[0]
		(parts[3] as Node3D).position = solved[1]

## แขนขวาถือดาบ แขนซ้ายปล่อยข้างตัว ตอนวิ่งแกว่งสวนขาแบบงอศอก
func _sync_arms(breathe: float, wind: float, busy: bool, delta: float) -> void:
	var shoulder := _world(_torso.transform * SHOULDER)
	var pose: Array = _sword_pose(breathe)
	var hand: Vector3 = _hand_from_pose(pose[0])
	var angle: float = pose[1]
	var body_y := _torso.position.y - HIP_Y
	var off_target: Vector3 = _hand_from_pose(stage_off) if stage_mode else _world(OFF_REST) + Vector3(0.0, body_y, 0.0)
	if not stage_mode:
		var flip := signf(_turn) if _turn != 0.0 else 1.0
		if not busy:
			hand.y += body_y
		var side_off := Vector3(-RUN_HAND_FORE.x * 2.0, 0.0, 0.0)
		if wind > 0.0 or _land_k > 0.0:
			var k := maxf(wind, _land_k * 0.6)
			hand = hand.lerp(shoulder + _turn_node.basis * RUN_HAND_BACK, k)
			off_target = off_target.lerp(shoulder + _turn_node.basis * (RUN_HAND_BACK + side_off), k)
		if _run_k > 0.0:
			# แขนถือดาบอยู่ข้างเดียวกับขา i 1 จึงแกว่งสวนกัน
			var a := cos(TAU * _run_cycle)
			var sword_fore := 0.5 - 0.5 * a
			var run_hand := shoulder + _turn_node.basis * RUN_GRIP_BACK.lerp(RUN_GRIP_FORE, sword_fore)
			var run_off := shoulder + _turn_node.basis * (RUN_OFF_LOW.lerp(RUN_OFF_HIGH, sword_fore) + side_off * 0.5)
			hand = hand.lerp(run_hand, _run_k)
			off_target = off_target.lerp(run_off, _run_k)
			angle = lerpf(angle, lerpf(RUN_SWORD_BACK, RUN_SWORD_FORE, sword_fore) * flip, _run_k)
		if _air_k > 0.0:
			var air_hand := shoulder + _turn_node.basis * _air_vec(RISE_SWORD_HAND, APEX_SWORD_HAND, FALL_SWORD_HAND)
			var air_off := shoulder + _turn_node.basis * _air_vec(RISE_OFF_HAND, APEX_OFF_HAND, FALL_OFF_HAND)
			hand = hand.lerp(air_hand, _air_k)
			off_target = off_target.lerp(air_off, _air_k)
			angle = lerpf(angle, _air_float(RISE_SWORD, APEX_SWORD, FALL_SWORD) * flip, _air_k)
		if busy and hero.plain_swing_kind == "combo":
			off_target = _combo_off(shoulder, off_target)
		# มือที่ไม่ถือดาบตามหลังตัวนิดหน่อย
		if not _lag_ready or delta <= 0.0:
			_off_lag = off_target
			_lag_ready = true
		else:
			_off_lag = _off_lag.lerp(off_target, 1.0 - exp(-LAG_RATE * delta))
		off_target = _off_lag
	var aim := Vector3.ZERO
	if busy and hero.plain_swing_kind == "combo":
		var swung := _combo_pose(shoulder, hand, angle)
		hand = swung[0]
		aim = swung[1]
	var calm_aim := Vector3.ZERO
	var calm_k := 0.0
	if _is_cat and not stage_mode:
		var flip_c := signf(hero.facing)
		# เดินสองขาก็ถือดาบข้างตัวเหมือนตอนยืน แกว่งมือเบาๆ ตามก้าว
		var calm := (1.0 - _busy_k) * (1.0 - _air_k) * (1.0 - _gallop_k)
		var swing_w := sin(TAU * _run_cycle) * CAT_WALK_SWING * _run_k * (1.0 - _gallop_k)
		# มือถือดาบอยู่ข้างตัวอีกฝั่ง สมมาตรกับมือว่าง หมุนดูมุมไหนก็อยู่ข้างตัว
		var side_hand := _world(Vector3(-OFF_REST.x * wide_hands, OFF_REST.y, OFF_REST.z - swing_w)) + Vector3(0.0, body_y, 0.0)
		if style == "cat_azure" or style.begins_with("cat_azure~"):
			# ปล่อยมือลงข้างตัวสบายๆ กรงเล็บห้อยลงพื้น ยังเห็นกรงเล็บชัด
			side_hand = _world(Vector3(-OFF_REST.x * wide_hands * 1.35, OFF_REST.y - 0.12, OFF_REST.z + 0.35 - swing_w)) + Vector3(0.0, body_y, 0.0)
		hand = hand.lerp(side_hand, calm)
		off_target = off_target.lerp(_world(Vector3(OFF_REST.x, OFF_REST.y, OFF_REST.z + swing_w)) + Vector3(0.0, body_y, 0.0), calm * _run_k)
		if wide_hands != 1.0:
			off_target = off_target.lerp(_world(Vector3(OFF_REST.x * wide_hands, OFF_REST.y, OFF_REST.z)) + Vector3(0.0, body_y, 0.0), calm)
		calm_aim = Vector3(0.25 * flip_c, -1.0, 0.0).normalized() if (style == "cat_azure" or style.begins_with("cat_azure~")) else _turn_node.basis * (STAFF_SIDE_AIM if style.begins_with("cat_staff") or style.begins_with("cat_bow") or style.begins_with("cat_spear") else CAT_SIDE_AIM).normalized()
		calm_k = calm
		if _air_k > 0.0 and not busy:
			hand = hand.lerp(shoulder + _turn_node.basis * CAT_TUCK_HAND, _air_k)
			off_target = off_target.lerp(shoulder + _turn_node.basis * Vector3(-CAT_TUCK_HAND.x, CAT_TUCK_HAND.y, CAT_TUCK_HAND.z), _air_k)
		var drop := Vector3(0.0, (CAT_HAND_DROP + CAT_RUN_HAND_DROP * _run_k) * (1.0 - _busy_k), 0.0)
		hand = _keep_out(hand - drop)
		off_target = _keep_out(off_target - drop)
		if busy and hero.plain_move.get("shield_hand", false):
			off_target.y -= SHIELD_LOW
		if _gallop_k > 0.0 and not busy:
			var paw_r := _run_foot(fposmod(_run_cycle + 0.5, 1.0), 1.0)
			var paw_l := _run_foot(fposmod(_run_cycle + 0.5 + CAT_GALLOP_PAIR, 1.0), -1.0)
			hand = hand.lerp(_world(Vector3(CAT_PAW_X, paw_r.y, paw_r.z + CAT_PAW_Z)), _gallop_k)
			off_target = off_target.lerp(_world(Vector3(-CAT_PAW_X, paw_l.y, paw_l.z + CAT_PAW_Z)), _gallop_k)
			angle = lerpf(angle, CAT_GALLOP_SWORD * signf(hero.facing), _gallop_k)
	var shoulder_r := _world(_torso.transform * (SHOULDER + Vector3(_shoulder_x, 0.0, 0.0)))
	var shoulder_l := _world(_torso.transform * (SHOULDER - Vector3(_shoulder_x, 0.0, 0.0)))
	var solved_r := solve_joint(shoulder_r, hand, UPPER_ARM, FOREARM, _turn_node.basis * Vector3(0.1, -0.5, -1.0))
	_set_arm(_arm_r, shoulder_r, solved_r)
	# แมวไม่มีแขน มือจึงอยู่ตรงเป้าได้เลย ไม่ถูกความยาวแขนรั้ง
	_sword.position = hand if _is_cat else solved_r[1]
	if aim == Vector3.ZERO and calm_k > 0.0:
		var a := deg_to_rad(angle)
		aim = _blend_aim(Vector3(-sin(a), cos(a), 0.0), calm_aim, calm_k)
	if aim != Vector3.ZERO:
		_sword.basis = _blade_basis(aim)
	else:
		_sword.rotation = Vector3(0.0, 0.0, deg_to_rad(angle))
	_sword.visible = sword_on
	_sword.scale = Vector3.ONE * _sword_k
	_last_shoulder = shoulder
	_tick_blade_fire(delta)
	_update_trail(delta, shoulder)
	if _blade != null:
		var hide := _dash_k if _is_cat and not busy else 0.0
		if (busy and hero.plain_move.get("hide_sword", false)) or hide_blade:
			hide = 1.0
		_blade.visible = hide < 0.95
		_blade.scale = Vector3.ONE * (1.0 - hide)
	var solved_l := solve_joint(shoulder_l, off_target, UPPER_ARM, FOREARM, _turn_node.basis * Vector3(-0.1, -0.5, -1.0))
	_set_arm(_arm_l, shoulder_l, solved_l)
	_off_hand.position = off_target if _is_cat else solved_l[1]
	_aim_off_blade(busy)

## ท่าที่มีคีย์ off_aim_wind/off_aim_end (องศาบนจอ 0 ชี้ไปทางที่หัน 90 ชี้ขึ้น -90 ชี้ลง) ดาบมือรองหันตามท่า
func _aim_off_blade(busy: bool) -> void:
	if _off_blade == null:
		return
	var hit: Dictionary = hero.plain_move if hero != null else {}
	if not busy or hero.plain_swing_kind != "combo" or not hit.has("off_aim_end"):
		_off_blade.rotation_degrees = OFF_BLADE_REST
		_off_blade.visible = false
		return
	_off_blade.visible = true
	var u := hero.plain_swing
	var w := float(hit.get("wind", 0.3))
	var st := float(hit.get("strike", 0.6))
	var k := clampf((u - w) / maxf(st - w, 0.01), 0.0, 1.0)
	k = k * k * (3.0 - 2.0 * k)
	var a := deg_to_rad(lerpf(float(hit.get("off_aim_wind", hit["off_aim_end"])), float(hit["off_aim_end"]), k))
	var f := signf(hero.facing) if hero.facing != 0.0 else 1.0
	# ใบดาบชี้ไปทาง -y ของกลุ่ม หมุนรอบแกน z ให้ชี้ไปตามมุม เอียงเข้าหากล้องนิดหน่อยให้ดูมีมิติ
	var theta := atan2(cos(a) * f, -sin(a))
	_off_blade.rotation = Vector3(deg_to_rad(-15.0), 0.0, theta)
## เก็บทางที่ใบดาบผ่านตอนฟาด คำนวณจากท่าโดยตรง จึงโค้งเนียนและครบแม้เฟรมกระตุก
func _update_trail(delta: float, shoulder: Vector3) -> void:
	var had := not _trail_points.is_empty()
	for point in _trail_points:
		point[2] += delta
	while not _trail_points.is_empty() and _trail_points[0][2] >= TRAIL_LIFE:
		_trail_points.pop_front()
	var combo: bool = not stage_mode and hero.plain_swing > 0.0 and hero.plain_swing_kind == "combo" and not hero.plain_move.has("no_trail")
	var nth: int = hero.plain_combo_id
	if combo and not hero.plain_move.is_empty():
		var hit: Dictionary = hero.plain_move
		if hero.plain_swing < float(hit["wind"]) or nth != _trail_nth:
			_trail_on = false
			_trail_done = false
		if not _trail_done and hero.plain_swing >= float(hit["wind"]):
			if not _trail_on:
				_trail_on = true
				_trail_nth = nth
				_trail_k = 0.0
				_add_trail_point(hit, 0.0, shoulder, delta, nth)
			var now := _strike_eased(hit)
			var from_aim: Vector2 = hit["wind_aim"]
			var to_aim: Vector2 = hit["end_aim"]
			var span := maxf(maxf(absf(to_aim.x - from_aim.x), absf(to_aim.y - from_aim.y)), 40.0)
			var steps := clampi(ceili((now - _trail_k) * span / TRAIL_STEP), 1, 80)
			for i in range(1, steps + 1):
				var w := float(i) / float(steps)
				_add_trail_point(hit, lerpf(_trail_k, now, w), shoulder, (1.0 - w) * delta, nth)
			_trail_k = now
			_trail_done = now >= 1.0
	else:
		_trail_on = false
		_trail_done = false
		_trail_nth = -1
	if had or not _trail_points.is_empty():
		_trail.queue_redraw()

func _add_trail_point(hit: Dictionary, k: float, shoulder: Vector3, age: float, nth: int) -> void:
	var pose: Array = _blade_at(hit, k, shoulder)
	var hand: Vector3 = pose[0]
	var aim: Vector3 = pose[1]
	var tip := Vector2(hand.x + aim.x * TRAIL_TIP * _sword_k, hand.y + aim.y * TRAIL_TIP * _sword_k)
	var outer := tip
	var inner := Vector2(hand.x + aim.x * TRAIL_BASE * _sword_k, hand.y + aim.y * TRAIL_BASE * _sword_k)
	if hit.has("ribbon"):
		var across := Vector2(-aim.y, aim.x).normalized() * TRAIL_RIBBON
		outer = tip + across
		inner = tip - across
	_trail_points.append([_model_to_global(outer), _model_to_global(inner), age, nth, FLAME_ORANGE if hit.get("flame", false) or (hero.plain_fire_t > 0.0 and _blade_fire != null) else (BLOOD_TRAIL if hit.get("blood", false) else _trail_color)])

## ช่วงที่ใบดาบกวาดผ่านในทีนี้ เป็นระยะแนวนอนในพิกัดของ parent ของตัวละคร ใช้ตัดสินว่าดาบโดนมอนไหม
func blade_span_x(which = null) -> Vector2:
	var hit: Dictionary
	if which is int:
		hit = Hero.CHIBI_Z[which]
	elif which is Dictionary:
		hit = which
	else:
		hit = hero.plain_move
	var low := INF
	var high := -INF
	var holder := hero.get_parent() as Node2D
	for i in 13:
		var pose: Array = _blade_at(hit, float(i) / 12.0, _last_shoulder)
		var hand: Vector3 = pose[0]
		var aim: Vector3 = pose[1]
		for reach in [TRAIL_BASE, TRAIL_TIP]:
			var at := _model_to_global(Vector2(hand.x + aim.x * reach * _sword_k, hand.y + aim.y * reach * _sword_k))
			var x := holder.to_local(at).x if holder != null else at.x
			low = minf(low, x)
			high = maxf(high, x)
	return Vector2(low, high)

## ตำแหน่งมือข้างที่ไม่ได้ถือดาบบนจอ ใช้เป็นจุดปล่อยเวท
## มือที่ถืออาวุธ (คันธนูของ CAT MATCHA)
func weapon_hand_global() -> Vector2:
	return _model_to_global(Vector2(_sword.position.x, _sword.position.y))

func off_hand_global() -> Vector2:
	return _model_to_global(Vector2(_off_hand.position.x, _off_hand.position.y))

## ช่วงความสูงที่ใบดาบกวาดผ่าน เป็นค่า y ในพิกัดของ parent ค่าน้อยคือสูง
func blade_span_y(which = null) -> Vector2:
	var hit: Dictionary
	if which is int:
		hit = Hero.CHIBI_Z[which]
	elif which is Dictionary:
		hit = which
	else:
		hit = hero.plain_move
	var low := INF
	var high := -INF
	var holder := hero.get_parent() as Node2D
	for i in 13:
		var pose: Array = _blade_at(hit, float(i) / 12.0, _last_shoulder)
		var hand: Vector3 = pose[0]
		var aim: Vector3 = pose[1]
		for reach in [0.0, TRAIL_TIP]:
			var at := _model_to_global(Vector2(hand.x + aim.x * reach * _sword_k, hand.y + aim.y * reach * _sword_k))
			var y := holder.to_local(at).y if holder != null else at.y
			low = minf(low, y)
			high = maxf(high, y)
	return Vector2(low, high)

## จุดบนใบดาบเป็นจุดบนจอ รวมการหมุนตัวทั้งตัว (ลากหมุนหน้าเลือกตัว ท่าหมุนตัว) หยดเลือดและไฟจะได้ตามดาบ
func _sword_point(along: float) -> Vector2:
	var p: Vector3 = _pivot.transform * (_view.transform * (_sword.transform * Vector3(0.0, along, 0.0)))
	return _model_to_global(Vector2(p.x, p.y))

## จุดในมุมกล้องของโมเดลเป็นจุดบนจอ เก็บเป็นจุดบนจอเพื่อให้รอยค้างอยู่กับที่ตอนตัวพุ่ง
func _model_to_global(at: Vector2) -> Vector2:
	return global_transform * Vector2(at.x * PX_PER_UNIT * _size_k, -at.y * PX_PER_UNIT * _size_k)

## รอยสีดาบ เข้มที่ขอบนอก จางเข้าหาด้านใน และจางตามอายุ
func _draw_trail() -> void:
	var to_local := _trail.get_global_transform().affine_inverse()
	for i in range(1, _trail_points.size()):
		var before: Array = _trail_points[i - 1]
		var after: Array = _trail_points[i]
		if before[3] != after[3]:
			continue
		var fade_a := 1.0 - float(before[2]) / TRAIL_LIFE
		var fade_b := 1.0 - float(after[2]) / TRAIL_LIFE
		var tip_a: Vector2 = to_local * (before[0] as Vector2)
		var tip_b: Vector2 = to_local * (after[0] as Vector2)
		var base_a: Vector2 = to_local * (before[1] as Vector2)
		var base_b: Vector2 = to_local * (after[1] as Vector2)
		var tint: Color = after[4]
		var outer_a := Color(tint, 0.9 * fade_a)
		var outer_b := Color(tint, 0.9 * fade_b)
		var inner_a := Color(tint, 0.0)
		_trail.draw_primitive(PackedVector2Array([tip_a, tip_b, base_b, base_a]), PackedColorArray([outer_a, outer_b, inner_a, inner_a]), PackedVector2Array())
		_trail.draw_line(tip_a, tip_b, Color(FLAME_RED if tint == FLAME_ORANGE else (Color(0.3, 0.0, 0.02) if tint == BLOOD_TRAIL else _trail_edge), 0.9 * fade_b), TRAIL_EDGE, true)

## จากพื้นที่ที่ตัวหันอยู่ สู่พื้นที่กล้อง
func _world(local: Vector3) -> Vector3:
	return _turn_node.transform * local

func _set_arm(parts: Array, shoulder: Vector3, solved: Array) -> void:
	_place(parts[0], shoulder, solved[0])
	_place(parts[1], solved[0], solved[1])
	(parts[2] as Node3D).position = solved[0]
	(parts[3] as Node3D).position = shoulder

## มือจากท่าดาบและฉาก HYPER เทียบไหล่ตัวนี้ แขนยาวกว่าจึงยืดระยะตาม
func _hand_from_pose(old: Vector3) -> Vector3:
	return Vector3(old.x, HIP_Y + SHOULDER.y + (old.y - OLD_SHOULDER_Y) * HAND_STRETCH, old.z)

## ตำแหน่งมือในหน่วยท่าดาบ และมุมหมุนดาบ องศา
func _sword_pose(breathe: float) -> Array:
	if stage_mode:
		return [stage_hand, stage_sw]
	var pose: Array = hero.plain_pose(breathe * PX_PER_UNIT)
	var px: Vector2 = pose[0]
	var flip := signf(hero.facing)
	return [Vector3(px.x * flip / LEGACY_PX, -px.y / LEGACY_PX, 0.3), float(pose[1]) * flip]

func _mat(color: Color, rough: float, specular: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rough
	m.metallic_specular = specular
	return m

func _part(parent: Node3D, mesh: Mesh, material: Material, at: Vector3, size := Vector3.ONE, turn := Vector3.ZERO) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.material_override = material
	node.position = at
	node.scale = size
	node.rotation_degrees = turn
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(node)
	return node

## กรวยแหลม ปลายอยู่ด้านบน
func _cone(r: float, h: float) -> CylinderMesh:
	var m := CylinderMesh.new()
	m.top_radius = 0.0
	m.bottom_radius = r
	m.height = h
	m.radial_segments = 8
	return m

func _ball(r: float) -> SphereMesh:
	var m := SphereMesh.new()
	m.radius = r
	m.height = r * 2.0
	m.radial_segments = 28
	m.rings = 14
	return m

func _pill(r: float, length: float) -> CapsuleMesh:
	var m := CapsuleMesh.new()
	m.radius = r
	m.height = length + r * 2.0
	m.radial_segments = 16
	m.rings = 4
	return m

func _box(size: Vector3) -> BoxMesh:
	var m := BoxMesh.new()
	m.size = size
	return m

func _rod(top: float, length: float, sides: int) -> CylinderMesh:
	var m := CylinderMesh.new()
	m.top_radius = top
	m.bottom_radius = top
	m.height = length
	m.radial_segments = sides
	return m

func _group(parent: Node) -> Node3D:
	var node := Node3D.new()
	parent.add_child(node)
	return node

func _build() -> void:
	_pivot = _group(viewport)
	_view = _group(_pivot)
	_turn_node = _group(_pivot)
	_torso = _group(_turn_node)
	_sword = _group(_view)
	_off_hand = _group(_view)
	# ทุกตัวเป็นแมว (โมเดล BOYS stickman กับ PIXEL เก่าถูกลบแล้ว)
	_build_cat()

## ตัว CAT ผิวชิ้นเดียวหมุนรอบแกนตั้ง ลอยเหนือเท้า หูตั้ง ตาดำ มือกับเท้าเป็นก้อนกลมลอย ซ่อนแขนขา
func _build_cat() -> void:
	var fur := _mat(_fur() if _tabby else CAT_FUR, 1.0, 0.2)
	var skin := fur
	if _tabby:
		skin = _mat(Color.WHITE, 1.0, 0.2)
		skin.vertex_color_use_as_albedo = true
	var eye := _mat(CAT_EYE, 0.25, 0.5)
	var body := MeshInstance3D.new()
	_cat_mesh_still = _cat_mesh(false)
	# ไม่ทำหูกระดิก หูสองข้างคงที่ตลอด
	_cat_mesh_bent = _cat_mesh_still
	# NPC ไม่วิ่ง ไม่ต้องสร้างผิวท่าวิ่ง
	_cat_mesh_run = _cat_mesh_still if style == "cat_npc" else _cat_mesh(false, true)
	body.mesh = _cat_mesh_still
	body.material_override = skin
	body.position = Vector3(0.0, CAT_FLOAT - HIP_Y, 0.0)
	_torso.add_child(body)
	_cat_body = body
	if _knight:
		_build_knight_gear(body)
	_charge_fx = true
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	for i in 41:
		_cat_r.append(_profile_at(CAT_PROFILE, float(i) / 40.0).y)
	var face := Vector3(0.0, CAT_FLOAT - HIP_Y + top * 0.8, 0.0)
	var foot_mesh := _lathe(CAT_FOOT, 1.0, 0.0 if style.begins_with("cat_staff") else CAT_FLUFF * 1.4, false)
	for side in [-1.0, 1.0]:
		_cat_eyes.append(_part(_torso, _ball(0.07), eye, face + Vector3(side * 0.2, 0.0, 0.47), Vector3(0.85, 1.3, 0.45)))
		_cat_eye_home.append(face + Vector3(side * 0.2, 0.0, 0.47))
		# ตอนควบตัวนอน ยอดหัวกลายเป็นด้านหน้า ตาย้ายไปกลางยอดหัวค่อนลงล่าง หน้าจึงมองไปข้างหน้า ตัวเอียงไม่ถึงแนวนอนจึงเงยนิดๆ
		_cat_eye_up.append(Vector3(side * 0.15, CAT_FLOAT - HIP_Y + top * 0.955, 0.14))
	_build_collar(top)
	# ปากแมว ω ใต้ตา
	var mouth := _group(_torso)
	mouth.position = face + Vector3(0.0, -0.14, 0.5)
	for side in [-1.0, 1.0]:
		for n in 7:
			var a := PI * float(n) / 6.0
			_part(mouth, _ball(0.011), eye, Vector3(side * 0.034 + cos(a) * 0.034, -sin(a) * 0.028, 0.0))
	_mouth_cat = mouth
	if style != "cat_npc":
		_build_faces(eye, face)
	for i in 2:
		var foot := _group(_turn_node)
		_part(foot, foot_mesh, fur, Vector3(0.0, -0.08, 0.04), Vector3(1.0, 0.6, 1.3))
		_legs.append([_group(_turn_node), _group(_turn_node), _group(_turn_node), foot])
	_arm_r = [_group(_view), _group(_view), _group(_view), _group(_view)]
	_arm_l = [_group(_view), _group(_view), _group(_view), _group(_view)]
	var hand_mat: Material = _mat(DARK_GLOVE, 0.6, 0.3) if style in ["cat_dark", "cat_crimson"] else fur
	_part(_off_hand, _ball(CAT_HAND_R), hand_mat, Vector3.ZERO)
	_part(_sword, _ball(CAT_HAND_R), hand_mat, Vector3.ZERO)
	match style:
		"cat_knight":
			_build_steel_sword()
		"cat_magic":
			_build_magic_sword()
			_build_hand_flame()
			_build_blade_fire()
		"cat_shield":
			_build_slim_sword(SHIELD_BLADE, SHIELD_LINE, SHIELD_GOLD, SHIELD_GRIP)
			_build_back_shield(body)
		"cat_dark":
			_build_slim_sword(DARK_BLADE, DARK_RED, DARK_BLADE, DARK_GLOVE)
			_build_dark_extras()
		"cat_staff":
			_build_staff()
		"cat_grand":
			_build_grand_sword()
			_build_grand_armor(body)
		"cat_grand_armor":
			# ตัวทดลอง: GRAND KNIGHT ใส่เกราะเหล็กเต็มตัว (ยังไม่ใช้ในเกม)
			_build_grand_sword()
			_build_plate_armor(body, foot_mesh)
		"cat_flame":
			_build_flame_sword()
			_build_fire_orb()
			_build_blade_fire()
		"cat_guardian":
			_build_guardian_sword()
			_build_guardian_shield()
		"cat_crimson":
			_build_crimson_sword()
			_build_dark_extras()
		_:
			if style.begins_with("cat_staff"):
				_build_staff()
			elif style.begins_with("cat_bow"):
				_build_bow()
			elif style.begins_with("cat_spear"):
				_build_spear()
			elif style.begins_with("cat_fist"):
				_build_fist()
			elif style.begins_with("cat_spirit"):
				_build_spirit(body)
			elif style.begins_with("cat_azure"):
				_build_azure()
			elif style.begins_with("cat_lapis"):
				_build_lapis()
			elif style == "cat_npc":
				_build_npc()
			else:
				_build_sword(fur)
	# ชุดของแต่ละคลาส (แยกไฟล์ตามตัวละคร outfit_*.gd)
	Outfit.build(self, body, foot_mesh)

## เสื้อคลุมอัศวินรอบลำตัว และเกราะไหล่เหล็กสองข้าง ติดไปกับตัวจึงหายใจและยืดยุบตาม
func _build_knight_gear(body: MeshInstance3D) -> void:
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var band := []
	for i in 9:
		var t := lerpf(TUNIC_FROM, TUNIC_TO, float(i) / 8.0)
		var p := _profile_at(CAT_PROFILE, t)
		band.append(Vector2(p.x, p.y * TUNIC_PUFF + 0.01))
	var cloth := _mat(Color.WHITE, 0.9, 0.2)
	cloth.vertex_color_use_as_albedo = true
	cloth.cull_mode = BaseMaterial3D.CULL_DISABLED
	if KNIGHT_WEARS_TUNIC:
		_build_tunic(body, band, cloth, top)
	var steel := _mat(KNIGHT_STEEL, 0.35, 0.8)
	var rim := _mat(KNIGHT_TRIM, 0.4, 0.7)
	var r := _profile_at(CAT_PROFILE, PAULDRON_AT).y * (TUNIC_PUFF if KNIGHT_WEARS_TUNIC else 1.0)
	_add_pauldrons(body, steel, rim, r, top)
	_place_gear(false)

func _build_tunic(body: MeshInstance3D, band: Array, cloth: Material, top: float) -> void:
	_tunic_still = ArrayMesh.new()
	_tunic_still.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _lathe_arrays(band, CAT_DEPTH, 0.0, false, false, false, 2, top))
	_tunic_run = ArrayMesh.new()
	_tunic_run.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _lathe_arrays(band, CAT_DEPTH, 0.0, false, false, true, 2, top))
	_tunic = MeshInstance3D.new()
	_tunic.mesh = _tunic_still
	_tunic.material_override = cloth
	body.add_child(_tunic)

func _add_pauldrons(body: MeshInstance3D, steel: Material, rim: Material, r: float, top: float) -> void:
	for side in [-1.0, 1.0]:
		var plate := Node3D.new()
		body.add_child(plate)
		_part(plate, _ball(0.22), steel, Vector3.ZERO, Vector3(1.05, 0.55, 1.15))
		_part(plate, _ball(0.17), steel, Vector3(side * 0.06, -0.09, 0.0), Vector3(1.0, 0.45, 1.05))
		_part(plate, _rod(0.225, 0.025, 28), rim, Vector3(0.0, -0.035, 0.0), Vector3(1.05, 1.0, 1.15))
		_pauldrons.append([plate, Vector3(side * r, top * PAULDRON_AT, 0.0), side])

## วางเกราะไหล่และเสื้อตามท่า ตอนควบงอไปกับหัว
func _place_gear(lifted: bool) -> void:
	if not _knight:
		return
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	if _tunic != null:
		_tunic.mesh = _tunic_run if lifted else _tunic_still
	for item in _pauldrons:
		var plate := item[0] as Node3D
		var at: Vector3 = item[1]
		var side: float = item[2]
		plate.position = _lift_head(at, top) if lifted else at
		plate.rotation_degrees = Vector3(-CAT_HEAD_LIFT * _neck_weight(at.y, top) if lifted else 0.0, 0.0, -side * 32.0)

func _glow(color: Color, energy := 1.6) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.emission_enabled = true
	m.emission = color
	m.emission_energy_multiplier = energy
	return m

## ดาบ MAGIC KNIGHT ใบเป็นแท่งสี่เหลี่ยมปลายตัด มีแกนกลางสีเข้ม
func _build_magic_sword() -> void:
	_cat_blade(Color(0.95, 0.42, 0.22), Color(1.0, 0.8, 0.35), Color(0.95, 0.55, 0.25), WOOD_DARK, 0.9, 0.12, false, 1.4)

## ดาบแบบแมว ใช้ทุกสาย ใบป้อมปลายมน แกนกลาง กระบังเป็นอุ้งเท้า (หรือหูแมวคู่) รอยอุ้งเท้าบนใบ ท้ายด้ามกระดิ่งทอง
func _cat_blade(blade: Color, core: Color, guard: Color, grip: Color, length := 0.95, width := 0.1, ears := false, core_glow := 0.0) -> void:
	_blade = _group(_sword)
	var bm := _mat(blade, 0.35, 0.7)
	var cm: Material = _glow(core, core_glow) if core_glow > 0.0 else _mat(core, 0.4, 0.6)
	var gm := _mat(guard, 0.3, 0.8)
	var pad := _mat(Color(1.0, 0.65, 0.74), 0.5, 0.4)
	var gold := _mat(Color(1.0, 0.8, 0.3), 0.25, 0.9)
	_part(_blade, _rod(0.032, 0.3, 14), _mat(grip, 0.7, 0.2), Vector3(0.0, -0.02, 0.0))
	for y in [-0.08, 0.02, 0.1]:
		_part(_blade, _rod(0.038, 0.025, 14), gm, Vector3(0.0, y, 0.0))
	_part(_blade, _ball(0.07), gold, Vector3(0.0, -0.22, 0.0))
	_part(_blade, _rod(0.072, 0.012, 16), _mat(Color(0.8, 0.55, 0.15), 0.3, 0.8), Vector3(0.0, -0.22, 0.0))
	_part(_blade, _box(Vector3(0.012, 0.04, 0.02)), _mat(Color(0.3, 0.2, 0.1), 0.6, 0.2), Vector3(0.0, -0.26, 0.06))
	if ears:
		# กระบังหูแมวคู่
		_part(_blade, _pill(0.04, 0.3), gm, Vector3(0.0, 0.15, 0.0), Vector3(1.0, 1.0, 0.8), Vector3(0.0, 0.0, 90.0))
		for side in [-1.0, 1.0]:
			var ear := PrismMesh.new()
			ear.size = Vector3(0.12, 0.13, 0.05)
			_part(_blade, ear, gm, Vector3(side * 0.13, 0.24, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -side * 12.0))
			var inner := PrismMesh.new()
			inner.size = Vector3(0.06, 0.07, 0.055)
			_part(_blade, inner, pad, Vector3(side * 0.13, 0.225, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -side * 12.0))
		_part(_blade, _ball(0.045), cm, Vector3(0.0, 0.16, 0.035), Vector3(1.0, 1.0, 0.6))
	else:
		# กระบังอุ้งเท้า
		_part(_blade, _ball(0.12), gm, Vector3(0.0, 0.16, 0.0), Vector3(1.4, 0.6, 0.55))
		for i in 3:
			_part(_blade, _ball(0.04), pad, Vector3((float(i) - 1.0) * 0.085, 0.24 + (0.02 if i == 1 else 0.0), 0.03), Vector3(1.0, 1.0, 0.7))
		_part(_blade, _ball(0.06), pad, Vector3(0.0, 0.15, 0.05), Vector3(1.2, 0.8, 0.5))
	var mid := 0.26 + width + length * 0.5
	_part(_blade, _pill(width, length), bm, Vector3(0.0, mid, 0.0), Vector3(1.0, 1.0, 0.32))
	_part(_blade, _pill(width * 0.34, length * 0.9), cm, Vector3(0.0, mid, 0.0), Vector3(1.0, 1.0, 0.4))
	for face in [-1.0, 1.0]:
		var at := Vector3(0.0, 0.26 + width + 0.18, face * width * 0.33)
		_part(_blade, _ball(width * 0.3), pad, at, Vector3(1.0, 0.85, 0.3))
		for t in 3:
			_part(_blade, _ball(width * 0.12), pad, at + Vector3((float(t) - 1.0) * width * 0.26, width * (0.35 + (0.06 if t == 1 else 0.0)), 0.0), Vector3(1.0, 1.0, 0.3))

func _flame_mat(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = color
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m

## ดาบติดไฟ วาดเป็นภาพ 2 มิติทับใบดาบ ไม่ใช้โมเดล 3 มิติ โหนดนี้เป็นแค่สวิตช์เปิดปิด
func _build_blade_fire() -> void:
	_blade_fire = _group(_sword)
	_blade_fire.visible = false
	_fire_fx = Node2D.new()
	_fire_fx.draw.connect(_draw_blade_fire)
	add_child(_fire_fx)

## เปลวไฟหนึ่งลิ้น แกนกลางโค้งเป็นคลื่นที่วิ่งจากโคนไปปลาย จึงพลิ้วเหมือนไฟจริง โคนกว้างปลายเรียว
func _tongue(base: Vector2, dir: Vector2, length: float, width: float, phase: float) -> PackedVector2Array:
	const STEPS := 7
	var side := Vector2(-dir.y, dir.x)
	var t := hero._clock
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for n in STEPS + 1:
		var k := float(n) / float(STEPS)
		var sway := sin(k * 4.2 - t * 15.0 + phase) * FIRE_SWAY * length * k
		var spine := base + dir * length * k + side * sway
		var w := width * pow(1.0 - k, 0.75)
		left.append(spine - side * w)
		right.append(spine + side * w)
	right.reverse()
	left.append_array(right)
	return left

## รอยเลือดแบนบนพื้น รูปวงรีขอบหยัก
func _splat(at: Vector2, r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 12:
		var a := TAU * float(i) / 12.0
		var bump := 1.0 + 0.25 * sin(float(i) * 2.7 + r)
		pts.append(at + Vector2(cos(a) * r * 1.6, sin(a) * r * 0.45) * bump)
	return pts

## ใบดาบเรืองแสงเหลืองขาว ขอบส้ม มีเปลวไฟเลียออกจากขอบทั้งสองข้างพลิ้วขึ้นและไปทางหลัง พร้อมสะเก็ดไฟ
func _draw_blade_fire() -> void:
	var burning := _blade_fire != null and _blade_fire.visible
	if not burning and not _glowing and not _bloody and not _gk_aura and not _dripping:
		return
	var to_local := _fire_fx.get_global_transform().affine_inverse()
	var base: Vector2 = to_local * _fire_base
	var tip: Vector2 = to_local * _fire_tip
	var along := tip - base
	if along.length() < 1.0:
		return
	var dir := along.normalized()
	var normal := Vector2(-dir.y, dir.x)
	if normal.y > 0.0:
		normal = -normal
	var t := hero._clock
	if _gk_aura:
		# ออร่าดาบใหญ่คลุมดาบ ยาวเลยปลายดาบออกไป สีแดงอ่อนจางๆ เต้นเบาๆ
		var reach := along * 2.3
		var shimmer := 0.85 + 0.15 * sin(t * 6.0)
		var wide := 26.0 * shimmer
		var shape := PackedVector2Array([base - normal * wide * 0.6, base + reach * 0.8 - normal * wide, base + reach, base + reach * 0.8 + normal * wide, base + normal * wide * 0.6])
		_fire_fx.draw_colored_polygon(shape, Color(1.0, 0.35, 0.35, 0.35 * shimmer))
		var core := PackedVector2Array([base - normal * wide * 0.25, base + reach * 0.82 - normal * wide * 0.4, base + reach * 0.97, base + reach * 0.82 + normal * wide * 0.4, base + normal * wide * 0.25])
		_fire_fx.draw_colored_polygon(core, Color(1.0, 0.6, 0.6, 0.35))
		var rim := shape.duplicate()
		rim.append(shape[0])
		_fire_fx.draw_polyline(rim, Color(1.0, 0.6, 0.6, 0.35), 2.0, true)
		if not burning and not _glowing and not _bloody:
			return
	if _dripping and not _bloody:
		for sp in _splats:
			var at: Vector2 = to_local * (sp[0] as Vector2)
			var k := 1.0 - float(sp[1]) / 3.0
			var paw_r := 6.0 + float(sp[2]) * 3.0
			var paw_col := Color(0.85, 0.22, 0.42, 0.85 * k)
			_fire_fx.draw_colored_polygon(_splat(at, paw_r * 0.8), paw_col)
			for toe in 4:
				_fire_fx.draw_circle(at + Vector2((float(toe) - 1.5) * paw_r * 0.7, -paw_r * (0.55 + (0.15 if toe == 1 or toe == 2 else 0.0))), paw_r * 0.3, paw_col)
		for d in _drips:
			var p: Vector2 = to_local * (d[0] as Vector2)
			var fade := 1.0 - float(d[2]) / 1.2
			_fire_fx.draw_line(p, p + Vector2(0.0, -8.0), Color(0.88, 0.25, 0.45, fade), 3.0, true)
			_fire_fx.draw_circle(p, 3.2, Color(0.92, 0.3, 0.5, fade))
		if not burning and not _glowing:
			return
	if _bloody and not burning and not _glowing:
		# ดาบเลือด ใบแดงคล้ำเรือง มีเลือดเกาะไหลเป็นหยด
		_fire_fx.draw_line(base, tip, Color(0.5, 0.08, 0.22, 0.45), 24.0, true)
		_fire_fx.draw_line(base, tip, Color(0.9, 0.25, 0.45), 13.0, true)
		_fire_fx.draw_line(base, tip, Color(1.0, 0.7, 0.8, 0.9), 4.0, true)
		for i in 4:
			var k := (float(i) + 0.5) / 4.0
			var bead := base + along * k - normal * 6.0 + Vector2(0.0, 4.0 + 3.0 * sin(t * 4.0 + float(i)))
			_fire_fx.draw_circle(bead, 3.5, Color(0.85, 0.22, 0.42))
		for d in _drips:
			var p: Vector2 = to_local * (d[0] as Vector2)
			var fade := 1.0 - float(d[2]) / 0.7
			_fire_fx.draw_line(p, p + Vector2(0.0, -9.0), Color(0.88, 0.25, 0.45, fade), 3.0, true)
			_fire_fx.draw_circle(p, 3.5, Color(0.92, 0.3, 0.5, fade))
		return
	if _glowing and not burning:
		# รวมพลัง ใบดาบเรืองแดงขาว เต้นเป็นจังหวะ
		var pulse := 0.75 + 0.25 * sin(t * 18.0)
		_fire_fx.draw_line(base, tip, Color(1.0, 0.2, 0.15, 0.35 * pulse), 30.0, true)
		_fire_fx.draw_line(base, tip, Color(1.0, 0.55, 0.5, 0.7 * pulse), 14.0, true)
		_fire_fx.draw_line(base, tip, Color(1.0, 0.97, 0.95), 5.0, true)
		return
	_fire_fx.draw_line(base, tip, Color(1.0, 0.45, 0.1, 0.45), 26.0, true)
	_fire_fx.draw_line(base, tip, Color(1.0, 0.7, 0.2, 0.75), 15.0, true)
	_fire_fx.draw_line(base, tip, Color(1.0, 0.95, 0.75), 6.0, true)
	for i in 9:
		var k := (float(i) + 0.5) / 9.0
		var root := base + along * k
		for side in [1.0, -1.0]:
			var lick: float = 0.7 + 0.3 * sin(t * 16.0 + float(i) * 1.7 + side) + 0.15 * sin(t * 27.0 + float(i) * 2.9)
			var flow: Vector2 = (normal * side * 0.5 + Vector2(0.0, -1.0) * 0.8 - dir * 0.55).normalized()
			var length := (22.0 + 16.0 * sin(k * PI)) * lick
			var wobble: float = float(i) * 2.3 + side * 1.1
			_fire_fx.draw_colored_polygon(_tongue(root, flow, length, 12.0, wobble), Color(1.0, 0.42, 0.08, 0.75))
			_fire_fx.draw_colored_polygon(_tongue(root, flow, length * 0.65, 7.0, wobble), Color(1.0, 0.72, 0.22, 0.9))
			_fire_fx.draw_colored_polygon(_tongue(root, flow, length * 0.35, 3.5, wobble), Color(1.0, 0.95, 0.7))
	for ember in _embers:
		var age: float = ember[2]
		var fade := 1.0 - age / EMBER_LIFE
		_fire_fx.draw_circle(to_local * (ember[0] as Vector2), 2.5 + 2.0 * fade, Color(1.0, 0.7, 0.25, fade))

func _tick_blade_fire(delta: float) -> void:
	if _fire_fx == null:
		return
	var move: Dictionary = hero.plain_move
	_glowing = hero.plain_swing > 0.0 and hero.plain_swing_kind == "combo" and move.get("charge_glow", false) and hero.plain_swing < float(move.get("strike", 1.0)) + 0.1
	_bloody = hero.plain_blood_t > 0.0
	_gk_aura = hero.plain_aura_t > 0.0
	var burning := _blade_fire != null and _blade_fire.visible
	if burning or _glowing or _bloody or _gk_aura or _dripping:
		_fire_base = _sword_point(0.25)
		_fire_tip = _sword_point(1.15)
	if burning:
		_fire_base = _sword_point(0.25)
		_fire_tip = _sword_point(1.15)
		_ember_spawn -= delta
		while _ember_spawn <= 0.0:
			_ember_spawn += 0.03
			_embers.append([_fire_base.lerp(_fire_tip, randf()), Vector2(randf_range(-40.0, 40.0), randf_range(-160.0, -80.0)), 0.0])
	for ember in _embers.duplicate():
		ember[2] += delta
		ember[0] += (ember[1] as Vector2) * delta
		if ember[2] >= EMBER_LIFE:
			_embers.erase(ember)
	if _bloody or (_dripping and _blade != null and _blade.visible):
		_drip_spawn -= delta
		while _drip_spawn <= 0.0:
			_drip_spawn += 0.12 if _bloody else 0.35
			_drips.append([_fire_base.lerp(_fire_tip, randf_range(0.3, 1.0)), Vector2(0.0, 40.0), 0.0])
	# พื้นอยู่ที่เท้าตัวละคร หยดที่ตกถึงพื้นกลายเป็นรอยเลือด
	var floor_y: float = global_position.y + (-hero.position.y if hero.is_inside_tree() else 0.0) * global_transform.get_scale().y
	for d in _drips.duplicate():
		d[2] += delta
		d[1] = (d[1] as Vector2) + Vector2(0.0, 900.0) * delta
		d[0] = (d[0] as Vector2) + (d[1] as Vector2) * delta
		if _dripping and (d[0] as Vector2).y >= floor_y:
			_splats.append([Vector2((d[0] as Vector2).x, floor_y), 0.0, randf()])
			_drips.erase(d)
		elif d[2] >= (1.2 if _dripping else 0.7):
			_drips.erase(d)
	for sp in _splats.duplicate():
		sp[1] += delta
		if sp[1] >= 3.0:
			_splats.erase(sp)
	_fire_fx.queue_redraw()

## ออร่าแดงจางๆ ห่อใบดาบ ใช้ตอนท่าที่มีออร่า
func _build_aura() -> void:
	_aura = _group(_blade)
	_part(_aura, _box(Vector3(0.3, 1.18, 0.12)), _flame_mat(Color(AURA_RED, 0.28)), Vector3(0.0, 0.68, 0.0))
	_part(_aura, _box(Vector3(0.23, 1.08, 0.08)), _flame_mat(Color(AURA_RED, 0.4)), Vector3(0.0, 0.66, 0.0))
	_aura.visible = false

## ไฟลุกเล็กๆ บนมือข้างที่ไม่ได้ถือดาบ ชั้นนอกส้ม ชั้นในเหลือง ขยับวูบวาบ
func _build_hand_flame() -> void:
	_flame_root = _group(_off_hand)
	_flame_root.position = Vector3(0.0, CAT_HAND_R * 0.8, 0.0)
	var parts := [[FLAME_RED, Vector3(0.0, 0.07, 0.0), 0.085, 0.0], [FLAME_ORANGE, Vector3(-0.035, 0.1, 0.02), 0.07, 1.7],
		[FLAME_ORANGE, Vector3(0.04, 0.09, -0.01), 0.06, 3.1], [FLAME_YELLOW, Vector3(0.0, 0.08, 0.03), 0.05, 4.4]]
	for item in parts:
		var cone := CylinderMesh.new()
		cone.top_radius = 0.0
		cone.bottom_radius = float(item[2])
		cone.height = float(item[2]) * 3.0
		cone.radial_segments = 12
		var node := _part(_flame_root, cone, _glow(item[0], 2.2), item[1])
		_flames.append([node, item[1], float(item[3])])
		_part(node, _ball(float(item[2])), _glow(item[0], 2.2), Vector3(0.0, -float(item[2]) * 1.4, 0.0))

## ดาบเรียวยาว ปลายแหลม มีเส้นกลางสีตามสาย
func _build_slim_sword(blade_color: Color, line_color: Color, guard_color: Color, grip_color: Color) -> void:
	_cat_blade(blade_color, line_color, guard_color, grip_color, 0.95, 0.085)

## โล่เหล็กกลมเล็กสะพายหลัง มีขอบและปุ่มกลาง ติดไปกับตัว
func _build_back_shield(body: MeshInstance3D) -> void:
	_hand_shield = _group(_off_hand)
	_shield_parts(_hand_shield)
	_hand_shield.visible = false
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var h := 0.42
	var r := _profile_at(CAT_PROFILE, h).y * CAT_DEPTH
	var shield := Node3D.new()
	shield.position = Vector3(0.0, top * h, -r - 0.03)
	shield.rotation_degrees = Vector3(90.0 - 8.0, 0.0, 0.0)
	body.add_child(shield)
	_back_shield = shield
	_shield_parts(shield)

func _shield_parts(shield: Node3D) -> void:
	var steel := _mat(KNIGHT_STEEL, 0.3, 0.85)
	var rim := _mat(Color(0.4, 0.42, 0.48), 0.35, 0.8)
	_part(shield, _rod(BACK_SHIELD_R, 0.05, 32), steel, Vector3.ZERO)
	_part(shield, _rod(BACK_SHIELD_R + 0.03, 0.035, 32), rim, Vector3(0.0, -0.01, 0.0))
	_part(shield, _ball(0.08), rim, Vector3(0.0, -0.03, 0.0), Vector3(1.0, 0.6, 1.0))
	# รอยอุ้งเท้ากลางโล่
	var paw := _mat(SHIELD_LINE, 0.4, 0.5)
	_part(shield, _ball(BACK_SHIELD_R * 0.32), paw, Vector3(0.0, -0.035, BACK_SHIELD_R * 0.2), Vector3(1.0, 0.2, 0.85))
	for i in 4:
		var a := -PI * 0.5 + (float(i) - 1.5) * 0.55
		_part(shield, _ball(BACK_SHIELD_R * 0.13), paw, Vector3(cos(a) * BACK_SHIELD_R * 0.5, -0.035, sin(a) * BACK_SHIELD_R * 0.5), Vector3(1.0, 0.2, 1.0))

## ถุงมือดำมีแกนแดงเล็กๆ ที่หลังมือ
func _build_dark_extras() -> void:
	var red := _glow(DARK_RED, 2.0)
	_sparkles.append(_part(_off_hand, _ball(0.04), red, Vector3(0.0, 0.03, CAT_HAND_R * 0.92), Vector3(1.0, 1.0, 0.5)))
	_sparkles.append(_part(_sword, _ball(0.04), red, Vector3(0.0, 0.0, CAT_HAND_R * 0.92), Vector3(1.0, 1.0, 0.5)))

## ดาบเหล็ก ใบสีแดง แกนกลางขาว ปลายแหลม กระบังกับปุ่มท้ายเป็นเหล็ก
func _build_steel_sword() -> void:
	_cat_blade(KNIGHT_BLADE, KNIGHT_CORE, KNIGHT_STEEL, KNIGHT_BELT, 0.88, 0.11)

func _profile_at(profile: Array, t: float) -> Vector2:
	var n := profile.size() - 1
	var f := clampf(t, 0.0, 1.0) * float(n)
	var i := mini(int(f), n - 1)
	var u := f - float(i)
	var p0: Vector2 = profile[maxi(i - 1, 0)]
	var p1: Vector2 = profile[i]
	var p2: Vector2 = profile[i + 1]
	var p3: Vector2 = profile[mini(i + 2, n)]
	return 0.5 * ((2.0 * p1) + (-p0 + p2) * u + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * u * u + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * u * u * u)

## ผิวเดียวหมุนรอบแกนตั้งตามรูปตัด มีปุยเล็กๆ ทั่วผิว
## ตัวแมวสองแบบ หูปกติ กับหูซ้ายเอียง สลับกันตอนหูกระดิก
## ไม่ใช้ blend shape เพราะ renderer gl_compatibility บนมือถือบางรุ่นทำผิวตัวพัง
func _cat_mesh(twitch: bool, lifted := false) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _lathe_arrays(CAT_PROFILE, CAT_DEPTH, 0.0 if style.begins_with("cat_staff") else CAT_FLUFF, true, twitch, lifted, 1 if _tabby else 0))
	return mesh

func _lathe(profile: Array, depth: float, fluff: float, ears: bool) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _lathe_arrays(profile, depth, fluff, ears, false))
	return mesh

## เก็บผิวที่สร้างแล้วไว้ใช้ซ้ำ ผิวหนึ่งคำนวณหลายพันจุด สร้างใหม่ทุกครั้งที่เปิดหน้าทำให้กดแล้วหน่วง
static var _lathe_cache := {}
static var _cache_lock := Mutex.new()

func _lathe_arrays(profile: Array, depth: float, fluff: float, ears: bool, twitch: bool, lifted := false, paint := 0, paint_top := 0.0) -> Array:
	var key := [style, profile.hash(), depth, fluff, ears, twitch, lifted, paint, paint_top, _ear_h, _ear_w, _ear_z, _tabby, npc_look.hash() if style == "cat_npc" else 0].hash()
	_cache_lock.lock()
	var hit: Variant = _lathe_cache.get(key)
	_cache_lock.unlock()
	if hit != null:
		return hit
	var made := _lathe_arrays_build(profile, depth, fluff, ears, twitch, lifted, paint, paint_top)
	_cache_lock.lock()
	_lathe_cache[key] = made
	_cache_lock.unlock()
	return made

func _lathe_arrays_build(profile: Array, depth: float, fluff: float, ears: bool, twitch: bool, lifted := false, paint := 0, paint_top := 0.0) -> Array:
	# NPC ในเมืองใช้ผิวละเอียดน้อยลง สร้างเร็วกว่าราว 4 เท่า (มองจากไกล ไม่ต่าง)
	var npc := style == "cat_npc"
	var AROUND := 48 if npc else 96
	var ROWS := 42 if npc else 84
	var top: float = (profile[profile.size() - 1] as Vector2).x
	var noise := FastNoiseLite.new()
	noise.seed = 7
	noise.frequency = 6.0
	noise.fractal_octaves = 2
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(0)
	var rings := []
	var color_rings := []
	for r in ROWS + 1:
		var p := _profile_at(profile, float(r) / float(ROWS))
		var ring := []
		var colors_row := []
		for a in AROUND:
			var ang := TAU * float(a) / float(AROUND)
			var puff := 1.0 + fluff * noise.get_noise_3d(sin(ang) * 3.0, p.x * 3.0, cos(ang) * 3.0)
			var v := Vector3(sin(ang) * p.y * puff, p.x, cos(ang) * p.y * depth * puff)
			var plain := v
			if ears and p.x > top * 0.6:
				v.y += _ear_lift(v, top, twitch)
			if paint > 0:
				colors_row.append(_paint_color(paint, plain, v, paint_top if paint_top > 0.0 else top))
			if lifted:
				v = _lift_head(v, paint_top if paint_top > 0.0 else top)
			ring.append(v)
		rings.append(ring)
		color_rings.append(colors_row)
	for r in ROWS:
		for a in AROUND:
			var b := (a + 1) % AROUND
			var corners := [[r, a], [r + 1, a], [r, b], [r, b], [r + 1, a], [r + 1, b]]
			for c in corners:
				if paint > 0:
					st.set_color(color_rings[c[0]][c[1]])
				st.add_vertex(rings[c[0]][c[1]])
	st.index()
	st.generate_normals()
	return st.commit_to_arrays()

## สีของจุดบนผิว 1 คือขนแมวอัศวิน 2 คือเสื้อคลุม คิดจากตำแหน่งก่อนงอหัว ลายจึงติดไปกับตัว
## ขนหลักกับลาย แมวทุกคลาสสีเดียวกับร่าง BASIC แมวแดงจางลายส้ม
func _fur() -> Color:
	if style == "cat_npc":
		return npc_look.get("fur", BASIC_FUR)
	if style == "cat_azure_demon_b":
		return Color(0.32, 0.48, 0.85)
	if style.begins_with("cat_azure"):
		return Color(0.66, 0.85, 1.0)
	if style.begins_with("cat_lapis"):
		return Color(0.52, 0.74, 0.97)
	if style == "cat_spirit_fox":
		return Color(0.98, 0.98, 1.0)
	if style.begins_with("cat_fist"):
		return ASH_FUR
	if style.begins_with("cat_spear") or style.begins_with("cat_spirit"):
		return CITRUS_FUR
	if style.begins_with("cat_bow"):
		return MATCHA_FUR
	return MAGE_FUR if style.begins_with("cat_staff") else BASIC_FUR

func _stripe() -> Color:
	if style == "cat_npc":
		return npc_look.get("stripe", BASIC_STRIPE)
	if style.begins_with("cat_azure"):
		return Color(0.4, 0.6, 0.92)
	if style.begins_with("cat_lapis"):
		return Color(0.28, 0.46, 0.82)
	if style == "cat_spirit_tiger":
		return Color(0.22, 0.12, 0.06)
	if style == "cat_spirit_fox":
		return Color(0.86, 0.88, 0.95)
	if style.begins_with("cat_fist"):
		return ASH_STRIPE
	if style.begins_with("cat_spear") or style.begins_with("cat_spirit"):
		return CITRUS_STRIPE
	if style.begins_with("cat_bow"):
		return MATCHA_STRIPE
	return MAGE_STRIPE if style.begins_with("cat_staff") else BASIC_STRIPE

const STRIPE_SOFT := 0.6        # ลายบนตัวจางเข้าหาสีขนหลัก ดูนุ่มนวล ไม่รก (ปลายหูยังเข้มตามเดิม)

func _paint_color(paint: int, plain: Vector3, v: Vector3, top: float) -> Color:
	var c := _paint_color_raw(paint, plain, v, top)
	if paint == 2 or v.y > top + 0.2:
		return c
	var st := _stripe()
	if c.is_equal_approx(st) or c.is_equal_approx(MATCHA_STRIPE):
		var base := MATCHA_FUR if style.begins_with("cat_bow") else _fur()
		return c.lerp(base, STRIPE_SOFT)
	return c

func _paint_color_raw(paint: int, plain: Vector3, v: Vector3, top: float) -> Color:
	# CAT SUSI แมวสฟิงซ์ผิวม่วงเรียบ ไม่มีลาย มีรอยย่นจางๆ บนหน้าผาก ใบหูด้านในชมพูม่วง
	if style.begins_with("cat_staff") and paint != 2:
		if v.y > top + 0.1 and plain.z > 0.0:
			return MAGE_STRIPE.lerp(Color(0.95, 0.7, 0.85), 0.5)
		if plain.z > 0.12 and plain.y > top * 0.86 and plain.y < top * 0.97:
			for y in [0.885, 0.915, 0.945]:
				if absf(plain.y - top * y) < top * 0.006 and absf(plain.x) < 0.16:
					return MAGE_FUR.darkened(0.12)
		return MAGE_FUR
	if paint == 2:
		var h := (plain.y / top - TUNIC_FROM) / (TUNIC_TO - TUNIC_FROM)
		if h < 0.07 or h > 0.95:
			return KNIGHT_TRIM
		if absf(h - 0.3) < 0.06:
			return KNIGHT_BELT
		if plain.z > 0.0 and absf(plain.x) < 0.05 and h > 0.36:
			return KNIGHT_TRIM
		return KNIGHT_TUNIC
	# CAT MATCHA ลายสลิดเขียว
	if style.begins_with("cat_bow"):
		return _matcha_color(plain, v, top)
	# CAT CITRUS แมวส้มลาย (ใช้ลายแบบแมวลายเดิม)
	if style.begins_with("cat_spear") or style == "cat_spirit_turtle" or style.begins_with("cat_fist"):
		return _old_boys_color(plain, v, top)
	# AZURE / LAPIS ฟ้าอ่อนล้วน ปลายหูเข้ม พุงขาวอมฟ้า
	if style.begins_with("cat_azure") or style.begins_with("cat_lapis"):
		if v.y > top + 0.2:
			return _stripe()
		var belly_p := Vector2(plain.x / 0.34, (plain.y - top * 0.32) / (top * 0.22))
		if plain.z > 0.25 and belly_p.length() < 1.0:
			return Color(0.92, 0.97, 1.0)
		return _fur()
	# NPC ในเมือง สีตามที่กำหนด ปลายหูเข้ม พุงอ่อน มีลายถ้า tabby
	if style == "cat_npc":
		if v.y > top + 0.2:
			return _stripe()
		var belly_n := Vector2(plain.x / 0.34, (plain.y - top * 0.32) / (top * 0.22))
		if plain.z > 0.25 and belly_n.length() < 1.0:
			return _fur().lightened(0.35)
		if npc_look.get("tabby", false) and plain.y > top * 0.1 and plain.y < top * 0.84 and sin(plain.y * 16.0 + absf(plain.x) * 4.0) > 0.6:
			return _stripe()
		return _fur()
	# ร่างวิญญาณเสือ ลายดำหนาทั้งตัว
	if style == "cat_spirit_tiger":
		if v.y > top + 0.2:
			return _stripe()
		if plain.z > 0.12 and plain.y > top * 0.86 and plain.y < top * 0.97:
			for x in [-0.12, 0.0, 0.12]:
				if absf(plain.x - x) < 0.03:
					return _stripe()
		var belly_t := Vector2(plain.x / 0.34, (plain.y - top * 0.32) / (top * 0.22))
		if plain.z > 0.25 and belly_t.length() < 1.0:
			return Color(1.0, 0.95, 0.85)
		if plain.y > top * 0.1 and plain.y < top * 0.84 and sin(plain.y * 16.0 + absf(plain.x) * 4.0) > 0.55:
			return _stripe()
		return _fur()
	# ร่างวิญญาณจิ้งจอก ขาวล้วน ปลายหูเทาอ่อน
	if style == "cat_spirit_fox":
		if v.y > top + 0.24:
			return _stripe()
		return _fur()
	# CAT BOYS โอเรียนทัลสีแดงล้วน ไม่มีลาย ปลายหูเข้มนิดหน่อย พุงอ่อนลงนิด
	if v.y > top + 0.26:
		return _stripe()
	var belly0 := Vector2(plain.x / 0.34, (plain.y - top * 0.32) / (top * 0.22))
	if plain.z > 0.25 and belly0.length() < 1.0:
		return BASIC_FUR.lightened(0.18)
	return _fur()

## สีผิวแมวลายสลิด ลาย M บนหน้าผาก เส้นบางตั้งเรียงรอบตัวเหมือนก้างปลา เส้นกลางหลัง พุงครีม
func _matcha_color(plain: Vector3, v: Vector3, top: float) -> Color:
	if v.y > top + 0.2:
		return MATCHA_STRIPE
	if plain.z > 0.12 and plain.y > top * 0.86 and plain.y < top * 0.97:
		var u := plain.x / 0.13
		var m_line := (absf(absf(u) - 0.55) < 0.18 and plain.y > top * (0.88 + 0.05 * absf(u))) or (absf(u) < 0.12 and plain.y > top * 0.9)
		if m_line:
			return MATCHA_STRIPE
	var ang := atan2(plain.x, -plain.z)
	var back := clampf(-plain.z / 0.35 + 0.55, 0.0, 1.0)
	if back > 0.0 and plain.y > top * 0.1 and plain.y < top * 0.82 and sin(ang * 11.0 + plain.y * 2.0) > 1.0 - back * 0.5:
		return MATCHA_STRIPE
	if plain.z < -0.2 and absf(plain.x) < 0.035 and plain.y > top * 0.15:
		return MATCHA_STRIPE
	var belly := Vector2(plain.x / 0.34, (plain.y - top * 0.32) / (top * 0.22))
	if plain.z > 0.25 and belly.length() < 1.0:
		return MATCHA_CREAM
	return MATCHA_FUR

## ลายเดิมของ CAT BOYS (แมวลาย) เก็บไว้เผื่อใช้
func _old_boys_color(plain: Vector3, v: Vector3, top: float) -> Color:
	# ปลายหูสีเข้ม
	if v.y > top + 0.18:
		return _stripe()
	# ลายสามขีดบนหน้าผาก
	if plain.z > 0.12 and plain.y > top * 0.86 and plain.y < top * 0.96:
		for x in [-0.11, 0.0, 0.11]:
			if absf(plain.x - x) < 0.028:
				return _stripe()
	# ลายขวางด้านหลังและข้างตัว
	var back := clampf(-plain.z / 0.4 + 0.3, 0.0, 1.0)
	if back > 0.0 and plain.y > top * 0.12 and plain.y < top * 0.8 and sin(plain.y * 15.0 + plain.x * 3.0) > 1.0 - back * 0.55:
		return _stripe()
	# พุงครีม
	var belly := Vector2(plain.x / 0.34, (plain.y - top * 0.32) / (top * 0.22))
	if plain.z > 0.25 and belly.length() < 1.0:
		return KNIGHT_CREAM
	return _fur()

## งอส่วนหัวไปทางหลังรอบจุดคอ ส่วนล่างของตัวไม่ขยับ ไล่งอทีละน้อยจึงเป็นคอโค้งเนียน
func _neck_weight(y: float, top: float) -> float:
	var w := clampf((y - top * CAT_NECK_FROM) / (top * (CAT_NECK_TO - CAT_NECK_FROM)), 0.0, 1.0)
	return w * w * (3.0 - 2.0 * w)

func _lift_head(v: Vector3, top: float) -> Vector3:
	var w := _neck_weight(v.y, top)
	if w <= 0.0:
		return v
	var pivot := Vector3(0.0, top * CAT_NECK_FROM, 0.0)
	return pivot + Basis(Vector3.RIGHT, -deg_to_rad(CAT_HEAD_LIFT) * w) * (v - pivot)

## ยอดหูดึงผิวด้านบนขึ้นเป็นกรวยแหลม ใกล้จุดกลางหูยิ่งสูง
func _ear_lift(v: Vector3, top: float, twitch := false) -> float:
	var upper := clampf((v.y - top * 0.6) / (top * 0.25), 0.0, 1.0)
	var lift := 0.0
	for side in [-1.0, 1.0]:
		# ท่ากระดิก หูซ้ายเอียงออกข้างและต่ำลงนิดหนึ่ง
		var bent: bool = twitch and side < 0.0
		var center: float = side * (CAT_EAR_X + (0.07 if bent else 0.0))
		var d := Vector2(v.x - center, (v.z - _ear_z) * CAT_EAR_FLAT).length()
		var w := maxf(1.0 - d / _ear_w, 0.0)
		lift = maxf(lift, _ear_h * (0.8 if bent else 1.0) * w * w * (3.0 - 2.0 * w) * upper)
	return lift

## เส้นมนลากผ่านจุด ปลายและข้อต่อเป็นก้อนกลม
func _stroke(parent: Node3D, pts: Array, r: float, material: Material) -> void:
	for i in pts.size():
		_part(parent, _ball(r), material, pts[i])
		if i + 1 < pts.size():
			_edge(parent, pts[i], pts[i + 1], r, material)

## ชุดตาแต่ละอารมณ์ ตาข้างละชุด จุดศูนย์กลางอยู่ที่ตำแหน่งตาเดิม ซ่อนไว้ก่อน
## big ตากลมโตมีจุดวาว  fierce ตาเรียวมีคิ้วชี้ลง  squint > <  dizzy ก้นหอย  ko X  happy ^  shut ปิดตาโค้ง
func _build_faces(eye: Material, face: Vector3) -> void:
	var shine := _mat(Color.WHITE, 0.2, 0.6)
	shine.emission_enabled = true
	shine.emission = Color(1.0, 1.0, 1.0)
	shine.emission_energy_multiplier = 0.5
	var t := 0.022
	for i in _cat_eyes.size():
		var side := -1.0 if i == 0 else 1.0
		var inward := -side            # ทิศเข้าหาจมูก
		var sets := {}
		var big := Node3D.new()
		_torso.add_child(big)
		_part(big, _ball(0.07), eye, Vector3.ZERO, Vector3(1.05, 1.42, 0.5))
		_part(big, _ball(0.024), shine, Vector3(-0.022, 0.04, 0.034))
		_part(big, _ball(0.012), shine, Vector3(0.022, -0.035, 0.034))
		sets["big"] = big
		var fierce := Node3D.new()
		_torso.add_child(fierce)
		_part(fierce, _ball(0.07), eye, Vector3(0.0, -0.012, 0.0), Vector3(0.85, 1.0, 0.45))
		_part(fierce, _ball(0.013), shine, Vector3(-0.015, 0.012, 0.03))
		_stroke(fierce, [Vector3(-inward * 0.07, 0.135, 0.01), Vector3(inward * 0.055, 0.09, 0.02)], t * 0.95, eye)
		sets["fierce"] = fierce
		var squint := Node3D.new()
		_torso.add_child(squint)
		_stroke(squint, [Vector3(-inward * 0.06, 0.07, 0.0), Vector3(inward * 0.05, 0.0, 0.014), Vector3(-inward * 0.06, -0.07, 0.0)], t, eye)
		sets["squint"] = squint
		var dizzy := Node3D.new()
		_torso.add_child(dizzy)
		var spiral := []
		for n in 15:
			var a := float(n) / 14.0 * TAU * 1.6
			var rr := 0.012 + 0.066 * float(n) / 14.0
			spiral.append(Vector3(cos(a * side) * rr, sin(a * side) * rr, 0.004 * float(n) / 14.0))
		_stroke(dizzy, spiral, t * 0.75, eye)
		sets["dizzy"] = dizzy
		var ko := Node3D.new()
		_torso.add_child(ko)
		_stroke(ko, [Vector3(-0.06, 0.06, 0.0), Vector3(0.06, -0.06, 0.0)], t, eye)
		_stroke(ko, [Vector3(0.06, 0.06, 0.0), Vector3(-0.06, -0.06, 0.0)], t, eye)
		sets["ko"] = ko
		var happy := Node3D.new()
		_torso.add_child(happy)
		var arch := []
		for n in 7:
			var a := PI * (0.12 + 0.76 * float(n) / 6.0)
			arch.append(Vector3(cos(a) * 0.066, sin(a) * 0.066 - 0.024, 0.0))
		_stroke(happy, arch, t, eye)
		sets["happy"] = happy
		var shut := Node3D.new()
		_torso.add_child(shut)
		var bowl := []
		for n in 7:
			var a := PI * (0.12 + 0.76 * float(n) / 6.0)
			bowl.append(Vector3(cos(a) * 0.056, -sin(a) * 0.03 + 0.01, 0.0))
		_stroke(shut, bowl, t * 0.85, eye)
		sets["shut"] = shut
		for k in sets:
			(sets[k] as Node3D).visible = false
		_face_sets.append(sets)
	# ปากอ้ากลมเล็ก กับปากยิ้มกว้าง
	_mouth_open = _group(_torso)
	_mouth_open.position = face + Vector3(0.0, -0.155, 0.49)
	_part(_mouth_open, _ball(0.034), eye, Vector3.ZERO, Vector3(0.9, 1.1, 0.4))
	_part(_mouth_open, _ball(0.018), _mat(Color(0.95, 0.5, 0.55), 0.6, 0.2), Vector3(0.0, -0.012, 0.012), Vector3(1.0, 0.7, 0.4))
	_mouth_open.visible = false
	_mouth_smile = _group(_torso)
	_mouth_smile.position = face + Vector3(0.0, -0.14, 0.5)
	var grin := []
	for n in 9:
		var a := PI * (0.1 + 0.8 * float(n) / 8.0)
		grin.append(Vector3(cos(a) * 0.06, -sin(a) * 0.035, 0.0))
	_stroke(_mouth_smile, grin, 0.012, eye)
	_mouth_smile.visible = false

## อารมณ์ตอนนี้จากสถานะตัวละคร
## idle ปกติ  big วิ่ง  fierce ตีคอมโบ Z  squint ท่าพิเศษ สกิล HYPER  dizzy โดนตี  ko หมดเลือด  happy เลเวลอัป
func _mood_now() -> String:
	if face_test != "":
		return face_test
	if hero == null or stage_mode:
		return "idle"
	if hero.hp <= 0.0:
		return "ko"
	if hero.hurt_t > 0.0:
		return "dizzy"
	if hero.face_t > 0.0 and hero.face_kind != "":
		return hero.face_kind
	if hero.in_hyper():
		return "squint"
	if hero.plain_swing > 0.0:
		if hero.plain_swing_kind == "combo" and (hero.plain_combo_nth >= 99 or hero.plain_move.get("sa", false) or hero.plain_move.get("charge_glow", false)):
			return "squint"
		return "fierce"
	if hero.cheer_t > 0.0:
		return "happy"
	if _run_k > 0.5 and absf(hero.vel.x) > 0.5:
		return "big"
	return "idle"

## เปิดชุดตาของอารมณ์นี้ ซ่อนตาเดิม ตาม position/หมุนของตาเดิม
func _apply_face(mood: String) -> void:
	_face_mood = mood
	var plain := mood == "idle"
	for i in _cat_eyes.size():
		var eye := _cat_eyes[i] as MeshInstance3D
		eye.visible = plain
		if i >= _face_sets.size():
			continue
		var sets: Dictionary = _face_sets[i]
		for k in sets:
			var g := sets[k] as Node3D
			g.visible = k == mood
			if g.visible:
				g.position = eye.position
				g.rotation_degrees = eye.rotation_degrees
	if _mouth_open != null:
		_mouth_open.visible = mood in ["squint", "dizzy"]
		_mouth_smile.visible = mood in ["happy", "big"]
		_mouth_cat.visible = not (_mouth_open.visible or _mouth_smile.visible)

## แมวหายใจ กะพริบตา หูกระดิก และยืดยุบตามจังหวะฟาด
func _animate_cat(delta: float) -> void:
	if _cat_body == null:
		return
	var clock: float = hero._clock
	var calm := (1.0 - _run_k) * (1.0 - _air_k) * (1.0 - _busy_k)
	var breath := sin(clock * CAT_BREATH_SPEED) * CAT_BREATH * calm
	var stretch := 0.0
	if not stage_mode and hero.plain_swing > 0.0 and hero.plain_swing_kind == "combo":
		var hit: Dictionary = hero.plain_move
		var after := clampf((hero.plain_swing - float(hit["strike"])) / (1.0 - float(hit["strike"])), 0.0, 1.0)
		stretch = (sin(_strike_raw(hit) * PI) * CAT_STRETCH - sin(after * PI) * CAT_SQUASH) * (1.0 - hero.plain_combo_rest)
	var tall := 1.0 + breath + stretch
	_cat_body.scale = Vector3(1.0 / sqrt(tall), tall, 1.0 / sqrt(tall))
	if delta <= 0.0:
		return
	_blink_t -= delta
	if _blink_t <= 0.0:
		_blink = 0.14
		_blink_t = _rng.randf_range(2.2, 4.5)
	_blink = maxf(_blink - delta, 0.0)
	var open := 0.12 if _blink > 0.0 else 1.0
	var galloping := _gallop_k > 0.5 and not stage_mode
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var base := Vector3(0.0, CAT_FLOAT - HIP_Y, 0.0)
	for i in _cat_eyes.size():
		var eye := _cat_eyes[i] as MeshInstance3D
		var home: Vector3 = _cat_eye_home[i]
		eye.scale = Vector3(0.85, 1.3 * open, 0.45)
		if galloping:
			# ตาอยู่บนหน้าเหมือนเดิม แต่ไปกับหัวที่งอเงยขึ้น
			eye.position = base + _lift_head(home - base, top)
			eye.rotation_degrees.x = -CAT_HEAD_LIFT * _neck_weight((home - base).y, top)
		else:
			eye.position = home
			eye.rotation_degrees.x = 0.0
	if not _face_sets.is_empty():
		var mood := _mood_now()
		# ตาเดิมกะพริบปิดอยู่ ใช้ตาโค้งปิดแทน ตาโตก็กะพริบได้
		if _blink > 0.0 and mood == "big":
			mood = "shut"
		_apply_face(mood)
		if mood == "big":
			for i in _face_sets.size():
				var g := (_face_sets[i] as Dictionary)["big"] as Node3D
				g.scale = Vector3.ONE * (1.0 + 0.04 * sin(hero._clock * 14.0))
	var clock_f: float = hero._clock
	var acting: bool = hero.plain_swing > 0.0 and hero.plain_swing_kind == "combo"
	if _blade_fire != null:
		var burning: bool = (acting and hero.plain_move.get("flame", false)) or hero.plain_fire_t > 0.0
		_blade_fire.visible = burning
		if burning:
			pass
	if _hand_shield != null:
		var guarding: bool = acting and hero.plain_move.get("shield_hand", false)
		# GUARDIAN ถือโล่ที่มืออีกข้างตลอด ไม่มีโล่หลัง
		_hand_shield.visible = guarding or _back_shield == null
		if _back_shield != null:
			_back_shield.visible = not guarding
		# หน้าโล่หันไปข้างหน้าและเอียงเข้าหากล้อง จึงเห็นหน้าโล่ ไม่เห็นแค่สันบาง
		var face := Vector3(signf(hero.facing) * 0.55, 0.0, 0.85).normalized()
		_hand_shield.basis = Basis(Quaternion(Vector3.UP, face)).scaled(Vector3(1.15, 1.0, 1.15))
		# ขยับโล่ออกไปข้างหน้ามือ มือจึงอยู่หลังโล่ ไม่โผล่ทะลุหน้าโล่
		_hand_shield.position = face * (CAT_HAND_R + 0.06)
	if _aura != null:
		var glowing: bool = acting and hero.plain_move.get("aura", false)
		_aura.visible = glowing
		if glowing:
			var pulse := 1.0 + 0.08 * sin(clock_f * 18.0)
			_aura.scale = Vector3(pulse, 1.0 + 0.03 * sin(clock_f * 13.0), pulse)
	if _flame_root != null:
		var calm_f := (1.0 - _run_k) * (1.0 - _busy_k) * (1.0 - _air_k)
		_flame_root.visible = calm_f > 0.05
		_flame_root.scale = Vector3.ONE * calm_f
		for item in _flames:
			var node := item[0] as MeshInstance3D
			var home: Vector3 = item[1]
			var beat: float = item[2]
			var flick := sin(clock_f * 11.0 + beat) * 0.5 + sin(clock_f * 17.0 + beat * 2.0) * 0.5
			node.scale = Vector3(1.0 - flick * 0.12, 1.0 + flick * 0.28, 1.0 - flick * 0.12)
			node.position = home + Vector3(sin(clock_f * 7.0 + beat) * 0.008, flick * 0.012, 0.0)
	for item in _orbs:
		var orb := item[0] as Node3D
		var home: Vector3 = item[1]
		orb.position = home + Vector3(0.0, sin(clock_f * 3.0) * 0.03, 0.0)
		var pulse := 1.0 + 0.08 * sin(clock_f * 9.0)
		orb.scale = Vector3.ONE * pulse
		orb.rotation.y = clock_f * 2.0
	_tick_staff(clock_f, delta)
	for i in _sparkles.size():
		var spark := _sparkles[i] as MeshInstance3D
		var glow := 0.75 + 0.25 * sin(clock_f * 5.0 + float(i) * 2.1)
		spark.scale = Vector3(glow, glow * (1.6 if i == 2 else 1.0), 0.5 if i < 2 else 0.4)
	_twitch_t -= delta
	if _twitch_t <= 0.0:
		_twitch = 0.3
		_twitch_t = _rng.randf_range(3.0, 6.0)
	_twitch = maxf(_twitch - delta, 0.0)
	var bent := false
	if _gallop_k > 0.5 and not stage_mode:
		_cat_body.mesh = _cat_mesh_run
	else:
		_cat_body.mesh = _cat_mesh_bent if bent else _cat_mesh_still
	_place_gear(_gallop_k > 0.5 and not stage_mode)

## ดันมือที่จมอยู่ในตัวแมวออกมาให้ลอยห่างผิวตัว
func _keep_out(p: Vector3) -> Vector3:
	if _cat_r.is_empty():
		return p
	var axis := _world(Vector3(0.0, 0.0, _torso.position.z))
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var h := (p.y - (_torso.position.y - HIP_Y) - CAT_FLOAT) / top
	if h < -0.1 or h > 1.1:
		return p
	var f := clampf(h, 0.0, 1.0) * 40.0
	var i := mini(int(f), 39)
	# หน้าสร้างตัวละครกางมือ ให้ลูกมือลอยพ้นผิวตัวทั้งลูก ไม่จมเข้าตัว
	var need := lerpf(float(_cat_r[i]), float(_cat_r[i + 1]), f - float(i)) + CAT_HAND_GAP + maxf(wide_hands - 1.0, 0.0) * 0.25
	var d := Vector2(p.x - axis.x, p.z - axis.z)
	if d.length() >= need:
		return p
	d = d.normalized() if d.length() > 0.01 else Vector2(signf(hero.facing), 0.0)
	d *= need
	return Vector3(axis.x + d.x, p.y, axis.z + d.y)

## ดาบไม้ ใบแบนมีความหนา ปลายมน กระบังแท่งไม้ ด้ามกลม
## คฑาไม้ ด้ามยาว ปลายล่างมีปุ่มไม้ หัวคฑาเป็นปมไม้มีกิ่งสามกิ่งโอบอัญมณีม่วงเรืองแสง
## GRAND KNIGHT ดาบเรียวยาว ใบเงินแกนแดง โกร่งทองโค้งปลายมน อัญมณีแดงกลางโกร่งและท้ายด้าม
func _build_grand_sword() -> void:
	_cat_blade(Color(0.9, 0.91, 0.95), Color(1.0, 0.35, 0.4), KNIGHT_TRIM, KNIGHT_BELT, 1.1, 0.09, true, 1.4)

## GRAND KNIGHT เกราะอกเหล็ก ลายกากบาททอง เข็มขัดทอง เกราะไหล่ชั้นที่สอง
func _build_grand_armor(body: MeshInstance3D) -> void:
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var steel := _mat(KNIGHT_STEEL, 0.3, 0.85)
	var gold := _mat(KNIGHT_TRIM, 0.3, 0.85)
	var chest_r := _profile_at(CAT_PROFILE, 0.42).y * CAT_DEPTH
	_part(body, _ball(0.3), steel, Vector3(0.0, top * 0.42, chest_r - 0.1), Vector3(1.15, 0.95, 0.45))
	_part(body, _box(Vector3(0.05, 0.36, 0.04)), gold, Vector3(0.0, top * 0.43, chest_r + 0.03))
	_part(body, _box(Vector3(0.3, 0.05, 0.04)), gold, Vector3(0.0, top * 0.48, chest_r + 0.02))
	_part(body, _ball(0.04), _glow(Color(1.0, 0.15, 0.15), 1.6), Vector3(0.0, top * 0.48, chest_r + 0.05))
	var waist := _profile_at(CAT_PROFILE, 0.24)
	_part(body, _rod(waist.y * 1.03, 0.07, 40), gold, Vector3(0.0, top * 0.24, 0.0), Vector3(1.0, 1.0, CAT_DEPTH))
	_part(body, _box(Vector3(0.12, 0.1, 0.04)), gold, Vector3(0.0, top * 0.24, waist.y * CAT_DEPTH + 0.02))
	var r := _profile_at(CAT_PROFILE, PAULDRON_AT).y
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.16), gold, Vector3(side * r * 1.02, top * (PAULDRON_AT - 0.05), 0.0), Vector3(1.0, 0.4, 1.0))

## เกราะอัศวินเหล็กเต็มตัวแบบน่ารัก: หมวกหูแมว เกราะอกตราอุ้งเท้า เกราะไหล่กลม กระโปรงเกราะ ถุงมือเหล็ก รองเท้าเกราะ
## ชิ้นเกราะติดกับตัว มือ และเท้า จึงขยับตามท่าเดิมทั้งหมด
func _build_plate_armor(body: MeshInstance3D, foot_mesh: Mesh) -> void:
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var steel := _mat(Color(0.6, 0.64, 0.73), 0.32, 0.9)
	steel.metallic = 0.55
	var steel_dark := _mat(Color(0.45, 0.48, 0.58), 0.35, 0.85)
	steel_dark.metallic = 0.55
	var gold := _mat(KNIGHT_TRIM, 0.3, 0.85)
	var red := _mat(Color(0.88, 0.22, 0.28), 0.6, 0.3)
	# เกราะลำตัว เปลือกพองกว่าตัวนิดหน่อย ตั้งแต่สะโพกถึงคอ
	var shell := []
	for i in 12:
		var t := lerpf(0.06, 0.66, float(i) / 11.0)
		var p := _profile_at(CAT_PROFILE, t)
		shell.append(Vector2(p.x, p.y * 1.07 + 0.012))
	_part(body, _lathe(shell, CAT_DEPTH, 0.0, false), steel, Vector3.ZERO)
	# ขอบทองที่คอและเอว
	# รอยต่อแผ่นเกราะสีเงินเข้ม ให้ดูเป็นแผ่นเหล็กซ้อนกัน
	for t in [0.33, 0.5]:
		var j := _profile_at(CAT_PROFILE, t)
		_part(body, _rod(j.y * 1.085, 0.02, 40), steel_dark, Vector3(0.0, j.x, 0.0), Vector3(1.0, 1.0, CAT_DEPTH))
	for t in [0.66, 0.2]:
		var q := _profile_at(CAT_PROFILE, t)
		_part(body, _rod(q.y * 1.1, 0.05, 40), gold, Vector3(0.0, q.x, 0.0), Vector3(1.0, 1.0, CAT_DEPTH))
	# ตราอุ้งเท้าทองกลางอก
	var chest := _profile_at(CAT_PROFILE, 0.42)
	var cz := chest.y * CAT_DEPTH * 1.07 + 0.02
	_part(body, _ball(0.09), gold, Vector3(0.0, chest.x - 0.02, cz), Vector3(1.1, 0.9, 0.35))
	for k in 3:
		var a := deg_to_rad(-40.0 + 40.0 * float(k))
		_part(body, _ball(0.04), gold, Vector3(sin(a) * 0.12, chest.x + 0.1 + cos(a) * 0.02, cz - 0.01), Vector3(1.0, 1.0, 0.35))
	# กระโปรงเกราะ แผ่นโค้งรอบเอว สลับเงินเข้ม
	var hip := _profile_at(CAT_PROFILE, 0.1)
	for n in 10:
		var ang := TAU * float(n) / 10.0
		var at := Vector3(sin(ang) * hip.y * 1.12, hip.x - 0.04, cos(ang) * hip.y * 1.12 * CAT_DEPTH)
		var plate := _part(body, _ball(0.12), steel_dark if n % 2 == 0 else steel, at, Vector3(1.0, 0.75, 0.35))
		plate.rotation = Vector3(0.0, ang, 0.0)
	# ไม่ใส่หมวก (ผู้เล่นให้เอาออก)
	# เกราะไหล่ใหญ่กลม (เพิ่มจากเกราะไหล่ของอัศวิน) ขอบทอง
	var r := _profile_at(CAT_PROFILE, PAULDRON_AT).y
	for side in [-1.0, 1.0]:
		_part(body, _ball(0.2), steel, Vector3(side * r * 1.05, top * (PAULDRON_AT - 0.02), 0.0), Vector3(1.0, 0.6, 1.1))
		_part(body, _rod(0.2, 0.03, 28), gold, Vector3(side * r * 1.05, top * (PAULDRON_AT - 0.06), 0.0), Vector3(1.0, 1.0, 1.1))
	# ถุงมือเหล็กกลม ข้อมือทอง
	for hand in [_sword, _off_hand]:
		_part(hand, _ball(CAT_HAND_R * 1.15), steel, Vector3.ZERO)
		_part(hand, _rod(CAT_HAND_R * 1.05, 0.04, 24), gold, Vector3(0.0, -CAT_HAND_R * 0.75, 0.0))
	# รองเท้าเกราะครอบเท้า ขอบทอง
	for leg in _legs:
		var foot: Node3D = leg[3]
		_part(foot, foot_mesh, steel, Vector3(0.0, -0.06, 0.05), Vector3(1.12, 0.7, 1.4))
		_part(foot, _rod(0.13, 0.03, 24), gold, Vector3(0.0, 0.02, 0.0), Vector3(1.0, 1.0, 1.2))

## FLAME KNIGHT ดาบเหลี่ยมอัพเกรด ใบหนาขอบเรืองส้ม ปลายเป็นขั้นบันได โกร่งเหลี่ยมมีอัญมณีไฟ
func _build_flame_sword() -> void:
	_cat_blade(Color(0.98, 0.5, 0.18), Color(1.0, 0.9, 0.4), KNIGHT_TRIM, WOOD_DARK, 1.0, 0.13, true, 1.8)

## FLAME KNIGHT ลูกบอลไฟลอยค้างเหนือมือข้างที่ไม่ถือดาบ
func _build_fire_orb() -> void:
	var orb := Node3D.new()
	var home := Vector3(0.0, CAT_HAND_R + 0.15, 0.0)
	orb.position = home
	_off_hand.add_child(orb)
	_part(orb, _ball(0.07), _glow(Color(1.0, 0.95, 0.75), 2.4), Vector3.ZERO)
	_part(orb, _ball(0.1), _flame_mat(Color(1.0, 0.6, 0.15, 0.55)), Vector3.ZERO)
	_part(orb, _ball(0.135), _flame_mat(Color(1.0, 0.3, 0.05, 0.3)), Vector3.ZERO)
	for i in 3:
		var a := TAU * float(i) / 3.0
		_part(orb, _box(Vector3(0.025, 0.025, 0.025)), _glow(Color(1.0, 0.7, 0.2), 2.0), Vector3(cos(a) * 0.17, 0.0, sin(a) * 0.17))
	_orbs.append([orb, home])

## GUARDIAN KNIGHT ดาบศักดิ์สิทธิ์ ใบกว้างสีเงิน เส้นกลางน้ำเงิน โกร่งทองแบบปีก อัญมณีฟ้า
func _build_guardian_sword() -> void:
	_cat_blade(Color(0.88, 0.9, 0.95), SHIELD_LINE, SHIELD_GOLD, SHIELD_GRIP, 0.95, 0.11, true, 0.0)

## GUARDIAN KNIGHT โล่ใหญ่บนมืออีกข้าง ขอบทองมีหมุด พื้นน้ำเงิน กากบาททอง อัญมณีกลาง
func _build_guardian_shield() -> void:
	_hand_shield = _group(_off_hand)
	var r := BACK_SHIELD_R * 1.35
	var field := _mat(Color(0.2, 0.36, 0.75), 0.4, 0.5)
	var gold := _mat(SHIELD_GOLD, 0.3, 0.85)
	# หน้าโล่อยู่ด้าน +y ซึ่งหันเข้าหากล้อง
	_part(_hand_shield, _rod(r + 0.04, 0.05, 40), gold, Vector3(0.0, 0.0, 0.0))
	_part(_hand_shield, _rod(r, 0.06, 40), field, Vector3(0.0, 0.012, 0.0))
	# รอยอุ้งเท้าทองกลางโล่ อุ้งกลางเป็นอัญมณีเรือง
	_part(_hand_shield, _ball(r * 0.34), gold, Vector3(0.0, 0.045, -r * 0.18), Vector3(1.0, 0.25, 0.85))
	_part(_hand_shield, _ball(r * 0.2), _glow(Color(0.85, 0.95, 1.0), 1.6), Vector3(0.0, 0.06, -r * 0.18), Vector3(1.0, 0.3, 0.85))
	for i in 4:
		var a := PI * 0.5 + (float(i) - 1.5) * 0.55
		_part(_hand_shield, _ball(r * 0.13), gold, Vector3(cos(a) * r * 0.52, 0.045, sin(a) * r * 0.52), Vector3(1.0, 0.25, 1.0))
	for i in 12:
		var a := TAU * float(i) / 12.0
		_part(_hand_shield, _ball(0.022), gold, Vector3(cos(a) * (r - 0.02), 0.045, sin(a) * (r - 0.02)))

## CRIMSON KNIGHT ดาบดำน่ากลัว ฟันเลื่อยข้างใบ อักษรแดงเรืองกลางใบ โกร่งเขาแหลม ท้ายด้ามเป็นตาแดง
## ดาบ CRIMSON แบบแมว ใบป้อมปลายมนสีแดงอมชมพูเข้ม แกนชมพูเรือง กระบังเป็นอุ้งเท้า มีรอยอุ้งเท้าบนใบ ท้ายด้ามเป็นกระดิ่งทอง
func _build_crimson_sword() -> void:
	_blade = _group(_sword)
	var rose := _mat(Color(0.55, 0.12, 0.28), 0.35, 0.7)
	var pink := _glow(Color(1.0, 0.45, 0.65), 1.6)
	var pad := _mat(Color(1.0, 0.62, 0.72), 0.5, 0.4)
	var gold := _mat(Color(1.0, 0.8, 0.3), 0.25, 0.9)
	_part(_blade, _rod(0.032, 0.3, 14), _mat(DARK_GLOVE, 0.7, 0.2), Vector3(0.0, -0.02, 0.0))
	for y in [-0.08, 0.02, 0.1]:
		_part(_blade, _rod(0.038, 0.025, 14), rose, Vector3(0.0, y, 0.0))
	# กระดิ่งท้ายด้าม
	_part(_blade, _ball(0.07), gold, Vector3(0.0, -0.22, 0.0))
	_part(_blade, _rod(0.072, 0.012, 16), _mat(Color(0.8, 0.55, 0.15), 0.3, 0.8), Vector3(0.0, -0.22, 0.0))
	_part(_blade, _box(Vector3(0.012, 0.04, 0.02)), _mat(Color(0.3, 0.2, 0.1), 0.6, 0.2), Vector3(0.0, -0.26, 0.06))
	# กระบังอุ้งเท้า
	_part(_blade, _ball(0.12), rose, Vector3(0.0, 0.16, 0.0), Vector3(1.4, 0.6, 0.55))
	for i in 3:
		var x := (float(i) - 1.0) * 0.085
		_part(_blade, _ball(0.04), pad, Vector3(x, 0.24 + (0.02 if i == 1 else 0.0), 0.03), Vector3(1.0, 1.0, 0.7))
	_part(_blade, _ball(0.06), pad, Vector3(0.0, 0.15, 0.05), Vector3(1.2, 0.8, 0.5))
	# ใบป้อมปลายมน
	_part(_blade, _pill(0.105, 0.95), rose, Vector3(0.0, 0.8, 0.0), Vector3(1.0, 1.0, 0.32))
	_part(_blade, _pill(0.035, 0.85), pink, Vector3(0.0, 0.8, 0.0), Vector3(1.0, 1.0, 0.38))
	# รอยอุ้งเท้าบนใบ
	for face in [-1.0, 1.0]:
		var at := Vector3(0.0, 0.48, face * 0.035)
		_part(_blade, _ball(0.03), pad, at, Vector3(1.0, 0.85, 0.3))
		for t in 3:
			_part(_blade, _ball(0.012), pad, at + Vector3((float(t) - 1.0) * 0.026, 0.035 + (0.006 if t == 1 else 0.0), 0.0), Vector3(1.0, 1.0, 0.3))

## ปลอกคอมีกระดิ่งทองที่คอของแมวทุกตัว CAT BOYS ปลอกคอแดง SUSI ปลอกคอม่วง
func _build_collar(top: float) -> void:
	var k := 0.66
	var r: float = float(_cat_r[int(k * 40.0)])
	var y := CAT_FLOAT - HIP_Y + top * k
	var band := _mat(Color(0.75, 0.38, 0.9) if style.begins_with("cat_staff") else Color(0.88, 0.2, 0.25), 0.5, 0.4)
	var ring := TorusMesh.new()
	ring.inner_radius = r - 0.02
	ring.outer_radius = r + 0.06
	ring.rings = 40
	ring.ring_segments = 10
	_part(_torso, ring, band, Vector3(0.0, y, 0.0), Vector3(1.0, 1.1, CAT_DEPTH))
	var front := Vector3(0.0, y - 0.07, r * CAT_DEPTH + 0.05)
	_part(_torso, _ball(0.085), _mat(Color(1.0, 0.82, 0.3), 0.2, 0.9), front)
	_part(_torso, _rod(0.088, 0.014, 16), _mat(Color(0.8, 0.55, 0.15), 0.3, 0.8), front + Vector3(0.0, 0.015, 0.0))
	_part(_torso, _ball(0.016), _mat(Color(0.3, 0.2, 0.1), 0.6, 0.2), front + Vector3(0.0, -0.045, 0.07))

func _build_sword(ink: Material) -> void:
	_part(_sword, _ball(HAND_R), ink, Vector3.ZERO)
	_cat_blade(WOOD, Color(0.85, 0.65, 0.4), WOOD_DARK, WOOD_DARK, 0.85, 0.1)

## ---------- คฑาของสาย CAT SUSI ----------
## หัวคฑาแบบแบนหันหน้าเข้ากล้องเสมอ ส่วนที่ขยับเก็บใน _staff_fx แล้วขยับใน _tick_staff
const STAFF_HEAD_Y := 1.3
const STAFF_WHITE := Color(0.96, 0.96, 0.98)
const STAFF_BLACK := Color(0.1, 0.08, 0.12)
const STAFF_GOLD := Color(1.0, 0.8, 0.3)
const STAFF_PINK := Color(1.0, 0.5, 0.78)
const STAFF_YELLOW := Color(1.0, 0.88, 0.25)
const STAFF_VIOLET := Color(0.55, 0.25, 0.9)
const STAFF_SIDE_AIM := Vector3(0.12, 1.0, 0.25)   # ถือคฑาตั้งข้างตัว หัวคฑาอยู่บน

var _staff_fx: Array = []         # [โหนด ชนิด ค่า]
var _staff_last := Vector3.ZERO   # ตำแหน่งหัวคฑาเฟรมก่อน ใช้ให้น้ำยากระฉอก
var _slosh := 0.0
var _slosh_v := 0.0

## รูปดาวห้าแฉกแบน
func _star_poly(r: float, inner := 0.45) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 10:
		var a := PI * 0.5 + TAU * float(i) / 10.0
		var k := 1.0 if i % 2 == 0 else inner
		pts.append(Vector2(cos(a), sin(a)) * r * k)
	return pts

## รูปหัวใจแบน ปลายแหลมชี้ลง
func _heart_poly(r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 40:
		var t := TAU * float(i) / 40.0
		var x := 16.0 * pow(sin(t), 3.0)
		var y := 13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t)
		pts.append(Vector2(x, y) * r / 16.0)
	return pts

## ปีกเล็ก ขนสามชั้น ชี้ออกทาง +x
func _wing_poly(r: float) -> PackedVector2Array:
	return PackedVector2Array([Vector2(0.0, 0.1) * r, Vector2(0.45, 0.55) * r, Vector2(1.0, 0.75) * r, Vector2(0.85, 0.35) * r, Vector2(1.0, 0.25) * r, Vector2(0.75, -0.05) * r, Vector2(0.85, -0.2) * r, Vector2(0.4, -0.25) * r, Vector2(0.0, -0.15) * r])

## รูปแบนหนาเท่า depth หน้าอยู่ทาง +z
func _flat(poly: PackedVector2Array, depth: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var tris := Geometry2D.triangulate_polygon(poly)
	var h := depth * 0.5
	for i in range(0, tris.size(), 3):
		var a := poly[tris[i]]
		var b := poly[tris[i + 1]]
		var c := poly[tris[i + 2]]
		st.add_vertex(Vector3(a.x, a.y, h))
		st.add_vertex(Vector3(c.x, c.y, h))
		st.add_vertex(Vector3(b.x, b.y, h))
		st.add_vertex(Vector3(a.x, a.y, -h))
		st.add_vertex(Vector3(b.x, b.y, -h))
		st.add_vertex(Vector3(c.x, c.y, -h))
	var clockwise := Geometry2D.is_polygon_clockwise(poly)
	for i in poly.size():
		var p := poly[i]
		var q := poly[(i + 1) % poly.size()]
		var v := [Vector3(p.x, p.y, h), Vector3(q.x, q.y, h), Vector3(q.x, q.y, -h), Vector3(p.x, p.y, -h)]
		if clockwise:
			v.reverse()
		st.add_vertex(v[0])
		st.add_vertex(v[2])
		st.add_vertex(v[1])
		st.add_vertex(v[0])
		st.add_vertex(v[3])
		st.add_vertex(v[2])
	st.generate_normals()
	return st.commit()

## แท่งเชื่อมสองจุด ใช้ทำเส้นโครง
func _edge(parent: Node3D, a: Vector3, b: Vector3, r: float, material: Material) -> MeshInstance3D:
	var node := _part(parent, _rod(r, a.distance_to(b), 8), material, (a + b) * 0.5)
	var up := (b - a).normalized()
	var side := up.cross(Vector3(0.0, 0.0, 1.0))
	if side.length() < 0.01:
		side = up.cross(Vector3(1.0, 0.0, 0.0))
	side = side.normalized()
	node.basis = Basis(side, up, side.cross(up))
	return node

## วงแหวนบาง ตั้งฉากกับแกน z (หันหน้าเข้ากล้อง)
func _hoop(parent: Node3D, r: float, thick: float, material: Material, at: Vector3) -> MeshInstance3D:
	var m := TorusMesh.new()
	m.inner_radius = r - thick
	m.outer_radius = r + thick
	m.rings = 40
	m.ring_segments = 10
	return _part(parent, m, material, at, Vector3.ONE, Vector3(90.0, 0.0, 0.0))

## กลุ่มหัวคฑาที่หันเข้ากล้องตลอด
func _face_group() -> Node3D:
	var g := _group(_blade)
	g.position = Vector3(0.0, STAFF_HEAD_Y, 0.0)
	_staff_fx.append([g, "face", 0.0])
	return g

## ด้ามคฑา ปุ่มท้าย และปลอกสองวง
func _shaft(color: Color, ring: Color, top := 1.12) -> void:
	var body := _mat(color, 0.5, 0.4)
	var band := _mat(ring, 0.35, 0.6)
	_part(_blade, _rod(0.04, top + 0.26, 14), body, Vector3(0.0, (top - 0.26) * 0.5, 0.0))
	_part(_blade, _ball(0.055), band, Vector3(0.0, -0.26, 0.0))
	for y in [0.06, 0.13, top - 0.04]:
		_part(_blade, _rod(0.052, 0.035, 14), band, Vector3(0.0, y, 0.0))

## หูแมวคู่บนหัวคฑา ด้านในชมพู วางใน parent ที่ at
func _staff_ears(parent: Node3D, at: Vector3, size: float, gap: float, color: Color) -> void:
	for side in [-1.0, 1.0]:
		var ear := PrismMesh.new()
		ear.size = Vector3(size, size * 1.1, size * 0.4)
		_part(parent, ear, _mat(color, 0.4, 0.5), at + Vector3(side * gap, 0.0, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -side * 14.0))
		var inner := PrismMesh.new()
		inner.size = Vector3(size * 0.5, size * 0.6, size * 0.44)
		_part(parent, inner, _mat(Color(1.0, 0.68, 0.78), 0.5, 0.3), at + Vector3(side * gap, -size * 0.12, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -side * 14.0))

## กระดิ่งทองบนด้ามใต้หัวคฑา
func _staff_bell(y: float) -> void:
	_part(_blade, _ball(0.05), _mat(Color(1.0, 0.82, 0.3), 0.2, 0.9), Vector3(0.0, y, 0.06))
	_part(_blade, _rod(0.052, 0.01, 16), _mat(Color(0.8, 0.55, 0.15), 0.3, 0.8), Vector3(0.0, y + 0.01, 0.06))
	_part(_blade, _ball(0.01), _mat(Color(0.3, 0.2, 0.1), 0.6, 0.2), Vector3(0.0, y - 0.025, 0.105))

## รอยอุ้งเท้าเล็กแบนหันหน้าเข้ากล้อง
func _staff_paw(parent: Node3D, at: Vector3, r: float, color: Color) -> void:
	var m := _glow(color, 1.2)
	_part(parent, _ball(r), m, at, Vector3(1.0, 0.85, 0.4))
	for t in 3:
		_part(parent, _ball(r * 0.42), m, at + Vector3((float(t) - 1.0) * r * 0.9, r * (1.05 + (0.15 if t == 1 else 0.0)), 0.0), Vector3(1.0, 1.0, 0.4))

func _build_staff() -> void:
	_blade = _group(_sword)
	match style:
		"cat_staff_arch":
			_staff_arch()
		"cat_staff_element":
			_staff_element()
		"cat_staff_battle":
			_staff_battle()
		"cat_staff_dimension":
			_staff_dimension()
		"cat_staff_dark":
			_staff_dark()
		"cat_staff_eclipse":
			_staff_eclipse()
		"cat_staff_alch":
			_staff_alch()
		"cat_staff_trans":
			_staff_trans()
		_:
			_staff_wood()

## CAT AZURE (ผู้หญิง) ถุงมือกรงเล็บแมวน่ารักข้างเดียว อีกมือมือเปล่า มีเขาเล็กๆ บนหัว
func _build_azure() -> void:
	_blade = _group(_sword)
	var top0: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var head_y := CAT_FLOAT - HIP_Y + top0 * 0.86
	_azure_tail(top0)
	if style == "cat_azure_demon_a" or style == "cat_azure_demon_b":
		_build_azure_demon(head_y, top0)
		return
	_azure_glove()
	# เขาเล็กๆ บนหัว
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var horn_m := _mat(Color(0.2, 0.25, 0.55), 0.35, 0.6)
	for side in [-1.0, 1.0]:
		var h := _part(_torso, _cone(0.07, 0.24), horn_m, Vector3(side * 0.14, CAT_FLOAT - HIP_Y + top * 0.99, 0.18))
		h.rotation_degrees = Vector3(25.0, 0.0, -side * 22.0)
		_part(_torso, _ball(0.035), _mat(Color(0.75, 0.88, 1.0), 0.3, 0.6), Vector3(side * 0.17, CAT_FLOAT - HIP_Y + top * 0.99 + 0.11, 0.22))

## ถุงมือกรงเล็บแมวน่ารักข้างเดียว (มือหลัก) อ้วนกลม สีฟ้าพาสเทล เล็บมนสีขาว หลังมือมีลายอุ้งเท้าชมพู
## แกน y ของมือชี้ทางเล็บ แกน z หันเข้ากล้องตอนยกมือ จึงเห็นหลังมือ
## หมุนถุงมือรอบแกนนิ้ว ตามทิศที่หัน ให้ฝ่ามือหันเข้าหาตัวเสมอ (เอียงเข้ากล้องนิดหน่อยให้เห็นอุ้งเท้าชมพูบางส่วน)
const AZURE_GLOVE_YAW := 70.0
const AZURE_GLOVE_OUT := Vector3(0.14, 0.08, 0.16)
var _az_glove: Node3D
var _az_glove_off: Node3D           # ถุงมือกรงเล็บมือรอง โผล่ตอนโจมตี
var _az_off_paw: Node3D

## หางปีศาจแมวน้อย เส้นเรียวสีน้ำเงินเข้ม โค้งเป็นตัว S ขึ้นไปด้านหลัง ปลายเป็นหัวใจ
func _azure_tail(top: float) -> void:
	var tail := _group(_torso)
	tail.position = Vector3(0.0, CAT_FLOAT - HIP_Y + top * 0.12, -0.55)
	var m := _mat(_fur(), 0.9, 0.2)
	var band := _mat(Color(0.12, 0.2, 0.62), 0.5, 0.4)
	var n := 40
	var last := Vector3.ZERO
	for i in n:
		var k := float(i) / float(n - 1)
		# ยื่นออกไปด้านหลังก่อน แล้วโค้งขึ้นเป็นตัว S ให้เห็นพ้นตัว
		var p := Vector3(sin(k * PI * 1.6) * 0.06, k * 0.7 - sin(k * PI) * 0.05, -0.1 - sin(k * PI * 0.5) * 0.55)
		# สีขนเจ้าตัว แซมลายน้ำเงินเข้มเป็นช่วงๆ
		_part(tail, _ball(0.05 * (1.0 - k * 0.3)), band if (i / 4) % 2 == 1 else m, p)
		last = p
	# ปลายหางรูปหัวใจ
	var heart := PackedVector2Array()
	for i in 24:
		var t := TAU * float(i) / 24.0
		heart.append(Vector2(16.0 * pow(sin(t), 3.0), 13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t)) * 0.0085)
	var tip := _part(tail, _flat(heart, 0.04), band, last + Vector3(0.0, 0.1, -0.02))
	tip.rotation_degrees = Vector3(0.0, 90.0, 0.0)
	_staff_fx.append([tail, "wag", 0.0])

func _azure_glove() -> void:
	var glove := _mat(Color(0.66, 0.84, 1.0), 0.75, 0.25)
	var cuff := _mat(Color(0.97, 0.98, 1.0), 1.0, 0.1)
	var pink := _mat(Color(1.0, 0.68, 0.8), 0.6, 0.3)
	var claw := _mat(Color(0.98, 0.99, 1.0), 0.3, 0.6)
	var claw_glow := _glow(Color(0.65, 0.9, 1.0), 0.5)
	# มือแมวเดิมซ่อนไว้ ให้มืออยู่ในถุงมือ ไม่โผล่ออกมานอกกรงเล็บ
	for c in _sword.get_children():
		if c is MeshInstance3D and (c as MeshInstance3D).mesh is SphereMesh and is_equal_approx(((c as MeshInstance3D).mesh as SphereMesh).radius, CAT_HAND_R):
			(c as MeshInstance3D).visible = false
	var g := _group(_sword)
	g.scale = Vector3.ONE * 1.25
	# หมุนรอบแกนนิ้ว ให้ฝ่ามือ (อุ้งเท้าชมพู) หันเข้าหาตัว หลังมือหันไปทางศัตรู (ปรับตามทิศทุกเฟรมใน _process)
	_az_glove = g
	# ตัวถุงมือกลมอ้วน
	_part(g, _ball(0.24), glove, Vector3(0.0, 0.05, 0.0), Vector3(1.05, 1.0, 0.82))
	# ขอบขนฟูที่ข้อมือ
	for n in 10:
		var a := TAU * float(n) / 10.0
		_part(g, _ball(0.065), cuff, Vector3(cos(a) * 0.15, -0.17, sin(a) * 0.12))
	# อุ้งเท้าชมพูอยู่ฝั่งฝ่ามือ (หันออกจากกล้อง) หลังมือเรียบมีหัวใจเล็กๆ สีฟ้าเข้ม
	_part(g, _ball(0.075), pink, Vector3(0.0, 0.0, -0.19), Vector3(1.25, 1.0, 0.35))
	for n in 3:
		_part(g, _ball(0.036), pink, Vector3((float(n) - 1.0) * 0.07, 0.1 + (0.02 if n == 1 else 0.0), -0.18), Vector3(1.0, 1.0, 0.4))
	# หลังมือเรียบ มีข้อนิ้วนูนกลมๆ เรียงตามแนวนิ้ว ไม่มีลายที่ดูเหมือนอุ้งเท้า
	for n in 4:
		_part(g, _ball(0.05), glove, Vector3((float(n) - 1.5) * 0.1, 0.15 - absf(float(n) - 1.5) * 0.025, 0.12), Vector3(1.0, 0.8, 0.7))
	# นิ้วกลมสี่นิ้ว แต่ละนิ้วมีเล็บมนโค้งขึ้น
	for n in 4:
		var x := (float(n) - 1.5) * 0.105
		_part(g, _ball(0.07), glove, Vector3(x, 0.24 - absf(float(n) - 1.5) * 0.03, 0.02))
		var c := _group(g)
		c.position = Vector3(x, 0.29 - absf(float(n) - 1.5) * 0.03, 0.04)
		# เล็บงอโค้งไปทางฝ่ามือ (ออกจากกล้อง) เหมือนอุ้งเท้าแมวกำนิดๆ
		c.rotation_degrees = Vector3(-42.0, 0.0, -(float(n) - 1.5) * 10.0)
		_part(c, _pill(0.03, 0.06), claw, Vector3(0.0, 0.06, 0.0))
		_part(c, _ball(0.022), claw_glow, Vector3(0.0, 0.11, 0.01))
	# มือรองมีกรงเล็บเหมือนกัน โผล่เฉพาะตอนโจมตี
	_az_glove_off = g.duplicate()
	_off_hand.add_child(_az_glove_off)
	_az_glove_off.visible = false
	for oc in _off_hand.get_children():
		if oc is MeshInstance3D and (oc as MeshInstance3D).mesh is SphereMesh and is_equal_approx(((oc as MeshInstance3D).mesh as SphereMesh).radius, CAT_HAND_R):
			_az_off_paw = oc

## NPC ในเมือง ไม่ถืออาวุธ มีหมวกหรือของประจำตัวตาม npc_look["hat"]
func _build_npc() -> void:
	_blade = _group(_sword)
	hide_blade = true
	var top0: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var crown_y := CAT_FLOAT - HIP_Y + top0 * 0.98
	var neck_y := CAT_FLOAT - HIP_Y + top0 * 0.62
	var hat := str(npc_look.get("hat", ""))
	var col: Color = npc_look.get("hat_color", Color(0.9, 0.45, 0.4))
	var m := _mat(col, 0.7, 0.3)
	var gold := _mat(Color(1.0, 0.82, 0.3), 0.3, 0.8)
	match hat:
		"helm":
			var steel := _mat(Color(0.78, 0.82, 0.88), 0.3, 0.8)
			_part(_torso, _ball(0.34), steel, Vector3(0.0, crown_y - 0.04, 0.0), Vector3(1.0, 0.55, 1.0))
			_part(_torso, _ball(0.08), _mat(Color(0.9, 0.3, 0.3), 0.8, 0.2), Vector3(0.0, crown_y + 0.18, -0.05))
		"beret":
			_part(_torso, _ball(0.3), m, Vector3(0.06, crown_y + 0.02, 0.0), Vector3(1.1, 0.3, 1.0))
			_part(_torso, _ball(0.04), m, Vector3(0.06, crown_y + 0.1, 0.0))
		"straw":
			var straw := _mat(Color(0.95, 0.85, 0.55), 0.9, 0.1)
			_part(_torso, _rod(0.5, 0.03, 24), straw, Vector3(0.0, crown_y - 0.02, 0.0))
			_part(_torso, _ball(0.22), straw, Vector3(0.0, crown_y + 0.04, 0.0), Vector3(1.0, 0.6, 1.0))
			_part(_torso, _rod(0.225, 0.04, 24), m, Vector3(0.0, crown_y + 0.02, 0.0))
		"crown":
			_part(_torso, _rod(0.22, 0.1, 20), gold, Vector3(0.0, crown_y + 0.02, 0.0))
			for i in 5:
				var a := TAU * float(i) / 5.0
				_part(_torso, _ball(0.045), gold, Vector3(cos(a) * 0.21, crown_y + 0.1, sin(a) * 0.21))
		"wizard":
			_part(_torso, _cone(0.26, 0.5), m, Vector3(0.0, crown_y + 0.2, -0.02))
			_part(_torso, _ball(0.05), gold, Vector3(0.0, crown_y + 0.46, -0.02))
		"chef":
			var white := _mat(Color(0.98, 0.98, 0.98), 0.9, 0.1)
			_part(_torso, _rod(0.18, 0.14, 20), white, Vector3(0.0, crown_y + 0.04, 0.0))
			_part(_torso, _ball(0.22), white, Vector3(0.0, crown_y + 0.18, 0.0), Vector3(1.0, 0.7, 1.0))
		"bow":
			for side in [-1.0, 1.0]:
				_part(_torso, _ball(0.08), m, Vector3(0.22 + side * 0.07, crown_y - 0.02, 0.1), Vector3(1.0, 0.7, 0.5))
			_part(_torso, _ball(0.04), m, Vector3(0.22, crown_y - 0.02, 0.12))
		"hood":
			_part(_torso, _ball(0.4), m, Vector3(0.0, crown_y - 0.12, -0.08), Vector3(1.0, 0.75, 1.0))
		"scarf":
			for i in 14:
				var a := TAU * float(i) / 14.0
				_part(_torso, _ball(0.07), m, Vector3(cos(a) * 0.36, neck_y, sin(a) * 0.36))
			_part(_torso, _ball(0.07), m, Vector3(0.22, neck_y - 0.14, 0.3), Vector3(0.8, 1.6, 0.6))
		"goggles":
			var lens := _mat(Color(0.6, 0.85, 1.0), 0.2, 0.9)
			_part(_torso, _rod(0.36, 0.05, 24), m, Vector3(0.0, crown_y - 0.12, 0.0))
			for side in [-1.0, 1.0]:
				_part(_torso, _ball(0.08), lens, Vector3(side * 0.1, crown_y - 0.1, 0.33), Vector3(1.0, 1.0, 0.5))
		"flower":
			for i in 5:
				var a := TAU * float(i) / 5.0
				_part(_torso, _ball(0.05), m, Vector3(0.2 + cos(a) * 0.06, crown_y - 0.02 + sin(a) * 0.06, 0.12))
			_part(_torso, _ball(0.035), gold, Vector3(0.2, crown_y - 0.02, 0.15))

## AZURE ร่างปีศาจเต็มตัว ไม่ใส่ถุงมือ
## demon_a (SOMNAMBULIST): เขาใหญ่สองข้างลายขาวน้ำเงินปลายแหลม ดาวสี่แฉกสีขาวกลางหลัง
## demon_b (NEON BOLT): เขาย้อยมาด้านหน้า ตัวน้ำเงินเข้ม ปีกน้ำเงินขาวใหญ่ที่ก้นกบ
func _build_azure_demon(head_y: float, top: float) -> void:
	var white := _mat(Color(0.96, 0.98, 1.0), 0.35, 0.5)
	var blue := _mat(Color(0.2, 0.32, 0.75), 0.35, 0.5)
	for side in [-1.0, 1.0]:
		var horn := _group(_torso)
		horn.position = Vector3(side * 0.16, head_y + top * 0.12, 0.12)
		for i in 7:
			var k := float(i) / 6.0
			var p: Vector3
			if style == "cat_azure_demon_a":
				# เขาใหญ่โค้งขึ้นออกข้าง ลายสลับขาวน้ำเงิน
				p = Vector3(side * (k * 0.12 - 0.06), 0.06 + k * 0.46 - k * k * 0.08, -k * 0.05)
			else:
				# เขาย้อยมาข้างหน้า
				p = Vector3(side * (k * 0.08 - 0.07), 0.08 + sin(k * PI * 0.6) * 0.16 - k * k * 0.2, k * 0.32)
			var r := 0.085 * (1.0 - k * 0.8)
			_part(horn, _ball(r), white if i % 2 == 0 else blue, p)
		var tip := _part(horn, _cone(0.03, 0.12), white, Vector3(side * 0.07, 0.48, -0.05) if style == "cat_azure_demon_a" else Vector3(side * 0.02, -0.14, 0.4))
		tip.rotation_degrees = Vector3(0.0, 0.0, -side * 20.0) if style == "cat_azure_demon_a" else Vector3(120.0, 0.0, 0.0)
	if style == "cat_azure_demon_a":
		# ดาวสี่แฉกสีขาวกลางหลัง เส้นโค้งนิดๆ ไม่มีเส้นตัด
		var star := PackedVector2Array()
		for i in 16:
			var ang := float(i) * TAU / 16.0
			var rr := 0.26 if i % 4 == 0 else (0.08 if i % 2 == 0 else 0.1)
			star.append(Vector2(cos(ang + PI * 0.5) * rr, sin(ang + PI * 0.5) * rr))
		var sn := _part(_torso, _flat(star, 0.02), _glow(Color(1.0, 1.0, 1.0), 0.6), Vector3(0.0, CAT_FLOAT - HIP_Y + top * 0.5, -0.66), Vector3.ONE * 1.4)
		sn.rotation_degrees = Vector3(0.0, 180.0, 0.0)
	else:
		# ปีกน้ำเงินขาวใหญ่ที่ก้นกบ
		for side in [-1.0, 1.0]:
			var wing := _group(_torso)
			wing.position = Vector3(side * 0.18, CAT_FLOAT - HIP_Y + top * 0.25, -0.46)
			wing.rotation_degrees = Vector3(-10.0, side * 35.0, 0.0)
			for f in 4:
				var poly := PackedVector2Array([Vector2(0.0, 0.0), Vector2(side * (0.25 + float(f) * 0.12), 0.18 + float(f) * 0.12), Vector2(side * (0.42 + float(f) * 0.14), 0.05 + float(f) * 0.1), Vector2(side * 0.12, -0.02)])
				if side < 0.0:
					poly.reverse()
				_part(wing, _flat(poly, 0.015), white if f % 2 == 0 else _mat(Color(0.45, 0.65, 1.0), 0.4, 0.4), Vector3(0.0, float(f) * 0.04, -float(f) * 0.01))

## CAT LAPIS (ผู้ชาย) ดาบปลายปืน ใบดาบเหล็ก ลำกล้องปืนแนบสันดาบ ลูกโม่ ไกปืน หูลู่ไปด้านหลัง
func _build_lapis() -> void:
	_part(_sword, _ball(CAT_HAND_R), _mat(_fur(), 1.0, 0.2), Vector3.ZERO)
	if style == "cat_lapis_demon":
		var top1: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
		var hy := CAT_FLOAT - HIP_Y + top1 * 0.86
		# เขาข้างเดียวงอกแล้วย้อยลง สีดำปลายฟ้า
		var horn := _group(_torso)
		horn.position = Vector3(0.18, hy + top1 * 0.1, 0.1)
		var horn_m := _mat(Color(0.08, 0.08, 0.14), 0.35, 0.6)
		for i in 6:
			var k := float(i) / 5.0
			_part(horn, _ball(0.11 * (1.0 - k * 0.7)), horn_m if i < 5 else _glow(Color(0.5, 0.8, 1.0), 0.8), Vector3(0.08 + k * 0.36, 0.16 + sin(k * PI) * 0.2 - k * k * 0.32, 0.0))
		# ที่ปิดปากสีดำ
		_part(_torso, _ball(0.19), _mat(Color(0.06, 0.06, 0.09), 0.4, 0.4), Vector3(0.0, hy - top1 * 0.1, 0.5), Vector3(1.5, 0.75, 0.5))
	_lapis_gun()

## ปืนของเล่นน่ารัก ตัวกลมมน ลำกล้องกลม หูแมวท้ายปืน กระดิ่งทอง ลายอุ้งเท้า ดาบปลายปืนสั้นๆ ปลายมน
## แกน y ชี้ทางปากกระบอก มือจับด้ามที่จุดกำเนิด
func _lapis_gun() -> void:
	_blade = _group(_sword)
	var gun := _group(_blade)
	gun.scale = Vector3.ONE * 1.5
	var demon := style == "cat_lapis_demon"
	var body_c := Color(0.2, 0.22, 0.34) if demon else Color(0.93, 0.96, 1.0)
	var body := _mat(body_c, 0.45, 0.4)
	var blue := _mat(Color(0.36, 0.55, 0.95), 0.35, 0.6)
	var pink := _mat(Color(1.0, 0.68, 0.8), 0.6, 0.3)
	var gold := _mat(Color(1.0, 0.82, 0.3), 0.25, 0.9)
	var steel := _mat(Color(0.86, 0.92, 1.0), 0.25, 0.8)
	# ด้ามจับ
	_part(gun, _pill(0.05, 0.1), blue, Vector3(0.0, 0.0, 0.0), Vector3(1.0, 1.0, 0.9), Vector3(70.0, 0.0, 0.0))
	# ตัวปืนกลมอ้วน
	_part(gun, _pill(0.1, 0.22), body, Vector3(0.0, 0.17, 0.09))
	# หูแมวคู่ท้ายปืน
	for side in [-1.0, 1.0]:
		var ear := _part(gun, _cone(0.045, 0.09), body, Vector3(side * 0.05, 0.02, 0.17))
		ear.rotation_degrees = Vector3(-60.0, 0.0, side * 15.0)
		var inner := _part(gun, _cone(0.025, 0.06), pink, Vector3(side * 0.05, 0.02, 0.185))
		inner.rotation_degrees = Vector3(-60.0, 0.0, side * 15.0)
	# ลายอุ้งเท้าข้างปืน
	_part(gun, _ball(0.04), pink, Vector3(0.0, 0.16, 0.19), Vector3(1.2, 1.0, 0.35))
	for n in 3:
		_part(gun, _ball(0.02), pink, Vector3((float(n) - 1.0) * 0.038, 0.215 + (0.01 if n == 1 else 0.0), 0.185), Vector3(1.0, 1.0, 0.4))
	# กระดิ่งทอง
	_part(gun, _ball(0.04), gold, Vector3(0.0, 0.06, -0.02))
	# ลำกล้องกลมสั้น ปากกระบอกเรืองฟ้า
	_part(gun, _rod(0.055, 0.16, 16), blue, Vector3(0.0, 0.37, 0.09))
	_part(gun, _rod(0.068, 0.04, 16), _glow(Color(0.55, 0.85, 1.0), 0.7), Vector3(0.0, 0.46, 0.09))
	# ดาบปลายปืนสั้น ใบมนแบน ติดใต้ลำกล้อง
	_part(gun, _rod(0.03, 0.05, 10), steel, Vector3(0.0, 0.45, 0.0))
	_part(gun, _pill(0.045, 0.16), steel, Vector3(0.0, 0.58, 0.0), Vector3(1.0, 1.0, 0.3))
	_part(gun, _pill(0.018, 0.12), _glow(Color(0.55, 0.85, 1.0), 0.6), Vector3(0.0, 0.58, 0.012), Vector3(1.0, 1.0, 0.4))

## ร่างวิญญาณของ CAT CITRUS ใน HYPER: เสือ (หาง เล็บ) จิ้งจอก (หางอ้วนฟู) เต่า (กระดองหลัง หางงู)
func _build_spirit(body: MeshInstance3D) -> void:
	_blade = _group(_sword)
	var top: float = (CAT_PROFILE[CAT_PROFILE.size() - 1] as Vector2).x
	var base := Vector3(0.0, CAT_FLOAT - HIP_Y, 0.0)
	match style:
		"cat_spirit_tiger":
			_spirit_tail(base + Vector3(0.0, top * 0.16, -0.6), 9, 0.1, _fur(), _stripe(), false)
			# เล็บแหลมสามเล็บบนมือทั้งสองข้าง
			var claw := _mat(Color(1.0, 1.0, 0.97), 0.3, 0.7)
			for hand in [_sword, _off_hand]:
				for i in 3:
					var c := _part(hand, _cone(0.025, 0.12), claw, Vector3((float(i) - 1.0) * 0.045, 0.02, 0.09))
					c.rotation_degrees = Vector3(80.0, 0.0, 0.0)
		"cat_spirit_fox":
			# เก้าหางจิ้งจอกฟูๆ ยาว แผ่เป็นพัดขึ้นไปด้านหลังเหนือหัว เห็นจากด้านข้าง สีขาวสลับฟ้าอ่อนให้แยกหางออก
			var fur := _mat(Color(0.97, 0.97, 1.0), 1.0, 0.2)
			var fur2 := _mat(Color(0.86, 0.91, 1.0), 1.0, 0.2)
			var tip := _mat(Color(0.7, 0.85, 1.0), 1.0, 0.2)
			for t in 9:
				var fan := float(t) / 8.0
				var pivot := _group(_torso)
				pivot.position = base + Vector3(0.0, top * 0.2, -0.45)
				# ไล่จากชี้ขึ้นเกือบตรงไปจนชี้ไปข้างหลัง และกางออกซ้ายขวาสลับกันเล็กน้อย
				var side := -1.0 if t % 2 == 0 else 1.0
				pivot.rotation_degrees = Vector3(12.0 - fan * 105.0, 0.0, side * (12.0 + 22.0 * absf(fan - 0.5)))
				var tail := _group(pivot)
				var m := fur if t % 2 == 0 else fur2
				for i in 11:
					var k := float(i) / 10.0
					var r := 0.12 + sin(k * PI * 0.85) * 0.12
					_part(tail, _ball(r), tip if i >= 9 else m, Vector3(0.0, k * 1.1, -sin(k * 2.0) * 0.2))
				_staff_fx.append([tail, "wag", 0.0])
		"cat_spirit_turtle":
			# กระดองโดมเขียวติดหลัง ขอบอ่อน ลายหกเหลี่ยม
			var shell := _group(_torso)
			shell.position = base + Vector3(0.0, top * 0.42, -0.46)
			shell.scale = Vector3.ONE * 1.25
			_part(shell, _ball(0.52), _mat(Color(0.35, 0.7, 0.42), 0.6, 0.3), Vector3.ZERO, Vector3(1.0, 1.05, 0.7))
			_part(shell, _ball(0.54), _mat(Color(0.75, 0.9, 0.6), 0.6, 0.3), Vector3(0.0, 0.0, 0.06), Vector3(1.02, 1.07, 0.5))
			for i in 6:
				var a := float(i) * TAU / 6.0
				_part(shell, _ball(0.12), _mat(Color(0.28, 0.58, 0.34), 0.6, 0.3), Vector3(cos(a) * 0.27, sin(a) * 0.29, -0.33), Vector3(1.0, 1.0, 0.3))
			_part(shell, _ball(0.14), _mat(Color(0.28, 0.58, 0.34), 0.6, 0.3), Vector3(0.0, 0.0, -0.37), Vector3(1.0, 1.0, 0.3))
			# หางงูน่ารัก หัวกลมตาแป๋ว
			_spirit_tail(base + Vector3(0.0, top * 0.05, -0.75), 8, 0.07, Color(0.45, 0.78, 0.45), Color(0.95, 0.9, 0.5), true)

## หางเป็นลูกกลมต่อกันโค้งขึ้น ลายสลับ  snake คือหัวงูกลมมีตาที่ปลาย
func _spirit_tail(at: Vector3, count: int, r: float, col: Color, band: Color, snake: bool) -> void:
	var tail := _group(_torso)
	tail.position = at
	var m := _mat(col, 0.9, 0.2)
	var b := _mat(band, 0.9, 0.2)
	for i in count:
		var k := float(i) / float(count - 1)
		var p := Vector3(sin(k * 3.0) * 0.08, k * 0.55 + sin(k * PI) * 0.1, -k * 0.35)
		_part(tail, _ball(r * (1.0 - k * 0.25)), b if i % 2 == 1 else m, p)
	if snake:
		var head := Vector3(0.0, 0.66, -0.42)
		_part(tail, _ball(r * 1.6), m, head, Vector3(1.0, 0.85, 1.1))
		for side in [-1.0, 1.0]:
			_part(tail, _ball(r * 0.35), _mat(Color(0.06, 0.06, 0.07), 0.3, 0.5), head + Vector3(side * r * 0.7, r * 0.4, -r * 0.9))
			_part(tail, _ball(r * 0.3), _mat(Color(1.0, 0.6, 0.65), 0.8, 0.2), head + Vector3(side * r * 0.9, -r * 0.2, -r * 0.8), Vector3(1.0, 0.6, 0.5))
	_staff_fx.append([tail, "wag", 0.0])

## หอกยาวของ CAT CITRUS แต่ละสาย [ด้าม หัวหอก พู่ ประกาย]
const SPEAR_KINDS := {
	"cat_spear": [Color(0.6, 0.38, 0.2), Color(0.88, 0.9, 0.94), Color(1.0, 0.55, 0.2), Color(1.0, 0.85, 0.4)],
	"cat_spear_tiger": [Color(0.75, 0.45, 0.15), Color(1.0, 0.85, 0.4), Color(1.0, 0.5, 0.15), Color(1.0, 0.85, 0.3)],
	"cat_spear_prowler": [Color(0.55, 0.22, 0.08), Color(1.0, 0.8, 0.3), Color(0.95, 0.3, 0.1), Color(1.0, 0.6, 0.2)],
	"cat_spear_fang": [Color(0.22, 0.25, 0.4), Color(0.85, 0.9, 1.0), Color(0.4, 0.5, 0.9), Color(0.7, 0.85, 1.0)],
	"cat_spear_lupine": [Color(0.1, 0.12, 0.25), Color(0.9, 0.93, 1.0), Color(0.25, 0.3, 0.75), Color(0.6, 0.8, 1.0)],
	"cat_spear_vixen": [Color(0.35, 0.2, 0.5), Color(0.7, 0.95, 1.0), Color(0.6, 0.35, 0.95), Color(0.5, 0.95, 1.0)],
	"cat_spear_phantom": [Color(0.2, 0.08, 0.35), Color(0.75, 0.95, 1.0), Color(0.45, 0.85, 1.0), Color(0.75, 0.5, 1.0)],
	"cat_spear_shell": [Color(0.15, 0.2, 0.17), Color(0.6, 0.85, 0.7), Color(0.25, 0.6, 0.4), Color(0.5, 0.95, 0.7)],
	"cat_spear_genbu": [Color(0.06, 0.07, 0.07), Color(0.45, 0.85, 0.65), Color(0.1, 0.45, 0.3), Color(0.4, 1.0, 0.7)],
}

## CAT CITRUS หอกยาว ด้ามยาว หัวหอกเรียวมีเงี่ยงรูปหูแมว พู่ใต้หัวหอก กระดิ่ง ปุ่มท้ายด้าม
## ---------- CAT ASH หมัดกับเท้า ไม่ถืออาวุธ มือกลมเป็นหมัด ----------
## เครื่องประดับเล็กๆ ตามสาย: ซูโม่ผ้าคาดเอวมาวาชิ กังฟูผ้าคาดเอวยาว มวยไทยมงคลกับประเจียด แซมโบเข็มขัด
func _build_fist() -> void:
	_blade = _group(_sword)
	# ชุดของแต่ละคลาสอยู่ใน outfit_ash.gd

func _build_spear() -> void:
	_blade = _group(_sword)
	var pal: Array = SPEAR_KINDS.get(style, SPEAR_KINDS["cat_spear"])
	var shaft := _mat(pal[0], 0.55, 0.35)
	var metal := _mat(pal[1], 0.25, 0.9)
	var tassel := _mat(pal[2], 0.7, 0.2)
	var shine := _glow(pal[3], 0.8)
	_part(_blade, _rod(0.03, 2.1, 12), shaft, Vector3(0.0, 0.45, 0.0))
	_part(_blade, _ball(0.045), metal, Vector3(0.0, -0.6, 0.0))
	for y in [0.0, 0.12, 1.42]:
		_part(_blade, _rod(0.038, 0.03, 12), metal, Vector3(0.0, y, 0.0))
	var head := _group(_blade)
	head.position = Vector3(0.0, 1.5, 0.0)
	_staff_fx.append([head, "face", 0.0])
	var tip := PackedVector2Array([Vector2(-0.07, 0.0), Vector2(0.07, 0.0), Vector2(0.05, 0.22), Vector2(0.0, 0.42), Vector2(-0.05, 0.22)])
	_part(head, _flat(tip, 0.02), metal, Vector3.ZERO)
	_part(head, _flat(PackedVector2Array([Vector2(-0.015, 0.02), Vector2(0.015, 0.02), Vector2(0.0, 0.36)]), 0.026), shine, Vector3.ZERO)
	# เงี่ยงสองข้างรูปหูแมว
	for side in [-1.0, 1.0]:
		var ear := PackedVector2Array([Vector2(side * 0.05, 0.0), Vector2(side * 0.15, 0.1), Vector2(side * 0.07, 0.07)])
		if side < 0.0:
			ear.reverse()
		_part(head, _flat(ear, 0.018), metal, Vector3.ZERO)
	# พู่ใต้หัวหอก
	for i in 5:
		var a := float(i) * TAU / 5.0
		_part(_blade, _rod(0.012, 0.16, 6), tassel, Vector3(cos(a) * 0.035, 1.33, sin(a) * 0.035), Vector3.ONE, Vector3(rad_to_deg(sin(a)) * 0.25, 0.0, -rad_to_deg(cos(a)) * 0.25))
	_part(_blade, _ball(0.04), _mat(Color(1.0, 0.82, 0.3), 0.2, 0.9), Vector3(0.0, 1.27, 0.05))

## แบบคันธนูของแต่ละสายของ CAT MATCHA
## สี: คัน ปลอกมือจับ ประกาย  len ครึ่งความยาวคัน  bulge ความโก่ง  thick ความหนา  tip ปลายคัน  alpha ความโปร่ง  blade ดาบมืออีกข้าง
const BOW_KINDS := {
	"cat_bow": {"c": [Color(0.62, 0.42, 0.24), Color(0.35, 0.55, 0.3), Color(0.75, 1.0, 0.6)], "len": 0.66, "bulge": 0.2, "thick": 0.034, "tip": "ears"},
	"cat_bow_wind": {"c": [Color(0.96, 0.98, 0.95), Color(0.55, 0.88, 0.62), Color(0.7, 1.0, 0.8)], "len": 0.68, "bulge": 0.2, "thick": 0.026, "tip": "ears", "alpha": 0.72, "accent": Color(0.45, 0.85, 0.55)},
	"cat_bow_gale": {"c": [Color(0.95, 0.98, 0.95), Color(0.4, 0.8, 0.55), Color(0.7, 1.0, 0.85)], "len": 0.5, "bulge": 0.17, "thick": 0.028, "tip": "feather", "alpha": 0.8, "accent": Color(0.4, 0.8, 0.5)},
	"cat_bow_snipe": {"c": [Color(0.35, 0.65, 0.38), Color(0.95, 0.97, 0.94), Color(0.9, 1.0, 0.85)], "len": 0.76, "bulge": 0.17, "thick": 0.024, "tip": "ears", "accent": Color(0.96, 0.98, 0.95)},
	"cat_bow_apex": {"c": [Color(0.28, 0.58, 0.34), Color(0.96, 0.97, 0.95), Color(1.0, 0.95, 0.6)], "len": 0.7, "bulge": 0.15, "thick": 0.021, "tip": "inward", "accent": Color(0.96, 0.98, 0.95)},
	"cat_bow_mana": {"c": [Color(0.12, 0.38, 0.2), Color(0.85, 0.75, 0.35), Color(0.55, 1.0, 0.6)], "len": 0.66, "bulge": 0.2, "thick": 0.03, "tip": "wing", "pen": true},
	"cat_bow_essence": {"c": [Color(0.05, 0.22, 0.1), Color(0.95, 0.8, 0.25), Color(1.0, 0.9, 0.3)], "len": 0.7, "bulge": 0.22, "thick": 0.03, "tip": "spiral", "lyre": true},
	"cat_bow_trap": {"c": [Color(0.08, 0.08, 0.09), Color(0.4, 0.85, 0.4), Color(0.5, 1.0, 0.4)], "len": 0.66, "bulge": 0.2, "thick": 0.03, "tip": "ears", "accent": Color(0.35, 0.85, 0.4)},
	"cat_bow_twilight": {"c": [Color(0.04, 0.04, 0.05), Color(0.95, 0.8, 0.25), Color(1.0, 0.9, 0.35)], "len": 0.72, "bulge": 0.21, "thick": 0.028, "tip": "black_feather"},
}

func _bow_mat(color: Color, alpha: float) -> StandardMaterial3D:
	var m := _mat(Color(color, alpha), 0.45, 0.45)
	if alpha < 1.0:
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return m

## CAT MATCHA คันธนูแมว แต่ละสายรูปทรงต่างกัน มือจับมีรอยเท้าแมว กระดิ่งห้อย สายธนูขาว
func _build_bow() -> void:
	_blade = _group(_sword)
	var k: Dictionary = BOW_KINDS.get(style, BOW_KINDS["cat_bow"])
	var pal: Array = k["c"]
	var alpha := float(k.get("alpha", 1.0))
	var limb := _bow_mat(pal[0], alpha)
	var accent := _bow_mat(k.get("accent", pal[0]), alpha)
	var wrap := _mat(pal[1], 0.6, 0.3)
	var shine := _glow(pal[2], 0.8)
	var half := float(k["len"])
	var bulge := float(k["bulge"]) * 1.7
	var tip_kind := str(k["tip"])
	var g := _group(_blade)
	# มือจับอยู่กลางคันธนูพอดี ไม่ให้คันลอยสูงเหนือมือ
	g.position = Vector3(0.0, 0.04, 0.0)
	# คันธนูใหญ่ขึ้นให้อลังการ คลาสต่อยอดใหญ่กว่าคลาสแรก
	g.scale = Vector3.ONE * (1.42 if style in BOW_GRAND else 1.3)
	_staff_fx.append([g, "bow", 0.0])
	var pts: Array = []
	var n := 17
	for i in n:
		var t := -1.0 + 2.0 * float(i) / float(n - 1)
		var at := absf(t)
		var x := bulge * (1.0 - t * t) - bulge
		var y := t * half
		if k.get("lyre", false):
			# โก่งแบบพิณ ปลายแขนแยกออกไปข้างหน้าแล้วม้วน
			x += 0.42 * at * at * at
		elif tip_kind == "inward":
			# ปลายคันโค้งเข้าหาสาย
			if at > 0.78:
				x -= (at - 0.78) * 0.5
				y -= signf(t) * (at - 0.78) * 0.12
		elif at > 0.82:
			x += (at - 0.82) * 0.5
		pts.append(Vector3(x, y, 0.0))
	for i in pts.size() - 1:
		var thick := float(k["thick"]) * 1.6 * (1.0 - absf(float(i) - float(n - 1) * 0.5) / float(n) * 0.9)
		var mat := accent if (i % 4 == 1 and k.has("accent")) else limb
		_edge(g, pts[i], pts[i + 1], thick, mat)
	var top: Vector3 = pts[pts.size() - 1]
	var low: Vector3 = pts[0]
	# สายธนู
	_edge(g, low, top, 0.007, _mat(Color(1.0, 1.0, 0.97), 0.3, 0.2))
	# มือจับ
	_part(g, _rod(0.042, 0.19, 12), wrap, Vector3.ZERO)
	for y in [-0.095, 0.095]:
		_part(g, _rod(0.047, 0.022, 12), _mat(pal[2], 0.3, 0.6), Vector3(0.0, y, 0.0))
	_staff_paw(g, Vector3(0.035, 0.0, 0.05), 0.02, pal[2])
	_part(g, _ball(0.036), _mat(Color(1.0, 0.82, 0.3), 0.2, 0.9), Vector3(-0.02, -0.15, 0.04))
	# ปลายคัน
	for end in [top, low]:
		var up := 1.0 if end == top else -1.0
		match tip_kind:
			"ears":
				_part(g, _ball(0.028), shine, end)
				if up > 0.0:
					_staff_ears(g, end + Vector3(0.0, 0.03, 0.0), 0.045, 0.032, pal[0])
			"inward":
				_part(g, _ball(0.024), shine, end)
			"feather", "black_feather":
				var fcol: Color = Color(0.08, 0.08, 0.1) if tip_kind == "black_feather" else Color(0.92, 1.0, 0.94)
				_bow_feather(g, end, up, fcol, k.get("accent", pal[2]))
				if tip_kind == "black_feather":
					_bow_spiral(g, end + Vector3(0.0, up * 0.02, 0.0), up, pal[2])
			"wing":
				_bow_wing_big(g, end, up, pal[0], pal[2], 1.1)
			"spiral":
				_bow_spiral(g, end, up, pal[2])
	_bow_ornate(g, pts, k, pal, limb)
	if k.get("pen", false):
		_build_wing_pen(pal[2])
	# ดาบมือรองไม่ถือติดมือ โผล่เฉพาะตอนออกท่าฟันดาบ (คีย์ off_aim_end)
	var blade_kind := str(k.get("blade", ""))
	if style == "cat_bow_trap":
		blade_kind = "short"
	elif style == "cat_bow_twilight":
		blade_kind = "long"
	match blade_kind:
		"short":
			_build_off_blade(0.36, 0.034, Color(0.97, 0.98, 0.94), Color(0.35, 0.85, 0.4), Color(1.0, 0.85, 0.25), Color(0.95, 0.15, 0.15))
		"long":
			_build_off_blade(0.62, 0.026, Color(0.06, 0.06, 0.08), Color(0.95, 0.8, 0.25), Color(0.92, 0.9, 1.0), Color(0.6, 0.25, 0.9))

## คลาสต่อยอดของ MATCHA คันธนูใหญ่และหรูกว่า
const BOW_GRAND := ["cat_bow_gale", "cat_bow_apex", "cat_bow_essence", "cat_bow_twilight"]

## ของประดับคันธนู: แขนคันซ้อนชั้นใน ปลายม้วน อัญมณีที่มือจับ และของประจำสาย
func _bow_ornate(g: Node3D, pts: Array, k: Dictionary, pal: Array, limb: Material) -> void:
	var grand := style in BOW_GRAND
	var gold := _mat(Color(1.0, 0.84, 0.35), 0.25, 0.9)
	var n := pts.size()
	var half_n := floori(float(n) * 0.5)
	# แขนคันชั้นในบางๆ ซ้อนขนานด้านหน้า สีตัดหรือทอง
	var inner_m: Material = gold if grand or style == "cat_bow" else _bow_mat(k.get("accent", pal[1]), float(k.get("alpha", 1.0)))
	for i in range(2, n - 3):
		var a: Vector3 = pts[i] + Vector3(0.028, 0.0, 0.0)
		var b: Vector3 = pts[i + 1] + Vector3(0.028, 0.0, 0.0)
		_edge(g, a, b, 0.009, inner_m)
	# อัญมณีกลมเรืองแสงหน้ามือจับ ล้อมด้วยวงทอง
	_part(g, _ball(0.06 if grand else 0.05), _glow(pal[2], 1.0), Vector3(0.05, 0.0, 0.0))
	# คลาสต่อยอดมีแสงฟุ้งตามแขนคัน
	if grand:
		for i in range(1, n - 1):
			_part(g, _ball(0.03), _glow(pal[2], 0.5), pts[i] + Vector3(0.015, 0.0, 0.0))
	_part(g, _rod(0.046, 0.012, 16), gold, Vector3(0.045, 0.0, 0.0), Vector3.ONE, Vector3(0.0, 0.0, 90.0))
	# ปลายคันม้วนกลมไปด้านหน้า
	for end_i in [0, n - 1]:
		var at: Vector3 = pts[end_i]
		var up := 1.0 if end_i == n - 1 else -1.0
		for j in 6:
			var ang := float(j) * 0.9
			var r := 0.045 * (1.0 - float(j) / 7.0)
			_part(g, _ball(0.022 - float(j) * 0.002), limb, at + Vector3(0.03 + cos(ang) * r, up * (0.015 + sin(ang) * r), 0.0))
	match style:
		"cat_bow":
			for i in [4, n - 5]:
				_bow_leaf(g, pts[i], Color(0.45, 0.75, 0.4), 0.1)
		"cat_bow_wind":
			# ริบบิ้นเขียวห้อยจากมือจับ กับใบไม้ตามแขนคัน
			for i in [3, 6, n - 7, n - 4]:
				_bow_leaf(g, pts[i], Color(0.55, 0.9, 0.6), 0.12)
		"cat_bow_gale":
			# แขนคันรูปปีกสองข้าง กับลูกลมลอยวนรอบคัน
			for i in [5, n - 6]:
				_bow_wing_big(g, pts[i], 1.0 if i > half_n else -1.0, Color(0.92, 1.0, 0.95), pal[2], 1.9)
			_bow_orbit(g, [Color(0.7, 1.0, 0.85), Color(0.85, 1.0, 0.9), Color(0.6, 0.95, 0.8)], 0.5, 1.6)
		"cat_bow_snipe":
			# ผลึกเล็งยาวเหนือมือจับ แบบกล้องเล็ง
			var scope := _group(g)
			scope.position = Vector3(0.06, 0.14, 0.0)
			_part(scope, _rod(0.035, 0.26, 12), _mat(Color(0.25, 0.45, 0.3), 0.4, 0.5), Vector3.ZERO, Vector3.ONE, Vector3(0.0, 0.0, 90.0))
			_part(scope, _ball(0.05), _glow(Color(0.7, 1.0, 0.8), 1.0), Vector3(0.15, 0.0, 0.0), Vector3(1.4, 1.0, 1.0))
			for i in [4, n - 5]:
				_bow_leaf(g, pts[i], Color(0.35, 0.6, 0.35), 0.1)
		"cat_bow_apex":
			# คันใหญ่ขอบทอง ปลายเป็นปีกอินทรีขาวทอง
			for end_i in [0, n - 1]:
				var up2 := 1.0 if end_i == n - 1 else -1.0
				_bow_wing_big(g, pts[end_i], up2, Color(0.98, 0.98, 0.95), Color(1.0, 0.9, 0.5), 2.1)
				_bow_wing_big(g, pts[end_i] + Vector3(0.0, -up2 * 0.08, 0.004), up2, Color(1.0, 0.86, 0.45), Color(1.0, 0.95, 0.6), 1.7)
			_bow_ribbons(g, Color(1.0, 0.85, 0.4), 2, 0.55)
		"cat_bow_mana":
			# ผลึกมานาเรืองแสงเรียงตามแขนคัน
			for i in range(2, n - 2, 3):
				_part(g, _ball(0.04), _glow(pal[2], 1.0), pts[i] + Vector3(0.01, 0.0, 0.0), Vector3(1.0, 1.6, 1.0))
		"cat_bow_essence":
			# ผลึกสามธาตุลอยวนรอบคัน
			_bow_orbit(g, [Color(1.0, 0.55, 0.4), Color(0.55, 0.85, 1.0), Color(1.0, 0.9, 0.4)], 0.55, 1.2)
			for i in range(2, n - 2, 4):
				_part(g, _ball(0.02), _glow(Color(1.0, 0.9, 0.5), 0.9), pts[i] + Vector3(0.01, 0.0, 0.0))
		"cat_bow_trap":
			# เถาวัลย์พันแขนคัน มีใบไม้เล็ก
			var vine := _mat(Color(0.3, 0.6, 0.3), 0.6, 0.2)
			for i in range(1, n - 1):
				var p: Vector3 = pts[i]
				_part(g, _ball(0.02), vine, p + Vector3(cos(float(i) * 1.6) * 0.035, 0.0, sin(float(i) * 1.6) * 0.035))
			for i in [3, n - 4]:
				_bow_leaf(g, pts[i], Color(0.35, 0.7, 0.35), 0.11)
		"cat_bow_twilight":
			# แสงม่วงเรืองตามแขนคัน ขนนกดำที่กลางแขน
			for i in range(2, n - 2, 3):
				_part(g, _ball(0.035), _glow(Color(0.65, 0.4, 1.0), 1.0), pts[i] + Vector3(0.012, 0.0, 0.0))
			for i in [5, n - 6]:
				var fg := _group(g)
				fg.position = pts[i]
				fg.scale = Vector3.ONE * 2.0
				_bow_feather(fg, Vector3.ZERO, 1.0 if i > half_n else -1.0, Color(0.08, 0.08, 0.1), Color(0.65, 0.4, 1.0))
			_bow_orbit(g, [Color(0.7, 0.45, 1.0), Color(0.5, 0.3, 0.9)], 0.48, 0.9)

## ใบไม้กลมติดแขนคัน
func _bow_leaf(g: Node3D, at: Vector3, col: Color, size: float) -> void:
	# ใบไม้ทรงรีพองนิดๆ มองจากมุมไหนก็เห็น
	var leaf := _part(g, _ball(size * 0.5), _mat(col, 0.6, 0.2), at + Vector3(size * 0.45, 0.0, 0.0), Vector3(1.0, 0.45, 0.35))
	leaf.rotation_degrees = Vector3(0.0, 0.0, 25.0 if at.y > 0.0 else -25.0)

## ริบบิ้นห้อยจากมือจับ ปลายมน
func _bow_ribbons(g: Node3D, col: Color, count: int, length: float) -> void:
	var rib := _group(g)
	rib.position = Vector3(0.0, -0.1, 0.0)
	var m := _mat(col, 0.6, 0.2)
	for r in count:
		var off := (float(r) - float(count - 1) * 0.5) * 0.05
		var prev := Vector3(off, 0.0, 0.0)
		for j in 6:
			var nxt := Vector3(off - float(j + 1) * 0.012, -float(j + 1) * length / 6.0, sin(float(j) * 1.2 + float(r)) * 0.02)
			_edge(rib, prev, nxt, 0.024 - float(j) * 0.002, m)
			prev = nxt
		_part(rib, _ball(0.03), m, prev)
	_staff_fx.append([rib, "wag", 0.0])

## ลูกแก้วเรืองแสงลอยวนรอบคันธนู
func _bow_orbit(g: Node3D, cols: Array, r: float, speed: float) -> void:
	var orbit := _group(g)
	for i in cols.size():
		var a := TAU * float(i) / float(cols.size())
		_part(orbit, _ball(0.055), _glow(cols[i], 1.1), Vector3(cos(a) * r * 0.5 + 0.08, sin(a) * r, absf(sin(a)) * r * 0.25 + 0.06))
	_staff_fx.append([orbit, "spin_y", speed])

## ขนนกเล็กติดปลายคันสองข้าง
func _bow_feather(g: Node3D, at: Vector3, up: float, col: Color, vein: Color) -> void:
	# ขนนกทรงรีพองสองเส้น ปลายมน มองจากมุมไหนก็เห็น
	for side in [-1.0, 1.0]:
		var f := _part(g, _ball(0.06), _mat(col, 0.6, 0.2), at + Vector3(side * 0.03, up * 0.07, 0.02), Vector3(0.4, 1.0, 0.5))
		f.rotation = Vector3(0.0, 0.0, -side * up * 0.35)
	_part(g, _ball(0.016), _mat(vein, 0.5, 0.3), at)

## ปีกขยายขนาด
func _bow_wing_big(g: Node3D, at: Vector3, up: float, col: Color, glow_c: Color, k: float) -> void:
	# ปีกแบบขนนกทรงรีพองเรียงเป็นพัด มองจากมุมไหนก็เห็นเป็นปีกมนๆ ไม่เป็นเส้นแหลม
	var wg := _group(g)
	wg.position = at
	wg.scale = Vector3.ONE * k
	for i in 5:
		var ang := deg_to_rad(20.0 + float(i) * 22.0)
		var l := 0.075 - float(i) * 0.008
		var d := Vector3(-cos(ang) * 0.6 - 0.2, up * sin(ang), 0.0).normalized()
		var f := _part(wg, _ball(l), _mat(col.lightened(0.05 * float(i)), 0.5, 0.3), d * l * 0.9 + Vector3(0.0, 0.0, 0.03), Vector3(0.38, 1.0, 0.5))
		f.rotation = Vector3(0.0, 0.0, atan2(d.y, d.x) - PI * 0.5)
	_part(wg, _ball(0.026), _glow(glow_c, 0.9), Vector3.ZERO)

## ปลายคันคล้ายปีก
func _bow_wing(g: Node3D, at: Vector3, up: float, col: Color, glow_c: Color) -> void:
	for i in 3:
		var l := 0.16 - float(i) * 0.035
		var poly := PackedVector2Array([Vector2(0.0, 0.0), Vector2(-0.02 - float(i) * 0.04, up * l * 0.6), Vector2(-0.06 - float(i) * 0.05, up * l), Vector2(-0.01 - float(i) * 0.03, up * l * 0.35)])
		if up < 0.0:
			poly.reverse()
		_part(g, _flat(poly, 0.01), _mat(col.lightened(0.15 * float(i)), 0.5, 0.3), at + Vector3(0.0, 0.0, float(i) * 0.004))
	_part(g, _ball(0.026), _glow(glow_c, 0.9), at)

## ปลายคันเป็นเกลียวสีเหลือง
func _bow_spiral(g: Node3D, at: Vector3, up: float, col: Color) -> void:
	var m := _glow(col, 0.6)
	for i in 9:
		var a := float(i) * 0.8
		var r := 0.05 * (1.0 - float(i) / 10.0)
		_part(g, _ball(0.016 - float(i) * 0.001), m, at + Vector3(cos(a) * r + 0.03, up * (0.02 + float(i) * 0.012), sin(a) * r * 0.4))

## ปากกาติดปีกลอยตามข้างตัว (MANASTARKER)
func _build_wing_pen(glow_c: Color) -> void:
	var pen := _group(_blade)
	pen.position = Vector3(-0.32, 1.0, -0.12)
	_part(pen, _rod(0.018, 0.26, 10), _mat(Color(0.12, 0.38, 0.2), 0.4, 0.5), Vector3.ZERO)
	_part(pen, _box(Vector3(0.02, 0.06, 0.02)), _mat(Color(0.95, 0.8, 0.3), 0.3, 0.8), Vector3(0.0, -0.15, 0.0), Vector3(1.0, 1.0, 1.0), Vector3(0.0, 0.0, 45.0))
	_part(pen, _ball(0.022), _glow(glow_c, 0.9), Vector3(0.0, 0.13, 0.0))
	for side in [-1.0, 1.0]:
		var poly := PackedVector2Array([Vector2(0.0, 0.0), Vector2(side * 0.1, 0.05), Vector2(side * 0.16, 0.1), Vector2(side * 0.06, 0.02)])
		if side < 0.0:
			poly.reverse()
		_part(pen, _flat(poly, 0.008), _mat(Color(0.95, 1.0, 0.95), 0.6, 0.2), Vector3(0.0, 0.05, 0.0))
	_staff_fx.append([pen, "pen", 0.0])

## ดาบมืออีกข้าง (TRAPSTARKER ดาบสั้น / TWILIGHT ดาบเรียวยาว)
func _build_off_blade(length: float, width: float, grip_c: Color, grip2_c: Color, core_c: Color, gem_c: Color) -> void:
	var g := _group(_off_hand)
	g.rotation_degrees = OFF_BLADE_REST
	g.visible = false
	_off_blade = g
	g.scale = Vector3.ONE * 1.45
	# ด้ามสองสีพันสลับ
	for i in 4:
		_part(g, _rod(0.026, 0.035, 10), _mat(grip_c if i % 2 == 0 else grip2_c, 0.5, 0.3), Vector3(0.0, 0.06 - float(i) * 0.035, 0.0))
	_part(g, _ball(0.03), _mat(grip2_c, 0.4, 0.5), Vector3(0.0, 0.09, 0.0))
	# การ์ด
	_part(g, _box(Vector3(0.14, 0.022, 0.04)), _mat(grip2_c, 0.35, 0.6), Vector3(0.0, -0.085, 0.0))
	# ใบดาบ แกนกลางสีเด่น
	var blade_m := _mat(Color(0.88, 0.92, 0.95), 0.25, 0.9)
	var poly := PackedVector2Array([Vector2(-width, 0.0), Vector2(width, 0.0), Vector2(width * 0.8, -length * 0.85), Vector2(0.0, -length), Vector2(-width * 0.8, -length * 0.85)])
	_part(g, _flat(poly, 0.012), blade_m, Vector3(0.0, -0.095, 0.0))
	var core := PackedVector2Array([Vector2(-width * 0.3, 0.0), Vector2(width * 0.3, 0.0), Vector2(0.0, -length * 0.9)])
	_part(g, _flat(core, 0.016), _glow(core_c, 0.6), Vector3(0.0, -0.095, 0.0))
	# ก้อนกลมที่แกน
	_part(g, _ball(0.028), _glow(gem_c, 0.9), Vector3(0.0, -0.13, 0.0))

## BASIC คฑาไม้ หัวคฑาเป็นปมไม้มีกิ่งสามกิ่งโอบอัญมณีม่วงเรืองแสง
func _staff_wood() -> void:
	var wood := _mat(WOOD, 0.82, 0.25)
	var dark := _mat(WOOD_DARK, 0.82, 0.25)
	var grain := _mat(WOOD_GRAIN, 0.82, 0.25)
	_part(_blade, _rod(0.042, 1.45, 14), wood, Vector3(0.0, 0.47, 0.0))
	_part(_blade, _ball(0.055), dark, Vector3(0.0, -0.26, 0.0))
	for y in [0.05, 0.12, 0.85]:
		_part(_blade, _rod(0.05, 0.035, 14), dark, Vector3(0.0, y, 0.0))
	_part(_blade, _ball(0.085), dark, Vector3(0.0, 1.2, 0.0), Vector3(1.0, 0.8, 1.0))
	for i in 3:
		var a := TAU * float(i) / 3.0
		_part(_blade, _box(Vector3(0.03, 0.2, 0.03)), grain, Vector3(cos(a) * 0.07, 1.31, sin(a) * 0.07), Vector3.ONE, Vector3(rad_to_deg(sin(a)) * 0.4, 0.0, -rad_to_deg(cos(a)) * 0.4))
	_part(_blade, _ball(0.085), _glow(MAGE_GEM, 2.0), Vector3(0.0, 1.36, 0.0))
	_part(_blade, _ball(0.13), _flame_mat(Color(MAGE_GEM, 0.25)), Vector3(0.0, 1.36, 0.0))
	# หูแมวบนอัญมณี กระดิ่งใต้หัว
	_staff_ears(_blade, Vector3(0.0, 1.47, 0.0), 0.07, 0.06, MAGE_GEM)
	_staff_bell(1.06)

## ARCH MAGE ด้ามขาว หัวเป็นเปียสามเส้นบิดเกลียวขึ้นไปนิดหนึ่ง ปลายเปียแตกเป็นสองแฉกเล็ก มีอัญมณีฟ้าตรงง่าม
func _staff_arch() -> void:
	_shaft(STAFF_WHITE, Color(0.75, 0.85, 1.0))
	var white := _mat(STAFF_WHITE, 0.35, 0.6)
	var shade := _mat(Color(0.82, 0.86, 0.95), 0.35, 0.6)
	for strand in 3:
		for i in 9:
			var k := float(i) / 8.0
			var a := TAU * float(strand) / 3.0 + k * TAU * 1.1
			var r := 0.05 * (1.0 - k * 0.35)
			_part(_blade, _ball(0.036 - k * 0.008), white if strand != 1 else shade, Vector3(cos(a) * r, 1.12 + k * 0.24, sin(a) * r))
	var face := _face_group()
	for side in [-1.0, 1.0]:
		var prong := _part(face, _rod(0.0, 0.16, 10), white, Vector3(side * 0.05, 0.14, 0.0), Vector3.ONE, Vector3(0.0, 0.0, -side * 28.0))
		(prong.mesh as CylinderMesh).bottom_radius = 0.025
	_part(face, _ball(0.04), _glow(Color(0.55, 0.85, 1.0), 2.2), Vector3(0.0, 0.08, 0.0))
	# ง่ามสองแฉกเป็นหูแมว อุ้งเท้าฟ้ากลางง่าม กระดิ่งใต้เปีย
	_staff_paw(face, Vector3(0.0, 0.06, 0.02), 0.03, Color(0.6, 0.85, 1.0))
	_staff_bell(1.08)

## ELEMENT MASTER ด้ามขาวทอง หัวเป็นวงทองสองชั้นมีปีกโค้ง ผลึกกลางเรืองขาว อัญมณีไฟ น้ำแข็ง ไฟฟ้า หมุนรอบในวง
## มีหนังสือเวทลอยข้างหลังตัว เปิดอยู่และพลิกหน้าไปมา
func _staff_element() -> void:
	_shaft(STAFF_WHITE, STAFF_GOLD, 1.22)
	var gold := _mat(STAFF_GOLD, 0.25, 0.8)
	var face := _face_group()
	face.position.y += 0.1
	_hoop(face, 0.17, 0.016, gold, Vector3.ZERO)
	_hoop(face, 0.13, 0.008, _glow(Color(1.0, 0.95, 0.75), 1.2), Vector3.ZERO)
	for side in [-1.0, 1.0]:
		var wing := _part(face, _flat(_wing_poly(0.16), 0.02), gold, Vector3(side * 0.17, 0.02, 0.0))
		wing.scale = Vector3(side, 1.0, 1.0)
	_part(face, _flat(PackedVector2Array([Vector2(0.0, 0.11), Vector2(0.05, 0.0), Vector2(0.0, -0.11), Vector2(-0.05, 0.0)]), 0.05), _glow(Color(0.95, 0.97, 1.0), 2.0), Vector3.ZERO)
	_part(face, _ball(0.04), gold, Vector3(0.0, -0.2, 0.0))
	var orbit := _group(face)
	_staff_fx.append([orbit, "spin_z", 2.2])
	var gems := [Color(1.0, 0.4, 0.1), Color(0.45, 0.85, 1.0), Color(1.0, 0.92, 0.3)]
	for i in 3:
		var a := TAU * float(i) / 3.0
		_part(orbit, _ball(0.032), _glow(gems[i], 2.4), Vector3(cos(a), sin(a), 0.0) * 0.095)
	# หนังสือลอยข้างหลัง
	var book := _group(_torso)
	book.position = Vector3(0.0, 1.05, -0.62)
	book.rotation_degrees = Vector3(-25.0, 0.0, 0.0)
	_staff_fx.append([book, "bob", book.position])
	var cover := _mat(Color(0.45, 0.15, 0.55), 0.6, 0.3)
	var paper := _mat(Color(0.98, 0.95, 0.85), 0.9, 0.1)
	for side in [-1.0, 1.0]:
		var half := _group(book)
		half.rotation_degrees.z = side * -12.0
		_part(half, _box(Vector3(0.24, 0.015, 0.3)), cover, Vector3(side * 0.12, 0.0, 0.0))
		_part(half, _box(Vector3(0.22, 0.03, 0.28)), paper, Vector3(side * 0.115, 0.022, 0.0))
		_part(half, _box(Vector3(0.05, 0.016, 0.05)), gold, Vector3(side * 0.12, -0.009, 0.0))
	_part(book, _rod(0.012, 0.3, 8), gold, Vector3.ZERO, Vector3.ONE, Vector3(90.0, 0.0, 0.0))
	var page := _group(book)
	_part(page, _box(Vector3(0.21, 0.004, 0.27)), paper, Vector3(0.105, 0.04, 0.0))
	_staff_fx.append([page, "page", 0.0])
	_part(book, _ball(0.05), _glow(Color(1.0, 0.85, 0.4), 1.5), Vector3(0.0, 0.1, 0.0))
	# หูแมวทองบนวงแหวน กระดิ่ง
	_staff_ears(face, Vector3(0.0, 0.2, 0.0), 0.08, 0.1, STAFF_GOLD)
	_staff_bell(1.18)

## BATTLE MAGE ขอบดาวสีเหลืองกลวง ดาวชมพูลอยข้างในไม่ติดขอบ ปีกจิ๋วสองข้างกระพือ
func _staff_battle() -> void:
	_shaft(Color(0.98, 0.9, 0.95), STAFF_YELLOW, 1.24)
	var yellow := _mat(STAFF_YELLOW, 0.3, 0.7)
	var face := _face_group()
	face.position.y += 0.08
	var outline := _star_poly(0.2, 0.47)
	for i in outline.size():
		var a := outline[i]
		var b := outline[(i + 1) % outline.size()]
		_edge(face, Vector3(a.x, a.y, 0.0), Vector3(b.x, b.y, 0.0), 0.016, yellow)
		_part(face, _ball(0.016), yellow, Vector3(a.x, a.y, 0.0))
	var inner := _group(face)
	_part(inner, _flat(_star_poly(0.1, 0.48), 0.04), _mat(STAFF_PINK, 0.35, 0.6), Vector3.ZERO)
	_part(inner, _flat(_star_poly(0.05, 0.48), 0.05), _glow(Color(1.0, 0.8, 0.92), 1.2), Vector3.ZERO)
	_staff_fx.append([inner, "spin_z", 1.2])
	for side in [-1.0, 1.0]:
		var hinge := _group(face)
		hinge.position = Vector3(side * 0.18, 0.0, 0.0)
		var wing := _part(hinge, _flat(_wing_poly(0.1), 0.015), _mat(STAFF_WHITE, 0.5, 0.3), Vector3.ZERO)
		wing.scale = Vector3(side, 1.0, 1.0)
		_staff_fx.append([hinge, "flap", side])
	# หูแมวบนยอดดาว กระดิ่ง
	_staff_ears(face, Vector3(0.0, 0.2, 0.0), 0.06, 0.07, STAFF_YELLOW)
	_staff_bell(1.2)

## DIMENSION CASTER หัวใจสีชมพู ปีกตรงรอยต่อด้ามกับหัวใจ ท้ายด้ามเป็นดาวเหลืองเล็ก ดาวชมพูเหลืองลอยวนรอบตัว
func _staff_dimension() -> void:
	_shaft(Color(1.0, 0.85, 0.93), STAFF_PINK, 1.22)
	var face := _face_group()
	_part(face, _flat(_heart_poly(0.17), 0.07), _mat(STAFF_PINK, 0.3, 0.7), Vector3(0.0, 0.12, 0.0))
	_part(face, _flat(_heart_poly(0.08), 0.08), _glow(Color(1.0, 0.75, 0.9), 1.3), Vector3(-0.05, 0.16, 0.0))
	for side in [-1.0, 1.0]:
		var hinge := _group(face)
		hinge.position = Vector3(side * 0.03, -0.1, 0.0)
		var wing := _part(hinge, _flat(_wing_poly(0.15), 0.018), _mat(STAFF_WHITE, 0.5, 0.3), Vector3.ZERO)
		wing.scale = Vector3(side, 1.0, 1.0)
		_staff_fx.append([hinge, "flap", side])
	var butt := _group(_blade)
	butt.position = Vector3(0.0, -0.3, 0.0)
	_staff_fx.append([butt, "face", 0.0])
	_part(butt, _ball(0.045), _glow(STAFF_YELLOW, 1.2), Vector3.ZERO)
	# เม็ดแสงกลมเล็กวนรอบตัว (ไม่ใช้ดาวแฉก)
	var ring := _group(_pivot)
	ring.position = Vector3(0.0, 0.75, 0.0)
	_staff_fx.append([ring, "spin_y", 1.4])
	for i in 6:
		var a := TAU * float(i) / 6.0
		var star := _part(ring, _ball(0.035), _glow(STAFF_PINK if i % 2 == 0 else STAFF_YELLOW, 1.4), Vector3(cos(a) * 0.72, 0.18 * sin(a * 2.0), sin(a) * 0.72), Vector3.ONE * 1.5)
		_staff_fx.append([star, "twinkle", float(i)])
	# หูแมวบนหัวใจ อุ้งเท้ากลางหัวใจ กระดิ่ง
	_staff_ears(face, Vector3(0.0, 0.28, 0.0), 0.08, 0.1, STAFF_PINK)
	_staff_paw(face, Vector3(0.05, 0.08, 0.045), 0.03, Color(1.0, 0.9, 0.95))
	_staff_bell(1.18)

## DARK MAGE ด้ามดำ หัวเป็นแม่เหล็กเกือกม้าซ้อนสองชั้น ม่วงเข้มกับดำ ปลายเงินม่วงเรือง มีประกายไฟฟ้าระหว่างปลาย
func _staff_dark() -> void:
	_shaft(STAFF_BLACK, Color(0.35, 0.15, 0.5), 1.27)
	var face := _face_group()
	_edge(face, Vector3(-0.17, -0.03, 0.0), Vector3(0.17, -0.03, 0.0), 0.022, _mat(Color(0.35, 0.15, 0.5), 0.35, 0.6))
	var layers := [[0.17, Color(0.32, 0.12, 0.45)], [0.105, Color(0.14, 0.06, 0.2)]]
	for layer in layers:
		var r: float = layer[0]
		var mat := _mat(layer[1], 0.35, 0.6)
		var pts: Array = []
		for i in 13:
			var a := PI * float(i) / 12.0
			pts.append(Vector3(cos(a) * r, 0.08 + sin(a) * r, 0.0))
		pts.push_front(Vector3(r, -0.04, 0.0))
		pts.append(Vector3(-r, -0.04, 0.0))
		for i in pts.size() - 1:
			_edge(face, pts[i], pts[i + 1], 0.03 if r > 0.15 else 0.025, mat)
			_part(face, _ball(0.03 if r > 0.15 else 0.025), mat, pts[i])
		for side in [-1.0, 1.0]:
			_part(face, _box(Vector3(0.07, 0.05, 0.07)), _mat(Color(0.78, 0.76, 0.86), 0.25, 0.9), Vector3(side * r, -0.07, 0.0))
	var spark := _part(face, _ball(0.025), _glow(Color(0.85, 0.6, 1.0), 2.5), Vector3(0.0, 0.1, 0.0))
	_staff_fx.append([spark, "pulse", 0.0])
	# หูแมวบนแม่เหล็ก กระดิ่ง
	_staff_ears(face, Vector3(0.0, 0.3, 0.0), 0.08, 0.1, Color(0.32, 0.12, 0.45))
	_staff_bell(1.22)

## ECLIPSE หัวเป็นหลุมมิติมืดเล็กๆ ดูดตลอด มีแสงม่วงไหลเข้าหา วงเส้นม่วงหลายวงหมุนรอบหัวคฑาคนละแกน
func _staff_eclipse() -> void:
	_shaft(STAFF_BLACK, Color(0.4, 0.2, 0.6), 1.3)
	var head := _group(_blade)
	head.position = Vector3(0.0, STAFF_HEAD_Y + 0.08, 0.0)
	var core := _mat(Color(0.02, 0.0, 0.04), 0.9, 0.0)
	core.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_part(head, _ball(0.075), core, Vector3.ZERO)
	_part(head, _ball(0.09), _flame_mat(Color(0.6, 0.3, 1.0, 0.3)), Vector3.ZERO)
	for i in 3:
		var shell := _part(head, _ball(0.2), _flame_mat(Color(0.65, 0.35, 1.0, 0.16)), Vector3.ZERO)
		_staff_fx.append([shell, "suck", float(i) / 3.0])
	var line := _glow(Color(0.7, 0.4, 1.0), 1.8)
	var tilts := [Vector3(70.0, 0.0, 0.0), Vector3(20.0, 0.0, 60.0), Vector3(-30.0, 40.0, -50.0)]
	for i in 3:
		var spin := _group(head)
		spin.rotation_degrees = tilts[i]
		var m := TorusMesh.new()
		m.inner_radius = 0.15 + 0.03 * float(i)
		m.outer_radius = m.inner_radius + 0.012
		m.rings = 40
		m.ring_segments = 6
		_part(spin, m, line, Vector3.ZERO)
		_staff_fx.append([spin, "spin_y", 1.5 + float(i) * 0.7])
	# หูแมวบนหลุมมิติ กระดิ่ง
	_staff_ears(head, Vector3(0.0, 0.1, 0.0), 0.06, 0.05, Color(0.2, 0.08, 0.3))
	_staff_bell(1.26)

## ALCHEMIST MAGE หัวเป็นขวดยาทรงกลม แก้วใส น้ำยาแดงข้างในกระฉอกตามการขยับ จุกไม้ คอขวดทอง วงทองและลูกแก้วทองวนรอบ
func _staff_alch() -> void:
	_shaft(Color(0.62, 0.42, 0.25), STAFF_GOLD, 1.24)
	var head := _group(_blade)
	head.position = Vector3(0.0, STAFF_HEAD_Y + 0.08, 0.0)
	var gold := _mat(STAFF_GOLD, 0.25, 0.8)
	var glass := _mat(Color(0.85, 0.95, 1.0, 0.28), 0.05, 1.0)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_part(head, _rod(0.06, 0.03, 14), gold, Vector3(0.0, -0.15, 0.0))
	var level := _group(head)
	_staff_fx.append([level, "slosh", 0.0])
	_part(level, _ball(0.118), _glow(Color(0.85, 0.05, 0.12), 0.5), Vector3(0.0, -0.035, 0.0), Vector3(1.0, 0.68, 1.0))
	_part(level, _ball(0.03), _glow(Color(1.0, 0.5, 0.5), 1.0), Vector3(0.04, 0.0, 0.05))
	_part(head, _ball(0.13), glass, Vector3.ZERO)
	_part(head, _rod(0.035, 0.08, 12), glass, Vector3(0.0, 0.16, 0.0))
	_part(head, _rod(0.04, 0.02, 12), gold, Vector3(0.0, 0.135, 0.0))
	_part(head, _rod(0.032, 0.05, 10), _mat(WOOD, 0.8, 0.2), Vector3(0.0, 0.215, 0.0))
	var spin := _group(head)
	spin.rotation_degrees.x = 18.0
	_staff_fx.append([spin, "spin_y", 1.6])
	var m := TorusMesh.new()
	m.inner_radius = 0.19
	m.outer_radius = 0.205
	_part(spin, m, _glow(STAFF_YELLOW, 1.3), Vector3.ZERO)
	for i in 3:
		var a := TAU * float(i) / 3.0
		_part(spin, _ball(0.028), _glow(STAFF_GOLD, 1.8), Vector3(cos(a) * 0.2, 0.0, sin(a) * 0.2))
	# จุกขวดมีหูแมว รอยอุ้งเท้าบนขวด กระดิ่ง
	_staff_ears(head, Vector3(0.0, 0.27, 0.0), 0.05, 0.035, Color(0.72, 0.5, 0.27))
	_staff_paw(head, Vector3(0.0, 0.02, 0.125), 0.025, Color(1.0, 0.85, 0.9))
	_staff_bell(1.2)

## TRANSMUTATION MASTER ลูกบาศก์ทึบสีม่วงเล็ก ล้อมด้วยโครงปริซึมสามเหลี่ยม 3 มิติเป็นเส้นล้วน มองทะลุเห็นข้างใน หมุนสวนกัน
func _staff_trans() -> void:
	_shaft(Color(0.25, 0.18, 0.35), Color(0.7, 0.55, 1.0), 1.26)
	var head := _group(_blade)
	head.position = Vector3(0.0, STAFF_HEAD_Y + 0.1, 0.0)
	var cube := _group(head)
	cube.rotation_degrees = Vector3(35.0, 45.0, 0.0)
	_part(cube, _box(Vector3.ONE * 0.1), _mat(Color(0.5, 0.2, 0.8), 0.3, 0.6), Vector3.ZERO)
	_staff_fx.append([cube, "spin_y", -1.8])
	var tilt := _group(head)
	tilt.rotation_degrees = Vector3(22.0, 0.0, 12.0)
	var cage := _group(tilt)
	_staff_fx.append([cage, "spin_y", 0.9])
	var line := _glow(Color(0.85, 0.75, 1.0), 1.6)
	var top: Array = []
	var low: Array = []
	for i in 3:
		var a := TAU * float(i) / 3.0
		top.append(Vector3(cos(a) * 0.17, 0.15, sin(a) * 0.17))
		low.append(Vector3(cos(a) * 0.17, -0.15, sin(a) * 0.17))
	for i in 3:
		var j := (i + 1) % 3
		_edge(cage, top[i], top[j], 0.008, line)
		_edge(cage, low[i], low[j], 0.008, line)
		_edge(cage, top[i], low[i], 0.008, line)
		_part(cage, _ball(0.014), line, top[i])
		_part(cage, _ball(0.014), line, low[i])
	# ลูกบาศก์มีหูแมว กระดิ่ง
	_staff_ears(cube, Vector3(0.0, 0.07, 0.0), 0.05, 0.03, Color(0.5, 0.2, 0.8))
	_staff_bell(1.22)

## ขยับส่วนต่างๆ ของคฑา เรียกทุกเฟรม
func _tick_staff(clock_f: float, delta: float) -> void:
	if _staff_fx.is_empty():
		return
	# ความเร่งของหัวคฑาบนจอ ใช้ให้น้ำยากระฉอก
	var head := _blade.global_transform * Vector3(0.0, STAFF_HEAD_Y, 0.0) if _blade != null else Vector3.ZERO
	var move := (head - _staff_last).x / maxf(delta, 0.001) if delta > 0.0 else 0.0
	_staff_last = head
	_slosh_v += (-clampf(move, -6.0, 6.0) * 0.6 - _slosh * 40.0 - _slosh_v * 4.0) * delta
	_slosh += _slosh_v * delta
	for item in _staff_fx:
		var node := item[0] as Node3D
		if not is_instance_valid(node) or not node.is_inside_tree():
			continue
		match str(item[1]):
			"wag":
				# หางส่ายไปมาช้าๆ
				node.rotation_degrees.y = sin(clock_f * 3.0) * 18.0
				node.rotation_degrees.x = sin(clock_f * 2.0) * 6.0
			"pen":
				# ปากกาติดปีกลอยขึ้นลงช้าๆ ข้างตัว
				node.position.y = 1.0 + sin(clock_f * 2.4) * 0.06
				node.rotation_degrees.z = sin(clock_f * 1.7) * 12.0 - 20.0
			"face", "bow":
				var up := (node.get_parent() as Node3D).global_transform.basis.y.normalized()
				var side := up.cross(Vector3(0.0, 0.0, 1.0))
				# คันธนูโก่งไปทางด้านหน้าของแมวเสมอเหมือนธนูจริง สายธนูอยู่ฝั่งตัว
				# หมุนดูมุมหน้าจะเห็นคันธนูด้านข้าง หมุนดูด้านข้างเห็นความโก่งเต็มๆ
				if str(item[1]) == "bow" and _torso != null:
					var fwd := _torso.global_transform.basis.z.normalized()
					var flat_fwd := fwd - up * fwd.dot(up)
					if flat_fwd.length() > 0.05:
						side = flat_fwd.normalized()
				if str(item[1]) == "bow" and side.length() > 0.05:
					# หันหน้าคันธนูเข้าหากล้องราว 55 องศา ยังโก่งไปทางด้านหน้าของแมว
					var hz := Vector3(signf(side.x) if absf(side.x) > 0.02 else 1.0, 0.0, 0.0)
					hz = hz - up * hz.dot(up)
					if hz.length() > 0.05:
						side = side.normalized().lerp(hz.normalized(), 0.65)
				if side.length() > 0.05:
					side = side.normalized()
					var keep := node.global_transform.basis.get_scale()
					node.global_transform.basis = Basis(side, up, side.cross(up)).scaled(keep)
					if str(item[1]) == "bow":
						# ดันคันธนูออกมาด้านหน้าตัวและเข้าหากล้อง ไม่ให้ซ่อนหลังตัวตอนยืน
						var holder := node.get_parent() as Node3D
						node.global_position = holder.global_position + side * 0.06 + Vector3(0.0, 0.0, 0.32)
			"spin_z":
				node.rotation.z = clock_f * float(item[2])
			"spin_y":
				node.rotation.y = clock_f * float(item[2])
			"flap":
				node.rotation.y = sin(clock_f * 14.0) * 0.6 * float(item[2])
			"bob":
				node.position = (item[2] as Vector3) + Vector3(0.0, sin(clock_f * 2.2) * 0.04, 0.0)
			"page":
				var k := fposmod(clock_f * 0.45, 1.0)
				var turn := clampf((k - 0.2) / 0.5, 0.0, 1.0)
				node.rotation.z = PI * (turn * turn * (3.0 - 2.0 * turn)) * 0.86 + 0.1
			"twinkle":
				node.scale = Vector3.ONE * (1.2 + 0.45 * sin(clock_f * 6.0 + float(item[2])))
				node.rotation.y = -clock_f * 1.4
			"pulse":
				node.scale = Vector3.ONE * (0.6 + 0.5 * absf(sin(clock_f * 9.0)))
			"suck":
				var k := 1.0 - fposmod(clock_f * 0.8 + float(item[2]), 1.0)
				node.scale = Vector3.ONE * (0.4 + 0.8 * k)
				var mat := node.material_override as StandardMaterial3D
				mat.albedo_color.a = 0.28 * (1.0 - k)
			"slosh":
				# น้ำยาอยู่ระดับเดิมเทียบพื้นโลก แล้วเอียงตามแรงกระฉอก
				var keep_s := node.global_transform.basis.get_scale()
				node.global_transform.basis = Basis(Vector3(0.0, 0.0, 1.0), clampf(_slosh, -0.7, 0.7)).scaled(keep_s)
