extends "res://scripts/Particle.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var body_entered = []

var _timer = null

# Called when the node enters the scene tree for the first time.
func set_attributes(hasRandomInitialPosition, hasRandomMovement, special = false):
	rng.randomize()
	if hasRandomInitialPosition:
		set_initial_pos(rng.randi_range(32, projectResolution.x - 32), rng.randi_range(32, projectResolution.y))
	else:
		set_initial_pos(100, 100)
	
	if hasRandomMovement:
		var speed = 2
		set_movement(rng.randf_range(-speed, speed), rng.randf_range(-speed, speed))
	else:
		set_movement(1.0, 1.0)
	length = 32
	width = 18
	type = "oxygen"
	mass = 31.998
	self.special = special

func _ready():
	#$Area2D.connect("body_entered", self, "_on_collision")
	#$Area2D.connect("area_entered", self, "_on_collision")
	
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_self_destruct")
	_timer.set_wait_time(4.0)
	_timer.set_one_shot(true) # Make sure it loops
	
	set_texture("OxygenSprite.png")
	if special:
	#	print(get_global_transform_with_canvas().get_origin())
		set_texture("OxygenSprite.png")

func _self_destruct():
	hide()
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D2.disabled = true
	#queue_free()

func _on_collision():
	var colliding_bodies = $Area2D.get_overlapping_bodies()
	
	var colliding_bodies_type = {
		"carbon": [],
		"oxygen": [],
		"hydrogen": [],
		"sulfur": [],
		"sulfurdioxide": [],
		"water": [],
		"carbondioxide": [],
		"carbonmonoxide": []}
	if special:
		#print("COLLIDING BODIES LENGTH: ", len($Area2D.get_overlapping_bodies()))
		#print("double trouble")
		for body in range(len(colliding_bodies)):
			if colliding_bodies[body] == self:
				continue
			#print(body+2, " ", colliding_bodies, colliding_bodies[body].type)
			#colliding_bodies[body].queue_free()
			colliding_bodies_type[colliding_bodies[body].type].append(body)
				
		var carbons = colliding_bodies_type["carbon"]
		var oxygens = colliding_bodies_type["oxygen"]
		var hydrogens = colliding_bodies_type["hydrogen"]
		var sulfurs = colliding_bodies_type["sulfur"]
		#print("C", carbons)
		#print("O", oxygens)
		if type == "oxygen":
			var change = false
			
			if not change and len(carbons) > 0:
				var firstCarbon = colliding_bodies[carbons[0]]
				if firstCarbon.touching_carbon:
					#print("Carbon Monoxide")
					firstCarbon.touching_carbon.queue_free()
					become_carbon_monoxide()
				elif len(carbons) > 1:
					#print("Carbon Monoxide")
					colliding_bodies[carbons[1]].queue_free()
					become_carbon_monoxide()
				else:
					#print("Carbon Dioxide")
					become_carbon_dioxide()
				
				firstCarbon.queue_free()
				_timer.start()
				change = true
				
			if not change and len(hydrogens) > 0:
				var firstHydrogen = colliding_bodies[hydrogens[0]]
				if firstHydrogen.touching_hydrogen:
					firstHydrogen.touching_hydrogen.queue_free()
					change = true
				elif len(hydrogens) > 1:
					colliding_bodies[hydrogens[1]].queue_free()
					change = true
				
				if change:
					#print("Water")
					firstHydrogen.queue_free()
					become_water()
					_timer.start()
					
			if not change and len(sulfurs) > 0:
				#print("Sulfur Dioxide")
				colliding_bodies[sulfurs[0]].queue_free()
				become_sulfur_dioxide()
				_timer.start()
				change = true
				
			

func become_sulfur_dioxide():
	set_texture("SulfurDioxideSprite.png")
	type = "sulfurdioxide"
	energy += 296
	length = 40
	width = 34
	mass= 64
	bounce()

func become_water():
	set_texture("WaterSprite.png")
	type = "water"
	energy += 572 # (286 * 2)
	length = 22
	width = 18
	mass = 18
	bounce()

func become_carbon_monoxide():
	set_texture("CarbonMonoxideSprite.png")
	type = "carbonmonoxide"
	energy += 283
	length = 27
	width = 17
	mass = 28
	bounce()

func become_carbon_dioxide():
	set_texture("CarbonDioxideSprite.png")
	type = "carbondioxide"
	energy += 393
	length = 36
	width = 24
	mass = 44
	bounce()

#func get_attributes():
#	return [Vector2(100, 100), 16, "CarbonSprite.png", true]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	bounds_collision()
	
	var collision = move_and_collide(movement)
	if collision:
		set_movement_after_collision(collision.collider)
		_on_collision()
	
	#if collision and special:
	#	print("Collided with: " + collision.collider.type + " ", collision.collider_id)
		

