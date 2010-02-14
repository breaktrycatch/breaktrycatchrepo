package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.HashMap;

import megamu.shapetween.Shaper;

import org.apache.log4j.Level;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.config.control.ColorController;
import com.breaktrycatch.needmorehumans.control.camera.Simple2DCamera;
import com.breaktrycatch.needmorehumans.control.display.Countdown;
import com.breaktrycatch.needmorehumans.control.display.HeightMarker;
import com.breaktrycatch.needmorehumans.control.display.MonkeySpawner;
import com.breaktrycatch.needmorehumans.control.display.ParallaxBackground;
import com.breaktrycatch.needmorehumans.control.display.SkyObject;
import com.breaktrycatch.needmorehumans.control.display.TallestPointTextField;
import com.breaktrycatch.needmorehumans.control.display.Windmill;
import com.breaktrycatch.needmorehumans.control.display.XBoxControllableSprite;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureValidator;
import com.breaktrycatch.needmorehumans.control.webcam.callback.ICaptureCallback;
import com.breaktrycatch.needmorehumans.model.BodyVO;
import com.breaktrycatch.needmorehumans.tracing.callback.IThreadedImageAnalysisCallback;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
import com.breaktrycatch.needmorehumans.utils.FileUtils;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.RectUtils;
import com.breaktrycatch.needmorehumans.utils.twitter.TwitterTowerMonitor;
import com.esotericsoftware.controller.device.Button;

public class GameView extends AbstractView
{
	private static final long serialVersionUID = 1L;
	private CaptureControl _capControl;
	private PhysicsControl _physControl;
	protected Countdown _countdown;
	private ParallaxBackground _background;
	private DisplayObject _zoomContainer;
	private Simple2DCamera _camera;
	private TwitterTowerMonitor _twitterMonitor;
	private HeightMarker _heightMarker;
	private TallestPointTextField _tallestPoint;
	private boolean _isPlacing = false;
	private String[] _spriteLookup = new String[]
	{ "../data/no-ear.png", "../data/tracing/RealPerson_1.png", "../data/tracing/RealPerson_3.png", "../data/tracing/RealPerson_4.png", "../data/tracing/RealPerson_5.png" };

	private String _debugFilename = _spriteLookup[0];

	private ArrayList<XBoxControllableSprite> _sprites;
	private XBoxControllableSprite _activeSprite;

	Rectangle _activeSpriteRect;
	Rectangle _checkSpriteRect;
	boolean _validplacement;
	private MonkeySpawner _deliveryMonkey;

	public GameView()
	{
		PApplet.println("DEBUG MODE? " + ConfigTools.getBoolean("general", "debugMode"));

		if (!ConfigTools.getBoolean("general", "debugMode"))
		{
			LogRepository.getInstance().getJonsLogger().setLevel(Level.ERROR);
			LogRepository.getInstance().getMikesLogger().setLevel(Level.ERROR);
		}
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		_sprites = new ArrayList<XBoxControllableSprite>();
		_zoomContainer = new DisplayObject(app);
		add(_zoomContainer);

		createPhysicsControl();
		createEnvironment();
		createCamera();

		// add after we create the environment!
		_zoomContainer.add(_physControl);
		
		// put the grass in front of the people.
		ParallaxBackground frontLayer = new ParallaxBackground(app, _physControl.width * 3.5f, _physControl.height);
		DisplayObject grass = frontLayer.addHorizontalTilingLayer(app.loadImage("../data/world/grass.png"), 1);
		grass.y = _physControl.height - 7 - 40;
		_zoomContainer.add(frontLayer);
		
		createCaptureControl();
		createInputListeners();

		_twitterMonitor = new TwitterTowerMonitor(app);
	}

	private void createEnvironment()
	{
		// creates the environment
		PApplet app = getApp();
		_background = new ParallaxBackground(app, _physControl.width * 3.5f, _physControl.height);
		DisplayObject background = _background.addHorizontalTilingLayer(app.loadImage("../data/world/large-background2.png"), .05f);
		
		int numClouds = 6;
		HashMap<String, PImage> cloudTable = new HashMap<String, PImage>();
		Rectangle cloudBounds = new Rectangle((int)(-_physControl.width), 0, (int) (_physControl.width * 2), (int) _physControl.height);
		for (int i = 0; i < 40; i++)
		{
			int cloudType = (int) (Math.floor(Math.random() * numClouds)) + 1;
			String filename = "../data/world/cloud" + cloudType + ".png";
			if(!cloudTable.containsKey(filename))
			{
				cloudTable.put(filename, app.loadImage(filename));
			}
			
			SkyObject cloud = new SkyObject(app, cloudBounds);
			cloud.addFrame(cloudTable.get(filename));
			cloud.setSpritePosition((int) (Math.random() * cloudBounds.width), (int) (Math.random() * (cloudBounds.height - 400)));
			cloud.setVelocity(-((float) (Math.random() / 2) + .5f), 0);
			_background.addLayer(cloud, .2f);
		}
		
		DisplayObject windmill = _background.addLayer(new Windmill(app), .15f);
		
		SkyObject backgroundMonkey = new SkyObject(getApp(), cloudBounds);
		backgroundMonkey.addFrame(app.loadImage("../data/world/ape-background.png"));
		backgroundMonkey.setVelocity(1,0);
		backgroundMonkey.x = (int)(Math.random() * cloudBounds.width);
		_background.addLayer(backgroundMonkey, .15f);
		
		DisplayObject cityBack = _background.addHorizontalTilingLayer(app.loadImage("../data/world/amsterdam-buildings-back.png"), .1f);
		DisplayObject cityFront = _background.addHorizontalTilingLayer(app.loadImage("../data/world/amsterdam-buildings-front.png"), .2f);
		DisplayObject trees = _background.addHorizontalTilingLayer(app.loadImage("../data/world/far-grass.png"), .5f);
		DisplayObject ground = _background.addHorizontalTilingLayer(app.loadImage("../data/world/ground.png"), 1);
		
		
		background.y = -app.height;
		ground.y = _physControl.height - 7; // 7 is half the thickness of the
		// physics ground plane
		windmill.y = ground.y - windmill.height - 70;
		cityFront.y = ground.y - cityFront.height - 60;
		cityBack.y = ground.y - cityBack.height;
		trees.y = ground.y - trees.height;
		background.y = ground.y - background.height;
		backgroundMonkey.y = cityBack.y - backgroundMonkey.height / 3;

		_deliveryMonkey = new MonkeySpawner(getApp());
		_deliveryMonkey.visible = false;
		_deliveryMonkey.setBounds(new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
		_background.add(_deliveryMonkey);
		
		_zoomContainer.add(_background);
		_heightMarker = new HeightMarker(app);
		_heightMarker.setBounds(new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
		_zoomContainer.add(_heightMarker);

		_tallestPoint = new TallestPointTextField(app);
		_tallestPoint.x = app.width - 330;
		_tallestPoint.y = 30;
		add(_tallestPoint);
	}

	private void createPhysicsControl()
	{
		PApplet app = getApp();
		_physControl = new PhysicsControl(app);
		_physControl.width = 4000;
		_physControl.height = 10000;
		_physControl.init();
	}

	private void createCaptureControl()
	{
		PApplet app = getApp();
		_capControl = new CaptureControl(app);
		_capControl.x = (app.width / 2);
		_capControl.width = (app.width / 2);
		_capControl.height = (app.height);

		// TODO: Hook this up to a config var...
		_capControl.setDebugMode(true);
		add(_capControl);
	}

	private void createCamera()
	{
		PApplet app = getApp();
		_camera = new Simple2DCamera(app, new Rectangle(0, 0, app.width, app.height), new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
		_camera.lookAt(_physControl.width / 2, 0);
		_camera.lookAt(_physControl.width / 2, _physControl.height, 5f);
	}

	private void createInputListeners()
	{
		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

		final ISimpleCallback countdownCallback = new ISimpleCallback()
		{
			public void execute()
			{
				startCountdown();
			}
		};

		// A button triggers the start of the count down...
		controllerManager.registerButtonOnce(Button.b, countdownCallback);
		keyboardManager.registerKeyOnce('c', countdownCallback);

		if (ConfigTools.getBoolean("general", "debugMode"))
		{
			keyboardManager.registerKeyOnce('7', new ISimpleCallback()
			{
				public void execute()
				{
					_debugFilename = _spriteLookup[0];
					beginCapture(null);
				}
			});

			keyboardManager.registerKeyOnce('8', new ISimpleCallback()
			{
				public void execute()
				{
					_debugFilename = _spriteLookup[1];
					beginCapture(null);
				}
			});

			keyboardManager.registerKeyOnce('9', new ISimpleCallback()
			{
				public void execute()
				{
					_debugFilename = _spriteLookup[2];
					beginCapture(null);
				}
			});

			keyboardManager.registerKeyOnce('0', new ISimpleCallback()
			{
				public void execute()
				{
					_debugFilename = _spriteLookup[3];
					beginCapture(null);
				}
			});

			keyboardManager.registerKeyOnce('j', new ISimpleCallback()
			{
				public void execute()
				{
					PImage img = FileUtils.createTowerImage(getApp(), _sprites);
					FileUtils.saveTowerImage(img);
				}
			});
		}
	}

	private void startCountdown()
	{
		// don't start a count down if one is in progress.
		if (_countdown == null && !_isPlacing)
		{
			LogRepository.getInstance().getPaulsLogger().info("Beginning count down");

			_countdown = new Countdown(getApp(), new ISimpleCallback()
			{
				// once the count down is complete we start capturing
				// the image.
				public void execute()
				{
					countdownComplete();
				}
			});
			_countdown.x = getApp().width / 2;
			_countdown.y = getApp().height / 2;
			_countdown.setCountFrom(3);
			_countdown.start();
			add(_countdown);
		}	
	}

	private void countdownComplete()
	{
		remove(_countdown);
		_countdown = null;

		_capControl.beginCapture(1, new ICaptureCallback()
		{
			// executes when the capture has completed.
			public void execute(ArrayList<PImage> images)
			{
				beginCapture(images);
			}
		});
	}

	private void beginCapture(ArrayList<PImage> images)
	{
		if (!_isPlacing)
		{
			if (images != null)
			{
				ArrayList<PImage> culledImages = CaptureValidator.validateList(images);

				if (images.size() > 0)
				{
					beginPlacement(culledImages);
					showCameraFlash();
				} else
				{
					LogRepository.getInstance().getPaulsLogger().warn("No images returned from capture control!");
					errorCameraFlash();
				}
			} else
			{
				ArrayList<PImage> debugImage = new ArrayList<PImage>();
//				debugImage.add(ImageUtils.trimTransparency(getApp().loadImage(_debugFilename)));
				debugImage.add(getApp().loadImage(_debugFilename));
				beginPlacement(debugImage);

				showCameraFlash();
			}
		}
	}

	private void beginPlacement(final ArrayList<PImage> images)
	{
		_isPlacing = true;

		final PImage img = images.get(0);

		// save the file out for later.
		FileUtils.saveSourceImage(img);

		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

		_activeSprite = createPlacementSprite(images);


		// fire up the worker thread to process our guy.
		_physControl.createBodyFromHuman(_activeSprite, new IThreadedImageAnalysisCallback()
		{
			public void execute(BodyVO analyzedBody)
			{
				// if we didn't find an ear, throw it away!
				if (analyzedBody == null)
				{
					_activeSprite.enableController(false);
					LogRepository.getInstance().getPaulsLogger().info("Removed Sprite.");

					keyboardManager.unregisterKeyOnce('p', _placementCallback);
					controllerManager.unregisterButtonOnce(Button.a, _placementCallback);

					keyboardManager.unregisterKeyOnce('r', _removeCallback);
					controllerManager.unregisterButtonOnce(Button.b, _removeCallback);

					errorCameraFlash();

					_isPlacing = false;
				} else
				{
					// _sprites.add(sprite);
					_activeSprite.scaleX = _activeSprite.scaleY = 0;
					_physControl.add(_activeSprite);
					creationCameraZoom(_activeSprite);
					
					introActiveSprite();

				}
			}
		});
		
		LogRepository.getInstance().getPaulsLogger().info("Captured image of size: " + img.width + ", " + img.height);
	}
	
	private void introActiveSprite()
	{
		

		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);
		final int dist = 1000;
		final Rectangle towerRect = (Rectangle)_physControl.getTowerRect().clone();
		
		if(towerRect.width == 0 || towerRect.height == 0)
		{
			towerRect.x = (int)_physControl.width / 2;
		}
		_deliveryMonkey.x = towerRect.x + towerRect.width + dist;
		_deliveryMonkey.y = _activeSprite.y - _deliveryMonkey.height / 2;
		_deliveryMonkey.visible = true;
		_deliveryMonkey.slideTo((int)_activeSprite.x, (int)_deliveryMonkey.y, .5f, null, new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				_deliveryMonkey.shake(new ISimpleCallback()
				{
					
					@Override
					public void execute()
					{
						_activeSprite.enableController(true);
						_activeSprite.setScaleAroundCenter(true);
						_activeSprite.scaleTo(1, 1, .5f, Shaper.COSINE);
						
						controllerManager.registerButtonOnce(Button.a, _placementCallback);
						keyboardManager.registerKeyOnce('p', _placementCallback);

						controllerManager.registerButtonOnce(Button.b, _removeCallback);
						keyboardManager.registerKeyOnce('r', _removeCallback);
						
						_deliveryMonkey.slideTo(towerRect.x + towerRect.width + dist, (int)_deliveryMonkey.y, .5f, null, new ISimpleCallback()
						{	
							@Override
							public void execute()
							{
								_deliveryMonkey.visible = false;
							}
						});
					}
				});
			}
		});
	}

	// remove the human from the sim since its a bad capture.
	private final ISimpleCallback _removeCallback = new ISimpleCallback()
	{
		@Override
		public void execute()
		{
			final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
			final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

			_activeSprite.enableController(false);
			_physControl.remove(_activeSprite);
			_activeSprite = null;

			LogRepository.getInstance().getPaulsLogger().info("Removed Sprite.");

			keyboardManager.unregisterKeyOnce('p', _placementCallback);
			controllerManager.unregisterButtonOnce(Button.a, _placementCallback);

			keyboardManager.unregisterKeyOnce('r', _removeCallback);
			controllerManager.unregisterButtonOnce(Button.b, _removeCallback);
		}
	};

	// place the human in to the sim
	private final ISimpleCallback _placementCallback = new ISimpleCallback()
	{

		@Override
		public void execute()
		{
			if (_validplacement)
			{
				_sprites.add(_activeSprite);
				_activeSprite.enableController(false);

				// zoom out to see the whole tower (with a minimum size)
				Rectangle towerRect = (Rectangle) _physControl.getTowerRect().clone();
				if (towerRect.width == 0 || towerRect.height == 0)
				{
					towerRect.x = (int) _activeSprite.x;
					towerRect.y = (int) _physControl.height;
					towerRect.width = 600;
					towerRect.height = 600;
				}

				RectUtils.expand(towerRect, 300);
				_camera.lookAt(towerRect, 1f);

				_physControl.addCurrentBody();
				LogRepository.getInstance().getPaulsLogger().info("Placed Sprite in PhysicsControl.");

				final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
				final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

				keyboardManager.unregisterKeyOnce('p', this);
				controllerManager.unregisterButtonOnce(Button.a, this);

				keyboardManager.unregisterKeyOnce('r', _removeCallback);
				controllerManager.unregisterButtonOnce(Button.b, _removeCallback);

				_isPlacing = false;
				_activeSprite = null;
			} else
			{
				errorCameraFlash();
			}
		}
	};

	private void creationCameraZoom(final XBoxControllableSprite sprite)
	{
		Rectangle lookAtBounds = RectUtils.expand(sprite.getBounds(), 700);
		_camera.lookAt(lookAtBounds, .5f, new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				sprite.setUpdatedCallback(new ISimpleCallback()
				{
					public void execute()
					{
						Rectangle lookAtBounds = sprite.getBounds();
						lookAtBounds = RectUtils.expand(lookAtBounds, 700);
						_camera.lookAt(lookAtBounds);
						sprite.constrainToBounds();
					}
				});
			}
		});
	}

	private XBoxControllableSprite createPlacementSprite(ArrayList<PImage> images)
	{
		final XBoxControllableSprite sprite = new XBoxControllableSprite(getApp());
		sprite.setRotateAroundCenter(true);
		sprite.addFrames(images);
		sprite.setFPS(3);

		Rectangle towerRect = _physControl.getTowerRect();
		if (towerRect.width > 0 && towerRect.height > 0)
		{
			sprite.x = towerRect.x + (towerRect.width - sprite.width) / 2;
			sprite.y = towerRect.y - sprite.height - 50;
		} else
		{
			sprite.x = _physControl.width / 2 - sprite.width / 2;
			sprite.y = _physControl.height - getApp().height / 2 - sprite.height / 2;
		}

		Rectangle imageBounds = new Rectangle(0, 20, (int) (_physControl.width - sprite.width), (int) (_physControl.height - sprite.height));
		sprite.setScrollBounds(imageBounds);

		sprite.enableController(false);

		return sprite;
	}

	@Override
	public void draw()
	{
		Rectangle r = _physControl.getTowerRect();

		_heightMarker.y = (r.y == 0) ? (_physControl.height) : (r.y);
		_heightMarker.x = ((r.x == 0) ? (-1000) : (r.x)) + r.width;
		// love with a red underline upside-down q
		_tallestPoint.setValue(_heightMarker.getDisplayValue());

		if (!ConfigTools.getBoolean("general", "debugMode"))
		{
			_twitterMonitor.update(_heightMarker.getDisplayValue(), _sprites);
		}

		// transforms the root container to the camera's view port.
		_camera.update();
		_camera.setTransform(_zoomContainer);

		_validplacement = true;
		if (_activeSprite != null)
		{
			_activeSpriteRect = _activeSprite.getScreenBounds();

			// Check rect bounds between activeSprite and others
			for (int i = 0; i < _sprites.size(); i++)
			{
				_checkSpriteRect = _sprites.get(i).getScreenBounds();
				if (_activeSpriteRect.intersects(_checkSpriteRect))
				{
					_activeSprite.errorTint();
					 LogRepository.getInstance().getJonsLogger().warn("INVALID PLACEMENT");
					_validplacement = false;
					i = _sprites.size();
				}
			}
			if (_validplacement)
			{
				_activeSprite.regularTint();
			}
		}

		super.draw();
	}

	private void errorCameraFlash()
	{
		showCameraFlash(0xffff0000);
	}

	private void showCameraFlash()
	{
		showCameraFlash(0xffffffff);
	}

	private void showCameraFlash(int col)
	{
		// camera flash
		final ColorController color = new ColorController(getApp(), 0, 0, getApp().width, getApp().height);
		color.setColor(col);
		add(color);
		color.alphaTo(0, 1f, null, new ISimpleCallback()
		{
			public void execute()
			{
				remove(color);
			}
		});
	}

}
