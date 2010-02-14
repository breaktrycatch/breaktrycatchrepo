package com.breaktrycatch.needmorehumans.control.camera;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Float;

import megamu.shapetween.Shaper;
import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.utils.RectUtils;

public class Simple2DCamera
{
	private Rectangle _viewport;
	private Rectangle _bounds;
	private Rectangle _innerBounds;
	private Point _lastMousePos;
	private PApplet _app;

	private DisplayObject _tweenObj;

	/**
	 * Creates a new Simple2DCamera using the supplied view port as the camera's
	 * visible area.
	 * 
	 * @param app
	 *            The PApplet.
	 * @param viewport
	 *            A rectangle defining the camera's visible area.
	 * @param bounds
	 *            The bounding area for the camera. The camera will not view
	 *            anything outside this bounding rectangle.
	 */
	public Simple2DCamera(PApplet app, Rectangle viewport, Rectangle bounds)
	{
		_app = app;
		_viewport = viewport;
		_bounds = bounds;

		// the inner bounding rectangle of the camera if the scale is set to 1.
		_innerBounds = new Rectangle(bounds.x + viewport.width / 2, bounds.y + viewport.height / 2, bounds.width - viewport.width, bounds.height - viewport.height);

		_tweenObj = new DisplayObject(app);
		_tweenObj.scaleX = _tweenObj.scaleY = 1f;
	}

	/**
	 * Creates a new Simple2DCamera using the PApplet's dimensions as the view
	 * port.
	 * 
	 * @param app
	 *            The PApplet.
	 * @param bounds
	 *            The bounding area for the camera. The camera will not view
	 *            anything outside this bounding rectangle.
	 */
	public Simple2DCamera(PApplet app, Rectangle bounds)
	{
		this(app, new Rectangle(0, 0, app.width, app.height), bounds);
	}

	public void update()
	{
		// manually move the tween forward.
		_tweenObj.preDraw();
		_tweenObj.draw();
		_tweenObj.postDraw();

		if (_lastMousePos != null && _app.mousePressed)
		{
			_tweenObj.y -= _app.mouseY - _lastMousePos.y;
			_tweenObj.x -= _app.mouseX - _lastMousePos.x;
		} else
		{
			_lastMousePos = null;
		}
		_lastMousePos = new Point(_app.mouseX, _app.mouseY);
		updateInnerBounds();

		// make sure we can't go through the floor.
		if (_tweenObj.y > _innerBounds.y + _innerBounds.height)
		{
			_tweenObj.y = _innerBounds.y + _innerBounds.height;
		}

	}

	/**
	 * Centers the view port on the supplied object immediately.
	 * 
	 * @param obj
	 *            An object to look at.
	 */
	public void lookAt(DisplayObject obj)
	{
		lookAt(obj.getBounds());
	}

	/**
	 * Animates the view port to center on the supplied object over a duration
	 * (in seconds)
	 * 
	 * @param obj
	 *            An object to look at.
	 * @param duration
	 *            The duration of the animation.
	 * @param completeCallback
	 *            A callback to execute once the animation is complete.
	 */
	public void lookAt(DisplayObject obj, float duration, ISimpleCallback completeCallback)
	{
		lookAt(obj.getBounds(), duration, completeCallback);
	}

	/**
	 * Animates the view port to center on the supplied object over a duration
	 * (in seconds)
	 * 
	 * @param obj
	 *            An object to look at.
	 * @param duration
	 *            The duration of the animation.
	 */
	public void lookAt(DisplayObject obj, float duration)
	{
		lookAt(obj, duration, null);
	}

	public void lookAt(Rectangle rect, float duration, ISimpleCallback completeCallback)
	{
		_tweenObj.cancelTweens();

		float dScaleX = (float) _viewport.width / (float) rect.width;
		float dScaleY = (float) _viewport.height / (float) rect.height;
		float newScale = (dScaleX > dScaleY) ? dScaleY : dScaleX;

		_tweenObj.scaleTo(newScale, newScale, duration, Shaper.COSINE);
		_tweenObj.slideTo((int) (rect.x + rect.width / 2), (int) (rect.y + rect.height / 2), duration, Shaper.COSINE, completeCallback);
	}

	public void lookAt(Rectangle rect, float duration)
	{
		lookAt(rect, duration, null);
	}

	public void lookAt(Rectangle rect)
	{
		_tweenObj.cancelTweens();

		rect = RectUtils.fitIn(rect, _bounds);

		_tweenObj.x = rect.x + rect.width / 2;
		_tweenObj.y = rect.y + rect.height / 2;

		float dScaleX = (float) _viewport.width / (float) rect.width;
		float dScaleY = (float) _viewport.height / (float) rect.height;
		
		_tweenObj.scaleX = _tweenObj.scaleY = (dScaleX > dScaleY) ? dScaleY : dScaleX;

		updateInnerBounds();
	}

	/**
	 * Centers the view port on a point over a duration (in seconds);
	 * 
	 * @param x
	 * @param y
	 * @param duration
	 *            The duration of the animation.
	 * @param completeCallback
	 *            A callback to execute once the animation is complete.
	 */
	public void lookAt(float x, float y, float duration, ISimpleCallback completeCallback)
	{
		Float constrain = RectUtils.constrain(new Point2D.Float(x, y), _innerBounds);
		x = constrain.x;
		y = constrain.y;

		_tweenObj.cancelTweens();
		_tweenObj.slideTo((int) x, (int) y, duration, Shaper.COSINE, completeCallback);
	}

	/**
	 * Centers the view port on a point over a duration (in seconds);
	 * 
	 * @param x
	 * @param y
	 * @param duration
	 *            The duration of the animation.
	 */
	public void lookAt(float x, float y, float duration)
	{
		lookAt(x, y, duration, null);
	}

	/**
	 * Centers the view port on a point.
	 * 
	 * @param x
	 * @param y
	 */
	public void lookAt(float x, float y)
	{
		_tweenObj.cancelTweens();

		_tweenObj.x = x;
		_tweenObj.y = y;

		RectUtils.constrainDisplayObject(_tweenObj, _innerBounds);
	}

	/**
	 * Transforms a display object based on the camera's position and zoom.
	 * 
	 * @param obj
	 */
	public void setTransform(DisplayObject obj)
	{
		obj.setScaleAroundCenter(false);

		obj.x = (-_tweenObj.x - obj.width / 2) * _tweenObj.scaleX + _viewport.width / 2;
		obj.y = (-_tweenObj.y - obj.height / 2) * _tweenObj.scaleY + _viewport.height / 2;

		obj.scaleX = _tweenObj.scaleX;
		obj.scaleY = _tweenObj.scaleY;
	}

	private void updateInnerBounds()
	{
		updateInnerBounds(_tweenObj.scaleX, _tweenObj.scaleY);
	}

	private void updateInnerBounds(float newScaleX, float newScaleY)
	{
		// recalculate the inner bounds based on the camera zoom.
		_innerBounds.x = (int) (_bounds.x + (_viewport.width / 2) * (1 / newScaleX));
		_innerBounds.y = (int) (_bounds.y + (_viewport.height / 2) * (1 / newScaleY));

		_innerBounds.width = (int) (_bounds.width - (_viewport.width) * (1 / newScaleX));
		_innerBounds.height = (int) (_bounds.height - (_viewport.height) * (1 / newScaleY));
	}
}
