extends CanvasLayer

@onready var hpText = $HP
@onready var ammoText = $Bullets
@onready var dashCD = %DashCD
@onready var possessCD = %PosCD

func updateHP(hp):
	hpText.text = "HP: " + str(hp)
	
func updateAmmo(bul):
	if bul is String:
		ammoText.text = "AMMO: X" 
	else:
		ammoText.text = "AMMO: " + str(bul)
	
func cdDash(time = 2.15):
	visualCD(dashCD, time)

func cdPossess(time = 3):
	visualCD(possessCD, time)

func visualCD(skill, duration):
	var tween = create_tween()
	
	tween.tween_property(skill, "value", 100, duration)
	
	await tween.finished
	skill.value = 0
