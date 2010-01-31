package com.breaktrycatch.needmorehumans.view;

import org.jbox2d.common.MathUtils;

import processing.core.PApplet;
import toxi.geom.Vec2D;

import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.util.callback.IFloatCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.sprite.PhysicsSprite;
import com.esotericsoftware.controller.device.Axis;

public class InputTestView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final int MAX_VEL = 10;

	private PhysicsSprite _frame;
	private Vec2D _velocity;
	private float _rotation;

	public InputTestView()
	{

	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		_velocity = new Vec2D();
		_frame = new PhysicsSprite(app, app.loadImage("../data/tracing/RealPerson_1.png"));
		_frame.setRotateAroundCenter(true);
		add(_frame);
	}

	@Override
	public void draw()
	{
		super.draw();

		XBoxControllerManager manager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);

		manager.registerAxis(Axis.leftTrigger, new IFloatCallback()
		{
			public void execute(float value)
			{
				PApplet.println("LEFT TRIGGER " + value);
				_rotation += value;
				_rotation = MathUtils.clamp(_rotation, -1, 1);
			}
		});
		manager.registerAxis(Axis.rightTrigger, new IFloatCallback()
		{
			public void execute(float value)
			{
				_rotation -= value;
				_rotation = MathUtils.clamp(_rotation, -1, 1);
			}
		});

		manager.registerAxis(Axis.leftStickX, new IFloatCallback()
		{
			public void execute(float value)
			{
				_velocity.x += value;
				_velocity.x = MathUtils.clamp(_velocity.x, -MAX_VEL, MAX_VEL);
			}
		});

		manager.registerAxis(Axis.leftStickY, new IFloatCallback()
		{
			public void execute(float value)
			{
				_velocity.y += value;
				_velocity.y = MathUtils.clamp(_velocity.y, -MAX_VEL, MAX_VEL);
			}
		});

		_rotation *= .9;
		_frame.rotationRad -= _rotation;

		_velocity.x *= .9;
		_velocity.y *= .9;
		_frame.x += _velocity.x;
		_frame.y -= _velocity.y;
	}
}
