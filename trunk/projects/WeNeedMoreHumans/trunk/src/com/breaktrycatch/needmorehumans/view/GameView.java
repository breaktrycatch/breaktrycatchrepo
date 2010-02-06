package com.breaktrycatch.needmorehumans.view;

import java.awt.Rectangle;
import java.awt.geom.Point2D.Float;
import java.io.File;
import java.util.ArrayList;

import org.jbox2d.common.MathUtils;

import processing.core.PApplet;
import processing.core.PGraphics;
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
	private static final long serialVersionUID = 1L;
	private CaptureControl _capControl;
	private PhysicsControl _physControl;
	protected Countdown _countdown;
	private ParallaxBackground _background;
	private DisplayObject _zoomContainer;
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
		
		File tempFile = new File("");
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
		DisplayObject background = _background.addTilingLayer(app.loadImage("../data/world/large-background.png"), 0);
		DisplayObject trees = _background.addHorizontalTilingLayer(app.loadImage("../data/world/trees.png"), .5f);
		DisplayObject windmill = _background.addLayer(new Windmill(app), .7f);
		DisplayObject ground = _background.addHorizontalTilingLayer(app.loadImage("../data/world/ground.png"), 1);
		background.y = -app.height;
		ground.y = _physControl.height - 7; // 7 is half the thickness of the
		// physics ground plane
		windmill.y = ground.y - windmill.height + 20;
		trees.y = ground.y - trees.height;

		_zoomContainer.add(_background);
	}

	private void createPhysicsControl()
	{
		PApplet app = getApp();
		_physControl = new PhysicsControl(app);
		_physControl.width = app.width * 2;
		_physControl.height = app.height * 6;

		_physControl.x = -_physControl.width / 2 + app.width / 2;
		_physControl.y = -_physControl.height + app.height - 25; // (40 is the
		// height of
		// the
		// ground
		// image)

		Rectangle rect = new Rectangle((int) -_physControl.width / 2, (int) _physControl.y, (int) _physControl.width - app.width, (int) _physControl.height);
		_physControl.setScrollBounds(rect);
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

		keyboardManager.registerKeyOnce('7', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[0];
				_countdownCallback.execute();
			}
		});

		keyboardManager.registerKeyOnce('8', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[1];
				_countdownCallback.execute();
			}
		});

		keyboardManager.registerKeyOnce('9', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[2];
				_countdownCallback.execute();
			}
		});

		keyboardManager.registerKeyOnce('0', new ISimpleCallback()
		{
			public void execute()
			{
				_debugFilename = _spriteLookup[3];
				_countdownCallback.execute();
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

	private ISimpleCallback _countdownCallback = new ISimpleCallback()
	{
		public void execute()
		{
			LogRepository.getInstance().getPaulsLogger().info("Countdown complete, processing image.");
			final PImage img = _capControl.getProcessedImage();
			if (img != null)
			{
				if (img.width > 0 && img.height > 0)
				{
					beginPlacement(img);
				} else
				{
					// TODO: Trap images that are > 60% opaque. They
					// are too big and we had a lighting glitch.
					// TODO: Trap images that are < 10% opaque. They
					// don't have a person in it!
					// TODO: Inform user that no image was captured.

					LogRepository.getInstance().getPaulsLogger().warn("Image was no good! Discarding.");
				}
			} else
			{
				beginPlacement(getApp().loadImage(_debugFilename));
			}

			_physControl.remove(_countdown);
			_countdown = null;

		}
	};

	private void beginPlacement(final PImage img)
	{
		final XBoxControllerManager controllerManager = (XBoxControllerManager) ManagerLocator.getManager(XBoxControllerManager.class);
		final KeyboardManager keyboardManager = (KeyboardManager) ManagerLocator.getManager(KeyboardManager.class);
		// final PImage img = getApp().loadImage(_debugFilename);
		
		saveSourceImage(img);

		

		final XBoxControllableSprite sprite = new XBoxControllableSprite(getApp());
		sprite.setRotateAroundCenter(true);
		sprite.addFrame(img);
		sprite.x = _physControl.width / 2 - sprite.width / 2;
		sprite.y = _physControl.height - getApp().height / 2 - sprite.height / 2;

		Rectangle imageBounds = new Rectangle(0, 0, (int) (_physControl.width - sprite.width), (int) (_physControl.height - sprite.height));
		sprite.setScrollBounds(imageBounds);
		
		sprites.add(sprite);

		// on update check if our sprite is near the edges and scroll the
		// view port so we never lose it.
		sprite.setUpdatedCallback(new ISimpleCallback()
		{
			public void execute()
			{
				Float localToGlobal = sprite.localToGlobal();
				float margin = 5;
				PApplet app = getApp();
				if (localToGlobal.x < margin)
				{
					_physControl.x += margin - localToGlobal.x;
				} else if (localToGlobal.x > app.width - img.width - margin)
				{
					_physControl.x -= (localToGlobal.x - app.width + img.width) + margin;
				}

				if (localToGlobal.y < margin)
				{
					float jumpAmt = (margin - localToGlobal.y);
					_physControl.y += margin - localToGlobal.y;
					float scaleAmt = (jumpAmt / _physControl.height) * 3;
					_zoomContainer.scaleX -= scaleAmt;
					_zoomContainer.scaleY -= scaleAmt;

				} else if (localToGlobal.y > app.height - img.height - margin)
				{
					float jumpAmt = (localToGlobal.y - app.height + img.height) + margin;
					_physControl.y -= (localToGlobal.y - app.height + img.height) + margin;
					float scaleAmt = (jumpAmt / _physControl.height) * 3;
					_zoomContainer.scaleX += scaleAmt;
					_zoomContainer.scaleY += scaleAmt;
				}

				_zoomContainer.scaleX = MathUtils.clamp(_zoomContainer.scaleX, .37f, 1f);
				_zoomContainer.scaleY = MathUtils.clamp(_zoomContainer.scaleY, .37f, 1f);

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
	}

	@Override
	public void draw()
	{
		_background.x = _physControl.x;
		_background.y = _physControl.y;

		super.draw();
	}
}
