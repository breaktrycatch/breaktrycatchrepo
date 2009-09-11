package com.thread.transform 
{	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.motion.IPositionable;

	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class RibbonTransform extends AbstractTransform implements IDrawTransform 
	{
		private var _ribbonSeparation : int;
		private var _sections : int;
		private var _trnsPoint : Point = new Point( ThreadConstants.MANAGER_WIDTH / 2, ThreadConstants.MANAGER_HEIGHT / 2 );

		public function RibbonTransform(sections : int = 20, ribbonSeparation : int = 5)
		{
			_sections = sections;
			_ribbonSeparation = ribbonSeparation;
			super( this );
		}

		override public function transform(d : IPositionable) : Vector.<Line>
		{
			var lines : Vector.<Line> = new Vector.<Line>( );
			
			for (var i : Number = 0; i < _sections ; i++) 
			{
				var rot : Number = _ribbonSeparation * (i / _sections);

				var nPt : Point = rotateAroundPoint( rot, _trnsPoint, new Point( d.x, d.y ) );
				var pPt : Point = rotateAroundPoint( rot, _trnsPoint, new Point( d.prevX, d.prevY ) );
				
				lines.push( Line.createFromPoints( pPt, nPt ) );
			}
			return lines;
		}

		private function rotateAroundPoint(rot : Number, o : Point, p : Point) : Point
		{
			var np : Point = new Point( );
			p.x += (0 - o.x);
			p.y += (0 - o.y);
			np.x = (p.x * Math.cos( rot * (Math.PI / 180) )) - (p.y * Math.sin( rot * (Math.PI / 180) ));
			np.y = Math.sin( rot * (Math.PI / 180) ) * p.x + Math.cos( rot * (Math.PI / 180) ) * p.y;
			np.x += (0 + o.x);
			np.y += (0 + o.y);

			return np; 
		}
	}}