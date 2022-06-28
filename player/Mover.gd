extends RigidBody2D

signal landed(wingCount)

const JUMP_VELOCITY = 50
const STOP_JUMP_FORCE = 10
const TORQUE = 200
const LANDING_TIME = 3

var timeLanded = 0

var state = "playing"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumping = false
var stopping_jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
  
func _process(delta):
  if state == "playing":
    if $LandingDetector.get_overlapping_areas().size() > 0 and abs(linear_velocity.y) < 1:
      timeLanded += delta
      if timeLanded >= LANDING_TIME:
        state = "landed"
        var wingCount = 0
        for wing in $OnArea.get_overlapping_bodies():
          if !wing.isSpoiled:
            wingCount += 1
        emit_signal("landed", wingCount)
    else:
      timeLanded = 0

func _integrate_forces(s):
  if state == "playing":
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
      
    if up:
      $Motor/LeftBird.fly(lv.y > 100)
      $Motor/RightBird.fly(lv.y > 100)
    elif lv.y > 0.5:
      $Motor/LeftBird.glide()
      $Motor/RightBird.glide()
    else:
      $Motor/LeftBird.idle()
      $Motor/RightBird.idle()

func success():
      $Motor/LeftBird.success()
      $Motor/RightBird.success()  
      
func failed_level():
  state = "failed"
  mode = RigidBody2D.MODE_STATIC
  $Motor/LeftBird.fail()
  $Motor/RightBird.fail()
