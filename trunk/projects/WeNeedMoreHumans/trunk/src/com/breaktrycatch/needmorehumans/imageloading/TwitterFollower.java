package com.breaktrycatch.needmorehumans.imageloading;

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
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TwitterFollower
{

	private AsyncTwitter __twitter;
	private AsyncTwitterFactory factory;
	private static final String USERNAME = "NeedMoreHumans";
	private static final String PASSWORD = "ignite";
	private List<Tweet> returnedTweets;
	private PApplet app;
	private ISimpleCallback __callback;
	private PImage _vessel;
	private int _page;

	private static ArrayList<String> _usedURLs = new ArrayList<String>();

	public TwitterFollower(ISimpleCallback _callback, final ISimpleCallback _noTweetsCallback, PApplet _appletReference)
	{
		app = _appletReference;
		__callback = _callback;
		factory = new AsyncTwitterFactory(new TwitterAdapter()
		{
			@Override
			public void searched(QueryResult result)
			{
				LogRepository.getInstance().getJonsLogger().info("SEARCH COMPLETE");
				returnedTweets = result.getTweets();
				LogRepository.getInstance().getJonsLogger().info("Tweets returned " + returnedTweets.size());
				for (int i = 0; i < returnedTweets.size(); i++)
				{
					Tweet tweet = returnedTweets.get(i);
					
					if (!_usedURLs.contains(tweet.getProfileImageUrl()))
					{
						_usedURLs.add(tweet.getProfileImageUrl());
						loadTweetImage(tweet.getProfileImageUrl());
						return;
					}
				}
				
				PApplet.println("NO TWEETS FOUND, next page?  " + _page);
				if(_page < 3)
				{
					_page++;
					follow(_page);
				}
				else
				{
					_noTweetsCallback.execute();
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

	public void follow(int page)
	{
		_page = page;
		Query query;
		query = new Query("#FITC");
		query.setPage(page);
		__twitter.search(query);
	}

	public void follow()
	{
		follow(1);
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
