package com.thread.constant 
{

	/**
	 * @author Paul
	 */
	public class ThreadConstants 
	{
		public static const BG_COLOUR : int = 0x000000;
		
		public static var GRID_WIDTH			:Number = 1;
		public static var GRID_HEIGHT			:Number = 1;
		
		public static var MST_STAGE_WIDTH		:Number = 800;
		public static var MST_STAGE_HEIGHT		:Number = 800;
		
		public static var MANAGER_WIDTH			:Number = MST_STAGE_WIDTH / GRID_WIDTH;
		public static var MANAGER_HEIGHT		:Number = MST_STAGE_HEIGHT / GRID_HEIGHT;
		
		public static var START_THREADS			:uint = 50;
		public static var MAX_THREADS			:uint = 100;
		
		public static var CLEAR_INTERVAL		:int = 6;
		public static var CLEAR_AMOUNT			:Number = .0;
		
		public static var GROSS_GLOBAL_HACK : int = 0;
	}
}
