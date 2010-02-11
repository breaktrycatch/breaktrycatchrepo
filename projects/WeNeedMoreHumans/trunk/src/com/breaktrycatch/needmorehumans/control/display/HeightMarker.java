package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;
import java.text.DecimalFormat;

import processing.core.PApplet;
import processing.core.PFont;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.TextField;

public class HeightMarker extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected TextField _textField;
	protected TextField _shadowTextField;
	protected DecimalFormat _formatter;
	private Rectangle _bounds;

	public HeightMarker(PApplet app)
	{
		super(app);
		_formatter = new DecimalFormat("##0.00");
		PFont font = app.loadFont("../data/Miramonte-Bold-24.vlw");
		
		_textField = new TextField(app);
		_textField.setFont(font);

		_shadowTextField = new TextField(app);
		_shadowTextField.setFont(font);
		_shadowTextField.setColor(0x000000);
		
		add(_shadowTextField);
		add(_textField);
	}

	public void setBounds(Rectangle rect)
	{
		_bounds = rect;
	}

	@Override
	public void draw()
	{		
		String value = String.valueOf(_formatter.format(getDisplayValue() / 100)) + "M";
		_textField.setText(value);
		_textField.y = _textField.height / 2;

		_shadowTextField.setText(value);
		_shadowTextField.x = _textField.x + 2;
		_shadowTextField.y = _textField.y + 2;
		
		PApplet app = getApp();
		
		int width = 200;
		int height = 3;

		app.fill(0x000000);
		app.rect(-width + 2, 2, width, height);
		
		app.fill(0xffffffff);
		app.rect(-width, 0, width, height);

	}

	public float getDisplayValue()
	{
		return _bounds.height - y;
	}
}
