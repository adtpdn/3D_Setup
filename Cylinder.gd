extends MeshInstance3D

var original_material: Material
var highlight_material: ShaderMaterial
var is_hovered = false

func _ready():
	original_material = get_surface_override_material(0)
	if original_material == null:
		original_material = get_active_material(0)
	
	highlight_material = ShaderMaterial.new()
	highlight_material.shader = load("res://shaders/cylinder_outline.gdshader")
	
	# Set initial shader parameters
	highlight_material.set_shader_parameter("highlight_color", Color(1.0, 0.5, 0.0, 0.15))  # Orange highlight
	highlight_material.set_shader_parameter("highlight_intensity", 0.15)
	
	# Copy texture from original material if it exists
	if original_material is StandardMaterial3D and original_material.albedo_texture != null:
		highlight_material.set_shader_parameter("albedo_texture", original_material.albedo_texture)
		highlight_material.set_shader_parameter("use_texture", true)
	else:
		highlight_material.set_shader_parameter("use_texture", false)
	
	# Set up area for mouse detection
	var area = Area3D.new()
	var collision_shape = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 1.0  # Adjust based on your mesh size
	collision_shape.shape = shape
	area.add_child(collision_shape)
	add_child(area)
	
	area.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	area.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	is_hovered = true
	_update_material()

func _on_mouse_exited():
	is_hovered = false
	_update_material()

func _update_material():
	if is_hovered:
		# Apply highlight material
		set_surface_override_material(0, highlight_material)
	else:
		# Restore original material
		set_surface_override_material(0, original_material)

func set_highlight_color(color: Color):
	highlight_material.set_shader_parameter("highlight_color", color)

func set_highlight_intensity(intensity: float):
	highlight_material.set_shader_parameter("highlight_intensity", intensity)
