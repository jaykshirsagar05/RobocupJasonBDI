/*First existing goal in belief space*/
!go_to_position.

/*>>>>>>PLAN TO ACHIEVE GOTO POSITION GOAL<<<<<<<*/
+!go_to_position
	:ball_near
	<- defend_kick;
	!go_to_position.
	
+!go_to_position
	:in_a_zone
	<- !goto_d_zone.

+!go_to_position
	:in_g_zone
	<- !goto_d_zone.

+!go_to_position
	: in_d_zone
	<- !find_ball.

+!go_to_position
	: not in_d_zone & not in_a_zone & not in_g_zone
	<- turn;
	!go_to_position.

/*>>>>>>PLAN TO ACHIEVE BALL SEARCH GOAL<<<<<<<*/

+!find_ball
	:not ball_visible
	<- turn;
	!find_ball.
	
+!find_ball
	: ball_visible & not ball_in_range
	<- turn_to_ball;
	!find_ball.

+!find_ball
	: ball_visible & ball_in_range
	<- !defend.

/*>>>>>>PLAN TO ACHIEVE DEFEND GOAL<<<<<<<*/

+!defend
	:not ball_visible
	<- turn;
	!find_ball.
	
+!defend
	: ball_visible & not facing_ball
	<- turn_to_ball;
	!defend.
	
+!defend
	: ball_visible & facing_ball & not ball_near
	<- dash_to_ball;
	!defend.

+!defend
	:ball_visible & ball_near
	<- defend_kick;
	!go_to_position.

/*>>>>>>>>>>PLAN TO ACHIEVE goto_d_zone GOAL <<<<<<<<<*/

+!goto_d_zone
	: in_d_zone
	<- !find_ball.

+!goto_d_zone
	: in_g_zone
	<- dash_to_enemy_goal;
	!goto_d_zone.
	
+!goto_d_zone
	: in_a_zone
	<- dash_to_own_goal;
	!goto_d_zone.

	

