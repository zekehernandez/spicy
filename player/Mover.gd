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

onready var controls = $CanvasLayer/Controls

onready var bar = $Bar

onready var cutsceneMusic = $CutsceneMusic
onready var flappingSound = $Motor/Flapping

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
  bar.scale.x = 0
  
func start():
  state = "playing"
  
func _process(delta):
  if state == "playing":
    if $LandingDetector.get_overlapping_areas().size() > 0 and abs(linear_velocity.y) < 1:
      timeLanded += delta
      if !$Charge.playing:
        $Charge.play()
      if timeLanded >= LANDING_TIME:
        $Charge.stop()
        state = "landed"
        var wingCount = 0
        for wing in $OnArea.get_overlapping_bodies():
          if !wing.isSpoiled:
            wingCount += 1
        emit_signal("landed", wingCount)
    else:
      timeLanded = 0
      $Charge.stop()
      
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
      controls.hide()
    else:
      flappingSound.stop()
      
    if up:
      leftBird.fly(lv.y > 100)
      rightBird.fly(lv.y > 100)
      if !flappingSound.playing:
        flappingSound.play(1)
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
  controls.show()
  

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
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: ZR, MESSAGE: 'Good morning! We\'re glad to have you join us for the first delivery of the day.'},
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
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "It's not easy work making these deliveries. So, consider this a practice run, Rookie."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "I'm ready to fly!"},
    { SPEAKER: sentientWing, EXPRESSION: HAPPY, ANIMATION: LB, MESSAGE: 'Weeeeeeeeeeeeeeeeeee!'},
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
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: ZR, MESSAGE: 'Alright, Rookie, you completed your first job. Not bad.'},
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: RL, MESSAGE: "Yeah, that wasn't so hard I guess."},
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: LR, MESSAGE: "Don't get too comfortable. You hear that sound?"},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "Seagulls?"},
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: LR, MESSAGE: "Seagulls."},
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: null, MESSAGE: "Those ruthless birds will knock you right out of the sky if you're not careful."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "Okay, I'll watch out."},
  ],
  2: [
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: ZL, MESSAGE: "So... that's a pretty big whale over there."},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Yes, whales are large creatures."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "..."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "So, we just have to fly right past that whale, huh?"},
    { SPEAKER: rightBird, EXPRESSION: NEUTRAL, ANIMATION: LR, MESSAGE: "Well, yes. That's where we need to deliver the wings."},
    { SPEAKER: leftBird, EXPRESSION: STRAIN, ANIMATION: RL, MESSAGE: "Okay, fine."},
  ],
  3: [
    { SPEAKER: sentientWing, EXPRESSION: DEFAULT, ANIMATION: ZB, MESSAGE: "Ooooooohhh! A windmill!"},
    { SPEAKER: rightBird, EXPRESSION: DEFAULT, ANIMATION: BR, MESSAGE: "What are you doing here, little wing?"},
    { SPEAKER: rightBird, EXPRESSION: DEFAULT, ANIMATION: null, MESSAGE: "Are you coming along?"},
    { SPEAKER: sentientWing, EXPRESSION: HAPPY, ANIMATION: RB, MESSAGE: "No."},
    { SPEAKER: sentientWing, EXPRESSION: DEFAULT, ANIMATION: null, MESSAGE: "I still don't want to be eaten."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: BL, MESSAGE: "Understandable."},
  ],
  4: [
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: ZR, MESSAGE: "Ahhh. It just doesn't get much better than this" },
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: RL, MESSAGE: "Yeah, it's nice..."},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "..but I have so many questions - like, why?"},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "Why are we doing this?"},
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: null, MESSAGE: "Don't get me wrong, I've been enjoying our time, but there have got to be better ways to deliver wings, right?"},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "Drones are a thing now you know? Or even a boat would probably work better."},
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
  5: [
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: ZR, MESSAGE: "Alright, rookie. Last delivery of the day." },
    { SPEAKER: leftBird, EXPRESSION: HAPPY, ANIMATION: RL, MESSAGE: "Oh look, the house is right there!"},
    { SPEAKER: rightBird, EXPRESSION: HAPPY, ANIMATION: LR, MESSAGE: "But look where the sauce is..." },
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: RL, MESSAGE: "Where is it?"},
    { SPEAKER: leftBird, EXPRESSION: NEUTRAL, ANIMATION: null, MESSAGE: "Oh, just right down..."},
    { SPEAKER: leftBird, EXPRESSION: SURPRISED, ANIMATION: null, MESSAGE: "[Bird sounds]"},
   ]
}

func playScene():
  if currentCutscene == null:
    return 
  
  if currentScene >= currentCutscene.size():
    currentCutscene = null
    currentScene = null
    animator.play('fadeOut')
    cutsceneMusic.stop()
    yield(get_node('AnimationPlayer'), "animation_finished")
    sentientWing.hide();
    get_tree().call_group("cargo", "show")
    emit_signal("cutsceneOver")
    return
  
  var scene = currentCutscene[currentScene]
  currentScene += 1
    
  # Facial expression
  scene.speaker.express(scene.expression)
  
  # Pan Camera
  if scene.animation != null:
    animator.play(scene.animation)
    yield(get_node('AnimationPlayer'), "animation_finished")
  
  if scene.message != null:
    dialog.show_message(scene.message, scene.speaker.pitch)
  else:
    playScene()

func showCutscene(level):
  if !cutscenes.has(level) || cutscenes.get(level) == null || Global.shownCutscenes[level]:
    emit_signal("cutsceneOver")
    return
    
  cutsceneMusic.play()
    
  Global.showCutscene(level)
  
  if level == 0 or level == 3:
    sentientWing.show();
    get_tree().call_group("cargo", "hide")
    
  camera.current = true
  
  currentCutscene = cutscenes.get(level)
  currentScene = 0
  
  animator.play('panIn')
  yield(get_node('AnimationPlayer'), "animation_finished")
  playScene()

func _on_Dialog_hide_message():
  playScene()

func removeFade():
  $CanvasLayer/ColorRect.hide()

func _on_Platform_body_entered(body):
  if state == "playing" and !body.is_in_group("cargo") and !$Pat.playing:
    $Pat.play()
