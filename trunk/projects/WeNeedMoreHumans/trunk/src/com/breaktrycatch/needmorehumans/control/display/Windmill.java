package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;

import org.jbox2d.p5.PhysicsUtils;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;

public class Windmill extends DisplayObject
{

	private ImageFrame _windmillBase;
	private ImageFrame _windmillBlades;

	private float _rotationSpeed = 4;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public Windmill(PApplet app)
	{
		super(app);

		_windmillBase = new ImageFrame(app, app.loadImage("../data/world/windmill-base.png"));
		_windmillBlades = new ImageFrame(app, app.loadImage("../data/world/windmill-blades.png"));
		_windmillBlades.x = -80;
		_windmillBlades.y = -100;
		_windmillBlades.setRotateAroundCenter(true);
		_windmillBlades.rotationRad = PhysicsUtils.degToRad((float)Math.random() * 360);
		_rotationSpeed = PhysicsUtils.degToRad(2 + (float)Math.random() * 4);
		add(_windmillBase);
		add(_windmillBlades);

		width = (_windmillBase.width > _windmillBlades.width) ? (_windmillBase.width) : (_windmillBlades.width);
		height = (_windmillBase.height > _windmillBlades.height) ? (_windmillBase.height) : (_windmillBlades.height);
		
		scaleX = scaleY = .65f;
	}
	
	@Override
	public Rectangle getBounds()
	{
		return _windmillBase.getBounds().union(_windmillBlades.getBounds());
	}

	@Override
	public void draw()
	{
		super.draw();

		_windmillBlades.rotationRad -= _rotationSpeed;
	}

	public void setRotationSpeed(float _rotationSpeed)
	{
		this._rotationSpeed = _rotationSpeed;
	}

	public float gRotationSpeed()
	{
		return _rotationSpeed;
	}

}
