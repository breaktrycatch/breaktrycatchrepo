package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;

import processing.core.PApplet;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.utils.RectUtils;

public class InputTestView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public InputTestView()
	{

	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);
	}

	@Override
	public void draw()
	{
		super.draw();
		
		PApplet app = getApp();
		
		Rectangle bounds = new Rectangle(100,100, 300,300);
		Rectangle tooBig = new Rectangle(app.mouseX,app.mouseY, 600,100);
		Rectangle resized = RectUtils.fitIn(tooBig, bounds);

		app.fill(0,0);
		
		app.stroke(0xffff00ff);
		app.rect(bounds.x, bounds.y, bounds.width, bounds.height);
		
		app.stroke(0xffffff00);
		app.rect(tooBig.x, tooBig.y, tooBig.width, tooBig.height);
		
		app.stroke(0xff00ff00);
		app.rect(resized.x, resized.y, resized.width, resized.height);
		
	}
}
