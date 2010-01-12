package com.breaktrycatch.needmorehumans.view;

import hypermedia.video.OpenCV;
import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.webcam.ImageSubstractionController;

public class HumanCaptureView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private PImage _background;
	private OpenCV _opencv;
	private ImageSubstractionController _subtractor;

	public HumanCaptureView()
	{
	}
	
	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);
		
		PApplet.println("Initialized HumanCaptureView");

		_background = app.loadImage("sunset-beach.jpg");
		_background.resize(app.width, app.height);
		_opencv = new OpenCV(app);
		_opencv.capture(app.width, app.height);
		_opencv.remember();
		_subtractor = new ImageSubstractionController(app, app.createImage(_background.width, _background.height, PApplet.ARGB));
	}
	
	@Override
	public void dispose()
	{
		_opencv.dispose();
		super.dispose();
	}
	
	@Override
	public void draw()
	{
		super.draw();
				
		PApplet app = getApp();
		int c = (int) PApplet.map(app.mouseX, 0, app.width, -128, 128);
		int r = (int) PApplet.map(app.mouseY, 0, app.height, -128, 128);

		_opencv.read();
		// _opencv.brightness(r);
		// _opencv.contrast(c);

		_opencv.brightness(10);
		_opencv.contrast(13);

		PApplet.println(r + " :  " + c);

		PImage frame = _opencv.image();
		PImage diffed = _subtractor.createDifferenceMask(frame);

		app.image(_background, 0, 0);
		app.image(diffed, 0, 0);
	}

}
