package com.breaktrycatch.needmorehumans.control.video.plugins;

import hypermedia.video.Blob;
import hypermedia.video.OpenCV;

import java.util.HashMap;

import com.breaktrycatch.needmorehumans.utils.LogRepository;

import processing.core.PApplet;
import processing.core.PGraphics;

import toxi.video.capture.ProcessorPipeline;
import toxi.video.capture.plugins.ProcessorPlugin;

public class LargestBlobExtraction extends ProcessorPlugin
{

	public static final String OPEN_CV = "com.breaktrycatch.needmorehumans.control.video.plugins.OPENCV";
	public static final String PAPPLET = "com.breaktrycatch.needmorehumans.control.video.plugins.PAPPLET";
	private OpenCV _cv;
	private PApplet _app;

	public LargestBlobExtraction(ProcessorPipeline p, String id)
	{
		super(p, id);
		// TODO Auto-generated constructor stub
	}


	@Override
	public HashMap<String, Comparable<?>> getConfig()
	{
		LogRepository.getInstance().getPaulsLogger().info("Created hash!");
		
		HashMap<String, Comparable<?>> config = new HashMap<String, Comparable<?>>();
		config.put(OPEN_CV, null);
		config.put(PAPPLET, null);
		return config;
	}

	@Override
	public void configure(HashMap<String, Object> conf)
	{
		_cv = ((OpenCV) conf.get(OPEN_CV));
		_app = ((PApplet) conf.get(PAPPLET));
	}

	@Override
	public int[] process(int[] pixels, int w, int h)
	{
		PGraphics diffed = _app.createGraphics(w, h, PApplet.P2D);
		int imageSize = pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int currColor = pixels[i];
			int fgA = (currColor >> 24) & 0xFF;
			if (fgA == 0)
			{
				diffed.pixels[i] = 0;
			} else
			{
				diffed.pixels[i] = 0xffffffff;
			}
		}

		_cv.copy(diffed);
		Blob[] blobs = _cv.blobs(10, diffed.width * diffed.height / 2, 1, false, OpenCV.MAX_VERTICES);// *

		if (blobs.length == 0)
		{
			return pixels;
		}

		PGraphics blobImage = _app.createGraphics(w, h, PApplet.P2D);
		Blob b = blobs[0];
		blobImage.beginDraw();
		blobImage.beginShape();
		blobImage.fill(0xff0000ff);
		for (int j = 0; j < b.points.length; j++)
		{
			blobImage.vertex(b.points[j].x, b.points[j].y);
		}
		blobImage.endShape();
		blobImage.endDraw();

		imageSize = pixels.length;
		for (int i = imageSize - 1; i > -1; i--)
		{
			int fgB = (blobImage.pixels[i]) & 0xFF;
			if (fgB == 0)
			{
				pixels[i] = 0;
			} else
			{
				pixels[i] = (255 << 24 | pixels[i]);
			}
		}
		return pixels;
	}

}
