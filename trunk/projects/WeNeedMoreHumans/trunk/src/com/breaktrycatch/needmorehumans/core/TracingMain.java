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
		
	}
	
	public void draw() {
		background(255);
		image(__originalImage, 0, 0);
	}


}
