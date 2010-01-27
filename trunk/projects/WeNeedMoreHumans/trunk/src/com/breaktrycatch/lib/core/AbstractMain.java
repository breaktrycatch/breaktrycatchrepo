package com.breaktrycatch.lib.core;

import processing.core.PApplet;

import com.breaktrycatch.lib.component.IManager;
import com.breaktrycatch.lib.component.ManagerLocator;

public class AbstractMain extends PApplet
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public AbstractMain()
	{
	}

	protected void addManager(IManager manager)
	{
		ManagerLocator.getInstance().add(manager);
	}

	@Override
	public void setup()
	{
		super.setup();
	}

	public void draw()
	{
		// do NOT call super.draw() here or the draw loop will terminate after
		// one iteration.
		ManagerLocator.getInstance().update();
	}
}
