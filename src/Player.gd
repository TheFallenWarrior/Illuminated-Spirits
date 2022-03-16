extends KinematicBody

var gravity: = Vector3.DOWN * 8
var speed: = 6
var acceleration: = 1
var jump_speed: = 6
var spin = 0.1

var velocity: = Vector3.ZERO
var jump: = false

func get_input():
	var vy = velocity.y
	velocity = Vector3()
	if Input.is_action_pressed("forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("back"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("right"):
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("left"):
		velocity += -transform.basis.x * speed
	velocity.y = vy
	if Input.is_action_just_pressed("jump"):
		jump = true
	else:
		jump = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x > 0:
			rotate_y(-lerp(0, spin, event.relative.x/10))
		elif event.relative.x < 0:
			rotate_y(-lerp(0, spin, event.relative.x/10))

# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()
	velocity += gravity*delta
	if jump and is_on_floor():
		velocity.y = jump_speed
	velocity = move_and_slide(velocity, Vector3.UP)
