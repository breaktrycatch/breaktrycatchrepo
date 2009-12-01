package com.thread.transform 
{	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IPositionable;
	import com.util.Randomizer;

	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class RibbonTransform extends AbstractTransform implements IDrawTransform 
	{
		private var _ribbonSeparation : int;
		private var _sections : int;
		private var _transformationPoint : Point = new Point( ThreadConstants.MANAGER_WIDTH / 2, ThreadConstants.MANAGER_HEIGHT / 2 );

		public function RibbonTransform(sections : int = 10, ribbonSeparation : int = 10)
		{
			_sections = sections;
			_ribbonSeparation = ribbonSeparation;
			super( this );
		}

		override public function transform(d : IPositionable) : Array
		{
			var lines : Array = [];
			
			for (var i : Number = 0; i < _sections ; i++) 
			{
				var rot : Number = _ribbonSeparation * (i / _sections);

				var nPt : Point = rotateAroundPoint( rot, _transformationPoint, new Point( d.x, d.y ) );
				var pPt : Point = rotateAroundPoint( rot, _transformationPoint, new Point( d.prevX, d.prevY ) );
				
				lines.push( Line.createFromPoints( pPt, nPt ) );
			}
			return lines;
		}

		private function rotateAroundPoint(rot : Number, origin : Point, p : Point) : Point
		{
			var np : Point = new Point( );
			p.x += (0 - origin.x);
			p.y += (0 - origin.y);
			np.x = (p.x * Math.cos( rot * (Math.PI / 180) )) - (p.y * Math.sin( rot * (Math.PI / 180) ));
			np.y = Math.sin( rot * (Math.PI / 180) ) * p.x + Math.cos( rot * (Math.PI / 180) ) * p.y;
			np.x += (0 + origin.x);
			np.y += (0 + origin.y);

			return np; 
		}				public function get ribbonSeparation() : int		{
			return _ribbonSeparation;		}				public function set ribbonSeparation(ribbonSeparation : int) : void		{
			_ribbonSeparation = ribbonSeparation;		}
		
		public function get sections() : int
		{
			return _sections;
		}
		
		public function set sections(sections : int) : void
		{
			_sections = sections;
		}
		
		public function get transformationPoint() : Point
		{
			return _transformationPoint;
		}
		
		public function set transformationPoint(transformationPoint : Point) : void
		{
			_transformationPoint = transformationPoint;
		}
		
		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.addRule( Number, "sections", 4, 20 );
			randomizer.addRule( Number, "ribbonSeparation", 5, 40 );
			randomizer.randomize( this );
		}
	}}