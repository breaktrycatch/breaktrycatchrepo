package com.breaktrycatch.needmorehumans.control.video.plugins;

import java.util.HashMap;

import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class ContrastPlugin extends ProcessorPlugin
{

	public ContrastPlugin(ProcessorPipeline p, String id)
	{
		super(p, id);
	}

	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		return null;
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		int min = Integer.MAX_VALUE;
		int max = Integer.MIN_VALUE;
		int size = pixels.length;
		for (int i = 0; i < size; i++)
		{
			int p = pixels[i];
			int b = ( ((p >> 16) & 0xFF) + ((p >> 8) & 0xFF) + ((p) & 0xFF) ) / 3;
            if (b < min)
            	min = b;
            if (b > max)
            	max = b;

		}

		for (int i = 0; i < size; i++)
		{
			int pixel = pixels[i];

	        double delta = max - min;
	        double PI_2 = Math.PI / 2.0;

	        double red =   ((double) (((pixel >> 16) & 0xFF) - min)) * Math.PI / delta - PI_2;
	        if (red > PI_2)
	                red = PI_2;
	        else if (red < -PI_2)
	                red = -PI_2;

	        double green = ((double) (((pixel >> 8) & 0xFF) - min)) * Math.PI / delta - PI_2;
	        if (green > PI_2)
	                green = PI_2;
	        else if (green < -PI_2)
	                green = -PI_2;

	        double blue =  ((double) (((pixel) & 0xFF) - min)) * Math.PI / delta - PI_2;
	        if (blue > PI_2)
	                blue = PI_2;
	        else if (blue < -PI_2)
	                blue = -PI_2;

	        //System.out.print("(" + red + ", " + green + ", " + blue + ")");

	        red   = Math.sin(red);
	        green = Math.sin(green);
	        blue  = Math.sin(blue);

	        int r = (int) Math.round((red   + 1.0) * 255.0 / 2.0);
	        int g = (int) Math.round((green + 1.0) * 255.0 / 2.0);
	        int b = (int) Math.round((blue  + 1.0) * 255.0 / 2.0);

	        //System.out.println(" => (" + r + ", " + g + ", " + b + ")");

	        pixels[i] = (255 << 24) | (r << 16) | (g << 8) | (b);

		}
		return pixels;
	}

}
