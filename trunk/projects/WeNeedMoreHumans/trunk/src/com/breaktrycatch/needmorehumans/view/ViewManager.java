package com.breaktrycatch.needmorehumans.view;

import processing.core.PApplet;

import com.breaktrycatch.lib.view.AbstractViewManager;

public class ViewManager extends AbstractViewManager
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ViewManager(PApplet app)
	{
		super(app);
	}

	public static final String CAPTURE_VIEW = com.breaktrycatch.needmorehumans.view.CaptureView.class.getName();
	public static final String TRACING_VIEW = com.breaktrycatch.needmorehumans.view.TracingDebugView.class.getName();
	public static final String PHYSICS_VIEW = com.breaktrycatch.needmorehumans.view.PhysicsView.class.getName();
	public static final String GAME_VIEW = com.breaktrycatch.needmorehumans.view.GameView.class.getName();
	public static final String INPUT_TEST_VIEW = com.breaktrycatch.needmorehumans.view.InputTestView.class.getName();
	public static final String TWITTER_VIEW = com.breaktrycatch.needmorehumans.view.TwitterAndLoadView.class.getName();
}
