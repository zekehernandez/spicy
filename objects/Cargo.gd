extends RigidBody2D

signal sauce_up

# Declare member variables here. Examples:
# var a = 2
var isSpoiled = false

onready var animatedSprite = $AnimatedSprite

func spoil():
  isSpoiled = true
  animatedSprite.play("spoiled")

func _on_Area2D_body_entered(body):
  spoil()


func _on_Area2D_area_entered(area):
  spoil()
