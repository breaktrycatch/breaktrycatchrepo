package com.breaktrycatch.needmorehumans.tracing;

public class PixelDataVO {
	
	public int x;
	public int y;
	
	public int index;
	
	public double distanceFromPreciseCenter;
	public double angle;
	
	public PixelDataVO prev;
	public PixelDataVO next;
	public boolean marked;
	public boolean rendered;
	
	public PixelDataVO(int _x, int _y, int _index) {
		x = _x;
		y = _y;
		index = _index;
		marked = false;
		rendered = false;
	}
}
