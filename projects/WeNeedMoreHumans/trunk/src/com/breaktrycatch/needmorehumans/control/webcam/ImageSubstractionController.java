package com.breaktrycatch.needmorehumans.control.webcam;

import processing.core.PApplet;
import processing.core.PImage;

public class ImageSubstractionController
{
	private PApplet _app;
	private PImage _backgroundImage;
	private int _activityLevel = 0;

	private int _differenceThreshold = 60;
	private int _blurAmount = 4;
	private float _downresFactor = 2f;
	private final int _gapFillSize = (int) (_blurAmount) * 3;

	public ImageSubstractionController(PApplet app)
	{
		_app = app;
	}

	public ImageSubstractionController(PApplet app, PImage background)
	{
		this(app);
		setBackgroundImage(background);
	}

	public int getBlurAmount()
	{
		return _blurAmount;
	}

	/**
	 * Sets the blur amount. This is useful for reducing video noise in the
	 * image. If you increase the blur amount, you may also need to increase the
	 * gapFillSize to compensate for where areas of different colors meet.
	 * 
	 * @param blur
	 */
	public void setBlurAmount(int blur)
	{
		_blurAmount = blur;
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

	/**
	 * Sets the background image. Use this if the static background changes and
	 * you need to reset.
	 * 
	 * @param background
	 *            A new background image.
	 */
	public void setBackgroundImage(PImage background)
	{
		_backgroundImage = background;
		_backgroundImage.resize((int) (_backgroundImage.width / _downresFactor), (int) (_backgroundImage.height / _downresFactor));
		_backgroundImage.filter(PApplet.BLUR, _blurAmount);
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
		foreground.resize((int) (foreground.width / _downresFactor), (int) (foreground.height / _downresFactor));

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
				float perc = (diff / 765f); // multiply by max val for 3 chans.
				int alpha = baseAlpha + (int) (maxAlpha * perc);
				if (alpha > baseAlpha + 5)
				{
					// PImage mask function uses blue channel
					diffed.pixels[i] = (255 << 24 | 0 << 16 | 0 << 8 | 255);
				}
			}

			// sub the cumulative differences in the image to get a general idea
			// of how much activity is on screen.
			_activityLevel += diff;
		}

		return diffed;
	}

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
			e.printStackTrace();
		}
		PImage mask = calculateImageDifference(foreground);
		fillGaps(mask);
		mask.resize(foregroundCopy.width, foregroundCopy.height);
		// return mask;

		foregroundCopy.mask(mask);
		return foregroundCopy;
	}

	private void fillGaps(PImage image)
	{
		fillHorizontalGaps(image);
		fillVerticalGaps(image);
	}

	private void fillVerticalGaps(PImage image)
	{
		int i = 0;
		for (int x = 0; x < image.width; x++)
		{
			int startY = -1;
			int possibleFillStart = -1;
			for (int y = 0; y < image.height; y++)
			{
				i = y * image.width + x;
				float alpha = _app.blue(image.pixels[i]);

				if (startY != -1)
				{
					if (possibleFillStart != -1 && alpha != 0)
					{
						int gapSize = possibleFillStart - startY;
						if (gapSize < _gapFillSize)
						{
							for (int k = 0; k <= gapSize; k++)
							{
								int pos = x + (startY + k) * image.width;
								image.pixels[pos] = (255 << 24 | 0 << 16 | 255 << 8 | 255);
							}
						}
						startY = -1;
						possibleFillStart = -1;
					}

					if (alpha == 0)
					{
						possibleFillStart = y;
					}
				}

				if (alpha > 0)
				{
					startY = y;
				}
			}
		}
	}

	private void fillHorizontalGaps(PImage image)
	{
		int i = 0;
		for (int y = 0; y < image.height; y++)
		{
			int startX = -1;
			int possibleFillStart = -1;
			for (int x = 0; x < image.width; x++)
			{
				float alpha = _app.blue(image.pixels[i]);

				if (startX != -1)
				{
					if (possibleFillStart != -1 && alpha != 0)
					{
						int gapSize = possibleFillStart - startX;
						if (gapSize < _gapFillSize)
						{
							for (int k = 0; k <= gapSize; k++)
							{
								int pos = y * image.width + startX + k;
								image.pixels[pos] = (255 << 24 | 255 << 16 | 0 << 8 | 255);
							}
						}
						startX = -1;
						possibleFillStart = -1;
					}

					if (alpha == 0)
					{
						possibleFillStart = x;
					}
				}

				if (alpha > 0)
				{
					startX = x;
				}

				i++;
			}
		}
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
