package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;
import java.text.DecimalFormat;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.TextField;
import com.breaktrycatch.needmorehumans.config.control.ColorController;

public class HeightMarker extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected TextField _textField;
	protected DecimalFormat _formatter;
	private Rectangle _bounds;
	private ColorController _colorController; 
	public HeightMarker(PApplet app)
	{
		super(app);
		_formatter = new DecimalFormat("##0.00");
		_textField = new TextField(app);
		_textField.setFont(app.loadFont("../data/Miramonte-Bold-24.vlw"));
		add(_textField);
	}
	
	public void setBounds(Rectangle rect)
	{
		_bounds = rect;
	}

	@Override
	public void draw()
	{
		_textField.setText(String.valueOf(_formatter.format(getDisplayValue() / 100)) + "M"); 
	}
	
	public float getDisplayValue()
	{
		return _bounds.height - y;
	}
}
