# Game Economy System
extends Node3D

# References to other systems
@onready var game_manager = $"/root/GameManager"
@onready var enemy_system = $"/root/Main/EnemyPathSystem"
@onready var wave_system = $"/root/Main/WaveSystem"

# Economy variables
var tower_costs = {
	"Basic Tower": 50,
	"Cannon Tower": 100,
	"Sniper Tower": 150
}

var enemy_rewards = {
	"Basic": 10,
	"Fast": 15,
	"Tank": 25
}

var wave_completion_bonus = 25  # Base bonus for completing a wave

# Signals
signal money_changed(new_amount)
signal purchase_successful(tower_type)
signal purchase_failed(tower_type, reason)

func _ready():
	# Initialize game economy system
	print("Game Economy System initialized")
	
	# Connect signals
	enemy_system.enemy_killed.connect(_on_enemy_killed)
	wave_system.wave_completed.connect(_on_wave_completed)

func can_afford_tower(tower_type):
	# Check if player can afford a tower
	if tower_type in tower_costs:
		return game_manager.player_money >= tower_costs[tower_type]
	return false

func purchase_tower(tower_type):
	# Attempt to purchase a tower
	if can_afford_tower(tower_type):
		game_manager.player_money -= tower_costs[tower_type]
		emit_signal("money_changed", game_manager.player_money)
		emit_signal("purchase_successful", tower_type)
		print("Tower purchased: " + tower_type + " for " + str(tower_costs[tower_type]))
		return true
	else:
		emit_signal("purchase_failed", tower_type, "Not enough money")
		print("Cannot afford tower: " + tower_type)
		return false

func _on_enemy_killed(enemy_type):
	# Award money for killing an enemy
	if enemy_type in enemy_rewards:
		var reward = enemy_rewards[enemy_type]
		game_manager.player_money += reward
		emit_signal("money_changed", game_manager.player_money)
		print("Earned " + str(reward) + " for killing " + enemy_type)

func _on_wave_completed(wave_number):
	# Award bonus money for completing a wave
	var bonus = wave_completion_bonus + (wave_number * 5)
	game_manager.player_money += bonus
	emit_signal("money_changed", game_manager.player_money)
	print("Wave completion bonus: " + str(bonus))

func get_tower_cost(tower_type):
	# Get the cost of a specific tower
	if tower_type in tower_costs:
		return tower_costs[tower_type]
	return 0

func reset():
	# Reset the economy system
	game_manager.player_money = 100  # Starting money
	emit_signal("money_changed", game_manager.player_money)
	print("Economy System reset")
