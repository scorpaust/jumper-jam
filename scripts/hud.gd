extends Control

signal pause_game

@onready var top_bar = $TopBar
@onready var top_bar_bg = $TopBarBG
@onready var score_label = $TopBar/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top = (safe_area_top / screen_scale)
			MyUtility.add_log_msg("Screen scale: " + str(screen_scale))
		
		top_bar.position.y += safe_area_top
		var margin = 10
		top_bar_bg.size.y += safe_area_top + margin
		
		MyUtility.add_log_msg("Safe area: " + str(safe_area))
		MyUtility.add_log_msg("Window size: " + str(DisplayServer.window_get_size()))
		MyUtility.add_log_msg("safe_area_top: " + str(safe_area_top))
		MyUtility.add_log_msg("top bar pos: " + str(top_bar.position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause_button_pressed():
	SoundFx.play("Click")
	pause_game.emit()

func set_score(new_score: int):
	score_label.text = str(new_score)
