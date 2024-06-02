extends Node

const TILEMAP_NODE_PATH : String = "res://Scenes/A1/S"
const STARTING_MAP : String = "res://Scenes/A1/S1.tscn"

const start_dialogic_on_instantiate : Dictionary= {
	1 : true,
	2 : true,
	3 : true,
}

var current_map : Node
var current_scene_index : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start("A1S1")
	show_map(STARTING_MAP)
	Dialogic.timeline_ended.connect(end_timeline)

func end_timeline():
	var next_scene_number : int = current_scene_index + 1
	var next_tilemap_path : String = "res://Scenes/A1/S" + str(next_scene_number) + ".tscn"
	print(next_tilemap_path)
	show_map(next_tilemap_path)
	if start_dialogic_on_instantiate[next_scene_number]:
		Dialogic.start("A1S" + str(next_scene_number))
	

func show_map(map_path):
	if self.current_map != null:
		self.current_map.queue_free()
	print(map_path)
	self.current_map = load(map_path).instantiate()
	self.add_child(self.current_map)
	current_scene_index = current_scene_index + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
