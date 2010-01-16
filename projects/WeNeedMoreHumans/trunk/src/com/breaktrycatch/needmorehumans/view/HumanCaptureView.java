package com.breaktrycatch.needmorehumans.view;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.LibCompVis;
import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ErosionPlugin;
import toxi.video.capture.plugins.ProcessorPlugin;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.video.OpenCVCapture;
import com.breaktrycatch.needmorehumans.control.video.plugins.AlphaThresholdPlugin;
import com.breaktrycatch.needmorehumans.control.video.plugins.GapFillPlugin;
import com.breaktrycatch.needmorehumans.control.webcam.ImageSubstractionController;
import com.breaktrycatch.needmorehumans.utils.ImageUtils;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

public class HumanCaptureView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private PImage _background;
	private OpenCVCapture _opencv;
	private ProcessorPipeline _pipeline;
	private ProcessorPipeline _postPipeline;
	private ImageSubstractionController _subtractor;

	private PImage _foreground;
	private TileImageDrawer _debugDrawer;

	public HumanCaptureView()
	{
	}

	@SuppressWarnings("unchecked")
	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		PApplet.println("Initialized HumanCaptureView");
		
		app.background(0);

		_background = app.loadImage("sunset-beach.jpg");
		_background.resize(app.width, app.height);
		_subtractor = new ImageSubstractionController(app, app.createImage(_background.width, _background.height, PApplet.ARGB));

		// _opencv = new OpenCVCapture(getApp());
		// _opencv.initVideo("", app.width, app.height, 30);
		// LibCompVis vis = new LibCompVis(getApp(), _opencv);
		LibCompVis vis = null;

		_debugDrawer = new TileImageDrawer(app, .5f);

		_postPipeline = new ProcessorPipeline(vis);
		_postPipeline.setDebugDrawer(_debugDrawer);
		_pipeline = new ProcessorPipeline(vis);
		_pipeline.setDebugDrawer(_debugDrawer);

		// HashMap<String, Comparable<?>> adaptiveThreshold = new
		// HashMap<String, Comparable<?>>();
		// adaptiveThreshold.put(AdaptiveThresholdPlugin.FILTER_CONSTANT, 3);
		// adaptiveThreshold.put(AdaptiveThresholdPlugin.KERNEL_SIZE, 5);
		// addPlugin(_pipeline, AdaptiveThresholdPlugin.class,
		// adaptiveThreshold);

		// get rid of the little things
		HashMap<String, Comparable<?>> contractConfig = new HashMap<String, Comparable<?>>();
		contractConfig.put(ErosionPlugin.INVERTED, false);
		contractConfig.put(ErosionPlugin.NUM_PASSES, 4);
		addPlugin(_pipeline, ErosionPlugin.class, contractConfig);

		HashMap<String, Comparable<?>> alphaThresholdConfig = new HashMap<String, Comparable<?>>();
		alphaThresholdConfig.put(AlphaThresholdPlugin.ALPHA_THRESHOLD, 1);
		addPlugin(_pipeline, AlphaThresholdPlugin.class, alphaThresholdConfig);

		HashMap<String, Comparable<?>> fillGaps = new HashMap<String, Comparable<?>>();
		fillGaps.put(GapFillPlugin.GAP_FILL, 6);
		fillGaps.put(GapFillPlugin.START_THRESHOLD, 200);
		fillGaps.put(GapFillPlugin.END_THRESHOLD, 50);
		addPlugin(_pipeline, GapFillPlugin.class, fillGaps);

		// blow it up huuuuuuge to fill in the holes
		HashMap<String, Comparable<?>> expandConfig = new HashMap<String, Comparable<?>>();
		expandConfig.put(ErosionPlugin.INVERTED, true);
		expandConfig.put(ErosionPlugin.NUM_PASSES, 8);
		addPlugin(_pipeline, ErosionPlugin.class, expandConfig);

		//
		// // shrink it down to normal.
		HashMap<String, Comparable<?>> contractBack = new HashMap<String, Comparable<?>>();
		contractBack.put(ErosionPlugin.INVERTED, false);
		contractBack.put(ErosionPlugin.NUM_PASSES, 4);
		addPlugin(_pipeline, ErosionPlugin.class, contractBack);
		//
		// 
		//
		// HashMap<String, Comparable<?>> noiseReduction = new HashMap<String,
		// Comparable<?>>();
		// noiseReduction.put(NoiseReductionPlugin.KERNEL, 8);
		// noiseReduction.put(NoiseReductionPlugin.THRESHOLD, 200);
		// addPlugin(_pipeline, NoiseReductionPlugin.class, noiseReduction);

		//
		// HashMap<String, Comparable<?>> edgeDetect = new HashMap<String,
		// Comparable<?>>();
		// edgeDetect.put(SobelEdgeDetectionPlugin.TOLERANCE, 50);
		// addPlugin(_postPipeline, SobelEdgeDetectionPlugin.class, edgeDetect);

		// HashMap<String, Comparable<?>> contractBack = new HashMap<String,
		// Comparable<?>>();
		// contractBack.put(ErosionPlugin.INVERTED, false);
		// contractBack.put(ErosionPlugin.NUM_PASSES, 1);
		// addPlugin(_pipeline, ErosionPlugin.class, contractBack);

		debug();
	}

	private void addPlugin(ProcessorPipeline pipeline, Class<?> c, HashMap<String, Comparable<?>> map)
	{
		try
		{
			ProcessorPlugin plugin = pipeline.addPlugin(c, Integer.toString(pipeline.list().size()));
			plugin.configure(map);
		} catch (InvocationTargetException e)
		{
			e.printStackTrace();
		}
	}

	private void debug()
	{
		_background = getApp().loadImage("../data/subtraction/real-background.jpg");
		_foreground = getApp().loadImage("../data/subtraction/real-foreground.jpg");
//		_background = getApp().loadImage("../data/subtraction/good-background.png");
//		_foreground = getApp().loadImage("../data/subtraction/good-foreground.png");
		PImage original = ImageUtils.cloneImage(_foreground);

		_subtractor.setBackgroundImage(_background);

		// draw the background image.
		// getApp().image(getApp().loadImage("sunset-beach.jpg"), 0, 0);

		// overlay the mask.
		PImage diffed = createDiffedImage(original);

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

	}

	private PImage createDiffedImage(PImage foreground)
	{
		// get the frame with the foreground object in it from the camera.
		PImage frame = ImageUtils.cloneImage(foreground);

		// create a simple difference mask from the frame.
		PImage mask = _subtractor.createDifferenceMask(frame);

		// process the mask to remove noise and gaps.
		mask.pixels = _pipeline.process(mask.pixels, mask.width, mask.height);
		
		// apply the mask to our raw camera frame.
		PImage maskedFrame = _subtractor.applyDifferenceMask(foreground, mask);

		// post process to clean up the image.
		maskedFrame.pixels = _postPipeline.process(maskedFrame.pixels, maskedFrame.width, maskedFrame.height);

		return maskedFrame;
	}

	@Override
	public void dispose()
	{
		_opencv.shutdown();
		super.dispose();
	}

	@Override
	public void draw()
	{
		super.draw();

		// PApplet app = getApp();
		//
		// _opencv.read();
		//
		// if (app.key == ' ')
		// {
		// _opencv.blur(3);
		// _subtractor.setBackgroundImage(_opencv.getFrame());
		//
		// // reset the key
		// app.key = 'q';
		// } else
		// {
		// PImage initialFrame = _opencv.getFrame();
		//
		// _opencv.contrast(120);
		// _opencv.blur(3);
		//
		// // draw the background image.
		// app.image(_background, 0, 0);
		//
		// // overlay the mask.
		// app.image(createDiffedImage(initialFrame), 0, 0);
		// }
	}
}
