package com.commitmon.util
{
	import mx.formatters.DateFormatter;

	public class DateUtils
	{
		public function DateUtils()
		{
		}
		
		public static function formatDate(date : Date):String
		{
			var formatter : DateFormatter = new DateFormatter();
			formatter.formatString = "MMM DD YYYY, L:NNA";
			return formatter.format(date);
		}
		
		private static function compareDates(d1:Date, d2:Date):Number
		{
			var d1ms:Number = d1.getTime();
			var d2ms:Number = d2.getTime();
			
			if(d1ms > d2ms)
			{
				return -1;
			}
			else if(d1ms < d2ms)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

	}
}