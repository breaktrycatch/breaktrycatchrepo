package com.breaktrycatch.needmorehumans.tracing;

import processing.core.PApplet;
import processing.core.PVector;

public class EdgeVO {
	
	public PixelVO p1;
	public PixelVO p2;
	
	public double length;
	
	public boolean markForCulling;
	
	public EdgeVO(PixelVO _p1, PixelVO _p2) {
		p1 = _p1;
		p2 = _p2;
		markForCulling = false;
		//PApplet.println("New EDGE " + p1.x + " " + p1.y + " p2 " + p2.x + " " + p2.y);
		updateLength();
	}
	
	public void updateLength() {
		length = Math.sqrt(Math.pow((p1.x - p2.x), 2) + Math.pow((p1.y - p2.y), 2));
		//PApplet.println(length);
	}
	
	public PVector getVector() {
		return new PVector(p2.x-p1.x, p2.y-p1.y);
	}

}
