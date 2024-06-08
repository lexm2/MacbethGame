extends Node

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
const TILEMAP_NODE_PATH: String = "res://Scenes/A1/S"
const STARTING_MAP: String = "res://Scenes/A1/S1.tscn"

var current_tilemap: TileMap
var lerp_class = load("res://Scripts/lerp_to.gd")
var lerp_instance = lerp_class.new()
var startedSection: bool = false

var scene_settings: Dictionary = {
    1: {"Auto_Dialogic": true, "Hide_Player": true, "Sections": 1},
    2: {"Auto_Dialogic": true, "Hide_Player": true, "Sections": 1},
    3: {"Auto_Dialogic": true, "Hide_Player": false, "Sections": 2},
}

var current_map: Node
var current_scene_index: int = 0
var current_section: int = 1

enum States {
    SECTION,
    DIALOGIC,
    BLOCK_EVENTS,
}

var state = States.DIALOGIC

func _ready():
    Dialogic.timeline_ended.connect(process_event)
    Dialogic.signal_event.connect(_on_dialogic_signal)
    process_event()

func _on_dialogic_signal(argument: String):
    if argument == "proceed_with_lerp_back":
        lerp_instance.emit_signal("proceed_with_lerp_back")

func process_event():
    match state:
        States.DIALOGIC:
            current_scene_index += 1
            var number_sections = get_total_sections(current_scene_index)
            if number_sections > 1:
                state = States.BLOCK_EVENTS
            process_scene(current_scene_index, current_section)
        States.SECTION:
            if (current_section == get_total_sections(current_scene_index)):
                state = States.DIALOGIC
            current_section += 1
            process_scene(current_scene_index, current_section)
        States.BLOCK_EVENTS:
            pass
        

func show_map(scene):
    print("Showing scene #%s" % scene)
    if self.current_map != null:
        self.current_map.queue_free()
    process_setting(scene)
    current_tilemap = load(TILEMAP_NODE_PATH + str(scene) + ".tscn").instantiate()
    self.current_map = current_tilemap
    self.add_child(self.current_map)

    for child in current_tilemap.get_children():
        if child is Area2D:
            child.body_entered.connect(_on_tripwire_body_entered.bind(child))

func start_dialogic(next_scene_number: int, section: int=1):
    var scene_to_start = "A1S" + str(next_scene_number)
    if section > 1:
        scene_to_start += "P" + str(section)
    Dialogic.start(scene_to_start)

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

func process_scene(scene: int, section: int):
    if section == 1:
        show_map(scene)
    if scene == 3:
        if section == 1:
            lerp_instance.move_to_coordinates(player, camera, current_map, Vector2( - 3, -35), 3)
        if section == 2:
            player.disable_movement()
            start_dialogic(3, 2)
        

func get_total_sections(scene: int) -> int:
    return scene_settings[scene].get("Sections", 1)

func _process(delta):
    lerp_instance._process(delta)

func _on_tripwire_body_entered(body, area2d):
    print("Body entered the tripwire:", body)
    print("Tripwire node:", area2d)
    state = States.SECTION
    lerp_instance.move_to_coordinates(player, camera, current_map, Vector2( - 3, -35), 3)
    process_event()

