package com.breaktrycatch.needmorehumans.control.webcam;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.control.video.PS3EyeCapture;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;
import com.breaktrycatch.needmorehumans.utils.TwitterTools;

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
	private ImageAnalysis _imageAnalysis;

	private boolean _debugMode = false;
	private boolean _imageCaptured = false;

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
		_capture.initVideo("", _cameraWidth, _cameraHeight, ConfigTools.getInt(CAPTURE, "cameraFPS"));
		_capture.setExposure(ConfigTools.getFloat(CAPTURE, "exposure"));
		_capture.setGain(ConfigTools.getFloat(CAPTURE, "gain"));

		_processor = new HumanProcessorControl(getApp(), _capture);
		_processor.setDebugDrawer(_debugDrawer);
		add(_debugDrawer);
	}

	@Override
	public void dispose()
	{
		_capture.shutdown();
		super.dispose();
	}

	@Override
	public void draw()
	{
		super.draw();

		if (_debugMode)
		{
			return;
		}

		_debugDrawer.reset();
		PApplet app = getApp();

		if (app.key == ' ')
		{
			_processor.captureBackgrounds(_maxBackgrounds);
			app.key = 'q';
		}

		_processor.update();
		if (!_imageCaptured)
		{
			PImage masked = _processor.getProcessedImage();

			float ratio = (float) width / (float) _cameraWidth;
			app.image(masked, 0, height - (_cameraHeight * ratio), _cameraWidth * ratio, _cameraHeight * ratio);

			if (app.key == 'c' && !_processor.isCapturingBackgrounds())
			{
				analizeImage(masked);
				_imageCaptured = true;
				_processor.setProcessingEnabled(false);

				// TODO: dispatch event up to the container.

				app.key = 'q';
			}
		}

		if (app.key == 't')
		{
			PApplet.println("Posting tweet...");
			TwitterTools.postTweet("Just captured a skinny dude: ", getApp().get());

			app.key = 'q';
		}
		if (_imageAnalysis != null)
		{
			_imageAnalysis.draw();
		}
	}

	private void analizeImage(PImage img)
	{
		// Physics View Handles this - Mike was here
		// _imageAnalysis = new ImageAnalysis(getApp(),
		// _physicsSim.getPhysWorld());
		// _imageAnalysis.setDebugDrawer(_debugDrawer);
		// ArrayList<PolygonDef> polys = _imageAnalysis.analyzeImage(img);

		// _physicsSim.setSprite(img);
	}
}
