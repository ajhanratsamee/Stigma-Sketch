class_name Outfit
## ชุดของแต่ละคลาส สร้างหลังตัวแมวเสร็จ แยกไฟล์ตามตัวละคร
## m คือ ChibiModel (ใช้ m._part m._mat m._group m._ball m._rod m._lathe m._profile_at m._torso m._sword m._off_hand m.style)
## body คือตัวแมว foot_mesh คือเมชเท้า  BASIC ไม่ใส่ชุด

const ENABLED := false

static func build(m: ChibiModel, body: MeshInstance3D, foot_mesh: Mesh) -> void:
	# ผู้เล่นให้เอาชุดออกทั้งหมด (2026-11-09) เก็บโค้ดชุดไว้เผื่อใช้ทีหลัง
	if not ENABLED:
		return
	var st := m.style
	if st in ["cat_knight", "cat_grand", "cat_grand_armor", "cat_flame", "cat_guardian", "cat_crimson", "cat_magic", "cat_shield", "cat_dark"]:
		OutfitBoys.build(m, body, foot_mesh)
	elif st.begins_with("cat_staff"):
		OutfitSusi.build(m, body, foot_mesh)
	elif st.begins_with("cat_bow"):
		OutfitMatcha.build(m, body, foot_mesh)
	elif st.begins_with("cat_spear"):
		OutfitCitrus.build(m, body, foot_mesh)
	elif st.begins_with("cat_azure") or st.begins_with("cat_lapis"):
		OutfitPair.build(m, body, foot_mesh)
	elif st.begins_with("cat_fist"):
		OutfitAsh.build(m, body, foot_mesh)
