package com.breaktrycatch.needmorehumans.control.webcam;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.needmorehumans.utils.ImageUtils;

public class ImageSubstractionController
{
	private PApplet _app;
	private PImage _backgroundImage;
	private int _activityLevel = 0;

	private int _differenceThreshold = 65;
	private float _downresFactor = 1f;

	public ImageSubstractionController(PApplet app)
	{
		_app = app;
	}

	public ImageSubstractionController(PApplet app, PImage background)
	{
		this(app);
		setBackgroundImage(background);
	}

	public int getDifferenceThreshold()
	{
		return _differenceThreshold;
	}
	
	/**
	 * Sets the difference threshold for background detection. Any pixels with a
	 * color difference over this value will be marked as the foreground.
	 * 
	 * @param diff
	 */
	public void setDifferenceThreshold(int diff)
	{
		_differenceThreshold = diff;
	}


	/*
	 * Plan of attack: Create background model: - queue of N (5-10?) background
	 * images used to create an average background distribution (histogram) -
	 * Smooth the histogram using the mean shift vector. + mean(of point x) =
	 * (sum->(i=1 to n) pt[i]*g((x - x[i]/h)^2) / sum->(i=1 to n) g((x -
	 * x[i]/h)^2)) - x; + where: x = point to test h = analysis bandwidth
	 * (positive const?)
	 * 
	 * g(u) = first derivative of a bounded support function called k(u). k(u) =
	 * kernel profile (Epanechnicov kernel). * - find items that lie outside
	 * this distribution?
	 */
	// private void computePixel(ArrayList<PImage> backgrounds, PImage target,
	// int pixel)
	// {
	// int x = backgrounds.get(0).pixels[pixel];
	// int kernelRadius = 3; // TODO: Create a kernel for g()
	//
	// int size = backgrounds.size();
	// for (int i = 1; i < size; i++)
	// {
	// PImage img = backgrounds.get(i);
	// int xi = img.pixels[pixel];
	// float gReduced = g(PApplet.pow((x - xi / kernelRadius), 2));
	// float mx = ((xi * gReduced) / gReduced) - x;
	// }
	// }

	// private float g(float val)
	// {
	// return val;
	//
	// }
	/**
	 * Sets the background image. Use this if the static background changes and
	 * you need to reset.
	 * 
	 * @param background
	 *            A new background image.
	 */
	public void setBackgroundImage(PImage background)
	{
		_backgroundImage = ImageUtils.cloneImage(background);
		_backgroundImage.resize((int) (_backgroundImage.width / _downresFactor), (int) (_backgroundImage.height / _downresFactor));
	}

	public PImage getBackgroundImage()
	{
		return _backgroundImage;
	}

	/**
	 * Returns the activity level in the image. A value of 1 indicates that
	 * every pixel in the image has changed from black to white (or vice versa).
	 * An activity level of zero means no pixels have changed between frames.
	 * 
	 * @return Value between [0-1].
	 */
	public float getActivityLevel()
	{
		return (_activityLevel / (_backgroundImage.width * _backgroundImage.height)) / 765;
	}

	/**
	 * Generates a difference image containing only the pixels not contained in
	 * the background image.
	 * 
	 * @param foreground
	 *            A foreground image to compare to the background.
	 * @return A new image containing only the pixels not contained in the
	 *         background
	 */
	public PImage calculateImageDifference(PImage foreground)
	{
		if (_downresFactor != 1)
		{
			foreground.resize((int) (foreground.width / _downresFactor), (int) (foreground.height / _downresFactor));
		}
		
		if (!verifyIdenticalSize(foreground, _backgroundImage))
		{
			throw new Error("Foreground and Background images must be the same size!");
		}

		PImage diffed = _app.createImage(foreground.width, foreground.height, PApplet.ARGB);

		_activityLevel = 0;
		int imageSize = foreground.pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int currColor = foreground.pixels[i];
			int backgroundColor = _backgroundImage.pixels[i];

			int currR = (currColor >> 16) & 0xFF;
			int currG = (currColor >> 8) & 0xFF;
			int currB = currColor & 0xFF;

			// Extract the red, green, and blue components of the background
			// pixelÕs color
			int bkgdR = (backgroundColor >> 16) & 0xFF;
			int bkgdG = (backgroundColor >> 8) & 0xFF;
			int bkgdB = backgroundColor & 0xFF;

			// Compute the difference of the red, green, and blue values
			int diffR = PApplet.abs(currR - bkgdR);
			int diffG = PApplet.abs(currG - bkgdG);
			int diffB = PApplet.abs(currB - bkgdB);

			int diff = (diffR + diffG + diffB);
			if (diffR >= _differenceThreshold || diffG >= _differenceThreshold || diffB >= _differenceThreshold)
			{
				diffed.pixels[i] = (255 << 24 | 0 << 16 | 0 << 8 | 255);
			}

			// sub the cumulative differences in the image to get a general idea
			// of how much activity is on screen.
			_activityLevel += diff;
		}

		return diffed;
	}

	/**
	 * Based on the background image and the supplied foreground image,
	 * calculates a new image that can be used to mask off the image to show
	 * only foreground elements.
	 * 
	 * @param foreground
	 * @return A mask
	 */
	public PImage createDifferenceMask(PImage foreground)
	{
		PImage mask = calculateImageDifference(foreground);
		mask.resize(foreground.width, foreground.height);
		return mask;
	}

	/**
	 * Creates a difference mask and applies it to a copy of the supplied image.
	 * 
	 * @param foreground
	 * @return
	 */
	public PImage createAndApplyDifferenceMask(PImage foreground)
	{
		PImage foregroundCopy = ImageUtils.cloneImage(foreground);
		PImage mask = createDifferenceMask(foregroundCopy);
		return applyDifferenceMask(foregroundCopy, mask);
	}

	/**
	 * Applies a difference mask to the supplied target image.
	 * 
	 * @param target
	 * @param mask
	 * @return
	 */
	public PImage applyDifferenceMask(PImage target, PImage mask)
	{
		if (!verifyIdenticalSize(target, mask))
		{
			mask.resize(target.width, target.height);
		}

		target.mask(mask);
		return target;
	}

	private boolean verifyIdenticalSize(PImage foreground, PImage image)
	{
		return (foreground.width == _backgroundImage.width && foreground.height == _backgroundImage.height);
	}
}
