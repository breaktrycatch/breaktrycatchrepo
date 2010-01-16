package com.breaktrycatch.needmorehumans.core;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.Stage;
import com.breaktrycatch.needmorehumans.view.ViewManager;
import com.breaktrycatch.needmorehumans.utils.FPS;

public class NeedMoreHumansCore extends Stage
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ViewManager _mainViewManager;

	public NeedMoreHumansCore(PApplet app)
	{
		super(app);

		app.frameRate(60);
		app.size(1300, 800, PApplet.P2D);
		
		_mainViewManager = new ViewManager(app);
		_mainViewManager.changeView(ViewManager.CAPTURE_VIEW);
		add(_mainViewManager);

		add(FPS.register(app));
	}

	@Override
	public void draw()
	{
		super.draw();

		PApplet app = getApp();
		if (app.key == '1')
		{
			_mainViewManager.changeView(ViewManager.CAPTURE_VIEW);
		} else if (app.key == '2')
		{
			_mainViewManager.changeView(ViewManager.TRACING_VIEW);
		} else if (app.key == '3')
		{
			_mainViewManager.changeView(ViewManager.PHYSICS_VIEW);
		}
	}
}
