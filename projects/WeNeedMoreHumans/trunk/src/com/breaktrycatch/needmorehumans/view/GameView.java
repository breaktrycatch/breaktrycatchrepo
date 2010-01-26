package com.breaktrycatch.needmorehumans.view;

import processing.core.PApplet;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;

public class GameView extends AbstractView
{

	// private PhysicsControl _physControl
	// private CaptureControl _capControl

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private CaptureControl _capControl;
	private PhysicsView _physicsControl;

	public GameView()
	{
		// TODO Auto-generated constructor stub
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		_physicsControl = new PhysicsView();
		_physicsControl.setWidth(app.width / 2);
		_physicsControl.setHeight(app.height);
		_physicsControl.initialize(app);
		add(_physicsControl);

		_capControl = new CaptureControl(app);
		_capControl.setX(app.width / 2);
		_capControl.setWidth(app.width / 2);
		_capControl.setHeight(app.height);
		add(_capControl);
	}

}
