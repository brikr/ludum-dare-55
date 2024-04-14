extends Object


var abomination = preload("res://Scenes/Entities/Abomination/abomination.tscn")
var apprentice = preload("res://Scenes/Entities/Apprentice/apprentice.tscn")
var balrog = preload("res://Scenes/Entities/Balrog/balrog.tscn")
var black_knight = preload("res://Scenes/Entities/BlackKnight/black_knight.tscn")
var demon_brute = preload("res://Scenes/Entities/DemonBrute/demon_brute.tscn")
var disciple = preload("res://Scenes/Entities/Disciple/disciple.tscn")
var dwarf_soul = preload("res://Scenes/Entities/DwarfSoul/dwarf_soul.tscn")
var hellhound = preload("res://Scenes/Entities/Hellhound/hellhound.tscn")
var imp = preload("res://Scenes/Entities/Imp/imp.tscn")
var kobold = preload("res://Scenes/Entities/Kobold/kobold.tscn")
var orc = preload("res://Scenes/Entities/Orc/orc.tscn")
var pit_lord = preload("res://Scenes/Entities/PitLord/pit_lord.tscn")

var packed_creatures := {
  "abomination": abomination,
  "apprentice": apprentice,
  "balrog": balrog,
  "black knight": black_knight,
  "demon brute": demon_brute,
  "disciple": disciple,
  "dwarf soul": dwarf_soul,
  "hellhound": hellhound,
  "imp": imp,
  "kobold": kobold,
  "orc": orc,
  "pit lord": pit_lord
}

var crystal = preload("res://Scenes/Entities/Crystal/crystal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
