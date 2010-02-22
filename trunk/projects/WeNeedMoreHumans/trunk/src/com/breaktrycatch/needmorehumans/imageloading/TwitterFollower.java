package com.breaktrycatch.needmorehumans.imageloading;



import java.awt.Image;
import java.awt.MediaTracker;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import processing.core.PApplet;
import processing.core.PImage;
import twitter4j.AsyncTwitter;
import twitter4j.AsyncTwitterFactory;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Tweet;
import twitter4j.TwitterAdapter;

import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TwitterFollower {
	
	private AsyncTwitter __twitter;
	private AsyncTwitterFactory factory;
	private static final String USERNAME = "NeedMoreHumans";
	private static final String PASSWORD = "ignite";
	
	private List<Tweet> returnedTweets;
	private Tweet tempTweet;
	private Tweet lastTweet;
	
	private PApplet app;
	
	private MediaTracker tracker;
	
	private ISimpleCallback __callback;
	
	public TwitterFollower(ISimpleCallback _callback, PApplet _appletReference) {
		// TODO Auto-generated constructor stub
		app = _appletReference;
		__callback = _callback;
		factory = new AsyncTwitterFactory(new TwitterAdapter()
		{
			
			@Override
			public void searched(QueryResult result) {
				// TODO Auto-generated method stub
				LogRepository.getInstance().getJonsLogger().info("SEARCH COMPLETE");
				returnedTweets = result.getTweets();
				LogRepository.getInstance().getJonsLogger().info("Tweets returned " + returnedTweets.size());
				for (int i = 0; i < returnedTweets.size(); i++) {
					tempTweet = returnedTweets.get(i);
					LogRepository.getInstance().getJonsLogger().info("Tweet: " + tempTweet.getFromUser() + " " + tempTweet.getProfileImageUrl() + " " + tempTweet.getText());
					if (lastTweet == null) {
						lastTweet = tempTweet;
						LogRepository.getInstance().getJonsLogger().info("First Tweet Ever!");
						try {
							loadTweetImage(lastTweet.getProfileImageUrl());
						} catch (MalformedURLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						return;
					}
					else {
						
						if (lastTweet.getId() == tempTweet.getId()) {
							LogRepository.getInstance().getJonsLogger().info("Same Tweet as last time...");
							return;
						}
						else {
							LogRepository.getInstance().getJonsLogger().info("New Tweet!");
							lastTweet = tempTweet;
							try {
								loadTweetImage(lastTweet.getProfileImageUrl());
							} catch (MalformedURLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							return;
						}
						
					}
					
				}
				
				
			}
			
			
		});
		__twitter = factory.getInstance(USERNAME, PASSWORD);
	}
	
	public void follow() {
	
		Query query;
		query = new Query("#FITC");
		query.setPage(1);
		__twitter.search(query);
	}
	
	private void loadTweetImage(String _url) throws MalformedURLException {
		//HOW DO WE DO THIS?
		tracker = new MediaTracker(app);
		Image img = app.getImage(new URL(_url));
		tracker.addImage(img, 1);
		
		PImage pimg = new PImage(img);
		
		LogRepository.getInstance().getJonsLogger().info("PImage complete");
		
		__callback.execute();
	}

}
