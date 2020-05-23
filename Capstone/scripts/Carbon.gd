extends "res://scripts/Particle.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var touching_carbon = null

# Called when the node enters the scene tree for the first time.
func set_attributes(hasRandomInitialPosition, hasRandomMovement, special = false):
	rng.randomize()
	if hasRandomInitialPosition:
		set_initial_pos(rng.randi_range(32, projectResolution.x - 32), rng.randi_range(32, projectResolution.y))
	else:
		set_initial_pos(100, 100)
	
	if hasRandomMovement:
		var speed = 2.4
		set_movement(rng.randf_range(-speed, speed), rng.randf_range(-speed, speed))
	else:
		set_movement(1.0, 1.0)
	length = 16
	width = 16
	type = "carbon"
	mass = 12
	self.special = special

func _ready():
	$Area2D.connect("area_entered", self, "_on_collision")
	set_texture("CarbonSprite.png")
	if special:
		#print(get_global_transform_with_canvas().get_origin())
		set_texture("CarbonSpriteSpecial.png")

func _on_collision(value):
	var colliding_bodies = $Area2D.get_overlapping_bodies()
	if special:
		pass
		#for collider in colliding_bodies:
		#	print(collider.type)
		#print(collider)

#func get_attributes():
#	return [Vector2(100, 100), 16, "CarbonSprite.png", true]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	bounds_collision()
	
	var collision = move_and_collide(movement)
	if collision:
		set_movement_after_collision(collision.collider)
		if collision.collider.type == "carbon" and collision.collider != self:
			touching_carbon = collision.collider
		else:
			touching_carbon = null
	else:
		touching_carbon = null
	
	
	#if collision and special:
	#	print("Collided with: " + collision.collider.type + " ", collision.collider_id)
		
