package com.thread
{
	import com.breaktrycatch.bitmap.PNGSnapshot;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.constant.ThreadConstants;
	import com.thread.manager.AbstractThreadManager;
	import com.thread.manager.ThreadManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Paul
	 */
	public class ThreadContainer extends Sprite 
	{
		private var _canvas : BitmapData;
		private var _threadManagers : Array;
		private var _timer : Timer;
		private var _bgData : BitmapData;
		private var _ctr : int = 0;
		private var _numSavedImages : int = 0;
		private var FILENAME_PREPEND : String;

		public function ThreadContainer(sW : Number, sH : Number)
		{	
			FILENAME_PREPEND = getFilenamePrepend();
			
			_canvas = new BitmapData( sW, sH, true, uint( (0xFF) << 24 ) | ThreadConstants.BG_COLOUR );
			addChild( new Bitmap( _canvas ) );
			
			_bgData = new BitmapData( sW, sH, true, (ThreadConstants.CLEAR_AMOUNT * 255) << 24 | ThreadConstants.BG_COLOUR );
			_threadManagers = [];
			
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemoved );
		}
		
		public function reset() : void
		{
			_timer.stop( );
			
			ArrayExtensions.executeCallbackOnArray( _threadManagers, 'dispose' );
			
			_canvas.fillRect( _canvas.rect, uint( (0xFF) << 24 ) | ThreadConstants.BG_COLOUR );
			_threadManagers = [];
			
			createThreadManagers();
			
			_timer.start();
		}
		
		public function takeSnapshot() : void
		{
			_numSavedImages++;
			
			var filename : String = FILENAME_PREPEND + _numSavedImages;
			var snap : PNGSnapshot = new PNGSnapshot( );
			snap.saveData( _canvas, filename );
		}
		
		private function getFilenamePrepend() : String
		{
			var date : Date = new Date();
			var time : String = date.toLocaleTimeString().replace(/:/g, "_").replace(/ /g, "_");
			var day : String = date.toDateString().replace(/ /g, "_");
			return day + "_" + time + "_";
		}

		private function createThreadManagers() : void
		{
			for(var i : uint = 0; i < ThreadConstants.GRID_WIDTH * ThreadConstants.GRID_HEIGHT ; i++)
			{
				var threadManager : AbstractThreadManager = new ThreadManager( _canvas );
				threadManager.x = (i % ThreadConstants.GRID_WIDTH) * ThreadConstants.MANAGER_WIDTH;
				threadManager.y = Math.floor( i / ThreadConstants.GRID_HEIGHT ) * ThreadConstants.MANAGER_HEIGHT;
				_threadManagers.push( threadManager );
			}
		}

		private function onAdded(event : Event) : void
		{
			createThreadManagers();
			
			_timer = new Timer( 1 );
			_timer.addEventListener( TimerEvent.TIMER, onTimer );
			_timer.start( );
		}

		private function onTimer(e : TimerEvent) : void
		{
			update( );
			draw( );	
		}

		private function onRemoved(event : Event) : void
		{
			_timer.stop( );
		}

		private function update() : void
		{
			for (var i : Number = 0; i < _threadManagers.length ; i++) 
			{
				_threadManagers[i].update( );
			}
		}

		private function draw() : void
		{
			for (var i : Number = 0; i < _threadManagers.length ; i++) 
			{
				_threadManagers[i].draw( );
			}
			
			if(_ctr % ThreadConstants.CLEAR_INTERVAL == 0)
			{
				_canvas.draw( _bgData );
			}
			_ctr++;
		}
	}
}
