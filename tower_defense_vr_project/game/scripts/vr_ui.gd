# VR UI System for Tower Defense
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"
@onready var vr_interaction = $"/root/Main/VRInteraction"

# UI elements
var health_display
var money_display
var wave_display
var game_status_display

# UI positioning
var ui_distance = 0.5  # Distance from camera
var ui_height = -0.2   # Height offset from camera center

func _ready():
	# Initialize VR UI system
	print("VR UI System initialized")
	
	# Create UI elements
	create_ui_elements()
	
	# Position UI elements in front of the camera
	position_ui_elements()

func _process(delta):
	# Update UI elements with current game state
	update_ui_elements()
	
	# Keep UI positioned relative to the camera
	follow_camera()

func create_ui_elements():
	# Create a panel to hold UI elements
	var ui_panel = CSGBox3D.new()
	ui_panel.name = "UIPanel"
	ui_panel.size = Vector3(0.4, 0.15, 0.01)
	ui_panel.material = StandardMaterial3D.new()
	ui_panel.material.albedo_color = Color(0.2, 0.2, 0.3, 0.7)
	ui_panel.material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	add_child(ui_panel)
	
	# Create 3D text for health display
	health_display = Label3D.new()
	health_display.text = "Health: 100"
	health_display.font_size = 12
	health_display.position = Vector3(-0.15, 0.05, 0.01)
	health_display.modulate = Color(0.8, 0.2, 0.2)
	ui_panel.add_child(health_display)
	
	# Create 3D text for money display
	money_display = Label3D.new()
	money_display.text = "Money: 100"
	money_display.font_size = 12
	money_display.position = Vector3(0.15, 0.05, 0.01)
	money_display.modulate = Color(0.2, 0.8, 0.2)
	ui_panel.add_child(money_display)
	
	# Create 3D text for wave display
	wave_display = Label3D.new()
	wave_display.text = "Wave: 0/10"
	wave_display.font_size = 12
	wave_display.position = Vector3(-0.15, -0.05, 0.01)
	wave_display.modulate = Color(0.2, 0.2, 0.8)
	ui_panel.add_child(wave_display)
	
	# Create 3D text for game status
	game_status_display = Label3D.new()
	game_status_display.text = "Ready to Start"
	game_status_display.font_size = 12
	game_status_display.position = Vector3(0.15, -0.05, 0.01)
	game_status_display.modulate = Color(0.8, 0.8, 0.2)
	ui_panel.add_child(game_status_display)

func position_ui_elements():
	# Position UI in front of the camera
	var camera = $"../XROrigin3D/XRCamera3D"
	if camera:
		var forward = -camera.global_transform.basis.z
		var position = camera.global_position + (forward * ui_distance)
		position.y += ui_height
		
		global_position = position
		look_at(camera.global_position, Vector3.UP)
		rotation.x = 0  # Keep UI upright

func update_ui_elements():
	# Update UI with current game state
	if game_manager:
		health_display.text = "Health: " + str(game_manager.player_health)
		money_display.text = "Money: " + str(game_manager.player_money)
		wave_display.text = "Wave: " + str(game_manager.current_wave) + "/" + str(game_manager.max_waves)
		
		if game_manager.game_running:
			game_status_display.text = "Game Running"
		else:
			game_status_display.text = "Ready to Start"

func follow_camera():
	# Keep UI positioned in front of the camera
	var camera = $"../XROrigin3D/XRCamera3D"
	if camera:
		var forward = -camera.global_transform.basis.z
		var position = camera.global_position + (forward * ui_distance)
		position.y += ui_height
		
		global_position = position
		look_at(camera.global_position, Vector3.UP)
		rotation.x = 0  # Keep UI upright
