package com.valkryie.data.vo.core {
	import com.valkryie.editor.elements.editor_panel.properties.statics.PropertyStatics;
	import com.valkryie.editor.elements.editor_panel.properties.vo.PropertyVO;

	/**
	 * @author jkeon
	 */
	public class AbstractDataVO extends SerializableVO {
		
		protected var __properties:Array;
		
		
		
		public function AbstractDataVO() {
			super();
			
		}
		
		protected function generateProperties():void {
			__properties = [];
			
			for (var b in _props) {
				var pvo:PropertyVO = new PropertyVO();
				pvo.propertyName = b;
				pvo.dataVO = this;
				pvo.type = determineType(_props[b]);
				__properties.push(pvo);
			}
			
			__properties.sortOn("propertyName");
			
		}
		
		protected function determineType(_instance:*):String {
			

			if (_instance is int) {
				return PropertyStatics.TYPE_INT;
			}
			else if (_instance is String) {
				return PropertyStatics.TYPE_STRING;
			}
			else {
				return PropertyStatics.TYPE_NUMBER;
			}
		}
		
		
		public function get properties() : Array {
			if (__properties == null) {
				generateProperties();
			}
			return __properties;
		}
	}
}
