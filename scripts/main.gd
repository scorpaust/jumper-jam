extends Node

@onready var game = $Game
@onready var screens = $Screens

var game_in_progress: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundFx.play("Title")
	DisplayServer.window_set_window_event_callback(_on_window_event)
	screens.start_game.connect(_on_screens_start_game, CONNECT_PERSIST)
	screens.delete_level.connect(_on_screens_delete_level, CONNECT_PERSIST)
	game.player_died.connect(_on_game_player_died, CONNECT_PERSIST)
	game.pause_game.connect(_on_game_pause_game, CONNECT_PERSIST)
	
	#IAP Signals
	screens.purchase_skin.connect(_on_screens_purchase_skin)

func _on_screens_purchase_skin():
	if game.new_skin_unlocked == false:
		game.new_skin_unlocked = true

func _on_window_event(event):
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			MyUtility.addLogMessage("Focus In")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			MyUtility.addLogMessage("Focus Out")
			if game_in_progress == true && !get_tree().paused:
				_on_game_pause_game()
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()

func _on_game_pause_game():
	get_tree().paused = true
	SoundFx.stop_sound("Level")
	screens.pause_game()

func _on_game_player_died(score, highscore):
	game_in_progress = false
	SoundFx.stop_sound("Level")
	await (get_tree().create_timer(0.75).timeout)
	screens.game_over(score, highscore)
	
func _on_screens_start_game():
	game_in_progress = true
	SoundFx.stop_sound("Title")
	SoundFx.play("Level")
	game.new_game()

func _on_screens_delete_level():
	game_in_progress = false
	SoundFx.stop_sound("Level")
	game.reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
