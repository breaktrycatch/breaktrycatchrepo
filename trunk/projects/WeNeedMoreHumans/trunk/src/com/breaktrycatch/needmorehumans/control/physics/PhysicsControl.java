package com.breaktrycatch.needmorehumans.control.physics;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Point2D;
import java.util.ArrayList;

import org.jbox2d.dynamics.Body;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;
import com.breaktrycatch.needmorehumans.model.PolyVO;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.utils.RectUtils;

public class PhysicsControl extends DisplayObject {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private PhysicsWorldWrapper _physWorld;
	private Point _lastMousePos;
	private Rectangle _scrollBounds;
	
	public PhysicsControl(PApplet app) {
		super(app);
		_scrollBounds = new Rectangle(-Integer.MAX_VALUE, -Integer.MAX_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);
	}
	
	public void setScrollBounds(Rectangle bounds)
	{
		_scrollBounds = bounds;
	}
	
	public Rectangle getScrollBounds()
	{
		return _scrollBounds;
	}
	
	/**
	 * Call after setting width/height
	 */
	public void init()
	{
		_physWorld = new PhysicsWorldWrapper((float)width, (float)height);
		_physWorld.enableDebugDraw(getApp());

//		PhysicsShapeDefVO vo = new PhysicsShapeDefVO();
//		vo.density = 0.0f;
//		_physWorld.createRect(0, height - 10, width, height, vo);
		
//		addDebugSmileBoxes();
//		addDebugPolyHuman();
//		_physWorld.createRect(50, 150, 150, 250, new PhysicsShapeDefVO());
	}
	
	private void addDebugSmileBoxes()
	{
		float size = 20;
		PImage img = getApp().loadImage("../data/physics/BoxMcSmiles.png");
//		PImage img = getApp().loadImage("../data/tracing/RealPerson_1.png");
		img.loadPixels();
		
		for(int i=0; i < 20; i++)
		{
			for(int j=0; j < 10; j++)
			{
				float x, y;
				x = (i * size) + 220;
				y = (j * size) + 310;
				Body rect = _physWorld.createRect(x, y, x + size, y + size, new PhysicsShapeDefVO());
				ImageFrame sprite = new ImageFrame(getApp(), img);
				sprite.setRotateAroundCenter(true);
				add(sprite);
				rect.setUserData(sprite);
			}
		}
	}
	
	private void addDebugPolyHuman()
	{
		PImage img = getApp().loadImage("../data/tracing/RealPerson_1.png");
		img.loadPixels();
		
		ImageFrame sprite = new ImageFrame(getApp(), img);
		//sprite.setRotateAroundCenter(true);
		sprite.x = 400;
		sprite.y = 200;
		
		addHuman(sprite);
	}
	
	public void addHuman(ImageFrame sprite)
	{
		sprite.setRotateAroundCenter(true);
		
		ImageAnalysis imageAnalysis = new ImageAnalysis(getApp());
		ArrayList<PolyVO> polyData = imageAnalysis.analyzeImage(sprite.getDisplay());
		
		DisplayObject castSprite = (DisplayObject)sprite;
		Body human = _physWorld.createPolyHuman(polyData, new PhysicsShapeDefVO(), castSprite.x + castSprite.width / 2, castSprite.y + castSprite.height / 2, -castSprite.rotationRad);
		human.setUserData(sprite);
		
		PApplet.println("addHuman POS: " + human.getPosition());
		
		add(sprite);
	}
	
	
	@Override
	public void draw() {
		// TODO Auto-generated method stub
		super.draw();
		
		getApp().fill(0x22000000);
		getApp().rect(0, 0, width, height);
		if(getApp().mouseX > this.x && getApp().mouseX < this.width + this.x && getApp().mousePressed)
		{
			if(_lastMousePos != null)
			{
				this.y += getApp().mouseY - _lastMousePos.y;
				this.x += getApp().mouseX - _lastMousePos.x;
			}
			_lastMousePos = new Point(getApp().mouseX, getApp().mouseY);
//			int hitAreaSize = 50;
//			int scrollSpeed = 2;
//			if(getApp().mouseY < hitAreaSize)
//			{
//				this.y += scrollSpeed;
//			}
//			else if(getApp().mouseY > getApp().height - hitAreaSize)
//			{
//				this.y -= scrollSpeed;
//			}
		}
		else
		{
			_lastMousePos = null;
		}
		
		constrainToBounds();
		
		_physWorld.step();
	}

	private void constrainToBounds()
	{
		Point2D.Float pt = RectUtils.constrain(new Point2D.Float((int)x,(int)y), _scrollBounds);
		this.x = pt.x;
		this.y = pt.y;
	}

	@Override
	public void dispose() {
		
		_physWorld.destroy();
		
		super.dispose();
	}
}
