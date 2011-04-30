package com.thread.manager 
{
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.vo.IDisposable;
	import com.thread.Thread;
	import com.thread.constant.ThreadConstants;
	import com.thread.factory.RandomThreadFactory;
	import com.thread.vo.IVisualComponent;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * @author Paul
	 */
	public class AbstractThreadManager extends Sprite implements IVisualComponent, IDisposable 
	{
		protected var _threads : Array;
		protected var _canvas : BitmapData;
		protected var _drawTransform : Matrix;
		protected var _threadFactory : RandomThreadFactory;

		public function AbstractThreadManager( canvas : BitmapData, enforcer : AbstractThreadManager )
		{
			enforcer = null;
			_canvas = canvas;
			_threads = new Array();
			_drawTransform = new Matrix( );
			_threadFactory = new RandomThreadFactory( );
			
			createThreads( );
			createTransformMatrix( );
		}
		
		protected function createThreads() : void
		{
			for (var i : Number = 0; i < ThreadConstants.START_THREADS ; i++) 
			{
				addThread( );
			}
		}
		
		protected function addThread() : void
		{
			_threads.push( addChild( _threadFactory.getThread() ) );
			
			//TODO: HACK!!! only for the right angle follow agents.
			if(_threads.length == 1)
			{
				Thread(_threads[0]).vo.lineAlpha = 0;
			}
		}
		
		public function update() : void
		{
			for (var i : Number = _threads.length - 1; i >= 0 ; i--) 
			{
				var thread : Thread = _threads[i];
				thread.setWorldData( _threads, i );
				thread.update( );
			}
		}
		
		public function draw() : void
		{
			for (var i : Number = _threads.length - 1; i >= 0 ; i--) 
			{
				Thread( _threads[i] ).draw( );
			}
			
			_canvas.draw( this, _drawTransform );
		}
		
		private function createTransformMatrix() : void
		{
			_drawTransform.tx = x;
			_drawTransform.ty = y;	
		}
		
		override public function set x(n : Number) : void
		{
			super.x = n;
			createTransformMatrix( );
		}
		
		override public function set y(n : Number) : void
		{
			super.y = n;
			createTransformMatrix( );
		}
		
		public function dispose() : void
		{
			ArrayExtensions.executeCallbackOnArray(_threads, 'dispose');
		}
	}
}
