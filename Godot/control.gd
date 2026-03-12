extends Control

@onready var cef_node = $GdCEF 
@onready var display = $TextureRect 

var browser: GdBrowserView

var google = "https://www.google.com"
var flicker = "https://watchflicker.doubtmedia.com"

func _ready():
	# Initialize CEF
	var initialized = cef_node.initialize({})
	
	if not initialized:
		print("CEF initialization failed: ", cef_node.get_error())
		return

	# Create browser
	browser = cef_node.create_browser(google, display, {})

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Forward mouse movement
		browser.set_mouse_moved(event.position.x, event.position.y)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			browser.set_mouse_wheel_vertical(5, event.shift_pressed, event.ctrl_pressed, event.alt_pressed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			browser.set_mouse_wheel_vertical(-5, event.shift_pressed, event.ctrl_pressed, event.alt_pressed)


	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				browser.set_mouse_left_down()
			else:
				browser.set_mouse_left_up()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				browser.set_mouse_right_down()
			else:
				browser.set_mouse_right_up()
		
func _input(event):
	if event is InputEventKey and event.pressed:
		browser.set_key_pressed(
			event.unicode, 
			true, 
			event.shift_pressed, 
			event.alt_pressed, 
			event.ctrl_pressed
		)
