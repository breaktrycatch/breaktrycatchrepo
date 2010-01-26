package com.breaktrycatch.needmorehumans.control.video;

import hypermedia.video.OpenCV;
import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

public class OpenCVCapture implements SimpleCapture
{
	private OpenCV _opencv;
	private PApplet _app;

	public OpenCVCapture(PApplet app)
	{
		_app = app;
	}

	@Override
	public String getDeviceName()
	{
		return "Generic Webcam";
	}

	@Override
	public String getError()
	{
		return "Oh no an error occured!";
	}

	@Override
	public PImage getFrame()
	{
		return _opencv.image();
	}

	@Override
	public int getHeight()
	{
		return _opencv.height;
	}

	@Override
	public int getWidth()
	{
		return _opencv.width;
	}

	@Override
	public boolean initVideo(String deviceID, int width, int height, int fps)
	{
		_opencv = new OpenCV(_app);
		_opencv.capture(width, height);
		return true;
	}

	@Override
	public boolean isNewFrameAvailable()
	{
		return true;
	}

	@Override
	public void shutdown()
	{
		_opencv.dispose();
	}

	public void read()
	{
		_opencv.read();
	}

	public void blur(int amt)
	{
		_opencv.blur(OpenCV.GAUSSIAN, amt);
	}

	public void brightness(int amt)
	{
		_opencv.brightness(amt);
	}

	public void contrast(int amt)
	{
		_opencv.contrast(amt);
	}

	@Override
	public void setExposure(float f)
	{
		// TODO Auto-generated method stub
	}

	@Override
	public void setGain(float i)
	{
		// TODO Auto-generated method stub
	}
	
	@Override
	public void setColorBalance(float r, float g, float b)
	{
		// TODO Auto-generated method stub
	}

	public OpenCV opencv()
	{
		return _opencv;
	}

}
