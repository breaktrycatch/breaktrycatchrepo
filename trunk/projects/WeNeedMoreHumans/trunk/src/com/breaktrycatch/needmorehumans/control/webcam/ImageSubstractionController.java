package com.breaktrycatch.needmorehumans.control.webcam;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;

public class ImageSubstractionController
{
	private PApplet _app;
	private PImage _backgroundImage;

	private int _differenceThreshold = 20;
	private float _blurAmount = 2;
	private int _activityLevel = 0;

	public ImageSubstractionController(PApplet app)
	{
		_app = app;
	}

	public ImageSubstractionController(PApplet app, PImage background)
	{
		this(app);
		setBackgroundImage(background);
	}

	public void setBackgroundImage(PImage background)
	{
		_backgroundImage = background;
		_backgroundImage.resize(_backgroundImage.width / 2, _backgroundImage.height / 2);
		_backgroundImage.filter(PApplet.BLUR, _blurAmount);
	}

	public PImage getBackgroundImage()
	{
		return _backgroundImage;
	}

	public float getActivityLevel()
	{
		return _activityLevel / (_backgroundImage.width * _backgroundImage.height);
	}

	public PImage calculateImageDifference(PImage foreground)
	{
		foreground.loadPixels();
		_backgroundImage.loadPixels();

		foreground.resize(foreground.width / 2, foreground.height / 2);

		if (!verifyIdenticalSize(foreground, _backgroundImage))
		{
			throw new Error("Foreground and Background images must be the same size!");
		}

		foreground.filter(PApplet.BLUR, _blurAmount);

		PImage diffed = _app.createImage(foreground.width, foreground.height, PApplet.ARGB);

		_activityLevel = 0;
		int imageSize = foreground.pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int diff = getDiff(foreground, _backgroundImage, i);
			if (diff > _differenceThreshold)
			{
				int baseAlpha = 123;
				int maxAlpha = 122;
				float perc = (diff / 765f); // multiply by max val for 3
				// channels.
				int alpha = baseAlpha + (int) (maxAlpha * perc);
				if (alpha > baseAlpha + 10)
				{
					diffed.pixels[i] = (alpha << 24 | 0 << 16 | 0 << 8 | (225 + (int) (20 * perc)));
				}
				// else
				// {
				// diffed.pixels[i] = (alpha << 24 | 255 << 16 | 0 << 8 | 0);
				// }
			}
			
			// sub the cumulative differences in the image to get a general idea
			// of how much activity is on screen.
			_activityLevel += diff;
		}

		return diffed;
	}

	float[][] kernel = { { -1, -1, -1 }, { -1, 9, -1 }, { -1, -1, -1 } };

	/**
	 * Based on the background image and the supplied foreground image,
	 * calculates a new image based on the foreground that has been masked to
	 * include only the parts of the image that have changed significantly.
	 * 
	 * @param foreground
	 * @return
	 */
	public PImage createDifferenceMask(PImage foreground)
	{
		PImage foregroundCopy = null;
		try
		{
			foregroundCopy = (PImage) foreground.clone();
		} catch (CloneNotSupportedException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PImage mask = calculateImageDifference(foreground);
		mask.resize(foregroundCopy.width, foregroundCopy.height);
		foregroundCopy.mask(mask);
		return foregroundCopy;
	}

	private int getDiff(PImage img1, PImage img2, int index)
	{
		float r1 = _app.red(img1.pixels[index]);
		float g1 = _app.green(img1.pixels[index]);
		float b1 = _app.blue(img1.pixels[index]);

		float r2 = _app.red(img2.pixels[index]);
		float g2 = _app.green(img2.pixels[index]);
		float b2 = _app.blue(img2.pixels[index]);

		return (int) PApplet.abs((r1 - r2) + (g1 - g2) + (b1 - b2));
	}

	private boolean verifyIdenticalSize(PImage foreground, PImage image)
	{
		return (foreground.width == _backgroundImage.width && foreground.height == _backgroundImage.height);
	}
}
