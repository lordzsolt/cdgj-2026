extends Control

@onready var resume_button: Button = %resumeButton
@onready var quit_button: Button = %quitButton

func _ready():
	resume_button.button_up.connect(func():
		if gs.current_level == 1:
			Main.instance.switch_scene(PF.Scene.LEVEL_1)
		elif gs.current_level == 2:
			Main.instance.switch_scene(PF.Scene.LEVEL_2)
		else:
			Main.instance.switch_scene(PF.Scene.MAIN_MENU)
	)

	quit_button.button_up.connect(
		func(): Main.instance.switch_scene(PF.Scene.MAIN_MENU))
