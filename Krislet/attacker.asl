// Attacker agent

/* Initial beliefs */

/* Initial goal */
!find_ball.

/* plans */

//**goal = find_ball**//
// if attacker can not see the ball, then turn till the ball is visible
+!find_ball
	: not ballVisible
	<-	turn;
	 	!find_ball.
// if attacker can see the ball, and not in direction of ball then turn to ball
+!find_ball
	: ballVisible & not facingBall
	<-	turn_to_ball;
	 	!find_ball.
        
// if attcker can see the ball, and in direction of ball then dash to ball
+!find_ball
	: facingBall & not ballNear
	<- !rush_to_ball.
		
//**goal = rush_to_ball**//		
// if attacker can see the ball and is not near ball then run towards ball
+!rush_to_ball
	: ballVisible & not ballNear
	<-	dash_to_ball;
        !rush_to_ball.
// if attacker can not see the ball then find ball
+!rush_to_ball
	: not ballVisible 
	<-	!find_ball.
// if attacker is near ball, and not in direction of ball then turn to ball
+!rush_to_ball
	: ballVisible & ballNear & not facingBall
	<-	turn_to_ball;
        !find_goal_post.
		
//**goal = find_goal_post**//	
// if attacker can see the ball, in kick range and facing ball and goal post not found then turn to find goal post
+!find_goal_post
	: ballVisible & ballNear & facingBall & not goalVisible 
	<-	turn;
        !find_goal_post.	
// if attacker  can see the ball, in kick range and facing ball and goal post found then kick the ball
+!find_goal_post
	: ballVisible & ballNear & facingBall & goalVisible
	<-	kick;
		!find_ball.
	
		
