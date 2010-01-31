package com.breaktrycatch.needmorehumans.control.webcam;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.LibCompVis;
import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.SimpleCapture;
import toxi.video.capture.plugins.ErosionPlugin;
import toxi.video.capture.plugins.ProcessorPlugin;

import com.breaktrycatch.needmorehumans.control.video.plugins.ChannelThresholdPlugin;
import com.breaktrycatch.needmorehumans.control.video.plugins.GapFillPlugin;
import com.breaktrycatch.needmorehumans.utils.ImageUtils;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

public class HumanProcessorControl
{
	private ProcessorPipeline _prePipeline;
	private ProcessorPipeline _pipeline;
	private ProcessorPipeline _postPipeline;
	private ImageSubstractionController _subtractor;
	private SimpleCapture _capture;
	private TileImageDrawer _debugDrawer;
	private boolean _captureBackgrounds;
	private int _numBackgrounds;
	private PImage _processedImage;
	private PImage _rawFrame;
	private boolean _processingEnabled;
	private boolean _debugMode = false;

	public HumanProcessorControl(PApplet app, SimpleCapture capture)
	{
		_capture = capture;
		_processingEnabled = true;

		_subtractor = new ImageSubstractionController(app, app.createImage(capture.getWidth(), capture.getHeight(), PApplet.ARGB));
		LibCompVis vis = new LibCompVis(app, _capture);

		_prePipeline = new ProcessorPipeline(vis);
		_pipeline = new ProcessorPipeline(vis);
		_postPipeline = new ProcessorPipeline(vis);

		configurePrePipeline();
		configurePipeline();
		configurePostPipeline();
	}

	public void setProcessingEnabled(boolean enabled)
	{
		_processingEnabled = enabled;
	}

	public void setDebugDrawer(TileImageDrawer debugDrawer)
	{
		_debugDrawer = debugDrawer;
		_postPipeline.setDebugDrawer(_debugDrawer);
		_pipeline.setDebugDrawer(_debugDrawer);
		_prePipeline.setDebugDrawer(_debugDrawer);
		_debugMode = true;
	}

	public void setBackgroundImage(PImage background)
	{
		_subtractor.setBackgroundImage(background);
	}

	private void configurePrePipeline()
	{
		// HashMap<String, Comparable<?>> contrastConfig = new HashMap<String,
		// Comparable<?>>();
		// addPlugin(_prePipeline, ContrastPlugin.class, contrastConfig);
	}

	private void configurePostPipeline()
	{
		// HashMap<String, Comparable<?>> edgeDetect = new HashMap<String,
		// Comparable<?>>();
		// edgeDetect.put(SobelEdgeDetectionPlugin.TOLERANCE, 50);
		// addPlugin(_postPipeline, SobelEdgeDetectionPlugin.class, edgeDetect);

		HashMap<String, Comparable<?>> contractBack = new HashMap<String, Comparable<?>>();
		contractBack.put(ErosionPlugin.INVERTED, false);
		contractBack.put(ErosionPlugin.NUM_PASSES, 2);
		addPlugin(_postPipeline, ErosionPlugin.class, contractBack);
	}

	private void configurePipeline()
	{
		HashMap<String, Comparable<?>> alphaThresholdConfig = new HashMap<String, Comparable<?>>();
		alphaThresholdConfig.put(ChannelThresholdPlugin.CHANNEL_THRESHOLD, 10);
		alphaThresholdConfig.put(ChannelThresholdPlugin.CHANNEL, ChannelThresholdPlugin.BLUE);
		addPlugin(_pipeline, ChannelThresholdPlugin.class, alphaThresholdConfig);

		// get rid of the little things
		HashMap<String, Comparable<?>> contractConfig = new HashMap<String, Comparable<?>>();
		contractConfig.put(ErosionPlugin.INVERTED, false);
		contractConfig.put(ErosionPlugin.NUM_PASSES, 2);
		addPlugin(_pipeline, ErosionPlugin.class, contractConfig);

		HashMap<String, Comparable<?>> fillGaps = new HashMap<String, Comparable<?>>();
		fillGaps.put(GapFillPlugin.GAP_FILL, 8);
		fillGaps.put(GapFillPlugin.START_THRESHOLD, 200);
		fillGaps.put(GapFillPlugin.END_THRESHOLD, 50);
		addPlugin(_pipeline, GapFillPlugin.class, fillGaps);

		// blow it up huuuuuuge to fill in the holes
		HashMap<String, Comparable<?>> expandConfig = new HashMap<String, Comparable<?>>();
		expandConfig.put(ErosionPlugin.INVERTED, true);
		expandConfig.put(ErosionPlugin.NUM_PASSES, 6);
		addPlugin(_pipeline, ErosionPlugin.class, expandConfig);

		// HashMap<String, Comparable<?>> adaptiveThreshold = new
		// HashMap<String, Comparable<?>>();
		// adaptiveThreshold.put(AdaptiveThresholdPlugin.FILTER_CONSTANT, 3);
		// adaptiveThreshold.put(AdaptiveThresholdPlugin.KERNEL_SIZE, 5);
		// addPlugin(_pipeline, AdaptiveThresholdPlugin.class,
		// adaptiveThreshold);

		// // shrink it down to normal.
		HashMap<String, Comparable<?>> contractBack = new HashMap<String, Comparable<?>>();
		contractBack.put(ErosionPlugin.INVERTED, false);
		contractBack.put(ErosionPlugin.NUM_PASSES, 3);
		addPlugin(_pipeline, ErosionPlugin.class, contractBack);

		// HashMap<String, Comparable<?>> noiseReduction = new HashMap<String,
		// Comparable<?>>();
		// noiseReduction.put(NoiseReductionPlugin.KERNEL, 8);
		// noiseReduction.put(NoiseReductionPlugin.THRESHOLD, 200);
		// addPlugin(_pipeline, NoiseReductionPlugin.class, noiseReduction);

		// HashMap<String, Comparable<?>> contractBack = new HashMap<String,
		// Comparable<?>>();
		// contractBack.put(ErosionPlugin.INVERTED, false);
		// contractBack.put(ErosionPlugin.NUM_PASSES, 1);
		// addPlugin(_pipeline, ErosionPlugin.class, contractBack);
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

	private void debugDraw(PImage img)
	{
		if (_debugMode)
		{
			_debugDrawer.drawImage(img);
		}
	}

	private PImage createDiffedImage(PImage foreground)
	{
		// get the frame with the foreground object in it from the camera.
		PImage frame = ImageUtils.cloneImage(foreground);

		// create a simple difference mask from the frame.
		PImage mask = _subtractor.createDifferenceMask(frame);

		debugDraw(mask);

		// process the mask to remove noise and gaps.
		mask.pixels = _pipeline.process(mask.pixels, mask.width, mask.height);

		// apply the mask to our raw camera frame.
		PImage maskedFrame = _subtractor.applyDifferenceMask(foreground, mask);

		_subtractor.extractLargestBlob(maskedFrame);
		// _subtractor.removeShadows(maskedFrame);

		// post process to clean up the image.
		maskedFrame.pixels = _postPipeline.process(maskedFrame.pixels, maskedFrame.width, maskedFrame.height);

		return ImageUtils.trimTransparency(maskedFrame);
	}

	public void update()
	{
		if (_captureBackgrounds)
		{
			PApplet.println("CAPTURING BACKGROUNDS..........");
			_capture.read();
			_rawFrame = _capture.getFrame();
			debugDraw(_rawFrame);
			
			_rawFrame.pixels = _prePipeline.process(_rawFrame.pixels, _rawFrame.width, _rawFrame.height);

			debugDraw(_rawFrame);
			_subtractor.addBackgroundImage(ImageUtils.cloneImage(_rawFrame));

			if (_subtractor.totalBackgrounds() > _numBackgrounds)
			{
				_subtractor.averageBackgrounds();
				_captureBackgrounds = false;
			}
		}

		// we want this to follow through if we just average the backgrounds.
		if (!_captureBackgrounds && _processingEnabled)
		{
			_capture.read();
			_rawFrame = _capture.getFrame();
			debugDraw(_rawFrame);
			_rawFrame.pixels = _prePipeline.process(_rawFrame.pixels, _rawFrame.width, _rawFrame.height);

			debugDraw(_subtractor.getBackgroundImage());

			PImage initialFrame = ImageUtils.cloneImage(_capture.getFrame());

			// overlay the mask.
			_processedImage = createDiffedImage(initialFrame);
		}
	}

	public PImage getRawCameraImage()
	{
		_capture.read();
		_rawFrame = _capture.getFrame();
		return _rawFrame;
	}

	public PImage getProcessedImage()
	{
		if (!_captureBackgrounds)
		{
			_capture.read();
			_rawFrame = _capture.getFrame();
			debugDraw(_rawFrame);
			
			_rawFrame.pixels = _prePipeline.process(_rawFrame.pixels, _rawFrame.width, _rawFrame.height);

			debugDraw(_subtractor.getBackgroundImage());

			PImage initialFrame = ImageUtils.cloneImage(_capture.getFrame());

			// overlay the mask.
			return createDiffedImage(initialFrame);

		} else
		{
			LogRepository.getInstance().getPaulsLogger().warn("Attempted to capture differenced image while backgrounds were being captured!");
			return null;
		}
	}

	public void captureBackgrounds(int numBackgrounds)
	{
		_subtractor.clearBackgrounds();
		_numBackgrounds = numBackgrounds;
		_captureBackgrounds = true;
	}

	public boolean isCapturingBackgrounds()
	{
		return _captureBackgrounds;
	}

	public void setDifferenceThreshold(int diff)
	{
		_subtractor.setDifferenceThreshold(diff);
	}

	public void setScale(float scale)
	{
		_subtractor.setScale(scale);
	}

	public void setShadowThreshold(float diff)
	{
		_subtractor.setShadowThreshold(diff);
	}
}
