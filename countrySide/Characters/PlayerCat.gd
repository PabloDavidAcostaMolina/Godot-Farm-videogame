extends KinematicBody2D

export  var move_speed : float = 100
export var starting_direction: Vector2 = Vector2.ZERO - Vector2(0, 1)

onready var animation_tree: AnimationTree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")

var velocity = Vector2()

func _ready():
	update_animation_parameters(starting_direction)


func _physics_process(_delta):
	#Establee la dirección de entrada
	var input_direction = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	#Actualiza la velocidad
	velocity = input_direction * move_speed
	
	#usa la velocidad del cuerpo del personaje para mover el personaje en el mapa
	move_and_slide(velocity)
	
	#
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	#no cambia parametros de animación si no hay direccion de entrada
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)
		
func pick_new_state():
	# escoje el estado basandose en que está pasando con el jugador
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
