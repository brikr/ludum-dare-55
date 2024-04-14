extends Node


# wandering speed in units / sec
const SPEED = 10.0


# index of this creature type in Main scene
var index := 0

# type of creature
var creature_type: String

# region in main scene that this creature lives in
var region: Rect2

# wandering destination
var destination: Vector2
# number of seconds to wait at current destination before wandering again
var waiting: float

# Called when the node enters the scene tree for the first time.
func _ready():
  pick_destination()
  print(destination)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if waiting > 0:
    waiting -= delta
  else:
    if creature_type == "pit lord":
      # pit lords don't move, but they do flip after waiting
      var flipped = get_parent().is_flipped_h()
      get_parent().set_flip_h(!flipped)
      waiting = randf_range(3.0, 10.0)
    else:
      var current_pos = get_parent().get_global_position()
      var new_pos = current_pos.move_toward(destination, SPEED * delta)

      if destination.x < get_parent().get_global_position().x:
        # face left
        get_parent().set_flip_h(false)
      else:
        # face right
        get_parent().set_flip_h(true)

      get_parent().set_global_position(new_pos)
      if new_pos == destination:
        waiting = randf_range(3.0, 10.0)
        pick_destination()

# pick a random destination for wandering
func pick_destination():
  var top_left = region.position
  var bottom_right = region.position + region.size
  var x = randf_range(top_left.x, bottom_right.x)
  var y = randf_range(top_left.y, bottom_right.y)
  destination = Vector2(x, y)

