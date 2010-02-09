package com.breaktrycatch.needmorehumans.control.video;

import cl.eye.CLCamera;
import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

public class PS3EyeCapture implements SimpleCapture
{
	private CLCamera _cam;
	private PImage _cameraBuffer;
	private PApplet _app;
	private int _width;
	private int _height;

	public PS3EyeCapture(PApplet app)
	{
		_app = app;
	}

	@Override
	public String getDeviceName()
	{
		return "PS3 Eye 0";
	}

	@Override
	public String getError()
	{
		return "An error occured with the PS3 Eye camera!";
	}

	public void read()
	{
		_cam.getCameraFrame(_cameraBuffer.pixels, 0);
	}

	@Override
	public PImage getFrame()
	{
		return _cameraBuffer;
	}

	@Override
	public int getHeight()
	{
		return _height;
	}

	@Override
	public int getWidth()
	{
		return _width;
	}

	@Override
	public boolean initVideo(String deviceID, int width, int height, int fps)
	{
		_width = width;
		_height = height;
		int numCams = CLCamera.cameraCount();
		PApplet.println("Found " + numCams + " cameras");

		if (numCams == 0)
		{
			return false;
		}

		PApplet.println("Initializing camera with UUID " + CLCamera.cameraUUID(0));
		_cam = new CLCamera(_app);

		if (width == 640 && height == 480)
		{
			_cam.createCamera(0, CLCamera.CLEYE_COLOR, CLCamera.CLEYE_VGA, fps);
		} else
		{
			_cam.createCamera(0, CLCamera.CLEYE_COLOR, CLCamera.CLEYE_QVGA, fps);
		}

		_cam.setCameraParam(CLCamera.CLEYE_WHITEBALANCE_RED, 75);
		_cam.setCameraParam(CLCamera.CLEYE_WHITEBALANCE_GREEN, 100);
		_cam.setCameraParam(CLCamera.CLEYE_WHITEBALANCE_BLUE, 240);

		_cam.setCameraParam(CLCamera.CLEYE_AUTO_WHITEBALANCE, 0);
		_cam.setCameraParam(CLCamera.CLEYE_AUTO_EXPOSURE, 0);
		_cam.setCameraParam(CLCamera.CLEYE_AUTO_GAIN, 0);
		_cam.setCameraParam(CLCamera.CLEYE_GRAYSCALE, 1);

		PApplet.println("Cam: " + _cam.getCameraParam(CLCamera.CLEYE_AUTO_EXPOSURE));
		PApplet.println("Cam: " + _cam.getCameraParam(CLCamera.CLEYE_AUTO_GAIN));
		PApplet.println("Cam: " + _cam.getCameraParam(CLCamera.CLEYE_AUTO_WHITEBALANCE));
		PApplet.println("Cam: " + _cam.getCameraParam(CLCamera.CLEYE_EXPOSURE));
		PApplet.println("Cam: " + _cam.getCameraParam(CLCamera.CLEYE_GAIN));

		// Starts camera captures
		_cam.startCamera();

		_cameraBuffer = _app.createImage(width, height, PApplet.RGB);

		return true;
	}

	@Override
	public boolean isNewFrameAvailable()
	{
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void shutdown()
	{
		if (_cam != null)
		{
			_cam.stopCamera();
			_cam.destroyCamera();
			_cam.dispose();
		}
	}

	public void setExposure(float amt)
	{
		if (_cam != null)
		{
			_cam.setCameraParam(CLCamera.CLEYE_EXPOSURE, (int) (amt * 511f));
		}
	}

	public void setGain(float amt)
	{
		if (_cam != null)
		{
			_cam.setCameraParam(CLCamera.CLEYE_GAIN, (int) (amt * 79f));
		}
	}

	public void setColorBalance(float r, float g, float b)
	{
		if (_cam != null)
		{
			_cam.setCameraParam(CLCamera.CLEYE_WHITEBALANCE_RED, (int) (r * 255));
			_cam.setCameraParam(CLCamera.CLEYE_WHITEBALANCE_GREEN, (int) (g * 255));
			_cam.setCameraParam(CLCamera.CLEYE_WHITEBALANCE_BLUE, (int) (b * 255));
		}
	}

	public void blur(int amt)
	{
		_cameraBuffer.filter(PApplet.BLUR, amt);
	}
}
