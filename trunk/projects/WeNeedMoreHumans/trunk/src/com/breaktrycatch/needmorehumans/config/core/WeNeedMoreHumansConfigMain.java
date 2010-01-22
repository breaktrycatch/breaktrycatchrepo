package com.breaktrycatch.needmorehumans.config.core;

import processing.core.PApplet;
import controlP5.ControlEvent;

public class WeNeedMoreHumansConfigMain extends PApplet
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static void main(String args[])
	{
		PApplet.main(new String[]
		{ "--present", "com.breaktrycatch.needmorehumans.config.core.WeNeedMoreHumansConfigMain" });
	}

	private NeedMoreHumansConfigCore _stage;

	public WeNeedMoreHumansConfigMain()
	{
		// all PApplet related commands should be made in setup().
	}

	@Override
	public void setup()
	{
		super.setup();

		_stage = new NeedMoreHumansConfigCore(this);
	}

	public void draw()
	{
		_stage.draw();
	}

	public void controlEvent(ControlEvent theEvent)
	{
		// pass through
		_stage.controlEvent(theEvent);
	}
	
	@Override
	public void exit()
	{
		_stage.clear();
		_stage.dispose();
		super.exit();
	}

}
