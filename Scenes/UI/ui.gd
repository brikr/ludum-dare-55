extends CanvasLayer

signal continue_button_pressed

const RESOURCE_STRING := "%s: %s (+%s)"
const SUPPLY_STRING := "Summons: %d/%d"
const SUMMON_STRING := "%s (%d)"
const BUILDING_STRING := "%s (%d/%d)"
const NIGHT_STRING := "Night %d"
const TIMER_STRING := "Time until night: %d:%02d"
const ATTACK_SIZE_STRING := "%s: %d"

var hovered_entity := "imp"
var summary_shown := false

# Called when the node enters the scene tree for the first time.
func _ready():
  # Setup button click triggers
  for button in $SummonButtons.get_children():
    if button is Button: # (there are some spacers)
      var entity := button.name.to_lower()
      #button.pressed.connect(_on_summon_pressed.bind(entity))
      button.gui_input.connect(_on_summon_gui_input.bind(entity))
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
  $Resources/Mana.text = RESOURCE_STRING % ["Mana", format_number(GameState.get_count("mana")), format_number(GameState.get_resource_rate("mana"))]
  $Resources/Gems.text = RESOURCE_STRING % ["Soul Gems", format_number(GameState.get_count("gems")), format_number(GameState.get_resource_rate("gems"))]

  $Resources/SummonCount.text = SUPPLY_STRING % [GameState.get_supply(), GameState.get_supply_cap()]
  if GameState.get_supply() == GameState.get_supply_cap():
    $Resources/SummonCount.set("theme_override_colors/font_color", Color.RED)
  else:
    $Resources/SummonCount.set("theme_override_colors/font_color", Color.WHITE)

  $Resources/DemonPower.text = ATTACK_SIZE_STRING % ["Demon Power", GameState.get_demon_power()]

  $Info/NightCounter.text = NIGHT_STRING % GameState.current_night
  $Info/AttackSize.text = ATTACK_SIZE_STRING % ["Attack Size", Constants.ATTACK_SIZES[GameState.current_night - 1]]

  var minutes := floori(GameState.time_until_day / 60)
  var seconds := floori(GameState.time_until_day % 60)
  $Info/NightTimer.text = TIMER_STRING % [minutes, seconds]


func update_button_texts():
  for summon in Constants.SUMMON_COSTS:
    get_node("SummonButtons/%s" % summon.capitalize()).text = format_summon(summon)

  for building in Constants.BUILDING_COSTS:
    get_node("BuildingButtons/%s" % building.capitalize()).text = format_building(building)


func update_summonable_entities():
  for summon in Constants.SUMMON_COSTS:
    var button = get_node("SummonButtons/%s" % summon.capitalize())
    var affordable := GameState.can_afford(summon)
    button.set_disabled(!affordable)

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
  var name_string = "[b]%s[/b]" % hovered_entity.capitalize()

  var cost = GameState.get_cost(hovered_entity)

  var cost_lines := [name_string]
  for requirement in cost:
    var cost_line = "%d %s" % [cost[requirement], requirement.capitalize()]
    if GameState.get_count(requirement) < cost[requirement]:
      cost_line = "[color=red]%s[/color]" % cost_line
    cost_lines.append(cost_line)
  var cost_string = "\n".join(cost_lines)

  var power_string := ""
  if Constants.BASE_DEMON_POWER.has(hovered_entity):
    power_string = "Base Power: %d" % Constants.BASE_DEMON_POWER[hovered_entity]

  var gen := {}
  if Constants.BASE_GEN.has(hovered_entity):
    gen = Constants.BASE_GEN[hovered_entity]

  var gen_lines := []
  for resource in gen:
    var gen_line = "%+d %s / sec" % [gen[resource], resource.capitalize()]
    gen_lines.append(gen_line)
  var gen_string = "\n".join(gen_lines)

  var tooltip_text = "\n\n".join(
    [cost_string, power_string, gen_string, Constants.TOOLTIP_DESCRIPTIONS[hovered_entity]]
        .filter(func (str): return !str.is_empty())
  )

  $Tooltip/TooltipContent.text = tooltip_text


func show_summary(results: Dictionary):
  var key_suffix = "_survived" if results["survived"] else "_failed"

  $Summary/SummaryHeader.text = Constants.NIGHT_SUMMARY_STRINGS["header" + key_suffix]

  var bonus_lines := []
  for bonus in results.bonuses:
    var line = "[ul]%s[/ul]" % Constants.NIGHT_SUMMARY_STRINGS["bonus_" + bonus]
    bonus_lines.append(line)
  var bonuses = "\n".join(bonus_lines)
  $Summary/SummaryBonuses.text = bonuses

  $Summary/SummaryDesc.text = Constants.NIGHT_SUMMARY_STRINGS["desc" + key_suffix]

  $Summary/SummaryButton.text = Constants.NIGHT_SUMMARY_STRINGS["button" + key_suffix]

  $Summary.set_visible(true)
  summary_shown = true


# number to string; if the number is >=10k, formats in k format
func format_number(num: int) -> String:
  if num < 10000:
    return str(num)
  else:
    var k = float(num) / 1000
    return "%.1fk" % k


func _on_button_mouse_entered(entity: String):
  hovered_entity = entity
  update_tooltip_text()
  $Tooltip.visible = true
  #print("hovered %s" % entity)


func _on_button_mouse_exited(entity: String):
  $Tooltip.visible = false
  #print("left %s" % entity)


func _on_summon_pressed(creature: String):
  if !summary_shown:
    GameState.summon(creature)


func _on_summon_gui_input(event: InputEvent, creature: String):
  if event is InputEventMouseButton && !summary_shown:
    if Input.is_action_just_released("ui_left_click"):
      GameState.summon(creature)
    elif Input.is_action_just_released("ui_right_click"):
      GameState.sacrifice(creature)


func _on_building_pressed(building: String):
  if !summary_shown:
    GameState.construct_building(building)


func _on_summary_button_pressed():
  if GameState.last_night_results["survived"]:
    $Summary.set_visible(false)
    summary_shown = false
    continue_button_pressed.emit()
  else:
    get_tree().quit()
