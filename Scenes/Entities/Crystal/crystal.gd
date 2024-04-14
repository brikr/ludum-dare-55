extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
  # Choose a random sprite to be visible
  var visible_sprite = randi_range(1, 4)
  get_node("Sprite%d" % visible_sprite).set_visible(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
