package com.breaktrycatch.lib.view;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;

public class AbstractView extends DisplayObject
{
	public AbstractView()
	{
		super(null);
	}


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void initialize(PApplet app)
	{
		PApplet.println("INITIALIZING ABSTRACTVIEW");
		setApp(app);
	}
}
