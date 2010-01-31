package com.breaktrycatch.lib.display;

import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.Collection;

import org.jbox2d.p5.PhysicsUtils;

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
	public float scaleX = 1;
	public float scaleY = 1;
	public float rotationRad = 0;

	private PApplet _app;
	private DisplayObject _parent;
	private boolean _rotateAroundCenter;

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

	public void rotateTo(float rot, float duration)
	{
		_activeTweens.add(new SlideTo(getApp(), this, x, y, duration));
	}

	public void rotateTo(float rot, float duration, Class<Shaper> shape)
	{
		_activeTweens.add(new SlideTo(getApp(), this, x, y, duration, shape));
	}

	public void preDraw()
	{
		getApp().pushMatrix();

		getApp().translate(x, y);
		getApp().scale(scaleX, scaleY);
		if (getRotateAroundCenter())
		{
			getApp().translate(width / 2, height / 2);
		}
		getApp().rotate(rotationRad);
		if (getRotateAroundCenter())
		{
			getApp().translate(-width / 2, -height / 2);
		}

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
			child.drawChildren();
			child.postDraw();
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

	public void setRotateAroundCenter(boolean _rotateAroundCenter)
	{
		this._rotateAroundCenter = _rotateAroundCenter;
	}

	public boolean getRotateAroundCenter()
	{
		return _rotateAroundCenter;
	}

	public Rectangle getBounds()
	{
		return new Rectangle(x, y, (int) (width * scaleX), (int) (height * scaleY));
	}
	
	public float getRotationDeg()
	{
		return PhysicsUtils.radToDeg(rotationRad);
	}
	
	public void setRotationDeg(float deg)
	{
		rotationRad = PhysicsUtils.degToRad(deg);
	}
}

interface ITween
{
	public void update();

	public boolean isComplete();
}

class AbstractTween
{

	protected Tween _tween;
	protected DisplayObject _target;

	public boolean isComplete()
	{
		return !_tween.isTweening();
	}
}

class SlideTo extends AbstractTween implements ITween
{
	private int _targetX;
	private int _targetY;
	private int _startX;
	private int _startY;

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

class RotateTo extends AbstractTween implements ITween
{
	private float _targetRotation;
	private float _startRotation;

	private void init(PApplet app, DisplayObject target, float rot)
	{
		_target = target;

		_targetRotation = target.rotationRad;
		_startRotation = rot;
	}

	public RotateTo(PApplet app, DisplayObject target, float rot, float duration, Class<Shaper> shape)
	{
		init(app, target, rot);
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public RotateTo(PApplet app, DisplayObject target, float rot, float duration)
	{
		init(app, target, rot);
		_tween = new Tween(app, duration, Tween.SECONDS);
	}

	public void update()
	{
		if (_tween.isTweening())
		{
			float amt = _tween.time() * _tween.position();
			_target.rotationRad = _startRotation + ((_targetRotation - _startRotation) * amt);
		}
	}
}
