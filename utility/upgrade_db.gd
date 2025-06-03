extends Node

const ICON_PATH = "res://Item/Upgrades/"
const WEAPON_PATH = "res://Item/Weapons/"

const UPGRADES = {
	"banana1": {
		"icon": WEAPON_PATH + "poop.png",
		"displayname": "Cocô",
		"details": "Duas vezes mais fedido",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"banana2": {
		"icon": WEAPON_PATH + "poop.png",
		"displayname": "Cocô",
		"details": "Consistência mais aerodinâmica que dá propriedades de velocidade e um impacto avassalador, arremessando os inimigos para longe.",
		"level": "Level: 2",
		"prerequesite": ["banana1"],
		"type": "weapon"
	},
	"banana3": {
		"icon": WEAPON_PATH + "poop.png",
		"displayname": "Cocô",
		"details": "É maior, É melhor",
		"level": "Level: 3",
		"prerequesite": ["banana2"],
		"type": "weapon"
	},
	"banana4": {
		"icon": WEAPON_PATH + "poop.png",
		"displayname": "Cocô",
		"details": "",
		"level": "Level: 4",
		"prerequesite": ["banana3"],
		"type": "weapon"
	},
	"punch1":{
		"icon": WEAPON_PATH + "punch.png",
		"displayname": "Punch",
		"details": "Soco poderoso de curta distancia",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"punch2":{
		"icon": WEAPON_PATH + "punch.png",
		"displayname": "Punch",
		"details": "Soco poderoso de curta distancia",
		"level": "Level: 2",
		"prerequesite": ["punch1"],
		"type": "weapon"
	},
	"punch3":{
		"icon": WEAPON_PATH + "punch.png",
		"displayname": "Punch",
		"details": "Soco poderoso de curta distancia",
		"level": "Level: 3",
		"prerequesite": ["punch2"],
		"type": "weapon"
	},
	"punch4":{
		"icon": WEAPON_PATH + "punch.png",
		"displayname": "Punch",
		"details": "Soco poderoso de curta distancia",
		"level": "Level: 4",
		"prerequesite": ["punch3"],
		"type": "weapon"
	},
	"banana_orbit1":{
		"icon": WEAPON_PATH + "banana.png",
		"displayname": "Banana Orbit",
		"details": "Bananas ao seu redor = proteção garantida",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"banana_orbit2":{
		"icon": WEAPON_PATH + "banana.png",
		"displayname": "Banana Orbit",
		"details": "Bananas ao seu redor = proteção garantida",
		"level": "Level: 2",
		"prerequesite": ["banana_orbit1"],
		"type": "weapon"
	},
	"banana_orbit3":{
		"icon": WEAPON_PATH + "banana.png",
		"displayname": "Banana Orbit",
		"details": "Bananas ao seu redor = proteção garantida",
		"level": "Level: 3",
		"prerequesite": ["banana_orbit2"],
		"type": "weapon"
	},
	"banana_orbit4":{
		"icon": WEAPON_PATH + "banana.png",
		"displayname": "Banana Orbit",
		"details": "Bananas ao seu redor = proteção garantida",
		"level": "Level: 4",
		"prerequesite": ["banana_orbit3"],
		"type": "weapon"
	},
	"banana_peel1":{
		"icon": WEAPON_PATH + "banana_peel.png",
		"displayname": "Banana Peel",
		"details": "Extraindo 100% do potencial de uma banana",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"banana_peel2":{
		"icon": WEAPON_PATH + "banana_peel.png",
		"displayname": "Banana Peel",
		"details": "Extraindo 100% do potencial de uma banana",
		"level": "Level: 2",
		"prerequesite": ["banana_peel1"],
		"type": "weapon"
	},
	"banana_peel3":{
		"icon": WEAPON_PATH + "banana_peel.png",
		"displayname": "Banana Peel",
		"details": "Extraindo 100% do potencial de uma banana",
		"level": "Level: 3",
		"prerequesite": ["banana_peel2"],
		"type": "weapon"
	},
	"banana_peel4":{
		"icon": WEAPON_PATH + "banana_peel.png",
		"displayname": "Banana Peel",
		"details": "Extraindo 100% do potencial de uma banana",
		"level": "Level: 4",
		"prerequesite": ["banana_peel3"],
		"type": "weapon"
	},
	"medic_kit": {
		"icon": ICON_PATH + "medical-kit-sprite-4.png",
		"displayname": "Medic Kit",
		"details": "Cura 20 de vida",
		"level": "N/A",
		"prerequesite": [],
		"type": "item"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
