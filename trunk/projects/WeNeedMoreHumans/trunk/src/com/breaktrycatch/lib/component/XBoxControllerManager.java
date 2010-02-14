package com.breaktrycatch.lib.component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import processing.core.PApplet;

import com.breaktrycatch.lib.util.callback.IFloatCallback;
import com.breaktrycatch.lib.util.callback.ISimpleCallback;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.esotericsoftware.controller.device.Axis;
import com.esotericsoftware.controller.device.Button;
import com.esotericsoftware.controller.input.JInputXboxController;
import com.esotericsoftware.controller.input.XboxController;
import com.esotericsoftware.controller.input.XboxController.Listener;

/**
 * A simple controller manager for XBox controllers. This manager provides a
 * standard interface for adding call backs that fire when controllers are
 * manipulated. It also allows you to add call backs to controllers that are not
 * currently connected, but may be in future. When the controller is connected,
 * the call backs will automatically start being dispatched.
 * 
 * TODO: Handle controller connecting.
 * 
 * @author Paul
 * 
 */
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

	/**
	 * Called automatically by the ManagerLocator.
	 */
	public void update()
	{
		for (XBoxControllerFacade controller : _controllers)
		{
			controller.poll();
		}
	}

	/**
	 * Sets the controller's dead zone. The dead zone is the amount of movement
	 * a thumb stick can move even if the user is not moving it.
	 * 
	 * @param deadZone
	 *            A value from [0-1] to use as the dead zone. Values in the
	 *            range of .2f to .4f are ideal.
	 */
	public void setDeadZone(float deadZone)
	{
		for (XBoxControllerFacade controller : _controllers)
		{
			controller.setDeadZone(deadZone);
		}
	}

	/**
	 * Registers a call back on a specific controller that will be triggered
	 * every update while the button is pressed.
	 * 
	 * @param player
	 *            The controller to add the call back to (from 0-3).
	 * @param button
	 *            A button to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerButton(int player, Button button, ISimpleCallback callback)
	{
		getController(player).registerButton(button, callback);
	}

	/**
	 * Registers a call back on the first connected controller that will be
	 * triggered every update while the button is pressed.
	 * 
	 * @param button
	 *            A button to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerButton(Button button, ISimpleCallback callback)
	{
		getController().registerButton(button, callback);
	}

	/**
	 * Registers a call back on a specific controller controller that will be
	 * triggered only once when the button is first pressed.
	 * 
	 * @param button
	 *            A button to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerButtonOnce(int player, Button button, ISimpleCallback callback)
	{
		getController(player).registerButtonOnce(button, callback);
	}

	/**
	 * Registers a call back on the first connected controller that will be
	 * triggered only once when the button is first pressed.
	 * 
	 * @param button
	 *            A button to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerButtonOnce(Button button, ISimpleCallback callback)
	{
		getController().registerButtonOnce(button, callback);
	}

	/**
	 * Registers a call back on a specific controller that will be triggered
	 * every update while the thumb stick axis is moved outside the dead zone.
	 * 
	 * @param player
	 *            The controller to add the call back to (from 0-3).
	 * @param button
	 *            A button to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerAxis(int player, Axis axis, IFloatCallback callback)
	{
		getController(player).registerAxis(axis, callback);
	}

	/**
	 * Registers a call back on the first connected controller that will be
	 * triggered every update while the thumb stick axis is moved outside the
	 * dead zone.
	 * 
	 * @param button
	 *            A button to register a call back to.
	 * @param callback
	 *            The call back to fire every update while the supplied key is
	 *            pressed.
	 */
	public void registerAxis(Axis axis, IFloatCallback callback)
	{
		getController().registerAxis(axis, callback);
	}

	/**
	 * Unregisters a call back on the first connected controller that was set
	 * using registerButton.
	 * 
	 * @param button
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterButton(Button button, ISimpleCallback callback)
	{
		return getController().unregisterButton(button, callback);
	}

	/**
	 * Unregisters a call back that was set using registerButton.
	 * 
	 * @player player The controller the call back was added to.
	 * @param button
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterButton(int player, Button button, ISimpleCallback callback)
	{
		return getController(player).unregisterButton(button, callback);
	}

	/**
	 * Unregisters a call back that was set using registerButtonOnce.
	 * 
	 * @param button
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterButtonOnce(Button button, ISimpleCallback callback)
	{
		return getController().unregisterButtonOnce(button, callback);
	}

	/**
	 * Unregisters a call back that was set using registerButtonOnce.
	 * 
	 * @player player The controller the call back was added to.
	 * @param button
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterButtonOnce(int player, Button button, ISimpleCallback callback)
	{
		return getController(player).unregisterButtonOnce(button, callback);
	}

	/**
	 * Unregisters a call back on the first connected controller that was set
	 * using registerAxis.
	 * 
	 * @param button
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterAxis(Axis axis, IFloatCallback callback)
	{
		return getController().unregisterAxis(axis, callback);
	}

	/**
	 * Unregisters a call back that was set using registerAxis.
	 * 
	 * @player player The controller the call back was added to.
	 * @param button
	 *            The key used to register the listener.
	 * @param callback
	 *            The call back to unregister.
	 * @return If the removal was successful.
	 */
	public boolean unregisterAxis(int player, Axis axis, IFloatCallback callback)
	{
		return getController(player).unregisterAxis(axis, callback);
	}

	private XBoxControllerFacade getController()
	{
		return getController(0);
	}

	private XBoxControllerFacade getController(int player)
	{
		return _controllers.get(player);
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
}

class XBoxControllerFacade
{
	private XboxController _controller;

	private HashMap<Button, ArrayList<ISimpleCallback>> _buttonMap;
	private HashMap<Button, ArrayList<ISimpleCallback>> _onceButtonMap;
	private HashMap<Button, Boolean> _alreadyFiredMap;
	private HashMap<Axis, ArrayList<IFloatCallback>> _axisMap;

	private float _deadZone = .3f;
	private float _triggerDeadZone = .1f;

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
		if (!_axisMap.containsKey(axis))
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

	public boolean unregisterAxis(Axis axis, IFloatCallback callback)
	{
		if (_axisMap.containsKey(axis))
		{
			return _axisMap.get(axis).remove(callback);
		}
		return false;
	}

	public boolean unregisterButton(Button button, ISimpleCallback callback)
	{
		return internalUnregisterButton(_buttonMap, button, callback);
	}

	public boolean unregisterButtonOnce(Button button, ISimpleCallback callback)
	{
		return internalUnregisterButton(_onceButtonMap, button, callback);
	}

	private boolean internalUnregisterButton(HashMap<Button, ArrayList<ISimpleCallback>> list, Button key, ISimpleCallback callback)
	{
		if (list.containsKey(key))
		{
			return list.get(key).remove(callback);
		}
		return false;
	}

	public void poll()
	{
		if (_controller == null || _disconnected)
		{
			// the controller is unplugged!
			return;
		}

		_controller.poll();

		// repeating button call backs (fire every tick)
		for (Button btn : _buttonMap.keySet())
		{
			if (_controller.get(btn))
			{
				ArrayList<ISimpleCallback> callbacks = _buttonMap.get(btn);
				executeList(callbacks);
			}
		}

		// button call backs that fire only on button down.
		for (Button btn : _onceButtonMap.keySet())
		{
			if (_controller.get(btn) && _alreadyFiredMap.get(btn) == false)
			{
				ArrayList<ISimpleCallback> callbacks = _onceButtonMap.get(btn);
				executeList(callbacks);
				
				PApplet.println("EXECUTING CALLBACK on  " + btn + " : " + _alreadyFiredMap.get(btn) + " ::: " + _controller.get(btn));
				
				_alreadyFiredMap.put(btn, true);
			} else if(!_controller.get(btn))
			{
				_alreadyFiredMap.put(btn, false);
			}
		}

		// axis call backs fired every time the axis is outside the dead zone.
		for (Axis axis : _axisMap.keySet())
		{
			float value = _controller.get(axis);
			if (Math.abs(value) > getDeadZone() || ((axis == Axis.leftTrigger || axis == Axis.rightTrigger) && value > _triggerDeadZone))
			{
				ArrayList<IFloatCallback> callbacks = _axisMap.get(axis);
				executeFloatList(callbacks, value);
			}
		}
	}

	public void setDeadZone(float deadZone)
	{
		_deadZone = deadZone;
	}

	public float getDeadZone()
	{
		return _deadZone;
	}

	private void executeList(ArrayList<ISimpleCallback> callbacks)
	{
		for (int i = callbacks.size() - 1; i >= 0; i--)
		{
			callbacks.get(i).execute();
		}
	}

	private void executeFloatList(ArrayList<IFloatCallback> callbacks, float value)
	{
		for (int i = callbacks.size() - 1; i >= 0; i--)
		{
			callbacks.get(i).execute(value);
		}
	}

	@Override
	public String toString()
	{
		return "[XBoxController: " + _controller.getName() + "]";
	}
}
