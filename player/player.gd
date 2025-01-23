extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 100
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtBox = $hurtBox
@onready var hurtTimer = $hurtTimer


@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 500

@export var inventory : Inventory

var isHurt : bool = false


func _ready():
	effects.play("RESET")

func HandleInput():
	var moveDirection = Input.get_vector( "ui_left", "ui_right", "ui_up", "ui_down" )
	velocity = moveDirection*speed
	
func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animations.play("walk" + direction)
		
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
	
	
func _physics_process(delta):
	HandleInput()
	move_and_slide()
	updateAnimation()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnnemy(area)

func hurtByEnnemy(area):
	currentHealth -= 1
	if currentHealth < 0:
		currentHealth = maxHealth
			
	healthChanged.emit(currentHealth)
	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false


func _on_hurt_box_area_entered(area:): 
	if area.has_method("collect"):
		area.collect(inventory)
		
func knockback(EnnemyVelocity : Vector2):
	var knockbackDirection = (EnnemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	

func _on_hurt_box_area_exited(area): pass
