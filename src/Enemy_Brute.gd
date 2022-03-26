extends Battler

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum states{IDLE, CHASE, ATTACK, DEATH}
var state = states.IDLE
var target
const XP = 95

func _ready():
	mhp = 240
	hp = mhp
	stamina = mstamina
	add_user_signal("enemy_killed")
	$HealthBar3D/Viewport/HealthBar.max_value = mhp
	$HealthBar3D/Viewport/HealthBar.value = hp
	speed = 1.2

func choose_action():
	match state:
		states.CHASE:
			look_at(self.translation - (target-self.translation), Vector3.UP)
			velocity = (target-self.translation).normalized()*speed
			if velocity.x == 0.0 and velocity.z == 0.0:
				state = states.IDLE
			animationState.travel("walk_forward")
		
		states.ATTACK:
			if stamina < 50:
				return
			look_at(self.translation - (target-self.translation), Vector3.UP)
			velocity = Vector3.ZERO
			stamina -= 50
			animationState.travel("attack_brute")
			
		states.IDLE:
			velocity = Vector3.ZERO
			animationState.travel("idle")
		
		states.DEATH: #fix this later
			emit_signal("enemy_killed", XP)
			print(self.name+" was killed.")
			queue_free()
			#velocity = Vector3.ZERO
			#$Axe.visible = false
			#animationState.travel("death")
			#set_physics_process(false)

func _physics_process(delta):
	choose_action()
	velocity += gravity*delta
	$Axe.transform = $Skeleton.get_bone_global_pose(36)
	$Axe.scale.z = -1
	$Axe.scale.x = -1
	self.rotation_degrees.x = 0
	self.rotation_degrees.z = 0
	
	if stamina < mstamina:
		stamina += 0.35
	velocity = move_and_slide(velocity, Vector3.UP)


# warning-ignore:unused_argument
func _on_HitDetection_area_entered(area):
	hp -= 40
	$HealthBar3D/Viewport/HealthBar.value = hp
	if hp <= 0:
		state = states.DEATH

func _on_DetectRadius_body_entered(body):
	if body.name != "StaticBody": 
		state = states.CHASE
		target = body.transform.origin

func _on_AttackRadius_body_entered(body):
	if body.name != "StaticBody": 
		state = states.ATTACK

func _on_AttackRadius_body_exited(body):
	if body.name != "StaticBody": 
		state = states.CHASE
		target = body.transform.origin

# warning-ignore:unused_argument
func _on_DetectRadius_body_exited(body):
	state = states.IDLE


func _on_DetectUpdate_body_entered(body):
	if body.name != "StaticBody": 
		state = states.CHASE
		target = body.transform.origin
