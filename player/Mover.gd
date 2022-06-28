extends RigidBody2D

signal landed(wingCount)
signal cutsceneOver

const JUMP_VELOCITY = 50
const STOP_JUMP_FORCE = 10
const TORQUE = 200
const LANDING_TIME = 3

onready var camera = $CutsceneCamera
onready var dialog = $CanvasLayer/Dialog
onready var animator = $AnimationPlayer

onready var leftBird = $Motor/LeftBird
onready var rightBird = $Motor/RightBird

var timeLanded = 0

var state = "initial"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumping = false
var stopping_jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
  
func start():
  state = "playing"
  
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
      leftBird.fly(lv.y > 100)
      rightBird.fly(lv.y > 100)
    elif lv.y > 0.5:
      leftBird.glide()
      rightBird.glide()
    else:
      leftBird.idle()
      rightBird.idle()

func success():
  leftBird.success()
  rightBird.success()  
      
func failed_level():
  state = "failed"
  mode = RigidBody2D.MODE_STATIC
  leftBird.fail()
  rightBird.fail()

func startPlaying():
  state = "playing"
  

# Cutscene Stuff
var currentCutscene = null
var currentScene = null

onready var cutscenes = {
  0: [
    { 'speaker': leftBird, 'expression': 'happy', 'message': null, 'animation': 'panIn'},
    { 'speaker': rightBird, 'expression': 'happy', 'message': 'hello', 'animation': 'zoomTwo'},
    { 'speaker': leftBird, 'expression': 'happy', 'message': 'hi there', 'animation': 'twoToOne'},
   ],
  1: null,
}

func playScene():
  print('playing scene %s' % currentScene)
  if currentCutscene == null:
    return 
  
  if currentScene >= currentCutscene.size():
    currentCutscene = null
    currentScene = null
    emit_signal("cutsceneOver")
    return
  
  var scene = currentCutscene[currentScene]
  currentScene += 1
    
  # Facial expression
  print('face')
  scene.speaker.express(scene.expression)
  
  # Pan Camera
  if scene.animation != null:
    print('animation')
    animator.play(scene.animation)
    yield(get_node('AnimationPlayer'), "animation_finished")
  
  if scene.message != null:
    print('dialog')
    dialog.show_message(scene.message)
  else:
    print('playScene calling playScene')
    playScene()

func showCutscene(level):
  print('showCutscene(%s)' % level)
  if !cutscenes.has(level):
    return
    
  camera.current = true
  
  currentCutscene = cutscenes.get(level)
  print('cutscene length: %s' % currentCutscene.size())
  currentScene = 0
  
  print('showCutscene calling playScene')
  playScene()

func _on_Dialog_hide_message():
  print('dialog calling playScene')
  playScene()
