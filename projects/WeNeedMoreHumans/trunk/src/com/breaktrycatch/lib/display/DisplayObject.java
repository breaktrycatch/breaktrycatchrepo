package com.breaktrycatch.lib.display;

import java.awt.Point;
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
	private int _x;
	private int _y;
	private int _width;
	private int _height;
	private float _rotation;
	
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

	public void draw()
	{
		//TODO: Test this shiz!
//		float shiftX = getX() + (getWidth()/2);
//		float shiftY = getY() + (getHeight()/2);
		//Set rotation for drawing
//		getApp().translate(shiftX, shiftY);
//		getApp().rotate(_rotation);
		
		for (int i = _activeTweens.size() - 1; i >= 0; i--)
		{
			ITween tween = _activeTweens.get(i);
			tween.update();

			if (tween.isComplete())
			{
				_activeTweens.remove(i);
			}
		}
		
		//Unset Rotation
//		getApp().rotate(-_rotation);
//		getApp().translate(-shiftX, -shiftY);
		
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

	public int getX()
	{
		if (getParent() != null)
		{
			return getParent()._x + _x;
		} else
		{
			return _x;
		}
	}

	public int getY()
	{
		if (getParent() != null)
		{
			return getParent()._y + _y;
		} else
		{
			return _y;
		}
	}
	
	public float getRotation()
	{
		return _rotation;
	}

	public void setX(int x)
	{
		this._x = x;
	}

	public void setY(int y)
	{
		this._y = _x;
	}
	
	public void setRotation(float radians)
	{
		_rotation = radians;
	}

	public int getWidth()
	{
		return _width;
	}

	public int getHeight()
	{
		return _height;
	}

	public void setWidth(int width)
	{
		this._width = width;
	}

	public void setHeight(int height)
	{
		this._height = height;
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

		_startX = target.getX();
		_startY = target.getY();

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

			_target.setX(_startX + (int) ((_targetX - _startX) * amt));
			_target.setY(_startY + (int) ((_targetY - _startY) * amt));
		}
	}

	public boolean isComplete()
	{
		return !_tween.isTweening();
	}
}
