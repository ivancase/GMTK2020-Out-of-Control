extends RigidBody2D

export (int) var MAX_POWER = 2000
export (int) var STICK_COMPRESSION = 7

var is_rolling = false
var shot_power = 0
var anim = null
var shots = 0

var sound = null
var squeaks = []
var booms = []
var honks = []

var destroyed_objects = []
var default_pos = null

var particle = load("res://scenes/DeathParticle.tscn")

func _ready():
	anim = find_node("AnimatedSprite")
	sound = find_node("sound")
	default_pos = position
	for i in range(5):
		squeaks.append(load("res://sounds/squeak" + str(i+1) + (".wav")))
	for i in range(2):
		booms.append(load("res://sounds/bounce" + str(i+1) + (".wav")))
	for i in range(3):
		honks.append(load("res://sounds/honk" + str(i+1) + (".wav")))
	
func _draw():
	var max_length = MAX_POWER / STICK_COMPRESSION
	var clamped_pos = get_local_mouse_position().clamped(max_length)
	draw_line(Vector2(), 
				clamped_pos, 
				Color(clamped_pos.length() / max_length, 0, 0, int(Input.is_action_pressed("click") && !is_rolling)),
				4)
		

func _physics_process(delta):
	get_parent().get_node("shots").bbcode_text = "shots: " + str(shots) + "\n par:  " + str(get_parent().get_par_amt())
	var speed = linear_velocity.length() / 100
	anim.speed_scale = speed
	if speed > 0.5:
		is_rolling = true
	else:
		is_rolling = false
	update()
	
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("click") && !is_rolling:
		shot_power = clamp(int(get_local_mouse_position().length() * STICK_COMPRESSION), 0, MAX_POWER)
	if Input.is_action_just_released("click") && !is_rolling:
		apply_central_impulse(-Vector2(1, 0).rotated(rotation) * shot_power)
		shot_power = 0
		shots += 1
		
		if !anim.playing:
			anim.play()
			
		sound.stream = honks[randi() % honks.size()]
		sound.play()
	if Input.is_action_just_pressed("restart"):
		_restart()
		
	for body in get_colliding_bodies():
		if body.is_in_group("Destroyable") && !body.is_destroyed:
			var node = particle.instance()
			get_parent().add_child(node)
			node.position = body.position
			node.scale = body.scale
			node.look_at(global_position)
			
			body.destroy()
			destroyed_objects.append(body)
			
			Engine.time_scale = 0.01
			
			sound.pitch_scale = 2 / speed
			sound.stream = booms[randi() % booms.size()]
			sound.play()
			
			yield(get_tree().create_timer(speed / 750), "timeout")
			
			sound.pitch_scale = 1
			
			Engine.time_scale = 1
			
			linear_velocity *= 1.5 * body.scale.x
			linear_velocity = linear_velocity.clamped(2000)
			print(linear_velocity)
			
			if destroyed_objects.size() == get_parent().get_win_amt():
				get_parent().open_exit()
				
		elif body.is_in_group("Exit"):
			get_parent().win()
		elif body.is_in_group("Kill"):
			_restart()
		elif body.is_in_group("Rocket"):
			get_tree().change_scene("res://scenes/final_cutscene.tscn")
		else:
			sound.stream = squeaks[randi() % squeaks.size()]
			sound.play()

func _restart():
	shots = 0
	for obj in destroyed_objects:
		obj.undestroy()
	destroyed_objects.clear()
	position = default_pos
	linear_velocity = Vector2()
