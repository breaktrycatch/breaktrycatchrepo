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
		width = _img.width;
		height = _img.height;
	}

	@Override
	public void draw()
	{
		super.draw();

		getApp().image(_img, 0, 0);
	}
	
	public PImage getDisplay()
	{
		return _img;
	}

}
