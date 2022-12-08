// goalie agent

/* Initial beliefs */

/* Initial goal */
!keep_goal.

/* plans */

//**goal = keep_goal**//
//if goalie is outside of goalie zone, go back
+!keep_goal
	:   not_in_goalie_range
	<-	!approach_goal.
+!keep_goal
	:	self_goal_visible & self_goal_far
	<- !approach_goal.
//if can't see the ball, find the ball
+!keep_goal
	:   not ball_visible 
	<-	turn;
		!keep_goal.
//if ball seen, not in defence range, keep looking
+!keep_goal
	:   ball_visible & not ball_in_defence_range & not ball_near
	<-	turn_to_ball;
		!keep_goal.

//if ball seen, it's in defence range, run to the ball 
+!keep_goal
	:   ball_visible & ball_in_defence_range & not ball_near & ball_far
	<-	!approach_ball.
// if ball is near, save the ball	
+!keep_goal
	:   ball_visible & ball_near 
	<-	!save_ball.



//**goal = approach_ball**//
// if goalie passes goalie range, go back 		
+!approach_ball
	:   not_in_goale_range 
	<-	!approach_goal.
// if ball not seen during approaching ball, find the ball
+!approach_ball
	:   not ball_visible | not facing_ball
	<-	!find_ball.
// if ball seen, goalie in goalie range, dash to the ball
+!approach_ball
	:   ball_visible & not not_in_goalie_range & not ball_near 
	<-	dash_to_ball;
		!approach_ball.
// if ball found but not facing the ball, turn to the ball
+!approach_ball
	:   ball_visible & not not_in_goalie_range & not ball_near & not facing_ball
	<-	!find_ball.
// if ball seen, goalie in goalie range, in save range, save ball	
+!approach_ball
	:   ball_visible & not not_in_goalie_range  & facing_ball & ball_near
	<-	!save_ball.


//**goal = save_ball**//
// if ball is seen, is near, and facing self goal, kick backward
+!save_ball
	:	ball_visible & ball_near & self_goal_visible
	<-	kick_to_defence;
		!keep_goal.
// if ball is seen, is near, and facing enemey's goal, kick forward
+!save_ball
	:	ball_visible & ball_near & goal_visible
	<-	kick;
		!keep_goal.
// if ball is seen, is near, and facing other position, just kick to outside
+!save_ball
	:	ball_visible & ball_near & not goal_visible & not self_goal_visible
	<-	kick_to_defence;
		!keep_goal.
// if ball is seen, is not near, approach ball
+!save_ball
	:	ball_visible & not ball_near 
	<-	!approach_ball.
// if ball is not seen when saving, find ball
+!save_ball
	:	not ball_visible & not ball_near 
	<-	!find_ball.


//**goal = find_ball**//
//if ball is found, go back to approaching
+!find_ball
	: 	ball_visible & facing_ball
	<-	!approach_ball.
// if ball is seen, but not facing ball, turn to the ball
+!find_ball
	: 	ball_visible & not facing_ball
	<-	turn_to_ball;
		!find_ball.
//if ball is not seen, turn and wait for input
+!find_ball
	: 	not ball_visible
	<-	turn;
		!find_ball.

//**goal = approach_ball**//
// if goalie is at its own net and goal is seen, add hold the position and keep goal
+!approach_goal
	:   at_own_net 
	<-	!keep_goal.
// if goalie is not at its own net and goal is far away, go to the net
+!approach_goal
	:   self_goal_visible & not at_own_net & self_goal_far & facing_self_goal & not ball_in_defence_range
	<-	dash_to_own_goal;
	 	!approach_goal.
+!approach_goal
	:   self_goal_visible & not at_own_net & self_goal_far & facing_self_goal & ball_in_defence_range
	<-	!approach_ball.
+!approach_goal
	:   self_goal_visible & not at_own_net & self_goal_far & not facing_self_goal
	<-	turn_to_self_goal;
	 	!approach_goal.
// if goalie is not at its own net and goal is not seen, find the net
+!approach_goal
	:   not self_goal_visible & not at_own_net 
	<-	turn;
		!approach_goal.



