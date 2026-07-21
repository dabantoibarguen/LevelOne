# Update Log

## 21-07-2021

### Summary
- Created Update Log
- Level 1 Map draft (with enemy positions)
- Created enemy subtypes (melee, pistol, shotgun, SMG)
- Pistol enemy behavior implemented (3 burst fire with delays, detection range, no friendly fire)
- Updated bullet behavior to detect categories, move/rotate naturally
- Added sound effect for pistol and revolver

### Details
- Level 1 Map
    - First floor: 3 main rooms with hallways. 
    - Second floor: 3 main rooms, no hallways
    - Flowchart w/ enemy count: https://www.canva.com/design/DAHEcrwY9Iw/6ggjlt2leKRWtDzwm7_ygg/edit

- Pistol enemies
    - 3 shots if there is line of sight and within detection range
    - Small delay between bursts, checks line of sight after burst
    - 1 damage per bullet, bullets aim at the player within the same burst
    - No HP decided yet, movement pending

- Bullet update
    - Direction, movement and speed code updated (now based on target vs origin location, less on angles)
    - Origin category: Categories added such as "Player" and "Enemy" to avoid friendly fire. Sets up for interactive environment
    - Spritesheet available, pending tests

- SFX for bullet sounds (pistol, Jose Revolver). Pitch randomness for variety


### Plans for next update
- Shotgun enemy (sway mechanic, multiple shots)
- SMG enemy (rate of fire testing required, some sway)
- Melee enemy (movement while/before attacking required)
- Polish level map and flow
