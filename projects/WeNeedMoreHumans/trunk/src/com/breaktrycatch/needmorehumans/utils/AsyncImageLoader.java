package com.breaktrycatch.needmorehumans.utils;

import processing.core.PApplet;
import processing.core.PImage;

public class AsyncImageLoader extends Thread
{
	static int loaderMax = 4;
	static int loaderCount;

	PApplet parent;
	String filename;
	PImage vessel;

	public AsyncImageLoader(PApplet parent, String filename, PImage vessel)
	{
		this.parent = parent;
		this.filename = filename;
		this.vessel = vessel;
	}

	public void run()
	{
		while (loaderCount == loaderMax)
		{
			try
			{
				Thread.sleep(10);
			} catch (InterruptedException e)
			{
			}
		}
		loaderCount++;

		PImage actual = parent.loadImage(filename);
		if (actual == null)
		{
			vessel.width = -1;
			vessel.height = -1;

		} else
		{
			vessel.width = actual.width;
			vessel.height = actual.height;
			vessel.format = actual.format;
			vessel.pixels = actual.pixels;
		}
		loaderCount--;
	}
}
