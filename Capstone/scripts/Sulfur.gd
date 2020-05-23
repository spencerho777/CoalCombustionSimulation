extends "res://scripts/Particle.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func set_attributes(hasRandomInitialPosition, hasRandomMovement, special = false):
	rng.randomize()
	if hasRandomInitialPosition:
		set_initial_pos(rng.randi_range(32, projectResolution.x - 32), rng.randi_range(32, projectResolution.y))
	else:
		set_initial_pos(100, 100)
	
	if hasRandomMovement:
		var speed = 1.0
		set_movement(rng.randf_range(-speed, speed), rng.randf_range(-speed, speed))
	else:
		set_movement(1.0, 1.0)
	length = 32
	width = 32
	type = "sulfur"
	mass = 32
	self.special = special

func _ready():
	set_texture("SulfurSprite.png")

#func get_attributes():
#	return [Vector2(100, 100), 16, "CarbonSprite.png", true]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	bounds_collision()
	
	var collision = move_and_collide(movement)
	if collision:
		set_movement_after_collision(collision.collider)
	
	#if collision and special:
	#	print("Collided with: " + collision.collider.type + " ", collision.collider_id)
		
