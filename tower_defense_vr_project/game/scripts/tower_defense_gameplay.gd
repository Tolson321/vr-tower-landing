# Tower Defense Gameplay Implementation
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"
@onready var tower_placement = $"/root/Main/TowerPlacement"
@onready var enemy_system = $"/root/Main/EnemySystem"

# Tower mechanics
var tower_scenes = {}
var active_towers = []

# Game state
var game_started = false
var wave_in_progress = false

func _ready():
	# Initialize tower defense gameplay
	print("Tower Defense Gameplay initialized")
	
	# Load tower scenes
	preload_tower_scenes()
	
	# Connect signals
	tower_placement.tower_placed.connect(_on_tower_placed)
	enemy_system.enemy_reached_end.connect(_on_enemy_reached_end)
	enemy_system.enemy_killed.connect(_on_enemy_killed)

func _process(delta):
	# Update tower targeting and attacks
	if game_started:
		update_towers(delta)

func preload_tower_scenes():
	# In a real implementation, we would load actual tower scenes
	# For now, we'll create placeholder data
	tower_scenes = {
		"Basic Tower": {
			"damage": 5,
			"range": 5.0,
			"fire_rate": 1.0,
			"color": Color(0.2, 0.5, 1.0)
		},
		"Cannon Tower": {
			"damage": 15,
			"range": 4.0,
			"fire_rate": 0.5,
			"color": Color(0.8, 0.3, 0.1)
		},
		"Sniper Tower": {
			"damage": 30,
			"range": 10.0,
			"fire_rate": 0.25,
			"color": Color(0.1, 0.8, 0.3)
		}
	}

func start_game():
	# Start the tower defense game
	game_started = true
	game_manager.start_game()
	print("Tower Defense Game started")

func _on_tower_placed(tower_type, position):
	# Create a new tower at the specified position
	create_tower(tower_type, position)

func create_tower(tower_type, position):
	# Create a tower instance
	var tower_data = tower_scenes[tower_type]
	
	# Create a visual representation of the tower
	var tower_model = CSGCylinder3D.new()
	tower_model.radius = 0.4
	tower_model.height = 1.5
	tower_model.position = position
	tower_model.position.y = tower_model.height / 2
	
	# Set tower material
	var material = StandardMaterial3D.new()
	material.albedo_color = tower_data.color
	tower_model.material = material
	
	# Create a turret on top of the tower
	var turret = CSGBox3D.new()
	turret.size = Vector3(0.3, 0.2, 0.8)
	turret.position = Vector3(0, tower_model.height / 2 + 0.1, 0)
	tower_model.add_child(turret)
	
	# Add tower to the scene
	add_child(tower_model)
	
	# Create tower data structure
	var tower = {
		"type": tower_type,
		"model": tower_model,
		"turret": turret,
		"position": position,
		"range": tower_data.range,
		"damage": tower_data.damage,
		"fire_rate": tower_data.fire_rate,
		"fire_timer": 0.0,
		"target": null
	}
	
	# Add to active towers list
	active_towers.append(tower)
	
	# Create a range indicator
	create_range_indicator(tower)
	
	print("Tower created: " + tower_type + " at " + str(position))

func create_range_indicator(tower):
	# Create a visual indicator for the tower's range
	var range_indicator = CSGCylinder3D.new()
	range_indicator.radius = tower.range
	range_indicator.height = 0.05
	range_indicator.position = Vector3(0, 0.05, 0)
	
	# Set range indicator material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(tower.model.material.albedo_color, 0.2)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	range_indicator.material = material
	
	# Add to tower model
	tower.model.add_child(range_indicator)
	tower.range_indicator = range_indicator

func update_towers(delta):
	# Update all active towers
	for tower in active_towers:
		# Find target if none exists
		if tower.target == null or not is_instance_valid(tower.target):
			tower.target = find_target_for_tower(tower)
		
		# If target exists, aim and fire
		if tower.target != null:
			aim_tower_at_target(tower)
			
			# Update fire timer
			tower.fire_timer += delta
			if tower.fire_timer >= 1.0 / tower.fire_rate:
				fire_tower(tower)
				tower.fire_timer = 0.0

func find_target_for_tower(tower):
	# Find the closest enemy within range
	var closest_enemy = null
	var closest_distance = tower.range + 1.0  # Start with something larger than range
	
	for enemy in enemy_system.active_enemies:
		var distance = tower.position.distance_to(enemy.node.position)
		if distance <= tower.range and distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	
	return closest_enemy

func aim_tower_at_target(tower):
	# Aim the turret at the target
	if tower.target != null:
		var direction = tower.target.node.position - tower.model.position
		direction.y = 0  # Keep turret level horizontally
		
		if direction.length() > 0.01:
			var look_at_pos = tower.model.position + direction.normalized()
			tower.turret.look_at(look_at_pos, Vector3.UP)

func fire_tower(tower):
	# Fire the tower at its target
	if tower.target != null:
		# Create a projectile effect
		var projectile = CSGSphere3D.new()
		projectile.radius = 0.1
		projectile.material = StandardMaterial3D.new()
		projectile.material.albedo_color = tower.model.material.albedo_color
		projectile.position = tower.turret.global_position + tower.turret.global_transform.basis.z * 0.5
		add_child(projectile)
		
		# Animate projectile to target
		var tween = create_tween()
		tween.tween_property(projectile, "position", tower.target.node.position, 0.2)
		tween.tween_callback(func(): 
			# Deal damage to enemy
			enemy_system.damage_enemy(tower.target, tower.damage)
			# Remove projectile
			projectile.queue_free()
		)
		
		print(tower.type + " fired at enemy")

func _on_enemy_reached_end():
	# Handle enemy reaching the end of the path
	print("Enemy reached the end of the path")

func _on_enemy_killed():
	# Handle enemy being killed
	print("Enemy killed")

func start_next_wave():
	# Start the next wave of enemies
	if game_started and not wave_in_progress:
		wave_in_progress = true
		game_manager.start_next_wave()
		print("Starting next wave")

func _on_wave_completed():
	# Handle wave completion
	wave_in_progress = false
	print("Wave completed")
