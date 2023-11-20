extends TextureProgressBar

@export var character_node : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = clamp((character_node.cur_stamina/character_node.max_stamina) * max_value, min_value, max_value)
