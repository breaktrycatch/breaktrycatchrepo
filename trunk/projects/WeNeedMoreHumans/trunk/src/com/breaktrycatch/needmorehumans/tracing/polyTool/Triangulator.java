package com.breaktrycatch.needmorehumans.tracing.polyTool;

import java.util.ArrayList;
import java.util.Collections;

import com.breaktrycatch.needmorehumans.tracing.PixelVO;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class Triangulator {

	public Triangulator() {
		// TODO Auto-generated constructor stub
	}
	
	/* give it an array of points (vertexes)
	 * returns an array of Triangles
	 * */
	public static ArrayList<Triangle> triangulatePolygon(ArrayList<PixelVO> v)
	{
		ArrayList<Float> xA = new ArrayList<Float>();
		ArrayList<Float> yA = new ArrayList<Float>();
		
		for(int i = 0; i < v.size(); i++) {
			xA.add((float)v.get(i).x);
			yA.add((float)v.get(i).y);
		}
		
		return(triangulatePolygonFromFlatArray(xA, yA));
	}
	
	/* give it a list of vertexes as flat arrays
	 * returns an array of Triangles
	 * */
	public static ArrayList<Triangle> triangulatePolygonFromFlatArray(ArrayList<Float> xv, ArrayList<Float> yv)
	{
		if (xv.size() < 3 || yv.size() < 3 || yv.size() != xv.size()) {
			LogRepository.getInstance().getJonsLogger().info("Please make sure both arrays or of the same length and have at least 3 vertices in them!");
			return null;
		}
		
		int i = 0;
		int vNum = xv.size();
	  
		ArrayList<Triangle> buffer = new ArrayList<Triangle>();
		int bufferSize = 0;
		ArrayList<Float> xrem = new ArrayList<Float>();
		ArrayList<Float> yrem = new ArrayList<Float>();
		
		for (i = 0; i <vNum; i++) {
			xrem.add(i, xv.get(i));
			yrem.add(i, yv.get(i));
		}

		while (vNum > 3) {
			//Find an ear
			int earIndex = -1;
			for (i = 0; i <vNum; i++) {
				if (isEar(i, xrem, yrem)) {
					earIndex = i;
					break;
				}
			}

			//If we still haven't found an ear, we're screwed.
			//The user did Something Bad, so return null.
			//This will probably crash their program, since
			//they won't bother to check the return value.
			//At this we shall laugh, heartily and with great gusto.
			if (earIndex == -1) {
				LogRepository.getInstance().getJonsLogger().info("no ear found");
				//trace('no ear found');
				return null;
			}

			//Clip off the ear:
			//  - remove the ear tip from the list

			//Opt note: actually creates a new list, maybe
			//this should be done in-place instead.  A linked
			//list would be even better to avoid array-fu.
			--vNum;
			ArrayList<Float> newx = new ArrayList<Float>();
			ArrayList<Float> newy = new ArrayList<Float>();
			int currDest = 0;
			for (i = 0; i <vNum; i++) {
				if (currDest == earIndex) {
					++currDest;
				}
				newx.add(i, xrem.get(currDest));
				newy.add(i, yrem.get(currDest));
				++currDest;
			}

			//  - add the clipped triangle to the triangle list
			int under = (earIndex == 0)?(xrem.size() - 1):(earIndex - 1);
			int over = (earIndex == xrem.size() - 1)?0:(earIndex + 1);
			
			//if(5 < getSmallestAngle(xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]))
			
			Triangle toAdd = new Triangle(xrem.get(earIndex), yrem.get(earIndex), xrem.get(over), yrem.get(over), xrem.get(under), yrem.get(under));
			buffer.add(bufferSize, toAdd);
			++bufferSize;
		
			//  - replace the old list with the new one
			xrem = newx;
			yrem = newy;
		}
		
		Triangle toAddMore = new Triangle(xrem.get(1), yrem.get(1), xrem.get(2), yrem.get(2), xrem.get(0), yrem.get(0));
		buffer.add(bufferSize, toAddMore);
		++bufferSize;

		ArrayList<Triangle> res = new ArrayList<Triangle>();
		for (i = 0; i < bufferSize; i++) {
			res.add(i, buffer.get(i));
		}
		return buffer;
	}
	
	public static float getSmallestAngle(float pax, float pay, float pbx, float pby, float pcx, float pcy) {
		ArrayList<AObject> angles = new ArrayList<AObject>();
//		var pax=pax;
//		var pay=pay;
//		var pbx=pbx;
//		var pby=pby;
//		var pcx=pcx;
//		var pcy=pcy;
		float abx=pax-pbx;
		float aby=pay-pby;
		float ab=(float) Math.sqrt(abx*abx+aby*aby);
		float bcx=pbx-pcx;
		float bcy=pby-pcy;
		float bc=(float)Math.sqrt(bcx*bcx+bcy*bcy);
		float cax=pcx-pax;
		float cay=pcy-pay;
		float ca=(float)Math.sqrt(cax*cax+cay*cay);
		float cosA=-(bc*bc-ab*ab-ca*ca)/(2*ab*ca);
		float acosA=(float) (Math.acos(cosA)*180/Math.PI);
		float cosB=-(ca*ca-bc*bc-ab*ab)/(2*bc*ab);
		float acosB=(float) (Math.acos(cosB)*180/Math.PI);
		float cosC=-(ab*ab-ca*ca-bc*bc)/(2*ca*bc);
		float acosC=(float) (Math.acos(cosC)*180/Math.PI);
		angles.add(new AObject(acosA));
		angles.add(new AObject(acosB));
		angles.add(new AObject(acosC));
		Collections.sort(angles);
//		angles.sort(function(x,y){
//			if(x>y)
//				return 1;
//			else if(y>x)
//				return -1;
//			else
//				return 0;
//		});
		
		return angles.get(0).f;
	}
	
	/* takes: array of Triangles 
	 * returns: array of Polygons
	 * */
	public static ArrayList<Polygon> polygonizeTriangles(ArrayList<Triangle> triangulated)
	{
		ArrayList<Polygon> polys;
		int polyIndex = 0;
		Polygon poly = null;

		int i = 0;
		
		if (triangulated == null){
			return null;
		} else {
			polys = new ArrayList<Polygon>();
			ArrayList<Boolean> covered = new ArrayList<Boolean>();
			for (i = 0; i < triangulated.size(); i++) {
				covered.add(i, false);
			}

			boolean notDone = true;

			while(notDone){
				int currTri = -1;
				for (i = 0; i < triangulated.size(); i++) {
					if (covered.get(i) == true) {
						continue;
					}
					currTri = i;
					break;
				}
				if (currTri == -1){
					notDone = false;
				} else{
					poly = new Polygon(triangulated.get(currTri).x, triangulated.get(currTri).y);
					covered.add(currTri, true);
					for (i = 0; i < triangulated.size(); i++) {
						if (covered.get(i) == true) {
							continue;
						}
						Polygon newP = poly.add(triangulated.get(i));
						if (newP == null || newP.x.size() > 7) {
							continue;
						}
						if (newP.isConvex()){
							poly = newP;
							covered.add(i, true);
						}
					}
				}
				polys.add(polyIndex, poly);
				polyIndex++;
			}
		}
		
		ArrayList<Polygon> ret = new ArrayList<Polygon>();
		for (i = 0; i < polyIndex; i++) {
			ret.add(i, polys.get(i));
		}
		return ret;
	}

	//Checks if vertex i is the tip of an ear
	/*
	 * */
	public static boolean isEar(int i, ArrayList<Float> xv, ArrayList<Float> yv)
	{
		float dx0;
		float dy0;
		float dx1;
		float dy1;
		dx0 = dy0 = dx1 = dy1 = 0;
		if (i >= xv.size() || i < 0 || xv.size() < 3) {
			return false;
		}
		int upper = i + 1;
		int lower = i - 1;
		if (i == 0){
			dx0 = xv.get(0) - xv.get(xv.size() - 1);
			dy0 = yv.get(0) - yv.get(yv.size() - 1);
			dx1 = xv.get(1) - xv.get(0);
			dy1 = yv.get(1) - yv.get(0);
			lower = xv.size() - 1;
		} else if (i == xv.size() - 1) {
			dx0 = xv.get(i) - xv.get(i - 1);
			dy0 = yv.get(i) - yv.get(i - 1);
			dx1 = xv.get(0) - xv.get(i);
			dy1 = yv.get(0) - yv.get(i);
			upper = 0;
		} else{
			dx0 = xv.get(i) - xv.get(i - 1);
			dy0 = yv.get(i) - yv.get(i - 1);
			dx1 = xv.get(i + 1) - xv.get(i);
			dy1 = yv.get(i + 1) - yv.get(i);
		}
		
		float cross = (dx0*dy1)-(dx1*dy0);
		if (cross > 0) {
			return false;
		}
		Triangle myTri = new Triangle(xv.get(i), yv.get(i), xv.get(upper), yv.get(upper), xv.get(lower), yv.get(lower));

		for (int j = 0; j < xv.size(); j++) {
			if (!(j == i || j == lower || j == upper)) {
				if (myTri.isInside(xv.get(j), yv.get(j))) {
					return false;
				}
			}
		}
		return true;
	}	

}
