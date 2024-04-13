extends Node

# Keeps track of game state. This node is autoloaded so every seen can peep it


# Current resource/entity counts
var arsenal := {
  "mana": 0,
  "gems": 0,

  # DEBUG
  #"hellcat": 2
}

var current_night := 1
var time_until_night := 180


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func tick():
  # Base mana
  arsenal["mana"] += Constants.BASE_MANA_REGEN

  # Resources from entities
  for entity in arsenal:
    # If this entity generates resources
    if Constants.BASE_GEN.has(entity):
      # Add each resource it generates per tick * the count we have
      for resource in Constants.BASE_GEN[entity]:
        arsenal[resource] += Constants.BASE_GEN[entity][resource] * arsenal[entity]

  # Subtract time
  time_until_night -= 1
  # Maybe go to day
  if time_until_night <= 0:
    pass


func summon(entity: String):
  if !arsenal.has(entity):
    arsenal[entity] = 0

  if !can_afford(entity):
    return

  # Pay for entity
  for requirement in Constants.SUMMON_COSTS[entity]:
    arsenal[requirement] -= Constants.SUMMON_COSTS[entity][requirement]

  # Give the new lad
  arsenal[entity] += 1
  print(arsenal)


func construct_building(building: String):
  if !arsenal.has(building):
    arsenal[building] = 0

  if !can_afford(building):
    return

  if arsenal[building] >= Constants.BUILDING_CAPS[building]:
    return

  # Pay for building
  for requirement in Constants.BUILDING_COSTS[building]:
    arsenal[requirement] -= Constants.BUILDING_COSTS[building][requirement]

  # Give the build
  arsenal[building] += 1
  print(arsenal)


func get_count(entity: String) -> int:
  if arsenal.has(entity):
    return arsenal[entity]
  else:
    return 0


func can_afford(entity: String) -> bool:
  var cost := {}
  if Constants.SUMMON_COSTS.has(entity):
    cost = Constants.SUMMON_COSTS[entity]
  elif Constants.BUILDING_COSTS.has(entity):
    cost = Constants.BUILDING_COSTS[entity]
  else:
    return true

  for requirement in cost:
    if !arsenal.has(requirement) || arsenal[requirement] < cost[requirement]:
      return false

  return true


func get_demon_power() -> int:
  var demon_power := 0

  for entity in arsenal:
    if Constants.BASE_DEMON_POWER.has(entity):
      demon_power += Constants.BASE_DEMON_POWER[entity] * arsenal[entity]

  return demon_power


# Returns how much of a resource you get each second based on your current arsenal
func get_resource_rate(resource: String) -> int:
  var delta := 0
  if resource == "mana":
    delta += Constants.BASE_MANA_REGEN

  for entity in arsenal:
    # If this entity generates resources
    if Constants.BASE_GEN.has(entity):
      # Add each resource it generates per tick * the count we have
      if Constants.BASE_GEN[entity].has(resource):
        delta += Constants.BASE_GEN[entity][resource] * arsenal[entity]

  return delta


func get_supply() -> int:
  var count := 0
  for creature in Constants.SUMMON_COSTS:
    count += get_count(creature)
  return count


func get_supply_cap() -> int:
  return get_count("rift portal") * 10 + 10

