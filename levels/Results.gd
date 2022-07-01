extends Control

# Declare member variables here. Examples:
# var a = 2
var level = -1

onready var mainLabel = $PanelContainer/CenterContainer/VBoxContainer/MainLabel
onready var wingCountLabel = $PanelContainer/CenterContainer/VBoxContainer/WingCountLabel
onready var spiceLevelLabel = $PanelContainer/CenterContainer/VBoxContainer/SpiceLevelLabel
onready var nextLevelButton = $PanelContainer/CenterContainer/VBoxContainer/NextLevel
onready var levelCodeSection = $PanelContainer/CenterContainer/VBoxContainer/LevelCodeSection
onready var levelCode = $PanelContainer/CenterContainer/VBoxContainer/LevelCodeSection/LevelCode

# Called when the node enters the scene tree for the first time.
#func _ready():
  #pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _on_TryAgainButton_pressed():
  get_tree().paused = false
  get_tree().reload_current_scene()
  
func setLevel(newLevel):
  level = newLevel
  levelCode.text = Global.levelState.keys()[level]
  if Global.levelState.keys().size() <= level + 1:
    nextLevelButton.hide()
  
func setWingCount(wingCount):
  wingCountLabel.text = "Wing Count: %s" % wingCount
  
func didSauceUp():
  spiceLevelLabel.text = "Spice Level: SPICY"

func wasIncomplete():
  mainLabel.text = "You lost all your wings!"
  wingCountLabel.hide()
  spiceLevelLabel.hide()
  nextLevelButton.hide()
  levelCodeSection.hide()

func _on_LevelSelectButton_pressed():
  get_tree().paused = false
  get_tree().change_scene("res://screens/LevelSelect.tscn")

func _on_NextLevel_pressed():
  get_tree().paused = false
  var nextLevel = level + 1
  if nextLevel >= 0:
    get_tree().change_scene("res://levels/Level%s.tscn" % nextLevel)
  else:
    get_tree().change_scene("res://screens/LevelSelect.tscn")

func _on_ResumeButton_pressed():
  get_tree().paused = false
  hide()
