//File: Belief.java

//These are the set of belief prepositions that our agent can add to it's belief space by processing the precepts. 

public enum Belief {
	//Precepts used for defender.
	BALL_VISIBLE,
	BALL_FAR,
	BALL_NEAR,
	BALL_TOUCHED,
	IN_D_ZONE,
	IN_G_ZONE,
	IN_A_ZONE,
	SELF_GOAL_VISIBLE,
	AT_OWN_NET,
	GOAL_VISIBLE,
	READY_TO_DEFEND, // Not sure the meaning
	FACING_BALL,
	FACING_GOAL,
	BALL_IN_DEFENCE_RANGE // Not sure the meaning
}
