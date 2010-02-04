package com.breaktrycatch.lib.display;

import java.awt.Rectangle;
import java.awt.geom.Point2D;
import java.util.ArrayList;
import java.util.Collection;

import megamu.shapetween.Shaper;
import megamu.shapetween.Tween;

import org.jbox2d.p5.PhysicsUtils;

import processing.core.PApplet;

public class DisplayObject extends ArrayList<DisplayObject>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private ArrayList<ITween> _activeTweens;
	public float x;
	public float y;
	public float width;
	public float height;
	public float scaleX = 1;
	public float scaleY = 1;
	public float rotationRad = 0;
	public boolean isHuman = false;
	
	private PApplet _app;
	private DisplayObject _parent;
	private boolean _rotateAroundCenter;
	private ArrayList<DisplayObject> _removeList;
	protected ArrayList<ItemToAdd> _addList;

	private boolean _scaleAroundCenter;

	public DisplayObject(PApplet app)
	{
		_app = app;
		_activeTweens = new ArrayList<ITween>();
		_removeList = new ArrayList<DisplayObject>();
		_addList = new ArrayList<ItemToAdd>();
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
		
		if (getScaleAroundCenter())
		{
			getApp().translate(width / 2, height / 2);
		}
		getApp().scale(scaleX, scaleY);
		if (getScaleAroundCenter())
		{
			getApp().translate(-width / 2, -height / 2);
		}
		
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

		executeAdds();
		executeRemoves();
	}

	// TODO: Make abstract?
	public void dispose()
	{

	}
	
	private void executeRemoves()
	{
		for (DisplayObject item : _removeList)
		{
			super.remove(item);
		}
		_removeList.clear();
	}

	private void executeAdds()
	{
		for (ItemToAdd item : _addList)
		{
			if(item.index == -1)
			{
				super.add(item.element);
			}
			else
			{
				super.add(item.index, item.element);
			}
			
		}
		_addList.clear();
	}

	private void addToRemovalList(DisplayObject item)
	{
		item.setParent(null);
		if(_addList.contains(item))
		{
			_addList.remove(item);
		}
		_removeList.add(item);
	}
	
	private void addToAddList(DisplayObject item, int index)
	{
		item.setParent(this);
		if(_removeList.contains(item))
		{
			_removeList.remove(item);
		}
		
		_addList.add(new ItemToAdd(item, index));
	}
	
	private void addToAddList(DisplayObject item)
	{
		addToAddList(item, -1);
	}

	@Override
	public boolean remove(Object o)
	{
		DisplayObject item = (DisplayObject) o;
		if (contains(o))
		{
			addToRemovalList(item);
			return true;
		}
		return false;
	}

	@Override
	public DisplayObject remove(int index)
	{
		get(index).dispose();
		DisplayObject item = get(index);
		addToRemovalList(item);
		return item;
	}

	@Override
	public void clear()
	{
		for (DisplayObject child : this)
		{
			child.dispose();
			addToRemovalList(child);
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
	public boolean add(DisplayObject item)
	{
		addToAddList(item);
		return true;
	}

	@Override
	public void add(int index, DisplayObject item)
	{
		addToAddList(item, index);
	}

	@Override
	public boolean addAll(Collection<? extends DisplayObject> c)
	{
		for (DisplayObject item : c)
		{
			addToAddList(item);
		}
		return true;
	}

	@Override
	public boolean addAll(int index, Collection<? extends DisplayObject> c)
	{
		for (DisplayObject item : c)
		{
			addToAddList(item);
		}
		return true;
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
	

	public void setScaleAroundCenter(boolean scaleAroundCenter)
	{
		_scaleAroundCenter = scaleAroundCenter;
	}

	public boolean getScaleAroundCenter()
	{
		return _scaleAroundCenter;
	}

	public Rectangle getBounds()
	{
		return new Rectangle((int) x, (int) y, (int) (width * scaleX), (int) (height * scaleY));
	}
	
	public float getRotationDeg()
	{
		return PhysicsUtils.radToDeg(rotationRad);
	}
	
	public void setRotationDeg(float deg)
	{
		rotationRad = PhysicsUtils.degToRad(deg);
	}
	
	public Point2D.Float localToGlobal()
	{
		if(getParent() != null)
		{
			Point2D.Float parent = getParent().localToGlobal();
			return new Point2D.Float(x + parent.x, y + parent.y);
		}
		else
		{
			return new Point2D.Float(x, y);
		}
	}
}

class ItemToAdd
{
	public DisplayObject element;
	public int index = -1;

	public ItemToAdd(DisplayObject item, int index)
	{
		this.element = item;
		this.index = index;
	}

	public ItemToAdd(DisplayObject item)
	{
		this.element = item;
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
	private float _targetX;
	private float _targetY;
	private float _startX;
	private float _startY;

	private void init(PApplet app, DisplayObject target, float x, float y)
	{
		_target = target;

		_startX = target.x;
		_startY = target.y;

		_targetX = x;
		_targetY = y;
	}

	public SlideTo(PApplet app, DisplayObject target, float x, float y, float duration, Class<Shaper> shape)
	{
		init(app, target, x, y);
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public SlideTo(PApplet app, DisplayObject target, float x, float y, float duration)
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

		_startRotation = target.rotationRad;
		_targetRotation = rot;
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
