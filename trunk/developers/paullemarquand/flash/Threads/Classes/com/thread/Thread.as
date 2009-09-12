package com.thread 
{
	import com.thread.draw.IDrawer;
	import com.thread.ai.IAgent;
	import com.thread.color.IColorSupplier;
	import com.thread.line.IDrawStyle;
	import com.thread.motion.IComponent;
	import com.thread.motion.bounds.IBoundsChecker;
	import com.thread.transform.IDrawTransform;
	import com.thread.vo.ThreadDataVO;
	import com.util.NumberUtils;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Paul
	 */
	public class Thread extends Sprite implements IComponent 
	{
		private var _colorSupplier 	: IColorSupplier;
		private var _boundsChecker 	: IBoundsChecker;
		private var _lineStyle 		: IDrawStyle;
		private var _data 			: ThreadDataVO;
		private var _transform		: IDrawTransform;
		private var _drawer 		: IDrawer;
		private var _motionAI 		: IAgent;

		private var _worldThreads 	: Vector.<Thread>;
		private var _worldIndex 	: int;

		public function Thread(data : ThreadDataVO, bounds : IBoundsChecker, color : IColorSupplier, transform : IDrawTransform, drawer : IDrawer, line : IDrawStyle, agent : IAgent)
		{
			_data = data;
			
			_boundsChecker = bounds;
			_colorSupplier = color;
			_transform = transform;
			_drawer = drawer;
			_lineStyle = line;
			_motionAI = agent;
		}

		public function setWorldData(threads : Vector.<Thread>, i : Number) : void
		{
			_worldThreads = threads;
			_worldIndex = i;
		}

		public function update() : void
		{
			_colorSupplier.update( );
			_lineStyle.setModifiers( _worldThreads, _worldIndex );
			_motionAI.setModifiers( _worldThreads, _worldIndex );
			_drawer.setModifiers( _worldThreads, _worldIndex );
			_motionAI.update( );
			
			var dx : Number = Math.cos( NumberUtils.degreeToRad( _data.angle ) ) * _data.speed;
			var dy : Number = Math.sin( NumberUtils.degreeToRad( _data.angle ) ) * _data.speed;
			var pt : Point = _boundsChecker.checkBounds( _data.x + dx, _data.y + dy );
			
			_data.x = pt.x;
			_data.y = pt.y;
		}

		public function draw() : void
		{
			graphics.clear( );
			
			_lineStyle.preDraw( this );
			_drawer.draw( this, _transform.transform( _data ) );
			_lineStyle.postDraw( this );
		}

		public function get data() : ThreadDataVO
		{
			return _data;
		}
	}
}
