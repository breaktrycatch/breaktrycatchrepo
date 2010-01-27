package com.breaktrycatch.lib.display;

import java.util.ArrayList;
import java.util.Collection;

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
	public int width;
	public int height;
	public float rotation;

	private PApplet _app;
	private DisplayObject _parent;

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

	public void preDraw()
	{
		getApp().pushMatrix();
		getApp().rotate(rotation);
		getApp().translate(x, y);
	}

	public void postDraw()
	{
		getApp().popMatrix();
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
			child.preDraw();
			child.draw();
			child.postDraw();

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

	@Override
	public boolean add(DisplayObject e)
	{
		e.setParent(this);
		return super.add(e);
	}

	@Override
	public void add(int index, DisplayObject element)
	{
		element.setParent(this);
		super.add(index, element);
	}

	@Override
	public boolean addAll(Collection<? extends DisplayObject> c)
	{
		for (DisplayObject item : c)
		{
			item.setParent(this);
		}
		return super.addAll(c);
	}

	@Override
	public boolean addAll(int index, Collection<? extends DisplayObject> c)
	{
		for (DisplayObject item : c)
		{
			item.setParent(this);
		}
		return super.addAll(index, c);
	}

	public DisplayObject getParent()
	{
		return _parent;
	}

	public void setParent(DisplayObject parent)
	{
		_parent = parent;
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
