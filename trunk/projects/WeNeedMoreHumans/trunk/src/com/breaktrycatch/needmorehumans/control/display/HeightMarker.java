package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;
import java.text.DecimalFormat;

import processing.core.PApplet;
import processing.core.PFont;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
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
	protected ImageFrame _background;
	private Rectangle _bounds;

	public HeightMarker(PApplet app)
	{
		super(app);
		_formatter = new DecimalFormat("##0.00");
		PFont font = app.loadFont("../data/fonts/AnonimRound-48.vlw");

		_background = new ImageFrame(app, app.loadImage("../data/world/height-marker-background.png"));
		_background.x = -_background.width / 2;
		_background.y = -_background.height / 2;
		
		_textField = new TextField(app);
		_textField.setFont(font);
		_textField.x = -30;
		_textField.visible = false;

		_shadowTextField = new TextField(app);
		_shadowTextField.setFont(font);
		_shadowTextField.setColor(0x000000);
		
		add(_background);
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
		_textField.y = _textField.height / 2 - 5;

		_shadowTextField.setText(value);
		_shadowTextField.x = _textField.x + 2;
		_shadowTextField.y = _textField.y + 2;
		
//		PApplet app = getApp();
//		
//		int width = 75;
//		int height = 2;
//
//		app.fill(0x000000);
//		app.rect(-width + 2, 2, width, height);
//		
//		app.fill(0xffffffff);
//		app.rect(-width, 0, width, height);

	}

	public float getDisplayValue()
	{
		return _bounds.height - y;
	}
}
