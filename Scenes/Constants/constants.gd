extends Object


const BASE_MANA_REGEN := 5


# Cost of each summon. Also source of truth for every available summon
const SUMMON_COSTS := {
  # Tier 1
  "imp": {
    "mana": 50
  },
  # Tier 2
  "kobold": {
    "mana": 50,
    "gems": 20
  },
  "hellhound": {
    "mana": 50,
    "gems": 20,
  },
  # Tier 3
  "dwarf soul": {
    "mana": 100,
    "gems": 50,
    "imp": 2,
    "kobold": 1
  },
  "orc": {
    "mana": 100,
    "gems": 75,
    "kobold": 1,
    "hellhound": 1
  },
  "demon brute": {
    "mana": 100,
    "gems": 50,
    "imp": 3,
    "hellhound": 2
  },
  # Tier 4
  "apprentice": {
    "gems": 250,
  },
  "abomination": {
    "mana": 250,
    "gems": 100,
    "imp": 5,
    "dwarf soul": 1
  },
  "black knight": {
    "mana": 250,
    "gems": 200,
    "orc": 1,
    "demon brute": 1
  },
  # Tier 5
  "disciple": {
    "gems": 500,
    "apprentice": 1
  },
  "pit lord": {
    "mana": 500,
    "gems": 1000,
    "imp": 50
  },
  "balrog": {
    "mana": 500,
    "gems": 2000,
    "demon brute": 5,
    "black knight": 2
  }
}

const BUILDING_COSTS := {
  "rift portal": {
    "gems": 500
  },
  "shadow well": {
    "gems": 500
  },
  "soul conduit": {
    "gems": 250
  },
  "dark library": {
    "gems": 2000
  }
}

const BUILDING_CAPS := {
  "rift portal": 10,
  "shadow well": 10,
  "soul conduit": 5,
  "dark library": 1
}

const TOOLTIP_DESCRIPTIONS := {
  "imp": "A basic worker. Mines soul gems slowly but doesn't complain about it. Used as a sacrifice for a lot of more powerful summons.",
  "kobold": "A natural miner, but very weak. It won't stand a chance against an attacking adventurer.",
  "hellhound": "A wild, untrained demon. Point it at the enemy and let it loose.",
  "dwarf soul": "A twisted remnant of a once proud dwarven miner, now enslaved by dark magic. The energy from this tormented soul also helps fuel your mana.",
  "orc": "Born from demonic ancestors, the orcs are a versatile race capable of mining resources and defending from attackers.",
  "demon brute": "A large and powerful monstrosity fueled by raw aggression.",
  "apprentice": "An apprentice summoner that's relatively new to the dark arts. Using their own mana pool, they will summon an Imp every 10 seconds.",
  "abomination": "A disgusting amalgamation of muscle and bone. It lacks the intelligence and versatility to excel in combat, but its pure strength makes it an excellence miner.",
  "black knight": "A fallen champion in plate armor. One of the best warriors in history, now under control by dark magic.",
  "disciple": "Spend some resources training an apprentice. Once they are a disciple, they will summon Imps, Hellhounds, and Kobolds.",
  "pit lord": "+1 Power to all summons\n\nA commander of the infernal legions. Its prowess in warfare increases the demon power of every summon in your army.",
  "balrog": "An ancient and powerful demon of fire and shadow. The strongest demon among the infernal ranks.",
  "rift portal": "+10 Summon limit\n\nOpens another channel into the void, allowing you to summon more creatures into this world.",
  "shadow well": "A pool of darkness swirling with malevolent energy, allowing you access to faster mana regeneration.",
  "soul conduit": "-10% Soul Gem costs\n\nA literal highway to hell. With direct access to the pool of souls in the underworld, all of your soul gem costs are reduced. This effect stacks.",
  "dark library": "2x summons from Apprentices and Diciples\n\nA repository of forbidden knowledge and untold power."
}

# Base resources generated by each summon per tick
const BASE_GEN := {
  "imp": {
    "gems": 1
  },
  "kobold": {
    "gems": 2
  },
  "dwarf soul": {
    "mana": 1,
    "gems": 5
  },
  "orc": {
    "gems": 3
  },
  "abomination": {
    "gems": 10
  },
  "shadow well": {
    "mana": 5
  }
}

# Base demon power provided by entities
const BASE_DEMON_POWER := {
  "hellhound": 5,
  "dwarf soul": 2,
  "orc": 7,
  "demon brute": 10,
  "apprentice": 1,
  "abomination": 5,
  "black knight": 20,
  "disciple": 3,
  "pit lord": 10,
  "balrog": 100
}

# Which region each creature type should be placed in
const PLACEMENT_REGIONS := {
  "imp": "MineRegion",
  "kobold": "MineRegion",
  "hellhound": "ArmyRegion",
  "dwarf soul": "MineRegion",
  "orc": "MineRegion",
  "demon brute": "ArmyRegion",
  "apprentice": "SummonerRegion",
  "abomination": "MineRegion",
  "black knight": "ArmyRegion",
  "disciple": "SummonerRegion",
  "pit lord": "ArmyRegion",
  "balrog": "ArmyRegion"
}

# Attack size at the end of each night
const ATTACK_SIZES = [
  20,
  100,
  500,
  1000
]

const NIGHT_SUMMARY_STRINGS := {
  "header_survived": "You defeated the attacking adventurers",
  "header_failed": "The adventurers have defeated your dark army",
  "desc_survived": "You should spend the next night preparing for another attack.",
  "desc_failed": "Better luck next time!",
  "button_survived": "Continue",
  "button_failed": "Exit",
  "bonus_gems": "Your army captures the adventurers' essence and convert them to 500 gems.",
  "bonus_dwarf soul": "A dwarven adventurer's soul was intercepted on its way to the afterlife and has been put to work in the mines.",
  "bonus_black knight": "A strong warrior among the adventuring party succumbed to your magic and has joined the army as a Black Knight.",
  "bonus_apprentice": "An adventurer has seen the power of your army and decided to join you as an Apprentice.",
  "bonus_time": "The dark forces shift cosmic entities in your favor. The next night will last longer."
}

const BONUS_PROBABILITY := {
  "gems": 0.5,
  "dwarf soul": 0.3,
  "time": 0.3,
  "apprentice": 0.2,
  "black knight": 0.1
}
