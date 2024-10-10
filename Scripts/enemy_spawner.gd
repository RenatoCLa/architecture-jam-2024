extends Node2D

var enemy: PackedScene = preload("res://Scenes/base_enemy.tscn")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var spawn_range: PathFollow2D
@onready var spawn_pivot: Marker2D

var g_dmg_multi: float = 0
var g_speed_multi: float = 0
var g_hp_multi: float = 0
var g_xp_multi: float = 0

var wave_size: int = 6
var current_wave_size: int
var is_wave_finished: bool = false

var wave: int = 1
var wave_increment: int = 0

var player_pos: Vector2

@onready var pos_timer: Timer = Timer.new()

func _ready() -> void:
	spawn_range = player.spawn_range
	spawn_pivot = player.spawn_pivot
	
	pos_timer.wait_time = .3
	pos_timer.one_shot = true
	pos_timer.timeout.connect(update_pos)
	pos_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(pos_timer)
	
	start_wave()

func _physics_process(delta: float) -> void:
	if pos_timer.is_stopped():
		position_timer()

#causes a tiny delay in the enemies movement to make their movement less weird
func position_timer() -> void:
	pos_timer.start()

func update_pos():
	player_pos = player.global_position

func spawn(enemy):
	var entity = enemy.instantiate()
	apply_stats(entity)
	entity.player = player
	entity.global_position = rand_position()
	add_child(entity)

func rand_position() -> Vector2:
	rng.randomize()
	spawn_range.progress = rng.randi_range(0, 2600)
	return spawn_pivot.global_position

func apply_stats(enemy):
	enemy.hp_multi = stat_range(g_hp_multi)
	enemy.dmg_multi = stat_range(g_dmg_multi)
	enemy.speed_multi = stat_range(g_speed_multi)
	enemy.size_multi = stat_range(enemy.hp_multi/100)
	enemy.xp_multi = stat_range(g_xp_multi)

func stat_range(multi_ceiling):
	var multi_floor: float = clampf((multi_ceiling - 2), 0, multi_ceiling)
	var chosen_multi = snappedf(randf_range(multi_floor, multi_ceiling), 0.01)
	
	return chosen_multi

func on_entity_death():
	current_wave_size -= 1
	print("current_wave_size ", current_wave_size)
	if current_wave_size <= 0:
		wave_over()

func wave_over() -> void:
	print("wave ", wave, " ended")
	wave += 1
	increase_wave_difficulty()
	await get_tree().create_timer(5, false).timeout
	print("Rest is over")
	start_wave()

func increase_wave_difficulty() -> void:
	if wave % 5:
		g_dmg_multi += 1
		g_hp_multi += .5
		g_speed_multi += .1
		g_xp_multi += 1
		wave_increment += roundf(wave_size/2)
		wave_size += wave_increment
	else:
		g_dmg_multi += .25
		g_hp_multi += .10
		g_speed_multi += .05
		g_xp_multi += .25
		wave_size += 5

func start_wave() -> void:
	print("dmg_multi: ", g_dmg_multi)
	#display text here saying WAVE "N" once wave starts
	#
	print("wave started")
	current_wave_size = wave_size
	print(current_wave_size)
	wave_spawning()

func wave_spawning() -> void:
	var spawned_enemies: int = 0
	var current_wave = current_wave_size
	print("current wave: " , wave)
	while spawned_enemies < current_wave:
		rng.randomize()
		await get_tree().create_timer(rng.randf_range(0, 2), false).timeout
		spawn(enemy)
		spawned_enemies += 1
		print("spawned: ", spawned_enemies, "/ Wave: ", current_wave)
		print(current_wave - spawned_enemies, " Remaining")
