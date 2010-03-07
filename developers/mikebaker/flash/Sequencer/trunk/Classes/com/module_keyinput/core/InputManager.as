package com.module_keyinput.core {
	import com.module_keyinput.elements.KeyFunction;

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 * @author jkeon
	 */
	public class InputManager extends EventDispatcher {
		
		private static var __instance:InputManager;
		
		protected var __keys:Dictionary;
		protected var __functions:Dictionary;
		protected var __stage:Stage;
		
		
		protected var __activeKeyCode:int;
		protected var __activeIndex:String;
		protected var __activeKeyFunction:KeyFunction;
		
		public function InputManager(target : IEventDispatcher = null) {
			if (__instance == null) {
				super(target);
				__keys = new Dictionary(true);
				__functions = new Dictionary(true);
			}
			else {
				throw new Error("[INPUTMANAGER] - Can't Instantiate More than Once");
			}
		}
		
		public static function getInstance():InputManager {
			if (__instance == null) {
				__instance = new InputManager();
			}
			
			return __instance;
		}
	
	
		public function initialize(_stageReference:Stage):void {
			__stage = _stageReference;
			
			__stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
			__stage.addEventListener(KeyboardEvent.KEY_UP, onKUp);
		}
		
		/**
		 * Maps a Function to a KeyCode so that when the key is pressed, the Function is fired
		 */
		public function mapFunction(_keyCode:int, _function:Function, _params:Array = null, _spamable:Boolean = false, _firecondition:int = 1) : void {
			
			var separator:int;
			if (_firecondition == KeyFunction.KEY_BOTH) {
				separator = KeyFunction.KEY_PRESS;
			}
			else {
				separator = _firecondition;
			}
			
			__activeIndex = String(_keyCode + "_" + separator);
			
			if (__functions[__activeIndex] == null) {
				var keyFunction:KeyFunction = new KeyFunction(_keyCode, _function, _params, _spamable, _firecondition);
				__functions[__activeIndex] = keyFunction;
			}
			else {
				trace("[INPUTMANAGER] Key " + __activeIndex + " already has a function mapped");
			}
		}
		
		public function clearFunction(_keyCode:int, _fireCondition:int = 0):void {
			if (_fireCondition == 0) {
				//Try to clear press first
				__activeIndex = String(_keyCode + "_" + KeyFunction.KEY_PRESS);
				if (__functions[__activeIndex] != null) {
					KeyFunction(__functions[__activeIndex]).clean();
					__functions[__activeIndex] = null;
				}
				__activeIndex = String(_keyCode + "_" + KeyFunction.KEY_RELEASE);
				if (__functions[__activeIndex] != null) {
					KeyFunction(__functions[__activeIndex]).clean();
					__functions[__activeIndex] = null;
				}
			}
			else {
				__activeIndex = String(_keyCode + "_" + _fireCondition);
				if (__functions[__activeIndex] != null) {
					KeyFunction(__functions[__activeIndex]).clean();
					__functions[__activeIndex] = null;
				}
			}
		}
		
		
		protected function onKDown(e:KeyboardEvent):void {
			
			__activeKeyCode = e.keyCode;
			__activeIndex = String(__activeKeyCode + "_" + KeyFunction.KEY_PRESS);
			
			
			
			//Check if a function is hooked into this key
			if (__functions[__activeIndex] != null) {
				__activeKeyFunction = __functions[__activeIndex];
				//If we're allowed to spam the function
				if (__activeKeyFunction.spamable) {
					if ((__activeKeyFunction.firecondition == KeyFunction.KEY_PRESS) || (__activeKeyFunction.firecondition == KeyFunction.KEY_BOTH)) {
						__activeKeyFunction.fire();
					}
				}
				else {
					//Only if the key was not pressed before
					if (__keys[__activeKeyCode] != true) {
						if ((__activeKeyFunction.firecondition == KeyFunction.KEY_PRESS) || (__activeKeyFunction.firecondition == KeyFunction.KEY_BOTH)) {
							__activeKeyFunction.fire();
						}
					}
				}
			}
			__keys[__activeKeyCode] = true;
		}
		
		protected function onKUp(e:KeyboardEvent):void {
			__activeKeyCode = e.keyCode;
			__activeIndex = String(__activeKeyCode + "_" + KeyFunction.KEY_RELEASE);
			
			//Check if a function is hooked into this key
			if (__functions[__activeIndex] != null) {
				__activeKeyFunction = __functions[__activeIndex];
				//Only if the key is being released
				if (__keys[__activeKeyCode] != false) {
					if ((__activeKeyFunction.firecondition == KeyFunction.KEY_RELEASE) || (__activeKeyFunction.firecondition == KeyFunction.KEY_BOTH)) {
						__activeKeyFunction.fire();
					}
				}
			}
			__keys[__activeKeyCode] = false;
		}
		
		public function isKeyDown(_keyCode:int):Boolean {
			return __keys[_keyCode];
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//KEYCODES LISTED BELOW
		
		//LETTERS (UPPERCASE AND LOWERCASE IDENTICAL)
		public static const KEY_A:int = 65;
		public static const KEY_B:int = 66;
		public static const KEY_C:int = 67;
		public static const KEY_D:int = 68;
		public static const KEY_E:int = 69;
		public static const KEY_F:int = 70;
		public static const KEY_G:int = 71;
		public static const KEY_H:int = 72;
		public static const KEY_I:int = 73;
		public static const KEY_J:int = 74;
		public static const KEY_K:int = 75;
		public static const KEY_L:int = 76;
		public static const KEY_M:int = 77;
		public static const KEY_N:int = 78;
		public static const KEY_O:int = 79;
		public static const KEY_P:int = 80;
		public static const KEY_Q:int = 81;
		public static const KEY_R:int = 82;
		public static const KEY_S:int = 83;
		public static const KEY_T:int = 84;
		public static const KEY_U:int = 85;
		public static const KEY_V:int = 86;
		public static const KEY_W:int = 87;
		public static const KEY_X:int = 88;
		public static const KEY_Y:int = 89;
		public static const KEY_Z:int = 90;
		
		//NUMBERS
		public static const KEY_0:int = 48;
		public static const KEY_1:int = 49;
		public static const KEY_2:int = 50;
		public static const KEY_3:int = 51;
		public static const KEY_4:int = 52;
		public static const KEY_5:int = 53;
		public static const KEY_6:int = 54;
		public static const KEY_7:int = 55;
		public static const KEY_8:int = 56;
		public static const KEY_9:int = 57;
		
		//NUMPAD DIGITS - Excluding Laptops users if you use these
		public static const KEY_N0:int = 96;
		public static const KEY_N1:int = 97;
		public static const KEY_N2:int = 98;
		public static const KEY_N3:int = 99;
		public static const KEY_N4:int = 100;
		public static const KEY_N5:int = 101;
		public static const KEY_N6:int = 102;
		public static const KEY_N7:int = 103;
		public static const KEY_N8:int = 104;
		public static const KEY_N9:int = 105;
		
		//NUMPAD COMMANDS - Excluding Laptops users if you use these
		public static const KEY_NMULTIPLY:int = 106;
		public static const KEY_NADD:int = 107;
		public static const KEY_NSUBTRACT:int = 109;
		public static const KEY_NDECIMAL:int = 110;
		public static const KEY_NDIVIDE:int = 111;
		
		//FUNCTION KEYS - F10 is reserved
		public static const KEY_F1:int = 112;
		public static const KEY_F2:int = 113;
		public static const KEY_F3:int = 114;
		public static const KEY_F4:int = 115;
		public static const KEY_F5:int = 116;
		public static const KEY_F6:int = 117;
		public static const KEY_F7:int = 118;
		public static const KEY_F8:int = 119;
		public static const KEY_F9:int = 120;
		public static const KEY_F11:int = 122;
		public static const KEY_F12:int = 123;
		public static const KEY_F13:int = 124;
		public static const KEY_F14:int = 125;
		public static const KEY_F15:int = 126;
		
		//OTHER KEYS
		public static const KEY_BACKSPACE:int = 8;
		public static const KEY_TAB:int = 9;
		public static const KEY_ENTER:int = 13;
		public static const KEY_SHIFT:int = 16;
		public static const KEY_CONTROL:int = 17;
		public static const KEY_CAPSLOCK:int = 20;
		public static const KEY_ESCAPE:int = 27;
		public static const KEY_SPACEBAR:int = 32;
		public static const KEY_PAGEUP:int = 33;
		public static const KEY_PAGEDOWN:int = 34;
		public static const KEY_END:int = 35;
		public static const KEY_HOME:int = 36;
		public static const KEY_LEFTARROW:int = 37;
		public static const KEY_UPARROW:int = 38;
		public static const KEY_RIGHTARROW:int = 39;
		public static const KEY_DOWNARROW:int = 40;
		public static const KEY_INSERT:int = 45;
		public static const KEY_DELETE:int = 46;
		public static const KEY_NUMLOCK:int = 144;
		public static const KEY_SCROLLLOCK:int = 145;
		public static const KEY_PAUSE:int = 19;
		public static const KEY_SEMICOLON:int = 186;
		public static const KEY_EQUALS:int = 187;
		public static const KEY_DASH:int = 189;
		public static const KEY_FORWARDSLASH:int = 191;
		public static const KEY_BACKSINGLEQUOTE:int = 192;
		public static const KEY_LEFTBRACKET:int = 219;
		public static const KEY_PIPE:int = 220;
		public static const KEY_RIGHTBRACKET:int = 221;
		public static const KEY_QUOTES:int = 222;
		public static const KEY_COMMA:int = 188;
		public static const KEY_PERIOD:int = 190;
		//END KEYCODES
		
		
	}
}
