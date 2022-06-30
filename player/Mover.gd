extends RigidBody2D

signal landed(wingCount)
signal cutsceneOver

const JUMP_VELOCITY = 50
const STOP_JUMP_FORCE = 10
const TORQUE = 200
const LANDING_TIME = 2

onready var camera = $CutsceneCamera
onready var dialog = $CanvasLayer/Dialog
onready var animator = $AnimationPlayer

onready var leftBird = $Motor/LeftBird
onready var rightBird = $Motor/RightBird
onready var sentientWing = $SentientWing

onready var bar = $Bar

var timeLanded = 0

var fullLength = 0

var state = "initial"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumping = false
var stopping_jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
  fullLength = bar.scale.x
  
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
      
    bar.scale.x = (timeLanded / LANDING_TIME) * fullLength

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

const SPEAKER = 'speaker'
const EXPRESSION = 'expression'
const ANIMATION = 'animation'
const MESSAGE = 'message'

const HAPPY = 'happy'
const NEUTRAL = 'neutral'
const DEFAULT = 'default'
const SCARED = 'scared'
const UNCOMFORTABLE = 'uncomfortable'
const SURPRISED = 'surprised'
const STRAIN = 'strain'

const LR = 'oneToTwo'
const RL = 'twoToOne'
const LB = 'oneToThree'
const BL = 'threeToOne'
const RB = 'twoToThree'
const BR = 'threeToTwo'
const ZL = 'zoomOne'
const ZR = 'zoomTwo'
const ZB = 'zoomThree'

onready var cutscenes = {
  0: [
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: ZR, MESSAGE: 'Good morning, to you! We\'re glad to have you join us for the first delivery of the day.'},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: 'What exactly is this "thing" we\'re delivering again?'},
    { SPEAKER: sentientWing, EXPRESSION: HAPPY, ANIMATION: LB, MESSAGE: 'Hiya!'},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: BR, MESSAGE: 'I\'m getting to that, just a minute now, Rookie.'},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "If you look around you can see that there's not much left out here, and not many people. But the people that are here love hot, spicy wings."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: 'I think "spicy" is redundant there.'},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "I'm going to need you to stop interrupting, Rookie!"},
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: RL, MESSAGE: "Sorry!"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Anyhow, we've got to fly these wings over to the islands these folks live on."},
    { SPEAKER: sentientWing, EXPRESSION: DEFAULT, ANIMATION: RB, MESSAGE: 'It\'s always been my dream to fly!'},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: BR, MESSAGE: "Yes, yes okay, pipe down now."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "It's not easy work, making these deliveries. So, consider this a practice run, Rookie."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "I'm ready to fly!"},
    { SPEAKER: sentientWing, EXPRESSION: HAPPY, ANIMATION: LB, MESSAGE: 'Weeeee!'},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: BR, MESSAGE: "A couple more things before we take off..."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "If we drop any wings on the ground or in the water, they're ruined. So, let's not do that."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "Also, we only have mild wings with us, but the people prefer spicy wings."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "So, if you see any hot sauce bottles floating around, try to get that sauce on the wings."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "It's not a requirement for delivery, but the people love spicy wings."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "We have to get sauce on our wings?"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Not OUR wings, the ones we're delivering!"},
    { SPEAKER: sentientWing, EXPRESSION: HAPPY, ANIMATION: RB, MESSAGE: "I'm gonna be sooo SPICY!"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: BR, MESSAGE: "All we need to do is land SAFELY by that flag to complete the job."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "Alright, let's get moving. The people are hungry!"},
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: RL, MESSAGE: "Let's go!"},
    { SPEAKER: sentientWing, EXPRESSION: HAPPY, ANIMATION: LB, MESSAGE: 'Yeah, let\'s go!'},
    { SPEAKER: sentientWing, EXPRESSION: DEFAULT, ANIMATION: null, MESSAGE: "Wait..."},
    { SPEAKER: sentientWing, EXPRESSION: SCARED, ANIMATION: null, MESSAGE: "AM I GOING TO BE EATEN?!"},
    { SPEAKER: leftBird, EXPRESSION: UNCOMFORTABLE, ANIMATION: BL, MESSAGE: "..."},
    { SPEAKER: rightBird, EXPRESSION: UNCOMFORTABLE, ANIMATION: LR, MESSAGE: "..."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "Maybe we should only deliver the non-sentient wings?"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Good idea, Rookie."},
   ],
  1: [
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: ZR, MESSAGE: 'Alright, Rookie, you completed your first job? What do think? Exhilirating, right?'},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: 'Yeah, but I have so many questions - like, why? Why are we doing this?'},
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: null, MESSAGE: "Don't get me wrong, I enjoyed it, but there have got to be better ways to deliver wings, right?"},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "Drones are a thing now, you know? Or even a boat would probably work better."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Well, I suppose..."},
    { SPEAKER: leftBird, EXPRESSION: STRAIN, ANIMATION: RL, MESSAGE: "And why are the wings just out? In the open! Could we get a box or..."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Now listen here, Rookie! This delivery practice was passed down generation to generation!"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "From my grandfather to my father, my father to me, and one day I'll pass it down to my son."},
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: RL, MESSAGE: "Alright, okay. I understand. Let's get to work."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "One thing though, you know my name isn't actually Rookie, right?"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "..."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "Because that's all you've calling me, and I can't help but noticing you've been using a capital 'R' for 'Rookie'."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "I uh..."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "...wait you can see that?"},
  ],
}

func playScene():
  print('playing scene %s' % currentScene)
  if currentCutscene == null:
    return 
  
  if currentScene >= currentCutscene.size():
    currentCutscene = null
    currentScene = null
    animator.play('fadeOut')
    yield(get_node('AnimationPlayer'), "animation_finished")
    sentientWing.hide();
    get_tree().call_group("cargo", "show")
    emit_signal("cutsceneOver")
    return
  
  var scene = currentCutscene[currentScene]
  currentScene += 1
    
  # Facial expression
  print('face')
  scene.speaker.express(scene.expression)
  
  # Pan Camera
  if scene.animation != null:
    print(ANIMATION)
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
  if !cutscenes.has(level) || cutscenes.get(level) == null || Global.shownCutscenes[level]:
    emit_signal("cutsceneOver")
    return
    
  Global.showCutscene(level)
  
  if level == 0:
    sentientWing.show();
    get_tree().call_group("cargo", "hide")
    
  camera.current = true
  
  currentCutscene = cutscenes.get(level)
  print('cutscene length: %s' % currentCutscene.size())
  currentScene = 0
  
  print('showCutscene calling playScene')
  animator.play('panIn')
  yield(get_node('AnimationPlayer'), "animation_finished")
  playScene()

func _on_Dialog_hide_message():
  print('dialog calling playScene')
  playScene()

func removeFade():
  $CanvasLayer/ColorRect.hide()
