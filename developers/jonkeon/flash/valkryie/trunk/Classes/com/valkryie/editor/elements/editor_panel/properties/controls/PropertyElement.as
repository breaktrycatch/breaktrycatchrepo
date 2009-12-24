package com.valkryie.editor.elements.editor_panel.properties.controls {
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.FuelMouseEvent;
	import com.fuelindustries.utils.IntervalCall;
	import com.fuelindustries.utils.IntervalManager;
	import com.module_data.Binding;
	import com.valkryie.editor.elements.editor_panel.properties.statics.PropertyStatics;
	import com.valkryie.editor.elements.editor_panel.properties.vo.PropertyVO;

	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author jkeon
	 */
	public class PropertyElement extends FuelUI {
		
		public var left_btn:SimpleButton;
		public var right_btn:SimpleButton;
		public var value_txt:TextField;
		
		private var __btnInterval:int;
		
		protected var __propertyVO:PropertyVO;
		
		protected var __binding:Binding;
		
		protected var __propertyType:String;
		
		public function PropertyElement() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			
			left_btn.addEventListener( MouseEvent.CLICK, arrowRelease, false, 0, true );
			right_btn.addEventListener( MouseEvent.CLICK, arrowRelease, false, 0, true);
			
			left_btn.addEventListener( FuelMouseEvent.PRESS, arrowPress, false, 0, true );
			right_btn.addEventListener( FuelMouseEvent.PRESS, arrowPress, false, 0, true );
			
			left_btn.addEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease, false, 0, true );
			right_btn.addEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease, false, 0, true );
			
			
		}
		
		public function get propertyVO() : PropertyVO {
			return __propertyVO;
		}
		
		public function set propertyVO(_propertyVO : PropertyVO) : void {
			__propertyVO = _propertyVO;
			__propertyType = __propertyVO.type;
			
			switch (__propertyType) {
				
				case PropertyStatics.TYPE_INT:
				case PropertyStatics.TYPE_NUMBER:
					left_btn.visible = true;
					right_btn.visible = true;
					value_txt.type = TextFieldType.INPUT;
					value_txt.addEventListener(FocusEvent.FOCUS_OUT, updateChange);
					break;
				
				case PropertyStatics.TYPE_STRING:
					left_btn.visible = false;
					right_btn.visible = false;
					value_txt.type = TextFieldType.INPUT;
					value_txt.addEventListener(FocusEvent.FOCUS_OUT, updateChange);
				break;
				
				case PropertyStatics.TYPE_ENUM:
					left_btn.visible = true;
					right_btn.visible = true;
					value_txt.type = TextFieldType.DYNAMIC;
				break;
				
				case PropertyStatics.TYPE_READ_ONLY:
					left_btn.visible = false;
					right_btn.visible = false;
					value_txt.type = TextFieldType.DYNAMIC;
				break;
			}
		
		
			__binding = __propertyVO.dataVO.bind(__propertyVO.propertyName, this, displayValue);
			displayValue(__propertyVO.dataVO[__propertyVO.propertyName]);
		}
		
		protected function updateChange(e:FocusEvent):void {
			__propertyVO.dataVO[__propertyVO.propertyName] = value_txt.text;
		}
		
		
		protected function arrowRelease( e:MouseEvent ):void
		{
			IntervalManager.clearInterval( __btnInterval );
		}
		
		/** @private */
		protected function arrowPress( e:FuelMouseEvent ):void
		{
			var btn:DisplayObject = e.target as DisplayObject;
			var dir:int = ( btn == left_btn.display ) ? -1 : 1;
			affectValue(dir);
			IntervalManager.clearInterval( __btnInterval );
			__btnInterval = IntervalManager.setInterval( affectValue, 100, dir );
		}
		
		
		protected function affectValue(amount:Number, intCall:IntervalCall = null):void {
			
			var value:*;
			
			switch(__propertyType) {
				case PropertyStatics.TYPE_INT:
				case PropertyStatics.TYPE_NUMBER:
					value = parseFloat(value_txt.text);
					value += amount;
				break;
				
				case PropertyStatics.TYPE_ENUM:
					if (amount == 1) {
						value = __propertyVO.enum.getNextAfter(value_txt.text);
					}
					else if (amount == -1) {
						value = __propertyVO.enum.getPrevBefore(value_txt.text);
					}
				break;
			}
			
			__propertyVO.dataVO[__propertyVO.propertyName] = value;
			displayValue(__propertyVO.dataVO[__propertyVO.propertyName]);
		}
		
		protected function displayValue(_value:*):void {
			if (__propertyType == PropertyStatics.TYPE_ENUM) {
				value_txt.text = __propertyVO.enum.resolveToIdentifier(_value);
			} 
			else {
				value_txt.text = String(_value);
			}
		}
		

		override public function clean() : void {
			
			left_btn.removeEventListener( MouseEvent.CLICK, arrowRelease );
			right_btn.removeEventListener( MouseEvent.CLICK, arrowRelease);
			
			left_btn.removeEventListener( FuelMouseEvent.PRESS, arrowPress );
			right_btn.removeEventListener( FuelMouseEvent.PRESS, arrowPress );
			
			left_btn.removeEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease );
			right_btn.removeEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease );
			
			__binding.unbind();
			__binding = null;
			
			__propertyVO = null;
			
			super.clean();
		}
		
		
	}
}
