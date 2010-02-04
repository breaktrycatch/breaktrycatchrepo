package com.breaktrycatch.needmorehumans.control.webcam;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.control.video.PS3EyeCapture;
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

	private static final String CAPTURE = "capture";

	public CaptureControl(PApplet app)
	{
		super(app);
		app.background(100);

		_cameraWidth = ConfigTools.getInt(CAPTURE, "cameraWidth");
		_cameraHeight = ConfigTools.getInt(CAPTURE, "cameraHeight");
		_maxBackgrounds = ConfigTools.getInt(CAPTURE, "maxBackgrounds");

		_debugDrawer = new TileImageDrawer(app, .7f);
		_debugDrawer.setEnabled(true);

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
			_debugDrawer.reset();
		}
	}

	public void setDebugMode(boolean debug)
	{
		_debugDrawer.setEnabled(debug);
		_debugDrawer.width = width;
		_debugDrawer.height = height;
	}
}
