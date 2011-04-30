package com.thread.constant 
{

	/**
	 * @author Paul
	 */
	public class ThreadConstants 
	{
		public static const BG_COLOUR : int = 0x000000;
		
		public static const GRID_WIDTH				: int = 16;
		public static const GRID_HEIGHT				: int = 8;
		public static const MANAGERS_PER_GRID 		: int = 1;
		
		public static const MARGIN_X				: Number = -4;
		public static const MARGIN_Y				: Number = -4;
		
		public static const START_THREADS			: uint = 15;
		
		public static const CLEAR_INTERVAL			: int = 15;
		public static const CLEAR_AMOUNT			: Number = .02;
		public static const CAPTURE_TIME 			: Number = 45;
		
		public static var MST_STAGE_WIDTH			: Number;
		public static var MST_STAGE_HEIGHT			: Number;
		
		public static var MANAGER_WIDTH 			: Number;
		public static var MANAGER_HEIGHT 			: Number;
		
		public static function initialize(_stageWidth : Number, _stageHeight : Number) : void
		{
			MST_STAGE_WIDTH = _stageWidth;
			MST_STAGE_HEIGHT = _stageHeight;
			
			var noMarginX : Number = ( MST_STAGE_WIDTH / GRID_WIDTH );
			var totalMarginXSize : Number = ( GRID_WIDTH * 2 ) * MARGIN_X;
			var amtToRemoveX : Number = totalMarginXSize / GRID_WIDTH;
			MANAGER_WIDTH = noMarginX - amtToRemoveX;

			var noMarginY : Number = ( MST_STAGE_HEIGHT / GRID_HEIGHT);
			var totalMarginYSize : Number = ( GRID_HEIGHT * 2 ) * MARGIN_Y;
			var amtToRemoveY : Number = totalMarginYSize / GRID_HEIGHT;
			MANAGER_HEIGHT = noMarginY - amtToRemoveY;
		}
	}
}
