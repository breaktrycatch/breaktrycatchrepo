package com.breaktrycatch.lib.display;

import java.awt.Rectangle;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;

import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.TimeManager;


public class Sprite extends ImageFrame
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ArrayList<ImageFrame> _timeline;
	private int _frame = 0;

	private boolean _playing;

	private float _elapsedFrames;
	private int _fps;

	public Sprite(PApplet app)
	{
		super(app);
		_fps = (int)app.frameRate;
		_timeline = new ArrayList<ImageFrame>();
		_playing = true;
	}

	@Override
	public void draw()
	{
		DisplayObject displayObject = _timeline.get(_frame);
		displayObject.draw();

		if (_playing)
		{
			TimeManager tManager = (TimeManager)(ManagerLocator.getManager(TimeManager.class));
			long diff = tManager.getGameTimeDiff();
			_elapsedFrames += (((float)_fps * (float)diff) / 1000);
			_frame = (int)_elapsedFrames % _timeline.size();
		}
	}
	
	@Override
	public void enableExternalRenderTarget(PGraphics _externalRenderTarget, int _ertoX, int _ertoY) {
		// TODO Auto-generated method stub
		super.enableExternalRenderTarget(_externalRenderTarget, _ertoX, _ertoY);
		
		for (int i = 0; i < _timeline.size(); i++) {
			_timeline.get(i).enableExternalRenderTarget(_externalRenderTarget, _ertoX, _ertoY);
		}
	}
	
	@Override
	public void disableExternalRenderTarget() {
		// TODO Auto-generated method stub
		super.disableExternalRenderTarget();
		for (int i = 0; i < _timeline.size(); i++) {
			_timeline.get(i).disableExternalRenderTarget();
		}
	}
	
	public void stop()
	{
		_playing = false;
	}
	
	public void play()
	{
		_playing = true;
	}
	
	public void goToAndPlay(int frame)
	{
		_frame = frame;
		_playing = true;
	}
	
	public int getTotalFrames()
	{
		return _timeline.size();
	}

	public void addFrame(PImage img)
	{
		_timeline.add(new ImageFrame(getApp(), img));
		invalidateDimensions();
	}


	@Override
	public PImage getDisplay()
	{
		return _timeline.get(_frame).getDisplay();
	}

	public void addFrames(ArrayList<PImage> images)
	{
		for(PImage img : images)
		{
			_timeline.add(new ImageFrame(getApp(), img));
		}
		invalidateDimensions();
	}
	
	public int getFPS()
	{
		return _fps;
	}
	
	public void setFPS(int fps)
	{
		_fps = fps;
	}
	
	private void invalidateDimensions()
	{
		Rectangle bounds = new Rectangle();
		for(DisplayObject obj : _timeline)
		{
			if(obj.x + obj.width > bounds.width)
			{
				bounds.width = (int)(obj.x + obj.width);
			}
			
			if(obj.y + obj.height > bounds.height)
			{
				bounds.height = (int)(obj.y + obj.height);
			}
		}
		
		width = bounds.width;
		height = bounds.height;
	}
}
