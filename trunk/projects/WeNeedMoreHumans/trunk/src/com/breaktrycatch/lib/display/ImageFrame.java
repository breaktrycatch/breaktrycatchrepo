package com.breaktrycatch.lib.display;

import com.breaktrycatch.needmorehumans.utils.LogRepository;

import processing.core.PApplet;
import processing.core.PImage;

public class ImageFrame extends DisplayObject
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected PImage _img;

	public ImageFrame(PApplet app, PImage img)
	{
		super(app);
		_img = img;
		width = _img.width;
		height = _img.height;
	}

	public ImageFrame(PApplet app)
	{
		super(app);
	}

	@Override
	public void draw()
	{
		super.draw();

		if (_img != null)
		{
			
			_drawTarget.image(_img, 0, 0);
			
//			if (externalRenderTarget != null) {
//				LogRepository.getInstance().getJonsLogger().info("Drawing to external");
//				//this.x -= externalRenderTargetOffsetX;
//				//this.y -= externalRenderTargetOffsetY;
//				externalRenderTarget.image(_img,0,0);
//				//this.x += externalRenderTargetOffsetX;
//				//this.y += externalRenderTargetOffsetY;
//			}
		}
	}

	public PImage getDisplay()
	{
		return _img;
	}
}
