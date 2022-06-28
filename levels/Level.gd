extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var currentLevel = -1

onready var mover = $Mover
onready var targetZone = $TargetZone
onready var camera = $Mover/Camera
onready var sauce = $Sauce

onready var results = $UI/Results

var didSauceUp = false

# Called when the node enters the scene tree for the first time.
func _ready():
  mover.position = $StartPosition.position
  targetZone.position = $TargetPosition.position
  camera.limit_right = $LevelBounds.position.x
  sauce.position = $SaucePosition.position

  results.setLevel(currentLevel)


# Called every wframe. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var unspoiled = 0
  for cargo in get_tree().get_nodes_in_group("cargo"):
    if !cargo.isSpoiled:
      if cargo.global_position.y >= $LevelBounds.global_position.y:
        cargo.spoil()
      else:
        unspoiled += 1

  if unspoiled == 0:
    mover.failed_level()
    results.wasIncomplete()
    results.show()
    
func _on_Mover_landed(wingCount):
  results.setWingCount(wingCount)
  results.show()
  Global.completeLevel(currentLevel, wingCount, didSauceUp)

func _on_Sauce_body_entered(body):
  results.didSauceUp()
  didSauceUp = true
  for cargo in get_tree().get_nodes_in_group("cargo"):
    if !cargo.isSpoiled:
      cargo.animatedSprite.play("spicy")