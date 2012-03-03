package com.thread.ai
{

	import com.thread.vo.ThreadDataVO;
	import com.util.NumberUtils;
	import flash.display.BitmapData;

	/**
	 * @author plemarquand
	 */
	public class SilhouetteAgent extends AbstractAgent
	{
		[Inject]
		public var silhouette : BitmapData;
		
		private var __forwardLookDistance : Number = 5;

		public function SilhouetteAgent(target : ThreadDataVO)
		{
			super( target );
		}

		override public function run() : void
		{
			var rads : Number = NumberUtils.degreeToRad( _target.angle );
			do
			{
				var nX : Number = Math.cos( NumberUtils.degreeToRad( rads ) ) * __forwardLookDistance;
				var nY : Number = Math.sin( NumberUtils.degreeToRad( rads ) ) * __forwardLookDistance;
				var pix : uint = silhouette.getPixel( nX, nY );
				
				rads += Math.PI / 16;
			}
			while (pix > 0xffffffff / 2);
			
			_target.angle = rads;
			
			super.run();
		}

		override public function randomize() : void
		{
			super.randomize();
		}
	}
}
