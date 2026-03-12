extends Control

@onready var cef_node = $GdCEF 
@onready var display = $TextureRect 

var browser: GdBrowserView

var google = "https://www.google.com"
var flicker = "https://watchflicker.doubtmedia.com"

func _ready():
	# Initialize CEF with a config dictionary
	# initialize() replaces Godot's _init() for CEF setup
	var initialized = cef_node.initialize({})
	
	if not initialized:
		print("CEF initialization failed: ", cef_node.get_error())
		return

	# Create browser: pass URL, the display node, and optional settings
	# The browser content is painted directly to the TextureRect's texture
	browser = cef_node.create_browser(google, display, {})

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Forward mouse movement (coordinates are local to the TextureRect)
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
		# You can add MOUSE_BUTTON_RIGHT or MOUSE_BUTTON_MIDDLE similarly
		
func _input(event):
	if event is InputEventKey and event.pressed:
		# Use the standard set_key_pressed method.
		# It requires: keycode, pressed_state, shift, alt, ctrl
		browser.set_key_pressed(
			event.unicode, 
			true, 
			event.shift_pressed, 
			event.alt_pressed, 
			event.ctrl_pressed
		)
