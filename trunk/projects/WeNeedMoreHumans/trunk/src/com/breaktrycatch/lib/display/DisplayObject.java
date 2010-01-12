package com.breaktrycatch.lib.display;

import java.util.ArrayList;
import java.util.Collection;

import processing.core.PApplet;

public class DisplayObject extends ArrayList<DisplayObject>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public int x;
	public int y;

	private PApplet _app;

	public DisplayObject(PApplet app)
	{
		_app = app;
	}

	public void draw()
	{

	}

	public void drawChildren()
	{
		for (DisplayObject child : this)
		{
			child.draw();
			child.drawChildren();
		}
	}

	public void dispose()
	{

	}

	@Override
	public DisplayObject remove(int index)
	{
		get(index).dispose();
		return super.remove(index);
	}

	@Override
	public void clear()
	{
		for (DisplayObject child : this)
		{
			child.dispose();
		}
		super.clear();
	}

	protected PApplet getApp()
	{
		return _app;
	}

	protected void setApp(PApplet app)
	{
		_app = app;
	}
}
