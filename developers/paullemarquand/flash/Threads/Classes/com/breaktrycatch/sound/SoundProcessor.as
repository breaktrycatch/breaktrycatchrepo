package com.breaktrycatch.sound
{
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class SoundProcessor extends Sound 
	{
		public const LEFT : String = "left";
		public const RIGHT : String = "right";
		public const BOTH : String = "both";
		
		private var _data : ByteArray;
		private var _floatArr : Array;

		function SoundProcessor() 
		{
			_data = new ByteArray( );
		}
		
		/**
		 * Updates the sound processor by fetching sound data from the
		 * sound card. To get access to this data use <code>getAverage()</code>
		 * or <code>getAverage()</code>
		 */
		public function update() : void 
		{
			SoundMixer.computeSpectrum( _data, true, 0 );
			_floatArr = getSoundSpectrum();
		}
		
		/**
		 * Gets the average volume in a channel.
		 * @param channel String constant representing the channel you wish to get data from.
		 * @return The average of the volume in that channel.
		 */
		public function getAverage(channel : String = BOTH) : Number
		{
			switch (channel) 
			{
				case LEFT:
					return calculateAverage(getSoundData(0, 256));
					break;
				case RIGHT:
					return calculateAverage(getSoundData(256));
					break;
				case BOTH:
				default:
					return calculateAverage(getSoundData());
					break;
			}
		}
		
		/**
		 * Gets a portion of the sound data. <code>update()</code>
		 * must be called before getSoundData in order to fetch the data from the sound card.
		 */
		public function getSoundData(start : int = 0, end : int = 512) : Array
		{
			return _floatArr.slice(start, end);
		}
		
		private function getSection(bArr : ByteArray, sectionLength : uint = 512) : Array 
		{
			var soundArray : Array = new Array( );
			for (var i : uint = 0; i < sectionLength ; i++) 
			{
				soundArray.push( bArr.readFloat( ) );
			}
			return soundArray;
		}

		private function calculateAverage(arr : Array) : Number
		{
			var avg : Number = 0;
			for (var i : uint = 0; i < arr.length ; i++) 
			{
				avg += arr[i];
			}
			return avg / arr.length;
		}
		
		private function getSoundSpectrum() : Array 
		{
			return getSection( _data, 512 );
		}
	}
}