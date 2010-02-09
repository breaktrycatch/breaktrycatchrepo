package com.breaktrycatch.needmorehumans.utils;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Point2D;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.config.control.ColorController;

public class RectUtils
{
	public static Point constrain(Point pt, Rectangle rect)
	{
		return constrain(pt, rect);
	}

	public static Point2D.Float constrain(Point2D.Float pt, Rectangle rect)
	{
		if (pt.x < rect.x)
		{
			pt.x = rect.x;
		} else if (pt.x > rect.x + rect.width)
		{
			pt.x = rect.x + rect.width;
		}

		if (pt.y < rect.y)
		{
			pt.y = rect.y;
		} else if (pt.y > rect.y + rect.height)
		{
			pt.y = rect.y + rect.height;
		}

		return pt;
	}

	public static DisplayObject constrainDisplayObject(DisplayObject obj, Rectangle bounds)
	{
		Point2D.Float pt = RectUtils.constrain(new Point2D.Float((int) obj.x, (int) obj.y), bounds);
		obj.x = pt.x;
		obj.y = pt.y;
		return obj;
	}

	public static float getRectRatio(Rectangle target, float targetSize)
	{
		float ratio = 1;
		if (target.width > target.height)
			ratio = targetSize / target.width;
		else if (target.height > target.width)
			ratio = targetSize / target.height;
		else if (target.height == target.width)
			ratio = targetSize / target.height;
		return ratio;
	}

	public static Rectangle expand(Rectangle rect, int expansionAmt)
	{
		rect.x -= expansionAmt / 2;
		rect.width += expansionAmt;

		rect.y -= expansionAmt / 2;
		rect.height += expansionAmt;
		
		return rect;
	}
	
	public static Rectangle expand(Rectangle rect, int expandWidth, int expandHeight)
	{
		rect.x -= expandWidth / 2;
		rect.width += expandWidth;

		rect.y -= expandHeight / 2;
		rect.height += expandHeight;
		
		return rect;
	}

	public static void sizeTo(DisplayObject display, Rectangle r)
	{
		display.x = r.x;
		display.y = r.y;
		display.width = r.width;
		display.height = r.height;
	}
}
