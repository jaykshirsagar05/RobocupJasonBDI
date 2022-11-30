/* Author: Jay Kshirsagar */

/* Initial goal */
/* First my agent will find defending zone and will stay in this area */
!gotoDzone.

//if ball is not visible and agent in goalie zone then go to dZone
+!gotoDzone
	: not ballVisible & inGZone 
	<- dash_to_enemy_goal;
	- inGZone;
	!gotoDzone.

//if ball is not visible and agent in attacker zone then dash towards own goal to be in attacker zone.
+!gotoDzone
	: not ballVisible & inAZone
	<- dash_to_own_goal;
	!gotoDzone.

//if agent is in defending zone and ball is not visible then next goal searchBall by performing turn
+!gotoDzone
	: not ballVisible & inDZone
	<- turn;
	- inDZone;
	!searchBall.

//if ball is in defending zone and it is visible then just monitor it and wait for the chance to kick it
+!gotoDzone
	: ballVisible & inDZone
	<- monitorBall;
	- ballVisible;
	- inDZone;
	!kickBall.

//Ball is away and agent is in golie zone than dash to ball.
+!gotoDzone
	: inGZone & ballFar
	<- dash_to_ball;
	- inGZone;
	- ballFar;
	- ballVisible;
	!gotoDzone.

//If agent is in golie zone and ball is near then defend it by dashing towards it.
+!gotoDzone
	: inGZone & ballNear
	<- dash_to_ball;
	- inGZone;
	- ballVisible;
	!kickBall.

//If agent is not in golie area but the ball is near than defend it
+!gotoDzone
	: not inGZone & ballNear
	<- dash_to_ball;
	- inGZone;
	- ballFar;
	- ballVisible;
	!kickBall.

//If agent is not in golie area and ball is away then stay in defender area.
+!gotoDzone
	: not inGZone & ballFar
	<- dash_to_own_goal;
	-ballFar;
	-ballVisible;
	!gotoDzone.

/* Next goal:ballSearch */
/* Once agent is in defending zone, search for ball to defend it. */

//if ball is not visible then perform turn.
+!ballSearch
	: not ballVisible
	<- turn;
	!ballSearch.

//If ball is fall and agent not in defending zone then just monitor ball and switch to gotoDzone goal.
+!ballSearch
	: ballFar & not inDZone
	<- monitorBall;
	-ballFar;
	-balVisible;
	!gotoDZone.

//If ball is far and agent is in defending zone and self goal is not visible then just monitor ball.
+!ballSearch
	: ballFar & inDZone & not selfGoalVisible
	<- monitorBall;
	-selfGoalVisible;
	-ballFar;
	-ballVisible;
	!ballSearch.

//If ball is far and agent is in defending zone and self goal is visible then dash towards ball o defednd it.
+!ballSearch
	: ballFar & inDZone & selfGoalVisible
	<- dash_to_ball
	-selfGoalVisible
	-ballFar
	-ballVisible
	!kickBall.

//If ball is near then dash towards it to kick.
+!ballSearch
	: ballNear
	<- dash_to_ball;
	-ballVisible;
	-ballNear;
	!kickBall.


/* Next goal: kickBall */
/*If agent is in defending zone and aligned with ball then it should intent to kickBall*/

//If ball is not visible then turn to search ball.
+!kickBall
	: not ballVisible
	<- turn;
	!ballSearch.

//If ball is far and agent is in defending zone and self goal is visible then defend it by dashing towards it.
+!kickBall
	: ballFar & inDZone & selfGoalVisible
	<- dash_to_ball;
	-selfGoalVisible;
	-ballVisible;
	-inDZone;
	!kickBall.

//If ball is far and agent in defending zone and self goal not visible then just monitor the ball.
+!kickBall
	: ballFar & inDZone & not selfGoalVisible
	<- monitorBall;
	-ballFar;
	-inDZone;
	-ballVisible;
	!kickBall.

//If ball is far and agent in golie zone than dash towards enemy goal by switching to gotoDzone goal.
+!kickBall
	: ballFar & inGZone
	<- dash_to_enemy_goal;
	-ballVisible;
	-ballFar;
	-inGZone;
	!gotoDzone.

//If ball is far and agent is in attacker zone then dash towards own goal and switch to gotoDzone goal.
+!kickBall
	: ballFar & inAZone
	<- dash_to_own_goal;
	-ballVisible;
	-ballFar;
	-inAZone;
	!gotoDzone.

//If ball is near then dash towards it to kick it.
+!kickBall
	: ballNear
	<- dash_to_ball;
	-ballVisible;
	-ballNear;
	!kickBall.

//If ball is touched then kick it.
+!kickBall
	: ballTouched
	<- kick;
	-ballVisible;
	-ballNear;
	-ballTouched;
	!kickBall.


	




