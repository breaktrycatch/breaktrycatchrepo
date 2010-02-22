package com.breaktrycatch.lib.display;

import java.awt.Rectangle;
import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Float;
import java.util.ArrayList;
import java.util.Collection;

import megamu.shapetween.Tween;

import org.jbox2d.p5.PhysicsUtils;

import processing.core.PApplet;
import processing.core.PGraphics;

import com.breaktrycatch.lib.util.callback.ISimpleCallback;

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
	public float alpha = 1;
	public boolean visible = true;

	protected PGraphics _renderTarget;

	private PApplet _app;
	private DisplayObject _parent;
	private boolean _rotateAroundCenter;
	private ArrayList<DisplayObject> _removeList;
	private ArrayList<ItemToAdd> _addList;

	private boolean _scaleAroundCenter;

	// protected PGraphics externalRenderTarget;
	protected int externalRenderTargetOffsetX;
	protected int externalRenderTargetOffsetY;

	private Float _scalePoint;

	public DisplayObject(PApplet app)
	{
		setApp(app);

		_activeTweens = new ArrayList<ITween>();
		_removeList = new ArrayList<DisplayObject>();
		_addList = new ArrayList<ItemToAdd>();
	}

	public void enableExternalRenderTarget(PGraphics _externalRenderTarget, int _ertoX, int _ertoY)
	{
		_renderTarget = _externalRenderTarget;
		externalRenderTargetOffsetX = _ertoX;
		externalRenderTargetOffsetY = _ertoY;
	}

	public void disableExternalRenderTarget()
	{
		_renderTarget = _app.g;
	}

	public void scaleTo(float x, float y, float duration)
	{
		addTween(new ScaleTo(getApp(), this, x, y, duration));
	}

	public void scaleTo(float x, float y, float duration, Object shape)
	{
		addTween(new ScaleTo(getApp(), this, x, y, duration, shape));
	}

	public void scaleTo(float x, float y, float duration, Object shape, ISimpleCallback completeCallback)
	{
		addTween(new ScaleTo(getApp(), this, x, y, duration, shape, completeCallback));
	}

	public void slideTo(int x, int y, float duration)
	{
		addTween(new SlideTo(getApp(), this, x, y, duration));
	}

	public void slideTo(int x, int y, float duration, Object shape)
	{
		addTween(new SlideTo(getApp(), this, x, y, duration, shape));
	}

	public void slideTo(int x, int y, float duration, Object shape, ISimpleCallback completeCallback)
	{
		addTween(new SlideTo(getApp(), this, x, y, duration, shape, completeCallback));
	}

	public void rotateTo(float rot, float duration)
	{
		addTween(new RotateTo(getApp(), this, rot, duration));
	}

	public void rotateTo(float rot, float duration, Object shape)
	{
		addTween(new RotateTo(getApp(), this, rot, duration, shape));
	}

	public void rotateTo(float rot, float duration, Object shape, ISimpleCallback completeCallback)
	{
		addTween(new RotateTo(getApp(), this, rot, duration, shape, completeCallback));
	}
	
	public void alphaTo(float alpha, float duration)
	{
		addTween(new AlphaTo(getApp(), this, alpha, duration));
	}

	public void alphaTo(float alpha, float duration, Object shape)
	{
		addTween(new AlphaTo(getApp(), this, alpha, duration, shape));
	}

	public void alphaTo(float alpha, float duration, Object shape, ISimpleCallback completeCallback)
	{
		addTween(new AlphaTo(getApp(), this, alpha, duration, shape, completeCallback));
	}

	public void cancelTweens()
	{
		_activeTweens.clear();
	}

	private void addTween(ITween item)
	{
		for (int i = _activeTweens.size() - 1; i >= 0; i--)
		{
			ITween existing = _activeTweens.get(i);
			if (item.getClass() == existing.getClass())
			{
				_activeTweens.remove(i);
			}
		}

		_activeTweens.add(item);
	}

	private void updateTweens()
	{
		for (int i = _activeTweens.size() - 1; i >= 0; i--)
		{
			ITween tween = _activeTweens.get(i);
			tween.update();

			if (tween.isComplete())
			{
				_activeTweens.remove(i);
				tween.finalizeTween();
			}
		}
	}

	public void preDraw()
	{
		updateTweens();
		
		
		_renderTarget.pushMatrix();
		
		// get some performance back if we're not visible. We still need to pushMatrix
		// since if the DisplayObject's draw method toggles visiblity, we'll end up with
		// one more pop or push matrix than we need.
		if(visible)
		{
			_renderTarget.tint(255, alpha * 255);
			_renderTarget.translate(x, y);
			if (getScaleAroundPoint() != null)
			{
				Point2D.Float pt = getScaleAroundPoint();
				_renderTarget.translate(pt.x / 2, pt.y / 2);
				_renderTarget.scale(scaleX, scaleY);
				_renderTarget.translate(-pt.x / 2, -pt.y / 2);
			} else
			{
				if (getScaleAroundCenter())
				{
					_renderTarget.translate(width / 2, height / 2);
				}
				_renderTarget.scale(scaleX, scaleY);
				if (getScaleAroundCenter())
				{
					_renderTarget.translate(-width / 2, -height / 2);
				}
			}
	
			if (getRotateAroundCenter())
			{
				_renderTarget.translate(width / 2, height / 2);
			}
			_renderTarget.rotate(rotationRad);
			if (getRotateAroundCenter())
			{
				_renderTarget.translate(-width / 2, -height / 2);
			}
		}
	}

	public void postDraw()
	{
		_renderTarget.popMatrix();
	}

	public void draw()
	{
		// override!
	}

	public void drawChildren()
	{
		for (DisplayObject child : this)
		{
			child.preDraw();
			child.draw();
			if(visible)
			{
				child.drawChildren();
			}
			child.postDraw();
		}

		executeAdds();
		executeRemoves();
	}

	// TODO: Make abstract?
	public void dispose()
	{
		// override!
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
			if (item.index == -1)
			{
				super.add(item.element);
			} else
			{
				super.add(item.index, item.element);
			}

		}
		_addList.clear();
	}

	private void addToRemovalList(DisplayObject item)
	{
		item.setParent(null);
		if (_addList.contains(item))
		{
			_addList.remove(item);
		}
		_removeList.add(item);
	}

	private void addToAddList(DisplayObject item, int index)
	{
		item.setParent(this);
		if (_removeList.contains(item))
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
		_renderTarget = (app != null) ? (app.g) : (null);
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

	public void setScaleAroundPoint(Point2D.Float scalePoint)
	{
		_scalePoint = scalePoint;
	}

	public Point2D.Float getScaleAroundPoint()
	{
		return _scalePoint;
	}

	public Rectangle getBounds()
	{
		return new Rectangle((int) x, (int) y, (int) (width * scaleX), (int) (height * scaleY));
	}

	public Rectangle getScreenBounds()
	{
		Rectangle bounds = getBounds();
		Rectangle rec = new Rectangle();

		rec.x = bounds.x;
		rec.y = bounds.y;
		rec.width = (int) (bounds.width * Math.abs(Math.cos(rotationRad)) + bounds.height * Math.abs(Math.sin(rotationRad)));
		rec.height = (int) (bounds.height * Math.abs(Math.cos(rotationRad)) + bounds.width * Math.abs(Math.sin(rotationRad)));

		return rec;
	}

	public float getRotationDeg()
	{
		return PhysicsUtils.radToDeg(rotationRad);
	}

	public void setRotationDeg(float deg)
	{
		rotationRad = PhysicsUtils.degToRad(deg);
	}
	
	public void setVisibility(boolean visible)
	{
		for(DisplayObject child : this)
		{
			child.visible = visible;
		}
		this.visible = visible;
	}
	
	public Point2D.Float localToGlobal()
	{
		if (getParent() != null)
		{
			Point2D.Float parent = getParent().localToGlobal();
			return new Point2D.Float(x + parent.x, y + parent.y);
		} else
		{
			return new Point2D.Float(x, y);
		}
	}
	
	@Override
	public boolean equals(Object arg0)
	{
		return this == arg0;
	}

	public boolean isTweening()
	{
		return (_activeTweens.size() > 0);
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

	public void finalizeTween();
}

abstract class AbstractTween
{
	protected Tween _tween;
	protected DisplayObject _target;
	protected ISimpleCallback _completeCallback;

	public boolean isComplete()
	{
		return !_tween.isTweening();
	}

	protected float getTweenPosition()
	{
		return _tween.position();
	}

	public void finalizeTween()
	{
		if (_completeCallback != null)
		{
			_completeCallback.execute();
		}
	}

	abstract public void update();
}

class SlideTo extends AbstractTween implements ITween
{
	private float _targetX;
	private float _targetY;
	private float _startX;
	private float _startY;

	public SlideTo(PApplet app, DisplayObject target, float x, float y, float duration, Object shape, ISimpleCallback completeCallback)
	{
		_target = target;

		_startX = target.x;
		_startY = target.y;

		_targetX = x;
		_targetY = y;

		_completeCallback = completeCallback;
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public SlideTo(PApplet app, DisplayObject target, float x, float y, float duration, ISimpleCallback completeCallback)
	{
		this(app, target, x, y, duration, null, completeCallback);
	}

	public SlideTo(PApplet app, DisplayObject target, float x, float y, float duration, Object shape)
	{
		this(app, target, x, y, duration, shape, null);
	}

	public SlideTo(PApplet app, DisplayObject target, float x, float y, float duration)
	{
		this(app, target, x, y, duration, null, null);
	}

	public void update()
	{
		if (_tween.isTweening())
		{
			float amt = getTweenPosition();

			_target.x = _startX + (int) ((_targetX - _startX) * amt);
			_target.y = _startY + (int) ((_targetY - _startY) * amt);
		}
	}

	@Override
	public void finalizeTween()
	{
		_target.x = _targetX;
		_target.y = _targetY;
		super.finalizeTween();
	}
}

class ScaleTo extends AbstractTween implements ITween
{
	private float _targetX;
	private float _targetY;
	private float _startX;
	private float _startY;

	public ScaleTo(PApplet app, DisplayObject target, float x, float y, float duration, Object shape, ISimpleCallback completeCallback)
	{
		_target = target;

		_startX = target.scaleX;
		_startY = target.scaleY;

		_targetX = x;
		_targetY = y;

		_completeCallback = completeCallback;
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public ScaleTo(PApplet app, DisplayObject target, float x, float y, float duration, ISimpleCallback completeCallback)
	{
		this(app, target, x, y, duration, null, completeCallback);
	}

	public ScaleTo(PApplet app, DisplayObject target, float x, float y, float duration, Object shape)
	{
		this(app, target, x, y, duration, shape, null);
	}

	public ScaleTo(PApplet app, DisplayObject target, float x, float y, float duration)
	{
		this(app, target, x, y, duration, null, null);
	}

	public void update()
	{
		if (_tween.isTweening())
		{
			float amt = getTweenPosition();

			_target.scaleX = _startX + ((_targetX - _startX) * amt);
			_target.scaleY = _startY + ((_targetY - _startY) * amt);
		}
	}

	@Override
	public void finalizeTween()
	{
		_target.scaleX = _targetX;
		_target.scaleY = _targetY;
		super.finalizeTween();
	}
}

class RotateTo extends AbstractTween implements ITween
{
	private float _targetRotation;
	private float _startRotation;

	public RotateTo(PApplet app, DisplayObject target, float rot, float duration, Object shape, ISimpleCallback completeCallback)
	{
		_target = target;

		_startRotation = target.rotationRad;
		_targetRotation = rot;

		_completeCallback = completeCallback;
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public RotateTo(PApplet app, DisplayObject target, float rot, float duration, ISimpleCallback completeCallback)
	{
		this(app, target, rot, duration, null, completeCallback);
	}

	public RotateTo(PApplet app, DisplayObject target, float rot, float duration, Object shape)
	{
		this(app, target, rot, duration, shape, null);
	}

	public RotateTo(PApplet app, DisplayObject target, float rot, float duration)
	{
		this(app, target, rot, duration, null, null);
	}

	public void update()
	{
		if (_tween.isTweening())
		{
			float amt = getTweenPosition();
			_target.rotationRad = _startRotation + ((_targetRotation - _startRotation) * amt);
		}
	}

	@Override
	public void finalizeTween()
	{
		_target.rotationRad = _targetRotation;
		super.finalizeTween();
	}
}


class AlphaTo extends AbstractTween implements ITween
{
	private float _targetAlpha;
	private float _startAlpha;

	public AlphaTo(PApplet app, DisplayObject target, float alpha, float duration, Object shape, ISimpleCallback completeCallback)
	{
		_target = target;

		_startAlpha = target.alpha;
		_targetAlpha = alpha;

		_completeCallback = completeCallback;
		_tween = new Tween(app, duration, Tween.SECONDS, shape);
	}

	public AlphaTo(PApplet app, DisplayObject target, float alpha, float duration, ISimpleCallback completeCallback)
	{
		this(app, target, alpha, duration, null, completeCallback);
	}

	public AlphaTo(PApplet app, DisplayObject target, float alpha, float duration, Object shape)
	{
		this(app, target, alpha, duration, shape, null);
	}

	public AlphaTo(PApplet app, DisplayObject target, float alpha, float duration)
	{
		this(app, target, alpha, duration, null, null);
	}

	public void update()
	{
		if (_tween.isTweening())
		{
			float amt = getTweenPosition();
			_target.alpha = _startAlpha + ((_targetAlpha - _startAlpha) * amt);
		}
	}

	@Override
	public void finalizeTween()
	{
		_target.alpha = _targetAlpha;
		super.finalizeTween();
	}
}

