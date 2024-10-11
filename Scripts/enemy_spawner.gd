extends Node2D

#VARIABLES

#Status Multipliers
var g_dmg_multi: float = 0 #increases enemy damage
var g_speed_multi: float = 0 #increases enemy movement speed
var g_hp_multi: float = 0 #increases enemy max health
var g_xp_multi: float = 0 #increases experience gained from killing enemies

#Wave Management Variables
var wave_size: int = 6 #amount of enemies that will spawn in any given wave
var current_wave_size: int #tracks how many enemies remain in the wave
var is_wave_finished: bool = false #checks if a
var wave: int = 1 #tracks the number of the current wave

#In every 5th wave, the wave size will have a bigger increase in number
#dictated by the below variable
var wave_size_increment: int = 0 #this += half of the wave size

#Preloaded Enemies
var enemy: PackedScene = preload("res://Scenes/base_enemy.tscn")

#Onready variables
@onready var wave_popup: PackedScene = preload("res://Scenes/wave_popup.tscn")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") #reference to the player node
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var spawn_range: PathFollow2D #area where enemies can spawn
@onready var spawn_point: Marker2D #exact point where enemies will spawn
@onready var pos_timer: Timer = Timer.new() #timer to set up a small delay
#for the game to pick up the player variable, did this to make enemies not
#move to your direction instantly, felt kinda weird to me how they moved

#Player Position
var player_pos: Vector2 #this value is given to all enemies so they know
#where the player is

#FUNCTIONS

func _ready() -> void:
	#creates references to the appropriate nodes
	spawn_range = player.spawn_range
	spawn_point = player.spawn_point
	
	#setting up the position timer
	pos_timer.wait_time = .3 #how long for each pos update
	pos_timer.one_shot = true
	pos_timer.timeout.connect(update_pos) #connect to the update function
	pos_timer.process_mode = Node.PROCESS_MODE_PAUSABLE #stops timer when
	#game is paused
	add_child(pos_timer) #add timer to the scene
	
	start_wave() #begin the game by spawining the first wave

func _physics_process(_delta: float) -> void:
	#checks if it's time for a position update
	if pos_timer.is_stopped():
		pos_timer.start() #starts the timer
		#calls the position update on timeout

#ENEMY FUNCTIONS

func spawn(enemy) -> void: #spawns an enemy
	var entity = enemy.instantiate() #creates instance of the enemy
	set_stats(entity) #set their stats to the appropriate values
	entity.player = player
	entity.global_position = rand_position()
	add_child(entity)

#adjusts the enemy stats to fit the current wave
func set_stats(enemy):
	#stats are increased via multipliers that increase for every wave
	enemy.hp_multi = stat_range(g_hp_multi)
	enemy.dmg_multi = stat_range(g_dmg_multi)
	enemy.speed_multi = stat_range(g_speed_multi)
	enemy.size_multi = stat_range(enemy.hp_multi/100)
	enemy.xp_multi = stat_range(g_xp_multi)

#this will pick a random value for the stats multiplier
#this is meant to add more variety to the enemies, so not every one of them
#has the same stats, but rather a value ranging from the lowest to highest
#multiplier possible
func stat_range(multi_ceiling):
	#calculates the minimum multiplier
	#the lowest multiplier can only be at most 2 points lower then the
	#highest multiplier
	var multi_floor: float = clampf((multi_ceiling - 2), 0, multi_ceiling)
	
	#picks a random value for the multiplier
	var chosen_multi = snappedf(randf_range(multi_floor, multi_ceiling), 0.01)
	
	return chosen_multi

#chooses a random position for the enemy to spawn on
func rand_position() -> Vector2: 
	rng.randomize() #picks a new seed for the random number generator
	spawn_range.progress = rng.randi_range(0, 2600)
	return spawn_point.global_position

#gets the position of the player
func update_pos() -> void: 
	player_pos = player.global_position

func on_entity_death() -> void:
	#on death
	current_wave_size -= 1 #reduce number of enemies by 1
	print("current wave size: ", current_wave_size)
	if current_wave_size <= 0: #if there's no enemy left
		wave_over()

#WAVE FUNCTIONS

func start_wave() -> void:
	print("dmg_multi: ", g_dmg_multi)
	#display text here saying WAVE "N" once wave starts
	display_wave_info()
	print("wave started")
	
	#tells the game how many enemies should spawn in this wave
	current_wave_size = wave_size
	print(current_wave_size)
	
	#starts spawning enemies
	wave_spawning()

func wave_spawning() -> void:
	var spawned_enemies: int = 0 #how many enemies have been spawned
	var current_wave = current_wave_size #how many enemies this wave needs
	print("current wave: " , wave)
	
	#run this until every enemy has been spawned
	while spawned_enemies < current_wave:
		rng.randomize()
		
		#pick a delay between each enemy spawn
		await get_tree().create_timer(rng.randf_range(0, 3), false).timeout
		
		spawn(enemy)
		spawned_enemies += 1
		print("spawned: ", spawned_enemies, " / Wave: ", current_wave)
		print(current_wave - spawned_enemies, " Remaining")

func display_wave_info() -> void:
	var popup = wave_popup.instantiate()
	add_child(popup)
	popup.label.text += str(wave)

#called when the wave is finished
func wave_over() -> void:
	print("wave ", wave, " ended")
	wave += 1 #increase the wave number
	increase_wave_difficulty() #increases wave size and enemy stats
	
	await get_tree().create_timer(3, false).timeout #gives player a break
	print("Rest is over")
	start_wave() #starts next wave

func increase_wave_difficulty() -> void:
	#increases stats by this much every 5th wave
	if wave % 5:
		#increases the multipliers used by the enemies
		g_dmg_multi += 1
		g_hp_multi += .5
		g_speed_multi += .1
		g_xp_multi += 1
		
		rng.randomize()
		#increases amount of enemies that will spawn in the next wave
		wave_size_increment += rng.randi_range(roundf(wave_size/2), wave_size)
		print("WAVE SIZE %d" %wave_size_increment)
		wave_size += wave_size_increment
	else: #increases stats by this much every other wave
		#enemy stat multiplier
		g_dmg_multi += .25
		g_hp_multi += .10
		g_speed_multi += .05
		g_xp_multi += .25
		#wave enemy amount increase
		wave_size += 5
