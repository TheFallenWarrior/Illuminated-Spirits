extends Battler

var rng = RandomNumberGenerator.new()

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	rng.randomize()
	add_user_signal("health_changed")
	speed = 0.8
	acceleration = 5.0
	HP = MHP

# warning-ignore:unused_argument
func _physics_process(delta):
	#emit_signal("health_changed", HP, MHP)
	var direction: = Vector3(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		0.0,
		Input.get_action_strength("back")-Input.get_action_strength("forward")
	)
	
	if direction != Vector3.ZERO:
		look_at(self.translation-direction, Vector3.UP)
		velocity = velocity.move_toward(direction.normalized()*speed, acceleration*delta)
		animationState.travel("Walk")
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector3.ZERO, acceleration*delta)
	
	if Input.is_action_pressed("attack"):
		animationState.travel("Attack")
	
	if Input.is_action_pressed("roll"):
		animationState.travel("Roll")
	
	if HP <= 0:
		animationState.travel("Death")
		$Sword.visible = false
		set_physics_process(false)
	
	velocity += gravity*delta
	
	$Sword.transform = $Skeleton.get_bone_global_pose(33)
	$CameraHub.rotation = -self.rotation
	velocity = move_and_slide(velocity, Vector3.UP)


func _on_HitDetection_area_entered(area):
	if area.name != "DetectRadius" and area.name != "AttackRadius":
		HP -= rng.randi()%80
		emit_signal("health_changed", HP, MHP)
		print(self.name+": oof i've been attacked by "+area.name)
