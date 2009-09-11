package com.thread.transform 
{	import com.geom.Line;
	import com.thread.motion.IPositionable;
	import com.thread.transform.AbstractTransform;
	import com.thread.transform.IDrawTransform;

	/**	 * @author plemarquand	 */	public class KaleidoscopeRibbonTransform extends AbstractTransform implements IDrawTransform 
	{
		private var _kaleidoscope : KaleidoscopeTransform;
		private var _ribbonDrawer : RibbonTransform;

		public function KaleidoscopeRibbonTransform(kaleidoscopeSections : int = 5, ribbonSections : int = 20, ribbonSeparation : int = 5)
		{
			_kaleidoscope = new KaleidoscopeTransform( kaleidoscopeSections );
			_ribbonDrawer = new RibbonTransform( ribbonSections, ribbonSeparation );			super( this );		}

		override public function transform(d : IPositionable) : Vector.<Line>
		{			var lines : Vector.<Line> = new Vector.<Line>( );
			var ribbons : Vector.<Line> = _ribbonDrawer.transform( d );
			
			for (var i : Number = 0; i < ribbons.length ; i++) 
			{
				lines = lines.concat( _kaleidoscope.transform( ribbons[i] ) );
			}
			
			return lines;
		}
	}}