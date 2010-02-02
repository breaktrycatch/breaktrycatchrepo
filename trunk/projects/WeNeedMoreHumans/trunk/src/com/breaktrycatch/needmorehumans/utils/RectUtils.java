package com.breaktrycatch.needmorehumans.utils;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Point2D;

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
}
