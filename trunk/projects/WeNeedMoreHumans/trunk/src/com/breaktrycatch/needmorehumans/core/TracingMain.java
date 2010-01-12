/**
 * 
 */
package com.breaktrycatch.needmorehumans.core;

import processing.core.PApplet;
import processing.core.PImage;

/**
 * @author jkeon
 *
 */
public class TracingMain extends PApplet {

	/**
	 * Main entry point for the application.
	 * 
	 * @param args
	 *            Command line arguments.
	 */
	public static void main(String args[])
	{
		PApplet.main(new String[] { "--present", "com.breaktrycatch.needmorehumans.core.TracingMain" });
	}
	
	
	private PImage __originalImage;
	private PImage __debugImage;
	
	public TracingMain()
	{
		// all PApplet related commands should be made in setup().
	}

	@Override
	public void setup()
	{
		super.setup();
		size(1680, 1050, P2D);
		frameRate(60);
	    background(255);

	    __originalImage = loadImage("TestPerson_png.png");
	    __originalImage.loadPixels();
	    __debugImage = loadImage("TestPerson_png.png");
	    __debugImage.loadPixels();
	    
	    int totalPixels = (__originalImage.width*__originalImage.height);
	    int index;
	    int left = __originalImage.width;
	    int right = 0;
	    int top = __originalImage.height;
	    int bottom = 0;
	   
	    
	    for (int y=0; y<__originalImage.height; y++) {
	    	for (int x=0; x<__originalImage.width; x++) {
	    		index = y*__originalImage.width + x;
	    		int pixel = __originalImage.pixels[index];
	    		if (pixel != 0x00FFFFFF) {
	    			if (x < left) {
	    				left = x;
	    			}
	    			if (x > right) {
	    				right = x;
	    			}
	    		}
	    	}
	    	if (left != __originalImage.width) {
	    		__debugImage.pixels[y*__originalImage.width + left] = 0xFFFF0000;
	    	}
	    	if (right != 0) {
	    		__debugImage.pixels[y*__originalImage.width + right] = 0xFFFF0000;
	    	}
	    	left = __originalImage.width;
	    	right = 0;
	    }
	    
	    for (int x=0; x<__originalImage.width; x++) {
	    	for (int y=0; y<__originalImage.height; y++) {
	    		index = y*__originalImage.width + x;
	    		int pixel = __originalImage.pixels[index];
	    		if (pixel != 0x00FFFFFF) {
	    			if (y < top) {
	    				top = y;
	    			}
	    			if (y > bottom) {
	    				bottom = y;
	    			}
	    		}
	    	}
	    	if (top != __originalImage.height) {
	    		__debugImage.pixels[top*__originalImage.width + x] = 0xFFFF0000;
	    	}
	    	if (bottom != 0) {
	    		__debugImage.pixels[bottom*__originalImage.width + x] = 0xFFFF0000;
	    	}
	    	top = __originalImage.height;
	    	bottom = 0;
	    }
	    
	    __debugImage.updatePixels();
	   
		
	}
	
	public void draw() {
		background(255);
		image(__originalImage, 0, 0);
		image(__debugImage, __originalImage.width, 0);
	}


}
