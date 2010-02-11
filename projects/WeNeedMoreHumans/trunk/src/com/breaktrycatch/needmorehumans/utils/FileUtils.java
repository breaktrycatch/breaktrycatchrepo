package com.breaktrycatch.needmorehumans.utils;

import java.awt.Rectangle;
import java.io.File;
import java.util.ArrayList;

import org.jbox2d.common.Vec2;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.control.physics.PhysicsControl;
import com.breaktrycatch.needmorehumans.view.GameView;

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
	
	public static void saveTowerImage(PImage img)
	{
		LogRepository.getInstance().getJonsLogger().info("SAVING TOWER IMAGE");
		int publishNumber = __towerPublishDirectory.list().length;
		String strPublishNumber = leadingSpaces(publishNumber);
		String path = __towerPublishDirectory.getAbsolutePath() + File.separator + "publish_" + strPublishNumber + ".png";
		
		LogRepository.getInstance().getJonsLogger().info("Saving tower to: " + path);
		img.save(path);
	}
	
	public static PImage createTowerImage(PApplet app, ArrayList<? extends DisplayObject> sprites)
	{
		Rectangle screenBounds = null;
		for (int i = 0; i < sprites.size(); i++)
		{
			DisplayObject sprite = sprites.get(i);
			
			float c = (float)Math.abs(Math.cos(sprite.rotationRad));
			float s = (float)Math.abs(Math.sin(sprite.rotationRad));					
			float x_radius = (sprite.width * c + sprite.height * s)/2.0f;
			float y_radius = (sprite.width * s + sprite.height * c)/2.0f;
			Vec2 min = new Vec2(sprite.x - x_radius, sprite.y - y_radius);
			Rectangle bounds = new Rectangle((int)min.x, (int)min.y, (int)x_radius*2, (int)y_radius*2);						

			screenBounds = (screenBounds == null) ? bounds : screenBounds.union(bounds);
		}
		
		PGraphics drawBuffer = app.createGraphics(screenBounds.width, screenBounds.height, PApplet.JAVA2D);
		drawBuffer.beginCamera();
		drawBuffer.beginDraw();
		drawBuffer.noFill();

		for (int i = 0; i < sprites.size(); i++)
		{
			drawBuffer.pushMatrix();
			DisplayObject s = sprites.get(i);
			Rectangle rectangle = s.getScreenBounds();
			drawBuffer.translate(-screenBounds.x - rectangle.width / 2, -screenBounds.y - rectangle.height / 2);
			s.enableExternalRenderTarget(drawBuffer, 0, 0);
			s.preDraw();
			s.draw();
			s.postDraw();
			s.disableExternalRenderTarget();
			drawBuffer.popMatrix();
		}
		drawBuffer.endDraw();
		drawBuffer.endCamera();
		return drawBuffer;
	}

	private static void constructTowerPaths()
	{
		File tempFile = new File("");
		String path = tempFile.getAbsolutePath() + File.separator + "data" + File.separator + "towers";

		__towerDirectory = new File(path);
		if (__towerDirectory.list() != null) {
			__towerNumber = __towerDirectory.list().length;
		}
		else {
			__towerNumber = 0;
		}
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
		if (__towerSourceDirectory.list() != null) {
			__sourceNumber = __towerSourceDirectory.list().length;
		}
		else {
			__sourceNumber = 0;
		}
		String strSourceNumber = leadingSpaces(__sourceNumber);

		String path = __towerSourceDirectory.getAbsolutePath() + "/source_" + strSourceNumber + ".png";
		img.save(path);
	}

	private static String leadingSpaces(int _int)
	{
		return String.format("%05d", _int);
	}
}
