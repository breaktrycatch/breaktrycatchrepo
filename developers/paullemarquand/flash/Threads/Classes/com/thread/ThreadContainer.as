package com.thread
{

	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.constant.ThreadConstants;
	import com.thread.manager.AbstractThreadManager;
	import com.thread.manager.ThreadManager;
	import com.util.FileUtil;
	import com.util.IntervalUpdater;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Paul
	 */
	public class ThreadContainer extends Sprite
	{
		private var _canvas : BitmapData;
		private var _threadManagers : Array = [];
		private var _timer : Timer;
		private var _bgData : BitmapData;
		private var _numSavedImages : int = 0;
		private var _canvasClearUpdater : IntervalUpdater;

		public function ThreadContainer(sW : Number, sH : Number)
		{
			ThreadConstants.initialize( sW, sH );

			_canvasClearUpdater = new IntervalUpdater( ThreadConstants.CLEAR_INTERVAL, clearCanvas );
			_bgData = new BitmapData( sW, sH, true, (ThreadConstants.CLEAR_AMOUNT * 255) << 24 | ThreadConstants.BG_COLOUR );

			_canvas = new BitmapData( sW, sH, true, uint( (0xFF) << 24 ) | ThreadConstants.BG_COLOUR );
			addChild( new Bitmap( _canvas ) );

			reset();
		}

		public function reset() : void
		{
			if (_timer)
			{
				_timer.removeEventListener( TimerEvent.TIMER, onTimer );
				_timer.stop();
				_timer = null;
			}

			ArrayExtensions.executeCallbackOnArray( _threadManagers, 'dispose' );

			_canvas.fillRect( _canvas.rect, uint( (0xFF) << 24 ) | ThreadConstants.BG_COLOUR );
			_threadManagers = [];

			createThreadManagers();

			_timer = new Timer( 1 );
			_timer.addEventListener( TimerEvent.TIMER, onTimer );
			_timer.start();
		}

		public function takeSnapshot() : void
		{
			FileUtil.saveUniquePNG( _canvas, ++ _numSavedImages + ".png" );
		}

		private function createThreadManagers() : void
		{
			for (var y : uint = 0; y < ThreadConstants.GRID_HEIGHT ; y++)
			{
				for (var x : int = 0; x < ThreadConstants.GRID_WIDTH; x++)
				{
					for(var i : int = 0; i < ThreadConstants.MANAGERS_PER_GRID; i++)
					{
						var threadManager : AbstractThreadManager = new ThreadManager( _canvas );
						threadManager.x = ThreadConstants.MARGIN_X + (x * ThreadConstants.MANAGER_WIDTH) + (ThreadConstants.MARGIN_X * x * 2);
						threadManager.y = ThreadConstants.MARGIN_Y + (y * ThreadConstants.MANAGER_HEIGHT ) + (ThreadConstants.MARGIN_Y * y * 2 );
						_threadManagers.push( threadManager );
					}
				}
			}
		}

		private function onTimer(e : TimerEvent) : void
		{
			update();
		}

		private function update() : void
		{
			for (var i : Number = 0; i < _threadManagers.length ; i++)
			{
				var manager : ThreadManager = _threadManagers[i];
				manager.update();
				manager.draw();
			}

			_canvasClearUpdater.update();
		}

		private function clearCanvas() : void
		{
			_canvas.draw( _bgData );
		}
	}
}
