package com.breaktrycatch.needmorehumans.control.webcam;

import hypermedia.video.Blob;
import hypermedia.video.OpenCV;

import java.awt.Rectangle;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;
import toxi.geom.Vec2D;

import com.breaktrycatch.needmorehumans.utils.ImageUtils;

public class ImageSubstractionController
{
	private PApplet _app;
	private PImage _backgroundImage;
	private ArrayList<PImage> _originalBackgrounds;
	private int _activityLevel = 0;

	private int _differenceThreshold = 20;
	private float _scale = 1f;
	private float _shadowThreshold = .45f;
	private OpenCV _cv;

	public ImageSubstractionController(PApplet app)
	{
		_cv = new OpenCV(app);
		_app = app;
		_originalBackgrounds = new ArrayList<PImage>();
	}

	public ImageSubstractionController(PApplet app, PImage background)
	{
		this(app);

		_cv.allocate(background.width, background.height);
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

	public float getShadowThreshold()
	{
		return _shadowThreshold;
	}

	/**
	 * Sets the difference threshold for background detection. Any pixels with a
	 * color difference over this value will be marked as the foreground.
	 * 
	 * @param diff
	 */
	public void setShadowThreshold(float diff)
	{
		_shadowThreshold = diff;
	}

	public float getScale()
	{
		return _scale;
	}

	/**
	 * Sets the difference threshold for background detection. Any pixels with a
	 * color difference over this value will be marked as the foreground.
	 * 
	 * @param diff
	 */
	public void setScale(float scale)
	{
		_scale = scale;
	}

	/**
	 * Sets the background image. Use this if the static background changes and
	 * you need to reset. It is recommended to provide the
	 * ImageSubtractionController with several background images using
	 * addBackgroundImage and then calculating the mean background using
	 * averageBackgrounds().
	 * 
	 * @param background
	 *            A new background image.
	 */
	public void setBackgroundImage(PImage background)
	{
		_backgroundImage = ImageUtils.cloneImage(background);
		scaleImage(_backgroundImage);
		_cv.allocate(_backgroundImage.width, _backgroundImage.height);
	}

	/**
	 * Returns the background image the controller uses to perform comparisons.
	 * 
	 * @return
	 */
	public PImage getBackgroundImage()
	{
		return _backgroundImage;
	}

	/**
	 * Adds a background to a list of backgrounds that will be used to create a
	 * mean image.
	 * 
	 * @param background
	 */
	public void addBackgroundImage(PImage background)
	{
		if (_scale != 1)
		{
			scaleImage(background);
		}

		_originalBackgrounds.add(background);
	}

	/**
	 * Clears the list of backgrounds so a new set may be defined.
	 */
	public void clearBackgrounds()
	{
		_originalBackgrounds.clear();
	}

	/**
	 * Calculates the background image by taking an average of all the given
	 * background images. This is preferable to using setBackgroundImage when
	 * using video as a source since it will smooth out CCD noise.
	 */
	public void averageBackgrounds()
	{
		if (_originalBackgrounds.size() == 0)
		{
			throw new Error("You must call addBackgroundImage() at least once before calling averageBackgrounds().");
		}

		_backgroundImage = _app.createImage(_originalBackgrounds.get(0).width, _originalBackgrounds.get(0).height, PApplet.ARGB);
		ImageUtils.averageImages(_backgroundImage, _originalBackgrounds);
		_cv.allocate(_backgroundImage.width, _backgroundImage.height);
	}

	/**
	 * Total number of images used to generate the background image.
	 * 
	 * @return
	 */
	public int totalBackgrounds()
	{
		return _originalBackgrounds.size();
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
		scaleImage(foreground);
		if (!verifyIdenticalSize(foreground, _backgroundImage))
		{
			PApplet.println("Foreground W: " + foreground.width + " : " + foreground.height);
			PApplet.println("Background W: " + _backgroundImage.width + " : " + _backgroundImage.height);
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
			// pixels color
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
				diffed.pixels[i] = (255 << 24 | 0 << 16 | 0 << 8 | (int) Math.max(diffB, Math.max(diffR, diffG)));
			}

			// sub the cumulative differences in the image to get a general idea
			// of how much activity is on screen.
			_activityLevel += diff;
		}

		return diffed;
	}

	private void scaleImage(PImage image)
	{
		if (_scale != 1)
		{
			image.resize((int) (image.width * _scale), (int) (image.height * _scale));
		}
	}

	/**
	 * Implementation of A Color Similarity Measure for Robust Shadow Removal as
	 * defined in:
	 * http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.102.775
	 * &rep=rep1&type=pdf
	 * 
	 * @param foreground
	 * @return
	 */
	public void removeShadows(PImage foreground)
	{
		// we wont find any pixels so this effectively disables shadow culling.
		if (_shadowThreshold == 1)
		{
			return;
		}

		scaleImage(foreground);
		if (!verifyIdenticalSize(foreground, _backgroundImage))
		{
			throw new Error("Foreground and Background images must be the same size!");
		}

		PGraphics diffed = _app.createGraphics(foreground.width, foreground.height, PApplet.P2D);
		diffed.pixels = ImageUtils.cloneImage(foreground).pixels;
		diffed.loadPixels();

		int windowWidth = 7;
		int windowHeight = 7;

		int stX = (windowWidth - 1) / 2;
		int stY = (windowHeight - 1) / 2;
		for (int y = stY; y < foreground.height - stY; y++)
		{
			for (int x = stX; x < foreground.width - stX; x++)
			{
				int pos = y * foreground.width + x;
				int currColor = foreground.pixels[pos];
				int bgColor = _backgroundImage.pixels[pos];

				int fgA = (currColor >> 24) & 0xFF;
				if (fgA == 0)
				{
					continue;
				}

				float[] fgHSL = new float[3];
				ImageUtils.RGBtoHSL((currColor >> 16) & 0xFF, (currColor >> 8) & 0xFF, currColor & 0xFF, fgHSL);

				float[] bgHSL = new float[3];
				ImageUtils.RGBtoHSL((bgColor >> 16) & 0xFF, (bgColor >> 8) & 0xFF, bgColor & 0xFF, bgHSL);

				// shadow pixels will be darker than the background
				if (fgHSL[2] < bgHSL[2])
				{
					int minWindowY = (int) (y - (windowHeight - 1) / 2);
					int maxWindowY = (int) (y + (windowHeight - 1) / 2);

					int minWindowX = (int) (x - (windowWidth - 1) / 2);
					int maxWindowX = (int) (x + (windowWidth - 1) / 2);

					double sum = 0;
					double sumKFG = 0;
					double sumKBG = 0;

					// M x N kernel to do texture detection
					for (int j = minWindowY; j < maxWindowY; j++)
					{
						for (int i = minWindowX; i < maxWindowX; i++)
						{
							// guard against out of bounds errors.
							if (j < 0 || j >= foreground.height || i < 0 || i >= foreground.width)
							{
								continue;
							}

							int kernelPos = j * foreground.width + i;
							sum += covariance(foreground.pixels[kernelPos], _backgroundImage.pixels[kernelPos]);
							sumKFG += covariance(foreground.pixels[kernelPos], foreground.pixels[kernelPos]);
							sumKBG += covariance(_backgroundImage.pixels[kernelPos], _backgroundImage.pixels[kernelPos]);
						}
					}

					Rectangle luminosityRect = new Rectangle(minWindowX, minWindowY, maxWindowX - minWindowX, maxWindowY - minWindowY);
					double avgFGLum = ImageUtils.luminosityVariance(foreground, luminosityRect);
					double avgBGLum = ImageUtils.luminosityVariance(_backgroundImage, luminosityRect);
					double d1 = sumKBG - (windowWidth * windowHeight * Math.pow(avgBGLum, 2));
					double d2 = sumKFG - (windowWidth * windowHeight * Math.pow(avgFGLum, 2));
					double CNCC = (sum - (avgFGLum * avgBGLum)) / Math.sqrt(d1 * d2);
					if (CNCC > _shadowThreshold)
					{
						diffed.pixels[pos] = 0x00000000;
					}
				}
			}
		}
		foreground.pixels = diffed.pixels;

	}

	public void extractLargestBlob(PImage img)
	{
		PGraphics diffed = _app.createGraphics(img.width, img.height, PApplet.P2D);
		int imageSize = img.pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int currColor = img.pixels[i];
			int fgA = (currColor >> 24) & 0xFF;
			if (fgA == 0)
			{
				diffed.pixels[i] = 0;
			} else
			{
				diffed.pixels[i] = 0xffffffff;
			}
		}

		_cv.copy(diffed);
		Blob[] blobs = _cv.blobs(10, diffed.width * diffed.height / 2, 1, false, OpenCV.MAX_VERTICES);// *

		if (blobs.length == 0)
		{
			return;
		}

		PGraphics blobImage = _app.createGraphics(img.width, img.height, PApplet.P2D);
		Blob b = blobs[0];
		blobImage.beginDraw();
		blobImage.beginShape();
		blobImage.fill(0xff0000ff);
		for (int j = 0; j < b.points.length; j++)
		{
			blobImage.vertex(b.points[j].x, b.points[j].y);
		}
		blobImage.endShape();
		blobImage.endDraw();
		
		imageSize = img.pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int fgB = (blobImage.pixels[i]) & 0xFF;
			if (fgB == 0)
			{
				img.pixels[i] = 0;
			}
			else
			{
				img.pixels[i] = (255 << 24 | img.pixels[i]);
			}
		}
	}

	private double covariance(int c1, int c2)
	{
		float[] c1HSV = new float[3];
		ImageUtils.RGBtoHSL((c1 >> 16) & 0xFF, (c1 >> 8) & 0xFF, c1 & 0xFF, c1HSV);

		float[] c2HSV = new float[3];
		ImageUtils.RGBtoHSL((c2 >> 16) & 0xFF, (c2 >> 8) & 0xFF, c2 & 0xFF, c2HSV);

		Vec2D fv = new Vec2D(c1HSV[0], c1HSV[1]);
		Vec2D bv = new Vec2D(c2HSV[0], c2HSV[1]);

		double product = fv.dot(bv) + (c1HSV[2] * c2HSV[2]);

		return (product < 0) ? (0) : (product);
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

		int imageSize = target.pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int fgA = (target.pixels[i] >> 24) & 0xFF;
			if (fgA == 0)
			{
				target.pixels[i] = (0 << 24 | target.pixels[i]);
			}
		}

		return target;
	}

	private boolean verifyIdenticalSize(PImage foreground, PImage image)
	{
		return (foreground.width == _backgroundImage.width && foreground.height == _backgroundImage.height);
	}
	
	public OpenCV getOpenCV()
	{
		return _cv;
	}
}
