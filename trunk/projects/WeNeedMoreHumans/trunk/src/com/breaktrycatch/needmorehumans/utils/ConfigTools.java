package com.breaktrycatch.needmorehumans.utils;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.BasicConfigurator;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;

import processing.core.PApplet;

public class ConfigTools
{
	private static final String stdFilename = "fuel";
	private static final String stdLocation = "file";

	private static Configuration configuration = null;

	public static boolean isConfigured()
	{
		return configuration != null;
	}

	public static int getInt(String category, String key)
	{
		int value = 0;
		try
		{
			value = Integer.parseInt(ConfigTools.get().getProperty(key, null, category));
		} catch (NumberFormatException e)
		{
			e.printStackTrace();
		}
		return value;
	}

	public static String getString(String category, String key)
	{
		String value = null;
		try
		{
			value = ConfigTools.get().getProperty(key, null, category);
		} catch (NumberFormatException e)
		{
			e.printStackTrace();
		}
		return value;
	}

	public static float getFloat(String category, String key)
	{
		float value = 0;
		try
		{
			String prop = ConfigTools.get().getProperty(key, null, category);
			value = Float.parseFloat(prop);
		} catch (NumberFormatException e)
		{
			e.printStackTrace();
		}
		return value;
	}
	
	public static boolean getBoolean(String category, String key)
	{
		boolean value = false;
		try
		{
			String prop = ConfigTools.get().getProperty(key, null, category);
			value = Boolean.parseBoolean(prop);
		} catch (NumberFormatException e)
		{
			e.printStackTrace();
		}
		return value;
	}

	public static Configuration get()
	{
		return get(stdFilename, stdLocation);
	}

	public static synchronized Configuration get(String stdFilename, String stdLocation)
	{
		if (configuration != null)
			return configuration;

		// configures Log4j.
		BasicConfigurator.configure();

		File dir1 = new File(".");

		try
		{
			PApplet.println("Loading configuration: " + dir1.getCanonicalPath() + stdFilename);
			configuration = ConfigurationManager.getConfiguration(stdFilename);
		} catch (IOException e)
		{
			e.printStackTrace();
		}

		if (configuration.isNew())
		{
			PApplet.println("This config was NOT loaded. It was created ");
		}

		PApplet.println("CREATED: " + configuration.getXMLAsString());

		return configuration;
	}

	public static synchronized void save()
	{
		try
		{
			ConfigurationManager.getInstance().save(stdFilename);
		} catch (ConfigurationManagerException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void setParameter(String section, String key, String value)
	{
		PApplet.println("Saving: "+ key + " : " + value + " : " + section);
		get().setProperty(key, value, section);
	}

}
