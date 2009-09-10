/**
 * @author         Paul LeMarquand
 * @published      March, 2007
 * @playerversion  Flash 9.0.16.0
 * 
 * <p>This Class performs colour tweens as well as provides a set of static methods for colour space transformations.</p>
 */

package com.breaktrycatch.color 
{
	import flash.events.EventDispatcher;	

	public class ColorUtil extends flash.events.EventDispatcher 
	{
		public static function generateMonochromeColorScheme(col : Number, colorInc : Number, numElements : Number) : Array 
		{
			var colorArr : Array = new Array( numElements );
			var colObj : ColorObject = ColorSpaceTransformations.HEXtoRGB( col );
			
			var multiplier : Number = -numElements / 2;
			for(var i : Number = 0; i < numElements ;i++)
			{
				colorArr[i] = ColorSpaceTransformations.RGBtoHEX( ColorUtil.ensureRGBBounds( colObj.r + colorInc * multiplier ), ColorUtil.ensureRGBBounds( colObj.g + colorInc * multiplier ), ColorUtil.ensureRGBBounds( colObj.b + colorInc * multiplier ) );
				multiplier++;
			}
			return colorArr;
		}

		public static function ensureRGBBounds(n : Number) : Number
		{
			if(n < 0) n = 0;
			if(n > 255) n = 255;
			return n;
		}

		public static function blendRGB(c1 : Number, c2 : Number, t : Number) : Number 
		{
			t = constrain(t, 0, 1);
			var obj1 : ColorObject = ColorSpaceTransformations.HEXtoRGB( c1 );
			var obj2 : ColorObject = ColorSpaceTransformations.HEXtoRGB( c2 );
			var ct : Number = (obj1.r + (obj2.r - obj1.r) * t) << 16 | (obj1.g + (obj2.g - obj1.g) * t) << 8 | (obj1.b + (obj2.b - obj1.b) * t);
			return ct;
		} 
		
		public static function RGBtoHexGrayScale(col : Number) : Number 
		{
			var colObj : ColorObject = ColorSpaceTransformations.HEXtoRGB( col );
			colObj.r = 0.299 * colObj.r;
			colObj.g = 0.587 * colObj.g;
			colObj.b = 0.114 * colObj.b;
			return colObj.r + colObj.g + colObj.b;
		}

		public static function getLuminocity(col : Number) : Number 
		{
			var colObj : ColorObject = ColorSpaceTransformations.HEXtoRGB( col );
			return (colObj.b + colObj.r + colObj.g) / 3;
		}
		
		/**
		 * Constrains a number between a given range
		 * @param num The number to constrain
		 * @param min The minimum number in the range
		 * @param max The maximum number in the range
		 * @return The constrained number
		 */
		public static function constrain( num:Number, min:Number, max:Number ):Number
		{
			return( Math.max( min, Math.min( num, max ) ) );
		}
		
		/*
		
		public function fastRGB(obj, r, g, b) {
			if (!isNaN(r) && !isNaN(g) && !isNaN(b) && r<256 && r>=0 && g<256 && g>=0 && b<256 && b>=0) {
				r = r<<16;
				g = g<<8;
				b = b;
				var rgb:Number = r|g|b;
				col = new Color(obj);
				col.setRGB(rgb);
			} 
		}

		public function fastRGBA(obj,ra,rb,ga,gb,ba,bb,aa,ab){
			if(arguments.length<9){
				return false;
			}
			var x=1;
			while(x<arguments.length){
				if(isNaN(arguments[x++])){
					return false;
				}
			}
			if (ra<=100 && ga<=100 && ba<=100 && aa<=100 && ra>=-100 && ga>=-100 && ba>=-100 && aa>=-100 && rb<=255 && gb<=255 && bb<=255 && ab<=255 && rb>=-255 && gb>=-255 && bb>=-255 && ab>=-255){
				var thisColor:Object ={ra:ra,rb:rb,ga:ga,gb:gb,ba:ba,bb:bb,aa:aa,ab:ab};
				
				col = new Color(obj);
				col.setTransform(thisColor);
				return true;
			} else {
				return false;
			}
		}

		public static function blendRGB(obj, c1, c2, t):Number {
			var col:Color;
			if (t<-1) t=-1;
			else if (t>1) t=1;
			if (t<0) t=1+t;
			c1 = HEXtoRGB(c1);
			c2 = HEXtoRGB(c2);
			var ct = (c1.rb+(c2.rb-c1.rb)*t) << 16 | (c1.gb+(c2.gb-c1.gb)*t) << 8 | (c1.bb+(c2.bb-c1.bb)*t);
			col = new Color(obj);
			col.setRGB(ct);
			return ct;
		} /*
		
		public static function setTint(obj:Object, HEXcol:Number, amount:Number) {
			var rgbcol = ColorManager.HEXtoRGB(HEXcol);
			
			var percent = 100 - amount;
			var trans = new Object();
			trans.ra = trans.ga = trans.ba = percent;
			var ratio = amount / 100;
			trans.rb = rgbcol.rb * ratio;
			trans.gb = rgbcol.gb * ratio;
			trans.bb = rgbcol.bb * ratio;
			var col:Color = new Color(obj);
			col.setTransform(trans);
		}*/
	}
}