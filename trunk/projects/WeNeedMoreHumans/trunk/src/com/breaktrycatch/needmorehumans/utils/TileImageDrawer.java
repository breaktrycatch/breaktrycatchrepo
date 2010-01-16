package com.breaktrycatch.needmorehumans.utils;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;

public class TileImageDrawer extends DisplayObject
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int _dX;
	private int _dY;
	private int _yJump;
	private float _scale = 1;

	public TileImageDrawer(PApplet app)
	{
		super(app);
	}

	public TileImageDrawer(PApplet app, float scale)
	{
		this(app);
		_scale = scale;
	}
	
	public void drawImage(int[] image, int w, int h)
	{
		PImage img = getApp().createImage(w, h, PApplet.ARGB);
		img.pixels = image;
		drawImage(img);
	}
	
	public void drawImage(PImage image)
	{
		if(_scale != 1)
		{
			image = ImageUtils.cloneImage(image);
			image.resize((int)(image.width * _scale),(int)(image.height * _scale));
		}
		
		if (image.height > _yJump)
		{
			_yJump = image.height;
		}

		if (image.width + _dX > getApp().width)
		{
			_dX = 0;
			_dY += _yJump;
			_yJump = 0;
		}

		getApp().image(image, _dX, _dY);

		_dX += image.width;
	}

	public void reset()
	{
		_dX = 0;
		_dY = 0;
		_yJump = 0;

	}
}
