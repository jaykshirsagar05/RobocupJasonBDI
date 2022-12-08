//
//	File:			Brain.java
//	Author:		Krzysztof Langner
//	Date:			1997/04/28
//
//    Modified by:	Paul Marlow

//    Modified by:      Edgar Acosta
//    Date:             March 4, 2008

import java.lang.Math;
import java.util.regex.*;
import java.util.*;

class Brain extends Thread implements SensorInput
{
    //---------------------------------------------------------------------------
    // This constructor:
    // - stores connection to krislet
    // - starts thread for this object
    public Brain(SendCommand krislet, 
		 String team, 
		 char side, 
		 int number, 
		 String playMode,
		 String playerType
		)
    {
	m_timeOver = false;
	m_krislet = krislet;
	m_memory = new Memory();
	//m_team = team;
	m_side = side;
	// m_number = number;
	m_playMode = playMode;
	m_playerType = playerType;
	start();
    }


    //---------------------------------------------------------------------------
    // This is main brain function used to make decision
    // In each cycle we decide which command to issue based on
    // current situation. the rules are:
    //
    //	1. If you don't know where is ball then turn right and wait for new info
    //
    //	2. If ball is too far to kick it then
    //		2.1. If we are directed towards the ball then go to the ball
    //		2.2. else turn to the ball
    //
    //	3. If we dont know where is opponent goal then turn wait 
    //				and wait for new info
    //
    //	4. Kick ball
    //
    //	To ensure that we don't send commands to often after each cycle
    //	we waits one simulator steps. (This of course should be done better)

    // ***************  Improvements ******************
    // Allways know where the goal is.
    // Move to a place on my side on a kick_off
    // ************************************************

    public void run()
    {
	ObjectInfo object;
	ObjectInfo enemyGoal;
	ObjectInfo selfGoal;
	ObjectInfo GoalieFlag_Center, GoalieFlag_Top, GoalieFlag_Bottom;
	String agentAsl = "";

	

	// Putting the player in the field based on it's type and decide asl file
	if(Pattern.matches("^before_kick_off.*",m_playMode)) {
		switch(m_playerType) {
			case Golie: {
				m_krislet.move( -50 , 0 );
				agentAsl = "goalie.asl";
				break;
			}
			case Attacker1: {
				m_krislet.move(0.0 , 0.0 );
				agentAsl = "attacker.asl";
				break;
			}
			case Attacker2: {
				m_krislet.move((-10.0),12.0 );
				agentAsl = "attacker.asl";
				break;
			}
			case Defender1: {
				m_krislet.move( -34.25 , -20.16 );
				agentAsl = "defender.asl";
				break;
			}
			case Defender2: {
				m_krislet.move( -34.25 , 20.16 );
				agentAsl = "defender.asl";
				break;
			}
		}
	}
	List<Belief> Goalie_perceptions= new ArrayList<>();
	while( !m_timeOver )
	    {
		List<Belief> perceptions = new ArrayList<>();
		Intentions intent;
		object = m_memory.getObject("ball");
		//help to keep in goalie zone
		GoalieFlag_Center = m_memory.getObject("flag c");
		GoalieFlag_Top = m_memory.getObject("flag c | t");
		GoalieFlag_Bottom = m_memory.getObject("flag c | b");

		if (object != null) {
			perceptions.add(Belief.BALL_VISIBLE);
			if(object.m_direction == 0) {
				perceptions.add(Belief.FACING_BALL);
			}
			if(object.m_distance > 1.0) {
				perceptions.add(Belief.BALL_FAR);
				if (object.m_distance < 23.0){
					perceptions.add(Belief.BALL_IN_DEFENCE_RANGE);
				}
				
			} else {
				perceptions.add(Belief.BALL_NEAR);
				perceptions.add(Belief.BALL_TOUCHED);
			}

		}

		if( m_side == 'l' ) {
			enemyGoal = m_memory.getObject("goal r");
			selfGoal = m_memory.getObject("goal l");
		} else {
			enemyGoal = m_memory.getObject("goal l");
			selfGoal = m_memory.getObject("goal r");
		}
				
		if(selfGoal != null) {
			perceptions.add(Belief.SELF_GOAL_VISIBLE);
			
			if(selfGoal.m_direction == 0) {
				perceptions.add(Belief.FACING_SELF_GOAL);
			}

			if (selfGoal.m_distance >3.0){
				perceptions.add(Belief.SELF_GOAL_FAR);
			}
			if(selfGoal.m_distance <3.0) {
				perceptions.add(Belief.AT_OWN_NET);
			}

			if(selfGoal.m_distance < 5.0) {
				perceptions.add(Belief.IN_G_ZONE);
			}

			if(selfGoal.m_distance < 30.0 && selfGoal.m_distance >= 4.0) {
				perceptions.add(Belief.IN_D_ZONE);
			}

			if(selfGoal.m_distance >= 30.0) {
				perceptions.add(Belief.IN_A_ZONE);
			}
		}
		
		if(enemyGoal != null) {
			perceptions.add(Belief.GOAL_VISIBLE);
			Goalie_perceptions.add(Belief.GOAL_VISIBLE);

			if(enemyGoal.m_direction == 0) {
				perceptions.add(Belief.FACING_GOAL);
			}

			if(enemyGoal.m_distance > 80.0 && enemyGoal.m_distance < 90.0) {
				perceptions.add(Belief.IN_D_ZONE);
			}

			if(enemyGoal.m_distance <= 80.0 ) {
				perceptions.add(Belief.IN_A_ZONE);
			}
		}

		// if goalie is outside of serving range, add perception 
		if (GoalieFlag_Center != null){
			if (GoalieFlag_Center.m_distance < 32){
				perceptions.add(Belief.NOT_IN_GOALIE_RANGE);
			}
		}else if (GoalieFlag_Top != null){
			if (GoalieFlag_Top.m_distance < 43){
				perceptions.add(Belief.NOT_IN_GOALIE_RANGE);
			}
		}else if (GoalieFlag_Bottom != null){
			if (GoalieFlag_Bottom.m_distance < 43){
				perceptions.add(Belief.NOT_IN_GOALIE_RANGE);
			}
		}

		System.out.println(perceptions);

		JsonAgentYash agent = new JsonAgentYash(agentAsl);
		// System.out.println(" is goalie");
		// if (isGoalie){
		// 	intent = agent.getIntention(Goalie_perceptions);

		// }else{
			
		// }
		intent = agent.getIntention(perceptions);

		System.out.println(intent + " is working correctly.");
	

		// Doing action according to intention
		
		switch(intent) {
			case TURN: {
				m_krislet.turn(40);
				m_memory.waitForNewInfo();
				break;
			}
			case TURN_TO_BALL: {
				if (object != null) {
					m_krislet.turn(object.m_direction);
				}
				break;
			}
			case KICK: {
				if (enemyGoal != null) {
					m_krislet.kick(200, enemyGoal.m_direction);
				}
				break;
			}
			case FIND_GOAL: {
				m_krislet.turn(40);
				m_memory.waitForNewInfo();
				break;
			}
			case MONITOR_BALL: {
				m_memory.waitForNewInfo();
				break;
			}
			case DASH_TO_BALL: {
				if (object != null) {
					m_krislet.dash(20*object.m_distance);
				}
				break;
			}
			case DASH_TO_OWN_GOAL: {
				if (selfGoal != null) {
					m_krislet.dash(30*selfGoal.m_distance);
				}
				break;
			}
			case DASH_TO_ENEMY_GOAL: {
				if (enemyGoal != null) {
					m_krislet.dash(10*enemyGoal.m_distance);
				}
				break;
			} 
			case FIND_BALL:{
				m_krislet.turn(40);
				m_memory.waitForNewInfo();
			}	
				break;
			case KICK_TO_DEFENCE:{
				if (selfGoal == null && enemyGoal == null){
					m_krislet.kick(80, 45);
					m_krislet.turn(45);
				}else{
					m_krislet.kick(100, 180);
				}
			}
			break;
			case TURN_TO_SELF_GOAL:{
				if (selfGoal != null ){
					m_krislet.turn(selfGoal.m_direction);
				}
			}
			break;
		}

		// clear goalie perception buffer, expect the flag 
		Iterator<Belief> itr = Goalie_perceptions.iterator();
        while (itr.hasNext()) {
            Belief x = itr.next();
            if (x != Belief.CHASING_BALL)
				itr.remove();
        }


		// if( object == null )
		//     {
		// 	// If you don't know where is ball then find it
		// 	m_krislet.turn(40);
		// 	m_memory.waitForNewInfo();
		//     }
		// else if( object.m_distance > 1.0 )
		//     {
		// 	// If ball is too far then
		// 	// turn to ball or 
		// 	// if we have correct direction then go to ball
		// 	if( object.m_direction != 0 )
		// 	    m_krislet.turn(object.m_direction);
		// 	else
		// 	    m_krislet.dash(10*object.m_distance);
		//     }
		// else 
		//     {
		// 	// We know where is ball and we can kick it
		// 	// so look for goal
		// 	if( m_side == 'l' )
		// 	    object = m_memory.getObject("goal r");
		// 	else
		// 	    object = m_memory.getObject("goal l");

		// 	if( object == null )
		// 	    {
		// 		m_krislet.turn(40);
		// 		m_memory.waitForNewInfo();
		// 	    }
		// 	else
		// 	    m_krislet.kick(100, object.m_direction);
		//     }

		// sleep one step to ensure that we will not send
		// two commands in one cycle.
		try{
		    Thread.sleep(2*SoccerParams.simulator_step);
		}catch(Exception e){}
	    }
	m_krislet.bye();
    }


    //===========================================================================
    // Here are suporting functions for implement logic


    //===========================================================================
    // Implementation of SensorInput Interface

    //---------------------------------------------------------------------------
    // This function sends see information
    public void see(VisualInfo info)
    {
	m_memory.store(info);
    }


    //---------------------------------------------------------------------------
    // This function receives hear information from player
    public void hear(int time, int direction, String message)
    {
    }

    //---------------------------------------------------------------------------
    // This function receives hear information from referee
    public void hear(int time, String message)
    {						 
	if(message.compareTo("time_over") == 0)
	    m_timeOver = true;

    }


    //===========================================================================
    // Private members
    private SendCommand	                m_krislet;			// robot which is controled by this brain
    private Memory			m_memory;				// place where all information is stored
    private char			m_side;
    volatile private boolean		m_timeOver;
    private String                      m_playMode;
	private String m_playerType;
	private final String Golie = "golie";
	private final String Attacker1 = "attacker1";
	private final String Attacker2 = "attacker2";
	private final String Defender1 = "defender1";
    private final String Defender2 = "defender2";
}
