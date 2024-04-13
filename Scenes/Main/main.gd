extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_pressed("ui_cancel"):
    get_tree().quit()

  update_building_visibility()


func update_building_visibility():
  # Toggle visibility on for every building node with ID less than or equal to the number we own
  for building in Constants.BUILDING_COSTS:
    var node_base_name = building.capitalize()
    for id in range(1, GameState.get_count(building) + 1):
      var node_name = "%s%d" % [node_base_name, id]
      get_node("Buildings/%s" % node_name).set_visible(true)


func _on_tick_timer_timeout():
  GameState.tick()
  $UI.tick()
