package com.breaktrycatch.needmorehumans.tracing;

public class PixelVO {
	
	public int id;
	
	public int x;
	public int y;
	
	public int index;
	
	public double distanceFromPreciseCenter;
	public double angle;
	
	public PixelVO prev;
	public PixelVO next;
	public boolean marked;
	public boolean rendered;
	public boolean saveFromSimpleCulling;
	
	public PixelVO(int _x, int _y, int _index) {
		x = _x;
		y = _y;
		index = _index;
		marked = false;
		rendered = false;
		saveFromSimpleCulling = false;
	}
}
