package com.thread.manager 
{
	import com.thread.Thread;
	import com.thread.constant.ThreadConstants;
	import com.thread.manager.AbstractThreadManager;
	import com.thread.motion.IComponent;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * @author Paul
	 */
	public class FontDrawThreadManager extends AbstractThreadManager implements IComponent 
	{
		private var _text : String;
		private var _font : String;
		private var _textField : TextField;
		private var _testData : BitmapData;

		public function FontDrawThreadManager(canvas : BitmapData, text : String, font : String)
		{
			_text = text;
			_font = font;
			_textField = new TextField( );
			_textField.text = _text;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			
			var format : TextFormat = new TextFormat( );
			format.font = _font;
			format.color = 0xff00ff;
			format.size = 100;
			_textField.setTextFormat( format );
			
			var fontTransform : Matrix = new Matrix( );
			var scale : Number = ThreadConstants.MANAGER_WIDTH / (_textField.textWidth + 20);
			fontTransform.scale( scale, scale );
			fontTransform.tx = (( ThreadConstants.MANAGER_WIDTH - _textField.textWidth * scale ) / 2 );
			fontTransform.ty = (( ThreadConstants.MANAGER_HEIGHT - _textField.textHeight* scale) / 2 ); 
			
			_testData = new BitmapData( ThreadConstants.MANAGER_WIDTH, ThreadConstants.MANAGER_HEIGHT, true, 0xff000000 );
			_testData.draw( _textField, fontTransform );
			
			super( canvas, this );
		}

		override protected function addThread() : void
		{
			_threads.push( addChild( _threadFactory.getAlphabetThread( _testData ) ) );
		}

		override public function update() : void
		{
			super.update( );
		}

		override public function draw() : void
		{
			//_canvas.draw( _testData, _drawTransform )
			super.draw( );
		}
	}
}
