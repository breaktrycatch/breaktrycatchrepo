package com.breaktrycatch.needmorehumans.tracing;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.needmorehumans.tracing.algorithms.BetterRelevancy;
import com.breaktrycatch.needmorehumans.tracing.earClipping.EarClipping;
import com.breaktrycatch.needmorehumans.tracing.earClipping.Polygon;
import com.breaktrycatch.needmorehumans.tracing.earClipping.Triangle;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class ImageAnalysis {
	
	
	private PImage __originalImage;
	private PApplet app;
	
	
	private ArrayList<PixelVO> pixelOutline;
	private ArrayList<PixelVO> orderedPixelOutline;
	private ArrayList<PixelVO> culledSimplePixelOutline;
	
	private ArrayList<EdgeVO> edges;
	private ArrayList<EdgeVO> culledEdges;
	
	private ArrayList<Triangle> triangles;
	private ArrayList<Polygon> polygons;
	
	private final int START_FOUND = 0;
	private final int PIXEL_VALID = 1;
	private final int PIXEL_INVALID = 2;
	
	
	public ImageAnalysis(PApplet _app) {
		// TODO Auto-generated constructor stub
		app = _app;
	}
	
	public void draw() {
		//Draw the original image
		app.background(255);
		app.image(__originalImage, 0, 0);
		
		//Draw the outline
		app.stroke(255, 0, 0);
		int offset = __originalImage.width;
		for (int i = 0; i < pixelOutline.size(); i++) {
			app.point(pixelOutline.get(i).x + offset, pixelOutline.get(i).y);
		}
		
		//Draw the ordered outline
		app.stroke(0, 255, 0);
		offset = __originalImage.width * 2;
		for (int i = 0; i < orderedPixelOutline.size(); i++) {
			app.point(orderedPixelOutline.get(i).x + offset, orderedPixelOutline.get(i).y);
		}
		
		//Draw the culled simple outline
		app.stroke(0, 0, 255);
		offset = __originalImage.width * 3;
		for (int i = 0; i < culledSimplePixelOutline.size(); i++) {
			app.point(culledSimplePixelOutline.get(i).x + offset, culledSimplePixelOutline.get(i).y);
		}
		
		//Draw the edges
		app.stroke(255, 0, 255);
		offset = __originalImage.width * 4;
		for (int i = 0; i < edges.size(); i++) {
			app.line(edges.get(i).p1.x + offset, edges.get(i).p1.y, edges.get(i).p2.x + offset, edges.get(i).p2.y);
		}
		
		//Draw the culled edges
		app.stroke(0, 255, 255);
		offset = __originalImage.width * 5;
		for (int i = 0; i < culledEdges.size(); i++) {
			app.line(culledEdges.get(i).p1.x + offset, culledEdges.get(i).p1.y, culledEdges.get(i).p2.x + offset, culledEdges.get(i).p2.y);
		}
	}
	
	public void analyzeImage(String _path) {
		
		__originalImage = app.loadImage(_path);
		__originalImage.loadPixels();
		
		determinePixelOutline();
			LogRepository.getInstance().getJonsLogger().info("NUMBER OF PIXELS IN OUTLINE " + pixelOutline.size());
		orderPixels();
			LogRepository.getInstance().getJonsLogger().info("NUMBER OF PIXELS IN ORDERED OUTLINE " + orderedPixelOutline.size());
		cullSimple();
			LogRepository.getInstance().getJonsLogger().info("NUMBER OF PIXELS IN CULLED ORDERED OUTLINE " + culledSimplePixelOutline.size());
		constructEdges();
			LogRepository.getInstance().getJonsLogger().info("NUMBER OF EDGES " + edges.size());
		cullEdges();
			LogRepository.getInstance().getJonsLogger().info("NUMBER OF CULLED EDGES " + culledEdges.size());
		convertToPolys();
			LogRepository.getInstance().getJonsLogger().info("TRIANGLES CREATED " + triangles.size());
			LogRepository.getInstance().getJonsLogger().info("POLYGONS CREATED " + polygons.size());
	}
	
	private void determinePixelOutline() {
		//Index in the pixels array of the image
	    int index;
	    //Whether we are in negative or positive space
	    boolean negativeSpace = true;
	    
	    //Constructs the pixelOutline array list
	    pixelOutline = new ArrayList<PixelVO>();
	    
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
	    	    		addPixelToList(pixelOutline, x, y, index);
	    			}
	    		}
	    		else {
	    			if (negativeSpace == false) {
	    				negativeSpace = true;
	    				addPixelToList(pixelOutline, x-1, y, index);
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
	    				addPixelToList(pixelOutline, x, y, index);
	    			}
	    		}
	    		else {
	    			if (negativeSpace == false) {
	    				negativeSpace = true;
	    				addPixelToList(pixelOutline, x, y-1, index);
	    			}
	    		}
	    	}
	    }
	}
	
	//TODO: Rare case where we have only 3 pixels. p1
	private void orderPixels() {
		PixelVO startPixel = pixelOutline.get(0);
		PixelVO currentPixel = startPixel;
		PixelVO checkPixel;
		
		ArrayList<ModVO> mods = new ArrayList<ModVO>();
		//RIGHT
		mods.add(new ModVO(1, 0));
		//DOWN
		mods.add(new ModVO(0, 1));
		//DOWN-RIGHT
		mods.add(new ModVO(1, 1));
		//LEFT
		mods.add(new ModVO(-1, 0));
		//DOWN - LEFT
		mods.add(new ModVO(-1, 1));
		//UP
		mods.add(new ModVO(0, -1));
		//UP - LEFT
		mods.add(new ModVO(-1, -1));
		//UP - RIGHT
		mods.add(new ModVO(1, -1));
		
		
		boolean found = false;
		
		searchLoop: while (found == false) {
			
			for (int i = 0; i < mods.size(); i++) {
				checkPixel = getPixelByXY(pixelOutline, currentPixel.x + mods.get(i).modX, currentPixel.y + mods.get(i).modY);
				switch (validatePixel(startPixel, currentPixel, checkPixel)) {
					case START_FOUND:
						found = true;
						break searchLoop;
					
					case PIXEL_VALID:
						currentPixel = checkPixel;
						continue searchLoop;
					
				}
			}
			
			//LogRepository.getInstance().getJonsLogger().info("NO PIXEL FOUND ALL AROUND!");
			currentPixel = currentPixel.prev;
		}
		
		orderedPixelOutline = new ArrayList<PixelVO>();
		
		currentPixel = startPixel;
		orderedPixelOutline.add(currentPixel);
		currentPixel.id = 0;
		found = false;
		int pid = 1;
		
		orderLoop: while (found == false) {
			checkPixel = currentPixel.next;
			if (checkPixel.x == startPixel.x && checkPixel.y == startPixel.y) {
				found = true;
				break orderLoop;
			}
			orderedPixelOutline.add(checkPixel);
			checkPixel.id = pid;
			pid++;
			currentPixel = checkPixel;
		}
		
	}
	
	private void cullSimple() {
		culledSimplePixelOutline = new ArrayList<PixelVO>();
		orderedPixelOutline.get(0).saveFromSimpleCulling = true;
		int skip = 5;
		//removes every 
		for (int i = 1; i < orderedPixelOutline.size(); i++) {
			if (i%skip == 0) {
				//LogRepository.getInstance().getJonsLogger().info("MODDING OUT PIXEL " + i + " " + skip);
				orderedPixelOutline.get(i).saveFromSimpleCulling = true;
			}
		}
		
		for (int i = 0; i < orderedPixelOutline.size(); i++) {
			if (orderedPixelOutline.get(i).saveFromSimpleCulling == true) {
				culledSimplePixelOutline.add(orderedPixelOutline.get(i));
			}
		}
	}
	
	private void constructEdges() {
		
		edges = new ArrayList<EdgeVO>();
		
		PixelVO startPixel = culledSimplePixelOutline.get(0);
		PixelVO currentPixel = startPixel;
		PixelVO nextPixel;
		
		int index;
		
		for (int i = 1; i < culledSimplePixelOutline.size(); i++) {
			index = i+1;
			if (index >= culledSimplePixelOutline.size()) {
				index = 0;
			}
			nextPixel = culledSimplePixelOutline.get(index);
			edges.add(new EdgeVO(currentPixel, nextPixel));
			currentPixel = nextPixel;
		}
	}
	
	private void cullEdges() {
		
		culledEdges = new ArrayList<EdgeVO>();
		
		EdgeVO nextEdge;
		EdgeVO currentEdge;
		EdgeVO linkedEdge = null;
		EdgeVO addedEdge;
		int index = 0;
		
		for (int i = 0; i < edges.size(); i++) {
			currentEdge = edges.get(i);
			index = i+1;
			if (index >= edges.size()) {
				index = 0;
			}
			nextEdge = edges.get(index);
			
			double relevancy = BetterRelevancy.calculate(currentEdge, nextEdge);
			
			if (relevancy < 50) {
				currentEdge.markForCulling = true;
			}
		}
		
		for (int i = 0; i < edges.size(); i++) {
			currentEdge = edges.get(i);
			if (currentEdge.markForCulling == false) {
				addedEdge = new EdgeVO(currentEdge.p1, currentEdge.p2);
				culledEdges.add(addedEdge);
				if (linkedEdge == null) {
					linkedEdge = addedEdge;
				}
				else {
					linkedEdge.p2 = addedEdge.p1;
					addedEdge.p1 = linkedEdge.p2;
					linkedEdge = addedEdge;
				}
			}
		}
	
	}
	
	private void convertToPolys() {
		EarClipping earClipping = new EarClipping();
		float x[] = new float[culledEdges.size()];
		float y[] = new float[culledEdges.size()];
		for (int i = culledEdges.size() - 1; i >= 0; i--) {
			x[i] = culledEdges.get(i).p1.x;
			y[i] = culledEdges.get(i).p1.y;
		}
		
		Triangle[] tArray = earClipping.createTriangles(x, y, culledEdges.size());
		
		
		if (tArray != null) {
			triangles = new ArrayList<Triangle>();
			for (int i = 0; i < tArray.length; i++) {
				triangles.add(tArray[i]);
			}
			
			
			Polygon[] pArray = earClipping.createPolys(tArray);
			
			if (pArray != null) {
				polygons = new ArrayList<Polygon>();
				for (int i = 0; i < pArray.length; i++) {
					polygons.add(pArray[i]);
				}
			}
			else {
				LogRepository.getInstance().getJonsLogger().info("PARRAY IS NULL!");
			}
			
		}
		else {
			LogRepository.getInstance().getJonsLogger().info("TARRAY IS NULL!");
		}
		
		
		
	}
	
	//HELPERS
	
	private PixelVO getPixelByXY(ArrayList<PixelVO> _list, int _x, int _y) {
		for (int i = 0; i < _list.size(); i++) {
			if (_list.get(i).x == _x && _list.get(i).y == _y) {
				return _list.get(i);
			}
		}
		return null;
	}
	
	private int validatePixel(PixelVO _start, PixelVO _current, PixelVO _check) {
		if (_check != null) {
			if (_check.marked == false) {
				_check.marked = true;
				_current.next = _check;
				_check.prev = _current;
				_current = _check;
				if (_current.x == _start.x && _current.y == _start.y) {
					LogRepository.getInstance().getJonsLogger().info("FOUND START RIGHT");
					return START_FOUND;
				}
				return PIXEL_VALID;
			}
			return PIXEL_INVALID;
		}
		return PIXEL_INVALID;
	}
	
	protected void addPixelToList(ArrayList<PixelVO> _list, int _x, int _y, int _index) {
		if (isDuplicatePixel(_list, _x, _y) == false) {
			_list.add(new PixelVO(_x, _y, _index));
		}
	}
	protected boolean isDuplicatePixel(ArrayList<PixelVO> _list, int _x, int _y) {
		 for (int i = 0; i < _list.size(); i++) {
			 if (_list.get(i).x == _x && _list.get(i).y == _y) {
				 return true;
			 }
		 }
		 return false;
	}

}
