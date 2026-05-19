extends Node


func _ready():
	# On dit au GameManager qu'on est prêt
	GameManager.current_level_index = 0

func _on_all_enemies_dead():
	# Appelé quand le dernier ennemi meurt
	GameManager.next_level()
