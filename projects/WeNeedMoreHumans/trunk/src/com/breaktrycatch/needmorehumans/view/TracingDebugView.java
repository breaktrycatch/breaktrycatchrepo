package com.breaktrycatch.needmorehumans.view;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.tracing.EdgeVO;
import com.breaktrycatch.needmorehumans.tracing.PixelDataVO;
import com.breaktrycatch.needmorehumans.tracing.algorithms.BetterRelevancy;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TracingDebugView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private PImage __originalImage;
	private PImage __debugImage;
	private PImage __linkedImage;
	
	private PixelDataVO pTop;
	private PixelDataVO pBottom;
	private PixelDataVO pLeft;
	private PixelDataVO pRight;
	private PixelDataVO pCenter;
	
	private PixelDataVO preciseCenter;
	
	private PixelDataVO farthestPixel;
	private PixelDataVO nearestPixel;
	private PixelDataVO tempPixelFar;
	private PixelDataVO tempPixelNear;
	
	private ArrayList<PixelDataVO> farPixels;
	private ArrayList<PixelDataVO> nearPixels;
	
	private ArrayList<PixelDataVO> outline;
	private ArrayList<EdgeVO> edges;
	
	private PixelDataVO startingNode;
	private PixelDataVO currentNode;
	private PixelDataVO tempNode;
	private PixelDataVO nextNode;
	private int nodeCount;
	
	public TracingDebugView()
	{
		// all PApplet related commands should be made in setup().
	}
	
	protected PixelDataVO getPixelByXY(int _x, int _y) {
		for (int i = 0; i < outline.size(); i++) {
			if (outline.get(i).x == _x && outline.get(i).y == _y) {
				return outline.get(i);
			}
		}
		return null;
	}
	
	protected void addPixelToOutline(PixelDataVO _pixel) {
		if (isDuplicatePixel(_pixel) == false) {
			outline.add(_pixel);
		}
	}
	
	protected boolean isDuplicatePixel(PixelDataVO _pixel) {
		 for (int i = 0; i < outline.size(); i++) {
			 if (outline.get(i).x == _pixel.x && outline.get(i).y == _pixel.y) {
				 return true;
			 }
		 }
		 return false;
	}
	
	protected void constructLinkedNodes() {
		//Look at the first red pixel on the debug image.
		//Traverse through until we get back to the same pixel.
		//This is our linked list edge.
		
		int pid = 0;
		
		LogRepository.getInstance().getJonsLogger().info("ORIGINAL PIXELS " + outline.size());
		
		PixelDataVO startPixel = outline.get(0);
		startPixel.id = pid;
		pid++;
		startingNode = startPixel;
		int[] pixels = __debugImage.pixels;
		PixelDataVO currentPixel;
		PixelDataVO checkPixel;
		int index;
		int count = 0;
		
		boolean found = false;
		
		//Assign the current Pixel
		currentPixel = startPixel;
		
		while (found == false) {
		
			//RIGHT
			//Look to the Right first
			index = (currentPixel.y)*__debugImage.width + (currentPixel.x + 1);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the right");
				checkPixel = getPixelByXY(currentPixel.x + 1, currentPixel.y);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START RIGHT");
						found = true;
						break;
					}
					continue;
				}
			}
			//DOWN
			//Look to the Down Next
			index = (currentPixel.y + 1)*__debugImage.width + (currentPixel.x);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the down");
				checkPixel = getPixelByXY(currentPixel.x, currentPixel.y + 1);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START DOWN");
						found = true;
						break;
					}
					continue;
				}
			}
			//DOWN RIGHT
			//Look to the Down Right Next
			index = (currentPixel.y + 1)*__debugImage.width + (currentPixel.x + 1);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the down right");
				checkPixel = getPixelByXY(currentPixel.x + 1, currentPixel.y + 1);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START DOWN RIGHT");
						found = true;
						break;
					}
					continue;
				}
			}
			//LEFT
			//Look to the Left Next
			index = (currentPixel.y)*__debugImage.width + (currentPixel.x - 1);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the left");
				checkPixel = getPixelByXY(currentPixel.x - 1, currentPixel.y);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START LEFT");
						found = true;
						break;
					}
					continue;
				}
			}
			//DOWN LEFT
			//Look to the Down Left Next
			index = (currentPixel.y + 1)*__debugImage.width + (currentPixel.x - 1);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the down left");
				checkPixel = getPixelByXY(currentPixel.x - 1, currentPixel.y + 1);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START DOWN LEFT");
						found = true;
						break;
					}
					continue;
				}
			}
			//UP
			//Look to the up left Next
			index = (currentPixel.y - 1)*__debugImage.width + (currentPixel.x);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the up");
				checkPixel = getPixelByXY(currentPixel.x, currentPixel.y - 1);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START UP");
						found = true;
						break;
					}
					continue;
				}
			}
			//UP LEFT
			//Look to the up left Next
			index = (currentPixel.y - 1)*__debugImage.width + (currentPixel.x - 1);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the up left");
				checkPixel = getPixelByXY(currentPixel.x - 1, currentPixel.y - 1);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START UP LEFT");
						found = true;
						break;
					}
					continue;
				}
			}
			//UP RIGHT
			//Look to the up right Next
			index = (currentPixel.y - 1)*__debugImage.width + (currentPixel.x + 1);
			//If it's a red pixel...
			if (pixels[index] == 0xFFFF0000) {
				//LogRepository.getInstance().getJonsLogger().info("Found red to the up right");
				checkPixel = getPixelByXY(currentPixel.x + 1, currentPixel.y - 1);
				if (checkPixel.marked == false) {
					checkPixel.marked = true;
					currentPixel.next = checkPixel;
					checkPixel.prev = currentPixel;
					currentPixel = checkPixel;
					__linkedImage.pixels[checkPixel.y*__debugImage.width + checkPixel.x] = 0xFF00FF00;
					count++;
					if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
						//LogRepository.getInstance().getJonsLogger().info("FOUND START UP RIGHT");
						found = true;
						break;
					}
					continue;
				}
			}
			
			LogRepository.getInstance().getJonsLogger().info("NO PIXEL FOUND ALL AROUND!");
			currentPixel = currentPixel.prev;
			
		}
		LogRepository.getInstance().getJonsLogger().info("ORDERED PIXELS " + count);
		__linkedImage.updatePixels();
		
		nodeCount = count;
		
		boolean edgesCompleted = false;
		
		currentPixel = startPixel;
		
		//CULLING PIXELS THROUGH EVERY 5
		currentNode = startingNode;
		currentNode.rendered = true;
		int renderCount = 0;
		int renderSkip = 1;
		
		float times = nodeCount/renderSkip;
		
		PApplet.println("TIMES nodeCount/renderSkip " + nodeCount + "/" + renderSkip + " = " + times);
		
		while (renderCount < times) {
			renderCount++;
			//temp node
			tempNode = currentNode;
			//for however many nodes to skip
			for (int i = 0; i < renderSkip; i++) {
				nextNode = tempNode.next;
				tempNode = nextNode;
			}
			currentNode.next = nextNode;
			nextNode.prev = currentNode;
			currentNode = nextNode;
		}
		//currentNode.prev.next = startingNode;
		//startingNode.prev = currentNode.prev;
		
		LogRepository.getInstance().getJonsLogger().info("CULLED PIXELS " + renderCount);
		currentPixel = startingNode;
		
		//CONSTRUCTING EDGES
		edges = new ArrayList<EdgeVO>();
		
		EdgeVO e;
		int edgeCount = 0;
		while (edgesCompleted == false) {
			e = new EdgeVO(currentPixel, currentPixel.next);
			edges.add(e);
			edgeCount++;
			currentPixel = currentPixel.next;
			if (currentPixel.x == startPixel.x && currentPixel.y == startPixel.y) {
				LogRepository.getInstance().getJonsLogger().info("EDGES COMPLETED " + edgeCount);
				edgesCompleted = true;
				break;
			}
		}
		
		EdgeVO ahead;
		EdgeVO behind;
		int aheadIndex;
		int behindIndex;
		int removeCount = 0;
		boolean iterate = true;
		double angle;
		
		
		while(iterate == true) {
			iterate = false;
			//Delete all edges with length less than 5 
			for (int i = edges.size() - 1; i >= 0; i-- ) {
				e = edges.get(i);
				if (i+1 > edges.size() - 1) {
					aheadIndex = 0;
				}
				else {
					aheadIndex = i+1;
				}
				if (i-1 < 0) {
					behindIndex = edges.size() - 1;
				}
				else {
					behindIndex = i-1;
				}
				ahead = edges.get(aheadIndex);
				behind = edges.get(behindIndex);
				
				double relevancy = BetterRelevancy.calculate(e, ahead);
				
				angle = PApplet.degrees(PVector.angleBetween(e.getVector(), ahead.getVector()));
				//PApplet.println(angle);
				//First we should distance cull to get a more manageable number.
				//then check for interest points. Angles that are sharp.
				//cull all the almost straight lines.
				
				
				if (e.length < 10) {
					ahead.p1 = e.p1;
					behind.p2 = e.p2;
					ahead.updateLength();
					behind.updateLength();
					edges.remove(i);
					removeCount++;
					iterate = true;
					break;
				}
			}
		}
		LogRepository.getInstance().getJonsLogger().info("REMOVE EDGES " + removeCount);
		LogRepository.getInstance().getJonsLogger().info("Total Edges " + (edgeCount - removeCount));
		
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);
		

//	    __originalImage = app.loadImage("TestPerson_png.png");
//	    __originalImage.loadPixels();
//	    __debugImage = app.loadImage("TestPerson_png.png");
//	    __debugImage.loadPixels();
//		__linkedImage = app.loadImage("TestPerson_png.png");
//	    __linkedImage.loadPixels();
		
//		__originalImage = app.loadImage("Cube.png");
//	    __originalImage.loadPixels();
//	    __debugImage = app.loadImage("Cube.png");
//	    __debugImage.loadPixels();
//		__linkedImage = app.loadImage("Cube.png");
//	    __linkedImage.loadPixels();
	    
	    __originalImage = app.loadImage("RealPerson_1.png");
	    __originalImage.loadPixels();
	    __debugImage = app.loadImage("RealPerson_1.png");
	    __debugImage.loadPixels();
		__linkedImage = app.loadImage("RealPerson_1.png");
	    __linkedImage.loadPixels();
	    
//	    __originalImage = app.loadImage("RealPerson_2.png");
//	    __originalImage.loadPixels();
//	    __debugImage = app.loadImage("RealPerson_2.png");
//	    __debugImage.loadPixels();
//		__linkedImage = app.loadImage("RealPerson_2.png");
//	    __linkedImage.loadPixels();
	    
//	    __originalImage = app.loadImage("RealPerson_3.png");
//	    __originalImage.loadPixels();
//	    __debugImage = app.loadImage("RealPerson_3.png");
//	    __debugImage.loadPixels();
//		__linkedImage = app.loadImage("RealPerson_3.png");
//	    __linkedImage.loadPixels();
	    
//	    __originalImage = app.loadImage("RealPerson_4.png");
//	    __originalImage.loadPixels();
//	    __debugImage = app.loadImage("RealPerson_4.png");
//	    __debugImage.loadPixels();
//		__linkedImage = app.loadImage("RealPerson_4.png");
//	    __linkedImage.loadPixels();
	    
//	    __originalImage = app.loadImage("RealPerson_5.png");
//	    __originalImage.loadPixels();
//	    __debugImage = app.loadImage("RealPerson_5.png");
//	    __debugImage.loadPixels();
//	    __linkedImage = app.loadImage("RealPerson_5.png");
//	    __linkedImage.loadPixels();
	    
	    int totalPixels = (__originalImage.width*__originalImage.height);
	    int index;
	    boolean negativeSpace = true;
	    
	    outline = new ArrayList<PixelDataVO>();
	    PixelDataVO vo;
	    
	    for (int y=0; y<__originalImage.height; y++) {
	    	negativeSpace = true;
	    	for (int x=0; x<__originalImage.width; x++) {
	    		index = y*__originalImage.width + x;
	    		//get the pixel
	    		int pixel = __originalImage.pixels[index];
	    		//If the alpha is real
	    		if (app.alpha(pixel) > 0xEE) {
	    			if (negativeSpace == true) {
	    				negativeSpace = false;
	    				__debugImage.pixels[y*__originalImage.width + x] = 0xFFFF0000;
	    	    		vo = new PixelDataVO(x, y, index);
	    	    		addPixelToOutline(vo);
	    			}
	    		}
	    		else {
	    			if (negativeSpace == false) {
	    				negativeSpace = true;
	    				__debugImage.pixels[y*__originalImage.width + x] = 0xFFFF0000;
	    	    		vo = new PixelDataVO(x, y, index);
	    	    		addPixelToOutline(vo);
	    			}
	    		}
	    	}
	    }
	    
	    for (int x=0; x<__originalImage.width; x++) {
	    	negativeSpace = true;
	    	for (int y=0; y<__originalImage.height; y++) {
	    		index = y*__originalImage.width + x;
	    		//get the pixel
	    		int pixel = __originalImage.pixels[index];
	    		//If the alpha is real
	    		if (app.alpha(pixel) > 0xEE) {
	    			if (negativeSpace == true) {
	    				negativeSpace = false;
	    				__debugImage.pixels[y*__originalImage.width + x] = 0xFFFF0000;
	    	    		vo = new PixelDataVO(x, y, index);
	    	    		addPixelToOutline(vo);
	    			}
	    		}
	    		else {
	    			if (negativeSpace == false) {
	    				negativeSpace = true;
	    				__debugImage.pixels[y*__originalImage.width + x] = 0xFFFF0000;
	    	    		vo = new PixelDataVO(x, y, index);
	    	    		addPixelToOutline(vo);
	    			}
	    		}
	    	}
	    }
	    
	    
	    constructLinkedNodes();
	    
	    
	    
	    __debugImage.updatePixels();
	    LogRepository.getInstance().getJonsLogger().info("Outline Size " + outline.size());
	   //LogRepository.getInstance().getJonsLogger().info("Trying to find top, left, right and bottom most pixels");
	   
	   pTop = outline.get(0);
	   pBottom = outline.get(0);
	   pLeft = outline.get(0);
	   pRight = outline.get(0);
	   PixelDataVO pTest;
	   
	   app.ellipseMode(PApplet.CENTER);
	   
	   int xAggregate = 0;
	   int yAggregate = 0;
	   
	   for (int i = 1; i < outline.size(); i++) {
		   pTest = outline.get(i);
		   xAggregate += pTest.x;
		   yAggregate += pTest.y;
		   if (pTest.y < pTop.y) {
			   pTop = pTest;
		   }
		   if (pTest.y > pBottom.y) {
			   pBottom = pTest;
		   }
		   if (pTest.x < pLeft.x) {
			   pLeft = pTest;
		   }
		   if (pTest.x > pRight.x) {
			   pRight = pTest;
		   }
	   }
	   
	   preciseCenter = new PixelDataVO(xAggregate/outline.size(), yAggregate/outline.size(), -1);
	   
	   //LogRepository.getInstance().getJonsLogger().info("TOP PIXEL " + pTop.x + " " + pTop.y);
	   //LogRepository.getInstance().getJonsLogger().info("BOTTOM PIXEL " + pBottom.x + " " + pBottom.y);
	   //LogRepository.getInstance().getJonsLogger().info("RIGHT PIXEL " + pRight.x + " " + pRight.y);
	  // LogRepository.getInstance().getJonsLogger().info("LEFT PIXEL " + pLeft.x + " " + pLeft.y);
	   
	   //LogRepository.getInstance().getJonsLogger().info("PRECISE CENTER " + preciseCenter.x + " " + preciseCenter.y);
	   
	   PVector line;
	   PVector plane = new PVector(0, 0 - preciseCenter.y);
	   //Now lets radially figure out this distance from the center
	   for (int i = 0; i < outline.size(); i++) {
		   pTest = outline.get(i);
		   pTest.distanceFromPreciseCenter = Math.sqrt(Math.pow((pTest.x - preciseCenter.x), 2) + Math.pow((pTest.y - preciseCenter.y), 2));
		   line = new PVector(pTest.x - preciseCenter.x, pTest.y - preciseCenter.y);
		   pTest.angle = PApplet.degrees(PVector.angleBetween(line, plane));
		   if (pTest.x < preciseCenter.x) {
			   pTest.angle = 360 - pTest.angle;
		   }
		   //LogRepository.getInstance().getJonsLogger().info(pTest.angle);
	   }
	   
	   farPixels = new ArrayList<PixelDataVO>();
	   nearPixels = new ArrayList<PixelDataVO>();
	   
	   //Find the farthest pixel from the center
	   farthestPixel = outline.get(0);
	   nearestPixel = outline.get(0);
	   //LogRepository.getInstance().getJonsLogger().info("Nearest Pixel " + nearestPixel.distanceFromPreciseCenter + " " + nearestPixel.x + " " + nearestPixel.y);
	   for (int i = 1; i < outline.size(); i++) {
		   pTest = outline.get(i);
		   if (pTest.distanceFromPreciseCenter > farthestPixel.distanceFromPreciseCenter) {
			   farthestPixel = pTest;
		   }
		   if (pTest.distanceFromPreciseCenter < nearestPixel.distanceFromPreciseCenter) {
			   nearestPixel = pTest;
			   //LogRepository.getInstance().getJonsLogger().info("Nearest Pixel Candidate " + nearestPixel.distanceFromPreciseCenter);
		   }
	   }
	   
	   farPixels.add(farthestPixel);
	   nearPixels.add(nearestPixel);
	   //LogRepository.getInstance().getJonsLogger().info("Nearest Pixel Set " + nearestPixel.distanceFromPreciseCenter);
	   
	   
	   double upperBoundsFar;
	   double lowerBoundsFar;
	   double upperBoundsNear;
	   double lowerBoundsNear;
	   
	   
	   
	   //Want to get 4 other extremities
	   for (int j = 0; j < 4; j++) {
		   //last added pixel is the farthest pixel
		   tempPixelFar = farthestPixel;
		   tempPixelNear = nearestPixel;
//		   LogRepository.getInstance().getJonsLogger().info("Current Angle " + tempPixel.angle);
		   //generate upper and lower bounds to search in
		   upperBoundsFar = tempPixelFar.angle + 90;
		   lowerBoundsFar = tempPixelFar.angle + 18;
		   upperBoundsNear = tempPixelNear.angle + 90;
		   lowerBoundsNear = tempPixelNear.angle + 18;
//		   LogRepository.getInstance().getJonsLogger().info("UpperBounds " + upperBounds);
//		   LogRepository.getInstance().getJonsLogger().info("LowerBounds " + lowerBounds);
		   //validate bounds
		   if (upperBoundsFar > 360) {
			   upperBoundsFar -= 360;
		   }
		   if (lowerBoundsFar < 0) {
			   lowerBoundsFar = 360 - lowerBoundsFar;
		   }
		   if (upperBoundsNear > 360) {
			   upperBoundsNear -= 360;
		   }
		   if (lowerBoundsNear < 0) {
			   lowerBoundsNear = 360 - lowerBoundsNear;
		   }
//		   LogRepository.getInstance().getJonsLogger().info("Validated UpperBounds " + upperBounds);
//		   LogRepository.getInstance().getJonsLogger().info("Validated LowerBounds " + lowerBounds);
		   //start at the beginning of the list
		   farthestPixel = outline.get(0);
		   nearestPixel = outline.get(0);
		   for (int i = 1; i < outline.size(); i++) {
			   pTest = outline.get(i);
			   
			   //difference = Math.abs(pTest.angle - tempPixel.angle);
			   boolean inRangeFar = false;
			   boolean inRangeNear = false;
			   
			   if (lowerBoundsFar > upperBoundsFar) {
				   if ((pTest.angle >= lowerBoundsFar && pTest.angle <= 360) || (pTest.angle <= upperBoundsFar && pTest.angle >= 0)) {
					   inRangeFar = true;
//					   LogRepository.getInstance().getJonsLogger().info("Overlap in Range " + pTest.angle);
				   }
			   }
			   else if (pTest.angle >= lowerBoundsFar && pTest.angle <= upperBoundsFar){
				   inRangeFar = true;
//				   LogRepository.getInstance().getJonsLogger().info("Regualr in Range " + pTest.angle);
			   }
			   
			   if (lowerBoundsNear > upperBoundsNear) {
				   if ((pTest.angle >= lowerBoundsNear && pTest.angle <= 360) || (pTest.angle <= upperBoundsNear && pTest.angle >= 0)) {
					   inRangeNear = true;
					   //LogRepository.getInstance().getJonsLogger().info("Overlap in Range " + pTest.angle);
				   }
			   }
			   else if (pTest.angle >= lowerBoundsNear && pTest.angle <= upperBoundsNear){
				   inRangeNear = true;
				   //LogRepository.getInstance().getJonsLogger().info("Regualr in Range " + pTest.angle);
			   }
			   
			   if (inRangeFar) {
				   if (pTest.distanceFromPreciseCenter > farthestPixel.distanceFromPreciseCenter) {
					   farthestPixel = pTest;
//					   //LogRepository.getInstance().getJonsLogger().info("CHOSEN " + pTest.angle);
				   }
			   }
			   if (inRangeNear) {
				   if (pTest.distanceFromPreciseCenter < nearestPixel.distanceFromPreciseCenter) {
					   nearestPixel = pTest;
					   //LogRepository.getInstance().getJonsLogger().info("CHOSEN " + pTest.angle);
				   }
			   }
		   }
		   //LogRepository.getInstance().getJonsLogger().info("ACTUAL " + nearestPixel.angle);
		   farPixels.add(farthestPixel);
		   nearPixels.add(nearestPixel);
	   }
	   
	   
	   
	   
	   
	   pCenter = new PixelDataVO((pRight.x + pLeft.x + pTop.x + pBottom.x)/4, (pRight.y + pLeft.y + pTop.y + pBottom.y)/4, -1);
	   
	   LogRepository.getInstance().getJonsLogger().info("CENTER PIXEL " + pCenter.x + " " + pCenter.y);
	   
	   
		
	}
	
	
	@Override
	public void draw() {
		PApplet app = getApp();
		app.background(255);
		app.image(__originalImage, 0, 0);
		app.image(__debugImage, __originalImage.width, 0);
		app.image(__linkedImage, __originalImage.width * 2, 0);
		app.noStroke();
//		app.fill(255, 255, 0);
//		app.ellipse(pTop.x + __originalImage.width, pTop.y, 20, 20);
//		app.ellipse(pBottom.x + __originalImage.width, pBottom.y, 20, 20);
//		app.ellipse(pRight.x + __originalImage.width, pRight.y, 20, 20);
//		app.ellipse(pLeft.x + __originalImage.width, pLeft.y, 20, 20);
		
//		app.fill(0, 255, 0);
//		app.ellipse(pCenter.x + __originalImage.width, pCenter.y, 20, 20);
		
		app.fill(0, 0, 255);
		app.ellipse(preciseCenter.x + __originalImage.width, preciseCenter.y, 20, 20);
		//app.ellipse(farthestPixel.x + __originalImage.width, farthestPixel.y, 20, 20);
		
		app.noFill();
		
//		app.stroke(255, 0, 0);
//		app.rect(pLeft.x + __originalImage.width, pTop.y, pRight.x - pLeft.x, pBottom.y - pTop.y);
		
//		app.strokeWeight(3);
//		app.stroke(0, 0, 255);
//		
//		for (int i = 0; i < farPixels.size(); i++) {
//			app.line(preciseCenter.x + __originalImage.width, preciseCenter.y, farPixels.get(i).x + __originalImage.width, farPixels.get(i).y);
//		}
		
//		app.stroke(255, 0, 255);
//		
//		for (int i = 0; i < nearPixels.size(); i++) {
//			app.line(preciseCenter.x + __originalImage.width, preciseCenter.y, nearPixels.get(i).x + __originalImage.width, nearPixels.get(i).y);
//		}
		
		app.stroke(255, 0, 255);
		for (int i = 0; i < edges.size(); i++) {
			app.line(edges.get(i).p1.x, edges.get(i).p1.y, edges.get(i).p2.x, edges.get(i).p2.y);
		}
		
//		LogRepository.getInstance().getJonsLogger().info("RenderCount " + renderCount);

//		currentNode = startingNode;
//		currentNode.rendered = true;
//		int renderCount = 0;
//		int renderSkip = 25;
//		while (true) {
//			renderCount++;
//			tempNode = currentNode;
//			for (int i = 0; i < renderSkip; i++) {
//				nextNode = tempNode.next;
//				nextNode.rendered = true;
//				tempNode = nextNode;
//			}
//			nextNode = tempNode.next;
//			app.line(currentNode.x, currentNode.y, nextNode.x, nextNode.y);
//			currentNode = nextNode;
//			if (currentNode.rendered) {
//				break;
//			}
//		}
		
//		PApplet.println("RenderCount " + renderCount);
		
	}
}
