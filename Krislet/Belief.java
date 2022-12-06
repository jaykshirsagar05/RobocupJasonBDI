//File: Belief.java

//These are the set of belief prepositions that our agent can add to it's belief space by processing the precepts. 

public enum Belief {
	//Precepts used for defender.
	BALL_VISIBLE,
	ballFar,
	BALL_NEAR,
	ballTouched,
	inDZone,
	inGZone,
	inAZone,
	SELF_GOAL_VISIBLE,
	AT_OWN_NET,
	goalVisible,
	READY_TO_DEFEND,
	FACING_BALL,
	facingGoal,
	BALL_IN_DEFENSE_RANGE
}
