package com.util
{

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author plemarquand
	 */
	public class RectUtil
	{
		/**
		 * Creates a rectangle from a DisplayObject. This is identical to calling
		 * obj.getBounds(obj).
		 * @param displayObject A display object from which to create a rectangle.
		 * @return A rectangle representing the position and dimentions of the DisplayObject.
		 */
		public static function rectFromDisplayObject(displayObject : DisplayObject) : Rectangle
		{
			return new Rectangle( displayObject.x, displayObject.y, displayObject.width, displayObject.height );
		}

		/**
		 * Resizes and positions a display object to the dimensions of another DisplayObject.
		 * @param target The target display object.
		 * @param rect The rectangle you wish to size.
		 */
		public static function resizeToDisplayObject(target : DisplayObject, rect : DisplayObject) : void
		{
			target.width = rect.width;
			target.height = rect.height;
			target.x = rect.x;
			target.y = rect.y;
		}

		/**
		 * Resizes and positions a display object to the dimensions of a rectangle.
		 * @param target The target display object.
		 * @param rect The rectangle you wish to size.
		 */
		public static function resizeToRect(target : DisplayObject, rect : Rectangle) : void
		{
			target.width = rect.width;
			target.height = rect.height;
			target.x = rect.x;
			target.y = rect.y;
		}

		/**
		 * Returns the proportionally scaled width and height of a display down so that
		 * the largest side is set to the maxSize.
		 * @param target The DisplayObject you wish to make into a thumbnail.
		 * @param maxSize The maximum dimension of the largest side of the resulting <code>Rectangle</code>.
		 */
		public static function getThumbnailDimensions(target : DisplayObject, maxSize : Number) : Rectangle
		{
			var ratio : Number = getRatio( target, maxSize );
			return new Rectangle( 0, 0, target.width * ratio, target.height * ratio );
		}

		/**
		 * Calculates the ratio required to resized the target DisplayObject such that
		 * neither its width or height is larger than the targetSize.
		 * @param target The target DisplayObject to generate the ratio from.
		 * @param targetSize The smallest size for either the width or height.
		 * @return The ratio required to resize the width and height of the rectangle 
		 * 		   such that it fits inside of targetSize
		 */
		public static function getRatio(target : DisplayObject, targetSize : Number) : Number
		{
			return getRectRatio( rectFromDisplayObject( target ), targetSize );
		}

		/**
		 * Calculates the ratio required to resized the target rectangle such that
		 * neither its width or height is larger than the targetSize.
		 * @param target The target rectangle to generate the ratio from.
		 * @param targetSize The smallest size for either the width or height.
		 * @return The ratio required to resize the width and height of the rectangle 
		 * 		   such that it fits inside of targetSize
		 */
		public static function getRectRatio(target : Rectangle, targetSize : Number) : Number
		{
			var ratio : Number = 1;
			if( target.width > target.height )
				ratio = targetSize / target.width;
			else if( target.height > target.width )
				ratio = targetSize / target.height;
			else if ( target.height == target.width )
				ratio = targetSize / target.height;
			return ratio;
		}

		/**
		 * Limits a display object to the bounding rectangle.
		 * @param target The display object whose position you wish to limit.
		 * @param bounds The bounding rectangle to limit the DisplayObject with.
		 */
		public static function limitBounds(target : DisplayObject, bounds : Rectangle) : void
		{
			if(target.x < bounds.x)
				target.x = bounds.x;
			if(target.x + target.width > bounds.x + bounds.width)
				target.x = bounds.x + bounds.width - target.width;

			if(target.y < bounds.y)
				target.y = bounds.y;
			if(target.y + target.height > bounds.y + bounds.height)
				target.y = bounds.y + bounds.height - target.height;
		}

		/**
		 * Resizes a rectangle to the bounds of another. The ratio of the rectangle
		 * will not change, but the width, height and possibly x/y will.
		 * @param target The rectangle to resize.
		 * @param bounds The bounds the rectangle should fit in to.
		 */
		public static function fitIn(target : Rectangle, bounds : Rectangle) : Rectangle
		{
			target = target.clone();

			var wD : Number = target.width;
			var hD : Number = target.height;

			var wR : Number = bounds.width;
			var hR : Number = bounds.height;

			var sX : Number = wR / wD;
			var sY : Number = hR / hD;

			var rD : Number = wD / hD;
			var rR : Number = wR / hR;

			var sH : Number = sX;
			var sV : Number = sY;

			var s : Number = rD >= rR ? sH : sV;
			s = s > 1 ? 1 : s;
			var w : Number = wD * s;
			var h : Number = hD * s;

			target.width = w;
			target.height = h;

			var constrain : Point = constrain( new Point( target.x, target.y ), bounds );
			target.x = constrain.x;
			target.y = constrain.y;

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

		/**
		 * Constrains a point to the bounds of a rectangle. This method acts
		 * directly on the point and also returns it (it does not create a new point).
		 * @param pt The point to constrain.
		 * @param rect The rectangle to constrain the bounds to.
		 * @return A point constrained to the rectangle.
		 */
		public static function constrain(pt : Point, rect : Rectangle) : Point
		{
			if (pt.x < rect.x)
			{
				pt.x = rect.x;
			}
			else if (pt.x > rect.x + rect.width)
			{
				pt.x = rect.x + rect.width;
			}

			if (pt.y < rect.y)
			{
				pt.y = rect.y;
			}
			else if (pt.y > rect.y + rect.height)
			{
				pt.y = rect.y + rect.height;
			}

			return pt;
		}

		/**
		 * Expands the rectangle on all sides by the given size. This method acts
		 * directly on the rectangle and does not clone it.
		 * @param rect The rectangle you wish to expand.
		 * @param size The size by which you want to expand all sides.
		 * @return The expanded rectangle.
		 */
		public static function expand(rect : Rectangle, size : int) : Rectangle
		{
			rect.x -= size / 2;
			rect.y -= size / 2;

			rect.width += size;
			rect.height += size;

			return rect;
		}

		/**
		 * Resizes and positions a target DisplayObject relative to the bounding Rectangle.
		 * The target will fit inside the bounding object and be centered.
		 * @param _target The DisplayObject to resize and position
		 * @param _bounds The Rectangle to resize and position the target relative to.
		 */
		public static function resizeToRectAndCenter(_target : DisplayObject, _bounds : Rectangle) : void
		{
			var targetSize : Rectangle = RectUtil.rectFromDisplayObject( _target );

			var target : Rectangle = RectUtil.fitIn( targetSize, _bounds );
			RectUtil.resizeToRect( _target, target );

			_target.x = _bounds.width / 2 - _target.width / 2;
			_target.y = _bounds.height / 2 - _target.height / 2;
		}
		
		public static function resizeRectAndCenter(_target : Rectangle, _bounds : Rectangle) : Rectangle
		{
			var target : Rectangle = RectUtil.fitIn( _target, _bounds );

			target.x = _bounds.width / 2 - target.width / 2;
			target.y = _bounds.height / 2 - target.height / 2;
			
			return target;
		}
		
		/**
		 * returns closest point on a rectangle to a given point.
		 * @param pnt The point to test rect with.
		 * @param rect The rectangle to measure distance to.
		 * @param contains Flag for checking if point is inside rectangle.
		 * @return The point within rectangle.
		 */
		public static function closestPointToRect(pnt:Point, rect:Rectangle, contains:Boolean = true):Point
		{
			if( contains && rect.containsPoint(pnt) )
				return pnt;
			
			var left:Point = closestPointToLine(pnt, new Point(rect.left, rect.top), new Point(rect.left, rect.bottom));
			var top:Point = closestPointToLine(pnt, new Point(rect.left, rect.top), new Point(rect.right, rect.top));
			var right:Point = closestPointToLine(pnt, new Point(rect.right, rect.top), new Point(rect.right, rect.bottom));
			var bottom:Point = closestPointToLine(pnt, new Point(rect.left, rect.bottom), new Point(rect.right, rect.bottom));
			
			var closest : Point;
			var dist : Number = int.MAX_VALUE;
			
			if(Point.distance(pnt, left) < dist)
			{
				closest = left;
				dist = Point.distance(pnt, left);
			}
			if(Point.distance(pnt, right) < dist)
			{
				closest = right;
				dist = Point.distance(pnt, right);
			}
			if(Point.distance(pnt, top) < dist)
			{
				closest = top;
				dist = Point.distance(pnt, top);
			}
			if(Point.distance(pnt, bottom) < dist)
			{
				closest = bottom;
				dist = Point.distance(pnt, bottom);
			}
			
			return closest;
		}
		
		/**
		 * returns closest point on a line to a given point.
		 * @param pnt The point to test line with.
		 * @param A Starting point of line segment.
		 * @param B Ending point of line segment.
		 * @return The point along line.
		 */
		public static function closestPointToLine( pt:Point, A:Point, B:Point ):Point
		{			
			var closest:Point;
			
			var offset:Number = NumberUtils.dotProduct( pt, A.subtract(B) );
			var segment:Number = Point.distance(A, B);
			
			if( offset <= 0 )  //point is past A
			{
			    closest = A;  
			}
			else if( offset >= segment ) //point is past B
			{
			    closest = B;
			}
			else 
			{
				var offsetInv:Number = offset/segment;
				var sec:Point = new Point( B.x * offsetInv, B.y * offsetInv );
				closest = A.add(sec);
			}
			
			return closest;
		}
		
		public static function lineIntersectLine(A:Point, B:Point, C:Point, D:Point):Point
		{
			var cross:Point = new Point();
			
			var AB_slope:Number = (B.y - A.y)/(B.x - A.x);
			var CD_slope:Number = (D.y - C.y)/(D.x - C.x);
			
			var AB_incp:Number = (AB_slope * A.x) + A.y;
			var CD_incp:Number = (CD_slope * C.x) + C.y;
			
			cross.x = ((CD_slope * A.x) + CD_incp) - (AB_slope * A.x) - AB_incp;
			cross.y = (CD_slope * cross.x) + CD_incp;
			
			return cross;
		}
	}
}
