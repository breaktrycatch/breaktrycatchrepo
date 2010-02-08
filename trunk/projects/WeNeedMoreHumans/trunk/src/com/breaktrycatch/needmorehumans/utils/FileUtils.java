package com.breaktrycatch.needmorehumans.utils;

import java.awt.Rectangle;
import java.io.File;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;

public class FileUtils
{

	// SAVING METHODS
	private static File __towerDirectory;
	private static File __towerPublishDirectory;
	private static File __towerSourceDirectory;
	private static int __towerNumber;
	private static int __sourceNumber;

	// static constructor
	static
	{
		constructTowerPaths();
	}

	public static void saveImage(PApplet app, ArrayList<? extends DisplayObject> sprites)
	{
		LogRepository.getInstance().getJonsLogger().info("SAVING TOWER IMAGE");

		int publishNumber = __towerPublishDirectory.list().length;
		String strPublishNumber = leadingSpaces(publishNumber);
		String path = __towerPublishDirectory.getAbsolutePath() + "/publish_" + strPublishNumber + ".png";

		Rectangle screenBounds = new Rectangle();
		for (int i = 0; i < sprites.size(); i++)
		{
			DisplayObject s = sprites.get(i);
			Rectangle spriteBounds = s.getScreenBounds();
			screenBounds = screenBounds.union(spriteBounds);
		}
		
		PGraphics drawBuffer = app.createGraphics(screenBounds.width, screenBounds.height, PApplet.JAVA2D);
		drawBuffer.beginCamera();
		drawBuffer.beginDraw();
		drawBuffer.noFill();

		for (int i = 0; i < sprites.size(); i++)
		{
			DisplayObject s = sprites.get(i);
			s.enableExternalRenderTarget(drawBuffer, 0, 0);
			s.preDraw();
			s.draw();
			s.postDraw();
			s.disableExternalRenderTarget();
		}
		drawBuffer.endDraw();
		drawBuffer.endCamera();
		drawBuffer.save(path);
	}

	private static void constructTowerPaths()
	{
		File tempFile = new File("../");
		String path = tempFile.getAbsolutePath() + File.separator + "data" + File.separator + "towers";

		__towerDirectory = new File(path);
		__towerNumber = __towerDirectory.list().length;
		LogRepository.getInstance().getJonsLogger().info("IS DIRECTORY " + __towerDirectory.isDirectory() + " length " + __towerNumber);

		String strTowerNumber = leadingSpaces(__towerNumber);

		File newTowerDirectory = new File(path + File.separator + "tower_" + strTowerNumber);
		createDirectory(newTowerDirectory);

		__towerPublishDirectory = new File(newTowerDirectory.getPath() + File.separator + "publish");
		createDirectory(__towerPublishDirectory);

		__towerSourceDirectory = new File(newTowerDirectory.getPath() + File.separator + "source");
		createDirectory(__towerSourceDirectory);
	}

	private static void createDirectory(File dir)
	{
		if (!dir.exists())
		{
			dir.mkdir();
		} else
		{
			LogRepository.getInstance().getJonsLogger().info("FILE " + dir.getPath() + " already exists!");
		}
	}

	public static void saveSourceImage(PImage img)
	{
		__sourceNumber = __towerSourceDirectory.list().length;
		String strSourceNumber = leadingSpaces(__sourceNumber);

		String path = __towerSourceDirectory.getAbsolutePath() + "/source_" + strSourceNumber + ".png";
		img.save(path);
	}

	private static String leadingSpaces(int _int)
	{
		return String.format("%05d", _int);
	}
}
