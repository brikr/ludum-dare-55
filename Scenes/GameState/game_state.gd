extends Node

# Keeps track of game state. This node is autoloaded so every seen can peep it

const SUMMONS = ["imp", "hellcat"]

const SUMMON_COSTS := {
  "imp": {
    "mana": 20
  },
  "hellcat": {
    "mana": 20,
    "gems": 10
  }
}

var resources := {
  "mana": 0,
  "gems": 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func get_count(entity: String) -> int:
  # TODO: can i jus || here?
  if resources.has(entity):
    return resources[entity]
  else:
    return 0

func tick():
  # Mana
  resources["mana"] += 1

func can_afford(entity: String) -> bool:
  if !SUMMON_COSTS.has(entity):
    return true

  for requirement in SUMMON_COSTS[entity]:
    if !resources.has(requirement) || resources[requirement] < SUMMON_COSTS[entity][requirement]:
      return false

  return true

func summon(entity: String):
  if !resources.has(entity):
    resources[entity] = 0

  if !can_afford(entity):
    return

  # Pay for entity
  for requirement in SUMMON_COSTS[entity]:
    resources[requirement] -= SUMMON_COSTS[entity][requirement]

  # Give the new lad
  resources[entity] += 1
  print(resources)
