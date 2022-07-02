extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelCodeEdit = $CanvasLayer/Control/CenterContainer/GridContainer/Panel/LevelCodeEdit
onready var levelCodeMessage = $CanvasLayer/Control/CenterContainer/GridContainer/Panel/LevelCodeMessage
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _on_IntroButton_pressed():
  get_tree().change_scene("res://levels/Level0.tscn")

func _on_SubmitButton_pressed():
  var code = levelCodeEdit.text
  var result = Global.enterCode(code)
  levelCodeEdit.text = ''
  if result == null:
    levelCodeMessage.text = 'Invalid Code.'
  elif result == -1:
    levelCodeMessage.text = 'That code is for a level you already have unlocked.'
  else:
    levelCodeMessage.text = 'Unlocked all levels up to level %s!' % (result)
    get_tree().call_group("level_card", "update")
