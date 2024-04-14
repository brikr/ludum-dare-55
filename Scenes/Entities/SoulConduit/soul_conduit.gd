extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func spawn():
  var tween = create_tween()
  tween.tween_property(self, "scale:y", 0 , 0)
  tween.tween_property(self, "scale:y", 1, randf_range(0.3, 0.5)).set_ease(Tween.EASE_OUT)
  tween.tween_callback(shake)


func shake():
  var tween = create_tween()
  tween.tween_property(self, "position:x", randf_range(-1, 1), 0.1).as_relative()
  tween.tween_property(self, "position:x", 0, 0.1).as_relative().from_current()
  tween.tween_callback(shake)
