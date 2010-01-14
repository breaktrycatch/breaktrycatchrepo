package com.breaktrycatch.needmorehumans.tracing;

public class EdgeVO {
	
	public PixelDataVO p1;
	public PixelDataVO p2;
	
	public double length;
	
	public EdgeVO(PixelDataVO _p1, PixelDataVO _p2) {
		p1 = _p1;
		p2 = _p2;
		
		length = Math.sqrt(Math.pow((p1.x - p2.x), 2) + Math.pow((p1.y - p2.y), 2));
	}

}
