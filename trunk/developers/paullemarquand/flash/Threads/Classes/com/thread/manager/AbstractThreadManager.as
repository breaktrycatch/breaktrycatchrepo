package com.thread.manager 
{
	import com.thread.Thread;
	import com.thread.constant.ThreadConstants;
	import com.thread.factory.ThreadFactory;
	import com.thread.motion.IComponent;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;	

	/**
	 * @author Paul
	 */
	public class AbstractThreadManager extends Sprite implements IComponent 
	{
		protected var _threads : Vector.<Thread>;
		protected var _canvas : BitmapData;
		protected var _drawTransform : Matrix;
		protected var _threadFactory : ThreadFactory;

		public function AbstractThreadManager( canvas : BitmapData, enforcer : AbstractThreadManager )
		{
			enforcer = null;
			_canvas = canvas;
			_threads = new Vector.<Thread>( );
			_drawTransform = new Matrix( );
			_threadFactory = new ThreadFactory( );
			
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
			_threads.push( addChild( _threadFactory.getSimpleThread( ) ) );
		}
		
		public function update() : void
		{
			for (var i : Number = _threads.length - 1; i >= 0 ; i--) 
			{
				_threads[i].setWorldData( _threads, i );
				_threads[i].update( );
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
	}
}
