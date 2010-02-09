package com.breaktrycatch.needmorehumans.control.display;

import processing.core.PApplet;

public class TallestPointTextField extends HeightMarker
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private float _highestValue;

	public TallestPointTextField(PApplet app)
	{
		super(app);
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
		_textField.setText("Tallest Point: " + String.valueOf(_formatter.format(_highestValue / 100)) + "M");
	}
}
