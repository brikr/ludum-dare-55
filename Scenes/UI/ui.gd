extends CanvasLayer

const RESOURCE_STRING := "%s: %d"
const SUMMON_STRING := "%s (%d)"

signal summon_creature

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  update_resource_counts()
  update_button_texts()
  update_affordable_summons()

func update_resource_counts():
  $Resources/Mana.text = format_resource("mana")
  $Resources/Gems.text = format_resource("gems")

func update_button_texts():
  for summon in GameState.SUMMONS:
    get_node("SummonButtons/%s" % summon.capitalize()).text = format_summon(summon)

func update_affordable_summons():
  for summon in GameState.SUMMONS:
    var affordable := GameState.can_afford(summon)
    get_node("SummonButtons/%s" % summon.capitalize()).set_disabled(!affordable)

func _on_summon_pressed(creature: String):
  print(creature)
  GameState.summon(creature)

func format_resource(resource: String) -> String:
  return RESOURCE_STRING % [resource.capitalize(), GameState.get_count(resource)]

func format_summon(summon: String) -> String:
  return SUMMON_STRING % [summon.capitalize(), GameState.get_count(summon)]
