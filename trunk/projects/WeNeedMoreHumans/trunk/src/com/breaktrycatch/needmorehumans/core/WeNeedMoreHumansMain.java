package com.breaktrycatch.needmorehumans.core;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.Stage;

public class WeNeedMoreHumansMain extends PApplet
{
	/**
	 * Default serial version id to appease the Eclipse gods.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Main entry point for the application.
	 * 
	 * @param args
	 *            Command line arguments.
	 */
	public static void main(String args[])
	{
		PApplet.main(new String[]
		{ "--present", "com.breaktrycatch.needmorehumans.core.WeNeedMoreHumansMain" });
	}

	private Stage _stage;

	public WeNeedMoreHumansMain()
	{
		// all PApplet related commands should be made in setup().
	}

	@Override
	public void setup()
	{
		super.setup();

		_stage = new NeedMoreHumansCore(this);
	}

	public void draw()
	{
		_stage.draw();
	}

	@Override
	public void exit()
	{
		_stage.clear();
		_stage.dispose();
		super.exit();
	}
}
