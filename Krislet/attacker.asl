// Attacker agent

/* Initial beliefs */

/* Initial goal */
!find_ball.

/* plans */

//**goal = find_ball**//
// if attacker can not see the ball, then turn till the ball is visible
+!find_ball
	: not ball_visible
	<-	turn;
	 	!find_ball.
// if attacker can see the ball, and not in direction of ball then turn to ball
+!find_ball
	: ball_visible & not facing_ball
	<-	turn_to_ball;
	 	!find_ball.
        
// if attacker can see the ball, and in direction of ball then dash to ball
+!find_ball
	: ball_visible & facing_ball & not ball_near
	<- dash_to_ball 
	!rush_to_ball.
	
+!find_ball
	: ball_visible & facing_ball & ball_near
	<- !find_goal_post.
		
//**goal = rush_to_ball**//		
// if attacker can see the ball and is not near ball then run towards ball
+!rush_to_ball
	: facing_ball & not ball_near
	<-	dash_to_ball;
        !rush_to_ball.
// if attacker can not see the ball then find ball
+!rush_to_ball
	: not ball_visible
	<-	!find_ball.
// if attacker is near ball, and not in direction of ball then turn to ball
+!rush_to_ball
	: ball_visible & ball_near & not facing_ball
	<-	turn_to_ball;
        !find_goal_post.
+!rush_to_ball
	: ball_visible & ball_near & facing_ball 
	<- turn;
	- ball_visible;
	- facing_ball
	!find_goal_post.
		
//**goal = find_goal_post**//		
// if attacker  can see the ball, in kick range and facing ball and goal post found then kick the ball
+!find_goal_post
	: ball_near & goal_visible 
	<-	kick;
		- ball_near;
		- goal_visible;
		!find_ball.

+!find_goal_post
	: ball_near & not goal_visible 
	<-	turn;
		!find_goal_post.

	
		
