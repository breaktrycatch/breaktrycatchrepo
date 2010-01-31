package com.breaktrycatch.needmorehumans.view;

import processing.core.PApplet;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;

public class GameView extends AbstractView
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private CaptureControl _capControl;
	private PhysicsControl _physControl;

	public GameView()
	{
		// TODO Auto-generated constructor stub
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		_physControl = new PhysicsControl(app);
		_physControl.width = (app.width / 2);
		_physControl.height = (app.height);
		_physControl.init();
		add(_physControl);

//		_capControl = new CaptureControl(app, new ICaptureCallback()
//		{
//			public void execute(PImage img)
//			{
//				// whenever we've captured an image in the capture view, we set
//				// the sprite in PhysicsControl
//				_physicsControl.setSprite(img);
//			}
//		});
//		_capControl.x = (app.width / 2);
//		_capControl.width = (app.width / 2);
//		_capControl.height = (app.height);
//		add(_capControl);
	}
	
	@Override
	public void draw() {
		// TODO Auto-generated method stub
		super.draw();
		
		
	}
}
