package com.breaktrycatch.needmorehumans.imageloading;

import java.awt.Image;
import java.awt.MediaTracker;
import java.net.MalformedURLException;
import java.util.ArrayList;
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
import com.breaktrycatch.needmorehumans.utils.AsyncImageLoader;
import com.breaktrycatch.needmorehumans.utils.ImageLoader;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TwitterFollower
{

	private AsyncTwitter __twitter;
	private AsyncTwitterFactory factory;
	private static final String USERNAME = "NeedMoreHumans";
	private static final String PASSWORD = "ignite";

	private List<Tweet> returnedTweets;
	private Tweet tempTweet;

	private PApplet app;

	private MediaTracker tracker;

	private ISimpleCallback __callback;
	private Image _loadingImage;
	private ImageLoader _loader;
	private PImage _vessel;

	private static  ArrayList<String> _usedURLs = new ArrayList<String>();

	public TwitterFollower(ISimpleCallback _callback, PApplet _appletReference)
	{
		// TODO Auto-generated constructor stub
		app = _appletReference;
		__callback = _callback;
		factory = new AsyncTwitterFactory(new TwitterAdapter()
		{
			@Override
			public void searched(QueryResult result)
			{
				// TODO Auto-generated method stub
				LogRepository.getInstance().getJonsLogger().info("SEARCH COMPLETE");
				returnedTweets = result.getTweets();
				LogRepository.getInstance().getJonsLogger().info("Tweets returned " + returnedTweets.size());
				for (int i = 0; i < returnedTweets.size(); i++)
				{
					Tweet tweet = returnedTweets.get(i);
//					LogRepository.getInstance().getJonsLogger().info("Tweet: " + tempTweet.getFromUser() + " " + tempTweet.getProfileImageUrl() + " " + tempTweet.getText());

					PApplet.println("DO I CONTAIN? " + _usedURLs.contains(tweet.getProfileImageUrl()) + " : " + tweet.getProfileImageUrl());
					
					if (!_usedURLs.contains(tweet.getProfileImageUrl()))
					{
						_usedURLs.add(tweet.getProfileImageUrl());
						loadTweetImage(tweet.getProfileImageUrl());
						return;
					}
				}
			}

		});
		__twitter = factory.getInstance(USERNAME, PASSWORD);
	}

	public boolean update()
	{
		if (_vessel == null)
		{
			return false;
		}

		if (_vessel.width == 0)
		{
			return false;
		} else if (_vessel.width == -1)
		{
			return false;
		} else
		{
			// image is ready to go, draw it
			__callback.execute();
			return true;
		}
	}

	public void follow()
	{
		Query query;
		query = new Query("#FITC");
		query.setPage(1);
		__twitter.search(query);
	}

	PImage loadImageAsync(String filename)
	{
		PImage vessel = app.createImage(0, 0, PApplet.ARGB);
		AsyncImageLoader ail = new AsyncImageLoader(app, filename, vessel);
		ail.start();
		return vessel;
	}

	private void loadTweetImage(String _url)
	{

		PApplet.println("Loading URL: " + _url);
		_vessel = loadImageAsync(_url);
	}

	public PImage getImage()
	{
		return _vessel;
	}

}
