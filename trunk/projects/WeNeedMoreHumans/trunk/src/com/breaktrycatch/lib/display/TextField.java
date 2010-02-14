package com.breaktrycatch.lib.display;

import processing.core.PApplet;
import processing.core.PFont;

public class TextField extends DisplayObject
{

	private String _text = "";
	private int _color = 0xffffff;

	private PFont _font;

	private static PFont _defaultFont;

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public TextField(PApplet app)
	{
		super(app);

		if (_defaultFont == null)
		{
			_defaultFont = app.createFont("Arial-Bold", 50);
		}

		setFont(_defaultFont);
	}

	@Override
	public void draw()
	{
		if (visible)
		{
			PApplet app = getApp();
			app.fill((255 << 24 | _color), alpha * 255);
			app.textFont(getFont());
			app.text(_text, 0, 0);
		}
	}

	public void setText(String text)
	{
		_text = text;

		getApp().textFont(getFont());
		width = getApp().textWidth(_text);
		height = getApp().textAscent() + getApp().textDescent();
	}

	public String getText()
	{
		return _text;
	}

	public void setColor(int color)
	{
		_color = color;
	}

	public int getColor()
	{
		return _color;
	}

	public void setFont(PFont font)
	{
		_font = font;
	}

	public PFont getFont()
	{
		return _font;
	}
}
