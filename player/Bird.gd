extends RigidBody2D

const JUMP_VELOCITY = 50
const STOP_JUMP_FORCE = 10

export var input_action = "left_action"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumping = false
var stopping_jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _physics_process(delta):
  # Get player input.
  var jump = Input.is_action_pressed(input_action)

  if jump:
    apply_impulse(Vector2(0,0), Vector2(0, -5))
