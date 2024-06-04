extends Node

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
const TILEMAP_NODE_PATH : String = "res://Scenes/A1/S"
const STARTING_MAP : String = "res://Scenes/A1/S1.tscn"

var current_tilemap: TileMap;
var lerp_class = load("res://Scripts/lerp_to_signal.gd")
var lerp_instance = lerp_class.new()

const scene_settings: Dictionary = {
	1: {"Auto_Dialogic": true, "Hide_Player": true},
	2: {"Auto_Dialogic": true, "Hide_Player": true},
	3: {"Auto_Dialogic": false, "Hide_Player": false}
}

var current_map : Node
var current_scene_index : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	show_map(STARTING_MAP, 1)
	Dialogic.timeline_ended.connect(end_timeline)

func end_timeline():
	var next_scene_number: int = current_scene_index + 1
	if scene_settings.has(next_scene_number):
		pass #end game
	var next_tilemap_path: String = "res://Scenes/A1/S" + str(next_scene_number) + ".tscn"
	print(next_tilemap_path)
	show_map(next_tilemap_path, next_scene_number)
	process_scene(next_scene_number)
	

func show_map(map_path, next_scene_number):
	if self.current_map != null:
		self.current_map.queue_free()
	process_setting(next_scene_number)
	current_tilemap = load(map_path).instantiate()
	self.current_map = current_tilemap
	self.add_child(self.current_map)
	current_scene_index = current_scene_index + 1

func start_dialogic(next_scene_number):
	Dialogic.start("A1S" + str(next_scene_number))

func process_setting(scene: int):
	if scene_settings[scene].get("Auto_Dialogic", false):
		print("Starting Dialogic")
		start_dialogic(scene)
	if scene_settings[scene].get("Hide_Player", false):
		print("Hiding player")
		player.hide()
		player.disable_movement()
	else:
		print("Showing Player")
		player.show()
		player.enable_movement()

func process_scene(scene: int):
	if scene == 3:
		print("Attempting to move lerp")
		lerp_instance.move_to_coordinates(player, camera, current_map, Vector2(-3, -35), 3)

func _process(delta):
	lerp_instance._process(delta)