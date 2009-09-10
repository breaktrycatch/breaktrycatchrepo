package com.thread.draw 
{
	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;
	import com.thread.motion.IMotionable;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;	

	/**
	 * @author Paul
	 */
	public class LibraryItemDrawer extends AbstractDrawer implements IDrawer 
	{
		private var _clip : MovieClip;

		public function LibraryItemDrawer()
		{
			super( this );
		}

		override public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			if(_clip)
			{
				_clip.parent.removeChild( _clip );
			}
			var cls : Class = getDefinitionByName( "DrawClip1" ) as Class;
			_clip = new cls( );
			
			
			drawTarget.transform.colorTransform.color = 0xff00ff;
			
			drawTarget.addChild( _clip );
			_clip.x = d.x;
			_clip.y = d.y;
		}
	}
}
