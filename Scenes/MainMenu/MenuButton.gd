@tool
extends TextureButton

@export var text: String = "Text button"
@export var arrow_margin_from_center: int = 100

func _ready():
	setup_text()
	show_arrows()
	hide_arrows()

func _process(delta):
	if Engine.is_editor_hint():
		setup_text()
		show_arrows()
	
func setup_text():
	$RichTextLabel.text = "[center] %s [/center]" % [text]
	
func show_arrows():
	for arrow in [$Left_arrow, $Right_arrow]:
		arrow.visible = true
		arrow.global_position.y = global_position.y + (size.y / 4.0)

	var center_x = 576
	$Left_arrow.global_position.x = center_x - arrow_margin_from_center
	$Right_arrow.global_position.x = center_x + arrow_margin_from_center
#	print(ProjectSettings.get("display/window/size/width"))

func hide_arrows():
	for arrow in [$Left_arrow, $Right_arrow]:
		arrow.visible = false


func _on_focus_entered():
	show_arrows()


func _on_focus_exited():
	hide_arrows()


func _on_mouse_entered():
	grab_focus()


func _on_pressed():
	pass # Replace with function body.
