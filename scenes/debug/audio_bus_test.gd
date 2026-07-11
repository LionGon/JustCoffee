extends Control
## Dev scene: audio buses + saturation muffling on Ambience (ISSUE-501).

@onready var _status_label: Label = $VBox/StatusLabel
@onready var _ambience_player: AudioStreamPlayer = $AmbiencePlayer

const MIX_RATE: int = 44100
const BUFFER_LENGTH: float = 0.5
const NOISE_AMPLITUDE: float = 0.3

var _playback: AudioStreamGeneratorPlayback


func _ready() -> void:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = MIX_RATE
	stream.buffer_length = BUFFER_LENGTH
	_ambience_player.stream = stream
	_ambience_player.bus = "Ambience"
	_ambience_player.volume_db = 6.0
	_ambience_player.play()
	call_deferred("_init_playback")
	EventBus.saturation_changed.connect(_on_saturation_changed)
	_refresh()


func _init_playback() -> void:
	_playback = _ambience_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if _playback == null:
		push_error("audio_bus_test: failed to get AudioStreamGeneratorPlayback")
	_refresh()


func _process(_delta: float) -> void:
	if _playback == null:
		return
	var frames_available: int = _playback.get_frames_available()
	if frames_available <= 0:
		return
	var buffer := PackedVector2Array()
	buffer.resize(frames_available)
	for i: int in frames_available:
		var sample: float = randf_range(-NOISE_AMPLITUDE, NOISE_AMPLITUDE)
		buffer[i] = Vector2(sample, sample)
	_playback.push_buffer(buffer)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var physical: Key = (event as InputEventKey).physical_keycode
		var logical: Key = (event as InputEventKey).keycode
		if physical in [KEY_EQUAL, KEY_KP_ADD, KEY_UP] or logical in [KEY_EQUAL, KEY_KP_ADD, KEY_UP]:
			SaturationManager.add_saturation(0.1, "audio_test")
			_refresh()
		elif physical in [KEY_MINUS, KEY_KP_SUBTRACT, KEY_DOWN] or logical in [KEY_MINUS, KEY_KP_SUBTRACT, KEY_DOWN]:
			SaturationManager.reduce_saturation(0.1, "audio_test")
			_refresh()
		elif physical == KEY_0 or logical == KEY_0:
			SaturationManager.apply_cycle_opening_reset(0)
			_refresh()


func _on_saturation_changed(_level: float) -> void:
	_refresh()


func _refresh() -> void:
	var cutoff: float = AudioSaturationController.get_ambience_cutoff_hz()
	var bus_ok: bool = AudioServer.get_bus_index("Ambience") >= 0
	var playing: bool = _ambience_player.playing
	var playback_ok: bool = _playback != null
	_status_label.text = (
		"Saturation %.2f · Ambience low-pass %.0f Hz\n"
		% [SaturationManager.saturation_level, cutoff]
		+ "Ambience bus: %s · Player: %s · Buffer: %s\n"
		% [
			"OK" if bus_ok else "MISSING — reload project",
			"playing" if playing else "stopped",
			"OK" if playback_ok else "waiting",
		]
		+ "↑/+ = more saturation (muffled) · ↓/- = less · 0 = reset\n"
		+ "Speakers or headphones both work — no activation needed"
	)
