package com.breaktrycatch.needmorehumans.control.display;

import org.jbox2d.common.MathUtils;

import processing.core.PApplet;

import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.TimeManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.TextField;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;

import controlP5.ControlP5;
import controlP5.Textlabel;

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

	public Countdown(PApplet app, ISimpleCallback completeCallback)
	{
		super(app);

		_textfield = new TextField(app);
		_textfield.setColor(0x000000);
		_textfield.setFont(app.loadFont("DejaVuSansCondensed-Bold-82.vlw"));
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
			}

			int counter = (int) MathUtils.clamp(_countFrom - _currentCount, 1, Integer.MAX_VALUE);
			_textfield.setText(String.valueOf(counter));
			
			if (_currentCount == _countFrom)
			{
				_started = false;
				_completeCallback.execute();
			}
		}
		super.draw();
	}

	public void setCountFrom(int countFrom)
	{
		_countFrom = countFrom;
	}

	public void start()
	{
		_ctr = 0;
		_started = true;
	}

	public void pause()
	{
		_started = false;
	}

	public void unpause()
	{
		_started = true;
	}
}
