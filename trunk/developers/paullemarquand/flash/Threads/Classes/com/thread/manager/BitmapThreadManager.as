package com.thread.manager
{

	import org.swiftsuspenders.Injector;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author plemarquand
	 */
	public class BitmapThreadManager extends AbstractThreadManager
	{
		public function BitmapThreadManager(drawTarget : Sprite, canvas : BitmapData, stage : Stage)
		{
			var injector : Injector = new Injector();
			injector.mapValue( BitmapData, useValue );

			super( drawTarget, canvas, stage );
		}
	}
}
