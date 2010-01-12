package com.thread.draw 
{

	import flash.display.Sprite;

	/**
	{
		public function SquareDrawer() 
		{
			super( this );
		}

		override public function draw(drawTarget : Sprite, lines : Array) : void
		{
			var len : int = lines.length;
			for (var i : Number = 0; i < len ; i++) 
			{
				var radius : Number = lines[i].length;	
				drawTarget.graphics.drawRect( lines[i].pt1.x, lines[i].pt1.y, radius, radius );
			}
		}
		
		override public function randomize() : void
		{
			// do nothing.
		}
	}