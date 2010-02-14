package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;

public class MonkeySpawner extends DisplayObject
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static ImageFrame _body;
	private static ImageFrame _arm;
	private static ImageFrame _ship;

	private DisplayObject _monkeyContainer;

	private int _numShakes;

	private final int MAX_SHAKES = 6;

	private ISimpleCallback _onShakeComplete;

	public MonkeySpawner(PApplet app)
	{
		super(app);

		if (_body == null)
		{
			_body = new ImageFrame(app, app.loadImage("../data/world/ape-bottom.png"));
			_arm = new ImageFrame(app, app.loadImage("../data/world/ape-arm.png"));
			_ship = new ImageFrame(app, app.loadImage("../data/world/ape-ship.png"));
		}

		_monkeyContainer = new DisplayObject(app);
		add(_monkeyContainer);
		_monkeyContainer.add(_body);
		_monkeyContainer.add(_ship);
		_monkeyContainer.add(_arm);
		_monkeyContainer.scaleX = _monkeyContainer.scaleY = .75f;

		Rectangle bounds = _body.getBounds().union(_ship.getBounds().union(_arm.getBounds()));
		width = bounds.width * _monkeyContainer.scaleX;
		height = bounds.height * _monkeyContainer.scaleY;
	}
	
	public void shake()
	{
		shake(null);
	}
	public void shake(ISimpleCallback onShakeComplete)
	{
		_onShakeComplete = onShakeComplete;
		_numShakes = 0;
		doShake();
	}
	private void doShake()
	{
		if (_numShakes >= MAX_SHAKES)
		{
			if(_onShakeComplete != null)
			{
				_onShakeComplete.execute();
			}
			return;
		}
		_numShakes++;
		_arm.slideTo(10, -5, .05f);
		_body.slideTo(10, -5, .05f);
		_ship.slideTo((int) _ship.x, -10, .05f, null, new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				_arm.slideTo(0, 0, .05f);
				_body.slideTo(0, 0, .05f);
				_ship.slideTo((int) _ship.x, 0, .05f, null, new ISimpleCallback()
				{
					@Override
					public void execute()
					{
						doShake();
					}
				});
			}
		});
	}

	@Override
	public void dispose()
	{
		clear();
		super.dispose();
	}

}
