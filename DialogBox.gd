extends Control

var dialogue_index = 0
var currently_talking = false

var clerkname = null
var gamername = null
var body = null
var tween = null
var sprite = null
var talksound = null

func _ready():
	clerkname = get_node("clerkname")
	gamername = get_node("gamername")
	body = get_node("body")
	tween = get_node("Tween")
	_load_dialog()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && !currently_talking:
		_load_dialog()

func _load_dialog():
	_switch_names(dialogue_index % 2)
	currently_talking = true
	if sprite:
		sprite.hide()
	sprite = null
	match dialogue_index:
		0:
			sprite = get_node("clerkhappy")
			body.bbcode_text = "\nHey! Welcome to Game[color=#ff5277]Shop[/color]: [wave amp=50 freq=3]Home of games.[/wave] How can I help you?"
		1:
			sprite = get_node("gamerhappy")
			body.bbcode_text = "\nYes. I want a game from you."
		2:
			sprite = get_node("clerkhappy")
			body.bbcode_text = "\nOf course! What game are you looking for?"
		3:
			sprite = get_node("gamerhappy")
			body.bbcode_text = "\nI want a copy of the game Control."
		4:
			sprite = get_node("clerkwink")
			body.bbcode_text = "\nOh, I'm very sorry... [wave amp=50 freq=3]we're out of Control.[/wave]"
		5:
			sprite = get_node("gamerangry")
			body.bbcode_text = "\n[shake rate=10 level=10]FOR THIS TRANSGRESSION. YOUR STORE WILL PERISH.[/shake]"
		6:
			sprite = get_node("clerkshocked")
			body.bbcode_text = "\n..."
			talksound.volume_db = -1000
		7:
			sprite = get_node("clerkshocked")
			get_tree().change_scene("res://scenes/scene1.tscn")
			return
	talksound.play()
	sprite.show()
	sprite.playing = true
	body.percent_visible = 0
	tween.interpolate_property(body, "percent_visible", 0, 1, 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	
	if dialogue_index == 4:
		yield(get_tree().create_timer(1.4), "timeout")
		get_node("wink").play()
	
	dialogue_index += 1
	currently_talking = false
	
func _switch_names(index):
	if index == 0:
		clerkname.show()
		gamername.hide()
		talksound = get_node("clerktalk")
	else:
		gamername.show()
		clerkname.hide()
		talksound = get_node("gamertalk")
