extends StaticBody2D

export (Image) var dead_sprite = null;

var regular_sprite
var is_destroyed = false

func _ready():
	add_to_group("Destroyable")
	regular_sprite = find_node("sprite").texture

func destroy():
	is_destroyed = true
	find_node("sprite").texture = dead_sprite
	
func undestroy():
	is_destroyed = false
	find_node("sprite").texture = regular_sprite
