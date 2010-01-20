package com.breaktrycatch.needmorehumans.tracing.polyTool;

import java.util.ArrayList;
import java.util.Collections;

import com.breaktrycatch.needmorehumans.tracing.PixelVO;

public class GrahamScan {

	public GrahamScan() {
		
		
	}
	
	/**
	*  Returns a convex hull given an unordered array of points.
	*/
	public ArrayList<PixelVO> convexHull(ArrayList<PixelVO> data)
	{
		return findHull( order(data) );
	}
	
	/**
	*  Orders an array of points counterclockwise.
	*/
	public ArrayList<PixelVO> order(ArrayList<PixelVO> data)
	{
		//trace("GrahamScan::order()");
		// first run through all the points and find the upper left [lower left]
		PixelVO p = data.get(0);
		int n = data.size();
		for (int i = 0; i < n; i++)
		{
			if(data.get(i).y < p.y)
			{
				p = data.get(i);
			}
			else if(data.get(i).y == p.y && data.get(i).x < p.x)
			{
				p = data.get(i);
			}
		}
		// next find all the cotangents of the angles made by the point P and the
		// other points
		ArrayList<GObject> sorted = new ArrayList<GObject>();
		// we need arrays for positive and negative values, because Array.sort
		// will put sort the negatives backwards.
		ArrayList<GObject> pos = new ArrayList<GObject>();
		ArrayList<GObject> neg = new ArrayList<GObject>();
		// add points back in order
		for (int i = 0; i < n; i++) {
			float a = data.get(i).x - p.x;
			float b = data.get(i).y - p.y;
			float cot = b/a;
			if(cot < 0) {
				neg.add(new GObject(data.get(i), cot));
			}
			else {
				pos.add(new GObject(data.get(i), cot));
			}
		}
		// sort the arrays
		
		Collections.sort(pos);
		Collections.sort(neg);
		
		//untyped pos.sortOn("cotangent", Array.NUMERIC | Array.DESCENDING);
		//untyped neg.sortOn("cotangent", Array.NUMERIC | Array.DESCENDING);
//		pos.sort(function(x,y){
//			return x.cotangent - y.cotangent;
//		});
//		neg.sort(function(x,y):Int{
//			return x.cotangent - y.cotangent;
//		});
		
		//Add all the negatives
		for (int i = 0; i < neg.size(); i++) {
			sorted.add(neg.get(i));
		}
		//And now the positives
		for (int i = 0; i < pos.size(); i++) {
			sorted.add(pos.get(i));
		}
		
		ArrayList<PixelVO> ordered  = new ArrayList<PixelVO>();
		ordered.add(p);
		for (int i = 0; i < n; i++)
		{
			if(p == sorted.get(i).point) {
				continue;
			}
			ordered.add(sorted.get(i).point);
		}
		return ordered;
	}
	/**
	*  Given and array of points ordered counterclockwise, findHull will
	*  filter the points and return an array containing the vertices of a
	*  convex polygon that envelopes those points.
	*/
	public ArrayList<PixelVO> findHull(ArrayList<PixelVO> data)
	{
		//trace("GrahamScan::findHull()");
		int n = data.size();
		ArrayList<PixelVO> hull = new ArrayList<PixelVO>();
		hull.add(data.get(0)); // add the pivot
		hull.add(data.get(1)); // makes first vector
		
		for (int i = 2; i < n; i++)
		{
			while(direction(hull.get(hull.size() - 2), hull.get(hull.size() - 1), data.get(i)) > 0) {
				hull.remove(hull.size() - 1);
			}
			hull.add(data.get(i));
		}
		
		return hull;
	}
	/**
	*
	*/
	private float direction(PixelVO p1, PixelVO p2, PixelVO p3)
	{
		// > 0  is right turn
		// == 0 is collinear
		// < 0  is left turn
		// we only want right turns, usually we want right turns, but
		// flash's grid is flipped on y.
		return (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
	}

}
