package com.breaktrycatch.needmorehumans.utils;

import java.io.OutputStreamWriter;

import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;

public class LogRepository
{
	private static LogRepository instance;
	private static Logger paulsLogger;
	private static Logger jonsLogger;
	private static Logger mikesLogger;

	protected LogRepository()
	{
		ConsoleAppender ca = new ConsoleAppender();
		ca.setWriter(new OutputStreamWriter(System.out));
		ca.setLayout(new PatternLayout("%-5p [%t]: %m%n"));
		
		
		//TOSO: Configure the levels here based on config file.
		paulsLogger = Logger.getLogger("com.breaktrycatch.paul");
		paulsLogger.setLevel(Level.DEBUG);
		paulsLogger.addAppender(ca);
		
		jonsLogger = Logger.getLogger("com.breaktrycatch.jon");
		jonsLogger.setLevel(Level.DEBUG);
		jonsLogger.addAppender(ca);

		mikesLogger = Logger.getLogger("com.breaktrycatch.mike");
		mikesLogger.setLevel(Level.DEBUG);
		mikesLogger.addAppender(ca);
	}

	public static LogRepository getInstance()
	{
		if (instance == null)
		{
			instance = new LogRepository();
		}

		return instance;
	}

	public Logger getPaulsLogger()
	{
		return paulsLogger;
	}

	public Logger getJonsLogger()
	{
		return jonsLogger;
	}

	public Logger getMikesLogger()
	{
		return mikesLogger;
	}

	public Object clone() throws CloneNotSupportedException
	{
		throw new CloneNotSupportedException();
	}

}
