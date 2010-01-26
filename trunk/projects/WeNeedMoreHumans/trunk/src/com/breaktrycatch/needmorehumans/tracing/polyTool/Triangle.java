package com.breaktrycatch.needmorehumans.tracing.polyTool;

import java.util.ArrayList;

public class Triangle {

	public ArrayList<Float> x;
	public ArrayList<Float> y;
	
	public Triangle(float x1, float y1, float x2, float y2, float x3, float y3) {
		x = new ArrayList<Float>();
		y = new ArrayList<Float>();
		float dx1 = x2-x1;
		float dx2 = x3-x1;
		float dy1 = y2-y1;
		float dy2 = y3-y1;
		float cross = (dx1*dy2)-(dx2*dy1);
		boolean ccw = (cross>0);
		if (ccw){
			x.add(0, x1); x.add(1, x2); x.add(2, x3);
			y.add(0, y1); y.add(1, y2); y.add(2, y3);
		} else{
			x.add(0, x1); x.add(1, x3); x.add(2, x2);
			y.add(0, y1); y.add(1, y3); y.add(2, y2);
		}
	}
	
	
	
	public String toString() {
		return "{("+x.get(0)+","+y.get(0)+"), ("+x.get(1)+","+y.get(1)+"), ("+x.get(2)+","+y.get(2)+")}";
	}
	
	
	public boolean isInside(float _x, float _y){
		float vx2 = _x - x.get(0); 
		float vy2 = _y - y.get(0);
		float vx1 = x.get(1) - x.get(0); 
		float vy1 = y.get(1) - y.get(0);
		float vx0 = x.get(2) - x.get(0); 
		float vy0 = y.get(2) - y.get(0);
		
		float dot00 = vx0 * vx0 + vy0 * vy0;
		float dot01 = vx0 * vx1 + vy0 * vy1;
		float dot02 = vx0 * vx2 + vy0 * vy2;
		float dot11 = vx1 * vx1 + vy1 * vy1;
		float dot12 = vx1 * vx2 + vy1 * vy2;
		float invDenom = (float) (1.0 / (dot00 * dot11 - dot01 * dot01));
		float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
		
		return ((u > 0) && (v > 0) && (u + v < 1));
	}		
}
