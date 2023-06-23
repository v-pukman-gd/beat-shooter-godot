tool
extends Control

signal pressed
export(Texture) var icon_texture

func _ready():
	if icon_texture:
		$Button.icon = icon_texture

func _on_Button_pressed():
	GameFX.click()
	emit_signal("pressed")

func _on_Button_mouse_entered():
	$Button.modulate.a = 0.8

func _on_Button_mouse_exited():
	$Button.modulate.a = 1


func _on_Button_button_up():
	$Button.rect_scale = Vector2(1, 1)

func _on_Button_button_down():
	$Button.rect_scale = Vector2(0.95, 0.95)
