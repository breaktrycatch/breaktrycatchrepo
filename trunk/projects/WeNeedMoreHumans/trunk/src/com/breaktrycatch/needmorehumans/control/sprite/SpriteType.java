package com.breaktrycatch.needmorehumans.control.sprite;

public enum SpriteType{
	
	//public static final SpriteType POLYHUMAN_SPRITE = new SpriteType("spriteImage");
	POLYHUMAN_SPRITE("polyHumanSprite");
	
	
	private final String name;
	
	private SpriteType(String name)
	{
		this.name = name;
	}
	
	String value() { return name; }
	
	public String toString()
	{
		return name;
	}
}
