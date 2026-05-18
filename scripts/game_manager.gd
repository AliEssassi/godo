extends Node


# Liste ordonnée de tous vos niveaux
var levels: Array[String] = [
	"res://scenes/levels/Level1.tscn",
	"res://scenes/levels/Level2.tscn",
]

var current_level_index: int = 0


# ─── Chargement ───────────────────────────────

func start_game():
	current_level_index = 0
	_load_current()

func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		_load_current()
	else:
		# Tous les niveaux terminés → écran victoire
		get_tree().change_scene_to_file(
			"res://scenes/UI/VictoryScreen.tscn"
		)

func restart_level():
	_load_current()

func _load_current():
	get_tree().change_scene_to_file(
		levels[current_level_index]
	)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
