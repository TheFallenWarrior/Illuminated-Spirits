extends Battler

var rng = RandomNumberGenerator.new()

var estus: = 3
var direction: = Vector3.ZERO

#onready var animationPlayer = $AnimationPlayer
#onready var animationTree = $AnimationTree
#onready var animationState = animationTree.get("parameters/playback")

#enum states{IDLE, WALK, ATTACK, DEATH, ROLL}
#var state = states.IDLE

func _ready():
	rng.randomize()
	add_user_signal("health_changed")
	add_user_signal("estus_qty_changed")
	add_user_signal("stamina_changed")
	speed = 1.5
	acceleration = 8.0
	HP = MHP
	stamina = Mstamina

func choose_action(delta):
	if direction != Vector3.ZERO and $AnimationPlayer.current_animation != "Attack" and $AnimationPlayer.current_animation != "Roll" :
		$AnimationPlayer.current_animation = "Walk"
		look_at(self.translation-direction, Vector3.UP)
		velocity = velocity.move_toward(direction.normalized()*speed, acceleration*delta)
	elif $AnimationPlayer.current_animation != "Attack" and $AnimationPlayer.current_animation != "Roll":
		$AnimationPlayer.current_animation = "Idle"
		velocity = velocity.move_toward(Vector3.ZERO, acceleration*delta)
	
	if Input.is_action_just_pressed("attack"):
		if stamina >= 50 and $AnimationPlayer.current_animation != "Attack" and $AnimationPlayer.current_animation != "Roll" :
			stamina -= 50
			emit_signal("stamina_changed", stamina, Mstamina)
			$AnimationPlayer.current_animation = "Attack"
	
	if Input.is_action_just_pressed("roll") and direction != Vector3.ZERO and $AnimationPlayer.current_animation != "Roll" and stamina >= 50:
		velocity *= 1.65
		stamina -= 30
		emit_signal("stamina_changed", stamina, Mstamina) 
		$AnimationPlayer.current_animation = "Roll"
	
	if Input.is_action_just_pressed("use_estus") and estus > 0:
		estus -= 1
		HP += 100
		if HP > MHP:
			HP = MHP
		emit_signal("health_changed", HP, MHP)
		emit_signal("estus_qty_changed", estus)
	
	if HP <= 0:
		$Sword.visible = false
		$AnimationPlayer.current_animation = "Death"
		set_physics_process(false)
	
	if $AnimationPlayer.current_animation == "Attack":
		velocity = velocity.move_toward(Vector3.ZERO, acceleration*delta)

func _physics_process(delta):
	direction = Vector3(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		0.0,
		Input.get_action_strength("back")-Input.get_action_strength("forward")
	)
	
	choose_action(delta)
	
	if !is_on_floor():
		velocity += gravity*delta
	
	if stamina < Mstamina:
		stamina += 0.35
		emit_signal("stamina_changed", stamina, Mstamina)
	
	$Sword.transform = $Skeleton.get_bone_global_pose(33)
	$CameraHub.rotation = -self.rotation
	velocity = move_and_slide(velocity, Vector3.UP)


func _on_HitDetection_area_entered(area):
	HP -= 50 + (rng.randi()%40)
	emit_signal("health_changed", HP, MHP)
	print(self.name+": oof i've been attacked by "+area.name)
