package com.breaktrycatch.needmorehumans.view;

import java.util.ArrayList;

import org.jbox2d.collision.PolygonDef;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.video.PS3EyeCapture;
import com.breaktrycatch.needmorehumans.control.webcam.HumanProcessorControl;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
import com.breaktrycatch.needmorehumans.utils.ImageUtils;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

public class CaptureView extends AbstractView
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int _cameraWidth = 640;
	private int _cameraHeight = 480;
	private int _maxBackgrounds = 16;

	private PImage _background;
	private PImage _foreground;

	private SimpleCapture _capture;
	private HumanProcessorControl _processor;
	private PhysicsView _physicsSim;
	private TileImageDrawer _debugDrawer;
	private ImageAnalysis _imageAnalysis;

	private boolean _debugMode = false;
	private boolean _imageCaptured = false;

	private static final String CAPTURE = "capture";

	public CaptureView()
	{
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		app.background(100);

		_cameraWidth = ConfigTools.getInt(CAPTURE, "cameraWidth");
		_cameraHeight = ConfigTools.getInt(CAPTURE, "cameraHeight");
		_maxBackgrounds = ConfigTools.getInt(CAPTURE, "maxBackgrounds");

		_background = app.loadImage("../data/subtraction/sunset-beach.jpg");
		_background.resize(_cameraWidth, _cameraHeight);

		_debugDrawer = new TileImageDrawer(app, .7f);
		_debugDrawer.setEnabled(true);

		_capture = new PS3EyeCapture(app);
		_capture.initVideo("", _cameraWidth, _cameraHeight, ConfigTools.getInt(CAPTURE, "cameraFPS"));
		_capture.setExposure(ConfigTools.getFloat(CAPTURE, "exposure"));
		_capture.setGain(ConfigTools.getFloat(CAPTURE, "gain"));

		_processor = new HumanProcessorControl(getApp(), _capture);
		_processor.setDebugDrawer(_debugDrawer);

		_physicsSim = new PhysicsView();
		_physicsSim.initialize(app);
		add(_physicsSim);
		// debug();
	}

	private void debug()
	{
		_background = getApp().loadImage("../data/subtraction/shadow-background.png");
		_foreground = getApp().loadImage("../data/subtraction/shadow-foreground.png");
		PImage original = ImageUtils.cloneImage(_foreground);

		_processor.setBackgroundImage(_background);

		// draw the background image.
		// getApp().image(getApp().loadImage("sunset-beach.jpg"), 0, 0);

		// overlay the mask.
		PImage diffed = _processor.createDiffedImage(original);

		_debugDrawer.drawImage(_background);
		_debugDrawer.drawImage(_foreground);
		_debugDrawer.drawImage(diffed);

		// getApp().image(diffed, 0, 0);

		// diffed.pixels = _pipeline.process(diffed.pixels, diffed.width,
		// diffed.height);
		// _background.pixels = _pipeline.process(_background.pixels,
		// _background.width, _background.height);
		// _subtractor.setBackgroundImage(_background);
		// diffed = createDiffedImage(diffed);
		// getApp().image(diffed, 0, 0);

		_debugMode = true;
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

			// draw the background image.
			app.image(_processor.getRawCameraImage(), getApp().width - _processor.getRawCameraImage().width * 2, getApp().height - _processor.getRawCameraImage().height);

			PImage masked = _processor.getProcessedImage();
			app.image(_background, getApp().width - masked.width, getApp().height - masked.height);
			app.image(masked, getApp().width - masked.width, getApp().height - masked.height);
			if (app.key == 'c' && !_processor.isCapturingBackgrounds())
			{
				analizeImage(masked);
				_imageCaptured = true;
				_processor.setProcessingEnabled(false);
				app.key = 'q';
			}

		}

		if (_imageAnalysis != null)
		{
			_imageAnalysis.draw();
		}
	}

	private void analizeImage(PImage img)
	{
		//Physics View Handles this - Mike was here
//		_imageAnalysis = new ImageAnalysis(getApp(), _physicsSim.getPhysWorld());
//		_imageAnalysis.setDebugDrawer(_debugDrawer);
//		ArrayList<PolygonDef> polys = _imageAnalysis.analyzeImage(img);
		
		_physicsSim.setSprite(img);
	}
}
