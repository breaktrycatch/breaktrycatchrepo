package com.breaktrycatch.lib.view;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;

public class AbstractView extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public AbstractView()
	{
		super(null);
	}

	public void initialize(PApplet app)
	{
		setApp(app);
	}
}
