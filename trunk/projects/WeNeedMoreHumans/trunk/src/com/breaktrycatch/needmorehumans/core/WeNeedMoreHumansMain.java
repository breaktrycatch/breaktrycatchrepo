package com.breaktrycatch.needmorehumans.core;

import processing.core.PApplet;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.TimeManager;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.core.AbstractMain;
import com.breaktrycatch.lib.display.Stage;

public class WeNeedMoreHumansMain extends AbstractMain
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
		
		// a list of Manager classes that need their update() method
		// called once per render tick. They can be accessed via
		// ManagerLocator.getInstance().getManager(ManagerType.class);

		size(1440, 900, PApplet.OPENGL);
		
		addManager(new KeyboardManager(this));
		addManager(new TimeManager());
		addManager(new XBoxControllerManager());
		_stage = new NeedMoreHumansCore(this);
	}

	public void draw()
	{
		super.draw();
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
