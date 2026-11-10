class_name PairHyperBase
extends FistHyperBase
## ฐาน HYPER ของสาย HARMONY DUET / ID EGO SAGE (CAT AZURE & LAPIS) ใช้ตัวช่วยของ FistHyperBase (วงพื้น ฝุ่นกลม วงกระแทก)
## มีทั้งสองตัวบนเวที: ตัวที่ออกหน้า (actor) กับคู่หู (_mate)  สีน้ำเงินของคู่ แซมสีของสาย ทรงกลมทั้งหมด ไม่มีดาว

var _mate: ChibiModel
var _mate_x := 0.0

func _begin(total: float) -> void:
	black_backdrop = true
	open_time = 0.5
	close_from = total
	end_time = total + 0.5
	Monster.hide_bars = true
	_dir = signf(hero.facing) if hero.facing != 0.0 else 1.0
	_cx = hero.position.x
	var me := "cat_" + WalkPage.pair_form
	add_actor(Vector2(_cx, 0.0), SIZE, ChibiModel.TURN * _dir, me)
	actor.sword_on = false
	_mate = ChibiModel.new()
	_mate.hero = hero
	_mate.style = "cat_" + SkillPanel.pair_partner(WalkPage.pair_form)
	_mate.stage_mode = true
	_mate.stage_turn = ChibiModel.TURN * _dir
	_mate.view_size = 1024
	add_child(_mate)
	move_child(_mate, actor.get_index())
	_mate_x = _cx - _dir * 160.0
	_mate.place_stage(Vector2(_mate_x, 0.0), SIZE)
	add_over()
	if hero.plain_model != null:
		hero.plain_model.visible = false

## วางท่าคู่หู
func _pose_mate(hand: Vector3, off: Vector3, x: float, y := 0.0, tilt := 0.0) -> void:
	if _mate == null:
		return
	_mate.stage_hand = hand
	_mate.stage_off = off
	_mate_x = x
	_mate.place_stage(Vector2(x, y), SIZE)
	_mate.rotation = tilt
