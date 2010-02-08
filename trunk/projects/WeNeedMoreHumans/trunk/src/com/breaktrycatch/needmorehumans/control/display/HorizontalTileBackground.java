package com.breaktrycatch.needmorehumans.control.display;

import processing.core.PApplet;
import processing.core.PImage;

public class HorizontalTileBackground extends AbstractTileBackground
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public HorizontalTileBackground(PApplet app, PImage img, float maxSize)
	{
		super(app, img, maxSize);
	}

	@Override
	public void draw()
	{
		for (int i = 0; i < _maxImages; i++)
		{
			_images.get(i).x = _img.width * (i - 1);
		}
	}

	@Override
	protected int calculateMaxImages()
	{
		return (int) Math.ceil((float)maxSize / (float)_img.width) + 1;
	}
}