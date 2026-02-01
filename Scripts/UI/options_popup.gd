extends Control

@onready var music_slider: HSlider = $PanelContainer/VBoxContainer/MusicContainer/MusicSlider
@onready var sound_slider: HSlider = $PanelContainer/VBoxContainer/SoundContainer/SoundSlider
@onready var language_selector: OptionButton = $PanelContainer/VBoxContainer/LanguageContainer/OptionButton

func _ready() -> void:
	# Connect signals
	language_selector.item_selected.connect(_on_language_selected)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sound_slider.value_changed.connect(_on_sfx_volume_changed)

	# Set current language
	var current_locale = TranslationServer.get_locale()
	if current_locale.begins_with("es"):
		language_selector.selected = 0
	else:
		language_selector.selected = 1

	# Set current audio volumes
	music_slider.value = AudioManager.get_music_volume()
	sound_slider.value = AudioManager.get_sfx_volume()

func _on_language_selected(index: int) -> void:
	match index:
		0:  # Spanish
			TranslationServer.set_locale("es")
		1:  # English
			TranslationServer.set_locale("en")

func _on_music_volume_changed(value: float) -> void:
	AudioManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
