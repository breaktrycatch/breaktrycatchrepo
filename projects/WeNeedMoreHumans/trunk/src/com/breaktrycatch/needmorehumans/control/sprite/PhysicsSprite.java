package com.breaktrycatch.needmorehumans.control.sprite;

import org.jbox2d.collision.ShapeDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.ImageFrame;

public class PhysicsSprite extends ImageFrame
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	protected ShapeDef[] _physDef;
	private Body _body;

	public PhysicsSprite(PApplet app, Body body, PImage img)
	{
		super(app, img);
		_body = body;
	}

	@Override
	public void draw()
	{

		Vec2 bodyPosition = _body.getPosition();
		float bodyRotation = _body.getAngle();

		x = (int)bodyPosition.x * 100;
		y = (int)bodyPosition.y * 100;
		rotation = bodyRotation;

		super.draw();
	}
	
	public ShapeDef[] getPhysDef()
	{
		return _physDef;
	}

	public void setPhysDef(ShapeDef[] physDef)
	{
		_physDef = physDef;
	}

	public boolean isPhysDefSet()
	{
		return _physDef != null && _physDef.length > 0;
	}

}
