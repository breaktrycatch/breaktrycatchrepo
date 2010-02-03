package com.humans.utils {
	import com.humans.utils.elements.BitmapLoaderInstance;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author plemarquand
	 */
	public class BitmapUtils extends EventDispatcher {
		
		public function BitmapUtils() {
		}
		
		public static function loadBitmap(_url:String, _handlerSuccessFunction:Function = null, _handlerErrorFunction:Function = null, _handlerProgressFunction:Function = null):BitmapLoaderInstance {
			return (new BitmapLoaderInstance(_url, _handlerSuccessFunction, _handlerErrorFunction, _handlerProgressFunction));
		}
		
		/**
		 * Takes a BitmapData object and returns a transparent copy of it.
		 * 
		 * @param bitmap A BitmapData object to make transparent.
		 */
		public static function makeBitmapTransparent( bitmap : BitmapData ) : BitmapData
		{
			if( bitmap.transparent )
				return bitmap;
			
			var trans : BitmapData = new BitmapData(bitmap.width, bitmap.height, true);
			trans.draw(bitmap);
			
			return trans;
		}

		/**
		 * Takes a <code>BitmapData</code> object and returns a resized copy of it.
		 * It resizes the bitmap based on the <code>maxWidth</code> and <code>maxHeight</code>
		 * parameters, taking the larger dimension and sizing it to the appropriate maximum value.
		 * 
		 * @param data		<BitmapData>	The bitmapdata you wish to make into a thumbnail.
		 * @param maxSize 	<Number>		The maximum dimension of the largest side of the resulting thumbnail.
		 */
		public static function makeThumbnail( data : BitmapData, maxSize : Number, smoothing : Boolean = false  ) : BitmapData
		{
			var ratio : Number = sizeToRatio(data.width, data.height, maxSize);
			var m : Matrix = new Matrix();
			m.scale(ratio, ratio);
			
			var thumbData : BitmapData = new BitmapData(data.width * ratio, data.height * ratio, data.transparent);
			thumbData.draw(data, m, null, null, null, smoothing);
			
			return thumbData;
		}

		/**
		 * Returns the proportionally scaled width and height of a bitmap down so that
		 * the largest side is set to the maxSize.
		 * 
		 * @param data		<BitmapData>	The bitmapdata you wish to make into a thumbnail.
		 * @param maxSize 	<Number>		The maximum dimension of the largest side of the resulting <code>Rectangle</code>.
		 */
		public static function getThumbnailDimensions( data : BitmapData, maxSize : Number ) : Rectangle
		{
			var ratio : Number = 1;
			
			if( data.width > data.height && data.width > maxSize )
				ratio = maxSize / data.width;	
			else if( data.height > data.width && data.height > maxSize )
				ratio = maxSize / data.height;
			else if ( data.height == data.width && data.height > maxSize )
				ratio = maxSize / data.height;
				
			return new Rectangle(0, 0, data.width * ratio, data.height * ratio);
		}

		/**
		 * Creates a Bitmap object from the supplied DisplayObject. The Bitmap's
		 * dimensions match those of the bounds the movieclip.
		 * 
		 * @param target	<DisplayObject>	The display object you wish to convert to a Bitmap.
		 */
		public static function createBitmapFromDisplayObject(target : DisplayObject, scale : Number = 1) : Bitmap
		{
			var data : BitmapData;
			if(target.width == 0 || target.height == 0)
			{
				data = new BitmapData(1, 1, true, 0);
			}
			else
			{
				var bounds : Rectangle = target.getBounds(target);
				var matrix : Matrix = new Matrix();

				matrix.scale(scale, scale);
				var w : Number = target.width * scale + 1;
				var h : Number = target.height * scale + 1;
				data = new BitmapData(w, h, true, 0);
				matrix.tx -= bounds.x * scale;
				matrix.ty -= bounds.y * scale;
				data.draw(target, matrix);
			}
			return new Bitmap(data);
		}
		
		public static function getResizeRatio(width : Number, height : Number, maxSize : Number) : Number
		{
			var ratio : Number = 1;
			
			if( width >= height && width >= maxSize )
			{
				ratio = maxSize / width;
			} 
			else if( height >= width && height >= maxSize )
			{
				ratio = maxSize / height;
			}
			return ratio;
		}
		
		public static function getUpsizeRatio(width : Number, height : Number, targetSize : Number) : Number
		{
			var ratio : Number = 1;
			
			if( width >= height && width <= targetSize )
			{
				ratio = targetSize / width;
			} 
			else if( height >= width && height <= targetSize )
			{
				ratio = targetSize / width;
			}
			return ratio;
		}
		
		public static function sizeToRatio(width : Number, height : Number, targetSize : Number) : Number
		{
			if(width <= targetSize && height <= targetSize)
			{
				return getUpsizeRatio(width, height, targetSize);
			}
			else
			{
				return BitmapUtils.getResizeRatio(width, height, targetSize);
			}
		}
	}
}
