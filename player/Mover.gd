extends RigidBody2D

const JUMP_VELOCITY = 50
const STOP_JUMP_FORCE = 10
const TORQUE = 200


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumping = false
var stopping_jump = false


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _integrate_forces(s):
  var lv = s.get_linear_velocity()
  var step = s.get_step()

  var left = Input.is_action_pressed("move_left")
  var right = Input.is_action_pressed("move_right")
  var up = Input.is_action_pressed("jump")
  
  
  if left:
    $Motor.apply_central_impulse(Vector2(-2, 0))
    
  if right:
    $Motor.apply_central_impulse(Vector2(2, 0))
  
  if up:
    $Motor.apply_central_impulse(Vector2(0, -15))
  
