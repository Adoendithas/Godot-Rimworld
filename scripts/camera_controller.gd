extends Camera2D

@export var zoomSpeed : float
@export var minZoom : float
@export var maxZoom : float

var zoomTarget : Vector2

var dragMousePosStart = Vector2.ZERO
var dragCameraPosStart = Vector2.ZERO
var isDragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoomTarget = zoom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_zoom(delta)
	simple_pan(delta)
	click_and_drag()
	pass
	
func camera_zoom(delta):
	#if (Input.is_action_just_pressed("camera_zoom_in") && zoom.y <= maxZoom):
	if (Input.is_action_just_pressed("camera_zoom_in")):
		zoomTarget *=  1.1
	#if (Input.is_action_just_pressed("camera_zoom_out") && zoom.y >= minZoom):
	if (Input.is_action_just_pressed("camera_zoom_out")):
		zoomTarget *= 0.9
	zoomTarget.y = clamp(zoomTarget.y, minZoom, maxZoom)
	zoomTarget.x = clamp(zoomTarget.x, minZoom, maxZoom)
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	
func simple_pan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("camera_move_down"):
		moveAmount.y += 1
	if Input.is_action_pressed("camera_move_up"):
		moveAmount.y += -1
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x += -1
	if Input.is_action_pressed("camera_move_right"):
		moveAmount.x += 1
	moveAmount = moveAmount.normalized()
	#position += moveAmount * delta * 1000 * (sqrt(5 + zoom.y))
	position += moveAmount * delta * 1000 * (1/zoom.y)
	
func click_and_drag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragMousePosStart = get_viewport().get_mouse_position()
		dragCameraPosStart = position
		isDragging = true
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragMousePosStart
		position = dragCameraPosStart - moveVector * 1/zoom.x
