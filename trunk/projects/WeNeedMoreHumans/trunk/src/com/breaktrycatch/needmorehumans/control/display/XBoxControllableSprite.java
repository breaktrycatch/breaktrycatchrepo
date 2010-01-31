package com.breaktrycatch.needmorehumans.control.display;

import org.jbox2d.common.MathUtils;

import processing.core.PApplet;
import toxi.geom.Vec2D;

import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.Sprite;
import com.breaktrycatch.lib.util.callback.IFloatCallback;
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

	public XBoxControllableSprite(PApplet app)
	{
		super(app);

		_velocity = new Vec2D();
		XBoxControllerManager manager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);

		manager.registerAxis(Axis.leftTrigger, new IFloatCallback()
		{
			public void execute(float value)
			{
				_updatedRot = true;
				_rotation += value;
				_rotation = MathUtils.clamp(_rotation, -MAX_ROT, MAX_ROT);
			}
		});
		manager.registerAxis(Axis.rightTrigger, new IFloatCallback()
		{
			public void execute(float value)
			{
				_updatedRot = true;
				_rotation -= value;
				_rotation = MathUtils.clamp(_rotation, -MAX_ROT, MAX_ROT);
			}
		});

		manager.registerAxis(Axis.leftStickX, new IFloatCallback()
		{
			public void execute(float value)
			{
				_updatedVel = true;
				_velocity.x += value;
				_velocity.x = MathUtils.clamp(_velocity.x, -MAX_VEL, MAX_VEL);
			}
		});

		manager.registerAxis(Axis.leftStickY, new IFloatCallback()
		{
			public void execute(float value)
			{
				_updatedVel = true;
				_velocity.y += value;
				_velocity.y = MathUtils.clamp(_velocity.y, -MAX_VEL, MAX_VEL);
			}
		});
	}

	@Override
	public void draw()
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

		super.draw();
	}

}
