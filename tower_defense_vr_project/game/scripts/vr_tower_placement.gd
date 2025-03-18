# VR Tower Placement Controller
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"
@onready var tower_placement = $"/root/Main/TowerPlacement"
@onready var vr_interaction = $"/root/Main/VRInteraction"

# Tower selection variables
var available_tower_buttons = []
var selected_tower_type = ""

# Tower placement state
var is_placing_tower = false

func _ready():
	# Initialize VR tower placement controller
	print("VR Tower Placement Controller initialized")
	
	# Connect to VR interaction signals
	vr_interaction.controller_button_pressed.connect(_on_controller_button_pressed)
	vr_interaction.controller_button_released.connect(_on_controller_button_released)
	vr_interaction.controller_moved.connect(_on_controller_moved)
	
	# Connect to tower placement signals
	tower_placement.tower_placed.connect(_on_tower_placed)
	
	# Create tower selection UI
	create_tower_selection_ui()

func create_tower_selection_ui():
	# Create a UI panel attached to the left controller for tower selection
	var ui_panel = Node3D.new()
	ui_panel.name = "TowerSelectionPanel"
	$"../XROrigin3D/LeftController".add_child(ui_panel)
	
	# Position the panel above the controller
	ui_panel.position = Vector3(0, 0.1, 0)
	
	# Create a background for the panel
	var panel_bg = CSGBox3D.new()
	panel_bg.size = Vector3(0.2, 0.15, 0.01)
	panel_bg.material = StandardMaterial3D.new()
	panel_bg.material.albedo_color = Color(0.2, 0.2, 0.3, 0.8)
	panel_bg.material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ui_panel.add_child(panel_bg)
	
	# Create buttons for each tower type
	var tower_types = ["Basic Tower", "Cannon Tower", "Sniper Tower"]
	var button_size = Vector3(0.05, 0.05, 0.01)
	var spacing = 0.06
	var start_x = -0.07
	
	for i in range(tower_types.size()):
		var tower_type = tower_types[i]
		var button = CSGBox3D.new()
		button.size = button_size
		button.position = Vector3(start_x + (i * spacing), 0, 0.01)
		button.material = StandardMaterial3D.new()
		button.material.albedo_color = Color(0.5, 0.5, 0.8)
		
		# Add collision shape for interaction
		var collision = CollisionShape3D.new()
		var shape = BoxShape3D.new()
		shape.size = button_size
		collision.shape = shape
		
		var area = Area3D.new()
		area.add_child(collision)
		area.input_ray_pickable = true
		area.set_meta("tower_type", tower_type)
		
		# Connect area signals
		area.mouse_entered.connect(_on_tower_button_hover.bind(area, button))
		area.mouse_exited.connect(_on_tower_button_exit.bind(area, button))
		
		button.add_child(area)
		ui_panel.add_child(button)
		available_tower_buttons.append({"area": area, "button": button, "tower_type": tower_type})

func _on_tower_button_hover(area, button):
	# Visual feedback when hovering over a tower button
	button.material.albedo_color = Color(0.7, 0.7, 1.0)

func _on_tower_button_exit(area, button):
	# Reset visual feedback when no longer hovering
	button.material.albedo_color = Color(0.5, 0.5, 0.8)

func _on_controller_button_pressed(controller, button):
	# Handle controller button presses for tower placement
	if controller == "right" and button == "trigger_click":
		# Check if pointing at a tower button
		for tower_button in available_tower_buttons:
			if vr_interaction.hovering_object == tower_button.area:
				select_tower_type(tower_button.tower_type)
				return
		
		# If placing a tower and pointing at the ground, place the tower
		if is_placing_tower and tower_placement.is_placing_tower:
			tower_placement.confirm_tower_placement()
	
	# Use grip button to cancel tower placement
	if (controller == "right" or controller == "left") and button == "grip_click":
		if is_placing_tower:
			cancel_tower_placement()

func _on_controller_button_released(controller, button):
	# Handle controller button releases
	pass

func _on_controller_moved(controller, position, rotation):
	# Update tower preview position based on right controller position
	if controller == "right" and is_placing_tower:
		# Tower placement is handled by the tower_placement system
		# which uses raycasting from the controller
		pass

func select_tower_type(tower_type):
	# Select a tower type and start placement mode
	selected_tower_type = tower_type
	is_placing_tower = true
	
	# Start tower placement in the tower placement system
	tower_placement.start_tower_placement(tower_type)
	
	print("Selected tower type: " + tower_type)

func cancel_tower_placement():
	# Cancel tower placement mode
	selected_tower_type = ""
	is_placing_tower = false
	
	# Cancel in the tower placement system
	tower_placement.cancel_tower_placement()
	
	print("Tower placement cancelled")

func _on_tower_placed(tower_type, position):
	# Tower has been successfully placed
	is_placing_tower = false
	print("Tower placed: " + tower_type + " at " + str(position))
	
	# Automatically start placing another tower of the same type
	# This is a common UX pattern in tower defense games
	select_tower_type(tower_type)
