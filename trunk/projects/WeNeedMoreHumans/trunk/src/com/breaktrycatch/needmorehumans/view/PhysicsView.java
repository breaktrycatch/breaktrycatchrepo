package com.breaktrycatch.needmorehumans.view;

import org.jbox2d.dynamics.Body;
import org.jbox2d.p5.Physics;

import processing.core.PApplet;

import com.breaktrycatch.lib.view.AbstractView;

public class PhysicsView extends AbstractView {

	Physics physWorld;
	boolean doPoly = false;
	
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
			doPoly = !doPoly;
			Body shape;
			
			if(doPoly)
			{
				//float[] coords = {mouseX, mouseY, mouseX - 15.0f, mouseY + 15.0f, mouseX + 15.0f, mouseY + 15.0f};
				
				shape = physWorld.createRect(app.mouseX - 10, app.mouseY - 10, app.mouseX + 10, app.mouseY + 10);
				shape.setAngle(45.0f);
				
			}
			else
			{
				shape = physWorld.createCircle(app.mouseX, app.mouseY, 10.0f);
			}
			
			
			
		}
	}
	
	private void initPhysics() {
		PApplet app = getApp();
		
		physWorld = new Physics(app, app.width, app.height);
		physWorld.setDensity(1.0f);
	}
}
