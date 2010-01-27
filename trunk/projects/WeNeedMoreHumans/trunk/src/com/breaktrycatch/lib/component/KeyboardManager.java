package com.breaktrycatch.lib.component;

import java.util.HashMap;

import com.breaktrycatch.lib.util.callback.ISimpleCallback;

import processing.core.PApplet;

public class KeyboardManager implements IManager
{
	private PApplet _app;

	private HashMap<Character, ISimpleCallback> _charMap;
	private HashMap<Character, ISimpleCallback> _onceCharMap;
	private Character _lastKey;

	public KeyboardManager(PApplet app)
	{
		_app = app;
		_charMap = new HashMap<Character, ISimpleCallback>();
		_onceCharMap = new HashMap<Character, ISimpleCallback>();
	}

	public void registerKey(char key, ISimpleCallback callback)
	{
		_charMap.put(key, callback);
	}

	public void registerKeyOnce(char key, ISimpleCallback callback)
	{
		_onceCharMap.put(key, callback);
	}

	@Override
	public void update()
	{
		if (!_app.keyPressed && _lastKey != null)
		{
			_lastKey = null;
		} else if (_app.keyPressed && _lastKey == null)
		{
			_lastKey = _app.key;
			if (_onceCharMap.containsKey(_app.key))
			{
				ISimpleCallback callback = _onceCharMap.get(_app.key);
				callback.execute();
			}
		}

		if (_app.keyPressed && _charMap.containsKey(_app.key))
		{
			ISimpleCallback callback = _charMap.get(_app.key);
			callback.execute();
		}
	}
}
