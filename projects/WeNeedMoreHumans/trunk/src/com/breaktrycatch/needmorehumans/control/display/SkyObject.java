package com.breaktrycatch.needmorehumans.control.display;

import java.awt.Rectangle;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.geom.Vec2D;

import com.breaktrycatch.lib.display.Sprite;

public class SkyObject extends Sprite
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Rectangle _bounds;
	private Vec2D _velocity;
	private Sprite _internalSprite;

	public SkyObject(PApplet app, Rectangle bounds)
	{
		super(app);
		_bounds = bounds;
		_velocity = new Vec2D(-1, 0);
		_internalSprite = new Sprite(app);
		add(_internalSprite);
	}

	@Override
	public void addFrame(PImage img)
	{
		if(img.width > width)
		{
			width = img.width;
		}
		if(img.height > height)
		{
			height = img.height;
		}
		_internalSprite.addFrame(img);
	}

	@Override
	public void addFrames(ArrayList<PImage> images)
	{
		throw new UnsupportedOperationException("Not Implemented!");
	}

	public void setVelocity(float velX, float velY)
	{
		_velocity.x = velX;
		_velocity.y = velY;
	}

	public Vec2D getVelocity()
	{
		return _velocity;
	}

	@Override
	public void draw()
	{
		_internalSprite.x += _velocity.x;
		_internalSprite.y += _velocity.y;

		checkBounds();

		super.draw();
	}

	private void checkBounds()
	{
		if (_internalSprite.x + width < _bounds.x)
		{
			_internalSprite.x = _bounds.x + _bounds.width;
		} else if (x > _bounds.x + _bounds.width)
		{
			_internalSprite.x = _bounds.x;
		}

		if (_internalSprite.y + height < _bounds.y)
		{
			_internalSprite.y = _bounds.y + _bounds.height;
		} else if (_internalSprite.y > _bounds.y + _bounds.height)
		{
			_internalSprite.y = _bounds.y;
		}
	}

	public void setSpritePosition(int x, int y)
	{
		_internalSprite.x = x;
		_internalSprite.y = y;
	}
}
