package com.fuelindustries.utils {	/**	 * A set of Date Helper Methods	*/	public class DateUtils 	{				/**		 * Represents the number of milliseconds in 1 day.		*/		public static var DAY_TIME:Number = 86400000;				/**		 * Returns todays date with the time at 12am.		 * This is useful when comparing dates.		 * @return Today's date		*/		public static function getToday():Date		{			var now:Date = getNow();			return( getMidnight( now ) );				}				/**		 * Returns todays date with the current time		 * @return Today's date		*/		public static function getNow():Date		{			return( new Date() );		}				/**		 * Returns todays date with the time set to midnight		 * This is useful when trying to compare dates.		 * @param d The date object that you want to remove the time from		 * @return A Date object with the time set to 12am.		*/		public static function getMidnight( d:Date ):Date		{			return( new Date( d.getFullYear(), d.getMonth(), d.getDate() ) );				}						/**		 * Returns the week number for a specific Date		 * @param d The Date object to get the week number for		 * @return The week number		*/		public static function getWeekNumber( d:Date ):int		{			var onejan:Date = new Date(d.getFullYear(),0,1);			return Math.ceil((((d.getTime() - onejan.getTime()) / DAY_TIME) + onejan.getDay())/7);			}				/**		 * Returns the number of days between 2 Dates		 * @param start The start date to compare		 * @param end The end date to compate		 * @return The number of days between the 2 specified Date objects		*/		public static function getDaysBetween( start:Date, end:Date ):Number		{			var days:Number = ( end.getTime() - start.getTime() ) / DAY_TIME;			return( days );		}				/**		 * Returns a Date object for tomorrow based on another Date object		 * @param d The Date object to get one day into the future		 * @return The new Date object for tomorrow		*/		public static function getTomorrow( d:Date ):Date		{			return( getDateOffset( d, 1 ) );		}				/**		 * Returns a Date object for yesterday based on another Date object		 * @param d The Date object to get one day into the past		 * @return The new Date object for yesterday		*/		public static function getYesterday( d:Date ):Date		{			return( getDateOffset( d, -1 ) );		}				/**		 * Returns a Date object based on an offset of days from another Date object		 * @param d The Date object to use as a starting point to get the offset		 * @param offset The offset in days for the date you are calculating		 * @return The new Date object the date based on the offset.		*/		public static function getDateOffset( date:Date, offset:int ):Date		{			var retDate:Date = new Date( date );			retDate.setTime( retDate.getTime() + ( offset * DAY_TIME ) ); // 86400000 represents a number of milliseconds each day haves			return retDate;		}				/**		 * Compares 2 Date Objects and checks to see if they are equal. 		 * This does not take into account time just Year, Month, Date 		 * @param date1 A date object to compare		 * @param date2 A date object to compare against		 * @return The new Date object the date based on the offset.		*/		public static function areEqual( date1:Date, date2:Date ):Boolean		{			var areequal:Boolean = false;						if( date1.getFullYear() == date2.getFullYear() )			{				if( date1.getMonth() == date2.getMonth() )				{					if( date1.getDate() == date2.getDate() )					{						return( true );					}				}			}			return( areequal );		}				/**		 * Checks to see if a specified Date object is today		 * @param d A date object to compare		 * @return True if the Date object is today, False if it isn't		*/		public static function isToday( d:Date ):Boolean		{			return( areEqual( new Date(), d ) );		}				/**		 * Checks to see if the Date object is in the Future		 * @param d A date object to compare		 * @return True if the Date object is in the future, False if it isn't		*/		public static function isFuture( d:Date ):Boolean		{			var today:Date = new Date();			return( ( today.getTime() < d.getTime() ) );		}					/**		 * Checks to see if the Date object is in the Past		 * @param d A date object to compare		 * @return True if the Date object is in the past, False if it isn't		*/		public static function isPast( d:Date ):Boolean		{			var today:Date = new Date();			return( ( today.getTime() > d.getTime() ) );		}							/**		 * Checks to see if the Date object for a day that is on the weekend		 * @param d A date object to compare		 * @return True if the Date object is either Saturday or Sunday, False if it isn't		*/		public static function isWeekend( d:Date ):Boolean		{			return( ( d.day == 0 || d.day == 6 ) );		}						public static function formatForServer( d:Date ):String		{			return( d.getFullYear() + "-" + ( d.getMonth() + 1 ) + "-" + d.getDate() );		}	}}