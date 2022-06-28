class_name Sauce
extends Area2D

var taken = false

func _ready():
  $AnimationPlayer.play("idle")

func _on_body_enter(body):
  if not taken:
    ($AnimationPlayer as AnimationPlayer).play("taken")
