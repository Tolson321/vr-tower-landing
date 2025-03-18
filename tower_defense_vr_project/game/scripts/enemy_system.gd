# Enemy System
extends Node3D

signal enemy_reached_end
signal enemy_killed

# References to game components
@onready var game_manager = $"/root/GameManager"

# Enemy variables
var enemy_scene = preload("res://scenes/enemy.tscn")
var active_enemies = []
var spawn_timer = 0.0
var spawn_interval = 2.0

# Path variables
var path_points = []
var path_node

func _ready():
	# Initialize enemy system
	print("Enemy System initialized")
	initialize_path()

func _process(delta):
	if game_manager.game_running and game_manager.enemies_remaining > 0:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0
			spawn_enemy()

func initialize_path():
	# In a real implementation, this would load path points from the level
	# For now, we'll create a simple path
	path_points = [
		Vector3(-8, 0, 0),
		Vector3(-8, 0, 8),
		Vector3(0, 0, 8),
		Vector3(0, 0, -8),
		Vector3(8, 0, -8),
		Vector3(8, 0, 0)
	]
	
	# Create a visual representation of the path
	path_node = Node3D.new()
	add_child(path_node)
	
	for i in range(path_points.size() - 1):
		var line = CSGBox3D.new()
		var start = path_points[i]
		var end = path_points[i + 1]
		var mid = (start + end) / 2
		var length = start.distance_to(end)
		var direction = (end - start).normalized()
		
		line.size = Vector3(0.5, 0.1, length)
		line.position = mid
		
		# Calculate rotation to align with direction
		if direction.x != 0:
			line.rotation.y = 0 if direction.x > 0 else PI
		else:
			line.rotation.y = PI/2 if direction.z > 0 else -PI/2
		
		var material = StandardMaterial3D.new()
		material.albedo_color = Color(0.8, 0.5, 0.2)
		line.material = material
		
		path_node.add_child(line)

func spawn_enemy():
	# In a real implementation, we would instantiate an enemy scene
	# For now, we'll create a simple placeholder
	var enemy = CSGSphere3D.new()
	enemy.radius = 0.3
	enemy.material = StandardMaterial3D.new()
	enemy.material.albedo_color = Color(1, 0, 0)
	add_child(enemy)
	
	# Set initial position at the start of the path
	enemy.position = path_points[0]
	
	# Store enemy data
	var enemy_data = {
		"node": enemy,
		"health": 10,
		"speed": 1.0,
		"path_index": 0,
		"progress": 0.0
	}
	
	active_enemies.append(enemy_data)
	
	print("Enemy spawned")

func update_enemies(delta):
	for enemy in active_enemies:
		move_enemy_along_path(enemy, delta)

func move_enemy_along_path(enemy_data, delta):
	var current_index = enemy_data.path_index
	var next_index = current_index + 1
	
	if next_index < path_points.size():
		var start_pos = path_points[current_index]
		var end_pos = path_points[next_index]
		
		enemy_data.progress += enemy_data.speed * delta
		
		if enemy_data.progress >= 1.0:
			enemy_data.path_index += 1
			enemy_data.progress = 0.0
			
			if enemy_data.path_index >= path_points.size() - 1:
				enemy_reached_end(enemy_data)
		else:
			enemy_data.node.position = start_pos.lerp(end_pos, enemy_data.progress)
	else:
		enemy_reached_end(enemy_data)

func enemy_reached_end(enemy_data):
	emit_signal("enemy_reached_end")
	remove_enemy(enemy_data)
	game_manager.enemy_reached_end()

func damage_enemy(enemy_data, damage):
	enemy_data.health -= damage
	
	if enemy_data.health <= 0:
		emit_signal("enemy_killed")
		remove_enemy(enemy_data)
		game_manager.enemy_killed()

func remove_enemy(enemy_data):
	active_enemies.erase(enemy_data)
	enemy_data.node.queue_free()
