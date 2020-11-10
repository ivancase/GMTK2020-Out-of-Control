extends Control

var dialogue_index = 0
var currently_talking = false

var clerkname = null
var body = null
var tween = null
var sprite = null

func _ready():
	clerkname = get_node("clerkname")
	body = get_node("body")
	tween = get_node("Tween")
	_load_dialog()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && !currently_talking:
		_load_dialog()

func _load_dialog():
	get_node("clerktalk").play()
	currently_talking = true
	if sprite:
		sprite.hide()
	sprite = null
	match dialogue_index:
		0:
			sprite = get_node("clerkshocked")
			body.bbcode_text = "\nGamer died on the way to his home planet. I will never forget him."
		1:
			sprite = get_node("clerkshocked")
			body.bbcode_text = "\nHis fate was..."
		2:
			sprite = get_node("clerkwink")
			body.bbcode_text = "[wave amp=50 freq=3]Out of our control.[/wave]"
		3:
			body.bbcode_text = "The end! Thank you for playing."
			return
	sprite.show()
	sprite.playing = true
	body.percent_visible = 0
	tween.interpolate_property(body, "percent_visible", 0, 1, 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	
	if dialogue_index == 2:
		yield(get_tree().create_timer(1), "timeout")
		get_node("wink").play()
	
	dialogue_index += 1
	currently_talking = false
