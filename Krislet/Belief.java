//File: Belief.java

//These are the set of belief prepositions that our agent can add to it's belief space by processing the precepts. 

public enum Belief {
	//Precepts used for defender.
	ballVisible,
	ballFar,
	ballNear,
	ballTouched,
	inDZone,
	inGZone,
	inAZone,
	selfGoalVisible,
	atOwnNet,
	goalVisible,
	readyToDefend, // Not sure the meaning
	facingBall,
	facingGoal,
	ballInDefenseRange // Not sure the meaning
}
