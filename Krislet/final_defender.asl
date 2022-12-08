/*First existing goal in belief space*/

!go_to_position.

/*>>>>>>PLAN TO ACHIEVE BALL SEARCH GOAL<<<<<<<*/


+!go_to_position
	:in_a_zone
	<- !gotoDzone.

+!go_to_position
	:in_g_zone
	<- !gotoDzone.

+!go_to_position
	: in_d_zone
	<- !ballSearch.

+!go_to_position
	: not in_d_zone & not in_a_zone & not in_g_zone
	<- turn;
	!go_to_position.


+!ballSearch
	:not ball_visible
	<- turn;
	!ballSearch.
	
+!ballSearch
	: ball_visible & not ball_in_range
	<- turn_to_ball;
	!ballSearch.

+!ballSearch
	: ball_visible & ball_in_range
	<- !defend.


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
	:ball_visible & ball_near
	<- defend_kick;
	!go_to_position.

/*>>>>>>>>>>PLAN TO ACHIEVE GOTODZONE GOAL <<<<<<<<<*/

+!gotoDzone
	: in_d_zone
	<- !ballSearch.

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
	


