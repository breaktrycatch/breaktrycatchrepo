package com.thread
{
	import com.breaktrycatch.bitmap.PNGSnapshot;
	import com.breaktrycatch.module_autoui.AutoUIPanel;
	import com.thread.constant.ThreadConstants;
	import com.thread.factory.ThreadFactory;
	import com.thread.manager.AbstractThreadManager;
	import com.thread.manager.ThreadManager;
	import com.thread.motion.IComponent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Paul
	 */
	public class ThreadContainer extends Sprite 
	{
		private var _canvas : BitmapData;
		private var _threadManagers : Vector.<IComponent>;
		private var _timer : Timer;
		private var _bgData : BitmapData;
		private var _ctr : int;
		private var _panels : Vector.<AutoUIPanel>;
		private var _ticks : int = 0;
		private var FILENAME_PREPEND : String;
		
		private const alphabet : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ...................";

		public function ThreadContainer(sW : Number, sH : Number)
		{	
			FILENAME_PREPEND = getFilenamePrepend();
			
			_canvas = new BitmapData( sW, sH, true, uint( (0xFF) << 24 ) | ThreadConstants.BG_COLOUR );
			addChild( new Bitmap( _canvas ) );
			
			_bgData = new BitmapData( sW, sH, true, (ThreadConstants.CLEAR_AMOUNT * 255) << 24 | ThreadConstants.BG_COLOUR );
			_threadManagers = new Vector.<IComponent>( );
			_ctr = 0;
			
			createPanels( );
			
			addEventListener( MouseEvent.CLICK, onTakeSnapshot );
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemoved );
		}
		
		private function getFilenamePrepend() : String
		{
			var date : Date = new Date();
			var time : String = date.toLocaleTimeString().replace(/:/g, "_").replace(/ /g, "_");
			var day : String = date.toDateString().replace(/ /g, "_");
			return day + "_" + time + "_";
		}

		private function onTakeSnapshot(event : MouseEvent) : void
		{
			var filename : String = FILENAME_PREPEND + _ticks;
			trace("FILENAME: " + filename)
			var snap : PNGSnapshot = new PNGSnapshot( );
			snap.saveData( _canvas, filename );
			_ticks++;
		}

		private function createPanels() : void
		{
			_panels = new Vector.<AutoUIPanel>( );
			var factory : ThreadFactory = new ThreadFactory( );
			var sampleThread : Thread = factory.getSimpleThread( );
			
			//var panel : AutoUIPanel = new AutoUIPanel();
			//panel.create( sampleThread. );
		}

		private function onAdded(event : Event) : void
		{
			for(var i : uint = 0; i < ThreadConstants.GRID_WIDTH * ThreadConstants.GRID_HEIGHT ; i++)
			{
				//var threadManager : AbstractThreadManager = new FontDrawThreadManager( _canvas, alphabet.substr(i, 1), "Arial Black" );
				var threadManager : AbstractThreadManager = new ThreadManager( _canvas );
				threadManager.x = (i % ThreadConstants.GRID_WIDTH) * ThreadConstants.MANAGER_WIDTH;
				threadManager.y = Math.floor( i / ThreadConstants.GRID_HEIGHT ) * ThreadConstants.MANAGER_HEIGHT;
				_threadManagers.push( threadManager );
				
				ThreadConstants.GROSS_GLOBAL_HACK++;
			}
			
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
