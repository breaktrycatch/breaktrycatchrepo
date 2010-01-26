//package com.breaktrycatch.needmorehumans.notepad;
//
//public class NotepadJon {
//	//NOTHING HERE, Just a notepad of code.
//	
//	
//	package com.breaktrycatch.needmorehumans.view;
//
//	import java.util.ArrayList;
//
//	import processing.core.PApplet;
//	import processing.core.PImage;
//	import processing.core.PVector;
//
//	import com.breaktrycatch.lib.view.AbstractView;
//	import com.breaktrycatch.needmorehumans.tracing.PixelDataVO;
//
//	public class TracingDebugView extends AbstractView
//	{
//
//		/**
//		 * 
//		 */
//		private static final long serialVersionUID = 1L;
//
//		private PImage __originalImage;
//		private PImage __debugImage;
//		
//		private PixelDataVO pTop;
//		private PixelDataVO pBottom;
//		private PixelDataVO pLeft;
//		private PixelDataVO pRight;
//		private PixelDataVO pCenter;
//		
//		private PixelDataVO preciseCenter;
//		
//		private PixelDataVO farthestPixel;
//		private PixelDataVO nearestPixel;
//		private PixelDataVO tempPixelFar;
//		private PixelDataVO tempPixelNear;
//		
//		private ArrayList<PixelDataVO> farPixels;
//		private ArrayList<PixelDataVO> nearPixels;
//		
//		public TracingDebugView()
//		{
//			// all PApplet related commands should be made in setup().
//		}
//
//		@Override
//		public void initialize(PApplet app)
//		{
//			super.initialize(app);
//			
//
////		    __originalImage = app.loadImage("TestPerson_png.png");
////		    __originalImage.loadPixels();
////		    __debugImage = app.loadImage("TestPerson_png.png");
////		    __debugImage.loadPixels();
//		    
////		    __originalImage = app.loadImage("RealPerson_1.png");
////		    __originalImage.loadPixels();
////		    __debugImage = app.loadImage("RealPerson_1.png");
////		    __debugImage.loadPixels();
//		    
////		    __originalImage = app.loadImage("RealPerson_2.png");
////		    __originalImage.loadPixels();
////		    __debugImage = app.loadImage("RealPerson_2.png");
////		    __debugImage.loadPixels();
//		    
////		    __originalImage = app.loadImage("RealPerson_3.png");
////		    __originalImage.loadPixels();
////		    __debugImage = app.loadImage("RealPerson_3.png");
////		    __debugImage.loadPixels();
//		    
////		    __originalImage = app.loadImage("RealPerson_4.png");
////		    __originalImage.loadPixels();
////		    __debugImage = app.loadImage("RealPerson_4.png");
////		    __debugImage.loadPixels();
//		    
//		    __originalImage = app.loadImage("RealPerson_5.png");
//		    __originalImage.loadPixels();
//		    __debugImage = app.loadImage("RealPerson_5.png");
//		    __debugImage.loadPixels();
//		    
//		    int totalPixels = (__originalImage.width*__originalImage.height);
//		    int index;
//		    int left = __originalImage.width;
//		    int right = 0;
//		    int top = __originalImage.height;
//		    int bottom = 0;
//		    ArrayList<PixelDataVO> outline = new ArrayList<PixelDataVO>();
//		    PixelDataVO vo;
//		    
//		    for (int y=0; y<__originalImage.height; y++) {
//		    	for (int x=0; x<__originalImage.width; x++) {
//		    		index = y*__originalImage.width + x;
//		    		int pixel = __originalImage.pixels[index];
//		    		if (app.alpha(pixel) > 0xEE) {
//		    			if (x < left) {
//		    				left = x;
//		    			}
//		    			if (x > right) {
//		    				right = x;
//		    			}
//		    		}
//		    	}
//		    	if (left != __originalImage.width) {
//		    		__debugImage.pixels[y*__originalImage.width + left] = 0xFFFF0000;
//		    		vo = new PixelDataVO();
//		    		vo.x = left;
//		    		vo.y = y;
//		    		outline.add(vo);
//		    	}
//		    	if (right != 0) {
//		    		__debugImage.pixels[y*__originalImage.width + right] = 0xFFFF0000;
//		    		vo = new PixelDataVO();
//		    		vo.x = right;
//		    		vo.y = y;
//		    		outline.add(vo);
//		    	}
//		    	left = __originalImage.width;
//		    	right = 0;
//		    }
//		    
//		    for (int x=0; x<__originalImage.width; x++) {
//		    	for (int y=0; y<__originalImage.height; y++) {
//		    		index = y*__originalImage.width + x;
//		    		int pixel = __originalImage.pixels[index];
//		    		if (app.alpha(pixel) > 0xEE) {
//		    			if (y < top) {
//		    				top = y;
//		    			}
//		    			if (y > bottom) {
//		    				bottom = y;
//		    			}
//		    		}
//		    	}
//		    	if (top != __originalImage.height) {
//		    		__debugImage.pixels[top*__originalImage.width + x] = 0xFFFF0000;
//		    		vo = new PixelDataVO();
//		    		vo.x = x;
//		    		vo.y = top;
//		    		outline.add(vo);
//		    	}
//		    	if (bottom != 0) {
//		    		__debugImage.pixels[bottom*__originalImage.width + x] = 0xFFFF0000;
//		    		vo = new PixelDataVO();
//		    		vo.x = x;
//		    		vo.y = bottom;
//		    		outline.add(vo);
//		    	}
//		    	top = __originalImage.height;
//		    	bottom = 0;
//		    }
//		    
//		    __debugImage.updatePixels();
//		    PApplet.println("Outline Size " + outline.size());
//		   
//		   PApplet.println("Trying to find top, left, right and bottom most pixels");
//		   
//		   pTop = outline.get(0);
//		   pBottom = outline.get(0);
//		   pLeft = outline.get(0);
//		   pRight = outline.get(0);
//		   PixelDataVO pTest;
//		   
//		   app.ellipseMode(PApplet.CENTER);
//		   
//		   int xAggregate = 0;
//		   int yAggregate = 0;
//		   
//		   for (int i = 1; i < outline.size(); i++) {
//			   pTest = outline.get(i);
//			   xAggregate += pTest.x;
//			   yAggregate += pTest.y;
//			   if (pTest.y < pTop.y) {
//				   pTop = pTest;
//			   }
//			   if (pTest.y > pBottom.y) {
//				   pBottom = pTest;
//			   }
//			   if (pTest.x < pLeft.x) {
//				   pLeft = pTest;
//			   }
//			   if (pTest.x > pRight.x) {
//				   pRight = pTest;
//			   }
//		   }
//		   
//		   preciseCenter = new PixelDataVO();
//		   preciseCenter.x = xAggregate/outline.size();
//		   preciseCenter.y = yAggregate/outline.size();
//		   
//		   PApplet.println("TOP PIXEL " + pTop.x + " " + pTop.y);
//		   PApplet.println("BOTTOM PIXEL " + pBottom.x + " " + pBottom.y);
//		   PApplet.println("RIGHT PIXEL " + pRight.x + " " + pRight.y);
//		   PApplet.println("LEFT PIXEL " + pLeft.x + " " + pLeft.y);
//		   
//		   PApplet.println("PRECISE CENTER " + preciseCenter.x + " " + preciseCenter.y);
//		   
//		   PVector line;
//		   PVector plane = new PVector(0, 0 - preciseCenter.y);
//		   //Now lets radially figure out this distance from the center
//		   for (int i = 0; i < outline.size(); i++) {
//			   pTest = outline.get(i);
//			   pTest.distanceFromPreciseCenter = Math.sqrt(Math.pow((pTest.x - preciseCenter.x), 2) + Math.pow((pTest.y - preciseCenter.y), 2));
//			   line = new PVector(pTest.x - preciseCenter.x, pTest.y - preciseCenter.y);
//			   pTest.angle = PApplet.degrees(PVector.angleBetween(line, plane));
//			   if (pTest.x < preciseCenter.x) {
//				   pTest.angle = 360 - pTest.angle;
//			   }
//			   //PApplet.println(pTest.angle);
//		   }
//		   
//		   farPixels = new ArrayList<PixelDataVO>();
//		   nearPixels = new ArrayList<PixelDataVO>();
//		   
//		   //Find the farthest pixel from the center
//		   farthestPixel = outline.get(0);
//		   nearestPixel = outline.get(0);
//		   PApplet.println("Nearest Pixel " + nearestPixel.distanceFromPreciseCenter + " " + nearestPixel.x + " " + nearestPixel.y);
//		   for (int i = 1; i < outline.size(); i++) {
//			   pTest = outline.get(i);
//			   if (pTest.distanceFromPreciseCenter > farthestPixel.distanceFromPreciseCenter) {
//				   farthestPixel = pTest;
//			   }
//			   if (pTest.distanceFromPreciseCenter < nearestPixel.distanceFromPreciseCenter) {
//				   nearestPixel = pTest;
//				   PApplet.println("Nearest Pixel Candidate " + nearestPixel.distanceFromPreciseCenter);
//			   }
//		   }
//		   
//		   farPixels.add(farthestPixel);
//		   nearPixels.add(nearestPixel);
//		   PApplet.println("Nearest Pixel Set " + nearestPixel.distanceFromPreciseCenter);
//		   
//		   
//		   double upperBoundsFar;
//		   double lowerBoundsFar;
//		   double upperBoundsNear;
//		   double lowerBoundsNear;
//		   
//		   
//		   
//		   //Want to get 4 other extremities
//		   for (int j = 0; j < 4; j++) {
//			   //last added pixel is the farthest pixel
//			   tempPixelFar = farthestPixel;
//			   tempPixelNear = nearestPixel;
////			   PApplet.println("Current Angle " + tempPixel.angle);
//			   //generate upper and lower bounds to search in
//			   upperBoundsFar = tempPixelFar.angle + 90;
//			   lowerBoundsFar = tempPixelFar.angle + 18;
//			   upperBoundsNear = tempPixelNear.angle + 90;
//			   lowerBoundsNear = tempPixelNear.angle + 18;
////			   PApplet.println("UpperBounds " + upperBounds);
////			   PApplet.println("LowerBounds " + lowerBounds);
//			   //validate bounds
//			   if (upperBoundsFar > 360) {
//				   upperBoundsFar -= 360;
//			   }
//			   if (lowerBoundsFar < 0) {
//				   lowerBoundsFar = 360 - lowerBoundsFar;
//			   }
//			   if (upperBoundsNear > 360) {
//				   upperBoundsNear -= 360;
//			   }
//			   if (lowerBoundsNear < 0) {
//				   lowerBoundsNear = 360 - lowerBoundsNear;
//			   }
////			   PApplet.println("Validated UpperBounds " + upperBounds);
////			   PApplet.println("Validated LowerBounds " + lowerBounds);
//			   //start at the beginning of the list
//			   farthestPixel = outline.get(0);
//			   nearestPixel = outline.get(0);
//			   for (int i = 1; i < outline.size(); i++) {
//				   pTest = outline.get(i);
//				   
//				   //difference = Math.abs(pTest.angle - tempPixel.angle);
//				   boolean inRangeFar = false;
//				   boolean inRangeNear = false;
//				   
//				   if (lowerBoundsFar > upperBoundsFar) {
//					   if ((pTest.angle >= lowerBoundsFar && pTest.angle <= 360) || (pTest.angle <= upperBoundsFar && pTest.angle >= 0)) {
//						   inRangeFar = true;
////						   PApplet.println("Overlap in Range " + pTest.angle);
//					   }
//				   }
//				   else if (pTest.angle >= lowerBoundsFar && pTest.angle <= upperBoundsFar){
//					   inRangeFar = true;
////					   PApplet.println("Regualr in Range " + pTest.angle);
//				   }
//				   
//				   if (lowerBoundsNear > upperBoundsNear) {
//					   if ((pTest.angle >= lowerBoundsNear && pTest.angle <= 360) || (pTest.angle <= upperBoundsNear && pTest.angle >= 0)) {
//						   inRangeNear = true;
//						   PApplet.println("Overlap in Range " + pTest.angle);
//					   }
//				   }
//				   else if (pTest.angle >= lowerBoundsNear && pTest.angle <= upperBoundsNear){
//					   inRangeNear = true;
//					   PApplet.println("Regualr in Range " + pTest.angle);
//				   }
//				   
//				   if (inRangeFar) {
//					   if (pTest.distanceFromPreciseCenter > farthestPixel.distanceFromPreciseCenter) {
//						   farthestPixel = pTest;
////						   PApplet.println("CHOSEN " + pTest.angle);
//					   }
//				   }
//				   if (inRangeNear) {
//					   if (pTest.distanceFromPreciseCenter < nearestPixel.distanceFromPreciseCenter) {
//						   nearestPixel = pTest;
//						   PApplet.println("CHOSEN " + pTest.angle);
//					   }
//				   }
//			   }
//			   PApplet.println("ACTUAL " + nearestPixel.angle);
//			   farPixels.add(farthestPixel);
//			   nearPixels.add(nearestPixel);
//		   }
//		   
//		   
//		   
//		   
//		   
//		   pCenter = new PixelDataVO();
//		   pCenter.x = (pRight.x + pLeft.x + pTop.x + pBottom.x)/4;
//		   pCenter.y = (pRight.y + pLeft.y + pTop.y + pBottom.y)/4;
//		   
//		   PApplet.println("CENTER PIXEL " + pCenter.x + " " + pCenter.y);
//		   
//		   
//			
//		}
//		
//		
//		@Override
//		public void draw() {
//			PApplet app = getApp();
//			app.background(255);
//			app.image(__originalImage, 0, 0);
//			app.image(__debugImage, __originalImage.width, 0);
//			app.noStroke();
//			app.fill(255, 255, 0);
//			app.ellipse(pTop.x + __originalImage.width, pTop.y, 20, 20);
//			app.ellipse(pBottom.x + __originalImage.width, pBottom.y, 20, 20);
//			app.ellipse(pRight.x + __originalImage.width, pRight.y, 20, 20);
//			app.ellipse(pLeft.x + __originalImage.width, pLeft.y, 20, 20);
//			
//			app.fill(0, 255, 0);
//			app.ellipse(pCenter.x + __originalImage.width, pCenter.y, 20, 20);
//			
//			app.fill(0, 0, 255);
//			app.ellipse(preciseCenter.x + __originalImage.width, preciseCenter.y, 20, 20);
//			//app.ellipse(farthestPixel.x + __originalImage.width, farthestPixel.y, 20, 20);
//			
//			app.noFill();
//			
//			app.stroke(255, 0, 0);
//			app.rect(pLeft.x + __originalImage.width, pTop.y, pRight.x - pLeft.x, pBottom.y - pTop.y);
//			
//			app.strokeWeight(3);
//			app.stroke(0, 0, 255);
//			
//			for (int i = 0; i < farPixels.size(); i++) {
//				app.line(preciseCenter.x + __originalImage.width, preciseCenter.y, farPixels.get(i).x + __originalImage.width, farPixels.get(i).y);
//			}
//			
////			app.stroke(255, 0, 255);
////			
////			for (int i = 0; i < nearPixels.size(); i++) {
////				app.line(preciseCenter.x + __originalImage.width, preciseCenter.y, nearPixels.get(i).x + __originalImage.width, nearPixels.get(i).y);
////			}
//			
//			
//		}
//	}
//
//	
//	
//	
//}
