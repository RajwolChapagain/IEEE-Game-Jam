extends Node2D

@export var deck: Deck
@export var player: Player
@export var enemy: Player
@export var dealt_positions: Array[Marker2D]
@export var enemies: Array[EnemyStats]
@export var enemy_index = 0
@export var cheshire_scene: PackedScene

enum BATTLE {LOSS, WIN, CONTINUE}

var dealt_card: Array[Card] = []
var player_turn: bool = false
var deal_size: int = 10
var battle_ended: bool = false
var can_select_swappable = false
var selected_cards = []
var card_scene = preload("res://scenes/card.tscn")
var relic_picker_scene = preload("res://scenes/relic_picker.tscn")


func _ready():
	load_enemy(enemy_index)
	start_game()

func start_game():
	battle_ended = false
	await deal()
	enemy_turn()

func deal():
	var tween_duration = 0.2
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].card_clicked.connect(_on_card_clicked)
		dealt_card[i].face_up = true
		var tween = create_tween()
		tween.tween_property(dealt_card[i],"global_position",dealt_positions[i].global_position,tween_duration)
		dealt_card[i].update_card()
	await start_timer(tween_duration)

func enemy_turn():
	if dealt_card.size() > 0:
		var index: int = randi_range(0, dealt_card.size()-1)
		dealt_card[index].card_clicked.disconnect(_on_card_clicked)
		enemy.pick(dealt_card[index])
		dealt_card.pop_at(index)
		player_turn = not player_turn
	else:
		start_battle()

func continue_game():
	clear_game()
	start_game()

func start_battle():
	apply_effects(player.hand, enemy.hand)
	player.shuffle_hand()
	enemy.shuffle_hand()

	do_battle()
	
func do_battle() -> void:
	var hand_size: int = deal_size / 2

	for i in range(0, hand_size):
		if battle_ended or player.hand.is_empty() or enemy.hand.is_empty():
			return
		await do_round(player.hand[i], enemy.hand[i])
	
	continue_game()

func do_round(player_card: Card, enemy_card: Card) -> void:
	await start_timer(0.8)
	
	flip_card_up(player_card)
	flip_card_up(enemy_card)
	
	compare_cards_and_do_damage(player_card.get_comparison_val(), enemy_card.get_comparison_val())
	
func compare_cards_and_do_damage(player_card_val, enemy_card_val):
	print(player_card_val, " fought with ", enemy_card_val)
	var cmp = Calculator.compare(player_card_val, enemy_card_val)
	
	if cmp == 1:
		damage_entity(enemy)
	elif cmp == -1:
		damage_entity(player)
	else:
		# Draw
		pass

func damage_entity(entity: Player) -> void:
	entity.take_damage(1)

func flip_card_up(card: Card) -> void:
	card.face_up = true
	card.update_card()

func flip_card_down(card: Card) -> void:
	card.face_up = false
	card.update_card()
	
func start_timer(wait_time: float):
	var timer = Timer.new() 
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func clear_game():
	player.clear()
	enemy.clear()
	dealt_card.clear()
	deck.clear()
	deck.shuffle_deck()

func _on_card_clicked(card: Card):
	if player_turn:
		card.card_clicked.disconnect(_on_card_clicked)
		player.pick(card)
		remove_from_dealt(card)
		player_turn = not player_turn
		enemy_turn()

func remove_from_dealt(card):
	for i in range(0, dealt_card.size()):
		if str(dealt_card[i]) == str(card):
			dealt_card.pop_at(i)
			return

func _on_player_entity_died() -> void:
	end_battle(false)
	print("Player lost!")

func _on_enemy_entity_died() -> void:
	end_battle(true)
	print("Player won!")
	
func end_battle(player_won: bool) -> void:
	battle_ended = true
	
	if player_won:
		return_cards()
		replenish_player_hp()
		pick_relic()
		if enemy_index >= 0:
			instantiate_cheshire()
			deal_swappable_cards()
		else:
			load_next_enemy()
			start_game()

func pick_relic():
	var relic_picker = relic_picker_scene.instantiate()
	
	var rand1 = randi_range(0, 9)
	var rand2 = randi_range(0, 9)
	
	var unwanted_relics = [Relic.relic_type.SPADE_SAVE, Relic.relic_type.DIAMOND_DETERRENT, Relic.relic_type.HEALTH_BOOST]
	
	while (rand1 in player.relics or rand1 in unwanted_relics):
		rand1 = randi_range(0, 9)
		
	while (rand2 in player.relics or rand1 == rand2 or rand2 in unwanted_relics):
		rand2 = randi_range(0, 9)
	
	relic_picker.initialize(rand1, rand2)	
	get_tree().root.add_child(relic_picker)
	relic_picker.relic_picked.connect(on_relic_picked)
	get_tree().paused = true
	
func on_relic_picked(relic_type):
	player.relics.append(relic_type)
	
func replenish_player_hp():
	player.hp = player.initial_hp
	player.get_node("HealthBar").value = player.hp
	
func return_cards():
	# Flips the hands down and empties the hands arrays
	player.hand.all(flip_card_down)
	enemy.hand.all(flip_card_down)
	
	for card in player.hand:
		card.applied_effects.clear()
		card.hide_effects()
	for card in enemy.hand:
		card.applied_effects.clear()
		card.hide_effects()
	
	enemy.hand.clear()
	player.hand.clear()
	# Returns all cards to the deck's position
	deck.clear() 
	dealt_card.clear()

func load_next_enemy():
	enemy_index += 1
	load_enemy(enemy_index)

func load_enemy(index: int):
	enemy.load_new_enemy(enemies[index])
	
func apply_effects(player_hand, enemy_hand):
	for relic in player.relics:
		Relic.add_effect(player_hand, enemy_hand, relic)
	
	stamp_cards(player_hand, enemy_hand)
	
func stamp_cards(hand, enemy_hand):
	for card in hand:
		card.display_effects()
	for card in enemy_hand:
		card.display_effects()

func instantiate_cheshire():
	var cheshire = cheshire_scene.instantiate()
	cheshire.cheshire_closed.connect(on_cheshire_closed)
	cheshire.five_selected.connect(on_five_selected)
	add_child(cheshire)
	
func on_cheshire_closed():
	load_next_enemy()
	start_game()

func deal_swappable_cards():
	var tween_duration = 0.2
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].card_clicked.connect(on_swappable_card_clicked)
		dealt_card[i].face_up = true
		var tween = create_tween()
		tween.tween_property(dealt_card[i],"global_position",dealt_positions[i].global_position,tween_duration)
		dealt_card[i].update_card()
	
	await get_tree().create_timer(0.8)
	
func on_five_selected():
	enable_swappable_card_selection()

func enable_swappable_card_selection():
	can_select_swappable = true

func on_swappable_card_clicked(card):
	if not can_select_swappable:
		return
		
	if card not in selected_cards:
		selected_cards.append(card)
		card.modulate = Color(card.modulate.r, card.modulate.g, card.modulate.b, 0.6)
	else:
		var index = -1
		for i in range(0, len(selected_cards)):
			if str(selected_cards[i]) == str(card):
				index = i
				break
		
		selected_cards.pop_at(index)
		card.modulate = Color(card.modulate.r, card.modulate.g, card.modulate.b, 1)
		
	if len(selected_cards) == 5:
		swap_with_cheshire()
		can_select_swappable = false
		
func swap_with_cheshire():
	for card in selected_cards:
		deck.deck.pop_at(get_card_index_in_deck(card))
		card.queue_free()
	
	for card in $CheshireHat.selected_cards:
		var new_card = card_scene.instantiate()
		new_card.rank = card.rank
		new_card.suit = card.suit
		new_card.type = card.type
		new_card.face_up = false
		new_card.update_card()
		add_child(new_card)
		deck.deck.append(new_card)
		
	for i in range(0, len(selected_cards)):
		var temp = selected_cards[i].global_position
		selected_cards[i].global_position = $CheshireHat.selected_cards[i].global_position
		$CheshireHat.selected_cards[i].global_position = temp
	
	$CheshireHat.close()
	return_cards()
	selected_cards.clear()
	
func get_card_index_in_deck(card):
	for i in range(0, len(deck.deck)):
		if str(deck.deck[i]) == str(card):
			return i
			
