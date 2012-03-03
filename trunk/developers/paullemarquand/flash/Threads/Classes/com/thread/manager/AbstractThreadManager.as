package com.thread.manager
{

	import com.util.Profiler;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.Thread;
	import com.thread.constant.ThreadConstants;
	import com.thread.factory.RandomThreadFactory;
	import com.thread.vo.IDisposable;
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
		private var _profiler : Profiler;
		private var __counter : Number = 0;

		public function AbstractThreadManager(canvas : BitmapData, enforcer : AbstractThreadManager)
		{
			enforcer = null;
			_canvas = canvas;
			_threads = new Array();
			_drawTransform = new Matrix();
			_profiler = new Profiler();
			_threadFactory = new RandomThreadFactory( _profiler );

			createThreads();
			createTransformMatrix();
		}

		public function removeThread() : void
		{
			if (_threads.length == 0)
				return;

			var firstThread : Thread = _threads[0];
			ArrayExtensions.removeElementFromArray( _threads, firstThread );
		}

		protected function createThreads() : void
		{
			for (var i : Number = 0; i < ThreadConstants.START_THREADS ; i++)
			{
				addThread();
			}
		}

		public function addThread() : void
		{
			var thread : Thread = _threadFactory.getThread();
			addChild( thread );
			_threads.push( thread );

			// TODO: HACK!!! only for the right angle follow agents.
			if (_threads.length <= 2)
			{
				thread.data.lineAlpha = 0;
			}
		}

		public function update() : void
		{
			_profiler.start( "AbstractThreadManager.update()" );
			for (var i : Number = _threads.length - 1; i >= 0 ; i--)
			{
				var thread : Thread = _threads[i];
				
				if (! thread.isDead)
				{
					thread.setWorldData( _threads, i );
					thread.update();
				}
			}
			_profiler.stop( "AbstractThreadManager.update()" );
			
			__counter++;
			if(__counter == 200)
				_profiler.showResults();
		}

		public function draw() : void
		{
			_profiler.start("AbstractThreadManager.draw()");
			for (var i : Number = _threads.length - 1; i >= 0 ; i--)
			{
				Thread( _threads[i] ).draw();
			}

			_canvas.draw( this, _drawTransform );
			_profiler.stop("AbstractThreadManager.draw()");
		}

		private function createTransformMatrix() : void
		{
			_drawTransform.tx = x;
			_drawTransform.ty = y;
		}

		override public function set x(n : Number) : void
		{
			super.x = n;
			createTransformMatrix();
		}

		override public function set y(n : Number) : void
		{
			super.y = n;
			createTransformMatrix();
		}

		public function dispose() : void
		{
			ArrayExtensions.executeCallbackOnArray( _threads, 'dispose' );
		}
	}
}
