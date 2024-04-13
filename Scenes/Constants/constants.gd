extends Object


# Cost of each summon. Also source of truth for every available summon
const SUMMON_COSTS := {
  # Tier 1
  "imp": {
    "mana": 50
  },
  "hellcat": {
    "mana": 50,
    "gems": 20
  },
  # Tier 2
  "kobold": {
    "mana": 50,
    "gems": 20
  },
  "hellhound": {
    "mana": 50,
    "gems": 20,
    "hellcat": 1
  },
  # Tier 3
  "dwarf soul": {
    "mana": 100,
    "gems": 50,
    "imp": 3,
    "kobold": 2
  },
  "orc": {
    "mana": 100,
    "gems": 75,
    "imp": 3,
    "kobold": 1,
    "hellhound": 1
  },
  "lesser demon": {
    "mana": 100,
    "gems": 50,
    "imp": 5,
    "hellhound": 3
  },
  # Tier 4
  "apprentice": {
    "mana": 500,
    "gems": 250,
  },
  "abomination": {
    "mana": 250,
    "gems": 100,
    "imp": 5,
    "kobold": 2,
    "dwarf soul": 1
  },
  "black knight": {
    "mana": 250,
    "gems": 100,
    "hellhound": 3,
    "orc": 2,
    "lesser demon": 1
  },
  # Tier 5
  "disciple": {
    "mana": 1000,
    "gems": 500,
    "apprentice": 1
  },
  "pit lord": {
    "mana": 500,
    "gems": 500,
    "imps": 50
  },
  "balrog": {
    "mana": 500,
    "gems": 500,
    "lesser demon": 5,
    "black knight": 2
  }
}

const BUILDING_COSTS := {
  "rift portal": {},
  "shadow well": {},
  "soul conduit": {},
  "forbidden library": {}
}

const TOOLTIP_DESCRIPTIONS := {
  "imp": "Basic worker",
  "hellcat": "",
  "kobold": "",
  "hellhound": "",
  "dwarf soul": "",
  "orc": "",
  "lesser demon": "",
  "apprentice": "",
  "abomination": "",
  "black knight": "",
  "disciple": "",
  "pit lord": "",
  "balrog": "",
  "rift portal": "",
  "shadow well": "",
  "soul conduit": "",
  "forbidden library": ""
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
    "gems": 5
  },
  "orc": {
    "gems": 3
  },
  "abomination": {
    "gems": 10
  }
}

# Base demon power provided by entities
const BASE_DEMON_POWER := {
  "hellcat": 2,
  "hellhound": 5,
  "dwarf soul": 2,
  "orc": 7,
  "lesser demon": 10,
  "apprentice": 1,
  "abomination": 5,
  "black knight": 20,
  "disciple": 3,
  "balrog": 50
}

# Attack size at the end of each night
const ATTACK_SIZES = [
  20,
  100,
  1000
]
