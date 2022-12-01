//File: JasonAgent.java
// Author: Jay Kshirsagar

/*
 * We are planning to use just jason's BDI engine as our interpreter.
 * 
 * Hence, the class must extend AgArch to be used by the Jason engine.
 */
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import jason.architecture.AgArch;
import jason.asSemantics.ActionExec;
import jason.asSemantics.Agent;
import jason.asSemantics.Circumstance;
import jason.asSemantics.TransitionSystem;
import jason.asSyntax.Literal;
import jason.runtime.Settings;

public class JasonAgent extends AgArch {
	
	public List<Belief> currentPrecepts;
	public Intentions currentIntent;

    private static Logger logger = Logger.getLogger(JasonAgent.class.getName());

//    public static void main(String[] a) {
//        new RunLocalMAS().setupLogger();
//        JasonAgent ag = new JasonAgent();
//        ag.run();
//    }

    public JasonAgent(String asl_file) {
        // set up the Jason agent
        try {
            Agent ag = new Agent();
            new TransitionSystem(ag, new Circumstance(), new Settings(), this);
            ag.initAg();
            ag.load(asl_file);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Init error", e);
        }
    }
    
    public Intentions getCurrentIntent(List<Belief> precepts) {
    	currentPrecepts = precepts;
    	run();
		return currentIntent;
    }

    public void run() {
        try {
            while (isRunning()) {
                // calls the Jason engine to perform one reasoning cycle
                logger.fine("Reasoning....");
                getTS().reasoningCycle();
                if (getTS().canSleep())
                    sleep();
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Run error", e);
        }
    }

    public String getAgName() {
        return "bob";
    }

    // this method just add some perception for the agent
    @Override
    public List<Literal> perceive() {
        List<Literal> l = new ArrayList<Literal>();
        l.add(Literal.parseLiteral("x(10)"));
        return l;
    }

    // this method get the agent actions
    @Override
    public void act(ActionExec action) {
        getTS().getLogger().info("Agent " + getAgName() + " is doing: " + action.getActionTerm());
        // set that the execution was ok
        action.setResult(true);
        actionExecuted(action);
    }

    @Override
    public boolean canSleep() {
        return true;
    }

    @Override
    public boolean isRunning() {
        return true;
    }

    // a very simple implementation of sleep
    public void sleep() {
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {}
    }

    // Not used methods
    // This simple agent does not need messages/control/...
    @Override
    public void sendMsg(jason.asSemantics.Message m) throws Exception {
    }

    @Override
    public void broadcast(jason.asSemantics.Message m) throws Exception {
    }

    @Override
    public void checkMail() {
    }

}
