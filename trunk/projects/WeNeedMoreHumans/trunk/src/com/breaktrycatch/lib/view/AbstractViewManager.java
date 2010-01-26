package com.breaktrycatch.lib.view;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;

public class AbstractViewManager extends DisplayObject
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private AbstractView _currentView = null;
	private String _currentViewName = null;

	public AbstractViewManager(PApplet app)
	{
		super(app);
	}

	public void changeView(String view)
	{
		// don't change if the view is already up.
		if (_currentViewName == view)
		{
			return;
		}

		AbstractView instance = null;
		try
		{
			instance = (AbstractView) Class.forName(view).newInstance();
			instance.initialize(getApp());
			PApplet.println("Created View: " + instance);
		} catch (ClassNotFoundException cnf)
		{
			PApplet.println("Couldn't find class: " + view);
		} catch (InstantiationException ie)
		{
			PApplet.println("Couldn't instantiate the class: " + view);
		} catch (IllegalAccessException ia)
		{
			PApplet.println("Couldn't access class: " + view);
		}

		if (_currentView != null)
		{
			remove(_currentView);
		}

		_currentViewName = view;
		_currentView = instance;
		add(_currentView);
	}
}
