package com.valkryie.editor.elements.editor_panel.properties.vo {
	import com.valkryie.data.enum.Enum;
	import com.valkryie.data.vo.core.AbstractDataVO;

	/**
	 * @author jkeon
	 */
	public class PropertyVO extends Object {
		
		public var propertyName:String;
		public var dataVO:AbstractDataVO;
		public var type:String;
		public var enum:Enum;
		
		
		public function PropertyVO() {
		}
		
		public function get value():* {
			return dataVO[propertyName];
		}
	}
}
