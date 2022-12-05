// goalie agent
// kick to defence changed to kick at line 54

/* Initial beliefs */

/* Initial goal */
!approach_goal.

/* plans */

//**goal = approach_goal**//
// if goalie is not at its own net and goal is seen, go to the net
+!approach_goal
	: not atOwnNet & goalVisible
	<-	dashToOwnGoal;
	 	!approach_goal.
// if goalie is not at its own net and goal is not seen, find the net
+!approach_goal
	: not atOwnNet & not goalVisible
	<-	findGoal;
	 	!approach_goal.
// if goalie is at its own net and goal is not seen, find the net
+!approach_goal
	: atOwnNet & not goalVisible
	<-	findGoal;
	 	!approach_goal.		
		
// if goalie is at its own net and goal is seen, add goal keep_goal
+!approach_goal
	: atOwnNet & goalVisible
	<-	+readyToDefend;
	 	!keep_goal.
		
//**goal = keep_goal**//		
// if goalie is ready to defence, ball is not seen, find the ball
+!keep_goal
	: not ballVisible & readyToDefend 
	<-	!find_ball.
// if goalie is ready to defence, ball is seen, but not facing the ball, turn to the ball
+!keep_goal
	: ballVisible & readyToDefend 
	<-	turnToBall;
		!keep_goal.
// if goalie is ready to defence, ball is seen and facing the ball, but ball is not in defence range, do nothing
+!keep_goal
	: ballVisible & facingBall & readyToDefend & not ballInDefenseRange 
	<-	!keep_goal.
// if goalie is ready to defence, ball is seen and facing the ball, ball is in defence range, but not in kick range, run to the ball
+!keep_goal
	: ballVisible & facingBall & readyToDefend & ballInDefenseRange & not ballNear
	<-	!approachBall.
// if goaile in the kick range, kick to defence 
+!keep_goal: ballNear
	<- kick;
		!approach_goal.
		
//**goal = approach_ball**//	
// if ball is not seen when approaching, go to the goal
+!approach_ball
	: not ballVisible | not facingBall 
	<-	!approach_goal.	
// if ball is seen but agent is not near the ball, go to the ball
+!approach_ball
	: ballVisible & facingBall & not ballNear
	<-	-readyToDefend;
		approachBall;
		!approach_ball.
// when ball is in kick range, kick to defence
+!approach_ball
	: ballNear
	<-	!keep_goal.

//**goal = find_ball**//
// if ball is seen, but not facing ball
+!find_ball
	: ballVisible & not facingBall
	<-	turnToBall;
		!find_ball.
//if ball is found, go to keep_goal
+!find_ball
	: ballVisible & facingBall
	<- !keep_goal.
//if ball is not seen, turn and wait for input
+!find_ball
	: not ballVisible
	<-	turn;
		!find_ball.
	
		
