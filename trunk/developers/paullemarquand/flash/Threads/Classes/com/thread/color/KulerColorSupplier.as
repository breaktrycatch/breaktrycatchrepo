package com.thread.color
{

	import com.adobe.kuler.KulerSingletonProxy;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.vo.IDisposable;
	import com.util.binding.Binding;

	/**
	 * @author Paul
	 */
	public class KulerColorSupplier extends GradientColorSupplier implements IDisposable
	{
		private var __binding : Binding;

		public function KulerColorSupplier(initialColors : Array = null, stepSpeed : int = 10)
		{
			__binding = KulerSingletonProxy.getInstance().bind( 'result', this, onResults, false );
			KulerSingletonProxy.getInstance().getRandomColours();

			super( (initialColors == null) ? ([]) : (initialColors), stepSpeed );
		}

		protected function onResults(results : Array) : void
		{
			_colors = results;
			activeColorIndex = 0;
		}

		override protected function nextColor() : Number
		{
			var swatch : Array = _colors[_currColorIndex % _colors.length];
			return ArrayExtensions.randomElement( swatch );
		}

		public function dispose() : void
		{
			__binding.unbind();
			__binding = null;
		}
	}
}
