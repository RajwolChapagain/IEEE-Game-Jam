extends Node
class_name Relic

enum relic_type {DOUBLE_DOUBLE, BLACK_CAT, BLEEDING_HEART, ELEMENTAL_COURAGE, SPADE_SAVE, HARD_HAND, DIAMOND_DETERRENT, SUPER_SUIT, CLUB_HOUSE, HEALTH_BOOST}

static func apply_relic(card_val: int, type: relic_type) -> int:
	match type:
		relic_type.DOUBLE_DOUBLE:
			return card_val * 2
		relic_type.BLACK_CAT:
			return card_val + 1
		relic_type.BLEEDING_HEART:
			return card_val / 2
		relic_type.ELEMENTAL_COURAGE:
			return card_val + 2
		relic_type.SPADE_SAVE:
			return 0
		relic_type.HARD_HAND:
			return 1
		relic_type.DIAMOND_DETERRENT:
			return 0
		relic_type.SUPER_SUIT:
			return card_val + 3
		relic_type.HEALTH_BOOST:
			return 0
		_:
			return 0

static func add_effect(hand, enemy_hand, relic):
	match relic:
		relic_type.DOUBLE_DOUBLE:
			for card in hand:
				if Relic.count_freq(card, hand) == 2:
					card.applied_effects.append(relic_type.DOUBLE_DOUBLE)
		relic_type.BLACK_CAT:
			var black_count = 0
			for card in hand:
				if card.suit == Card.SUIT.SPADE or card.suit == Card.SUIT.CLUB:
					black_count += 1
			
			if black_count == 5:
				for card in hand:
					card.applied_effects.append(relic_type.BLACK_CAT)
					
		relic_type.BLEEDING_HEART:
			for card in enemy_hand:
				if card.suit == Card.SUIT.HEART:
					card.applied_effects.append(relic_type.BLEEDING_HEART)
		relic_type.ELEMENTAL_COURAGE:
			for card in hand:
				if card.type != Card.TYPE.NORMAL:
					card.applied_effects.append(relic_type.ELEMENTAL_COURAGE)
		relic_type.SPADE_SAVE:
			pass
		relic_type.HARD_HAND:
			for card in enemy_hand:
				if card.rank == Card.RANK.ACE:
					card.applied_effects.append(relic_type.HARD_HAND)
		relic_type.DIAMOND_DETERRENT:
			pass
		relic_type.SUPER_SUIT:
			for card in hand:
				if count_freq(card, hand) >= 3:
					card.applied_effects.append(relic_type.SUPER_SUIT)
		relic_type.HEALTH_BOOST:
			pass
		_:
			pass
		
static func count_freq(card, hand) -> int:
	var freq = 0
	for c in hand:
		if c.rank == card.rank:
			freq += 1
	return freq
