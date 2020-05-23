extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var carbon = preload("res://scenes/Carbon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var carbon = carbon.instance()
	add_child(carbon)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
