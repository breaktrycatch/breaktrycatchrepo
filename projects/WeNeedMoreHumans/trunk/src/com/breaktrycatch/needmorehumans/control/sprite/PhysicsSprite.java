package com.breaktrycatch.needmorehumans.control.sprite;

import org.jbox2d.collision.ShapeDef;

import com.breaktrycatch.lib.display.DisplayObject;

public abstract class PhysicsSprite extends Sprite {

	protected ShapeDef[] _physDef;
	
	protected PhysicsSprite(DisplayObject display) {
		super(display);
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
