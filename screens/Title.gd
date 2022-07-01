extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = $Camera2D
onready var dummy = $Dummy

onready var mainTimer = $MainTimer
onready var subtitleTimer = $SubtitleTimer

onready var animator = $AnimationPlayer

var canProgress = false

# Called when the node enters the scene tree for the first time.
func _ready():
  mainTimer.start()
  
func _process(delta):
  if canProgress:
    var enter = Input.is_action_just_pressed('ui_accept')
    if enter:
      get_tree().change_scene("res://screens/LevelSelect.tscn")
      
  dummy.move_and_slide(Vector2(200, 0))

  
func _on_MainTimer_timeout():
  animator.play("Main")
  subtitleTimer.start();


func _on_SubtitleTimer_timeout():
  animator.play("Subtitle")
  canProgress = true
