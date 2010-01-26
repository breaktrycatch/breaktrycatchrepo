package com.breaktrycatch.needmorehumans.tracing.polyTool;

import java.util.ArrayList;

import com.breaktrycatch.needmorehumans.tracing.PixelVO;

public class PolyTool {

	public PolyTool() {
		// TODO Auto-generated constructor stub
		// PixelVO = Dynamic
	}
	
	// Originally posted as C code at http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
	public boolean isPolyConvex(ArrayList<PixelVO> p_poly) {
		int i;
		int j;
		int k;
		
		int flag = -1;
		
		float z;
		
		int n = p_poly.size();
		
		if (n < 3) {
			return false;
		}
		
		for (i = 0; i < n; i++) {
			j = (i + 1) % n;
			k = (i + 2) % n;
			z  = (p_poly.get(j).x - p_poly.get(i).x) * (p_poly.get(k).y - p_poly.get(j).y);
			z -= (p_poly.get(j).y - p_poly.get(i).y) * (p_poly.get(k).x - p_poly.get(j).x);
			if (z < 0) {
				flag |= 1;
			}
			else if (z > 0) {
				flag |= 2;
			}
			if (flag == 3) {
				return false;
			}
		}
		if (flag != 0) {
			return true;
		}
		else {
			return false;
		}
	}
	
	// Determine if an arbitrary polygon is winded clockwise
	public boolean isPolyClockwise(ArrayList<PixelVO> p_vertices)
	{
		int i;
		int j;
		int k;
		
		int count = 0;
		float z;
		
		if (p_vertices.size() < 3) {
			return false;
		}
		
		for (i = 0; i < p_vertices.size(); i++) {
			j = (i + 1) % p_vertices.size();
			k = (i + 2) % p_vertices.size();
			z  = (p_vertices.get(j).x - p_vertices.get(i).x) * (p_vertices.get(k).y - p_vertices.get(j).y);
			z -= (p_vertices.get(j).y - p_vertices.get(i).y) * (p_vertices.get(k).x - p_vertices.get(j).x);
			if (z < 0) {
				count--;
			}
			else if (z > 0) {
				count++;
			}
		}
		if (count > 0) {
			return false;
		}
		else if (count < 0) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public ArrayList<PixelVO> getConvexPoly(ArrayList<PixelVO> p_vertices)
	{
		GrahamScan grahamScan = new GrahamScan();
		return grahamScan.convexHull((ArrayList<PixelVO>)p_vertices.clone());
	}
	
	//SHOULD RETURN : Array<Array<Dynamic>>
	public ArrayList<ArrayList<PixelVO>> earClip(ArrayList<PixelVO> p_vertices)
	{
		// Touchmypixel's triangulator needs an array of points.
		ArrayList<PixelVO> points = new ArrayList<PixelVO>();
		for(int i = 0; i < p_vertices.size(); i++) {
			points.add(new PixelVO(p_vertices.get(i).x, p_vertices.get(i).y, -1));
		}
		ArrayList<Triangle> triangles = Triangulator.triangulatePolygon(points);
		ArrayList<Polygon> polys = Triangulator.polygonizeTriangles(triangles);
		
		// We want to return an Array<Array<Dynamic>>
		ArrayList<ArrayList<PixelVO>> polyArray = new ArrayList<ArrayList<PixelVO>>();
		if(polys != null) {
			for(int i = 0; i < polys.size() - 1; i++) { // The last poly seem to always be a copy of the next last one for some reason.
				ArrayList<PixelVO> poly = new ArrayList<PixelVO>();
				if(polys.get(i) != null) {
					for (int j = 0; j < polys.get(i).x.size(); j++) {
						poly.add(new PixelVO(polys.get(i).x.get(j), polys.get(i).y.get(j), -1));
					}
				}
				polyArray.add(poly);
			}
		} else {
			return null;
		}
		
		return polyArray;
	}
	
	public PixelVO getCentroid(ArrayList<PixelVO> p_pa)
	{
		
		float cx = 0;
		float cy = 0;
		
		PixelVO C = new PixelVO(0, 0, -1);
		
		// We don't want to modify the original array, so let's make a copy of the array and it's values
		ArrayList<PixelVO> pa = (ArrayList<PixelVO>) p_pa.clone();
		
		pa.add(pa.get(0));
		int n = pa.size()-1;
		while(n > -1){
			C = pa.get(n);
			if(n > 0){
				cx+=C.x;
				cy+=C.y;
			}
			n--;
		}
		
		return (new PixelVO(cx/(pa.size()-1), cy/(pa.size()-1), -1)); // Calculate the centroid
	}
	
	
	public float lengthOfLine(PixelVO p1 ,PixelVO p2)
	{
		float dx;
		float dy;

		dx = p2.x-p1.x;
		dy = p2.y-p1.y;
		return (float) Math.sqrt(dx*dx + dy*dy);
	}
	
	/**
	* Translate all vertices in p_poly by a factor of p_vector
	*/
	public ArrayList<PixelVO> translatePoly(ArrayList<PixelVO> p_poly, PixelVO p_vector)
	{
		ArrayList<PixelVO> translatedPoly = new ArrayList<PixelVO>();
		for(int i = 0; i < p_poly.size(); i++) {
			translatedPoly.add(new PixelVO(p_poly.get(i).x + p_vector.x, p_poly.get(i).y + p_vector.y, -1));
		}
		return translatedPoly;
	}
	
	public ArrayList<PixelVO> reverseArrayList(ArrayList<PixelVO> _array) {
		ArrayList<PixelVO> newArray = new ArrayList<PixelVO>();
		for (int i = _array.size() - 1; i>=0; i--) {
			newArray.add(_array.get(i));
		}
		return newArray;
	}
	
	/**
	* Cut out a piece of a polygon and return the remain piece.
	* subjectPoly is the poly being cut
	* cuttingPoly is the poly used for cutting
	* Will only work if the cutting poly contour is intersecting the subject poly contour.
	*/
	public ArrayList<PixelVO> cutPoly(ArrayList<PixelVO> p_subjectPoly, ArrayList<PixelVO> p_cuttingPoly)
	{
			
		ArrayList<PixelVO> resultingPoly = new ArrayList<PixelVO>();
		
		// Copy the original polygons so they don't get modified.
		ArrayList<PixelVO> subjectPolyCopy = (ArrayList<PixelVO>) p_subjectPoly.clone();
		ArrayList<PixelVO> cuttingPolyCopy = (ArrayList<PixelVO>) p_cuttingPoly.clone();
			
		// Add the first vertex at the end of the polygon.
		subjectPolyCopy.add(subjectPolyCopy.get(0));
		cuttingPolyCopy.add(cuttingPolyCopy.get(0));
			
		boolean isInside = false;
		boolean innerVerticesAdded = false;
		
		// First we need to make sure that vertex 0 of the cutting polygon is not inside the subject polygon
		// We'll do that by shifting the vertices until it is outside
		DObject vert0Check = lineIntersectPoly(cuttingPolyCopy.get(0), cuttingPolyCopy.get(1), subjectPolyCopy);
		while(vert0Check.start_inside || vert0Check.Intersects) {
			cuttingPolyCopy.add(0,cuttingPolyCopy.remove(cuttingPolyCopy.size() - 1));
			vert0Check = lineIntersectPoly(cuttingPolyCopy.get(0), cuttingPolyCopy.get(1), subjectPolyCopy);
		}
		
		// And then the same thing goes for the subject poly
		vert0Check = lineIntersectPoly(subjectPolyCopy.get(0), subjectPolyCopy.get(1), cuttingPolyCopy);
		while(vert0Check.start_inside || vert0Check.Intersects) {
			subjectPolyCopy.add(0,subjectPolyCopy.remove(subjectPolyCopy.size() - 1));
			vert0Check = lineIntersectPoly(subjectPolyCopy.get(0), subjectPolyCopy.get(1), cuttingPolyCopy);
		}
		
		// We want our polys to in oposite vertex order
		if(isPolyClockwise(subjectPolyCopy))
			subjectPolyCopy = reverseArrayList(subjectPolyCopy);
		if(!isPolyClockwise(cuttingPolyCopy))
			cuttingPolyCopy = reverseArrayList(cuttingPolyCopy);
		
		/* trace(isPolyClockwise(subjectPolyCopy));
		trace(isPolyClockwise(cuttingPolyCopy));
		
		p_dbgDraw.graphics.lineStyle(2, 0xFF0000);
		p_dbgDraw.graphics.moveTo(subjectPolyCopy[0].x, subjectPolyCopy[0].y);
		var wn:Int = 0;
		for(vertex in subjectPolyCopy) {
			p_dbgDraw.graphics.lineTo(vertex.x, vertex.y);
			var wntf:TextField = new TextField();
			untyped wntf.text=wn;
			wntf.width=15;
			wntf.height=15;
			wntf.x = vertex.x;
			wntf.y = vertex.y;
			p_dbgDraw.addChild(wntf);
			wn++;
		}
		
		p_dbgDraw.graphics.lineStyle(2, 0x0000FF);
		p_dbgDraw.graphics.moveTo(cuttingPolyCopy[0].x, cuttingPolyCopy[0].y);
		var wn:Int = 0;
		for(vertex in cuttingPolyCopy) {
			p_dbgDraw.graphics.lineTo(vertex.x, vertex.y);
			var wntf:TextField = new TextField();
			untyped wntf.text=wn;
			wntf.width=15;
			wntf.height=15;
			wntf.x = vertex.x;
			wntf.y = vertex.y;
			p_dbgDraw.addChild(wntf);
			wn++;
		} */
		
		// Check the subject poly for intersections with the cutting poly.
		// Add all vertices that are outside and the intersection points.
		for(int i=0; i < subjectPolyCopy.size(); i++) {
			if(i > 0) {
				DObject lip = lineIntersectPoly(subjectPolyCopy.get(i-1), subjectPolyCopy.get(i), cuttingPolyCopy);
				
				//if(p_dbgDraw!=null) {
					
					// Determine if the current vertex is inside or outside of the cuting poly
					if(!lip.start_inside && !lip.end_inside) isInside = false;
					else if(!lip.start_inside && lip.end_inside) isInside = true;
					else if(lip.start_inside && lip.end_inside) isInside = true;
					else if(lip.start_inside && !lip.end_inside) isInside = false;
					
					// if this is the first vertex outside, we'll add the intersection vertex before this vertex
					if(!isInside && lip.start_inside)
						resultingPoly.add(lip.Intersections.get(0));
					
					// Add vertices that are outside
					if(!isInside && !(lip.Intersects && !lip.start_inside && !lip.end_inside))
						resultingPoly.add(subjectPolyCopy.get(i));
					
					// If this is the first vertex inside, add the intersection vertex,
					// and then the vertices from the cutting poly that is inside the subject
					if((isInside && !lip.start_inside) || (lip.Intersects && !lip.start_inside && !lip.end_inside)) {
						if(!(lip.Intersects && !lip.start_inside && !lip.end_inside))
							resultingPoly.add(lip.Intersections.get(0));
						else
							resultingPoly.add(lip.Intersections.get(1));
						
						if(!innerVerticesAdded) {
							// Check intersections for the cutting poly, and add the vertices that are inside the subject
							boolean isInside2 = false;
							for(int j = 0; j < cuttingPolyCopy.size(); j++) {
								if(j > 0) {
									DObject lip2 = lineIntersectPoly(cuttingPolyCopy.get(j-1), cuttingPolyCopy.get(j), subjectPolyCopy);
									if(!lip2.start_inside && !lip2.end_inside) isInside2 = false;
									else if(!lip2.start_inside && lip2.end_inside) isInside2 = true;
									else if(lip2.start_inside && lip2.end_inside) isInside2 = true;
									else if(lip2.start_inside && !lip2.end_inside) isInside2 = false;
									// Add vertices that are inside
									if(isInside2)
										resultingPoly.add(cuttingPolyCopy.get(j));
								}
							}
							
							if((lip.Intersects && !lip.start_inside && !lip.end_inside)) {
								resultingPoly.add(lip.Intersections.get(0));
							}
							
							innerVerticesAdded = true;
						}
					}
					
					if((lip.Intersects && !lip.start_inside && !lip.end_inside))
						resultingPoly.add(subjectPolyCopy.get(i));
					
				}
			//}
		}
		
		return resultingPoly;
	}
	
	
	// Originally posted at http://keith-hair.net/blog/2008/08/04/find-Intersection-point-of-two-lines-in-as3/
	//---------------------------------------------------------------
	//Checks for Intersection of Segment if as_seg is true.
	//Checks for Intersection of Line if as_seg is false.
	//Return Intersection of Segment "AB" and Segment "EF" as a Dynamic
	//Return null if there is no Intersection
	//---------------------------------------------------------------
	public PixelVO lineIntersectLine(PixelVO A,PixelVO B, PixelVO E, PixelVO F, boolean as_seg)
	{
		PixelVO ip;
		float a1;
		float a2;
		float b1;
		float b2;
		float c1;
		float c2;
		
		a1= B.y-A.y;
		b1= A.x-B.x;
		c1= B.x*A.y - A.x*B.y;
		a2 = F.y - E.y;
		b2= E.x-F.x;
		c2= F.x*E.y - E.x*F.y;
		
		float denom = a1*b2 - a2*b1;
		if(denom == 0){
			return null;
		}
		ip = new PixelVO((b1*c2 - b2*c1)/denom,(a2*c1 - a1*c2)/denom, -1);
	 
		//---------------------------------------------------
		//Do checks to see if Intersection to endpoints
		//distance is longer than actual Segments.
		//Return null if it is with any.
		//---------------------------------------------------
		if(as_seg == true){
			if(lengthOfLine(ip, B) > lengthOfLine(A, B)){
				return null;
			}
			if(lengthOfLine(ip, A) > lengthOfLine(A, B)){
				return null;
			}	
			
			if(lengthOfLine(ip, F) > lengthOfLine(E, F)){
				return null;
			}
			if(lengthOfLine(ip, E) > lengthOfLine(E, F)){
				return null;
			}
		}
		return ip;
	}
	
	// Originally posted at http://keith-hair.net/blog/2008/08/04/find-Intersection-point-of-two-lines-in-as3/
	/*---------------------------------------------------------------------------
	Returns an Object with the following properties:
	intersects        -Boolean indicating if an intersection exists.
	start_inside      -Boolean indicating if Point A is inside of the polygon.
	end_inside       -Boolean indicating if Point B is inside of the polygon.
	intersections    -Array of intersection Points along the polygon.
	centroid          -A Point indicating "center of mass" of the polygon.
	 
	"pa" is an Array of Points.
	----------------------------------------------------------------------------*/
	public DObject lineIntersectPoly(PixelVO A, PixelVO B, ArrayList<PixelVO> p_pa)
	{
		int An = 1;
		int Bn = 1;
		PixelVO C;
		PixelVO D;
		PixelVO i;
		float cx = 0;
		float cy = 0;
		
		// We don't want to modify the original array, so let's make a copy of the array and it's values
		ArrayList<PixelVO> pa = (ArrayList<PixelVO>) p_pa.clone();
		
		DObject result = new DObject(false, new ArrayList<PixelVO>(), false, false);
		//pa.push(pa[0]);
		int n = pa.size()-1;
		while(n > -1){
			C = pa.get(n);
			if(n > 0){
				cx+=C.x;
				cy+=C.y;
				D = ( (pa.get(n-1) != null) ? pa.get(n-1) : pa.get(0) );
				i=lineIntersectLine(A,B,C,D, true);
				if(i != null){
					result.Intersections.add(i);
				}
				if(lineIntersectLine(A, new PixelVO(C.x+D.x, A.y, -1),C,D, true) != null){
					An++;
				}
				if(lineIntersectLine(B,new PixelVO(C.x+D.x, B.y, -1),C,D, true) != null){
					Bn++;
				}
			}
			n--;
		}
		if(An % 2 == 0){
			result.start_inside=true;
		}
		if(Bn % 2 == 0){
			result.end_inside=true;
		}
		result.centroid= new PixelVO(cx/(pa.size()-1), cy/(pa.size()-1), -1);
		result.Intersects = result.Intersections.size() > 0;
		return result;
	}
}
