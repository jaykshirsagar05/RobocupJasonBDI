// goalie agent
// by Hongbo

/* Initial beliefs */

/* Initial goal */
!approach_goal.

/* plans */

//**goal = approach_goal**//
// if goalie is not at its own net and goal is seen, go to the net
+!approach_goal
	:   self_goal_visible & not at_own_net
	<-	dash_to_own_goal;
	 	!approach_goal.
// if goalie is not at its own net and goal is not seen, find the net
+!approach_goal
	:   not self_goal_visible & not at_own_net
	<-	find_goal;
	 	!approach_goal.
// if goalie is at its own net and goal is not seen, find the net
// +!approach_goal
// 	: atOwnNet & not selfGoalVisible
// 	<-	find_goal;
// 	 	!approach_goal.		
		
// if goalie is at its own net and goal is seen, add goal keep_goal
+!approach_goal
	:   self_goal_visible & at_own_net 
	<-	+ready_to_defend;
		wait_ball;
		!keep_goal.

//**goal = keep_goal**//		
// if goalie is ready to defence, ball is not seen, find the ball
+!keep_goal
	:   not ball_visible   
	<-	turn_to_ball;
		!keep_goal.
// if goalie is ready to defence, ball is seen, but not facing the ball, turn to the ball
+!keep_goal
	:   ball_visible  
	<-	turn_to_ball;
		!keep_goal.
// if goalie is ready to defence, ball is seen and facing the ball, but ball is not in defence range, do nothing
+!keep_goal
	:   ball_visible & not ball_in_defense_range 
	<-	!keep_goal.
// if goalie is ready to defence, ball is seen and facing the ball, ball is in defence range, but not in kick range, run to the ball
+!keep_goal
	:   ballVisible & readyToDefend & ballInDefenseRange & not ball_near
	<-	!approachBall.
// if goaile in the kick range, kick to defence 
+!keep_goal
	: 	ball_near
	<-  kick;
		!approach_goal.
		
//**goal = approach_ball**//	
// if ball is not seen when approaching, go to the goal
// +!approach_ball
// 	: 	not ball_visible | not facing_ball 
// 	<-	!approach_goal.	
// if ball is seen but agent is not near the ball, go to the ball
+!approach_ball
	: 	ball_visible & facing_ball & not ball_near
	<-	-readyToDefend;
		dash_to_ball;
		!approach_ball.
// when ball is in kick range, kick to defence
+!approach_ball
	: 	ball_near
	<-	kick;
		!keep_goal.

//**goal = find_ball**//
// if ball is seen, but not facing ball
+!find_ball
	: 	ball_visible & not facing_ball
	<-	turn_to_ball;
		!find_ball.
//if ball is found, go to keep_goal
+!find_ball
	: 	ball_visible & facing_ball
	<-	!keep_goal.
//if ball is not seen, turn and wait for input
+!find_ball
	: 	not ball_visible
	<-	turn;
		!find_ball.
	
		
