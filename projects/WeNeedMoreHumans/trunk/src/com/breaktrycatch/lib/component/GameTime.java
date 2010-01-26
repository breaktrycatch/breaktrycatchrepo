package com.breaktrycatch.lib.component;

public class GameTime
{
	private static final long serialVersionUID = 707404131651174714L;

	public long totalRealTime;
	public long elapsedRealTime;
	public long totalGameTime;
	public long elapsedGameTime;
	public boolean isRunningSlowly;

	public long updateElapsedTime;
	public long drawElapsedTime;
	public long elapsedOverTime;

	private long mTotalElapsedOverTime;

	public GameTime()
	{
		totalRealTime = 0L;
		elapsedRealTime = 0L;
		totalGameTime = 0L;
		elapsedGameTime = 0L;
		isRunningSlowly = false;

		updateElapsedTime = 0L;
		drawElapsedTime = 0L;
		elapsedOverTime = 0L;

		mTotalElapsedOverTime = 0L;
	}

	public long totalElapsedOverTime()
	{
		return mTotalElapsedOverTime;
	}

	public void appendTotalElapsedOverTime(long time)
	{
		mTotalElapsedOverTime += time;
	}

	public GameTime copy()
	{
		GameTime gt = new GameTime();

		gt.totalRealTime = totalRealTime;
		gt.elapsedRealTime = elapsedRealTime;
		gt.totalGameTime = totalGameTime;
		gt.elapsedGameTime = elapsedGameTime;
		gt.isRunningSlowly = isRunningSlowly;

		gt.updateElapsedTime = updateElapsedTime;
		gt.drawElapsedTime = drawElapsedTime;
		gt.elapsedOverTime = elapsedOverTime;

		gt.appendTotalElapsedOverTime(totalElapsedOverTime());

		return gt;
	}

	@Override
	public String toString()
	{
		return "totalRealTime = " + totalRealTime + ", elapsedRealTime = " + elapsedRealTime + ", totalGameTime = " + totalGameTime + ", elapsedGameTime = " + elapsedGameTime + ", isRunningSlowly = "
				+ isRunningSlowly + ", updateElapsedTime = " + updateElapsedTime + ", drawElapsedTime = " + drawElapsedTime + ", elapsedOverTime = " + elapsedOverTime + ", totalElapsedOverTime = "
				+ mTotalElapsedOverTime;
	}
}
