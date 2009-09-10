package com.thread.factory 
{
	import com.thread.motion.bounds.ContinuationBoundsChecker;	
	import com.thread.Thread;
	import com.thread.ai.BitmapFollowAgent;
	import com.thread.ai.FollowAgent;
	import com.thread.ai.IAgent;
	import com.thread.ai.SimpleAgent;
	import com.thread.color.IColorSupplier;
	import com.thread.color.KulerColorSupplier;
	import com.thread.constant.ThreadConstants;
	import com.thread.draw.IDrawer;
	import com.thread.draw.SimpleDrawer;
	import com.thread.line.IDrawStyle;
	import com.thread.line.SimpleLine;
	import com.thread.line.SizedAlphaLine;
	import com.thread.motion.bounds.BounceBoundsChecker;
	import com.thread.motion.bounds.IBoundsChecker;
	import com.thread.vo.ThreadDataVO;
	
	import flash.display.BitmapData;		

	/**
	 * @author Paul
	 */
	public class ThreadFactory 
	{
		private var _threadCount : int = 0;

		public function getSimpleThread() : Thread
		{
			var vo : ThreadDataVO = new ThreadDataVO( );
			vo.angle = _threadCount * 10
			vo.x = ThreadConstants.MANAGER_WIDTH / 2// * Math.random( );
			vo.y = ThreadConstants.MANAGER_HEIGHT / 2// * Math.random( );
			vo.lineAlpha = 1;
			vo.lineSize = 2;
			vo.initialSpeed = 1.1;
			
			var colorSupplier : IColorSupplier = new KulerColorSupplier( [0xff0000, 0x00ff00, 0x0000ff], 200 );
			//var drawer : IDrawer = new KaleidoscopeDrawer( 5 );
			var drawer : IDrawer = new SimpleDrawer( );
			//var motionAI : IAgent = (_threadCount % (ThreadConstants.START_THREADS / 100) == 0) ? (new SimpleAgent( vo )) : (new FollowAgent( vo ));
			var motionAI : IAgent = (_threadCount < 1) ? (new SimpleAgent( vo )) : (new FollowAgent( vo ));
			motionAI.randomize( );
			
			var boundsChecker : IBoundsChecker = new ContinuationBoundsChecker( );
			boundsChecker.target = vo;
			
			var lineStyle : IDrawStyle = new SizedAlphaLine( );
			lineStyle.colorSupplier = colorSupplier;
			lineStyle.target = vo;
			
			_threadCount++;
			
			return new Thread( vo, boundsChecker, colorSupplier, drawer, lineStyle, motionAI );	
		}
		public function getAlphabetThread(letterData : BitmapData) : Thread
		{
			var vo : ThreadDataVO = new ThreadDataVO( );
			vo.angle = 0
			vo.x = ThreadConstants.MANAGER_WIDTH / 2// * Math.random( );
			vo.y = ThreadConstants.MANAGER_HEIGHT / 2// * Math.random( );
			vo.lineAlpha = .1;
			vo.lineSize = 2;
			vo.initialSpeed = .8;
			
			var colorSupplier : IColorSupplier = new KulerColorSupplier( [0xff0000, 0x00ff00, 0x0000ff], 50 + _threadCount + ThreadConstants.GROSS_GLOBAL_HACK );
			//var drawer : IDrawer = new KaleidoscopeDrawer( 5 );
			var drawer : IDrawer = new SimpleDrawer( );
			var motionAI : IAgent = (_threadCount == 0) ? (new BitmapFollowAgent( vo, letterData )) : (new FollowAgent( vo ));
			motionAI.randomize( );
			
			var boundsChecker : IBoundsChecker = new BounceBoundsChecker( );
			boundsChecker.target = vo;
			
			var lineStyle : IDrawStyle = new SimpleLine( );
			lineStyle.colorSupplier = colorSupplier;
			lineStyle.target = vo;
			
			_threadCount++;
			
			return new Thread( vo, boundsChecker, colorSupplier, drawer, lineStyle, motionAI );	
		}

//		public function getAlphabetThread(letterData : BitmapData) : Thread
//		{
//			var vo : ThreadDataVO = new ThreadDataVO( );
//			vo.angle = 0
//			vo.x = ThreadConstants.MANAGER_WIDTH / 2;
//			vo.y = ThreadConstants.MANAGER_HEIGHT / 2;
//			vo.lineAlpha = 1;
//			vo.lineSize = 1;
//			vo.speed = 1.2;
//			
//			var colorSupplier : IColorSupplier = new KulerColorSupplier( [0xff0000, 0x00ff00, 0x0000ff], 10 );
//			var drawer : IDrawer = new SimpleDrawer( );
//			//var motionAI : IAgent = (_threadCount == 0) ? (new BitmapFollowAgent( vo, letterData )) : (new FollowAgent( vo ));
//			var motionAI : IAgent = (_threadCount == 0) ? (new SimpleAgent( vo )) : (new FollowAgent( vo ));
//
//			var boundsChecker : IBoundsChecker = new BounceBoundsChecker( );
//			boundsChecker.target = vo;
//			
//			var lineStyle : IDrawStyle = new SizedAlphaLine( );
//			lineStyle.colorSupplier = colorSupplier;
//			lineStyle.target = vo;
//			
//			_threadCount++;
//			
//			return new Thread( vo, boundsChecker, colorSupplier, drawer, lineStyle, motionAI );	
//		}
	}
}
