extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var levelState = {
  'EARLYBIRD': { 'wings': 0, 'spice': false },
  'WINGINGIT': null,
  'AVIANBLUES': null,
  'BIRDBRAIN': null,
  'BIRDSOFAFEATHER': null,
  'SOUTHFORTHEWINTER': null,
}

var shownCutscenes = [false, false, false, false, false, false, false, false]

var currentLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  # COMMENT THIS OUT PLZ
  # shownCutscenes = [true, true, true, false, false, false, false, false]
  pass # Replace with function body.
  
  
func showCutscene(level):
  shownCutscenes[level] = true
  
func completeLevel(level, wings, spice):
  var code = levelState.keys()[level]
  if (levelState[code] == null
  or levelState[code].wings < wings
  or (levelState[code].wings == wings
    and levelState[code].spice == false and spice == true)):
      levelState[code] = { 'wings': wings, 'spice': spice }
  if level == currentLevel:
    currentLevel += 1
  
func enterCode(code):
  if levelState.has(code):
    var newLevel = levelState.keys().find(code) + 1
    if newLevel > currentLevel:
      currentLevel = newLevel 
      return currentLevel
    else:
      return -1
  else:
    return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
