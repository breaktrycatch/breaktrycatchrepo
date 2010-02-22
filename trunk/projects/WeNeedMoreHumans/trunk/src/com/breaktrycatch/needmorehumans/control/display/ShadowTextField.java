package com.breaktrycatch.needmorehumans.control.display;

import processing.core.PApplet;
import processing.core.PFont;

import com.breaktrycatch.lib.display.TextField;

public class ShadowTextField extends TextField
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private TextField _shadowField;
	
	public ShadowTextField(PApplet app)
	{
		super(app);
	}
	
	public void setShadowOffset(float x, float y)
	{
		_shadowField.x = x;
		_shadowField.y = y;
	}
	
	public void setShadowOffset(float offset)
	{
		setShadowOffset(offset, offset);
	}
	
	@Override
	public void setFont(PFont font)
	{
		super.setFont(font);
		lazyCreateShadowField();
		_shadowField.setFont(font);
	}
	
	@Override
	public void setText(String text)
	{
		super.setText(text);
		lazyCreateShadowField();
		_shadowField.setText(text);
	}
	
	@Override
	public void setColor(int color)
	{
		super.setColor(color);
		lazyCreateShadowField();
		_shadowField.setColor(0);
	}
	
	@Override
	public void draw()
	{
		_shadowField.preDraw();
		_shadowField.draw();
		_shadowField.postDraw();
		
		super.draw();
	}
	
	private void lazyCreateShadowField()
	{
		if(_shadowField == null)
		{
			_shadowField = new TextField(getApp());
			_shadowField.setColor(0);
//			add(_shadowField);
			setShadowOffset(2);
		}
	}
}
