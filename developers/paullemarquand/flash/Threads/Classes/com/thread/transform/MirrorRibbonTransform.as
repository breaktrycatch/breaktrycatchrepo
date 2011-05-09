package com.thread.transform 
{	import com.thread.transform.AbstractTransform;
	import com.thread.transform.IDrawTransform;
	import com.thread.vo.IPositionable;

	/**	 * @author plemarquand	 */	public class MirrorRibbonTransform extends AbstractTransform implements IDrawTransform 
	{
		private var _mirrorDrawer : MirrorTransform;
		private var _ribbonDrawer : RibbonTransform;

		public function MirrorRibbonTransform(ribbonSections : int = 5, ribbonSeparation : int = 5)
		{
			_mirrorDrawer = new MirrorTransform();
			_ribbonDrawer = new RibbonTransform( ribbonSections, ribbonSeparation );
			super();
		}

		override public function transform(d : IPositionable) : Array
		{
			var lines : Array = [];
			var ribbons : Array = _ribbonDrawer.transform( d );
			
			for (var i : Number = 0; i < ribbons.length ; i++) 
			{
				lines = lines.concat( _mirrorDrawer.transform( ribbons[i] ) );
			}
			
			return lines;
		}
		
		override public function randomize() : void
		{
			_mirrorDrawer.randomize( );
			_ribbonDrawer.randomize();
		}
	}}