package com.breaktrycatch.needmorehumans.tracing;

public class PixelVO {
	
	public int id;
	
	public float x;
	public float y;
	
	public int index;
	
	public double distanceFromPreciseCenter;
	public double angle;
	
	public PixelVO prev;
	public PixelVO next;
	public boolean marked;
	public boolean rendered;
	public boolean saveFromSimpleCulling;
	
	public boolean isExtremity;
	
	
	public PixelVO(float _x, float _y, int _index) {
		x = _x;
		y = _y;
		index = _index;
		marked = false;
		rendered = false;
		saveFromSimpleCulling = false;
		isExtremity = false;
		
	}
}
