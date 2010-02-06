package com.breaktrycatch.needmorehumans.control.physics;

import org.jbox2d.common.Vec2;

import com.breaktrycatch.lib.display.DisplayObject;

public class PhysicsUserDataVO {

	public DisplayObject display;
	public Vec2[] extremities;
	public boolean isHuman = false;
	public boolean breaksHumanJoints = false;
	
	public PhysicsUserDataVO() {
		// TODO Auto-generated constructor stub
	}

}
