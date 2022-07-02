extends Node2D

signal start_level
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var currentLevel = -1

onready var mover = $Mover
onready var targetZone = $TargetZone
onready var camera = $Mover/Camera
onready var sauce = $Sauce

onready var results = $UI/Results
onready var pauseMenu = $UI/PauseMenu

onready var mainMusic = $MainMusic
onready var successMusic = $SuccessMusic
onready var failMusic = $FailMusic

var didSauceUp = false

# Called when the node enters the scene tree for the first time.
func _ready():
  mover.position = $StartPosition.position
  targetZone.position = $TargetPosition.position
  camera.limit_right = $LevelBounds.position.x
  sauce.position = $SaucePosition.position

  results.setLevel(currentLevel)
  mover.showCutscene(currentLevel)

# Called every wframe. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var unspoiled = 0
  for cargo in get_tree().get_nodes_in_group("cargo"):
    if !cargo.isSpoiled:
      if cargo.global_position.y >= $LevelBounds.global_position.y:
        cargo.spoil()
      else:
        unspoiled += 1

  if unspoiled == 0 and results.visible == false:
    mover.failed_level()
    results.wasIncomplete()
    mainMusic.stop()
    failMusic.play()
    results.show()
    
func _unhandled_input(event):
  if results.visible == true:
    return
  
  var tree  = get_tree()
  if event.is_action_pressed('ui_cancel'):
    tree.paused = not tree.paused
    if tree.paused:
      pauseMenu.show()
    else:
      pauseMenu.hide()
    tree.set_input_as_handled()
    
func _on_Mover_landed(wingCount):
  results.setWingCount(wingCount)
  mainMusic.stop()
  successMusic.play()
  results.show()
  mover.success()
  Global.completeLevel(currentLevel, wingCount, didSauceUp)

func _on_Sauce_body_entered(body):
  results.didSauceUp()
  didSauceUp = true
  for cargo in get_tree().get_nodes_in_group("cargo"):
    if !cargo.isSpoiled:
      cargo.animatedSprite.play("spicy")

func _on_Mover_cutsceneOver():
  camera.current = true
  mover.removeFade()
  mover.startPlaying()
  mainMusic.play()
  emit_signal('start_level')


func _on_GroundCollision_body_entered(body):
  pass # Replace with function body.

func _on_WaterArea_body_entered(body):
  if !body.is_in_group("level"):
    $Splash.play()
