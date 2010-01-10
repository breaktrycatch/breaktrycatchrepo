package org.box2DTest.core;

import org.jbox2d.dynamics.Body;
import org.jbox2d.p5.Physics;

import processing.core.PApplet;

public class FrameworkCore extends PApplet {

	Physics physWorld;
	boolean doPoly = false;
//	Body 
	
	public FrameworkCore() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void setup() {
		size(640, 480, P2D);
		frameRate(30);
		
		initPhysics();
	}
	
	private void initPhysics() {
		physWorld = new Physics(this, width, height);
		physWorld.setDensity(1.0f);
	}

	@Override
	public void draw() {
		background(0xFF0000);
		
		if(mousePressed)
		{
			doPoly = !doPoly;
			Body shape;
			
			if(doPoly)
			{
				//float[] coords = {mouseX, mouseY, mouseX - 15.0f, mouseY + 15.0f, mouseX + 15.0f, mouseY + 15.0f};
				
				shape = physWorld.createRect(mouseX - 10, mouseY - 10, mouseX + 10, mouseY + 10);
				shape.setAngle(45.0f);
				
			}
			else
			{
				shape = physWorld.createCircle(mouseX, mouseY, 10.0f);
			}
			
			
			
		}
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		PApplet.main(new String[] { "--present", "org.box2DTest.core.FrameworkCore" });
	}

}
