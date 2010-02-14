package com.breaktrycatch.needmorehumans.control.display;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.ImageFrame;

abstract class AbstractTileBackground extends ImageFrame
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public float maxSize;

	protected int _maxImages;
	protected ArrayList<ImageFrame> _images;

	public AbstractTileBackground(PApplet app, PImage img, float maxSize)
	{
		super(app, img);

		this.maxSize = maxSize;

		_maxImages = calculateMaxImages();
		_images = new ArrayList<ImageFrame>();
		
		for (int i = 0; i < _maxImages; i++)
		{
			ImageFrame frame = new ImageFrame(app, img);

			frame.setScaleAroundCenter(true);
			frame.scaleX = frame.scaleY = 1.01f;
			_images.add(frame);
			add(frame);
		}
	}
	
	public ArrayList<ImageFrame> getImages()
	{
		return _images;
	}
	
	abstract protected int calculateMaxImages();
}
