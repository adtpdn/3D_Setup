extends Node3D

class_name CharacterShowcase

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_container: Node3D = $MeshContainer

var current_mesh: Node3D
var current_skeleton: Skeleton3D
var current_animation: String = "idle"

func _ready():
	if mesh_container.get_child_count() > 0:
		set_current_mesh(0)
	play_animation(current_animation)

func set_current_mesh(index: int):
	if index < 0 or index >= mesh_container.get_child_count():
		push_error("Invalid mesh index")
		return

	for child in mesh_container.get_children():
		child.visible = false

	current_mesh = mesh_container.get_child(index)
	current_mesh.visible = true

	current_skeleton = find_skeleton(current_mesh)

	if current_skeleton:
		update_all_animations()

	play_animation(current_animation)

func find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var skeleton = find_skeleton(child)
		if skeleton:
			return skeleton
	return null

func update_all_animations():
	for animation_name in animation_player.get_animation_list():
		var animation = animation_player.get_animation(animation_name)
		update_animation_skeleton(animation)

func update_animation_skeleton(animation: Animation):
	for track_idx in range(animation.get_track_count()):
		var path = animation.track_get_path(track_idx)
		var new_path = find_matching_node_path(path)
		if new_path:
			animation.track_set_path(track_idx, new_path)

func find_matching_node_path(original_path: NodePath) -> NodePath:
	var path_string = original_path.get_concatenated_names()
	var path_parts = path_string.split("/")
	var current_node = current_skeleton
	var new_path_parts = []

	for part in path_parts:
		var found = false
		for child in current_node.get_children():
			if child.name == part:
				new_path_parts.append(part)
				current_node = child
				found = true
				break
		if not found:
			# If we can't find an exact match, try a case-insensitive match
			for child in current_node.get_children():
				if child.name.to_lower() == part.to_lower():
					new_path_parts.append(child.name)
					current_node = child
					found = true
					break
		if not found:
			push_warning("Couldn't find matching node for: " + part)
			return NodePath()

	return NodePath(current_skeleton.get_path_to(current_node))

func switch_character(index: int):
	set_current_mesh(index)

func play_animation(animation_name: String):
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)
		current_animation = animation_name
	else:
		push_error("Animation not found: " + animation_name)

func next_animation():
	var animations = animation_player.get_animation_list()
	var current_index = animations.find(current_animation)
	var next_index = (current_index + 1) % animations.size()
	play_animation(animations[next_index])
