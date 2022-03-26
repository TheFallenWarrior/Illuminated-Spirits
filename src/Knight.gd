extends Battler

var rng = RandomNumberGenerator.new()

var estus: = 3
var xp: = 0
var level: = 0 
var direction: = Vector3.ZERO

func _ready():
	rng.randomize()
	add_user_signal("health_changed")
	add_user_signal("estus_qty_changed")
	add_user_signal("stamina_changed")
	add_user_signal("xp_level_changed")
	speed = 1.5
	acceleration = 8.0
	hp = mhp
	stamina = mstamina

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
			emit_signal("stamina_changed", stamina, mstamina)
			$AnimationPlayer.current_animation = "Attack"
	
	if Input.is_action_just_pressed("roll") and direction != Vector3.ZERO and $AnimationPlayer.current_animation != "Roll" and stamina >= 50:
		velocity *= 1.65
		stamina -= 30
		emit_signal("stamina_changed", stamina, mstamina) 
		$AnimationPlayer.current_animation = "Roll"
	
	if Input.is_action_just_pressed("use_estus") and estus > 0:
		estus -= 1
		hp += 100
		if hp > mhp:
			hp = mhp
		emit_signal("health_changed", hp, mhp)
		emit_signal("estus_qty_changed", estus)
	
	if hp <= 0:
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
	
	if stamina < mstamina:
		stamina += 0.35
		emit_signal("stamina_changed", stamina, mstamina)
	
	$Sword.transform = $Skeleton.get_bone_global_pose(33)
	$CameraHub.rotation = -self.rotation
	velocity = move_and_slide(velocity, Vector3.UP)

func enemy_killed(en_xp):
	xp += en_xp + (rng.randi()%10)
	if xp >= 500:
		xp -= 500
		level += 1
	emit_signal("xp_level_changed", xp, level)

# warning-ignore:unused_argument
func _on_HitDetection_area_entered(area):
	hp -= 50 + (rng.randi()%40)
	emit_signal("health_changed", hp, mhp)
