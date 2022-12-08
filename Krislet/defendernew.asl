/* Initial beliefs */

/* Initial goal */
!find_ball.

//**goal = find_ball**//
// if defender can not see the ball, then turn till the ball is visible
+!find_ball
	: not ball_visible
	<-	turn;
	 	!find_ball.
// if defender can see the ball, and not in direction of ball then turn to ball
+!find_ball
	: ball_visible & not ball_near & not facing_ball
	<-	turn_to_ball;
	 	!find_ball.
        
// if defender can see the ball, and in direction of ball and in d zone then dash to ball
+!find_ball
	: ball_visible & facing_ball & not ball_near & not in_g_zone &  not in_a_zone
	<- dash_to_ball; 
	!rush_to_ball.

// if defender can see the ball, and in direction of ball and in a zone and self goal is visible then dash to ball
+!find_ball
	: ball_visible & facing_ball & not ball_near & in_a_zone & self_goal_visible
	<- dash_to_ball; 
	!rush_to_ball.
// if defender can see the ball, and in direction of ball and in g zone and enemy goal is visible then dash to ball
+!find_ball
	: ball_visible & facing_ball & not ball_near & in_g_zone & not self_goal_visible
	<- dash_to_ball; 
	!rush_to_ball.

+!find_ball
	: ball_visible & in_g_zone & self_goal_visible
	<- monitor_ball; 
	!find_ball.

+!find_ball
	: ball_visible & in_a_zone & goal_visible
	<- monitor_ball; 
	!find_ball.
	
+!find_ball
	: ball_visible & ball_near
	<- !find_goal_post.


//**goal = rush_to_ball**//		
// if defender can see the ball and is not near ball then run towards ball
+!rush_to_ball
	: ball_visible & facing_ball & not ball_near & not in_g_zone & not in_a_zone
	<-	dash_to_ball;
        !rush_to_ball.
+!rush_to_ball
	: ball_visible & facing_ball & not ball_near & in_g_zone & not self_goal_visible
	<- dash_to_ball; 
	!rush_to_ball.
+!rush_to_ball
	: ball_visible & facing_ball & not ball_near & in_a_zone & not goal_visible
	<- dash_to_ball; 
	!rush_to_ball.
// if defender can not see the ball then find ball
+!rush_to_ball
	: not ball_visible
	<-	!find_ball.
//if defender is runnig towards self goal to the ball then stop once in dzone!
+!rush_to_ball
	: ball_visible & self_goal_visible & in_g_zone
	<- monitor_ball;
	!find_ball.

+!rush_to_ball
	: ball_visible & ball_near 
	<- kick;
	- ball_near;
	!find_ball.


//**goal = find_goal_post**//		
// if defender  can see the ball, in kick range and facing ball and goal post found then kick the ball
+!find_goal_post
	: ball_near & goal_visible 
	<-	kick;
		- ball_near;
		!find_ball.

+!find_goal_post
	: ball_near & not goal_visible 
	<-	turn;
		!find_goal_post.
