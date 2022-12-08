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
	: ball_visible & not ball_near & not facing_ball
	<-	turn_to_ball;
	 	!find_ball.
        
// if attacker can see the ball, and in direction of ball then dash to ball
+!find_ball
	: ball_visible & facing_ball & not ball_near & not in_d_zone
	<- dash_to_ball; 
	!rush_to_ball.

+!find_ball
	: ball_visible & facing_ball & not ball_near & in_d_zone & not self_goal_visible
	<- dash_to_ball; 
	!rush_to_ball.

// if attacker is not in its zone, monitor ball
+!find_ball
	: ball_visible & in_d_zone & self_goal_visible
	<- monitor_ball; 
	!find_ball.

// if ball is near and visible, find goal post	
+!find_ball
	: ball_visible & ball_near
	<- !find_goal_post.
		
//**goal = rush_to_ball**//		
// if attacker can see the ball and is not near ball then run towards ball
+!rush_to_ball
	: ball_visible & facing_ball & not ball_near & not in_d_zone
	<-	dash_to_ball;
        !rush_to_ball.
+!rush_to_ball
	: ball_visible & facing_ball & not ball_near & in_d_zone & not self_goal_visible
	<- dash_to_ball; 
	!rush_to_ball.
// if attacker can not see the ball then find ball
+!rush_to_ball
	: not ball_visible
	<-	!find_ball.
//if attacker is runnig towards self goal to the ball then stop once in dzone!
+!rush_to_ball
	: ball_visible & self_goal_visible & in_d_zone
	<- monitor_ball;
	!find_ball.

+!rush_to_ball
	: ball_visible & ball_near & not goal_visible
	<- turn;
	!find_goal_post.

+!rush_to_ball
	: ball_visible & ball_near & goal_visible
	<- kick;
	- ball_near;
	!find_ball.

		
//**goal = find_goal_post**//		
// if attacker can see the ball, in kick range and facing ball and goal post found then kick the ball
+!find_goal_post
	: ball_near & goal_visible 
	<-	kick;
		- ball_near;
		!find_ball.

+!find_goal_post
	: ball_near & not goal_visible 
	<-	turn;
		!find_goal_post.
		
