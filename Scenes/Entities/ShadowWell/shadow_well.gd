extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func spawn():
  var tween = create_tween()
  tween.tween_property(self, "modulate:a", 0 , 0)
  tween.tween_property(self, "modulate:a", 1, randf_range(0.3, 0.5)).set_ease(Tween.EASE_OUT)
