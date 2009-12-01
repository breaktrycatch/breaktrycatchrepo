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

	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Paul
	 */
	public class Thread extends Sprite implements IVisualComponent, IDisposable
	{
		public var colorSupplier 	: IColorSupplier;
		public var boundsChecker 	: IBoundsChecker;
		public var lineStyle 		: IDrawStyle;
		public var drawTransform	: IDrawTransform;
		public var drawer 			: IDrawer;
		public var motionAI 		: IAgent;
		public var vo	 			: ThreadDataVO;

		private var _worldThreads 	: Array;
		private var _worldIndex 	: int;

		public function Thread(_data : ThreadDataVO, _bounds : IBoundsChecker, _color : IColorSupplier, _transform : IDrawTransform, _drawer : IDrawer, _line : IDrawStyle, _agent : IAgent)
		{
			vo = _data;
			
			boundsChecker = _bounds;
			colorSupplier = _color;
			drawTransform = _transform;
			drawer = _drawer;
			lineStyle = _line;
			motionAI = _agent;
		}

		public function setWorldData(threads : Array, i : Number) : void
		{
			_worldThreads = threads;
			_worldIndex = i;
		}

		public function update() : void
		{
			colorSupplier.update( );
			lineStyle.setModifiers( _worldThreads, _worldIndex );
			motionAI.setModifiers( _worldThreads, _worldIndex );
			drawer.setModifiers( _worldThreads, _worldIndex );
			motionAI.update( );
			
			var dx : Number = Math.cos( NumberUtils.degreeToRad( vo.angle ) ) * vo.speed;
			var dy : Number = Math.sin( NumberUtils.degreeToRad( vo.angle ) ) * vo.speed;
			var pt : Point = boundsChecker.checkBounds( vo.x + dx, vo.y + dy );
			
			vo.x = pt.x;
			vo.y = pt.y;
		}

		public function draw() : void
		{
			graphics.clear( );
			
			lineStyle.preDraw( this );
			drawer.draw( this, drawTransform.transform( vo ) );
			lineStyle.postDraw( this );
		}

		public function get data() : ThreadDataVO
		{
			return vo;
		}
		
		public function dispose() : void
		{
			var disposableElementNames : Array = getDisposableElementNames( );
			var parentRef : Thread = this;
			var elementsToDispose : Array = disposableElementNames.map( function(name : String, ...args):*
			{
				return parentRef[name];
			} );
			ArrayExtensions.executeCallbackOnArray(elementsToDispose, 'dispose');
		}
		
		private function getDisposableElementNames() : Array
		{			
			var disposableNames : Array = [];
			var typeInfo : Type = Type.forInstance( this );
			var parentRef : Thread = this;
			typeInfo.variables.forEach( function(element : Variable, ...args) : void
			{
				if(parentRef[element.name] is IDisposable)
				{
					disposableNames.push(element.name);
				}
			} );
			return disposableNames;
		}
	}
}
