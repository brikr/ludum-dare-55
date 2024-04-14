extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func spawn():
  var tween = create_tween()
  tween.tween_property(self, "scale", Vector2() , 0)
  tween.tween_property(self, "scale", Vector2(1, 1), randf_range(0.3, 0.5)).set_ease(Tween.EASE_OUT)
  tween.tween_callback(start_looping_animation)


func start_looping_animation():
  var tween = create_tween()
  tween.tween_property(self, "position:y", -3, 1).as_relative().set_ease(Tween.EASE_IN)
  tween.tween_property(self, "position:y", 3, 1).as_relative().set_ease(Tween.EASE_OUT)
  tween.set_loops()
