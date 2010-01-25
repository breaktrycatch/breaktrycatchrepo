package com.breaktrycatch.needmorehumans.control.sprite;

import com.breaktrycatch.lib.display.DisplayObject;

public class SpriteFactory extends Sprite{

	private static SpriteFactory _instance;
	
	private SpriteFactory() {
		// TODO Auto-generated constructor stub
		super(null);
	}
	
	public static SpriteFactory getInstance()
	{
		if(_instance == null)
		{
			_instance = new SpriteFactory();
		}
		
		return _instance;
	}
	
	public Sprite MakeSprite(SpriteType type, DisplayObject display)
	{
		Sprite sprite;

		switch(type)
		{
			case POLYHUMAN_SPRITE:
				sprite = new PolyHumanSprite(display);
				break;
				
			default:
				throw new Error("Sprite Type Not Supported: " + type.toString());
		}
		
		
		
		return sprite;
	}

}
