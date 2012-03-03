package com.util
{

	import flash.text.TextFormat;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	/**
	 * @author plemarquand
	 */
	public class PromptUtil
	{
		public static function confirm(container : DisplayObjectContainer, onReset : Function, warningText : String = null) : void
		{
			var warning : TextField = new TextField();
			warning.text = warningText || "About to reset. Are you sure? Y/N";
			
			warning.x = container.stage.stageWidth / 2 - warning.textWidth / 2;
			warning.y = container.stage.stageHeight / 2 - warning.textHeight / 2;
			warning.width = container.stage.stageWidth;
			warning.height = container.stage.stageHeight;

			var format : TextFormat = new TextFormat();
			format.color = 0xff00ff;
			format.size = 16;
			warning.setTextFormat( format );
			
			container.stage.addEventListener( KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent) : void
			{
				if (e.keyCode == Keyboard.Y)
				{
					container.removeChild( warning );
					onReset();
				}
				else if (e.keyCode == Keyboard.N)
				{
					container.removeChild( warning );
					(e.target as IEventDispatcher).removeEventListener( KeyboardEvent.KEY_DOWN, arguments['callee'] );
				}
			} );
			container.addChild( warning );
		}
	}
}
