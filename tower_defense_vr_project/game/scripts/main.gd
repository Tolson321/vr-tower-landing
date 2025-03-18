# Main Scene for Tower Defense VR Game
extends Node3D

func _ready():
	# Initialize the game
	print("Tower Defense VR Game initialized")
	
	# Set up VR environment
	if XRServer.find_interface("OpenXR"):
		var xr_interface = XRServer.find_interface("OpenXR")
		if xr_interface and xr_interface.is_initialized():
			get_viewport().use_xr = true
			print("OpenXR initialized successfully")
		else:
			print("Failed to initialize OpenXR")
	else:
		print("OpenXR interface not found")

func _process(delta):
	# Main game loop
	pass
