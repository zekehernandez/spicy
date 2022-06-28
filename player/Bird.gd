extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var prefix = 'left'

# Called when the node enters the scene tree for the first time.
func _ready():
  $Face.play("%s_happy" % prefix)

func fly(isStraining):
  set_animation("fly")
  if isStraining:
    $Face.set_animation("%s_strain" % prefix)
  else:
    $Face.set_animation("%s_neutral" % prefix)

func glide():
  set_animation("glide")
  $Face.set_animation("%s_neutral" % prefix)

func idle(): 
  set_animation("idle")
  $Face.set_animation("%s_neutral" % prefix)
  
func fail():
  set_animation("glide")
  $Face.set_animation("%s_surprised" % prefix)

func success():
  $Face.set_animation("%s_happy" % prefix)
  
func express(expression):
  $Face.set_animation("%s_%s" % [prefix, expression])
