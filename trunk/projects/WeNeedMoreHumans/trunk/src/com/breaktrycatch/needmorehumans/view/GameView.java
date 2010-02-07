package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;
import java.io.File;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;

import com.breaktrycatch.lib.component.KeyboardManager;
import com.breaktrycatch.lib.component.ManagerLocator;
import com.breaktrycatch.lib.component.XBoxControllerManager;
import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.control.camera.Simple2DCamera;
import com.breaktrycatch.needmorehumans.control.display.Countdown;
import com.breaktrycatch.needmorehumans.control.display.ParallaxBackground;
import com.breaktrycatch.needmorehumans.control.display.SkyObject;
import com.breaktrycatch.needmorehumans.control.display.Windmill;
import com.breaktrycatch.needmorehumans.control.display.XBoxControllableSprite;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureControl;
import com.breaktrycatch.needmorehumans.control.webcam.CaptureValidator;
import com.breaktrycatch.needmorehumans.control.webcam.callback.ICaptureCallback;
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
	private String[] _spriteLookup = new String[]
	{ "../data/tracing/RealPerson_1.png", "../data/tracing/RealPerson_3.png", "../data/tracing/RealPerson_4.png", "../data/tracing/RealPerson_5.png" };

	private String _debugFilename = _spriteLookup[0];
	
	
	//SAVING METHODS
	private File __towerDirectory;
	private File __towerPublishDirectory;
	private File __towerSourceDirectory;
	private int __towerNumber;
	private int __publishNumber;
	private int __sourceNumber;
	
	private ArrayList<XBoxControllableSprite> sprites;

	public GameView()
	{
		
	}
	
	private String leadingSpaces(int _int) {
		String str;
		if (_int < 10) {
			str = "0000" + _int;
		}
		else if (_int < 100) {
			str = "000" + _int;
		}
		else if (_int < 1000) {
			str = "00" + _int;
		}
		else if (_int < 10000) {
			str = "0" + _int;
		}
		else {
			str = "" + _int;
		}
		return str;
	}
	
	private void constructTowerPaths() {
		
		File tempFile = new File("../");
		String path = tempFile.getAbsolutePath() + tempFile.separator + "data" + tempFile.separator + "towers";
		
		__towerDirectory = new File(path);
		__towerNumber = __towerDirectory.list().length;
		LogRepository.getInstance().getJonsLogger().info("IS DIRECTORY " + __towerDirectory.isDirectory() + " length " + __towerNumber);
		
		String strTowerNumber = leadingSpaces(__towerNumber);
		
		
		File newTowerDirectory = new File(path + tempFile.separator + "tower_" + strTowerNumber);
		
		if (!newTowerDirectory.exists()) {
			newTowerDirectory.mkdir();
		}
		else {
			LogRepository.getInstance().getJonsLogger().info("FILE " + newTowerDirectory.getPath() + " already exists!");
		}
		
		__towerPublishDirectory = new File(newTowerDirectory.getPath() + tempFile.separator + "publish");
		if (!__towerPublishDirectory.exists()) {
			__towerPublishDirectory.mkdir();
		}
		else {
			LogRepository.getInstance().getJonsLogger().info("FILE " + __towerPublishDirectory.getPath() + " already exists!");
		}
		
		__towerSourceDirectory = new File(newTowerDirectory.getPath() + tempFile.separator + "source");
		if (!__towerSourceDirectory.exists()) {
			__towerSourceDirectory.mkdir();
		}
		else {
			LogRepository.getInstance().getJonsLogger().info("FILE " + __towerSourceDirectory.getPath() + " already exists!");
		}
	
	}
	
	private void saveSourceImage(final PImage img) {
		
		__sourceNumber = __towerSourceDirectory.list().length;
		String strSourceNumber = leadingSpaces(__sourceNumber);
		
		String path = __towerSourceDirectory.getAbsolutePath() + "/source_" + strSourceNumber + ".png";
		img.save(path);
	}
	
	private void saveTowerImage() {
		LogRepository.getInstance().getJonsLogger().info("SAVING TOWER IMAGE");
	
		__publishNumber = __towerPublishDirectory.list().length;
		String strPublishNumber = leadingSpaces(__publishNumber);
		
		String path = __towerPublishDirectory.getAbsolutePath() + "/publish_" + strPublishNumber + ".png";
		
		XBoxControllableSprite s = sprites.get(0);
		Rectangle screenBounds = s.getScreenBounds();
		float minX = screenBounds.x;
		float minY = screenBounds.y;
		float maxX = screenBounds.x + screenBounds.width;
		float maxY = screenBounds.y + screenBounds.height;
		
		
		for (int i = 0; i < sprites.size(); i++) {
			s = sprites.get(i);
			screenBounds = s.getScreenBounds();
			
			if (screenBounds.x < minX) {
				minX = screenBounds.x;
			}
			if (screenBounds.y < minY) {
				minY = screenBounds.y;
			}
			if ((screenBounds.x + screenBounds.width) > maxX) {
				maxX = screenBounds.x + screenBounds.width;
			}
			if ((screenBounds.y + screenBounds.height) > maxY) {
				maxY = screenBounds.y + screenBounds.height;
			}
			
		}
		
		Rectangle imageBounds = new Rectangle();
		imageBounds.x = (int) minX;
		imageBounds.y = (int) minY;
		imageBounds.width = (int) Math.abs(maxX - minX);
		imageBounds.height = (int) Math.abs(maxY - minY);
		LogRepository.getInstance().getJonsLogger().info("IMAGE BOUNDS " + imageBounds);
		
		PApplet app = getApp();
		PGraphics drawBuffer = app.createGraphics((int)(minX + maxX),(int)(minY + maxY), PApplet.JAVA2D);
		drawBuffer.beginCamera();
		drawBuffer.beginDraw();
		drawBuffer.noFill();
		
		for (int i = 0; i < sprites.size(); i++) {
			s = sprites.get(i);
			s.enableExternalRenderTarget(drawBuffer, 0, 0);
			s.preDraw();
			s.draw();
			s.postDraw();
			s.disableExternalRenderTarget();
		}
		drawBuffer.endDraw();
		drawBuffer.endCamera();
		drawBuffer.save(path);
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
			cloud.setVelocity(-((float)(Math.random() / 2) + .5f), 0);
			_background.addLayer(cloud, .2f);
		}

		_zoomContainer.add(_background);
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

	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);
		
		
		sprites = new ArrayList<XBoxControllableSprite>();
		constructTowerPaths();

		_zoomContainer = new DisplayObject(app);
		add(_zoomContainer);

		createPhysicsControl();
		createEnvironment();

		_camera = new Simple2DCamera(app, new Rectangle(0, 0, app.width, app.height), new Rectangle(0, 0, (int) _physControl.width, (int) _physControl.height));
		_camera.lookAt(_physControl.width / 2, _physControl.height);

		// add after we create the environment!
		_zoomContainer.add(_physControl);

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
					_countdown = new Countdown(getApp(), _countdownCallback);
					_countdown.x = _physControl.width / 2 - _countdown.width / 2;
					_countdown.y = _physControl.height - getApp().height / 2;
					_countdown.setCountFrom(3);
					_countdown.start();
					_physControl.add(_countdown);
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
				saveTowerImage();
			}
		});
	}

	// once the countdown is complete we start capturing the image.
	private ISimpleCallback _countdownCallback = new ISimpleCallback()
	{
		public void execute()
		{
			LogRepository.getInstance().getPaulsLogger().info("Countdown complete, processing image.");

			_physControl.remove(_countdown);
			_countdown = null;

			_capControl.beginCapture(1, _captureCallback);
		}
	};

	// once the capture is complete we place it in to the sim.
	private ICaptureCallback _captureCallback = new ICaptureCallback()
	{
		@Override
		public void execute(ArrayList<PImage> images)
		{
			if (images != null)
			{
				ArrayList<PImage> culledImages = CaptureValidator.validateList(images);
				beginPlacement(culledImages);
			} else
			{
				ArrayList<PImage> debugImage = new ArrayList<PImage>();
				debugImage.add(getApp().loadImage(_debugFilename));
				beginPlacement(debugImage);
			}
		}
	};

	private void beginPlacement(final ArrayList<PImage> images)
	{
		if (images.size() == 0)
		{
			// TODO: Inform user that no image was captured.
			LogRepository.getInstance().getPaulsLogger().warn("No images returned from capture control!");
			return;
		}

		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);
		final PImage img = images.get(0);
		
		saveSourceImage(img);

		

		final XBoxControllableSprite sprite = new XBoxControllableSprite(getApp());
		sprite.setRotateAroundCenter(true);
		sprite.addFrames(images);
		sprite.setFPS(3);
		sprite.x = _physControl.width / 2 - sprite.width / 2;
		sprite.y = _physControl.height - getApp().height / 2 - sprite.height / 2;

		Rectangle imageBounds = new Rectangle(0, 0, (int) (_physControl.width - sprite.width), (int) (_physControl.height - sprite.height));
		sprite.setScrollBounds(imageBounds);
		
		sprites.add(sprite);

		sprite.enableController(false);
		Rectangle lookAtBounds = RectUtils.expand(sprite.getBounds(), 700);
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
				
				//TODO: Zoom out to see the whole tower...
				_camera.lookAt(new Rectangle((int)_physControl.width / 2 - 600, (int)_physControl.height, 1200,1200), 1f);
				
				_physControl.addHuman(sprite);
				LogRepository.getInstance().getPaulsLogger().info("Placed Sprite in PhysicsControl.");
				keyboardManager.unregisterKeyOnce('p', this);
				controllerManager.registerButtonOnce(Button.a, this);

				keyboardManager.unregisterKeyOnce('r', this);
				controllerManager.registerButtonOnce(Button.b, this);
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

	@Override
	public void draw()
	{
		// transforms the root container to the camera's viewport.
		_camera.update();
		_camera.setTransform(_zoomContainer);
		super.draw();
	}
}
