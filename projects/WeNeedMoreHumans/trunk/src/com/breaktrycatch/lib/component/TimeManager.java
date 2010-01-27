package com.breaktrycatch.lib.component;

import java.util.Date;

public class TimeManager implements IManager
{
	private static long _lastTime;
	private static long _gameTimeDiff;
	private static GameTime _time;

	static
	{
		_lastTime = new Date().getTime();
		_time = new GameTime();
	}

	public void update()
	{
//		long frameInTime = System.nanoTime();
//
//		long elapsedTime = System.nanoTime() - frameInTime;
//		long updateElapsedTime = System.nanoTime() - frameInTime;
//
//		_time.updateElapsedTime = updateElapsedTime;
//		_time.isRunningSlowly = targetElap < elapOver + updateElapsedTime;
//
//		long drawTime = elapsedTime - updateElapsedTime;
//		long elapOver = elapsedTime - targetElap;
//
//		_time.appendTotalElapsedOverTime(elapOver);
//
//		_time.drawElapsedTime = drawTime;
//		_time.elapsedOverTime = elapOver;
//		_time.totalRealTime += (_time.elapsedRealTime = System.nanoTime() - frameInTime);
//		_time.totalGameTime += (_time.elapsedGameTime = targetElap);

		long newDate = new Date().getTime();
		_gameTimeDiff = newDate - _lastTime;
		_lastTime = newDate;
	}

	public static long getGameTimeDiff()
	{
		return _gameTimeDiff;
	}
}
