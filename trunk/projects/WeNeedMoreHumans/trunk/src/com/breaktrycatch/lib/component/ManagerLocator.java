package com.breaktrycatch.lib.component;

import java.util.ArrayList;

public class ManagerLocator extends ArrayList<IManager>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static ManagerLocator instance = null;

	private ManagerLocator()
	{

	}

	public static ManagerLocator getInstance()
	{
		if (instance == null)
		{
			instance = new ManagerLocator();
		}
		return instance;
	}

	public static IManager getManager(Class<? extends IManager> type)
	{
		for (IManager manager : instance)
		{
			if (type == manager.getClass())
			{
				return manager;
			}
		}

		return null;
	}

	public void update()
	{
		// TODO: add a time diff to the update method
		for (IManager manager : this)
		{
			manager.update();
		}
	}
}
