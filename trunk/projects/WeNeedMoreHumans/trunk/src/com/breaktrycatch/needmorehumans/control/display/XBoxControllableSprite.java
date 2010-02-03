package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;
import java.awt.geom.Point2D;

import org.jbox2d.common.MathUtils;

import processing.core.PApplet;
import toxi.geom.Vec2D;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.Sprite;
import com.breaktrycatch.lib.util.callback.IFloatCallback;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.utils.RectUtils;
import com.esotericsoftware.controller.device.Axis;

public class XBoxControllableSprite extends Sprite
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Vec2D _velocity;
	private float _rotation;
	private static final int MAX_VEL = 20;
	private static final float MAX_ROT = .2f;
	private boolean _updatedVel = false;
	private boolean _updatedRot = false;
	private boolean _enabled;
	private ISimpleCallback _updatedCallback;
	private Rectangle _scrollBounds;

	private final IFloatCallback leftTrigger = new IFloatCallback()
	{
		public void execute(float value)
		{
			_updatedRot = true;
			_rotation += value;
			_rotation = MathUtils.clamp(_rotation, -MAX_ROT, MAX_ROT);
		}
	};

	private final IFloatCallback rightTrigger = new IFloatCallback()
	{
		public void execute(float value)
		{
			_updatedRot = true;
			_rotation -= value;
			_rotation = MathUtils.clamp(_rotation, -MAX_ROT, MAX_ROT);
		}
	};

	private final IFloatCallback leftStickX = new IFloatCallback()
	{
		public void execute(float value)
		{
			_updatedVel = true;
			_velocity.x += value;
			_velocity.x = MathUtils.clamp(_velocity.x, -MAX_VEL, MAX_VEL);
		}
	};

	private final IFloatCallback leftStickY = new IFloatCallback()
	{
		public void execute(float value)
		{
			_updatedVel = true;
			_velocity.y += value;
			_velocity.y = MathUtils.clamp(_velocity.y, -MAX_VEL, MAX_VEL);
		}
	};

	private final ISimpleCallback keyboardForward = new ISimpleCallback()
	{
		public void execute()
		{
			leftStickY.execute(1f);
		}
	};

	private final ISimpleCallback keyboardBackward = new ISimpleCallback()
	{
		public void execute()
		{
			leftStickY.execute(-1f);
		}
	};

	private final ISimpleCallback keyboardLeft = new ISimpleCallback()
	{
		public void execute()
		{
			leftStickX.execute(-1f);
		}
	};

	private final ISimpleCallback keyboardRight = new ISimpleCallback()
	{
		public void execute()
		{
			leftStickX.execute(1f);
		}
	};

	private final ISimpleCallback keyboardRotateRight = new ISimpleCallback()
	{
		public void execute()
		{
			rightTrigger.execute(.3f);
		}
	};

	private final ISimpleCallback keyboardRotateLeft = new ISimpleCallback()
	{
		public void execute()
		{
			leftTrigger.execute(.3f);
		}
	};

	public XBoxControllableSprite(PApplet app)
	{
		super(app);

		_enabled = true;
		_rotation = 0;
		_velocity = new Vec2D();
		_scrollBounds = new Rectangle(-Integer.MAX_VALUE / 2, -Integer.MAX_VALUE / 2, Integer.MAX_VALUE, Integer.MAX_VALUE);

		enableListeners();
	}

	public void setUpdatedCallback(ISimpleCallback callback)
	{
		_updatedCallback = callback;
	}

	private void enableListeners()
	{
		XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);
		keyboardManager.registerKey('w', keyboardForward);
		keyboardManager.registerKey('s', keyboardBackward);

		keyboardManager.registerKey('a', keyboardLeft);
		keyboardManager.registerKey('d', keyboardRight);

		keyboardManager.registerKey('.', keyboardRotateRight);
		keyboardManager.registerKey(',', keyboardRotateLeft);

		controllerManager.registerAxis(Axis.leftTrigger, leftTrigger);
		controllerManager.registerAxis(Axis.rightTrigger, rightTrigger);

		controllerManager.registerAxis(Axis.leftStickX, leftStickX);
		controllerManager.registerAxis(Axis.leftStickY, leftStickY);
	}

	private void disableListeners()
	{
		XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);
		keyboardManager.unregisterKey('w', keyboardForward);
		keyboardManager.unregisterKey('s', keyboardBackward);

		keyboardManager.unregisterKey('a', keyboardLeft);
		keyboardManager.unregisterKey('d', keyboardRight);

		keyboardManager.unregisterKey('.', keyboardRotateRight);
		keyboardManager.unregisterKey(',', keyboardRotateLeft);

		controllerManager.unregisterAxis(Axis.leftTrigger, leftTrigger);
		controllerManager.unregisterAxis(Axis.rightTrigger, rightTrigger);

		controllerManager.unregisterAxis(Axis.leftStickX, leftStickX);
		controllerManager.unregisterAxis(Axis.leftStickY, leftStickY);
	}

	@Override
	public void draw()
	{
		if (_enabled)
		{
			float dampening = .7f;
			if (!_updatedRot)
			{
				_rotation *= dampening;
			}

			rotationRad -= _rotation;

			if (!_updatedVel)
			{
				_velocity.x *= dampening;
				_velocity.y *= dampening;
			}

			x += _velocity.x;
			y -= _velocity.y;

			_updatedVel = false;
			_updatedRot = false;

			if (_updatedCallback != null)
			{
				_updatedCallback.execute();
			}
		}

		super.draw();
	}

	public void enableController(boolean b)
	{
		if (b != _enabled)
		{
			_enabled = b;
			if (_enabled)
			{
				enableListeners();
			} else
			{
				disableListeners();
			}
		}
	}

	public void setScrollBounds(Rectangle bounds)
	{
		_scrollBounds = bounds;
	}

	public Rectangle getScrollBounds()
	{
		return _scrollBounds;
	}

	public void constrainToBounds()
	{
		if (_scrollBounds != null)
		{
			Point2D.Float pt = RectUtils.constrain(new Point2D.Float((int) x, (int) y), _scrollBounds);
			this.x = pt.x;
			this.y = pt.y;
		}
	}

}
