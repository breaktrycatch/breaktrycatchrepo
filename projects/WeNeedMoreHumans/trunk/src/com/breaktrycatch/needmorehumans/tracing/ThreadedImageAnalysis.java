package com.breaktrycatch.needmorehumans.tracing;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.needmorehumans.model.BodyVO;
import com.breaktrycatch.needmorehumans.tracing.callback.IThreadedImageAnalysisCallback;

public class ThreadedImageAnalysis
{
	private final PApplet _app;
	private final ImageFrame _sprite;

	public ThreadedImageAnalysis(PApplet app, ImageFrame sprite)
	{
		_app = app;
		_sprite = sprite;
	}

	public void start(IThreadedImageAnalysisCallback completeCallback)
	{
		ExecutorService newCachedThreadPool = Executors.newCachedThreadPool();
		ImageAnalysisTask future = new ImageAnalysisTask(completeCallback, new Callable<BodyVO>()
		{
			public BodyVO call()
			{
				ImageAnalysis imageAnalysis = new ImageAnalysis(_app);
				return imageAnalysis.analyzeImage(_sprite.getDisplay());
			}

		});
		newCachedThreadPool.execute(future);
	}
}

class ImageAnalysisTask extends FutureTask<BodyVO>
{
	private final IThreadedImageAnalysisCallback _callback;

	public ImageAnalysisTask(IThreadedImageAnalysisCallback callback, Callable<BodyVO> callable)
	{
		super(callable);
		_callback = callback;
	}

	@Override
	protected void done()
	{
		super.done();
		
		PApplet.println("Threaded Image Analysis DONE!");
		
		try
		{
			_callback.execute(get());
		} catch (InterruptedException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}