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
		"details": "A arma definitiva de fezes",
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
		"details": "Capacidade de pensar aprimorada te tornando capaz de usar os 2 braços.",
		"level": "Level: 2",
		"prerequesite": ["punch1"],
		"type": "weapon"
	},
	"punch3":{
		"icon": WEAPON_PATH + "punch.png",
		"displayname": "Punch",
		"details": "Aprimora o recuo dos seus golpes",
		"level": "Level: 3",
		"prerequesite": ["punch2"],
		"type": "weapon"
	},
	"punch4":{
		"icon": WEAPON_PATH + "punch.png",
		"displayname": "Punch",
		"details": "3 socos?",
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
		"details": "Seu poder telepático e simbiotico com as bannas aumenta te concedendo maior velocidade de giro",
		"level": "Level: 2",
		"prerequesite": ["banana_orbit1"],
		"type": "weapon"
	},
	"banana_orbit3":{
		"icon": WEAPON_PATH + "banana.png",
		"displayname": "Banana Orbit",
		"details": "Aprimora ainda mais sua concentração fazendo com que inimigos recuem ao tocar nas bananas telepáticas",
		"level": "Level: 3",
		"prerequesite": ["banana_orbit2"],
		"type": "weapon"
	},
	"banana_orbit4":{
		"icon": WEAPON_PATH + "banana.png",
		"displayname": "Banana Orbit",
		"details": "Disco de acreção. Adiciona mais uma orbita",
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
		"details": "Sua fome aumenta e seu armamento também",
		"level": "Level: 2",
		"prerequesite": ["banana_peel1"],
		"type": "weapon"
	},
	"banana_peel3":{
		"icon": WEAPON_PATH + "banana_peel.png",
		"displayname": "Banana Peel",
		"details": "Sua saliva fica arraigada na banana garantindo uma maior lentidão",
		"level": "Level: 3",
		"prerequesite": ["banana_peel2"],
		"type": "weapon"
	},
	"banana_peel4":{
		"icon": WEAPON_PATH + "banana_peel.png",
		"displayname": "Banana Peel",
		"details": "Lentidão extrema",
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
func _process(_delta: float) -> void:
	pass
