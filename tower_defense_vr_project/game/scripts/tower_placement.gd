# Tower Placement System
extends Node3D

signal tower_selected(tower_type)
signal tower_placed(tower_type, position)

# References to game components
@onready var game_manager = $"/root/GameManager"

# Tower placement variables
var is_placing_tower = false
var current_tower_type = ""
var tower_preview = null
var valid_placement = false

# Grid settings
var grid_size = 1.0
var grid_height = 0.0

func _ready():
	# Initialize tower placement system
	print("Tower Placement System initialized")

func _process(delta):
	if is_placing_tower and tower_preview:
		update_tower_preview_position()

func start_tower_placement(tower_type):
	if game_manager.get_tower_data(tower_type):
		current_tower_type = tower_type
		is_placing_tower = true
		create_tower_preview()
		print("Started placement for " + tower_type)

func create_tower_preview():
	# In a real implementation, we would instantiate a semi-transparent model
	# For now, we'll just create a placeholder
	tower_preview = CSGBox3D.new()
	tower_preview.size = Vector3(0.8, 1.5, 0.8)
	tower_preview.material = StandardMaterial3D.new()
	tower_preview.material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	tower_preview.material.albedo_color = Color(0, 1, 0, 0.5)  # Green for valid placement
	add_child(tower_preview)

func update_tower_preview_position():
	# In VR, this would use the controller's position
	# For now, we'll use a placeholder position
	var ray_origin = get_viewport().get_camera_3d().global_position
	var ray_direction = -get_viewport().get_camera_3d().global_transform.basis.z
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * 100)
	var result = space_state.intersect_ray(query)
	
	if result:
		var pos = result.position
		# Snap to grid
		pos.x = round(pos.x / grid_size) * grid_size
		pos.z = round(pos.z / grid_size) * grid_size
		pos.y = grid_height
		
		tower_preview.global_position = pos
		
		# Check if placement is valid
		check_placement_validity(pos)

func check_placement_validity(position):
	# Check if the position is valid for tower placement
	# For now, we'll just use a simple check
	valid_placement = true
	
	# Update preview color based on validity
	if valid_placement:
		tower_preview.material.albedo_color = Color(0, 1, 0, 0.5)  # Green for valid
	else:
		tower_preview.material.albedo_color = Color(1, 0, 0, 0.5)  # Red for invalid

func confirm_tower_placement():
	if is_placing_tower and valid_placement:
		var position = tower_preview.global_position
		
		# Try to place the tower using the game manager
		if game_manager.place_tower(current_tower_type, position):
			emit_signal("tower_placed", current_tower_type, position)
			print("Tower placed at " + str(position))
		
		cancel_tower_placement()

func cancel_tower_placement():
	is_placing_tower = false
	current_tower_type = ""
	
	if tower_preview:
		tower_preview.queue_free()
		tower_preview = null
