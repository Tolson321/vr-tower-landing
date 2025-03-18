# Wave System for Tower Defense
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"
@onready var enemy_system = $"/root/Main/EnemyPathSystem"

# Wave variables
var current_wave = 0
var max_waves = 10
var wave_in_progress = false
var wave_cooldown = 10.0  # Seconds between waves
var cooldown_timer = 0.0

# Wave configuration
var wave_configs = []

# Signals
signal wave_started(wave_number)
signal wave_completed(wave_number)
signal all_waves_completed

func _ready():
	# Initialize wave system
	print("Wave System initialized")
	
	# Generate wave configurations
	generate_wave_configs()
	
	# Connect signals
	enemy_system.enemy_reached_end.connect(_on_enemy_reached_end)
	enemy_system.enemy_killed.connect(_on_enemy_killed)

func _process(delta):
	# Update wave system
	if game_manager.game_running:
		if wave_in_progress:
			check_wave_completion()
		else:
			# Update cooldown between waves
			if current_wave > 0 and current_wave < max_waves:
				cooldown_timer += delta
				if cooldown_timer >= wave_cooldown:
					start_next_wave()
					cooldown_timer = 0.0

func generate_wave_configs():
	# Generate configurations for each wave
	for i in range(1, max_waves + 1):
		var config = {
			"basic_count": 5 + i,
			"fast_count": max(0, i - 2),
			"tank_count": max(0, i - 4),
			"spawn_interval": max(0.5, 2.0 - (i * 0.1))
		}
		wave_configs.append(config)

func start_game():
	# Start the tower defense game
	current_wave = 0
	wave_in_progress = false
	cooldown_timer = wave_cooldown  # Start first wave immediately
	
	print("Wave System started")

func start_next_wave():
	# Start the next wave
	if current_wave < max_waves:
		current_wave += 1
		wave_in_progress = true
		
		# Configure enemy system for this wave
		var config = wave_configs[current_wave - 1]
		enemy_system.spawn_interval = config.spawn_interval
		enemy_system.enemies_to_spawn = config.basic_count + config.fast_count + config.tank_count
		
		# Set enemy type distribution
		enemy_system.enemy_distribution = {
			"Basic": config.basic_count,
			"Fast": config.fast_count,
			"Tank": config.tank_count
		}
		
		# Start the wave in the enemy system
		enemy_system.start_wave(current_wave)
		
		emit_signal("wave_started", current_wave)
		print("Wave " + str(current_wave) + " started")
		
		# Update game manager
		game_manager.current_wave = current_wave

func check_wave_completion():
	# Check if the current wave is completed
	if wave_in_progress and enemy_system.get_active_enemy_count() == 0 and enemy_system.enemies_to_spawn == 0:
		complete_current_wave()

func complete_current_wave():
	# Complete the current wave
	wave_in_progress = false
	cooldown_timer = 0.0
	
	emit_signal("wave_completed", current_wave)
	print("Wave " + str(current_wave) + " completed")
	
	# Check if all waves are completed
	if current_wave >= max_waves:
		complete_all_waves()
	
	# Give player bonus money for completing wave
	game_manager.player_money += 25 + (current_wave * 5)

func complete_all_waves():
	# All waves have been completed
	emit_signal("all_waves_completed")
	print("All waves completed! Game won!")
	
	# Notify game manager
	game_manager.game_won()

func _on_enemy_reached_end():
	# An enemy has reached the end of the path
	check_wave_completion()

func _on_enemy_killed():
	# An enemy has been killed
	check_wave_completion()

func get_wave_progress():
	# Return the current wave progress as a percentage
	return float(current_wave) / max_waves

func get_cooldown_progress():
	# Return the current cooldown progress as a percentage
	return cooldown_timer / wave_cooldown

func skip_cooldown():
	# Skip the cooldown and start the next wave immediately
	if not wave_in_progress and current_wave < max_waves:
		cooldown_timer = wave_cooldown
		print("Wave cooldown skipped")

func reset():
	# Reset the wave system
	current_wave = 0
	wave_in_progress = false
	cooldown_timer = 0.0
	enemy_system.clear_all_enemies()
	print("Wave System reset")
