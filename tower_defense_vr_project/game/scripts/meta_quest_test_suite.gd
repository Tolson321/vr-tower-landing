# Meta Quest Optimization Test Suite
extends Node

# References to other systems
@onready var performance_optimizer = $"/root/Main/PerformanceOptimization"

# Test variables
var test_scenarios = [
	{
		"name": "Idle Scene",
		"description": "Empty scene with just the environment",
		"duration": 5.0
	},
	{
		"name": "Few Towers",
		"description": "Scene with 5 towers, no enemies",
		"duration": 5.0
	},
	{
		"name": "Many Towers",
		"description": "Scene with 20 towers, no enemies",
		"duration": 5.0
	},
	{
		"name": "Few Enemies",
		"description": "Scene with 5 enemies, no towers",
		"duration": 5.0
	},
	{
		"name": "Many Enemies",
		"description": "Scene with 20 enemies, no towers",
		"duration": 5.0
	},
	{
		"name": "Full Battle",
		"description": "Scene with 15 towers and 15 enemies",
		"duration": 10.0
	},
	{
		"name": "Stress Test",
		"description": "Scene with 30 towers and 30 enemies",
		"duration": 10.0
	}
]

var current_test_index = -1
var test_timer = 0.0
var test_results = []
var is_testing = false

# Signals
signal test_started(scenario)
signal test_completed(scenario, results)
signal all_tests_completed(results)

func _ready():
	# Initialize test suite
	print("Meta Quest Optimization Test Suite initialized")

func _process(delta):
	# Update test progress
	if is_testing:
		test_timer += delta
		
		var current_test = test_scenarios[current_test_index]
		if test_timer >= current_test.duration:
			complete_current_test()
			run_next_test()

func start_tests():
	# Start running all test scenarios
	is_testing = true
	current_test_index = -1
	test_results = []
	
	print("Starting Meta Quest optimization tests...")
	run_next_test()

func run_next_test():
	# Run the next test scenario
	current_test_index += 1
	
	if current_test_index < test_scenarios.size():
		var scenario = test_scenarios[current_test_index]
		test_timer = 0.0
		
		# Set up the test scenario
		setup_test_scenario(scenario)
		
		emit_signal("test_started", scenario)
		print("Running test: " + scenario.name)
	else:
		# All tests completed
		is_testing = false
		emit_signal("all_tests_completed", test_results)
		print("All optimization tests completed")
		generate_test_report()

func setup_test_scenario(scenario):
	# Set up the scene for the current test scenario
	var game_manager = get_node_or_null("/root/GameManager")
	var tower_placement = get_node_or_null("/root/Main/TowerPlacement")
	var enemy_system = get_node_or_null("/root/Main/EnemyPathSystem")
	
	# Clear existing entities
	if tower_placement:
		tower_placement.clear_all_towers()
	
	if enemy_system:
		enemy_system.clear_all_enemies()
	
	# Create test entities based on scenario
	match scenario.name:
		"Few Towers":
			create_test_towers(5)
		"Many Towers":
			create_test_towers(20)
		"Few Enemies":
			create_test_enemies(5)
		"Many Enemies":
			create_test_enemies(20)
		"Full Battle":
			create_test_towers(15)
			create_test_enemies(15)
		"Stress Test":
			create_test_towers(30)
			create_test_enemies(30)

func create_test_towers(count):
	# Create test towers for the scenario
	var tower_placement = get_node_or_null("/root/Main/TowerPlacement")
	if tower_placement:
		var tower_types = ["Basic Tower", "Cannon Tower", "Sniper Tower"]
		var spacing = 2.0
		var grid_size = ceil(sqrt(count))
		
		for i in range(count):
			var x = (i % grid_size) * spacing - (grid_size * spacing / 2)
			var z = floor(i / grid_size) * spacing - (grid_size * spacing / 2)
			var position = Vector3(x, 0, z)
			
			var tower_type = tower_types[i % tower_types.size()]
			tower_placement.place_tower(tower_type, position)

func create_test_enemies(count):
	# Create test enemies for the scenario
	var enemy_system = get_node_or_null("/root/Main/EnemyPathSystem")
	if enemy_system:
		var enemy_types = ["Basic", "Fast", "Tank"]
		
		for i in range(count):
			var enemy_type = enemy_types[i % enemy_types.size()]
			enemy_system.spawn_test_enemy(enemy_type)

func complete_current_test():
	# Complete the current test and record results
	var scenario = test_scenarios[current_test_index]
	
	# Get performance stats
	var stats = performance_optimizer.get_performance_stats()
	
	# Record test results
	var result = {
		"scenario": scenario.name,
		"fps": stats.fps,
		"draw_calls": stats.draw_calls,
		"objects": stats.objects,
		"memory": stats.memory,
		"performance_level": stats.performance_level
	}
	
	test_results.append(result)
	emit_signal("test_completed", scenario, result)
	print("Test completed: " + scenario.name + " - FPS: " + str(stats.fps))

func generate_test_report():
	# Generate a comprehensive test report
	var report = "===== META QUEST OPTIMIZATION TEST REPORT =====\n\n"
	
	for result in test_results:
		report += "Scenario: " + result.scenario + "\n"
		report += "- FPS: " + str(result.fps) + "\n"
		report += "- Draw Calls: " + str(result.draw_calls) + "\n"
		report += "- Object Count: " + str(result.objects) + "\n"
		report += "- Memory Usage: " + str(result.memory) + " MB\n"
		report += "- Performance Level: " + result.performance_level + "\n\n"
	
	# Calculate averages
	var avg_fps = 0.0
	var avg_draw_calls = 0.0
	var avg_objects = 0.0
	var avg_memory = 0.0
	
	for result in test_results:
		avg_fps += result.fps
		avg_draw_calls += result.draw_calls
		avg_objects += result.objects
		avg_memory += result.memory
	
	avg_fps /= test_results.size()
	avg_draw_calls /= test_results.size()
	avg_objects /= test_results.size()
	avg_memory /= test_results.size()
	
	report += "AVERAGES:\n"
	report += "- FPS: " + str(avg_fps) + "\n"
	report += "- Draw Calls: " + str(avg_draw_calls) + "\n"
	report += "- Object Count: " + str(avg_objects) + "\n"
	report += "- Memory Usage: " + str(avg_memory) + " MB\n\n"
	
	# Add recommendations
	report += "RECOMMENDATIONS:\n"
	if avg_fps < 72:
		report += "- FPS is below target (72 FPS). Consider further optimizations.\n"
	
	if avg_draw_calls > 100:
		report += "- High draw call count. Consider batching or reducing visible objects.\n"
	
	if avg_memory > 200:
		report += "- Memory usage is high. Consider texture compression and mesh simplification.\n"
	
	report += "\n========================================="
	
	# Save report to file
	var file = FileAccess.open("res://optimization_report.txt", FileAccess.WRITE)
	file.store_string(report)
	file.close()
	
	print("Test report generated and saved to optimization_report.txt")
	return report
