package com.breaktrycatch.needmorehumans.model;

import org.jbox2d.common.Vec2;


public class PolyVO {

	protected Vec2[] _points;
	
	public PolyVO(int capacity) {
		_points = new Vec2[capacity];
	}
	
	public void addVertexAt(Vec2 vec, int index)
	{
		_points[index] = vec;
	}
	
	public float getCapacity()
	{
		return _points.length;
	}
	
	public Vec2 getVertex(int index)
	{
		return _points[index];
	}

}
