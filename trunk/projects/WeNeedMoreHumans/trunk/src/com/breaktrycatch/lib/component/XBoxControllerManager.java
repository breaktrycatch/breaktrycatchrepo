package com.breaktrycatch.lib.component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.breaktrycatch.lib.util.callback.IFloatCallback;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.esotericsoftware.controller.device.Axis;
import com.esotericsoftware.controller.device.Button;
import com.esotericsoftware.controller.input.JInputXboxController;
import com.esotericsoftware.controller.input.XboxController;
import com.esotericsoftware.controller.input.XboxController.Listener;

public class XBoxControllerManager implements IManager
{
	public int numControllers;
	private ArrayList<XBoxControllerFacade> _controllers;
	private final int MAX_CONTROLLERS = 4;

	public XBoxControllerManager()
	{
		_controllers = new ArrayList<XBoxControllerFacade>();
		List<XboxController> jInputControllers = JInputXboxController.getJInputControllers();

		numControllers = jInputControllers.size();

		// none found
		if (numControllers == 0)
		{
			LogRepository.getInstance().getPaulsLogger().warn("No Gamepad Found!");
		}

		for (int i = 0; i < MAX_CONTROLLERS; i++)
		{
			_controllers.add(new XBoxControllerFacade(null));
		}

		syncLists(jInputControllers, _controllers);
	}

	@Override
	public void update()
	{
		for (XBoxControllerFacade controller : _controllers)
		{
			controller.poll();
		}
	}

	private void syncLists(List<XboxController> jInputControllers, ArrayList<XBoxControllerFacade> controllers)
	{
		for (int i = 0; i < MAX_CONTROLLERS; i++)
		{
			if (i < jInputControllers.size())
			{
				XboxController controller = jInputControllers.get(i);
				controllers.get(i).setController(controller);
			} else
			{
				// controller is unplugged.
				controllers.get(i).setController(null);
			}
		}
	}

	public void registerButton(int player, Button button, ISimpleCallback callback)
	{
		getController(player).registerButton(button, callback);
	}

	public void registerButton(Button button, ISimpleCallback callback)
	{
		getController().registerButton(button, callback);
	}

	public void registerButtonOnce(int player, Button button, ISimpleCallback callback)
	{
		getController(player).registerButtonOnce(button, callback);
	}

	public void registerButtonOnce(Button button, ISimpleCallback callback)
	{
		getController().registerButtonOnce(button, callback);
	}

	public void registerAxis(int player, Axis axis, IFloatCallback callback)
	{
		getController(player).registerAxis(axis, callback);
	}

	public void registerAxis(Axis axis, IFloatCallback callback)
	{
		getController().registerAxis(axis, callback);
	}

	private XBoxControllerFacade getController()
	{
		return getController(0);
	}

	private XBoxControllerFacade getController(int player)
	{
		return _controllers.get(player);
	}
}

class XBoxControllerFacade
{
	private XboxController _controller;

	private HashMap<Button, ArrayList<ISimpleCallback>> _buttonMap;
	private HashMap<Button, ArrayList<ISimpleCallback>> _onceButtonMap;
	private HashMap<Button, Boolean> _alreadyFiredMap;
	private HashMap<Axis, ArrayList<IFloatCallback>> _axisMap;

	private float _deadZone = .3f;

	private boolean _disconnected;

	public XBoxControllerFacade(XboxController controller)
	{
		setController(controller);
		_buttonMap = new HashMap<Button, ArrayList<ISimpleCallback>>();
		_onceButtonMap = new HashMap<Button, ArrayList<ISimpleCallback>>();
		_alreadyFiredMap = new HashMap<Button, Boolean>();
		_axisMap = new HashMap<Axis, ArrayList<IFloatCallback>>();
	}

	public void setController(XboxController controller)
	{
		_controller = controller;
		if (_controller != null)
		{
			_disconnected = false;
			_controller.addListener(new Listener()
			{
				public void disconnected()
				{
					LogRepository.getInstance().getPaulsLogger().warn(_controller.getName() + " Has disconnected!!");
					_disconnected = true;
				}
			});
		}
	}

	public XboxController getController()
	{
		return _controller;
	}

	public void registerAxis(Axis axis, IFloatCallback callback)
	{
		if (!_buttonMap.containsKey(axis))
		{
			_axisMap.put(axis, new ArrayList<IFloatCallback>());
		}

		_axisMap.get(axis).add(callback);
	}

	public void registerButton(Button button, ISimpleCallback callback)
	{
		if (!_buttonMap.containsKey(button))
		{
			_buttonMap.put(button, new ArrayList<ISimpleCallback>());
		}

		_buttonMap.get(button).add(callback);
	}

	public void registerButtonOnce(Button button, ISimpleCallback callback)
	{
		if (!_onceButtonMap.containsKey(button))
		{
			_onceButtonMap.put(button, new ArrayList<ISimpleCallback>());
		}

		_onceButtonMap.get(button).add(callback);
	}

	public void poll()
	{
		if (_controller == null || _disconnected)
		{
			// the controller is unplugged!
			return;
		}

		_controller.poll();

		// repeating button callbacks (fire every tick)
		for (Button btn : _buttonMap.keySet())
		{
			if (_controller.get(btn))
			{
				ArrayList<ISimpleCallback> callbacks = _buttonMap.get(btn);
				executeList(callbacks);
			}
		}

		// button callbacks that fire only on button down.
		for (Button btn : _onceButtonMap.keySet())
		{
			if (_controller.get(btn) && !_alreadyFiredMap.get(btn))
			{
				ArrayList<ISimpleCallback> callbacks = _onceButtonMap.get(btn);
				executeList(callbacks);

				_alreadyFiredMap.put(btn, true);
			} else
			{
				_alreadyFiredMap.put(btn, false);
			}
		}

		// axis callbacks fired every time the axis is outside the deadzone
		// (triggers have no deadzone).
		for (Axis axis : _axisMap.keySet())
		{
			float value = _controller.get(axis);
			if (Math.abs(value) > _deadZone || ((axis == Axis.leftTrigger || axis == Axis.rightTrigger) && value > 0))
			{
				ArrayList<IFloatCallback> callbacks = _axisMap.get(axis);
				executeFloatList(callbacks, value);
			}
		}
	}

	private void executeList(ArrayList<ISimpleCallback> callbacks)
	{
		for (ISimpleCallback callback : callbacks)
		{
			callback.execute();
		}
	}

	private void executeFloatList(ArrayList<IFloatCallback> callbacks, float value)
	{
		for (IFloatCallback callback : callbacks)
		{
			callback.execute(value);
		}
	}

	@Override
	public String toString()
	{
		return "[XBoxController: " + _controller.getName() + "]";
	}
}
