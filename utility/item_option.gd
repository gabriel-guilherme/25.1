extends TextureRect

@onready var lblName = $label_name
@onready var lblDesc = $label_desc
@onready var lblLevel = $label_level
@onready var itemIcon = $ColorRect/ItemIcon

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item == null:
		item = "medic_kit"
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	lblName.text = UpgradeDb.UPGRADES[item]["displayname"]
	lblDesc.text = UpgradeDb.UPGRADES[item]["details"]
	lblLevel.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)

func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
