extends Object
class_name Calculator

# Returns:
#  1: if card1 beats card2
# -1: if card2 beats card1
#  0: if it's a tie 
static func compare(card1: Card, card2: Card) -> int:
	if card1.rank > card2.rank:
		return 1
	elif card1.rank < card2.rank:
		return -1
	else:
		return 0
