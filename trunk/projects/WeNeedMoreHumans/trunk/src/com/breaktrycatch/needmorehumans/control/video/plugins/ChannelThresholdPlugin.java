package com.breaktrycatch.needmorehumans.control.video.plugins;

import java.util.HashMap;

import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class ChannelThresholdPlugin extends ProcessorPlugin
{

	public static final String CHANNEL_THRESHOLD = "com.breaktrycatch.needmorehumans.control.video.plugins.ChannelThresholdPlugin.CHANNEL_THRESHOLD";
	public static final String CHANNEL = "com.breaktrycatch.needmorehumans.control.video.plugins.ChannelThresholdPlugin.CHANNEL";

	private int channelThreshold = 123;
	private int channel = 24;

	public static final int ALPHA = 24;
	public static final int RED = 16;
	public static final int GREEB = 8;
	public static final int BLUE = 0;

	public ChannelThresholdPlugin(ProcessorPipeline p, String id)
	{
		super(p, id);
	}

	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		HashMap<String, Comparable<?>> config = new HashMap<String, Comparable<?>>();
		config.put(CHANNEL_THRESHOLD, new Integer(channelThreshold));
		config.put(CHANNEL, new Integer(channel));
		return config;
	}

	@Override
	public void configure(HashMap<String, Comparable<?>> conf)
	{
		channelThreshold = ((Integer) conf.get(CHANNEL_THRESHOLD)).intValue();
		channel = ((Integer) conf.get(CHANNEL)).intValue();
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		for (int i = 0; i < pixels.length; i++)
		{
			int alpha = (pixels[i] >> channel) & 0xFF;
			pixels[i] = alpha > channelThreshold ? 0xffffffff : 0;
		}
		return pixels;
	}
}
