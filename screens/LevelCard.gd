extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var level = -1

onready var levelLabel = $PanelContainer/VSplitContainer/VSplitContainer/LevelLabel
onready var playButton = $PanelContainer/VSplitContainer/PlayButton
onready var wingsLabel = $PanelContainer/VSplitContainer/VSplitContainer/HSplitContainer/WingsLabel
onready var spiceLabel = $PanelContainer/VSplitContainer/VSplitContainer/HSplitContainer/SpiceLabel

# Called when the node enters the scene tree for the first time.
func _ready():
  update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func update():
  print("update with level %s" % Global.currentLevel)
  levelLabel.text = "Level - %s" % level
  var currentLevel = Global.currentLevel
  var levelState = Global.levelState.values()[level]
  if Global.currentLevel < level:
    playButton.disabled = true
    playButton.text = "Locked"
  else:
    playButton.disabled = false
    playButton.text = "Play"
  
  if levelState != null:
    var wingCount = levelState.wings
    wingsLabel.text = "Wings: %s/3" % wingCount
    if wingCount > 0:
      spiceLabel.text = 'Spice: SPICY' if levelState.spice else 'Spice: Mild'

func _on_PlayButton_pressed():
  get_tree().change_scene("res://levels/Level%s.tscn" % level)
