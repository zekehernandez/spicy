extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var call = $Call

var startingPoint 
export var respawnTime = 3

# Called when the node enters the scene tree for the first time.
func _ready():
  startingPoint = global_position
  call.play()
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  move_and_slide(Vector2(-500, 0))
  
  if global_position.x < 0:
    yield(get_tree().create_timer(respawnTime), "timeout")
    global_position = startingPoint
