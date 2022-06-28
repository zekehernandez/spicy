extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var levelState = {
  'EARLYBIRD': { 'wings': 0, 'spice': false },
  'OUTONAWING': null,
  'AVIANBLUES': null,
}

var currentLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
  
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
    var newLevel = levelState.keys().find(code)
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
