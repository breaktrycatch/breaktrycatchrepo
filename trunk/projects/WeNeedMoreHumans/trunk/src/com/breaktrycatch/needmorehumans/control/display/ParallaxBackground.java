package com.breaktrycatch.needmorehumans.control.display;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;

public class ParallaxBackground extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int _maxWidth = 1000;

	private ArrayList<ParallaxLayer> _layers;

	public ParallaxBackground(PApplet app, int maxWidth)
	{
		super(app);

		_maxWidth = maxWidth;
		_layers = new ArrayList<ParallaxLayer>();
	}

	public DisplayObject addTilingLayer(PImage image, float movementAmt)
	{
		return internalAddLayer(new TileBackground(getApp(), image, _maxWidth), movementAmt);
	}

	public DisplayObject addLayer(PImage image, float movementAmt)
	{
		return internalAddLayer(new ImageFrame(getApp(), image), movementAmt);
	}
	
	public DisplayObject addLayer(DisplayObject display, float movementAmt)
	{
		return internalAddLayer(display, movementAmt);
	}

	private DisplayObject internalAddLayer(DisplayObject layer, float movementAmt)
	{
		add(layer);

		_layers.add(new ParallaxLayer(layer, movementAmt));
		return layer;
	}

	public void draw()
	{
		for (ParallaxLayer layer : _layers)
		{
			layer.image.x = -(x * (1 - layer.movementAmt));
		}

		super.draw();
	}
}

class ParallaxLayer
{
	public DisplayObject image;
	public float movementAmt;

	public ParallaxLayer(DisplayObject image, float movementAmt)
	{
		this.image = image;
		this.movementAmt = movementAmt;
	}
}
