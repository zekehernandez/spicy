extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var pitch = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
  set_animation('default')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func express(expression):
  set_animation(expression)
