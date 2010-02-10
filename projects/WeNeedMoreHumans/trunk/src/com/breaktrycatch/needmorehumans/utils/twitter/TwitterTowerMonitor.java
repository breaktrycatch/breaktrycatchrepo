package com.breaktrycatch.needmorehumans.utils.twitter;

import java.text.DecimalFormat;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.utils.FileUtils;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TwitterTowerMonitor
{
	private ArrayList<Integer> _increments;
	private ArrayList<String> _messages;
	private String _token = "{TOKEN}";
	private DecimalFormat _formatter;
	private PApplet _app;

	public TwitterTowerMonitor(PApplet app)
	{
		_app = app;
		_formatter = new DecimalFormat("##0.00");
		reset();
	}

	public void update(float height, ArrayList<? extends DisplayObject> sprites)
	{
		height = height / 100;

		if (_increments.size() > 0 && height > _increments.get(0))
		{
			_increments.remove(0);
			
			PImage img = FileUtils.createTowerImage(_app, sprites);

			String message = _messages.remove(0);
			message = message.replaceAll("\\{TOKEN\\}", _formatter.format(height));
			TwitterTools.postTweet(message, img);

			LogRepository.getInstance().getPaulsLogger().info("Tweeting with: " + message);
		}
	}

	public void reset()
	{
		_increments = new ArrayList<Integer>();
		_increments.add(5);
		_increments.add(10);
		_increments.add(25);
		_increments.add(50);
		_increments.add(100);
		_increments.add(150);
		
		_messages = new ArrayList<String>();
		_messages.add("What a tiny tower at only " + _token + " meters. We need more humans!");
		_messages.add("The tower is starting to take shape at " + _token + " meters!");
		_messages.add("The tower just hit 10 stories at " + _token + " meters!");
		_messages.add("Now thats a pile of people! The tower is now " + _token + " meters.");
		_messages.add("A sturdy skyscraper syle structure stretching upwards to " + _token + " meters!");
		_messages.add("This tower is now the 8th wonder of the world at " + _token + " meters!");
	}
}
