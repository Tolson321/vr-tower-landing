# Tower Attack System
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"
@onready var enemy_system = $"/root/Main/EnemySystem"

# Tower attack variables
var tower_attack_range = {
	"Basic Tower": 5.0,
	"Cannon Tower": 4.0,
	"Sniper Tower": 10.0
}

var tower_attack_damage = {
	"Basic Tower": 5,
	"Cannon Tower": 15,
	"Sniper Tower": 30
}

var tower_attack_rate = {
	"Basic Tower": 1.0,  # attacks per second
	"Cannon Tower": 0.5,
	"Sniper Tower": 0.25
}

# Active towers
var active_towers = []

func _ready():
	# Initialize tower attack system
	print("Tower Attack System initialized")

func _process(delta):
	# Update all tower attacks
	for tower in active_towers:
		update_tower_attack(tower, delta)

func register_tower(tower_node, tower_type, position):
	# Register a new tower with the attack system
	var tower = {
		"node": tower_node,
		"type": tower_type,
		"position": position,
		"range": tower_attack_range[tower_type],
		"damage": tower_attack_damage[tower_type],
		"fire_rate": tower_attack_rate[tower_type],
		"fire_timer": 0.0,
		"target": null,
		"turret": find_turret_in_tower(tower_node)
	}
	
	active_towers.append(tower)
	print("Tower registered with attack system: " + tower_type)
	return tower

func find_turret_in_tower(tower_node):
	# Find the turret node in the tower model
	for child in tower_node.get_children():
		if child.name.begins_with("Turret"):
			return child
	return null

func update_tower_attack(tower, delta):
	# Update tower targeting and attack
	
	# Find target if none exists or current target is invalid
	if tower.target == null or not is_instance_valid(tower.target.node):
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
	if tower.target != null and tower.turret != null:
		var direction = tower.target.node.position - tower.node.position
		direction.y = 0  # Keep turret level horizontally
		
		if direction.length() > 0.01:
			var look_at_pos = tower.node.position + direction.normalized()
			tower.turret.look_at(look_at_pos, Vector3.UP)

func fire_tower(tower):
	# Fire the tower at its target
	if tower.target != null:
		# Create a projectile effect
		var projectile = CSGSphere3D.new()
		projectile.radius = 0.1
		
		# Set projectile appearance based on tower type
		var material = StandardMaterial3D.new()
		match tower.type:
			"Basic Tower":
				material.albedo_color = Color(0.2, 0.5, 1.0)
			"Cannon Tower":
				material.albedo_color = Color(0.8, 0.3, 0.1)
				projectile.radius = 0.2
			"Sniper Tower":
				material.albedo_color = Color(0.1, 0.8, 0.3)
				projectile.radius = 0.05
		
		projectile.material = material
		
		# Position projectile at turret muzzle
		var muzzle_position = tower.turret.global_position
		if tower.turret.has_node("Muzzle"):
			muzzle_position = tower.turret.get_node("Muzzle").global_position
		else:
			muzzle_position += tower.turret.global_transform.basis.z * 0.5
		
		projectile.position = muzzle_position
		add_child(projectile)
		
		# Animate projectile to target
		var tween = create_tween()
		var travel_time = 0.2
		if tower.type == "Cannon Tower":
			travel_time = 0.5
		elif tower.type == "Sniper Tower":
			travel_time = 0.1
			
		tween.tween_property(projectile, "position", tower.target.node.position, travel_time)
		tween.tween_callback(func(): 
			# Deal damage to enemy
			enemy_system.damage_enemy(tower.target, tower.damage)
			
			# Create impact effect
			create_impact_effect(projectile.position, tower.type)
			
			# Remove projectile
			projectile.queue_free()
		)
		
		print(tower.type + " fired at enemy")

func create_impact_effect(position, tower_type):
	# Create a visual effect for projectile impact
	var impact = CSGSphere3D.new()
	impact.position = position
	
	# Set impact appearance based on tower type
	var material = StandardMaterial3D.new()
	match tower_type:
		"Basic Tower":
			impact.radius = 0.2
			material.albedo_color = Color(0.2, 0.5, 1.0, 0.7)
		"Cannon Tower":
			impact.radius = 0.4
			material.albedo_color = Color(0.8, 0.3, 0.1, 0.7)
		"Sniper Tower":
			impact.radius = 0.1
			material.albedo_color = Color(0.1, 0.8, 0.3, 0.7)
	
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	impact.material = material
	add_child(impact)
	
	# Animate impact effect
	var tween = create_tween()
	tween.tween_property(impact, "radius", impact.radius * 2, 0.2)
	tween.parallel().tween_property(impact.material, "albedo_color:a", 0.0, 0.2)
	tween.tween_callback(impact.queue_free)

func unregister_tower(tower):
	# Remove a tower from the attack system
	active_towers.erase(tower)
