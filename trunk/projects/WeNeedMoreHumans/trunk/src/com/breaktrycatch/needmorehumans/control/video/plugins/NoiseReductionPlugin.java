package com.breaktrycatch.needmorehumans.control.video.plugins;

import java.util.HashMap;

import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class NoiseReductionPlugin extends ProcessorPlugin
{
	public static final String KERNEL = "com.breaktrycatch.needmorehumans.control.video.plugins.NoiseReductionPlugin.KERNEL";
	public static final String THRESHOLD = "com.breaktrycatch.needmorehumans.control.video.plugins.NoiseReductionPlugin.THRESHOLD";
	
	private int kernel = 1;
	private int threshold = 30;
	
	public NoiseReductionPlugin(ProcessorPipeline p, String id)
	{
		super(p, id);
	}

	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		HashMap<String, Comparable<?>> config = new HashMap<String, Comparable<?>>();
		config.put(KERNEL, new Integer(kernel));
		config.put(THRESHOLD, new Integer(threshold));
		return config;
	}

	@Override
	public void configure(HashMap<String, Object> conf)
	{
		kernel = ((Integer) conf.get(KERNEL)).intValue();
		threshold = ((Integer) conf.get(THRESHOLD)).intValue();
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		for (int y = 0; y < h; y++)
		{
			for (int x = 0; x < w; x++)
			{

				int alpha = (pixels[y * w + x] >> 24) & 0xFF;
				if(alpha == 0)
				{
					continue;
				}
				
				int sumR = 0;
				int sumG = 0;
				int sumB = 0;

				// Convolute across the image, averages out the pixels to remove
				// noise
				for (int i = -kernel; i <= kernel; i++)
				{
					for (int j = -kernel; j <= kernel; j++)
					{
						
						// for alpha = 0 pixels don't perform edge detection on them.
						if ( y + j < 0 || y + j > h - 1 || x + i < 0 || x + i > w - 1)
						{
							continue;
						}
						
						int col = pixels[(y + j) * w + (x + i)];
						int r = (col >> 16) & 0xFF;
						int g = (col >> 8) & 0xFF;
						int b = col & 0xFF;

						if (r > threshold)
							sumR++;
						if (g > threshold)
							sumG++;
						if (b > threshold)
							sumB++;
					}
				}

				int halfKernel = (((kernel * 2) + 1) * ((kernel * 2) + 1)) / 2;

				if (sumR > halfKernel)
					sumR = 255;
				else
					sumR = 0;
				if (sumG > halfKernel)
					sumG = 255;
				else
					sumG = 0;
				if (sumB > halfKernel)
					sumB = 255;
				else
					sumB = 0;

				pixels[y * w + x] = (255 << 24 | sumR << 16 | sumG << 8 | sumB);

			}

		}
		return pixels;
	}

}
