extends Object
class_name Calculator

# Returns:
#  1: if card1 beats card2
# -1: if card2 beats card1
#  0: if it's a tie 
static func compare(val1: int, val2: int) -> int:
	if val1 > val2:
		return 1
	elif val1 < val2:
		return -1
	else:
		return 0
