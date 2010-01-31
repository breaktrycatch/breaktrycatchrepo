package com.breaktrycatch.needmorehumans.core;

import java.awt.Dimension;
import java.awt.Toolkit;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.Stage;
import com.breaktrycatch.needmorehumans.utils.FPS;
import com.breaktrycatch.needmorehumans.view.ViewManager;

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

		Toolkit toolkit = Toolkit.getDefaultToolkit();

		// Get the current screen size
		Dimension scrnsize = toolkit.getScreenSize();

		app.frameRate(60);
		app.size(scrnsize.width, scrnsize.height - 120, PApplet.P2D);

		_mainViewManager = new ViewManager(app);
		
		PApplet.println("Changing to game view???");
		
		_mainViewManager.changeView(ViewManager.GAME_VIEW);
		add(_mainViewManager);

		add(FPS.register(app));
	}

	@Override
	public void draw()
	{
		getApp().background(0xff00ff);
		
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
