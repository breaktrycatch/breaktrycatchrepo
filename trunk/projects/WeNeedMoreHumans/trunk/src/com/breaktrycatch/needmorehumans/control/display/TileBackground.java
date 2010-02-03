package com.breaktrycatch.needmorehumans.control.display;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.ImageFrame;

public class TileBackground extends ImageFrame
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public int maxSize;

	private int _maxImages;
	private ArrayList<ImageFrame> _images;

	public TileBackground(PApplet app, PImage img, int maxSize)
	{
		super(app, img);

		this.maxSize = maxSize;

		_maxImages = (int) Math.ceil((float)maxSize / (float)img.width) + 1;
		_images = new ArrayList<ImageFrame>();
		
		for (int i = 0; i < _maxImages; i++)
		{
			ImageFrame frame = new ImageFrame(app, img);
			_images.add(frame);
			add(frame);
		}
	}

	@Override
	public void draw()
	{
		for (int i = 0; i < _maxImages; i++)
		{
			_images.get(i).x = _img.width * (i - 1);
		}
		
		super.draw();
	}
}