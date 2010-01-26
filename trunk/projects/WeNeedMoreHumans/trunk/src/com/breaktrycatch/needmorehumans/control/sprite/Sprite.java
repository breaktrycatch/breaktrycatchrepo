package com.breaktrycatch.needmorehumans.control.sprite;

import com.breaktrycatch.lib.display.DisplayObject;

public class Sprite {

	protected DisplayObject _display;
	
	protected Sprite(DisplayObject display) {
		_display = display;
	}
	
	public DisplayObject getDisplay()
	{
		return _display;
	}

}
