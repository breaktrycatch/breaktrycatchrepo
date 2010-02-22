package com.breaktrycatch.needmorehumans.control.sprite;

import java.awt.Rectangle;
import java.util.HashMap;

import processing.core.PApplet;
import processing.core.PImage;

public class HumanImageCreator
{
	private PImage _frame;
	private HashMap<String, PImage> _loadedBaseImages;
	private String[] _spriteLookup = new String[]
	{ "../data/tracing/RealPerson_1.png",
	// "../data/tracing/RealPerson_3.png",
			"../data/tracing/RealPerson_4.png", "../data/tracing/RealPerson_5.png" };

	private Rectangle[] _rectangleLookup = new Rectangle[]
	{ new Rectangle(15, 60, 50,50),
	// new Rectangle(112,30,33,33),
			new Rectangle(60, 25, 47, 47), new Rectangle(72, 28, 44, 44) };

	private PApplet _app;

	public HumanImageCreator(PApplet app)
	{
		_app = app;
		_loadedBaseImages = new HashMap<String, PImage>();
		_frame = app.loadImage("../data/tracing/frame.png");
	}

	public PImage create(PImage twitterImage)
	{
		int rnd = (int) Math.floor((_spriteLookup.length * Math.random()));
		String filename = _spriteLookup[rnd];
		PImage baseImage;

		if (!_loadedBaseImages.containsKey(filename))
		{
			baseImage = _app.loadImage(_spriteLookup[rnd]);
			_loadedBaseImages.put(filename, baseImage);
		}

		baseImage = _loadedBaseImages.get(filename);
		Rectangle rect = _rectangleLookup[rnd];

		PImage mashed = _app.createImage(baseImage.width, baseImage.height, PApplet.ARGB);
		mashed.copy(baseImage, 0, 0, baseImage.width, baseImage.height, 0, 0, baseImage.width, baseImage.height);
		mashed.copy(_frame, 0, 0, baseImage.width, baseImage.height, rect.x - 5, rect.y - 5, rect.width + 10, rect.height + 7);
		mashed.copy(twitterImage, 0, 0, twitterImage.width, twitterImage.height, rect.x, rect.y, rect.width, rect.height);

		return mashed;
	}
}
