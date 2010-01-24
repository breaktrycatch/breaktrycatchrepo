package com.breaktrycatch.needmorehumans.view;

import java.awt.Point;
import java.util.ArrayList;

import org.jbox2d.collision.PolygonDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;
import org.jbox2d.dynamics.BodyDef;
import org.jbox2d.dynamics.joints.PrismaticJoint;
import org.jbox2d.dynamics.joints.PrismaticJointDef;
import org.jbox2d.p5.Physics;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class PhysicsView extends AbstractView {

	private static final char CHANGE_SPRITE_KEY = '9';
	
	private Physics _physWorld;
	private boolean doSquare = false;
	private ImageAnalysis _imageAnalysis;
	private ArrayList<PolygonDef> _polyHumanDef;
	private String[] _spriteLookup  = new String[]
	                                             {
													"../data/tracing/TestPerson_png.png", 
													"../data/tracing/Cube.png", 
													"../data/tracing/RealPerson_1.png",
													"../data/tracing/RealPerson_3.png",
													"../data/tracing/RealPerson_4.png",
													"../data/tracing/RealPerson_5.png"
	                                             };
	private int _currentSpriteIndex = -1;
	private PImage _currentSprite;
	private boolean _changeSpriteKeyDown = false;
	private boolean _mouseDown = false;
	
	
	public PhysicsView() {
		
	}
	
	@Override
	public void initialize(PApplet app) {
		super.initialize(app);
		
		initPhysics();
	}
	
	@Override
	public void draw() {
		getApp().background(0xFF0000);
		
		showPolyHumanTemplate();
		
		if(getApp().mousePressed)
		{
			if(!_mouseDown)
			{
				_mouseDown = true;
				createPolyHuman(new Vec2(getApp().mouseX, getApp().mouseY));
				//_physWorld.createRect(getApp().mouseX, getApp().mouseY, getApp().mouseX + 20, getApp().mouseY + 20);
				//createHuman();
			}
			
			
//			doSquare = !doSquare;
//			Body shape;
//			
//			if(doSquare)
//			{
//				//float[] coords = {mouseX, mouseY, mouseX - 15.0f, mouseY + 15.0f, mouseX + 15.0f, mouseY + 15.0f};
//				
//				shape = physWorld.createRect(app.mouseX - 10, app.mouseY - 10, app.mouseX + 10, app.mouseY + 10);
//				shape.setAngle(45.0f);
//			}
//			else
//			{
//				shape = physWorld.createCircle(app.mouseX, app.mouseY, 10.0f);
//			}
			
		}
		else
		{
			_mouseDown = false;
		}
		
		super.draw();
	}
	
	private void showPolyHumanTemplate()
	{
		///UGH wtf is wrong with this right now hit a different key..need to figure out mouseUpEvent
		if(getApp().key == CHANGE_SPRITE_KEY)
		{
			if(!_changeSpriteKeyDown)
			{
				
				setSprite((_currentSpriteIndex + 1)%_spriteLookup.length);				
			}
			
			_changeSpriteKeyDown = true;
			//getApp().key = 'q';
		}
		else
		{
			_changeSpriteKeyDown = false;
		}
		
		Point centerSpawn = new Point(getApp().mouseX, getApp().mouseY);
		
		getApp().image(_currentSprite, centerSpawn.x - (_currentSprite.width/2), centerSpawn.y - (_currentSprite.height/2));
	}
	
	private void createPolyHuman(Vec2 spawnPoint)
	{
		Body bd = _physWorld.getWorld().createBody(new BodyDef());
		
		for (int i = 0; i < _polyHumanDef.size(); i++) {
			bd.createShape(_polyHumanDef.get(i));
		}
		
		PolygonDef polyDef;
		polyDef = new PolygonDef();
		polyDef.friction = 0.1f;
		polyDef.restitution = 0.1f;
		polyDef.density = 1.0f;
		
		// TEST POLY
//		polyDef.addVertex(new Vec2(0.0f, 0.0f));
//		polyDef.addVertex(new Vec2(4.0f, 0.0f));
//		polyDef.addVertex(new Vec2(4.0f, 2.0f));
//		polyDef.addVertex(new Vec2(0.0f, 3.0f));
//		bd.createShape(polyDef);
		
		bd.setMassFromShapes();
		
		spawnPoint = _physWorld.screenToWorld(spawnPoint);
		bd.setXForm(spawnPoint, 0);
	}
	
	private void initPhysics() {
//		_physWorld = new Physics(getApp(), getApp().width, getApp().height);
		_physWorld = new Physics(getApp(), getApp().width, getApp().height, 0.0f, -10.0f, getApp().width * 1.2f, getApp().height * 1.2f, getApp().width, getApp().height, 100.0f);
		_physWorld.setDensity(1.0f);
		
		_imageAnalysis = new ImageAnalysis(getApp(), _physWorld);
		
		setSprite(0);
		
		//createLift(getApp());
		createPolyHuman(new Vec2( (getApp().width/2), getApp().height/2));
		
	}
	
	private void setSprite(int index)
	{
		LogRepository.getInstance().getMikesLogger().info("Sprite to INDEX: " + index);
		
		
		//I just wanna say...that this is the lamest hack ever...Taylor's was lame but..
		try
		{
			setSprite(_spriteLookup[index]);
		}
		catch( Exception e )
		{
			LogRepository.getInstance().getMikesLogger().info("IMAGE ERROR - index: " + index);
			setSprite((_currentSpriteIndex + 1)%_spriteLookup.length);
		}
		
		_currentSpriteIndex = index;
	}
	
	public void setSprite(String path)
	{
		PImage img = getApp().loadImage(path);
		img.loadPixels();
		
		setSprite(img);
	}
	
	public void setSprite(PImage img)
	{
		_currentSpriteIndex = -1;
		_currentSprite = img;
		
		_polyHumanDef = _imageAnalysis.analyzeImage(_currentSprite);
	}
	
	
	//*************** OLD **********************//
	private void createLift(PApplet app)
	{
		Body mount, platform;
		
		float centerX, centerY;
		centerX = app.width/2;
		centerY = app.height/2;
		
		_physWorld.setDensity(0.0f);
		mount = _physWorld.createRect(centerX-5, centerY-5, centerX+5, centerY+5);
		
		_physWorld.setDensity(1.0f);
		platform = _physWorld.createRect(centerX-25, centerY-25, centerX+25, centerY-20);
		
		PrismaticJointDef jointDef = new PrismaticJointDef();
		//physWorld.screenToWorld(new Vec2(100.0f,100.0f))
		jointDef.initialize(platform, mount, mount.getPosition().clone(), new Vec2(0.0f,-1.0f));
		jointDef.motorSpeed = 10.0f;
		jointDef.maxMotorForce = 100.0f;
		jointDef.enableMotor = true;
		jointDef.lowerTranslation = 0.0f;
		jointDef.upperTranslation = 10.0f;
		jointDef.enableLimit = true;
		
		PrismaticJoint joint = (PrismaticJoint)_physWorld.getWorld().createJoint(jointDef);
	}
	
	private void createJointHuman()
	{
		Body shape1, shape2, shape3, shape4, shape5, shape6;

//		DistanceJoint joint;
//		
//		//Arms
		_physWorld.setDensity(0.0f);
		shape1 = _physWorld.createRect(10, 10, 20, 20);
		_physWorld.setDensity(1.0f);
		shape3 = _physWorld.createRect(110, 10, 120, 20);
		


		
		
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
