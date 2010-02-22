package com.breaktrycatch.needmorehumans.config.core;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;
import toxi.video.capture.SimpleCapture;

import com.breaktrycatch.lib.display.Stage;
import com.breaktrycatch.needmorehumans.config.control.ColorController;
import com.breaktrycatch.needmorehumans.control.video.PS3EyeCapture;
import com.breaktrycatch.needmorehumans.control.webcam.HumanProcessorControl;
import com.breaktrycatch.needmorehumans.utils.ConfigTools;
import com.breaktrycatch.needmorehumans.utils.ImageUtils;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

import controlP5.CheckBox;
import controlP5.ControlEvent;
import controlP5.ControlP5;
import controlP5.Controller;
import controlP5.RadioButton;
import controlP5.Textlabel;

public class NeedMoreHumansConfigCore extends Stage
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ControlP5 _controlP5;
	private ArrayList<Controller> _manualList;
	private ColorController _colorRect;
	private SimpleCapture _capture;
	private HumanProcessorControl _control;
	private boolean _useSubtractor = false;

	private int _marginX = 10;
	private int _cameraWidth;
	private int _cameraHeight;
	private static final String CAPTURE = "capture";
	private TileImageDrawer tileImageDrawer;

	public NeedMoreHumansConfigCore(PApplet app)
	{
		super(app);

		app.frameRate(60);
		app.size(ConfigTools.getInt(CAPTURE, "cameraWidth") + 350, ConfigTools.getInt(CAPTURE, "cameraHeight") + 400, PApplet.P2D);
		createUI(app);
		createCamera(app);
	}

	private void createCamera(PApplet app)
	{
		_cameraWidth = ConfigTools.getInt(CAPTURE, "cameraWidth");
		_cameraHeight = ConfigTools.getInt(CAPTURE, "cameraHeight");

		_capture = new PS3EyeCapture(app);
		_capture.initVideo("", _cameraWidth, _cameraHeight, ConfigTools.getInt(CAPTURE, "cameraFPS"));
		_capture.setExposure(ConfigTools.getFloat(CAPTURE, "exposure"));
		_capture.setGain(ConfigTools.getFloat(CAPTURE, "gain"));
		_capture.setColorBalance(_colorRect.getRed(), _colorRect.getGreen(), _colorRect.getBlue());

		_control = new HumanProcessorControl(app, _capture);
		_control.setDifferenceThreshold((int) ConfigTools.getFloat(CAPTURE, "captureThreshold"));
		_control.setScale(ConfigTools.getFloat(CAPTURE, "subtractionScale"));
		_control.setShadowThreshold(ConfigTools.getFloat(CAPTURE, "shadowThreshold"));
		_control.setProcessingEnabled(false);

		tileImageDrawer = new TileImageDrawer(app, .4f, 300);
		tileImageDrawer.x = 300;
		add(tileImageDrawer);
		_control.setDebugDrawer(tileImageDrawer);

	}

	private void createUI(PApplet app)
	{
		_manualList = new ArrayList<Controller>();
		_manualList.add(new Textlabel(getApp(), "WE NEED MORE HUMANS", _marginX, 10, getApp().width, 35));
		_manualList.add(new Textlabel(getApp(), "CONFIGURATOR.", _marginX, 45, getApp().width, 35));

		int startY = 75;
		int yJump = 25;
		int controlIndex = 0;
		_controlP5 = new ControlP5(app);
		_controlP5.addSlider("Exposure", 0f, 1f, ConfigTools.getFloat(CAPTURE, "exposure"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(1);
		_controlP5.addSlider("Gain", 0f, 1f, ConfigTools.getFloat(CAPTURE, "gain"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(2);
		_controlP5.addSlider("Capture Threshold", 0f, 122f, ConfigTools.getFloat(CAPTURE, "captureThreshold"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(3);
		_controlP5.addSlider("Shadow Threshold", 0f, 1f, ConfigTools.getFloat(CAPTURE, "shadowThreshold"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(4);

		controlIndex++;
		_controlP5.addSlider("Red Balance", 0f, 1f, ConfigTools.getFloat(CAPTURE, "redBalance"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(5);

		_colorRect = new ColorController(getApp(), getApp().width, startY + controlIndex * yJump, 60, 60);
		_colorRect.slideTo(_marginX + 200, startY + controlIndex * yJump, 1f);

		_controlP5.addSlider("Green Balance", 0f, 1f, ConfigTools.getFloat(CAPTURE, "greenBalance"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(6);
		_controlP5.addSlider("Blue Blanace", 0f, 1f, ConfigTools.getFloat(CAPTURE, "blueBalance"), _marginX, startY + (++controlIndex * yJump), 100, 14).setId(7);

		controlIndex++;
		_controlP5.addButton("Save", 1, _marginX, startY + (++controlIndex * yJump), 60, 25).setId(8);

		CheckBox checkbox = _controlP5.addCheckBox("thresholdBox", _marginX + 120, startY + (controlIndex * yJump));
		checkbox.setItemsPerRow(3);
		checkbox.setId(9);
		checkbox.addItem("Show Thresholds", 0).setState(false);

		_controlP5.addButton("Capture BG", 1, _marginX + 120, startY + (++controlIndex * yJump), 120, 25).setId(9);

		_colorRect.setRed(ConfigTools.getFloat(CAPTURE, "redBalance"));
		_colorRect.setGreen(ConfigTools.getFloat(CAPTURE, "greenBalance"));
		_colorRect.setBlue(ConfigTools.getFloat(CAPTURE, "blueBalance"));
		add(_colorRect);
	}

	public void controlEvent(ControlEvent theEvent)
	{
		if (theEvent.isGroup())
		{
			PApplet.println("got an event from " + theEvent.group().name() + "\t" + " :: ");
			if (theEvent.group().name() == "thresholdBox")
			{
				_useSubtractor = ((RadioButton) theEvent.group()).getItem(0).getState();

				if (_useSubtractor)
				{
					_control.setProcessingEnabled(true);
					_control.captureBackgrounds(ConfigTools.getInt(CAPTURE, "maxBackgrounds"));
				}

			}
		} else if (theEvent.isController())
		{
			switch (theEvent.controller().id())
			{
			case 1:
				_capture.setExposure(theEvent.controller().value());
				ConfigTools.setParameter(CAPTURE, "exposure", String.valueOf(theEvent.controller().value()));
				break;
			case 2:
				_capture.setGain(theEvent.controller().value());
				ConfigTools.setParameter(CAPTURE, "gain", String.valueOf(theEvent.controller().value()));
				break;
			case 3:
				int threshold = (int) theEvent.controller().value();
				_control.setDifferenceThreshold(threshold);
				ConfigTools.setParameter(CAPTURE, "captureThreshold", String.valueOf(threshold));
				break;
			case 4:
				_control.setShadowThreshold(theEvent.controller().value());
				ConfigTools.setParameter(CAPTURE, "shadowThreshold", String.valueOf(theEvent.controller().value()));
				break;
			case 5:
				_colorRect.setRed(theEvent.controller().value());
				_capture.setColorBalance(_colorRect.getRed(), _colorRect.getGreen(), _colorRect.getBlue());
				ConfigTools.setParameter(CAPTURE, "redBalance", String.valueOf(theEvent.controller().value()));
				break;
			case 6:
				_colorRect.setGreen(theEvent.controller().value());
				_capture.setColorBalance(_colorRect.getRed(), _colorRect.getGreen(), _colorRect.getBlue());
				ConfigTools.setParameter(CAPTURE, "greenBalance", String.valueOf(theEvent.controller().value()));
				break;
			case 7:
				_colorRect.setBlue(theEvent.controller().value());
				_capture.setColorBalance(_colorRect.getRed(), _colorRect.getGreen(), _colorRect.getBlue());
				ConfigTools.setParameter(CAPTURE, "blueBalance", String.valueOf(theEvent.controller().value()));
				break;
			case 8:
				ConfigTools.save();
				break;

			case 9:
				if (_useSubtractor)
				{
					_control.captureBackgrounds(ConfigTools.getInt(CAPTURE, "maxBackgrounds"));
				}
				break;
			}
		}
	}

	@Override
	public void draw()
	{
		tileImageDrawer.reset();
		getApp().background(0);
		super.draw();

		for (Controller control : _manualList)
		{
			control.draw(getApp());
		}

		if (!_useSubtractor)
		{
			getApp().image(_control.getRawCameraImage(), (getApp().width - _cameraWidth) / 2, getApp().height - _cameraHeight - 20);
		} else
		{
			if (!_control.isCapturingBackgrounds())
			{
				PImage masked = _control.getProcessedImage();

				getApp().image(_control.getRawCameraImage(), (getApp().width - _cameraWidth) / 2, getApp().height - _cameraHeight - 20);
				getApp().image(masked, (getApp().width - _cameraWidth) / 2, getApp().height - _cameraHeight - 20);
			}
		}

		_controlP5.draw();
		_capture.read();
		_control.update();

	}

	@Override
	public void dispose()
	{
		super.dispose();
		_capture.shutdown();
	}
}
