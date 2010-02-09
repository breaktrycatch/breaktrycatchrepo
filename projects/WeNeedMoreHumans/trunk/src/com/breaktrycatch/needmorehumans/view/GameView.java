package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;
import java.util.ArrayList;

import megamu.shapetween.Shaper;
import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.config.control.ColorController;
import com.breaktrycatch.needmorehumans.control.camera.Simple2DCamera;
import com.breaktrycatch.needmorehumans.control.display.Countdown;
import com.breaktrycatch.needmorehumans.control.display.HeightMarker;
import com.breaktrycatch.needmorehumans.control.display.ParallaxBackground;
import com.breaktrycatch.needmorehumans.control.display.SkyObject;
import com.breaktrycatch.needmorehumans.control.display.TallestPointTextField;
import com.breaktrycatch.needmorehumans.control.display.Windmill;
import com.breaktrycatch.needmorehumans.control.display.XBoxControllableSprite;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureValidator;
import com.breaktrycatch.needmorehumans.control.webcam.callback.ICaptureCallback;
import com.breaktrycatch.needmorehumans.utils.FileUtils;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.RectUtils;
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
	private HeightMarker _heightMarker;
	private TallestPointTextField _tallestPoint;
	private boolean _isPlacing = false;
	private String[] _spriteLookup = new String[]
	{ "../data/tracing/RealPerson_1.png", "../data/tracing/RealPerson_3.png", "../data/tracing/RealPerson_4.png", "../data/tracing/RealPerson_5.png" };

	private String _debugFilename = _spriteLookup[0];

	private ArrayList<XBoxControllableSprite> _sprites;

	public GameView()
	{
	}

	private void createEnvironment()
	{
		// creates the environment
		PApplet app = getApp();
		_background = new ParallaxBackground(app, _physControl.width * 3, _physControl.height);
		DisplayObject background = _background.addTilingLayer(app.loadImage("../data/world/large-background.png"), .05f);
		DisplayObject city = _background.addHorizontalTilingLayer(app.loadImage("../data/world/city.png"), .2f);
		DisplayObject trees = _background.addHorizontalTilingLayer(app.loadImage("../data/world/trees.png"), .5f);
		DisplayObject windmill = _background.addLayer(new Windmill(app), .7f);
		DisplayObject ground = _background.addHorizontalTilingLayer(app.loadImage("../data/world/ground.png"), 1);
		background.y = -app.height;
		ground.y = _physControl.height - 7; // 7 is half the thickness of the
		// physics ground plane
		windmill.y = ground.y - windmill.height + 20;
		city.y = ground.y - city.height;
		trees.y = ground.y - trees.height;

		for (int i = 0; i < 20; i++)
		{
			int cloudType = (int) (Math.floor(Math.random() * 2)) + 1;
			SkyObject cloud = new SkyObject(app, new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
			cloud.addFrame(app.loadImage("../data/world/cloud" + cloudType + ".png"));
			cloud.setSpritePosition((int) (Math.random() * _physControl.width), (int) (Math.random() * (_physControl.height - 400)));
			cloud.setVelocity(-((float) (Math.random() / 2) + .5f), 0);
			_background.addLayer(cloud, .2f);
		}

		_zoomContainer.add(_background);

		_heightMarker = new HeightMarker(app);
		_heightMarker.setBounds(new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
		_zoomContainer.add(_heightMarker);

		_tallestPoint = new TallestPointTextField(app);
		_tallestPoint.x = app.width - 250;
		_tallestPoint.y = 25;
		add(_tallestPoint);
	}

	private void createPhysicsControl()
	{
		PApplet app = getApp();
		_physControl = new PhysicsControl(app);
		_physControl.width = app.width * 2;
		_physControl.height = app.height * 6;
		_physControl.init();
	}

	private void createCaptureControl()
	{
		PApplet app = getApp();
		_capControl = new CaptureControl(app);
		_capControl.x = (app.width / 2);
		_capControl.width = (app.width / 2);
		_capControl.height = (app.height);
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

		createCaptureControl();

		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);

		final ISimpleCallback countdownCallback = new ISimpleCallback()
		{
			public void execute()
			{
				// don't start a count down if one is in progress.
				if (_countdown == null && !_isPlacing)
				{
					_countdown = new Countdown(getApp(), _countdownCallback);
					_countdown.x = getApp().width / 2;
					_countdown.y = getApp().height / 2;
					_countdown.setCountFrom(3);
					_countdown.start();
					add(_countdown);
				}
				LogRepository.getInstance().getPaulsLogger().info("Beginning count down");
			};
		};

		// A button triggers the start of the count down...
		controllerManager.registerButtonOnce(Button.b, countdownCallback);
		keyboardManager.registerKeyOnce('c', countdownCallback);

		keyboardManager.registerKeyOnce('7', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[0];
				_captureCallback.execute(null);
			}
		});

		keyboardManager.registerKeyOnce('8', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[1];
				_captureCallback.execute(null);
			}
		});

		keyboardManager.registerKeyOnce('9', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[2];
				_captureCallback.execute(null);
			}
		});

		keyboardManager.registerKeyOnce('0', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[3];
				_captureCallback.execute(null);
			}
		});

		keyboardManager.registerKeyOnce('-', new ISimpleCallback()
		{
			public void execute()
			{
				_physControl.addDebugSmileBoxes();
			}
		});
		keyboardManager.registerKeyOnce('j', new ISimpleCallback()
		{
			public void execute()
			{
				FileUtils.saveImage(getApp(), _sprites);
			}
		});
	}

	// once the count down is complete we start capturing the image.
	private ISimpleCallback _countdownCallback = new ISimpleCallback()
	{
		public void execute()
		{
			LogRepository.getInstance().getPaulsLogger().info("Countdown complete, processing image.");

			remove(_countdown);
			_countdown = null;
			_capControl.beginCapture(1, _captureCallback);
		}
	};

	// once the capture is complete we place it in to the sim.
	private final ICaptureCallback _captureCallback = new ICaptureCallback()
	{
		@Override
		public void execute(ArrayList<PImage> images)
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
						showCameraFlash(0xffff0000);
					}
				} else
				{
					ArrayList<PImage> debugImage = new ArrayList<PImage>();
					debugImage.add(getApp().loadImage(_debugFilename));
					beginPlacement(debugImage);

					showCameraFlash();
				}
			}
		}
	};

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
		color.alphaTo(0, .5f, null, new ISimpleCallback()
		{
			public void execute()
			{
				remove(color);
			}
		});
	}

	private void beginPlacement(final ArrayList<PImage> images)
	{
		_isPlacing = true;

		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);
		final PImage img = images.get(0);

		// save the file out for later.
		FileUtils.saveSourceImage(img);

		final XBoxControllableSprite sprite = new XBoxControllableSprite(getApp());
		sprite.setRotateAroundCenter(true);
		sprite.addFrames(images);
		sprite.setFPS(3);
		sprite.x = _physControl.width / 2 - sprite.width / 2;
		sprite.y = _physControl.height - getApp().height / 2 - sprite.height / 2;

		Rectangle imageBounds = new Rectangle(0, 0, (int) (_physControl.width - sprite.width), (int) (_physControl.height - sprite.height));
		sprite.setScrollBounds(imageBounds);

		_sprites.add(sprite);

		sprite.enableController(false);
		Rectangle lookAtBounds = RectUtils.expand(sprite.getBounds(), 700);

		sprite.scaleX = sprite.scaleY = 0;
		sprite.setScaleAroundCenter(true);
		sprite.scaleTo(1, 1, .5f, Shaper.COSINE);

		_camera.lookAt(lookAtBounds, .5f, new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				sprite.enableController(true);
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

		_physControl.add(sprite);

		// place the human in to the sim
		final ISimpleCallback placementCallback = new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				sprite.enableController(false);

				// TODO: Zoom out to see the whole tower...
				_camera.lookAt(new Rectangle((int) _physControl.width / 2 - 600, (int) _physControl.height, 1200, 1200), 1f);

				_physControl.addHuman(sprite);
				LogRepository.getInstance().getPaulsLogger().info("Placed Sprite in PhysicsControl.");
				keyboardManager.unregisterKeyOnce('p', this);
				controllerManager.registerButtonOnce(Button.a, this);

				keyboardManager.unregisterKeyOnce('r', this);
				controllerManager.registerButtonOnce(Button.b, this);

				_isPlacing = false;
			}
		};

		// remove the human from the sim since its a bad capture.
		final ISimpleCallback removeCallback = new ISimpleCallback()
		{
			@Override
			public void execute()
			{
				sprite.enableController(false);
				_physControl.remove(sprite);
				LogRepository.getInstance().getPaulsLogger().info("Removed Sprite.");

				keyboardManager.unregisterKeyOnce('p', this);
				controllerManager.registerButtonOnce(Button.a, this);

				keyboardManager.unregisterKeyOnce('r', this);
				controllerManager.registerButtonOnce(Button.b, this);
			}
		};

		controllerManager.registerButtonOnce(Button.a, placementCallback);
		keyboardManager.registerKeyOnce('p', placementCallback);

		controllerManager.registerButtonOnce(Button.b, removeCallback);
		keyboardManager.registerKeyOnce('r', removeCallback);

		LogRepository.getInstance().getPaulsLogger().info("Captured image of size: " + img.width + ", " + img.height);
	}

	private ColorController _debugController;

	@Override
	public void draw()
	{
		// if (_debugController == null)
		// {
		// _debugController = new ColorController(getApp());
		// _debugController.setColor(0x33ff00ff);
		// _zoomContainer.add(_debugController);
		// }

		Rectangle r = _physControl.getTowerRect();
		// RectUtils.sizeTo(_debugController, r);

		_heightMarker.y = (r.y == 0) ? (_physControl.height) : (r.y);
		_heightMarker.x = r.x + r.width;
		
		
		PApplet.println("RECT: " + r + " : " + _heightMarker.getDisplayValue());
		
		_tallestPoint.setValue(_heightMarker.getDisplayValue());

		// transforms the root container to the camera's view port.
		_camera.update();
		_camera.setTransform(_zoomContainer);
		super.draw();
	}
}
