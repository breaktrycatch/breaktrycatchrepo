package com.breaktrycatch.needmorehumans.control.video.plugins;

import java.util.HashMap;

import com.breaktrycatch.needmorehumans.utils.LogRepository;

import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class GapFillPlugin extends ProcessorPlugin
{
	public static final String GAP_FILL = "com.breaktrycatch.needmorehumans.control.video.plugins.GAP_FILL";
	public static final String START_THRESHOLD = "com.breaktrycatch.needmorehumans.control.video.plugins.START_THRESHOLD";
	public static final String END_THRESHOLD = "com.breaktrycatch.needmorehumans.control.video.plugins.END_THRESHOLD";
	
	private int gapFillSize = 3;

	// if the pixel is less than the startThreshold, we consider this 'positive
	// space'
	private int startThreshold = 200;

	// while in positive space if we find a pixel that is less than the
	// endThreshold, we end our positive space search.
	private int endThrshold = 50;

	public GapFillPlugin(ProcessorPipeline p, String id)
	{
		super(p, id);
	}

	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		LogRepository.getInstance().getPaulsLogger().info("Created hash!");
		
		HashMap<String, Comparable<?>> config = new HashMap<String, Comparable<?>>();
		config.put(GAP_FILL, new Integer(gapFillSize));
		config.put(START_THRESHOLD, new Integer(startThreshold));
		config.put(END_THRESHOLD, new Integer(endThrshold));
		return config;
	}

	@Override
	public void configure(HashMap<String, Comparable<?>> conf)
	{
		gapFillSize = ((Integer) conf.get(GAP_FILL)).intValue();
		startThreshold = ((Integer) conf.get(START_THRESHOLD)).intValue();
		endThrshold = ((Integer) conf.get(END_THRESHOLD)).intValue();
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		pixels = fillHorizontalGaps(pixels, w, h);
		pixels = fillVerticalGaps(pixels, w, h);
		return pixels;
	}

	private int[] fillVerticalGaps(int[] pixels, int w, int h)
	{
		int i = 0;
		for (int x = 0; x < w; x++)
		{
			int startY = -1;
			int possibleFillStart = -1;
			for (int y = 0; y < h; y++)
			{
				i = y * w + x;
				float blue = pixels[i] & 0xFF;
				
				// we're in 'positive space'
				if (startY != -1)
				{
					if (possibleFillStart != -1 && blue >= endThrshold)
					{
						int gapSize = possibleFillStart - startY;
						if (gapSize < gapFillSize)
						{
							for (int k = 0; k <= gapSize; k++)
							{
								int pos = x + (startY + k) * w;
								pixels[pos] = (255 << 24 | 0 << 16 | 255 << 8 | 255);
							}
						}
						
						// reset our search.
						startY = -1;
						possibleFillStart = -1;
					}

					if (blue <= startThreshold)
					{
						possibleFillStart = y;
					}
				}

				if (blue > startThreshold)
				{
					startY = y;
				}
			}
		}
		return pixels;
	}

	private int[] fillHorizontalGaps(int[] pixels, int w, int h)
	{
		int i = 0;
		for (int y = 0; y < h; y++)
		{
			int startX = -1;
			int possibleFillStart = -1;
			for (int x = 0; x < w; x++)
			{
				float blue = pixels[i] & 0xFF;

				if (startX != -1)
				{
					if (possibleFillStart != -1 && blue >= endThrshold)
					{
						int gapSize = possibleFillStart - startX;
						if (gapSize < gapFillSize)
						{
							for (int k = 0; k <= gapSize; k++)
							{
								int pos = y * w + startX + k;
								pixels[pos] = (255 << 24 | 255 << 16 | 0 << 8 | 255);
							}
						}
						startX = -1;
						possibleFillStart = -1;
					}

					if (blue <= startThreshold)
					{
						possibleFillStart = x;
					}
				}

				if (blue > startThreshold)
				{
					startX = x;
				}

				i++;
			}
		}
		return pixels;
	}

}
