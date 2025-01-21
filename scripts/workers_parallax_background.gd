extends ParallaxBackground

@export var clouds_speed: float = -10.0

@onready var cloud_parallax: ParallaxLayer = $ParallaxLayer4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cloud_parallax.motion_offset.x += clouds_speed * delta
