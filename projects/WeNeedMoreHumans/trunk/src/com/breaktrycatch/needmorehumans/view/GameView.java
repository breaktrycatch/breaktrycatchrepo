package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;
import java.awt.geom.Point2D.Float;
import java.io.File;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.display.Countdown;
import com.breaktrycatch.needmorehumans.control.display.ParallaxBackground;
import com.breaktrycatch.needmorehumans.control.display.Windmill;
import com.breaktrycatch.needmorehumans.control.display.XBoxControllableSprite;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;
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
	private ParallaxBackground _background;

	public GameView()
	{
	}
	
	private void createEnvironment()
	{
		// creates the environment
		PApplet app = getApp();
		_background = new ParallaxBackground(app, _physControl.width * 3, _physControl.height);
		DisplayObject background = _background.addVerticalTilingLayer(app.loadImage("../data/world/large-background.png"), 0);
		DisplayObject trees = _background.addHorizontalTilingLayer(app.loadImage("../data/world/trees.png"), .5f);
		DisplayObject windmill = _background.addLayer(new Windmill(app), .7f);
		DisplayObject ground = _background.addHorizontalTilingLayer(app.loadImage("../data/world/ground.png"), 1);
		background.y = -app.height;
		ground.y = _physControl.height - 7; // 7 is half the thickness of the physics ground plane
		windmill.y = ground.y - windmill.height + 20;
		trees.y = ground.y - trees.height;
		
		add(_background);
	}
	
	private void createPhysicsControl()
	{
		PApplet app = getApp();
		_physControl = new PhysicsControl(app);
		_physControl.width = app.width * 2;
		_physControl.height = app.height * 6;
		
		_physControl.x = -_physControl.width / 2 + app.width / 2;
		_physControl.y = -_physControl.height + app.height - 25; // (40 is the height of the ground image)
		
		Rectangle rect = new Rectangle((int)-_physControl.width / 2, (int)_physControl.y, (int) _physControl.width - app.width, (int) _physControl.height);
		_physControl.setScrollBounds(rect);
		_physControl.init();
	}
	
	private void createCaptureControl()
	{
//		PApplet app = getApp();
//		_capControl = new CaptureControl(app);
//		_capControl.x = (app.width / 2);
//		_capControl.width = (app.width / 2);
//		_capControl.height = (app.height);
//		_capControl.setDebugMode(true);
//		add(_capControl);
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		createPhysicsControl();
		createEnvironment();
		
		// add after we create the environment!
		add(_physControl);
		
		createCaptureControl();

		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

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
//							PImage img = _capControl.getProcessedImage();
//							if (img.width > 0 && img.height > 0)
//							{
//								final PImage img = getApp().loadImage("../data/subtraction/debug-image-1252438725312.png");
								final PImage img = getApp().loadImage("../data/tracing/RealPerson_2_trimmed.png");

								String path = new File("").getAbsolutePath() + "debug-image" + System.nanoTime() + ".png";
								LogRepository.getInstance().getPaulsLogger().info("Saving Debug Image " + path);
								img.save(path);

								final XBoxControllableSprite sprite = new XBoxControllableSprite(getApp());
								sprite.setRotateAroundCenter(true);
								sprite.addFrame(img);
								sprite.x = _physControl.width / 2 - sprite.width / 2;
								sprite.y = _physControl.height - getApp().height / 2 - sprite.height / 2;

								Rectangle imageBounds = new Rectangle(0,0,(int)(_physControl.width - sprite.width), (int)(_physControl.height - sprite.height));
								sprite.setScrollBounds(imageBounds);
								
								// on update check if our sprite is near the edges and scroll the view port so we never lose it.
								sprite.setUpdatedCallback(new ISimpleCallback()
								{
									public void execute()
									{
										Float localToGlobal = sprite.localToGlobal();
										float margin = 5;
										PApplet app = getApp();
										if(localToGlobal.x < margin)
										{
											_physControl.x += margin - localToGlobal.x;
										}
										else if(localToGlobal.x > app.width - img.width - margin)
										{
											_physControl.x -= (localToGlobal.x - app.width + img.width) + margin;
										}
										
										if(localToGlobal.y < margin)
										{
											_physControl.y += margin - localToGlobal.y;
										}
										else if(localToGlobal.y > app.height - img.height - margin)
										{
											_physControl.y -= (localToGlobal.y - app.height + img.height) + margin;
										}

//										_background.scaleX = _background.scaleY -= .01f;
//										_physControl.scaleX = _physControl.scaleY -= .01f;
										
										_physControl.constrainToBounds();
										sprite.constrainToBounds();
									}
								});
								_physControl.add(sprite);

								final ISimpleCallback placementCallback = new ISimpleCallback()
								{
									@Override
									public void execute()
									{
										sprite.enableController(false);
										_physControl.remove(sprite);
										_physControl.addHuman(sprite);
										LogRepository.getInstance().getPaulsLogger().info("Placed Sprite in PhysicsControl.");
										keyboardManager.unregisterKeyOnce('p', this);
										controllerManager.registerButtonOnce(Button.a, this);
									}
								};

								controllerManager.registerButtonOnce(Button.a, placementCallback);
								keyboardManager.registerKeyOnce('p', placementCallback);

								LogRepository.getInstance().getPaulsLogger().info("Captured image of size: " + img.width + ", " + img.height);
//							} else
//							{
//								// TODO: Trap images that are > 60% opaque. They
//								// are too big and we had a lighting glitch.
//								// TODO: Trap images that are < 10% opaque. They
//								// don't have a person in it!
//								// TODO: Inform user that no image was captured.
//
//								LogRepository.getInstance().getPaulsLogger().warn("Image was no good! Discarding.");
//							}

							_physControl.remove(_countdown);
							_countdown = null;

						};
					});

					_countdown.x = _physControl.width / 2 - _countdown.width / 2;
					_countdown.y = _physControl.height - getApp().height / 2;
					_countdown.setCountFrom(1);
					_countdown.start();
					_physControl.add(_countdown);
				}
				LogRepository.getInstance().getPaulsLogger().info("Beginning count down");
			};
		};

		// A button triggers the start of the count down...
		controllerManager.registerButtonOnce(Button.b, countdownCallback);
		keyboardManager.registerKeyOnce('c', countdownCallback);

	}

	@Override
	public void draw()
	{
		_background.x = _physControl.x;
		_background.y = _physControl.y;

		super.draw();
	}
}
