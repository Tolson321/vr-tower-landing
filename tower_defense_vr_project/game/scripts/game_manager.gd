# Tower Defense Game Manager
extends Node

# Game state variables
var game_running = false
var player_health = 100
var player_money = 100
var current_wave = 0
var max_waves = 10
var enemies_remaining = 0

# Tower variables
var available_towers = []
var placed_towers = []

# Path variables
var enemy_path = []

func _ready():
	# Initialize the tower defense game
	print("Tower Defense Game Manager initialized")
	initialize_available_towers()

func initialize_available_towers():
	# Define the types of towers available to the player
	available_towers = [
		{
			"name": "Basic Tower",
			"cost": 10,
			"damage": 5,
			"range": 5.0,
			"fire_rate": 1.0,
			"model": "res://assets/models/tower_basic.tscn"
		},
		{
			"name": "Cannon Tower",
			"cost": 25,
			"damage": 15,
			"range": 4.0,
			"fire_rate": 0.5,
			"model": "res://assets/models/tower_cannon.tscn"
		},
		{
			"name": "Sniper Tower",
			"cost": 40,
			"damage": 30,
			"range": 10.0,
			"fire_rate": 0.25,
			"model": "res://assets/models/tower_sniper.tscn"
		}
	]

func start_game():
	game_running = true
	current_wave = 0
	player_health = 100
	player_money = 100
	start_next_wave()

func start_next_wave():
	if current_wave < max_waves:
		current_wave += 1
		spawn_enemies_for_wave(current_wave)
	else:
		game_won()

func spawn_enemies_for_wave(wave_number):
	# Calculate number of enemies based on wave number
	var num_enemies = 5 + (wave_number * 2)
	enemies_remaining = num_enemies
	
	# In a real implementation, we would spawn enemies over time
	print("Wave " + str(wave_number) + " started with " + str(num_enemies) + " enemies")

func place_tower(tower_type, position):
	# Check if player has enough money
	var tower_data = get_tower_data(tower_type)
	if tower_data and player_money >= tower_data.cost:
		player_money -= tower_data.cost
		
		# In a real implementation, we would instantiate the tower at the position
		placed_towers.append({
			"type": tower_type,
			"position": position,
			"level": 1
		})
		
		print("Placed " + tower_data.name + " at " + str(position))
		return true
	
	return false

func get_tower_data(tower_type):
	for tower in available_towers:
		if tower.name == tower_type:
			return tower
	return null

func enemy_reached_end():
	player_health -= 10
	enemies_remaining -= 1
	
	if player_health <= 0:
		game_over()
	elif enemies_remaining <= 0:
		wave_completed()

func enemy_killed():
	player_money += 5
	enemies_remaining -= 1
	
	if enemies_remaining <= 0:
		wave_completed()

func wave_completed():
	print("Wave " + str(current_wave) + " completed!")
	start_next_wave()

func game_over():
	game_running = false
	print("Game Over! You lost at wave " + str(current_wave))

func game_won():
	game_running = false
	print("Congratulations! You won the game!")
