package com.breaktrycatch.needmorehumans.control.physics;

import java.util.ArrayList;

import org.jbox2d.dynamics.Body;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;
import com.breaktrycatch.needmorehumans.model.PolyVO;
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
		_physWorld = new PhysicsWorldWrapper((float)width, (float)height);
		_physWorld.enableDebugDraw(getApp());

		PhysicsShapeDefVO vo = new PhysicsShapeDefVO();
		vo.density = 0.0f;
		_physWorld.createRect(0, height - 10, width, height, vo);
		_physWorld.createRect(0, 0, 50, 50, new PhysicsShapeDefVO());
		
		addDebugPolyHuman();
//		_physWorld.createRect(50, 150, 150, 250, new PhysicsShapeDefVO());
	}
	
	private void addDebugPolyHuman()
	{
		PImage img = getApp().loadImage("../data/tracing/RealPerson_1.png");
		img.loadPixels();
		
		ImageFrame sprite = new ImageFrame(getApp(), img);
		//sprite.setRotateAroundCenter(true);
		sprite.x = 200;
		sprite.y = 200;
		
		addHuman(sprite);
	}
	
	public void addHuman(ImageFrame sprite)
	{
		sprite.setRotateAroundCenter(true);
		
		ImageAnalysis imageAnalysis = new ImageAnalysis(getApp());
		ArrayList<PolyVO> polyData = imageAnalysis.analyzeImage(sprite.getDisplay());
		
		Body human = _physWorld.createPolyHuman(polyData, new PhysicsShapeDefVO(), sprite.x, sprite.y, sprite.rotationRad);
		human.setUserData(sprite);
		add(sprite);
	}
	
	
	@Override
	public void draw() {
		// TODO Auto-generated method stub
		super.draw();
		
		getApp().fill(0xff000000);
		getApp().rect(0, 0, width, height);
		
		_physWorld.step();
	}

	@Override
	public void dispose() {
		
		_physWorld.destroy();
		
		super.dispose();
	}
}
