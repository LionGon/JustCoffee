extends Node
## Applies high-frequency muffling to Ambience bus as saturation rises (RULES.md §6.1, §10).

const AMBIENCE_BUS_NAME: String = "Ambience"
const INNER_MONOLOGUE_BUS_NAME: String = "Inner_Monologue"

const CUT_OFF_CLEAR: float = 20500.0
const CUT_OFF_MUFFLED: float = 650.0

var _ambience_bus_index: int = -1
var _low_pass_effect_index: int = -1


func _ready() -> void:
	_ambience_bus_index = AudioServer.get_bus_index(AMBIENCE_BUS_NAME)
	if _ambience_bus_index < 0:
		push_error("AudioSaturationController: missing '%s' bus" % AMBIENCE_BUS_NAME)
		return
	_ensure_low_pass_effect()
	_configure_inner_monologue_bus()
	EventBus.saturation_changed.connect(_on_saturation_changed)


func _ensure_low_pass_effect() -> void:
	for i: int in AudioServer.get_bus_effect_count(_ambience_bus_index):
		var effect: AudioEffect = AudioServer.get_bus_effect(_ambience_bus_index, i)
		if effect is AudioEffectLowPassFilter:
			_low_pass_effect_index = i
			return
	var low_pass := AudioEffectLowPassFilter.new()
	low_pass.cutoff_hz = CUT_OFF_CLEAR
	low_pass.resonance = 0.5
	_low_pass_effect_index = AudioServer.get_bus_effect_count(_ambience_bus_index)
	AudioServer.add_bus_effect(_ambience_bus_index, low_pass)


func _configure_inner_monologue_bus() -> void:
	var bus_index: int = AudioServer.get_bus_index(INNER_MONOLOGUE_BUS_NAME)
	if bus_index < 0:
		push_warning("AudioSaturationController: missing '%s' bus" % INNER_MONOLOGUE_BUS_NAME)
		return
	AudioServer.set_bus_volume_db(bus_index, 0.0)


func get_ambience_cutoff_hz() -> float:
	if _ambience_bus_index < 0 or _low_pass_effect_index < 0:
		return -1.0
	var effect: AudioEffect = AudioServer.get_bus_effect(_ambience_bus_index, _low_pass_effect_index)
	if effect is AudioEffectLowPassFilter:
		return (effect as AudioEffectLowPassFilter).cutoff_hz
	return -1.0


func _on_saturation_changed(level: float) -> void:
	if _ambience_bus_index < 0 or _low_pass_effect_index < 0:
		return
	var effect: AudioEffect = AudioServer.get_bus_effect(_ambience_bus_index, _low_pass_effect_index)
	if effect is AudioEffectLowPassFilter:
		var low_pass: AudioEffectLowPassFilter = effect as AudioEffectLowPassFilter
		low_pass.cutoff_hz = lerpf(CUT_OFF_CLEAR, CUT_OFF_MUFFLED, clampf(level, 0.0, 1.0))
