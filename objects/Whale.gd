extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animator = $AnimationPlayer
onready var waitTimer = $WaitTimer
onready var activeTimer = $ActiveTimer
onready var eye = $KinematicBody2D/Body/Eye

# Called when the node enters the scene tree for the first time.
func _ready():
  animator.play("activate")
  activeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var players = get_tree().get_nodes_in_group("player")
  if players.size() > 0:
    eye.look_at((players[0] as Node2D).global_position)    

func _on_WaitTimer_timeout():
  animator.play("activate")
  yield(get_node('AnimationPlayer'), "animation_finished")
  activeTimer.start()


func _on_ActiveTimer_timeout():
  animator.play("deactivate")
  yield(get_node('AnimationPlayer'), "animation_finished")
  waitTimer.start()
  animator.play("wait")
