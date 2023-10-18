extends CharacterBody3D

const SPEED = 5
const JUMP_VELOCITY = 7

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lastMoveAndSlideState = false
var startingHeight = null

@export var health = 100

@onready var main = get_node("/root/Main")
@onready var springArm = $CameraSpringArm

func _physics_process(delta):
	var currentSpeed = SPEED
	var jumpSpeed = SPEED / 2
	var onFloor = true
	
	print(startingHeight)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		onFloor = false
			
		if lastMoveAndSlideState:
			startingHeight = null
			
		elif startingHeight == null or startingHeight < position.y:
			startingHeight = position.y
			
	elif startingHeight != null and onFloor:
		var distance = startingHeight - position.y
		if distance > 6:
			var damage = (distance - 6) * 10
			takeDamage(damage)
			
		startingHeight = null
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or lastMoveAndSlideState):
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, springArm.rotation.y).normalized()
	
	if direction:
		if not onFloor:
			velocity.x += direction.x * jumpSpeed * 0.12
			if abs(velocity.x) > currentSpeed:
				velocity.x = direction.x * currentSpeed
				
			velocity.z += direction.z * jumpSpeed * 0.12
			if abs(velocity.z) > currentSpeed:
				velocity.z = direction.z * currentSpeed
		else:
			velocity.x = direction.x * currentSpeed
			velocity.z = direction.z * currentSpeed
	else:
		if onFloor:
			velocity.x = move_toward(velocity.x, 0, currentSpeed)
			velocity.z = move_toward(velocity.z, 0, currentSpeed)
			
	lastMoveAndSlideState = move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		#model.rotation.y = lookdirection.angle()
	
func _process(delta):
	springArm.position = position
	
func _ready():
	floor_max_angle = 0.349066
	
func takeDamage(amount):
	health -= amount 
	
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
