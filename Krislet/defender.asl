/*First existing goal in belief space*/
!go_to_position.

/*>>>>>>PLAN TO ACHIEVE GOTO POSITION GOAL<<<<<<<*/

//If ball is near than kick.
+!go_to_position
	:ball_near
	<- defend_kick;
	!go_to_position.
	
//If it defender is in attacking zone then goto defending zone.
+!go_to_position
	:in_a_zone
	<- !goto_d_zone.

//If it is in goalie zone then goto defending zone.
+!go_to_position
	:in_g_zone
	<- !goto_d_zone.

//If agent is in defending zone then transition to find ball plan.
+!go_to_position
	: in_d_zone
	<- !find_ball.

//If agent can't find it's zone then turn and wait for next info.
+!go_to_position
	: not in_d_zone & not in_a_zone & not in_g_zone
	<- turn;
	!go_to_position.

/*>>>>>>PLAN TO ACHIEVE BALL SEARCH GOAL<<<<<<<*/

//If ball is not visible then turn.
+!find_ball
	:not ball_visible
	<- turn;
	!find_ball.
	
//If ball is visible and it is not in range then turn to ball.
+!find_ball
	: ball_visible & not ball_in_range
	<- turn_to_ball;
	!find_ball.

//If ball is visible and it's in range then transition to defending block.
+!find_ball
	: ball_visible & ball_in_range
	<- !defend.

/*>>>>>>PLAN TO ACHIEVE DEFEND GOAL<<<<<<<*/

//Again if ball is not visible then turn and transition to find_ball.
+!defend
	:not ball_visible
	<- turn;
	!find_ball.
	
//if ball is visible and not facing then turn towards ball.
+!defend
	: ball_visible & not facing_ball
	<- turn_to_ball;
	!defend.
	
//if ball is visible and aligned and agent is not closed to it then dash towards it.
+!defend
	: ball_visible & facing_ball & not ball_near
	<- dash_to_ball;
	!defend.

//If ball is visible and near then perform kick action.
+!defend
	:ball_visible & ball_near
	<- defend_kick;
	!go_to_position.

/*>>>>>>>>>>PLAN TO ACHIEVE goto_d_zone GOAL <<<<<<<<<*/

//If agent is in defending zone than transition to find_ball
+!goto_d_zone
	: in_d_zone
	<- !find_ball.

//If agent is in goalie zone than dash_towards enemy goal.
+!goto_d_zone
	: in_g_zone
	<- dash_to_enemy_goal;
	!goto_d_zone.
	
//If agent is in attacking zone than dash towards own goal.
+!goto_d_zone
	: in_a_zone
	<- dash_to_own_goal;
	!goto_d_zone.

	

