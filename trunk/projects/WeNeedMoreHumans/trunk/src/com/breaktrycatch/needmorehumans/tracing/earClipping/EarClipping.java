package com.breaktrycatch.needmorehumans.tracing.earClipping;

public class EarClipping {

	public EarClipping() {
		// TODO Auto-generated constructor stub
	}
	
	final int maxVertices = 2<<8;
	float x[] = new float[maxVertices];
	float y[] = new float[maxVertices];
	int numVertices = 0;
	
	if (mousePressed && !pmousePressed && numVertices < maxVertices){
	    x[numVertices] = mouseX; y[numVertices] = mouseY;
	    numVertices++;
	  }
	  
	  if (keyPressed && key == 'r'){
	    x = new float[maxVertices];
	    y = new float[maxVertices];
	    numVertices = 0;
	  }
	  

	
	Triangle[] triangulated = triangulatePolygon(x,y,numVertices);

	  Polygon[] polys = polygonizeTriangles(triangulated);
	  if (triangulated != null){
	    for (int i=0; i<polys.length; i++){
	      if (polys[i] != null) polys[i].draw();
	    }
	  }
	  stroke(255);
	  for (int i=0; i<numVertices; i++){
	    if (i<numVertices-1) line(x[i],y[i],x[i+1],y[i+1]);
	    else line(x[i],y[i],x[0],y[0]);
//	    if (isEar(i,x,y)) ellipse(x[i],y[i],4,4);
	  }


}
