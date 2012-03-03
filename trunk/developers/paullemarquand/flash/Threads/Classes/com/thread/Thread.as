package com.thread
{

	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.ai.IAgent;
	import com.thread.bounds.IBoundsChecker;
	import com.thread.color.IColorSupplier;
	import com.thread.draw.IDrawer;
	import com.thread.line.IDrawStyle;
	import com.thread.transform.IDrawTransform;
	import com.thread.vo.IDisposable;
	import com.thread.vo.IVisualComponent;
	import com.thread.vo.ThreadDataVO;
	import com.util.NumberUtils;
	import com.util.Profiler;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.osflash.signals.Signal;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Paul
	 */
	public class Thread extends Sprite implements IVisualComponent, IDisposable
	{
		public var onDead : Signal = new Signal( Thread );
		public var colorSupplier : IColorSupplier;
		public var boundsChecker : IBoundsChecker;
		public var lineStyle : IDrawStyle;
		public var drawTransform : IDrawTransform;
		public var drawer : IDrawer;
		public var motionAI : IAgent;
		public var data : ThreadDataVO;
		private var _worldThreads : Array;
		private var _worldIndex : int;
		private var _isDead : Boolean;
		public var profiler : Profiler;
		
		public function Thread(_data : ThreadDataVO, _bounds : IBoundsChecker, _color : IColorSupplier, _transform : IDrawTransform, _drawer : IDrawer, _line : IDrawStyle, _agent : IAgent, _profiler : Profiler)
		{
			data = _data;

			boundsChecker = _bounds;
			colorSupplier = _color;
			drawTransform = _transform;
			drawer = _drawer;
			lineStyle = _line;
			motionAI = _agent;
			profiler = _profiler;
		}

		public function setWorldData(threads : Array, i : Number) : void
		{
			_worldThreads = threads;
			_worldIndex = i;
		}

		public function update() : void
		{
			profiler.start("color");
			colorSupplier.update();
			profiler.stop("color");
			
			profiler.start("lineStyle");
			lineStyle.setModifiers( _worldThreads, _worldIndex );
			profiler.start("lineStyle");
			
			profiler.start("motionAIMods");
			motionAI.setModifiers( _worldThreads, _worldIndex );
			profiler.stop("motionAIMods");
			
			profiler.start("drawer");
			drawer.setModifiers( _worldThreads, _worldIndex );
			profiler.start("drawer");
			
			profiler.start("motionAI");
			motionAI.update();
			profiler.stop("motionAI");
			
			profiler.start("applyPositions");
			var dx : Number = Math.cos( NumberUtils.degreeToRad( data.angle ) ) * data.speed;
			var dy : Number = Math.sin( NumberUtils.degreeToRad( data.angle ) ) * data.speed;
			var pt : Point = boundsChecker.checkBounds( data.x + dx, data.y + dy );
			profiler.stop("applyPositions");
			
			data.x = pt.x;
			data.y = pt.y;
		}

		public function draw() : void
		{
			graphics.clear();

			lineStyle.preDraw( this );
			drawer.draw( this, drawTransform.transform( data ) );
			lineStyle.postDraw( this );

			graphics.endFill();
		}

		public function dispose() : void
		{
			onDead.removeAll();

			var disposableElementNames : Array = getDisposableElementNames();
			var parentRef : Thread = this;
			var elementsToDispose : Array = disposableElementNames.map( function(name : String, ...args) : *
			{
				return parentRef[name];
			} );
			ArrayExtensions.executeCallbackOnArray( elementsToDispose, 'dispose' );
		}

		private function getDisposableElementNames() : Array
		{
			var disposableNames : Array = [];
			var typeInfo : Type = Type.forInstance( this );
			var parentRef : Thread = this;
			typeInfo.variables.forEach( function(element : Variable, ...args) : void
			{
				if (parentRef[element.name] is IDisposable)
				{
					disposableNames.push( element.name );
				}
			} );
			return disposableNames;
		}
		
		public function get isDead() : Boolean
		{
			return _isDead;
		}

		public function kill() : void
		{
			_isDead = true;
			onDead.dispatch(this);
		}
	}
}
