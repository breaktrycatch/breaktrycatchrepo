package com.breaktrycatch.needmorehumans.utils;

import processing.core.PImage;

public class ImageUtils
{
	public static PImage cloneImage(PImage target)
	{
		PImage cloned = null;
		try
		{
			cloned = (PImage) target.clone();
		} catch (CloneNotSupportedException e)
		{
			e.printStackTrace();
		}
		return cloned;

	}
}
