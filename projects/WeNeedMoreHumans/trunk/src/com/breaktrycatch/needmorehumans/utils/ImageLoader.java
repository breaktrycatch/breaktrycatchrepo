package com.breaktrycatch.needmorehumans.utils;

import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Toolkit;
import java.net.URL;

import processing.core.PApplet;
import processing.core.PImage;

public class ImageLoader
{
	PApplet parent;
	MediaTracker tracker;
	PImage[] images;
	Image[] awtImages;
	int count;
	boolean finished;

	public ImageLoader(PApplet parent)
	{
		this.parent = parent;
		tracker = new MediaTracker(parent);
		// Start with 100 possible elements and expand as necessary later
		images = new PImage[100];
		awtImages = new Image[100];
	}

	// This method loads images from the Internet, and can be substituted
	// for addFile when testing is finished and the application is deployed.
	public PImage addURL(String url)
	{
		try
		{
			return add(Toolkit.getDefaultToolkit().getImage(new URL(url)));
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;
	}

	public PImage addFile(String path)
	{
		return add(Toolkit.getDefaultToolkit().getImage(path));
	}

	protected PImage add(Image img)
	{
		try
		{
			awtImages[count] = img;
			tracker.addImage(img, count);
			images[count] = new PImage();
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return images[count++];
	}


	public boolean isFinished()
	{
		if (finished)
		{
			return true;
		}
		if (tracker.checkAll())
		{
			finish();
			return true;
		}
		return false;
	}

	public void finish()
	{
		try
		{
			tracker.waitForAll();
		} catch (InterruptedException e)
		{
		}

		for (int i = 0; i < count; i++)
		{
			if (!tracker.isErrorID(i))
			{
				Image img = awtImages[i];
				PImage temp = new PImage(img);
				// Replace the image data without changing the PImage object
				// reference
				images[i].width = temp.width;
				images[i].height = temp.height;
				images[i].format = temp.format;
				images[i].pixels = temp.pixels;
			}
		}
		finished = true;
	}
}