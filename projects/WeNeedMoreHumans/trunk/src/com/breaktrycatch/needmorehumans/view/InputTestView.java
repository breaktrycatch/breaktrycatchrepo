package com.breaktrycatch.needmorehumans.view;

import java.util.List;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.lib.view.AbstractView;
import com.esotericsoftware.controller.device.Axis;
import com.esotericsoftware.controller.input.JInputXboxController;
import com.esotericsoftware.controller.input.XboxController;

public class InputTestView extends AbstractView {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ImageFrame _frame;
	private XboxController _controller;

	public InputTestView() {

	}

	@Override
	public void initialize(PApplet app) {

		super.initialize(app);
		
		List<XboxController> jInputControllers = JInputXboxController
				.getJInputControllers();
		_controller = jInputControllers.get(0);

		// none found
		if (_controller == null) {
			throw new NullPointerException("No gamepad found");
		}

		PImage img = app.loadImage("../data/tracing/TestPerson_png.png");
		_frame = new ImageFrame(app, img);
		add(_frame);

	}
	
	@Override
	public void draw() {
		// TODO Auto-generated method stub
		super.draw();
		
		_controller.poll();

		_frame.rotation += _controller.get(Axis.leftTrigger);
		_frame.rotation -= _controller.get(Axis.rightTrigger);

		_frame.x += (int)(_controller.get(Axis.leftStickX) * 5);
		_frame.y -= (int)(_controller.get(Axis.leftStickY) * 5);
		
		
	}
}
