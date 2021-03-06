tool
extends Sprite

export var emission_color: Gradient = Gradient.new() setget _set_gradient

var debug_dissolve_control := 0.0 setget _set_debug_control

var frame_count := 0

onready var tween := $Tween


func _ready() -> void:
	if Engine.editor_hint:
		emission_color.connect("changed", self, "_gradient_changed")


func dissolve() -> void:
	tween.interpolate_method(self, "dissolve_amount", 0, 1, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_method(self, "dissolve_color", 0, 1, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func dissolve_amount(value: float) -> void:
	material.set_shader_param("dissolve_amount", value)


func dissolve_color(value: float) -> void:
	material.set_shader_param("burn_color", emission_color.interpolate(value))


func _set_debug_control(value: float) -> void:
	debug_dissolve_control = value
	if Engine.editor_hint:
		dissolve_amount(value)
		dissolve_color(value)


func _set_gradient(value: Gradient) -> void:
	emission_color = value
	if Engine.editor_hint:
		material.set_shader_param("burn_color", emission_color.interpolate(debug_dissolve_control))


func _gradient_changed() -> void:
	if Engine.editor_hint:
		print(debug_dissolve_control)
		material.set_shader_param("burn_color", emission_color.interpolate(debug_dissolve_control))
