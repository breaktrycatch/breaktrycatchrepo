package com.breaktrycatch.needmorehumans.tracing.polyTool;

import java.util.ArrayList;

import com.breaktrycatch.needmorehumans.tracing.PixelVO;

public class DObject {
 
	public boolean Intersects;
	public boolean start_inside;
	public boolean end_inside;
	public ArrayList<PixelVO> Intersections;
	public PixelVO centroid;
	
	public DObject(boolean _intersects, ArrayList<PixelVO> _intersections, boolean _start_inside,  boolean _end_inside) {
		Intersects = _intersects;
		Intersections = _intersections;
		start_inside = _start_inside;
		end_inside = _end_inside;
	}
}
