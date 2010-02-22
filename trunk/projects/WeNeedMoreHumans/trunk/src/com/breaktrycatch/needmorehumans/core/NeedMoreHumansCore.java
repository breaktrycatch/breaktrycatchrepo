package com.breaktrycatch.needmorehumans.core;

import java.awt.Dimension;
import java.awt.Toolkit;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.Stage;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
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
		Dimension scrnsize = toolkit.getScreenSize();

		app.frameRate(45);
		
		PApplet.println("SIZE: " + scrnsize.width + " :: " +  scrnsize.height);

		
		_mainViewManager = new ViewManager(app);
		_mainViewManager.changeView(ViewManager.GAME_VIEW);
		add(_mainViewManager);

		if(ConfigTools.getBoolean("general", "debugMode"))
		{
			add(FPS.register(app));
		}
	}

	@Override
	public void draw()
	{
		getApp().background(0x66a5ea);
		
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
		else if (app.key == '4')
		{
			_mainViewManager.changeView(ViewManager.INPUT_TEST_VIEW);
		}
	}
}
