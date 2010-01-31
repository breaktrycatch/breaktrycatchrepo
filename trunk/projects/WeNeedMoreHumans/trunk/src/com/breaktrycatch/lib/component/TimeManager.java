package com.breaktrycatch.lib.component;

import processing.core.PApplet;

public class TimeManager implements IManager
{
	private long _lastTime;
	private long _gameTimeDiff;

	public TimeManager()
	{
		PApplet.println("Setting start time; " + System.nanoTime());
		_lastTime = System.nanoTime();
	}

	public void update()
	{
		long newDate = System.nanoTime();
		_gameTimeDiff = newDate - _lastTime;
		_lastTime = newDate;
	}

	public long getGameTimeDiff()
	{
		return _gameTimeDiff;
	}

	public float getGameTimeDiffMillis()
	{
		return (_gameTimeDiff / 1000000);
	}
}
