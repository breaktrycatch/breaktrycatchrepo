package com.breaktrycatch.needmorehumans.control.video.plugins;

import java.util.HashMap;

import processing.core.PApplet;
import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class SobelEdgeDetectionPlugin extends ProcessorPlugin
{
	public SobelEdgeDetectionPlugin(ProcessorPipeline p, String id)
	{
		super(p, id);
	}

	public static final String TOLERANCE = "com.breaktrycatch.needmorehumans.control.video.plugins.TOLERANCE";

	private int tolerance;

	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		HashMap<String, Comparable<?>> config = new HashMap<String, Comparable<?>>();
		config.put(TOLERANCE, new Integer(tolerance));
		return config;
	}

	@Override
	public void configure(HashMap<String, Comparable<?>> conf)
	{
		tolerance = ((Integer) conf.get(TOLERANCE)).intValue();
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		int GX[][] = new int[3][3];
		int GY[][] = new int[3][3];
		int sumRx = 0;
		int sumGx = 0;
		int sumBx = 0;
		int sumRy = 0;
		int sumGy = 0;
		int sumBy = 0;
		int finalSumR = 0;
		int finalSumG = 0;
		int finalSumB = 0;

		// 3x3 Sobel Mask for X
		GX[0][0] = -1;
		GX[0][1] = 0;
		GX[0][2] = 1;
		GX[1][0] = -2;
		GX[1][1] = 0;
		GX[1][2] = 2;
		GX[2][0] = -1;
		GX[2][1] = 0;
		GX[2][2] = 1;

		// 3x3 Sobel Mask for Y
		GY[0][0] = 1;
		GY[0][1] = 2;
		GY[0][2] = 1;
		GY[1][0] = 0;
		GY[1][1] = 0;
		GY[1][2] = 0;
		GY[2][0] = -1;
		GY[2][1] = -2;
		GY[2][2] = -1;

		for (int y = 0; y < h; y++)
		{
			for (int x = 0; x < w; x++)
			{
				int alpha = (pixels[y * w + x] >> 24) & 0xFF;
				
				
				PApplet.println("ALPJHA: " + alpha);
				
				// for alpha = 0 pixels dont perform edge detection on them.
				if (alpha == 0 || y == 0 || y == h - 1 || x == 0 || x == w - 1)
				{
					continue;
				}

				// Convolve across the X axis and return gradiant
				// aproximation
				for (int i = -1; i <= 1; i++)
				{
					for (int j = -1; j <= 1; j++)
					{
						int col = pixels[(y + j) * w + (x + i)];
						int r = (col >> 16) & 0xFF;
						int g = (col >> 8) & 0xFF;
						int b = col & 0xFF;

						sumRx += r * GX[i + 1][j + 1];
						sumGx += g * GX[i + 1][j + 1];
						sumBx += b * GX[i + 1][j + 1];
					}
				}
				// Convolve across the Y axis and return gradiant
				// aproximation
				for (int i = -1; i <= 1; i++)
				{
					for (int j = -1; j <= 1; j++)
					{
						int col = pixels[(y + j) * w + (x + i)];
						int r = (col >> 16) & 0xFF;
						int g = (col >> 8) & 0xFF;
						int b = col & 0xFF;

						sumRy += r * GY[i + 1][j + 1];
						sumGy += g * GY[i + 1][j + 1];
						sumBy += b * GY[i + 1][j + 1];

					}
				}

				finalSumR = PApplet.abs(sumRx) + PApplet.abs(sumRy);
				finalSumG = PApplet.abs(sumGx) + PApplet.abs(sumGy);
				finalSumB = PApplet.abs(sumBx) + PApplet.abs(sumBy);

				// I only want to return a black or a white value, here I
				// determine the greyscale value,
				// and if it is above a tolerance, then set the colour to
				// white

				float gray = (finalSumR + finalSumG + finalSumB) / 3;

				if (gray > tolerance)
				{
					finalSumR = 0;
					finalSumG = 0;
					finalSumB = 0;
				} else
				{
					finalSumR = 255;
					finalSumG = 255;
					finalSumB = 255;
				}

				pixels[y * w + x] = (255 << 24 | finalSumR << 16 | finalSumG << 8 | finalSumB);

				sumRx = 0;
				sumGx = 0;
				sumBx = 0;
				sumRy = 0;
				sumGy = 0;
				sumBy = 0;
			}

		}

		return pixels;
	}

}
