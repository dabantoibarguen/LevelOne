extends CanvasLayer

@onready var hpText = $HP
@onready var dashCD = %DashCD
@onready var possessCD = %PosCD

func updateHP(hp):
	hpText.text = "HP :" + str(hp)
	
func cdDash(time = 2.15):
	visualCD(dashCD, time)

func cdPossess(time = 3):
	visualCD(possessCD, time)

func visualCD(skill, duration):
	var tween = create_tween()
	
	tween.tween_property(skill, "value", 100, duration)
	
	await tween.finished
	skill.value = 0
