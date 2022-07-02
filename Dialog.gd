extends Control

signal show_message
signal hide_message

var MESSAGES = {
  'test': 'This is a test message.',
  'shoot': 'Pew pew. I love to shoot my gun.',
  'spawn': 'Oh, no! What have I DONE!!!',
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_message = ''
var current_pitch = 1

onready var sound = $Sound

# Called when the node enters the scene tree for the first time.
func _ready():
  $Panel.visible = false
  $Panel/Label.text = ''
  $Panel/Label2.hide()
  current_message = ''

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if !$Panel.visible:
    return
  
  var textLength = $Panel/Label.text.length()
  if textLength < current_message.length():
    $Panel/Label.text = current_message.substr(0, textLength + 1)
    sound.pitch_scale = randf() + current_pitch + 1
    sound.play()
    if $Panel/Label.text.length() == current_message.length():
      $Panel/Label2.show()
    
  var skip = Input.is_action_just_pressed("ui_accept")
  
  if skip:
    if textLength == current_message.length():
      $Panel.visible = false
      $Panel/Label.text = ''
      current_message = ''
      emit_signal("hide_message")
    else:
      $Panel/Label.text = current_message
      $Panel/Label2.show()

func show_message(message, pitch):
  current_message = message
  current_pitch = pitch
  $Panel/Label2.hide()
  $Panel/Label.text = ''
  $Panel.visible = true
  emit_signal("show_message")

