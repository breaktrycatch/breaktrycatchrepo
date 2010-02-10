package com.breaktrycatch.needmorehumans.utils.twitter;

import java.io.File;
import java.io.IOException;
import java.util.Date;

import processing.core.PApplet;
import processing.core.PImage;
import twitter4j.AsyncTwitter;
import twitter4j.AsyncTwitterFactory;
import twitter4j.Status;
import twitter4j.TwitterAdapter;
import twitter4j.TwitterException;
import twitter4j.TwitterMethod;

import com.harrison.lee.twitpic4j.TwitPic;
import com.harrison.lee.twitpic4j.TwitPicResponse;
import com.harrison.lee.twitpic4j.exception.TwitPicException;

public class TwitterTools
{
	private static final String USERNAME = "NeedMoreHumans";
	private static final String PASSWORD = "ignite";

	public static void postTweet(String message)
	{
		PApplet.println("Posting tweet....");
		AsyncTwitterFactory factory = new AsyncTwitterFactory(new TwitterAdapter()
		{
			@Override
			public void updatedStatus(Status statuses)
			{
				System.out.println("Successfully updated the status to [" + statuses.getText() + "].");
			};

			@Override
			public void onException(TwitterException e, TwitterMethod method)
			{
				if (method == TwitterMethod.UPDATE_STATUS)
				{
					e.printStackTrace();
				} else
				{
					throw new AssertionError("Should not happen");
				}
			}
		});
		AsyncTwitter twitter = factory.getInstance(USERNAME, PASSWORD);
		twitter.updateStatus(message);
	}

	public static void postTweet(String message, PImage image)
	{
		AsyncTweetPicRequest request = new AsyncTweetPicRequest(USERNAME, PASSWORD, message, image);
		request.startProcess();
	}
}

class AsyncTweetPicRequest implements Runnable
{
	private String _username;
	private String _password;
	private String _message;
	private PImage _image;
	private Thread _thread;

	public AsyncTweetPicRequest(String username, String password, String message, PImage image)
	{
		_username = username;
		_password = password;
		_message = message;
		_image = image;
	}

	public void startProcess()
	{
		_thread = new Thread(this);
		_thread.start();
	}

	@Override
	public void run()
	{
		String filename = "tweetImageTemp" + new Date().getTime() + ".png";
		_image.save(filename);
		File file = new File(filename);

		PApplet.println("got file: " + file.getAbsolutePath());

		TwitPic tpRequest = new TwitPic(_username, _password);
		TwitPicResponse tpResponse = null;

		// Make request and handle exceptions
		try
		{
			tpResponse = tpRequest.uploadAndPost(file, _message);
		} catch (IOException e)
		{
			e.printStackTrace();
		} catch (TwitPicException e)
		{
			e.printStackTrace();
		}

		// If we got a response back, print out response variables
		if (tpResponse != null)
		{
			tpResponse.dumpVars();
		}

		file.delete();
	}
}
