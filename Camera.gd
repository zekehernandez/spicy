extends Camera2D

signal done_zooming

var current_zoom
export var default_zoom = 3
export var max_zoom = 1
var min_zoom

var zoom_factor = 0.75 # < 1 = zoom_in; > 1 = zoom_out
var transition_time = 20

func _ready():
  min_zoom = default_zoom

func zoom_in(new_offset):
  transition_camera(Vector2(min_zoom, min_zoom), Vector2(max(new_offset.x, 0), max(new_offset.y, 0)))


func zoom_out(new_offset):
  transition_camera(Vector2(max_zoom, max_zoom), Vector2(max(new_offset.x, 0), max(new_offset.y, 0)))


func transition_camera(new_zoom, new_offset):
  if new_zoom != current_zoom:
    current_zoom = new_zoom
    $Tween.interpolate_property(self, "zoom", get_zoom(), current_zoom, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.interpolate_property(self, "offset", get_offset(), new_offset, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()


func _on_Tween_tween_all_completed():
  emit_signal('done_zooming')
