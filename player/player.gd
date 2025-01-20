extends CharacterBody2D

@export var speed: int = 100

func HandleInput():
	var moveDirection = Input.get_vector( "ui_left", "ui_right", "ui_up", "ui_down" )
	velocity = moveDirection*speed
	
func _physics_process(delta):
	HandleInput()
	move_and_slide()
