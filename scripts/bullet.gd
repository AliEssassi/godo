# bullet.gd — la balle rebondissante
extends CharacterBody2D

# ─── Paramètres ───────────────────────────────
const SPEED        = 400.0   # pixels/seconde
const MAX_BOUNCES  = 3       # comme Wii Play

var bounces_left: int = MAX_BOUNCES
var shooter        = null    # qui a tiré ? (pour ne pas s'auto-tuer)

# ─── Initialisation ───────────────────────────
func _ready():
	$LifeTimer.start()
	$LifeTimer.timeout.connect(_on_expired)

# ─── Mouvement chaque frame ───────────────────
func _physics_process(delta: float):
	# move_and_slide() retourne les collisions
	var collision = move_and_slide()

	# Si on a touché quelque chose...
	if get_slide_collision_count() > 0:
		var col = get_slide_collision(0)
		var collider = col.get_collider()

		# Est-ce un mur ? → ricochet
		if collider.is_in_group("walls"):
			_bounce(col.get_normal())

		# Est-ce un tank (et pas celui qui a tiré) ?
		elif collider.is_in_group("tanks") \
		  and collider != shooter:
			collider.die()   # le tank gère sa propre mort
			queue_free()      # la balle disparaît

# ─── Ricochet ─────────────────────────────────
func _bounce(normal: Vector2):
	bounces_left -= 1
	if bounces_left <= 0:
		queue_free()          # plus de ricochets → disparaît
		return
	# Réfléchir la vélocité par rapport à la normale du mur
	velocity = velocity.bounce(normal)

# ─── Expiration ───────────────────────────────
func _on_expired():
	queue_free()

# ─── Appelé par le tank qui tire ──────────────
func setup(direction: Vector2, owner_node: Node):
	velocity  = direction.normalized() * SPEED
	shooter   = owner_node
