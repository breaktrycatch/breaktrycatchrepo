package com.breaktrycatch.needmorehumans.control.physics;

import java.awt.Rectangle;

import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.needmorehumans.model.BodyVO;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;
import com.breaktrycatch.needmorehumans.tracing.ThreadedImageAnalysis;
import com.breaktrycatch.needmorehumans.tracing.callback.IThreadedImageAnalysisCallback;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.PhysicsUtils;

public class PhysicsControl extends DisplayObject
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static PApplet DEBUG_APP;
	private PhysicsWorldWrapper _physWorld;
	private ThreadedImageAnalysis _threadedAnalysis;
	private boolean _isProcessingHuman;
	private ImageFrame _currentSprite;
	private BodyVO _currentBody;
	private boolean _processingComplete;
	private IThreadedImageAnalysisCallback _onCompleteCallback;

	public PhysicsControl(PApplet app)
	{
		super(app);
		DEBUG_APP = app;
	}

	/**
	 * Call after setting width/height
	 */
	public void init()
	{
		_physWorld = new PhysicsWorldWrapper((float) width, (float) height);
		_physWorld.enableDebugDraw(getApp());
		_threadedAnalysis = new ThreadedImageAnalysis(getApp());

		PhysicsShapeDefVO vo = new PhysicsShapeDefVO();
		vo.density = 0.0f;
		vo.friction = 1.0f;
		PhysicsUserDataVO userData = new PhysicsUserDataVO();
		userData.breaksHumanJoints = true;
		
		// bounds[2] is the floor so we don't break joints on contact.
		Body[] bounds = _physWorld.createHollowBox(width / 2.0f, height / 2.0f, width, height, 15.0f, vo);
		bounds[0].setUserData(userData);
		bounds[1].setUserData(userData);
		bounds[3].setUserData(userData);
		
//		addDebugSmileBoxes();
	}

	/**
	 * Starts creating a body in a worker thread. When you're ready to put this
	 * body in to the physics sim, call addCurrentBody().
	 * 
	 * @param sprite
	 */
	public void createBodyFromHuman(ImageFrame sprite, IThreadedImageAnalysisCallback onCompleteCallback)
	{
		_currentSprite = sprite;
		_currentSprite.setRotateAroundCenter(true);

		if (!_isProcessingHuman)
		{
			_onCompleteCallback = onCompleteCallback;
			_isProcessingHuman = true;
			_processingComplete = false;
			_threadedAnalysis.start(sprite);
		}
	}

	public void addCurrentBody()
	{
		if (_currentSprite == null)
		{
			LogRepository.getInstance().getPaulsLogger().warn("addCurrentBody must not be called before createBodyFromHuman()!");
			return;
		}

		// check if we're done with the worker thread. If it has completed
		// already, start creating the human.
		if (_processingComplete)
		{
			if (_currentBody == null)
			{
				PApplet.println("NO EAR FOUND!");
			} else
			{
				createHuman(_currentBody, _currentSprite);
				_currentSprite = null;
				_currentBody = null;
			}
		} else
		{
			// the user has placed the body before the analysis thread has
			// completed. block until we get it and then call ourselves to try
			// and add again.
			_currentBody = _threadedAnalysis.get();
			_processingComplete = true;
			_isProcessingHuman = false;
			
			_onCompleteCallback.execute(_currentBody);
			
			addCurrentBody();
		}
	}

	@Override
	public void draw()
	{
		_physWorld.step();

		if (_isProcessingHuman && _threadedAnalysis.isDone())
		{
			_processingComplete = true;
			_isProcessingHuman = false;
			_currentBody = _threadedAnalysis.get();
			_onCompleteCallback.execute(_currentBody);
		}

		super.draw();
	}

	public void addDebugSmileBoxes()
	{
		float size = 20;
		PImage img = getApp().loadImage("../data/physics/BoxMcSmiles.png");
		// PImage img = getApp().loadImage("../data/tracing/RealPerson_1.png");
		img.loadPixels();

		for (int i = 0; i < 20; i++)
		{
			for (int j = 0; j < 10; j++)
			{
				float x, y;
				x = (i * size) + width / 2 - ((20 / 2) * size);
				y = (j * size) + 310;
				Body rect = _physWorld.createRect(x, y, x + size, y + size, new PhysicsShapeDefVO());
				ImageFrame sprite = new ImageFrame(getApp(), img);
				sprite.setRotateAroundCenter(true);
				add(sprite);
				rect.setUserData(sprite);
			}
		}
	}

	private void createHuman(BodyVO analyzedBody, ImageFrame sprite)
	{
		Body human = _physWorld.createPolyHuman(analyzedBody.polyDefs, new PhysicsShapeDefVO(), sprite.x + sprite.width / 2.0f, sprite.y + sprite.height / 2.0f, -sprite.rotationRad);

		PhysicsUserDataVO userData = new PhysicsUserDataVO();
		userData.display = sprite;
		
		/*
		// Convert all of the extremity points to world space
		Vec2 axisTransform = new Vec2(1, -1);
		Vec2 offset = new Vec2(0.0f, 0.0f);
		for (Vec2 extremity : analyzedBody.extremities)
		{
			PhysicsUtils.genericTransform(extremity, _physWorld.getPhysScale(), offset, axisTransform, true);
		}

		userData.extremities = analyzedBody.extremities;
		*/
	
		userData.isHuman = true;
		human.setUserData(userData);

	}

	@Override
	public void dispose()
	{
		_physWorld.destroy();

		super.dispose();
	}

	public Rectangle getTowerRect()
	{
		return _physWorld.getTowerRect();
	}
}
