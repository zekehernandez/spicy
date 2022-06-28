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

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if !$Panel.visible:
    return
  
  var textLength = $Panel/Label.text.length()
  if textLength < current_message.length():
    $Panel/Label.text = current_message.substr(0, textLength + 1)
    if $Panel/Label.text.length() == current_message.length():
      $Panel/Label2.show()
    
  var skip = Input.is_action_pressed("ui_accept")
  
  if skip:
    if textLength == current_message.length():
      $Panel.visible = false
      $Panel/Label.text = ''
      current_message = ''
      emit_signal("hide_message")
    else:
      $Panel/Label.text = current_message

func show_message(message):
  current_message = message
  $Panel/Label.text = ''
  $Panel.visible = true
  emit_signal("show_message")

