extends Object
class_name Calculator

# Returns true if card1 beats card2
static func compare(card1: Card, card2: Card) -> bool:
	return card1.rank > card2.rank
