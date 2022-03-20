extends Battler

var rng = RandomNumberGenerator.new()

var estus: = 3

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	rng.randomize()
	add_user_signal("health_changed")
	add_user_signal("estus_qty_changed")
	add_user_signal("stamina_changed")
	speed = 1.5
	acceleration = 5.0
	HP = MHP
	stamina = Mstamina

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
	
	if Input.is_action_just_pressed("attack"):
		if stamina >= 50:
			stamina -= 50
			emit_signal("stamina_changed", stamina, Mstamina)
			animationState.travel("Attack")
	
	if Input.is_action_pressed("roll"):
		animationState.travel("Roll")
	
	if Input.is_action_just_pressed("use_estus"):
		estus -= 1
		HP += 100
		if HP > MHP:
			HP = MHP
		emit_signal("health_changed", HP, MHP)
		emit_signal("estus_qty_changed", estus)
	
	if HP <= 0:
		animationState.travel("Death")
		$Sword.visible = false
		set_physics_process(false)
	
	if !is_on_floor():
		velocity += gravity*delta
	
	if stamina != Mstamina:
		stamina += 1
		emit_signal("stamina_changed", stamina, Mstamina)
	
	$Sword.transform = $Skeleton.get_bone_global_pose(33)
	$CameraHub.rotation = -self.rotation
	velocity = move_and_slide(velocity, Vector3.UP)


func _on_HitDetection_area_entered(area):
	if true:
		HP -= 50 + (rng.randi()%40)
		emit_signal("health_changed", HP, MHP)
		print(self.name+": oof i've been attacked by "+area.name)
