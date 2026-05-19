extends CharacterBody2D

var speed = 150
var shoot_cooldown = 0.4
var can_shoot = true
var bullet_scene = preload("res://scenes/Bullet.tscn")

@onready var canon = $Canon
@onready var bullet_spawn = $Canon/BulletSpawn

func _ready():
	add_to_group("player")

func _physics_process(_delta):
	_move()
	_aim()
	if Input.is_action_just_pressed("shoot") and can_shoot:
		_shoot()
	move_and_slide()

func _move():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	velocity = direction.normalized() * speed

func _aim():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	canon.rotation = direction.angle()

func _shoot():
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	var direction = Vector2.from_angle(canon.rotation)
	bullet.global_position = bullet_spawn.global_position
	bullet.setup(direction, self)
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func die():
	GameManager.restart_level()
