package com.breaktrycatch.needmorehumans.control.display;

import java.awt.geom.Point2D;

import org.jbox2d.common.MathUtils;

import processing.core.PApplet;
import processing.core.PFont;

import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.TimeManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.TextField;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;

public class Countdown extends DisplayObject
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int _countFrom = 3;
	private int _currentCount = 0;
	private double _ctr = 0;

	private TextField _textfield;
	private ISimpleCallback _completeCallback;

	private boolean _started;

	private TextField _shadowTextField;

	public Countdown(PApplet app, ISimpleCallback completeCallback)
	{
		super(app);

		PFont font = app.loadFont("../data/fonts/Toonish-124.vlw");
		
		_textfield = new TextField(app);
		_textfield.setColor(0xffffffff);
		_textfield.setScaleAroundCenter(true);
		_textfield.setFont(font);

		_shadowTextField = new TextField(app);
		_shadowTextField.setColor(0x000000);
		_shadowTextField.setScaleAroundCenter(true);
		_shadowTextField.setFont(font);

		add(_shadowTextField);
		add(_textfield);
		
		_completeCallback = completeCallback;
	}

	@Override
	public void draw()
	{

		if (_started)
		{
			TimeManager tManager = (TimeManager) (ManagerLocator.getManager(TimeManager.class));
			_ctr += tManager.getGameTimeDiffMillis() / 1000f;
			if (Math.floor(_ctr) > _currentCount)
			{
				_currentCount = (int) Math.floor(_ctr);
				
				if(_currentCount < _countFrom )
				{
					scaleInText();
				}
			}

			int counter = (int) MathUtils.clamp(_countFrom - _currentCount, 1, Integer.MAX_VALUE);
			_textfield.setText(String.valueOf(counter));
			_shadowTextField.setText(String.valueOf(counter));
			
			_shadowTextField.x = _textfield.x + 2;
			_shadowTextField.y = _textfield.y + 2;
			
			if (_currentCount == _countFrom)
			{
				_started = false;
				_completeCallback.execute();
			}
		}
		super.draw();
	}
	
	private void scaleInText()
	{
		_textfield.setScaleAroundPoint(new Point2D.Float((float)(Math.random() * _textfield.width), (float)(Math.random() * _textfield.height)));
		_textfield.scaleX = _textfield.scaleY = 1.5f + (float)(Math.random() * .5f);
		_textfield.scaleTo(1f, 1f, .25f);
		
		_shadowTextField.setScaleAroundPoint(new Point2D.Float((float)(Math.random() * _shadowTextField.width), (float)(Math.random() * _shadowTextField.height)));
		_shadowTextField.scaleX = _shadowTextField.scaleY = _textfield.scaleY;
		_shadowTextField.scaleTo(1f, 1f, .25f);
	}

	public void setCountFrom(int countFrom)
	{
		_countFrom = countFrom;
	}

	public void start()
	{
		_ctr = 0;
		_started = true;
		
		scaleInText();
	}

	public void pause()
	{
		_started = false;
	}

	public void unpause()
	{
		_started = true;
	}
	
	@Override
	public String toString()
	{
		return "[Countdown]";
	}
}
