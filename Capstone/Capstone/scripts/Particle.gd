extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var projectResolution = OS.get_window_size()
var rng = RandomNumberGenerator.new()

var initial_position = Vector2(0, 0)
var length = 16
var width = 16
var movement = Vector2(0, 0)
var type = ""
var mass = 0
var special = false

var energy = 0

var accelerate_quarter_timer = null

func _ready():
	rng.randomize()
	accelerate_quarter_timer = Timer.new()
	add_child(accelerate_quarter_timer)

	accelerate_quarter_timer.connect("timeout", self, "_accelerate")
	accelerate_quarter_timer.set_wait_time(2.0)
	accelerate_quarter_timer.set_one_shot(false)
	accelerate_quarter_timer.start()

func _accelerate():
	if rng.randi_range(1, 2) == 1:
		increase_movement()

func increase_movement():
	var direction = Vector2(1, 1)
	if movement.x < 0:
		direction.x = -1
	if movement.y < 0:
		direction.y - -1
	set_movement(movement.x + rng.randf_range(0.0, 0.5 * direction.x),
				 movement.y + rng.randf_range(0.0, 0.5 * direction.y))

func set_initial_pos(x, y):
	initial_position = Vector2(x, y)

#func set_size(newSize):
#	size = newSize
#	var newShape = CircleShape2D.new()
#	newShape.set_extents(Vector2(size, size))
	
	
	
	#$CollisionShape2D.set_s  #et_extents(Vector2(size/16, size/16))

func set_texture(textureString):
	var texture = load("res://art/sprites/%s" % textureString)
	$Sprite.texture = texture

func set_movement(x_vel, y_vel):
	movement = Vector2(x_vel, y_vel)

func bounce():
	set_movement(-movement.x, -movement.y)
	
func elastic_collision(s_movement, c_movement, c_mass):
	
	# Vself_initial + Vself_final = Vcol_initial + Vcol_final
	# Vcol_final = Vself_final + (Vself_initial - Vcol_initial)
	# (self_mass * Vself_initial) + (col_mass * Vcol_initial) = (self_mass * Vself_final) + (col_mass * Vcol_final)
	# (self_mass * Vself_initial) + (col_mass * Vcol_initial) = (self_mass * Vself_final) + (col_mass * (Vself_final + (Vself_initial - Vcol_initial)))
	# (a * b) + (c * d) = (a * x) + (c * (x + (b - d)))
	# Vself_final = ((self_mass * Vself_initial) + (col_mass * Vcol_initial) - (col_mass * (Vself_final + (Vself_initial - Vcol_initial))) / self_mass
	var new_movement = (((-s_movement)*c_mass) + (2 * c_mass * c_movement) + (mass * s_movement)) / (mass + c_mass)
	if abs(new_movement) > 5:
		return 5 * (abs(new_movement) / new_movement)
	return new_movement

func set_movement_after_collision(collider):
	var new_x = elastic_collision(movement.x, collider.movement.x, collider.mass)
	var new_y = elastic_collision(movement.y, collider.movement.y, collider.mass)
	
	movement = Vector2(new_x, new_y)

func bounds_collision():
	var particlePos = get_global_transform_with_canvas().get_origin()

	if particlePos.x < length/2:
		set_movement(-movement.x, movement.y)
		global_position.x = length/2 + 1
	elif particlePos.x > projectResolution.x - width/2:
		set_movement(-movement.x, movement.y)
		global_position.x = projectResolution.x - width/2 - 1

	if particlePos.y < width/2:
		set_movement(movement.x, -movement.y)
		global_position.y = width/2 + 1
	elif particlePos.y > projectResolution.y - width/2:
		set_movement(movement.x, -movement.y)
		global_position.y = projectResolution.y - width/2 - 1
		#print("bounced y")
