package com.breaktrycatch.needmorehumans.config.control;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;

public class ColorController extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private float red;
	private float green;
	private float blue;
	private int col = 0;
	private int w, h;

	public ColorController(PApplet app, int x, int y, int w, int h)
	{
		super(app);
		setX(x);
		setY(y);
		this.w = w;
		this.h = h;
	}

	public void setRed(float r)
	{
		red = r;
		updateColor();
	}

	public void setGreen(float g)
	{
		green = g;
		updateColor();
	}

	public void setBlue(float b)
	{
		blue = b;
		updateColor();
	}
	
	public float getRed()
	{
		return red;
	}
	

	public float getGreen()
	{
		return green;
	}
	
	public float getBlue()
	{
		return blue;
	}


	private void updateColor()
	{
		col = (255 << 24 | (int)(red * 255) << 16 | (int)(green * 255) << 8 | (int)(blue * 255));
	}
	
	@Override
	public void draw()
	{
		super.draw();

		getApp().stroke(col);
		getApp().fill(col);
		getApp().rect(getX(), getY(), w, h);
	}

}
