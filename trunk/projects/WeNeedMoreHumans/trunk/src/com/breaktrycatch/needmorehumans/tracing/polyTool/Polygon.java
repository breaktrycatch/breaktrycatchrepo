package com.breaktrycatch.needmorehumans.tracing.polyTool;

import java.util.ArrayList;

public class Polygon {

	public int nVertices;
	public ArrayList<Float> x;
	public ArrayList<Float> y;
	
	
	public Polygon(ArrayList<Float>_x, ArrayList<Float> _y) {
		/* if(_y == null) {
		_y = _x.y;
		_x = _x.x;
		} */
		
		nVertices = _x.size();
		
		x = new ArrayList<Float>();
		y = new ArrayList<Float>();
		
		for (int i = 0; i <nVertices; i++) {
			x.add(i, _x.get(i));
			y.add(i, _y.get(i));
		}
	}
	
	
	
	public void set(Polygon p)
	{
		nVertices = p.nVertices;
		x = new ArrayList<Float>();
		y = new ArrayList<Float>();
		for (int i = 0; i <nVertices; i++) {
			x.add(i, p.x.get(i));
			y.add(i, p.y.get(i));
		}
	}
	
	/*
	 * Assuming the polygon is simple, checks
	 * if it is convex.
	 */
	public boolean isConvex()
	{
		boolean isPositive = false;
		for (int i = 0; i <nVertices; i++) {
			int lower = (i == 0)?(nVertices - 1):(i - 1);
			int middle = i;
			int upper = (i == nVertices - 1)?(0):(i + 1);
			float dx0 = x.get(middle) - x.get(lower);
			float dy0 = y.get(middle) - y.get(lower);
			float dx1 = x.get(upper)-x.get(middle);
			float dy1 = y.get(upper)-y.get(middle);
			float cross = dx0 * dy1 - dx1 * dy0;
			//Cross product should have same sign
			//for each vertex if poly is convex.
			boolean newIsP = (cross>0)?true:false;
			if (i == 0) {
				isPositive = newIsP;
			} else if (isPositive != newIsP){
				return false;
			}
		}
		return true;
	}

	/*
	 * Tries to add a triangle to the polygon.
	 * Returns null if it can't connect properly.
	 * Assumes bitwise equality of join vertices.
	 */
	public Polygon add(Triangle t)
	{
		//First, find vertices that connect
		int firstP = -1; 
		int firstT = -1;
		int secondP = -1; 
		int secondT = -1;
		
		int i = 0;
		
		for (i = 0; i <nVertices; i++) {
			if (t.x.get(0) == this.x.get(i) && t.y.get(0) == this.y.get(i)){
				if (firstP == -1){
					firstP = i; firstT = 0;
				} else{
					secondP = i; secondT = 0;
				}
			} else if (t.x.get(1) == this.x.get(i) && t.y.get(1) == this.y.get(i)) {
				if (firstP == -1){
					firstP = i; firstT = 1;
				} else{
					secondP = i; secondT = 1;
				}
			} else if (t.x.get(2) == this.x.get(i) && t.y.get(2) == this.y.get(i)){
				if (firstP == -1){
					firstP = i; firstT = 2;
				} else{
					secondP = i; secondT = 2;
				}
			} else {
				//println(t.x[0]+" "+t.y[0]+" "+t.x[1]+" "+t.y[1]+" "+t.x[2]+" "+t.y[2]);
				//println(x[0]+" "+y[0]+" "+x[1]+" "+y[1]);
			}
		}
		
		//Fix ordering if first should be last vertex of poly
		if (firstP == 0 && secondP == nVertices - 1) {
			firstP = nVertices-1;
			secondP = 0;
		}
		
		//Didn't find it
		if (secondP == -1) return null;
		
		//Find tip index on triangle
		int tipT = 0;
		if (tipT == firstT || tipT == secondT) tipT = 1;
		if (tipT == firstT || tipT == secondT) tipT = 2;
		
		ArrayList<Float> newx = new ArrayList<Float>();
		ArrayList<Float> newy = new ArrayList<Float>();
		int currOut = 0;
		
		for (i = 0; i <nVertices; i++) {
			newx.add(currOut, x.get(i));
			newy.add(currOut, y.get(i));
			if (i == firstP){
				++currOut;
				newx.add(currOut, t.x.get(tipT));
				newy.add(currOut,t.y.get(tipT));
			}
			++currOut;
		}
		return new Polygon(newx, newy);
	}

}
