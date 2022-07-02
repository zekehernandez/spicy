extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = $Camera2D
onready var dummy = $Dummy

onready var mainTimer = $MainTimer
onready var subtitleTimer = $SubtitleTimer

onready var animator = $AnimationPlayer

onready var gull1 = $Dummy/Gull1
onready var gull2 = $Dummy/Gull2

var hasStarted = false
var canProgress = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#

func end():
  get_tree().change_scene("res://screens/LevelSelect.tscn")

func _process(delta):
  if hasStarted:
    if canProgress:
      var enter = Input.is_action_just_pressed('ui_accept')
      if enter:
        animator.play("End")
        
    dummy.move_and_slide(Vector2(200, 0))
    
    gull1.position.x += 0.65
    gull2.position.x += 0.6
  elif Input.is_action_just_pressed("ui_accept"):
    hasStarted = true
    animator.play("Start")
    mainTimer.start()
    gull1.frame = 0
    gull2.frame = 1
  
func _on_MainTimer_timeout():
  $Music.play()
  yield(get_tree().create_timer(1), "timeout")
  animator.play("Main")
  subtitleTimer.start();


func _on_SubtitleTimer_timeout():
  animator.play("Subtitle")
  canProgress = true
