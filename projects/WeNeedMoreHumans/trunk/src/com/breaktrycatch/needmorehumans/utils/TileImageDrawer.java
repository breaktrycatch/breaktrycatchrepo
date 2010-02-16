package com.breaktrycatch.needmorehumans.utils;

import java.util.ArrayList;

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
	private float _maxWidth;
	private ArrayList<ImageToDraw> _imagesToDraw;

	private boolean _enabled = true;

	public TileImageDrawer(PApplet app)
	{
		super(app);
		_maxWidth = app.width;
		_imagesToDraw = new ArrayList<ImageToDraw>();
	}

	public TileImageDrawer(PApplet app, float scale)
	{
		this(app);

		_scale = scale;
	}

	public TileImageDrawer(PApplet app, float scale, float maxWidth)
	{
		this(app, scale);
		_maxWidth = maxWidth;
	}

	public void drawImage(int[] image, int w, int h)
	{
		if (!_enabled)
		{
			return;
		}

		PImage img = getApp().createImage(w, h, PApplet.ARGB);
		img.pixels = image;
		drawImage(img);
	}

	public void drawImage(PImage image)
	{
		if (!_enabled)
		{
			return;
		}
		
//		image = ImageUtils.cloneImage(image);

		_imagesToDraw.add(new ImageToDraw(image, _dX, _dY));
		
		if (image.height > _yJump)
		{
			_yJump = image.height;
		}

		if (image.width + _dX > _maxWidth)
		{
			_dX = 0;
			_dY += _yJump;
			_yJump = 0;
		}
		_dX += image.width;

	}

	@Override
	public void draw()
	{
		getApp().pushMatrix();
		for (ImageToDraw toDraw : _imagesToDraw)
		{
			getApp().scale(_scale);
			getApp().image(toDraw.img, toDraw.x, toDraw.y);
//			getApp().image(toDraw.img, 0,0);
		}
		getApp().popMatrix();
		super.draw();
	}

	@Override
	public void postDraw()
	{
		super.postDraw();
		_imagesToDraw.clear();
	}
	
	public int numImagesToDraw()
	{
		return _imagesToDraw.size();
	}
	
	public float getScale()
	{
		return _scale;
	}

	public void reset()
	{
		_dX = 0;
		_dY = 0;
		_yJump = 0;
	}

	public void setEnabled(boolean enabled)
	{
		_enabled = enabled;
	}

	public boolean getEnabled()
	{
		return _enabled;
	}
}

class ImageToDraw
{
	public PImage img;
	public float x;
	public float y;

	public ImageToDraw(PImage img, float x, float y)
	{
		this.img = img;
		this.x = x;
		this.y = y;
	}
}
