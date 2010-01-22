package com.fuelindustries.data
{

	/**
	 * A set of methods to help with Validating Data
	 */
	public class DataValidation
	{
		/**
		 * Checks to see if the String is a valid email address
		 * 
		 * @param email The string to check against
		 * @return Returns true if the string is a valid email address. False if it isn't.
		 */
		public static function isEmail( email : String ) : Boolean
		{
			var pattern : RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			return( pattern.test( email ) );	
		}

		/**
		 * Checks to see if the date exists. 
		 * You can use this to check for days in a leap year or whether there are 30 or 31 days in a month.
		 * 
		 * @param year The year of the date
		 * @param month The month of the date
		 * @param day The day of the date
		 * 
		 * @return Returns true if the date exists. False if it isn't.
		 */
		public static function isDate( year : int, month : int, day : int ) : Boolean
		{
			var date : Date = new Date( year, month - 1, day ); 
			
			if( date.getMonth( ) != month - 1 )
			{
				return false;
			}
		
			return true;
		}

		/**
		 * Match a North American telephone number in the format (###) ###-####, 
		 * where the area code is optional, the parentheses around the area code 
		 * are optional and could be replaced with a dash, and there is 
		 * optional spacing between the number groups.
		 * 
		 * @param phoneNumber The phone number to check against as a String
		 * 
		 * @return Returns true if the string is a valid phone number. False if it isn't.
		 * 
		 * @example
		 * <pre>
		 * import com.fuelindustries.data.DataValidation;
		 * trace( DataValidation.isPhoneNumber( "555 555 5555" ) );//true
		 * trace( DataValidation.isPhoneNumber( "(555)5555555" ) );//true
		 * trace( DataValidation.isPhoneNumber( "555-555-5555" ) );//true
		 * <pre>
		 */
		public static function isPhoneNumber( phoneNumber : String ) : Boolean
		{
			var phoneExp : RegExp = /^(\(\s*\d{3}\s*\)|(\d{3}\s*-?))?\s*\d{3}\s*-?\s*\d{4}$/;
			return phoneExp.test( phoneNumber );	
		}

		/**
		 * Match a North American telephone number. Works like isPhoneNumber()
		 * except allows for an optional one- to five-digit extension specified 
		 * with an "x", "ext", or "ext." and optional spacing.
		 * 
		 * @param phoneNumber The phone number to check against as a String
		 * 
		 * @return Returns true if the string is a valid phone number. False if it isn't.
		 * 
		 * @example
		 * <pre>
		 * import com.fuelindustries.data.DataValidation;
		 * trace( DataValidation.isPhoneNumber( "555 555 5555 ext.1234 " ) );//true
		 * trace( DataValidation.isPhoneNumber( "(555)5555555x123" ) );//true
		 * trace( DataValidation.isPhoneNumber( "555-555-5555 ext5555" ) );//true
		 * <pre>
		 */
		public function isPhoneNumberWithExtension( phoneNumber : String ) : Boolean
		{
			var phoneExp : RegExp = /^(\(\s*\d{3}\s*\)|(\d{3}\s*-?))?\s*\d{3}\s*-?\s*\d{4}\s*((x|ext|ext\.)\s*\d{1,5})?$/;
			return phoneExp.test( phoneNumber );
		}

		/**
		 * Match a generic credit card number with four group of four digits separated 
		 * by optional dashes and optional spacing between the groups.
		 * 
		 * @param cardNumber A credit card number to check against as a string.
		 * 
		 * @return Returns true if the string is a valid generic credit card number. False if it isn't.
		 * 
		 * @example
		 * <pre>
		 * import com.fuelindustries.data.DataValidation;
		 * trace( DataValidation.isPhoneNumber( "4111 1111 1111 1111" ) );//true
		 * trace( DataValidation.isPhoneNumber( "4111-1111-1111-1111" ) );//true
		 * <pre>
		 */
		public function isCreditCard( cardNumber : String ) : Boolean
		{
			var cardExp : RegExp = /^(\d{4}\s*\-?\s*){3}\d{4}$/;
			return cardExp.test( cardNumber );
		}

		/**
		 * Match an IP address when you are concerned that the address is 
		 * formatted correctly and that each number group only ranges from 0-255. 
		 * This function does not actually ping the server to check if it actually exists, 
		 * it only validates the input based on standard IPv4 addresses.
		 * 
		 * @param cardNumber An IP number to check against as a string.
		 * 
		 * @return Returns true if the string is a valid IP address. False if it isn't.
		 * 
		 * @example
		 * <pre>
		 * import com.fuelindustries.data.DataValidation;
		 * trace( DataValidation.isPhoneNumber( "4111 1111 1111 1111" ) );//true
		 * trace( DataValidation.isPhoneNumber( "4111-1111-1111-1111" ) );//true
		 * </pre>
		 */
		public static function isIPAddress( ip : String ) : Boolean
		{
			var ipExp : RegExp = /^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$/;
			return ipExp.test( ip );
		}

		/**
		 * Checks to see if the String is a valid  Canadian Postal Code.
		 * This takes in to account having a space in between the 3rd and 4th index.
		 * Also it isn't case sensitive.
		 * 
		 * @param pc The string to check against
		 * 
		 * @return Returns true if the string is a valid Canadian Postal Code. False if it isn't.
		 * 
		 * @example 
		 * <pre>
		 * import com.fuelindustries.data.DataValidation;
		 * trace( DataValidation.isPostalCode( "k1k 2c3" ) );//true
		 * trace( DataValidation.isPostalCode( "k1k2c3" ) );//true
		 * </pre>
		 */
		public static function isPostalCode( pc : String ) : Boolean
		{
			var pattern : RegExp;
			if( pc.length == 6 )
			{
				pattern = /^[A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9]$/;
			}
			else
			{
				pattern = /^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$/;
			}
				
			return( pattern.test( pc ) );
		}

		/**
		 * Checks to see if the String is a valid US Zip Code
		 * Zip Codes must be between 5-9 digits.
		 * 
		 * @param email The string to check against
		 * 
		 * @return Returns true if the string is a valid Zip Code. False if it isn't.
		 */
		public static function isZipCode( zip : String ) : Boolean
		{
			var pattern : RegExp = /^\d{5,9}$/;
			return( pattern.test( zip ) );
		}
		
		/**
		 * Constrains a number between a min and max range
		 * 
		 * @param value The number in which to constrain
		 * @param min The min number to constrain to
		 * @param max The max number to constrain to
		 * 
		 * @return Returns a new number constrained. If the number is in the range then it is unchanged.
		 */
		public static function constrain( value : Number, min : Number, max : Number ) : Number
		{
			return ( Math.max( min, Math.min( value, max ) ) );
		}
	}
}