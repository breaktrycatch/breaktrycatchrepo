package com.thread.ai
{

	import com.thread.Thread;
	import com.thread.vo.ThreadDataVO;
	import com.util.NumberUtils;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;

	/**
	 * @author plemarquand
	 */
	public class ClickDrawAgent extends AbstractAgent implements IAgent
	{
		private var __stage : Stage;
		private var __points : Array;
		private var __disabled : Boolean;
		private var __currentPoint : Point;
		private static var __recorder : ClickDrawRecorder;

		public function ClickDrawAgent(target : ThreadDataVO, _stage : Stage)
		{
			__stage = _stage;
			__points = [];

			super( target );

			__recorder ||= new ClickDrawRecorder( _stage );
			__recorder.onRecorded.add( onRecordingComplete );
		}

		private function onRecordingComplete(_points : Array) : void
		{
			if (_isLeader)
			{
				__points = variate( _points.concat(), 20 );
				__currentPoint = null;
			}
		}

		private function variate(_points : Array, _variation : Number) : Array
		{
			for (var i : int = 0; i < _points.length; i++)
			{
				var pt : Point = Point( _points[i] ).clone();
				pt.x += _variation * Math.random() - _variation * Math.random();
				pt.y += _variation * Math.random() - _variation * Math.random();
				_points[i] = pt;
			}
			return _points;
		}

		override public function run() : void
		{
			super.run();

			if (__points && __points.length)
			{
				if (! __currentPoint || Point.distance( __currentPoint, new Point( _target.x, _target.y ) ) < 5)
				{
					__currentPoint = __points.shift();
					if (__disabled)
					{
						enableThreads( __currentPoint.x, __currentPoint.y );
					}
				}
				var nX : Number = __currentPoint.x - _target.x;
				var nY : Number = __currentPoint.y - _target.y;
				var rad : Number = Math.atan2( nY, nX ) ;
				_target.angle = NumberUtils.radToDegree( rad );
			}
			else if (! __disabled)
			{
				__disabled = true;
				disableThreads();
			}
		}

		private function enableThreads(_x : Number, _y : Number) : void
		{
			__disabled = false;
			var agents : Array = _worldAgents;
			for (var i : int = 0; i < agents.length; i++)
			{
				var thread : Thread = agents[i];
				thread.data.x = _x;
				thread.data.y = _y;
				thread.data.prevX = _x;
				thread.data.prevY = _y;
				thread.visible = true;
			}
		}

		private function disableThreads() : void
		{
			var agents : Array = _worldAgents;
			for (var i : int = 0; i < agents.length; i++)
			{
				var thread : Thread = agents[i];
				thread.visible = false;
			}
		}
	}
}

import com.thread.constant.ThreadConstants;
import org.osflash.signals.Signal;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * @author plemarquand
 */
class ClickDrawRecorder
{
	public var onRecorded : Signal = new Signal( Array );
	private var __stage : Stage;
	private var __points : Array;

	public function ClickDrawRecorder(_stage : Stage)
	{
		__points = [];
		__stage = _stage;
		__stage.addEventListener( MouseEvent.MOUSE_DOWN, onDown );
		__stage.addEventListener( MouseEvent.MOUSE_UP, onRelease );
	}

	private function onRelease(event : MouseEvent) : void
	{
		__stage.removeEventListener( Event.ENTER_FRAME, onFrame );
		onRecorded.dispatch( __points );
	}

	private function onDown(event : MouseEvent) : void
	{
		__points = [];
		__stage.addEventListener( Event.ENTER_FRAME, onFrame );
	}

	private function onFrame(event : Event) : void
	{
		var dX : Number = __stage.mouseX % ThreadConstants.MANAGER_WIDTH;
		var dY : Number = __stage.mouseY % ThreadConstants.MANAGER_HEIGHT;
		__points.push( new Point( dX, dY ) );
	}
}
