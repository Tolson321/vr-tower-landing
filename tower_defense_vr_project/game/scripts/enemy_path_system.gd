# Enemy Path System
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"

# Path variables
var path_points = []
var path_node

# Enemy variables
var enemy_prefabs = {
	"Basic": {
		"health": 10,
		"speed": 1.0,
		"color": Color(1.0, 0.2, 0.2)
	},
	"Fast": {
		"health": 5,
		"speed": 2.0,
		"color": Color(0.2, 0.2, 1.0)
	},
	"Tank": {
		"health": 30,
		"speed": 0.5,
		"color": Color(0.5, 0.5, 0.5)
	}
}

var active_enemies = []
var spawn_timer = 0.0
var spawn_interval = 2.0
var enemies_to_spawn = 0

# Signals
signal enemy_reached_end
signal enemy_killed

func _ready():
	# Initialize enemy path system
	print("Enemy Path System initialized")
	initialize_path()

func _process(delta):
	# Update enemy spawning and movement
	if game_manager.game_running and enemies_to_spawn > 0:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0
			spawn_enemy()
			enemies_to_spawn -= 1
	
	# Update enemy movement
	update_enemies(delta)

func initialize_path():
	# Create a path for enemies to follow
	path_points = [
		Vector3(-8, 0, 0),    # Start point
		Vector3(-8, 0, 8),    # First turn
		Vector3(0, 0, 8),     # Second turn
		Vector3(0, 0, -8),    # Third turn
		Vector3(8, 0, -8),    # Fourth turn
		Vector3(8, 0, 0)      # End point
	]
	
	# Create a visual representation of the path
	path_node = Node3D.new()
	path_node.name = "EnemyPath"
	add_child(path_node)
	
	# Create path segments
	for i in range(path_points.size() - 1):
		create_path_segment(path_points[i], path_points[i + 1])

func create_path_segment(start, end):
	# Create a visual segment of the path
	var segment = CSGBox3D.new()
	
	# Calculate segment properties
	var mid = (start + end) / 2
	var length = start.distance_to(end)
	var direction = (end - start).normalized()
	
	# Set segment size and position
	segment.size = Vector3(1.0, 0.1, length)
	segment.position = mid
	
	# Calculate rotation to align with direction
	if direction.x != 0:
		segment.rotation.y = 0 if direction.x > 0 else PI
	else:
		segment.rotation.y = PI/2 if direction.z > 0 else -PI/2
	
	# Set segment material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.8, 0.5, 0.2)
	segment.material = material
	
	# Add to path node
	path_node.add_child(segment)

func start_wave(wave_number):
	# Start a new wave of enemies
	var num_enemies = 5 + (wave_number * 2)
	enemies_to_spawn = num_enemies
	spawn_timer = 0
	
	# Adjust spawn interval based on wave number
	spawn_interval = max(0.5, 2.0 - (wave_number * 0.1))
	
	print("Wave " + str(wave_number) + " started with " + str(num_enemies) + " enemies")

func spawn_enemy():
	# Determine enemy type based on wave number
	var enemy_type = "Basic"
	var wave = game_manager.current_wave
	
	# Introduce different enemy types in later waves
	if wave >= 3:
		var roll = randf()
		if roll < 0.3:
			enemy_type = "Fast"
		elif roll < 0.4 and wave >= 5:
			enemy_type = "Tank"
	
	# Get enemy data
	var enemy_data = enemy_prefabs[enemy_type]
	
	# Create enemy visual representation
	var enemy_node = CSGSphere3D.new()
	enemy_node.radius = 0.3
	if enemy_type == "Fast":
		enemy_node.radius = 0.2
	elif enemy_type == "Tank":
		enemy_node.radius = 0.4
	
	# Set enemy material
	var material = StandardMaterial3D.new()
	material.albedo_color = enemy_data.color
	enemy_node.material = material
	
	# Add enemy to scene
	add_child(enemy_node)
	
	# Set initial position at the start of the path
	enemy_node.position = path_points[0]
	
	# Create enemy data structure
	var enemy = {
		"node": enemy_node,
		"type": enemy_type,
		"health": enemy_data.health,
		"speed": enemy_data.speed,
		"path_index": 0,
		"progress": 0.0,
		"max_health": enemy_data.health
	}
	
	# Add health bar
	add_health_bar_to_enemy(enemy)
	
	# Add to active enemies list
	active_enemies.append(enemy)
	
	print("Enemy spawned: " + enemy_type)

func add_health_bar_to_enemy(enemy):
	# Create a health bar for the enemy
	var health_bar_bg = CSGBox3D.new()
	health_bar_bg.size = Vector3(0.6, 0.05, 0.05)
	health_bar_bg.position = Vector3(0, enemy.node.radius + 0.1, 0)
	
	var bg_material = StandardMaterial3D.new()
	bg_material.albedo_color = Color(0.2, 0.2, 0.2)
	health_bar_bg.material = bg_material
	
	enemy.node.add_child(health_bar_bg)
	
	# Create the actual health indicator
	var health_bar = CSGBox3D.new()
	health_bar.size = Vector3(0.6, 0.05, 0.05)
	health_bar.position = Vector3(0, 0, 0)
	
	var health_material = StandardMaterial3D.new()
	health_material.albedo_color = Color(0.2, 0.8, 0.2)
	health_bar.material = health_material
	
	health_bar_bg.add_child(health_bar)
	enemy.health_bar = health_bar

func update_enemies(delta):
	# Update all active enemies
	for i in range(active_enemies.size() - 1, -1, -1):
		var enemy = active_enemies[i]
		move_enemy_along_path(enemy, delta)
		update_enemy_health_bar(enemy)

func move_enemy_along_path(enemy, delta):
	# Move enemy along the path
	var current_index = enemy.path_index
	var next_index = current_index + 1
	
	if next_index < path_points.size():
		var start_pos = path_points[current_index]
		var end_pos = path_points[next_index]
		
		# Update progress based on speed
		enemy.progress += enemy.speed * delta / start_pos.distance_to(end_pos)
		
		if enemy.progress >= 1.0:
			# Move to next path segment
			enemy.path_index += 1
			enemy.progress = 0.0
			
			if enemy.path_index >= path_points.size() - 1:
				# Reached the end of the path
				enemy_reached_end(enemy)
		else:
			# Interpolate position along current path segment
			enemy.node.position = start_pos.lerp(end_pos, enemy.progress)
	else:
		# Reached the end of the path
		enemy_reached_end(enemy)

func update_enemy_health_bar(enemy):
	# Update the health bar to reflect current health
	if enemy.health_bar:
		var health_percent = float(enemy.health) / enemy.max_health
		enemy.health_bar.size.x = 0.6 * health_percent
		enemy.health_bar.position.x = (0.6 - enemy.health_bar.size.x) / 2 * -1
		
		# Update color based on health
		var health_color = lerp(Color(0.8, 0.2, 0.2), Color(0.2, 0.8, 0.2), health_percent)
		enemy.health_bar.material.albedo_color = health_color

func enemy_reached_end(enemy):
	# Handle enemy reaching the end of the path
	emit_signal("enemy_reached_end")
	remove_enemy(enemy)
	
	# Notify game manager
	game_manager.enemy_reached_end()

func damage_enemy(enemy, damage):
	# Apply damage to an enemy
	enemy.health -= damage
	
	if enemy.health <= 0:
		emit_signal("enemy_killed")
		remove_enemy(enemy)
		
		# Notify game manager
		game_manager.enemy_killed()
	
	# Update health bar
	update_enemy_health_bar(enemy)

func remove_enemy(enemy):
	# Remove an enemy from the game
	active_enemies.erase(enemy)
	enemy.node.queue_free()

func get_active_enemy_count():
	# Return the number of active enemies
	return active_enemies.size()

func clear_all_enemies():
	# Remove all active enemies
	for enemy in active_enemies:
		enemy.node.queue_free()
	
	active_enemies.clear()
	enemies_to_spawn = 0
