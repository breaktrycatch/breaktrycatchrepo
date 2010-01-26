package com.breaktrycatch.lib.display;

import processing.core.PApplet;

import com.breaktrycatch.lib.component.TimeManager;

public class Stage extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public Stage(PApplet app)
	{
		super(app);
	}
	
	@Override
	public void draw()
	{
		TimeManager.update();
		
		super.draw();
		
		// start drawing from the root of the display hierarchy.
		drawChildren();
		
	}
}
