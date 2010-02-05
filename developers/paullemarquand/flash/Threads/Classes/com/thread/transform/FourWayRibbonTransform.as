package com.thread.transform 
{

	/**
	{
		private var _fourWay : FourWayTransform;
		private var _ribbonDrawer : RibbonTransform;

		public function FourWayRibbonTransform(ribbonSection : int = 5, ribbonSeparation : int = 5)
		{
			_fourWay = new FourWayTransform( );
			_ribbonDrawer = new RibbonTransform( ribbonSection, ribbonSeparation );

		override public function transform(d : IPositionable) : Array
		{
			var lines : Array = [];
			var ribbons : Array = _ribbonDrawer.transform(d);
			
			for (var i : Number = 0; i < ribbons.length; i++) 
			{
				lines = lines.concat( _fourWay.transform(ribbons[i]));
			}
			
			return lines;
		
		override public function randomize() : void
		{
			// do nothing
		}
	}