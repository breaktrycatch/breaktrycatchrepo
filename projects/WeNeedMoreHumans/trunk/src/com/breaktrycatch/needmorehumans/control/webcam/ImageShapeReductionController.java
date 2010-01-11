package com.breaktrycatch.needmorehumans.control.webcam;

import processing.core.PImage;

public class ImageShapeReductionController
{
	private PImage _target;

	public ImageShapeReductionController(PImage target)
	{
		setTarget(target);
	}

	public void setTarget(PImage target)
	{
		_target = target;
	}
	
	public void getPrimitives()
	{
		
	}
}
