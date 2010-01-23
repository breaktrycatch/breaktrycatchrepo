package com.breaktrycatch.lib.display;

import java.util.ArrayList;

import megamu.shapetween.Shaper;
import megamu.shapetween.Tween;
import processing.core.PApplet;

public class DisplayObject extends ArrayList<DisplayObject>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private ArrayList<ITween> _activeTweens;
	public int x;
	public int y;

	private PApplet _app;

	public DisplayObject(PApplet app)
	{
		_app = app;
		_activeTweens = new ArrayList<ITween>();
	}

	public void slideTo(int x, int y, float duration)
	{
		_activeTweens.add(new SlideTo(getApp(), this, x, y, duration));
	}

	public void slideTo(int x, int y, float duration, Class<Shaper> shape)
	{
		_activeTweens.add(new SlideTo(getApp(), this, x, y, duration, shape));
	}

	public void draw()
	{
		for (int i = _activeTweens.size() - 1; i >= 0; i--)
		{
			ITween tween = _activeTweens.get(i);
			tween.update();

			if (tween.isComplete())
			{
				_activeTweens.remove(i);
			}
		}
	}

	public void drawChildren()
	{
		for (DisplayObject child : this)
		{
			child.draw();
			child.drawChildren();
		}
	}

	public void dispose()
	{

	}

	@Override
	public DisplayObject remove(int index)
	{
		get(index).dispose();
		return super.remove(index);
	}

	@Override
	public void clear()
	{
		for (DisplayObject child : this)
		{
			child.dispose();
		}
		super.clear();
	}

	protected PApplet getApp()
	{
		return _app;
	}

	protected void setApp(PApplet app)
	{
		_app = app;
	}
}

interface ITween
{
	public void update();

	public boolean isComplete();
}

class SlideTo implements ITween
{
	private Tween _tween;
	private int _targetX;
	private int _targetY;
	private int _startX;
	private int _startY;
	private DisplayObject _target;

	private void init(PApplet app, DisplayObject target, int x, int y)
	{
		_target = target;
		
		_startX = target.x;
		_startY = target.y;

		_targetX = x;
		_targetY = y;
	}

	public SlideTo(PApplet app, DisplayObject target, int x, int y, float duration, Class<Shaper> shape)
	{
		init(app, target, x, y);
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public SlideTo(PApplet app, DisplayObject target, int x, int y, float duration)
	{
		init(app, target, x, y);
		_tween = new Tween(app, duration, Tween.SECONDS);
	}

	public void update()
	{
		if (_tween.isTweening())
		{
			float amt = _tween.time() * _tween.position();

			_target.x = _startX + (int) ((_targetX - _startX) * amt);
			_target.y = _startY + (int) ((_targetY - _startY) * amt);
		}
	}

	public boolean isComplete()
	{
		return !_tween.isTweening();
	}
}
