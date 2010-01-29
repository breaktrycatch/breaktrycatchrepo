package com.breaktrycatch.needmorehumans.control.physics;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;

public class PhysicsControl extends DisplayObject {

	private PhysicsWorldWrapper _physWorld;
	
	public PhysicsControl(PApplet app) {
		super(app);
		// TODO Auto-generated constructor stub
	}
	
	/**
	 * Call after setting width/height
	 */
	public void init()
	{
		_physWorld = new PhysicsWorldWrapper((float)width, (float)height);
		//_imageAnalysis = new ImageAnalysis(getApp(), _physWorld);
//		_physWorld.enableDebugDraw(getApp());
		//setSprite(0);
		//createPolyHuman(new Vec2( width/2, height/2));
		_physWorld.createRect(25, 25, 50, 50, new PhysicsShapeDefVO());
	}
	
	@Override
	public void draw() {
		// TODO Auto-generated method stub
		super.draw();
		
		_physWorld.step();
	}
	
	public void setSprite(PImage img)
	{
//		_currentSpriteIndex = -1;
//		_currentSprite = img;
//		
//		_polyHumanDef = _imageAnalysis.analyzeImage(_currentSprite);
	}

	@Override
	public void dispose() {
		
		_physWorld.destroy();
		
		super.dispose();
	}
}
