package com.breaktrycatch.lib.display;

import processing.core.PApplet;
import processing.core.PImage;

public class ImageFrame extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private PImage _img;

	public ImageFrame(PApplet app, PImage img)
	{
		super(app);
		_img = img;
	}

	@Override
	public void draw()
	{
		super.draw();

		getApp().image(_img, getX(), getY());
	}

}
