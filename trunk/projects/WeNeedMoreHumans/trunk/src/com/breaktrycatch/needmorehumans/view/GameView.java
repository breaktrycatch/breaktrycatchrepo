package com.breaktrycatch.needmorehumans.view;

import java.io.File;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.display.Countdown;
import com.breaktrycatch.needmorehumans.control.display.XBoxControllableSprite;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;
import com.breaktrycatch.needmorehumans.utils.ImageUtils;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.esotericsoftware.controller.device.Button;

public class GameView extends AbstractView
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private CaptureControl _capControl;
	private PhysicsControl _physControl;
	protected Countdown _countdown;

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

		_capControl = new CaptureControl(app);
		_capControl.x = (app.width / 2);
		_capControl.width = (app.width / 2);
		_capControl.height = (app.height);
		_capControl.setDebugMode(true);
		add(_capControl);

		XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

		ISimpleCallback countdownCallback = new ISimpleCallback()
		{
			public void execute()
			{
				// don't start a count down if one is in progress.
				if (_countdown == null)
				{
					_countdown = new Countdown(getApp(), new ISimpleCallback()
					{
						public void execute()
						{
							LogRepository.getInstance().getPaulsLogger().info("Countdown complete, processing image.");
							PImage img = _capControl.getProcessedImage();
							if (img.width > 0 && img.height > 0)
							{

								// this one works..
								img = getApp().loadImage("../data/tracing/RealPerson_1.png");

								// but this one doesn't...????
								// img = getApp().loadImage("../data/subtraction/debug-image-1252438725312.png");
								img.loadPixels();

								ImageFrame sprite = new ImageFrame(getApp(), img);
								// sprite.setRotateAroundCenter(true);
								sprite.x = 200;
								sprite.y = 200;
								_physControl.addHuman(sprite);

								ImageFrame debugSprite = new ImageFrame(getApp(), ImageUtils.cloneImage(img));
								_capControl.add(debugSprite);
								//								
								//								
								// img.save( new File("").getAbsolutePath() +
								// "debug-image-"+System.nanoTime() +".png");
								//								
								// XBoxControllableSprite sprite = new
								// XBoxControllableSprite(getApp());
								// sprite.setRotateAroundCenter(true);
								// sprite.addFrame(img);
								// sprite.x = 200;
								// sprite.y = 200;
								// // _capControl.add(sprite);
								//								
								// _physControl.addHuman(sprite);

								PApplet.println("Captured image of size: " + img.width + ", " + img.height);
							} else
							{
								// TODO: Trap images that are > 60% opaque. They
								// are too big and we had a lighting glitch.
								// TODO: Inform user that no image was captured.

								LogRepository.getInstance().getPaulsLogger().warn("Image was no good! Discarding.");
							}

							remove(_countdown);
							_countdown = null;

						};
					});

					_countdown.x = _capControl.x + _capControl.width / 2;
					_countdown.y = _capControl.y + _capControl.height / 2;
					_countdown.start();
					add(_countdown);
				}
				LogRepository.getInstance().getPaulsLogger().info("Beginning count down");
			};
		};

		// A button triggers the start of the count down...
		controllerManager.registerButtonOnce(Button.a, countdownCallback);
		keyboardManager.registerKeyOnce('c', countdownCallback);
	}

	@Override
	public void draw()
	{
		// TODO Auto-generated method stub
		super.draw();

	}
}
