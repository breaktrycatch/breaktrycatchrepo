package com.breaktrycatch.needmorehumans.view;

import java.awt.Image;
import java.net.MalformedURLException;
import java.net.URL;

import processing.core.PApplet;

import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.imageloading.TwitterFollower;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TwitterAndLoadView extends AbstractView {

		
	private static final long serialVersionUID = 1L;
	private TwitterFollower __twitterFollower;
	private ISimpleCallback __callback;
	
	private Image test;
	
	public TwitterAndLoadView() {
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);
		LogRepository.getInstance().getJonsLogger().info("TWITTER VIEW LOADED");
		
		//Creates the callback
		createCallback();
		createFollower();
//		URL url;
//		try {
//			url = new URL("https://clblgn.sceur.ch:8090/logo.gif");
//			test = app.getImage(url);
//		} catch (MalformedURLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		
//		LogRepository.getInstance().getJonsLogger().info("IMAGE LOADED " + test);
//		
		
		
		__twitterFollower.follow();
	}
	
	private void createFollower() {
		__twitterFollower = new TwitterFollower(__callback, getApp());
	}
	
	private void createCallback() {
		__callback = new ISimpleCallback()
		{
			public void execute()
			{
				retrieveImageFromFollower();
			}
		};
	}
	
	private void retrieveImageFromFollower() {
		
	}
	
	@Override
	public void draw()
	{
		super.draw();
		
	}

}
