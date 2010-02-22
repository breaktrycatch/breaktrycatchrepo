package com.breaktrycatch.needmorehumans.utils;

import processing.core.PApplet;
import processing.core.PFont;

import com.breaktrycatch.lib.display.DisplayObject;

/**
 * fpscounter taken from http://processinghacks.com/hacks:fpscounter
 * 
 * @author mflux
 * @author mbaker - Modified
 */

// The framerate counter
// To use this you must first do FPS.register(this) in your setup()
public class FPS extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static private int frames = 0;
	static private long startTime = 0;
	static private int fps = 0;
	static private PApplet p;

	static PFont font;
	static FPS instance;

	private static float _memory;

	public FPS(PApplet app)
	{
		super(app);

		if (instance != null)
		{
			throw new Error("[FPS] - Cannot instantiate, Class is a singleton!");
		}
	}

	public static FPS register(PApplet p)
	{

		if (instance == null)
		{
			instance = new FPS(p);
			instance.y = 35;
			font = p.createFont("Courier", 50);
			FPS.p = p;
			p.registerPost(instance);
		}

		return instance;
	}

	public static void frame()
	{
		if (startTime == 0)
			startTime = p.millis();
		frames++;
		long t = p.millis() - startTime;
		if (t > 1000)
		{
			fps = (int) (1000 * frames / t);
			startTime += t;
			frames = 0;
		}
		
		_memory = (float)(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / (float)Runtime.getRuntime().totalMemory();
		
	}

	static public int frameRate()
	{
		return fps;
	}

	public void post()
	{
		FPS.frame();
	}

	@Override
	public void draw()
	{
		PApplet app = getApp();
		
		// draw the fps counter
		app.noStroke();
		app.fill(0xffff00ff);
		app.textFont(font, 22);
		app.text("FPS: " + frameRate() + " MEM: " + (_memory * 100) + "%", 8, 24);
	}

}
