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
	public PImage img;

	private int _maxImages;
	private ArrayList<ImageFrame> _images;

	public TileBackground(PApplet app, PImage img, int maxSize)
	{
		super(app);

		this.maxSize = maxSize;
		this.img = img;

		_maxImages = (int) Math.ceil((float)maxSize / (float)img.width) + 1;
		_images = new ArrayList<ImageFrame>();
		
		PApplet.println("MAX IMG: " + maxSize + " / " + img.width);
		for (int i = 0; i < _maxImages; i++)
		{
			ImageFrame frame = new ImageFrame(app, img);
			_images.add(frame);
			add(frame);
		}
		PApplet.println("NUMCHILDREN: " + size() + " : " + _addList.size());
	}

	@Override
	public void draw()
	{
		for (int i = 0; i < _maxImages; i++)
		{
			_images.get(i).x = img.width * (i - 1);
		}
		
		super.draw();
	}
}