# VR Controller Interaction System
extends Node3D

signal controller_button_pressed(controller, button)
signal controller_button_released(controller, button)
signal controller_moved(controller, position, rotation)

# Controller references
@onready var left_controller = $"../XROrigin3D/LeftController"
@onready var right_controller = $"../XROrigin3D/RightController"

# Visual elements for controllers
var left_model
var right_model

# Ray for pointing and interaction
var left_ray
var right_ray

# Interaction state
var hovering_object = null
var selected_object = null
var active_controller = null

func _ready():
	# Initialize controller models and rays
	print("VR Controller Interaction System initialized")
	
	# Set up controller models
	setup_controller_models()
	
	# Set up interaction rays
	setup_interaction_rays()
	
	# Connect controller signals
	connect_controller_signals()

func setup_controller_models():
	# Create visual models for controllers
	# In a real implementation, we would load proper 3D models
	left_model = CSGBox3D.new()
	left_model.size = Vector3(0.05, 0.05, 0.2)
	left_controller.add_child(left_model)
	
	right_model = CSGBox3D.new()
	right_model.size = Vector3(0.05, 0.05, 0.2)
	right_controller.add_child(right_model)

func setup_interaction_rays():
	# Create rays for controller pointing
	left_ray = RayCast3D.new()
	left_ray.target_position = Vector3(0, 0, -10)  # 10 meters forward
	left_ray.collision_mask = 1
	left_ray.enabled = true
	left_controller.add_child(left_ray)
	
	# Visual indicator for the ray
	var left_line = CSGCylinder3D.new()
	left_line.radius = 0.003
	left_line.height = 10
	left_line.position = Vector3(0, 0, -5)  # Center of the ray
	left_line.rotation_degrees.x = 90  # Point forward
	var left_material = StandardMaterial3D.new()
	left_material.albedo_color = Color(0.2, 0.5, 1.0, 0.5)
	left_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	left_line.material = left_material
	left_controller.add_child(left_line)
	
	# Right controller ray
	right_ray = RayCast3D.new()
	right_ray.target_position = Vector3(0, 0, -10)  # 10 meters forward
	right_ray.collision_mask = 1
	right_ray.enabled = true
	right_controller.add_child(right_ray)
	
	# Visual indicator for the ray
	var right_line = CSGCylinder3D.new()
	right_line.radius = 0.003
	right_line.height = 10
	right_line.position = Vector3(0, 0, -5)  # Center of the ray
	right_line.rotation_degrees.x = 90  # Point forward
	var right_material = StandardMaterial3D.new()
	right_material.albedo_color = Color(1.0, 0.5, 0.2, 0.5)
	right_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	right_line.material = right_material
	right_controller.add_child(right_line)

func connect_controller_signals():
	# Connect XR controller input signals
	left_controller.button_pressed.connect(_on_left_controller_button_pressed)
	left_controller.button_released.connect(_on_left_controller_button_released)
	
	right_controller.button_pressed.connect(_on_right_controller_button_pressed)
	right_controller.button_released.connect(_on_right_controller_button_released)

func _process(delta):
	# Update controller positions and check for interactions
	update_controller_rays()
	check_hover_interactions()
	
	# Emit controller movement signals
	emit_signal("controller_moved", "left", left_controller.global_position, left_controller.global_rotation)
	emit_signal("controller_moved", "right", right_controller.global_position, right_controller.global_rotation)

func update_controller_rays():
	# Update ray interactions
	if left_ray.is_colliding():
		var collider = left_ray.get_collider()
		var collision_point = left_ray.get_collision_point()
		handle_ray_collision("left", collider, collision_point)
	
	if right_ray.is_colliding():
		var collider = right_ray.get_collider()
		var collision_point = right_ray.get_collision_point()
		handle_ray_collision("right", collider, collision_point)

func handle_ray_collision(controller_name, collider, collision_point):
	# Handle ray collision with objects
	if collider.has_method("interact"):
		hovering_object = collider
	elif collider.get_parent().has_method("interact"):
		hovering_object = collider.get_parent()

func check_hover_interactions():
	# Handle hover interactions
	if hovering_object and hovering_object.has_method("hover"):
		hovering_object.hover()

func _on_left_controller_button_pressed(button):
	emit_signal("controller_button_pressed", "left", button)
	handle_button_press("left", button)

func _on_left_controller_button_released(button):
	emit_signal("controller_button_released", "left", button)
	handle_button_release("left", button)

func _on_right_controller_button_pressed(button):
	emit_signal("controller_button_pressed", "right", button)
	handle_button_press("right", button)

func _on_right_controller_button_released(button):
	emit_signal("controller_button_released", "right", button)
	handle_button_release("right", button)

func handle_button_press(controller_name, button):
	# Handle different button presses
	if button == "trigger_click" or button == "grip_click":
		if hovering_object and hovering_object.has_method("interact"):
			selected_object = hovering_object
			active_controller = controller_name
			hovering_object.interact(controller_name)
	
	# Handle specific buttons for tower defense gameplay
	if button == "primary_click":  # A/X button
		# Start tower placement mode
		var tower_placement = get_node_or_null("/root/Main/TowerPlacement")
		if tower_placement:
			tower_placement.start_tower_placement("Basic Tower")
	
	if button == "secondary_click":  # B/Y button
		# Cancel current action
		var tower_placement = get_node_or_null("/root/Main/TowerPlacement")
		if tower_placement and tower_placement.is_placing_tower:
			tower_placement.cancel_tower_placement()

func handle_button_release(controller_name, button):
	# Handle button releases
	if button == "trigger_click" or button == "grip_click":
		if selected_object and selected_object.has_method("interact_release"):
			selected_object.interact_release(controller_name)
			
		selected_object = null
		active_controller = null
