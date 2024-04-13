extends CanvasLayer

const RESOURCE_STRING := "%s: %d (%+d)"
const SUMMON_STRING := "%s (%d)"
const BUILDING_STRING := "%s (%d/%d)"
const NIGHT_STRING := "Night %d"
const TIMER_STRING := "Time until night: %d:%02d"
const ATTACK_SIZE_STRING := "%s: %d"

var hovered_entity := "imp"

signal summon_creature

# Called when the node enters the scene tree for the first time.
func _ready():
  # Setup button click triggers
  for button in $SummonButtons.get_children():
    if button is Button: # (there are some spacers)
      var entity := button.name.to_lower()
      button.pressed.connect(_on_summon_pressed.bind(entity))
      button.mouse_entered.connect(_on_button_mouse_entered.bind(entity))
      button.mouse_exited.connect(_on_button_mouse_exited.bind(entity))

  for button in $BuildingButtons.get_children():
    if button is Button:
      var entity := button.name.to_lower()
      button.pressed.connect(_on_building_pressed.bind(entity))
      button.mouse_entered.connect(_on_button_mouse_entered.bind(entity))
      button.mouse_exited.connect(_on_button_mouse_exited.bind(entity))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  update_labels()
  update_button_texts()
  update_summonable_entities()


func tick():
  update_tooltip_text()


func update_labels():
  $Resources/Mana.text = RESOURCE_STRING % ["Mana", GameState.get_count("mana"), GameState.get_resource_rate("mana")]
  $Resources/Gems.text = RESOURCE_STRING % ["Soul Gems", GameState.get_count("gems"), GameState.get_resource_rate("gems")]
  $Resources/DemonPower.text = ATTACK_SIZE_STRING % ["Demon Power", GameState.get_demon_power()]

  $Info/NightCounter.text = NIGHT_STRING % GameState.current_night
  $Info/AttackSize.text = ATTACK_SIZE_STRING % ["Attack Size", Constants.ATTACK_SIZES[GameState.current_night]]

  var minutes := floori(GameState.time_until_night / 60)
  var seconds := floori(GameState.time_until_night % 60)
  $Info/NightTimer.text = TIMER_STRING % [minutes, seconds]


func update_button_texts():
  for summon in Constants.SUMMON_COSTS:
    get_node("SummonButtons/%s" % summon.capitalize()).text = format_summon(summon)

  for building in Constants.BUILDING_COSTS:
    get_node("BuildingButtons/%s" % building.capitalize()).text = format_building(building)


func update_summonable_entities():
  for summon in Constants.SUMMON_COSTS:
    var affordable := GameState.can_afford(summon)
    get_node("SummonButtons/%s" % summon.capitalize()).set_disabled(!affordable)

  for building in Constants.BUILDING_COSTS:
    var button = get_node("BuildingButtons/%s" % building.capitalize())
    if GameState.get_count(building) >= Constants.BUILDING_CAPS[building]:
      button.set_disabled(true)
    else:
      var affordable := GameState.can_afford(building)
      button.set_disabled(!affordable)


func format_summon(summon: String) -> String:
  var count = GameState.get_count(summon)
  if count == 0:
    return summon.capitalize()
  else:
    return SUMMON_STRING % [summon.capitalize(), count]


func format_building(building: String) -> String:
  var count = GameState.get_count(building)
  if count == 0:
    return building.capitalize()
  else:
    return BUILDING_STRING % [building.capitalize(), count, Constants.BUILDING_CAPS[building]]


func update_tooltip_text():
  var cost := {}
  if Constants.SUMMON_COSTS.has(hovered_entity):
    cost = Constants.SUMMON_COSTS[hovered_entity]
  else:
    cost = Constants.BUILDING_COSTS[hovered_entity]

  var cost_string := "\n"
  for requirement in cost:
    var cost_line = "%d %s\n" % [cost[requirement], requirement.capitalize()]
    if GameState.get_count(requirement) < cost[requirement]:
      cost_line = "[color=red]%s[/color]" % cost_line
    cost_string += cost_line

  var power_string := ""
  if Constants.BASE_DEMON_POWER.has(hovered_entity):
    power_string = "\nBase Power: %d" % Constants.BASE_DEMON_POWER[hovered_entity]

  var gen := {}
  if Constants.BASE_GEN.has(hovered_entity):
    gen = Constants.BASE_GEN[hovered_entity]

  var gen_string := "\n"
  for resource in gen:
    var gen_line = "%+d %s / sec\n" % [gen[resource], resource.capitalize()]
    gen_string += gen_line

  var tooltip_text = "[b]%s[/b]%s%s%s\n%s" % [hovered_entity.capitalize(), cost_string, power_string, gen_string, Constants.TOOLTIP_DESCRIPTIONS[hovered_entity]]
  $Tooltip/TooltipContent.text = tooltip_text


func _on_button_mouse_entered(entity: String):
  hovered_entity = entity
  update_tooltip_text()
  $Tooltip.visible = true
  #print("hovered %s" % entity)


func _on_button_mouse_exited(entity: String):
  $Tooltip.visible = false
  #print("left %s" % entity)


func _on_summon_pressed(creature: String):
  GameState.summon(creature)


func _on_building_pressed(building: String):
  GameState.construct_building(building)

