package com.thread.factory 
{	import com.thread.Thread;
	import com.thread.ai.FollowAgent;
	import com.thread.ai.IAgent;
	import com.thread.ai.RightAngleAgent;
	import com.thread.bounds.BounceBoundsChecker;
	import com.thread.bounds.IBoundsChecker;
	import com.thread.color.IColorSupplier;
	import com.thread.color.KulerColorSupplier;
	import com.thread.constant.ThreadConstants;
	import com.thread.draw.IDrawer;
	import com.thread.draw.SimpleDrawer;
	import com.thread.line.IDrawStyle;
	import com.thread.line.SizedAlphaLine;
	import com.thread.transform.IDrawTransform;
	import com.thread.transform.MirrorXTransform;
	import com.thread.vo.ThreadDataVO;

	/**	 * @author plemarquand	 */	public class SavedFactory 
	{
		private var _threadCount : int = 0;
		private var _seed : Number = Math.random( );

		public function getGridDrawThread() : Thread
		{
			var vo : ThreadDataVO = new ThreadDataVO( );
			vo.angle = 360 * _seed;
			vo.x = ThreadConstants.MANAGER_WIDTH / 2;
			vo.y = ThreadConstants.MANAGER_HEIGHT / 2;
			vo.lineAlpha = .5;
			vo.lineSize = 5;
			vo.initialSpeed = 1.1;
			
			var colorSupplier : IColorSupplier = new KulerColorSupplier( [0xff0000, 0x00ff00, 0x0000ff], 200 );
			var transform : IDrawTransform = new MirrorXTransform( );
			var drawer : IDrawer = new SimpleDrawer( );
			var motionAI : IAgent = (_threadCount < 1) ? (new RightAngleAgent( vo )) : (new FollowAgent( vo ));
			motionAI.randomize( );
			
			var boundsChecker : IBoundsChecker = new BounceBoundsChecker( vo );			
			var lineStyle : IDrawStyle = new SizedAlphaLine( vo, colorSupplier );
			
			_threadCount++;
			
			return new Thread( vo, boundsChecker, colorSupplier, transform, drawer, lineStyle, motionAI );	
		}	}}