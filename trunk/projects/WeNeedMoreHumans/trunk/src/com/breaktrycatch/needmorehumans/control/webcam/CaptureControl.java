package com.breaktrycatch.needmorehumans.control.webcam;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.control.video.PS3EyeCapture;
import com.breaktrycatch.needmorehumans.control.webcam.callback.ICaptureCallback;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

public class CaptureControl extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int _cameraWidth = 640;
	private int _cameraHeight = 480;
	private int _maxBackgrounds = 16;

	private SimpleCapture _capture;
	private HumanProcessorControl _processor;
	private TileImageDrawer _debugDrawer;
	private boolean _initialized;
	private boolean _capturing;
	private ArrayList<PImage> _capturedImages;

	private ICaptureCallback _captureCompleteCallback;
	private boolean _showDebugImage = false;

	private int _imagesToCapture;

	private static final String CAPTURE = "capture";

	public CaptureControl(PApplet app)
	{
		super(app);
		app.background(100);

		_cameraWidth = ConfigTools.getInt(CAPTURE, "cameraWidth");
		_cameraHeight = ConfigTools.getInt(CAPTURE, "cameraHeight");
		_maxBackgrounds = ConfigTools.getInt(CAPTURE, "maxBackgrounds");

		scaleX = scaleY = .3f;

		_capturedImages = new ArrayList<PImage>();
		_debugDrawer = new TileImageDrawer(app, .3f);
		_debugDrawer.setEnabled(ConfigTools.getBoolean("general", "debugMode"));

		_capture = new PS3EyeCapture(app);
		if (_capture.initVideo("", _cameraWidth, _cameraHeight, ConfigTools.getInt(CAPTURE, "cameraFPS")))
		{
			_capture.setExposure(ConfigTools.getFloat(CAPTURE, "exposure"));
			_capture.setGain(ConfigTools.getFloat(CAPTURE, "gain"));

			_processor = new HumanProcessorControl(getApp(), _capture);
			_processor.setDebugDrawer(_debugDrawer);
			_processor.setProcessingEnabled(false);
			add(_debugDrawer);

			_processor.captureBackgrounds(_maxBackgrounds);

			KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

			// SPACE will re-capture the background images.
			keyboardManager.registerKeyOnce(' ', new ISimpleCallback()
			{
				public void execute()
				{
					PApplet.println("Re-Capturing backgrounds....");
					_processor.captureBackgrounds(_maxBackgrounds);
				};
			});

			keyboardManager.registerKeyOnce('m', new ISimpleCallback()
			{
				public void execute()
				{
					_showDebugImage = !_showDebugImage;
				};
			});

			_initialized = true;
		}
	}

	public PImage getProcessedImage()
	{
		if (_initialized)
		{
			return _processor.getProcessedImage();
		} else
		{
			return null;
		}
	}

	@Override
	public void dispose()
	{
		if (_initialized)
		{
			_capture.shutdown();
		}
		super.dispose();
	}

	@Override
	public void draw()
	{
		super.draw();
		if (_initialized)
		{
			_processor.update();

			if (_capturing)
			{
				PImage img = _processor.getProcessedImage();
				_capturedImages.add(img);

				if (_capturedImages.size() >= _imagesToCapture)
				{
					executeCaptureCallback();
				}
			}

			if (_showDebugImage)
			{
				PImage img = _processor.getRawCameraImage();
				img.updatePixels();
				getApp().image(img, 0, 0);
			}

			_debugDrawer.reset();
		}

	}

	public void setDebugMode(boolean debug)
	{
		_debugDrawer.setEnabled(debug);
		_debugDrawer.width = width;
		_debugDrawer.height = height;
	}

	public void beginCapture(int imagesToCapture, ICaptureCallback iCaptureCallback)
	{
		_captureCompleteCallback = iCaptureCallback;
		if (_initialized)
		{
			_imagesToCapture = imagesToCapture;
			_capturedImages.clear();
			_capturing = true;
		} else
		{
			_captureCompleteCallback.execute(null);
		}
	}

	private void executeCaptureCallback()
	{
		_capturing = false;
		_captureCompleteCallback.execute(_capturedImages);
	}

	public PImage getRawImage()
	{
		return _capture.getFrame();
	}

}
