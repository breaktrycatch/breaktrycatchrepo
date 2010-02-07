package com.breaktrycatch.needmorehumans.control.webcam;

import java.util.ArrayList;

import processing.core.PImage;

public class CaptureValidator
{
	public static ArrayList<PImage> validateList(ArrayList<PImage> images)
	{
		for (int i = images.size() - 1; i >= 0; i--)
		{
			PImage img = images.get(i);
			if (img.width <= 0 || img.height <= 0)
			{
				images.remove(img);
			}
			// TODO: Trap images that are > 60% opaque. They
			// are too big and we had a lighting glitch.
			// TODO: Trap images that are < 10% opaque. They
			// don't have a person in it!
		}

		return images;
	}
}
