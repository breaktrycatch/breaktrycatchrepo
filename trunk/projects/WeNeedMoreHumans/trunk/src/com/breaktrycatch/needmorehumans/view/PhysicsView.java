package com.breaktrycatch.needmorehumans.view;

import java.awt.Point;
import java.util.ArrayList;

import org.jbox2d.collision.PolygonDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;
import org.jbox2d.dynamics.BodyDef;
import org.jbox2d.p5.Physics;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class PhysicsView extends AbstractView {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static final char CHANGE_SPRITE_KEY = '9';
	
	private Physics _physWorld;
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
		
		if(width == 0)
		{
			width = app.width;
			height = app.height;
		}
		initPhysics();
	}
	
	@Override
	public void draw() {
//		getApp().background(0xFF0000);
		
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
		
		
		getApp().pushMatrix();

		getApp().translate(x + centerSpawn.x + (_currentSprite.width/2), y +  centerSpawn.y + (_currentSprite.height/2));
		getApp().rotate((float)Math.PI);
		getApp().image(_currentSprite,0.0f,0.0f);
		getApp().popMatrix();
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
		
//		AABB bounds = new AABB();
//		bounds.lowerBound = _physWorld.getWorld().getWorldAABB().lowerBound;
//		bounds.upperBound = _physWorld.getWorld().getWorldAABB().upperBound;
//		Shape[] query = _physWorld.getWorld().query(bounds, 100);
//		for(Shape s : query)
//		{
//			PApplet.println("Position: "+  s.m_body.getPosition());
//		}
//		
//		PApplet.println("UPPER BOUND Y: " + _physWorld.getWorld().getWorldAABB().upperBound.y);
		
		//PhysicsSprite sprite = new PhysicsSprite(getApp(),bd,_currentSprite);
		//add(sprite);
	}
	
	private void initPhysics() {
//		_physWorld = new Physics(getApp(), getApp().width, getApp().height);
		_physWorld = new Physics(getApp(), width, height, 0.0f, -10.0f, width * 2.2f, height * 1.2f, width, height, 100.0f);
		_physWorld.setDensity(1.0f);
		add(_physWorld);
		
//		_imageAnalysis = new ImageAnalysis(getApp(), _physWorld);
		
		setSprite(0);
		createPolyHuman(new Vec2( width/2, height/2));
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
		
		//_polyHumanDef = _imageAnalysis.analyzeImage(_currentSprite);
	}
}
