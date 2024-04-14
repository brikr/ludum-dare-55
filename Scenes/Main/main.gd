extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
  GameState.night_ended.connect(_on_night_ended)
  GameState.summon_count_changed.connect(_on_summon_count_changed)
  GameState.building_constructed.connect(_on_building_constructed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_pressed("ui_cancel"):
    get_tree().quit()


func spawn_crystals():
  var rect = $MineRegion/CollisionShape2D.get_shape().get_rect()
  var global_rect = Rect2($MineRegion/CollisionShape2D.global_position + rect.position, rect.size)

  var top_left = global_rect.position
  var bottom_right = global_rect.position + global_rect.size

  for i in range(30):
    var node = Preloaded.crystal.instantiate()

    # pick a random spot in the rect
    var x = randf_range(top_left.x, bottom_right.x)
    var y = randf_range(top_left.y, bottom_right.y)

    node.set_global_position(Vector2(x, y))

    $Entities.add_child(node)


func place_creature(creature: String, node: Node2D):
  # get the region for the creature
  var collision_shape = get_node("%s/CollisionShape2D" % Constants.PLACEMENT_REGIONS[creature])
  var rect = collision_shape.get_shape().get_rect()
  var global_rect = Rect2(collision_shape.global_position + rect.position, rect.size)

  # reduce the rectangle so the creature doesn't go outside it
  var creature_size = node.get_texture().get_size()
  var top_left = global_rect.position
  var bottom_right = global_rect.position + global_rect.size
  # left/right each move inward by half the creature's width
  top_left.x += creature_size.x / 2
  bottom_right.x -= creature_size.x / 2
  # top moves down by creature height
  top_left.y += creature_size.y

  # pick a random spot in the rect
  var x = randf_range(top_left.x, bottom_right.x)
  var y = randf_range(top_left.y, bottom_right.y)

  node.set_global_position(Vector2(x, y))

  # tell the creature component this bounding rectangle
  node.get_node("CreatureComponent").region = Rect2(top_left, bottom_right - top_left)

  $Entities.add_child(node)


func _on_night_ended(results: Dictionary):
  $TickTimer.stop()
  if results.won:
    $UI.show_win_screen()
  else:
    $UI.show_summary(results)


func _on_summon_count_changed(creature: String, count: int):
  # Ensure every creature node up to count exists
  for idx in range(1, count + 1):
    var node = get_node_or_null("Entities/%s%d" % [creature.capitalize(), idx])
    if node == null:
      node = Preloaded.packed_creatures[creature].instantiate()
      node.set_name("%s%d" % [creature.capitalize(), idx])
      # Special index field to make removal easier
      node.get_node("CreatureComponent").creature_type = creature
      node.get_node("CreatureComponent").index = idx

      place_creature(creature, node)

  # Delete every creature node above count
  for node in $Entities.get_children():
    if node.name.begins_with(creature.capitalize()):
      if node.get_node("CreatureComponent").index > count:
        node.queue_free()


func _on_building_constructed(building: String, count: int):
  var node_name = "%s%d" % [building.capitalize(), count]
  get_node("Entities/%s" % node_name).set_visible(true)


func _on_tick_timer_timeout():
  GameState.tick()
  $UI.tick()


func _on_ui_continue_button_pressed():
  GameState.current_night += 1
  $TickTimer.start()


func _on_ui_start_button_pressed():
  $TickTimer.start()
