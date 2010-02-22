package com.breaktrycatch.needmorehumans.control.display;

import java.text.DecimalFormat;

import processing.core.PApplet;

public class TallestPointTextField extends ShadowTextField
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private float _highestValue;
	private DecimalFormat _formatter;

	public TallestPointTextField(PApplet app)
	{
		super(app);
		_formatter = new DecimalFormat("##0.00");
		setFont(app.loadFont("../data/fonts/AnonimRound-48.vlw"));
	}

	public void setValue(float value)
	{
		if (value > _highestValue)
		{
			_highestValue = value;
		}
	}

	public void reset()
	{
		_highestValue = 0;
	}

	@Override
	public void draw()
	{
		setText("Best: " + String.valueOf(_formatter.format(_highestValue / 100)) + "M");
		super.draw();
	}

	@Override
	public String toString()
	{
		return "[TallestPointTextField]";
	}
}
