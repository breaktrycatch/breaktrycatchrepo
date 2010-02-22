package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

import megamu.shapetween.Shaper;

import org.apache.log4j.Level;
import org.jbox2d.common.MathUtils;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.geom.Vec2D;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.lib.util.callback.IFloatCallback;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.config.control.ColorController;
import com.breaktrycatch.needmorehumans.control.camera.Simple2DCamera;
import com.breaktrycatch.needmorehumans.control.display.HeightMarker;
import com.breaktrycatch.needmorehumans.control.display.MonkeySpawner;
import com.breaktrycatch.needmorehumans.control.display.ParallaxBackground;
import com.breaktrycatch.needmorehumans.control.display.ShadowTextField;
import com.breaktrycatch.needmorehumans.control.display.SkyObject;
import com.breaktrycatch.needmorehumans.control.display.TallestPointTextField;
import com.breaktrycatch.needmorehumans.control.display.Windmill;
import com.breaktrycatch.needmorehumans.control.display.XBoxControllableSprite;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.sprite.HumanImageCreator;
import com.breaktrycatch.needmorehumans.imageloading.TwitterFollower;
import com.breaktrycatch.needmorehumans.model.BodyVO;
import com.breaktrycatch.needmorehumans.tracing.callback.IThreadedImageAnalysisCallback;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
import com.breaktrycatch.needmorehumans.utils.FileUtils;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.RectUtils;
import com.breaktrycatch.needmorehumans.utils.twitter.TwitterTowerMonitor;
import com.esotericsoftware.controller.device.Axis;

public class GameView extends AbstractView
{
	private static final long serialVersionUID = 1L;
	private PhysicsControl _physControl;
	private ParallaxBackground _background;
	private DisplayObject _zoomContainer;
	private Simple2DCamera _camera;
	private TwitterTowerMonitor _twitterMonitor;
	private HeightMarker _heightMarker;
	private TallestPointTextField _tallestPoint;

	private ArrayList<XBoxControllableSprite> _sprites;
	private XBoxControllableSprite _activeSprite;
	public static  int HEIGHT_DIVISOR  = 180;

	Rectangle _activeSpriteRect;
	Rectangle _checkSpriteRect;
	boolean _validplacement;
	private MonkeySpawner _deliveryMonkey;
	private Vec2D _cameraVelocity;

	private final int MAX_CAMERA_VEL = 30;
	private Timer _timer;

	private TwitterFollower _follower;

	public GameView()
	{
		PApplet.println("DEBUG MODE? " + ConfigTools.getBoolean("general", "debugMode"));

		// if (!ConfigTools.getBoolean("general", "debugMode"))
		// {
		LogRepository.getInstance().getJonsLogger().setLevel(Level.ERROR);
		LogRepository.getInstance().getMikesLogger().setLevel(Level.ERROR);
		LogRepository.getInstance().getPaulsLogger().setLevel(Level.ERROR);
		// }
	}

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);

		if (!ConfigTools.getBoolean("general", "debugMode"))
		{
			app.noCursor();
		}

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

		createInputListeners();

		_twitterMonitor = new TwitterTowerMonitor(app);

		scheduleTask();
	}

	private void scheduleTask()
	{
		_timer = new Timer();
		_timer.schedule(new TimerTask()
		{
			@Override
			public void run()
			{
				PApplet.println("Run");
				fetchTwitterImage();
			}
		}, ConfigTools.getInt("general", "tweetCheckInterval"));
	}

	private void fetchTwitterImage()
	{
		PApplet.println("Fetching.... " + _follower);
		if(_follower != null)
		{
		
//			ArrayList<PImage> list = new ArrayList<PImage>();
//			
//			HumanImageCreator creator = new HumanImageCreator(getApp());
//			PImage debug = creator.create(getApp().loadImage("../data/world/SNC00153_bigger.jpg"));
//			
//
//			ImageFrame debugFrame = new ImageFrame(getApp(), debug);
//			add(debugFrame);
//			
//			
//			list.add(debug);
//			beginPlacement(list);
//			scheduleTask();
			
			scheduleTask();
			return;
			
		
		}
		_follower = new TwitterFollower(new ISimpleCallback()
		{

			@Override
			public void execute()
			{
				PApplet.println("GOT!");
				ArrayList<PImage> list = new ArrayList<PImage>();
				
				HumanImageCreator creator = new HumanImageCreator(getApp());
				PImage create = creator.create(_follower.getImage());

				list.add(create);
				
				beginPlacement(list);
				scheduleTask();
			}
		}, getApp());
		_follower.follow();
	}

	private void createClouds()
	{
		int numClouds = 6;
		PApplet app = getApp();
		HashMap<String, PImage> cloudTable = new HashMap<String, PImage>();
		Rectangle cloudBounds = new Rectangle((int) (-_physControl.width), 0, (int) (_physControl.width * 2.5), (int) _physControl.height);
		for (int i = 0; i < 40; i++)
		{
			int cloudType = (int) (Math.floor(Math.random() * numClouds)) + 1;
			String filename = "../data/world/cloud" + cloudType + ".png";
			if (!cloudTable.containsKey(filename))
			{
				cloudTable.put(filename, app.loadImage(filename));
			}

			SkyObject cloud = new SkyObject(app, cloudBounds);
			cloud.addFrame(cloudTable.get(filename));
			cloud.setSpritePosition(cloudBounds.x + (int) (Math.random() * cloudBounds.width - cloud.width), (int) (cloudBounds.height - (Math.random() * 3000) - 400));
			cloud.setVelocity(((float) (Math.random() / 2) + .5f), 0);
			_background.addLayer(cloud, .2f);
		}
	}

	private void createPlanes()
	{
		Rectangle cloudBounds = new Rectangle((int) (-_physControl.width), 0, (int) (_physControl.width * 2.5), (int) _physControl.height);
		PImage plane1 = getApp().loadImage("../data/world/plane1.png");
		PImage plane2 = getApp().loadImage("../data/world/plane2.png");
		for (int i = 0; i < 5; i++)
		{
			SkyObject plane = new SkyObject(getApp(), cloudBounds);
			plane.addFrame(plane1);
			plane.addFrame(plane2);
			plane.setSpritePosition(cloudBounds.x + (int) (Math.random() * cloudBounds.width - plane.width), (int) (cloudBounds.height - (Math.random() * 2000) - 3000));
			plane.setVelocity(((float) (-Math.random() * 3) + .5f) - 1, 0);
			_background.addLayer(plane, .2f);
		}
	}

	private void createEnvironment()
	{
		// creates the environment
		PApplet app = getApp();
		_background = new ParallaxBackground(app, _physControl.width * 3.5f, _physControl.height);
		DisplayObject tier1 = _background.addHorizontalTilingLayer(app.loadImage("../data/world/tier1.jpg"), .05f);
		DisplayObject tier2 = _background.addHorizontalTilingLayer(app.loadImage("../data/world/tier2.jpg"), .05f);
		DisplayObject tier3 = _background.addHorizontalTilingLayer(app.loadImage("../data/world/tier3.jpg"), .05f);
		DisplayObject tier4 = _background.addHorizontalTilingLayer(app.loadImage("../data/world/tier4.jpg"), .05f);
		DisplayObject tier5 = _background.addHorizontalTilingLayer(app.loadImage("../data/world/tier5.jpg"), .05f);

		createClouds();
		createPlanes();

		DisplayObject windmill = _background.addLayer(new Windmill(app), .08f);

		Rectangle simBounds = new Rectangle((int) (-_physControl.width), 0, (int) (_physControl.width * 2), (int) _physControl.height);
		SkyObject backgroundMonkey = new SkyObject(getApp(), simBounds);
		backgroundMonkey.addFrame(app.loadImage("../data/world/ape-background.png"));
		backgroundMonkey.setVelocity(1, 0);
		backgroundMonkey.x = (int) (Math.random() * simBounds.width);
		_background.addLayer(backgroundMonkey, .15f);

		DisplayObject cityBack = _background.addHorizontalTilingLayer(app.loadImage("../data/world/amsterdam-buildings-back.png"), .1f);
		DisplayObject cityFront = _background.addHorizontalTilingLayer(app.loadImage("../data/world/amsterdam-buildings-front.png"), .2f);
		DisplayObject trees = _background.addHorizontalTilingLayer(app.loadImage("../data/world/far-grass.png"), .8f);
		DisplayObject ground = _background.addHorizontalTilingLayer(app.loadImage("../data/world/ground.png"), 1);

		ground.y = _physControl.height - 7; // 7 is half the thickness of the
		// physics ground plane
		windmill.y = ground.y - windmill.height - 70;
		cityFront.y = ground.y - cityFront.height - 60;
		cityBack.y = ground.y - cityBack.height;
		trees.y = ground.y - trees.height;
		tier1.y = ground.y - tier1.height;
		tier2.y = tier1.y - tier2.height;
		tier3.y = tier2.y - tier3.height;
		tier4.y = tier3.y - tier4.height;
		tier5.y = tier4.y - tier5.height;
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
		_tallestPoint.x = app.width - 175;
		_tallestPoint.y = 30;
		add(_tallestPoint);

		ShadowTextField followUs = new ShadowTextField(app);
		followUs.setFont(app.loadFont("../data/fonts/AnonimRound-48.vlw"));
		followUs.setText("Follow us on Twitter @NeedMoreHumans");
		followUs.y = 30;
		followUs.x = 3;
		add(followUs);

		ShadowTextField tweetWith = new ShadowTextField(app);
		tweetWith.setFont(app.loadFont("../data/fonts/AnonimRound-48.vlw"));
		tweetWith.setText("Tweet with #FITC to add yourself!");
		tweetWith.y = 63;
		tweetWith.x = 3;
		add(tweetWith);
	}

	private void createPhysicsControl()
	{
		PApplet app = getApp();
		_physControl = new PhysicsControl(app);
		_physControl.width = 4000;
		_physControl.height = 10000;
		_physControl.init();
	}

	private void createCamera()
	{
		PApplet app = getApp();
		_camera = new Simple2DCamera(app, new Rectangle(0, 0, app.width, app.height), new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
		_camera.lookAt(_physControl.width / 2, 0);
		_camera.lookAt(_physControl.width / 2, _physControl.height, 5f);
	}

	private void onMoveCamera()
	{
		if (_activeSprite == null && !_camera.isTweening())
		{
			_camera.lookAt(_camera.getCameraX() + _cameraVelocity.x, _camera.getCameraY() + _cameraVelocity.y);
		}
	}

	private void createInputListeners()
	{
		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

		_cameraVelocity = new Vec2D();
		controllerManager.registerAxis(Axis.rightStickX, new IFloatCallback()
		{

			public void execute(float value)
			{
				_cameraVelocity.x += value * 3;
				_cameraVelocity.x = MathUtils.clamp(_cameraVelocity.x, -MAX_CAMERA_VEL, MAX_CAMERA_VEL);
			}
		});
		controllerManager.registerAxis(Axis.rightStickY, new IFloatCallback()
		{
			public void execute(float value)
			{
				_cameraVelocity.y -= value * 3;
				_cameraVelocity.y = MathUtils.clamp(_cameraVelocity.y, -MAX_CAMERA_VEL, MAX_CAMERA_VEL);
			}
		});

		keyboardManager.registerKeyOnce('q', new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				HumanImageCreator creator = new HumanImageCreator(getApp());
				PImage create = creator.create(getApp().loadImage("../data/world/SNC00153_bigger.jpg"));

				ArrayList<PImage> list = new ArrayList<PImage>();
				list.add(create);
				beginPlacement(list);
			}
		});

		if (ConfigTools.getBoolean("general", "debugMode"))
		{

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

	private void beginPlacement(final ArrayList<PImage> images)
	{
		final PImage img = images.get(0);

		// save the file out for later.
		FileUtils.saveSourceImage(img);

		_activeSprite = createPlacementSprite(images);
		if(_activeSprite == null)
		{
			return;
		}

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

					errorCameraFlash();

					_activeSprite = null;
				} else
				{
					showCameraFlash();

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
		final int dist = 1000;
		final Rectangle towerRect = (Rectangle) _physControl.getTowerRect().clone();

		if (towerRect.width == 0 || towerRect.height == 0)
		{
			towerRect.x = (int) _physControl.width / 2;
		}
		_deliveryMonkey.x = towerRect.x + towerRect.width + dist;
		_deliveryMonkey.y = _activeSprite.y - _deliveryMonkey.height / 2;
		_deliveryMonkey.visible = true;
		_deliveryMonkey.slideTo((int) _activeSprite.x - 200, (int) _deliveryMonkey.y, .5f, null, new ISimpleCallback()
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
						_activeSprite.rotateTo((float) Math.PI * 2, .5f, Shaper.COSINE);
						_activeSprite.scaleTo(1, 1, .5f, Shaper.COSINE);

						_placementCallback.execute();

						_deliveryMonkey.slideTo(towerRect.x + towerRect.width + dist, (int) _deliveryMonkey.y, .5f, null, new ISimpleCallback()
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
		Rectangle towerRect = _physControl.getTowerRect();
		if(towerRect == null)
		{
			return null;
		}
		
		final XBoxControllableSprite sprite = new XBoxControllableSprite(getApp());
		sprite.setRotateAroundCenter(true);
		sprite.addFrames(images);
		sprite.setFPS(3);

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

		// hide it off screen if there is no one there.
		_heightMarker.y = (r.y == 0) ? (_physControl.height + 1000) : (r.y);
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

					// What is this!?!?
					i = _sprites.size();
				}
			}
			if (_validplacement)
			{
				_activeSprite.regularTint();
			}
		}

		onMoveCamera();
		_cameraVelocity.scaleSelf(.9f);

		if(_follower != null)
		{
			if(_follower.update())
			{
				_follower = null;
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
