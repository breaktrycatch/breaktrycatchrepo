package com.breaktrycatch.needmorehumans.control.physics;

import org.jbox2d.common.Vec2;
import org.jbox2d.p5.Physics;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;

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
//		_physWorld = new Physics(getApp(), getApp().width, getApp().height);
//		_physWorld = new Physics(getApp(), width, height, 0.0f, -10.0f, width * 2.2f, height * 1.2f, width, height, 100.0f);
//		_physWorld.setDensity(1.0f);
//		
//		_imageAnalysis = new ImageAnalysis(getApp(), _physWorld);
//		
//		setSprite(0);
//		createPolyHuman(new Vec2( width/2, height/2));
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
		
		
		
		super.dispose();
	}
}
