package com.breaktrycatch.lib.component;

import java.util.ArrayList;
import java.util.HashMap;

import processing.core.PApplet;

import com.breaktrycatch.lib.util.callback.ISimpleCallback;

/**
 * A simple keyboard manager that allows you to register call backs that trigger
 * every update while the key is depressed, or just once when the key is first
 * pressed.
 * 
 * @author Paul
 * 
 */
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

	/**
	 * Registers a call back that will be triggered every update while the key
	 * is pressed.
	 * 
	 * @param key
	 *            A key to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerKey(char key, ISimpleCallback callback)
	{
		if (!_charMap.containsKey(key))
		{
			_charMap.put(key, new ArrayList<ISimpleCallback>());
		}

		_charMap.get(key).add(callback);
	}

	/**
	 * Registers a call back that will be triggered only once every time a key
	 * is pressed.
	 * 
	 * @param key
	 *            A key to register a call back to.
	 * @param callback
	 *            The call back to fire once per key press.
	 */
	public void registerKeyOnce(char key, ISimpleCallback callback)
	{
		if (!_onceCharMap.containsKey(key))
		{
			_onceCharMap.put(key, new ArrayList<ISimpleCallback>());
		}

		_onceCharMap.get(key).add(callback);
	}

	/**
	 * Unregisters a call back that was set using registerKey.
	 * 
	 * @param key
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterKey(char key, ISimpleCallback callback)
	{
		return internalUnregisterKey(_charMap, key, callback);
	}

	/**
	 * Unregisters a call back that was set using registerKeyOnce.
	 * 
	 * @param key
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterKeyOnce(char key, ISimpleCallback callback)
	{
		return internalUnregisterKey(_onceCharMap, key, callback);
	}

	@Override
	/**
	 * Called automatically by the ManagerLocator.
	 */
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

	private boolean internalUnregisterKey(HashMap<Character, ArrayList<ISimpleCallback>> list, char key, ISimpleCallback callback)
	{
		if (list.containsKey(key))
		{
			return list.get(key).remove(callback);
		}
		return false;
	}

	private void executeList(ArrayList<ISimpleCallback> callbacks)
	{
		for(int i = callbacks.size() - 1; i >= 0; i--)
		{
			ISimpleCallback callback = callbacks.get(i);
			callback.execute();
		}
	}
}
