package com.breaktrycatch.needmorehumans.tracing.earClipping;

import processing.core.PApplet;

public class EarClipping {
	
	private Triangulation tri;
	
	public EarClipping() {
		tri = new Triangulation();
	}
	
	
	public Triangle[] createTriangles(float x[], float y[], int _numVertices) {
		
		Triangle[] triangulated = tri.triangulatePolygon(x,y,_numVertices);
		
		return triangulated;
	}
	
	public Polygon[] createPolys(Triangle[] triangulated) {
		
		Polygon[] polys = tri.polygonizeTriangles(triangulated);
//		if (triangulated != null){
//			for (int i=0; i<polys.length; i++){
//				if (polys[i] != null) {
//					polys[i].draw();
//				}
//		    }
//		}
		
		return polys;
		
		//stroke(255);
		  //for (int i=0; i<numVertices; i++){
		    //if (i<numVertices-1) line(x[i],y[i],x[i+1],y[i+1]);
		   // else line(x[i],y[i],x[0],y[0]);
	//		    if (isEar(i,x,y)) ellipse(x[i],y[i],4,4);
		 // }
	}
	


}
