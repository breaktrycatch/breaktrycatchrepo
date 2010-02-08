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

	public ColorController(PApplet app, int x, int y, int w, int h)
	{
		super(app);
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
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
	
	public void setColor(int col)
	{
		this.col = col;
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
		col = ((int) (red * 255) << 16 | (int) (green * 255) << 8 | (int) (blue * 255));
	}

	@Override
	public void draw()
	{
		_renderTarget.stroke(col, alpha * 255);
		_renderTarget.fill(col, alpha * 255);
		_renderTarget.rect(0, 0, width, height);

		PApplet.println("ALPHA: " + alpha + " COL: " + Integer.toHexString(col) + " R: " + red + " B: " + blue);
	}

}
