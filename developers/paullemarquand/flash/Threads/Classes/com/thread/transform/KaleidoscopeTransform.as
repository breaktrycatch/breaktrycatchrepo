package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.motion.IPositionable;

	import flash.geom.Point;

	/**
	 * @author Paul
	 */
	public class KaleidoscopeTransform extends AbstractTransform implements IDrawTransform 
	{
		private var _sections : int;
		private var _trnsPoint : Point = new Point( ThreadConstants.MANAGER_WIDTH / 2, ThreadConstants.MANAGER_HEIGHT / 2 );

		public function KaleidoscopeTransform(sections : int = 20)
		{
			_sections = sections;
			super( this );
		}

		override public function transform(d : IPositionable) : Vector.<Line>
		{
			var lines : Vector.<Line> = new Vector.<Line>( );
			
			for (var i : Number = 0; i < _sections ; i++) 
			{
				var rot : Number = 360 * (i / _sections);

				var nPt : Point = rotateAroundPoint( rot, _trnsPoint, new Point( d.x, d.y ) );
				var pPt : Point = rotateAroundPoint( rot, _trnsPoint, new Point( d.prevX, d.prevY ) );
				
				lines.push( Line.createFromPoints( pPt, nPt ) );
			}
			return lines;
		}

		private function rotateAroundPoint(rot : Number, origin : Point, p : Point) : Point
		{
			var np : Point = new Point( );
			p.x += -origin.x;
			p.y += -origin.y;
			np.x = (p.x * Math.cos( rot * (Math.PI / 180) )) - (p.y * Math.sin( rot * (Math.PI / 180) ));
			np.y = Math.sin( rot * (Math.PI / 180) ) * p.x + Math.cos( rot * (Math.PI / 180) ) * p.y;
			np.x += origin.x;
			np.y += origin.y;
			return np; 
		}
	}
}