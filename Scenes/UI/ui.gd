extends CanvasLayer

const RESOURCE_STRING := "%s: %d"
const SUMMON_STRING := "%s (%d)"
const NIGHT_STRING := "Night %d"
const TIMER_STRING := "Time until night: %d:%02d"
const ATTACK_SIZE_STRING := "Attack Size: %d"

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
  update_affordable_summons()


func update_labels():
  $Resources/Mana.text = RESOURCE_STRING % ["Mana", GameState.get_count("mana")]
  $Resources/Gems.text = RESOURCE_STRING % ["Soul Gems", GameState.get_count("gems")]
  $Resources/DemonPower.text = RESOURCE_STRING % ["Demon Power", GameState.get_demon_power()]

  $Info/NightCounter.text = NIGHT_STRING % GameState.current_night
  $Info/AttackSize.text = ATTACK_SIZE_STRING % Constants.ATTACK_SIZES[GameState.current_night]

  var minutes := floori(GameState.time_until_night / 60)
  var seconds := floori(GameState.time_until_night % 60)
  $Info/NightTimer.text = TIMER_STRING % [minutes, seconds]


func update_button_texts():
  for summon in Constants.SUMMON_COSTS:
    get_node("SummonButtons/%s" % summon.capitalize()).text = format_summon(summon)


func update_affordable_summons():
  for summon in Constants.SUMMON_COSTS:
    var affordable := GameState.can_afford(summon)
    get_node("SummonButtons/%s" % summon.capitalize()).set_disabled(!affordable)


func format_summon(summon: String) -> String:
  return SUMMON_STRING % [summon.capitalize(), GameState.get_count(summon)]


func _on_button_mouse_entered(entity: String):
  $Tooltip.visible = true
  #print("hovered %s" % entity)


func _on_button_mouse_exited(entity: String):
  $Tooltip.visible = false
  #print("left %s" % entity)


func _on_summon_pressed(creature: String):
  GameState.summon(creature)


func _on_building_pressed(building: String):
  GameState.construct_building(building)

