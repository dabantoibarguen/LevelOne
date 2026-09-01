# Current tasks
### Possession Mechanics
- Shift key press -> Highlight enemies that can be possessed
- Mouse click + Shift Key -> Take over highlighted enemy
- Cooldown timer started after possession is complete
- Sprite overwrite or modification for possessed enemy
- Life, weapon and speed update based on possessed enemy
- Visual indicator of cooldown timer
    - Show indicator when it is available vs show cooldown indicator while recharging
    - Decide between: Indicator always visible, visible while pressing Shift, visible in the pause menu
- Life indicator for current body. (EXTRA) Life indicator for bodies that can be possessed
- (EXTRA) Grace period when current body dies to jump, or warning when body can only take one more hit

### UI/Gameflow
- Pause button
    - Continue, Retry, Exit buttons
    - Settings/Options button
- Death -> Retry from start
    - Checkpoints for longer levels. None for now
- Pre-level room exploration
    - Hop from room to room to scout and choose starting body
    - Enemy type info when hovering over
    - (EXTRA, low priority) Pre-level hacking menu

### General
- Breakable objects (do CharacterBody2D, give "category" variable)
- Patrol routes for enemies. Currently static until engaged
- Clean up attacking assets and timing (mainly melee)
- Dash/Dodge mechanic?
- Melee hits to break bullets?


----------------------------------------------------------------------------------------------------------------------------------------------------------------


# Update Log

## 5-27-2021

### Summary
- Detection fixes (based on ray cast, not hearing)
- Room separation
- New mechanics discussed
- Killed Jose, made him a Virus
- First story draft

### Details
- Detection fixes
    - Raycast is created when the thugs are loaded
    - Raycast points to Jose when he enters the room
    - Tracking begins when line of sight is confirmed
    - Pending: Being tracking when a sound is heard
    - Pending: Hearing range to be expanded or reworked
 
- Rooms
    - Clear entries and exits, locked when Player enters the area
    - Entries and exits unlock when all enemies within are killed
    - Engages enemy vision Raycast when entered
    - Pending: Fix position so Jose is not bumped inside
    - Pending: Warning so Jose knows he has entered a room. Visual/Sound required
 
- New mechanics (The Virus)
    - Remove Jose as an entity
    - The Virus will take over the bodies of enemies (with their weapons and HP)
 
- Story draft
    - Focus on the unnamed grandchild
    - Done in runs. 4-5 levels depending on choices, interactions in between
    - 4 main bosses, 2 offered at random each levels
    - Unselected boss shows up the next level
    - A boss that's skipped twice becomes the "Final Boss" for that run
    - If every boss is selected so that they don't become a "Final Boss", a 5th boss appears for an extra level
    - WIP: When defeating a boss, some of their personality gets absorbed along their data
    - WIP: Different endings based on choices and interactions between levels
 
### Plans for next update
- Generalize Room Scene (if possible)
- Decide if all doors open, or only the "exits"
- Revise/Polish story
- Implement "Possession" mechanics

----------------------------------------------------------------------------------------------------------------------------------------------------------------

## 5-08-2021

### Summary
- Melee guard attack implemented
- Jose update (shooting delay and invisibility frames)
- Updated Level 1 map for testing
- Guard customizability update

### Details
- Melee Guard
    - Attack speed of 0.8
    - Hits the latest location towards Jose
    - Fastest enemy
    - 3 HP for durability

- Jose Update
    - Can shoot every 0.3 seconds
    - Can't take damage within 0.4 seconds of being hurt
    - No death implemented yet

- Swing scene
    - Highly dependent on parent (Melee guard)
    - Updates constantly, hides visibility when animation is done
    - Needs a better animation and sound effects. Purely placeholders atm
 
- Guard customizability
    - Hearing range points to different shapes so they can be unique
    - Ready function with super() should be run after parameters are set within children
    - Navigation Agents do function independently
 
- Level 1
    - https://www.canva.com/design/DAHEcrwY9Iw/6ggjlt2leKRWtDzwm7_ygg/edit
    - Enemies placed in planned positions. Level 2 needs a link
    - Guard count and ranges (hearing and attacking) require updates


### Plans for next update
- Balance enemies
- Build levels properly
- Debugging -> Export

  
----------------------------------------------------------------------------------------------------------------------------------------------------------------



## 30-07-2021

### Summary
- Navigation agent and navigation regions refined
- Base guard functions reorganized
- Navigation made universal for all guards. Attack range depends on subtype

### Details
- Base guard scene and script
    - Navigation at slow speed when Jose is heard but not seen
    - Navigation at faster speed when Jose is seen and heard
    - Attacks started when Jose is seen at x1.5 of attack range
    - Return to original location after guard cannot reach the target for 2 seconds

- Åttack ranges
    - Pistol w/ 150 range
    - Shotgun w/ 70 range
    - SMG w/ 100 range
    - Melee w/ 50 range

- Swing update
    - Created but not functional yet


### Plans for next update
- Melee enemy (attack mechanics and swing file)
- Add all enemies to the both maps

  
----------------------------------------------------------------------------------------------------------------------------------------------------------------


## 29-07-2021

### Summary
- Reorganized files and created base guard scene/script
- Implemented enemy subtypes (Shotgun, SMG)
- Shotgun spread working as intended
- Added behavior for Jose going out of sight while being shot at
- Started pathfinding and navigation

### Details
- Base guard scene and script
    - Shared functionality: take damage, ready, physics process, hearing/seeing signals and timers
    - Default variables for setup, HP and speed are guard dependent
    - Inherited as a class using "extend"

- Shotgun Guard
    - 3 bullets, 10 degree spread approximately

- SMG
    - 25 bullets, faster rate of fire, longer pauses between bursts

- Bullet update
    - Stops updating in real time if 2d ray cast does not collide with Jose.
    - Moves slowly towards current position when vision is blocked


### Plans for next update
- Melee enemy (movement while/before attacking required)
- Implement basic navigation and routes for different enemy types

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------


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
