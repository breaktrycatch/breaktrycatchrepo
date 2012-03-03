package com.thread.transform
{

	import com.thread.vo.IPositionable;

	/**
	 * @author plemarquand
	 */
	public class OffsetTransform extends AbstractTransform implements IDrawTransform
	{
		public function OffsetTransform()
		{
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
	}
}
