class_name GameSettings
extends RefCounted
## ค่าตั้งของผู้เล่น เก็บแยกไฟล์จากเซฟตัวละคร: ความดังเพลง/เสียง สั่น ความโปร่งและขนาดปุ่ม

const PATH := "user://settings.cfg"
const ALPHAS := [0.5, 0.7, 1.0]          # ความโปร่งช่องสกิลตอนไม่ได้แตะ
const SIZES := [0.85, 1.0, 1.15]         # ขนาดปุ่มขวาล่าง เล็ก กลาง ใหญ่
const SIZE_NAMES := ["เล็ก", "กลาง", "ใหญ่"]

static var music := 0.6
static var sfx := 0.8
static var vibrate := true
static var alpha_i := 0                  # 0 = 50% (ค่าเดิมของเกม)
static var size_i := 1                   # 1 = กลาง (ขนาดเดิม)
static var _loaded := false

static func ensure() -> void:
	if _loaded:
		return
	_loaded = true
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	music = clampf(float(cfg.get_value("audio", "music", music)), 0.0, 1.0)
	sfx = clampf(float(cfg.get_value("audio", "sfx", sfx)), 0.0, 1.0)
	vibrate = bool(cfg.get_value("input", "vibrate", vibrate))
	alpha_i = clampi(int(cfg.get_value("pad", "alpha", alpha_i)), 0, ALPHAS.size() - 1)
	size_i = clampi(int(cfg.get_value("pad", "size", size_i)), 0, SIZES.size() - 1)

static func save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", music)
	cfg.set_value("audio", "sfx", sfx)
	cfg.set_value("input", "vibrate", vibrate)
	cfg.set_value("pad", "alpha", alpha_i)
	cfg.set_value("pad", "size", size_i)
	cfg.save(PATH)

static func pad_alpha() -> float:
	ensure()
	return ALPHAS[alpha_i]

static func pad_scale() -> float:
	ensure()
	return SIZES[size_i]
