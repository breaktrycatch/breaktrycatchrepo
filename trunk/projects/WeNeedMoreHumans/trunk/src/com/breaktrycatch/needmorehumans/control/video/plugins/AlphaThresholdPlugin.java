package com.breaktrycatch.needmorehumans.control.video.plugins;

import java.util.HashMap;

import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class AlphaThresholdPlugin extends ProcessorPlugin
{

	public static final String ALPHA_THRESHOLD = "com.breaktrycatch.needmorehumans.control.video.plugins.ALPHA";
	private int alphaThreshold = 123;

	public AlphaThresholdPlugin(ProcessorPipeline p, String id)
	{
		super(p, id);
	}

	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		HashMap<String, Comparable<?>> config = new HashMap<String, Comparable<?>>();
		config.put(ALPHA_THRESHOLD, new Integer(alphaThreshold));
		return config;
	}

	@Override
	public void configure(HashMap<String, Object> conf)
	{
		alphaThreshold = ((Integer) conf.get(ALPHA_THRESHOLD)).intValue();
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		for (int i = 0; i < pixels.length; i++)
		{
			int alpha = (pixels[i] >> 24) & 0xFF;
			pixels[i] = alpha > alphaThreshold ? 0xffffffff : 0;
		}
		return pixels;
	}

}
