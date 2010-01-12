package com.breaktrycatch.needmorehumans.core;

import hypermedia.video.OpenCV;
import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.needmorehumans.control.webcam.ImageSubstractionController;

public class WeNeedMoreHumansMain extends PApplet
{
	/**
	 * Default serial version id to appease the Eclipse gods.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Main entry point for the application.
	 * 
	 * @param args
	 *            Command line arguments.
	 */
	public static void main(String args[])
	{
		PApplet.main(new String[] { "--present", "com.breaktrycatch.needmorehumans.core.WeNeedMoreHumansMain" });
	}

	private PImage _background;
	private ImageSubstractionController _subtractor;
	private OpenCV _opencv;

	public WeNeedMoreHumansMain()
	{
		// all PApplet related commands should be made in setup().
	}

	@Override
	public void setup()
	{
		super.setup();

		frameRate(60);

		size(800, 600, P2D);
		_background = loadImage("sunset-beach.jpg");
		_background.resize(width, height);
		_opencv = new OpenCV(this);
		_opencv.capture(width, height);
		_opencv.remember();
		_subtractor = new ImageSubstractionController(this, createImage(_background.width, _background.height, ARGB));
	}

	public void keyPressed()
	{
		// saves an image is spacebar is hit
		if (key == ' ')
		{
			_subtractor.setBackgroundImage(_opencv.image());
		} else if (key == ENTER)
		{
			println("Building primitives");
		}
	}

	public void draw()
	{

		int c = (int) map(mouseX, 0, width, -128, 128);
		int r = (int) map(mouseY, 0, height, -128, 128);

		_opencv.read();
//		_opencv.brightness(r);
//		_opencv.contrast(c);

		_opencv.brightness(10);
		_opencv.contrast(13);

		println(r + " :  " +c);
		
		PImage frame = _opencv.image();
		PImage diffed = _subtractor.createDifferenceMask(frame);
		
		image(_background, 0, 0);
		image(diffed, 0, 0);
	}
}
