package com.breaktrycatch.needmorehumans.view;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

public class TracingDebugView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private ImageAnalysis __imageAnalysis;

	private TileImageDrawer _debugDrawer;

	public TracingDebugView()
	{

		// all PApplet related commands should be made in setup().
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		_debugDrawer = new TileImageDrawer(app, 1);
		String t1 = "../data/tracing/TestPerson_png.png";
		String t2 = "../data/tracing/Cube.png";
		String p1 = "../data/tracing/RealPerson_1.png";
		String p2 = "../data/tracing/RealPerson_2.png";
		String p3 = "../data/tracing/RealPerson_3.png";
		String p4 = "../data/tracing/RealPerson_4.png";
		String p5 = "../data/tracing/RealPerson_5.png";
		String p6 = "../data/tracing/fuzzy.png";
		String p7 = "../data/tracing/fuzzy2.png";
		String p8 = "../data/tracing/no-ear.png";

		// PImage p =
		// getApp().loadImage("../data/subtraction/debug-image-1252438725312.png");//
		// app.loadImage(p1);
		// PImage p = getApp().loadImage("../data/tracing/RealPerson_3.png");//
		// app.loadImage(p1);
		PImage p = getApp().loadImage(p8);// app.loadImage(p1);
		p.loadPixels();

		__imageAnalysis = new ImageAnalysis(app);
		__imageAnalysis.setDebugDrawer(_debugDrawer);
		__imageAnalysis.analyzeImage(p);
		add(_debugDrawer);
	}

	@Override
	public void draw()
	{
		super.draw();
		_debugDrawer.reset();
		__imageAnalysis.draw();

	}
}
