package com.breaktrycatch.needmorehumans.view;

import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;
import org.jbox2d.dynamics.joints.PrismaticJoint;
import org.jbox2d.dynamics.joints.PrismaticJointDef;
import org.jbox2d.p5.Physics;
import org.jbox2d.p5.PhysicsUtils;

import processing.core.PApplet;

import com.breaktrycatch.lib.view.AbstractView;

public class PhysicsView extends AbstractView {

	Physics physWorld;
	boolean doSquare = false;
	
	public PhysicsView() {
		
	}
	
	@Override
	public void initialize(PApplet app) {
		super.initialize(app);
		
		initPhysics();
	}
	
	@Override
	public void draw() {
		PApplet app = getApp();
		app.background(0xFF0000);
		
		if(app.mousePressed)
		{
			doSquare = !doSquare;
			Body shape;
			
			if(doSquare)
			{
				//float[] coords = {mouseX, mouseY, mouseX - 15.0f, mouseY + 15.0f, mouseX + 15.0f, mouseY + 15.0f};
				
				shape = physWorld.createRect(app.mouseX - 10, app.mouseY - 10, app.mouseX + 10, app.mouseY + 10);
				shape.setAngle(45.0f);
			}
			else
			{
				shape = physWorld.createCircle(app.mouseX, app.mouseY, 10.0f);
			}
			
			//createHuman();
			
		}
	}
	
	private void initPhysics() {
		PApplet app = getApp();
		
		physWorld = new Physics(app, app.width, app.height);
		physWorld.setDensity(1.0f);
		
		createLift(app);
	}
	
	private void createLift(PApplet app)
	{
		Body mount, platform;
		
		float centerX, centerY;
		centerX = app.width/2;
		centerY = app.height/2;
		
		physWorld.setDensity(0.0f);
		mount = physWorld.createRect(centerX-5, centerY-5, centerX+5, centerY+5);
		
		physWorld.setDensity(1.0f);
		platform = physWorld.createRect(centerX-25, centerY-25, centerX+25, centerY-20);
		
		PrismaticJointDef jointDef = new PrismaticJointDef();
		//physWorld.screenToWorld(new Vec2(100.0f,100.0f))
		jointDef.initialize(platform, mount, mount.getPosition().clone(), new Vec2(0.0f,-1.0f));
		jointDef.motorSpeed = 10.0f;
		jointDef.maxMotorForce = 100.0f;
		jointDef.enableMotor = true;
		jointDef.lowerTranslation = 0.0f;
		jointDef.upperTranslation = 10.0f;
		jointDef.enableLimit = true;
		
		PrismaticJoint joint = (PrismaticJoint)physWorld.getWorld().createJoint(jointDef);
	}
	
	private void createHuman()
	{
		Body shape1, shape2, shape3, shape4, shape5, shape6;

//		DistanceJoint joint;
//		
//		//Arms
		physWorld.setDensity(0.0f);
		shape1 = physWorld.createRect(10, 10, 20, 20);
		physWorld.setDensity(1.0f);
		shape3 = physWorld.createRect(110, 10, 120, 20);
		


		
		
//		joint.setLimits(lower, upper)
		//Torso
//		shape2 = physWorld.createRect(60, 60, 70, 70);
//		shape4 = physWorld.createRect(60, 120, 70, 130);
//		
//		//Legs
//		shape5 = physWorld.createRect(10, 170, 20, 180);
//		shape6 = physWorld.createRect(110, 170, 120, 180);

//		joint = JointUtils.createDistanceJoint(shape1, shape2);
//		joint.setFrequency(60.0f);
//		joint = JointUtils.createDistanceJoint(shape2, shape3);
//		joint.setFrequency(60.0f);
//		joint = JointUtils.createDistanceJoint(shape2, shape4);
//		joint.setFrequency(60.0f);
//		joint = JointUtils.createDistanceJoint(shape4, shape5);
//		joint.setFrequency(60.0f);
//		joint = JointUtils.createDistanceJoint(shape4, shape6);
//		joint.setFrequency(60.0f);
	}
	
}
