package com.breaktrycatch.lib.component;

import java.util.ArrayList;
import java.util.HashMap;

import processing.core.PApplet;

import com.breaktrycatch.lib.util.callback.ISimpleCallback;

public class KeyboardManager implements IManager
{
	private PApplet _app;

	private HashMap<Character, ArrayList<ISimpleCallback>> _charMap;
	private HashMap<Character, ArrayList<ISimpleCallback>> _onceCharMap;
	private Character _lastKey;

	public KeyboardManager(PApplet app)
	{
		_app = app;
		_charMap = new HashMap<Character, ArrayList<ISimpleCallback>>();
		_onceCharMap = new HashMap<Character, ArrayList<ISimpleCallback>>();
	}

	public void registerKey(char key, ISimpleCallback callback)
	{
		if(!_charMap.containsKey(key))
		{
			_charMap.put(key, new ArrayList<ISimpleCallback>());
		}
		
		_charMap.get(key).add(callback);
	}
	
	public void registerKeyOnce(char key, ISimpleCallback callback)
	{
		if(!_onceCharMap.containsKey(key))
		{
			_onceCharMap.put(key, new ArrayList<ISimpleCallback>());
		}

		_onceCharMap.get(key).add(callback);
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
				ArrayList<ISimpleCallback> callbacks = _onceCharMap.get(_app.key);
				executeList(callbacks);
			}
		}

		if (_app.keyPressed && _charMap.containsKey(_app.key))
		{
			ArrayList<ISimpleCallback> callbacks = _charMap.get(_app.key);
			executeList(callbacks);
		}
	}
	
	private void executeList(ArrayList<ISimpleCallback> callbacks)
	{
		for(ISimpleCallback callback : callbacks)
		{
			callback.execute();
		}
	}
}
