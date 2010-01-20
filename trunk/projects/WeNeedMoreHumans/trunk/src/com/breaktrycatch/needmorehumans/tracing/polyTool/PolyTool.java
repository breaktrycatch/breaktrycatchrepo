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
		
		int flag;
		
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
	public boolean PixelVOPolyClockwise(ArrayList<PixelVO> p_vertices)
	{
		int i;
		int j;
		int k;
		
		int count;
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
		return grahamScan.convexHull((ArrayList<PixelVO>) p_vertices.subList(0, 1));
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
					for (int j = 0; j < polys.get(i).x.size(); i++) {
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
		ArrayList<PixelVO> pa = p_pa.slice(0);
		
		pa.push(pa[0]);
		int n = pa.length-1;
		while(n > -1){
			C = pa[n];
			if(n > 0){
				cx+=C.x;
				cy+=C.y;
			}
			n--;
		}
		
		return (new PixelVO(cx/(pa.size()-1), cy/(pa.size()-1, -1)); // Calculate the centroid
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
			translatedPoly.add(new PixelVO(p_poly.get(i).x + p_vector.x, p_poly.get(i).y + p_vector.y, -1);
		}
		return translatedPoly;
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
		ArrayList<PixelVO> subjectPolyCopy = p_subjectPoly.slice(0);
		ArrayList<PixelVO> cuttingPolyCopy = p_cuttingPoly.slice(0);
			
		// Add the first vertex at the end of the polygon.
		subjectPolyCopy.add(subjectPolyCopy.get(0));
		cuttingPolyCopy.add(cuttingPolyCopy.get(0));
			
		boolean isInside = false;
		boolean innerVerticesAdded = false;
		
		// First we need to make sure that vertex 0 of the cutting polygon is not inside the subject polygon
		// We'll do that by shifting the vertices until it is outside
		var vert0Check:Dynamic = lineIntersectPoly(cuttingPolyCopy[0], cuttingPolyCopy[1], subjectPolyCopy);
		while(vert0Check.start_inside || vert0Check.Intersects) {
			cuttingPolyCopy.insert(0,cuttingPolyCopy.pop());
			vert0Check = lineIntersectPoly(cuttingPolyCopy[0], cuttingPolyCopy[1], subjectPolyCopy);
		}
		
		// And then the same thing goes for the subject poly
		var vert0Check:Dynamic = lineIntersectPoly(subjectPolyCopy[0], subjectPolyCopy[1], cuttingPolyCopy);
		while(vert0Check.start_inside || vert0Check.Intersects) {
			subjectPolyCopy.insert(0,subjectPolyCopy.pop());
			vert0Check = lineIntersectPoly(subjectPolyCopy[0], subjectPolyCopy[1], cuttingPolyCopy);
		}
		
		// We want our polys to in oposite vertex order
		if(isPolyClockwise(subjectPolyCopy))
			subjectPolyCopy.reverse();
		if(!isPolyClockwise(cuttingPolyCopy))
			cuttingPolyCopy.reverse();
		
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
		for(i in 0...subjectPolyCopy.length) {
			if(i > 0) {
				var lip:Dynamic = lineIntersectPoly(subjectPolyCopy[i-1], subjectPolyCopy[i], cuttingPolyCopy);
				
				if(p_dbgDraw!=null) {
					
					// Determine if the current vertex is inside or outside of the cuting poly
					if(!lip.start_inside && !lip.end_inside) isInside = false;
					else if(!lip.start_inside && lip.end_inside) isInside = true;
					else if(lip.start_inside && lip.end_inside) isInside = true;
					else if(lip.start_inside && !lip.end_inside) isInside = false;
					
					// if this is the first vertex outside, we'll add the intersection vertex before this vertex
					if(!isInside && lip.start_inside)
						resultingPoly.push(lip.Intersections[0]);
					
					// Add vertices that are outside
					if(!isInside && !(lip.Intersects && !lip.start_inside && !lip.end_inside))
						resultingPoly.push(subjectPolyCopy[i]);
					
					// If this is the first vertex inside, add the intersection vertex,
					// and then the vertices from the cutting poly that is inside the subject
					if((isInside && !lip.start_inside) || (lip.Intersects && !lip.start_inside && !lip.end_inside)) {
						if(!(lip.Intersects && !lip.start_inside && !lip.end_inside))
							resultingPoly.push(lip.Intersections[0]);
						else
							resultingPoly.push(lip.Intersections[1]);
						
						if(!innerVerticesAdded) {
							// Check intersections for the cutting poly, and add the vertices that are inside the subject
							var isInside2:Bool = false;
							for(j in 0...cuttingPolyCopy.length) {
								if(j > 0) {
									var lip2:Dynamic = lineIntersectPoly(cuttingPolyCopy[j-1], cuttingPolyCopy[j], subjectPolyCopy);
									if(!lip2.start_inside && !lip2.end_inside) isInside2 = false;
									else if(!lip2.start_inside && lip2.end_inside) isInside2 = true;
									else if(lip2.start_inside && lip2.end_inside) isInside2 = true;
									else if(lip2.start_inside && !lip2.end_inside) isInside2 = false;
									// Add vertices that are inside
									if(isInside2)
										resultingPoly.push(cuttingPolyCopy[j]);
								}
							}
							
							if((lip.Intersects && !lip.start_inside && !lip.end_inside)) {
								resultingPoly.push(lip.Intersections[0]);
							}
							
							innerVerticesAdded = true;
						}
					}
					
					if((lip.Intersects && !lip.start_inside && !lip.end_inside))
						resultingPoly.push(subjectPolyCopy[i]);
					
				}
			}
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
	public function lineIntersectLine(A:Dynamic,B:Dynamic,E:Dynamic,F:Dynamic,as_seg:Bool=true) : Dynamic
	{
		var ip:Dynamic;
		var a1:Float;
		var a2:Float;
		var b1:Float;
		var b2:Float;
		var c1:Float;
		var c2:Float;
		
		a1= B.y-A.y;
		b1= A.x-B.x;
		c1= B.x*A.y - A.x*B.y;
		a2 = F.y - E.y;
		b2= E.x-F.x;
		c2= F.x*E.y - E.x*F.y;
		
		var denom:Float=a1*b2 - a2*b1;
		if(denom == 0){
			return null;
		}
		ip = {
			x : (b1*c2 - b2*c1)/denom,
			y : (a2*c1 - a1*c2)/denom
		};
	 
		//---------------------------------------------------
		//Do checks to see if Intersection to endpoints
		//distance is longer than actual Segments.
		//Return null if it is with any.
		//---------------------------------------------------
		if(as_seg){
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
	public function lineIntersectPoly(A : Dynamic, B : Dynamic, p_pa:Array<Dynamic>):Dynamic
	{
		var An:Int=1;
		var Bn:Int=1;
		var C:Dynamic;
		var D:Dynamic;
		var i:Dynamic;
		var cx:Float=0;
		var cy:Float=0;
		
		// We don't want to modify the original array, so let's make a copy of the array and it's values
		var pa = p_pa.slice(0);
		
		var result:Dynamic = {Intersects:false, Intersections:[], start_inside:false, end_inside:false};
		//pa.push(pa[0]);
		var n:Int=pa.length-1;
		while(n > -1){
			C = pa[n];
			if(n > 0){
				cx+=C.x;
				cy+=C.y;
				D = ( pa[n-1] ? pa[n-1] : pa[0] );
				i=lineIntersectLine(A,B,C,D);
				if(i != null){
					result.Intersections.push(i);
				}
				if(lineIntersectLine(A,{x:C.x+D.x, y:A.y},C,D) != null){
					An++;
				}
				if(lineIntersectLine(B,{x:C.x+D.x, y:B.y},C,D) != null){
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
		result.centroid={x:cx/(pa.length-1), y:cy/(pa.length-1)};
		result.Intersects = result.Intersections.length > 0;
		return result;
	}
}
