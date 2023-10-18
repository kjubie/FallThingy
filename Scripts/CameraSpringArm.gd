extends SpringArm3D

var mouse_sens = 0.3

func _ready():
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):         
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sens
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 30)
		
		rotation_degrees.y -= event.relative.x * mouse_sens
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
