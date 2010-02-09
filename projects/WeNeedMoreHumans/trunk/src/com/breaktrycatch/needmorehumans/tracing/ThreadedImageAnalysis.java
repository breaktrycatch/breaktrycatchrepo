package com.breaktrycatch.needmorehumans.tracing;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.needmorehumans.model.BodyVO;

public class ThreadedImageAnalysis
{
	private final PApplet _app;
	private final ImageFrame _sprite;
	private FutureTask<BodyVO> _future;

	public ThreadedImageAnalysis(PApplet app, ImageFrame sprite)
	{
		_app = app;
		_sprite = sprite;
	}

	public void start()
	{
		ExecutorService newCachedThreadPool = Executors.newCachedThreadPool();
		_future = new FutureTask<BodyVO>(new Callable<BodyVO>()
		{
			public BodyVO call()
			{
				ImageAnalysis imageAnalysis = new ImageAnalysis(_app);
				return imageAnalysis.analyzeImage(_sprite.getDisplay());
			}

		});
		newCachedThreadPool.execute(_future);
	}

	public BodyVO get()
	{
		try
		{
			return _future.get();
		} catch (InterruptedException e)
		{
			e.printStackTrace();
		} catch (ExecutionException e)
		{
			e.printStackTrace();
		}
		return null;
	}

	public boolean isDone()
	{
		return _future.isDone();
	}
	
	public ImageFrame getSprite()
	{
		return _sprite;
	}
}