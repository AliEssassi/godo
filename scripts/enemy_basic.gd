extends CharacterBody2D

var health = 1
var shoot_interval = 2.5
var bullet_scene = preload("res://scenes/Bullet.tscn")

@onready var canon = $Canon
@onready var shoot_timer = $ShootTimer
@onready var bullet_spawn = $Canon/BulletSpawn

func _ready():
	shoot_timer.wait_time = shoot_interval
	shoot_timer.start()

func _process(_delta):        # ← underscore devant _delta : avertissement disparu
	_aim_at_player()

func _aim_at_player():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		canon.rotation = direction.angle()

func _shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	var direction = Vector2.from_angle(canon.rotation)
	bullet.global_position = bullet_spawn.global_position
	bullet.setup(direction, self)

func die():
	queue_free()              # ← on supprime l'ennemi d'abord
	await get_tree().process_frame   # ← on attend un frame que ce soit effectif
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		GameManager.next_level()   # ← maintenant la liste est à jour

func _on_shoot_timer_timeout():
	_shoot()
