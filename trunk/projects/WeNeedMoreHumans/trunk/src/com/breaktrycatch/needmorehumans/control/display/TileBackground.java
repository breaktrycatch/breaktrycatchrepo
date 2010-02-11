package com.breaktrycatch.needmorehumans.control.display;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;

public class TileBackground extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ArrayList<ImageFrame> _images;
	private int _maxImages;
	private PImage _img;

	public TileBackground(PApplet app, PImage img, float maxWidth, float maxHeight)
	{
		super(app);
		_img = img;
		_images = new ArrayList<ImageFrame>();
		_maxImages = (int) Math.ceil((float) maxWidth / (float) img.width) + 1;
		for (int i = 0; i < _maxImages; i++)
		{
			ImageFrame frame = new VerticalTileBackground(app, img, maxHeight);
			_images.add(frame);
			add(frame);
		}
	}

	@Override
	public void draw()
	{
		for (int i = 0; i < _maxImages; i++)
		{
			_images.get(i).x = _img.width * (i - (int)(_maxImages / 2));
		}
	}
}