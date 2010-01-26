package com.breaktrycatch.lib.display;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.component.TimeManager;


public class Sprite extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ArrayList<DisplayObject> _timeline;
	private int _frame = 0;

	private boolean _playing;

	private float _elapsedFrames;
	private int _fps;

	public Sprite(PApplet app)
	{
		super(app);
		_fps = (int)app.frameRate;
		_timeline = new ArrayList<DisplayObject>();
		_playing = true;
	}

	@Override
	public void draw()
	{
		// TODO Auto-generated method stub
		super.draw();

		DisplayObject displayObject = _timeline.get(_frame);
		displayObject.draw();

		if (_playing)
		{
			long diff = TimeManager.getGameTimeDiff();
			_elapsedFrames += (((float)_fps * (float)diff) / 1000);
			_frame = (int)_elapsedFrames % _timeline.size();
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

	public void addFrame(DisplayObject frame)
	{
		_timeline.add(frame);
	}
	
	public void addFrame(PImage img)
	{
		_timeline.add(new ImageFrame(getApp(), img));
	}

	public void addFrames(ArrayList<DisplayObject> images)
	{
		_timeline.addAll(images);
	}
	
	public int getFPS()
	{
		return _fps;
	}
	
	public void setFPS(int fps)
	{
		_fps = fps;
	}
}
