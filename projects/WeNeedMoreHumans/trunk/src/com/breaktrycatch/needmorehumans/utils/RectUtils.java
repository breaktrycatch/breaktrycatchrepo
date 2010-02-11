package com.breaktrycatch.needmorehumans.utils;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Float;

import com.breaktrycatch.lib.display.DisplayObject;

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


	public static void constrain(Rectangle rect, Rectangle bounds)
	{
		Point2D.Float pt = RectUtils.constrain(new Point2D.Float((int) rect.x, (int) rect.y), bounds);
		rect.x = (int)pt.x;
		rect.y = (int)pt.y;

		rect.width = (int)((rect.width > bounds.width) ? (bounds.width) : (rect.width));
		rect.height = (int)((rect.height > bounds.height) ? (bounds.height) : (rect.height));
	}

	public static DisplayObject constrainDisplayObject(DisplayObject obj, Rectangle bounds)
	{
		Point2D.Float pt = RectUtils.constrain(new Point2D.Float((int) obj.x, (int) obj.y), bounds);
		obj.x = pt.x;
		obj.y = pt.y;

		obj.width = (int)((obj.width > bounds.width) ? (bounds.width) : (obj.width));
		obj.height = (int)((obj.height > bounds.height) ? (bounds.height) : (obj.height));
		
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
	
	public static Rectangle fitIn(Rectangle target, Rectangle bounds)
	{
		target = (Rectangle)target.clone();
		
		float wD = target.width;
		float hD = target.height;

		float wR = bounds.width;
		float hR = bounds.height;

		float sX = wR / wD;
		float sY = hR / hD;

		float rD = wD / hD;
		float rR = wR / hR;

		float sH = sX;
		float sV = sY;

		float s = rD >= rR ? sH : sV;
		s = s > 1 ? 1 : s;
		float w = wD * s;
		float h = hD * s;
		
		target.width = (int)w;
		target.height = (int)h;
		
		Float constrain = constrain(new Point2D.Float(target.x, target.y), bounds);
		target.x = (int)constrain.x;
		target.y = (int)constrain.y;
		
		if(target.x + target.width > bounds.x + bounds.width)
		{
			target.x = bounds.x + bounds.width - target.width;
		}
		if(target.y + target.height > bounds.y + bounds.height)
		{
			target.y = bounds.y + bounds.height - target.height;
		}
		
		return target;
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

	public static Rectangle createFromDisplay(DisplayObject tweenObj)
	{
		return new Rectangle((int)tweenObj.x, (int)tweenObj.y, (int)tweenObj.width, (int)tweenObj.height);
	}
}
