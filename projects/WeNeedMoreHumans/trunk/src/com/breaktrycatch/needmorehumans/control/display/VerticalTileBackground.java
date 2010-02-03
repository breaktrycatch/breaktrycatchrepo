package com.breaktrycatch.needmorehumans.control.display;

import processing.core.PApplet;
import processing.core.PImage;

public class VerticalTileBackground extends AbstractTileBackground
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public VerticalTileBackground(PApplet app, PImage img, float maxSize)
	{
		super(app, img, maxSize);
	}

	@Override
	public void draw()
	{
		for (int i = 0; i < _maxImages; i++)
		{
			_images.get(i).y = _img.height * (i - 1);
		}
		
		super.draw();
	}

	@Override
	protected int calculateMaxImages()
	{
		return (int) Math.ceil((float)maxSize / (float)_img.height) + 1;
	}
}
