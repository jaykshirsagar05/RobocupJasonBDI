/*First existing goal in belief space*/

!ballSearch.

/*>>>>>>PLAN TO ACHIEVE BALL SEARCH GOAL<<<<<<<*/

+!ballSearch
	:not in_d_zone
	<- !gotoDzone.

+!ballSearch
	:not ball_visible
	<- turn;
	!ballSearch.
	
+!ballSearch
	: in_d_zone & ball_visible & not ball_in_range
	<- turn_to_ball;
	!ballSearch.

+!ballSearch
	: in_d_zone & ball_visible & ball_in_range
	<- turn_to_ball;
	!defend.


/*>>>>>>PLAN TO ACHIEVE DEFEND GOAL<<<<<<<*/

+!defend
	:not ball_visible
	<- turn;
	!ballSearch.
	
+!defend
	: ball_visible & not facing_ball
	<- turn_to_ball;
	!defend.
	
+!defend
	: ball_visible & facing_ball & not ball_near
	<- dash_to_ball;
	!defend.

+!defend
	:ball_visible & ball_near & facing_ball
	<- !find_enemy_goal.

+!find_enemy_goal
	: ball_near & goal_visible 
	<-	kick;
		- ball_near;
		!ballSearch.

+!find_enemy_goal
	: ball_near & not goal_visible 
	<-	turn;
		!find_enemy_goal.

+!find_enemy_goal
	: not ball_visible
	<-	turn;
		!ballSearch.

/*>>>>>>>>>>PLAN TO ACHIEVE GOTODZONE GOAL <<<<<<<<<*/

+!gotoDzone
	: in_g_zone
	<- dash_to_enemy_goal;
	!gotoDzone.
	
+!gotoDzone
	: in_a_zone
	<- dash_to_own_goal;
	!gotoDzone.

+!gotoDzone
	: not ball_visible & not in_d_zone
	<- dash_to_own_goal;
	!gotoDzone.
	
+!ballSearch
	: in_d_zone
	<- !ballSearch.


